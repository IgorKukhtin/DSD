-- Function: gpReport_SheetWorkTime_Update()

DROP FUNCTION IF EXISTS gpReport_SheetWorkTime_Update(TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_SheetWorkTime_Update(TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SheetWorkTime_Update(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inUnitId      Integer   , -- 
    IN inisErased    Boolean   , --
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS TABLE (MovementId Integer, MovementItemId Integer
               , UnitId Integer
               , UnitName  TVarChar
               , MemberId Integer
               , MemberCode Integer
               , MemberName  TVarChar
               , PositionId Integer
               , PositionName  TVarChar
               , PositionLevelId Integer
               , PositionLevelName   TVarChar
               , PersonalGroupId Integer
               , PersonalGroupName   TVarChar 
               , StorageLineId Integer, StorageLineName TVarChar
               , WorkTimeKindId Integer
               , WorkTimeKindId_key Integer
               , WorkTimeKindName   TVarChar
               , ShortName TVarChar
               , Amount    TFloat  
               , DayOfWeekName TVarChar
               , OperDate   TDateTime
               , DateIn     TDateTime
               , DateOut    TDateTime
               , OperDate_mi  TDateTime, UserName_mi  TVarChar 
               , OperDate_mov TDateTime, UserName_mov TVarChar 
               , StatusCode Integer
               , StatusName TVarChar

               , CheckedHeadId Integer, CheckedHeadName TVarChar
               , CheckedPersonalId Integer, CheckedPersonalName TVarChar
               , CheckedHead_date TDateTime
               , CheckedPersonal_date TDateTime
               , isCheckedHead Boolean
               , isCheckedPersonal Boolean

               , isErased Boolean
                )
AS
$BODY$

   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     RETURN QUERY
     WITH 
     tmpMI AS (SELECT 
                      Movement.Id         AS MovementId
                    , MI_SheetWorkTime.Id AS MovementItemId
                    , Movement.OperDate
                    , MI_SheetWorkTime.Amount
                    , COALESCE(MI_SheetWorkTime.ObjectId, 0)        AS MemberId
                    , COALESCE(MIObject_Position.ObjectId, 0)       AS PositionId
                    , COALESCE(MIObject_PositionLevel.ObjectId, 0)  AS PositionLevelId
                    , COALESCE(MIObject_PersonalGroup.ObjectId, 0)  AS PersonalGroupId
                    , MIObject_WorkTimeKind.ObjectId                AS WorkTimeKindId
                    , ObjectString_WorkTimeKind_ShortName.ValueData AS ShortName 
                    , COALESCE(MIObject_StorageLine.ObjectId, 0)    AS StorageLineId
                    , MovementLinkObject_Unit.ObjectId              AS UnitId
                    , COALESCE (ObjectBoolean_NoSheetCalc.ValueData, FALSE) ::Boolean AS isNoSheetCalc
                    , CASE WHEN inUnitId = 8451
                                THEN CASE WHEN MI_SheetWorkTime.Amount > 0 AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Quit() THEN zc_Enum_WorkTimeKind_Work() ELSE COALESCE (MIObject_WorkTimeKind.ObjectId, 0) END
                           ELSE 0
                      END AS WorkTimeKindId_key
                    , Object_Status.ObjectCode AS StatusCode
                    , Object_Status.ValueData  AS StatusName

                    , Object_CheckedHead.Id                     AS CheckedHeadId
                    , Object_CheckedHead.ValueData              AS CheckedHeadName
                    , Object_CheckedPersonal.Id                 AS CheckedPersonalId
                    , Object_CheckedPersonal.ValueData          AS CheckedPersonalName

                    , MovementDate_CheckedHead.ValueData         :: TDateTime AS CheckedHead_date
                    , MovementDate_CheckedPersonal.ValueData     :: TDateTime AS CheckedPersonal_date
                    , COALESCE (MovementBoolean_CheckedHead.ValueData, FALSE)     :: Boolean  AS isCheckedHead
                    , COALESCE (MovementBoolean_CheckedPersonal.ValueData, FALSE) :: Boolean  AS isCheckedPersonal

                    , MI_SheetWorkTime.isErased 
               FROM Movement
                    JOIN MovementLinkObject AS MovementLinkObject_Unit
                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                           AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId =0)  
                    JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
                                                         AND (MI_SheetWorkTime.isErased = inisErased OR inisErased = TRUE)
                    LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                                     ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                                    AND MIObject_Position.DescId = zc_MILinkObject_Position() 
                    LEFT JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                     ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
                                                    AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 
                    LEFT JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                     ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id 
                                                    AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind() 
                    LEFT JOIN ObjectString AS ObjectString_WorkTimeKind_ShortName 
                                                     ON ObjectString_WorkTimeKind_ShortName.ObjectId = MIObject_WorkTimeKind.ObjectId  
                                                    AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()       
                    LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                     ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                                    AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup()
                    LEFT JOIN ObjectBoolean AS ObjectBoolean_NoSheetCalc
                                            ON ObjectBoolean_NoSheetCalc.ObjectId = COALESCE(MIObject_PositionLevel.ObjectId, 0)
                                           AND ObjectBoolean_NoSheetCalc.DescId = zc_ObjectBoolean_PositionLevel_NoSheetCalc() 
                    LEFT JOIN MovementItemLinkObject AS MIObject_StorageLine
                                                     ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id
                                                    AND MIObject_StorageLine.DescId         = zc_MILinkObject_StorageLine()
                    LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                    LEFT JOIN MovementDate AS MovementDate_CheckedHead
                                           ON MovementDate_CheckedHead.MovementId = Movement.Id
                                          AND MovementDate_CheckedHead.DescId = zc_MovementDate_CheckedHead()
                    LEFT JOIN MovementDate AS MovementDate_CheckedPersonal
                                           ON MovementDate_CheckedPersonal.MovementId = Movement.Id
                                          AND MovementDate_CheckedPersonal.DescId = zc_MovementDate_CheckedPersonal()

                    LEFT JOIN MovementBoolean AS MovementBoolean_CheckedHead
                                              ON MovementBoolean_CheckedHead.MovementId = Movement.Id
                                             AND MovementBoolean_CheckedHead.DescId = zc_MovementBoolean_CheckedHead()
                    LEFT JOIN MovementBoolean AS MovementBoolean_CheckedPersonal
                                              ON MovementBoolean_CheckedPersonal.MovementId = Movement.Id
                                             AND MovementBoolean_CheckedPersonal.DescId = zc_MovementBoolean_CheckedPersonal()

                    LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckedHead
                                                 ON MovementLinkObject_CheckedHead.MovementId = Movement.Id
                                                AND MovementLinkObject_CheckedHead.DescId = zc_MovementLinkObject_CheckedHead()
                    LEFT JOIN Object AS Object_CheckedHead ON Object_CheckedHead.Id = MovementLinkObject_CheckedHead.ObjectId

                    LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckedPersonal
                                                 ON MovementLinkObject_CheckedPersonal.MovementId = Movement.Id
                                                AND MovementLinkObject_CheckedPersonal.DescId = zc_MovementLinkObject_CheckedPersonal()
                    LEFT JOIN Object AS Object_CheckedPersonal ON Object_CheckedPersonal.Id = MovementLinkObject_CheckedPersonal.ObjectId

               WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                 AND Movement.DescId   = zc_Movement_SheetWorkTime()
               --AND Movement.StatusId <> zc_Enum_Status_Erased()
               --AND COALESCE (MIObject_WorkTimeKind.ObjectId,0)<> 0
               )
     --
   , tmpMIProtocol AS (SELECT MovementItemProtocol.*
                              -- № п/п
                            , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.OperDate DESC) AS Ord
                       FROM MovementItemProtocol
                       WHERE MovementItemProtocol.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                      )
     --
   , tmpMovProtocol AS (SELECT *
                               -- № п/п
                             , ROW_NUMBER() OVER (PARTITION BY MovementProtocol.MovementId ORDER BY MovementProtocol.OperDate DESC) AS Ord
                        FROM MovementProtocol
                        WHERE MovementProtocol.MovementId IN (SELECT DISTINCT tmpMI.MovementId FROM tmpMI)
                       )
     --
   , tmpPersonal AS (SELECT Object_Personal_View.MemberId
                          , Object_Personal_View.PersonalId
                          , Object_Personal_View.PositionId
                          , Object_Personal_View.PositionLevelId
                          , Object_Personal_View.PersonalGroupId
                          , Object_Personal_View.UnitId
                          , Object_Personal_View.DateIn
                          , CASE WHEN Object_Personal_View.DateOut = zc_DateEnd() THEN NULL ELSE Object_Personal_View.DateOut END ::TDateTime AS DateOut
                     FROM Object_Personal_View
                     WHERE (Object_Personal_View.UnitId = inUnitId OR inUnitId =0)
                     )

    SELECT tmpMI.MovementId
         , tmpMI.MovementItemId
         , Object_Unit.Id                  AS UnitId
         , Object_Unit.ValueData           AS UnitName
         , Object_Member.Id                AS MemberId
         , Object_Member.ObjectCode        AS MemberCode
         , Object_Member.ValueData         AS MemberName
         , Object_Position.Id              AS PositionId
         , Object_Position.ValueData       AS PositionName
         , Object_PositionLevel.Id         AS PositionLevelId
         , Object_PositionLevel.ValueData  AS PositionLevelName
         , Object_PersonalGroup.Id         AS PersonalGroupId
         , Object_PersonalGroup.ValueData  AS PersonalGroupName
         , Object_StorageLine.Id           AS StorageLineId
         , Object_StorageLine.ValueData    AS StorageLineName
         , Object_WorkTimeKind.Id          AS WorkTimeKindId
         , Object_WorkTimeKind.Id          AS WorkTimeKindId_key
         , Object_WorkTimeKind.ValueData   AS WorkTimeKindName 
         , tmpMI.ShortName
         , tmpMI.Amount
         , tmpWeekDay.DayOfWeekName ::TVarChar AS DayOfWeekName
         , tmpMI.OperDate
         , tmpPersonal.DateIn
         , tmpPersonal.DateOut

         , tmpMIProtocol.OperDate    AS OperDate_mi
         , Object_User_mi.ValueData  AS UserName_mi

         , tmpMovProtocol.OperDate   AS OperDate_mov
         , Object_User_mov.ValueData AS UserName_mov

         , tmpMI.StatusCode
         , tmpMI.StatusName

         , tmpMI.CheckedHeadId
         , tmpMI.CheckedHeadName
         , tmpMI.CheckedPersonalId
         , tmpMI.CheckedPersonalName

         , tmpMI.CheckedHead_date
         , tmpMI.CheckedPersonal_date
         , tmpMI.isCheckedHead
         , tmpMI.isCheckedPersonal

         , tmpMI.isErased ::Boolean

    FROM tmpMI
         LEFT JOIN tmpMIProtocol   ON tmpMIProtocol.MovementItemId = tmpMI.MovementItemId
                                  AND tmpMIProtocol.Ord            = 1
         LEFT JOIN Object AS Object_User_mi ON Object_User_mi.Id = tmpMIProtocol.UserId
         LEFT JOIN tmpMovProtocol ON tmpMovProtocol.MovementId = tmpMI.MovementId
                                 AND tmpMovProtocol.Ord        = 1
         LEFT JOIN Object AS Object_User_mov ON Object_User_mov.Id = tmpMovProtocol.UserId
         --
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpMI.MemberId
         LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpMI.PositionId
         LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = tmpMI.PositionLevelId
         LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = tmpMI.PersonalGroupId
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId
         LEFT JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = tmpMI.WorkTimeKindId
         LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = tmpMI.StorageLineId

         LEFT JOIN tmpPersonal ON tmpPersonal.MemberId        = tmpMI.MemberId
                              AND tmpPersonal.PositionId      = tmpMI.PositionId
                              AND tmpPersonal.PositionLevelId = tmpMI.PositionLevelId
                              AND tmpPersonal.PersonalGroupId = tmpMI.PersonalGroupId
                              AND tmpPersonal.UnitId          = tmpMI.UnitId
         
         LEFT JOIN zfCalc_DayOfWeekName (tmpMI.OperDate) AS tmpWeekDay ON 1=1

       ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--
/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.07.22         *
*/
