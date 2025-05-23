-- Function: gpGet_Movement_Loss (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_Loss (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Loss(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , Comment TVarChar 
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Loss());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY 
         SELECT
               0 AS Id
             --, CAST (NEXTVAL ('Movement_Loss_seq') AS TVarChar) AS InvNumber
             , CAST (lfGet_InvNumber (0, zc_Movement_Loss()) AS TVarChar) AS InvNumber
             , CASE WHEN inOperDate > CURRENT_DATE THEN CURRENT_DATE ELSE CURRENT_DATE /*inOperDate*/ END :: TDateTime AS OperDate
             , Object_Status.Code    AS StatusCode
             , Object_Status.Name    AS StatusName
            
             , 0                     AS FromId
             , CAST ('' as TVarChar) AS FromName
             , 0                     AS ToId
             , CAST ('' as TVarChar) AS ToName
           
             , CAST ('' as TVarChar) AS Comment
           
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
       RETURN QUERY 
         SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode  AS StatusCode
             , Object_Status.ValueData   AS StatusName

             , Object_From.Id            AS FromId
             , Object_From.ValueData     AS FromName
             , Object_To.Id              AS ToId
             , Object_To.ValueData       AS ToName

             , MovementString_Comment.ValueData         AS Comment
          
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
/*
            LEFT JOIN Object AS ObjectCurrencycyDocumentInf
                             ON ObjectCurrencycyDocumentInf.descid= zc_Object_Currency()
                            AND ObjectCurrencycyDocumentInf.Id = 14461*/
                  
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Loss();
     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�. 
 26.06.17         *
 08.09.17         *
 25.04.17         *
*/

-- ����
-- SELECT * FROM gpGet_Movement_Loss (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin())
