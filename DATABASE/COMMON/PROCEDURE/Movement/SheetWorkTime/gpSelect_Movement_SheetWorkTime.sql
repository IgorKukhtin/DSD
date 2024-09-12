-- Function: gpSelect_SheetWorkTime_Period()
-- не так названо

DROP FUNCTION IF EXISTS gpSelect_SheetWorkTime_Period - не так названо (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_SheetWorkTime_Period(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitName TVarChar

             , CheckedHeadId Integer, CheckedHeadName TVarChar
             , CheckedPersonalId Integer, CheckedPersonalName TVarChar
             , CheckedHead_date TDateTime
             , CheckedPersonal_date TDateTime
             , isCheckedHead Boolean
             , isCheckedPersonal Boolean
           
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           
           , Object_Status.ObjectCode AS StatusCode
           , Object_Status.ValueData  AS StatusName

           , Object_Unit.Id           AS UnitId
           , Object_Unit.ValueData    AS UnitName
           
           , Object_CheckedHead.Id                     AS CheckedHeadId
           , Object_CheckedHead.ValueData              AS CheckedHeadName
           , Object_CheckedPersonal.Id                 AS CheckedPersonalId
           , Object_CheckedPersonal.ValueData          AS CheckedPersonalName

           , MovementDate_CheckedHead.ValueData        :: TDateTime AS CheckedHead_date
           , MovementDate_CheckedPersonal.ValueData    :: TDateTime AS CheckedPersonal_date
           , MovementBoolean_CheckedHead.ValueData     :: Boolean   AS isCheckedHead
           , MovementBoolean_CheckedPersonal.ValueData :: Boolean   AS isCheckedPersonal

           , Object_Insert.ValueData             AS InsertName
           , MovementDate_Insert.ValueData       AS InsertDate
           , Object_Update.ValueData             AS UpdateName
           , MovementDate_Update.ValueData       AS UpdateDate

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckedHead
                                         ON MovementLinkObject_CheckedHead.MovementId = Movement.Id
                                        AND MovementLinkObject_CheckedHead.DescId = zc_MovementLinkObject_CheckedHead()
            LEFT JOIN Object AS Object_CheckedHead ON Object_CheckedHead.Id = MovementLinkObject_CheckedHead.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckedPersonal
                                         ON MovementLinkObject_CheckedPersonal.MovementId = Movement.Id
                                        AND MovementLinkObject_CheckedPersonal.DescId = zc_MovementLinkObject_CheckedPersonal()
            LEFT JOIN Object AS Object_CheckedPersonal ON Object_CheckedPersonal.Id = MovementLinkObject_CheckedPersonal.ObjectId
           
            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                         ON MovementLinkObject_Update.MovementId = Movement.Id
                                        AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId

       WHERE Movement.DescId = zc_Movement_SheetWorkTime()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.08.21         *
 01.10.13         *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_SheetWorkTime (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')
