-- Function: gpSelect_Object_PartionCell_list()

DROP FUNCTION IF EXISTS gpSelect_Object_PartionCell_list (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PartionCell_list (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartionCell_list(
    IN inisErased    Boolean ,
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Name_search TVarChar
             , Level TFloat, Length TFloat, Width TFloat, Height TFloat
             , BoxCount TFloat, RowBoxCount TFloat, RowWidth TFloat, RowHeight TFloat
             , Comment TVarChar  
             , Ord Integer
             , isErased boolean
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PartionCell());

      RETURN QUERY
       SELECT
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name 
           , (Object.ValueData ||'@'||REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (Object.ValueData, '.', ''), '-', ''), ' ', ''), '=', ''), ',', '')) :: TVarChar AS Name_search
           
           , ObjectFloat_Level.ValueData        ::TFloat  AS Level
           , ObjectFloat_Length.ValueData       ::TFloat  AS Length 
           , ObjectFloat_Width.ValueData        ::TFloat  AS Width
           , ObjectFloat_Height.ValueData       ::TFloat  AS Height
           , ObjectFloat_BoxCount.ValueData     ::TFloat  AS BoxCount
           , ObjectFloat_RowBoxCount.ValueData  ::TFloat  AS RowBoxCount
           , ObjectFloat_RowWidth.ValueData     ::TFloat  AS RowWidth
           , ObjectFloat_RowHeight.ValueData    ::TFloat  AS RowHeight    
           , ObjectString_Comment.ValueData     ::TVarChar AS Comment
           
           , (ROW_NUMBER() OVER (ORDER BY ObjectFloat_Level.ValueData
                                       , zfConvert_StringToNumber (zfCalc_Word_Split (inValue:= Object.ValueData, inSep:= '-', inIndex:=2))::Integer
                                       
                                       , zfConvert_StringToNumber (zfCalc_Word_Split (inValue:= Object.ValueData, inSep:= '-', inIndex:=4))::Integer
                                       , zfConvert_StringToNumber (zfCalc_Word_Split (inValue:= Object.ValueData, inSep:= '-', inIndex:=3))::Integer
                                )  -  1 )::Integer AS Ord

           , Object.isErased   AS isErased

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

       WHERE Object.DescId = zc_Object_PartionCell() 
         AND (Object.isErased = FALSE OR inisErased = TRUE)

    /*UNION ALL
       SELECT 0 AS Id
            , 0 AS Code
            , 'УДАЛИТЬ' :: TVarChar AS Name 
            , '' ::TVarChar          AS Name_search
            , CAST (NULL as TFLOAT)  AS Level      
            , CAST (NULL as TFLOAT)  AS Length     
            , CAST (NULL as TFLOAT)  AS Width      
            , CAST (NULL as TFLOAT)  AS Height     
            , CAST (NULL as TFLOAT)  AS BoxCount    
            , CAST (NULL as TFLOAT)  AS RowBoxCount
            , CAST (NULL as TFLOAT)  AS RowWidth   
            , CAST (NULL as TFLOAT)  AS RowHeight
            , CAST (NULL as TVarChar) AS Comment
            , FALSE                  AS isErased*/
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  
 28.12.23         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PartionCell_list (FALSE, zfCalc_UserAdmin())
/*

 SELECT Name, zfConvert_StringToNumber(zfCalc_Word_Split (inValue:= Name, inSep:= '-', inIndex:=2))::Integer
                                       , zfConvert_StringToNumber(zfCalc_Word_Split (inValue:= Name, inSep:= '-', inIndex:=3))::Integer
                                     , zfConvert_StringToNumber(zfCalc_Word_Split (inValue:= Name, inSep:= '-', inIndex:=4) )::Integer
 FROM gpSelect_Object_PartionCell_list (FALSE, zfCalc_UserAdmin())*/
