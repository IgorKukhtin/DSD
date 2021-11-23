-- Function: gpGet_Movement_ReturnOut_PUSH_NotGiven()

DROP FUNCTION IF EXISTS gpGet_Movement_ReturnOut_PUSH_NotGiven (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ReturnOut_PUSH_NotGiven(
   OUT outMessage      TEXT ,      -- 
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TEXT
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbUnitId   Integer;
   DECLARE vbUnitKey  TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     vbUnitKey := COALESCE (lpGet_DefaultValue ('zc_Object_Unit', vbUserId), '');
     vbUnitId  := CASE WHEN vbUnitKey = '' THEN 0 ELSE vbUnitKey :: Integer END;

     outMessage := '';
     
     
     IF vbUnitId = 0
     THEN
       RETURN;
     END IF;

     WITH 
       tmpMovement AS (SELECT Movement_ReturnOut.*
                            , Object_To.ValueData                        AS ToName  
                       FROM Movement AS Movement_ReturnOut
                                                            
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                       ON MovementLinkObject_From.MovementId = Movement_ReturnOut.Id
                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                           LEFT JOIN MovementDate AS MovementDate_Branch
                                                  ON MovementDate_Branch.MovementId = Movement_ReturnOut.Id
                                                 AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

                           LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                     ON MovementBoolean_Deferred.MovementId = Movement_ReturnOut.Id
                                                    AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement_ReturnOut.Id
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                           LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
                       WHERE Movement_ReturnOut.DescId = zc_Movement_ReturnOut()
                         AND Movement_ReturnOut.StatusId = zc_Enum_Status_UnComplete()
                         AND Movement_ReturnOut.OperDate BETWEEN CURRENT_DATE - INTERVAL '2 MONTH' AND CURRENT_DATE + INTERVAL '1 MONTH'
                         AND MovementLinkObject_From.ObjectId = vbUnitId
                         AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = TRUE
                         AND MovementDate_Branch.ValueData IS NULL)
                         
       SELECT string_agg('Номер: '||Movement.InvNumber||' дата: '||TO_CHAR (Movement.OperDate, 'dd.mm.yyyy')||' поставщик: '||Movement.ToName, CHR(13))
       INTO outMessage
       FROM tmpMovement AS Movement;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_ReturnOut_PUSH_NotGiven (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 19.11.21                                                                     *
*/

-- тест
-- 
SELECT * FROM gpGet_Movement_ReturnOut_PUSH_NotGiven (inSession:= '3')