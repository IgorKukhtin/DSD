-- Function: gpSelect_Object_Position(TVarChar)

--DROP FUNCTION gpSelect_Object_Position(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Position(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Position());

   RETURN QUERY 
     SELECT 
           Object_Position.Id             AS Id
         , Object_Position.ObjectCode     AS Code
         , Object_Position.ValueData      AS Name
         , Object_Position.isErased       AS isErased
     FROM OBJECT AS Object_Position
     WHERE Object_Position.DescId = zc_Object_Position();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Position(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.13          *              

*/

-- тест
-- SELECT * FROM gpSelect_Object_Position('2')