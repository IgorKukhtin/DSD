-- Function: gpSelect_MovementItem_EmployeeSchedule()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_EmployeeSchedule(Integer, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_EmployeeSchedule(
    IN inMovementId  Integer      , -- ключ Документа
    IN inDate        TDateTime    ,
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE cur1 refcursor;
  DECLARE cur2 refcursor;
  DECLARE cur3 refcursor;
  DECLARE vbDefaultValue TVarChar;
  DECLARE vbCurrDay Integer;
  DECLARE vbDate TDateTime;
  DECLARE vbMovementId  Integer;
  DECLARE i Integer;
  DECLARE vbQueryText Text;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

     inDate := DATE_TRUNC ('MONTH', inDate);

     CREATE TEMP TABLE tmpUnserUnit (UserId Integer, UnitId Integer,
               D1 BOOLEAN DEFAULT FALSE, D2 BOOLEAN DEFAULT FALSE, D3 BOOLEAN DEFAULT FALSE, D4 BOOLEAN DEFAULT FALSE, D5 BOOLEAN DEFAULT FALSE,
               D6 BOOLEAN DEFAULT FALSE, D7 BOOLEAN DEFAULT FALSE, D8 BOOLEAN DEFAULT FALSE, D9 BOOLEAN DEFAULT FALSE, D10 BOOLEAN DEFAULT FALSE,
               D11 BOOLEAN DEFAULT FALSE, D12 BOOLEAN DEFAULT FALSE, D13 BOOLEAN DEFAULT FALSE, D14 BOOLEAN DEFAULT FALSE, D15 BOOLEAN DEFAULT FALSE,
               D16 BOOLEAN DEFAULT FALSE, D17 BOOLEAN DEFAULT FALSE, D18 BOOLEAN DEFAULT FALSE, D19 BOOLEAN DEFAULT FALSE, D20 BOOLEAN DEFAULT FALSE,
               D21 BOOLEAN DEFAULT FALSE, D22 BOOLEAN DEFAULT FALSE, D23 BOOLEAN DEFAULT FALSE, D24 BOOLEAN DEFAULT FALSE, D25 BOOLEAN DEFAULT FALSE,
               D26 BOOLEAN DEFAULT FALSE, D27 BOOLEAN DEFAULT FALSE, D28 BOOLEAN DEFAULT FALSE, D29 BOOLEAN DEFAULT FALSE, D30 BOOLEAN DEFAULT FALSE,
               D31 BOOLEAN DEFAULT FALSE) ON COMMIT DROP;

     INSERT INTO tmpUnserUnit (UserId, UnitId)
     SELECT DISTINCT
            EmployeeWorkLog.UserId
          , EmployeeWorkLog.UnitId
     FROM EmployeeWorkLog
     WHERE EmployeeWorkLog.DateLogIn >= inDate AND EmployeeWorkLog.DateLogIn < inDate + INTERVAL '1 MONTH';

     I := 1;
     WHILE I <= date_part('DAY', inDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
     LOOP
       vbQueryText := 'UPDATE tmpUnserUnit SET D'||I::Text||' = CASE WHEN COALESCE (EWL.Ord, 0) = 0 THEN FALSE ELSE TRUE END
                       FROM (SELECT ROW_NUMBER() OVER (PARTITION BY EmployeeWorkLog.UserId
                                                 ORDER BY EmployeeWorkLog.DateLogIn) AS Ord
                                  , EmployeeWorkLog.UnitId
                                  , EmployeeWorkLog.UserId
                             FROM EmployeeWorkLog
                             WHERE EmployeeWorkLog.DateLogIn >= ('''||to_char(inDate + (I - 1) * INTERVAL '1 DAY', 'DD.MM.YYYY')||''')::TDateTime
                               AND EmployeeWorkLog.DateLogIn < ('''||to_char(inDate + I * INTERVAL '1 DAY', 'DD.MM.YYYY')||''')::TDateTime) AS EWL
                       WHERE EWL.Ord = 1
                         AND tmpUnserUnit.UnitId = EWL.UnitId
                         AND tmpUnserUnit.UserId = EWL.UserId';

       EXECUTE vbQueryText;
       I := I + 1;
     END LOOP;

     IF inDate < CURRENT_DATE AND inDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY' > CURRENT_DATE
     THEN

       INSERT INTO tmpUnserUnit (UserId, UnitId)
       SELECT Object_User.Id, Max(Object_Personal_View.UnitId)
       FROM Object AS Object_User

            INNER JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

            INNER JOIN Object_Personal_View ON Object_Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId

            LEFT JOIN tmpUnserUnit ON tmpUnserUnit.UnitId = Object_Personal_View.UnitId
                                  AND tmpUnserUnit.UserId = Object_User.Id

       WHERE Object_User.DescId = zc_Object_User()
         AND Object_User.Id NOT IN (SELECT tmpUnserUnit.UserId FROM tmpUnserUnit)
       GROUP BY Object_User.Id;

       I := date_part('DAY', CURRENT_DATE + INTERVAL '1 DAY');
       vbQueryText := 'D'||I::Text||' = True';
       I := I + 1;
       WHILE I <= date_part('DAY', inDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
       LOOP
         vbQueryText := vbQueryText||', D'||I::Text||' = True';
         I := I + 1;
       END LOOP;

       vbQueryText := 'UPDATE tmpUnserUnit SET '||vbQueryText||'
                       FROM (SELECT Object_User.Id AS UserId, Object_Personal_View.UnitId
                             FROM Object AS Object_User

                                  INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                        ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                                       AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

                                  INNER JOIN Object_Personal_View ON Object_Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId

                             WHERE Object_User.DescId = zc_Object_User()) AS EWL
                       WHERE tmpUnserUnit.UnitId = EWL.UnitId
                         AND tmpUnserUnit.UserId = EWL.UserId';

       EXECUTE vbQueryText;

     END IF;

     IF DATE_TRUNC ('MONTH', inDate) < DATE_TRUNC ('MONTH', CURRENT_DATE)
     THEN
       vbCurrDay := 31;
     ELSEIF DATE_TRUNC ('MONTH', inDate) = DATE_TRUNC ('MONTH', CURRENT_DATE)
     THEN
       vbCurrDay := date_part('day', CURRENT_DATE);
     ELSE
       vbCurrDay := 0;
     END IF;

     --
     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
        SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inDate), DATE_TRUNC ('MONTH', inDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;

     vbDate := DATE_TRUNC ('MONTH', inDate) - INTERVAL '1 MONTH';

     CREATE TEMP TABLE tmpOperDatePrev ON COMMIT DROP AS
        SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', vbDate), DATE_TRUNC ('MONTH', vbDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;

     SELECT Movement.Id
     INTO vbMovementId
     FROM Movement
     WHERE Movement.OperDate = vbDate
          AND Movement.DescId = zc_Movement_EmployeeSchedule();

     IF (SELECT count(*) FROM tmpOperDatePrev) <> (SELECT count(*) FROM tmpOperDate)
     THEN
       WHILE (SELECT count(*) FROM tmpOperDatePrev) <> (SELECT count(*) FROM tmpOperDate)
       LOOP
         IF (SELECT count(*) FROM tmpOperDatePrev) > (SELECT count(*) FROM tmpOperDate)
         THEN
           INSERT INTO tmpOperDate (OperDate) VALUES (NULL);
         ELSE
           INSERT INTO tmpOperDatePrev (OperDate) VALUES (NULL);
         END IF;
       END LOOP;
     END IF;


     -- возвращаем заголовки столбцов и даты
     OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime,
                          ((EXTRACT(DAY FROM tmpOperDate.OperDate))||case when tmpCalendar.Working = False then ' *' else ' ' END||tmpWeekDay.DayOfWeekName) ::TVarChar AS ValueField,
                          EXTRACT(DAY FROM tmpOperDate.OperDate)::TVarChar   AS ValueFieldUser
               FROM tmpOperDate
                   LEFT JOIN zfCalc_DayOfWeekName (tmpOperDate.OperDate) AS tmpWeekDay ON 1=1
                   LEFT JOIN gpSelect_Object_Calendar(tmpOperDate.OperDate,tmpOperDate.OperDate,inSession) tmpCalendar ON 1=1

      ;
     RETURN NEXT cur1;

     -- возвращаем заголовки столбцов и даты для предыдущего месяца
     OPEN cur2 FOR SELECT tmpOperDatePrev.OperDate::TDateTime,
                          ((EXTRACT(DAY FROM tmpOperDatePrev.OperDate))||case when tmpCalendar.Working = False then ' *' else ' ' END||tmpWeekDay.DayOfWeekName) ::TVarChar AS ValueField
               FROM tmpOperDatePrev
                   LEFT JOIN zfCalc_DayOfWeekName (tmpOperDatePrev.OperDate) AS tmpWeekDay ON 1=1
                   LEFT JOIN gpSelect_Object_Calendar(tmpOperDatePrev.OperDate,tmpOperDatePrev.OperDate,inSession) tmpCalendar ON 1=1

      ;
     RETURN NEXT cur2;

     vbDefaultValue := '0000000000000000000000000000000';

     IF COALESCE(inMovementId, 0) = 0 OR inShowAll = TRUE OR
        NOT EXISTS(SELECT MovementItem.ObjectId
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId = zc_MI_Master())
     THEN


       OPEN cur3 FOR
       WITH tmPersonal_View AS (SELECT Object_User.Id                      AS UserID
                                     , Max(Object_Personal_View.UnitId)    AS UnitId
                                     , Object_Personal_View.MemberId       AS MemberId
                                     , Object_Personal_View.PositionName   AS PositionName
                                FROM Object AS Object_User

                                     INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                           ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                                          AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

                                     INNER JOIN Object_Personal_View ON Object_Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId

                                WHERE Object_User.DescId = zc_Object_User()
                                GROUP BY Object_User.Id, Object_Personal_View.MemberId, Object_Personal_View.PositionName)


       SELECT
         0                                                           AS ID,
         tmPersonal_View.UserID                                      AS UserID,
         NULL::Boolean                                               AS IsErased,
         Object_Member.ObjectCode                                    AS PersonalCode,
         Object_Member.ValueData                                     AS PersonalName,
         tmPersonal_View.PositionName                                AS PositionName,
         Object_Unit.ID                                              AS UnitID,
         Object_Unit.ObjectCode                                      AS UnitCode,
         Object_Unit.ValueData                                       AS UnitName,
         lpDecodeValueDay(1, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev1,
         lpDecodeValueDay(2, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev2,
         lpDecodeValueDay(3, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev3,
         lpDecodeValueDay(4, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev4,
         lpDecodeValueDay(5, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev5,
         lpDecodeValueDay(6, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev6,
         lpDecodeValueDay(7, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev7,
         lpDecodeValueDay(8, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev8,
         lpDecodeValueDay(9, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev9,
         lpDecodeValueDay(10, MIString_ComingValueDayPrev.ValueData) AS ValuePrev10,
         lpDecodeValueDay(11, MIString_ComingValueDayPrev.ValueData) AS ValuePrev11,
         lpDecodeValueDay(12, MIString_ComingValueDayPrev.ValueData) AS ValuePrev12,
         lpDecodeValueDay(13, MIString_ComingValueDayPrev.ValueData) AS ValuePrev13,
         lpDecodeValueDay(14, MIString_ComingValueDayPrev.ValueData) AS ValuePrev14,
         lpDecodeValueDay(15, MIString_ComingValueDayPrev.ValueData) AS ValuePrev15,
         lpDecodeValueDay(16, MIString_ComingValueDayPrev.ValueData) AS ValuePrev16,
         lpDecodeValueDay(17, MIString_ComingValueDayPrev.ValueData) AS ValuePrev17,
         lpDecodeValueDay(18, MIString_ComingValueDayPrev.ValueData) AS ValuePrev18,
         lpDecodeValueDay(19, MIString_ComingValueDayPrev.ValueData) AS ValuePrev19,
         lpDecodeValueDay(20, MIString_ComingValueDayPrev.ValueData) AS ValuePrev20,
         lpDecodeValueDay(21, MIString_ComingValueDayPrev.ValueData) AS ValuePrev21,
         lpDecodeValueDay(22, MIString_ComingValueDayPrev.ValueData) AS ValuePrev22,
         lpDecodeValueDay(23, MIString_ComingValueDayPrev.ValueData) AS ValuePrev23,
         lpDecodeValueDay(24, MIString_ComingValueDayPrev.ValueData) AS ValuePrev24,
         lpDecodeValueDay(25, MIString_ComingValueDayPrev.ValueData) AS ValuePrev25,
         lpDecodeValueDay(26, MIString_ComingValueDayPrev.ValueData) AS ValuePrev26,
         lpDecodeValueDay(27, MIString_ComingValueDayPrev.ValueData) AS ValuePrev27,
         lpDecodeValueDay(28, MIString_ComingValueDayPrev.ValueData) AS ValuePrev28,
         lpDecodeValueDay(29, MIString_ComingValueDayPrev.ValueData) AS ValuePrev29,
         lpDecodeValueDay(30, MIString_ComingValueDayPrev.ValueData) AS ValuePrev30,
         lpDecodeValueDay(31, MIString_ComingValueDayPrev.ValueData) AS ValuePrev31,
         lpDecodeValueDay(1, vbDefaultValue)  AS Value1,
         lpDecodeValueDay(2, vbDefaultValue)  AS Value2,
         lpDecodeValueDay(3, vbDefaultValue)  AS Value3,
         lpDecodeValueDay(4, vbDefaultValue)  AS Value4,
         lpDecodeValueDay(5, vbDefaultValue)  AS Value5,
         lpDecodeValueDay(6, vbDefaultValue)  AS Value6,
         lpDecodeValueDay(7, vbDefaultValue)  AS Value7,
         lpDecodeValueDay(8, vbDefaultValue)  AS Value8,
         lpDecodeValueDay(9, vbDefaultValue)  AS Value9,
         lpDecodeValueDay(10, vbDefaultValue) AS Value10,
         lpDecodeValueDay(11, vbDefaultValue) AS Value11,
         lpDecodeValueDay(12, vbDefaultValue) AS Value12,
         lpDecodeValueDay(13, vbDefaultValue) AS Value13,
         lpDecodeValueDay(14, vbDefaultValue) AS Value14,
         lpDecodeValueDay(15, vbDefaultValue) AS Value15,
         lpDecodeValueDay(16, vbDefaultValue) AS Value16,
         lpDecodeValueDay(17, vbDefaultValue) AS Value17,
         lpDecodeValueDay(18, vbDefaultValue) AS Value18,
         lpDecodeValueDay(19, vbDefaultValue) AS Value19,
         lpDecodeValueDay(20, vbDefaultValue) AS Value20,
         lpDecodeValueDay(21, vbDefaultValue) AS Value21,
         lpDecodeValueDay(22, vbDefaultValue) AS Value22,
         lpDecodeValueDay(23, vbDefaultValue) AS Value23,
         lpDecodeValueDay(24, vbDefaultValue) AS Value24,
         lpDecodeValueDay(25, vbDefaultValue) AS Value25,
         lpDecodeValueDay(26, vbDefaultValue) AS Value26,
         lpDecodeValueDay(27, vbDefaultValue) AS Value27,
         lpDecodeValueDay(28, vbDefaultValue) AS Value28,
         lpDecodeValueDay(29, vbDefaultValue) AS Value29,
         lpDecodeValueDay(30, vbDefaultValue) AS Value30,
         lpDecodeValueDay(31, vbDefaultValue) AS Value31,
         lpDecodeValueDay(1, vbDefaultValue)  AS ValueUser1,
         lpDecodeValueDay(2, vbDefaultValue)  AS ValueUser2,
         lpDecodeValueDay(3, vbDefaultValue)  AS ValueUser3,
         lpDecodeValueDay(4, vbDefaultValue)  AS ValueUser4,
         lpDecodeValueDay(5, vbDefaultValue)  AS ValueUser5,
         lpDecodeValueDay(6, vbDefaultValue)  AS ValueUser6,
         lpDecodeValueDay(7, vbDefaultValue)  AS ValueUser7,
         lpDecodeValueDay(8, vbDefaultValue)  AS ValueUser8,
         lpDecodeValueDay(9, vbDefaultValue)  AS ValueUser9,
         lpDecodeValueDay(10, vbDefaultValue) AS ValueUser10,
         lpDecodeValueDay(11, vbDefaultValue) AS ValueUser11,
         lpDecodeValueDay(12, vbDefaultValue) AS ValueUser12,
         lpDecodeValueDay(13, vbDefaultValue) AS ValueUser13,
         lpDecodeValueDay(14, vbDefaultValue) AS ValueUser14,
         lpDecodeValueDay(15, vbDefaultValue) AS ValueUser15,
         lpDecodeValueDay(16, vbDefaultValue) AS ValueUser16,
         lpDecodeValueDay(17, vbDefaultValue) AS ValueUser17,
         lpDecodeValueDay(18, vbDefaultValue) AS ValueUser18,
         lpDecodeValueDay(19, vbDefaultValue) AS ValueUser19,
         lpDecodeValueDay(20, vbDefaultValue) AS ValueUser20,
         lpDecodeValueDay(21, vbDefaultValue) AS ValueUser21,
         lpDecodeValueDay(22, vbDefaultValue) AS ValueUser22,
         lpDecodeValueDay(23, vbDefaultValue) AS ValueUser23,
         lpDecodeValueDay(24, vbDefaultValue) AS ValueUser24,
         lpDecodeValueDay(25, vbDefaultValue) AS ValueUser25,
         lpDecodeValueDay(26, vbDefaultValue) AS ValueUser26,
         lpDecodeValueDay(27, vbDefaultValue) AS ValueUser27,
         lpDecodeValueDay(28, vbDefaultValue) AS ValueUser28,
         lpDecodeValueDay(29, vbDefaultValue) AS ValueUser29,
         lpDecodeValueDay(30, vbDefaultValue) AS ValueUser30,
         lpDecodeValueDay(31, vbDefaultValue) AS ValueUser31,
         1                                    AS TypeId1,
         2                                    AS TypeId2,
         3                                    AS TypeId3,
         4                                    AS TypeId4,
         5                                    AS TypeId5,
         6                                    AS TypeId6,
         7                                    AS TypeId7,
         8                                    AS TypeId8,
         9                                    AS TypeId9,
         10                                   AS TypeId10,
         11                                   AS TypeId11,
         12                                   AS TypeId12,
         13                                   AS TypeId13,
         14                                   AS TypeId14,
         15                                   AS TypeId15,
         16                                   AS TypeId16,
         17                                   AS TypeId17,
         18                                   AS TypeId18,
         19                                   AS TypeId19,
         20                                   AS TypeId20,
         21                                   AS TypeId21,
         22                                   AS TypeId22,
         23                                   AS TypeId23,
         24                                   AS TypeId24,
         25                                   AS TypeId25,
         26                                   AS TypeId26,
         27                                   AS TypeId27,
         28                                   AS TypeId28,
         29                                   AS TypeId29,
         30                                   AS TypeId30,
         31                                   AS TypeId31,
         zc_Color_White()                     AS Color_Calc1,
         zc_Color_White()                     AS Color_Calc2,
         zc_Color_White()                     AS Color_Calc3,
         zc_Color_White()                     AS Color_Calc4,
         zc_Color_White()                     AS Color_Calc5,
         zc_Color_White()                     AS Color_Calc6,
         zc_Color_White()                     AS Color_Calc7,
         zc_Color_White()                     AS Color_Calc8,
         zc_Color_White()                     AS Color_Calc9,
         zc_Color_White()                     AS Color_Calc10,
         zc_Color_White()                     AS Color_Calc11,
         zc_Color_White()                     AS Color_Calc12,
         zc_Color_White()                     AS Color_Calc13,
         zc_Color_White()                     AS Color_Calc14,
         zc_Color_White()                     AS Color_Calc15,
         zc_Color_White()                     AS Color_Calc16,
         zc_Color_White()                     AS Color_Calc17,
         zc_Color_White()                     AS Color_Calc18,
         zc_Color_White()                     AS Color_Calc19,
         zc_Color_White()                     AS Color_Calc20,
         zc_Color_White()                     AS Color_Calc21,
         zc_Color_White()                     AS Color_Calc22,
         zc_Color_White()                     AS Color_Calc23,
         zc_Color_White()                     AS Color_Calc24,
         zc_Color_White()                     AS Color_Calc25,
         zc_Color_White()                     AS Color_Calc26,
         zc_Color_White()                     AS Color_Calc27,
         zc_Color_White()                     AS Color_Calc28,
         zc_Color_White()                     AS Color_Calc29,
         zc_Color_White()                     AS Color_Calc30,
         zc_Color_White()                     AS Color_Calc31
       FROM tmPersonal_View

            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmPersonal_View.MemberId

            LEFT JOIN tmpUnserUnit ON tmpUnserUnit.UserId = tmPersonal_View.UserId

            LEFT JOIN MovementItem AS MovementItemPrev
                                   ON MovementItemPrev.MovementId = vbMovementId
                                  AND MovementItemPrev.ObjectId = tmpUnserUnit.UserID
                                  AND MovementItemPrev.DescId = zc_MI_Master()

            LEFT JOIN MovementItemString AS MIString_ComingValueDayPrev
                                         ON MIString_ComingValueDayPrev.DescId = zc_MIString_ComingValueDay()
                                        AND MIString_ComingValueDayPrev.MovementItemId = MovementItemPrev.Id

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE(tmpUnserUnit.UnitID, tmPersonal_View.UnitID)

       WHERE tmpUnserUnit.UserID NOT IN (SELECT MovementItem.ObjectId
                                         FROM MovementItem
                                         WHERE MovementItem.MovementId = inMovementId
                                           AND MovementItem.DescId = zc_MI_Master())
       UNION ALL

       SELECT
         MovementItem.Id                                         AS ID,
         MovementItem.ObjectId                                   AS UserID,
         MovementItem.IsErased                                   AS IsErased,
         Object_Member.ObjectCode                                AS PersonalCode,
         Object_Member.ValueData                                 AS PersonalName,
         Personal_View.PositionName                              AS PositionName,
         Object_Unit.ID                                          AS UnitID,
         Object_Unit.ObjectCode                                  AS UnitCode,
         Object_Unit.ValueData                                   AS UnitName,
         lpDecodeValueDay(1, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev1,
         lpDecodeValueDay(2, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev2,
         lpDecodeValueDay(3, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev3,
         lpDecodeValueDay(4, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev4,
         lpDecodeValueDay(5, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev5,
         lpDecodeValueDay(6, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev6,
         lpDecodeValueDay(7, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev7,
         lpDecodeValueDay(8, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev8,
         lpDecodeValueDay(9, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev9,
         lpDecodeValueDay(10, MIString_ComingValueDayPrev.ValueData) AS ValuePrev10,
         lpDecodeValueDay(11, MIString_ComingValueDayPrev.ValueData) AS ValuePrev11,
         lpDecodeValueDay(12, MIString_ComingValueDayPrev.ValueData) AS ValuePrev12,
         lpDecodeValueDay(13, MIString_ComingValueDayPrev.ValueData) AS ValuePrev13,
         lpDecodeValueDay(14, MIString_ComingValueDayPrev.ValueData) AS ValuePrev14,
         lpDecodeValueDay(15, MIString_ComingValueDayPrev.ValueData) AS ValuePrev15,
         lpDecodeValueDay(16, MIString_ComingValueDayPrev.ValueData) AS ValuePrev16,
         lpDecodeValueDay(17, MIString_ComingValueDayPrev.ValueData) AS ValuePrev17,
         lpDecodeValueDay(18, MIString_ComingValueDayPrev.ValueData) AS ValuePrev18,
         lpDecodeValueDay(19, MIString_ComingValueDayPrev.ValueData) AS ValuePrev19,
         lpDecodeValueDay(20, MIString_ComingValueDayPrev.ValueData) AS ValuePrev20,
         lpDecodeValueDay(21, MIString_ComingValueDayPrev.ValueData) AS ValuePrev21,
         lpDecodeValueDay(22, MIString_ComingValueDayPrev.ValueData) AS ValuePrev22,
         lpDecodeValueDay(23, MIString_ComingValueDayPrev.ValueData) AS ValuePrev23,
         lpDecodeValueDay(24, MIString_ComingValueDayPrev.ValueData) AS ValuePrev24,
         lpDecodeValueDay(25, MIString_ComingValueDayPrev.ValueData) AS ValuePrev25,
         lpDecodeValueDay(26, MIString_ComingValueDayPrev.ValueData) AS ValuePrev26,
         lpDecodeValueDay(27, MIString_ComingValueDayPrev.ValueData) AS ValuePrev27,
         lpDecodeValueDay(28, MIString_ComingValueDayPrev.ValueData) AS ValuePrev28,
         lpDecodeValueDay(29, MIString_ComingValueDayPrev.ValueData) AS ValuePrev29,
         lpDecodeValueDay(30, MIString_ComingValueDayPrev.ValueData) AS ValuePrev30,
         lpDecodeValueDay(31, MIString_ComingValueDayPrev.ValueData) AS ValuePrev31,
         lpDecodeValueDay(1, MIString_ComingValueDay.ValueData)  AS Value1,
         lpDecodeValueDay(2, MIString_ComingValueDay.ValueData)  AS Value2,
         lpDecodeValueDay(3, MIString_ComingValueDay.ValueData)  AS Value3,
         lpDecodeValueDay(4, MIString_ComingValueDay.ValueData)  AS Value4,
         lpDecodeValueDay(5, MIString_ComingValueDay.ValueData)  AS Value5,
         lpDecodeValueDay(6, MIString_ComingValueDay.ValueData)  AS Value6,
         lpDecodeValueDay(7, MIString_ComingValueDay.ValueData)  AS Value7,
         lpDecodeValueDay(8, MIString_ComingValueDay.ValueData)  AS Value8,
         lpDecodeValueDay(9, MIString_ComingValueDay.ValueData)  AS Value9,
         lpDecodeValueDay(10, MIString_ComingValueDay.ValueData) AS Value10,
         lpDecodeValueDay(11, MIString_ComingValueDay.ValueData) AS Value11,
         lpDecodeValueDay(12, MIString_ComingValueDay.ValueData) AS Value12,
         lpDecodeValueDay(13, MIString_ComingValueDay.ValueData) AS Value13,
         lpDecodeValueDay(14, MIString_ComingValueDay.ValueData) AS Value14,
         lpDecodeValueDay(15, MIString_ComingValueDay.ValueData) AS Value15,
         lpDecodeValueDay(16, MIString_ComingValueDay.ValueData) AS Value16,
         lpDecodeValueDay(17, MIString_ComingValueDay.ValueData) AS Value17,
         lpDecodeValueDay(18, MIString_ComingValueDay.ValueData) AS Value18,
         lpDecodeValueDay(19, MIString_ComingValueDay.ValueData) AS Value19,
         lpDecodeValueDay(20, MIString_ComingValueDay.ValueData) AS Value20,
         lpDecodeValueDay(21, MIString_ComingValueDay.ValueData) AS Value21,
         lpDecodeValueDay(22, MIString_ComingValueDay.ValueData) AS Value22,
         lpDecodeValueDay(23, MIString_ComingValueDay.ValueData) AS Value23,
         lpDecodeValueDay(24, MIString_ComingValueDay.ValueData) AS Value24,
         lpDecodeValueDay(25, MIString_ComingValueDay.ValueData) AS Value25,
         lpDecodeValueDay(26, MIString_ComingValueDay.ValueData) AS Value26,
         lpDecodeValueDay(27, MIString_ComingValueDay.ValueData) AS Value27,
         lpDecodeValueDay(28, MIString_ComingValueDay.ValueData) AS Value28,
         lpDecodeValueDay(29, MIString_ComingValueDay.ValueData) AS Value29,
         lpDecodeValueDay(30, MIString_ComingValueDay.ValueData) AS Value30,
         lpDecodeValueDay(31, MIString_ComingValueDay.ValueData) AS Value31,
         lpDecodeValueDay(1, MIString_ComingValueDayUser.ValueData)  AS ValueUser1,
         lpDecodeValueDay(2, MIString_ComingValueDayUser.ValueData)  AS ValueUser2,
         lpDecodeValueDay(3, MIString_ComingValueDayUser.ValueData)  AS ValueUser3,
         lpDecodeValueDay(4, MIString_ComingValueDayUser.ValueData)  AS ValueUser4,
         lpDecodeValueDay(5, MIString_ComingValueDayUser.ValueData)  AS ValueUser5,
         lpDecodeValueDay(6, MIString_ComingValueDayUser.ValueData)  AS ValueUser6,
         lpDecodeValueDay(7, MIString_ComingValueDayUser.ValueData)  AS ValueUser7,
         lpDecodeValueDay(8, MIString_ComingValueDayUser.ValueData)  AS ValueUser8,
         lpDecodeValueDay(9, MIString_ComingValueDayUser.ValueData)  AS ValueUser9,
         lpDecodeValueDay(10, MIString_ComingValueDayUser.ValueData) AS ValueUser10,
         lpDecodeValueDay(11, MIString_ComingValueDayUser.ValueData) AS ValueUser11,
         lpDecodeValueDay(12, MIString_ComingValueDayUser.ValueData) AS ValueUser12,
         lpDecodeValueDay(13, MIString_ComingValueDayUser.ValueData) AS ValueUser13,
         lpDecodeValueDay(14, MIString_ComingValueDayUser.ValueData) AS ValueUser14,
         lpDecodeValueDay(15, MIString_ComingValueDayUser.ValueData) AS ValueUser15,
         lpDecodeValueDay(16, MIString_ComingValueDayUser.ValueData) AS ValueUser16,
         lpDecodeValueDay(17, MIString_ComingValueDayUser.ValueData) AS ValueUser17,
         lpDecodeValueDay(18, MIString_ComingValueDayUser.ValueData) AS ValueUser18,
         lpDecodeValueDay(19, MIString_ComingValueDayUser.ValueData) AS ValueUser19,
         lpDecodeValueDay(20, MIString_ComingValueDayUser.ValueData) AS ValueUser20,
         lpDecodeValueDay(21, MIString_ComingValueDayUser.ValueData) AS ValueUser21,
         lpDecodeValueDay(22, MIString_ComingValueDayUser.ValueData) AS ValueUser22,
         lpDecodeValueDay(23, MIString_ComingValueDayUser.ValueData) AS ValueUser23,
         lpDecodeValueDay(24, MIString_ComingValueDayUser.ValueData) AS ValueUser24,
         lpDecodeValueDay(25, MIString_ComingValueDayUser.ValueData) AS ValueUser25,
         lpDecodeValueDay(26, MIString_ComingValueDayUser.ValueData) AS ValueUser26,
         lpDecodeValueDay(27, MIString_ComingValueDayUser.ValueData) AS ValueUser27,
         lpDecodeValueDay(28, MIString_ComingValueDayUser.ValueData) AS ValueUser28,
         lpDecodeValueDay(29, MIString_ComingValueDayUser.ValueData) AS ValueUser29,
         lpDecodeValueDay(30, MIString_ComingValueDayUser.ValueData) AS ValueUser30,
         lpDecodeValueDay(31, MIString_ComingValueDayUser.ValueData) AS ValueUser31,
         1                                                       AS TypeId1,
         2                                                       AS TypeId2,
         3                                                       AS TypeId3,
         4                                                       AS TypeId4,
         5                                                       AS TypeId5,
         6                                                       AS TypeId6,
         7                                                       AS TypeId7,
         8                                                       AS TypeId8,
         9                                                       AS TypeId9,
         10                                                      AS TypeId10,
         11                                                      AS TypeId11,
         12                                                      AS TypeId12,
         13                                                      AS TypeId13,
         14                                                      AS TypeId14,
         15                                                      AS TypeId15,
         16                                                      AS TypeId16,
         17                                                      AS TypeId17,
         18                                                      AS TypeId18,
         19                                                      AS TypeId19,
         20                                                      AS TypeId20,
         21                                                      AS TypeId21,
         22                                                      AS TypeId22,
         23                                                      AS TypeId23,
         24                                                      AS TypeId24,
         25                                                      AS TypeId25,
         26                                                      AS TypeId26,
         27                                                      AS TypeId27,
         28                                                      AS TypeId28,
         29                                                      AS TypeId29,
         30                                                      AS TypeId30,
         31                                                      AS TypeId31,
         CASE WHEN COALESCE(tmpUnserUnit.D1, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 1, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 1, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc1,
         CASE WHEN COALESCE(tmpUnserUnit.D2, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 2 AND SUBSTRING(MIString_ComingValueDay.ValueData, 2, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 2, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc2,
         CASE WHEN COALESCE(tmpUnserUnit.D3, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 3 AND SUBSTRING(MIString_ComingValueDay.ValueData, 3, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 3, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc3,
         CASE WHEN COALESCE(tmpUnserUnit.D4, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 4 AND SUBSTRING(MIString_ComingValueDay.ValueData, 4, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 4, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc4,
         CASE WHEN COALESCE(tmpUnserUnit.D5, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 5 AND SUBSTRING(MIString_ComingValueDay.ValueData, 5, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 5, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc5,
         CASE WHEN COALESCE(tmpUnserUnit.D6, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 6 AND SUBSTRING(MIString_ComingValueDay.ValueData, 6, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 6, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc6,
         CASE WHEN COALESCE(tmpUnserUnit.D7, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 7 AND SUBSTRING(MIString_ComingValueDay.ValueData, 7, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 7, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc7,
         CASE WHEN COALESCE(tmpUnserUnit.D8, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 8 AND SUBSTRING(MIString_ComingValueDay.ValueData, 8, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 8, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc8,
         CASE WHEN COALESCE(tmpUnserUnit.D9, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 9 AND SUBSTRING(MIString_ComingValueDay.ValueData, 9, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 9, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc9,
         CASE WHEN COALESCE(tmpUnserUnit.D10, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 10 AND SUBSTRING(MIString_ComingValueDay.ValueData, 10, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 10, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc10,
         CASE WHEN COALESCE(tmpUnserUnit.D11, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 11 AND SUBSTRING(MIString_ComingValueDay.ValueData, 11, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 11, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc11,
         CASE WHEN COALESCE(tmpUnserUnit.D12, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 12 AND SUBSTRING(MIString_ComingValueDay.ValueData, 12, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 12, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc12,
         CASE WHEN COALESCE(tmpUnserUnit.D13, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 13 AND SUBSTRING(MIString_ComingValueDay.ValueData, 13, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 13, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc13,
         CASE WHEN COALESCE(tmpUnserUnit.D14, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 14 AND SUBSTRING(MIString_ComingValueDay.ValueData, 14, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 14, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc14,
         CASE WHEN COALESCE(tmpUnserUnit.D15, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 15 AND SUBSTRING(MIString_ComingValueDay.ValueData, 15, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 15, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc15,
         CASE WHEN COALESCE(tmpUnserUnit.D16, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 16 AND SUBSTRING(MIString_ComingValueDay.ValueData, 16, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 16, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc16,
         CASE WHEN COALESCE(tmpUnserUnit.D17, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 17 AND SUBSTRING(MIString_ComingValueDay.ValueData, 17, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 17, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc17,
         CASE WHEN COALESCE(tmpUnserUnit.D18, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 18 AND SUBSTRING(MIString_ComingValueDay.ValueData, 18, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 18, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc18,
         CASE WHEN COALESCE(tmpUnserUnit.D19, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 19 AND SUBSTRING(MIString_ComingValueDay.ValueData, 19, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 19, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc19,
         CASE WHEN COALESCE(tmpUnserUnit.D20, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 20 AND SUBSTRING(MIString_ComingValueDay.ValueData, 20, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 20, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc20,
         CASE WHEN COALESCE(tmpUnserUnit.D21, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 21 AND SUBSTRING(MIString_ComingValueDay.ValueData, 21, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 21, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc21,
         CASE WHEN COALESCE(tmpUnserUnit.D22, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 22 AND SUBSTRING(MIString_ComingValueDay.ValueData, 22, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 22, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc22,
         CASE WHEN COALESCE(tmpUnserUnit.D23, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 23 AND SUBSTRING(MIString_ComingValueDay.ValueData, 23, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 23, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc23,
         CASE WHEN COALESCE(tmpUnserUnit.D24, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 24 AND SUBSTRING(MIString_ComingValueDay.ValueData, 24, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 24, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc24,
         CASE WHEN COALESCE(tmpUnserUnit.D25, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 25 AND SUBSTRING(MIString_ComingValueDay.ValueData, 25, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 25, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc25,
         CASE WHEN COALESCE(tmpUnserUnit.D26, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 26 AND SUBSTRING(MIString_ComingValueDay.ValueData, 26, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 26, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc26,
         CASE WHEN COALESCE(tmpUnserUnit.D27, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 27 AND SUBSTRING(MIString_ComingValueDay.ValueData, 27, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 27, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc27,
         CASE WHEN COALESCE(tmpUnserUnit.D28, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 28 AND SUBSTRING(MIString_ComingValueDay.ValueData, 28, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 28, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc28,
         CASE WHEN COALESCE(tmpUnserUnit.D29, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 29 AND SUBSTRING(MIString_ComingValueDay.ValueData, 29, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 29, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc29,
         CASE WHEN COALESCE(tmpUnserUnit.D30, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 30 AND SUBSTRING(MIString_ComingValueDay.ValueData, 30, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 30, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc30,
         CASE WHEN COALESCE(tmpUnserUnit.D31, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 31 AND SUBSTRING(MIString_ComingValueDay.ValueData, 31, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 31, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc31
       FROM Movement

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                   AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN tmpUnserUnit ON tmpUnserUnit.UserId = MovementItem.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId

            LEFT JOIN tmPersonal_View AS Personal_View ON Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE(tmpUnserUnit.UnitID, Personal_View.UnitID)

            INNER JOIN MovementItemString AS MIString_ComingValueDay
                                          ON MIString_ComingValueDay.DescId = zc_MIString_ComingValueDay()
                                         AND MIString_ComingValueDay.MovementItemId = MovementItem.Id

            LEFT JOIN MovementItemString AS MIString_ComingValueDayUser
                                         ON MIString_ComingValueDayUser.DescId = zc_MIString_ComingValueDayUser()
                                        AND MIString_ComingValueDayUser.MovementItemId = MovementItem.Id

            LEFT JOIN MovementItem AS MovementItemPrev
                                   ON MovementItemPrev.MovementId = vbMovementId
                                  AND MovementItemPrev.ObjectId = MovementItem.ObjectId
                                  AND MovementItemPrev.DescId = zc_MI_Master()

            LEFT JOIN MovementItemString AS MIString_ComingValueDayPrev
                                         ON MIString_ComingValueDayPrev.DescId = zc_MIString_ComingValueDay()
                                        AND MIString_ComingValueDayPrev.MovementItemId = MovementItemPrev.Id

       WHERE Movement.ID = inMovementId
         AND (MovementItem.IsErased = FALSE OR inIsErased = TRUE);
     ELSE
       OPEN cur3 FOR
       WITH tmPersonal_View AS (SELECT Object_User.Id                      AS UserID
                                     , Max(Object_Personal_View.UnitId)    AS UnitId
                                     , Object_Personal_View.MemberId       AS MemberId
                                     , Object_Personal_View.PositionName   AS PositionName
                                FROM Object AS Object_User

                                     INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                           ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                                          AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

                                     INNER JOIN Object_Personal_View ON Object_Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId

                                WHERE Object_User.DescId = zc_Object_User()
                                GROUP BY Object_User.Id, Object_Personal_View.MemberId, Object_Personal_View.PositionName)

       SELECT
         MovementItem.Id                                         AS ID,
         MovementItem.ObjectId                                   AS UserID,
         MovementItem.IsErased                                   AS IsErased,
         Object_Member.ObjectCode                                AS PersonalCode,
         Object_Member.ValueData                                 AS PersonalName,
         Personal_View.PositionName                              AS PositionName,
         Object_Unit.ID                                          AS UnitID,
         Object_Unit.ObjectCode                                  AS UnitCode,
         Object_Unit.ValueData                                   AS UnitName,
         lpDecodeValueDay(1, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev1,
         lpDecodeValueDay(2, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev2,
         lpDecodeValueDay(3, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev3,
         lpDecodeValueDay(4, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev4,
         lpDecodeValueDay(5, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev5,
         lpDecodeValueDay(6, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev6,
         lpDecodeValueDay(7, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev7,
         lpDecodeValueDay(8, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev8,
         lpDecodeValueDay(9, MIString_ComingValueDayPrev.ValueData)  AS ValuePrev9,
         lpDecodeValueDay(10, MIString_ComingValueDayPrev.ValueData) AS ValuePrev10,
         lpDecodeValueDay(11, MIString_ComingValueDayPrev.ValueData) AS ValuePrev11,
         lpDecodeValueDay(12, MIString_ComingValueDayPrev.ValueData) AS ValuePrev12,
         lpDecodeValueDay(13, MIString_ComingValueDayPrev.ValueData) AS ValuePrev13,
         lpDecodeValueDay(14, MIString_ComingValueDayPrev.ValueData) AS ValuePrev14,
         lpDecodeValueDay(15, MIString_ComingValueDayPrev.ValueData) AS ValuePrev15,
         lpDecodeValueDay(16, MIString_ComingValueDayPrev.ValueData) AS ValuePrev16,
         lpDecodeValueDay(17, MIString_ComingValueDayPrev.ValueData) AS ValuePrev17,
         lpDecodeValueDay(18, MIString_ComingValueDayPrev.ValueData) AS ValuePrev18,
         lpDecodeValueDay(19, MIString_ComingValueDayPrev.ValueData) AS ValuePrev19,
         lpDecodeValueDay(20, MIString_ComingValueDayPrev.ValueData) AS ValuePrev20,
         lpDecodeValueDay(21, MIString_ComingValueDayPrev.ValueData) AS ValuePrev21,
         lpDecodeValueDay(22, MIString_ComingValueDayPrev.ValueData) AS ValuePrev22,
         lpDecodeValueDay(23, MIString_ComingValueDayPrev.ValueData) AS ValuePrev23,
         lpDecodeValueDay(24, MIString_ComingValueDayPrev.ValueData) AS ValuePrev24,
         lpDecodeValueDay(25, MIString_ComingValueDayPrev.ValueData) AS ValuePrev25,
         lpDecodeValueDay(26, MIString_ComingValueDayPrev.ValueData) AS ValuePrev26,
         lpDecodeValueDay(27, MIString_ComingValueDayPrev.ValueData) AS ValuePrev27,
         lpDecodeValueDay(28, MIString_ComingValueDayPrev.ValueData) AS ValuePrev28,
         lpDecodeValueDay(29, MIString_ComingValueDayPrev.ValueData) AS ValuePrev29,
         lpDecodeValueDay(30, MIString_ComingValueDayPrev.ValueData) AS ValuePrev30,
         lpDecodeValueDay(31, MIString_ComingValueDayPrev.ValueData) AS ValuePrev31,
         lpDecodeValueDay(1, MIString_ComingValueDay.ValueData)  AS Value1,
         lpDecodeValueDay(2, MIString_ComingValueDay.ValueData)  AS Value2,
         lpDecodeValueDay(3, MIString_ComingValueDay.ValueData)  AS Value3,
         lpDecodeValueDay(4, MIString_ComingValueDay.ValueData)  AS Value4,
         lpDecodeValueDay(5, MIString_ComingValueDay.ValueData)  AS Value5,
         lpDecodeValueDay(6, MIString_ComingValueDay.ValueData)  AS Value6,
         lpDecodeValueDay(7, MIString_ComingValueDay.ValueData)  AS Value7,
         lpDecodeValueDay(8, MIString_ComingValueDay.ValueData)  AS Value8,
         lpDecodeValueDay(9, MIString_ComingValueDay.ValueData)  AS Value9,
         lpDecodeValueDay(10, MIString_ComingValueDay.ValueData) AS Value10,
         lpDecodeValueDay(11, MIString_ComingValueDay.ValueData) AS Value11,
         lpDecodeValueDay(12, MIString_ComingValueDay.ValueData) AS Value12,
         lpDecodeValueDay(13, MIString_ComingValueDay.ValueData) AS Value13,
         lpDecodeValueDay(14, MIString_ComingValueDay.ValueData) AS Value14,
         lpDecodeValueDay(15, MIString_ComingValueDay.ValueData) AS Value15,
         lpDecodeValueDay(16, MIString_ComingValueDay.ValueData) AS Value16,
         lpDecodeValueDay(17, MIString_ComingValueDay.ValueData) AS Value17,
         lpDecodeValueDay(18, MIString_ComingValueDay.ValueData) AS Value18,
         lpDecodeValueDay(19, MIString_ComingValueDay.ValueData) AS Value19,
         lpDecodeValueDay(20, MIString_ComingValueDay.ValueData) AS Value20,
         lpDecodeValueDay(21, MIString_ComingValueDay.ValueData) AS Value21,
         lpDecodeValueDay(22, MIString_ComingValueDay.ValueData) AS Value22,
         lpDecodeValueDay(23, MIString_ComingValueDay.ValueData) AS Value23,
         lpDecodeValueDay(24, MIString_ComingValueDay.ValueData) AS Value24,
         lpDecodeValueDay(25, MIString_ComingValueDay.ValueData) AS Value25,
         lpDecodeValueDay(26, MIString_ComingValueDay.ValueData) AS Value26,
         lpDecodeValueDay(27, MIString_ComingValueDay.ValueData) AS Value27,
         lpDecodeValueDay(28, MIString_ComingValueDay.ValueData) AS Value28,
         lpDecodeValueDay(29, MIString_ComingValueDay.ValueData) AS Value29,
         lpDecodeValueDay(30, MIString_ComingValueDay.ValueData) AS Value30,
         lpDecodeValueDay(31, MIString_ComingValueDay.ValueData) AS Value31,
         lpDecodeValueDay(1, MIString_ComingValueDayUser.ValueData)  AS ValueUser1,
         lpDecodeValueDay(2, MIString_ComingValueDayUser.ValueData)  AS ValueUser2,
         lpDecodeValueDay(3, MIString_ComingValueDayUser.ValueData)  AS ValueUser3,
         lpDecodeValueDay(4, MIString_ComingValueDayUser.ValueData)  AS ValueUser4,
         lpDecodeValueDay(5, MIString_ComingValueDayUser.ValueData)  AS ValueUser5,
         lpDecodeValueDay(6, MIString_ComingValueDayUser.ValueData)  AS ValueUser6,
         lpDecodeValueDay(7, MIString_ComingValueDayUser.ValueData)  AS ValueUser7,
         lpDecodeValueDay(8, MIString_ComingValueDayUser.ValueData)  AS ValueUser8,
         lpDecodeValueDay(9, MIString_ComingValueDayUser.ValueData)  AS ValueUser9,
         lpDecodeValueDay(10, MIString_ComingValueDayUser.ValueData) AS ValueUser10,
         lpDecodeValueDay(11, MIString_ComingValueDayUser.ValueData) AS ValueUser11,
         lpDecodeValueDay(12, MIString_ComingValueDayUser.ValueData) AS ValueUser12,
         lpDecodeValueDay(13, MIString_ComingValueDayUser.ValueData) AS ValueUser13,
         lpDecodeValueDay(14, MIString_ComingValueDayUser.ValueData) AS ValueUser14,
         lpDecodeValueDay(15, MIString_ComingValueDayUser.ValueData) AS ValueUser15,
         lpDecodeValueDay(16, MIString_ComingValueDayUser.ValueData) AS ValueUser16,
         lpDecodeValueDay(17, MIString_ComingValueDayUser.ValueData) AS ValueUser17,
         lpDecodeValueDay(18, MIString_ComingValueDayUser.ValueData) AS ValueUser18,
         lpDecodeValueDay(19, MIString_ComingValueDayUser.ValueData) AS ValueUser19,
         lpDecodeValueDay(20, MIString_ComingValueDayUser.ValueData) AS ValueUser20,
         lpDecodeValueDay(21, MIString_ComingValueDayUser.ValueData) AS ValueUser21,
         lpDecodeValueDay(22, MIString_ComingValueDayUser.ValueData) AS ValueUser22,
         lpDecodeValueDay(23, MIString_ComingValueDayUser.ValueData) AS ValueUser23,
         lpDecodeValueDay(24, MIString_ComingValueDayUser.ValueData) AS ValueUser24,
         lpDecodeValueDay(25, MIString_ComingValueDayUser.ValueData) AS ValueUser25,
         lpDecodeValueDay(26, MIString_ComingValueDayUser.ValueData) AS ValueUser26,
         lpDecodeValueDay(27, MIString_ComingValueDayUser.ValueData) AS ValueUser27,
         lpDecodeValueDay(28, MIString_ComingValueDayUser.ValueData) AS ValueUser28,
         lpDecodeValueDay(29, MIString_ComingValueDayUser.ValueData) AS ValueUser29,
         lpDecodeValueDay(30, MIString_ComingValueDayUser.ValueData) AS ValueUser30,
         lpDecodeValueDay(31, MIString_ComingValueDayUser.ValueData) AS ValueUser31,
         1                                                       AS TypeId1,
         2                                                       AS TypeId2,
         3                                                       AS TypeId3,
         4                                                       AS TypeId4,
         5                                                       AS TypeId5,
         6                                                       AS TypeId6,
         7                                                       AS TypeId7,
         8                                                       AS TypeId8,
         9                                                       AS TypeId9,
         10                                                      AS TypeId10,
         11                                                      AS TypeId11,
         12                                                      AS TypeId12,
         13                                                      AS TypeId13,
         14                                                      AS TypeId14,
         15                                                      AS TypeId15,
         16                                                      AS TypeId16,
         17                                                      AS TypeId17,
         18                                                      AS TypeId18,
         19                                                      AS TypeId19,
         20                                                      AS TypeId20,
         21                                                      AS TypeId21,
         22                                                      AS TypeId22,
         23                                                      AS TypeId23,
         24                                                      AS TypeId24,
         25                                                      AS TypeId25,
         26                                                      AS TypeId26,
         27                                                      AS TypeId27,
         28                                                      AS TypeId28,
         29                                                      AS TypeId29,
         30                                                      AS TypeId30,
         31                                                      AS TypeId31,
         CASE WHEN COALESCE(tmpUnserUnit.D1, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 1, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 1, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc1,
         CASE WHEN COALESCE(tmpUnserUnit.D2, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 2 AND SUBSTRING(MIString_ComingValueDay.ValueData, 2, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 2, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc2,
         CASE WHEN COALESCE(tmpUnserUnit.D3, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 3 AND SUBSTRING(MIString_ComingValueDay.ValueData, 3, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 3, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc3,
         CASE WHEN COALESCE(tmpUnserUnit.D4, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 4 AND SUBSTRING(MIString_ComingValueDay.ValueData, 4, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 4, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc4,
         CASE WHEN COALESCE(tmpUnserUnit.D5, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 5 AND SUBSTRING(MIString_ComingValueDay.ValueData, 5, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 5, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc5,
         CASE WHEN COALESCE(tmpUnserUnit.D6, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 6 AND SUBSTRING(MIString_ComingValueDay.ValueData, 6, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 6, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc6,
         CASE WHEN COALESCE(tmpUnserUnit.D7, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 7 AND SUBSTRING(MIString_ComingValueDay.ValueData, 7, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 7, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc7,
         CASE WHEN COALESCE(tmpUnserUnit.D8, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 8 AND SUBSTRING(MIString_ComingValueDay.ValueData, 8, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 8, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc8,
         CASE WHEN COALESCE(tmpUnserUnit.D9, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 9 AND SUBSTRING(MIString_ComingValueDay.ValueData, 9, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 9, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc9,
         CASE WHEN COALESCE(tmpUnserUnit.D10, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 10 AND SUBSTRING(MIString_ComingValueDay.ValueData, 10, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 10, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc10,
         CASE WHEN COALESCE(tmpUnserUnit.D11, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 11 AND SUBSTRING(MIString_ComingValueDay.ValueData, 11, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 11, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc11,
         CASE WHEN COALESCE(tmpUnserUnit.D12, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 12 AND SUBSTRING(MIString_ComingValueDay.ValueData, 12, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 12, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc12,
         CASE WHEN COALESCE(tmpUnserUnit.D13, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 13 AND SUBSTRING(MIString_ComingValueDay.ValueData, 13, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 13, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc13,
         CASE WHEN COALESCE(tmpUnserUnit.D14, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 14 AND SUBSTRING(MIString_ComingValueDay.ValueData, 14, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 14, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc14,
         CASE WHEN COALESCE(tmpUnserUnit.D15, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 15 AND SUBSTRING(MIString_ComingValueDay.ValueData, 15, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 15, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc15,
         CASE WHEN COALESCE(tmpUnserUnit.D16, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 16 AND SUBSTRING(MIString_ComingValueDay.ValueData, 16, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 16, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc16,
         CASE WHEN COALESCE(tmpUnserUnit.D17, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 17 AND SUBSTRING(MIString_ComingValueDay.ValueData, 17, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 17, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc17,
         CASE WHEN COALESCE(tmpUnserUnit.D18, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 18 AND SUBSTRING(MIString_ComingValueDay.ValueData, 18, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 18, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc18,
         CASE WHEN COALESCE(tmpUnserUnit.D19, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 19 AND SUBSTRING(MIString_ComingValueDay.ValueData, 19, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 19, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc19,
         CASE WHEN COALESCE(tmpUnserUnit.D20, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 20 AND SUBSTRING(MIString_ComingValueDay.ValueData, 20, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 20, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc20,
         CASE WHEN COALESCE(tmpUnserUnit.D21, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 21 AND SUBSTRING(MIString_ComingValueDay.ValueData, 21, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 21, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc21,
         CASE WHEN COALESCE(tmpUnserUnit.D22, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 22 AND SUBSTRING(MIString_ComingValueDay.ValueData, 22, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 22, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc22,
         CASE WHEN COALESCE(tmpUnserUnit.D23, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 23 AND SUBSTRING(MIString_ComingValueDay.ValueData, 23, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 23, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc23,
         CASE WHEN COALESCE(tmpUnserUnit.D24, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 24 AND SUBSTRING(MIString_ComingValueDay.ValueData, 24, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 24, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc24,
         CASE WHEN COALESCE(tmpUnserUnit.D25, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 25 AND SUBSTRING(MIString_ComingValueDay.ValueData, 25, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 25, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc25,
         CASE WHEN COALESCE(tmpUnserUnit.D26, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 26 AND SUBSTRING(MIString_ComingValueDay.ValueData, 26, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 26, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc26,
         CASE WHEN COALESCE(tmpUnserUnit.D27, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 27 AND SUBSTRING(MIString_ComingValueDay.ValueData, 27, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 27, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc27,
         CASE WHEN COALESCE(tmpUnserUnit.D28, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 28 AND SUBSTRING(MIString_ComingValueDay.ValueData, 28, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 28, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc28,
         CASE WHEN COALESCE(tmpUnserUnit.D29, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 29 AND SUBSTRING(MIString_ComingValueDay.ValueData, 29, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 29, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc29,
         CASE WHEN COALESCE(tmpUnserUnit.D30, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 30 AND SUBSTRING(MIString_ComingValueDay.ValueData, 30, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 30, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc30,
         CASE WHEN COALESCE(tmpUnserUnit.D31, False) = FALSE THEN zc_Color_White() ELSE
           CASE WHEN vbCurrDay >= 31 AND SUBSTRING(MIString_ComingValueDay.ValueData, 31, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 31, 1) THEN zc_Color_Red() ELSE zc_Color_Yelow() END END AS Color_Calc31
       FROM Movement

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                   AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN tmpUnserUnit ON tmpUnserUnit.UserId = MovementItem.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId

            LEFT JOIN tmPersonal_View AS Personal_View ON Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE(tmpUnserUnit.UnitID, Personal_View.UnitID)

            INNER JOIN MovementItemString AS MIString_ComingValueDay
                                          ON MIString_ComingValueDay.DescId = zc_MIString_ComingValueDay()
                                         AND MIString_ComingValueDay.MovementItemId = MovementItem.Id

            LEFT JOIN MovementItemString AS MIString_ComingValueDayUser
                                         ON MIString_ComingValueDayUser.DescId = zc_MIString_ComingValueDayUser()
                                        AND MIString_ComingValueDayUser.MovementItemId = MovementItem.Id

            LEFT JOIN MovementItem AS MovementItemPrev
                                   ON MovementItemPrev.MovementId = vbMovementId
                                  AND MovementItemPrev.ObjectId = MovementItem.ObjectId
                                  AND MovementItemPrev.DescId = zc_MI_Master()

            LEFT JOIN MovementItemString AS MIString_ComingValueDayPrev
                                         ON MIString_ComingValueDayPrev.DescId = zc_MIString_ComingValueDay()
                                        AND MIString_ComingValueDayPrev.MovementItemId = MovementItemPrev.Id
       WHERE Movement.ID = inMovementId
         AND (MovementItem.IsErased = FALSE OR inIsErased = TRUE);
     END IF;

     RETURN NEXT cur3;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_EmployeeSchedule (Integer, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.03.19                                                       *
 08.12.18                                                       *
*/

-- тест
-- select * from gpSelect_MovementItem_EmployeeSchedule(inMovementId := 13211961 , inDate := ('01.02.2019')::TDateTime , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');