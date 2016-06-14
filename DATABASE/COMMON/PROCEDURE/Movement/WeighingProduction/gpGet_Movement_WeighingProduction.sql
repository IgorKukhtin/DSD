-- Function: gpGet_Movement_WeighingProduction (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_WeighingProduction (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_WeighingProduction(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Parent TVarChar
             , isProductionIn Boolean
             , StartWeighing TDateTime, EndWeighing TDateTime
             , MovementDesc TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , UserId Integer, UserName TVarChar
             , DocumentKindId Integer, DocumentKindName TVarChar

              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY 
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_WeighingProduction_seq') AS TVarChar) AS InvNumber
             , CAST (CURRENT_DATE as TDateTime) AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName
             
             , CAST ('' as TVarChar)            AS Parent

             , FALSE AS isProductionIn
             , CAST (CURRENT_DATE as TDateTime) AS StartWeighing
             , CAST (CURRENT_DATE as TDateTime) AS EndWeighing

             , CAST (0 as TFloat)    AS MovementDesc

             , 0                     AS FromId
             , CAST ('' as TVarChar) AS FromName
             , 0                     AS ToId
             , CAST ('' as TVarChar) AS ToName

             , 0                     AS UserId
             , CAST ('' as TVarChar) AS UserName


             , 0                     AS DocumentKindId
             , CAST ('' as TVarChar) AS DocumentKindName
             
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
       RETURN QUERY 
         SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode          AS StatusCode
             , Object_Status.ValueData           AS StatusName

             , Movement_Parent.InvNumber         AS Parent
              
             , MovementBoolean_isIncome.ValueData    AS isProductionIn
             , MovementDate_StartWeighing.ValueData  AS StartWeighing  
             , MovementDate_EndWeighing.ValueData    AS EndWeighing

             , MovementFloat_MovementDesc.ValueData  AS MovementDesc

             , Object_From.Id                  AS FromId
             , Object_From.ValueData           AS FromName
             , Object_To.Id                    AS ToId
             , Object_To.ValueData             AS ToName
             
             , Object_User.Id                  AS UserId
             , Object_User.ValueData           AS UserName

             , Object_DocumentKind.Id          AS DocumentKindId
             , Object_DocumentKind.ValueData   AS DocumentKindName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId

            LEFT JOIN MovementBoolean AS MovementBoolean_isIncome
                                      ON MovementBoolean_isIncome.MovementId =  Movement.Id
                                     AND MovementBoolean_isIncome.DescId = zc_MovementBoolean_isIncome()
            LEFT JOIN MovementDate AS MovementDate_StartWeighing
                                   ON MovementDate_StartWeighing.MovementId =  Movement.Id
                                  AND MovementDate_StartWeighing.DescId = zc_MovementDate_StartWeighing()
            LEFT JOIN MovementDate AS MovementDate_EndWeighing
                                   ON MovementDate_EndWeighing.MovementId =  Movement.Id
                                  AND MovementDate_EndWeighing.DescId = zc_MovementDate_EndWeighing()
                                  
            LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                    ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                   AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
            
            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                         ON MovementLinkObject_User.MovementId = Movement.Id
                                        AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentKind
                                         ON MovementLinkObject_DocumentKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
            LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = MovementLinkObject_DocumentKind.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_WeighingProduction();
     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_WeighingProduction (Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 14.06.16         *
 13.03.14         *
*/

-- ����
-- SELECT * FROM gpGet_Movement_WeighingProduction (inMovementId:= 1, inSession:= zfCalc_UserAdmin())
