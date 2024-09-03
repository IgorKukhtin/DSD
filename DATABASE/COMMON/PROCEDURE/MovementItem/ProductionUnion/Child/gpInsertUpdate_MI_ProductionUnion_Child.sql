-- Function: gpInsertUpdate_MI_ProductionUnion_Child()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, TFloat, Integer, TDateTime, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ Производство - смешивание>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inCount_onCount       TFloat    , -- Количество батонов
    IN inParentId            Integer   , -- Главный элемент документа
    IN inPartionGoodsDate    TDateTime , -- Партия товара	
    IN inPartionGoods        TVarChar  , -- Партия товара        
 INOUT ioPartNumber          TVarChar  , -- № по тех паспорту
 INOUT ioModel               TVarChar  , -- модель
    IN inGoodsKindId         Integer   , -- Виды товаров 
    IN inGoodsKindCompleteId Integer   , -- Виды товаров ГП
    IN inStorageId           Integer   , -- Место хранения           
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProductionUnion());

   -- сохранили 
   ioId := lpInsertUpdate_MI_ProductionUnion_Child(ioId               := ioId
                                                 , inMovementId       := inMovementId
                                                 , inGoodsId          := inGoodsId
                                                 , inAmount           := inAmount
                                                 , inParentId         := inParentId
                                                 , inPartionGoodsDate := inPartionGoodsDate
                                                 , inPartionGoods     := inPartionGoods 
                                                 , inPartNumber       := ioPartNumber
                                                 , inModel            := ioModel
                                                 , inGoodsKindId      := inGoodsKindId
                                                 , inGoodsKindCompleteId := inGoodsKindCompleteId  
                                                 , inStorageId        := inStorageId
                                                 , inCount_onCount    := inCount_onCount -- COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_Count()), 0)
                                                 , inUserId           := vbUserId
                                                 );
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.05.23         * Model
 07.11.15         * add inGoodsKindCompleteId
 21.03.15                                        * all
 11.12.14         * add lpInsertUpdate_MI_ProductionUnion_Child
 24.07.13                                        * Важен порядок полей
 15.07.13         *     
 30.06.13                                        *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ProductionUnion_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
