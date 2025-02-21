-- Function: gpSelect_ScaleCeh_PartionCell()

DROP FUNCTION IF EXISTS gpSelect_ScaleCeh_PartionCell (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ScaleCeh_PartionCell(
    IN inSession          TVarChar      -- сессия пользователя
)
RETURNS TABLE (PartionCellId   Integer
             , PartionCellCode Integer
             , PartionCellName TVarChar
             , Level_cell Integer
             , BoxCount Integer
             , InvNumber TVarChar
             , Name_search TVarChar
             , isErased  Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       SELECT Object_PartionCell.Id                                 AS PartionCellId
            , Object_PartionCell.ObjectCode                         AS PartionCellCode
            , Object_PartionCell.ValueData                          AS PartionCellName
            , ObjectFloat_PartionCell_Level.ValueData    :: Integer AS Level_cell
            , ObjectFloat_PartionCell_BoxCount.ValueData :: Integer AS BoxCount
            , zfCalc_PartionCellName (Object_PartionCell.ValueData, ObjectFloat_PartionCell_BoxCount.ValueData, ObjectFloat_PartionCell_Level.ValueData) AS InvNumber
            , (Object_PartionCell.ValueData ||';'||REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (Object_PartionCell.ValueData, '.', ''), '-', ''), ' ', ''), '=', ''), ',', '')) :: TVarChar AS Name_search
            , Object_PartionCell.isErased                           AS isErased

       FROM Object AS Object_PartionCell
            LEFT JOIN ObjectFloat AS ObjectFloat_PartionCell_Level
                                  ON ObjectFloat_PartionCell_Level.ObjectId = Object_PartionCell.Id
                                 AND ObjectFloat_PartionCell_Level.DescId   = zc_ObjectFloat_PartionCell_Level()
            LEFT JOIN ObjectFloat AS ObjectFloat_PartionCell_BoxCount
                                  ON ObjectFloat_PartionCell_BoxCount.ObjectId = Object_PartionCell.Id
                                 AND ObjectFloat_PartionCell_BoxCount.DescId   = zc_ObjectFloat_PartionCell_BoxCount()
       WHERE Object_PartionCell.DescId = zc_Object_PartionCell()
         AND Object_PartionCell.isErased = FALSE
       ORDER BY 3
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.06.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ScaleCeh_PartionCell (inSession:=zfCalc_UserAdmin())
