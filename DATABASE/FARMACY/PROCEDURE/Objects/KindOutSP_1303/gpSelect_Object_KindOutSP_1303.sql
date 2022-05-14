-- Function: gpSelect_Object_KindOutSP_1303(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_KindOutSP_1303(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_KindOutSP_1303(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_KindOutSP_1303());

   RETURN QUERY 
     SELECT Object_KindOutSP_1303.Id                 AS Id
          , Object_KindOutSP_1303.ObjectCode         AS Code
          , Object_KindOutSP_1303.ValueData          AS Name
          , Object_KindOutSP_1303.isErased           AS isErased
     FROM OBJECT AS Object_KindOutSP_1303
     WHERE Object_KindOutSP_1303.DescId = zc_Object_KindOutSP_1303();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_KindOutSP_1303(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.05.22                                                       *              

*/

-- тест
-- SELECT * FROM gpSelect_Object_KindOutSP_1303('2')