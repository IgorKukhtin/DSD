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

             , PartionCellName   Text

             , Amount TFloat, Amount_Weight TFloat

             , NPP_ChoiceCell      Integer
             , ChoiceCellCode      Integer
             , ChoiceCellName      TVarChar
             , ChoiceCellName_shot TVarChar
             , InsertDate_ChoiceCell_mi TDateTime
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

        , (CASE WHEN COALESCE (tmpResult.PartionCellName_1,'') <> ''  AND COALESCE (tmpResult.PartionCellName_1,'')  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_1  NOT ILIKE '%Отбор%' THEN tmpResult.PartionCellName_1 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_2,'') <> ''  AND COALESCE (tmpResult.PartionCellName_2,'')  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_2  NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_2 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_3,'') <> ''  AND COALESCE (tmpResult.PartionCellName_3,'')  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_3  NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_3 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_4,'') <> ''  AND COALESCE (tmpResult.PartionCellName_4,'')  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_4  NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_4 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_5,'') <> ''  AND COALESCE (tmpResult.PartionCellName_5,'')  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_5  NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_5 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_6,'') <> ''  AND COALESCE (tmpResult.PartionCellName_6,'')  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_6  NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_6 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_7,'') <> ''  AND COALESCE (tmpResult.PartionCellName_7,'')  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_7  NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_7 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_8,'') <> ''  AND COALESCE (tmpResult.PartionCellName_8,'')  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_8  NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_8 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_9,'') <> ''  AND COALESCE (tmpResult.PartionCellName_9,'')  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_9  NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_9 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_10,'') <> '' AND COALESCE (tmpResult.PartionCellName_10,'') NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_10 NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_10 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_11,'') <> '' AND COALESCE (tmpResult.PartionCellName_11,'') NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_11 NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_11 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_12,'') <> '' AND COALESCE (tmpResult.PartionCellName_12,'') NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_12 NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_12 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_13,'') <> '' AND COALESCE (tmpResult.PartionCellName_13,'') NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_13 NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_13 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_14,'') <> '' AND COALESCE (tmpResult.PartionCellName_14,'') NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_14 NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_14 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_15,'') <> '' AND COALESCE (tmpResult.PartionCellName_15,'') NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_15 NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_15 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_16,'') <> '' AND COALESCE (tmpResult.PartionCellName_16,'') NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_16 NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_16 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_17,'') <> '' AND COALESCE (tmpResult.PartionCellName_17,'') NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_17 NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_17 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_18,'') <> '' AND COALESCE (tmpResult.PartionCellName_18,'') NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_18 NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_18 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_19,'') <> '' AND COALESCE (tmpResult.PartionCellName_19,'') NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_19 NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_19 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_20,'') <> '' AND COALESCE (tmpResult.PartionCellName_20,'') NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_20 NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_20 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_21,'') <> '' AND COALESCE (tmpResult.PartionCellName_21,'') NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_21 NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_21 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_22,'') <> '' AND COALESCE (tmpResult.PartionCellName_22,'') NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_22 NOT ILIKE '%Отбор%' THEN chr(13)||tmpResult.PartionCellName_22 ELSE '' END
          ) ::Text AS PartionCellName

        , tmpResult.Amount, tmpResult.Amount_Weight

        --ячейки отбора
        , tmpResult.NPP_ChoiceCell
        , tmpResult.ChoiceCellCode
        , tmpResult.ChoiceCellName
        , tmpResult.ChoiceCellName_shot
        , tmpResult.InsertDate_ChoiceCell_mi

   FROM gpReport_Send_PartionCell (inStartDate, inEndDate, inUnitId, inIsMovement, inIsCell, inIsShowAll, inSession) AS tmpresult
   WHERE tmpResult.isChoiceCell_mi = TRUE
   ORDER BY tmpResult.ChoiceCellCode
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
-- SELECT * FROM gpReport_PartionCell_ChoiceCellPrint(inStartDate := ('25.08.2024')::TDateTime , inEndDate := ('26.08.2024')::TDateTime , inUnitId := 8459 , inIsMovement := 'False' , inIsCell := 'false' , inIsShowAll := 'False' ,  inSession := '9457') --where GoodsCode = 41;
