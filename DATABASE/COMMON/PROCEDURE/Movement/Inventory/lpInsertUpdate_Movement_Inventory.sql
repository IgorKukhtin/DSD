-- Function: lpInsertUpdate_Movement_Inventory()

--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, Boolean, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, Boolean, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Inventory(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inGoodsGroupId        Integer   , -- Группа товара
    IN inPriceListId         Integer   , -- Прайс лист
    IN inIsGoodsGroupIn      Boolean   , -- Только выбр. группа
    IN inIsGoodsGroupExc     Boolean   , -- Кроме выбр. группы
    IN inisList              Boolean   , -- по всем товарам накладной
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- !!!Проверка - Инвентаризация - запрет на изменения (разрешено только проведение)!!!
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = 11109744)
        AND inUserId > 0
     THEN
          RAISE EXCEPTION 'Ошибка.Нет прав.';
     END IF;
     
     -- !!!замена после Проверки!!!
     IF inUserId < 0 THEN inUserId:= -1 * inUserId; END IF;


     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- проверка
     IF ioId <> 0 AND inOperDate < (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = ioId) - INTERVAL '1 YEAR'
     THEN
         RAISE EXCEPTION 'Ошибка.Дата документа должна быть больше <%>.', zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = ioId) - INTERVAL '1 YEAR');
     END IF;


     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Inventory());

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Inventory(), inInvNumber, inOperDate, NULL, vbAccessKeyId, inUserId);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили связь с <Группа товара>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsGroup(), ioId, inGoodsGroupId);

     -- сохранили связь с <Прайс лист>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, inPriceListId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_GoodsGroupIn(), ioId, inIsGoodsGroupIn);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_GoodsGroupExc(), ioId, inIsGoodsGroupExc);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_List(), ioId, inIsList);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.05.22         *
 22.07.21         *
 18.09.17         *
 29.05.15                                        *
 13.11.14                                        * add vbAccessKeyId
 06.09.14                                        * add lpInsert_MovementProtocol
 18.07.13         * 
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Inventory (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
