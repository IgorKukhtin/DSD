-- Function: gpSelect_Movement_PersonalServiceChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalServiceChoice (TDateTime, TDateTime, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalServiceChoice(
    IN inStartDate              TDateTime , --
    IN inEndDate                TDateTime , --
    IN inPersonalServiceListId  Integer ,
    IN inIsServiceDate          Boolean ,
    IN inIsErased               Boolean ,
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumber_full TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , ServiceDate TDateTime
             , TotalSumm TFloat, TotalSummToPay TFloat, TotalSummCash TFloat, TotalSummService TFloat, TotalSummCard TFloat, TotalSummMinus TFloat
             , TotalSummAdd TFloat, TotalSummAuditAdd TFloat
             , TotalSummHoliday TFloat, TotalSummCardRecalc TFloat, TotalSummSocialIn TFloat, TotalSummSocialAdd TFloat, TotalSummChild TFloat
             , TotalSummAddOth TFloat, TotalSummAddOthRecalc TFloat
             , TotalSummFine TFloat, TotalSummHosp TFloat
             , Comment TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , JurIdicalId Integer, JurIdicalName TVarChar
             , isDetail Boolean
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalService());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Блокируем ему просмотр
     IF 1=0 AND vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;


     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAll AS (SELECT UserId FROM Constant_User_LevelMax01_View
                         WHERE UserId = vbUserId AND UserId <> 9464 -- Документы-меню (управленцы) AND <> Рудик Н.В. + ЗП просмотр ВСЕ
                         --AND vbUserId <> zfCalc_UserMain()
                        )

        , tmpRoleAccessKey AS (SELECT AccessKeyId_PersonalService AS AccessKeyId FROM Object_RoleAccessKeyGuIde_View WHERE UserId = vbUserId GROUP BY AccessKeyId_PersonalService
                              UNION
                               -- Админ и другие видят ВСЕХ
                               SELECT AccessKeyId_PersonalService AS AccessKeyId FROM tmpUserAll INNER JOIN Object_RoleAccessKeyGuIde_View ON tmpUserAll.UserId > 0 GROUP BY AccessKeyId_PersonalService
                              UNION
                               -- "ЗП Админ" видят "ЗП карточки БН"
                               SELECT zc_Enum_Process_AccessKey_PersonalServiceFirstForm() FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceAdmin() GROUP BY AccessKeyId_PersonalService
                              )
        , tmpMemberPersonalServiceList
                     AS (SELECT Object_PersonalServiceList_User_View.PersonalServiceListId FROM Object_PersonalServiceList_User_View WHERE Object_PersonalServiceList_User_View.UserId = vbUserId
                        UNION
                         -- Админ и другие видят ВСЕХ
                         SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                         FROM Object AS Object_PersonalServiceList
                         WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                           AND EXISTS (SELECT 1 FROM tmpUserAll)
                        UNION
                         -- Админ и другие видят ВСЕХ
                         SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                         FROM Object AS Object_PersonalServiceList
                         WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                           AND EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND AccessKeyId_PersonalService IN (zc_Enum_Process_AccessKey_PersonalServiceAdmin()))
                         --AND vbUserId <> zfCalc_UserMain()
                        )
       --статьи
       , tmpInfoMoney_View AS (SELECT *
                               FROM Object_InfoMoney_View
                               WHERE Object_InfoMoney_View.InfoMoneyId IN (zc_Enum_InfoMoney_60101(), zc_Enum_InfoMoney_21421())
                               )
       
       -- Результат
       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , zfCalc_PartionMovementName (Movement.DescId, MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate) ::TVarChar AS InvNumber_Full
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

           , MovementFloat_TotalSummService .ValueData  AS TotalSummService 
           , MovementFloat_TotalSummCard.ValueData      AS TotalSummCard
           
           , MovementFloat_TotalSummMinus.ValueData     AS TotalSummMinus
           , MovementFloat_TotalSummAdd.ValueData       AS TotalSummAdd
           , MovementFloat_TotalSummAuditAdd.ValueData  AS TotalSummAuditAdd
           , MovementFloat_TotalSummHoliday.ValueData   AS TotalSummHoliday

           , MovementFloat_TotalSummCardRecalc.ValueData  AS TotalSummCardRecalc
           , MovementFloat_TotalSummSocialIn.ValueData    AS TotalSummSocialIn
           , MovementFloat_TotalSummSocialAdd.ValueData   AS TotalSummSocialAdd
           , MovementFloat_TotalSummChild.ValueData       AS TotalSummChild

           , MovementFloat_TotalSummAddOth.ValueData        AS TotalSummAddOth
           , MovementFloat_TotalSummAddOthRecalc.ValueData  AS TotalSummAddOthRecalc

           , MovementFloat_TotalSummFine.ValueData :: TFloat   AS TotalSummFine
           , MovementFloat_TotalSummHosp.ValueData :: TFloat   AS TotalSummHosp

           , MovementString_Comment.ValueData           AS Comment
           , Object_PersonalServiceList.Id              AS PersonalServiceListId
           , Object_PersonalServiceList.ValueData       AS PersonalServiceListName
           , Object_JurIdical.Id                        AS JurIdicalId
           , Object_JurIdical.ValueData                 AS JurIdicalName
           , COALESCE(MovementBoolean_Detail.ValueData, False) :: Boolean  AS isDetail

           , View_InfoMoney.InfoMoneyId
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName
           , View_InfoMoney.InfoMoneyName_all

       FROM (--Документы <Начисление зарплаты>
             SELECT Movement.Id
             FROM tmpStatus
                  INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_PersonalService() AND Movement.StatusId = tmpStatus.StatusId
                --INNER JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                               ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                              AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                  INNER JOIN tmpMemberPersonalServiceList ON tmpMemberPersonalServiceList.PersonalServiceListId = MovementLinkObject_PersonalServiceList.ObjectId
             WHERE inIsServiceDate = FALSE
               -- Волошина Е.А. + Няйко В.И. + Спічка Є.А.
               -- AND (vbUserId NOT IN (140094, 1058530, 4538468) OR tmpMemberPersonalServiceList.PersonalServiceListId > 0)
            UNION ALL
             SELECT MovementDate_ServiceDate.MovementId  AS Id
             FROM MovementDate AS MovementDate_ServiceDate
                  JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId AND Movement.DescId = zc_Movement_PersonalService()
                  JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                --JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                               ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                              AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                  INNER JOIN tmpMemberPersonalServiceList ON tmpMemberPersonalServiceList.PersonalServiceListId = MovementLinkObject_PersonalServiceList.ObjectId
            WHERE inIsServiceDate = TRUE
               AND MovementDate_ServiceDate.ValueData BETWEEN DATE_TRUNC ('MONTH', inStartDate) AND (DATE_TRUNC ('MONTH', inEndDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
               AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
               -- Волошина Е.А. + Няйко В.И. + Спічка Є.А.
               -- AND (vbUserId NOT IN (140094, 1058530, 4538468) OR tmpMemberPersonalServiceList.PersonalServiceListId > 0)  
           UNION ALL
           --Документы <Начисление проезд>
             SELECT Movement.Id
             FROM tmpStatus
                  INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_PersonalTransport() AND Movement.StatusId = tmpStatus.StatusId
                --INNER JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                               ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                              AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                  INNER JOIN tmpMemberPersonalServiceList ON tmpMemberPersonalServiceList.PersonalServiceListId = MovementLinkObject_PersonalServiceList.ObjectId
             WHERE inIsServiceDate = FALSE
            UNION ALL
             SELECT MovementDate_ServiceDate.MovementId  AS Id
             FROM MovementDate AS MovementDate_ServiceDate
                  JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId AND Movement.DescId = zc_Movement_PersonalTransport()
                  JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                               ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                              AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                  INNER JOIN tmpMemberPersonalServiceList ON tmpMemberPersonalServiceList.PersonalServiceListId = MovementLinkObject_PersonalServiceList.ObjectId
            WHERE inIsServiceDate = TRUE
               AND MovementDate_ServiceDate.ValueData BETWEEN DATE_TRUNC ('MONTH', inStartDate) AND (DATE_TRUNC ('MONTH', inEndDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
               AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
            ) AS tmpMovement
            LEFT JOIN Movement ON Movement.Id = tmpMovement.Id
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                   ON MovementDate_ServiceDate.MovementId = Movement.Id
                                  AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
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
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCardSecond
                                    ON MovementFloat_TotalSummCardSecond.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummCardSecond.DescId = zc_MovementFloat_TotalSummCardSecond()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCardSecondCash
                                    ON MovementFloat_TotalSummCardSecondCash.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummCardSecondCash.DescId = zc_MovementFloat_TotalSummCardSecondCash()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMinus
                                    ON MovementFloat_TotalSummMinus.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMinus.DescId = zc_MovementFloat_TotalSummMinus()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAdd
                                    ON MovementFloat_TotalSummAdd.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummAdd.DescId = zc_MovementFloat_TotalSummAdd()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAuditAdd
                                    ON MovementFloat_TotalSummAuditAdd.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummAuditAdd.DescId = zc_MovementFloat_TotalSummAuditAdd()
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

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAddOth
                                    ON MovementFloat_TotalSummAddOth.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummAddOth.DescId = zc_MovementFloat_TotalSummAddOth()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAddOthRecalc
                                    ON MovementFloat_TotalSummAddOthRecalc.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummAddOthRecalc.DescId = zc_MovementFloat_TotalSummAddOthRecalc()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummFine
                                    ON MovementFloat_TotalSummFine.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummFine.DescId = zc_MovementFloat_TotalSummFine()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummHosp
                                    ON MovementFloat_TotalSummHosp.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummHosp.DescId = zc_MovementFloat_TotalSummHosp()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_Detail
                                      ON MovementBoolean_Detail.MovementId = Movement.Id
                                     AND MovementBoolean_Detail.DescId = zc_MovementBoolean_Detail()

            INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                          ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                        AND (MovementLinkObject_PersonalServiceList.ObjectId = inPersonalServiceListId OR COALESCE (inPersonalServiceListId, 0) = 0)
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_JurIdical
                                         ON MovementLinkObject_JurIdical.MovementId = Movement.Id
                                        AND MovementLinkObject_JurIdical.DescId = zc_MovementLinkObject_JurIdical()
            LEFT JOIN Object AS Object_JurIdical ON Object_JurIdical.Id = MovementLinkObject_JurIdical.ObjectId    

            -- выводим в грид уп статья - для PersonalService - zc_Enum_InfoMoney_60101()  - для PersonalTransport - zc_Enum_InfoMoney_21421
            LEFT JOIN tmpInfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = CASE WHEN Movement.DescId = zc_Movement_PersonalService()   THEN zc_Enum_InfoMoney_60101()
                                                                                               WHEN Movement.DescId = zc_Movement_PersonalTransport() THEN zc_Enum_InfoMoney_21421()
                                                                                          END
                                                                          
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.08.22         * add InfoMoney And zc_Movement_PersonalTransport
 25.03.20         * add TotalSummAuditAdd
 29.07.19         *
 25.06.18         * TotalSummAddOth
                    TotalSummAddOthRecalc
 20.04.16         * Holiday
 05.04.15                                        * all
 23.10.14         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalServiceChoice (inStartDate:= '30.01.2014', inEndDate:= '01.02.2015', inPersonalServiceListId:= 0, inIsServiceDate:= FALSE, inIsErased := FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_Movement_PersonalServiceChoice (inStartDate:= '22.08.2022', inEndDate:= '31.08.2022', inPersonalServiceListId:= 0, inIsServiceDate:= FALSE, inIsErased := FALSE, inSession:= '9457')

