-- Function: gpSelect_Object_Goods_Lite()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Lite(Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Lite(TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_Lite(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, CodeInt Integer, Code TVarChar, Name TVarChar
             , GoodsGroupName TVarChar
             , NDSKindName TVarChar
             , NDS TFloat
             , isErased boolean) AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbObjectId Integer;
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);



   RETURN QUERY 
   SELECT Object_Goods.Id             AS Id 
        , Object_Goods.GoodsCodeInt   AS CodeInt
        , Object_Goods.GoodsCode      AS Code
        , Object_Goods.GoodsName      AS Name
        , Object_Goods.GoodsGroupName AS GoodsGroupName
        , Object_Goods.NDSKindName    AS NDSKindName
        , Object_Goods.NDS            AS NDS
        , Object_Goods.isErased
  
    FROM Object_Goods_View AS Object_Goods
   WHERE Object_Goods.ObjectId = vbObjectId;
  
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
-- SELECT * FROM gpSelect_Object_Goods_Lite('2')