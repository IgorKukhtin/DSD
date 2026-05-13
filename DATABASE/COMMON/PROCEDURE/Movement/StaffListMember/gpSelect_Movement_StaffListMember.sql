-- Function: gpSelect_Movement_StaffListMember()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_StaffListMember (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_StaffListMember (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_StaffListMember(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , DateIn TDateTime, DateSend TDateTime, DateOut TDateTime
             , StatusId Integer, StatusCode Integer, StatusName TVarChar
             , MemberId Integer, MemberCode Integer, MemberName TVarChar
             , PositionId Integer, PositionName TVarChar
             , PositionLevelId Integer, PositionLevelName TVarChar
             , UnitId Integer, UnitName TVarChar
             , PositionId_old Integer, PositionName_old TVarChar
             , PositionLevelId_old Integer, PositionLevelName_old TVarChar
             , UnitId_old Integer, UnitName_old TVarChar
             , ReasonOutId Integer, ReasonOutName TVarChar
             , StaffListKindId Integer, StaffListKindName TVarChar
             , isOfficial Boolean, isMain Boolean 
             , isDateOut Boolean
             , NumBiz TVarChar
             , Comment TVarChar
             , InsertName TVarChar
             , UpdateName TVarChar
             , InsertDate TDateTime
             , UpdateDate TDateTime
             , Member_ReferId Integer
             , Member_ReferCode Integer
             , Member_ReferName TVarChar
             , Member_MentorId Integer
             , Member_MentorCode Integer
             , Member_MentorName TVarChar 
             --
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , PersonalServiceListOfficialId Integer, PersonalServiceListOfficialName TVarChar
             , ServiceListId_AvanceF2 Integer, ServiceListName_AvanceF2 TVarChar
             , ServiceListCardSecondId Integer, ServiceListCardSecondName TVarChar
             , SheetWorkTimeId Integer, SheetWorkTimeName TVarChar
             , StorageLineId_1 Integer, StorageLineName_1 TVarChar
             , StorageLineId_2 Integer, StorageLineName_2 TVarChar
             , StorageLineId_3 Integer, StorageLineName_3 TVarChar
             , StorageLineId_4 Integer, StorageLineName_4 TVarChar
             , StorageLineId_5 Integer, StorageLineName_5 TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsAccessKey_StaffListMember Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_StaffListMember());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )

        , tmpMovement AS (SELECT Movement.*
                        FROM tmpStatus
                             JOIN Movement ON Movement.DescId = zc_Movement_StaffListMember()
                                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                          AND Movement.StatusId = tmpStatus.StatusId
                        )

        , tmpMovementBoolean AS (SELECT MovementBoolean.*
                                 FROM MovementBoolean
                                 WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement) 
                                   AND MovementBoolean.DescId IN (zc_MovementBoolean_Official()
                                                                , zc_MovementBoolean_Main()
                                                                 )
                                 )       

        , tmpMovementString AS (SELECT MovementString.*
                                FROM MovementString
                                WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement) 
                                  AND MovementString.DescId IN (zc_MovementString_Comment()
                                                              , zc_MovementString_NumBiz()
                                                                )
                                )

        , tmpMovementDate AS (SELECT MovementDate.*
                              FROM MovementDate
                              WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement) 
                                AND MovementDate.DescId IN (zc_MovementDate_Insert()
                                                             , zc_MovementDate_Update()
                                                              )
                              )
        , tmpMLO AS (SELECT MovementLinkObject.*
                     FROM MovementLinkObject
                     WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement) 
                       AND MovementLinkObject.DescId IN (zc_MovementLinkObject_ReasonOut()
                                                       , zc_MovementLinkObject_StaffListKind() 
                                                       , zc_MovementLinkObject_Member()
                                                       , zc_MovementLinkObject_Unit()
                                                       , zc_MovementLinkObject_Position()
                                                       , zc_MovementLinkObject_PositionLevel()
                                                       , zc_MovementLinkObject_Unit_old()
                                                       , zc_MovementLinkObject_Position_old()
                                                       , zc_MovementLinkObject_PositionLevel_old()
                                                       , zc_MovementLinkObject_Insert()
                                                       , zc_MovementLinkObject_Update()
                                                        )
                     )
          --линии производства
        , tmpStorageLine AS (WITH
                             tmp AS(SELECT ObjectLink_PersonalByStorageLine_Personal.ChildObjectId     AS PersonalId
                                         , ObjectLink_PersonalByStorageLine_StorageLine.ChildObjectId  AS StorageLineId
                                         , ROW_NUMBER() OVER (PARTITION BY ObjectLink_PersonalByStorageLine_Personal.ChildObjectId ORDER BY Object_PersonalByStorageLine) AS Ord
                                    FROM Object AS Object_PersonalByStorageLine
                                         INNER JOIN ObjectLink AS ObjectLink_PersonalByStorageLine_Personal
                                                               ON ObjectLink_PersonalByStorageLine_Personal.ObjectId = Object_PersonalByStorageLine.Id
                                                              AND ObjectLink_PersonalByStorageLine_Personal.DescId = zc_ObjectLink_PersonalByStorageLine_Personal()
                                                             -- AND ObjectLink_PersonalByStorageLine_Personal.ChildObjectId IN (SELECT DISTINCT tmpPersonal.PersonalId FROM tmpPersonal)
                                                               
                                         LEFT JOIN ObjectLink AS ObjectLink_PersonalByStorageLine_StorageLine
                                                              ON ObjectLink_PersonalByStorageLine_StorageLine.ObjectId = Object_PersonalByStorageLine.Id
                                                             AND ObjectLink_PersonalByStorageLine_StorageLine.DescId = zc_ObjectLink_PersonalByStorageLine_StorageLine()
                                    WHERE Object_PersonalByStorageLine.DescId = zc_Object_PersonalByStorageLine()
                                      AND Object_PersonalByStorageLine.isErased = False
                                    ) 
                           , tmpOrd AS (SELECT tmp.PersonalId
                                             , CASE WHEN tmp.Ord = 1 THEN tmp.StorageLineId ELSE 0 END AS StorageLineId_1
                                             , CASE WHEN tmp.Ord = 2 THEN tmp.StorageLineId ELSE 0 END AS StorageLineId_2
                                             , CASE WHEN tmp.Ord = 3 THEN tmp.StorageLineId ELSE 0 END AS StorageLineId_3
                                             , CASE WHEN tmp.Ord = 4 THEN tmp.StorageLineId ELSE 0 END AS StorageLineId_4
                                             , CASE WHEN tmp.Ord = 5 THEN tmp.StorageLineId ELSE 0 END AS StorageLineId_5
                                        FROM tmp 
                                        )
                             SELECT tmp.PersonalId
                                  , MAX (tmp.StorageLineId_1) AS StorageLineId_1
                                  , MAX (tmp.StorageLineId_2) AS StorageLineId_2
                                  , MAX (tmp.StorageLineId_3) AS StorageLineId_3
                                  , MAX (tmp.StorageLineId_4) AS StorageLineId_4
                                  , MAX (tmp.StorageLineId_5) AS StorageLineId_5
                             FROM tmpOrd AS tmp
                             GROUP BY tmp.PersonalId 
                             )


          --дату приема берем по основному месту работы, но только если дата документа >= дата приема в сотрудниках
        , tmpPersonal AS (SELECT DISTINCT
                                 ObjectLink_Personal_Member.ChildObjectId AS MemberId
                               , ObjectDate_DateIn.ValueData              AS DateIn
                               , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN NULL ELSE ObjectDate_DateOut.ValueData END AS DateOut
                               , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN FALSE ELSE TRUE END AS isDateOut
                               , ObjectLink_Personal_Unit.ChildObjectId           AS UnitId
                               , ObjectLink_Personal_Position.ChildObjectId       AS PositionId
                               , ObjectLink_Personal_PositionLevel.ChildObjectId  AS PositionLevelId

                               , Object_Member_Refer.Id                           AS Member_ReferId
                               , Object_Member_Refer.ObjectCode                   AS Member_ReferCode
                               , Object_Member_Refer.ValueData                    AS Member_ReferName
                               , Object_Member_Mentor.Id                          AS Member_MentorId
                               , Object_Member_Mentor.ObjectCode                  AS Member_MentorCode
                               , Object_Member_Mentor.ValueData                   AS Member_MentorName

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

                               , Object_StorageLine1.Id                           AS StorageLineId_1
                               , Object_StorageLine1.ValueData                    AS StorageLineName_1
                               , Object_StorageLine2.Id                           AS StorageLineId_2
                               , Object_StorageLine2.ValueData                    AS StorageLineName_2
                               , Object_StorageLine3.Id                           AS StorageLineId_3
                               , Object_StorageLine3.ValueData                    AS StorageLineName_3
                               , Object_StorageLine4.Id                           AS StorageLineId_4
                               , Object_StorageLine4.ValueData                    AS StorageLineName_4
                               , Object_StorageLine5.Id                           AS StorageLineId_5
                               , Object_StorageLine5.ValueData                    AS StorageLineName_5
                          FROM Object AS Object_Personal
                               INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                     ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                                                    AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                               INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                     ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                    AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                               INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                        ON ObjectBoolean_Main.ObjectId = Object_Personal.Id
                                                       AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Personal_Main()
                                                       AND COALESCE (ObjectBoolean_Main.ValueData, FALSE) = TRUE

                               LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                    ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                                   AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                               --LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                                    ON ObjectLink_Personal_PositionLevel.ObjectId = Object_Personal.Id
                                                   AND ObjectLink_Personal_PositionLevel.DescId = zc_ObjectLink_Personal_PositionLevel()
                               --LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = ObjectLink_Personal_PositionLevel.ChildObjectId

                               LEFT JOIN ObjectDate AS ObjectDate_DateIn
                                                    ON ObjectDate_DateIn.ObjectId = Object_Personal.Id
                                                   AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_In()
                               LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                    ON ObjectDate_DateOut.ObjectId = Object_Personal.Id
                                                   AND ObjectDate_DateOut.DescId = zc_ObjectDate_Personal_Out()

                               LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_Refer
                                                    ON ObjectLink_Personal_Member_Refer.ObjectId = Object_Personal.Id
                                                   AND ObjectLink_Personal_Member_Refer.DescId = zc_ObjectLink_Personal_Member_Refer()
                               LEFT JOIN Object AS Object_Member_Refer ON Object_Member_Refer.Id = ObjectLink_Personal_Member_Refer.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_Mentor
                                                    ON ObjectLink_Personal_Member_Mentor.ObjectId = Object_Personal.Id
                                                   AND ObjectLink_Personal_Member_Mentor.DescId = zc_ObjectLink_Personal_Member_Mentor()
                               LEFT JOIN Object AS Object_Member_Mentor ON Object_Member_Mentor.Id = ObjectLink_Personal_Member_Mentor.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                    ON ObjectLink_Personal_PersonalServiceList.ObjectId = Object_Personal.Id
                                                   AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                               LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_Personal_PersonalServiceList.ChildObjectId
                     
                               LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListOfficial
                                                    ON ObjectLink_Personal_PersonalServiceListOfficial.ObjectId = Object_Personal.Id
                                                   AND ObjectLink_Personal_PersonalServiceListOfficial.DescId = zc_ObjectLink_Personal_PersonalServiceListOfficial()
                               LEFT JOIN Object AS Object_PersonalServiceListOfficial ON Object_PersonalServiceListOfficial.Id = ObjectLink_Personal_PersonalServiceListOfficial.ChildObjectId
                     
                               LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                                                    ON ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId = Object_Personal.Id
                                                   AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId = zc_ObjectLink_Personal_PersonalServiceListCardSecond()
                               LEFT JOIN Object AS Object_PersonalServiceListCardSecond ON Object_PersonalServiceListCardSecond.Id = ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId
                     
                               LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Avance_F2
                                                    ON ObjectLink_PersonalServiceList_Avance_F2.ObjectId = Object_Personal.Id
                                                   AND ObjectLink_PersonalServiceList_Avance_F2.DescId = zc_ObjectLink_Personal_PersonalServiceListAvance_F2()
                               LEFT JOIN Object AS Object_PersonalServiceListAvance_F2 ON Object_PersonalServiceListAvance_F2.Id = ObjectLink_PersonalServiceList_Avance_F2.ChildObjectId
                     
                               LEFT JOIN ObjectLink AS ObjectLink_Personal_SheetWorkTime
                                                    ON ObjectLink_Personal_SheetWorkTime.ObjectId = Object_Personal.Id
                                                   AND ObjectLink_Personal_SheetWorkTime.DescId = zc_ObjectLink_Personal_SheetWorkTime()
                               LEFT JOIN Object AS Object_SheetWorkTime ON Object_SheetWorkTime.Id = ObjectLink_Personal_SheetWorkTime.ChildObjectId
                               LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                                    ON ObjectLink_Personal_PersonalGroup.ObjectId = Object_Personal.Id
                                                   AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
                               LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId
                               LEFT JOIN ObjectLink AS ObjectLink_Personal_StorageLine
                                                    ON ObjectLink_Personal_StorageLine.ObjectId = Object_Personal.Id
                                                   AND ObjectLink_Personal_StorageLine.DescId = zc_ObjectLink_Personal_StorageLine()
                     
                               LEFT JOIN tmpStorageLine ON tmpStorageLine.PersonalId = Object_Personal.Id                              
                               LEFT JOIN Object AS Object_StorageLine1 ON Object_StorageLine1.Id = COALESCE (tmpStorageLine.StorageLineId_1, ObjectLink_Personal_StorageLine.ChildObjectId)
                               LEFT JOIN Object AS Object_StorageLine2 ON Object_StorageLine2.Id = tmpStorageLine.StorageLineId_2
                               LEFT JOIN Object AS Object_StorageLine3 ON Object_StorageLine3.Id = tmpStorageLine.StorageLineId_3
                               LEFT JOIN Object AS Object_StorageLine4 ON Object_StorageLine4.Id = tmpStorageLine.StorageLineId_4
                               LEFT JOIN Object AS Object_StorageLine5 ON Object_StorageLine5.Id = tmpStorageLine.StorageLineId_5
          
                          WHERE Object_Personal.DescId = zc_Object_Personal()
                          --  AND Object_Personal.isErased = FALSE
                       ) 
                       

        , tmpData AS (SELECT Movement.*
                           , MovementLinkObject_Member.ObjectId        AS MemberId
                           , MovementLinkObject_StaffListKind.ObjectId AS StaffListKindId                         
                      FROM tmpMovement AS Movement
                           LEFT JOIN tmpMLO AS MovementLinkObject_Member
                                            ON MovementLinkObject_Member.MovementId = Movement.Id
                                           AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                           LEFT JOIN tmpMLO AS MovementLinkObject_StaffListKind
                                            ON MovementLinkObject_StaffListKind.MovementId = Movement.Id
                                           AND MovementLinkObject_StaffListKind.DescId = zc_MovementLinkObject_StaffListKind()
                      )

       -- Результат
       SELECT
             Movement.Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , CASE WHEN Object_StaffListKind.Id IN (zc_Enum_StaffListKind_In(), zc_Enum_StaffListKind_Add()) THEN Movement.OperDate
                  ELSE tmpPersonal.DateIn 
             END ::TDateTime AS DateIn
           , CASE WHEN Object_StaffListKind.Id = zc_Enum_StaffListKind_Send() THEN Movement.OperDate ELSE NULL END ::TDateTime AS DateSend
           , CASE WHEN Object_StaffListKind.Id = zc_Enum_StaffListKind_Out()  THEN Movement.OperDate
                  ELSE tmpPersonal.DateOut
             END ::TDateTime AS DateOut
           , Object_Status.Id                      AS StatusId
           , Object_Status.ObjectCode              AS StatusCode
           , Object_Status.ValueData               AS StatusName

           , Object_Member.Id                      AS MemberId
           , Object_Member.ObjectCode              AS MemberCode
           , Object_Member.ValueData               AS MemberName

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

           , COALESCE (MovementBoolean_Official.ValueData, FALSE) ::Boolean  AS isOfficial
           , COALESCE (MovementBoolean_Main.ValueData, FALSE)     ::Boolean  AS isMain
           , CASE WHEN Object_StaffListKind.Id = zc_Enum_StaffListKind_Out() THEN TRUE
                  ELSE COALESCE (tmpPersonal.isDateOut, FALSE)
             END ::Boolean AS isDateOut 

           , MovementString_NumBiz.ValueData                      ::TVarChar AS NumBiz
           , MovementString_Comment.ValueData                     ::TVarChar AS Comment
           
           , Object_Insert.ValueData               AS InsertName
           , Object_Update.ValueData               AS UpdateName
           , MovementDate_Insert.ValueData         AS InsertDate
           , MovementDate_Update.ValueData         AS UpdateDate

           , tmpPersonal.Member_ReferId
           , tmpPersonal.Member_ReferCode
           , tmpPersonal.Member_ReferName
           , tmpPersonal.Member_MentorId
           , tmpPersonal.Member_MentorCode
           , tmpPersonal.Member_MentorName   
           
           , tmpPersonal.PersonalServiceListId
           , tmpPersonal.PersonalServiceListName
           , tmpPersonal.PersonalServiceListOfficialId
           , tmpPersonal.PersonalServiceListOfficialName
           , tmpPersonal.ServiceListId_AvanceF2
           , tmpPersonal.ServiceListName_AvanceF2
           , tmpPersonal.ServiceListCardSecondId
           , tmpPersonal.ServiceListCardSecondName
           , tmpPersonal.SheetWorkTimeId
           , tmpPersonal.SheetWorkTimeName
           , tmpPersonal.StorageLineId_1
           , tmpPersonal.StorageLineName_1
           , tmpPersonal.StorageLineId_2
           , tmpPersonal.StorageLineName_2
           , tmpPersonal.StorageLineId_3
           , tmpPersonal.StorageLineName_3
           , tmpPersonal.StorageLineId_4
           , tmpPersonal.StorageLineName_4
           , tmpPersonal.StorageLineId_5
           , tmpPersonal.StorageLineName_5
       FROM tmpData AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN tmpMovementDate AS MovementDate_Insert
                                      ON MovementDate_Insert.MovementId = Movement.Id
                                     AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN tmpMovementDate AS MovementDate_Update
                                      ON MovementDate_Update.MovementId = Movement.Id
                                     AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_Main
                                         ON MovementBoolean_Main.MovementId = Movement.Id
                                        AND MovementBoolean_Main.DescId = zc_MovementBoolean_Main()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_Official
                                         ON MovementBoolean_Official.MovementId = Movement.Id
                                        AND MovementBoolean_Official.DescId = zc_MovementBoolean_Official()

            LEFT JOIN tmpMovementString AS MovementString_Comment
                                        ON MovementString_Comment.MovementId = Movement.Id
                                       AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN tmpMovementString AS MovementString_NumBiz
                                        ON MovementString_NumBiz.MovementId = Movement.Id
                                       AND MovementString_NumBiz.DescId = zc_MovementString_NumBiz()

            LEFT JOIN Object AS Object_Member ON Object_Member.Id = Movement.MemberId

            LEFT JOIN tmpMLO AS MovementLinkObject_ReasonOut
                             ON MovementLinkObject_ReasonOut.MovementId = Movement.Id
                            AND MovementLinkObject_ReasonOut.DescId = zc_MovementLinkObject_ReasonOut()
            LEFT JOIN Object AS Object_ReasonOut ON Object_ReasonOut.Id = MovementLinkObject_ReasonOut.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_StaffListKind
                             ON MovementLinkObject_StaffListKind.MovementId = Movement.Id
                            AND MovementLinkObject_StaffListKind.DescId = zc_MovementLinkObject_StaffListKind()
            LEFT JOIN Object AS Object_StaffListKind ON Object_StaffListKind.Id = MovementLinkObject_StaffListKind.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_Unit
                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_Position
                             ON MovementLinkObject_Position.MovementId = Movement.Id
                            AND MovementLinkObject_Position.DescId = zc_MovementLinkObject_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = MovementLinkObject_Position.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_PositionLevel
                             ON MovementLinkObject_PositionLevel.MovementId = Movement.Id
                            AND MovementLinkObject_PositionLevel.DescId = zc_MovementLinkObject_PositionLevel()
            LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = MovementLinkObject_PositionLevel.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_Unit_old
                             ON MovementLinkObject_Unit_old.MovementId = Movement.Id
                            AND MovementLinkObject_Unit_old.DescId = zc_MovementLinkObject_Unit_old()
            LEFT JOIN Object AS Object_Unit_old ON Object_Unit_old.Id = MovementLinkObject_Unit_old.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_Position_old
                             ON MovementLinkObject_Position_old.MovementId = Movement.Id
                            AND MovementLinkObject_Position_old.DescId = zc_MovementLinkObject_Position_old()
            LEFT JOIN Object AS Object_Position_old ON Object_Position_old.Id = MovementLinkObject_Position_old.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_PositionLevel_old
                             ON MovementLinkObject_PositionLevel_old.MovementId = Movement.Id
                            AND MovementLinkObject_PositionLevel_old.DescId = zc_MovementLinkObject_PositionLevel_old()
            LEFT JOIN Object AS Object_PositionLevel_old ON Object_PositionLevel_old.Id = MovementLinkObject_PositionLevel_old.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_Insert
                             ON MovementLinkObject_Insert.MovementId = Movement.Id
                            AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_Update
                             ON MovementLinkObject_Update.MovementId = Movement.Id
                            AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId

            LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = Movement.MemberId
                                 AND tmpPersonal.DateIn <= Movement.OperDate
                                 AND COALESCE (tmpPersonal.DateOut, zc_DateEnd()) >= Movement.OperDate
                                 AND COALESCE (tmpPersonal.UnitId,0)          = COALESCE (MovementLinkObject_Unit.ObjectId,0) 
                                 AND COALESCE (tmpPersonal.PositionId,0)      = COALESCE (MovementLinkObject_Position.ObjectId,0) 
                                 AND COALESCE (tmpPersonal.PositionLevelId,0) = COALESCE (MovementLinkObject_PositionLevel.ObjectId,0) 
                              --   AND Object_StaffListKind.Id IN (zc_Enum_StaffListKind_Send(), zc_Enum_StaffListKind_Out())
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.05.26         *
 07.05.26         *
 26.02.26         *
 15.09.25         *
*/

-- тест
-- 
SELECT * FROM gpSelect_Movement_StaffListMember (inStartDate:= '01.08.2025', inEndDate:= '01.08.2025', inIsErased:=true, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
