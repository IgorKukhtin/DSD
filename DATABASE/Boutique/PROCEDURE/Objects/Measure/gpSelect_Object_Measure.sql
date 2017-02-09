-- Function: gpSelect_Object_Measure()

DROP FUNCTION IF EXISTS gpSelect_Object_Measure (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Measure(
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, InternalCode TVarChar, InternalName TVarChar, isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());

   RETURN QUERY
   SELECT
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , OS_Measure_InternalCode.ValueData  AS InternalCode
           , OS_Measure_InternalName.ValueData  AS InternalName
           , Object.isErased   AS isErased

   FROM Object
        LEFT JOIN ObjectString AS OS_Measure_InternalName
                 ON OS_Measure_InternalName.ObjectId = Object.Id
                AND OS_Measure_InternalName.DescId = zc_ObjectString_Measure_InternalName()
        LEFT JOIN ObjectString AS OS_Measure_InternalCode
                 ON OS_Measure_InternalCode.ObjectId = Object.Id
                AND OS_Measure_InternalCode.DescId = zc_ObjectString_Measure_InternalCode()

   WHERE Object.DescId = zc_Object_Measure();

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Measure(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.10.14                                                       *
 13.06.13          *
 00.06.13

*/

-- тест
-- SELECT * FROM gpSelect_Object_Measure('2')
