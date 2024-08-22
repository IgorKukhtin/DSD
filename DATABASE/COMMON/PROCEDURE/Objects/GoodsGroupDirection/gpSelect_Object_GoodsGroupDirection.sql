-- Function: gpSelect_Object_GoodsGroupDirection (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsGroupDirection (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsGroupDirection(
    IN inShowAll     Boolean,  
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsGroupDirection());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_GoodsGroupDirection.Id          AS Id
           , Object_GoodsGroupDirection.ObjectCode  AS Code
           , Object_GoodsGroupDirection.ValueData   AS Name
           , Object_GoodsGroupDirection.isErased    AS isErased
           
       FROM Object AS Object_GoodsGroupDirection
       WHERE Object_GoodsGroupDirection.DescId = zc_Object_GoodsGroupDirection() 
         AND (Object_GoodsGroupDirection.isErased = inShowAll OR inShowAll = TRUE)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.08.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsGroupDirection (FALSE, zfCalc_UserAdmin())
