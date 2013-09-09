-- Function: lfSelect_Object_Goods_byGoodsGroup (Integer)

-- DROP FUNCTION lfSelect_Object_Goods_byGoodsGroup (Integer);

CREATE OR REPLACE FUNCTION lfSelect_Object_Goods_byGoodsGroup (IN inGoodsGroupId Integer)
RETURNS TABLE  (GoodsId Integer)  
AS
$BODY$
BEGIN

     -- Выбираем данные для справочника счетов (на самом деле это три справочника)
     RETURN QUERY
     SELECT ObjectLink_0.ObjectId AS GoodsId 
     FROM ObjectLink AS ObjectLink_0
          LEFT JOIN ObjectLink AS ObjectLink_1 ON ObjectLink_0.ChildObjectId = ObjectLink_1.ObjectId  
          LEFT JOIN ObjectLink AS ObjectLink_2 ON ObjectLink_1.ChildObjectId = ObjectLink_2.ObjectId
          LEFT JOIN ObjectLink AS ObjectLink_3 ON ObjectLink_2.ChildObjectId = ObjectLink_3.ObjectId
          LEFT JOIN ObjectLink AS ObjectLink_4 ON ObjectLink_3.ChildObjectId = ObjectLink_4.ObjectId
          LEFT JOIN ObjectLink AS ObjectLink_5 ON ObjectLink_4.ChildObjectId = ObjectLink_5.ObjectId
          LEFT JOIN ObjectLink AS ObjectLink_6 ON ObjectLink_5.ChildObjectId = ObjectLink_6.ObjectId
          LEFT JOIN ObjectLink AS ObjectLink_7 ON ObjectLink_6.ChildObjectId = ObjectLink_7.ObjectId
          LEFT JOIN ObjectLink AS ObjectLink_8 ON ObjectLink_7.ChildObjectId = ObjectLink_8.ObjectId
          LEFT JOIN ObjectLink AS ObjectLink_9 ON ObjectLink_8.ChildObjectId = ObjectLink_9.ObjectId
          LEFT JOIN ObjectLink AS ObjectLink_10 ON ObjectLink_9.ChildObjectId = ObjectLink_10.ObjectId
     WHERE ObjectLink_0.DescId = zc_ObjectLink_Goods_GoodsGroup() 
       AND ((ObjectLink_0.ChildObjectId = inGoodsGroupId)
         OR (ObjectLink_1.ChildObjectId = inGoodsGroupId)
         OR (ObjectLink_2.ChildObjectId = inGoodsGroupId)
         OR (ObjectLink_3.ChildObjectId = inGoodsGroupId)
         OR (ObjectLink_4.ChildObjectId = inGoodsGroupId)
         OR (ObjectLink_5.ChildObjectId = inGoodsGroupId)
         OR (ObjectLink_6.ChildObjectId = inGoodsGroupId)
         OR (ObjectLink_7.ChildObjectId = inGoodsGroupId)
         OR (ObjectLink_8.ChildObjectId = inGoodsGroupId)
         OR (ObjectLink_9.ChildObjectId = inGoodsGroupId)
           ) ;

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfSelect_Object_Goods_byGoodsGroup (Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.09.13         *
*/

-- тест
-- SELECT * FROM lfSelect_Object_Goods_byGoodsGroup (zc_Enum_GoodsGroup_20000())
