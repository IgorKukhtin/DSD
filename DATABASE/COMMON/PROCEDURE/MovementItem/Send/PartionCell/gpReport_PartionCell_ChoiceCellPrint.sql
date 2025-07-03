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

         , (
           CASE WHEN vbUserId = 5 AND 1=0 AND tmpResult.GoodsCode = 770 THEN 'N-7-4-1' || chr(13) ELSE '' END :: Text
         ||CASE WHEN vbUserId = 5 AND 1=0 AND tmpResult.GoodsCode = 166 THEN 'M-7-4-1' || chr(13) ELSE '' END :: Text

         ||CASE WHEN vbUserId = 5 AND 1=0 AND tmpResult.GoodsCode = 770 THEN '<font color=yelow><sub><b>' ELSE '' END :: Text --  ***
         ||CASE WHEN vbUserId = 5 AND 1=0 AND tmpResult.GoodsCode = 166 THEN '<font color=yelow><sup><b>' ELSE '' END :: Text --  ---

         ||CASE WHEN COALESCE (tmpResult.PartionCellName_1,'') <> '' AND tmpResult.PartionCellName_1  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_1  NOT ILIKE '%Отбор%'

                     THEN CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_1 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_1 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_1
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_1 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_1 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_2,'') <> '' AND tmpResult.PartionCellName_2  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_2  NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_2 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_2 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_2
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_2 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_2 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_3,'') <> '' AND tmpResult.PartionCellName_3  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_3  NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_3 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_3 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_3
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_3 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_3 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_4,'') <> '' AND tmpResult.PartionCellName_4  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_4  NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_4 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_4 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_4
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_4 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_4 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_5,'') <> '' AND tmpResult.PartionCellName_5  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_5  NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_5 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_5 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_5
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_5 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_5 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_6,'') <> '' AND tmpResult.PartionCellName_6  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_6  NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_6 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_6 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_6
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_6 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_6 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_7,'') <> '' AND tmpResult.PartionCellName_7  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_7  NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_7 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_7 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_7
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_7 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_7 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_8,'') <> '' AND tmpResult.PartionCellName_8  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_8  NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_8 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_8 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_8
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_8 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_8 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_9,'') <> '' AND tmpResult.PartionCellName_9  NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_9  NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_9 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_9 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_9
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_9 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_9 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_10,'') <> '' AND tmpResult.PartionCellName_10 NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_10 NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_10 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_10 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_10
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_10 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_10 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_11,'') <> '' AND tmpResult.PartionCellName_11 NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_11 NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_11 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_11 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_11
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_11 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_11 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_12,'') <> '' AND tmpResult.PartionCellName_12 NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_12 NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_12 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_12 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_12
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_12 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_12 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_13,'') <> '' AND tmpResult.PartionCellName_13 NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_13 NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_13 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_13 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_13
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_13 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_13 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_14,'') <> '' AND tmpResult.PartionCellName_14 NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_14 NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_14 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_14 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_14
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_14 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_14 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_15,'') <> '' AND tmpResult.PartionCellName_15 NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_15 NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_15 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_15 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_15
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_15 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_15 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_16,'') <> '' AND tmpResult.PartionCellName_16 NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_16 NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_16 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_16 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_16
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_16 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_16 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_17,'') <> '' AND tmpResult.PartionCellName_17 NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_17 NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_17 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_17 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_17
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_17 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_17 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_18,'') <> '' AND tmpResult.PartionCellName_18 NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_18 NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_18 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_18 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_18
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_18 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_18 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_19,'') <> '' AND tmpResult.PartionCellName_19 NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_19 NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_19 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_19 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_19
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_19 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_19 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_20,'') <> '' AND tmpResult.PartionCellName_20 NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_20 NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_20 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_20 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_20
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_20 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_20 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_21,'') <> '' AND tmpResult.PartionCellName_21 NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_21 NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_21 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_21 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_21
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_21 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_21 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_22,'') <> '' AND tmpResult.PartionCellName_22 NOT ILIKE 'ошибка' AND tmpResult.PartionCellName_22 NOT ILIKE '%Отбор%'
                     THEN chr(13)
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_22 = TRUE THEN '<font color=yelow><b>'
                               WHEN isPartionCell_Many_22 = TRUE THEN '<b>'
                               ELSE ''
                          END
                       || tmpResult.PartionCellName_22
                       || CASE WHEN tmpResult.PartionCellId_isMany_no > 0 AND isPartionCell_Many_22 = TRUE THEN '</font></b>'
                               WHEN isPartionCell_Many_22 = TRUE THEN '</b>'
                               ELSE ''
                          END
                ELSE ''
           END

         ||CASE WHEN vbUserId = 5 AND 1=0 AND tmpResult.GoodsCode = 770 THEN '</font></sub></b>' ELSE '' END :: Text
         ||CASE WHEN vbUserId = 5 AND 1=0 AND tmpResult.GoodsCode = 166 THEN '</font></sup></b>' ELSE '' END :: Text

         ||CASE WHEN vbUserId = 5 AND 1=0 AND tmpResult.GoodsCode = 770 THEN chr(13) || 'N-7-4-2' ELSE '' END :: Text
         ||CASE WHEN vbUserId = 5 AND 1=0 AND tmpResult.GoodsCode = 166 THEN chr(13) || 'M-7-4-2' ELSE '' END :: Text
/*
<b>	bold text
<i>	italic text
<u>	underlined text
<sub>	subscript
<sup>	superscript
<font color>	font color
<nowrap>	text which is not split when WordWrap is enabled, the whole text is shifted to the next line
*/
	          ) ::Text AS PartionCellName

        , tmpResult.Amount, tmpResult.Amount_Weight

        --ячейки отбора
        , tmpResult.NPP_ChoiceCell
        , tmpResult.ChoiceCellCode
        , tmpResult.ChoiceCellName
        , tmpResult.ChoiceCellName_shot
        , tmpResult.InsertDate_ChoiceCell_mi

   FROM gpReport_Send_PartionCell (inStartDate, inEndDate, inUnitId, inIsMovement, inIsCell, inIsShowAll, inSession) AS tmpresult
   WHERE tmpResult.isChoiceCell_mi = TRUE OR vbUserId = 5
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
