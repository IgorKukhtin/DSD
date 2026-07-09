-- Function: gpInsertUpdate_Movement_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Inventory(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Возврат поставщику>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inGoodsGroupId        Integer   , -- Группа товара
    IN inPriceListId         Integer   , -- Прайс лист
 --INOUT ioIsGoodsGroupIn      Boolean   , -- Только выбр. группа
 --INOUT ioIsGoodsGroupExc     Boolean   , -- Кроме выбр. группы
 --   IN inIsList              Boolean   , -- по всем товарам накладной
    IN inSession             TVarChar    -- сессия пользователя
)                               
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Inventory());
   
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_Inventory (ioId               := ioId
                                              , inInvNumber        := inInvNumber
                                              , inOperDate         := inOperDate
                                              , inFromId           := inFromId
                                              , inToId             := inToId
                                              , inGoodsGroupId     := inGoodsGroupId
                                              , inPriceListId      := inPriceListId
                                              , inUserId           := vbUserId
                                               );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.07.26         *
 25.05.22         *
 22.07.21         *
 18.09.17         *
 29.05.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Inventory (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inSession:= '2')
