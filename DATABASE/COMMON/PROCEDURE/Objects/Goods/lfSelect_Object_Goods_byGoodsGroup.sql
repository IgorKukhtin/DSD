-- Function: lfSelect_Object_Goods_byGoodsGroup (Integer)

-- DROP FUNCTION lfSelect_Object_Goods_byGoodsGroup (Integer);

CREATE OR REPLACE FUNCTION lfSelect_Object_Goods_byGoodsGroup (IN inGoodsGroupId Integer)
RETURNS TABLE  (GoodsId Integer)  
AS
$BODY$
BEGIN

     -- Выбираем данные для справочника счетов (на самом деле это три справочника)
     RETURN QUERY
     
     WITH RECURSIVE RecurObjectLink (ObjectId, GroupId) AS
    (
    	SELECT ObjectLink.ObjectId, ObjectLink.ChildObjectId AS GroupId
    	FROM ObjectLink
	    WHERE ObjectLink.ChildObjectId=inGoodsGroupId OR ObjectLink.ObjectId=inGoodsGroupId 
	      AND ObjectLink.DescId =  zc_ObjectLink_GoodsGroup_Parent()
     UNION
    	SELECT ObjectLink.ObjectId, ObjectLink.ChildObjectId AS GroupId
    	FROM ObjectLink
    	    inner join RecurObjectLink ON RecurObjectLink.ObjectId = ObjectLink.ChildObjectId
    	                              AND ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
    ) 

    SELECT Object_Goods.Id AS GoodsId
    FROM Object AS Object_Goods
         JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                                       AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                                       AND ObjectLink_Goods_GoodsGroup.ChildObjectId IN (SELECT ObjectId FROM RecurObjectLink)
    WHERE Object_Goods.DescId = zc_Object_Goods();
     
 END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfSelect_Object_Goods_byGoodsGroup (Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.13         * вроде работает правильно)))             
 09.09.13         *
*/

-- тест
-- SELECT * FROM lfSelect_Object_Goods_byGoodsGroup (zc_Enum_GoodsGroup_20000())
