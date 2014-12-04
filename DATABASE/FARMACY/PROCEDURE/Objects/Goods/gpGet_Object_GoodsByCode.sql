-- Function: gpGet_Object_Goods()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsByCode(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsByCode(
    IN inGoodsCode   Integer,       -- Товар 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar) AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
BEGIN
       vbUserId := lpGetUserBySession (inSession);

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Goods());
  
       vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

       RETURN QUERY 
     SELECT Object_Goods_View.Id             AS Id 
          , Object_Goods_View.GoodsCodeInt   AS Code
          , Object_Goods_View.GoodsName      AS Name
                    
     FROM Object_Goods_View
    WHERE Object_Goods_View.GoodsCodeInt = inGoodsCode AND Object_Goods_View.ObjectId = vbObjectId;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_GoodsByCode(integer, TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.12.14                        *

*/

-- тест
-- SELECT * FROM gpGet_Object_Goods('2')