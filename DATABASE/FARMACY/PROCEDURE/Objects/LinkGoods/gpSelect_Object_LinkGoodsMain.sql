-- Function: gpSelect_Object_LinkGoodsMain(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_LinkGoodsMain(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_LinkGoodsMain(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_LinkGoodsMain(
    IN inObjectId    Integer, 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsMainId Integer, GoodsCodeInt Integer, GoodsMainName TVarChar
             , GoodsId Integer    
             ) AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_AdditionalGoods());
   vbUserId := lpGetUserBySession (inSession);

   RETURN QUERY 
     SELECT                                          	

           Object_LinkGoods_View.Id               
         , Object_LinkGoods_View.GoodsMainId
         , Object_LinkGoods_View.GoodsCodeInt
         , Object_LinkGoods_View.GoodsMainName
         , Object_LinkGoods_View.GoodsId
         
     FROM Object_LinkGoods_View 
           
    WHERE Object_LinkGoods_View.ObjectId = inObjectId AND Object_LinkGoods_View.ObjectMainId IS NULL;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_LinkGoodsMain (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.08.14                        *
 02.07.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_AdditionalGoods ('2')
