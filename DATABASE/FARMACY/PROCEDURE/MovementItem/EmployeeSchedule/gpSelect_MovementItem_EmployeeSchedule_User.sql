-- Function: gpSelect_MovementItem_EmployeeSchedule_User()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_EmployeeSchedule_User(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_EmployeeSchedule_User(
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor
AS
$BODY$
  DECLARE cur1 refcursor;
  DECLARE cur2 refcursor;
  DECLARE vbUserId Integer;
  DECLARE vbMovementId Integer;
  DECLARE vbPlanValue TVarChar;
  DECLARE vbUserValue TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     --
     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
        SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', CURRENT_DATE), DATE_TRUNC ('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;


     -- возвращаем заголовки столбцов и даты
     OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime,
                          ((EXTRACT(DAY FROM tmpOperDate.OperDate))||case when tmpCalendar.Working = False then ' *' else ' ' END||tmpWeekDay.DayOfWeekName) ::TVarChar AS ValueField,
                          ''::TVarChar   AS ValueFieldUser
               FROM tmpOperDate
                   LEFT JOIN zfCalc_DayOfWeekName (tmpOperDate.OperDate) AS tmpWeekDay ON 1=1
                   LEFT JOIN gpSelect_Object_Calendar(tmpOperDate.OperDate,tmpOperDate.OperDate,inSession) tmpCalendar ON 1=1;
                   
     RETURN NEXT cur1;


     vbMovementId := 0;

      IF EXISTS(SELECT 1 FROM Movement
                WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
                  AND Movement.OperDate = DATE_TRUNC ('MONTH', CURRENT_DATE))
      THEN
         SELECT Movement.ID
         INTO vbMovementId
         FROM Movement
         WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
           AND Movement.OperDate = DATE_TRUNC ('MONTH', CURRENT_DATE);
      END IF;

      IF COALESCE (vbMovementId, 0) <> 0 AND
         EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementId = vbMovementId
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.ObjectId = vbUserId)
      THEN
        SELECT 
          COALESCE(MIString_ComingValueDayUser.ValueData, '0000000000000000000000000000000'),
          COALESCE(MIString_ComingValueDay.ValueData, '0000000000000000000000000000000')
        INTO 
          vbUserValue, 
          vbPlanValue
        FROM MovementItem

             LEFT JOIN MovementItemString AS MIString_ComingValueDayUser
                                          ON MIString_ComingValueDayUser.DescId = zc_MIString_ComingValueDayUser()
                                         AND MIString_ComingValueDayUser.MovementItemId = MovementItem.Id

             LEFT JOIN MovementItemString AS MIString_ComingValueDay
                                          ON MIString_ComingValueDay.DescId = zc_MIString_ComingValueDay()
                                         AND MIString_ComingValueDay.MovementItemId = MovementItem.Id

        WHERE MovementItem.MovementId = vbMovementId
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.ObjectId = vbUserId;
      ELSE
        vbUserValue := '0000000000000000000000000000000';
        vbPlanValue := '0000000000000000000000000000000';
      END IF;
      
      OPEN cur2 FOR
       SELECT
         0                                 AS ID,
         'Согласно графика'::TVarChar      AS WhoInput,
         lpDecodeValueDay(1, vbPlanValue)  AS Value1,
         lpDecodeValueDay(2, vbPlanValue)  AS Value2,
         lpDecodeValueDay(3, vbPlanValue)  AS Value3,
         lpDecodeValueDay(4, vbPlanValue)  AS Value4,
         lpDecodeValueDay(5, vbPlanValue)  AS Value5,
         lpDecodeValueDay(6, vbPlanValue)  AS Value6,
         lpDecodeValueDay(7, vbPlanValue)  AS Value7,
         lpDecodeValueDay(8, vbPlanValue)  AS Value8,
         lpDecodeValueDay(9, vbPlanValue)  AS Value9,
         lpDecodeValueDay(10, vbPlanValue) AS Value10,
         lpDecodeValueDay(11, vbPlanValue) AS Value11,
         lpDecodeValueDay(12, vbPlanValue) AS Value12,
         lpDecodeValueDay(13, vbPlanValue) AS Value13,
         lpDecodeValueDay(14, vbPlanValue) AS Value14,
         lpDecodeValueDay(15, vbPlanValue) AS Value15,
         lpDecodeValueDay(16, vbPlanValue) AS Value16,
         lpDecodeValueDay(17, vbPlanValue) AS Value17,
         lpDecodeValueDay(18, vbPlanValue) AS Value18,
         lpDecodeValueDay(19, vbPlanValue) AS Value19,
         lpDecodeValueDay(20, vbPlanValue) AS Value20,
         lpDecodeValueDay(21, vbPlanValue) AS Value21,
         lpDecodeValueDay(22, vbPlanValue) AS Value22,
         lpDecodeValueDay(23, vbPlanValue) AS Value23,
         lpDecodeValueDay(24, vbPlanValue) AS Value24,
         lpDecodeValueDay(25, vbPlanValue) AS Value25,
         lpDecodeValueDay(26, vbPlanValue) AS Value26,
         lpDecodeValueDay(27, vbPlanValue) AS Value27,
         lpDecodeValueDay(28, vbPlanValue) AS Value28,
         lpDecodeValueDay(29, vbPlanValue) AS Value29,
         lpDecodeValueDay(30, vbPlanValue) AS Value30,
         lpDecodeValueDay(31, vbPlanValue) AS Value31
       UNION ALL
       SELECT
         0                                  AS ID,
         'Отметки сотрудника'::TVarChar    AS WhoInput,
         lpDecodeValueDay(1, vbUserValue)  AS Value1,
         lpDecodeValueDay(2, vbUserValue)  AS Value2,
         lpDecodeValueDay(3, vbUserValue)  AS Value3,
         lpDecodeValueDay(4, vbUserValue)  AS Value4,
         lpDecodeValueDay(5, vbUserValue)  AS Value5,
         lpDecodeValueDay(6, vbUserValue)  AS Value6,
         lpDecodeValueDay(7, vbUserValue)  AS Value7,
         lpDecodeValueDay(8, vbUserValue)  AS Value8,
         lpDecodeValueDay(9, vbUserValue)  AS Value9,
         lpDecodeValueDay(10, vbUserValue) AS Value10,
         lpDecodeValueDay(11, vbUserValue) AS Value11,
         lpDecodeValueDay(12, vbUserValue) AS Value12,
         lpDecodeValueDay(13, vbUserValue) AS Value13,
         lpDecodeValueDay(14, vbUserValue) AS Value14,
         lpDecodeValueDay(15, vbUserValue) AS Value15,
         lpDecodeValueDay(16, vbUserValue) AS Value16,
         lpDecodeValueDay(17, vbUserValue) AS Value17,
         lpDecodeValueDay(18, vbUserValue) AS Value18,
         lpDecodeValueDay(19, vbUserValue) AS Value19,
         lpDecodeValueDay(20, vbUserValue) AS Value20,
         lpDecodeValueDay(21, vbUserValue) AS Value21,
         lpDecodeValueDay(22, vbUserValue) AS Value22,
         lpDecodeValueDay(23, vbUserValue) AS Value23,
         lpDecodeValueDay(24, vbUserValue) AS Value24,
         lpDecodeValueDay(25, vbUserValue) AS Value25,
         lpDecodeValueDay(26, vbUserValue) AS Value26,
         lpDecodeValueDay(27, vbUserValue) AS Value27,
         lpDecodeValueDay(28, vbUserValue) AS Value28,
         lpDecodeValueDay(29, vbUserValue) AS Value29,
         lpDecodeValueDay(30, vbUserValue) AS Value30,
         lpDecodeValueDay(31, vbUserValue) AS Value31;

     RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_EmployeeSchedule_User (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.12.18                                                       *
 08.12.18                                                       *
*/

-- тест
-- select * from gpSelect_MovementItem_EmployeeSchedule_User(inSession := '308120');