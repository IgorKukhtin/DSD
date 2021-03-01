-- Function: gpReport_HammerTimeSUN()

DROP FUNCTION IF EXISTS gpReport_HammerTimeSUN (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_HammerTimeSUN(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitCode Integer, UnitName TVarChar
             , InvNumber TVarChar, OperDate TDateTime
             , isSUN Boolean, isSUN_v2 Boolean, isSUN_v3 Boolean, isSUN_v4 Boolean
             , Comment TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , Price TFloat, Amount TFloat, Summa TFloat
             , HammerTime Integer
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
  WITH tmpMovement AS (SELECT Movement.ID
                            , Movement.InvNumber
                            , Movement.StatusId
                            , Movement.OperDate
                            , MovementDate_Insert.ValueData  AS Date_Insert
                       FROM Movement
                            INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                   AND MovementBoolean_SUN.ValueData = TRUE
                            INNER JOIN MovementDate AS MovementDate_Insert
                                                    ON MovementDate_Insert.MovementId = Movement.Id
                                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                       WHERE MovementDate_Insert.ValueData BETWEEN inStartDate AND inEndDate + INTERVAL '1 DAY'
                         AND Movement.DescId = zc_Movement_Send())
     , tmpMI AS (SELECT Movement.ID                                                                    AS ID
                      , Movement.InvNumber
                      , Movement.OperDate
                      , MovementLinkObject_From.ObjectId                                               AS UnitId
                      , MovementItem.Id                                                                AS MovementItemId
                      , MIC.ContainerId                                                                AS ContainerId
                      , MovementItem.ObjectId                                                          AS GoodsID
                      , -1.0 * MIC.Amount                                                              AS Amount
                      , COALESCE(MIFloat_PriceFrom.ValueData,0)                                        AS Price
                      , Movement.Date_Insert                                                           AS Date_Insert
                      , Max(MovementDate_Insert.ValueData)                                             AS DateIncome
                 FROM tmpMovement AS Movement
                      INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                    ON MovementLinkObject_From.MovementId = Movement.Id
                                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                      INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                             AND MovementItem.DescId = zc_MI_Master()
                                             AND MovementItem.isErased = FALSE

                      LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceFrom
                                                        ON MIFloat_PriceFrom.MovementItemId = MovementItem.ID
                                                       AND MIFloat_PriceFrom.DescId = zc_MIFloat_PriceFrom()

                      INNER JOIN MovementItemContainer AS MIC
                                                       ON MIC.MovementItemId = MovementItem.Id
                                                      AND MIC.DescId = zc_MIContainer_Count()
                                                      AND MIC.Amount < 0

                      INNER JOIN MovementItemContainer AS MICIn
                                                       ON MICIn.ContainerId = MIC.ContainerId
                                                      AND MICIn.DescId = zc_MIContainer_Count()
                                                      AND MICIn.MovementDescId = zc_Movement_Send()
                                                      AND MICIn.Amount > 0
                                                      AND MICIn.OperDate < Movement.Date_Insert
                      INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                 ON MovementBoolean_SUN.MovementId = MICIn.MovementId
                                                AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                AND MovementBoolean_SUN.ValueData = True
                      INNER JOIN MovementDate AS MovementDate_Insert
                                              ON MovementDate_Insert.MovementId = MICIn.MovementId
                                             AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                 GROUP BY Movement.ID
                        , Movement.InvNumber
                        , Movement.OperDate
                        , MovementLinkObject_From.ObjectId
                        , MovementItem.Id
                        , MIC.ContainerId
                        , MovementItem.ObjectId
                        , MIC.Amount
                        , COALESCE(MIFloat_PriceFrom.ValueData,0)
                        , Movement.Date_Insert             
                 )

  SELECT tmpMI.Id
       , Object_From.ObjectCode                                                           AS UnitCode
       , Object_From.ValueData                                                            AS UnitName
       , tmpMI.InvNumber
       , tmpMI.OperDate
       , COALESCE (MovementBoolean_SUN.ValueData, FALSE)     AS isSUN
       , COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE)  AS isSUN_v2
       , COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE)  AS isSUN_v3
       , COALESCE (MovementBoolean_SUN_v4.ValueData, FALSE)  AS isSUN_v4
       , COALESCE (MovementString_Comment.ValueData,'')     :: TVarChar AS Comment

       , Object_Goods.ObjectCode                                                          AS GoodsCode
       , Object_Goods.ValueData                                                           AS GoodsName
       , tmpMI.Price::TFloat                                                              AS Price
       , tmpMI.Amount::TFloat                                                             AS Amount
       , ROUND(tmpMI.Price * tmpMI.Amount, 2)::TFloat                                     AS Summa
       , DATE_PART('day', tmpMI.Date_Insert - tmpMI.DateIncome)::Integer
  FROM tmpMI
       LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMI.UnitId
       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsID
       LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                 ON MovementBoolean_SUN.MovementId = tmpMI.Id
                                AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()

       LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                 ON MovementBoolean_SUN_v2.MovementId = tmpMI.Id
                                AND MovementBoolean_SUN_v2.DescId = zc_MovementBoolean_SUN_v2()
 
       LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                 ON MovementBoolean_SUN_v3.MovementId = tmpMI.Id
                                AND MovementBoolean_SUN_v3.DescId = zc_MovementBoolean_SUN_v3()

       LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v4
                                 ON MovementBoolean_SUN_v4.MovementId = tmpMI.Id
                                AND MovementBoolean_SUN_v4.DescId = zc_MovementBoolean_SUN_v3()

      LEFT JOIN MovementString AS MovementString_Comment
                               ON MovementString_Comment.MovementId = tmpMI.Id
                              AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                
  ORDER BY Object_From.ValueData, tmpMI.Id;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_HammerTimeSUN (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.03.21                                                       *
*/

-- тест
--

select * from gpReport_HammerTimeSUN(inStartDate := ('01.01.2021')::TDateTime , inEndDate := ('22.02.2021')::TDateTime ,  inSession := '3');