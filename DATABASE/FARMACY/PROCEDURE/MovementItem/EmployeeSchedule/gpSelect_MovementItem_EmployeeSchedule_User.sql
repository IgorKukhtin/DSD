-- Function: gpSelect_MovementItem_EmployeeSchedule_User()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_EmployeeSchedule_User(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_EmployeeSchedule_User(
    IN inSession     TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbMovementId Integer;

  DECLARE cur1 refcursor;
  DECLARE cur2 refcursor;
  DECLARE cur3 refcursor;
  DECLARE cur4 refcursor;

  DECLARE vbCurrDay Integer;
  DECLARE vbDate TDateTime;
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

     -- Получение главных аптек
     CREATE TEMP TABLE tmpMainUnit (ID integer, MovementItemID integer, UnitId Integer) ON COMMIT DROP;

     INSERT INTO tmpMainUnit (ID, MovementItemID, UnitId)
     SELECT 1, MovementItem.Id, MILinkObject_Unit.ObjectId
     FROM Movement

          LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                AND MovementItem.DescId = zc_MI_Master()
                                AND MovementItem.ObjectId = vbUserId

          LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                           ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

     WHERE Movement.OperDate = vbDate
          AND Movement.DescId = zc_Movement_EmployeeSchedule();


     IF (SELECT UnitId FROM tmpMainUnit WHERE ID = 1) IS NULL
     THEN
       WITH tmLogAll AS (SELECT count(*) as CountLog
                              , EmployeeWorkLog.UnitId
                         FROM EmployeeWorkLog
                         WHERE EmployeeWorkLog.DateLogIn >= vbDate AND EmployeeWorkLog.DateLogIn < CURRENT_DATE
                           AND EmployeeWorkLog.UserId = vbUserId
                         GROUP BY EmployeeWorkLog.UnitId),

            tmLog AS (SELECT ROW_NUMBER() OVER (ORDER BY tmLogAll.CountLog DESC) AS Ord
                           , tmLogAll.UnitId
                      FROM tmLogAll)

       UPDATE tmpMainUnit SET UnitId = COALESCE((SELECT tmLog.UnitId FROM tmLog WHERE tmLog.Ord = 1), vbUnitId) WHERE ID = 1;
     END IF;

     -- Получение главных аптек для отображения подмен
     CREATE TEMP TABLE tmpMainUnitSubstitution (ID integer, MovementItemID integer, UnitId Integer,
               UnitID1 Integer, UnitID2 Integer, UnitID3 Integer, UnitID4 Integer, UnitID5 Integer,
               UnitID6 Integer, UnitID7 Integer, UnitID8 Integer, UnitID9 Integer, UnitID10 Integer,
               UnitID11 Integer, UnitID12 Integer, UnitID13 Integer, UnitID14 Integer, UnitID15 Integer,
               UnitID16 Integer, UnitID17 Integer, UnitID18 Integer, UnitID19 Integer, UnitID20 Integer,
               UnitID21 Integer, UnitID22 Integer, UnitID23 Integer, UnitID24 Integer, UnitID25 Integer,
               UnitID26 Integer, UnitID27 Integer, UnitID28 Integer, UnitID29 Integer, UnitID30 Integer,
               UnitID31 Integer) ON COMMIT DROP;

     INSERT INTO tmpMainUnitSubstitution (ID, MovementItemID, UnitId)
     SELECT 1, MovementItem.Id, MILinkObject_Unit.ObjectId
     FROM Movement
          LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                AND MovementItem.DescId = zc_MI_Master()
                                AND MovementItem.ObjectId = vbUserId

          LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                           ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

     WHERE Movement.OperDate = vbDate
          AND Movement.DescId = zc_Movement_EmployeeSchedule();

     IF (SELECT UnitId FROM tmpMainUnitSubstitution WHERE ID = 1) IS NULL
     THEN
       WITH tmLogAll AS (SELECT count(*) as CountLog
                              , EmployeeWorkLog.UnitId
                         FROM EmployeeWorkLog
                         WHERE EmployeeWorkLog.DateLogIn >= vbDate AND EmployeeWorkLog.DateLogIn < CURRENT_DATE
                           AND EmployeeWorkLog.UserId = vbUserId
                         GROUP BY EmployeeWorkLog.UnitId),

            tmLog AS (SELECT ROW_NUMBER() OVER (ORDER BY tmLogAll.CountLog DESC) AS Ord
                           , tmLogAll.UnitId
                      FROM tmLogAll)

       UPDATE tmpMainUnitSubstitution SET UnitId = COALESCE((SELECT tmLog.UnitId FROM tmLog WHERE tmLog.Ord = 1), vbUnitId) WHERE ID = 1;
     END IF;

     WITH tmpUnitChild AS (SELECT DISTINCT
                                  MovementItemChild.ParentId        AS MovementItemID
                                , MovementItemChild.ObjectId        AS UnitId
                             FROM MovementItem AS MovementItemChild
                             WHERE MovementItemChild.MovementId = vbMovementId
                               AND MovementItemChild.DescId = zc_MI_Child()
                               AND MovementItemChild.ParentId = (SELECT tmpMainUnitSubstitution.MovementItemID FROM tmpMainUnitSubstitution WHERE ID = 1)
                               AND MovementItemChild.ObjectId <> (SELECT tmpMainUnitSubstitution.UnitId FROM tmpMainUnitSubstitution WHERE ID = 1))

     INSERT INTO tmpMainUnitSubstitution (ID, MovementItemID, UnitId)
     SELECT 1, tmpUnitChild.MovementItemID, tmpUnitChild.UnitId
     FROM tmpUnitChild;

     I := 1;
     WHILE I <= date_part('DAY', vbDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
     LOOP

       vbQueryText := 'UPDATE tmpMainUnitSubstitution SET UnitID'||I::Text||' = MI_Child.UnitID
                       FROM (SELECT
                                    MovementItemChild.ObjectId        AS UnitId
                             FROM MovementItem

                                  INNER JOIN MovementItem AS MovementItemChild
                                                          ON MovementItemChild.MovementId = '||vbMovementId::Text||'
                                                         AND MovementItemChild.Amount = '||I::Text||'
                                                         AND MovementItemChild.DescId = zc_MI_Child()
                                                         AND MovementItemChild.ParentId = MovementItem.ID

                             WHERE MovementItem.MovementId = '||vbMovementId::Text||'
                               AND MovementItem.DescId = zc_MI_Master()
                               AND MovementItem.ObjectId = '||vbUserId::Text||') AS MI_Child
                       WHERE tmpMainUnitSubstitution.ID = 1';

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

     -- проверка наличия графика на следующий месяц
     IF EXISTS(SELECT 1 FROM Movement

                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.ObjectId = vbUserId

                   WHERE Movement.OperDate = vbDate
                     AND Movement.DescId = zc_Movement_EmployeeSchedule())
     THEN

       SELECT Movement.ID
       INTO vbMovementId
       FROM Movement
       WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
         AND Movement.OperDate = vbDate;

       INSERT INTO tmpMainUnit (ID, MovementItemID, UnitId)
       SELECT 2, MovementItem.Id, MILinkObject_Unit.ObjectId
       FROM Movement

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND MovementItem.ObjectId = vbUserId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

       WHERE Movement.OperDate = vbDate
         AND Movement.DescId = zc_Movement_EmployeeSchedule();


       IF (SELECT UnitId FROM tmpMainUnit WHERE ID = 2) IS NULL
       THEN
         WITH tmLogAll AS (SELECT count(*) as CountLog
                                , EmployeeWorkLog.UnitId
                           FROM EmployeeWorkLog
                           WHERE EmployeeWorkLog.DateLogIn >= vbDate AND EmployeeWorkLog.DateLogIn < CURRENT_DATE
                             AND EmployeeWorkLog.UserId = vbUserId
                           GROUP BY EmployeeWorkLog.UnitId),

              tmLog AS (SELECT ROW_NUMBER() OVER (ORDER BY tmLogAll.CountLog DESC) AS Ord
                             , tmLogAll.UnitId
                        FROM tmLogAll)

         UPDATE tmpMainUnit SET UnitId = COALESCE((SELECT tmLog.UnitId FROM tmLog WHERE tmLog.Ord = 1), vbUnitId) WHERE ID = 2;
       END IF;

       INSERT INTO tmpMainUnitSubstitution (ID, MovementItemID, UnitId)
       SELECT 2, MovementItem.Id, MILinkObject_Unit.ObjectId
       FROM Movement
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND MovementItem.ObjectId = vbUserId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

       WHERE Movement.OperDate = vbDate
            AND Movement.DescId = zc_Movement_EmployeeSchedule();

       IF (SELECT UnitId FROM tmpMainUnitSubstitution WHERE ID = 2) IS NULL
       THEN
         UPDATE tmpMainUnitSubstitution SET UnitId = COALESCE((SELECT UnitId FROM tmpMainUnitSubstitution WHERE ID = 2), vbUnitId) WHERE ID = 2;
       END IF;

       WITH tmpUnitChild AS (SELECT DISTINCT
                                    MovementItemChild.ParentId        AS MovementItemID
                                  , MovementItemChild.ObjectId        AS UnitId
                               FROM MovementItem AS MovementItemChild
                               WHERE MovementItemChild.MovementId = vbMovementId
                                 AND MovementItemChild.DescId = zc_MI_Child()
                                 AND MovementItemChild.ParentId = (SELECT tmpMainUnitSubstitution.MovementItemID FROM tmpMainUnitSubstitution WHERE ID = 2)
                                 AND MovementItemChild.ObjectId <> (SELECT tmpMainUnitSubstitution.UnitId FROM tmpMainUnitSubstitution WHERE ID = 2))

       INSERT INTO tmpMainUnitSubstitution (ID, MovementItemID, UnitId)
       SELECT 2, tmpUnitChild.MovementItemID, tmpUnitChild.UnitId
       FROM tmpUnitChild;

       I := 1;
       WHILE I <= date_part('DAY', vbDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
       LOOP

         vbQueryText := 'UPDATE tmpMainUnitSubstitution SET UnitID'||I::Text||' = MI_Child.UnitID
                         FROM (SELECT
                                      MovementItemChild.ObjectId        AS UnitId
                               FROM MovementItem

                                    INNER JOIN MovementItem AS MovementItemChild
                                                            ON MovementItemChild.MovementId = '||vbMovementId::Text||'
                                                           AND MovementItemChild.Amount = '||I::Text||'
                                                           AND MovementItemChild.DescId = zc_MI_Child()
                                                           AND MovementItemChild.ParentId = MovementItem.ID

                               WHERE MovementItem.MovementId = '||vbMovementId::Text||'
                                 AND MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.ObjectId = '||vbUserId::Text||') AS MI_Child
                         WHERE tmpMainUnitSubstitution.ID = 2';

         EXECUTE vbQueryText;
         I := I + 1;
       END LOOP;

     END IF;

     -- возвращаем заголовки столбцов и даты
     OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime,
                          ((EXTRACT(DAY FROM tmpOperDate.OperDate))||case when tmpCalendar.Working = False then ' *' else ' ' END||tmpWeekDay.DayOfWeekName) ::TVarChar AS ValueField
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
       tmpMainUnit.Id                                          AS ID,
       CASE WHEN tmpMainUnit.Id = 1
         THEN 'Регламент '||zfCalc_MonthName(CURRENT_DATE)
         ELSE 'Регламент '||zfCalc_MonthName(vbDate) END       AS Note,
       CASE WHEN tmpMainUnit.Id = 1
         THEN 'Факт '||zfCalc_MonthName(CURRENT_DATE)
         ELSE '' END                                           AS NoteUser,
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
       CASE WHEN vbCurrDay >= 1 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 1, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 1, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc1,
       CASE WHEN vbCurrDay >= 2 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 2, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 2, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc2,
       CASE WHEN vbCurrDay >= 3 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 3, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 3, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc3,
       CASE WHEN vbCurrDay >= 4 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 4, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 4, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc4,
       CASE WHEN vbCurrDay >= 5 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 5, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 5, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc5,
       CASE WHEN vbCurrDay >= 6 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 6, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 6, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc6,
       CASE WHEN vbCurrDay >= 7 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 7, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 7, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc7,
       CASE WHEN vbCurrDay >= 8 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 8, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 8, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc8,
       CASE WHEN vbCurrDay >= 9 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 9, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 9, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc9,
       CASE WHEN vbCurrDay >= 10 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 10, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 10, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc10,
       CASE WHEN vbCurrDay >= 11 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 11, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 11, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc11,
       CASE WHEN vbCurrDay >= 12 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 12, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 12, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc12,
       CASE WHEN vbCurrDay >= 13 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 13, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 13, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc13,
       CASE WHEN vbCurrDay >= 14 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 14, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 14, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc14,
       CASE WHEN vbCurrDay >= 15 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 15, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 15, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc15,
       CASE WHEN vbCurrDay >= 16 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 16, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 16, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc16,
       CASE WHEN vbCurrDay >= 17 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 17, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 17, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc17,
       CASE WHEN vbCurrDay >= 18 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 18, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 18, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc18,
       CASE WHEN vbCurrDay >= 19 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 19, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 19, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc19,
       CASE WHEN vbCurrDay >= 20 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 20, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 20, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc20,
       CASE WHEN vbCurrDay >= 21 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 21, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 21, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc21,
       CASE WHEN vbCurrDay >= 22 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 22, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 22, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc22,
       CASE WHEN vbCurrDay >= 23 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 23, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 23, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc23,
       CASE WHEN vbCurrDay >= 24 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 24, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 24, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc24,
       CASE WHEN vbCurrDay >= 25 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 25, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 25, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc25,
       CASE WHEN vbCurrDay >= 26 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 26, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 26, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc26,
       CASE WHEN vbCurrDay >= 27 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 27, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 27, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc27,
       CASE WHEN vbCurrDay >= 28 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 28, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 28, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc28,
       CASE WHEN vbCurrDay >= 29 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 29, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 29, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc29,
       CASE WHEN vbCurrDay >= 30 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 30, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 30, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc30,
       CASE WHEN vbCurrDay >= 31 AND tmpMainUnit.Id = 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 31, 1) <>
         SUBSTRING(MIString_ComingValueDayUser.ValueData, 31, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc31,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont1,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont2,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont3,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont4,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont5,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont6,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont7,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont8,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont9,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont10,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont11,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont12,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont13,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont14,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont15,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont16,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont17,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont18,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont19,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont20,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont21,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont22,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont23,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont24,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont25,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont26,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont27,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont28,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont29,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont30,
       CASE WHEN tmpMainUnit.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont31
     FROM tmpMainUnit

          INNER JOIN MovementItemString AS MIString_ComingValueDay
                                        ON MIString_ComingValueDay.DescId = zc_MIString_ComingValueDay()
                                       AND MIString_ComingValueDay.MovementItemId = tmpMainUnit.MovementItemId

          LEFT JOIN MovementItemString AS MIString_ComingValueDayUser
                                       ON MIString_ComingValueDayUser.DescId = zc_MIString_ComingValueDayUser()
                                      AND MIString_ComingValueDayUser.MovementItemId = tmpMainUnit.MovementItemId

     ORDER BY ID;

     RETURN NEXT cur3;

     OPEN cur4 FOR
     SELECT
       tmpMainUnitSubstitution.Id                              AS ID,
       CASE WHEN tmpMainUnitSubstitution.Id = 1
         THEN zfCalc_MonthName(CURRENT_DATE)
         ELSE zfCalc_MonthName(vbDate) END       AS Note,

       Object_Unit.ID                                          AS UnitID,
       Object_Unit.ObjectCode                                  AS UnitCode,
       Object_Unit.ValueData                                   AS UnitName,

       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID1 THEN
         lpDecodeValueDay(1, MIString_ComingValueDay.ValueData) END  AS Value1,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID2 THEN
         lpDecodeValueDay(2, MIString_ComingValueDay.ValueData) END  AS Value2,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID3 THEN
         lpDecodeValueDay(3, MIString_ComingValueDay.ValueData) END  AS Value3,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID4 THEN
         lpDecodeValueDay(4, MIString_ComingValueDay.ValueData) END  AS Value4,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID5 THEN
         lpDecodeValueDay(5, MIString_ComingValueDay.ValueData) END  AS Value5,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID6 THEN
         lpDecodeValueDay(6, MIString_ComingValueDay.ValueData) END  AS Value6,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID7 THEN
         lpDecodeValueDay(7, MIString_ComingValueDay.ValueData) END  AS Value7,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID8 THEN
         lpDecodeValueDay(8, MIString_ComingValueDay.ValueData) END  AS Value8,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID9 THEN
         lpDecodeValueDay(9, MIString_ComingValueDay.ValueData) END  AS Value9,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID10 THEN
         lpDecodeValueDay(10, MIString_ComingValueDay.ValueData) END AS Value10,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID11 THEN
         lpDecodeValueDay(11, MIString_ComingValueDay.ValueData) END AS Value11,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID12 THEN
         lpDecodeValueDay(12, MIString_ComingValueDay.ValueData) END AS Value12,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID13 THEN
         lpDecodeValueDay(13, MIString_ComingValueDay.ValueData) END AS Value13,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID14 THEN
         lpDecodeValueDay(14, MIString_ComingValueDay.ValueData) END AS Value14,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID15 THEN
         lpDecodeValueDay(15, MIString_ComingValueDay.ValueData) END AS Value15,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID16 THEN
         lpDecodeValueDay(16, MIString_ComingValueDay.ValueData) END AS Value16,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID17 THEN
         lpDecodeValueDay(17, MIString_ComingValueDay.ValueData) END AS Value17,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID18 THEN
         lpDecodeValueDay(18, MIString_ComingValueDay.ValueData) END AS Value18,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID19 THEN
         lpDecodeValueDay(19, MIString_ComingValueDay.ValueData) END AS Value19,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID20 THEN
         lpDecodeValueDay(20, MIString_ComingValueDay.ValueData) END AS Value20,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID21 THEN
         lpDecodeValueDay(21, MIString_ComingValueDay.ValueData) END AS Value21,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID22 THEN
         lpDecodeValueDay(22, MIString_ComingValueDay.ValueData) END AS Value22,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID23 THEN
         lpDecodeValueDay(23, MIString_ComingValueDay.ValueData) END AS Value23,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID24 THEN
         lpDecodeValueDay(24, MIString_ComingValueDay.ValueData) END AS Value24,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID25 THEN
         lpDecodeValueDay(25, MIString_ComingValueDay.ValueData) END AS Value25,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID26 THEN
         lpDecodeValueDay(26, MIString_ComingValueDay.ValueData) END AS Value26,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID27 THEN
         lpDecodeValueDay(27, MIString_ComingValueDay.ValueData) END AS Value27,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID28 THEN
         lpDecodeValueDay(28, MIString_ComingValueDay.ValueData) END AS Value28,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID29 THEN
         lpDecodeValueDay(29, MIString_ComingValueDay.ValueData) END AS Value29,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID30 THEN
         lpDecodeValueDay(30, MIString_ComingValueDay.ValueData) END AS Value30,
       CASE WHEN tmpMainUnitSubstitution.UnitID = tmpMainUnitSubstitution.UnitID31 THEN
         lpDecodeValueDay(31, MIString_ComingValueDay.ValueData) END AS Value31,
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
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont1,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont2,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont3,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont4,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont5,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont6,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont7,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont8,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont9,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont10,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont11,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont12,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont13,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont14,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont15,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont16,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont17,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont18,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont19,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont20,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont21,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont22,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont23,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont24,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont25,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont26,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont27,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont28,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont29,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont30,
       CASE WHEN tmpMainUnitSubstitution.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont31
     FROM tmpMainUnitSubstitution

          LEFT JOIN tmpMainUnit ON tmpMainUnit.Id = tmpMainUnitSubstitution.ID

          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMainUnitSubstitution.UnitID

          LEFT JOIN MovementItemString AS MIString_ComingValueDay
                                       ON MIString_ComingValueDay.DescId = zc_MIString_ComingValueDay()
                                      AND MIString_ComingValueDay.MovementItemId = tmpMainUnitSubstitution.MovementItemId

          LEFT JOIN MovementItemString AS MIString_ComingValueDayUser
                                       ON MIString_ComingValueDayUser.DescId = zc_MIString_ComingValueDayUser()
                                      AND MIString_ComingValueDayUser.MovementItemId = tmpMainUnitSubstitution.MovementItemId
     WHERE tmpMainUnit.UnitID <> tmpMainUnitSubstitution.UnitID;

     RETURN NEXT cur4;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_EmployeeSchedule_User (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.03.19                                                       *
*/

-- тест
-- select * from gpSelect_MovementItem_EmployeeSchedule_User(inSession := '308120');