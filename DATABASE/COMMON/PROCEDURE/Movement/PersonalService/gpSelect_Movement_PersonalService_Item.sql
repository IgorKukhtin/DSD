 -- Function: gpSelect_Movement_PersonalService_Item()

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService_Item (TDateTime, TDateTime, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalService_Item(
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
             , TotalSummNalog TFloat, TotalSummMinus TFloat
             , TotalSummAdd TFloat
             , TotalSummAuditAdd TFloat, TotalDayAudit TFloat
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
             , Comment TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , isAuto Boolean, isDetail Boolean, isExport Boolean
             , isMail Boolean
             , strSign        TVarChar -- ФИО пользователей. - есть эл. подпись
             , strSignNo      TVarChar -- ФИО пользователей. - ожидается эл. подпись
             , MemberName     TVarChar  

             , MovementItemId Integer
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , MemberId_Personal Integer
             , INN TVarChar, Code1C TVarChar, Card TVarChar, CardSecond TVarChar
             --, CardIBAN TVarChar, CardIBANSecond TVarChar
             , isMain Boolean, isOfficial Boolean, DateOut TDateTime, DateIn TDateTime
             --, PersonalCode_to Integer, PersonalName_to TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PositionId Integer, PositionName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , MemberId_mi Integer, MemberName_mi TVarChar
             , PersonalServiceListId_mi Integer, PersonalServiceListName_mi TVarChar
             , FineSubjectId Integer, FineSubjectName TVarChar
             , UnitFineSubjectId Integer, UnitFineSubjectName TVarChar
             --, StaffListSummKindName TVarChar
             , Amount TFloat, AmountToPay TFloat, AmountCash TFloat, SummService TFloat
             , SummCard TFloat, SummCardRecalc TFloat, SummCardSecond TFloat, SummCardSecondRecalc TFloat, SummCardSecondDiff TFloat, SummCardSecondCash TFloat
             , SummNalog TFloat, SummNalogRecalc TFloat
             , SummNalogRet TFloat, SummNalogRetRecalc TFloat
             , SummMinus TFloat, SummFine TFloat, SummFineOth TFloat, SummFineOthRecalc TFloat
             , SummAdd TFloat, SummAuditAdd TFloat
             , SummHoliday TFloat, SummHosp TFloat, SummHospOth TFloat, SummHospOthRecalc TFloat
             , SummSocialIn TFloat, SummSocialAdd TFloat
             , SummChild TFloat, SummChildRecalc TFloat, SummMinusExt TFloat, SummMinusExtRecalc TFloat
             , SummTransport TFloat, SummTransportAdd TFloat, SummTransportAddLong TFloat, SummTransportTaxi TFloat, SummPhone TFloat
             --, Amount_avance TFloat
             --, TotalSummChild TFloat, SummDiff TFloat
             --, DayCount_child TFloat
             --, WorkTimeHoursOne_child TFloat
             --, Price_child TFloat
            
             , SummAddOth TFloat, SummAddOthRecalc TFloat
             , SummHouseAdd TFloat 
             
             , SummAvance TFloat, SummAvanceRecalc TFloat

             , SummCompensation TFloat, SummCompensationRecalc TFloat
             , DayCompensation TFloat, PriceCompensation TFloat
             , DayVacation TFloat, DayHoliday TFloat, DayWork TFloat
             , DayAudit TFloat
             , Number TVarChar
             , Comment_mi TVarChar
             , isErased Boolean
             , isAuto_mi Boolean
             , isBankOut Boolean
             , BankOutDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalService());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Проверка прав роль - Ограничение просмотра данных ЗП!!!
     PERFORM lpCheck_UserRole_8813637 (vbUserId);


     -- Блокируем ему просмотр
     IF 1=0 AND vbUserId = 9457 -- Климентьев К.И.
     THEN
        vbUserId:= NULL;
         RETURN;
     END IF;

     ---
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE ('tmpPersonalServiceList_check'))
     THEN
          -- Оптимизация
          CREATE TEMP TABLE tmpPersonalServiceList_check ON COMMIT DROP AS 
            WITH tmpUserAll_check AS (SELECT UserId FROM Constant_User_LevelMax01_View WHERE UserId = vbUserId /*AND UserId <> 9464*/) -- Документы-меню (управленцы) AND <> Рудик Н.В. + ЗП просмотр ВСЕ
            SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
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
              AND (EXISTS (SELECT 1 FROM tmpUserAll_check)
               OR vbUserId = 80373 -- Прохорова С.А.
                  )
           UNION
            -- Админ и другие видят ВСЕХ
            SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
            FROM Object AS Object_PersonalServiceList
            WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
              AND EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceAdmin())
           ;
     END IF;
     

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAll AS (SELECT UserId FROM Constant_User_LevelMax01_View
                         WHERE UserId = vbUserId   -- Документы-меню (управленцы) AND <> Рудик Н.В. + ЗП просмотр ВСЕ
                         --AND vbUserId <> zfCalc_UserMain()
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
                           AND EXISTS (SELECT 1 FROM tmpUserAll)
                        UNION
                         -- Админ и другие видят ВСЕХ
                         SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                         FROM Object AS Object_PersonalServiceList
                         WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                           AND EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceAdmin())
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
        , tmpMember AS (SELECT tmp.PersonalServiceListId 
                             , ObjectLink_PersonalServiceList_Member.ChildObjectId AS MemberId
                        FROM (SELECT DISTINCT tmpMovement.PersonalServiceListId FROM tmpMovement) AS tmp
                             LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                                  ON ObjectLink_PersonalServiceList_Member.ObjectId = tmp.PersonalServiceListId 
                                                 AND ObjectLink_PersonalServiceList_Member.DescId = zc_ObjectLink_PersonalServiceList_Member()
                       )

        , tmpMI_All AS (SELECT MovementItem.*
                        FROM tmpMovement
                           INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.isErased = FALSE
                        )

        , tmpMI AS (SELECT MovementItem.MovementId
                         , MovementItem.Id                          AS MovementItemId
                         , MovementItem.Amount
                         , MovementItem.ObjectId                    AS PersonalId
                         , MILinkObject_Unit.ObjectId               AS UnitId
                         , MILinkObject_Position.ObjectId           AS PositionId
                         , MILinkObject_InfoMoney.ObjectId          AS InfoMoneyId
                         , MILinkObject_Member.ObjectId             AS MemberId
                         , ObjectLink_Personal_Member.ChildObjectId AS MemberId_Personal
                         , MILinkObject_PersonalServiceList.ObjectId AS PersonalServiceListId
                         , MovementItem.isErased
                    FROM tmpMI_All AS MovementItem
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                          ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                          ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                          ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                                          ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_Member.DescId = zc_MILinkObject_Member()
                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                              ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                             AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

                         LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                                          ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_PersonalServiceList.DescId = zc_MILinkObject_PersonalServiceList()
                   )

        , tmpMovementItemString AS (SELECT MovementItemString.*
                                    FROM MovementItemString
                                    WHERE MovementItemString.MovementItemId IN (SELECT tmpMI_All.Id FROM tmpMI_All)
                                      AND MovementItemString.DescId IN (zc_MIString_Comment()
                                                                      , zc_MIString_Number())
                                   )

        , tmpMovementItemBoolean AS (SELECT MovementItemBoolean.*
                                     FROM MovementItemBoolean
                                     WHERE MovementItemBoolean.MovementItemId IN (SELECT tmpMI_All.Id FROM tmpMI_All)
                                       AND MovementItemBoolean.DescId IN (zc_MIBoolean_Main()
                                                                        , zc_MIBoolean_isAuto())
                                    )

        , tmpMovementItemDate AS (SELECT MovementItemDate.*
                                  FROM MovementItemDate
                                  WHERE MovementItemDate.MovementItemId IN (SELECT tmpMI_All.Id FROM tmpMI_All)
                                    AND MovementItemDate.DescId IN (zc_MIDate_BankOut())
                                 )

        , tmpMovementItemFloat AS (SELECT MovementItemFloat.*
                                   FROM MovementItemFloat
                                   WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI_All.Id FROM tmpMI_All)
                                   ) 

        , tmpMovementItemLinkObject AS (SELECT MovementItemLinkObject.*
                                        FROM MovementItemLinkObject
                                        WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMI_All.Id FROM tmpMI_All)
                                          AND MovementItemLinkObject.DescId IN (zc_MILinkObject_FineSubject()
                                                                              , zc_MILinkObject_UnitFineSubject())
                                       )
   

       -- Результат
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
           , MovementFloat_TotalSummAuditAdd.ValueData   AS TotalSummAuditAdd
           , MovementFloat_TotalDayAudit.ValueData       AS TotalDayAudit

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
           , MovementFloat_TotalAvanceRecalc.ValueData  :: TFloat AS TotalAvanceRecalc

           , MovementString_Comment.ValueData           AS Comment
           , Object_PersonalServiceList.Id              AS PersonalServiceListId
           , Object_PersonalServiceList.ValueData       AS PersonalServiceListName
           , Object_Juridical.Id                        AS JuridicalId
           , Object_Juridical.ValueData                 AS JuridicalName

           , COALESCE(MovementBoolean_isAuto.ValueData, False) :: Boolean  AS isAuto
           , COALESCE(MovementBoolean_Detail.ValueData, False) :: Boolean  AS isDetail
           , COALESCE(MovementBoolean_Export.ValueData, False) :: Boolean  AS isExport
           , COALESCE(MovementBoolean_Mail.ValueData, False)   :: Boolean  AS isMail

           , tmpSign.strSign
           , tmpSign.strSignNo 

           , Object_Member.ValueData                    AS MemberName

           ---------------
            , tmpAll.MovementItemId                         AS Id
            , Object_Personal.Id                            AS PersonalId
            , Object_Personal.ObjectCode                    AS PersonalCode
            , Object_Personal.ValueData                     AS PersonalName
            , tmpAll.MemberId_Personal
            , ObjectString_Member_INN.ValueData             AS INN
            , ObjectString_Code1C.ValueData                 AS Code1C
            , ObjectString_Member_Card.ValueData            AS Card
            , ObjectString_Member_CardSecond.ValueData      AS CardSecond
            --, ObjectString_Member_CardIBAN.ValueData        AS CardIBAN
            --, ObjectString_Member_CardIBANSecond.ValueData  AS CardIBANSecond
            , CASE WHEN tmpAll.MovementItemId > 0 AND 1=0 /*vbUserId <> 5*/ THEN COALESCE (MIBoolean_Main.ValueData, FALSE) ELSE COALESCE (ObjectBoolean_Personal_Main.ValueData, FALSE) END :: Boolean AS isMain
            , COALESCE (ObjectBoolean_Member_Official.ValueData, FALSE) :: Boolean AS isOfficial
              -- дата увольнения
            , CASE WHEN COALESCE (ObjectDate_Personal_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN NULL ELSE ObjectDate_Personal_DateOut.ValueData END     :: TDateTime AS DateOut
             -- дата приема на работу - только если мес начислений соотв месяцу приема 
            , CASE WHEN DATE_TRUNC ('Month', ObjectDate_DateIn.ValueData) = DATE_TRUNC ('Month', MovementDate_ServiceDate.ValueData) THEN ObjectDate_DateIn.ValueData ELSE NULL END ::TDateTime AS DateIn 
            --, Object_PersonalTo.ObjectCode            AS PersonalCode_to
            --, Object_PersonalTo.ValueData             AS PersonalName_to

            , Object_Unit.Id                          AS UnitId
            , Object_Unit.ObjectCode                  AS UnitCode
            , Object_Unit.ValueData                   AS UnitName
            , Object_Position.Id                      AS PositionId
            , Object_Position.ValueData               AS PositionName
            , View_InfoMoney.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName
            , View_InfoMoney.InfoMoneyName_all

            , COALESCE (Object_Member_mi.Id, 0)          AS MemberId_mi
            , COALESCE (Object_Member_mi.ValueData, ''::TVarChar) AS MemberName_mi

            , COALESCE (Object_PersonalServiceList_mi.Id, 0)                   AS PersonalServiceListId
            , COALESCE (Object_PersonalServiceList_mi.ValueData, ''::TVarChar) AS PersonalServiceListName

            , COALESCE (Object_FineSubject.Id, 0)         :: Integer  AS FineSubjectId
            , COALESCE (Object_FineSubject.ValueData, '') :: TVarChar AS FineSubjectName

            , COALESCE (Object_UnitFineSubject.Id, 0)         :: Integer  AS UnitFineSubjectId
            , COALESCE (Object_UnitFineSubject.ValueData, '') :: TVarChar AS UnitFineSubjectName
            
            --, COALESCE (tmpMIChild.StaffListSummKindName,'') ::TVarChar AS StaffListSummKindName

            , tmpAll.Amount :: TFloat           AS Amount
            , MIFloat_SummToPay.ValueData       AS AmountToPay
            , (COALESCE (MIFloat_SummToPay.ValueData, 0)
            + (-1) *  CASE WHEN 1=0 AND vbUserId = 5
                               THEN 0
                          ELSE COALESCE (MIFloat_SummCard.ValueData, 0)
                             + COALESCE (MIFloat_SummCardSecond.ValueData, 0)
                             + COALESCE (MIFloat_SummCardSecondCash.ValueData, 0)
                      END 
              ) :: TFloat AS AmountCash
            , MIFloat_SummService.ValueData           AS SummService
            , MIFloat_SummCard.ValueData              AS SummCard
            , MIFloat_SummCardRecalc.ValueData        AS SummCardRecalc
            , MIFloat_SummCardSecond.ValueData        AS SummCardSecond
            , MIFloat_SummCardSecondRecalc.ValueData  AS SummCardSecondRecalc
            , MIFloat_SummCardSecondDiff.ValueData    AS SummCardSecondDiff
            , MIFloat_SummCardSecondCash.ValueData    AS SummCardSecondCash
            , MIFloat_SummNalog.ValueData             AS SummNalog
            , MIFloat_SummNalogRecalc.ValueData       AS SummNalogRecalc
            , MIFloat_SummNalogRet.ValueData          AS SummNalogRet
            , MIFloat_SummNalogRetRecalc.ValueData    AS SummNalogRetRecalc
            , MIFloat_SummMinus.ValueData             AS SummMinus
            , MIFloat_SummFine.ValueData              AS SummFine
            , MIFloat_SummFineOth.ValueData           AS SummFineOth
            , MIFloat_SummFineOthRecalc.ValueData     AS SummFineOthRecalc
            , MIFloat_SummAdd.ValueData               AS SummAdd
            , MIFloat_SummAuditAdd.ValueData          AS SummAuditAdd
            , MIFloat_SummHoliday.ValueData           AS SummHoliday
            , MIFloat_SummHosp.ValueData              AS SummHosp
            , MIFloat_SummHospOth.ValueData           AS SummHospOth
            , MIFloat_SummHospOthRecalc.ValueData     AS SummHospOthRecalc
            , MIFloat_SummSocialIn.ValueData          AS SummSocialIn
            , MIFloat_SummSocialAdd.ValueData         AS SummSocialAdd
            , MIFloat_SummChild.ValueData             AS SummChild
            , MIFloat_SummChildRecalc.ValueData       AS SummChildRecalc
            , MIFloat_SummMinusExt.ValueData          AS SummMinusExt
            , MIFloat_SummMinusExtRecalc.ValueData    AS SummMinusExtRecalc

            , MIFloat_SummTransport.ValueData         AS SummTransport
            , MIFloat_SummTransportAdd.ValueData      AS SummTransportAdd
            , MIFloat_SummTransportAddLong.ValueData  AS SummTransportAddLong
            , MIFloat_SummTransportTaxi.ValueData     AS SummTransportTaxi
            , MIFloat_SummPhone.ValueData             AS SummPhone
            --, ( 1 * tmpMIContainer_pay.Amount_avance) :: TFloat AS Amount_avance

            --, COALESCE (tmpMIChild.Amount, 0)                                                 :: TFloat AS TotalSummChild
            --, (COALESCE (tmpMIChild.Amount, 0) - COALESCE (MIFloat_SummService.ValueData, 0)) :: TFloat AS SummDiff
            --, COALESCE (tmpMIChild.DayCount, 0)         ::TFloat AS DayCount_child
            --, COALESCE (tmpMIChild.WorkTimeHoursOne, 0) ::TFloat AS WorkTimeHoursOne_child
            --, COALESCE (tmpMIChild.Price, 0)            ::TFloat AS Price_child

            , MIFloat_SummAddOth.ValueData              AS SummAddOth
            , MIFloat_SummAddOthRecalc.ValueData        AS SummAddOthRecalc
            , MIFloat_SummHouseAdd.ValueData  ::TFloat  AS SummHouseAdd

            , MIFloat_SummAvance.ValueData        ::TFloat AS SummAvance
            , MIFloat_SummAvanceRecalc.ValueData  ::TFloat AS SummAvanceRecalc

            , CASE WHEN tmpPersonalServiceList_check.PersonalServiceListId > 0 OR tmpAll.PersonalServiceListId IS NULL THEN MIFloat_SummCompensation.ValueData        ELSE 0 END ::TFloat AS SummCompensation
            , CASE WHEN tmpPersonalServiceList_check.PersonalServiceListId > 0 OR tmpAll.PersonalServiceListId IS NULL THEN MIFloat_SummCompensationRecalc.ValueData  ELSE 0 END ::TFloat AS SummCompensationRecalc
            
            , MIFloat_DayCompensation.ValueData AS DayCompensation
            , CASE WHEN tmpPersonalServiceList_check.PersonalServiceListId > 0 OR tmpAll.PersonalServiceListId IS NULL THEN MIFloat_PriceCompensation.ValueData       ELSE 0 END ::TFloat AS PriceCompensation
            
            , MIFloat_DayVacation.ValueData             ::TFloat AS DayVacation
            , MIFloat_DayHoliday.ValueData              ::TFloat AS DayHoliday
            , MIFloat_DayWork.ValueData                 ::TFloat AS DayWork
            , MIFloat_DayAudit.ValueData                ::TFloat AS DayAudit



            , MIString_Number.ValueData   ::TVarChar AS Number
            , MIString_Comment.ValueData             AS Comment_mi
            , tmpAll.isErased
            , COALESCE (MIBoolean_isAuto.ValueData, FALSE)      :: Boolean   AS isAuto_mi
            , COALESCE (ObjectBoolean_BankOut.ValueData, FALSE) :: Boolean   AS isBankOut
            , MIDate_BankOut.ValueData                          :: TDateTime AS BankOutDate           

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

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAuditAdd
                                    ON MovementFloat_TotalSummAuditAdd.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummAuditAdd.DescId = zc_MovementFloat_TotalSummAuditAdd()

            LEFT JOIN MovementFloat AS MovementFloat_TotalDayAudit
                                    ON MovementFloat_TotalDayAudit.MovementId = Movement.Id
                                   AND MovementFloat_TotalDayAudit.DescId = zc_MovementFloat_TotalDayAudit()

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
                                     
            -- эл.подписи
            LEFT JOIN tmpSign ON tmpSign.Id = Movement.Id   
            
            ---строки
            LEFT JOIN tmpMI AS tmpAll
                            ON tmpAll.MovementId = Movement.Id
                                   --AND MovementItem.isErased = tmpIsErased.isErased
            LEFT JOIN tmpMovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpAll.MovementItemId
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN tmpMovementItemString AS MIString_Number
                                         ON MIString_Number.MovementItemId = tmpAll.MovementItemId
                                        AND MIString_Number.DescId = zc_MIString_Number()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummToPay
                                        ON MIFloat_SummToPay.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummToPay.DescId = zc_MIFloat_SummToPay()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummService
                                        ON MIFloat_SummService.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummService.DescId = zc_MIFloat_SummService()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummCard
                                        ON MIFloat_SummCard.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummCard.DescId = zc_MIFloat_SummCard()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummCardRecalc
                                        ON MIFloat_SummCardRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummCardRecalc.DescId = zc_MIFloat_SummCardRecalc()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummCardSecond
                                        ON MIFloat_SummCardSecond.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummCardSecond.DescId = zc_MIFloat_SummCardSecond()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummCardSecondRecalc
                                        ON MIFloat_SummCardSecondRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummCardSecondRecalc.DescId = zc_MIFloat_SummCardSecondRecalc()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummCardSecondDiff
                                        ON MIFloat_SummCardSecondDiff.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummCardSecondDiff.DescId         = zc_MIFloat_SummCardSecondDiff()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummCardSecondCash
                                        ON MIFloat_SummCardSecondCash.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummCardSecondCash.DescId = zc_MIFloat_SummCardSecondCash()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummNalog
                                        ON MIFloat_SummNalog.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummNalog.DescId = zc_MIFloat_SummNalog()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummNalogRecalc
                                        ON MIFloat_SummNalogRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummNalogRecalc.DescId = zc_MIFloat_SummNalogRecalc()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummNalogRet
                                        ON MIFloat_SummNalogRet.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummNalogRet.DescId = zc_MIFloat_SummNalogRet()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummNalogRetRecalc
                                        ON MIFloat_SummNalogRetRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummNalogRetRecalc.DescId = zc_MIFloat_SummNalogRetRecalc()
                                       
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummMinus
                                        ON MIFloat_SummMinus.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummMinus.DescId = zc_MIFloat_SummMinus()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummFine
                                        ON MIFloat_SummFine.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummFine.DescId = zc_MIFloat_SummFine()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummFineOth
                                        ON MIFloat_SummFineOth.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummFineOth.DescId = zc_MIFloat_SummFineOth()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummFineOthRecalc
                                        ON MIFloat_SummFineOthRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummFineOthRecalc.DescId = zc_MIFloat_SummFineOthRecalc()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummAdd
                                        ON MIFloat_SummAdd.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummAuditAdd
                                        ON MIFloat_SummAuditAdd.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummAuditAdd.DescId = zc_MIFloat_SummAuditAdd()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummHoliday
                                        ON MIFloat_SummHoliday.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummHoliday.DescId = zc_MIFloat_SummHoliday()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummHosp
                                        ON MIFloat_SummHosp.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummHosp.DescId = zc_MIFloat_SummHosp()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummHospOth
                                        ON MIFloat_SummHospOth.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummHospOth.DescId = zc_MIFloat_SummHospOth()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummHospOthRecalc
                                        ON MIFloat_SummHospOthRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummHospOthRecalc.DescId = zc_MIFloat_SummHospOthRecalc()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummSocialIn
                                        ON MIFloat_SummSocialIn.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummSocialIn.DescId = zc_MIFloat_SummSocialIn()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummSocialAdd
                                        ON MIFloat_SummSocialAdd.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummSocialAdd.DescId = zc_MIFloat_SummSocialAdd()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummChild
                                        ON MIFloat_SummChild.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummChild.DescId = zc_MIFloat_SummChild()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummChildRecalc
                                        ON MIFloat_SummChildRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummChildRecalc.DescId = zc_MIFloat_SummChildRecalc()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummMinusExt
                                        ON MIFloat_SummMinusExt.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummMinusExt.DescId = zc_MIFloat_SummMinusExt()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummMinusExtRecalc
                                        ON MIFloat_SummMinusExtRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummMinusExtRecalc.DescId = zc_MIFloat_SummMinusExtRecalc()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummTransport
                                        ON MIFloat_SummTransport.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummTransport.DescId = zc_MIFloat_SummTransport()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummTransportAdd
                                        ON MIFloat_SummTransportAdd.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummTransportAdd.DescId = zc_MIFloat_SummTransportAdd()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummTransportAddLong
                                        ON MIFloat_SummTransportAddLong.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummTransportAddLong.DescId = zc_MIFloat_SummTransportAddLong()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummTransportTaxi
                                        ON MIFloat_SummTransportTaxi.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummTransportTaxi.DescId = zc_MIFloat_SummTransportTaxi()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummPhone
                                        ON MIFloat_SummPhone.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummPhone.DescId = zc_MIFloat_SummPhone()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummAddOth
                                        ON MIFloat_SummAddOth.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummAddOth.DescId = zc_MIFloat_SummAddOth()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummAddOthRecalc
                                        ON MIFloat_SummAddOthRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummAddOthRecalc.DescId = zc_MIFloat_SummAddOthRecalc()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummHouseAdd
                                        ON MIFloat_SummHouseAdd.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummHouseAdd.DescId = zc_MIFloat_SummHouseAdd()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummCompensation
                                        ON MIFloat_SummCompensation.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummCompensation.DescId = zc_MIFloat_SummCompensation()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummCompensationRecalc
                                        ON MIFloat_SummCompensationRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummCompensationRecalc.DescId = zc_MIFloat_SummCompensationRecalc()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_DayCompensation
                                        ON MIFloat_DayCompensation.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_DayCompensation.DescId = zc_MIFloat_DayCompensation()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_PriceCompensation
                                        ON MIFloat_PriceCompensation.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_PriceCompensation.DescId = zc_MIFloat_PriceCompensation()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_DayVacation
                                        ON MIFloat_DayVacation.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_DayVacation.DescId = zc_MIFloat_DayVacation()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_DayHoliday
                                        ON MIFloat_DayHoliday.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_DayHoliday.DescId = zc_MIFloat_DayHoliday()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_DayWork
                                        ON MIFloat_DayWork.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_DayWork.DescId = zc_MIFloat_DayWork()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_DayAudit
                                        ON MIFloat_DayAudit.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_DayAudit.DescId = zc_MIFloat_DayAudit()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummAvance
                                        ON MIFloat_SummAvance.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummAvance.DescId = zc_MIFloat_SummAvance()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_SummAvanceRecalc
                                        ON MIFloat_SummAvanceRecalc.MovementItemId = tmpAll.MovementItemId
                                       AND MIFloat_SummAvanceRecalc.DescId = zc_MIFloat_SummAvanceRecalc()

            LEFT JOIN tmpMovementItemBoolean AS MIBoolean_Main
                                          ON MIBoolean_Main.MovementItemId = tmpAll.MovementItemId
                                         AND MIBoolean_Main.DescId = zc_MIBoolean_Main()

            LEFT JOIN tmpMovementItemBoolean AS MIBoolean_isAuto
                                          ON MIBoolean_isAuto.MovementItemId = tmpAll.MovementItemId
                                         AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

            LEFT JOIN tmpMovementItemDate AS MIDate_BankOut
                                          ON MIDate_BankOut.MovementItemId = tmpAll.MovementItemId
                                         AND MIDate_BankOut.DescId = zc_MIDate_BankOut()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_BankOut
                                    ON ObjectBoolean_BankOut.ObjectId = Object_PersonalServiceList.Id 
                                   AND ObjectBoolean_BankOut.DescId = zc_ObjectBoolean_PersonalServiceList_BankOut()

            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpAll.PersonalId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpAll.UnitId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpAll.PositionId
            LEFT JOIN Object AS Object_Member_mi ON Object_Member_mi.Id = tmpAll.MemberId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpAll.InfoMoneyId
            LEFT JOIN Object AS Object_PersonalServiceList_mi ON Object_PersonalServiceList_mi.Id = tmpAll.PersonalServiceListId

            LEFT JOIN ObjectString AS ObjectString_Member_INN
                                   ON ObjectString_Member_INN.ObjectId = tmpAll.MemberId_Personal
                                  AND ObjectString_Member_INN.DescId = zc_ObjectString_Member_INN()
            LEFT JOIN ObjectString AS ObjectString_Member_Card
                                   ON ObjectString_Member_Card.ObjectId = tmpAll.MemberId_Personal
                                  AND ObjectString_Member_Card.DescId = zc_ObjectString_Member_Card()
            LEFT JOIN ObjectString AS ObjectString_Member_CardSecond
                                   ON ObjectString_Member_CardSecond.ObjectId = tmpAll.MemberId_Personal
                                  AND ObjectString_Member_CardSecond.DescId = zc_ObjectString_Member_CardSecond()

            LEFT JOIN ObjectString AS ObjectString_Code1C
                                   ON ObjectString_Code1C.ObjectId = tmpAll.PersonalId
                                  AND ObjectString_Code1C.DescId    = zc_ObjectString_Personal_Code1C()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal_Main
                                    ON ObjectBoolean_Personal_Main.ObjectId = tmpAll.PersonalId
                                   AND ObjectBoolean_Personal_Main.DescId = zc_ObjectBoolean_Personal_Main()
            LEFT JOIN ObjectDate AS ObjectDate_Personal_DateOut
                                 ON ObjectDate_Personal_DateOut.ObjectId = tmpAll.PersonalId
                                AND ObjectDate_Personal_DateOut.DescId = zc_ObjectDate_Personal_Out()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Member_Official
                                    ON ObjectBoolean_Member_Official.ObjectId = tmpAll.MemberId_Personal
                                   AND ObjectBoolean_Member_Official.DescId = zc_ObjectBoolean_Member_Official()

            LEFT JOIN ObjectDate AS ObjectDate_DateIn
                                 ON ObjectDate_DateIn.ObjectId = tmpAll.PersonalId
                                AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_In()   
                                
            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_FineSubject
                                             ON MILinkObject_FineSubject.MovementItemId = tmpAll.MovementItemId
                                            AND MILinkObject_FineSubject.DescId = zc_MILinkObject_FineSubject()
            LEFT JOIN Object AS Object_FineSubject ON Object_FineSubject.Id = MILinkObject_FineSubject.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_UnitFineSubject
                                             ON MILinkObject_UnitFineSubject.MovementItemId = tmpAll.MovementItemId
                                            AND MILinkObject_UnitFineSubject.DescId = zc_MILinkObject_UnitFineSubject()
            LEFT JOIN Object AS Object_UnitFineSubject ON Object_UnitFineSubject.Id = MILinkObject_UnitFineSubject.ObjectId
            
            LEFT JOIN tmpPersonalServiceList_check ON tmpPersonalServiceList_check.PersonalServiceListId = tmpAll.PersonalServiceListId
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
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
-- SELECT * FROM gpSelect_Movement_PersonalService (inStartDate:= '30.01.2015', inEndDate:= '01.02.2015', inJuridicalBasisId:= 0, inIsServiceDate:= FALSE, inIsErased:= FALSE, inSession:= '2')
--select * from gpSelect_Movement_PersonalService_Item(inStartDate := ('01.12.2022')::TDateTime , inEndDate := ('01.12.2022')::TDateTime , inJuridicalBasisId := 9399 , inIsServiceDate := 'False' , inIsErased := 'False' ,  inSession := '9457');