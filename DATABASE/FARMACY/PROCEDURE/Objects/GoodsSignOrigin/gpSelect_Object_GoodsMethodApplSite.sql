-- Function: gpSelect_Object_GoodsSignOriginSite(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsSignOriginSite(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsSignOriginSite(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar, NameUkr TVarChar, Status Integer) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsSignOrigin());

   RETURN QUERY 
     SELECT Object_GoodsSignOrigin.Id               AS Id
          , Object_GoodsSignOrigin.ValueData                AS Name
          , ObjectString_GoodsSignOrigin_NameUkr.ValueData  AS NameUkr
          , CASE WHEN COALESCE(Object_GoodsSignOrigin.isErased,FALSE)=TRUE THEN 0::Integer ELSE 1::Integer END AS Status
     FROM OBJECT AS Object_GoodsSignOrigin

          LEFT JOIN ObjectString AS ObjectString_GoodsSignOrigin_NameUkr
                                 ON ObjectString_GoodsSignOrigin_NameUkr.ObjectId = Object_GoodsSignOrigin.Id
                                AND ObjectString_GoodsSignOrigin_NameUkr.DescId = zc_ObjectString_GoodsSignOrigin_NameUkr()   

     WHERE Object_GoodsSignOrigin.DescId = zc_Object_GoodsSignOrigin()
     ORDER BY Object_GoodsSignOrigin.ID;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsSignOrigin(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.07.22                                                       *              

*/

-- тест
-- 
SELECT * FROM gpSelect_Object_GoodsSignOriginSite(zfCalc_UserSite())