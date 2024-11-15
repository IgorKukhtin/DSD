-- Function: gpReport_CashPersonal_toPay ()

DROP FUNCTION IF EXISTS gpReport_CashPersonal_toPay (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CashPersonal_toPay(
    IN inServiceDate               TDateTime, --
    IN inPersonalId                Integer,   --
    IN inSession                   TVarChar   -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, ContainerId Integer, ParentId Integer, OperDate TDateTime, InvNumber TVarChar, ItemName TVarChar
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , PositionId Integer, PositionCode Integer, PositionName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , PersonalServiceListCode Integer, PersonalServiceListName TVarChar
             , PersonalServiceListCode_parent Integer, PersonalServiceListName_parent TVarChar
             , DateIn TDateTime, DateOut TDateTime
             , isMain Boolean, isOfficial Boolean
             , Amount            TFloat
             , Amount_Service    TFloat
             , Amount_Bank       TFloat
             , Amount_rem        TFloat
             , AnalyzerName      TVarChar
             , AnalyzerName_enum TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
              )
AS
$BODY$
    DECLARE vbUserId    Integer;
    DECLARE vbMemberId  Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inServiceDate, inServiceDate, NULL, NULL, NULL, vbUserId);

    -- !!!Проверка прав роль - Ограничение - нет вообще доступа к просмотру данных ЗП!!!
    PERFORM lpCheck_UserRole_8813637 (vbUserId);


    -- !!!Проверка прав роль - Ограничение - нет доступа к просмотру ведомость Админ ЗП!!!
    PERFORM lpCheck_UserRole_11026035 ((SELECT OB.ObjectId FROM ObjectBoolean AS OB WHERE OB.DescId = zc_ObjectBoolean_PersonalServiceList_User() AND OB.ValueData = TRUE LIMIT 1)
                                     , vbUserId
                                      );


    vbMemberId := (SELECT ObjectLink_Personal_Member.ChildObjectId AS MemberId
                   FROM ObjectLink AS ObjectLink_Personal_Member
                   WHERE ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                     AND ObjectLink_Personal_Member.ObjectId = inPersonalId
                  );

    -- Результат
    RETURN QUERY

    WITH
     -- все сотрудники
     tmpContainer AS (SELECT CLO_Personal.ContainerId         AS ContainerId
                           , Container.ObjectId               AS AccountId
                           , Container.Amount
                           , CLO_Personal.ObjectId            AS PersonalId
                           , CLO_InfoMoney.ObjectId           AS InfoMoneyId
                           , CLO_Unit.ObjectId                AS UnitId
                           , CLO_Position.ObjectId            AS PositionId
                           , CLO_PersonalServiceList.ObjectId AS PersonalServiceListId
                           , CLO_Branch.ObjectId              AS BranchId
                      FROM ContainerLinkObject AS CLO_Personal
                           INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                 ON ObjectLink_Personal_Member.ObjectId      = CLO_Personal.ObjectId
                                                AND ObjectLink_Personal_Member.ChildObjectId = vbMemberId
                                                AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()

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
                           INNER JOIN ObjectDate AS ObjectDate_Service
                                                 ON ObjectDate_Service.ObjectId  = CLO_ServiceDate.ObjectId
                                                AND ObjectDate_Service.DescId    = zc_ObjectDate_ServiceDate_Value()
                                                AND ObjectDate_Service.ValueData = DATE_TRUNC ('MONTH', inServiceDate)
                           -- LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = CLO_InfoMoney.ObjectId
                      WHERE CLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                     )

 , tmpMovement AS (SELECT *
                          -- № п/п
                        , ROW_NUMBER() OVER (PARTITION BY tmpMovement.ContainerId ORDER BY tmpMovement.Amount_Service DESC) AS Ord
                   FROM (SELECT MIContainer.MovementId
                              , MIContainer.MovementDescId
                              , CASE WHEN MIContainer.MovementDescId = zc_Movement_PersonalService() THEN NULL ELSE MIContainer.MovementId END AS MovementId_begin
                              , MIContainer.AnalyzerId
                              , tmpContainer.AccountId
                              , -1 * tmpContainer.Amount AS Amount_rem
                              , tmpContainer.PersonalId
                              , tmpContainer.InfoMoneyId
                              , tmpContainer.UnitId
                              , tmpContainer.PositionId
                              , tmpContainer.PersonalServiceListId
                              , tmpContainer.BranchId
                              , tmpContainer.ContainerId
                              , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Cash()            THEN  1 * MIContainer.Amount ELSE 0 END) AS Amount
                              , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_PersonalService(), zc_Movement_Income()) THEN -1 * MIContainer.Amount ELSE 0 END) AS Amount_Service
                              , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_BankAccount()     THEN  1 * MIContainer.Amount ELSE 0 END) AS Amount_Bank
                         FROM tmpContainer
                              INNER JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                              AND MIContainer.DescId      = zc_MIContainer_Summ()
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                           ON MovementLinkObject_PersonalServiceList.MovementId = MIContainer.MovementId
                                                          AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_CompensationNot
                                                      ON ObjectBoolean_CompensationNot.ObjectId  = MovementLinkObject_PersonalServiceList.ObjectId
                                                     AND ObjectBoolean_CompensationNot.DescId    = zc_ObjectBoolean_PersonalServiceList_CompensationNot()
                                                     AND ObjectBoolean_CompensationNot.ValueData = TRUE
                         -- Исключить из расчета компенсации для отпуска
                         WHERE ObjectBoolean_CompensationNot.ObjectId IS NULL
      
                         GROUP BY MIContainer.MovementId
                                , MIContainer.MovementDescId
                                , MIContainer.AnalyzerId
                                , tmpContainer.AccountId
                                , tmpContainer.Amount
                                , tmpContainer.PersonalId
                                , tmpContainer.InfoMoneyId
                                , tmpContainer.UnitId
                                , tmpContainer.PositionId
                                , tmpContainer.PersonalServiceListId
                                , tmpContainer.BranchId
                                , tmpContainer.ContainerId
                        ) AS tmpMovement
                  )
   
 , tmpMI_begin AS (SELECT MI_Master.*
                   FROM MovementItem  AS MI_Master
                   WHERE MI_Master.MovementId IN (SELECT DISTINCT tmpMovement.MovementId_begin FROM tmpMovement)
                     AND MI_Master.DescId     = zc_MI_Master()
                     AND MI_Master.isErased   = FALSE                
                   )  

    --
    SELECT tmpMovement.MovementId
         , tmpMovement.ContainerId
         , Movement.ParentId
         , Movement.OperDate
         , Movement.InvNumber
         , MovementDesc.ItemName
         , tmpMovement.PersonalId
         , Object_Personal.ObjectCode AS PersonalCode
         , Object_Personal.ValueData  AS PersonalName
         , Object_Position.Id         AS PositionId
         , Object_Position.ObjectCode AS PositionCode
         , Object_Position.ValueData  AS PositionName
         , Object_Unit.Id             AS UnitId
         , Object_Unit.ObjectCode     AS UnitCode
         , Object_Unit.ValueData      AS UnitName
         , Object_Branch.ObjectCode   AS BranchCode
         , Object_Branch.ValueData    AS BranchName

         , Object_PersonalServiceList.ObjectCode     AS PersonalServiceListCode
         , Object_PersonalServiceList.ValueData      AS PersonalServiceListName

         , CASE WHEN MovementDescId = zc_Movement_PersonalService()
                     THEN Object_PersonalServiceList_parent.ObjectCode
                WHEN MovementDescId = zc_Movement_BankAccount()
                     THEN Object_PersonalServiceList_master.ObjectCode
                ELSE Object_PersonalServiceList_parent.ObjectCode
           END :: Integer AS PersonalServiceListCode_parent

         , CASE WHEN MovementDescId = zc_Movement_PersonalService()
                     THEN Object_PersonalServiceList_parent.ValueData
                WHEN MovementDescId = zc_Movement_BankAccount()
                     THEN Object_PersonalServiceList_master.ValueData
                WHEN COALESCE (Object_PersonalServiceList_master.Id, 0) <> COALESCE (Object_PersonalServiceList_parent.Id, 0)
                     THEN 'ош-(' || MI_Master.Id :: TVarChar || ')' || COALESCE (Object_PersonalServiceList_master.ValueData, '???') || ' - ' || COALESCE (Object_PersonalServiceList_parent.ValueData, '???')
                ELSE Object_PersonalServiceList_parent.ValueData
           END :: TVarChar AS PersonalServiceListName_parent

         , COALESCE (ObjectDate_DateIn.ValueData, zc_DateEnd()) ::TDateTime AS DateIn
         , COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd())::TDateTime AS DateOut
         , COALESCE (ObjectBoolean_Main.ValueData, FALSE)           AS isMain
         , COALESCE (ObjectBoolean_Official.ValueData, FALSE)       AS isOfficial

         , tmpMovement.Amount         :: TFloat AS Amount
         , tmpMovement.Amount_Service :: TFloat AS Amount_Service
         , tmpMovement.Amount_Bank    :: TFloat AS Amount_Bank
         , CASE WHEN tmpMovement.Ord = 1 THEN tmpMovement.Amount_rem ELSE 0 END    :: TFloat AS Amount_rem
         
         , Object_Analyzer.ValueData    AS AnalyzerName
         , OS_Analyzer.ValueData        AS AnalyzerName_enum

         , Object_InfoMoney_View.InfoMoneyCode
         , Object_InfoMoney_View.InfoMoneyName
         , Object_InfoMoney_View.InfoMoneyName_all AS InfoMoneyName_all

    FROM tmpMovement
         LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId
         LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

         LEFT JOIN Object AS Object_Personal            ON Object_Personal.Id            = tmpMovement.PersonalId
         LEFT JOIN Object AS Object_Position            ON Object_Position.Id            = tmpMovement.PositionId
         LEFT JOIN Object AS Object_Unit                ON Object_Unit.Id                = tmpMovement.UnitId
         LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = tmpMovement.PersonalServiceListId
         LEFT JOIN Object AS Object_Branch              ON Object_Branch.Id              = tmpMovement.BranchId

         LEFT JOIN ObjectDate AS ObjectDate_DateIn
                              ON ObjectDate_DateIn.ObjectId = tmpMovement.PersonalId
                             AND ObjectDate_DateIn.DescId   = zc_ObjectDate_Personal_In()
         LEFT JOIN ObjectDate AS ObjectDate_DateOut
                              ON ObjectDate_DateOut.ObjectId = tmpMovement.PersonalId
                             AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                 ON ObjectBoolean_Main.ObjectId = tmpMovement.PersonalId
                                AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Personal_Main()
         LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                 ON ObjectBoolean_Official.ObjectId = vbMemberId
                                AND ObjectBoolean_Official.DescId = zc_ObjectBoolean_Member_Official()

         LEFT JOIN tmpMI_begin AS MI_Master ON MI_Master.MovementId = tmpMovement.MovementId_begin

         LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                          ON MILinkObject_MoneyPlace.MovementItemId = MI_Master.Id
                                         AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
         LEFT JOIN Object AS Object_PersonalServiceList_master ON Object_PersonalServiceList_master.Id = MILinkObject_MoneyPlace.ObjectId

         LEFT JOIN MovementLinkObject AS MLO_PersonalServiceList
                                      ON MLO_PersonalServiceList.MovementId = CASE WHEN tmpMovement.MovementDescId = zc_Movement_PersonalService()
                                                                                   THEN Movement.Id
                                                                                   ELSE Movement.ParentId
                                                                              END
                                     AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
         LEFT JOIN Object AS Object_PersonalServiceList_parent ON Object_PersonalServiceList_parent.Id = MLO_PersonalServiceList.ObjectId

         LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpMovement.InfoMoneyId

         LEFT JOIN Object AS Object_Analyzer ON Object_Analyzer.Id = tmpMovement.AnalyzerId
         LEFT JOIN ObjectString AS OS_Analyzer ON OS_Analyzer.ObjectId = tmpMovement.AnalyzerId
                                              AND OS_Analyzer.DescId   = zc_ObjectString_Enum()
    WHERE tmpMovement.Amount         <> 0
       OR tmpMovement.Amount_Service <> 0
       OR tmpMovement.Amount_Bank    <> 0
       OR tmpMovement.Amount_rem     <> 0
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.06.23         *
*/

-- тест
-- SELECT * FROM gpReport_CashPersonal_toPay(inServiceDate:= '01.05.2023', inPersonalId:= 7117901, inSession:= '5');
-- SELECT * FROM gpReport_CashPersonal_toPay(inServiceDate:= ('01.05.2024')::TDateTime , inPersonalId := 3442965 ,  inSession := '5');
