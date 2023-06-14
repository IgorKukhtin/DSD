-- Function: gpReport_CashPersonal_toPay ()

DROP FUNCTION IF EXISTS gpReport_CashPersonal_toPay (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CashPersonal_toPay(
    IN inServiceDate               TDateTime, --
    IN inPersonalId                Integer,   --
    IN inSession                   TVarChar   -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, ParentId Integer, OperDate TDateTime, InvNumber TVarChar
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , PositionId Integer, PositionCode Integer, PositionName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , PersonalServiceListCode Integer, PersonalServiceListName TVarChar
             , PersonalServiceListCode_parent Integer, PersonalServiceListName_parent TVarChar
             , DateIn TDateTime, DateOut TDateTime
             , isMain Boolean, isOfficial Boolean
             , Amount TFloat
              )
AS
$BODY$
    DECLARE vbUserId    Integer;
    DECLARE vbMemberId  Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

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
 , tmpMovement AS (SELECT Movement.Id AS  MovementId
                        , Movement.ParentId
                        , Movement.OperDate
                        , Movement.InvNumber
                        , MIContainer.Amount
                        , tmpContainer.AccountId
                        , tmpContainer.Amount AS Amount_rem
                        , tmpContainer.PersonalId
                        , tmpContainer.InfoMoneyId
                        , tmpContainer.UnitId
                        , tmpContainer.PositionId
                        , tmpContainer.PersonalServiceListId
                        , tmpContainer.BranchId
                   FROM tmpContainer
                        INNER JOIN MovementItemContainer AS MIContainer
                                                         ON MIContainer.ContainerId    = tmpContainer.ContainerId
                                                        AND MIContainer.MovementDescId = zc_Movement_Cash()
                        LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                  )
    --
    SELECT tmpMovement.MovementId
         , tmpMovement.ParentId
         , tmpMovement.OperDate
         , tmpMovement.InvNumber
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

         , Object_PersonalServiceList_parent.ObjectCode     AS PersonalServiceListCode_parent
         , CASE WHEN COALESCE (Object_PersonalServiceList_master.Id, 0) <> COALESCE (Object_PersonalServiceList_parent.Id, 0)
                     THEN COALESCE (Object_PersonalServiceList_master.ValueData, '???') || ' - ' || COALESCE (Object_PersonalServiceList_parent.ValueData, '???')
                ELSE Object_PersonalServiceList.ValueData
           END :: TVarChar AS PersonalServiceListName_parent

         , COALESCE (ObjectDate_DateIn.ValueData, zc_DateEnd()) ::TDateTime AS DateIn
         , COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd())::TDateTime AS DateOut
         , COALESCE (ObjectBoolean_Main.ValueData, FALSE)           AS isMain
         , COALESCE (ObjectBoolean_Official.ValueData, FALSE)       AS isOfficial

         , tmpMovement.Amount :: TFloat AS Amount

    FROM tmpMovement
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

         LEFT JOIN MovementItem AS MI_Master
                                ON MI_Master.MovementId = tmpMovement.MovementId
                               AND MI_Master.DescId     = zc_MI_Master()
         LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                          ON MILinkObject_MoneyPlace.MovementItemId = MI_Master.Id
                                         AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
         LEFT JOIN Object AS Object_PersonalServiceList_master ON Object_PersonalServiceList_master.Id = MILinkObject_MoneyPlace.ObjectId

         LEFT JOIN MovementLinkObject AS MLO_PersonalServiceList
                                      ON MLO_PersonalServiceList.MovementId = tmpMovement.ParentId
                                     AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
         LEFT JOIN Object AS Object_PersonalServiceList_parent ON Object_PersonalServiceList_parent.Id = MLO_PersonalServiceList.ObjectId

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
