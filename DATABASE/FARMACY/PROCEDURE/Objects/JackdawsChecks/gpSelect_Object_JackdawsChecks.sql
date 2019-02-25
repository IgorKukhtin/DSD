-- Function: gpSelect_Object_JackdawsChecks(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_JackdawsChecks(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JackdawsChecks(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_DiffKind());

   RETURN QUERY 
     SELECT Object_JackdawsChecks.Id                     AS Id
          , Object_JackdawsChecks.ObjectCode             AS Code
          , Object_JackdawsChecks.ValueData              AS Name
          , Object_JackdawsChecks.isErased               AS isErased
     FROM Object AS Object_JackdawsChecks
     WHERE Object_JackdawsChecks.DescId = zc_Object_JackdawsChecks();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.02.19                                                       * 

*/

-- тест
-- SELECT * FROM gpSelect_Object_JackdawsChecks('2')