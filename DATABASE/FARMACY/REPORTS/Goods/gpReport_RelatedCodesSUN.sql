-- Function: gpReport_RelatedCodesSUN()

DROP FUNCTION IF EXISTS gpReport_RelatedCodesSUN (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_RelatedCodesSUN(
    IN inOperDate      TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsID Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount_v1 TFloat, Amount_v1Supplement TFloat, Amount_v1UKTZED TFloat, Amount_v2 TFloat, Amount_v3 TFloat, Amount_v4 TFloat
             , Amount TFloat
              )

AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
  vbUserId:= lpGetUserBySession (inSession);
  
  inOperDate := inOperDate - ((date_part('isodow', inOperDate) - 1)||' day')::INTERVAL;
  
  IF NOT EXISTS(SELECT Movement.ID
                     , Movement.InvNumber
                     , Movement.StatusId
                     , Movement.OperDate
                FROM Movement
                     INNER JOIN MovementBoolean AS MovementBoolean_SUN
                             ON MovementBoolean_SUN.MovementId = Movement.Id
                            AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                            AND MovementBoolean_SUN.ValueData = TRUE
                     INNER JOIN MovementDate AS MovementDate_Insert
                                             ON MovementDate_Insert.MovementId = Movement.Id
                                            AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                WHERE MovementDate_Insert.ValueData BETWEEN inOperDate AND inOperDate + INTERVAL '7 DAY'
                  AND Movement.DescId = zc_Movement_Send())  
  THEN
    RAISE EXCEPTION 'В неделе с % по % перемещения по СУН не найдены', zfConvert_DateShortToString(inOperDate), zfConvert_DateShortToString(inOperDate + INTERVAL '6 DAY');  
  END IF;

  -- Результат
  RETURN QUERY
  WITH tmpMovement AS (SELECT Movement.ID
                            , Movement.InvNumber
                            , Movement.StatusId
                            , DATE_TRUNC('DAY', MovementDate_Insert.ValueData)::TDateTime AS DateSUN
                       FROM Movement
                            INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                   AND MovementBoolean_SUN.ValueData = TRUE
                            INNER JOIN MovementDate AS MovementDate_Insert
                                                    ON MovementDate_Insert.MovementId = Movement.Id
                                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                            LEFT JOIN MovementBoolean AS MovementBoolean_NotDisplaySUN
                                   ON MovementBoolean_NotDisplaySUN.MovementId = Movement.Id
                                  AND MovementBoolean_NotDisplaySUN.DescId = zc_MovementBoolean_NotDisplaySUN()
                       WHERE MovementDate_Insert.ValueData BETWEEN inOperDate AND inOperDate + INTERVAL '7 DAY'
                         AND Movement.DescId = zc_Movement_Send()
                         AND COALESCE (MovementBoolean_NotDisplaySUN.valuedata, FALSE) = FALSE)
     , tmpMIAll AS (SELECT Movement.ID                                                                    AS ID
                         , MovementItem.ObjectId                                                          AS GoodsID
                         , MovementItem.Id                                                                AS MovementItemId
                         , MovementItem.Amount                                                            AS Amount
                    FROM tmpMovement AS Movement
                         LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                               AND MovementItem.DescId = zc_MI_Master()
                     )
     , tmpProtocolAll AS (SELECT MovementItem.MovementItemId
                               , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                               , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                          FROM tmpMIAll AS MovementItem

                               INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.MovementItemId
                                                              AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                                              AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                          )
     , tmpProtocol AS (SELECT tmpProtocolAll.MovementItemId
                            , SUBSTRING(tmpProtocolAll.ProtocolData, 1, POSITION('"' IN tmpProtocolAll.ProtocolData) - 1)::TFloat AS AmountAuto
                       FROM tmpProtocolAll
                       WHERE tmpProtocolAll.Ord = 1)
     , tmpMI AS (SELECT MovementItem.GoodsID                                                           AS GoodsID
                      , SUM(COALESCE(tmpProtocol.AmountAuto, MovementItem.Amount))::TFloat             AS Amount
                      , SUM(CASE WHEN COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE) = FALSE
                                  AND COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE) = FALSE
                                  AND COALESCE (MovementBoolean_SUN_v4.ValueData, FALSE) = FALSE
                                  AND COALESCE (MovementString_Comment.ValueData,'') <> 'Распределение товара по сети согласно дополнению к СУН1'   
                                  AND COALESCE (MovementString_Comment.ValueData,'') <> 'Перемещение по УКТВЭД'   
                                 THEN COALESCE(tmpProtocol.AmountAuto, MovementItem.Amount) END)::TFloat             AS Amount_v1
                      , SUM(CASE WHEN COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE) = FALSE
                                  AND COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE) = FALSE
                                  AND COALESCE (MovementBoolean_SUN_v4.ValueData, FALSE) = FALSE
                                  AND COALESCE (MovementString_Comment.ValueData,'') = 'Распределение товара по сети согласно дополнению к СУН1'   
                                 THEN COALESCE(tmpProtocol.AmountAuto, MovementItem.Amount) END)::TFloat             AS Amount_v1Supplement
                      , SUM(CASE WHEN COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE) = FALSE
                                  AND COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE) = FALSE
                                  AND COALESCE (MovementBoolean_SUN_v4.ValueData, FALSE) = FALSE
                                  AND COALESCE (MovementString_Comment.ValueData,'') = 'Перемещение по УКТВЭД'   
                                 THEN COALESCE(tmpProtocol.AmountAuto, MovementItem.Amount) END)::TFloat             AS Amount_v1UKTZED
                      , SUM(CASE WHEN COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE) = True 
                                 THEN COALESCE(tmpProtocol.AmountAuto, MovementItem.Amount) END)::TFloat             AS Amount_v2
                      , SUM(CASE WHEN COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE) = True 
                                 THEN COALESCE(tmpProtocol.AmountAuto, MovementItem.Amount) END)::TFloat             AS Amount_v3
                      , SUM(CASE WHEN COALESCE (MovementBoolean_SUN_v4.ValueData, FALSE) = True 
                                 THEN COALESCE(tmpProtocol.AmountAuto, MovementItem.Amount) END)::TFloat             AS Amount_v4
                      
                 FROM tmpMIAll AS MovementItem

                      LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = MovementItem.MovementItemId

                      LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                                ON MovementBoolean_SUN_v2.MovementId = MovementItem.Id
                                               AND MovementBoolean_SUN_v2.DescId = zc_MovementBoolean_SUN_v2()
                 
                      LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                                ON MovementBoolean_SUN_v3.MovementId = MovementItem.Id
                                               AND MovementBoolean_SUN_v3.DescId = zc_MovementBoolean_SUN_v3()

                      LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v4
                                                ON MovementBoolean_SUN_v4.MovementId = MovementItem.Id
                                               AND MovementBoolean_SUN_v4.DescId = zc_MovementBoolean_SUN_v3()

                      LEFT JOIN MovementString AS MovementString_Comment
                                               ON MovementString_Comment.MovementId = MovementItem.Id
                                              AND MovementString_Comment.DescId = zc_MovementString_Comment()

                 GROUP BY MovementItem.GoodsID  
                 )



  SELECT MovementItem.GoodsID
       , Object_Goods.ObjectCode                                                           AS GoodsCode
       , Object_Goods.ValueData                                                            AS GoodsName       
       , MovementItem.Amount_v1
       , MovementItem.Amount_v1Supplement
       , MovementItem.Amount_v1UKTZED
       , MovementItem.Amount_v2
       , MovementItem.Amount_v3
       , MovementItem.Amount_v4
       , MovementItem.Amount
  FROM tmpMI AS MovementItem

       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsID

  WHERE COALESCE ( MovementItem.Amount_v1, 0) <> 0 AND COALESCE (MovementItem.Amount_v1, 0) <> COALESCE (MovementItem.Amount, 0)
     OR COALESCE ( MovementItem.Amount_v1Supplement, 0) <> 0 AND COALESCE (MovementItem.Amount_v1Supplement, 0) <> COALESCE (MovementItem.Amount, 0)
     OR COALESCE ( MovementItem.Amount_v1UKTZED, 0) <> 0 AND COALESCE (MovementItem.Amount_v1UKTZED, 0) <> COALESCE (MovementItem.Amount, 0)
     OR COALESCE ( MovementItem.Amount_v2, 0) <> 0 AND COALESCE (MovementItem.Amount_v2, 0) <> COALESCE (MovementItem.Amount, 0)
     OR COALESCE ( MovementItem.Amount_v3, 0) <> 0 AND COALESCE (MovementItem.Amount_v3, 0) <> COALESCE (MovementItem.Amount, 0)
     OR COALESCE ( MovementItem.Amount_v4, 0) <> 0 AND COALESCE (MovementItem.Amount_v4, 0) <> COALESCE (MovementItem.Amount, 0)
  ORDER BY Object_Goods.ValueData;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_RelatedCodesSUN (TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.11.21                                                       *
*/

-- тест
--

select * from gpReport_RelatedCodesSUN(inOperDate := ('09.11.2021')::TDateTime ,  inSession := '3');