-- Function: gpGet_Movement_SheetWorkTime_Checked()

DROP FUNCTION IF EXISTS gpGet_Movement_SheetWorkTime_Checked (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_SheetWorkTime_Checked(
    IN inOperDate       TDateTime , --
    IN inUnitId         Integer   , --
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE (CheckedHeadName TVarChar
             , CheckedPersonalName TVarChar
             , CheckedHead_date TDateTime
             , CheckedPersonal_date TDateTime
             , isCheckedHead Boolean
             , isCheckedPersonal Boolean
             )
AS
$BODY$
     DECLARE vbEndDate    TDateTime;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_SheetWorkTime());
     
    -- первое число месяца
    inOperDate := DATE_TRUNC ('MONTH', inOperDate);
    -- последнее число месяца
    vbEndDate := DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';

     RETURN QUERY 
      SELECT DISTINCT
             Object_CheckedHead.ValueData              AS CheckedHeadName
           , Object_CheckedPersonal.ValueData          AS CheckedPersonalName

           , COALESCE (MovementDate_CheckedHead.ValueData, NULL)        :: TDateTime AS CheckedHead_date
           , COALESCE (MovementDate_CheckedPersonal.ValueData, NULL)    :: TDateTime AS CheckedPersonal_date
           , COALESCE (MovementBoolean_CheckedHead.ValueData,FALSE)     :: Boolean   AS isCheckedHead
           , COALESCE (MovementBoolean_CheckedPersonal.ValueData,FALSE) :: Boolean   AS isCheckedPersonal

      FROM Movement
            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                         AND MovementLinkObject_Unit.ObjectId = inUnitId

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

            LEFT JOIN MovementDate AS MovementDate_CheckedHead
                                   ON MovementDate_CheckedHead.MovementId = Movement.Id
                                  AND MovementDate_CheckedHead.DescId = zc_MovementDate_CheckedHead()
            LEFT JOIN MovementDate AS MovementDate_CheckedPersonal
                                   ON MovementDate_CheckedPersonal.MovementId = Movement.Id
                                  AND MovementDate_CheckedPersonal.DescId = zc_MovementDate_CheckedPersonal()

      WHERE Movement.DescId = zc_Movement_SheetWorkTime()
        AND Movement.OperDate BETWEEN inOperDate AND vbEndDate
        --AND (COALESCE (MovementBoolean_CheckedHead.ValueData,FALSE) = TRUE OR COALESCE (MovementBoolean_CheckedPersonal.ValueData,FALSE) = TRUE)
      LIMIT 1
        ;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.08.21         *
*/

-- тест
-- select * from gpGet_Movement_SheetWorkTime_Checked(inOperDate := ('01.06.2021')::TDateTime , inUnitId := 8423 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');