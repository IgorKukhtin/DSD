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
             , StatusId Integer, StatusCode Integer, StatusName TVarChar
             , MemberId Integer, MemberName TVarChar
             , PositionId Integer, PositionName TVarChar
             , PositionLevelId Integer, PositionLevelName TVarChar
             , UnitId Integer, UnitName TVarChar
             , PositionId_old Integer, PositionName_old TVarChar
             , PositionLevelId_old Integer, PositionLevelName_old TVarChar
             , UnitId_old Integer, UnitName_old TVarChar
             , ReasonOutId Integer, ReasonOutName TVarChar
             , StaffListKindId Integer, StaffListKindName TVarChar
             , isOfficial Boolean, isMain Boolean
             , Comment TVarChar
             , InsertName TVarChar
             , UpdateName TVarChar
             , InsertDate TDateTime
             , UpdateDate TDateTime
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
                                                       
                                                       , zc_MovementLinkObject_Member()
                                                        )
                     )

       -- Результат
       SELECT
             Movement.Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.Id                      AS StatusId
           , Object_Status.ObjectCode              AS StatusCode
           , Object_Status.ValueData               AS StatusName

           , Object_Member.Id                      AS MemberId
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

           , MovementString_Comment.ValueData                     ::TVarChar AS Comment
           
           , Object_Insert.ValueData               AS InsertName
           , Object_Update.ValueData               AS UpdateName
           , MovementDate_Insert.ValueData         AS InsertDate
           , MovementDate_Update.ValueData         AS UpdateDate

       FROM tmpMovement AS Movement

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

            LEFT JOIN tmpMLO AS MovementLinkObject_Member
                             ON MovementLinkObject_Member.MovementId = Movement.Id
                            AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId

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


      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_StaffListMember (inStartDate:= '01.08.2023', inEndDate:= '01.08.2023', inIsErased:=true, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
