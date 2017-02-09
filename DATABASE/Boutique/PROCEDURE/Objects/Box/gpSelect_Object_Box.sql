-- Function: gpSelect_Object_Box()

--DROP FUNCTION gpSelect_Object_Box();
DROP FUNCTION IF EXISTS gpSelect_Object_Box (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Box(
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  BoxVolume TFloat, BoxWeight TFloat, isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Box());

   RETURN QUERY
   SELECT
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , OF_Box_Volume.ValueData  AS BoxVolume
           , OF_Box_Weight.ValueData  AS BoxWeight
           , Object.isErased   AS isErased

   FROM Object
        LEFT JOIN ObjectFloat AS OF_Box_Volume
                 ON OF_Box_Volume.ObjectId = Object.Id
                AND OF_Box_Volume.DescId = zc_ObjectFloat_Box_Volume()
        LEFT JOIN ObjectFloat AS OF_Box_Weight
                 ON OF_Box_Weight.ObjectId = Object.Id
                AND OF_Box_Weight.DescId = zc_ObjectFloat_Box_Weight()

   WHERE Object.DescId = zc_Object_Box();

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Box(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.10.14                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Box('2')