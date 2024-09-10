-- Function: gpReport_PartionCell_ChoiceCellPrint ()

DROP FUNCTION IF EXISTS gpReport_PartionCell_ChoiceCellPrint (TDateTime, TDateTime, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PartionCell_ChoiceCellPrint (
    IN inStartDate         TDateTime ,
    IN inEndDate           TDateTime ,
    IN inUnitId            Integer   ,
    IN inIsMovement        Boolean   ,
    IN inIsCell            Boolean   ,
    IN inIsShowAll         Boolean   ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (FromName TVarChar
             , ToName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar, MeasureName TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , PartionGoodsDate TDateTime

             , PartionCellName   TVarChar

             , Amount TFloat, Amount_Weight TFloat

             , NPP_ChoiceCell      Integer
             , ChoiceCellCode      Integer
             , ChoiceCellName      TVarChar
             , ChoiceCellName_shot TVarChar
              )
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE curPartionCell refcursor;
 DECLARE vbPartionCellId Integer;
 DECLARE vbIsWeighing Boolean;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);


-- выводим товар + вид + партию, в какое место отбора, какие ячейки в местах хранения  (в одной колонке)+ пустая колонка "примечание" - данные для отчета - SELECT ..... FROM gpReport_Send_PartionCell  WHERE isChoiceCell_mi = TRUE

   -- Результат
     RETURN QUERY  
   --
   SELECT tmpResult.FromName
        , tmpResult.ToName

        , tmpResult.GoodsId , tmpResult.GoodsCode , tmpResult.GoodsName
        , tmpResult.GoodsGroupNameFull, tmpResult.GoodsGroupName, tmpResult.MeasureName
        , tmpResult.GoodsKindId , tmpResult.GoodsKindName
        , tmpResult.PartionGoodsDate
          --
                               
         --chr(13)
         
        , CASE WHEN COALESCE (tmpResult.PartionCellName_1,'') <> '' THEN tmpResult.PartionCellName_1 ELSE '' END 
          CASE WHEN COALESCE (tmpResult.PartionCellName_2,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END  
          CASE WHEN COALESCE (tmpResult.PartionCellName_3,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_4,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_5,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_6,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_7,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_8,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_9,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_10,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_11,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_12,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_13,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_14,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_15,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_16,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_17,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_18,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_19,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_20,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_21,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_22,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END
          CASE WHEN COALESCE (tmpResult.PartionCellName_ets,'') <> '' THEN ||chr(13)||tmpResult.PartionCellName_2ELSE '' END ::TVarChar AS PartionCellName

        , tmpResult.Amount, tmpResult.Amount_Weight

        --ячейки отбора
        , tmpResult.NPP_ChoiceCell     
        , tmpResult.ChoiceCellCode
        , tmpResult.ChoiceCellName     
        , tmpResult.ChoiceCellName_shot

   FROM gpReport_Send_PartionCell (inStartDate, inEndDate, inUnitId, inIsMovement, inIsCell, inIsShowAll, inSession) AS tmpResult
   WHERE tmpResult.isChoiceCell_mi = TRUE
  ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.09.24         *
*/

-- тест
-- 
 select * from gpReport_PartionCell_ChoiceCellPrint(inStartDate := ('25.08.2024')::TDateTime , inEndDate := ('26.08.2024')::TDateTime , inUnitId := 8459 , inIsMovement := 'False' , inIsCell := 'false' , inIsShowAll := 'False' ,  inSession := '9457') --where GoodsCode = 41;
