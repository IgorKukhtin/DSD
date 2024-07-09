-- Function: gpReport_Personal

DROP FUNCTION IF EXISTS gpReport_Personal (TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Personal (TDateTime, TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Personal(
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
RETURNS TABLE (PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , PersonalServiceListCode Integer, PersonalServiceListName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PositionCode Integer, PositionName TVarChar
             , BusinessName TVarChar
             , BranchName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , ProfitLossDirectionName TVarChar
             , AccountName TVarChar
             , ServiceDate TDateTime
             , StartAmount TFloat, StartAmountD TFloat, StartAmountK TFloat
             , DebetSumm TFloat, KreditSumm TFloat
             , MoneySumm TFloat, MoneySummCard TFloat, MoneySummCardSecond TFloat, MoneySummCash TFloat
             , ServiceSumm TFloat, ServiceSumm_inf TFloat, SummHoliday_inf TFloat, ServiceSumm_dif TFloat
             , IncomeSumm TFloat
             , SummTransportAdd TFloat, SummTransportAddLong TFloat, SummTransportTaxi TFloat, SummPhone TFloat, SummNalog TFloat, SummNalogRet TFloat
             , SummFine TFloat, SummHosp TFloat
             , EndAmount TFloat, EndAmountD TFloat, EndAmountK TFloat
             , AmountCash_rem TFloat
             , SummCard_inf           TFloat
             , SummCardSecond_inf     TFloat
             , SummCardSecondCash_inf TFloat
             , SummAvCardSecond_inf TFloat
             , SummToPay_inf TFloat
             , ContainerId Integer
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMemberId   Integer;
   DECLARE vbIsList_all Boolean;
   DECLARE vbIsLevelMax01 Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- !!!Проверка прав роль - Ограничение - нет вообще доступа к просмотру данных ЗП!!!
     PERFORM lpCheck_UserRole_8813637 (vbUserId);

  
     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= 5;
         --vbUserId:= NULL;
         --RETURN;
     END IF;


     -- доступ Документы-меню (управленцы) + ЗП просмотр ВСЕ
     vbIsLevelMax01:= EXISTS (SELECT 1 FROM Constant_User_LevelMax01_View WHERE Constant_User_LevelMax01_View.UserId = vbUserId)
             -- + если нет Ограничения - только разрешенные ведомости ЗП
             AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 10657326)
             -- + если нет Ограничения - нет доступа к просмотру ведомость Админ ЗП
             AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 11026035)
           ;

 
     -- !!! права пользователей !!!
     IF EXISTS (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId)
        AND vbUserId <> 14599 -- Коротченко Т.Н.
     THEN
         inBranchId:= (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId);
     END IF;

     -- !!! округление !!!
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- таблица сотрудников
   /*  CREATE TEMP TABLE _tmpPersonal (PersonalId Integer) ON COMMIT DROP;

     -- если inIsMember = TRUE тогда определяем сотрудника по физ лицу
     IF (inIsMember = TRUE) AND (COALESCE (inPersonalId,0) <> 0)
     THEN
         vbMemberId := (SELECT ObjectLink_Personal_Member.ChildObjectId AS MemberId
                        FROM ObjectLink AS ObjectLink_Personal_Member
                        WHERE ObjectLink_Personal_Member.ObjectId = inPersonalId
                          AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                        );
         
         INSERT INTO _tmpPersonal (PersonalId)
             SELECT ObjectLink_Personal_Member.ObjectId AS PersonalId
             FROM ObjectLink AS ObjectLink_Personal_Member
             WHERE ObjectLink_Personal_Member.ChildObjectId = vbMemberId
               AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member();
     END IF;

     IF (inIsMember = FALSE) OR ( (inIsMember = TRUE) AND (COALESCE (inPersonalId,0) = 0))
     THEN
     INSERT INTO _tmpPersonal (PersonalId)
         SELECT Object.Id
         FROM Object
         WHERE Object.DescId = zc_Object_Personal()
         AND (Object.Id = inPersonalId OR COALESCE (inPersonalId,0) = 0);
     END IF;
*/
  
     -- таблица - элементы
     -- CREATE TEMP TABLE _tmpList (PersonalServiceListId Integer) ON COMMIT DROP;

     -- таблица - элементы
     /*INSERT INTO _tmpList (PersonalServiceListId)
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
        SELECT ObjectLink_PersonalServiceList_Member.ObjectId AS PersonalServiceListId
        FROM ObjectLink AS ObjectLink_User_Member
             INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                   ON ObjectLink_PersonalServiceList_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                  AND ObjectLink_PersonalServiceList_Member.DescId        = zc_ObjectLink_PersonalServiceList_Member()
        WHERE ObjectLink_User_Member.ObjectId = vbUserId
          AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
       ;*/
     --
   --vbIsList_all:= EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   --            OR NOT EXISTS (SELECT 1 FROM _tmpList)
   --              ;
     vbIsList_all:= (-- Роль Админ
                     EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
                     -- или НЕТ разрешенных ведомостей ЗП
                  OR NOT EXISTS (-- В справочнике Разрешений
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
                                 -- В справочнике Ведомости
                                 SELECT ObjectLink_PersonalServiceList_Member.ObjectId AS PersonalServiceListId
                                 FROM ObjectLink AS ObjectLink_User_Member
                                      INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                                            ON ObjectLink_PersonalServiceList_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                           AND ObjectLink_PersonalServiceList_Member.DescId        = zc_ObjectLink_PersonalServiceList_Member()
                                 WHERE ObjectLink_User_Member.ObjectId = vbUserId
                                   AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                                )
                  OR vbUserId = 14599 -- Коротченко Т.Н.
                    )
                -- + если нет Ограничения - только разрешенные ведомости ЗП
                AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 10657326)
                   ;

     -- Результат
     RETURN QUERY
     WITH
     _tmpPersonal AS(
                     SELECT ObjectLink_Personal_Member.ObjectId AS PersonalId
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

     
     , _tmpList AS (SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
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
                       WHERE ObjectLink_User_Member.ObjectId = CASE WHEN vbUserId = 10352030 THEN 6561986 ELSE vbUserId END -- Брикова В.В.
                         AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                      UNION
                       SELECT ObjectLink_PersonalServiceList_Member.ObjectId AS PersonalServiceListId
                       FROM ObjectLink AS ObjectLink_User_Member
                            INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                                  ON ObjectLink_PersonalServiceList_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                 AND ObjectLink_PersonalServiceList_Member.DescId        = zc_ObjectLink_PersonalServiceList_Member()
                       WHERE ObjectLink_User_Member.ObjectId = CASE WHEN vbUserId = 10352030 THEN 6561986 ELSE vbUserId END
                         AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                      )
   , tmpContainer AS (SELECT CLO_Personal.ContainerId         AS ContainerId
                           , Container.ObjectId               AS AccountId
                           , Container.Amount
                           , CLO_Personal.ObjectId            AS PersonalId
                           , CLO_InfoMoney.ObjectId           AS InfoMoneyId
                           , CLO_Unit.ObjectId                AS UnitId
                           , CLO_Position.ObjectId            AS PositionId
                           , CLO_PersonalServiceList.ObjectId AS PersonalServiceListId
                           , CLO_Branch.ObjectId              AS BranchId
                           , ObjectDate_Service.ValueData     AS ServiceDate
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
   , tmpMIFloat_SummService AS (SELECT tmp.ContainerId
                                     , SUM (COALESCE (MIFloat_SummService.ValueData,0)) AS  SummService_inf
                                     , SUM (COALESCE (MIFloat_SummHoliday.ValueData,0)) AS  SummHoliday_inf
                                     , SUM (COALESCE (MIFloat_SummFine.ValueData,0))    AS  SummFine
                                     , SUM (COALESCE (MIFloat_SummHosp.ValueData,0))    AS  SummHosp
                                     , SUM (COALESCE (MIFloat_SummToPay.ValueData,0))        AS SummToPay_inf
                                     , SUM (COALESCE (MIFloat_SummAvCardSecond.ValueData,0)) AS SummAvCardSecond_inf
                                     , SUM (COALESCE (MIFloat_SummCard.ValueData,0))           AS SummCard_inf
                                     , SUM (COALESCE (MIFloat_SummCardSecond.ValueData,0))     AS SummCardSecond_inf
                                     , SUM (COALESCE (MIFloat_SummCardSecondCash.ValueData,0)) AS SummCardSecondCash_inf
                                FROM (SELECT DISTINCT MIContainer.ContainerId
                                           , MIContainer.MovementItemId
                                           , ROW_NUMBER() OVER (PARTITION BY MIContainer.MovementItemId ORDER BY MIContainer.MovementItemId, MIContainer.ContainerId) AS Ord
                                      FROM tmpMIContainer AS MIContainer
                                      WHERE MIContainer.MovementDescId IN (zc_Movement_PersonalService(), zc_Movement_PersonalTransport())
                                     ) AS tmp
                                      LEFT JOIN MovementItemFloat AS MIFloat_SummService
                                                                  ON MIFloat_SummService.MovementItemId = tmp.MovementItemId
                                                                 AND MIFloat_SummService.DescId         = zc_MIFloat_SummService()
                                      LEFT JOIN MovementItemFloat AS MIFloat_SummHoliday
                                                                  ON MIFloat_SummHoliday.MovementItemId = tmp.MovementItemId
                                                                 AND MIFloat_SummHoliday.DescId         = zc_MIFloat_SummHoliday()
                                      LEFT JOIN MovementItemFloat AS MIFloat_SummFine
                                                                  ON MIFloat_SummFine.MovementItemId = tmp.MovementItemId
                                                                 AND MIFloat_SummFine.DescId = zc_MIFloat_SummFine()
                                      LEFT JOIN MovementItemFloat AS MIFloat_SummHosp
                                                                  ON MIFloat_SummHosp.MovementItemId = tmp.MovementItemId
                                                                 AND MIFloat_SummHosp.DescId = zc_MIFloat_SummHosp()
                                      LEFT JOIN MovementItemFloat AS MIFloat_SummToPay
                                                                  ON MIFloat_SummToPay.MovementItemId = tmp.MovementItemId
                                                                 AND MIFloat_SummToPay.DescId = zc_MIFloat_SummToPay()
                                      LEFT JOIN MovementItemFloat AS MIFloat_SummCard
                                                                  ON MIFloat_SummCard.MovementItemId = tmp.MovementItemId
                                                                 AND MIFloat_SummCard.DescId = zc_MIFloat_SummCard() 
                                      LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecond
                                                                  ON MIFloat_SummCardSecond.MovementItemId = tmp.MovementItemId
                                                                 AND MIFloat_SummCardSecond.DescId = zc_MIFloat_SummCardSecond() 
                                      LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondCash
                                                                  ON MIFloat_SummCardSecondCash.MovementItemId = tmp.MovementItemId
                                                                 AND MIFloat_SummCardSecondCash.DescId = zc_MIFloat_SummCardSecondCash()
                                      LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecond
                                                                  ON MIFloat_SummAvCardSecond.MovementItemId = tmp.MovementItemId
                                                                 AND MIFloat_SummAvCardSecond.DescId = zc_MIFloat_SummAvCardSecond()                                     
                                WHERE tmp.Ord = 1
                                GROUP BY tmp.ContainerId
                                )
, tmpOperation_all AS (SELECT tmpContainer.ContainerId
                            , tmpContainer.AccountId
                            , tmpContainer.PersonalId
                            , tmpContainer.InfoMoneyId
                            , tmpContainer.UnitId
                            , tmpContainer.PositionId
                            , tmpContainer.PersonalServiceListId
                            , tmpContainer.BranchId
                            , tmpContainer.ServiceDate
                            , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)                                                                                   AS StartAmount
                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END)          AS DebetSumm
                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)     AS KreditSumm
                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Cash(), zc_Movement_BankAccount()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS MoneySumm

                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS MoneySummCard
                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Cash()) AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Cash_PersonalCardSecond() THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS MoneySummCardSecond
                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Cash()) AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_Cash_PersonalService(), zc_Enum_AnalyzerId_Cash_PersonalAvance()) THEN MIContainer.Amount ELSE 0 END ELSE 0 END) AS MoneySummCash

                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND COALESCE (MIContainer.AnalyzerId, 0) NOT IN (zc_Enum_AnalyzerId_PersonalService_Nalog(), zc_Enum_AnalyzerId_PersonalService_NalogRet()) THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_PersonalService(), zc_Movement_PersonalTransport()) THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END) AS ServiceSumm
                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.MovementDescId        = zc_Movement_Income()                          THEN  1 * MIContainer.Amount ELSE 0 END) AS IncomeSumm
                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_Add()            THEN -1 * MIContainer.Amount ELSE 0 END) AS SummTransportAdd
                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_AddLong()        THEN -1 * MIContainer.Amount ELSE 0 END) AS SummTransportAddLong
                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_Taxi()           THEN -1 * MIContainer.Amount ELSE 0 END) AS SummTransportTaxi
                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_PersonalService_Nalog()    THEN  1 * MIContainer.Amount ELSE 0 END) AS SummNalog
                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_PersonalService_NalogRet() THEN -1 * MIContainer.Amount ELSE 0 END) AS SummNalogRet
                            , SUM (CASE WHEN MIContainer.OperDate <= inEndDate AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_MobileBills_Personal()     THEN  1 * MIContainer.Amount ELSE 0 END) AS SummPhone

                            , tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0)                        AS EndAmount
                            --
                            --, MIN (MIContainer.MovementItemId) AS MovementItemId
                            -- , MIContainer.MovementItemId
                            -- , ROW_NUMBER() OVER (PARTITION BY MIContainer.MovementItemId ORDER BY MIContainer.MovementItemId, tmpContainer.ContainerId) AS Ord
                       FROM tmpContainer
                            LEFT JOIN tmpMIContainer AS MIContainer
                                                     ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                    AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                          --LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId

                       GROUP BY tmpContainer.ContainerId
                              , tmpContainer.AccountId
                              , tmpContainer.PersonalId
                              , tmpContainer.InfoMoneyId
                              , tmpContainer.UnitId
                              , tmpContainer.PositionId
                              , tmpContainer.PersonalServiceListId
                              , tmpContainer.BranchId
                              , tmpContainer.ServiceDate
                              , tmpContainer.Amount
                           -- , MIContainer.MovementItemId
                       HAVING 0 <> tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)
                           OR 0 <> SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END ELSE 0 END)
                           OR 0 <> SUM (CASE WHEN MIContainer.OperDate <= inEndDate THEN CASE WHEN MIContainer.Amount < 0 THEN -1 * MIContainer.Amount ELSE 0 END ELSE 0 END)
                           OR 0 <> tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0)
                      UNION ALL
                       SELECT tmpContainer.ContainerId
                            , tmpContainer.AccountId
                            , tmpContainer.PersonalId
                            , tmpContainer.InfoMoneyId
                            , tmpContainer.UnitId
                            , tmpContainer.PositionId
                            , tmpContainer.PersonalServiceListId
                            , tmpContainer.BranchId
                            , tmpContainer.ServiceDate
                            , 0 - SUM (MIContainer.Amount) AS StartAmount
                            , 0 AS DebetSumm
                            , 0 AS KreditSumm
                            , 0 AS MoneySumm

                            , 0 AS MoneySummCard
                            , 0 AS MoneySummCardSecond
                            , 0 AS MoneySummCash

                            , 0 AS ServiceSumm
                            , 0 AS IncomeSumm
                            , 0 AS SummTransportAdd
                            , 0 AS SummTransportAddLong
                            , 0 AS SummTransportTaxi
                            , 0 AS SummNalog
                            , 0 AS SummNalogRet
                            , 0 AS SummPhone

                            , 0 - SUM (MIContainer.Amount) AS EndAmount
                            --
                            --, MIN (MIContainer.MovementItemId) AS MovementItemId
                            -- , MIContainer.MovementItemId
                            -- , ROW_NUMBER() OVER (PARTITION BY MIContainer.MovementItemId ORDER BY MIContainer.MovementItemId, tmpContainer.ContainerId) AS Ord
                       FROM tmpContainer
                            INNER JOIN MovementItemContainer AS MIContainer
                                                             ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                            AND MIContainer.OperDate    > inEndDate
                       GROUP BY tmpContainer.ContainerId
                              , tmpContainer.AccountId
                              , tmpContainer.PersonalId
                              , tmpContainer.InfoMoneyId
                              , tmpContainer.UnitId
                              , tmpContainer.PositionId
                              , tmpContainer.PersonalServiceListId
                              , tmpContainer.BranchId
                              , tmpContainer.ServiceDate
                              , tmpContainer.Amount
                       HAVING 0 <> SUM (MIContainer.Amount)
                      )
   , Operation_all AS (SELECT Operation_all.ContainerId, Operation_all.AccountId, Operation_all.PersonalId
                           , Operation_all.InfoMoneyId, Operation_all.UnitId, Operation_all.PositionId
                           , Operation_all.PersonalServiceListId
                           , Operation_all.BranchId, Operation_all.ServiceDate
                           , SUM (Operation_all.StartAmount) AS StartAmount
                           , SUM (Operation_all.DebetSumm)   AS DebetSumm
                           , SUM (Operation_all.KreditSumm)  AS KreditSumm
                           , SUM (Operation_all.MoneySumm)   AS MoneySumm
                           , SUM (Operation_all.MoneySummCard)       AS MoneySummCard
                           , SUM (Operation_all.MoneySummCardSecond) AS MoneySummCardSecond
                           , SUM (Operation_all.MoneySummCash)       AS MoneySummCash
                           , SUM (Operation_all.ServiceSumm)         AS ServiceSumm
                           , SUM (Operation_all.IncomeSumm)            AS IncomeSumm
                           , SUM (Operation_all.SummTransportAdd)      AS SummTransportAdd
                           , SUM (Operation_all.SummTransportAddLong)  AS SummTransportAddLong
                           , SUM (Operation_all.SummTransportTaxi)     AS SummTransportTaxi
                           , SUM (Operation_all.SummPhone)             AS SummPhone
                           , SUM (Operation_all.SummNalog)             AS SummNalog
                           , SUM (Operation_all.SummNalogRet)          AS SummNalogRet
                           , SUM (Operation_all.EndAmount)   AS EndAmount
                       FROM tmpOperation_all AS Operation_all
                       GROUP BY Operation_all.ContainerId
                              , Operation_all.AccountId
                              , Operation_all.PersonalId
                              , Operation_all.InfoMoneyId
                              , Operation_all.UnitId
                              , Operation_all.PositionId
                              , Operation_all.BranchId
                              , Operation_all.ServiceDate
                              , Operation_all.PersonalServiceListId
                     )
   , tmpOperation AS (SELECT Operation_all.ContainerId, Operation_all.AccountId, Operation_all.PersonalId
                           , Operation_all.InfoMoneyId, Operation_all.UnitId, Operation_all.PositionId
                           , Operation_all.PersonalServiceListId
                           , Operation_all.BranchId, Operation_all.ServiceDate
                           , SUM (Operation_all.StartAmount) AS StartAmount
                           , SUM (Operation_all.DebetSumm)   AS DebetSumm
                           , SUM (Operation_all.KreditSumm)  AS KreditSumm
                           , SUM (Operation_all.MoneySumm)   AS MoneySumm
                           , SUM (Operation_all.MoneySummCard)       AS MoneySummCard
                           , SUM (Operation_all.MoneySummCardSecond) AS MoneySummCardSecond
                           , SUM (Operation_all.MoneySummCash)       AS MoneySummCash
                           , SUM (Operation_all.ServiceSumm)         AS ServiceSumm
                           , SUM (tmpMIFloat_SummService.SummService_inf) AS ServiceSumm_inf
                           , SUM (tmpMIFloat_SummService.SummHoliday_inf) AS SummHoliday_inf
                           , SUM (tmpMIFloat_SummService.SummAvCardSecond_inf) AS SummAvCardSecond_inf
                           , SUM (tmpMIFloat_SummService.SummToPay_inf)        AS SummToPay_inf
                           
                          , SUM (COALESCE (tmpMIFloat_SummService.SummCard_inf,0))           AS SummCard_inf
                          , SUM (COALESCE (tmpMIFloat_SummService.SummCardSecond_inf,0))     AS SummCardSecond_inf
                          , SUM (COALESCE (tmpMIFloat_SummService.SummCardSecondCash_inf,0)) AS SummCardSecondCash_inf                           

                           , SUM (tmpMIFloat_SummService.SummFine)        AS SummFine
                           , SUM (tmpMIFloat_SummService.SummHosp)        AS SummHosp
                           , SUM (Operation_all.IncomeSumm)            AS IncomeSumm
                           , SUM (Operation_all.SummTransportAdd)      AS SummTransportAdd
                           , SUM (Operation_all.SummTransportAddLong)  AS SummTransportAddLong
                           , SUM (Operation_all.SummTransportTaxi)     AS SummTransportTaxi
                           , SUM (Operation_all.SummPhone)             AS SummPhone
                           , SUM (Operation_all.SummNalog)             AS SummNalog
                           , SUM (Operation_all.SummNalogRet)          AS SummNalogRet

                           , SUM (Operation_all.EndAmount)   AS EndAmount
                      FROM Operation_all
                           LEFT JOIN tmpMIFloat_SummService ON tmpMIFloat_SummService.Containerid = Operation_all.ContainerId
                      GROUP BY Operation_all.ContainerId
                             , Operation_all.AccountId
                             , Operation_all.PersonalId
                             , Operation_all.InfoMoneyId
                             , Operation_all.UnitId
                             , Operation_all.PositionId
                             , Operation_all.BranchId
                             , Operation_all.ServiceDate
                             , Operation_all.PersonalServiceListId
                     )
          --аванс
        , tmpMIContainer_pay AS (SELECT SUM (CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_Cash_PersonalAvance()) AND MIContainer.Amount > 0 THEN MIContainer.Amount ELSE 0 END) AS Amount_avance
                                      , SUM (CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_Cash_PersonalAvance())  THEN MIContainer.Amount ELSE 0 END) AS Amount_avance_all
                                      , SUM (CASE WHEN MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_Cash_PersonalService()) THEN MIContainer.Amount ELSE 0 END) AS Amount_service
                                        -- аванс по ведомости
                                      , SUM (CASE WHEN ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm()
                                                   AND MIContainer.MovementDescId = zc_Movement_Cash()
                                                   AND Object.ValueData ILIKE '%АВАНС%'

                                                       THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS Amount_avance_ps

                                      , tmpContainer.PersonalId
                                      , tmpContainer.PositionId
                                      , tmpContainer.BranchId
                                      , tmpContainer.UnitId
                                      , tmpContainer.ServiceDate
                                      , tmpContainer.PersonalServiceListId
                                      , tmpContainer.InfoMoneyId
                                 FROM tmpContainer
                                      INNER JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.ContainerId    = tmpContainer.ContainerId
                                                                      AND MIContainer.DescId         = zc_MIContainer_Summ()
                                                                      AND MIContainer.MovementDescId = zc_Movement_Cash()
                                      LEFT JOIN MovementItem ON MovementItem.MovementId = MIContainer.MovementId
                                                            AND MovementItem.DescId     = zc_MI_Master()
                                                            AND MovementItem.isErased   = FALSE
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                                       ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                                      LEFT JOIN Object ON Object.Id = MILinkObject_MoneyPlace.ObjectId
                                      LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                                           ON ObjectLink_PersonalServiceList_PaidKind.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                                          AND ObjectLink_PersonalServiceList_PaidKind.DescId   = zc_ObjectLink_PersonalServiceList_PaidKind()
                                 GROUP BY tmpContainer.PersonalId
                                        , tmpContainer.PositionId
                                        , tmpContainer.BranchId
                                        , tmpContainer.UnitId
                                        , tmpContainer.ServiceDate
                                        , tmpContainer.PersonalServiceListId
                                        , tmpContainer.InfoMoneyId
                                )


     SELECT
        Object_Personal.Id                                                                          AS PersonalId,
        Object_Personal.ObjectCode                                                                  AS PersonalCode,
        Object_Personal.ValueData                                                                   AS PersonalName,
        Object_PersonalServiceList.ObjectCode                                                       AS PersonalServiceListCode,
        Object_PersonalServiceList.ValueData                                                        AS PersonalServiceListName,
        Object_Unit.ObjectCode                                                                      AS UnitCode,
        Object_Unit.ValueData                                                                       AS UnitName,
        Object_Position.ObjectCode                                                                  AS PositionCode,
        Object_Position.ValueData                                                                   AS PositionName,
        Object_Business.ValueData                                                                   AS BusinessName,
        Object_Branch.ValueData                                                                     AS BranchName,
        Object_InfoMoney_View.InfoMoneyGroupName                                                    AS InfoMoneyGroupName,
        Object_InfoMoney_View.InfoMoneyDestinationName                                              AS InfoMoneyDestinationName,
        Object_InfoMoney_View.InfoMoneyCode                                                         AS InfoMoneyCode,
        Object_InfoMoney_View.InfoMoneyName                                                         AS InfoMoneyName,
        Object_InfoMoney_View.InfoMoneyName_all                                                     AS InfoMoneyName_all,
        lfObject_Unit_byProfitLossDirection.ProfitLossDirectionName                                 AS ProfitLossDirectionName,
        Object_Account_View.AccountName_all                                                         AS AccountName,
        Operation.ServiceDate                                                                       AS ServiceDate,
        (-1 * Operation.StartAmount) :: TFloat                                                      AS StartAmount,
        CASE WHEN Operation.StartAmount > 0 THEN Operation.StartAmount ELSE 0 END ::TFloat          AS StartAmountD,
        CASE WHEN Operation.StartAmount < 0 THEN -1 * Operation.StartAmount ELSE 0 END :: TFloat    AS StartAmountK,
        Operation.DebetSumm :: TFloat                                                               AS DebetSumm,
        Operation.KreditSumm :: TFloat                                                              AS KreditSumm,

        Operation.MoneySumm :: TFloat                                                               AS MoneySumm,
        Operation.MoneySummCard :: TFloat                                                           AS MoneySummCard,
        Operation.MoneySummCardSecond :: TFloat                                                     AS MoneySummCardSecond,
        Operation.MoneySummCash :: TFloat                                                           AS MoneySummCash,

        Operation.ServiceSumm :: TFloat                                                             AS ServiceSumm,
        Operation.ServiceSumm_inf :: TFloat                                                         AS ServiceSumm_inf,
        Operation.SummHoliday_inf :: TFloat                                                         AS SummHoliday_inf,
        (COALESCE (Operation.ServiceSumm,0) - COALESCE (Operation.ServiceSumm_inf,0)) :: TFloat     AS ServiceSumm_dif,
        Operation.IncomeSumm :: TFloat                                                              AS IncomeSumm,
        Operation.SummTransportAdd :: TFloat                                                        AS SummTransportAdd,
        Operation.SummTransportAddLong :: TFloat                                                    AS SummTransportAddLong,
        Operation.SummTransportTaxi :: TFloat                                                       AS SummTransportTaxi,
        Operation.SummPhone :: TFloat                                                               AS SummPhone,
        Operation.SummNalog :: TFloat                                                               AS SummNalog,
        Operation.SummNalogRet :: TFloat                                                            AS SummNalogRet,
        Operation.SummFine     :: TFloat                                                            AS SummFine,
        Operation.SummHosp     :: TFloat                                                            AS SummHosp,
        (-1 * Operation.EndAmount) :: TFloat                                                        AS EndAmount,
        CASE WHEN Operation.EndAmount > 0 THEN Operation.EndAmount ELSE 0 END :: TFloat             AS EndAmountD,
        CASE WHEN Operation.EndAmount < 0 THEN -1 * Operation.EndAmount ELSE 0 END :: TFloat        AS EndAmountK,
        
        -- Остаток к выдаче (из кассы) грн
        (COALESCE (Operation.SummToPay_inf, 0)
            + (-1) *  CASE WHEN 1=0 AND vbUserId = 5
                               THEN 0
                          ELSE COALESCE (Operation.SummCard_inf, 0)
                             + COALESCE (Operation.SummCardSecond_inf, 0)
                             + COALESCE (Operation.SummCardSecondCash_inf, 0)
                             + COALESCE (Operation.SummAvCardSecond_inf, 0)
                             + COALESCE (tmpMIContainer_pay.Amount_avance_all, 0)
                             + COALESCE (tmpMIContainer_pay.Amount_service, 0)
                      END
              ) :: TFloat AS AmountCash_rem,
        Operation.SummCard_inf           ::TFloat,
        Operation.SummCardSecond_inf     ::TFloat,
        Operation.SummCardSecondCash_inf ::TFloat,
        Operation.SummAvCardSecond_inf   ::TFloat,
        Operation.SummToPay_inf          ::TFloat,
              
        Operation.ContainerId :: Integer    AS ContainerId
       
     FROM tmpOperation AS Operation

          LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = Operation.AccountId
          LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = Operation.PersonalServiceListId
          LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = Operation.PersonalId
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Operation.UnitId
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = Operation.PositionId
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = Operation.BranchId

          -- Ограничить доступ к этим ведомостям
          LEFT JOIN ObjectBoolean AS OB_PersonalServiceList_User
                                  ON OB_PersonalServiceList_User.ObjectId  = Operation.PersonalServiceListId
                                 AND OB_PersonalServiceList_User.DescId    = zc_ObjectBoolean_PersonalServiceList_User()
                                 AND OB_PersonalServiceList_User.ValueData = TRUE

          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Operation.InfoMoneyId

          LEFT JOIN _tmpList ON _tmpList.PersonalServiceListId = Operation.PersonalServiceListId

          LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = Operation.UnitId
                                                          AND ObjectLink_Unit_Business.DescId   = zc_ObjectLink_Unit_Business()
          LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectLink_Unit_Business.ChildObjectId

          LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = Operation.UnitId

          LEFT JOIN tmpMIContainer_pay ON tmpMIContainer_pay.PersonalId = Operation.PersonalId
                                      AND tmpMIContainer_pay.PositionId = Operation.PositionId
                                      AND tmpMIContainer_pay.UnitId     = Operation.UnitId
                                      AND tmpMIContainer_pay.BranchId   = Operation.BranchId
                                      AND tmpMIContainer_pay.ServiceDate = Operation.ServiceDate
                                      AND tmpMIContainer_pay.PersonalServiceListId = Operation.PersonalServiceListId
                                      AND tmpMIContainer_pay.InfoMoneyId = Operation.InfoMoneyId

     WHERE (Operation.StartAmount <> 0 OR Operation.EndAmount <> 0 OR Operation.DebetSumm <> 0 OR Operation.KreditSumm <> 0)
       AND (_tmpList.PersonalServiceListId > 0 OR vbIsList_all = TRUE)
       AND ((Operation.PersonalServiceListId NOT IN (293443 -- Ведомость Админ
                                                   , 418967 -- Ведомость Админ ДП
                                                   , 593890 -- Премии АП
                                                   , 541887 -- Премии АДМИН KPI
                                                    )
           -- ИЛИ НЕТ ограничения у Ведомости
         AND OB_PersonalServiceList_User.ObjectId IS NULL
            )

            OR vbUserId IN (2573318 -- Любарський Георгій Олегович
                          , 14599   -- Коротченко Т.Н.
                           )
            -- !!!Разрешено ВСЕ!!!
            OR vbIsLevelMax01 = TRUE
           )
     ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.01.20         *
 29.07.19         *
 08.04.19         * add SummService_inf
 16.03.17         * add inPersonalId
                    add inPersonalServiceListId
 07.04.15                                        * all
 04.09.14                                                        *
*/

-- тест
-- 
/*
SELECT * FROM gpReport_Personal (inStartDate:= '01.01.2024', inEndDate:= '31.01.2024', inServiceDate:= '01.01.2024', inIsServiceDate:= TRUE, inIsMember:= TRUE, inAccountId:= 0, inBranchId:=0, inInfoMoneyId:= 0, inInfoMoneyGroupId:= 0
, inInfoMoneyDestinationId:= 0, inPersonalServiceListId:= 346777, inPersonalId:= 0, inSession:= zfCalc_UserAdmin())
*/