-- Function: gpGet_Movement_StaffListMember()

DROP FUNCTION IF EXISTS gpGet_Movement_StaffListMember (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_StaffListMember(
    IN inMovementId       Integer  , -- ключ Документа
    IN inOperDate         TDateTime , -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , MemberId Integer, MemberName TVarChar
             , PersonalId Integer
             , PositionId Integer, PositionName TVarChar
             , PositionLevelId Integer, PositionLevelName TVarChar
             , UnitId Integer, UnitName TVarChar
             , PositionId_old Integer, PositionName_old TVarChar
             , PositionLevelId_old Integer, PositionLevelName_old TVarChar
             , UnitId_old Integer, UnitName_old TVarChar
             , ReasonOutId Integer, ReasonOutName TVarChar
             , StaffListKindId Integer, StaffListKindName TVarChar
             
             , PersonalGroupId Integer, PersonalGroupName TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , PersonalServiceListOfficialId Integer, PersonalServiceListOfficialName TVarChar
             , ServiceListId_AvanceF2 Integer, ServiceListName_AvanceF2 TVarChar
             , ServiceListCardSecondId Integer, ServiceListCardSecondName TVarChar
             , SheetWorkTimeId Integer, SheetWorkTimeName TVarChar
             , StorageLineId Integer, StorageLineName TVarChar
             , Member_ReferId Integer, Member_ReferName TVarChar
             , Member_MentorId Integer, Member_MentorName TVarChar            
             
             , isOfficial Boolean, isMain Boolean
             , Comment TVarChar
             , InsertId Integer, InsertName TVarChar
             , UpdateId Integer, UpdateName TVarChar
             , InsertDate TDateTime
             , UpdateDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_StaffListMember());
     vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_StaffListMember_seq') AS TVarChar) AS InvNumber
             , inOperDate                                       AS OperDate
             , 0                                                AS MemberId
             , CAST ('' AS TVarChar)                            AS MemberName
             , 0                                                AS PersonalId
             , 0                                                AS PositionId       
             , CAST ('' AS TVarChar)                            AS PositionName     
             , 0                                                AS PositionLevelId  
             , CAST ('' AS TVarChar)                            AS PositionLevelName
             , 0                                                AS UnitId           
             , CAST ('' AS TVarChar)                            AS UnitName         
             , 0                                                AS PositionId_old       
             , CAST ('' AS TVarChar)                            AS PositionName_old     
             , 0                                                AS PositionLevelId_old  
             , CAST ('' AS TVarChar)                            AS PositionLevelName_old
             , 0                                                AS UnitId_old           
             , CAST ('' AS TVarChar)                            AS UnitName_old         
             , 0                                                AS ReasonOutId      
             , CAST ('' AS TVarChar)                            AS ReasonOutName    
             , 0                                                AS StaffListKindId  
             , CAST ('' AS TVarChar)                            AS StaffListKindName 
             
             , CAST (0 as Integer)      AS PersonalGroupId
             , CAST ('' as TVarChar)    AS PersonalGroupName
             , CAST (0 as Integer)      AS PersonalServiceListId 
             , CAST ('' as TVarChar)    AS PersonalServiceListName
             , CAST (0 as Integer)      AS PersonalServiceListOfficialId 
             , CAST ('' as TVarChar)    AS PersonalServiceListOfficialName
             , 0                        AS ServiceListId_AvanceF2
             , CAST ('' as TVarChar)    AS ServiceListName_AvanceF2
             , CAST (0 as Integer)      AS ServiceListCardSecondId 
             , CAST ('' as TVarChar)    AS ServiceListCardSecondName
             , CAST (0 as Integer)      AS SheetWorkTimeId 
             , CAST ('' as TVarChar)    AS SheetWorkTimeName
             , CAST (0 as Integer)      AS StorageLineId
             , CAST ('' as TVarChar)    AS StorageLineName
             , 0                        AS Member_ReferId
             , CAST ('' as TVarChar)    AS Member_ReferName
             , 0                        AS Member_MentorId
             , CAST ('' as TVarChar)    AS Member_MentorName
           
             , CAST (FALSE AS Boolean)                          AS isOfficial
             , CAST (FALSE AS Boolean)                          AS isMain
             , CAST ('' AS TVarChar)                            AS Comment
             , Object_Insert.Id                                 AS InsertId
             , Object_Insert.ValueData                          AS InsertName
             , 0                                                AS UpdateId
             , CAST ('' AS TVarChar)                            AS UpdateName
             , CURRENT_TIMESTAMP                :: TDateTime    AS InsertDate
             , CAST (NULL AS TDateTime)                         AS UpdateDate

          FROM Object AS Object_Insert 
          WHERE Object_Insert.Id = vbUserId;

     ELSE
     -- Результат
     RETURN QUERY
       WITH
       tmpPersonal AS (SELECT Object_Personal.Id AS PersonalId
                            , ObjectLink_Personal_Unit.ChildObjectId          AS UnitId
                            , ObjectLink_Personal_Position.ChildObjectId      AS PositionId
                            , ObjectLink_Personal_PositionLevel.ChildObjectId AS PositionLevelId
                            , COALESCE (ObjectBoolean_Main.ValueData, FALSE)  AS isMain
                            , ROW_NUMBER() OVER(PARTITION BY Object_Personal.Id, ObjectLink_Personal_Unit.ChildObjectId, ObjectLink_Personal_Position.ChildObjectId, COALESCE (ObjectLink_Personal_PositionLevel.ChildObjectId,0), COALESCE (ObjectBoolean_Main.ValueData, FALSE) ) AS Ord
                       FROM Object AS Object_Personal
                            INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                  ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                                                 AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                                 AND ObjectLink_Personal_Member.ChildObjectId = (SELECT MLO.ObjectId FROM  MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_Member() AND MLO.MovementId = inMovementId)
                            LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                 ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                                AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                            LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                                 ON ObjectLink_Personal_PositionLevel.ObjectId = Object_Personal.Id
                                                AND ObjectLink_Personal_PositionLevel.DescId = zc_ObjectLink_Personal_PositionLevel()
                            LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                 ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()

                            LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                    ON ObjectBoolean_Main.ObjectId = Object_Personal.Id
                                                   AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Personal_Main()                            
                      WHERE Object_Personal.DescId = zc_Object_Personal()
                        AND Object_Personal.isErased = FALSE 
                       ) 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate

           , Object_Member.Id                      AS MemberId
           , Object_Member.ValueData               AS MemberName
           , COALESCE (tmpPersonal.PersonalId,0)::Integer AS PersonalId
           , Object_Position.Id                    AS PositionId
           , Object_Position.ValueData             AS PositionName
           , Object_PositionLevel.Id               AS PositionLevelId
           , Object_PositionLevel.ValueData        AS PositionLevelName
           , Object_Unit.Id                        AS UnitId
           , Object_Unit.ValueData                 AS UnitName

           , Object_Position_old.Id                AS PositionId_old
           , Object_Position_old.ValueData         AS PositionName_old
           , Object_PositionLevel_old.Id           AS PositionLevelId_old
           , Object_PositionLevel_old.ValueData    AS PositionLevelName_old
           , Object_Unit_old.Id                    AS UnitId_old
           , Object_Unit_old.ValueData             AS UnitName_old

           , Object_ReasonOut.Id                   AS ReasonOutId
           , Object_ReasonOut.ValueData            AS ReasonOutName
           , Object_StaffListKind.Id               AS StaffListKindId
           , Object_StaffListKind.ValueData        AS StaffListKindName

           , ObjectLink_Personal_PersonalGroup.ChildObjectId  AS PersonalGroupId
           , Object_PersonalGroup.ValueData                   AS PersonalGroupName

           , Object_PersonalServiceList.Id                    AS PersonalServiceListId
           , Object_PersonalServiceList.ValueData             AS PersonalServiceListName
           , Object_PersonalServiceListOfficial.Id            AS PersonalServiceListOfficialId
           , Object_PersonalServiceListOfficial.ValueData     AS PersonalServiceListOfficialName
           , Object_PersonalServiceListAvance_F2.Id           AS ServiceListId_AvanceF2
           , Object_PersonalServiceListAvance_F2.ValueData    AS ServiceListName_AvanceF2
           , Object_PersonalServiceListCardSecond.Id          AS ServiceListCardSecondId
           , Object_PersonalServiceListCardSecond.ValueData   AS ServiceListCardSecondName


           , Object_SheetWorkTime.Id                          AS SheetWorkTimeId
           , Object_SheetWorkTime.ValueData                   AS SheetWorkTimeName
           , Object_StorageLine.Id                            AS StorageLineId
           , Object_StorageLine.ValueData                     AS StorageLineName
           , Object_Member_Refer.Id                           AS Member_ReferId
           , Object_Member_Refer.ValueData                    AS Member_ReferName
           , Object_Member_Mentor.Id                          AS Member_MentorId
           , Object_Member_Mentor.ValueData                   AS Member_MentorName


           , COALESCE (MovementBoolean_Official.ValueData, FALSE) ::Boolean  AS isOfficial
           , COALESCE (MovementBoolean_Main.ValueData, FALSE)     ::Boolean  AS isMain

           , MovementString_Comment.ValueData                     ::TVarChar AS Comment

           , Object_Insert.Id                      AS InsertId
           , Object_Insert.ValueData               AS InsertName
           , Object_Update.Id                      AS UpdateId
           , Object_Update.ValueData               AS UpdateName
           , MovementDate_Insert.ValueData         AS InsertDate
           , MovementDate_Update.ValueData         AS UpdateDate

       FROM Movement
            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementBoolean AS MovementBoolean_Main
                                      ON MovementBoolean_Main.MovementId = Movement.Id
                                     AND MovementBoolean_Main.DescId = zc_MovementBoolean_Main()

            LEFT JOIN MovementBoolean AS MovementBoolean_Official
                                      ON MovementBoolean_Official.MovementId = Movement.Id
                                     AND MovementBoolean_Official.DescId = zc_MovementBoolean_Official()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                         ON MovementLinkObject_Member.MovementId = Movement.Id
                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReasonOut
                                         ON MovementLinkObject_ReasonOut.MovementId = Movement.Id
                                        AND MovementLinkObject_ReasonOut.DescId = zc_MovementLinkObject_ReasonOut()
            LEFT JOIN Object AS Object_ReasonOut ON Object_ReasonOut.Id = MovementLinkObject_ReasonOut.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_StaffListKind
                                         ON MovementLinkObject_StaffListKind.MovementId = Movement.Id
                                        AND MovementLinkObject_StaffListKind.DescId = zc_MovementLinkObject_StaffListKind()
            LEFT JOIN Object AS Object_StaffListKind ON Object_StaffListKind.Id = MovementLinkObject_StaffListKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position
                                         ON MovementLinkObject_Position.MovementId = Movement.Id
                                        AND MovementLinkObject_Position.DescId = zc_MovementLinkObject_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = MovementLinkObject_Position.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PositionLevel
                                         ON MovementLinkObject_PositionLevel.MovementId = Movement.Id
                                        AND MovementLinkObject_PositionLevel.DescId = zc_MovementLinkObject_PositionLevel()
            LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = MovementLinkObject_PositionLevel.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit_old
                                         ON MovementLinkObject_Unit_old.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit_old.DescId = zc_MovementLinkObject_Unit_old()
            LEFT JOIN Object AS Object_Unit_old ON Object_Unit_old.Id = MovementLinkObject_Unit_old.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position_old
                                         ON MovementLinkObject_Position_old.MovementId = Movement.Id
                                        AND MovementLinkObject_Position_old.DescId = zc_MovementLinkObject_Position_old()
            LEFT JOIN Object AS Object_Position_old ON Object_Position_old.Id = MovementLinkObject_Position_old.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PositionLevel_old
                                         ON MovementLinkObject_PositionLevel_old.MovementId = Movement.Id
                                        AND MovementLinkObject_PositionLevel_old.DescId = zc_MovementLinkObject_PositionLevel_old()
            LEFT JOIN Object AS Object_PositionLevel_old ON Object_PositionLevel_old.Id = MovementLinkObject_PositionLevel_old.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                         ON MovementLinkObject_Update.MovementId = Movement.Id
                                        AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId

            LEFT JOIN tmpPersonal ON tmpPersonal.UnitId = MovementLinkObject_Unit.ObjectId
                                 AND tmpPersonal.PositionId = MovementLinkObject_Position.ObjectId
                                 AND COALESCE (tmpPersonal.PositionLevelId,0) = COALESCE (MovementLinkObject_PositionLevel.ObjectId,0)
                                 AND tmpPersonal.isMain = COALESCE (MovementBoolean_Main.ValueData, FALSE)
                                 AND tmpPersonal.Ord = 1
            
          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                               ON ObjectLink_Personal_PersonalServiceList.ObjectId = tmpPersonal.PersonalId
                              AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
          LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_Personal_PersonalServiceList.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListOfficial
                               ON ObjectLink_Personal_PersonalServiceListOfficial.ObjectId = tmpPersonal.PersonalId
                              AND ObjectLink_Personal_PersonalServiceListOfficial.DescId = zc_ObjectLink_Personal_PersonalServiceListOfficial()
          LEFT JOIN Object AS Object_PersonalServiceListOfficial ON Object_PersonalServiceListOfficial.Id = ObjectLink_Personal_PersonalServiceListOfficial.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                               ON ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId = tmpPersonal.PersonalId
                              AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId = zc_ObjectLink_Personal_PersonalServiceListCardSecond()
          LEFT JOIN Object AS Object_PersonalServiceListCardSecond ON Object_PersonalServiceListCardSecond.Id = ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Avance_F2
                               ON ObjectLink_PersonalServiceList_Avance_F2.ObjectId = tmpPersonal.PersonalId
                              AND ObjectLink_PersonalServiceList_Avance_F2.DescId = zc_ObjectLink_Personal_PersonalServiceListAvance_F2()
          LEFT JOIN Object AS Object_PersonalServiceListAvance_F2 ON Object_PersonalServiceListAvance_F2.Id = ObjectLink_PersonalServiceList_Avance_F2.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_SheetWorkTime
                               ON ObjectLink_Personal_SheetWorkTime.ObjectId = tmpPersonal.PersonalId
                              AND ObjectLink_Personal_SheetWorkTime.DescId = zc_ObjectLink_Personal_SheetWorkTime()
          LEFT JOIN Object AS Object_SheetWorkTime ON Object_SheetWorkTime.Id = ObjectLink_Personal_SheetWorkTime.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                               ON ObjectLink_Personal_PersonalGroup.ObjectId = tmpPersonal.PersonalId
                              AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
          LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Personal_StorageLine
                               ON ObjectLink_Personal_StorageLine.ObjectId = tmpPersonal.PersonalId
                              AND ObjectLink_Personal_StorageLine.DescId = zc_ObjectLink_Personal_StorageLine()
          LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = ObjectLink_Personal_StorageLine.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_Refer
                               ON ObjectLink_Personal_Member_Refer.ObjectId = tmpPersonal.PersonalId
                              AND ObjectLink_Personal_Member_Refer.DescId = zc_ObjectLink_Personal_Member_Refer()
          LEFT JOIN Object AS Object_Member_Refer ON Object_Member_Refer.Id   = ObjectLink_Personal_Member_Refer.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_Mentor
                               ON ObjectLink_Personal_Member_Mentor.ObjectId = tmpPersonal.PersonalId
                              AND ObjectLink_Personal_Member_Mentor.DescId = zc_ObjectLink_Personal_Member_Mentor()
          LEFT JOIN Object AS Object_Member_Mentor ON Object_Member_Mentor.Id = ObjectLink_Personal_Member_Mentor.ChildObjectId
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_StaffListMember()
      ;
      END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.25         *
*/

-- тест
--  select * from gpGet_Movement_StaffListMember(inMovementId := 32266687 , inOperDate := ('16.09.2025')::TDateTime ,  inSession := '9457');
