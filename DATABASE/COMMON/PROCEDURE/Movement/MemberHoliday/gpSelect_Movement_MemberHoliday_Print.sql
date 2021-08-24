-- Function: gpSelect_Movement_MemberHoliday_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_MemberHoliday_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_MemberHoliday_Print(
    IN inMovementId    Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_MemberHoliday());
     vbUserId:= lpGetUserBySession (inSession);

     IF zc_Enum_Status_Erased() = (SELECT StatusId FROM Movement WHERE Id = inMovementId)
     THEN
         RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = (SELECT DescId FROM Movement WHERE Id = inMovementId)), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
     END IF;
     IF zc_Enum_Status_UnComplete() = (SELECT StatusId FROM Movement WHERE Id = inMovementId)
     THEN
         RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = (SELECT DescId FROM Movement WHERE Id = inMovementId)), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
     END IF;

     --
     OPEN Cursor1 FOR
     WITH tmpMember AS (SELECT lfSelect.MemberId
                             , lfSelect.PersonalId
                             , lfSelect.UnitId
                             , lfSelect.PositionId
                             , lfSelect.BranchId
                        FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                        WHERE lfSelect.Ord = 1
                        )

       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate

           , MovementDate_OperDateStart.ValueData  AS OperDateStart
           , MovementDate_OperDateEnd.ValueData    AS OperDateEnd
           , MovementDate_BeginDateStart.ValueData AS BeginDateStart
           , MovementDate_BeginDateEnd.ValueData   AS BeginDateEnd

           , Object_Member.Id                      AS MemberId
           , Object_Member.ValueData               AS MemberName
           , Object_MemberMain.Id                  AS MemberMainId
           , Object_MemberMain.ValueData           AS MemberMainName
           , Object_Position.ValueData             AS PositionName
           , Object_Unit.ValueData                 AS UnitName

           , Object_WorkTimeKind.Id                AS WorkTimeKindId
           , Object_WorkTimeKind.ValueData         AS WorkTimeKindName

           , (DATE_PART ('DAY', MovementDate_OperDateEnd.ValueData - MovementDate_OperDateStart.ValueData)   + 1) :: TFloat AS Day_work
           , (DATE_PART ('DAY', MovementDate_BeginDateEnd.ValueData - MovementDate_BeginDateStart.ValueData) + 1) :: TFloat AS Day_holiday

       FROM Movement
            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                   ON MovementDate_OperDateStart.MovementId = Movement.Id
                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()

            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                   ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

            LEFT JOIN MovementDate AS MovementDate_BeginDateStart
                                   ON MovementDate_BeginDateStart.MovementId = Movement.Id
                                  AND MovementDate_BeginDateStart.DescId = zc_MovementDate_BeginDateStart()

            LEFT JOIN MovementDate AS MovementDate_BeginDateEnd
                                   ON MovementDate_BeginDateEnd.MovementId = Movement.Id
                                  AND MovementDate_BeginDateEnd.DescId = zc_MovementDate_BeginDateEnd()


            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                         ON MovementLinkObject_Member.MovementId = Movement.Id
                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberMain
                                         ON MovementLinkObject_MemberMain.MovementId = Movement.Id
                                        AND MovementLinkObject_MemberMain.DescId = zc_MovementLinkObject_MemberMain()
            LEFT JOIN Object AS Object_MemberMain ON Object_MemberMain.Id = MovementLinkObject_MemberMain.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_WorkTimeKind
                                         ON MovementLinkObject_WorkTimeKind.MovementId = Movement.Id
                                        AND MovementLinkObject_WorkTimeKind.DescId = zc_MovementLinkObject_WorkTimeKind()
            LEFT JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = MovementLinkObject_WorkTimeKind.ObjectId

            --
            LEFT JOIN tmpMember ON tmpMember.MemberId = MovementLinkObject_Member.ObjectId
            
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpMember.PositionId
            LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpMember.UnitId
            
            LEFT JOIN ObjectDate AS ObjectDate_DateIn
                                 ON ObjectDate_DateIn.ObjectId = tmpMember.PersonalId
                                AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_In()
            LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                 ON ObjectDate_DateOut.ObjectId = tmpMember.PersonalId
                                AND ObjectDate_DateOut.DescId = zc_ObjectDate_Personal_Out()
       WHERE Movement.Id = inMovementId
         AND Movement.StatusId = zc_Enum_Status_Complete()
         AND Movement.DescId = zc_Movement_MemberHoliday()
      ;
    RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
       SELECT
             inMovementId                                AS inMovementId
      ;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.12.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_MemberHoliday_Print (inMovementId := 1001606, inSession:= zfCalc_UserAdmin());
