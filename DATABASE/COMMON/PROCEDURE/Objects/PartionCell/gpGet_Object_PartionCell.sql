-- Function: gpGet_Object_PartionCell()

DROP FUNCTION IF EXISTS gpGet_Object_PartionCell (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PartionCell(
    IN inId          Integer,       -- Единица измерения
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Level TFloat, Length TFloat, Width TFloat, Height TFloat
             , BoxCount TFloat, RowBoxCount TFloat, RowWidth TFloat, RowHeight TFloat
             , Comment TVarChar
             , PSW TVarChar, isLock_record Boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PartionCell());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_PartionCell()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL as TFLOAT)  AS Level      
           , CAST (NULL as TFLOAT)  AS Length     
           , CAST (NULL as TFLOAT)  AS Width      
           , CAST (NULL as TFLOAT)  AS Height     
           , CAST (NULL as TFLOAT)  AS BoxCount    
           , CAST (NULL as TFLOAT)  AS RowBoxCount
           , CAST (NULL as TFLOAT)  AS RowWidth   
           , CAST (NULL as TFLOAT)  AS RowHeight
           , CAST (NULL as TVarChar) AS Comment  
           , CAST ('' AS TVarChar)  AS PSW
           , FALSE :: Boolean       AS isLock_record
      ;
   ELSE
       RETURN QUERY
       SELECT
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , ObjectFloat_Level.ValueData        ::TFloat  AS Level
           , ObjectFloat_Length.ValueData       ::TFloat  AS Length 
           , ObjectFloat_Width.ValueData        ::TFloat  AS Width
           , ObjectFloat_Height.ValueData       ::TFloat  AS Height
           , ObjectFloat_BoxCount.ValueData     ::TFloat  AS BoxCount
           , ObjectFloat_RowBoxCount.ValueData  ::TFloat  AS RowBoxCount
           , ObjectFloat_RowWidth.ValueData     ::TFloat  AS RowWidth
           , ObjectFloat_RowHeight.ValueData    ::TFloat  AS RowHeight    
           , ObjectString_Comment.ValueData     ::TVarChar AS Comment
           , CAST ('' AS TVarChar)  AS PSW
           , FALSE :: Boolean       AS isLock_record

       FROM Object
        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object.Id
                              AND ObjectString_Comment.DescId = zc_ObjectString_PartionCell_Comment()

        LEFT JOIN ObjectFloat AS ObjectFloat_Level
                              ON ObjectFloat_Level.ObjectId = Object.Id
                             AND ObjectFloat_Level.DescId = zc_ObjectFloat_PartionCell_Level()

        LEFT JOIN ObjectFloat AS ObjectFloat_Length
                              ON ObjectFloat_Length.ObjectId = Object.Id
                             AND ObjectFloat_Length.DescId = zc_ObjectFloat_PartionCell_Length()
                
        LEFT JOIN ObjectFloat AS ObjectFloat_Width
                              ON ObjectFloat_Width.ObjectId = Object.Id
                             AND ObjectFloat_Width.DescId = zc_ObjectFloat_PartionCell_Width()

        LEFT JOIN ObjectFloat AS ObjectFloat_Height
                              ON ObjectFloat_Height.ObjectId = Object.Id
                             AND ObjectFloat_Height.DescId = zc_ObjectFloat_PartionCell_Height()

        LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                              ON ObjectFloat_BoxCount.ObjectId = Object.Id
                             AND ObjectFloat_BoxCount.DescId = zc_ObjectFloat_PartionCell_BoxCount()

        LEFT JOIN ObjectFloat AS ObjectFloat_RowBoxCount
                              ON ObjectFloat_RowBoxCount.ObjectId = Object.Id
                             AND ObjectFloat_RowBoxCount.DescId = zc_ObjectFloat_PartionCell_RowBoxCount()

        LEFT JOIN ObjectFloat AS ObjectFloat_RowWidth
                              ON ObjectFloat_RowWidth.ObjectId = Object.Id
                             AND ObjectFloat_RowWidth.DescId = zc_ObjectFloat_PartionCell_RowWidth()                             

        LEFT JOIN ObjectFloat AS ObjectFloat_RowHeight
                              ON ObjectFloat_RowHeight.ObjectId = Object.Id
                             AND ObjectFloat_RowHeight.DescId = zc_ObjectFloat_PartionCell_RowHeight()

       WHERE Object.Id = inId;
   END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.12.23         *
*/

-- тест
-- SELECT * FROM gpGet_Object_PartionCell(0,'2')
