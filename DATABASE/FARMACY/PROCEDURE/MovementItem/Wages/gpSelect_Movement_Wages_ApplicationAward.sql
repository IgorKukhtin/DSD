-- Function: gpSelect_Movement_Wages_ApplicationAward()

DROP FUNCTION IF EXISTS gpSelect_Movement_Wages_ApplicationAward(TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Wages_ApplicationAward(
    IN inOperDate            TDateTime , -- Дата расчета
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());


    PERFORM  gpUpdate_MovementItem_Wages_ApplicationAward(inOperDate           := DATE_TRUNC ('MONTH', inOperDate)
                                                        , inUserID             := T1.UserId
                                                        , inApplicationAward   := T1.PenaltiMobApp
                                                        , inSession            := '3')
    FROM (
      WITH tmpApplicationAward AS (SELECT PlanMobileAppAntiTOP.UserId
                                        , PlanMobileAppAntiTOP.PenaltiMobApp
                                   FROM gpReport_FulfillmentPlanMobileAppAntiTOP(DATE_TRUNC ('MONTH', inOperDate), inSession) AS PlanMobileAppAntiTOP
                                   WHERE PlanMobileAppAntiTOP.PenaltiMobApp < 0),
           tmpMovementWages AS (SELECT Movement.Id
                                FROM Movement
                                WHERE Movement.OperDate = DATE_TRUNC ('MONTH', inOperDate)
                                  AND Movement.DescId = zc_Movement_Wages()
                                LIMIT 1),
           tnpMIWages AS (SELECT MovementItem.ObjectId              AS UserId
                               , MIFloat_ApplicationAward.ValueData AS ApplicationAward
                          FROM MovementItem
                          
                               LEFT JOIN MovementItemFloat AS MIFloat_ApplicationAward
                                                           ON MIFloat_ApplicationAward.MovementItemId = MovementItem.Id
                                                          AND MIFloat_ApplicationAward.DescId = zc_MIFloat_ApplicationAward()
                                                          
                          WHERE MovementItem.MovementID IN (SELECT tmpMovementWages.Id FROM tmpMovementWages)
                            AND MovementItem.DescId = zc_MI_Master())
                            
                            
      SELECT COALESCE (tmpApplicationAward.UserId, tnpMIWages.UserId)       AS UserId
           , COALESCE (tmpApplicationAward.PenaltiMobApp, 0)                AS PenaltiMobApp
      FROM tmpApplicationAward
      
           FULL JOIN tnpMIWages ON tnpMIWages.UserId = tmpApplicationAward.UserId
           
      WHERE COALESCE (tmpApplicationAward.PenaltiMobApp, 0) <> COALESCE (tnpMIWages.ApplicationAward, 0)) AS T1;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.06.22                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Wages_ApplicationAward (CURRENT_DATE - INTERVAL '1 DAY', inSession:= '3')      