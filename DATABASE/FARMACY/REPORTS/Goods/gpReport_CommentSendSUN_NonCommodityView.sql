-- Function: gpReport_CommentSendSUN_NonCommodityView()

DROP FUNCTION IF EXISTS gpReport_CommentSendSUN_NonCommodityView (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CommentSendSUN_NonCommodityView(
    IN inOperDate      TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, Formed TFloat, Remains TFloat
             , AmountPrev TFloat, FormedPrev TFloat
             , AmountLoss TFloat, AddLoss TFloat
              )

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
  vbUserId:= lpGetUserBySession (inSession);
  
  
  vbOperDate := inOperDate - ((date_part('isodow', inOperDate) - 1)||' day')::INTERVAL;

  -- Результат
  RETURN QUERY
  WITH tmpMovement AS (SELECT Movement.ID
                            , Movement.InvNumber
                            , Movement.StatusId
                            , Movement.OperDate
                            , inOperDate - ((date_part('isodow', inOperDate) - 1)||' day')::INTERVAL <= Movement.OperDate AS isCurrent
                       FROM Movement
                            INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                   AND MovementBoolean_SUN.ValueData = TRUE
                            INNER JOIN MovementDate AS MovementDate_Insert
                                                    ON MovementDate_Insert.MovementId = Movement.Id
                                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                       WHERE Movement.DescId = zc_Movement_Send()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                         AND Movement.OperDate >= '01.03.2021'
                         AND Movement.OperDate < vbOperDate + INTERVAL '7 DAY')
     , tmpResult AS (SELECT Movement.ID                                                                    AS ID
                          , Movement.InvNumber
                          , Movement.OperDate
                          , Movement.isCurrent                                                             AS isCurrent 
                          , MovementLinkObject_From.ObjectId                                               AS UnitId
                          , MILinkObject_CommentSend.ObjectId                                              AS CommentSendID
                          , MovementItem.ObjectId                                                          AS GoodsID
                          , MovementItem.Id                                                                AS MovementItemId
                          , MovementItem.Amount                                                            AS Amount
                     FROM tmpMovement AS Movement
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                          LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId = zc_MI_Master()
                                                AND MovementItem.isErased = FALSE

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                                           ON MILinkObject_CommentSend.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()

                     WHERE COALESCE (MILinkObject_CommentSend.ObjectId , 0) = 15180138 
                     )
     , tmpProtocolUnion AS (SELECT  MovementItemProtocol.Id
                                  , MovementItemProtocol.MovementItemId
                                  , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                             FROM tmpResult AS MovementItem

                                  INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.MovementItemId
                                                              AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                                              AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                             UNION ALL
                             SELECT MovementItemProtocol.Id
                                  , MovementItemProtocol.MovementItemId
                                  , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                             FROM tmpResult AS MovementItem

                                  INNER JOIN MovementItemProtocol_arc AS MovementItemProtocol
                                                                      ON MovementItemProtocol.MovementItemId = MovementItem.MovementItemId
                                                                     AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                                                     AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                            )
      , tmpProtocolAll AS (SELECT MovementItemProtocol.MovementItemId
                                , MovementItemProtocol.ProtocolData
                                , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                           FROM tmpProtocolUnion AS MovementItemProtocol
                           )
     , tmpProtocol AS (SELECT tmpProtocolAll.MovementItemId
                            , SUBSTRING(tmpProtocolAll.ProtocolData, 1, POSITION('"' IN tmpProtocolAll.ProtocolData) - 1)::TFloat AS AmountAuto
                       FROM tmpProtocolAll
                       WHERE tmpProtocolAll.Ord = 1)
     -- Текущий месяц
     , tmpData AS (SELECT tmpResult.UnitId                                                                    AS UnitId
                        , tmpResult.GoodsID                                                                   AS GoodsID
                        , tmpResult.CommentSendID                                                             AS CommentSendID
                        , SUM(COALESCE(tmpProtocol.AmountAuto, tmpResult.Amount ) - tmpResult.Amount)::TFloat AS Amount
                        , SUM(COALESCE(tmpProtocol.AmountAuto, tmpResult.Amount ))::TFloat                    AS Formed
                   FROM tmpResult
                        LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpResult.MovementItemId
                        
                   WHERE tmpResult.isCurrent = TRUE
                   GROUP BY tmpResult.UnitId
                          , tmpResult.GoodsID
                          , tmpResult.CommentSendID)
     -- Списаеия
     , tmpLoss AS (SELECT Movement.Id
                        , Movement.OperDate
                        , MovementLinkObject_Unit.ObjectId    AS UnitId
                   FROM Movement
                        
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                    AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()
                                                         
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                                     ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                                    AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
                                                          
                  WHERE Movement.DescId = zc_Movement_Loss()
                     AND Movement.OperDate >= '01.03.2021'
                     AND Movement.OperDate < vbOperDate + INTERVAL '7 DAY'
                     AND Movement.StatusId <> zc_Enum_Status_Erased()
                     AND MovementLinkObject_ArticleLoss.ObjectId = 12651643 
                     AND MovementLinkObject_Unit.ObjectId IN (SELECT tmpData.UnitId FROM tmpData)
                 )
     , tmpLossList AS (SELECT Movement.UnitId                   AS UnitId
                            , tmpData.GoodsId                   AS GoodsId
                            , sum(MovementItem.Amount)::TFloat  AS AmountLoss
                       FROM tmpLoss AS Movement
                              
                            INNER JOIN tmpData ON tmpData.UnitId = Movement.UnitId
                                                               
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.ObjectId = tmpData.GoodsId
                                                   AND MovementItem.isErased = FALSE
                                                       
                       WHERE Movement.OperDate >= vbOperDate         
                       GROUP BY Movement.UnitId
                              , tmpData.GoodsId 
                      )
     , tmpLossListPrev AS (SELECT Movement.UnitId                   AS UnitId
                                , tmpData.GoodsId                   AS GoodsId
                                , Max(Movement.OperDate - ((date_part('isodow', inOperDate) - 1)||' day')::INTERVAL + INTERVAL '7 DAY')  AS OperDate
                           FROM tmpLoss AS Movement
                              
                                INNER JOIN tmpData ON tmpData.UnitId = Movement.UnitId
                                                               
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId = zc_MI_Master()
                                                       AND MovementItem.ObjectId = tmpData.GoodsId
                                                       AND MovementItem.isErased = FALSE
                                                       
                           WHERE Movement.OperDate < vbOperDate         
                           GROUP BY Movement.UnitId
                                  , tmpData.GoodsId 
                          )
     -- Предыдущие периоды
     , tmpResultPrev AS (SELECT Movement.ID                                                                    AS ID
                              , Movement.InvNumber
                              , Movement.OperDate
                              , Movement.isCurrent                                                             AS isCurrent 
                              , MovementLinkObject_From.ObjectId                                               AS UnitId
                              , MILinkObject_CommentSend.ObjectId                                              AS CommentSendID
                              , MovementItem.ObjectId                                                          AS GoodsID
                              , MovementItem.Id                                                                AS MovementItemId
                              , MovementItem.Amount                                                            AS Amount
                         FROM tmpMovement AS Movement
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                              LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                              LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE
                                                    
                              LEFT JOIN tmpLossListPrev AS tmpLossListPrev
                                                        ON tmpLossListPrev.UnitId  = MovementLinkObject_From.ObjectId 
                                                       AND tmpLossListPrev.GoodsID = MovementItem.ObjectId                                                      

                              LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                                               ON MILinkObject_CommentSend.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()

                         WHERE Movement.isCurrent = False
                           AND COALESCE (MILinkObject_CommentSend.ObjectId , 0) = 15180138 
                           AND (COALESCE (tmpLossListPrev.UnitId , 0) = 0 OR tmpLossListPrev.OperDate <= Movement.OperDate)
                         )
      , tmpDataPrevWeek AS (SELECT tmpResult.UnitId                                                                        AS UnitId
                                , tmpResult.GoodsID                                                                       AS GoodsID
                                , tmpResult.OperDate - ((date_part('isodow', tmpResult.OperDate) - 1)||' day')::INTERVAL  AS OperDate
                                , tmpResult.CommentSendID                                                                 AS CommentSendID
                                , SUM(COALESCE(tmpProtocol.AmountAuto, tmpResult.Amount ) - tmpResult.Amount)::TFloat     AS Amount
                                , SUM(COALESCE(tmpProtocol.AmountAuto, tmpResult.Amount ))::TFloat                        AS Formed
                           FROM tmpResultPrev AS tmpResult
                                LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpResult.MovementItemId
                                
                           GROUP BY tmpResult.UnitId
                                  , tmpResult.GoodsID
                                  , tmpResult.OperDate - ((date_part('isodow', tmpResult.OperDate) - 1)||' day')::INTERVAL
                                  , tmpResult.CommentSendID)
     , tmpDataPrev AS (SELECT tmpResult.UnitId                                                                        AS UnitId
                            , tmpResult.GoodsID                                                                       AS GoodsID
                            , tmpResult.CommentSendID                                                                 AS CommentSendID
                            , Max(tmpResult.Amount)::TFloat                                                           AS Amount
                            , Max(tmpResult.Amount)::TFloat                                                           AS Formed
                       FROM tmpDataPrevWeek AS tmpResult
                                
                       GROUP BY tmpResult.UnitId
                              , tmpResult.GoodsID
                              , tmpResult.CommentSendID)
     , tmpRemains AS (SELECT tmpData.GoodsId
                           , tmpData.UnitId
                           , SUM (Container.Amount)::TFloat      AS Amount
                      FROM tmpData
                           LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                              AND Container.ObjectId = tmpData.GoodsId
                                              AND Container.WhereObjectId = tmpData.UnitId
                                              AND Container.Amount <> 0
                      GROUP BY tmpData.GoodsId
                             , tmpData.UnitId
                      HAVING SUM (Container.Amount) > 0
                     )


  SELECT Object_From.Id                                                                   AS UnitId
       , Object_From.ObjectCode                                                           AS UnitCode
       , Object_From.ValueData                                                            AS UnitName
       , Object_Goods.Id                                                                  AS GoodsId
       , Object_Goods.ObjectCode                                                          AS GoodsCode
       , Object_Goods.ValueData                                                           AS GoodsName
       , tmpData.Amount                                                                   AS Amount
       , tmpData.Formed                                                                   AS Formed
       , tmpRemains.Amount                                                                AS Remains
       , tmpDataPrev.Amount                                                               AS AmountPrev
       , tmpDataPrev.Formed                                                               AS FormedPrev
       , tmpLossList.AmountLoss                                                           AS AmountLoss
       , CASE WHEN COALESCE(tmpDataPrev.Amount, 0) > 0 AND CASE WHEN COALESCE(tmpDataPrev.Amount, 0) > tmpData.Amount THEN tmpData.Amount ELSE COALESCE(tmpDataPrev.Amount, 0) END > COALESCE (tmpLossList.AmountLoss, 0)
              THEN CASE WHEN COALESCE(tmpDataPrev.Amount, 0) > tmpData.Amount THEN tmpData.Amount ELSE COALESCE(tmpDataPrev.Amount, 0) END - COALESCE (tmpLossList.AmountLoss, 0)
              ELSE 0 END::TFloat                      AS AddLoss
  FROM tmpData
       LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.UnitId
       LEFT JOIN Object AS Object_CommentSend ON Object_CommentSend.Id = tmpData.CommentSendID
       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsID
       
       LEFT JOIN tmpDataPrev AS tmpDataPrev
                             ON tmpDataPrev.UnitId  = tmpData.UnitId
                            AND tmpDataPrev.GoodsID = tmpData.GoodsID

       LEFT JOIN tmpLossList AS tmpLossList
                             ON tmpLossList.UnitId  = tmpData.UnitId
                            AND tmpLossList.GoodsID = tmpData.GoodsID
                            
       LEFT JOIN tmpRemains AS tmpRemains
                            ON tmpRemains.UnitId  = tmpData.UnitId
                           AND tmpRemains.GoodsID = tmpData.GoodsID

  ORDER BY Object_From.ValueData, Object_Goods.ValueData;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_CommentSendSUN_NonCommodityView (TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.12.19                                                       *
*/

-- тест
-- 
select * from gpReport_CommentSendSUN_NonCommodityView(inOperDate := CURRENT_DATE, inSession := '3');