-- Function: gpGet_Movement_Pretension_PUSH_Actual()

DROP FUNCTION IF EXISTS gpGet_Movement_Pretension_PUSH_Actual (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Pretension_PUSH_Actual(
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
       tmpMovement AS (SELECT Movement_Pretension.*
                            , Object_To.ValueData                        AS ToName  
                       FROM Movement AS Movement_Pretension
                                                            
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                       ON MovementLinkObject_From.MovementId = Movement_Pretension.Id
                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                           LEFT JOIN MovementDate AS MovementDate_Branch
                                                  ON MovementDate_Branch.MovementId = Movement_Pretension.Id
                                                 AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement_Pretension.Id
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                           LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
                       WHERE Movement_Pretension.DescId = zc_Movement_Pretension()
                         AND Movement_Pretension.StatusId = zc_Enum_Status_UnComplete()
                         AND Movement_Pretension.OperDate BETWEEN CURRENT_DATE - INTERVAL '2 MONTH' AND CURRENT_DATE + INTERVAL '1 MONTH'
                         AND MovementLinkObject_From.ObjectId = vbUnitId
                         AND MovementDate_Branch.ValueData IS NULL)
      , tmpMI AS (SELECT Movement_Pretension.Id
                       , SUM(CASE WHEN MIBoolean_Checked.ValueData = True THEN 1 ELSE 0 END)      AS Checked
                       , Count(MI_Pretension.Id)::Integer                                         AS CountMI
                  FROM tmpMovement AS Movement_Pretension

                       LEFT JOIN MovementItem AS MI_Pretension
                                               ON MI_Pretension.MovementId = Movement_Pretension.Id
                                              AND MI_Pretension.isErased  = FALSE
                                              AND MI_Pretension.DescId     = zc_MI_Master()
                       LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                     ON MIBoolean_Checked.MovementItemId = MI_Pretension.Id
                                                    AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()

                  GROUP BY Movement_Pretension.Id
                  )
                         
       SELECT string_agg('Номер: '||Movement.InvNumber||' дата: '||TO_CHAR (Movement.OperDate, 'dd.mm.yyyy')||' поставщик: '||Movement.ToName, CHR(13))
       INTO outMessage
       FROM tmpMovement AS Movement

            INNER JOIN Movement_Pretension_View ON Movement_Pretension_View.Id = Movement.Id
       
            LEFT JOIN tmpMI ON tmpMI.ID = Movement.Id
            
       WHERE COALESCE (tmpMI.Checked, 1) > 0 OR 
             COALESCE (tmpMI.CountMI, 0) = 0 AND COALESCE (Movement_Pretension_View.Comment::Text, '') <> ''
       ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Pretension_PUSH_Actual (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 19.11.21                                                                     *
*/

-- тест
-- 
SELECT * FROM gpGet_Movement_Pretension_PUSH_Actual (inSession:= '3')