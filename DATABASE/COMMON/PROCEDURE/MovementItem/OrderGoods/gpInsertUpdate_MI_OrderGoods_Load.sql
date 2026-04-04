-- Function: gpInsertUpdate_MI_OrderGoods_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderGoods_Load (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_OrderGoods_Load(
    IN inMovementId          Integer   , -- Ключ объекта
    IN inGoodsCode           Integer   , -- Товар код
    IN inGoodsName           TVarChar  , -- товар название
    IN inGoodsKindName       TVarChar  , -- Виды товаров 
    IN inMeasureName         TVarChar  , --
    IN inAmountWeight        TFloat    , -- кол вес 
    IN inAmount              TFloat    , -- кол шт
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId     Integer;
   DECLARE vbGoodsKindId Integer;
           vbMIId        Integer;
           vbPriceListId Integer;
           vbPrice       TFloat; 
           vbOperDate    TDateTime;
           
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderGoods());

     IF COALESCE (inMovementId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не сохранен';
     END IF;

     IF inGoodsCode = 0 AND TRIM (inGoodsName) = ''
     THEN
         RETURN;
     END IF;

    -- находим товар по коду
     vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inGoodsCode AND inGoodsCode > 0);

     IF COALESCE (vbGoodsId,0) = 0 
     THEN
     -- Найти Id товара по названию, если нет кода
    vbGoodsId:= (SELECT Object.Id
                 FROM Object
                 WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inGoodsName))
                   AND Object.ObjectCode = inGoodsCode
                   AND Object.DescId = zc_Object_Goods()
                 LIMIT 1 --
                );
     END IF;
 
     IF COALESCE (vbGoodsId,0) = 0 AND inGoodsCode > 0
     THEN
        RAISE EXCEPTION 'Ошибка. Товар <%> по коду <%> не найден.', inGoodsName, inGoodsCode;
     END IF;


     -- находим вид товара
     vbGoodsKindId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName) AND Object.DescId = zc_Object_GoodsKind() AND TRIM (inGoodsKindName) <> '');

     IF COALESCE (vbGoodsKindId,0) = 0 AND TRIM (inGoodsKindName) <> ''
     THEN
        RAISE EXCEPTION 'Ошибка. Вид товара по названию <%> не найден.', inGoodsKindName;
     END IF;


     --пробуем найти строку если уже создана
     vbMIId := (SELECT MovementItem.Id
                FROM MovementItem
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                WHERE MovementItem.MovementId = 33897276 --inMovementId
                   AND MovementItem.DescId = zc_MI_Master()
                   AND MovementItem.isErased = FALSE
                   AND MovementItem.ObjectId = vbGoodsId
                   AND COALESCE (MILinkObject_GoodsKind.ObjectId,0) = COALESCE(vbGoodsKindId,0)
                );

     --получаем прайс для цены
     vbPriceListId := COALESCE((SELECT MLO.ObjectId 
                                 FROM MovementLinkObject AS MLO
                                 WHERE MLO.DescId = zc_MovementLinkObject_PriceList()
                                   AND MLO.MovementId = inMovementId
                                 )
                             , zc_PriceList_Basis()
                              );
     --получаем цену 
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     vbPrice := COALESCE ( (--товар + вид товара
                            SELECT tmpPrice.ValuePrice 
                            FROM gpSelect_ObjectHistory_PriceListGoodsItem (zc_PriceList_Basis(), vbGoodsId, vbGoodsKindId, zfCalc_UserAdmin()) AS tmpPrice
                            WHERE tmpPrice.StartDate <= vbOperDate AND tmpPrice.EndDate > vbOperDate)
                         , (--товар без вида товара
                            SELECT tmpPrice.ValuePrice FROM gpSelect_ObjectHistory_PriceListGoodsItem (zc_PriceList_Basis(), vbGoodsId, 0, zfCalc_UserAdmin()) AS tmpPrice
                            WHERE tmpPrice.StartDate <= vbOperDate AND tmpPrice.EndDate > vbOperDate)
                         , 0);

     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem_OrderGoods (ioId            := COALESCE (vbMIId,0) ::Integer
                                                   , inMovementId    := 33897276  -- inMovementId
                                                   , inGoodsId       := vbGoodsId
                                                   , inGoodsKindId   := vbGoodsKindId
                                                   , inAmount        := CASE WHEN ObjectLink_Measure.ChildObjectId = zc_Measure_Sh()      -- для шт надо из веса переводить в шт и сохранять Amount
                                                                             THEN CASE WHEN COALESCE (inAmount,0) <> 0 THEN inAmount 
                                                                                        ELSE CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0 THEN inAmountWeight / ObjectFloat_Weight.ValueData ELSE inAmountWeight END 
                                                                                  END
                                                                             ELSE inAmountWeight
                                                                        END       ::TFloat
                                                   , inAmountSecond  := 0         ::TFloat
                                                   , inPrice         := vbPrice   ::TFloat
                                                   , inComment       := ''        ::TVarChar
                                                   , inUserId        := vbUserId
                                                    ) 
     FROM ObjectLink AS ObjectLink_Measure
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = ObjectLink_Measure.ObjectId
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
     WHERE ObjectLink_Measure.ObjectId = vbGoodsId
       AND ObjectLink_Measure.DescId = zc_ObjectLink_Goods_Measure()
     ;


     IF vbUserId = 9457
     THEN
         RAISE EXCEPTION 'Ошибка.ok.';
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.04.26        *
*/

-- тест
--