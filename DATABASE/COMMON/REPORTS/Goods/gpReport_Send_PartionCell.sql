 -- Function: gpReport_Send_PartionCell ()

DROP FUNCTION IF EXISTS gpReport_Send_PartionCell (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Send_PartionCell (
    IN inStartDate         TDateTime ,
    IN inEndDate           TDateTime ,
    IN inUnitId            Integer   ,
    IN inIsPartion         Boolean   ,
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

             , Amount TFloat, Amount_Weight TFloat
             )
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY

     WITH 
      tmpMovement AS (SELECT Movement.*
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
                        AND (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId = 0)
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
                     , MovementItem.ObjectId 
                     AS GoodsId
                     , MovementItem.Amount   AS Amount
                FROM MovementItem 
                WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                  AND MovementItem.DescId   = zc_MI_Master()
                  AND MovementItem.isErased = FALSE
               )
    , tmpMI_LO AS (SELECT MovementItemLinkObject.*
                   FROM MovementItemLinkObject
                   WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                     AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind()
                                                         , zc_MILinkObject_PartionCell_1()
                                                         , zc_MILinkObject_PartionCell_2()
                                                         , zc_MILinkObject_PartionCell_3()
                                                         , zc_MILinkObject_PartionCell_4()
                                                         , zc_MILinkObject_PartionCell_5()
                                                          )
                   )

    , tmpMI_Float AS (SELECT *
                      FROM MovementItemFloat
                      WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                        AND MovementItemFloat.DescId IN (zc_MIFloat_PartionCell_Amount_1()
                                                       , zc_MIFloat_PartionCell_Amount_2()
                                                       , zc_MIFloat_PartionCell_Amount_3()
                                                       , zc_MIFloat_PartionCell_Amount_4()
                                                       , zc_MIFloat_PartionCell_Amount_5()
                                                        )
                      )

    , tmpMI_Date AS (SELECT *
                     FROM MovementItemDate
                     WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                       AND MovementItemDate.DescId = zc_MIDate_PartionGoods()
                     )


    , tmpPartionCell AS (SELECT tmp.ObjectId
                              , ROW_NUMBER() OVER(ORDER BY 1) AS Ord
                         FROM (SELECT tmpMI_LO.ObjectId
                               FROM tmpMI_LO
                               WHERE tmpMI_LO.DescId = zc_MILinkObject_PartionCell_1() 
                              UNION ALL
                               SELECT tmpMI_LO.ObjectId
                               FROM tmpMI_LO
                               WHERE tmpMI_LO.DescId = zc_MILinkObject_PartionCell_2()
                              UNION ALL
                               SELECT tmpMI_LO.ObjectId
                               FROM tmpMI_LO
                               WHERE tmpMI_LO.DescId = zc_MILinkObject_PartionCell_3()
                              UNION ALL
                               SELECT tmpMI_LO.ObjectId
                               FROM tmpMI_LO
                               WHERE tmpMI_LO.DescId = zc_MILinkObject_PartionCell_4()
                              UNION ALL
                               SELECT tmpMI_LO.ObjectId
                               FROM tmpMI_LO
                               WHERE tmpMI_LO.DescId = zc_MILinkObject_PartionCell_5()
                              ) AS tmp
                         )
    
    , tmpData AS (SELECT Movement.Id AS MovementId
                       , Movement.InvNumber   
                       , Movement.OperDate
                       , Movement.FromId
                       , Movement.ToId
                       
                       , CASE WHEN inIsPartion = FALSE THEN MovementItem.MovementItemId ELSE 0 END AS MovementItemId
                       , MovementItem.GoodsId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId,0)                             AS GoodsKindId
                       
                       , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) :: TDateTime AS PartionGoodsDate

                       , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 1
                              THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                              ELSE ''
                         END AS PartionCellName_1
                       , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 2
                              THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                              ELSE ''
                         END AS PartionCellName_2
                       , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 3
                              THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                              ELSE ''
                         END AS PartionCellName_3
                       , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 4
                              THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                              ELSE ''
                         END AS PartionCellName_4
                       , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 5
                              THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                              ELSE ''
                         END AS PartionCellName_5
                       , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 6
                              THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                              ELSE ''
                         END AS PartionCellName_6
                       , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 7
                              THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                              ELSE ''
                         END AS PartionCellName_7
                       , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 8
                              THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                              ELSE ''
                         END AS PartionCellName_8
                       , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 9
                              THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                              ELSE ''
                         END AS PartionCellName_9
                       , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 10
                              THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                              ELSE ''
                         END AS PartionCellName_10
                       
                       , SUM (MovementItem.Amount) AS Amount 
                  FROM tmpMovement AS Movement
                      INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
                      
                      LEFT JOIN tmpMI_Date AS MIDate_PartionGoods
                                           ON MIDate_PartionGoods.MovementItemId = MovementItem.MovementItemId
                                          AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
          
                      LEFT JOIN tmpMI_LO AS MILinkObject_GoodsKind
                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.MovementItemId
                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
          
                      LEFT JOIN tmpMI_LO AS MILinkObject_PartionCell_1
                                         ON MILinkObject_PartionCell_1.MovementItemId = MovementItem.MovementItemId
                                        AND MILinkObject_PartionCell_1.DescId = zc_MILinkObject_PartionCell_1()
                      LEFT JOIN Object AS Object_PartionCell_1 ON Object_PartionCell_1.Id = MILinkObject_PartionCell_1.ObjectId
          
                      LEFT JOIN tmpMI_LO AS MILinkObject_PartionCell_2
                                         ON MILinkObject_PartionCell_2.MovementItemId = MovementItem.MovementItemId
                                        AND MILinkObject_PartionCell_2.DescId = zc_MILinkObject_PartionCell_2()
                      LEFT JOIN Object AS Object_PartionCell_2 ON Object_PartionCell_2.Id = MILinkObject_PartionCell_2.ObjectId
          
                      LEFT JOIN tmpMI_LO AS MILinkObject_PartionCell_3
                                         ON MILinkObject_PartionCell_3.MovementItemId = MovementItem.MovementItemId
                                        AND MILinkObject_PartionCell_3.DescId = zc_MILinkObject_PartionCell_3()
                      LEFT JOIN Object AS Object_PartionCell_3 ON Object_PartionCell_3.Id = MILinkObject_PartionCell_3.ObjectId
          
                      LEFT JOIN tmpMI_LO AS MILinkObject_PartionCell_4
                                         ON MILinkObject_PartionCell_4.MovementItemId = MovementItem.MovementItemId
                                        AND MILinkObject_PartionCell_4.DescId = zc_MILinkObject_PartionCell_4()
                      LEFT JOIN Object AS Object_PartionCell_4 ON Object_PartionCell_4.Id = MILinkObject_PartionCell_4.ObjectId
          
                      LEFT JOIN tmpMI_LO AS MILinkObject_PartionCell_5
                                         ON MILinkObject_PartionCell_5.MovementItemId = MovementItem.MovementItemId
                                        AND MILinkObject_PartionCell_5.DescId = zc_MILinkObject_PartionCell_5()
                      LEFT JOIN Object AS Object_PartionCell_5 ON Object_PartionCell_5.Id = MILinkObject_PartionCell_5.ObjectId
          
                      LEFT JOIN tmpPartionCell AS tmpPartionCell_1 ON tmpPartionCell_1.ObjectId = MILinkObject_PartionCell_1.ObjectId
                      LEFT JOIN tmpPartionCell AS tmpPartionCell_2 ON tmpPartionCell_2.ObjectId = MILinkObject_PartionCell_2.ObjectId
                      LEFT JOIN tmpPartionCell AS tmpPartionCell_3 ON tmpPartionCell_3.ObjectId = MILinkObject_PartionCell_3.ObjectId
                      LEFT JOIN tmpPartionCell AS tmpPartionCell_4 ON tmpPartionCell_4.ObjectId = MILinkObject_PartionCell_4.ObjectId
                      LEFT JOIN tmpPartionCell AS tmpPartionCell_5 ON tmpPartionCell_5.ObjectId = MILinkObject_PartionCell_5.ObjectId
                       
                  GROUP BY Movement.Id
                         , Movement.InvNumber   
                         , Movement.OperDate
                         , Movement.FromId
                         , Movement.ToId
                         , CASE WHEN inIsPartion = FALSE THEN MovementItem.MovementItemId ELSE 0 END
                         , MovementItem.GoodsId
                         , COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                         , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate)

                         , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 1
                                THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                                ELSE ''
                           END
                         , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 2
                                THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                                ELSE ''
                           END
                         , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 3
                                THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                                ELSE ''
                           END
                         , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 4
                                THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                                ELSE ''
                           END
                         , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 5
                                THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                                ELSE ''
                           END
                         , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 6
                                THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                                ELSE ''
                           END
                         , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 7
                                THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                                ELSE ''
                           END
                         , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 8
                                THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                                ELSE ''
                           END
                         , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 9
                                THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                                ELSE ''
                           END
                         , CASE WHEN COALESCE (tmpPartionCell_1.Ord, tmpPartionCell_2.Ord, tmpPartionCell_3.Ord, tmpPartionCell_4.Ord, tmpPartionCell_5.Ord) = 10
                                THEN COALESCE (Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData, Object_PartionCell_1.ValueData)
                                ELSE ''
                           END
                  )

    
       -- Результат
       SELECT tmpData.MovementId
            , tmpData.InvNumber
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

            , tmpData.Amount ::TFloat
            , (tmpData.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS Amount_Weight
            
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
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ObjectId

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
-- SELECT * FROM gpReport_Send_PartionCell (inStartDate:= '27.12.2023', inEndDate:= '04.01.2024', inUnitId:= 8451, inIsPartion:= false, inSession:= zfCalc_UserAdmin()); -- Склад Реализации
