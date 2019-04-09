-- Function: lpInsertUpdate_Movement_UnnamedEnterprises()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_UnnamedEnterprises (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TFloat, TVarChar, TFloat, TDateTime, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_UnnamedEnterprises(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inUnitId                Integer    , -- От кого (подразделение)
    IN inClientsByBankId       Integer    , -- Кому (покупатель)
    IN inComment               TVarChar   , -- Примечание
    IN inAmountAccount         TFloat     , -- Сумма в счёте
    IN inAccountNumber         TVarChar   , -- Номер счёта
    IN inAmountPayment         TFloat     , -- Сумма оплаты
    IN inDatePayment           TDateTime  , -- Дата оплаты
    IN inUserId                Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка
    inOperDate:= DATE_TRUNC ('DAY', inOperDate);
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
    END IF;
    
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_UnnamedEnterprises(), inInvNumber, inOperDate, NULL, 0);
    
    -- сохранили связь с <От кого (подразделение)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    
    
    IF COALESCE(inClientsByBankId,0) = 0
    THEN
        --Удалить связь с покупателем
        IF EXISTS(SELECT 1 FROM MovementLinkObject
                  WHERE MovementId = ioId
                    AND DescId = zc_MovementLinkObject_ClientsByBank())
        THEN
            DELETE FROM MovementLinkObject
            WHERE MovementId = ioId
              AND DescId = zc_MovementLinkObject_ClientsByBank();
        END IF;
    ELSE
        -- сохранили связь с <Кому (покупатель)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ClientsByBank(), ioId, inClientsByBankId);
    END IF;
    
    IF vbIsInsert = TRUE AND COALESCE(inComment, '') = '' AND COALESCE (inClientsByBankId, 0) <> 0 AND
      EXISTS( SELECT MovementString_Comment.ValueData
              FROM Movement

                   INNER JOIN MovementLinkObject AS MovementLinkObject_ClientsByBank
                                                 ON MovementLinkObject_ClientsByBank.MovementId = Movement.Id
                                                AND MovementLinkObject_ClientsByBank.DescId = zc_MovementLinkObject_ClientsByBank()
                                                AND MovementLinkObject_ClientsByBank.ObjectId = inClientsByBankId

                   INNER JOIN MovementString AS MovementString_Comment
                                            ON MovementString_Comment.MovementId = Movement.Id
                                           AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                           AND COALESCE(MovementString_Comment.ValueData, '') <> ''

              WHERE Movement.DescId = zc_Movement_UnnamedEnterprises()
                AND Movement.StatusId = zc_Enum_Status_Complete())
    THEN
      SELECT MovementString_Comment.ValueData
      INTO inComment
      FROM Movement

           INNER JOIN MovementLinkObject AS MovementLinkObject_ClientsByBank
                                         ON MovementLinkObject_ClientsByBank.MovementId = Movement.Id
                                        AND MovementLinkObject_ClientsByBank.DescId = zc_MovementLinkObject_ClientsByBank()
                                        AND MovementLinkObject_ClientsByBank.ObjectId = inClientsByBankId

           INNER JOIN MovementString AS MovementString_Comment
                                    ON MovementString_Comment.MovementId = Movement.Id
                                   AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                   AND COALESCE(MovementString_Comment.ValueData, '') <> ''

      WHERE Movement.DescId = zc_Movement_UnnamedEnterprises()
        AND Movement.StatusId = zc_Enum_Status_Complete()   
      ORDER BY Movement.OperDate DESC
      LIMIT 1;
    END IF;
    
    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- сохранили <Сумма в счёте>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountAccount(), ioId, inAmountAccount);

    -- сохранили <Номер счёта>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_AccountNumber(), ioId, inAccountNumber);

    -- сохранили <Сумма оплаты>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountPayment(), ioId, inAmountPayment);

    -- сохранили <Дата оплаты>
    IF COALESCE(inAmountPayment, 0) = 0
    THEN
        --Удалить связь с <Дата оплаты>
        IF EXISTS(SELECT 1 FROM MovementDate
                  WHERE MovementId = ioId
                    AND DescId = zc_MovementDate_DatePayment())
        THEN
            DELETE FROM MovementDate
            WHERE MovementId = ioId
              AND DescId = zc_MovementDate_DatePayment();
        END IF;
    ELSE
        -- сохранили связь с <Дата оплаты>
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DatePayment(), ioId, inDatePayment);
    END IF;
    

    -- !!!протокол через свойства конкретного объекта!!!
     IF vbIsInsert = FALSE
     THEN
         -- сохранили свойство <Дата корректировки>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (корректировка)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- сохранили свойство <Дата создания>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- сохранили свойство <Пользователь (создание)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;
     
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 09.04.19         *
 30.09.18         *
*/
--
