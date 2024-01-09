-- Function: gpSelect_Object_PartionCell_list()

DROP FUNCTION IF EXISTS gpSelect_Object_PartionCell_list (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartionCell_list(
    IN inisErased    Boolean ,
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Level TFloat
             , Comment TVarChar
             , isErased boolean
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PartionCell());

      RETURN QUERY
       SELECT
             Object.Id                                 AS Id
           , Object.ObjectCode                         AS Code
           , Object.ValueData                          AS Name
           , ObjectFloat_Level.ValueData    ::TFloat   AS Level
           , ObjectString_Comment.ValueData ::TVarChar AS Comment
           , Object.isErased                           AS isErased
       FROM Object
        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object.Id
                              AND ObjectString_Comment.DescId = zc_ObjectString_PartionCell_Comment()

        LEFT JOIN ObjectFloat AS ObjectFloat_Level
                              ON ObjectFloat_Level.ObjectId = Object.Id
                             AND ObjectFloat_Level.DescId = zc_ObjectFloat_PartionCell_Level()

       WHERE Object.DescId = zc_Object_PartionCell() 
         AND (Object.isErased = FALSE OR inisErased = TRUE)
      UNION ALL
       SELECT 0 AS Id
            , 0 AS Code
            , 'УДАЛИТЬ' :: TVarChar   AS Name
            , CAST (NULL as TFLOAT)   AS Level      
            , CAST (NULL as TVarChar) AS Comment
            , FALSE                   AS isErased
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  
 08.01.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PartionCell_list (FALSE, zfCalc_UserAdmin())
