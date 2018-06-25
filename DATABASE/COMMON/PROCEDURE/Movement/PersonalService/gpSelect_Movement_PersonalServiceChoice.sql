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
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , ServiceDate TDateTime
             , TotalSumm TFloat, TotalSummToPay TFloat, TotalSummCash TFloat, TotalSummService TFloat, TotalSummCard TFloat, TotalSummMinus TFloat, TotalSummAdd TFloat
             , TotalSummHoliday TFloat, TotalSummCardRecalc TFloat, TotalSummSocialIn TFloat, TotalSummSocialAdd TFloat, TotalSummChild TFloat
             , TotalSummAddOth TFloat, TotalSummAddOthRecalc TFloat
             , Comment TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , JurIdicalId Integer, JurIdicalName TVarChar
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
        , tmpUserAll AS (SELECT UserId FROM Constant_User_LevelMax01_View WHERE UserId = vbUserId AND UserId <> 9464) -- Документы-меню (управленцы) AND <> Рудик Н.В. + ЗП просмотр ВСЕ
        , tmpRoleAccessKey AS (SELECT AccessKeyId_PersonalService AS AccessKeyId FROM Object_RoleAccessKeyGuIde_View WHERE UserId = vbUserId GROUP BY AccessKeyId_PersonalService
                              UNION
                               -- Админ и другие видят ВСЕХ
                               SELECT AccessKeyId_PersonalService AS AccessKeyId FROM tmpUserAll INNER JOIN Object_RoleAccessKeyGuIde_View ON tmpUserAll.UserId > 0 GROUP BY AccessKeyId_PersonalService
                              UNION
                               -- "ЗП Админ" видят "ЗП карточки БН"
                               SELECT zc_Enum_Process_AccessKey_PersonalServiceFirstForm() FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceAdmin() GROUP BY AccessKeyId_PersonalService
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
           , MovementFloat_TotalSummService .ValueData  AS TotalSummService 
           
           , MovementFloat_TotalSummMinus.ValueData     AS TotalSummMinus
           , MovementFloat_TotalSummAdd.ValueData       AS TotalSummAdd
           , MovementFloat_TotalSummHoliday.ValueData     AS TotalSummHoliday

           , MovementFloat_TotalSummSocialIn.ValueData    AS TotalSummSocialIn
           , MovementFloat_TotalSummSocialAdd.ValueData   AS TotalSummSocialAdd
           , MovementFloat_TotalSummChild.ValueData       AS TotalSummChild

           , MovementFloat_TotalSummAddOth.ValueData        AS TotalSummAddOth
           , MovementFloat_TotalSummAddOthRecalc.ValueData  AS TotalSummAddOthRecalc
           
           , MovementString_Comment.ValueData           AS Comment
           , Object_PersonalServiceList.Id              AS PersonalServiceListId
           , Object_PersonalServiceList.ValueData       AS PersonalServiceListName
           , Object_JurIdical.Id                        AS JurIdicalId
           , Object_JurIdical.ValueData                 AS JurIdicalName

       FROM (SELECT Movement.Id
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
            LEFT JOIN Movement ON Movement.Id = tmpMovement.Id

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

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                          ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                        AND (MovementLinkObject_PersonalServiceList.ObjectId = inPersonalServiceListId OR COALESCE (inPersonalServiceListId, 0) = 0)
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_JurIdical
                                         ON MovementLinkObject_JurIdical.MovementId = Movement.Id
                                        AND MovementLinkObject_JurIdical.DescId = zc_MovementLinkObject_JurIdical()
            LEFT JOIN Object AS Object_JurIdical ON Object_JurIdical.Id = MovementLinkObject_JurIdical.ObjectId
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.06.18         * TotalSummAddOth
                    TotalSummAddOthRecalc
 20.04.16         * Holiday
 05.04.15                                        * all
 23.10.14         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalServiceChoice (inStartDate:= '30.01.2014', inEndDate:= '01.02.2015', inPersonalServiceListId:= 0, inIsServiceDate:= FALSE, inIsErased := FALSE, inSession:= '2')
