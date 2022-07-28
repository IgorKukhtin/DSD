-- Function: gpSelect_Object_GoodsMethodApplSite(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsMethodApplSite(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsMethodApplSite(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar, NameUkr TVarChar, Status Integer) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsMethodAppl());

   RETURN QUERY 
     SELECT Object_GoodsMethodAppl.Id               AS Id
          , Object_GoodsMethodAppl.ValueData                AS Name
          , ObjectString_GoodsMethodAppl_NameUkr.ValueData  AS NameUkr
          , CASE WHEN COALESCE(Object_GoodsMethodAppl.isErased,FALSE)=TRUE THEN 0::Integer ELSE 1::Integer END AS Status
     FROM OBJECT AS Object_GoodsMethodAppl

          LEFT JOIN ObjectString AS ObjectString_GoodsMethodAppl_NameUkr
                                 ON ObjectString_GoodsMethodAppl_NameUkr.ObjectId = Object_GoodsMethodAppl.Id
                                AND ObjectString_GoodsMethodAppl_NameUkr.DescId = zc_ObjectString_GoodsMethodAppl_NameUkr()   

     WHERE Object_GoodsMethodAppl.DescId = zc_Object_GoodsMethodAppl()
     ORDER BY Object_GoodsMethodAppl.ID;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsMethodAppl(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.07.22                                                       *              

*/

-- тест
-- 
SELECT * FROM gpSelect_Object_GoodsMethodApplSite(zfCalc_UserSite())