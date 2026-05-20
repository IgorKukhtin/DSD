-- Function: lpGetInsert_Object_PricePlanItem(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpGetInsert_Object_PricePlanItem (Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGetInsert_Object_PricePlanItem(
    IN inPriceListId         Integer,      -- Прайс-лист
    IN inGoodsId             Integer,      -- Товар
    IN inGoodsKindId         Integer,      -- Вид Товар
    IN inUserId              Integer
)
RETURNS Integer
AS
$BODY$
DECLARE vbId Integer;
BEGIN
   

   IF COALESCE (inGoodsKindId,0) > 0
   THEN  
       -- пока ставим запрет на сохранение цены с видом
       -- RAISE EXCEPTION 'Ошибка.Запрещено сохранение цены по виду товара.';
       -- поиск
       vbId:= (SELECT ObjectLink_PricePlanItem_Goods.ObjectId
               FROM ObjectLink AS ObjectLink_PricePlanItem_Goods
                    JOIN ObjectLink AS ObjectLink_PricePlanItem_PriceList
                                    ON ObjectLink_PricePlanItem_PriceList.ObjectId      = ObjectLink_PricePlanItem_Goods.ObjectId
                                   AND ObjectLink_PricePlanItem_PriceList.DescId        = zc_ObjectLink_PricePlanItem_PriceList()
                                   AND ObjectLink_PricePlanItem_PriceList.ChildObjectId = inPriceListId
                    JOIN ObjectLink AS ObjectLink_PricePlanItem_GoodsKind
                                    ON ObjectLink_PricePlanItem_GoodsKind.ObjectId      = ObjectLink_PricePlanItem_Goods.ObjectId
                                   AND ObjectLink_PricePlanItem_GoodsKind.DescId        = zc_ObjectLink_PricePlanItem_GoodsKind()
                                   AND ObjectLink_PricePlanItem_GoodsKind.ChildObjectId = inGoodsKindId
               WHERE ObjectLink_PricePlanItem_Goods.DescId            = zc_ObjectLink_PricePlanItem_Goods()
                 AND ObjectLink_PricePlanItem_Goods.ChildObjectId     = inGoodsId
              );
   ELSE
        -- поиск
       vbId:= (SELECT ObjectLink_PricePlanItem_Goods.ObjectId
               FROM ObjectLink AS ObjectLink_PricePlanItem_Goods
                    JOIN ObjectLink AS ObjectLink_PricePlanItem_PriceList
                                    ON ObjectLink_PricePlanItem_PriceList.ObjectId      = ObjectLink_PricePlanItem_Goods.ObjectId
                                   AND ObjectLink_PricePlanItem_PriceList.DescId        = zc_ObjectLink_PricePlanItem_PriceList()
                                   AND ObjectLink_PricePlanItem_PriceList.ChildObjectId = inPriceListId
                    LEFT JOIN ObjectLink AS ObjectLink_PricePlanItem_GoodsKind
                                         ON ObjectLink_PricePlanItem_GoodsKind.ObjectId      = ObjectLink_PricePlanItem_Goods.ObjectId
                                        AND ObjectLink_PricePlanItem_GoodsKind.DescId        = zc_ObjectLink_PricePlanItem_GoodsKind()
               WHERE ObjectLink_PricePlanItem_Goods.DescId            = zc_ObjectLink_PricePlanItem_Goods()
                 AND ObjectLink_PricePlanItem_Goods.ChildObjectId     = inGoodsId
                 AND ObjectLink_PricePlanItem_GoodsKind.ChildObjectId IS NULL
              );
   END IF;


  -- поиск
  IF COALESCE (vbId, 0) = 0 THEN
     -- сохранили <Объект>
     vbId := lpInsertUpdate_Object(0, zc_Object_PricePlanItem(), 0, '');

     --
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PricePlanItem_PriceList(), vbId, inPriceListId);
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PricePlanItem_Goods()    , vbId, inGoodsId);
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PricePlanItem_GoodsKind(), vbId, inGoodsKindId);

  END IF;

  -- вернули значение
  RETURN vbId;

END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.05.26         *
*/

-- тест
--