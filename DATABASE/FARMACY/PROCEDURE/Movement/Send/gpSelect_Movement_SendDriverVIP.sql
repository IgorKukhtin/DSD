-- Function: gpSelect_Movement_SendDriverVIP()

DROP FUNCTION IF EXISTS gpSelect_Movement_SendDriverVIP (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SendDriverVIP(
    IN inOperDate      TDateTime , --
    IN inDriver        Integer   , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (isUrgently Boolean,
               FromName TVarChar,
               ToName TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
       SELECT
             COALESCE (MovementBoolean_Urgently.ValueData, FALSE)::Boolean AS isUrgently
           , Object_From.ValueData                                         AS FromName
           , Object_To.ValueData                                           AS ToName

       FROM (SELECT Movement.id
             FROM Movement
                  INNER JOIN MovementBoolean AS MovementBoolean_VIP
                                             ON MovementBoolean_VIP.MovementId = Movement.Id
                                            AND MovementBoolean_VIP.DescId = zc_MovementBoolean_VIP()
                                            AND MovementBoolean_VIP.ValueData = True
                  INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                             ON MovementBoolean_Deferred.MovementId = Movement.Id
                                            AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                            AND MovementBoolean_Deferred.ValueData = True
                  LEFT JOIN MovementBoolean AS MovementBoolean_Sent
                                            ON MovementBoolean_Sent.MovementId = Movement.Id
                                           AND MovementBoolean_Sent.DescId = zc_MovementBoolean_Sent()
             WHERE  Movement.DescId = zc_Movement_Send()
                AND Movement.StatusId = zc_Enum_Status_UnComplete()
                AND COALESCE (MovementBoolean_Sent.ValueData, FALSE) = False
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id


            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Driver
                                 ON ObjectLink_Driver.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Driver.DescId = zc_ObjectLink_Unit_Driver()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementBoolean AS MovementBoolean_Urgently
                                      ON MovementBoolean_Urgently.MovementId = Movement.Id
                                     AND MovementBoolean_Urgently.DescId = zc_MovementBoolean_Urgently()

            LEFT JOIN MovementDate AS MovementDate_Deferred
                                   ON MovementDate_Deferred.MovementId = Movement.Id
                                  AND MovementDate_Deferred.DescId = zc_MovementDate_Deferred()

       WHERE (ObjectLink_Driver.ChildObjectId = inDriver OR inDriver = 0)
         AND MovementDate_Deferred.ValueData >= inOperDate
       GROUP BY COALESCE (MovementBoolean_Urgently.ValueData, FALSE)::Boolean
           , Object_From.ValueData
           , Object_To.ValueData
       ORDER BY 1 DESC, 2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_SendDriverVIP (TDateTime, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.05.20                                                       * zc_MovementBoolean_Received

*/

-- тест
--
SELECT * FROM gpSelect_Movement_SendDriverVIP (inOperDate := '01.01.2020',inDriver := 0, inSession:= '3')