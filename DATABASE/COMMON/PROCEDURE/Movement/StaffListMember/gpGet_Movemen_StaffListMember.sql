-- Function: gpGet_Movement_StaffListMember()

DROP FUNCTION IF EXISTS gpGet_Movement_StaffListMember (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_StaffListMember(
    IN inMovementId       Integer  , -- ключ Документа
    IN inOperDate         TDateTime , -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
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
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate

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
-- SELECT * FROM gpGet_Movement_StaffListMember (inMovementId:= 0, inOperDate:= '01.01.2015', inSession:= zfCalc_UserAdmin())
