-- Function: gpSelect_Movement_PUSH()

DROP FUNCTION IF EXISTS gpSelect_Movement_PUSH (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PUSH(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TVarChar
             , StatusCode Integer
             , StatusName TVarChar
             , DateEndPUSH TVarChar
             , Replays Integer
             , Daily Boolean
             , isPoll Boolean
             , Message TBlob

             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbUnitId Integer;
BEGIN

     vbUserId:= lpGetUserBySession (inSession);

     -- Ðåçóëüòàò
     RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        -- Ðåçóëüòàò
        SELECT
            Movement.Id                                                AS ID
          , Movement.InvNumber                                         AS InvNumber
          , to_char(Movement.OperDate, 'DD.MM.YYYY HH24:MI:SS')::TVarChar AS OperDate
          , Object_Status.ObjectCode                                   AS StatusCode
          , Object_Status.ValueData                                    AS StatusName
          , to_char(COALESCE(MovementDate_DateEndPUSH.ValueData,
            date_trunc('day', Movement.OperDate + INTERVAL '1 DAY')), 
            'DD.MM.YYYY HH24:MI:SS')::TVarChar                         AS DateEndPUSH
          , COALESCE(MovementFloat_Replays.ValueData, 1)::Integer      AS Replays  
          , COALESCE(MovementBoolean_Daily.ValueData, False)           AS Daily
          , COALESCE(MovementBoolean_Poll.ValueData, False)            AS isPoll

          , COALESCE(NULLIF(MovementString_Function.ValueData, ''), NULLIF(MovementBlob_Message.ValueData, ''), MovementString_Form.ValueData)::TBlob AS Message

          , Object_Insert.ValueData                                    AS InsertName
          , MovementDate_Insert.ValueData                              AS InsertDate
          , Object_Update.ValueData                                    AS UpdateName
          , MovementDate_Update.ValueData                              AS UpdateDate
        FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            INNER JOIN tmpStatus ON Movement.StatusId = tmpStatus.StatusId
            
            LEFT JOIN MovementFloat AS MovementFloat_Replays
                                   ON MovementFloat_Replays.MovementId = Movement.Id
                                  AND MovementFloat_Replays.DescId = zc_MovementFloat_Replays()
            
            LEFT JOIN MovementBlob AS MovementBlob_Message
                                   ON MovementBlob_Message.MovementId = Movement.Id
                                  AND MovementBlob_Message.DescId = zc_MovementBlob_Message()

            LEFT JOIN MovementDate AS MovementDate_DateEndPUSH
                                   ON MovementDate_DateEndPUSH.MovementId = Movement.Id
                                  AND MovementDate_DateEndPUSH.DescId = zc_MovementDate_DateEndPUSH()
                                              
            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementBoolean AS MovementBoolean_Daily
                                      ON MovementBoolean_Daily.MovementId = Movement.Id
                                     AND MovementBoolean_Daily.DescId = zc_MovementBoolean_PUSHDaily()

            LEFT JOIN MovementBoolean AS MovementBoolean_Poll
                                      ON MovementBoolean_Poll.MovementId = Movement.Id
                                     AND MovementBoolean_Poll.DescId = zc_MovementBoolean_Poll()

            LEFT JOIN MovementString AS MovementString_Function
                                     ON MovementString_Function.MovementId = Movement.Id
                                    AND MovementString_Function.DescId = zc_MovementString_Function()

            LEFT JOIN MovementString AS MovementString_Form
                                     ON MovementString_Form.MovementId = Movement.Id
                                    AND MovementString_Form.DescId = zc_MovementString_Form()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
          AND Movement.DescId = zc_Movement_PUSH();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_PUSH (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Øàáëèé Î.Â.
 05.03.20        *
 11.05.19         *
 10.03.19         *
*/

-- òåñò
-- SELECT * FROM gpSelect_Movement_PUSH (inStartDate:= '01.08.2016', inEndDate:= '01.08.2020', inIsErased := FALSE, inSession:= zfCalc_UserAdmin());

select * from gpSelect_Movement_PUSH(inStartDate := ('01.10.2017')::TDateTime , inEndDate := ('30.04.2025')::TDateTime , inIsErased := 'False' ,  inSession := '3');