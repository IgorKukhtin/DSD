-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ Возврат поставщику>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPartionGoodsDate    TDateTime , -- Дата партии/Дата перемещения
    IN inPrice               TFloat    , -- Цена
    IN inSumm                TFloat    , -- Сумма
    IN inHeadCount           TFloat    , -- Количество голов
    IN inCount               TFloat    , -- Количество батонов или упаковок
    IN inPartionGoods        TVarChar  , -- Партия товара/Инвентарный номер
    IN inPartNumber          TVarChar  , -- № по тех паспорту 
    IN inPartionGoodsId      Integer   , -- партия
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inGoodsKindCompleteId Integer   , -- Виды товаров  ГП
    IN inAssetId             Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inUnitId              Integer   , -- Подразделение (для МО)
    IN inStorageId           Integer   , -- Место хранения 
    IN inPartionModelId      Integer   , -- Модель
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

     -- меняем параметр
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;



     -- Проверка
     /*IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.OperDate >= CURRENT_DATE - INTERVAL '1 DAY')
    AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId
                                                          AND MLO.ObjectId IN (8459 -- Склад Реализации
                                                                             , 8458 -- Склад База ГП
                                                                               )
                                                          AND MLO.DescId = zc_MovementLinkObject_From()
               )
    AND EXISTS (SELECT 1
                FROM MovementItem
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                  AND MovementItem.Amount <> 0
                  AND MovementItem.Id <> COALESCE (ioId, 0)
                  AND MovementItem.ObjectId                         = COALESCE (inGoodsId, 0)
                  AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = COALESCE (inGoodsKindId, 0)
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Товар <%> <%> уже существует в документе.Дублирование заблокировано', lfGet_Object_ValueData_sh (inGoodsId), lfGet_Object_ValueData_sh (inGoodsKindId);
         -- select goodsId, goodsKindId, goodsCode, goodsName, goodsKindName from gpSelect_MovementItem_Inventory(inMovementId := 8538761 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '5') where amount <> 0 group by goodsId, goodsKindId, goodsCode, goodsName, goodsKindName having count(*) > 1
     END IF;*/


     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_Inventory (ioId                 := ioId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := inGoodsId
                                                 , inAmount             := inAmount
                                                 , inPartionGoodsDate   := inPartionGoodsDate
                                                 , inPrice              := inPrice
                                                 , inSumm               := inSumm
                                                 , inHeadCount          := inHeadCount
                                                 , inCount              := inCount
                                                 , inPartionGoods       := inPartionGoods
                                                 , inPartNumber         := inPartNumber
                                                 , inPartionGoodsId     := inPartionGoodsId
                                                 , inGoodsKindId        := inGoodsKindId
                                                 , inGoodsKindCompleteId:= inGoodsKindCompleteId
                                                 , inAssetId            := inAssetId
                                                 , inUnitId             := inUnitId
                                                 , inStorageId          := inStorageId
                                                 , inPartionModelId     := inPartionModelId
                                                 , inUserId             := vbUserId
                                                  ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.05.23         *
 19.12.18         * add inPartionGoodsId              
 25.04.05         * add lpInsertUpdate_MovementItem_Inventory
 26.07.14                                        * add inPrice and inUnitId and inStorageId
 21.08.13                                        * add inGoodsKindId
 18.07.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inPartionGoodsId:=0 , inGoodsKindId:= 0, inSession:= '2')
