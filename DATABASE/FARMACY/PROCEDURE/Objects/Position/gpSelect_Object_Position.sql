-- Function: gpSelect_Object_Position(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Position(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Position(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , TaxService TFloat
             , isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Position());

   RETURN QUERY 
     SELECT 
           Object_Position.Id                 AS Id
         , Object_Position.ObjectCode         AS Code
         , Object_Position.ValueData          AS Name
         , ObjectFloat_TaxService.ValueData   AS TaxService
         , Object_Position.isErased           AS isErased
     FROM OBJECT AS Object_Position
        LEFT JOIN ObjectFloat AS ObjectFloat_TaxService
                              ON ObjectFloat_TaxService.ObjectId = Object_Position.Id
                             AND ObjectFloat_TaxService.DescId = zc_ObjectFloat_Position_TaxService()

     WHERE Object_Position.DescId = zc_Object_Position();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Position(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.01.16         *              

*/

-- тест
-- SELECT * FROM gpSelect_Object_Position('2')