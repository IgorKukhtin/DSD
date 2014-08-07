-- Function: gpSelect_Object_Goods_Lite()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Lite(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_Lite(
    IN inObjectId    INTEGER , 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar) AS
$BODY$
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT Object_Goods.Id           AS Id 
        , Object_Goods.ObjectCode   AS Code
        , Object_Goods.ValueData    AS Name
  
    FROM Object_MainGoods_View AS Object_Goods
   WHERE ObjectId = inObjectId;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Goods_Lite(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.06.14         *
 20.06.13                         *

*/

-- тест
 --SELECT * FROM gpSelect_Object_Goods('2')


