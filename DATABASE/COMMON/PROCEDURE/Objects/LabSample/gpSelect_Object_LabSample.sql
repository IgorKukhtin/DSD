-- Function: gpSelect_Object_LabSample()

DROP FUNCTION IF EXISTS gpSelect_Object_LabSample(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_LabSample(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_LabSample());

   RETURN QUERY 
   SELECT 
     Object.Id         AS Id 
   , Object.ObjectCode AS Code
   , Object.ValueData  AS Name
   , Object.isErased   AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_LabSample();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_LabSample(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.10.19          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_LabSample('2')