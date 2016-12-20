-- Function: gpSelect_Object_KindOutSP(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_KindOutSP(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_KindOutSP(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_KindOutSP());

   RETURN QUERY 
     SELECT Object_KindOutSP.Id                 AS Id
          , Object_KindOutSP.ObjectCode         AS Code
          , Object_KindOutSP.ValueData          AS Name
          , Object_KindOutSP.isErased           AS isErased
     FROM OBJECT AS Object_KindOutSP
     WHERE Object_KindOutSP.DescId = zc_Object_KindOutSP();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_KindOutSP(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.12.16         *              

*/

-- тест
-- SELECT * FROM gpSelect_Object_KindOutSP('2')