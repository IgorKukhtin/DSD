-- Function: gpReport_Top100GoodsSUN()

DROP FUNCTION IF EXISTS gpReport_Top100GoodsSUN (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Top100GoodsSUN(
    IN inТop           Integer,  
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Ord Integer
             , GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , AmountV1 TFloat
             , AmountV1_PartionDate TFloat
             , AmountV1_Supplement TFloat
             , AmountV1_SUA TFloat
             , AmountV1_UKTZED TFloat
             , AmountV2 TFloat
             , AmountV3 TFloat
             , AmountV4 TFloat      
             , Price TFloat, Summa TFloat
              )

AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
  vbUserId:= lpGetUserBySession (inSession);

  -- Результат
  RETURN QUERY
  WITH tmpMovement AS (SELECT MovementBoolean_SUN.MovementID
                       FROM MovementBoolean AS MovementBoolean_SUN
                       WHERE MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                         AND MovementBoolean_SUN.ValueData = TRUE)
     , tmpMIPartionDate AS (SELECT DISTINCT MovementItem.ParentId AS MovementItemId
                            FROM tmpMovement
                                 INNER JOIN Movement ON Movement.Id = tmpMovement.MovementID
                                                    AND Movement.DescId = zc_Movement_Send()
                                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                  

                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.ID
                                                        AND MovementItem.DescId = zc_MI_Child()
                                                        AND MovementItem.isErased = FALSE
                                                        AND MovementItem.Amount > 0 
                            )
     
     , tmpMI AS (SELECT Movement.ID                                                                    AS ID
                      , Movement.InvNumber
                      , Movement.OperDate
                      , MovementItem.ObjectId                                                          AS GoodsID
                      , MovementItem.Id                                                                AS MovementItemId
                      , MovementItem.Amount                                                            AS Amount
                      , COALESCE(MIFloat_PriceTo.ValueData,0)                                          AS Price
                      
                      , CASE WHEN COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE) = FALSE AND
                                  COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE) = FALSE AND
                                  COALESCE (MovementBoolean_SUN_v4.ValueData, FALSE) = FALSE AND
                                  COALESCE (MovementString_Comment.ValueData,'') <> 'Распределение товара по сети согласно дополнению к СУН1' AND
                                  COALESCE (MovementString_Comment.ValueData,'') <> 'Товар по СУА' AND
                                  COALESCE (MovementString_Comment.ValueData,'') <> 'Перемещение по УКТВЭД' AND
                                  COALESCE (tmpMIPartionDate.MovementItemId, 0) = 0
                             THEN MovementItem.Amount END                                              AS AmountV1
                      , CASE WHEN COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE) = FALSE AND
                                  COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE) = FALSE AND
                                  COALESCE (MovementBoolean_SUN_v4.ValueData, FALSE) = FALSE AND
                                  COALESCE (MovementString_Comment.ValueData,'') <> 'Распределение товара по сети согласно дополнению к СУН1' AND
                                  COALESCE (MovementString_Comment.ValueData,'') <> 'Товар по СУА' AND
                                  COALESCE (MovementString_Comment.ValueData,'') <> 'Перемещение по УКТВЭД' AND
                                  COALESCE (tmpMIPartionDate.MovementItemId, 0) <> 0
                             THEN MovementItem.Amount END                                              AS AmountV1_PartionDate
                      , CASE WHEN COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE) = FALSE AND
                                  COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE) = FALSE AND
                                  COALESCE (MovementBoolean_SUN_v4.ValueData, FALSE) = FALSE AND 
                                  COALESCE (MovementString_Comment.ValueData,'') = 'Распределение товара по сети согласно дополнению к СУН1' 
                             THEN MovementItem.Amount END                                              AS AmountV1_Supplement
                      , CASE WHEN COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE) = FALSE AND
                                  COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE) = FALSE AND
                                  COALESCE (MovementBoolean_SUN_v4.ValueData, FALSE) = FALSE AND 
                                  COALESCE (MovementString_Comment.ValueData,'') = 'Товар по СУА' 
                             THEN MovementItem.Amount END                                              AS AmountV1_SUA
                      , CASE WHEN COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE) = FALSE AND
                                  COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE) = FALSE AND
                                  COALESCE (MovementBoolean_SUN_v4.ValueData, FALSE) = FALSE AND 
                                  COALESCE (MovementString_Comment.ValueData,'') = 'Перемещение по УКТВЭД' 
                             THEN MovementItem.Amount END                                              AS AmountV1_UKTZED
                      , CASE WHEN COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE) = TRUE THEN MovementItem.Amount END  AS AmountV2
                      , CASE WHEN COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE) = TRUE THEN MovementItem.Amount END  AS AmountV3
                      , CASE WHEN COALESCE (MovementBoolean_SUN_v4.ValueData, FALSE) = TRUE THEN MovementItem.Amount END  AS AmountV4
                 FROM tmpMovement
                 
                      INNER JOIN Movement ON Movement.Id = tmpMovement.MovementID
                                         AND Movement.DescId = zc_Movement_Send()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                      
                      INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                             AND MovementItem.DescId = zc_MI_Master()
                                             AND MovementItem.isErased = FALSE
                                             AND MovementItem.Amount > 0 

                      LEFT JOIN tmpMIPartionDate ON tmpMIPartionDate.MovementItemId = MovementItem.Id

                      LEFT JOIN MovementItemFloat AS MIFloat_PriceTo
                                                  ON MIFloat_PriceTo.MovementItemId = MovementItem.ID
                                                 AND MIFloat_PriceTo.DescId = zc_MIFloat_PriceTo()
                                                 
                      LEFT JOIN MovementString AS MovementString_Comment
                                               ON MovementString_Comment.MovementId = Movement.Id
                                              AND MovementString_Comment.DescId = zc_MovementString_Comment()

                      LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                                ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                               AND MovementBoolean_SUN_v2.DescId = zc_MovementBoolean_SUN_v2()
                      LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                                ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                               AND MovementBoolean_SUN_v3.DescId = zc_MovementBoolean_SUN_v3()
                      LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v4
                                                ON MovementBoolean_SUN_v4.MovementId = Movement.Id
                                               AND MovementBoolean_SUN_v4.DescId = zc_MovementBoolean_SUN_v4()
                 )     
     , tmpMISum AS (SELECT tmpMI.GoodsID                                        AS GoodsID
                         , SUM(tmpMI.Amount)::TFloat                            AS Amount
                         , SUM(tmpMI.AmountV1)::TFloat                          AS AmountV1
                         , SUM(tmpMI.AmountV1_PartionDate)::TFloat              AS AmountV1_PartionDate
                         , SUM(tmpMI.AmountV1_Supplement)::TFloat               AS AmountV1_Supplement
                         , SUM(tmpMI.AmountV1_SUA)::TFloat                      AS AmountV1_SUA
                         , SUM(tmpMI.AmountV1_UKTZED)::TFloat                   AS AmountV1_UKTZED
                         , SUM(tmpMI.AmountV2)::TFloat                          AS AmountV2
                         , SUM(tmpMI.AmountV3)::TFloat                          AS AmountV3
                         , SUM(tmpMI.AmountV4)::TFloat                          AS AmountV4
                         , SUM(ROUND(tmpMI.Price * tmpMI.Amount, 2))::TFloat    AS Summa
                    FROM tmpMI
                    GROUP BY tmpMI.GoodsID
                    ORDER BY 2 DESC  
                    LIMIT inТop)

  SELECT ROW_NUMBER() OVER (ORDER BY tmpMISum.Amount DESC)::Integer  AS Ord
       , Object_Goods.ObjectCode                                     AS GoodsCode
       , Object_Goods.ValueData                                      AS GoodsName
       , tmpMISum.Amount                                             AS Amount
       , tmpMISum.AmountV1                                           AS AmountV1
       , tmpMISum.AmountV1_PartionDate                               AS AmountV1_PartionDate
       , tmpMISum.AmountV1_Supplement                                AS AmountV1_Supplement
       , tmpMISum.AmountV1_SUA                                       AS AmountV1_SUA
       , tmpMISum.AmountV1_UKTZED                                    AS AmountV1_UKTZED
       , tmpMISum.AmountV2                                           AS AmountV2
       , tmpMISum.AmountV3                                           AS AmountV3
       , tmpMISum.AmountV4                                           AS AmountV4
       , ROUND(tmpMISum.Summa / tmpMISum.Amount, 2)::TFloat          AS Price
       , tmpMISum.Summa                                              AS Summa
  FROM tmpMISum

       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMISum.GoodsID

  ORDER BY tmpMISum.Amount DESC;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Top100GoodsSUN (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.08.21                                                       *
*/

-- тест
--

select * from gpReport_Top100GoodsSUN(inТop := 100, inSession := '3');