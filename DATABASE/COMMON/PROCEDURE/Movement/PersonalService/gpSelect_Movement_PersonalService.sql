-- Function: gpSelect_Movement_PersonalService()

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService (TDateTime, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService (TDateTime, TDateTime, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalService(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer , -- гл. юр.лицо
    IN inIsServiceDate     Boolean ,
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , ServiceDate TDateTime
             , TotalSumm TFloat, TotalSummToPay TFloat, TotalSummCash TFloat, TotalSummService TFloat
             , TotalSummCard TFloat, TotalSummCardSecond TFloat, TotalSummCardSecondCash TFloat
             , TotalSummNalog TFloat, TotalSummMinus TFloat, TotalSummAdd TFloat, TotalSummHoliday TFloat
             , TotalSummCardRecalc TFloat, TotalSummCardSecondRecalc TFloat, TotalSummNalogRecalc TFloat, TotalSummSocialIn TFloat, TotalSummSocialAdd TFloat
             , TotalSummChild TFloat, TotalSummChildRecalc TFloat, TotalSummMinusExt TFloat, TotalSummMinusExtRecalc TFloat
             , TotalSummTransport TFloat, TotalSummTransportAdd TFloat, TotalSummTransportAddLong TFloat, TotalSummTransportTaxi TFloat, TotalSummPhone TFloat
             , TotalSummNalogRet TFloat, TotalSummNalogRetRecalc TFloat
             , TotalSummAddOth TFloat, TotalSummAddOthRecalc TFloat
             , Comment TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , isAuto Boolean
             , strSign        TVarChar -- ФИО пользователей. - есть эл. подпись
             , strSignNo      TVarChar -- ФИО пользователей. - ожидается эл. подпись
             , MemberName     TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalService());
     vbUserId:= lpGetUserBySession (inSession);


     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;


     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpMemberPersonalServiceList
                     AS (SELECT Object_PersonalServiceList.Id                       AS PersonalServiceListId
                         FROM ObjectLink AS ObjectLink_User_Member
                              INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList
                                                    ON ObjectLink_MemberPersonalServiceList.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                   AND ObjectLink_MemberPersonalServiceList.DescId        = zc_ObjectLink_MemberPersonalServiceList_Member()
                              LEFT JOIN ObjectBoolean ON ObjectBoolean.ObjectId = ObjectLink_MemberPersonalServiceList.ObjectId
                                                     AND ObjectBoolean.DescId   = zc_ObjectBoolean_MemberPersonalServiceList_All()
                              LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList
                                                   ON ObjectLink_PersonalServiceList.ObjectId = ObjectLink_MemberPersonalServiceList.ObjectId
                                                  AND ObjectLink_PersonalServiceList.DescId   = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                              LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                                                            AND (Object_PersonalServiceList.Id    = ObjectLink_PersonalServiceList.ChildObjectId
                                                                              OR ObjectBoolean.ValueData          = TRUE)
                         WHERE ObjectLink_User_Member.ObjectId = vbUserId
                           AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                        )
        , tmpUserAll AS (SELECT UserId FROM Constant_User_LevelMax01_View WHERE UserId = vbUserId /*AND UserId <> 9464*/) -- Документы-меню (управленцы) AND <> Рудик Н.В. + ЗП просмотр ВСЕ
        , tmpRoleAccessKey AS (SELECT DISTINCT AccessKeyId_PersonalService AS AccessKeyId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId
                              UNION
                               -- Админ и другие видят ВСЕХ
                               SELECT DISTINCT AccessKeyId_PersonalService AS AccessKeyId FROM tmpUserAll INNER JOIN Object_RoleAccessKeyGuide_View ON tmpUserAll.UserId > 0
                              UNION
                               -- "ЗП Админ" видят "ЗП карточки БН"
                               SELECT zc_Enum_Process_AccessKey_PersonalServiceFirstForm() FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId and AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceAdmin() GROUP BY AccessKeyId_PersonalService
                              UNION
                               -- "ЗП Админ" видят "ЗП карточки БН"
                               SELECT zc_Enum_Process_AccessKey_PersonalServiceFirstForm() FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId and AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceProduction() GROUP BY AccessKeyId_PersonalService
                              UNION
                               -- "ЗП филиалов" видят "zc_Enum_Process_AccessKey_PersonalServiceSbit"
                               SELECT zc_Enum_Process_AccessKey_PersonalServiceKrRog()      FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId and AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSbit() GROUP BY AccessKeyId_PersonalService
                         UNION SELECT zc_Enum_Process_AccessKey_PersonalServiceNikolaev()   FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId and AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSbit() GROUP BY AccessKeyId_PersonalService
                         UNION SELECT zc_Enum_Process_AccessKey_PersonalServiceKharkov()    FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId and AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSbit() GROUP BY AccessKeyId_PersonalService
                         UNION SELECT zc_Enum_Process_AccessKey_PersonalServiceCherkassi()  FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId and AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSbit() GROUP BY AccessKeyId_PersonalService
                         UNION SELECT zc_Enum_Process_AccessKey_PersonalServiceZaporozhye() FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId and AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceSbit() GROUP BY AccessKeyId_PersonalService
                              )

        , tmpMovement AS (SELECT Movement.Id
                               , MovementLinkObject_PersonalServiceList.ObjectId AS PersonalServiceListId
                          FROM tmpStatus
                               INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_PersonalService() AND Movement.StatusId = tmpStatus.StatusId
                               LEFT JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                            ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                                           AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                               LEFT JOIN tmpMemberPersonalServiceList ON tmpMemberPersonalServiceList.PersonalServiceListId = MovementLinkObject_PersonalServiceList.ObjectId
                          WHERE inIsServiceDate = FALSE
                            AND (tmpRoleAccessKey.AccessKeyId > 0 OR tmpMemberPersonalServiceList.PersonalServiceListId > 0)
                         UNION ALL
                          SELECT MovementDate_ServiceDate.MovementId             AS Id
                               , MovementLinkObject_PersonalServiceList.ObjectId AS PersonalServiceListId
                          FROM MovementDate AS MovementDate_ServiceDate
                               JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId AND Movement.DescId = zc_Movement_PersonalService()
                               JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                               LEFT JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                            ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                                           AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                               LEFT JOIN tmpMemberPersonalServiceList ON tmpMemberPersonalServiceList.PersonalServiceListId = MovementLinkObject_PersonalServiceList.ObjectId
                          WHERE inIsServiceDate = TRUE
                            AND MovementDate_ServiceDate.ValueData BETWEEN DATE_TRUNC ('MONTH', inStartDate) AND (DATE_TRUNC ('MONTH', inEndDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
                            AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
                            AND (tmpRoleAccessKey.AccessKeyId > 0 OR tmpMemberPersonalServiceList.PersonalServiceListId > 0)
                         )
                         
        , tmpSign AS (SELECT tmpMovement.Id
                           , tmpSign.strSign
                           , tmpSign.strSignNo
                      FROM tmpMovement
                           LEFT JOIN lpSelect_MI_PersonalService_Sign (inMovementId:= tmpMovement.Id ) AS tmpSign ON tmpSign.Id = tmpMovement.Id 
                      )
        , tmpMember AS (SELECT tmp.PersonalServiceListId 
                             , ObjectLink_PersonalServiceList_Member.ChildObjectId AS MemberId
                        FROM (SELECT DISTINCT tmpMovement.PersonalServiceListId FROM tmpMovement) AS tmp
                             LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                                  ON ObjectLink_PersonalServiceList_Member.ObjectId = tmp.PersonalServiceListId 
                                                 AND ObjectLink_PersonalServiceList_Member.DescId = zc_ObjectLink_PersonalServiceList_Member()
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
           , (COALESCE (MovementFloat_TotalSummToPay.ValueData, 0)
            - COALESCE (MovementFloat_TotalSummCard.ValueData, 0)
            - COALESCE (MovementFloat_TotalSummCardSecond.ValueData, 0)
            - COALESCE (MovementFloat_TotalSummCardSecondCash.ValueData, 0)
             ) :: TFloat AS TotalSummCash
           , MovementFloat_TotalSummService.ValueData    AS TotalSummService
           , MovementFloat_TotalSummCard.ValueData       AS TotalSummCard
           , MovementFloat_TotalSummCardSecond.ValueData AS TotalSummCardSecond
           , MovementFloat_TotalSummCardSecondCash.ValueData AS TotalSummCardSecondCash
           , MovementFloat_TotalSummNalog.ValueData      AS TotalSummNalog
           , MovementFloat_TotalSummMinus.ValueData      AS TotalSummMinus
           , MovementFloat_TotalSummAdd.ValueData        AS TotalSummAdd

           , MovementFloat_TotalSummHoliday.ValueData     AS TotalSummHoliday
           , MovementFloat_TotalSummCardRecalc.ValueData  AS TotalSummCardRecalc
           , MovementFloat_TotalSummCardSecondRecalc.ValueData  AS TotalSummCardSecondRecalc
           , MovementFloat_TotalSummNalogRecalc.ValueData AS TotalSummNalogRecalc
           , MovementFloat_TotalSummSocialIn.ValueData    AS TotalSummSocialIn
           , MovementFloat_TotalSummSocialAdd.ValueData   AS TotalSummSocialAdd

           , MovementFloat_TotalSummChild.ValueData            AS TotalSummChild
           , MovementFloat_TotalSummChildRecalc.ValueData      AS TotalSummChildRecalc
           , MovementFloat_TotalSummMinusExt.ValueData         AS TotalSummMinusExt
           , MovementFloat_TotalSummMinusExtRecalc.ValueData   AS TotalSummMinusExtRecalc

           , MovementFloat_TotalSummTransport.ValueData        AS TotalSummTransport
           , MovementFloat_TotalSummTransportAdd.ValueData     AS TotalSummTransportAdd
           , MovementFloat_TotalSummTransportAddLong.ValueData AS TotalSummTransportAddLong
           , MovementFloat_TotalSummTransportTaxi.ValueData    AS TotalSummTransportTaxi
           , MovementFloat_TotalSummPhone.ValueData            AS TotalSummPhone

           , MovementFloat_TotalSummNalogRet.ValueData         AS TotalSummNalogRet
           , MovementFloat_TotalSummNalogRetRecalc.ValueData   AS TotalSummNalogRetRecalc

           , MovementFloat_TotalSummAddOth.ValueData         AS TotalSummAddOth
           , MovementFloat_TotalSummAddOthRecalc.ValueData   AS TotalSummAddOthRecalc
           
           , MovementString_Comment.ValueData           AS Comment
           , Object_PersonalServiceList.Id              AS PersonalServiceListId
           , Object_PersonalServiceList.ValueData       AS PersonalServiceListName
           , Object_Juridical.Id                        AS JuridicalId
           , Object_Juridical.ValueData                 AS JuridicalName
         
           , COALESCE(MovementBoolean_isAuto.ValueData, False) :: Boolean  AS isAuto

           , tmpSign.strSign
           , tmpSign.strSignNo 
           
           , Object_Member.ValueData                    AS MemberName 

       FROM tmpMovement
            LEFT JOIN Movement ON Movement.id = tmpMovement.id

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                   ON MovementDate_ServiceDate.MovementId = Movement.Id
                                  AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummToPay
                                    ON MovementFloat_TotalSummToPay.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummToPay.DescId = zc_MovementFloat_TotalSummToPay()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummService
                                    ON MovementFloat_TotalSummService.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummService.DescId = zc_MovementFloat_TotalSummService()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCard
                                    ON MovementFloat_TotalSummCard.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummCard.DescId = zc_MovementFloat_TotalSummCard()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCardSecond
                                    ON MovementFloat_TotalSummCardSecond.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummCardSecond.DescId = zc_MovementFloat_TotalSummCardSecond()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCardSecondCash
                                    ON MovementFloat_TotalSummCardSecondCash.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummCardSecondCash.DescId = zc_MovementFloat_TotalSummCardSecondCash()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummNalog
                                    ON MovementFloat_TotalSummNalog.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummNalog.DescId = zc_MovementFloat_TotalSummNalog()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMinus
                                    ON MovementFloat_TotalSummMinus.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummMinus.DescId = zc_MovementFloat_TotalSummMinus()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAdd
                                    ON MovementFloat_TotalSummAdd.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummAdd.DescId = zc_MovementFloat_TotalSummAdd()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummHoliday
                                    ON MovementFloat_TotalSummHoliday.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummHoliday.DescId = zc_MovementFloat_TotalSummHoliday()           

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCardRecalc
                                    ON MovementFloat_TotalSummCardRecalc.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummCardRecalc.DescId = zc_MovementFloat_TotalSummCardRecalc()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCardSecondRecalc
                                    ON MovementFloat_TotalSummCardSecondRecalc.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummCardSecondRecalc.DescId = zc_MovementFloat_TotalSummCardSecondRecalc()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummNalogRecalc
                                    ON MovementFloat_TotalSummNalogRecalc.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummNalogRecalc.DescId = zc_MovementFloat_TotalSummNalogRecalc()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummSocialAdd
                                    ON MovementFloat_TotalSummSocialAdd.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummSocialAdd.DescId = zc_MovementFloat_TotalSummSocialAdd()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummSocialIn
                                    ON MovementFloat_TotalSummSocialIn.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummSocialIn.DescId = zc_MovementFloat_TotalSummSocialIn()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChild
                                    ON MovementFloat_TotalSummChild.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummChild.DescId = zc_MovementFloat_TotalSummChild()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChildRecalc
                                    ON MovementFloat_TotalSummChildRecalc.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummChildRecalc.DescId = zc_MovementFloat_TotalSummChildRecalc()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMinusExt
                                    ON MovementFloat_TotalSummMinusExt.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummMinusExt.DescId = zc_MovementFloat_TotalSummMinusExt()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMinusExtRecalc
                                    ON MovementFloat_TotalSummMinusExtRecalc.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummMinusExtRecalc.DescId = zc_MovementFloat_TotalSummMinusExtRecalc()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummTransport
                                    ON MovementFloat_TotalSummTransport.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummTransport.DescId = zc_MovementFloat_TotalSummTransport()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummTransportAdd
                                    ON MovementFloat_TotalSummTransportAdd.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummTransportAdd.DescId = zc_MovementFloat_TotalSummTransportAdd()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummTransportAddLong
                                    ON MovementFloat_TotalSummTransportAddLong.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummTransportAddLong.DescId = zc_MovementFloat_TotalSummTransportAddLong()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummTransportTaxi
                                    ON MovementFloat_TotalSummTransportTaxi.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummTransportTaxi.DescId = zc_MovementFloat_TotalSummTransportTaxi()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPhone
                                    ON MovementFloat_TotalSummPhone.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPhone.DescId = zc_MovementFloat_TotalSummPhone()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummNalogRet
                                    ON MovementFloat_TotalSummNalogRet.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummNalogRet.DescId = zc_MovementFloat_TotalSummNalogRet()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummNalogRetRecalc
                                    ON MovementFloat_TotalSummNalogRetRecalc.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummNalogRetRecalc.DescId = zc_MovementFloat_TotalSummNalogRetRecalc()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAddOth
                                    ON MovementFloat_TotalSummAddOth.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummAddOth.DescId = zc_MovementFloat_TotalSummAddOth()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAddOthRecalc
                                    ON MovementFloat_TotalSummAddOthRecalc.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummAddOthRecalc.DescId = zc_MovementFloat_TotalSummAddOthRecalc()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = tmpMovement.PersonalServiceListId
            LEFT JOIN tmpMember ON tmpMember.PersonalServiceListId = tmpMovement.PersonalServiceListId

            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpMember.MemberId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

            LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                      ON MovementBoolean_isAuto.MovementId = Movement.Id
                                     AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()

            LEFT JOIN tmpSign ON tmpSign.Id = Movement.Id   -- эл.подписи  --
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_PersonalService (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.09.18         *
 25.06.18         * add TotalSummAddOth,
                        TotalSummAddOthRecalc
 05.01.18         * add TotalSummNalogRet
                        TotalSummNalogRetRecalc
 04.12.17         * add Sign
 20.06.17         * add TotalSummCardSecondCash
 24.02.17         *
 20.02.17         * add CardSecond
 07.10.16         * add inJuridicalBasisId
 21.06.16         *
 20.04.16         *
 05.04.15                                        * all
 01.10.14         * add Juridical
 11.09.14         *
*/

/*
             SELECT Movement.*
             FROM Movement 
                  LEFT JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
             WHERE Movement.DescId = zc_Movement_PersonalService()
               and Movement.StatusId = zc_Enum_Status_Complete()
               and Movement.OperDate BETWEEN '01.01.2017' AND '31.05.2017'
               and MovementItemContainer.MovementId is null
             order by operDate desc
*/
-- тест
-- SELECT * FROM gpSelect_Movement_PersonalService (inStartDate:= '30.01.2015', inEndDate:= '01.02.2015', inJuridicalBasisId:= 0, inIsServiceDate:= FALSE, inIsErased:= FALSE, inSession:= '2')
