-- Function: gpSelect_Object_FormDispensingSite(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_FormDispensingSite(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_FormDispensingSite(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar, NameUkr TVarChar, Status Integer) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_FormDispensing());

   RETURN QUERY 
     SELECT Object_FormDispensing.Id               AS Id
          , Object_FormDispensing.ValueData                AS Name
          , ObjectString_FormDispensing_NameUkr.ValueData  AS NameUkr
          , CASE WHEN COALESCE(Object_FormDispensing.isErased,FALSE)=TRUE THEN 0::Integer ELSE 1::Integer END AS Status
     FROM OBJECT AS Object_FormDispensing

          LEFT JOIN ObjectString AS ObjectString_FormDispensing_NameUkr
                                 ON ObjectString_FormDispensing_NameUkr.ObjectId = Object_FormDispensing.Id
                                AND ObjectString_FormDispensing_NameUkr.DescId = zc_ObjectString_FormDispensing_NameUkr()   

     WHERE Object_FormDispensing.DescId = zc_Object_FormDispensing()
     ORDER BY Object_FormDispensing.ID;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_FormDispensing(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.09.21                                                       *              

*/

-- тест
-- 
SELECT * FROM gpSelect_Object_FormDispensingSite(zfCalc_UserSite())