-- Function: gpGet_Object_Measure()

DROP FUNCTION IF EXISTS gpGet_Object_Measure (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Measure(
    IN inId          Integer,       -- Единица измерения
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, InternalCode TVarChar, InternalName TVarChar, isErased boolean) AS
$BODY$BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE(MAX (Object.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST ('' as TVarChar)  AS InternalCode
           , CAST ('' as TVarChar)  AS InternalName
           , CAST (NULL AS Boolean) AS isErased
       FROM Object
       WHERE Object.DescId = zc_Object_Measure();
   ELSE
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
       WHERE Object.Id = inId;
   END IF;

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Measure(integer, TVarChar)
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.10.14                                                       *
 13.06.13          *
 00.06.13
 18.06.13                      *  COALESCE(MAX (Object.ObjectCode), 0) + 1 AS Code
*/

-- тест
-- SELECT * FROM gpSelect_Measure('2')
