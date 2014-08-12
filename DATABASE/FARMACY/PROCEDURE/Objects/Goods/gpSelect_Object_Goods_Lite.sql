-- Function: gpSelect_Object_Goods_Lite()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Lite(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_Lite(
    IN inObjectId    INTEGER , 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, CodeInt Integer, Code TVarChar, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT Object_Goods.Id           AS Id 
        , Object_Goods.GoodsCodeInt AS CodeInt
        , Object_Goods.GoodsCode    AS Code
        , Object_Goods.GoodsName    AS Name
        , Object_Goods.isErased
  
    FROM Object_Goods_View AS Object_Goods
   WHERE (inObjectId = 0 AND Object_Goods.ObjectId IS NULL) OR (Object_Goods.ObjectId = inObjectId AND inObjectId <> 0);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Goods_Lite(Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.06.14         *
 20.06.13                         *

*/

-- тест
 --SELECT * FROM gpSelect_Object_Goods('2')


