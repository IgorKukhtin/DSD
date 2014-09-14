-- Function: gpGet_Movement_PersonalService()

DROP FUNCTION IF EXISTS gpGet_Movement_PersonalService (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PersonalService(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ServiceDate TDateTime
             , Comment TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_PersonalService());
     vbUserId := lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_PersonalService_seq') AS TVarChar) AS InvNumber
             , inOperDate               AS OperDate
             , Object_Status.Code       AS StatusCode
             , Object_Status.Name       AS StatusName

             , DATE_TRUNC ('MONTH', inOperDate) :: TDateTime  AS ServiceDate 
             , CAST ('' AS TVarChar)    AS Comment
             , 0                     	AS PersonalServiceListId
             , CAST ('' AS TVarChar) 	AS PersonalServiceListName

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS Object_Status;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                          AS Id
           , Movement.InvNumber                   AS InvNumber
           , Movement.OperDate                    AS OperDate
           , Object_Status.ObjectCode             AS StatusCode
           , Object_Status.ValueData              AS StatusName
           , COALESCE (MovementDate_ServiceDate.ValueData, DATE_TRUNC ('MONTH', Movement.OperDate)) :: TDateTime AS ServiceDate 
           , MovementString_Comment.ValueData     AS Comment
           , Object_PersonalServiceList.Id        AS PersonalServiceListId
           , Object_PersonalServiceList.ValueData AS PersonalServiceListName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                   ON MovementDate_ServiceDate.MovementId = Movement.Id
                                  AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
                                  
            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
   
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                         ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId

       WHERE Movement.Id =  inMovementId;

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_PersonalService (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.09.14         *
*/

-- ����
-- SELECT * FROM gpGet_Movement_PersonalService (inMovementId:= 1, inOperDate:= NULL, inSession:= zfCalc_UserAdmin())