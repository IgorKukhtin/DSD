-- Function: gpSelect_Object_PartionCell()

DROP FUNCTION IF EXISTS gpSelect_Object_PartionCell (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartionCell(
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (GroupName TVarChar
             , Id_l1 Integer
             , Id_l2 Integer
             , Id_l3 Integer
             , Id_l4 Integer
             , Id_l5 Integer
             , Id_l6 Integer
                           
             , Code_l1 Integer
             , Code_l2 Integer
             , Code_l3 Integer
             , Code_l4 Integer
             , Code_l5 Integer
             , Code_l6 Integer            
             
             , Name_l1 TVarChar 
             , Name_l2 TVarChar 
             , Name_l3 TVarChar 
             , Name_l4 TVarChar 
             , Name_l5 TVarChar 
             , Name_l6 TVarChar 
             , Length_l1 TFloat 
             , Length_l2 TFloat 
             , Length_l3 TFloat 
             , Length_l4 TFloat 
             , Length_l5 TFloat 
             , Length_l6 TFloat 
             , Width_l1 TFloat 
             , Width_l2 TFloat 
             , Width_l3 TFloat 
             , Width_l4 TFloat 
             , Width_l5 TFloat 
             , Width_l6 TFloat 
             , Height_l1 TFloat
             , Height_l2 TFloat 
             , Height_l3 TFloat 
             , Height_l4 TFloat 
             , Height_l5 TFloat 
             , Height_l6 TFloat 
             , BoxCount_l1 TFloat 
             , BoxCount_l2 TFloat 
             , BoxCount_l3 TFloat 
             , BoxCount_l4 TFloat 
             , BoxCount_l5 TFloat 
             , BoxCount_l6 TFloat 
             , RowBoxCount_l1 TFloat 
             , RowBoxCount_l2 TFloat 
             , RowBoxCount_l3 TFloat 
             , RowBoxCount_l4 TFloat 
             , RowBoxCount_l5 TFloat 
             , RowBoxCount_l6 TFloat 
             , RowWidth_l1 TFloat 
             , RowWidth_l2 TFloat 
             , RowWidth_l3 TFloat 
             , RowWidth_l4 TFloat 
             , RowWidth_l5 TFloat 
             , RowWidth_l6 TFloat
             , RowHeight_l1 TFloat
             , RowHeight_l2 TFloat
             , RowHeight_l3 TFloat
             , RowHeight_l4 TFloat
             , RowHeight_l5 TFloat
             , RowHeight_l6 TFloat
             , Comment_l1 TVarChar
             , Comment_l2 TVarChar
             , Comment_l3 TVarChar
             , Comment_l4 TVarChar
             , Comment_l5 TVarChar
             , Comment_l6 TVarChar
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PartionCell());

      RETURN QUERY
      WITH
      tmpPartionCell AS (SELECT spSelect.* 
                         FROM gpSelect_Object_PartionCell_list (FALSE, inSession) AS spSelect
                         WHERE spSelect.Id > 0
                         )
 
       SELECT RIGHT (Object.Name,5) :: TVarChar AS GroupName
           , MAX (CASE WHEN Object.Level = 1 THEN Object.Id ELSE 0 END) AS Id_l1
           , MAX (CASE WHEN Object.Level = 2 THEN Object.Id ELSE 0 END) AS Id_l2
           , MAX (CASE WHEN Object.Level = 3 THEN Object.Id ELSE 0 END) AS Id_l3
           , MAX (CASE WHEN Object.Level = 4 THEN Object.Id ELSE 0 END) AS Id_l4
           , MAX (CASE WHEN Object.Level = 5 THEN Object.Id ELSE 0 END) AS Id_l5
           , MAX (CASE WHEN Object.Level = 6 THEN Object.Id ELSE 0 END) AS Id_l6
           
           , MAX (CASE WHEN Object.Level = 1 THEN Object.Code ELSE 0 END) AS Code_l1
           , MAX (CASE WHEN Object.Level = 2 THEN Object.Code ELSE 0 END) AS Code_l2
           , MAX (CASE WHEN Object.Level = 3 THEN Object.Code ELSE 0 END) AS Code_l3
           , MAX (CASE WHEN Object.Level = 4 THEN Object.Code ELSE 0 END) AS Code_l4
           , MAX (CASE WHEN Object.Level = 5 THEN Object.Code ELSE 0 END) AS Code_l5
           , MAX (CASE WHEN Object.Level = 6 THEN Object.Code ELSE 0 END) AS Code_l6

           , MAX (CASE WHEN Object.Level = 1 THEN Object.Name ELSE '' END)::TVarChar AS Name_l1
           , MAX (CASE WHEN Object.Level = 2 THEN Object.Name ELSE '' END)::TVarChar AS Name_l2
           , MAX (CASE WHEN Object.Level = 3 THEN Object.Name ELSE '' END)::TVarChar AS Name_l3
           , MAX (CASE WHEN Object.Level = 4 THEN Object.Name ELSE '' END)::TVarChar AS Name_l4
           , MAX (CASE WHEN Object.Level = 5 THEN Object.Name ELSE '' END)::TVarChar AS Name_l5
           , MAX (CASE WHEN Object.Level = 6 THEN Object.Name ELSE '' END)::TVarChar AS Name_l6
           
           , MAX (CASE WHEN Object.Level = 1 THEN Object.Length ELSE 0 END)::TFloat AS Length_l1
           , MAX (CASE WHEN Object.Level = 2 THEN Object.Length ELSE 0 END)::TFloat AS Length_l2
           , MAX (CASE WHEN Object.Level = 3 THEN Object.Length ELSE 0 END)::TFloat AS Length_l3
           , MAX (CASE WHEN Object.Level = 4 THEN Object.Length ELSE 0 END)::TFloat AS Length_l4
           , MAX (CASE WHEN Object.Level = 5 THEN Object.Length ELSE 0 END)::TFloat AS Length_l5
           , MAX (CASE WHEN Object.Level = 6 THEN Object.Length ELSE 0 END)::TFloat AS Length_l6
           
           , MAX (CASE WHEN Object.Level = 1 THEN Object.Width ELSE 0 END)::TFloat AS Width_l1
           , MAX (CASE WHEN Object.Level = 2 THEN Object.Width ELSE 0 END)::TFloat AS Width_l2
           , MAX (CASE WHEN Object.Level = 3 THEN Object.Width ELSE 0 END)::TFloat AS Width_l3
           , MAX (CASE WHEN Object.Level = 4 THEN Object.Width ELSE 0 END)::TFloat AS Width_l4
           , MAX (CASE WHEN Object.Level = 5 THEN Object.Width ELSE 0 END)::TFloat AS Width_l5
           , MAX (CASE WHEN Object.Level = 6 THEN Object.Width ELSE 0 END)::TFloat AS Width_l6
           
           , MAX (CASE WHEN Object.Level = 1 THEN Object.Height ELSE 0 END)::TFloat AS Height_l1
           , MAX (CASE WHEN Object.Level = 2 THEN Object.Height ELSE 0 END)::TFloat AS Height_l2
           , MAX (CASE WHEN Object.Level = 3 THEN Object.Height ELSE 0 END)::TFloat AS Height_l3
           , MAX (CASE WHEN Object.Level = 4 THEN Object.Height ELSE 0 END)::TFloat AS Height_l4
           , MAX (CASE WHEN Object.Level = 5 THEN Object.Height ELSE 0 END)::TFloat AS Height_l5
           , MAX (CASE WHEN Object.Level = 6 THEN Object.Height ELSE 0 END)::TFloat AS Height_l6
           
           , MAX (CASE WHEN Object.Level = 1 THEN Object.BoxCount ELSE 0 END)::TFloat AS BoxCount_l1
           , MAX (CASE WHEN Object.Level = 2 THEN Object.BoxCount ELSE 0 END)::TFloat AS BoxCount_l2
           , MAX (CASE WHEN Object.Level = 3 THEN Object.BoxCount ELSE 0 END)::TFloat AS BoxCount_l3
           , MAX (CASE WHEN Object.Level = 4 THEN Object.BoxCount ELSE 0 END)::TFloat AS BoxCount_l4
           , MAX (CASE WHEN Object.Level = 5 THEN Object.BoxCount ELSE 0 END)::TFloat AS BoxCount_l5
           , MAX (CASE WHEN Object.Level = 6 THEN Object.BoxCount ELSE 0 END)::TFloat AS BoxCount_l6
           
           , MAX (CASE WHEN Object.Level = 1 THEN Object.RowBoxCount ELSE 0 END)::TFloat AS RowBoxCount_l1
           , MAX (CASE WHEN Object.Level = 2 THEN Object.RowBoxCount ELSE 0 END)::TFloat AS RowBoxCount_l2
           , MAX (CASE WHEN Object.Level = 3 THEN Object.RowBoxCount ELSE 0 END)::TFloat AS RowBoxCount_l3
           , MAX (CASE WHEN Object.Level = 4 THEN Object.RowBoxCount ELSE 0 END)::TFloat AS RowBoxCount_l4
           , MAX (CASE WHEN Object.Level = 5 THEN Object.RowBoxCount ELSE 0 END)::TFloat AS RowBoxCount_l5
           , MAX (CASE WHEN Object.Level = 6 THEN Object.RowBoxCount ELSE 0 END)::TFloat AS RowBoxCount_l6
           
           , MAX (CASE WHEN Object.Level = 1 THEN Object.RowWidth ELSE 0 END)::TFloat AS RowWidth_l1
           , MAX (CASE WHEN Object.Level = 2 THEN Object.RowWidth ELSE 0 END)::TFloat AS RowWidth_l2
           , MAX (CASE WHEN Object.Level = 3 THEN Object.RowWidth ELSE 0 END)::TFloat AS RowWidth_l3
           , MAX (CASE WHEN Object.Level = 4 THEN Object.RowWidth ELSE 0 END)::TFloat AS RowWidth_l4
           , MAX (CASE WHEN Object.Level = 5 THEN Object.RowWidth ELSE 0 END)::TFloat AS RowWidth_l5
           , MAX (CASE WHEN Object.Level = 6 THEN Object.RowWidth ELSE 0 END)::TFloat AS RowWidth_l6
           
           , MAX (CASE WHEN Object.Level = 1 THEN Object.RowHeight ELSE 0 END)::TFloat AS RowHeight_l1
           , MAX (CASE WHEN Object.Level = 2 THEN Object.RowHeight ELSE 0 END)::TFloat AS RowHeight_l2
           , MAX (CASE WHEN Object.Level = 3 THEN Object.RowHeight ELSE 0 END)::TFloat AS RowHeight_l3
           , MAX (CASE WHEN Object.Level = 4 THEN Object.RowHeight ELSE 0 END)::TFloat AS RowHeight_l4
           , MAX (CASE WHEN Object.Level = 5 THEN Object.RowHeight ELSE 0 END)::TFloat AS RowHeight_l5
           , MAX (CASE WHEN Object.Level = 6 THEN Object.RowHeight ELSE 0 END)::TFloat AS RowHeight_l6
               
           , MAX (CASE WHEN Object.Level = 1 THEN Object.Comment ELSE '' END)::TVarChar AS Comment_l1
           , MAX (CASE WHEN Object.Level = 2 THEN Object.Comment ELSE '' END)::TVarChar AS Comment_l2
           , MAX (CASE WHEN Object.Level = 3 THEN Object.Comment ELSE '' END)::TVarChar AS Comment_l3
           , MAX (CASE WHEN Object.Level = 4 THEN Object.Comment ELSE '' END)::TVarChar AS Comment_l4
           , MAX (CASE WHEN Object.Level = 5 THEN Object.Comment ELSE '' END)::TVarChar AS Comment_l5
           , MAX (CASE WHEN Object.Level = 6 THEN Object.Comment ELSE '' END)::TVarChar AS Comment_l6

       FROM tmpPartionCell AS Object
       WHERE  Object.Level <> 0 
       GROUP BY RIGHT (Object.Name,5)
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
--SELECT * FROM gpSelect_Object_PartionCell (zfCalc_UserAdmin())