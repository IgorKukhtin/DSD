-- Function: gpReport_CashPersonal_toPay ()

DROP FUNCTION IF EXISTS gpReport_CashPersonal_toPay (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CashPersonal_toPay(
    IN inServiceDate               TDateTime, --
    IN inPersonalId                Integer,   -- 
    IN inSession                   TVarChar   -- сессия пользователя
)
RETURNS TABLE(MovementId Integer, OperDate TDateTime, InvNumber TVarChar
            , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
            , PositionId Integer, PositionCode Integer, PositionName TVarChar
            , UnitId Integer, UnitCode Integer, UnitName TVarChar
            , PersonalServiceListName TVarChar
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
    tmpPersonal AS (SELECT ObjectLink_Personal_Member.ObjectId AS PersonalId
                    FROM ObjectLink AS ObjectLink_Personal_Member
                    WHERE ObjectLink_Personal_Member.ChildObjectId > 0
                      AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                      AND ObjectLink_Personal_Member.ChildObjectId = vbMemberId 
                    )
 , tmpMovement AS (SELECT Movement.* 
                   FROM Movement
                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                              INNER JOIN MovementItemDate AS MIDate_ServiceDate
                                                          ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                                         AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                                         AND MIDate_ServiceDate.ValueData = inServiceDate
                   WHERE Movement.DescId = zc_Movement_Cash() 
                     AND Movement.StatusId <> zc_Enum_Status_Erased()
                   )
 , tmpMI AS (SELECT tmpMovement.Id
                  , tmpMovement.ParentId
                  , tmpMovement.OperDate
                  , tmpMovement.InvNumber
                  , MovementItem.ObjectId            AS PersonalId
                  , MILinkObject_Position.ObjectId   AS PositionId
                  , MILinkObject_InfoMoney.ObjectId  AS InfoMoneyId
                  , MILinkObject_Unit.ObjectId       AS UnitId
                  , SUM (COALESCE (MovementItem.Amount,0)) AS Amount
             FROM tmpMovement
                  INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                         AND MovementItem.DescId = zc_MI_Child()
                                         AND MovementItem.isErased = FALSE
                                         AND COALESCE (MovementItem.Amount,0) <> 0
                                         AND MovementItem.ObjectId IN (SELECT DISTINCT tmpPersonal.PersonalId FROM tmpPersonal)
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                   ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                   ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                   ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Position.DescId = zc_MILinkObject_Position() 
             GROUP BY tmpMovement.Id
                    , tmpMovement.ParentId
                    , tmpMovement.OperDate
                    , tmpMovement.InvNumber
                    , MovementItem.ObjectId 
                    , MILinkObject_Position.ObjectId
                    , MILinkObject_InfoMoney.ObjectId 
                    , MILinkObject_Unit.ObjectId
             )
                       

    SELECT tmpMI.Id AS MovementId
         , tmpMI.OperDate 
         , tmpMI.InvNumber
         , tmpMI.PersonalId           AS PersonalId
         , Object_Personal.ObjectCode AS PersonalCode
         , Object_Personal.ValueData  AS PersonalName 
         , Object_Position.Id         AS PositionId
         , Object_Position.ObjectCode AS PositionCode
         , Object_Position.ValueData  AS PositionName
         , Object_Unit.Id             AS UnitId
         , Object_Unit.ObjectCode     AS UnitCode
         , Object_Unit.ValueData      AS UnitName
         , Object_PersonalServiceList.ValueData       AS PersonalServiceListName 
         , COALESCE (ObjectDate_DateIn.ValueData, zc_DateEnd()) ::TDateTime AS DateIn
         , COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd())::TDateTime AS DateOut 
         , COALESCE (ObjectBoolean_Main.ValueData, FALSE)           AS isMain
         , COALESCE (ObjectBoolean_Official.ValueData, FALSE)       AS isOfficial
         , tmpMI.Amount    ::TFloat   AS Amount
    FROM tmpMI
        LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpMI.PersonalId
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpMI.PositionId
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId 
        
        LEFT JOIN ObjectDate AS ObjectDate_DateIn
                             ON ObjectDate_DateIn.ObjectId = tmpMI.PersonalId
                            AND ObjectDate_DateIn.DescId   = zc_ObjectDate_Personal_In()
        LEFT JOIN ObjectDate AS ObjectDate_DateOut
                             ON ObjectDate_DateOut.ObjectId = tmpMI.PersonalId
                            AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()  

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                ON ObjectBoolean_Main.ObjectId = tmpMI.PersonalId
                               AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Personal_Main()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                ON ObjectBoolean_Official.ObjectId = vbMemberId
                               AND ObjectBoolean_Official.DescId = zc_ObjectBoolean_Member_Official()
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                     ON MovementLinkObject_PersonalServiceList.MovementId = tmpMI.ParentId
                                    AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
        LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId

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