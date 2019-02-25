-- Function: gpGet_Object_JackdawsChecks (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_JackdawsChecks (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_JackdawsChecks(
    IN inId          Integer,        -- Должности
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_JackdawsChecks());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 AS Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_JackdawsChecks()) AS Code
           , CAST ('' AS TVarChar)  AS NAME
           , FALSE                  AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_JackdawsChecks.Id                     AS Id
            , Object_JackdawsChecks.ObjectCode             AS Code
            , Object_JackdawsChecks.ValueData              AS Name
            , Object_JackdawsChecks.isErased               AS isErased
       FROM Object AS Object_JackdawsChecks
       WHERE Object_JackdawsChecks.Id = inId;
   END IF;
   
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.02.19                                                       * 
*/

-- тест
-- SELECT * FROM gpGet_Object_JackdawsChecks(0,'2')