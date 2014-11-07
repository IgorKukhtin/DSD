-- Function: gpSelect_Object_Goods_Lite()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsMain_Lite(TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsMain_Lite(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbObjectId Integer;
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);



   RETURN QUERY 
   SELECT Object_Goods.Id           AS Id 
        , Object_Goods.GoodsCode    AS Code
        , Object_Goods.GoodsName    AS Name
        , Object_Goods.isErased
  
    FROM Object_Goods_Main_View AS Object_Goods;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsMain_Lite(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.10.14                         *
 24.06.14         *
 20.06.13                         *

*/

-- тест
 --SELECT * FROM gpSelect_Object_Goods('2')


