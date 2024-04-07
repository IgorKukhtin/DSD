-- Function: gpSelect_Movement_FounderService()

DROP FUNCTION IF EXISTS gpSelect_Movement_FounderService (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_FounderService (TDateTime, TDateTime, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_FounderService(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer   , -- ������� ��.����
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Amount TFloat
             , Comment TVarChar
             , FounderCode Integer, FounderName TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_FounderService());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- ��������� ��� ��������
     IF 1=0 AND vbUserId = 9457 -- ���������� �.�.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;


     -- ���������
     RETURN QUERY 
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , MovementItem.Amount
             
           , MIString_Comment.ValueData AS Comment

           , Object_Founder.ObjectCode  AS FounderCode
           , Object_Founder.ValueData   AS FounderName
 
       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_FounderService()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId
            --JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            LEFT JOIN Object AS Object_Founder ON Object_Founder.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
    
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_FounderService (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 06.10.16         * add inJuridicalBasisId
 03.09.14         *
*/

-- ����
--  SELECT * FROM gpSelect_Movement_FounderService (inStartDate:= '30.01.2013', inEndDate:= '01.02.2014', inIsErased:=false , inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
