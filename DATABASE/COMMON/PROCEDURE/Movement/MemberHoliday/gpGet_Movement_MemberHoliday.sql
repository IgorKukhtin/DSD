-- Function: gpGet_Movement_MemberHoliday()

DROP FUNCTION IF EXISTS gpGet_Movement_MemberHoliday (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_MemberHoliday(
    IN inMovementId       Integer  , -- ключ Документа
    IN inOperDate         TDateTime , -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , OperDateStart TDateTime, OperDateEnd TDateTime
             , BeginDateStart TDateTime, BeginDateEnd TDateTime
             , MemberId Integer, MemberName TVarChar
             , MemberMainId Integer, MemberMainName TVarChar
             , WorkTimeKindId Integer, WorkTimeKindName TVarChar
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
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_MemberHoliday());
     vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_memberholiday_seq') AS TVarChar) AS InvNumber
             , inOperDate                                       AS OperDate
             , DATE_TRUNC ('YEAR', inOperDate) :: TDateTime    AS OperDateStartDate
             , (DATE_TRUNC ('YEAR', inOperDate) + INTERVAL '1 YEAR' - INTERVAL '1 DAY') :: TDateTime    AS OperDateEndDate
             , CURRENT_DATE                     :: TDateTime    AS BeginDateStartDate
             , CURRENT_DATE                     :: TDateTime    AS BeginDateEndDate
             , 0                                                AS MemberId
             , CAST ('' AS TVarChar)                            AS MemberName
             , 0                                                AS MemberMainId
             , CAST ('' AS TVarChar)                            AS MemberMainName
             , 0                                                AS WorkTimeKindId
             , CAST ('' AS TVarChar)                            AS WorkTimeKindName
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

           , MovementDate_OperDateStart.ValueData  AS OperDateStartDate
           , MovementDate_OperDateEnd.ValueData    AS OperDateEndDate
           , MovementDate_BeginDateStart.ValueData AS BeginDateStartDate
           , MovementDate_BeginDateEnd.ValueData   AS BeginDateEndDate

           , Object_Member.Id                      AS MemberId
           , Object_Member.ValueData               AS MemberName
           , Object_MemberMain.Id                  AS MemberMainId
           , Object_MemberMain.ValueData           AS MemberMainName

           , Object_WorkTimeKind.Id                AS WorkTimeKindId
           , Object_WorkTimeKind.ValueData         AS WorkTimeKindName

           , Object_Insert.Id                      AS InsertId
           , Object_Insert.ValueData               AS InsertName
           , Object_Update.Id                      AS UpdateId
           , Object_Update.ValueData               AS UpdateName
           , MovementDate_Insert.ValueData         AS InsertDate
           , MovementDate_Update.ValueData         AS UpdateDate

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

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                         ON MovementLinkObject_Update.MovementId = Movement.Id
                                        AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_MemberHoliday()
      ;
      END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 20.12.18         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_MemberHoliday (inMovementId:= 0, inOperDate:= '01.01.2015', inSession:= zfCalc_UserAdmin())
