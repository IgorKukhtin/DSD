-- Function: gpReport_Send_PartionCell ()

--DROP FUNCTION IF EXISTS gpReport_Send_PartionCell (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Send_PartionCell (TDateTime, TDateTime, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Send_PartionCell (
    IN inStartDate         TDateTime ,
    IN inEndDate           TDateTime ,
    IN inUnitId            Integer   ,
    IN inIsMovement        Boolean   ,
    IN inIsShowAll         Boolean   ,
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime, OperDate_min TDateTime, OperDate_max TDateTime
             , InsertDate TDateTime, InsertName TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar

             , MovementItemId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , PartionGoodsDate TDateTime

             , PartionCellId_1  Integer
             , PartionCellId_2  Integer
             , PartionCellId_3  Integer
             , PartionCellId_4  Integer
             , PartionCellId_5  Integer
             , PartionCellId_6  Integer
             , PartionCellId_7  Integer
             , PartionCellId_8  Integer
             , PartionCellId_9  Integer
             , PartionCellId_10 Integer
             , PartionCellId_11  Integer
             , PartionCellId_12  Integer
             , PartionCellId_13  Integer
             , PartionCellId_14  Integer
             , PartionCellId_15  Integer
             , PartionCellId_16  Integer
             , PartionCellId_17  Integer
             , PartionCellId_18  Integer
             , PartionCellId_19  Integer
             , PartionCellId_20 Integer

             , PartionCellName_1   TVarChar
             , PartionCellName_2   TVarChar
             , PartionCellName_3   TVarChar
             , PartionCellName_4   TVarChar
             , PartionCellName_5   TVarChar
             , PartionCellName_6   TVarChar
             , PartionCellName_7   TVarChar
             , PartionCellName_8   TVarChar
             , PartionCellName_9   TVarChar
             , PartionCellName_10  TVarChar
             , PartionCellName_11   TVarChar
             , PartionCellName_12   TVarChar
             , PartionCellName_13   TVarChar
             , PartionCellName_14   TVarChar
             , PartionCellName_15   TVarChar
             , PartionCellName_16   TVarChar
             , PartionCellName_17   TVarChar
             , PartionCellName_18   TVarChar
             , PartionCellName_19   TVarChar
             , PartionCellName_20  TVarChar
             , PartionCellName_21  TVarChar

             , ColorFon_1  Integer
             , ColorFon_2  Integer
             , ColorFon_3  Integer
             , ColorFon_4  Integer
             , ColorFon_5  Integer
             , ColorFon_6  Integer
             , ColorFon_7  Integer
             , ColorFon_8  Integer
             , ColorFon_9  Integer
             , ColorFon_10 Integer
             , ColorFon_11  Integer
             , ColorFon_12  Integer
             , ColorFon_13  Integer
             , ColorFon_14  Integer
             , ColorFon_15  Integer
             , ColorFon_16  Integer
             , ColorFon_17  Integer
             , ColorFon_18  Integer
             , ColorFon_19  Integer
             , ColorFon_20 Integer

             , Color_1  Integer
             , Color_2  Integer
             , Color_3  Integer
             , Color_4  Integer
             , Color_5  Integer
             , Color_6  Integer
             , Color_7  Integer
             , Color_8  Integer
             , Color_9  Integer
             , Color_10 Integer
             , Color_11  Integer
             , Color_12  Integer
             , Color_13  Integer
             , Color_14  Integer
             , Color_15  Integer
             , Color_16  Integer
             , Color_17  Integer
             , Color_18  Integer
             , Color_19  Integer
             , Color_20 Integer

               -- ���� �� ���� ���� �������� ������
             , isClose_value_min Boolean
               -- ������������ ������ �� ������� (��/���)
             , isPartionCell Boolean

             , Amount TFloat, Amount_Weight TFloat

            , NormInDays      Integer
            , NormInDays_real Integer
            , NormInDays_tax  TFloat
            , NormInDays_date TDateTime

             , Color_PartionGoodsDate Integer
              )
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������!!!
     IF COALESCE (inUnitId,0) = 0
     THEN
         inUnitId := zc_Unit_RK();
     END IF;

   IF inIsShowAll = FALSE THEN
     -- ���������
     RETURN QUERY
     WITH
       -- ������ �� 2-� �����
       tmpGoods AS (SELECT lfSelect.GoodsId
                    FROM lfSelect_Object_Goods_byGoodsGroup (1832) AS lfSelect
                   UNION
                    SELECT lfSelect.GoodsId
                    FROM lfSelect_Object_Goods_byGoodsGroup (1979) AS lfSelect
                   )
    , tmpNormInDays AS (SELECT Object_GoodsByGoodsKind_View.GoodsId, Object_GoodsByGoodsKind_View.GoodsKindId, Object_GoodsByGoodsKind_View.NormInDays
                        FROM Object_GoodsByGoodsKind_View
                             JOIN tmpGoods ON tmpGoods.GoodsId = Object_GoodsByGoodsKind_View.GoodsId
                        WHERE Object_GoodsByGoodsKind_View.NormInDays > 0
                       )

    , tmpMovement AS (SELECT Movement.*
                           , MovementLinkObject_From.ObjectId AS FromId
                           , MovementLinkObject_To.ObjectId   AS ToId
                      FROM Movement
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()

                      WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                        AND Movement.DescId = zc_Movement_Send()
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                        AND MovementLinkObject_To.ObjectId = inUnitId
                      )

    , tmpMI AS (SELECT MovementItem.Id         AS MovementItemId
                     , MovementItem.MovementId AS MovementId
                     , MovementItem.ObjectId   AS GoodsId
                     , MovementItem.Amount     AS Amount
                FROM MovementItem
                     --���������� �������
                     INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                  AND MovementItem.DescId   = zc_MI_Master()
                  AND MovementItem.isErased = FALSE
               )
                       
     , tmpMILO_PC AS (SELECT MovementItemLinkObject.*
                      FROM MovementItemLinkObject
                      WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                        AND MovementItemLinkObject.DescId IN (zc_MILinkObject_PartionCell_1()
                                                            , zc_MILinkObject_PartionCell_2()
                                                            , zc_MILinkObject_PartionCell_3()
                                                            , zc_MILinkObject_PartionCell_4()
                                                            , zc_MILinkObject_PartionCell_5()
                                                             )
                        -- ������ ����������� ������
                        AND MovementItemLinkObject.ObjectId > 0
                     )

     , tmpMovementDate_Insert AS (SELECT MovementDate.*
                          FROM MovementDate
                          WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                            AND MovementDate.DescId = zc_MovementDate_Insert()
                          )
    , tmpMLO_Insert AS (SELECT MovementLinkObject.*
                 FROM MovementLinkObject
                 WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                   AND MovementLinkObject.DescId = zc_MovementLinkObject_Insert()
                 )

    , tmpMI_Boolean AS (SELECT MovementItemBoolean.*
                        FROM MovementItemBoolean
                        WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                          AND MovementItemBoolean.DescId IN (zc_MIBoolean_PartionCell_Close_1()
                                                           , zc_MIBoolean_PartionCell_Close_2()
                                                           , zc_MIBoolean_PartionCell_Close_3()
                                                           , zc_MIBoolean_PartionCell_Close_4()
                                                           , zc_MIBoolean_PartionCell_Close_5()
                                                            )
                       )

     , tmpMILO_PartionCell AS (SELECT MovementItemLinkObject.*
                                      -- ��������
                                    , CASE WHEN MIF_PartionCell_real.ValueData > 0 THEN MIF_PartionCell_real.ValueData ELSE NULL END :: Integer AS PartionCellId_real
                                      -- ���� ���� ���� ������ � ������ �� ������� - ��� �� �������
                                    , CASE WHEN tmpMI_Boolean.ValueData = TRUE THEN 0 ELSE 1 END AS isClose_value
                               FROM tmpMILO_PC AS MovementItemLinkObject
                                    LEFT JOIN tmpMI_Boolean ON tmpMI_Boolean.MovementItemId = MovementItemLinkObject.MovementItemId
                                                           AND tmpMI_Boolean.DescId         = CASE WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_1()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_1()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_2()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_2()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_3()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_3()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_4()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_4()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_5()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_5()
                                                                                              END
                                    LEFT JOIN MovementItemFloat AS MIF_PartionCell_real
                                                                ON MIF_PartionCell_real.MovementItemId = MovementItemLinkObject.MovementItemId
                                                               AND MIF_PartionCell_real.DescId         = CASE WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_1()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_1()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_2()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_2()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_3()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_3()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_4()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_4()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_5()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_5()
                                                                                                         END
                              )
     , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                               AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind())
                             )
     , tmpMI_Date AS (SELECT *
                      FROM MovementItemDate
                      WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                        AND MovementItemDate.DescId = zc_MIDate_PartionGoods()
                      )

       -- ������ ���-�� - ������
     , tmpData_MI AS (SELECT CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END                       AS MovementId        -- ***
                           , CASE WHEN inIsMovement = TRUE THEN Movement.InvNumber ELSE '' END               AS InvNumber
                           , CASE WHEN inIsMovement = TRUE THEN Movement.OperDate ELSE NULL END              AS OperDate
                           , MIN (Movement.OperDate)                                                         AS OperDate_min
                           , MAX (Movement.OperDate)                                                         AS OperDate_max
                           , CASE WHEN inIsMovement = TRUE THEN Movement.FromId ELSE 0 END                    AS FromId
                           , Movement.ToId                                                                   AS ToId              -- ***
                           , CASE WHEN inIsMovement = TRUE THEN MovementItem.MovementItemId ELSE 0 END       AS MovementItemId    -- ***
                           , MovementItem.GoodsId                                                            AS GoodsId           -- ***
                           , COALESCE (MILinkObject_GoodsKind.ObjectId,0)                                    AS GoodsKindId       -- ***
                           , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) :: TDateTime        AS PartionGoodsDate  -- ***
                           , SUM (MovementItem.Amount)                                                       AS Amount
                             -- ���� �������� ��� ��� - ��������� ����� ���������
                           , CASE WHEN tmpMILO_PartionCell.MovementItemId > 0 THEN TRUE ELSE FALSE END       AS isPartionCell
                             -- ���� ���� ������ ���������� �� ���� ��������� - �������� ��� ������ ������
                           , CASE WHEN Movement.OperDate <> COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate)
                                  THEN 8435455
                                  ELSE zc_Color_White()
                             END AS Color_PartionGoodsDate

                      FROM tmpMovement AS Movement
                           INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
                           -- ���� �������� ��� ��� - ��������� ����� ���������
                           LEFT JOIN (SELECT DISTINCT tmpMILO_PartionCell.MovementItemId FROM tmpMILO_PartionCell
                                     ) AS tmpMILO_PartionCell
                                       ON tmpMILO_PartionCell.MovementItemId = MovementItem.MovementItemId

                           LEFT JOIN tmpMI_Date AS MIDate_PartionGoods
                                                ON MIDate_PartionGoods.MovementItemId = MovementItem.MovementItemId
                                               AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()

                           LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.MovementItemId
                                                       AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
                      GROUP BY CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END
                             , CASE WHEN inIsMovement = TRUE THEN Movement.InvNumber ELSE '' END
                             , Movement.OperDate
                             , CASE WHEN inIsMovement = TRUE THEN Movement.FromId ELSE 0 END
                             , Movement.ToId
                             , CASE WHEN inIsMovement = TRUE THEN MovementItem.MovementItemId ELSE 0 END
                             , MovementItem.GoodsId
                             , COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                             , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate)
                             , CASE WHEN tmpMILO_PartionCell.MovementItemId > 0 THEN TRUE ELSE FALSE END
                     )

    -- ���������� �� ������� - �����������
  , tmpData_All_All AS (SELECT tmpData_list.MovementId        -- ***
                             , tmpData_list.ToId              -- ***
                             , tmpData_list.MovementItemId    -- ***
                             , tmpData_list.GoodsId           -- ***
                             , tmpData_list.GoodsKindId       -- ***
                             , tmpData_list.PartionGoodsDate  -- ***
                               -- ������������ �� �������
                             , tmpData_list.PartionCellId
                               -- ������������
                             , MAX (tmpData_list.PartionCellId_real) AS PartionCellId_real
                               -- ���� ���� ���� ������ � ������ �� ������� - ��� �� �������
                             , MAX (tmpData_list.isClose_value)                                        AS isClose_value_max
                               -- ���� ���� ���� �������� ������                                               
                             , MIN (tmpData_list.isClose_value)                                        AS isClose_value_min

                        FROM -- ������ ������ ������ �� ������� ������������
                             (SELECT DISTINCT
                                     CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END                       AS MovementId        -- ***
                                   , Movement.ToId                                                                   AS ToId              -- ***
                                   , CASE WHEN inIsMovement = TRUE THEN MovementItem.MovementItemId ELSE 0 END       AS MovementItemId    -- ***
                                   , MovementItem.GoodsId                                                            AS GoodsId           -- ***
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId,0)                                    AS GoodsKindId       -- ***
                                   , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) :: TDateTime        AS PartionGoodsDate  -- ***
                                     -- ������ ������ ������ �� ������� ������������
                                   , CASE WHEN inIsMovement = TRUE
                                          THEN MILinkObject_PartionCell.ObjectId
                                          ELSE COALESCE (MILinkObject_PartionCell.PartionCellId_real, MILinkObject_PartionCell.ObjectId)
                                     END AS PartionCellId
                                     -- ������������
                                   , CASE WHEN inIsMovement = TRUE
                                          THEN COALESCE (MILinkObject_PartionCell.PartionCellId_real, 0)
                                          ELSE NULL
                                     END AS PartionCellId_real

                                     -- ���� ���� ���� ������ � ������ �� ������� - ��� �� �������
                                   , MILinkObject_PartionCell.isClose_value
      
                              FROM tmpMovement AS Movement
                                   INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
      
                                   LEFT JOIN tmpMI_Date AS MIDate_PartionGoods
                                                        ON MIDate_PartionGoods.MovementItemId = MovementItem.MovementItemId
                                                       AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
      
                                   LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.MovementItemId
                                                              AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                   -- ������ ����������� ������
                                   INNER JOIN tmpMILO_PartionCell AS MILinkObject_PartionCell
                                                                  ON MILinkObject_PartionCell.MovementItemId = MovementItem.MovementItemId
     
                             ) AS tmpData_list

                        GROUP BY tmpData_list.MovementId        -- ***
                               , tmpData_list.ToId              -- ***
                               , tmpData_list.MovementItemId    -- ***
                               , tmpData_list.GoodsId           -- ***
                               , tmpData_list.GoodsKindId       -- ***
                               , tmpData_list.PartionGoodsDate  -- ***
                                 -- ������������ �� �������
                               , tmpData_list.PartionCellId
                       )
      -- ������ ����������� ������ - � �/�
    , tmpData_All AS (SELECT tmpData_All_All.MovementId        -- *** 
                           , tmpData_All_All.ToId              -- *** 
                           , tmpData_All_All.MovementItemId    -- *** 
                           , tmpData_All_All.GoodsId           -- *** 
                           , tmpData_All_All.GoodsKindId       -- *** 
                           , tmpData_All_All.PartionGoodsDate  -- *** 
                           , tmpData_All_All.PartionCellId
                           , tmpData_All_All.PartionCellId_real
                           , COALESCE (Object_PartionCell_real.ObjectCode :: TVarChar || ' ' || Object_PartionCell_real.ValueData, Object_PartionCell.ObjectCode :: TVarChar || ' ' || Object_PartionCell.ValueData) AS PartionCellName_calc
                             -- ���� ���� ���� ������ � ������ �� ������� - ��� �� �������
                           , tmpData_All_All.isClose_value_max
                             -- ���� ���� ���� �������� ������
                           , tmpData_All_All.isClose_value_min
                             --
                           , ROW_NUMBER() OVER (PARTITION BY tmpData_All_All.MovementId        -- *** 
                                                           , tmpData_All_All.ToId              -- *** 
                                                           , tmpData_All_All.MovementItemId    -- *** 
                                                           , tmpData_All_All.GoodsId           -- *** 
                                                           , tmpData_All_All.GoodsKindId       -- *** 
                                                           , tmpData_All_All.PartionGoodsDate  -- *** 
                                                ORDER BY COALESCE (ObjectFloat_Level.ValueData, 0)
                                                       , COALESCE (Object_PartionCell_real.ObjectCode, Object_PartionCell.ObjectCode, 0)
                                               ) AS Ord
                      FROM tmpData_All_All
                           LEFT JOIN Object AS Object_PartionCell      ON Object_PartionCell.Id      = tmpData_All_All.PartionCellId
                           LEFT JOIN Object AS Object_PartionCell_real ON Object_PartionCell_real.Id = tmpData_All_All.PartionCellId_real
                           LEFT JOIN ObjectFloat AS ObjectFloat_Level
                                                 ON ObjectFloat_Level.ObjectId = COALESCE (Object_PartionCell_real.Id, Object_PartionCell.Id)
                                                AND ObjectFloat_Level.DescId   = zc_ObjectFloat_PartionCell_Level()
                     )
      -- ���������� �� ������� - �������������
    , tmpData AS (SELECT tmpData_All.MovementId
                       , tmpData_All.ToId
                       , tmpData_All.MovementItemId
                       , tmpData_All.GoodsId
                       , tmpData_All.GoodsKindId
                       , tmpData_All.PartionGoodsDate

                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 1  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_1
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 2  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_2
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 3  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_3
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 4  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_4
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 5  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_5
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 6  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_6
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 7  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_7
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 8  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_8
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 9  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_9
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 10 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_10
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 11 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_11
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 12 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_12
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 13 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_13
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 14 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_14
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 15 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_15
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 16 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_16
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 17 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_17
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 18 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_18
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 19 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_19
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 20 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_20

                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 1  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_1
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 2  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_2
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 3  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_3
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 4  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_4
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 5  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_5
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 6  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_6
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 7  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_7
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 8  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_8
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 9  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_9
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 10 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_10
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 11 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_11
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 12 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_12
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 13 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_13
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 14 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_14
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 15 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_15
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 16 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_16
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 17 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_17
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 18 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_18
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 19 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_19
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 20 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_20

                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 1  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_1
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 2  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_2
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 3  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_3
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 4  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_4
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 5  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_5
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 6  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_6
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 7  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_7
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 8  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_8
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 9  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_9
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 10 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_10
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 11 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_11
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 12 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_12
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 13 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_13
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 14 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_14
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 15 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_15
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 16 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_16
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 17 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_17
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 18 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_18
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 19 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_19
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 20 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_20

                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 1  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_1
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 2  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_2
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 3  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_3
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 4  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_4
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 5  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_5
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 6  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_6
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 7  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_7
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 8  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_8
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 9  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_9
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 10 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_10
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 11 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_11
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 12 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_12
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 13 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_13
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 14 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_14
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 15 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_15
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 16 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_16
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 17 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_17
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 18 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_18
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 19 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_19
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 20 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_20

                         -- ���� ���� ���� �������� ������
                       , MIN (tmpData_All.isClose_value_min) AS isClose_value_min

                       , STRING_AGG (DISTINCT CASE WHEN COALESCE (tmpData_All.Ord, 0) > 20  THEN tmpData_All.PartionCellName_calc ELSE '' END, ';') AS PartionCellName_21

                  FROM tmpData_All

                  GROUP BY tmpData_All.MovementId
                         , tmpData_All.ToId
                         , tmpData_All.MovementItemId
                         , tmpData_All.GoodsId
                         , tmpData_All.GoodsKindId
                         , tmpData_All.PartionGoodsDate
                  )


       -- ���������
       SELECT tmpData_MI.MovementId
            , tmpData_MI.InvNumber    :: TVarChar
            , tmpData_MI.OperDate     :: TDateTime
            , tmpData_MI.OperDate_min :: TDateTime
            , tmpData_MI.OperDate_max :: TDateTime
            , MovementDate_Insert.ValueData AS InsertDate
            , Object_Insert.ValueData       AS InsertName
            , Object_From.Id                AS FromId
            , Object_From.ValueData         AS FromName
            , Object_To.Id                  AS ToId
            , Object_To.ValueData           AS ToName
            , tmpData_MI.MovementItemId
            , Object_Goods.Id                            AS GoodsId
            , Object_Goods.ObjectCode                    AS GoodsCode
            , Object_Goods.ValueData                     AS GoodsName
            , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
            , Object_Measure.ValueData                   AS MeasureName
            , Object_GoodsKind.Id                        AS GoodsKindId
            , Object_GoodsKind.ValueData                 AS GoodsKindName
            , tmpData_MI.PartionGoodsDate   :: TDateTime AS PartionGoodsDate
              --
            , tmpData.PartionCellId_1  :: Integer
            , tmpData.PartionCellId_2  :: Integer
            , tmpData.PartionCellId_3  :: Integer
            , tmpData.PartionCellId_4  :: Integer
            , tmpData.PartionCellId_5  :: Integer
            , tmpData.PartionCellId_6  :: Integer
            , tmpData.PartionCellId_7  :: Integer
            , tmpData.PartionCellId_8  :: Integer
            , tmpData.PartionCellId_9  :: Integer
            , tmpData.PartionCellId_10 :: Integer
            , tmpData.PartionCellId_11 :: Integer
            , tmpData.PartionCellId_12 :: Integer
            , tmpData.PartionCellId_13 :: Integer
            , tmpData.PartionCellId_14 :: Integer
            , tmpData.PartionCellId_15 :: Integer
            , tmpData.PartionCellId_16 :: Integer
            , tmpData.PartionCellId_17 :: Integer
            , tmpData.PartionCellId_18 :: Integer
            , tmpData.PartionCellId_19 :: Integer
            , tmpData.PartionCellId_20 :: Integer

            , tmpData.PartionCellName_1        :: TVarChar
            , tmpData.PartionCellName_2        :: TVarChar
            , tmpData.PartionCellName_3        :: TVarChar
            , tmpData.PartionCellName_4        :: TVarChar
            , tmpData.PartionCellName_5        :: TVarChar
            , tmpData.PartionCellName_6        :: TVarChar
            , tmpData.PartionCellName_7        :: TVarChar
            , tmpData.PartionCellName_8        :: TVarChar
            , tmpData.PartionCellName_9        :: TVarChar
            , tmpData.PartionCellName_10       :: TVarChar
            , tmpData.PartionCellName_11       :: TVarChar
            , tmpData.PartionCellName_12       :: TVarChar
            , tmpData.PartionCellName_13       :: TVarChar
            , tmpData.PartionCellName_14       :: TVarChar
            , tmpData.PartionCellName_15       :: TVarChar
            , tmpData.PartionCellName_16       :: TVarChar
            , tmpData.PartionCellName_17       :: TVarChar
            , tmpData.PartionCellName_18       :: TVarChar
            , tmpData.PartionCellName_19       :: TVarChar
            , tmpData.PartionCellName_20       :: TVarChar
            , tmpData.PartionCellName_21       :: TVarChar

            , CASE WHEN COALESCE (tmpData.ColorFon_1,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_1  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_2,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_2  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_3,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_3  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_4,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_4  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_5,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_5  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_6,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_6  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_7,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_7  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_8,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_8  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_9,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_9  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_10, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_10 END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_11, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_11  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_12, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_12  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_13, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_13  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_14, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_14  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_15, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_15  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_16, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_16  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_17, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_17  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_18, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_18  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_19, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_19  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_20, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_20 END :: Integer

            , CASE WHEN COALESCE (tmpData.Color_1,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_1  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_2,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_2  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_3,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_3  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_4,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_4  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_5,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_5  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_6,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_6  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_7,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_7  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_8,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_8  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_9,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_9  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_10, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_10 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_11, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_11 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_12, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_12 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_13, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_13 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_14, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_14 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_15, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_15 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_16, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_16 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_17, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_17 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_18, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_18 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_19, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_19 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_20, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_20 END :: Integer

              -- ���� ���� ���� �������� ������
            , CASE WHEN tmpData_MI.isPartionCell = TRUE AND tmpData.isClose_value_min = 0 THEN TRUE ELSE FALSE END :: Boolean AS isClose_value_min
              -- ������������ ������ �� ������� (��/���)
            , COALESCE (tmpData_MI.isPartionCell, FALSE) :: Boolean

            , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpData_MI.Amount ELSE 0 END ::TFloat AS Amount
            , (tmpData_MI.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS Amount_Weight

            , tmpNormInDays.NormInDays                   :: Integer AS NormInDays
            , CASE WHEN CURRENT_DATE < (tmpData_MI.PartionGoodsDate + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL)
                        THEN EXTRACT (DAY FROM (tmpData_MI.PartionGoodsDate + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL) - CURRENT_DATE)
                   ELSE 0
              END :: Integer AS NormInDays_real
            , CASE WHEN tmpNormInDays.NormInDays > 0 
                   THEN CAST (100 * CASE WHEN CURRENT_DATE < tmpData_MI.PartionGoodsDate + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL
                                              THEN EXTRACT (DAY FROM (tmpData_MI.PartionGoodsDate + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL) - CURRENT_DATE)
                                         ELSE 0
                                    END
                            / tmpNormInDays.NormInDays AS NUMERIC (16, 1))
                   ELSE 0
              END :: TFloat AS NormInDays_tax

            , (tmpData_MI.PartionGoodsDate + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL) :: TDateTime AS NormInDays_date

            , tmpData_MI.Color_PartionGoodsDate ::Integer
       
     FROM tmpData_MI -- ������ ���-�� - ������

          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData_MI.FromId
          LEFT JOIN Object AS Object_To   ON Object_To.Id   = tmpData_MI.ToId

          LEFT JOIN tmpMovementDate_Insert AS MovementDate_Insert
                                           ON MovementDate_Insert.MovementId = tmpData_MI.MovementId
                                          AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
          LEFT JOIN tmpMLO_Insert AS MLO_Insert
                                  ON MLO_Insert.MovementId = tmpData_MI.MovementId
                                 AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

          LEFT JOIN Object AS Object_Goods         ON Object_Goods.Id         = tmpData_MI.GoodsId
          LEFT JOIN Object AS Object_GoodsKind     ON Object_GoodsKind.Id     = tmpData_MI.GoodsKindId
          LEFT JOIN tmpNormInDays ON tmpNormInDays.GoodsId     = tmpData_MI.GoodsId
                                 AND tmpNormInDays.GoodsKindId = tmpData_MI.GoodsKindId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = tmpData_MI.GoodsId
                              AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

          -- ������ �� ������� - �������������
          LEFT JOIN tmpData ON tmpData.MovementId       = tmpData_MI.MovementId       -- ***
                           AND tmpData.ToId             = tmpData_MI.ToId             -- ***
                           AND tmpData.MovementItemId   = tmpData_MI.MovementItemId   -- ***
                           AND tmpData.GoodsId          = tmpData_MI.GoodsId          -- ***
                           AND tmpData.GoodsKindId      = tmpData_MI.GoodsKindId      -- ***
                           AND tmpData.PartionGoodsDate = tmpData_MI.PartionGoodsDate -- ***
                           -- !!!������������ ������ �� �������!!!
                           AND tmpData_MI.isPartionCell = TRUE
        ; 
    ELSE
     -- ���������
     RETURN QUERY
     WITH
       -- ������ �� 2-� �����
       tmpGoods AS (SELECT lfSelect.GoodsId
                    FROM lfSelect_Object_Goods_byGoodsGroup (1832) AS lfSelect
                   UNION
                    SELECT lfSelect.GoodsId
                    FROM lfSelect_Object_Goods_byGoodsGroup (1979) AS lfSelect
                   )
    , tmpNormInDays AS (SELECT Object_GoodsByGoodsKind_View.GoodsId, Object_GoodsByGoodsKind_View.GoodsKindId, Object_GoodsByGoodsKind_View.NormInDays
                        FROM Object_GoodsByGoodsKind_View
                             JOIN tmpGoods ON tmpGoods.GoodsId = Object_GoodsByGoodsKind_View.GoodsId
                        WHERE Object_GoodsByGoodsKind_View.NormInDays > 0
                       )
      --�������� ��� �� ������ �����
     , tmpMILO_PC AS (SELECT MovementItemLinkObject.*
                      FROM MovementItemLinkObject
                      WHERE MovementItemLinkObject.DescId IN (zc_MILinkObject_PartionCell_1()
                                                            , zc_MILinkObject_PartionCell_2()
                                                            , zc_MILinkObject_PartionCell_3()
                                                            , zc_MILinkObject_PartionCell_4()
                                                            , zc_MILinkObject_PartionCell_5()
                                                             )
                        -- ������ ����������� ������
                        AND COALESCE (MovementItemLinkObject.ObjectId,0) > 0
                     )
    , tmpMI AS (SELECT MovementItem.Id         AS MovementItemId
                     , MovementItem.MovementId AS MovementId
                     , MovementItem.ObjectId   AS GoodsId
                     , MovementItem.Amount     AS Amount
                FROM MovementItem
                     --���������� �������
                     --INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                WHERE MovementItem.Id IN (SELECT DISTINCT tmpMILO_PC.MovementItemId FROM tmpMILO_PC)
                  AND MovementItem.isErased = FALSE
                  AND MovementItem.DescId = zc_MI_Master() 
                )

    , tmpMovement AS (SELECT Movement.*
                           , MovementLinkObject_From.ObjectId AS FromId
                           , MovementLinkObject_To.ObjectId   AS ToId
                      FROM Movement
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()

                      WHERE Movement.Id IN (SELECT DISTINCT tmpMI.MovementId FROM tmpMI)
                        AND Movement.DescId = zc_Movement_Send()
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                        AND MovementLinkObject_To.ObjectId = inUnitId
                      )
                      

     , tmpMovementDate_Insert AS (SELECT MovementDate.*
                          FROM MovementDate
                          WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                            AND MovementDate.DescId = zc_MovementDate_Insert()
                          )
    , tmpMLO_Insert AS (SELECT MovementLinkObject.*
                 FROM MovementLinkObject
                 WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                   AND MovementLinkObject.DescId = zc_MovementLinkObject_Insert()
                 )

    , tmpMI_Boolean AS (SELECT MovementItemBoolean.*
                        FROM MovementItemBoolean
                        WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                          AND MovementItemBoolean.DescId IN (zc_MIBoolean_PartionCell_Close_1()
                                                           , zc_MIBoolean_PartionCell_Close_2()
                                                           , zc_MIBoolean_PartionCell_Close_3()
                                                           , zc_MIBoolean_PartionCell_Close_4()
                                                           , zc_MIBoolean_PartionCell_Close_5()
                                                            )
                       )

     , tmpMILO_PartionCell AS (SELECT MovementItemLinkObject.*
                                      -- ��������
                                    , CASE WHEN MIF_PartionCell_real.ValueData > 0 THEN MIF_PartionCell_real.ValueData ELSE NULL END :: Integer AS PartionCellId_real
                                      -- ���� ���� ���� ������ � ������ �� ������� - ��� �� �������
                                    , CASE WHEN tmpMI_Boolean.ValueData = TRUE THEN 0 ELSE 1 END AS isClose_value
                               FROM tmpMILO_PC AS MovementItemLinkObject
                                    LEFT JOIN tmpMI_Boolean ON tmpMI_Boolean.MovementItemId = MovementItemLinkObject.MovementItemId
                                                           AND tmpMI_Boolean.DescId         = CASE WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_1()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_1()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_2()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_2()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_3()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_3()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_4()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_4()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_5()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_5()
                                                                                              END
                                    LEFT JOIN MovementItemFloat AS MIF_PartionCell_real
                                                                ON MIF_PartionCell_real.MovementItemId = MovementItemLinkObject.MovementItemId
                                                               AND MIF_PartionCell_real.DescId         = CASE WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_1()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_1()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_2()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_2()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_3()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_3()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_4()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_4()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_5()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_5()
                                                                                                         END
                              )
     , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                               AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind())
                             )
     , tmpMI_Date AS (SELECT *
                      FROM MovementItemDate
                      WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                        AND MovementItemDate.DescId = zc_MIDate_PartionGoods()
                      )

       -- ������ ���-�� - ������
     , tmpData_MI AS (SELECT CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END                       AS MovementId        -- ***
                           , CASE WHEN inIsMovement = TRUE THEN Movement.InvNumber ELSE '' END               AS InvNumber
                           , CASE WHEN inIsMovement = TRUE THEN Movement.OperDate ELSE NULL END              AS OperDate
                           , MIN (Movement.OperDate)                                                         AS OperDate_min
                           , MAX (Movement.OperDate)                                                         AS OperDate_max
                           , CASE WHEN inIsMovement = TRUE THEN Movement.FromId ELSE 0 END                    AS FromId
                           , Movement.ToId                                                                   AS ToId              -- ***
                           , CASE WHEN inIsMovement = TRUE THEN MovementItem.MovementItemId ELSE 0 END       AS MovementItemId    -- ***
                           , MovementItem.GoodsId                                                            AS GoodsId           -- ***
                           , COALESCE (MILinkObject_GoodsKind.ObjectId,0)                                    AS GoodsKindId       -- ***
                           , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) :: TDateTime        AS PartionGoodsDate  -- ***
                           , SUM (MovementItem.Amount)                                                       AS Amount
                             -- ���� �������� ��� ��� - ��������� ����� ���������
                           , CASE WHEN tmpMILO_PartionCell.MovementItemId > 0 THEN TRUE ELSE FALSE END       AS isPartionCell
                             -- ���� ���� ������ ���������� �� ���� ��������� - �������� ��� ������ ������
                           , CASE WHEN Movement.OperDate <> COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate)
                                  THEN 8435455
                                  ELSE zc_Color_White()
                             END AS Color_PartionGoodsDate

                      FROM tmpMovement AS Movement
                           INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
                           -- ���� �������� ��� ��� - ��������� ����� ���������
                           LEFT JOIN (SELECT DISTINCT tmpMILO_PartionCell.MovementItemId FROM tmpMILO_PartionCell
                                     ) AS tmpMILO_PartionCell
                                       ON tmpMILO_PartionCell.MovementItemId = MovementItem.MovementItemId

                           LEFT JOIN tmpMI_Date AS MIDate_PartionGoods
                                                ON MIDate_PartionGoods.MovementItemId = MovementItem.MovementItemId
                                               AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()

                           LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.MovementItemId
                                                       AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
                      GROUP BY CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END
                             , CASE WHEN inIsMovement = TRUE THEN Movement.InvNumber ELSE '' END
                             , Movement.OperDate
                             , CASE WHEN inIsMovement = TRUE THEN Movement.FromId ELSE 0 END
                             , Movement.ToId
                             , CASE WHEN inIsMovement = TRUE THEN MovementItem.MovementItemId ELSE 0 END
                             , MovementItem.GoodsId
                             , COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                             , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate)
                             , CASE WHEN tmpMILO_PartionCell.MovementItemId > 0 THEN TRUE ELSE FALSE END
                     )

    -- ���������� �� ������� - �����������
  , tmpData_All_All AS (SELECT tmpData_list.MovementId        -- ***
                             , tmpData_list.ToId              -- ***
                             , tmpData_list.MovementItemId    -- ***
                             , tmpData_list.GoodsId           -- ***
                             , tmpData_list.GoodsKindId       -- ***
                             , tmpData_list.PartionGoodsDate  -- ***
                               -- ������������ �� �������
                             , tmpData_list.PartionCellId
                               -- ������������
                             , MAX (tmpData_list.PartionCellId_real) AS PartionCellId_real
                               -- ���� ���� ���� ������ � ������ �� ������� - ��� �� �������
                             , MAX (tmpData_list.isClose_value)                                        AS isClose_value_max
                               -- ���� ���� ���� �������� ������                                               
                             , MIN (tmpData_list.isClose_value)                                        AS isClose_value_min

                        FROM -- ������ ������ ������ �� ������� ������������
                             (SELECT DISTINCT
                                     CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END                       AS MovementId        -- ***
                                   , Movement.ToId                                                                   AS ToId              -- ***
                                   , CASE WHEN inIsMovement = TRUE THEN MovementItem.MovementItemId ELSE 0 END       AS MovementItemId    -- ***
                                   , MovementItem.GoodsId                                                            AS GoodsId           -- ***
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId,0)                                    AS GoodsKindId       -- ***
                                   , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) :: TDateTime        AS PartionGoodsDate  -- ***
                                     -- ������ ������ ������ �� ������� ������������
                                   , CASE WHEN inIsMovement = TRUE
                                          THEN MILinkObject_PartionCell.ObjectId
                                          ELSE COALESCE (MILinkObject_PartionCell.PartionCellId_real, MILinkObject_PartionCell.ObjectId)
                                     END AS PartionCellId
                                     -- ������������
                                   , CASE WHEN inIsMovement = TRUE
                                          THEN COALESCE (MILinkObject_PartionCell.PartionCellId_real, 0)
                                          ELSE NULL
                                     END AS PartionCellId_real

                                     -- ���� ���� ���� ������ � ������ �� ������� - ��� �� �������
                                   , MILinkObject_PartionCell.isClose_value
      
                              FROM tmpMovement AS Movement
                                   INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
      
                                   LEFT JOIN tmpMI_Date AS MIDate_PartionGoods
                                                        ON MIDate_PartionGoods.MovementItemId = MovementItem.MovementItemId
                                                       AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
      
                                   LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.MovementItemId
                                                              AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                   -- ������ ����������� ������
                                   INNER JOIN tmpMILO_PartionCell AS MILinkObject_PartionCell
                                                                  ON MILinkObject_PartionCell.MovementItemId = MovementItem.MovementItemId
     
                             ) AS tmpData_list

                        GROUP BY tmpData_list.MovementId        -- ***
                               , tmpData_list.ToId              -- ***
                               , tmpData_list.MovementItemId    -- ***
                               , tmpData_list.GoodsId           -- ***
                               , tmpData_list.GoodsKindId       -- ***
                               , tmpData_list.PartionGoodsDate  -- ***
                                 -- ������������ �� �������
                               , tmpData_list.PartionCellId
                       )
      -- ������ ����������� ������ - � �/�
    , tmpData_All AS (SELECT tmpData_All_All.MovementId        -- *** 
                           , tmpData_All_All.ToId              -- *** 
                           , tmpData_All_All.MovementItemId    -- *** 
                           , tmpData_All_All.GoodsId           -- *** 
                           , tmpData_All_All.GoodsKindId       -- *** 
                           , tmpData_All_All.PartionGoodsDate  -- *** 
                           , tmpData_All_All.PartionCellId
                           , tmpData_All_All.PartionCellId_real
                           , COALESCE (Object_PartionCell_real.ValueData, Object_PartionCell.ValueData) AS PartionCellName_calc
                             -- ���� ���� ���� ������ � ������ �� ������� - ��� �� �������
                           , tmpData_All_All.isClose_value_max
                             -- ���� ���� ���� �������� ������
                           , tmpData_All_All.isClose_value_min
                             --
                           , ROW_NUMBER() OVER (PARTITION BY tmpData_All_All.MovementId        -- *** 
                                                           , tmpData_All_All.ToId              -- *** 
                                                           , tmpData_All_All.MovementItemId    -- *** 
                                                           , tmpData_All_All.GoodsId           -- *** 
                                                           , tmpData_All_All.GoodsKindId       -- *** 
                                                           , tmpData_All_All.PartionGoodsDate  -- *** 
                                                ORDER BY COALESCE (ObjectFloat_Level.ValueData, 0)
                                                       , COALESCE (Object_PartionCell_real.ObjectCode, Object_PartionCell.ObjectCode, 0)
                                               ) AS Ord
                      FROM tmpData_All_All
                           LEFT JOIN Object AS Object_PartionCell      ON Object_PartionCell.Id      = tmpData_All_All.PartionCellId
                           LEFT JOIN Object AS Object_PartionCell_real ON Object_PartionCell_real.Id = tmpData_All_All.PartionCellId_real
                           LEFT JOIN ObjectFloat AS ObjectFloat_Level
                                                 ON ObjectFloat_Level.ObjectId = COALESCE (Object_PartionCell_real.Id, Object_PartionCell.Id)
                                                AND ObjectFloat_Level.DescId   = zc_ObjectFloat_PartionCell_Level()
                     )
      -- ���������� �� ������� - �������������
    , tmpData AS (SELECT tmpData_All.MovementId
                       , tmpData_All.ToId
                       , tmpData_All.MovementItemId
                       , tmpData_All.GoodsId
                       , tmpData_All.GoodsKindId
                       , tmpData_All.PartionGoodsDate

                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 1  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_1
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 2  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_2
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 3  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_3
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 4  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_4
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 5  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_5
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 6  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_6
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 7  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_7
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 8  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_8
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 9  THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_9
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 10 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_10
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 11 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_11
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 12 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_12
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 13 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_13
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 14 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_14
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 15 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_15
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 16 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_16
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 17 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_17
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 18 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_18
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 19 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_19
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 20 THEN tmpData_All.PartionCellId ELSE 0 END) AS PartionCellId_20

                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 1  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_1
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 2  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_2
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 3  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_3
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 4  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_4
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 5  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_5
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 6  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_6
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 7  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_7
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 8  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_8
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 9  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_9
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 10 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_10
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 11 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_11
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 12 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_12
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 13 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_13
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 14 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_14
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 15 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_15
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 16 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_16
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 17 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_17
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 18 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_18
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 19 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_19
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 20 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName_calc, tmpData_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_20

                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 1  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_1
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 2  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_2
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 3  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_3
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 4  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_4
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 5  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_5
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 6  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_6
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 7  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_7
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 8  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_8
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 9  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_9
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 10 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_10
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 11 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_11
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 12 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_12
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 13 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_13
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 14 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_14
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 15 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_15
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 16 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_16
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 17 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_17
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 18 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_18
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 19 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_19
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 20 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_20

                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 1  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_1
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 2  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_2
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 3  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_3
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 4  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_4
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 5  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_5
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 6  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_6
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 7  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_7
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 8  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_8
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 9  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_9
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 10 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_10
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 11 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_11
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 12 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_12
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 13 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_13
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 14 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_14
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 15 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_15
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 16 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_16
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 17 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_17
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 18 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_18
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 19 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_19
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 20 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_20

                         -- ���� ���� ���� �������� ������
                       , MIN (tmpData_All.isClose_value_min) AS isClose_value_min

                       , STRING_AGG (DISTINCT CASE WHEN COALESCE (tmpData_All.Ord, 0) > 20  THEN tmpData_All.PartionCellName_calc ELSE '' END, ';') AS PartionCellName_21

                  FROM tmpData_All

                  GROUP BY tmpData_All.MovementId
                         , tmpData_All.ToId
                         , tmpData_All.MovementItemId
                         , tmpData_All.GoodsId
                         , tmpData_All.GoodsKindId
                         , tmpData_All.PartionGoodsDate
                  )


       -- ���������
       SELECT tmpData_MI.MovementId
            , tmpData_MI.InvNumber    :: TVarChar
            , tmpData_MI.OperDate     :: TDateTime
            , tmpData_MI.OperDate_min :: TDateTime
            , tmpData_MI.OperDate_max :: TDateTime
            , MovementDate_Insert.ValueData AS InsertDate
            , Object_Insert.ValueData       AS InsertName
            , Object_From.Id                AS FromId
            , Object_From.ValueData         AS FromName
            , Object_To.Id                  AS ToId
            , Object_To.ValueData           AS ToName
            , tmpData_MI.MovementItemId
            , Object_Goods.Id                            AS GoodsId
            , Object_Goods.ObjectCode                    AS GoodsCode
            , Object_Goods.ValueData                     AS GoodsName
            , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
            , Object_Measure.ValueData                   AS MeasureName
            , Object_GoodsKind.Id                        AS GoodsKindId
            , Object_GoodsKind.ValueData                 AS GoodsKindName
            , tmpData_MI.PartionGoodsDate   :: TDateTime AS PartionGoodsDate
              --
            , tmpData.PartionCellId_1  :: Integer
            , tmpData.PartionCellId_2  :: Integer
            , tmpData.PartionCellId_3  :: Integer
            , tmpData.PartionCellId_4  :: Integer
            , tmpData.PartionCellId_5  :: Integer
            , tmpData.PartionCellId_6  :: Integer
            , tmpData.PartionCellId_7  :: Integer
            , tmpData.PartionCellId_8  :: Integer
            , tmpData.PartionCellId_9  :: Integer
            , tmpData.PartionCellId_10 :: Integer
            , tmpData.PartionCellId_11 :: Integer
            , tmpData.PartionCellId_12 :: Integer
            , tmpData.PartionCellId_13 :: Integer
            , tmpData.PartionCellId_14 :: Integer
            , tmpData.PartionCellId_15 :: Integer
            , tmpData.PartionCellId_16 :: Integer
            , tmpData.PartionCellId_17 :: Integer
            , tmpData.PartionCellId_18 :: Integer
            , tmpData.PartionCellId_19 :: Integer
            , tmpData.PartionCellId_20 :: Integer

            , tmpData.PartionCellName_1        :: TVarChar
            , tmpData.PartionCellName_2        :: TVarChar
            , tmpData.PartionCellName_3        :: TVarChar
            , tmpData.PartionCellName_4        :: TVarChar
            , tmpData.PartionCellName_5        :: TVarChar
            , tmpData.PartionCellName_6        :: TVarChar
            , tmpData.PartionCellName_7        :: TVarChar
            , tmpData.PartionCellName_8        :: TVarChar
            , tmpData.PartionCellName_9        :: TVarChar
            , tmpData.PartionCellName_10       :: TVarChar
            , tmpData.PartionCellName_11       :: TVarChar
            , tmpData.PartionCellName_12       :: TVarChar
            , tmpData.PartionCellName_13       :: TVarChar
            , tmpData.PartionCellName_14       :: TVarChar
            , tmpData.PartionCellName_15       :: TVarChar
            , tmpData.PartionCellName_16       :: TVarChar
            , tmpData.PartionCellName_17       :: TVarChar
            , tmpData.PartionCellName_18       :: TVarChar
            , tmpData.PartionCellName_19       :: TVarChar
            , tmpData.PartionCellName_20       :: TVarChar
            , tmpData.PartionCellName_21       :: TVarChar

            , CASE WHEN COALESCE (tmpData.ColorFon_1,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_1  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_2,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_2  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_3,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_3  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_4,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_4  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_5,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_5  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_6,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_6  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_7,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_7  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_8,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_8  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_9,  0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_9  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_10, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_10 END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_11, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_11  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_12, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_12  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_13, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_13  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_14, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_14  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_15, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_15  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_16, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_16  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_17, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_17  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_18, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_18  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_19, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_19  END :: Integer
            , CASE WHEN COALESCE (tmpData.ColorFon_20, 0) = 0 THEN zc_Color_White() ELSE tmpData.ColorFon_20 END :: Integer

            , CASE WHEN COALESCE (tmpData.Color_1,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_1  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_2,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_2  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_3,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_3  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_4,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_4  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_5,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_5  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_6,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_6  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_7,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_7  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_8,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_8  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_9,  0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_9  END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_10, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_10 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_11, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_11 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_12, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_12 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_13, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_13 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_14, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_14 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_15, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_15 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_16, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_16 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_17, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_17 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_18, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_18 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_19, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_19 END :: Integer
            , CASE WHEN COALESCE (tmpData.Color_20, 0) = 0 THEN zc_Color_Black() ELSE tmpData.Color_20 END :: Integer

              -- ���� ���� ���� �������� ������
            , CASE WHEN tmpData_MI.isPartionCell = TRUE AND tmpData.isClose_value_min = 0 THEN TRUE ELSE FALSE END :: Boolean AS isClose_value_min
              -- ������������ ������ �� ������� (��/���)
            , COALESCE (tmpData_MI.isPartionCell, FALSE) :: Boolean

            , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpData_MI.Amount ELSE 0 END ::TFloat AS Amount
            , (tmpData_MI.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS Amount_Weight

            , tmpNormInDays.NormInDays                   :: Integer AS NormInDays
            , CASE WHEN CURRENT_DATE < tmpData_MI.PartionGoodsDate + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL
                        THEN EXTRACT (DAY FROM (tmpData_MI.PartionGoodsDate + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL) - CURRENT_DATE)
                   ELSE 0
              END :: Integer AS NormInDays_real
            , CASE WHEN tmpNormInDays.NormInDays > 0 
                   THEN CAST (100 * CASE WHEN CURRENT_DATE < tmpData_MI.PartionGoodsDate + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL
                                              THEN EXTRACT (DAY FROM (tmpData_MI.PartionGoodsDate + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL) - CURRENT_DATE)
                                         ELSE 0
                                    END
                            / tmpNormInDays.NormInDays AS NUMERIC (16, 1))
                   ELSE 0
              END :: TFloat AS NormInDays_tax

            , (tmpData_MI.PartionGoodsDate + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL) :: TDateTime AS NormInDays_date

            , tmpData_MI.Color_PartionGoodsDate ::Integer
       
     FROM tmpData_MI -- ������ ���-�� - ������

          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData_MI.FromId
          LEFT JOIN Object AS Object_To   ON Object_To.Id   = tmpData_MI.ToId

          LEFT JOIN tmpMovementDate_Insert AS MovementDate_Insert
                                           ON MovementDate_Insert.MovementId = tmpData_MI.MovementId
                                          AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
          LEFT JOIN tmpMLO_Insert AS MLO_Insert
                                  ON MLO_Insert.MovementId = tmpData_MI.MovementId
                                 AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

          LEFT JOIN Object AS Object_Goods         ON Object_Goods.Id         = tmpData_MI.GoodsId
          LEFT JOIN Object AS Object_GoodsKind     ON Object_GoodsKind.Id     = tmpData_MI.GoodsKindId
          LEFT JOIN tmpNormInDays ON tmpNormInDays.GoodsId     = tmpData_MI.GoodsId
                                 AND tmpNormInDays.GoodsKindId = tmpData_MI.GoodsKindId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = tmpData_MI.GoodsId
                              AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

          -- ������ �� ������� - �������������
          LEFT JOIN tmpData ON tmpData.MovementId       = tmpData_MI.MovementId       -- ***
                           AND tmpData.ToId             = tmpData_MI.ToId             -- ***
                           AND tmpData.MovementItemId   = tmpData_MI.MovementItemId   -- ***
                           AND tmpData.GoodsId          = tmpData_MI.GoodsId          -- ***
                           AND tmpData.GoodsKindId      = tmpData_MI.GoodsKindId      -- ***
                           AND tmpData.PartionGoodsDate = tmpData_MI.PartionGoodsDate -- ***
                           -- !!!������������ ������ �� �������!!!
                           AND tmpData_MI.isPartionCell = TRUE
        ; 
    
    END IF;
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.01.24         *
*/

-- ����
-- SELECT * FROM gpReport_Send_PartionCell (inStartDate:= '04.02.2024', inEndDate:= '04.02.2024', inUnitId:= 8451, inIsMovement:= false, inIsShowAll := true, inSession:= zfCalc_UserAdmin()); -- ����� ����������
/*
zc_ObjectFloat_StickerProperty_Value5 -  ������� �� 
zc_ObjectFloat_StickerProperty_Value10 - ������� �� - ������ ����

zc_ObjectFloat_GoodsByGoodsKind_NormInDays -  ���� �������� � ���� 

zc_ObjectFloat_OrderType_TermProduction

*/
