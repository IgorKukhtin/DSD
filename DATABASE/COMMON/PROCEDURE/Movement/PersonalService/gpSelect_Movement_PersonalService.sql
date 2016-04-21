-- Function: gpSelect_Movement_PersonalService()

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService (TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalService(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsServiceDate Boolean ,
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , ServiceDate TDateTime
             , TotalSumm TFloat, TotalSummToPay TFloat, TotalSummCash TFloat, TotalSummService TFloat, TotalSummCard TFloat, TotalSummMinus TFloat, TotalSummAdd TFloat, TotalSummHoliday TFloat
             , TotalSummCardRecalc TFloat, TotalSummSocialIn TFloat, TotalSummSocialAdd TFloat, TotalSummChild TFloat
             , TotalSummTransportAdd TFloat, TotalSummTransport TFloat, TotalSummPhone TFloat
             , Comment TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalService());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� ��� ��������
     IF vbUserId = 9457 -- ���������� �.�.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;


     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAll AS (SELECT UserId FROM Constant_User_LevelMax01_View WHERE UserId = vbUserId /*AND UserId <> 9464*/) -- ���������-���� (����������) AND <> ����� �.�. + �� �������� ���
        , tmpRoleAccessKey AS (SELECT DISTINCT AccessKeyId_PersonalService AS AccessKeyId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId
                              UNION
                               -- ����� � ������ ����� ����
                               SELECT DISTINCT AccessKeyId_PersonalService AS AccessKeyId FROM tmpUserAll INNER JOIN Object_RoleAccessKeyGuide_View ON tmpUserAll.UserId > 0
                              UNION
                               -- "�� �����" ����� "�� �������� ��"
                               SELECT zc_Enum_Process_AccessKey_PersonalServiceFirstForm() FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId and AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceAdmin() GROUP BY AccessKeyId_PersonalService
                              UNION
                               -- "�� �����" ����� "�� �������� ��"
                               SELECT zc_Enum_Process_AccessKey_PersonalServiceFirstForm() FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId and AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceProduction() GROUP BY AccessKeyId_PersonalService
                              UNION
                               -- "�� ��������" ����� "zc_Enum_Process_AccessKey_PersonalServiceSbit"
                               SELECT zc_Enum_Process_AccessKey_PersonalServiceKrRog()      FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId and AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSbit() GROUP BY AccessKeyId_PersonalService
                         UNION SELECT zc_Enum_Process_AccessKey_PersonalServiceNikolaev()   FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId and AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSbit() GROUP BY AccessKeyId_PersonalService
                         UNION SELECT zc_Enum_Process_AccessKey_PersonalServiceKharkov()    FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId and AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSbit() GROUP BY AccessKeyId_PersonalService
                         UNION SELECT zc_Enum_Process_AccessKey_PersonalServiceCherkassi()  FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId and AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSbit() GROUP BY AccessKeyId_PersonalService
                         UNION SELECT zc_Enum_Process_AccessKey_PersonalServiceZaporozhye() FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId and AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSbit() GROUP BY AccessKeyId_PersonalService
                              )

       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , MovementDate_ServiceDate.ValueData         AS ServiceDate 
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
           , MovementFloat_TotalSummToPay.ValueData     AS TotalSummToPay
           , (COALESCE (MovementFloat_TotalSummToPay.ValueData, 0) - COALESCE (MovementFloat_TotalSummCard.ValueData, 0) - COALESCE (MovementFloat_TotalSummChild.ValueData, 0)) :: TFloat AS TotalSummCash
           , MovementFloat_TotalSummService.ValueData   AS TotalSummService
           , MovementFloat_TotalSummCard.ValueData      AS TotalSummCard
           , MovementFloat_TotalSummMinus.ValueData     AS TotalSummMinus
           , MovementFloat_TotalSummAdd.ValueData       AS TotalSummAdd

           , MovementFloat_TotalSummHoliday.ValueData     AS TotalSummHoliday
           , MovementFloat_TotalSummCardRecalc.ValueData  AS TotalSummCardRecalc
           , MovementFloat_TotalSummSocialIn.ValueData    AS TotalSummSocialIn
           , MovementFloat_TotalSummSocialAdd.ValueData   AS TotalSummSocialAdd
           , MovementFloat_TotalSummChild.ValueData       AS TotalSummChild

           , MovementFloat_TotalSummTransportAdd.ValueData AS TotalSummTransportAdd
           , MovementFloat_TotalSummTransport.ValueData    AS TotalSummTransport
           , MovementFloat_TotalSummPhone.ValueData        AS TotalSummPhone

           , MovementString_Comment.ValueData           AS Comment
           , Object_PersonalServiceList.Id              AS PersonalServiceListId
           , Object_PersonalServiceList.ValueData       AS PersonalServiceListName
           , Object_Juridical.Id                        AS JuridicalId
           , Object_Juridical.ValueData                 AS JuridicalName

       FROM (SELECT Movement.id
             FROM tmpStatus
                  INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_PersonalService() AND Movement.StatusId = tmpStatus.StatusId
                  INNER JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
             WHERE inIsServiceDate = FALSE
            UNION ALL
             SELECT MovementDate_ServiceDate.MovementId  AS Id
             FROM MovementDate AS MovementDate_ServiceDate
                  JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId AND Movement.DescId = zc_Movement_PersonalService()
                  JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
             WHERE inIsServiceDate = TRUE
               AND MovementDate_ServiceDate.ValueData BETWEEN DATE_TRUNC ('MONTH', inStartDate) AND (DATE_TRUNC ('MONTH', inEndDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
               AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
            ) AS tmpMovement
            LEFT JOIN Movement ON Movement.id = tmpMovement.id

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                   ON MovementDate_ServiceDate.MovementId = Movement.Id
                                  AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummToPay
                                    ON MovementFloat_TotalSummToPay.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummToPay.DescId = zc_MovementFloat_TotalSummToPay()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummService
                                    ON MovementFloat_TotalSummService.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummService.DescId = zc_MovementFloat_TotalSummService()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCard
                                    ON MovementFloat_TotalSummCard.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummCard.DescId = zc_MovementFloat_TotalSummCard()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMinus
                                    ON MovementFloat_TotalSummMinus.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMinus.DescId = zc_MovementFloat_TotalSummMinus()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAdd
                                    ON MovementFloat_TotalSummAdd.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummAdd.DescId = zc_MovementFloat_TotalSummAdd()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummHoliday
                                    ON MovementFloat_TotalSummHoliday.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummHoliday.DescId = zc_MovementFloat_TotalSummHoliday()           

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCardRecalc
                                    ON MovementFloat_TotalSummCardRecalc.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummCardRecalc.DescId = zc_MovementFloat_TotalSummCardRecalc()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummSocialAdd
                                    ON MovementFloat_TotalSummSocialAdd.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummSocialAdd.DescId = zc_MovementFloat_TotalSummSocialAdd()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummSocialIn
                                    ON MovementFloat_TotalSummSocialIn.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummSocialIn.DescId = zc_MovementFloat_TotalSummSocialIn()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChild
                                    ON MovementFloat_TotalSummChild.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummChild.DescId = zc_MovementFloat_TotalSummChild()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummTransportAdd
                                    ON MovementFloat_TotalSummTransportAdd.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummTransportAdd.DescId = zc_MovementFloat_TotalSummTransportAdd()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummTransport
                                    ON MovementFloat_TotalSummTransport.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummTransport.DescId = zc_MovementFloat_TotalSummTransport()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPhone
                                    ON MovementFloat_TotalSummPhone.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPhone.DescId = zc_MovementFloat_TotalSummPhone()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                         ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_PersonalService (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.04.16         *
 05.04.15                                        * all
 01.10.14         * add Juridical
 11.09.14         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_PersonalService (inStartDate:= '30.01.2014', inEndDate:= '01.02.2015', inIsServiceDate:= FALSE, inIsErased:= FALSE, inSession:= '2')




