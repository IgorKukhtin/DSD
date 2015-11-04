-- Function: gpSelect_Object_ConditionPromo(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ConditionPromo(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ConditionPromo(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY
     SELECT
       Object.Id                    AS Id
     , Object.ObjectCode            AS Code
     , Object.ValueData             AS Name
     , Object.isErased
     FROM Object
     WHERE Object.DescId = zc_Object_ConditionPromo();
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ConditionPromo (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 31.10.15                                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ConditionPromo('2')