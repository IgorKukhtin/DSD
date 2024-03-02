 -- Function: gpReport_Send_PartionCell ()

DROP FUNCTION IF EXISTS gpReport_Send_PartionCell (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Send_PartionCell (
    IN inStartDate         TDateTime ,
    IN inEndDate           TDateTime ,
    IN inUnitId            Integer   ,
    IN inIsMovement         Boolean   ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime
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
             , PartionCellName_11  TVarChar

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

               -- есть ли хоть одна закрытая партия
             , isClose_value_min Boolean

             , Amount TFloat, Amount_Weight TFloat 
             , Color_PartionGoodsDate Integer
             )
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     --если не выбрали подразделение выбираем из   8459
     --переопределяем
     IF COALESCE (inUnitId,0) = 0  
     THEN
         inUnitId := 8459;
     END IF;
     

     -- Результат
     RETURN QUERY
     WITH
      --товары из 2-х групп
       tmpGoods AS (SELECT lfSelect.GoodsId
                    FROM lfSelect_Object_Goods_byGoodsGroup (1832) AS lfSelect
                   UNION
                    SELECT lfSelect.GoodsId
                    FROM lfSelect_Object_Goods_byGoodsGroup (1979) AS lfSelect
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

    , tmpMovementDate AS (SELECT MovementDate.*
                          FROM MovementDate
                          WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                            AND MovementDate.DescId = zc_MovementDate_Insert()
                          )
    , tmpMLO AS (SELECT MovementLinkObject.*
                 FROM MovementLinkObject
                 WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                   AND MovementLinkObject.DescId = zc_MovementLinkObject_Insert()
                 )


    , tmpMI AS (SELECT MovementItem.Id         AS MovementItemId
                     , MovementItem.MovementId AS MovementId
                     , MovementItem.ObjectId   AS GoodsId
                     , MovementItem.Amount     AS Amount
                FROM MovementItem
                     --ограничили товаром
                     INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId 
                WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                  AND MovementItem.DescId   = zc_MI_Master()
                  AND MovementItem.isErased = FALSE
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
    , tmpMI_LO AS (SELECT MovementItemLinkObject.*
                        , tmpMI_Boolean.ValueData AS isClose
                          -- если хоть одна ячейка НЕ закрыта - все НЕ закрыты
                        , CASE WHEN tmpMI_Boolean.ValueData = TRUE THEN 0 ELSE 1 END AS isClose_value
                   FROM MovementItemLinkObject
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
                   WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                     AND MovementItemLinkObject.DescId IN (zc_MILinkObject_PartionCell_1()
                                                         , zc_MILinkObject_PartionCell_2()
                                                         , zc_MILinkObject_PartionCell_3()
                                                         , zc_MILinkObject_PartionCell_4()
                                                         , zc_MILinkObject_PartionCell_5()
                                                          )
                     AND MovementItemLinkObject.ObjectId > 0
                  )
     , tmpMI_LO_GoodsKind AS (SELECT MovementItemLinkObject.*
                              FROM MovementItemLinkObject
                              WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                                AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind())
                              )

    , tmpMI_Date AS (SELECT *
                     FROM MovementItemDate
                     WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                       AND MovementItemDate.DescId = zc_MIDate_PartionGoods()
                     )


  -- все ячейки по всем док. и товарам  - группировка
, tmpData_All_All AS (SELECT CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END                       AS MovementId
                           , CASE WHEN inIsMovement = TRUE THEN Movement.InvNumber ELSE '' END               AS InvNumber 
                           , Movement.OperDate
                           , CASE WHEN inIsMovement = TRUE THEN Movement.FromId ELSE 0 END                   AS FromId
                           --, CASE WHEN inIsMovement = TRUE THEN Movement.ToId ELSE 0 END                     AS ToId
                           , Movement.ToId                    AS ToId
                           , CASE WHEN inIsMovement = TRUE THEN MovementItem.MovementItemId ELSE 0 END       AS MovementItemId
                           , MovementItem.GoodsId                                                            AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId,0)                                    AS GoodsKindId
                           , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) :: TDateTime        AS PartionGoodsDate    
                           , Object_PartionCell.Id                                                           AS PartionCellId
                           , Object_PartionCell.ValueData                                                    AS PartionCellName
                             -- если хоть одна ячейка НЕ закрыта - все НЕ закрыты
                           , MAX (MILinkObject_PartionCell.isClose_value)                                    AS isClose_value
                           , MIN (MILinkObject_PartionCell.isClose_value)                                    AS isClose_value_min
                             --
                           , SUM (MovementItem.Amount)                                                       AS Amount

                      FROM tmpMovement AS Movement
                          INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
                          
                          LEFT JOIN tmpMI_Date AS MIDate_PartionGoods
                                               ON MIDate_PartionGoods.MovementItemId = MovementItem.MovementItemId
                                              AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                          LEFT JOIN tmpMI_LO_GoodsKind AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.MovementItemId
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
              
                          LEFT JOIN tmpMI_LO AS MILinkObject_PartionCell
                                             ON MILinkObject_PartionCell.MovementItemId = MovementItem.MovementItemId
                          LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = MILinkObject_PartionCell.ObjectId
                         
                      GROUP BY CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END 
                             , CASE WHEN inIsMovement = TRUE THEN Movement.InvNumber ELSE '' END  
                             , Movement.OperDate
                             , CASE WHEN inIsMovement = TRUE THEN Movement.FromId ELSE 0 END 
                             --, CASE WHEN inIsMovement = TRUE THEN Movement.ToId ELSE 0 END  
                             , Movement.ToId
                             , CASE WHEN inIsMovement = TRUE THEN MovementItem.MovementItemId ELSE 0 END 
                             , MovementItem.GoodsId
                             , COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                             , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate)    
                             , Object_PartionCell.Id
                             , Object_PartionCell.ValueData
                      )
      -- все ячейки по всем док. и товарам  - группировка
    , tmpData_All AS (SELECT tmpData_All_All.MovementId
                           , tmpData_All_All.InvNumber 
                           , tmpData_All_All.OperDate
                           , tmpData_All_All.FromId
                           , tmpData_All_All.ToId
                           , tmpData_All_All.MovementItemId
                           , tmpData_All_All.GoodsId
                           , tmpData_All_All.GoodsKindId
                           , tmpData_All_All.PartionGoodsDate    
                           , tmpData_All_All.PartionCellId
                           , tmpData_All_All.PartionCellName
                             -- если хоть одна ячейка НЕ закрыта - все НЕ закрыты
                           , tmpData_All_All.isClose_value
                           , tmpData_All_All.isClose_value_min
                             --
                           , tmpData_All_All.Amount
                           , ROW_NUMBER() OVER (PARTITION BY tmpData_All_All.MovementItemId
                                                           , tmpData_All_All.GoodsId
                                                           , tmpData_All_All.GoodsKindId
                                                           , tmpData_All_All.PartionGoodsDate
                                                ORDER BY COALESCE (ObjectFloat_Level.ValueData, 0)
                                               ) AS Ord 
                           , CASE WHEN tmpData_All_All.PartionGoodsDate <> tmpData_All_All.OperDate
                                  THEN 8435455
                                  ELSE zc_Color_White()
                             END AS Color_PartionGoodsDate                       
                      FROM tmpData_All_All
                           LEFT JOIN ObjectFloat AS ObjectFloat_Level
                                                 ON ObjectFloat_Level.ObjectId = tmpData_All_All.PartionCellId
                                                AND ObjectFloat_Level.DescId   = zc_ObjectFloat_PartionCell_Level()
                      WHERE tmpData_All_All.PartionCellId > 0

                     UNION ALL
                      SELECT tmpData_All_All.MovementId
                           , tmpData_All_All.InvNumber 
                           , tmpData_All_All.OperDate
                           , tmpData_All_All.FromId
                           , tmpData_All_All.ToId
                           , tmpData_All_All.MovementItemId
                           , tmpData_All_All.GoodsId
                           , tmpData_All_All.GoodsKindId
                           , tmpData_All_All.PartionGoodsDate    
                           , 0 AS PartionCellId
                           , tmpData_All_All.PartionCellName
                             -- если хоть одна ячейка НЕ закрыта - все НЕ закрыты
                           , 1 AS isClose_value
                           , 1 AS isClose_value_min
                             --
                           , tmpData_All_All.Amount
                           , 1 AS Ord 
                           , CASE WHEN tmpData_All_All.PartionGoodsDate <> tmpData_All_All.OperDate
                                  THEN 8435455
                                  ELSE zc_Color_White()
                             END AS Color_PartionGoodsDate                       
                      FROM tmpData_All_All
                      WHERE tmpData_All_All.PartionCellId IS NULL
                     )

    , tmpData AS (SELECT tmpData_All.MovementId
                       , tmpData_All.InvNumber   
                       , tmpData_All.OperDate
                       , tmpData_All.FromId
                       , tmpData_All.ToId
                       
                       , tmpData_All.MovementItemId
                       , tmpData_All.GoodsId
                       , tmpData_All.GoodsKindId
                       , tmpData_All.PartionGoodsDate    
                       , (tmpData_All.Amount) AS Amount

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
                       
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 1  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName, tmpData_All.isClose_value = 0) ELSE '' END) AS PartionCellName_1
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 2  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName, tmpData_All.isClose_value = 0) ELSE '' END) AS PartionCellName_2
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 3  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName, tmpData_All.isClose_value = 0) ELSE '' END) AS PartionCellName_3
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 4  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName, tmpData_All.isClose_value = 0) ELSE '' END) AS PartionCellName_4
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 5  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName, tmpData_All.isClose_value = 0) ELSE '' END) AS PartionCellName_5
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 6  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName, tmpData_All.isClose_value = 0) ELSE '' END) AS PartionCellName_6
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 7  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName, tmpData_All.isClose_value = 0) ELSE '' END) AS PartionCellName_7
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 8  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName, tmpData_All.isClose_value = 0) ELSE '' END) AS PartionCellName_8
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 9  THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName, tmpData_All.isClose_value = 0) ELSE '' END) AS PartionCellName_9
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 10 THEN zfCalc_PartionCell_IsClose (tmpData_All.PartionCellName, tmpData_All.isClose_value = 0) ELSE '' END) AS PartionCellName_10

                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 1  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE zc_Color_White() END) AS ColorFon_1
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 2  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE zc_Color_White() END) AS ColorFon_2
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 3  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE zc_Color_White() END) AS ColorFon_3
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 4  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE zc_Color_White() END) AS ColorFon_4
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 5  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE zc_Color_White() END) AS ColorFon_5
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 6  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE zc_Color_White() END) AS ColorFon_6
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 7  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE zc_Color_White() END) AS ColorFon_7
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 8  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE zc_Color_White() END) AS ColorFon_8
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 9  AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE zc_Color_White() END) AS ColorFon_9
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 10 AND tmpData_All.PartionCellId > 0 THEN CASE WHEN tmpData_All.isClose_value = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE zc_Color_White() END) AS ColorFon_10

                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 1  AND tmpData_All.PartionCellId > 0 AND tmpData_All.isClose_value = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END) AS Color_1
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 2  AND tmpData_All.PartionCellId > 0 AND tmpData_All.isClose_value = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END) AS Color_2
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 3  AND tmpData_All.PartionCellId > 0 AND tmpData_All.isClose_value = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END) AS Color_3
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 4  AND tmpData_All.PartionCellId > 0 AND tmpData_All.isClose_value = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END) AS Color_4
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 5  AND tmpData_All.PartionCellId > 0 AND tmpData_All.isClose_value = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END) AS Color_5
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 6  AND tmpData_All.PartionCellId > 0 AND tmpData_All.isClose_value = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END) AS Color_6
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 7  AND tmpData_All.PartionCellId > 0 AND tmpData_All.isClose_value = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END) AS Color_7
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 8  AND tmpData_All.PartionCellId > 0 AND tmpData_All.isClose_value = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END) AS Color_8
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 9  AND tmpData_All.PartionCellId > 0 AND tmpData_All.isClose_value = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END) AS Color_9
                       , MAX (CASE WHEN COALESCE (tmpData_All.Ord, 0) = 10 AND tmpData_All.PartionCellId > 0 AND tmpData_All.isClose_value = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END) AS Color_10

                         -- замена, есть ли хоть одна закрытая партия
                       , MIN (tmpData_All.isClose_value_min) AS isClose_value_min

                       , STRING_AGG (CASE WHEN COALESCE (tmpData_All.Ord, 0) > 10  THEN tmpData_All.PartionCellName END, ';') AS PartionCellName_11
                       , MAX (tmpData_All.Color_PartionGoodsDate) AS Color_PartionGoodsDate
                        
                  FROM tmpData_All

                  GROUP BY tmpData_All.MovementId
                         , tmpData_All.InvNumber   
                         , tmpData_All.OperDate
                         , tmpData_All.FromId
                         , tmpData_All.ToId
                         
                         , tmpData_All.MovementItemId
                         , tmpData_All.GoodsId
                         , tmpData_All.GoodsKindId
                         , tmpData_All.PartionGoodsDate 
                         , tmpData_All.Amount
                  )

    
       -- Результат
       SELECT tmpData.MovementId
            , tmpData.InvNumber ::TVarChar
            , tmpData.OperDate 
            , MovementDate_Insert.ValueData AS InsertDate
            , Object_Insert.ValueData       AS InsertName
            , Object_From.Id                AS FromId
            , Object_From.ValueData         AS FromName
            , Object_To.Id                  AS ToId
            , Object_To.ValueData           AS ToName
            , tmpData.MovementItemId
            , Object_Goods.Id                            AS GoodsId
            , Object_Goods.ObjectCode                    AS GoodsCode
            , Object_Goods.ValueData                     AS GoodsName
            , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
            , Object_Measure.ValueData                   AS MeasureName
            , Object_GoodsKind.Id                        AS GoodsKindId
            , Object_GoodsKind.ValueData                 AS GoodsKindName 
            , tmpData.PartionGoodsDate   :: TDateTime    AS PartionGoodsDate
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

            , tmpData.ColorFon_1  :: Integer
            , tmpData.ColorFon_2  :: Integer
            , tmpData.ColorFon_3  :: Integer
            , tmpData.ColorFon_4  :: Integer
            , tmpData.ColorFon_5  :: Integer
            , tmpData.ColorFon_6  :: Integer
            , tmpData.ColorFon_7  :: Integer
            , tmpData.ColorFon_8  :: Integer
            , tmpData.ColorFon_9  :: Integer
            , tmpData.ColorFon_10 :: Integer


            , tmpData.Color_1  :: Integer
            , tmpData.Color_2  :: Integer
            , tmpData.Color_3  :: Integer
            , tmpData.Color_4  :: Integer
            , tmpData.Color_5  :: Integer
            , tmpData.Color_6  :: Integer
            , tmpData.Color_7  :: Integer
            , tmpData.Color_8  :: Integer
            , tmpData.Color_9  :: Integer
            , tmpData.Color_10 :: Integer
              -- есть ли хоть одна закрытая партия
            , CASE WHEN tmpData.isClose_value_min = 0 THEN TRUE ELSE FALSE END :: Boolean AS isClose_value_min

            , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpData.Amount ELSE 0 END ::TFloat AS Amount
            , (tmpData.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS Amount_Weight
            , tmpData.Color_PartionGoodsDate ::Integer
     FROM tmpData 

          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.FromId
          LEFT JOIN Object AS Object_To ON Object_To.Id = tmpData.ToId

          LEFT JOIN tmpMovementDate AS MovementDate_Insert
                                    ON MovementDate_Insert.MovementId = tmpData.MovementId
          LEFT JOIN tmpMLO AS MLO_Insert
                           ON MLO_Insert.MovementId = tmpData.MovementId
                          AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

          LEFT JOIN Object AS Object_Goods         ON Object_Goods.Id         = tmpData.GoodsId
          LEFT JOIN Object AS Object_GoodsKind     ON Object_GoodsKind.Id     = tmpData.GoodsKindId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = tmpData.GoodsId
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
        ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.01.24         *
*/

-- тест
-- SELECT * FROM gpReport_Send_PartionCell (inStartDate:= '04.02.2024', inEndDate:= '04.02.2024', inUnitId:= 8451, inIsMovement:= false, inSession:= zfCalc_UserAdmin()); -- Склад Реализации
