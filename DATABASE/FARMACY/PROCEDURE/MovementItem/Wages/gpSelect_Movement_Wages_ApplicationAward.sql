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
                                                        , inApplicationAward   := T1.ApplicationAward
                                                        , inSession            := '3')
    FROM (
      WITH tmpMovementAll AS (SELECT MovementLinkObject.ObjectId                                     AS UserId
                                   , MovementLinkObject.MovementId
                              FROM MovementLinkObject
                              WHERE MovementLinkObject.DescId = zc_MovementLinkObject_UserReferals()),
           tmpMovement AS (SELECT MovementLinkObject.UserId                                       AS UserId
                                , DATE_TRUNC('MONTH', Movement.OperDate)                          AS OperDate
                                , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                                            MovementString_BayerPhone.ValueData)::TVarChar        AS BayerPhone
                                , ROW_NUMBER() OVER (PARTITION BY COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                                                                           MovementString_BayerPhone.ValueData) ORDER BY Movement.ID DESC) AS Ord
                           FROM tmpMovementAll AS MovementLinkObject

                                INNER JOIN Movement ON Movement.Id = MovementLinkObject.MovementId
                                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                  
                                LEFT JOIN MovementString AS MovementString_BayerPhone
                                                         ON MovementString_BayerPhone.MovementId = Movement.Id
                                                        AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()

                                LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                                             ON MovementLinkObject_BuyerForSite.MovementId = Movement.Id
                                                            AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
                                LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
                                LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                                       ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                                      AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()
                           ),
           tmpApplicationAward AS (SELECT tmpMovement.UserId
                                        , (COUNT(*) * 20)::TFloat  AS ApplicationAward
                                   FROM tmpMovement
                                   WHERE tmpMovement.Ord = 1  
                                     AND tmpMovement.OperDate = DATE_TRUNC ('MONTH', inOperDate)   
                                   GROUP BY tmpMovement.UserId),
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
           , COALESCE (tmpApplicationAward.ApplicationAward, 0)             AS ApplicationAward
      FROM tmpApplicationAward
      
           FULL JOIN tnpMIWages ON tnpMIWages.UserId = tmpApplicationAward.UserId
           
      WHERE COALESCE (tmpApplicationAward.ApplicationAward, 0)  <> COALESCE (tnpMIWages.ApplicationAward, 0)) AS T1;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.06.22                                                        *
*/

-- тест
-- 
SELECT * FROM gpSelect_Movement_Wages_ApplicationAward (CURRENT_DATE, inSession:= '3')      