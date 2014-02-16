-- Function: lpGetInsert_Object_PriceListItem(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

-- DROP FUNCTION lpGetInsert_Object_PriceListItem(Integer, Integer);

CREATE OR REPLACE FUNCTION lpGetInsert_Object_PriceListItem(
    IN inPriceListId         Integer,      -- Прайс-лист
    IN inGoodsId             Integer       -- Товар
)
RETURNS integer AS
$BODY$
DECLARE
  Id Integer;
BEGIN

   SELECT ObjectLink_PriceListItem_Goods.ObjectId INTO Id
   FROM ObjectLink AS ObjectLink_PriceListItem_Goods
   JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
     ON ObjectLink_PriceListItem_PriceList.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
    AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
    AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
  WHERE ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
    AND ObjectLink_PriceListItem_Goods.ChildObjectId = inGoodsId;

  IF COALESCE(Id, 0) = 0 THEN

     -- сохранили <Объект>
     Id := lpInsertUpdate_Object(0, zc_Object_PriceListItem(), 0, '');

     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceListItem_PriceList(), Id, inPriceListId);
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceListItem_Goods(), Id, inGoodsId);
  END IF;

  RETURN Id;

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpGetInsert_Object_PriceListItem (Integer, Integer) OWNER TO postgres;  


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.06.13                        *

*/

-- тест
-- SELECT * FROM lpGetInsert_Object_PriceListItem()