-- Function: gpSelect_MovementItem_EmployeeSchedule_Unit()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_EmployeeSchedule_Unit(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_EmployeeSchedule_Unit(
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbMovementId Integer;
  DECLARE vbMovementNextId Integer;

  DECLARE cur1 refcursor;
  DECLARE cur2 refcursor;
  DECLARE cur3 refcursor;
  DECLARE cur4 refcursor;

  DECLARE vbCurrDay Integer;
  DECLARE vbDate TDateTime;
  DECLARE vbDateNext TDateTime;
  DECLARE i Integer;
  DECLARE vbQueryText Text;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;
     vbUnitId := vbUnitKey::Integer;

     vbDate := DATE_TRUNC ('MONTH', CURRENT_DATE);
     vbDateNext := DATE_TRUNC ('MONTH', vbDate) + INTERVAL '1 MONTH';

     -- проверка наличия графика
     IF NOT EXISTS(SELECT 1 FROM Movement
                   WHERE Movement.OperDate = vbDate
                     AND Movement.DescId = zc_Movement_EmployeeSchedule())
     THEN
       RAISE EXCEPTION 'Ошибка. График работы сотрудеиков не найден. Обратитесь к Романовой Т.В.';
     END IF;

     SELECT Movement.ID
     INTO vbMovementId
     FROM Movement
     WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
       AND Movement.OperDate = vbDate;


     IF EXISTS(SELECT 1 FROM Movement
                   WHERE Movement.OperDate = vbDateNext
                     AND Movement.DescId = zc_Movement_EmployeeSchedule())
     THEN
       SELECT Movement.ID
       INTO vbMovementNextId
       FROM Movement
       WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
         AND Movement.OperDate = vbDateNext;
     ELSE
       vbMovementNextId := 0;
     END IF;


     -- Получение главных аптек
     CREATE TEMP TABLE tmpMainUnit (UserId Integer, MovementItemID integer, MovementItemNextID integer, Value TVarChar, ValueUser TVarChar, ValueNext TVarChar) ON COMMIT DROP;

     WITH tmMov AS (SELECT DISTINCT
                           MovementItem.ObjectId AS UserID
                    FROM Movement

                         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId = zc_MI_Master()

                         INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                            ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                           AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                           AND MILinkObject_Unit.ObjectId = vbUnitId

                    WHERE Movement.ID in (vbMovementId, vbMovementNextId)),

          tmLogAll AS (SELECT count(*) as CountLog
                            , EmployeeWorkLog.UserId
                            , EmployeeWorkLog.UnitId
                       FROM EmployeeWorkLog
                       WHERE EmployeeWorkLog.DateLogIn >= CURRENT_DATE - INTERVAL '1 MONTH' AND EmployeeWorkLog.DateLogIn < CURRENT_DATE
                       GROUP BY EmployeeWorkLog.UserId, EmployeeWorkLog.UnitId),

          tmLog AS (SELECT ROW_NUMBER() OVER (PARTITION BY tmLogAll.UserId ORDER BY tmLogAll.CountLog DESC) AS Ord
                         , tmLogAll.UserId
                         , tmLogAll.UnitId
                    FROM tmLogAll),

          tmAll AS (SELECT tmMov.UserID FROM tmMov
                    UNION ALL
                    SELECT tmLog.UserID FROM tmLog
                    WHERE tmLog.Ord = 1
                      AND tmLog.UnitId = vbUnitId)


     INSERT INTO tmpMainUnit (UserId)
     SELECT DISTINCT tmAll.UserID FROM tmAll;

     UPDATE tmpMainUnit SET MovementItemID = T1.ID
                          , Value = T1.Value
                          , ValueUser = T1.ValueUser
     FROM (SELECT MovementItem.ObjectId                       AS UserID
                , MovementItem.Id                             AS ID
                , MIString_ComingValueDay.ValueData           AS Value
                , MIString_ComingValueDayUser.ValueData       AS ValueUser
           FROM Movement

                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                       AND MovementItem.DescId = zc_MI_Master()

                INNER JOIN MovementItemString AS MIString_ComingValueDay
                                              ON MIString_ComingValueDay.DescId = zc_MIString_ComingValueDay()
                                             AND MIString_ComingValueDay.MovementItemId = MovementItem.Id

                LEFT JOIN MovementItemString AS MIString_ComingValueDayUser
                                             ON MIString_ComingValueDayUser.DescId = zc_MIString_ComingValueDayUser()
                                            AND MIString_ComingValueDayUser.MovementItemId = MovementItem.Id

           WHERE Movement.ID = vbMovementId) AS T1
     WHERE tmpMainUnit.UserID = T1.UserID;

     UPDATE tmpMainUnit SET MovementItemNextID = T1.ID
                          , ValueNext = T1.ValueNext
     FROM (SELECT MovementItem.ObjectId                       AS UserID
                , MovementItem.Id                             AS ID
                , MIString_ComingValueDay.ValueData           AS ValueNext
           FROM Movement

                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                       AND MovementItem.DescId = zc_MI_Master()

                INNER JOIN MovementItemString AS MIString_ComingValueDay
                                              ON MIString_ComingValueDay.DescId = zc_MIString_ComingValueDay()
                                             AND MIString_ComingValueDay.MovementItemId = MovementItem.Id

           WHERE Movement.ID = vbMovementNextId) AS T1
     WHERE tmpMainUnit.UserID = T1.UserID;

     DELETE FROM tmpMainUnit WHERE MovementItemID IS Null and MovementItemNextID IS NULL;

     -- Получение главных аптек для отображения подмен
     CREATE TEMP TABLE tmpMainUnitSubstitution (UserId Integer,
               Value1 TVarChar, Value2 TVarChar, Value3 TVarChar, Value4 TVarChar, Value5 TVarChar,
               Value6 TVarChar, Value7 TVarChar, Value8 TVarChar, Value9 TVarChar, Value10 TVarChar,
               Value11 TVarChar, Value12 TVarChar, Value13 TVarChar, Value14 TVarChar, Value15 TVarChar,
               Value16 TVarChar, Value17 TVarChar, Value18 TVarChar, Value19 TVarChar, Value20 TVarChar,
               Value21 TVarChar, Value22 TVarChar, Value23 TVarChar, Value24 TVarChar, Value25 TVarChar,
               Value26 TVarChar, Value27 TVarChar, Value28 TVarChar, Value29 TVarChar, Value30 TVarChar,
               Value31 TVarChar,
               ValueNext1 TVarChar, ValueNext2 TVarChar, ValueNext3 TVarChar, ValueNext4 TVarChar, ValueNext5 TVarChar,
               ValueNext6 TVarChar, ValueNext7 TVarChar, ValueNext8 TVarChar, ValueNext9 TVarChar, ValueNext10 TVarChar,
               ValueNext11 TVarChar, ValueNext12 TVarChar, ValueNext13 TVarChar, ValueNext14 TVarChar, ValueNext15 TVarChar,
               ValueNext16 TVarChar, ValueNext17 TVarChar, ValueNext18 TVarChar, ValueNext19 TVarChar, ValueNext20 TVarChar,
               ValueNext21 TVarChar, ValueNext22 TVarChar, ValueNext23 TVarChar, ValueNext24 TVarChar, ValueNext25 TVarChar,
               ValueNext26 TVarChar, ValueNext27 TVarChar, ValueNext28 TVarChar, ValueNext29 TVarChar, ValueNext30 TVarChar,
               ValueNext31 TVarChar) ON COMMIT DROP;

     -- Все подмены на аптеку
     WITH tmpUnitChild AS (SELECT DISTINCT
                                  MovementItemMain.ObjectId                                                                  AS UserId
                             FROM MovementItem AS MovementItemChild

                                  INNER JOIN MovementItem AS MovementItemMain
                                                          ON MovementItemMain.ID = MovementItemChild.ParentId

                             WHERE MovementItemChild.MovementId in (vbMovementId, vbMovementNextId)
                               AND MovementItemChild.DescId = zc_MI_Child()
                               AND MovementItemChild.ObjectId = vbUnitId)

     INSERT INTO tmpMainUnitSubstitution (UserId)
     SELECT tmpUnitChild.UserId
     FROM tmpUnitChild
     WHERE tmpUnitChild.UserId NOT IN (SELECT tmpMainUnit.UserId FROM tmpMainUnit);

     I := 1;
     WHILE I <= date_part('DAY', vbDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
     LOOP

       vbQueryText := 'UPDATE tmpMainUnitSubstitution SET Value'||I::Text||' = MI_Child.Value
                       FROM (SELECT
                                    MovementItem.ObjectId                                               AS UserId
                                  , lpDecodeValueDay('||I::Text||', MIString_ComingValueDay.ValueData)  AS Value
                             FROM MovementItem

                                  INNER JOIN MovementItem AS MovementItemChild
                                                          ON MovementItemChild.MovementId = '||vbMovementId::Text||'
                                                         AND MovementItemChild.Amount = '||I::Text||'
                                                         AND MovementItemChild.DescId = zc_MI_Child()
                                                         AND MovementItemChild.ObjectId = '||vbUnitID::Text||'
                                                         AND MovementItemChild.ParentId = MovementItem.ID

                                  INNER JOIN MovementItemString AS MIString_ComingValueDay
                                                                ON MIString_ComingValueDay.DescId = zc_MIString_ComingValueDay()
                                                               AND MIString_ComingValueDay.MovementItemId = MovementItem.Id

                             WHERE MovementItem.MovementId = '||vbMovementId::Text||'
                               AND MovementItem.DescId = zc_MI_Master()) AS MI_Child
                       WHERE tmpMainUnitSubstitution.UserId = MI_Child.UserId';

       EXECUTE vbQueryText;

       vbQueryText := 'UPDATE tmpMainUnit SET Value = SUBSTRING(Value, 1, '||I::Text||' - 1) ||''0''|| SUBSTRING(Value, '||I::Text||' + 1, 31),
                                              ValueUser = SUBSTRING(ValueUser, 1, '||I::Text||' - 1) ||''0''|| SUBSTRING(ValueUser, '||I::Text||' + 1, 31)
                       FROM (SELECT
                                    MovementItem.ObjectId                                               AS UserId
                             FROM MovementItem

                                  INNER JOIN MovementItem AS MovementItemChild
                                                          ON MovementItemChild.MovementId = '||vbMovementId::Text||'
                                                         AND MovementItemChild.Amount = '||I::Text||'
                                                         AND MovementItemChild.DescId = zc_MI_Child()
                                                         AND MovementItemChild.ObjectId <> '||vbUnitID::Text||'
                                                         AND MovementItemChild.ParentId = MovementItem.ID

                             WHERE MovementItem.MovementId = '||vbMovementId::Text||'
                               AND MovementItem.DescId = zc_MI_Master()) AS MI_Child
                       WHERE tmpMainUnit.UserId = MI_Child.UserId';

       EXECUTE vbQueryText;
       I := I + 1;
     END LOOP;

     I := 1;
     WHILE I <= date_part('DAY', vbDateNext + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
     LOOP

       vbQueryText := 'UPDATE tmpMainUnitSubstitution SET ValueNext'||I::Text||' = MI_Child.Value
                       FROM (SELECT
                                    MovementItem.ObjectId                                               AS UserId
                                  , lpDecodeValueDay('||I::Text||', MIString_ComingValueDay.ValueData)  AS Value
                             FROM MovementItem

                                  INNER JOIN MovementItem AS MovementItemChild
                                                          ON MovementItemChild.MovementId = '||vbMovementNextId::Text||'
                                                         AND MovementItemChild.Amount = '||I::Text||'
                                                         AND MovementItemChild.DescId = zc_MI_Child()
                                                         AND MovementItemChild.ObjectId = '||vbUnitID::Text||'
                                                         AND MovementItemChild.ParentId = MovementItem.ID

                                  INNER JOIN MovementItemString AS MIString_ComingValueDay
                                                                ON MIString_ComingValueDay.DescId = zc_MIString_ComingValueDay()
                                                               AND MIString_ComingValueDay.MovementItemId = MovementItem.Id

                             WHERE MovementItem.MovementId = '||vbMovementNextId::Text||'
                               AND MovementItem.DescId = zc_MI_Master()) AS MI_Child
                       WHERE tmpMainUnitSubstitution.UserId = MI_Child.UserId';

       EXECUTE vbQueryText;

       vbQueryText := 'UPDATE tmpMainUnit SET ValueNext = SUBSTRING(ValueNext, 1, '||I::Text||' - 1) ||''0''|| SUBSTRING(ValueNext, '||I::Text||' + 1, 31)
                       FROM (SELECT
                                    MovementItem.ObjectId                                               AS UserId
                             FROM MovementItem

                                  INNER JOIN MovementItem AS MovementItemChild
                                                          ON MovementItemChild.MovementId = '||vbMovementNextId::Text||'
                                                         AND MovementItemChild.Amount = '||I::Text||'
                                                         AND MovementItemChild.DescId = zc_MI_Child()
                                                         AND MovementItemChild.ObjectId <> '||vbUnitID::Text||'
                                                         AND MovementItemChild.ParentId = MovementItem.ID

                             WHERE MovementItem.MovementId = '||vbMovementNextId::Text||'
                               AND MovementItem.DescId = zc_MI_Master()) AS MI_Child
                       WHERE tmpMainUnit.UserId = MI_Child.UserId';

       EXECUTE vbQueryText;
       I := I + 1;
     END LOOP;

     --
     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
        SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', vbDate), DATE_TRUNC ('MONTH', vbDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;

     vbDate := DATE_TRUNC ('MONTH', vbDate) + INTERVAL '1 MONTH';

     CREATE TEMP TABLE tmpOperDateNext ON COMMIT DROP AS
        SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', vbDate), DATE_TRUNC ('MONTH', vbDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;

     IF (SELECT count(*) FROM tmpOperDateNext) <> (SELECT count(*) FROM tmpOperDate)
     THEN
       WHILE (SELECT count(*) FROM tmpOperDateNext) <> (SELECT count(*) FROM tmpOperDate)
       LOOP
         IF (SELECT count(*) FROM tmpOperDateNext) > (SELECT count(*) FROM tmpOperDate)
         THEN
           INSERT INTO tmpOperDate (OperDate) VALUES (NULL);
         ELSE
           INSERT INTO tmpOperDateNext (OperDate) VALUES (NULL);
         END IF;
       END LOOP;
     END IF;

     -- возвращаем заголовки столбцов и даты
     OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime,
                          ((EXTRACT(DAY FROM tmpOperDate.OperDate))||case when tmpCalendar.Working = False then ' *' else ' ' END||tmpWeekDay.DayOfWeekName) ::TVarChar AS ValueField
                        , ''::TVarChar AS ValueFieldUser
               FROM tmpOperDate
                   LEFT JOIN zfCalc_DayOfWeekName (tmpOperDate.OperDate) AS tmpWeekDay ON 1=1
                   LEFT JOIN gpSelect_Object_Calendar(tmpOperDate.OperDate,tmpOperDate.OperDate,inSession) tmpCalendar ON 1=1

      ;
     RETURN NEXT cur1;

     -- возвращаем заголовки столбцов и даты для следующего месяца
     OPEN cur2 FOR SELECT tmpOperDateNext.OperDate::TDateTime,
                          ((EXTRACT(DAY FROM tmpOperDateNext.OperDate))||case when tmpCalendar.Working = False then ' *' else ' ' END||tmpWeekDay.DayOfWeekName) ::TVarChar AS ValueField
               FROM tmpOperDateNext
                   LEFT JOIN zfCalc_DayOfWeekName (tmpOperDateNext.OperDate) AS tmpWeekDay ON 1=1
                   LEFT JOIN gpSelect_Object_Calendar(tmpOperDateNext.OperDate,tmpOperDateNext.OperDate,inSession) tmpCalendar ON 1=1

      ;
     RETURN NEXT cur2;

     OPEN cur3 FOR
     SELECT
       Object_Member.Id                                        AS ID,
       Object_Member.ObjectCode                                AS PersonalCode,
       Object_Member.ValueData                                 AS PersonalName,
       'Регламент '||zfCalc_MonthName(CURRENT_DATE)            AS Note,
       'Факт '||zfCalc_MonthName(CURRENT_DATE)                 AS NoteUser,
       'Регламент '||zfCalc_MonthName(vbDate)                  AS NoteNext,
       lpDecodeValueDay(1, tmpMainUnit.Value)  AS Value1,
       lpDecodeValueDay(2, tmpMainUnit.Value)  AS Value2,
       lpDecodeValueDay(3, tmpMainUnit.Value)  AS Value3,
       lpDecodeValueDay(4, tmpMainUnit.Value)  AS Value4,
       lpDecodeValueDay(5, tmpMainUnit.Value)  AS Value5,
       lpDecodeValueDay(6, tmpMainUnit.Value)  AS Value6,
       lpDecodeValueDay(7, tmpMainUnit.Value)  AS Value7,
       lpDecodeValueDay(8, tmpMainUnit.Value)  AS Value8,
       lpDecodeValueDay(9, tmpMainUnit.Value)  AS Value9,
       lpDecodeValueDay(10, tmpMainUnit.Value) AS Value10,
       lpDecodeValueDay(11, tmpMainUnit.Value) AS Value11,
       lpDecodeValueDay(12, tmpMainUnit.Value) AS Value12,
       lpDecodeValueDay(13, tmpMainUnit.Value) AS Value13,
       lpDecodeValueDay(14, tmpMainUnit.Value) AS Value14,
       lpDecodeValueDay(15, tmpMainUnit.Value) AS Value15,
       lpDecodeValueDay(16, tmpMainUnit.Value) AS Value16,
       lpDecodeValueDay(17, tmpMainUnit.Value) AS Value17,
       lpDecodeValueDay(18, tmpMainUnit.Value) AS Value18,
       lpDecodeValueDay(19, tmpMainUnit.Value) AS Value19,
       lpDecodeValueDay(20, tmpMainUnit.Value) AS Value20,
       lpDecodeValueDay(21, tmpMainUnit.Value) AS Value21,
       lpDecodeValueDay(22, tmpMainUnit.Value) AS Value22,
       lpDecodeValueDay(23, tmpMainUnit.Value) AS Value23,
       lpDecodeValueDay(24, tmpMainUnit.Value) AS Value24,
       lpDecodeValueDay(25, tmpMainUnit.Value) AS Value25,
       lpDecodeValueDay(26, tmpMainUnit.Value) AS Value26,
       lpDecodeValueDay(27, tmpMainUnit.Value) AS Value27,
       lpDecodeValueDay(28, tmpMainUnit.Value) AS Value28,
       lpDecodeValueDay(29, tmpMainUnit.Value) AS Value29,
       lpDecodeValueDay(30, tmpMainUnit.Value) AS Value30,
       lpDecodeValueDay(31, tmpMainUnit.Value) AS Value31,
       lpDecodeValueDay(1, tmpMainUnit.ValueUser)  AS ValueUser1,
       lpDecodeValueDay(2, tmpMainUnit.ValueUser)  AS ValueUser2,
       lpDecodeValueDay(3, tmpMainUnit.ValueUser)  AS ValueUser3,
       lpDecodeValueDay(4, tmpMainUnit.ValueUser)  AS ValueUser4,
       lpDecodeValueDay(5, tmpMainUnit.ValueUser)  AS ValueUser5,
       lpDecodeValueDay(6, tmpMainUnit.ValueUser)  AS ValueUser6,
       lpDecodeValueDay(7, tmpMainUnit.ValueUser)  AS ValueUser7,
       lpDecodeValueDay(8, tmpMainUnit.ValueUser)  AS ValueUser8,
       lpDecodeValueDay(9, tmpMainUnit.ValueUser)  AS ValueUser9,
       lpDecodeValueDay(10, tmpMainUnit.ValueUser) AS ValueUser10,
       lpDecodeValueDay(11, tmpMainUnit.ValueUser) AS ValueUser11,
       lpDecodeValueDay(12, tmpMainUnit.ValueUser) AS ValueUser12,
       lpDecodeValueDay(13, tmpMainUnit.ValueUser) AS ValueUser13,
       lpDecodeValueDay(14, tmpMainUnit.ValueUser) AS ValueUser14,
       lpDecodeValueDay(15, tmpMainUnit.ValueUser) AS ValueUser15,
       lpDecodeValueDay(16, tmpMainUnit.ValueUser) AS ValueUser16,
       lpDecodeValueDay(17, tmpMainUnit.ValueUser) AS ValueUser17,
       lpDecodeValueDay(18, tmpMainUnit.ValueUser) AS ValueUser18,
       lpDecodeValueDay(19, tmpMainUnit.ValueUser) AS ValueUser19,
       lpDecodeValueDay(20, tmpMainUnit.ValueUser) AS ValueUser20,
       lpDecodeValueDay(21, tmpMainUnit.ValueUser) AS ValueUser21,
       lpDecodeValueDay(22, tmpMainUnit.ValueUser) AS ValueUser22,
       lpDecodeValueDay(23, tmpMainUnit.ValueUser) AS ValueUser23,
       lpDecodeValueDay(24, tmpMainUnit.ValueUser) AS ValueUser24,
       lpDecodeValueDay(25, tmpMainUnit.ValueUser) AS ValueUser25,
       lpDecodeValueDay(26, tmpMainUnit.ValueUser) AS ValueUser26,
       lpDecodeValueDay(27, tmpMainUnit.ValueUser) AS ValueUser27,
       lpDecodeValueDay(28, tmpMainUnit.ValueUser) AS ValueUser28,
       lpDecodeValueDay(29, tmpMainUnit.ValueUser) AS ValueUser29,
       lpDecodeValueDay(30, tmpMainUnit.ValueUser) AS ValueUser30,
       lpDecodeValueDay(31, tmpMainUnit.ValueUser) AS ValueUser31,
       lpDecodeValueDay(1, tmpMainUnit.ValueNext)  AS ValueNext1,
       lpDecodeValueDay(2, tmpMainUnit.ValueNext)  AS ValueNext2,
       lpDecodeValueDay(3, tmpMainUnit.ValueNext)  AS ValueNext3,
       lpDecodeValueDay(4, tmpMainUnit.ValueNext)  AS ValueNext4,
       lpDecodeValueDay(5, tmpMainUnit.ValueNext)  AS ValueNext5,
       lpDecodeValueDay(6, tmpMainUnit.ValueNext)  AS ValueNext6,
       lpDecodeValueDay(7, tmpMainUnit.ValueNext)  AS ValueNext7,
       lpDecodeValueDay(8, tmpMainUnit.ValueNext)  AS ValueNext8,
       lpDecodeValueDay(9, tmpMainUnit.ValueNext)  AS ValueNext9,
       lpDecodeValueDay(10, tmpMainUnit.ValueNext) AS ValueNext10,
       lpDecodeValueDay(11, tmpMainUnit.ValueNext) AS ValueNext11,
       lpDecodeValueDay(12, tmpMainUnit.ValueNext) AS ValueNext12,
       lpDecodeValueDay(13, tmpMainUnit.ValueNext) AS ValueNext13,
       lpDecodeValueDay(14, tmpMainUnit.ValueNext) AS ValueNext14,
       lpDecodeValueDay(15, tmpMainUnit.ValueNext) AS ValueNext15,
       lpDecodeValueDay(16, tmpMainUnit.ValueNext) AS ValueNext16,
       lpDecodeValueDay(17, tmpMainUnit.ValueNext) AS ValueNext17,
       lpDecodeValueDay(18, tmpMainUnit.ValueNext) AS ValueNext18,
       lpDecodeValueDay(19, tmpMainUnit.ValueNext) AS ValueNext19,
       lpDecodeValueDay(20, tmpMainUnit.ValueNext) AS ValueNext20,
       lpDecodeValueDay(21, tmpMainUnit.ValueNext) AS ValueNext21,
       lpDecodeValueDay(22, tmpMainUnit.ValueNext) AS ValueNext22,
       lpDecodeValueDay(23, tmpMainUnit.ValueNext) AS ValueNext23,
       lpDecodeValueDay(24, tmpMainUnit.ValueNext) AS ValueNext24,
       lpDecodeValueDay(25, tmpMainUnit.ValueNext) AS ValueNext25,
       lpDecodeValueDay(26, tmpMainUnit.ValueNext) AS ValueNext26,
       lpDecodeValueDay(27, tmpMainUnit.ValueNext) AS ValueNext27,
       lpDecodeValueDay(28, tmpMainUnit.ValueNext) AS ValueNext28,
       lpDecodeValueDay(29, tmpMainUnit.ValueNext) AS ValueNext29,
       lpDecodeValueDay(30, tmpMainUnit.ValueNext) AS ValueNext30,
       lpDecodeValueDay(31, tmpMainUnit.ValueNext) AS ValueNext31,
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
       31                                                      AS TypeId31
     FROM tmpMainUnit

          LEFT JOIN ObjectLink AS ObjectLink_User_Member
                               ON ObjectLink_User_Member.ObjectId = tmpMainUnit.UserId
                              AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
          LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId

     ORDER BY ID;

     RETURN NEXT cur3;

     OPEN cur4 FOR
     SELECT
       Object_Member.Id                                        AS ID,
       Object_Member.ObjectCode                                AS PersonalCode,
       Object_Member.ValueData                                 AS PersonalName,

       zfCalc_MonthName(CURRENT_DATE)                          AS Note,
       zfCalc_MonthName(vbDate)                                AS NoteNext,

       Value1,
       Value2,
       Value3,
       Value4,
       Value5,
       Value6,
       Value7,
       Value8,
       Value9,
       Value10,
       Value11,
       Value12,
       Value13,
       Value14,
       Value15,
       Value16,
       Value17,
       Value18,
       Value19,
       Value20,
       Value21,
       Value22,
       Value23,
       Value24,
       Value25,
       Value26,
       Value27,
       Value28,
       Value29,
       Value30,
       Value31,
       ValueNext1,
       ValueNext2,
       ValueNext3,
       ValueNext4,
       ValueNext5,
       ValueNext6,
       ValueNext7,
       ValueNext8,
       ValueNext9,
       ValueNext10,
       ValueNext11,
       ValueNext12,
       ValueNext13,
       ValueNext14,
       ValueNext15,
       ValueNext16,
       ValueNext17,
       ValueNext18,
       ValueNext19,
       ValueNext20,
       ValueNext21,
       ValueNext22,
       ValueNext23,
       ValueNext24,
       ValueNext25,
       ValueNext26,
       ValueNext27,
       ValueNext28,
       ValueNext29,
       ValueNext30,
       ValueNext31,
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
       31                                                      AS TypeId31
     FROM tmpMainUnitSubstitution

          LEFT JOIN ObjectLink AS ObjectLink_User_Member
                               ON ObjectLink_User_Member.ObjectId = tmpMainUnitSubstitution.UserId
                              AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
          LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId;

     RETURN NEXT cur4;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_EmployeeSchedule_User (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.03.19                                                       *
*/

-- тест
-- select * from gpSelect_MovementItem_EmployeeSchedule_Unit( inSession := '3');