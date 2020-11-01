-- Function: lpInsertUpdate_Movement_SaleExternal()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_SaleExternal (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_SaleExternal(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата(склад)
    IN inFromId              Integer   , -- От кого (в документе)
    IN inGoodsPropertyId     Integer   , -- Классификатор свойств товаров 	
    In inComment             TVarChar  , -- примечание
    IN inUserId              Integer     -- Пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_SaleExternal(), inInvNumber,  DATE_TRUNC ('MONTH', inOperDate), NULL);

     -- сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);

     -- сохранили связь с <Классификатор свойств товаров>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsProperty(), ioId, inGoodsPropertyId);

     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <Дата создания> 
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили связь с <Пользователь>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     END IF;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
31.10.20          *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_SaleExternal (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inChecked:=TRUE, inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 1, inSession:= zfCalc_UserAdmin())
