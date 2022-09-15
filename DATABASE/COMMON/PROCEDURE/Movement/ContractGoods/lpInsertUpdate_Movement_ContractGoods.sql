-- Function: lpInsertUpdate_Movement_ContractGoods()

--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ContractGoods(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
 INOUT ioInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа / С какой даты действует
   OUT outEndBeginDate       TDateTime , -- По какую дату действует
    IN inContractId          Integer   , --
    IN inCurrencyId          Integer   , -- Валюта 
    IN inComment             TVarChar  , -- Примечание
    IN inUserId              Integer     -- пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert Boolean;

   DECLARE vbMovementId_old  Integer;
   DECLARE vbMovementId_next Integer;
   DECLARE vbOperDate_next   TDateTime;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- проверка
     IF COALESCE (inContractId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлен <Договор>.';
     END IF;

     -- находим предыдущий документ,ему устанавливаем дату окончания EndBeginDate  = inOperDate-1 день
     vbMovementId_old:= (SELECT tmp.Id
                         FROM (SELECT Movement.Id
                                    , ROW_NUMBER() OVER (ORDER BY Movement.OperDate DESC) AS Ord
                               FROM Movement
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                                 AND MovementLinkObject_Contract.ObjectId = inContractId
                               WHERE Movement.DescId = zc_Movement_ContractGoods()
                                  AND Movement.OperDate < inOperDate
                                  AND Movement.StatusId <> zc_Enum_Status_Erased()  --zc_Enum_Status_Complete() 
                                  AND Movement.Id <> ioId 
                               ) AS tmp
                         WHERE tmp.Ord = 1
                         LIMIT 1
                        );
     
     -- пробуем найти следующий док.
     SELECT tmp.Id, tmp.OperDate
    INTO vbMovementId_next, vbOperDate_next
     FROM (SELECT Movement.Id, Movement.OperDate
                , ROW_NUMBER() OVER (ORDER BY Movement.OperDate ASC) AS Ord
           FROM Movement
               INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                            AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                            AND MovementLinkObject_Contract.ObjectId = inContractId
           WHERE Movement.DescId = zc_Movement_ContractGoods()
              AND Movement.OperDate > inOperDate
              AND Movement.StatusId <> zc_Enum_Status_Erased()--zc_Enum_Status_Complete()
              AND Movement.Id <> ioId 
          ) AS tmp
     WHERE tmp.Ord = 1
     LIMIT 1;

     outEndBeginDate := (CASE WHEN COALESCE (vbMovementId_next,0) > 0 THEN vbOperDate_next - INTERVAL '1 DAY' ELSE zc_DateEnd() END);

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     IF vbIsInsert = TRUE
     THEN
         ioInvNumber := CAST (NEXTVAL ('Movement_ContractGoods_seq') AS TVarChar);
     END IF;
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ContractGoods(), ioInvNumber, inOperDate, NULL, NULL);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- сохранили связь с <Валюта>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Currency(), ioId, inCurrencyId);
     
     -- сохранили свойство <Дата окончания> текущего документа
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), ioId, outEndBeginDate);

     -- Комментарий
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);



     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <Дата создания>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (создание)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     ELSE
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);


     -- сохранили свойство <Дата окончания> предыдущего документа
     IF COALESCE (vbMovementId_old,0) > 0
     THEN
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), vbMovementId_old, (inOperDate - INTERVAL '1 day')::TDateTime);
     END IF;

    
                          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.22         *
 14.09.22         *
 05.07.21         *
*/

-- тест
-- 

