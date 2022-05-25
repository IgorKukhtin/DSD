-- Function: gpInsertUpdate_Movement_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Inventory(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Возврат поставщику>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inGoodsGroupId        Integer   , -- Группа товара
    IN inPriceListId         Integer   , -- Прайс лист
 INOUT ioIsGoodsGroupIn      Boolean   , -- Только выбр. группа
 INOUT ioIsGoodsGroupExc     Boolean   , -- Кроме выбр. группы
    IN inIsList              Boolean   , -- по всем товарам накладной
    IN inSession             TVarChar    -- сессия пользователя
)                               
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   
   DECLARE vbisGoodsGroupIn  Boolean;
   DECLARE vbisGoodsGroupExc Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Inventory());

     -- получаем прошлые значения Только выбр. группа / Кроме выбр. группы (для того чтобы одновременно не были выбранны обе галки)
     SELECT COALESCE (MovementBoolean_GoodsGroupIn.ValueData, FALSE)  :: Boolean AS isGoodsGroupIn
          , COALESCE (MovementBoolean_GoodsGroupExc.ValueData, FALSE) :: Boolean AS isGoodsGroupExc
          INTO vbisGoodsGroupIn, vbisGoodsGroupExc
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_GoodsGroupIn
                                    ON MovementBoolean_GoodsGroupIn.MovementId = Movement.Id
                                   AND MovementBoolean_GoodsGroupIn.DescId = zc_MovementBoolean_GoodsGroupIn()

          LEFT JOIN MovementBoolean AS MovementBoolean_GoodsGroupExc
                                    ON MovementBoolean_GoodsGroupExc.MovementId = Movement.Id
                                   AND MovementBoolean_GoodsGroupExc.DescId = zc_MovementBoolean_GoodsGroupExc()
     WHERE Movement.Id = ioId;
     
     --
     IF ioIsGoodsGroupIn <> vbisGoodsGroupIn AND ioIsGoodsGroupIn = TRUE
     THEN
          ioIsGoodsGroupExc := NOT ioIsGoodsGroupIn;
     END IF;
     IF ioIsGoodsGroupExc <> vbisGoodsGroupExc AND ioIsGoodsGroupIn = TRUE
     THEN
          ioIsGoodsGroupIn := NOT ioIsGoodsGroupExc;
     END IF; 
     
     -- замена
     IF inIsList = TRUE
     THEN
         ioIsGoodsGroupIn := FALSE;
         ioIsGoodsGroupExc:= FALSE;
     END IF;
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_Inventory (ioId               := ioId
                                              , inInvNumber        := inInvNumber
                                              , inOperDate         := inOperDate
                                              , inFromId           := inFromId
                                              , inToId             := inToId
                                              , inGoodsGroupId     := inGoodsGroupId
                                              , inPriceListId      := inPriceListId
                                              , inisGoodsGroupIn   := ioIsGoodsGroupIn
                                              , inisGoodsGroupExc  := ioIsGoodsGroupExc
                                              , inIsList           := inIsList
                                              , inUserId           := vbUserId
                                               );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.22         *
 22.07.21         *
 18.09.17         *
 29.05.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Inventory (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inSession:= '2')
