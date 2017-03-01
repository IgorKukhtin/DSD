-- Function: lpInsertUpdate_Movement_StoreReal()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_StoreReal (
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUserId              Integer   , -- пользователь
    IN inPriceListId         Integer   , -- Прайс лист
    IN inPartnerId           Integer   , -- Контрагент
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat      -- % НДС
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
      -- проверка
      IF inOperDate <> DATE_TRUNC('DAY', inOperDate)
      THEN
        RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
      END IF;

      -- определяем ключ доступа
      vbAccessKeyId := NULL; -- lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_StoreReal());

      -- определяем признак Создание/Корректировка
      vbIsInsert := COALESCE(ioId, 0) = 0;

      -- сохранили <Документ>
      ioId := lpInsertUpdate_Movement(ioId, zc_Movement_StoreReal(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

      IF vbIsInsert 
      THEN
           -- сохранили связь с <Пользователь>
           PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_Insert(), ioId, inUserId);
           -- сохранили свойство <Дата создания>
           PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
      END IF;

      -- сохранили связь с <Прайс лист>
      PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PriceList(), ioId, inPriceListId);

      -- сохранили связь с <Контрагент>
      PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_Partner(), ioId, inPartnerId);    

      -- сохранили свойство <Цена с НДС (да/нет)>
      PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
      -- сохранили свойство <% НДС>
      PERFORM lpInsertUpdate_MovementFloat(zc_MovementFloat_VATPercent(), ioId, inVATPercent);

      -- пересчитали Итоговые суммы по накладной
      PERFORM lpInsertUpdate_MovementFloat_TotalSumm(ioId);

      -- сохранили протокол
      PERFORM lpInsert_MovementProtocol(ioId, inUserId, vbIsInsert);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 16.02.17                                                        *                                          
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_StoreReal (ioId := 0, inInvNumber := '-1', inOperDate := CURRENT_DATE, inUserId := 2, inPriceListId := 0, inPartnerId := 0, inPriceWithVAT := TRUE, inVATPercent := 20);
