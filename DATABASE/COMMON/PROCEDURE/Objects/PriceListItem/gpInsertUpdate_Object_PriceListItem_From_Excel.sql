-- Function: gpInsertUpdate_Object_PriceListItem_From_Excel (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceListItem_From_Excel (TDateTime, Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceListItem_From_Excel(
    IN inOperDate        TDateTime,
    IN inPriceListId     Integer  , -- прайс лист
    IN inGoodsCode       Integer  , -- Code Товар
    IN inGoodsKindName   TVarChar , -- Вид Товара
    IN inPriceValue      TFloat   ,  -- Цена
    IN inSession         TVarChar -- сессия пользователя
)
RETURNS VOID AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbGoodsId Integer;
    DECLARE vbGoodsKindId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

    -- Проверка
    IF COALESCE(inPriceListId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Не выбран Прайс-лист.';
    END IF;
    
    IF COALESCE (TRIM (inGoodsKindName), '') <> ''
    THEN 
         -- Проверка
         IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_GoodsKind() AND TRIM (Object.ValueData) ILIKE TRIM (inGoodsKindName))
         THEN
             RAISE EXCEPTION 'Ошибка.Значение вид товара = <%> найден несколько раз.', inGoodsKindName;
         END IF;
         -- поиск вида товара
         vbGoodsKindId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsKind() AND TRIM (Object.ValueData) ILIKE TRIM (inGoodsKindName));
         IF COALESCE (vbGoodsKindId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение вид товара = <%> не найден.', inGoodsKindName;
         END IF;
    END IF;
    
    -- Проверка
    IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inGoodsCode)
    THEN
        RAISE EXCEPTION 'Ошибка.Значение код товара = <%> найден у разных Товаров.', inGoodsCode;
    END IF;
    -- поиск товара по коду
    vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inGoodsCode);

    -- Проверка
    IF COALESCE (vbGoodsId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Значение код товара = <%> не найден.', inGoodsCode;
    END IF;

 
    -- Проверка
    IF inPriceValue < 0
    THEN
        RAISE EXCEPTION 'Ошибка. Цена = <%> не может быть меньше нуля.', inPriceValue;
    END IF;
   
    -- 
    PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId          := 0
                                                      , inPriceListId := inPriceListId
                                                      , inGoodsId     := vbGoodsId
                                                      , inGoodsKindId := vbGoodsKindId
                                                      , inOperDate    := inOperDate
                                                      , inValue       := inPriceValue
                                                      , inUserId      := vbUserId
                                                       );
    -- !!!отключил!!!
    IF 1=0 AND COALESCE (vbGoodsKindId, 0) = 0
    THEN
        PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId          := 0
                                                          , inPriceListId := inPriceListId
                                                          , inGoodsId     := vbGoodsId
                                                          , inGoodsKindId := OL_PriceListItem_GoodsKind.ChildObjectId
                                                          , inOperDate    := inOperDate
                                                        --, inValue       := inPriceValue
                                                          , inValue       := COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0)
                                                          , inUserId      := vbUserId
                                                           )
        FROM ObjectLink AS OL_PriceListItem_Goods
             JOIN ObjectLink AS OL_PriceListItem_PriceList
                             ON OL_PriceListItem_PriceList.ObjectId      = OL_PriceListItem_Goods.ObjectId
                            AND OL_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                            AND OL_PriceListItem_PriceList.ChildObjectId = inPriceListId
             JOIN ObjectLink AS OL_PriceListItem_GoodsKind
                             ON OL_PriceListItem_GoodsKind.ObjectId      = OL_PriceListItem_Goods.ObjectId
                            AND OL_PriceListItem_GoodsKind.DescId        = zc_ObjectLink_PriceListItem_GoodsKind()
                            AND OL_PriceListItem_GoodsKind.ChildObjectId > 0

                               LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                       ON ObjectHistory_PriceListItem.ObjectId = OL_PriceListItem_Goods.ObjectId
                                                      AND ObjectHistory_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                      AND inOperDate - INTERVAL '1 DAY' >= ObjectHistory_PriceListItem.StartDate AND inOperDate - INTERVAL '1 DAY' < ObjectHistory_PriceListItem.EndDate
                               LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                            ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                           AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

        WHERE OL_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
          AND OL_PriceListItem_Goods.ChildObjectId = vbGoodsId
       ;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.03.20         *
*/

-- тест
