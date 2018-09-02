-- Function: lpInsertUpdate_Movement_Income()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Income(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inFromId               Integer   , -- От кого (в документе)
    IN inToId                 Integer   , -- Кому (в документе)
    IN inCurrencyDocumentId   Integer   , -- Валюта (документа)
    IN inCurrencyValue        TFloat    , -- курс валюты
    IN inParValue             TFloat    , -- Номинал для перевода в валюту баланса
    IN inComment              TVarChar  , -- Примечание
    IN inUserId               Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert     Boolean;
   DECLARE vbId_sale_part Integer;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate) THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- проверка - Поставщик
     IF COALESCE (inFromId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено значение <Поставщик>.';
     END IF;
     -- проверка - Подразделение
     IF COALESCE (inToId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено значение <Подразделение>.';
     END IF;

     -- проверка
     IF COALESCE (inCurrencyDocumentId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Валюта>.';
     END IF;

     -- Если НЕ Базовая Валюта
     IF inCurrencyDocumentId <> zc_Currency_Basis() THEN
        -- проверка
        IF COALESCE (inCurrencyValue, 0) = 0 THEN
           RAISE EXCEPTION 'Ошибка.Не определено значение <Курс>.';
        END IF;
        -- проверка
        IF COALESCE (inParValue, 0) = 0 THEN
           RAISE EXCEPTION 'Ошибка.Не определено значение <Номинал>.';
        END IF;
     END IF;


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement (ioId        := ioId
                                   , inDescId    := zc_Movement_Income()
                                   , inInvNumber := inInvNumber
                                   , inOperDate  := inOperDate
                                   , inParentId  := NULL
                                   , inUserId    := inUserId
                                    );

     -- только для Update
     IF vbIsInsert = FALSE
     THEN
         -- !!!Кроме Sybase!!! - !!!не забыли - проверили что НЕТ движения, тогда инфу в партии можно менять!!!
         -- ДЛЯ всех ПАРТИЙ
         IF inUserId <> zc_User_Sybase()
            AND (inToId               <> (SELECT MAX (COALESCE (Object_PartionGoods.UnitId, 0))     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementId = ioId AND COALESCE (Object_PartionGoods.UnitId, 0)     <> inToId)
              -- OR inFromId             <> (SELECT MAX (COALESCE (Object_PartionGoods.PartnerId, 0))  FROM Object_PartionGoods WHERE Object_PartionGoods.MovementId = ioId AND COALESCE (Object_PartionGoods.PartnerId, 0)  <> inFromId)
              OR inCurrencyDocumentId <> (SELECT MAX (COALESCE (Object_PartionGoods.CurrencyId, 0)) FROM Object_PartionGoods WHERE Object_PartionGoods.MovementId = ioId AND COALESCE (Object_PartionGoods.CurrencyId, 0) <> inCurrencyDocumentId)
                )
         THEN
            -- есть ли ПРОВЕДЕННЫЕ документы - все
            vbId_sale_part:= (SELECT MovementItem.Id
                              FROM Object_PartionGoods
                                   INNER JOIN MovementItem ON MovementItem.PartionId = Object_PartionGoods.MovementItemId
                                                          AND MovementItem.isErased  = FALSE -- !!!только НЕ удаленные!!!
                                                          -- AND MovementItem.DescId = ...   -- !!!любой Desc!!!
                                   INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                      AND Movement.StatusId = zc_Enum_Status_Complete() -- !!!только проведенные!!!
                                                      AND Movement.DescId   <> zc_Movement_Income()     -- !!!только НЕ Приход от постав.!!!
                              WHERE Object_PartionGoods.MovementId = ioId
                              ORDER BY Movement.OperDate DESC
                              LIMIT 1
                             );
             -- Проверка - ДЛЯ всех ПАРТИЙ
            IF vbId_sale_part > 0
            THEN
                RAISE EXCEPTION 'Ошибка.Найдено движение <%> № <%> от <%>.Нельзя корректировать <Документ>.'
                              , (SELECT MovementDesc.ItemName
                                 FROM MovementItem
                                      INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                      INNER JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                                 WHERE MovementItem.Id = vbId_sale_part
                                )
                              , (SELECT Movement.InvNumber
                                 FROM MovementItem
                                      INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                 WHERE MovementItem.Id = vbId_sale_part
                                )
                              , (SELECT zfConvert_DateToString (Movement.OperDate)
                                 FROM MovementItem
                                      INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                 WHERE MovementItem.Id = vbId_sale_part
                                )
                               ;
            END IF;
         END IF;

         -- !!!не забыли - изменили свойства в партии!!!
         PERFORM lpUpdate_Object_PartionGoods_Movement (inMovementId := ioId
                                                      , inPartnerId  := inFromId
                                                      , inUnitId     := inToId
                                                      , inOperDate   := inOperDate
                                                      , inCurrencyId := inCurrencyDocumentId
                                                      , inUserId     := inUserId
                                                       );

         -- !!!Кроме Sybase!!! - !!!не забыли - проверили что НЕТ движения, тогда дату цены в истории можно менять!!!
         -- PERFORM lpCheck ...
         -- !!!Кроме Sybase!!! - !!!не забыли - изменили дату цены в истории!!!
         -- PERFORM lpUpdate_ObjectHistory ...

     END IF;


     -- сохранили свойство <Курс для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, inCurrencyValue);
     -- сохранили свойство <Курс для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, inParValue);

     -- сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили связь с <Валюта (документа)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), ioId, inCurrencyDocumentId);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 09.06.17                                                       *  add inUserId in lpInsertUpdate_Movement
 10.04.17         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Income (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
