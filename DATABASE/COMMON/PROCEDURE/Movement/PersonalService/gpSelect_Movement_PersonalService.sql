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
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumber_full TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , ServiceDate TDateTime
             , StartBeginDate TDateTime, EndBeginDate TDateTime
             , TotalSumm TFloat, TotalSummToPay TFloat, TotalSummCash TFloat, TotalSummService TFloat
             , TotalSummCard TFloat, TotalSummCardSecond TFloat, TotalSummCardSecondCash TFloat
             , TotalSummNalog TFloat, TotalSummMinus TFloat
             , TotalSummAdd TFloat
             , TotalSummAuditAdd TFloat, TotalDayAudit TFloat
             , TotalSummMedicdayAdd TFloat, TotalDayMedicday TFloat
             , TotalSummSkip TFloat, TotalDaySkip TFloat
             
             , TotalSummHoliday TFloat
             , TotalSummCardRecalc TFloat, TotalSummCardSecondRecalc TFloat, TotalSummNalogRecalc TFloat, TotalSummSocialIn TFloat, TotalSummSocialAdd TFloat
             , TotalSummChild TFloat, TotalSummChildRecalc TFloat
             , TotalSummMinusExt TFloat, TotalSummMinusExtRecalc TFloat
             , TotalSummTransport TFloat, TotalSummTransportAdd TFloat, TotalSummTransportAddLong TFloat, TotalSummTransportTaxi TFloat, TotalSummPhone TFloat
             , TotalSummNalogRet TFloat, TotalSummNalogRetRecalc TFloat
             , TotalSummAddOth TFloat, TotalSummAddOthRecalc TFloat
             , TotalSummFine TFloat, TotalSummFineOth TFloat, TotalSummFineOthRecalc TFloat
             , TotalSummHosp TFloat, TotalSummHospOth TFloat, TotalSummHospOthRecalc TFloat
             , TotalSummCompensation TFloat, TotalSummCompensationRecalc TFloat
             , TotalSummHouseAdd TFloat
             , TotalSummAvance TFloat, TotalSummAvanceRecalc TFloat
             , TotalSummAvCardSecond TFloat, TotalSummAvCardSecondRecalc TFloat
             , PriceNalog TFloat                                               
             , TotalSumm_BankSecond_num TFloat, TotalSumm_BankSecondTwo_num TFloat, TotalSumm_BankSecondDiff_num TFloat
             , Comment TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , isAuto Boolean, isDetail Boolean, isExport Boolean
             , isMail Boolean 
             , is4000 Boolean
             , strSign        TVarChar -- ФИО пользователей. - есть эл. подпись
             , strSignNo      TVarChar -- ФИО пользователей. - ожидается эл. подпись
             , MemberName     TVarChar 
             , MovementId_BankSecondNum Integer, InvNumber_BankSecondNum TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUserAll Boolean;
   DECLARE vbIsLevelMax01 Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalService());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Проверка прав роль - Ограничение - нет вообще доступа к просмотру данных ЗП!!!
     PERFORM lpCheck_UserRole_8813637 (vbUserId);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- Доступ почти ко всем
     vbIsUserAll:= EXISTS (-- Документы-меню (управленцы) AND + ЗП просмотр ВСЕ
                           SELECT Constant_User_LevelMax01_View.UserId
                           FROM Constant_User_LevelMax01_View
                                -- Ограниченние - только разрешенные ведомости ЗП
                                LEFT JOIN ObjectLink_UserRole_View ON ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 10657326 

                           WHERE Constant_User_LevelMax01_View.UserId = vbUserId
                             -- если нет Ограничения - только разрешенные ведомости ЗП
                             AND ObjectLink_UserRole_View.UserId IS NULL
                           --AND vbUserId <> zfCalc_UserMain()
                          );
     -- Доступ ко всем + Админ ЗП
     vbIsLevelMax01:= vbIsUserAll = TRUE
                  -- + если нет Ограничения - нет доступа к просмотру ведомость Админ ЗП
                  AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 11026035)
                     ;


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
        , tmpMemberPersonalServiceList
                     AS (SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                         FROM ObjectLink AS ObjectLink_User_Member
                              INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList
                                                    ON ObjectLink_MemberPersonalServiceList.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                   AND ObjectLink_MemberPersonalServiceList.DescId        = zc_ObjectLink_MemberPersonalServiceList_Member()
                              INNER JOIN Object AS Object_MemberPersonalServiceList
                                                ON Object_MemberPersonalServiceList.Id       = ObjectLink_MemberPersonalServiceList.ObjectId
                                               AND Object_MemberPersonalServiceList.isErased = FALSE
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
                        UNION
                         SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                         FROM ObjectLink AS ObjectLink_User_Member
                              INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                                    ON ObjectLink_PersonalServiceList_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                   AND ObjectLink_PersonalServiceList_Member.DescId        = zc_ObjectLink_PersonalServiceList_Member()
                              LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                                                            AND Object_PersonalServiceList.Id     = ObjectLink_PersonalServiceList_Member.ObjectId
                         WHERE ObjectLink_User_Member.ObjectId = vbUserId
                           AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                        UNION
                         -- Админ и другие видят ВСЕХ
                         SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                         FROM Object AS Object_PersonalServiceList
                         WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                           AND vbIsUserAll = TRUE
                        UNION
                         -- Админ и другие видят ВСЕХ
                         SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                         FROM Object AS Object_PersonalServiceList
                         WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                           AND EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View
                                       WHERE UserId = vbUserId AND AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceAdmin()
                                      )
                         --AND vbUserId <> zfCalc_UserMain()
                        /*UNION
                         -- "ЗП филиалов" видят "Галат Е.Н."
                         SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                         FROM Object AS Object_PersonalServiceList
                         WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                           AND vbUserId = 106593*/
                        )
        , tmpRoleAccessKey AS (SELECT DISTINCT AccessKeyId_PersonalService AS AccessKeyId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId
                              UNION
                               -- Админ и другие видят ВСЕХ
                               SELECT DISTINCT AccessKeyId_PersonalService AS AccessKeyId FROM Object_RoleAccessKeyGuide_View WHERE vbIsUserAll = TRUE
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
                            -- Волошина Е.А. + Няйко В.И. + Спічка Є.А.
                            -- AND ((tmpRoleAccessKey.AccessKeyId > 0 AND vbUserId NOT IN (140094, 1058530, 4538468)) OR tmpMemberPersonalServiceList.PersonalServiceListId > 0)
                            AND tmpMemberPersonalServiceList.PersonalServiceListId > 0
                            -- AND (tmpRoleAccessKey.AccessKeyId > 0 OR tmpMemberPersonalServiceList.PersonalServiceListId > 0)
                            
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
                            -- Волошина Е.А. + Няйко В.И. + Спічка Є.А.
                            -- AND ((tmpRoleAccessKey.AccessKeyId > 0 AND vbUserId NOT IN (140094, 1058530, 4538468)) OR tmpMemberPersonalServiceList.PersonalServiceListId > 0)
                            AND tmpMemberPersonalServiceList.PersonalServiceListId > 0
                            -- AND (tmpRoleAccessKey.AccessKeyId > 0 OR tmpMemberPersonalServiceList.PersonalServiceListId > 0)
                         )
                         
        , tmpSign AS (SELECT tmpMovement.Id
                           , tmpSign.strSign
                           , tmpSign.strSignNo
                      FROM tmpMovement
                           LEFT JOIN lpSelect_MI_Sign (inMovementId:= tmpMovement.Id) AS tmpSign ON tmpSign.Id = tmpMovement.Id 
                      )
          -- Информативно - чья ведомость
        , tmpMember AS (SELECT tmp.PersonalServiceListId 
                             , ObjectLink_PersonalServiceList_Member.ChildObjectId AS MemberId
                        FROM (SELECT DISTINCT tmpMovement.PersonalServiceListId FROM tmpMovement) AS tmp
                             LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                                  ON ObjectLink_PersonalServiceList_Member.ObjectId = tmp.PersonalServiceListId 
                                                 AND ObjectLink_PersonalServiceList_Member.DescId = zc_ObjectLink_PersonalServiceList_Member()
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
           , MovementDate_StartBegin.ValueData          AS StartBeginDate
           , MovementDate_EndBegin.ValueData            AS EndBeginDate

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
           , MovementFloat_TotalSummAuditAdd.ValueData   AS TotalSummAuditAdd
           , MovementFloat_TotalDayAudit.ValueData       AS TotalDayAudit
           
           , MovementFloat_TotalSummMedicdayAdd.ValueData   AS TotalSummMedicdayAdd
           , MovementFloat_TotalDayMedicday.ValueData       AS TotalDayMedicday
           , MovementFloat_TotalSummSkip.ValueData          AS TotalSummSkip
           , MovementFloat_TotalDaySkip.ValueData           AS TotalDaySkip

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

           , MovementFloat_TotalSummAddOth.ValueData           AS TotalSummAddOth
           , MovementFloat_TotalSummAddOthRecalc.ValueData     AS TotalSummAddOthRecalc

           , MovementFloat_TotalSummFine.ValueData          :: TFloat AS TotalSummFine
           , MovementFloat_TotalSummFineOth.ValueData       :: TFloat AS TotalSummFineOth
           , MovementFloat_TotalSummFineOthRecalc.ValueData :: TFloat AS TotalSummFineOthRecalc
           , MovementFloat_TotalSummHosp.ValueData          :: TFloat AS TotalSummHosp
           , MovementFloat_TotalSummHospOth.ValueData       :: TFloat AS TotalSummHospOth
           , MovementFloat_TotalSummHospOthRecalc.ValueData :: TFloat AS TotalSummHospOthRecalc

           , MovementFloat_TotalSummCompensation.ValueData        :: TFloat AS TotalSummCompensation
           , MovementFloat_TotalSummCompensationRecalc.ValueData  :: TFloat AS TotalSummCompensationRecalc
           
           , COALESCE (MovementFloat_TotalSummHouseAdd.ValueData,0) ::TFloat AS TotalSummHouseAdd

           , MovementFloat_TotalAvance.ValueData        :: TFloat AS TotalSummAvance
           , MovementFloat_TotalAvanceRecalc.ValueData  :: TFloat AS TotalSummAvanceRecalc

           , MovementFloat_TotalSummAvCardSecond.ValueData        :: TFloat AS TotalSummAvCardSecond
           , MovementFloat_TotalSummAvCardSecondRecalc.ValueData  :: TFloat AS TotalSummAvCardSecondRecalc   
           
           , MovementFloat_PriceNalog.ValueData                   :: TFloat AS PriceNalog

           , MovementFloat_TotalSumm_BankSecond_num.ValueData          AS TotalSumm_BankSecond_num
           , MovementFloat_TotalSumm_BankSecondTwo_num.ValueData       AS TotalSumm_BankSecondTwo_num
           , MovementFloat_TotalSumm_BankSecondDiff_num.ValueData      AS TotalSumm_BankSecondDiff_num

           , MovementString_Comment.ValueData           AS Comment
           , Object_PersonalServiceList.Id              AS PersonalServiceListId
           , Object_PersonalServiceList.ValueData       AS PersonalServiceListName
           , Object_Juridical.Id                        AS JuridicalId
           , Object_Juridical.ValueData                 AS JuridicalName

           , COALESCE(MovementBoolean_isAuto.ValueData, False) :: Boolean  AS isAuto
           , COALESCE(MovementBoolean_Detail.ValueData, False) :: Boolean  AS isDetail
           , COALESCE(MovementBoolean_Export.ValueData, False) :: Boolean  AS isExport
           , COALESCE(MovementBoolean_Mail.ValueData, False)   :: Boolean  AS isMail
           , COALESCE(MovementBoolean_4000.ValueData, False)   :: Boolean  AS is4000
           
           , tmpSign.strSign
           , tmpSign.strSignNo 

           , Object_Member.ValueData                    AS MemberName 
           
           , Movement_BankSecondNum.Id                  AS MovementId_BankSecondNum
           , zfCalc_PartionMovementName (Movement_BankSecondNum.DescId
                                       , MovementDesc_BankSecondNum.ItemName
                                       , '(' 
                                      || (MovementFloat_BankSecond_num.ValueData     :: Integer) :: TVarChar
                             || ' + ' || (MovementFloat_BankSecondTwo_num.ValueData  :: Integer) :: TVarChar
                             || ' + ' || (MovementFloat_BankSecondDiff_num.ValueData :: Integer) :: TVarChar
                                      || ')'
                                      || ' № ' || Movement_BankSecondNum.InvNumber
                                       , Movement_BankSecondNum.OperDate) ::TVarChar AS InvNumber_BankSecondNum

       FROM tmpMovement
            LEFT JOIN Movement ON Movement.Id = tmpMovement.Id
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                   ON MovementDate_ServiceDate.MovementId = Movement.Id
                                  AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()

            LEFT JOIN MovementDate AS MovementDate_StartBegin
                                   ON MovementDate_StartBegin.MovementId = Movement.Id
                                  AND MovementDate_StartBegin.DescId = zc_MovementDate_StartBegin()
            LEFT JOIN MovementDate AS MovementDate_EndBegin
                                   ON MovementDate_EndBegin.MovementId = Movement.Id
                                  AND MovementDate_EndBegin.DescId = zc_MovementDate_EndBegin()

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

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAuditAdd
                                    ON MovementFloat_TotalSummAuditAdd.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummAuditAdd.DescId = zc_MovementFloat_TotalSummAuditAdd()

            LEFT JOIN MovementFloat AS MovementFloat_TotalDayAudit
                                    ON MovementFloat_TotalDayAudit.MovementId = Movement.Id
                                   AND MovementFloat_TotalDayAudit.DescId = zc_MovementFloat_TotalDayAudit()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMedicdayAdd
                                    ON MovementFloat_TotalSummMedicdayAdd.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummMedicdayAdd.DescId = zc_MovementFloat_TotalSummMedicdayAdd()
            LEFT JOIN MovementFloat AS MovementFloat_TotalDayMedicday
                                    ON MovementFloat_TotalDayMedicday.MovementId = Movement.Id
                                   AND MovementFloat_TotalDayMedicday.DescId = zc_MovementFloat_TotalDayMedicday()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummSkip
                                    ON MovementFloat_TotalSummSkip.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummSkip.DescId = zc_MovementFloat_TotalSummSkip()
            LEFT JOIN MovementFloat AS MovementFloat_TotalDaySkip
                                    ON MovementFloat_TotalDaySkip.MovementId = Movement.Id
                                   AND MovementFloat_TotalDaySkip.DescId = zc_MovementFloat_TotalDaySkip()

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

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummFine
                                    ON MovementFloat_TotalSummFine.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummFine.DescId     = zc_MovementFloat_TotalSummFine()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummFineOth
                                    ON MovementFloat_TotalSummFineOth.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummFineOth.DescId     = zc_MovementFloat_TotalSummFineOth()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummFineOthRecalc
                                    ON MovementFloat_TotalSummFineOthRecalc.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummFineOthRecalc.DescId     = zc_MovementFloat_TotalSummFineOthRecalc()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummHosp
                                    ON MovementFloat_TotalSummHosp.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummHosp.DescId     = zc_MovementFloat_TotalSummHosp()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummHospOth
                                    ON MovementFloat_TotalSummHospOth.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummHospOth.DescId     = zc_MovementFloat_TotalSummHospOth()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummHospOthRecalc
                                    ON MovementFloat_TotalSummHospOthRecalc.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummHospOthRecalc.DescId     = zc_MovementFloat_TotalSummHospOthRecalc()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCompensation
                                    ON MovementFloat_TotalSummCompensation.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummCompensation.DescId = zc_MovementFloat_TotalSummCompensation()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCompensationRecalc
                                    ON MovementFloat_TotalSummCompensationRecalc.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummCompensationRecalc.DescId = zc_MovementFloat_TotalSummCompensationRecalc()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummHouseAdd
                                    ON MovementFloat_TotalSummHouseAdd.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummHouseAdd.DescId = zc_MovementFloat_TotalSummHouseAdd()

            LEFT JOIN MovementFloat AS MovementFloat_TotalAvance
                                    ON MovementFloat_TotalAvance.MovementId = Movement.Id
                                   AND MovementFloat_TotalAvance.DescId = zc_MovementFloat_TotalAvance()

            LEFT JOIN MovementFloat AS MovementFloat_TotalAvanceRecalc
                                    ON MovementFloat_TotalAvanceRecalc.MovementId = Movement.Id
                                   AND MovementFloat_TotalAvanceRecalc.DescId = zc_MovementFloat_TotalAvanceRecalc()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAvCardSecond
                                    ON MovementFloat_TotalSummAvCardSecond.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummAvCardSecond.DescId = zc_MovementFloat_TotalSummAvCardSecond()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAvCardSecondRecalc
                                    ON MovementFloat_TotalSummAvCardSecondRecalc.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummAvCardSecondRecalc.DescId = zc_MovementFloat_TotalSummAvCardSecondRecalc()

            LEFT JOIN MovementFloat AS MovementFloat_PriceNalog
                                    ON MovementFloat_PriceNalog.MovementId = Movement.Id
                                   AND MovementFloat_PriceNalog.DescId = zc_MovementFloat_PriceNalog()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_BankSecond_num
                                    ON MovementFloat_TotalSumm_BankSecond_num.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_BankSecond_num.DescId = zc_MovementFloat_TotalSumm_BankSecond_num()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_BankSecondTwo_num
                                    ON MovementFloat_TotalSumm_BankSecondTwo_num.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_BankSecondTwo_num.DescId = zc_MovementFloat_TotalSumm_BankSecondTwo_num()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm_BankSecondDiff_num
                                    ON MovementFloat_TotalSumm_BankSecondDiff_num.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm_BankSecondDiff_num.DescId = zc_MovementFloat_TotalSumm_BankSecondDiff_num()

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
            LEFT JOIN MovementBoolean AS MovementBoolean_Detail
                                      ON MovementBoolean_Detail.MovementId = Movement.Id
                                     AND MovementBoolean_Detail.DescId = zc_MovementBoolean_Detail()
            LEFT JOIN MovementBoolean AS MovementBoolean_Export
                                      ON MovementBoolean_Export.MovementId = Movement.Id
                                     AND MovementBoolean_Export.DescId = zc_MovementBoolean_Export()
            LEFT JOIN MovementBoolean AS MovementBoolean_Mail
                                      ON MovementBoolean_Mail.MovementId = Movement.Id
                                     AND MovementBoolean_Mail.DescId = zc_MovementBoolean_Mail()
            LEFT JOIN MovementBoolean AS MovementBoolean_4000
                                      ON MovementBoolean_4000.MovementId = Movement.Id
                                     AND MovementBoolean_4000.DescId = zc_MovementBoolean_4000()                                     

            LEFT JOIN MovementLinkMovement AS MLM_BankSecond_num
                                           ON MLM_BankSecond_num.MovementId = Movement.Id
                                          AND MLM_BankSecond_num.DescId = zc_MovementLinkMovement_BankSecondNum() 
            LEFT JOIN Movement AS Movement_BankSecondNum ON Movement_BankSecondNum.Id       = MLM_BankSecond_num.MovementChildId
                                                        AND Movement_BankSecondNum.StatusId <> zc_Enum_Status_Erased()
            LEFT JOIN MovementDesc AS MovementDesc_BankSecondNum ON MovementDesc_BankSecondNum.Id = Movement_BankSecondNum.DescId

            LEFT JOIN MovementFloat AS MovementFloat_BankSecond_num
                                    ON MovementFloat_BankSecond_num.MovementId =  Movement_BankSecondNum.Id
                                   AND MovementFloat_BankSecond_num.DescId = zc_MovementFloat_BankSecond_num()

            LEFT JOIN MovementFloat AS MovementFloat_BankSecondTwo_num
                                    ON MovementFloat_BankSecondTwo_num.MovementId =  Movement_BankSecondNum.Id
                                   AND MovementFloat_BankSecondTwo_num.DescId = zc_MovementFloat_BankSecondTwo_num()

            LEFT JOIN MovementFloat AS MovementFloat_BankSecondDiff_num
                                    ON MovementFloat_BankSecondDiff_num.MovementId =  Movement_BankSecondNum.Id
                                   AND MovementFloat_BankSecondDiff_num.DescId = zc_MovementFloat_BankSecondDiff_num()

            -- Ограничить доступ к этим ведомостям
            LEFT JOIN ObjectBoolean AS OB_PersonalServiceList_User
                                    ON OB_PersonalServiceList_User.ObjectId  = tmpMovement.PersonalServiceListId
                                   AND OB_PersonalServiceList_User.DescId    = zc_ObjectBoolean_PersonalServiceList_User()
                                   AND OB_PersonalServiceList_User.ValueData = TRUE

            -- эл.подписи
            LEFT JOIN tmpSign ON tmpSign.Id = Movement.Id

      WHERE (vbUserId NOT IN (/*5,*/ 9457) or tmpMovement.PersonalServiceListId <> 416828)
         -- + НЕТ ограничения у Ведомости
        AND (OB_PersonalServiceList_User.ObjectId IS NULL
          OR vbIsLevelMax01 = TRUE
          --OR vbUserId = 2573318
          OR vbUserId = 5
            )
        AND (Object_PersonalServiceList.ValueData NOT ILIKE '%Костя%'
          OR vbUserId NOT IN (5, 9457 , 4467766)
            )
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.03.24         * 
 15.02.24         * is4000
 04.07.23         * PriceNalog
 02.05.23         *
 24.04.23         *
 27.03.23         *
 17.11.23         *
 18.11.21         * TotalSummHouseAdd
 16.11.21         * isMail
 27.09.21         * isExport
 28.04.21         * 
 04.06.20         * add TotalDayAudit
 25.03.20         * add TotalSummAuditAdd
 27.01.20         *
 15.10.19         *
 29.07.19         *
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
-- SELECT * FROM gpSelect_Movement_PersonalService (inStartDate:= '30.01.2024', inEndDate:= '01.02.2024', inJuridicalBasisId:= 0, inIsServiceDate:= FALSE, inIsErased:= FALSE, inSession:= '2')
