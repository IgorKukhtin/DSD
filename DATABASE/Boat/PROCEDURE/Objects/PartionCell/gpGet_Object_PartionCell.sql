-- Function: gpGet_Object_PartionCell()

DROP FUNCTION IF EXISTS gpGet_Object_PartionCell (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PartionCell(
    IN inId          Integer,       -- Единица измерения
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Level TFloat
             , Comment TVarChar
             ) AS
$BODY$BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PartionCell());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)     AS Id
           , lfGet_ObjectCode(0, zc_Object_PartionCell()) AS Code
           , CAST ('' as TVarChar)   AS Name
           , CAST (NULL as TFLOAT)   AS Level      
           , CAST (NULL as TVarChar) AS Comment  
      ;
   ELSE
       RETURN QUERY
       SELECT
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , ObjectFloat_Level.ValueData        ::TFloat   AS Level
           , ObjectString_Comment.ValueData     ::TVarChar AS Comment
       FROM Object
        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object.Id
                              AND ObjectString_Comment.DescId = zc_ObjectString_PartionCell_Comment()

        LEFT JOIN ObjectFloat AS ObjectFloat_Level
                              ON ObjectFloat_Level.ObjectId = Object.Id
                             AND ObjectFloat_Level.DescId = zc_ObjectFloat_PartionCell_Level()

       WHERE Object.Id = inId;
   END IF;

END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.01.24         *
*/

-- тест
-- SELECT * FROM gpGet_Object_PartionCell(0,'2')