-- Function: gpReport_PartionCell_ChoiceCellPrint ()

DROP FUNCTION IF EXISTS gpReport_PartionCell_ChoiceCellPrint (TDateTime, TDateTime, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PartionCell_ChoiceCellPrint (
    IN inStartDate         TDateTime ,
    IN inEndDate           TDateTime ,
    IN inUnitId            Integer   ,
    IN inIsMovement        Boolean   ,
    IN inIsCell            Boolean   ,
    IN inIsShowAll         Boolean   ,
    IN inSession           TVarChar    -- ������ ������������
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


-- ������� ����� + ��� + ������, � ����� ����� ������, ����� ������ � ������ ��������  (� ����� �������)+ ������ ������� "����������" - ������ ��� ������ - SELECT ..... FROM gpReport_Send_PartionCell  WHERE isChoiceCell_mi = TRUE

   -- ���������
     RETURN QUERY
   --
   SELECT tmpResult.FromName
        , tmpResult.ToName

        , tmpResult.GoodsId , tmpResult.GoodsCode , tmpResult.GoodsName
        , tmpResult.GoodsGroupNameFull, tmpResult.GoodsGroupName, tmpResult.MeasureName
        , tmpResult.GoodsKindId , tmpResult.GoodsKindName
        , tmpResult.PartionGoodsDate
          --

        , (CASE WHEN COALESCE (tmpResult.PartionCellName_1,'') <> ''  AND COALESCE (tmpResult.PartionCellName_1,'')  NOT ILIKE '������' AND tmpResult.PartionCellName_1  NOT ILIKE '%�����%' THEN tmpResult.PartionCellName_1 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_2,'') <> ''  AND COALESCE (tmpResult.PartionCellName_2,'')  NOT ILIKE '������' AND tmpResult.PartionCellName_2  NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_2 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_3,'') <> ''  AND COALESCE (tmpResult.PartionCellName_3,'')  NOT ILIKE '������' AND tmpResult.PartionCellName_3  NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_3 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_4,'') <> ''  AND COALESCE (tmpResult.PartionCellName_4,'')  NOT ILIKE '������' AND tmpResult.PartionCellName_4  NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_4 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_5,'') <> ''  AND COALESCE (tmpResult.PartionCellName_5,'')  NOT ILIKE '������' AND tmpResult.PartionCellName_5  NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_5 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_6,'') <> ''  AND COALESCE (tmpResult.PartionCellName_6,'')  NOT ILIKE '������' AND tmpResult.PartionCellName_6  NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_6 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_7,'') <> ''  AND COALESCE (tmpResult.PartionCellName_7,'')  NOT ILIKE '������' AND tmpResult.PartionCellName_7  NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_7 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_8,'') <> ''  AND COALESCE (tmpResult.PartionCellName_8,'')  NOT ILIKE '������' AND tmpResult.PartionCellName_8  NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_8 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_9,'') <> ''  AND COALESCE (tmpResult.PartionCellName_9,'')  NOT ILIKE '������' AND tmpResult.PartionCellName_9  NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_9 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_10,'') <> '' AND COALESCE (tmpResult.PartionCellName_10,'') NOT ILIKE '������' AND tmpResult.PartionCellName_10 NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_10 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_11,'') <> '' AND COALESCE (tmpResult.PartionCellName_11,'') NOT ILIKE '������' AND tmpResult.PartionCellName_11 NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_11 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_12,'') <> '' AND COALESCE (tmpResult.PartionCellName_12,'') NOT ILIKE '������' AND tmpResult.PartionCellName_12 NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_12 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_13,'') <> '' AND COALESCE (tmpResult.PartionCellName_13,'') NOT ILIKE '������' AND tmpResult.PartionCellName_13 NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_13 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_14,'') <> '' AND COALESCE (tmpResult.PartionCellName_14,'') NOT ILIKE '������' AND tmpResult.PartionCellName_14 NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_14 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_15,'') <> '' AND COALESCE (tmpResult.PartionCellName_15,'') NOT ILIKE '������' AND tmpResult.PartionCellName_15 NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_15 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_16,'') <> '' AND COALESCE (tmpResult.PartionCellName_16,'') NOT ILIKE '������' AND tmpResult.PartionCellName_16 NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_16 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_17,'') <> '' AND COALESCE (tmpResult.PartionCellName_17,'') NOT ILIKE '������' AND tmpResult.PartionCellName_17 NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_17 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_18,'') <> '' AND COALESCE (tmpResult.PartionCellName_18,'') NOT ILIKE '������' AND tmpResult.PartionCellName_18 NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_18 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_19,'') <> '' AND COALESCE (tmpResult.PartionCellName_19,'') NOT ILIKE '������' AND tmpResult.PartionCellName_19 NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_19 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_20,'') <> '' AND COALESCE (tmpResult.PartionCellName_20,'') NOT ILIKE '������' AND tmpResult.PartionCellName_20 NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_20 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_21,'') <> '' AND COALESCE (tmpResult.PartionCellName_21,'') NOT ILIKE '������' AND tmpResult.PartionCellName_21 NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_21 ELSE '' END
         ||CASE WHEN COALESCE (tmpResult.PartionCellName_22,'') <> '' AND COALESCE (tmpResult.PartionCellName_22,'') NOT ILIKE '������' AND tmpResult.PartionCellName_22 NOT ILIKE '%�����%' THEN chr(13)||tmpResult.PartionCellName_22 ELSE '' END
          ) ::Text AS PartionCellName

        , tmpResult.Amount, tmpResult.Amount_Weight

        --������ ������
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.09.24         *
*/

-- ����
--
-- SELECT * FROM gpReport_PartionCell_ChoiceCellPrint(inStartDate := ('25.08.2024')::TDateTime , inEndDate := ('26.08.2024')::TDateTime , inUnitId := 8459 , inIsMovement := 'False' , inIsCell := 'false' , inIsShowAll := 'False' ,  inSession := '9457') --where GoodsCode = 41;
