-- Function: gpReport_Personal_ServiceSumm

DROP FUNCTION IF EXISTS gpReport_Personal_ServiceSumm (TDateTime, TDateTime, TDateTime, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Personal_ServiceSumm (TDateTime, TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Personal_ServiceSumm(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inServiceDate      TDateTime , --
    IN inIsServiceDate    Boolean , --
    IN inIsMember         Boolean , -- по физ лицу
    IN inAccountId        Integer,    -- Счет
    IN inBranchId         Integer,    -- филиал
    IN inInfoMoneyId      Integer,    -- Управленческая статья
    IN inInfoMoneyGroupId Integer,    -- Группа управленческих статей
    IN inInfoMoneyDestinationId   Integer,    --
    IN inPersonalServiceListId    Integer,    -- ведомость
    IN inPersonalId       Integer,    -- Фио сотрудника
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, MovementDescName TVarChar
             , OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , ServiceDate TDateTime
             , StartBeginDate TDateTime, EndBeginDate TDateTime
             , ServiceSumm_inf TFloat 
              
             , TotalSumm TFloat, TotalSummToPay TFloat, TotalSummCash TFloat, TotalSummService TFloat
             , TotalSummCard TFloat, TotalSummCardSecond TFloat, TotalSummCardSecondCash TFloat
             , TotalSummNalog TFloat, TotalSummMinus TFloat
             , TotalSummAdd TFloat
             , Comment TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar

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
             
             , JuridicalId Integer, JuridicalName TVarChar
             , isAuto Boolean, isDetail Boolean, isExport Boolean
             , isMail Boolean 
             
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMemberId   Integer;
   DECLARE vbIsList_all Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Проверка прав роль - Ограничение просмотра данных ЗП!!!
     PERFORM lpCheck_UserRole_8813637 (vbUserId);


     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;

     -- !!! права пользователей !!!
     IF EXISTS (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId)
     THEN
         inBranchId:= (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId);
     END IF;

     -- !!! округление !!!
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);


     -- Результат
     RETURN QUERY
     WITH
     _tmpPersonal AS(SELECT ObjectLink_Personal_Member.ObjectId AS PersonalId
                     FROM ObjectLink AS ObjectLink_Personal_Member
                     WHERE ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                       AND inIsMember = TRUE AND COALESCE (inPersonalId,0) <> 0
                       AND ObjectLink_Personal_Member.ChildObjectId IN (SELECT ObjectLink_Personal_Member.ChildObjectId AS MemberId
                                                                        FROM ObjectLink AS ObjectLink_Personal_Member
                                                                        WHERE ObjectLink_Personal_Member.ObjectId = inPersonalId
                                                                          AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                                                        )
                     UNION
                      SELECT Object.Id
                      FROM Object
                      WHERE Object.DescId = zc_Object_Personal()
                      AND ( ((Object.Id = inPersonalId OR COALESCE (inPersonalId,0) = 0) AND inIsMember = FALSE)
                          OR (COALESCE (inPersonalId,0) = 0 AND inIsMember = TRUE) )
                     )

   , tmpContainer AS (SELECT CLO_Personal.ContainerId         AS ContainerId
                      FROM ContainerLinkObject AS CLO_Personal
                           INNER JOIN Container ON Container.Id = CLO_Personal.ContainerId AND Container.DescId = zc_Container_Summ()
                           INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                          ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                           LEFT JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                         ON CLO_PersonalServiceList.ContainerId = Container.Id
                                                        AND CLO_PersonalServiceList.DescId = zc_ContainerLinkObject_PersonalServiceList()

                           LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                         ON CLO_Unit.ContainerId = Container.Id AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                           LEFT JOIN ContainerLinkObject AS CLO_Position
                                                         ON CLO_Position.ContainerId = Container.Id AND CLO_Position.DescId = zc_ContainerLinkObject_Position()
                           LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                         ON CLO_Branch.ContainerId = Container.Id AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()

                           LEFT JOIN ContainerLinkObject AS CLO_ServiceDate
                                                         ON CLO_ServiceDate.ContainerId = CLO_Personal.ContainerId
                                                        AND CLO_ServiceDate.DescId = zc_ContainerLinkObject_ServiceDate()
                           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = CLO_InfoMoney.ObjectId
                           LEFT JOIN ObjectDate AS ObjectDate_Service
                                                ON ObjectDate_Service.ObjectId = CLO_ServiceDate.ObjectId
                                               AND ObjectDate_Service.DescId = zc_ObjectDate_ServiceDate_Value()
                      WHERE CLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                        --AND (CLO_Personal.ObjectId = inPersonalId OR inPersonalId = 0)  -- через _tmpPersonal
                        AND CLO_Personal.ObjectId  IN (SELECT _tmpPersonal.PersonalId FROM _tmpPersonal)
                        AND (Object_InfoMoney_View.InfoMoneyDestinationId = inInfoMoneyDestinationId OR inInfoMoneyDestinationId = 0)
                        AND (Object_InfoMoney_View.InfoMoneyId = inInfoMoneyId OR inInfoMoneyId = 0)
                        AND (Object_InfoMoney_View.InfoMoneyGroupId = inInfoMoneyGroupId OR inInfoMoneyGroupId = 0)
                        AND (Container.ObjectId = inAccountId OR inAccountId = 0)
                        AND (CLO_Branch.ObjectId = inBranchId OR inBranchId = 0)
                        AND (ObjectDate_Service.ValueData = inServiceDate OR inIsServiceDate = FALSE)
                        AND (CLO_PersonalServiceList.ObjectId = inPersonalServiceListId OR COALESCE (inPersonalServiceListId,0) = 0)
                      )

   , tmpMIContainer AS (SELECT MIContainer.*
                        FROM tmpContainer
                             INNER JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.Containerid = tmpContainer.ContainerId
                                                             AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
                       )

   , tmpMovement AS (SELECT MIContainer.MovementId
                          , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_PersonalService_Nalog(), zc_Enum_AnalyzerId_PersonalService_NalogRet()) THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_PersonalService(), zc_Movement_PersonalTransport()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ServiceSumm
                     FROM tmpContainer
                          LEFT JOIN tmpMIContainer AS MIContainer
                                                   ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                  AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                     GROUP BY MIContainer.MovementId
                     HAVING 0 <> SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_PersonalService_Nalog(), zc_Enum_AnalyzerId_PersonalService_NalogRet()) THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_PersonalService(), zc_Movement_PersonalTransport()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)
                    )



     SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber   
           , MovementDesc.ItemName     ::TVarChar       AS MovementDescName
           , Movement.OperDate                          AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , MovementDate_ServiceDate.ValueData         AS ServiceDate
           , MovementDate_StartBegin.ValueData          AS StartBeginDate
           , MovementDate_EndBegin.ValueData            AS EndBeginDate

           , tmpMovement.ServiceSumm ::TFloat AS ServiceSumm_inf

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
           
           , MovementString_Comment.ValueData           AS Comment
           , Object_PersonalServiceList.Id              AS PersonalServiceListId
           , Object_PersonalServiceList.ValueData       AS PersonalServiceListName
           
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


           , Object_Juridical.Id                        AS JuridicalId
           , Object_Juridical.ValueData                 AS JuridicalName

           , COALESCE(MovementBoolean_isAuto.ValueData, False) :: Boolean  AS isAuto
           , COALESCE(MovementBoolean_Detail.ValueData, False) :: Boolean  AS isDetail
           , COALESCE(MovementBoolean_Export.ValueData, False) :: Boolean  AS isExport
           , COALESCE(MovementBoolean_Mail.ValueData, False)   :: Boolean  AS isMail
           
        
     FROM tmpMovement
          LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId
          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                       ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                      AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()          

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

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId
           -- LEFT JOIN tmpMember ON tmpMember.PersonalServiceListId = MovementLinkObject_PersonalServiceList.ObjectId

           -- LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpMember.MemberId

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
     ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.07.23         *
*/

-- тест
-- 
-- select * from gpReport_Personal_ServiceSumm (inStartDate := ('01.06.2023')::TDateTime , inEndDate := ('30.06.2023')::TDateTime , inServiceDate := ('27.06.2023')::TDateTime , inisServiceDate := 'TRUE' , inisMember := 'False', inAccountId := 0 , inBranchId := 301310 , inInfoMoneyId := 273733 , inInfoMoneyGroupId := 0 , inInfoMoneyDestinationId := 0 , inPersonalServiceListId := 0 , inPersonalId := 633146 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');


--select * from object where id = 633146