-- Function: gpSelect_Object_Goods()

--DROP FUNCTION gpSelect_Object_Goods();

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, GoodsGroupId Integer) AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
     Object.Id          AS Id 
   , Object.ObjectCode  AS Code
   , Object.ValueData   AS Name
   , Object.isErased    AS isErased
   , Goods_GoodsGroup.ChildObjectId AS GoodsGroupId
   FROM Object
LEFT JOIN ObjectLink AS Goods_GoodsGroup
       ON Goods_GoodsGroup.ObjectId = Object.Id
      AND Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
  WHERE Object.DescId = zc_Object_Goods();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_Goods(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.06.13          *
 03.06.13          

*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsGroup('2')