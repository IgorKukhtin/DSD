-- Function: gpGet_Object_Position (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Position (Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Position(
    IN inId          Integer,        -- Должности
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               SheetWorkTimeId Integer, SheetWorkTimeName TVarChar,
               PositionPropertyId Integer, PositionPropertyName TVarChar,
               isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Position());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Position()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (0 as Integer)    AS SheetWorkTimeId 
           , CAST ('' as TVarChar)  AS SheetWorkTimeName
           , CAST (0 as Integer)    AS PositionPropertyId 
           , CAST ('' as TVarChar)  AS PositionPropertyName
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
     SELECT 
           Object_Position.Id             AS Id
         , Object_Position.ObjectCode     AS Code
         , Object_Position.ValueData      AS Name
         , Object_SheetWorkTime.Id        AS SheetWorkTimeId 
         , Object_SheetWorkTime.ValueData AS SheetWorkTimeName
         , Object_PositionProperty.Id        AS PositionPropertyId 
         , Object_PositionProperty.ValueData AS PositionPropertyName
         , Object_Position.isErased       AS isErased
     FROM Object AS Object_Position
          LEFT JOIN ObjectLink AS ObjectLink_Position_SheetWorkTime
                               ON ObjectLink_Position_SheetWorkTime.ObjectId = Object_Position.Id
                              AND ObjectLink_Position_SheetWorkTime.DescId = zc_ObjectLink_Position_SheetWorkTime()
          LEFT JOIN Object AS Object_SheetWorkTime ON Object_SheetWorkTime.Id = ObjectLink_Position_SheetWorkTime.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Position_PositionProperty
                               ON ObjectLink_Position_PositionProperty.ObjectId = Object_Position.Id
                              AND ObjectLink_Position_PositionProperty.DescId = zc_ObjectLink_Position_PositionProperty()
          LEFT JOIN Object AS Object_PositionProperty ON Object_PositionProperty.Id = ObjectLink_Position_PositionProperty.ChildObjectId

     WHERE Object_Position.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Position(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.10.24         * PositionProperty
 16.11.16         * add SheetWorkTime
 01.07.13         *

*/

-- тест
-- SELECT * FROM gpSelect_Position('2')