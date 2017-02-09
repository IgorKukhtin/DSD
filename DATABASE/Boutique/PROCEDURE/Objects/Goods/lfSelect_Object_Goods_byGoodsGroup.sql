-- Function: lfSelect_Object_Goods_byGoodsGroup (Integer)

-- DROP FUNCTION lfSelect_Object_Goods_byGoodsGroup (Integer);

CREATE OR REPLACE FUNCTION lfSelect_Object_Goods_byGoodsGroup (IN inGoodsGroupId Integer)
RETURNS TABLE (GoodsId Integer)  
AS
$BODY$
BEGIN

     -- Выбираем данные
     RETURN QUERY
     
     WITH RECURSIVE RecurObjectLink (ObjectId) AS
       (SELECT inGoodsGroupId
       UNION
        SELECT ObjectLink.ObjectId
        FROM ObjectLink
             INNER JOIN RecurObjectLink ON RecurObjectLink.ObjectId = ObjectLink.ChildObjectId
        WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
       ) 
     SELECT ObjectLink.ObjectId AS GoodsId
     FROM RecurObjectLink
          JOIN ObjectLink ON ObjectLink.ChildObjectId = RecurObjectLink.ObjectId
                         AND ObjectLink.DescId = zc_ObjectLink_Goods_GoodsGroup()
    ;
     
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfSelect_Object_Goods_byGoodsGroup (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.05.13                                        * all
 20.09.13         * вроде работает правильно)))             
 09.09.13         *
*/

-- тест
-- SELECT * FROM lfSelect_Object_Goods_byGoodsGroup (1832) AS lfSelect_Object_Goods_byGoodsGroup JOIN Object_Goods_View ON Object_Goods_View.GoodsId = lfSelect_Object_Goods_byGoodsGroup.GoodsId ORDER BY 4
