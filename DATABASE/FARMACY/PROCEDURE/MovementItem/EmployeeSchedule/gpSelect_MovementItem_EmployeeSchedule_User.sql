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

     IF vbUserId = 3
     THEN
       vbUserId:= 11698275;
     END IF;

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

     CREATE TEMP TABLE tmpUserData ON COMMIT DROP AS
     SELECT MIMaster.ObjectId                                                            AS UserID
          , MILinkObject_Unit.ObjectId                                                   AS MainUnitID
          , MIChild.ObjectId                                                             AS UnitID
          , MIChild.Amount                                                               AS Day
          , MILinkObject_PayrollType.ObjectId                                            AS PayrollTypeID
          , PayrollType_ShortName.ValueData                                              AS PThortName
          , TO_CHAR(MIDate_Start.ValueData, 'HH24:mi')                                   AS TimeStart
          , TO_CHAR(MIDate_End.ValueData, 'HH24:mi')                                     AS TimeEnd
          , NULL::TVarChar                                                               AS PThortNameNext
     FROM Movement

          INNER JOIN MovementItem AS MIMaster
                                  ON MIMaster.MovementId = Movement.id
                                 AND MIMaster.DescId = zc_MI_Master()
                                 AND MIMaster.ObjectId = vbUserId

          LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                           ON MILinkObject_Unit.MovementItemId = MIMaster.Id
                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

          LEFT JOIN MovementItem AS MIChild
                                 ON MIChild.MovementId = Movement.id
                                AND MIChild.ParentId = MIMaster.ID
                                AND MIChild.DescId = zc_MI_Child()

          LEFT JOIN MovementItemLinkObject AS MILinkObject_PayrollType
                                           ON MILinkObject_PayrollType.MovementItemId = MIChild.Id
                                          AND MILinkObject_PayrollType.DescId = zc_MILinkObject_PayrollType()

          LEFT JOIN ObjectString AS PayrollType_ShortName
                                 ON PayrollType_ShortName.ObjectId = MILinkObject_PayrollType.ObjectId
                                AND PayrollType_ShortName.DescId = zc_ObjectString_PayrollType_ShortName()

          LEFT JOIN MovementItemDate AS MIDate_Start
                                     ON MIDate_Start.MovementItemId = MIChild.Id
                                    AND MIDate_Start.DescId = zc_MIDate_Start()

          LEFT JOIN MovementItemDate AS MIDate_End
                                     ON MIDate_End.MovementItemId = MIChild.Id
                                    AND MIDate_End.DescId = zc_MIDate_End()

     WHERE Movement.ID = vbMovementId;

     -- Получение главных аптек
     CREATE TEMP TABLE tmpMainUnit (ID integer, MovementItemID integer, UnitId Integer) ON COMMIT DROP;

     INSERT INTO tmpMainUnit (ID, MovementItemID, UnitId)
     SELECT 1, MovementItem.Id, MILinkObject_Unit.ObjectId
     FROM Movement

          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
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
                         WHERE EmployeeWorkLog.DateLogIn >= CURRENT_DATE - INTERVAL '1 MONTH'  AND EmployeeWorkLog.DateLogIn < CURRENT_DATE
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
                          ((EXTRACT(DAY FROM tmpOperDate.OperDate))||case when tmpCalendar.Working = False then ' *' else ' ' END||tmpWeekDay.DayOfWeekName) ::TVarChar AS ValueField,
                          ' '::TVarChar AS ValueFieldNill
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
       'Тип дня '||zfCalc_MonthName(CURRENT_DATE)              AS Note,
       'Приход '||zfCalc_MonthName(CURRENT_DATE)               AS NoteStart,
       'Уход '||zfCalc_MonthName(CURRENT_DATE)                 AS NoteEnd,
       'Тип дня '||zfCalc_MonthName(vbDate)                    AS NoteNext,

       UserData_01.PThortName                        AS Value1,
       UserData_02.PThortName                        AS Value2,
       UserData_03.PThortName                        AS Value3,
       UserData_04.PThortName                        AS Value4,
       UserData_05.PThortName                        AS Value5,
       UserData_06.PThortName                        AS Value6,
       UserData_07.PThortName                        AS Value7,
       UserData_08.PThortName                        AS Value8,
       UserData_09.PThortName                        AS Value9,
       UserData_10.PThortName                        AS Value10,
       UserData_11.PThortName                        AS Value11,
       UserData_12.PThortName                        AS Value12,
       UserData_13.PThortName                        AS Value13,
       UserData_14.PThortName                        AS Value14,
       UserData_15.PThortName                        AS Value15,
       UserData_16.PThortName                        AS Value16,
       UserData_17.PThortName                        AS Value17,
       UserData_18.PThortName                        AS Value18,
       UserData_19.PThortName                        AS Value19,
       UserData_20.PThortName                        AS Value20,
       UserData_21.PThortName                        AS Value21,
       UserData_22.PThortName                        AS Value22,
       UserData_23.PThortName                        AS Value23,
       UserData_24.PThortName                        AS Value24,
       UserData_25.PThortName                        AS Value25,
       UserData_26.PThortName                        AS Value26,
       UserData_27.PThortName                        AS Value27,
       UserData_28.PThortName                        AS Value28,
       UserData_29.PThortName                        AS Value29,
       UserData_30.PThortName                        AS Value30,
       UserData_31.PThortName                        AS Value31,

       UserData_01.TimeStart                                   AS ValueStart1,
       UserData_02.TimeStart                                   AS ValueStart2,
       UserData_03.TimeStart                                   AS ValueStart3,
       UserData_04.TimeStart                                   AS ValueStart4,
       UserData_05.TimeStart                                   AS ValueStart5,
       UserData_06.TimeStart                                   AS ValueStart6,
       UserData_07.TimeStart                                   AS ValueStart7,
       UserData_08.TimeStart                                   AS ValueStart8,
       UserData_09.TimeStart                                   AS ValueStart9,
       UserData_10.TimeStart                                   AS ValueStart10,
       UserData_11.TimeStart                                   AS ValueStart11,
       UserData_12.TimeStart                                   AS ValueStart12,
       UserData_13.TimeStart                                   AS ValueStart13,
       UserData_14.TimeStart                                   AS ValueStart14,
       UserData_15.TimeStart                                   AS ValueStart15,
       UserData_16.TimeStart                                   AS ValueStart16,
       UserData_17.TimeStart                                   AS ValueStart17,
       UserData_18.TimeStart                                   AS ValueStart18,
       UserData_19.TimeStart                                   AS ValueStart19,
       UserData_20.TimeStart                                   AS ValueStart20,
       UserData_21.TimeStart                                   AS ValueStart21,
       UserData_22.TimeStart                                   AS ValueStart22,
       UserData_23.TimeStart                                   AS ValueStart23,
       UserData_24.TimeStart                                   AS ValueStart24,
       UserData_25.TimeStart                                   AS ValueStart25,
       UserData_26.TimeStart                                   AS ValueStart26,
       UserData_27.TimeStart                                   AS ValueStart27,
       UserData_28.TimeStart                                   AS ValueStart28,
       UserData_29.TimeStart                                   AS ValueStart29,
       UserData_30.TimeStart                                   AS ValueStart30,
       UserData_31.TimeStart                                   AS ValueStart31,

       UserData_01.TimeEnd                                     AS ValueEnd1,
       UserData_02.TimeEnd                                     AS ValueEnd2,
       UserData_03.TimeEnd                                     AS ValueEnd3,
       UserData_04.TimeEnd                                     AS ValueEnd4,
       UserData_05.TimeEnd                                     AS ValueEnd5,
       UserData_06.TimeEnd                                     AS ValueEnd6,
       UserData_07.TimeEnd                                     AS ValueEnd7,
       UserData_08.TimeEnd                                     AS ValueEnd8,
       UserData_09.TimeEnd                                     AS ValueEnd9,
       UserData_10.TimeEnd                                     AS ValueEnd10,
       UserData_11.TimeEnd                                     AS ValueEnd11,
       UserData_12.TimeEnd                                     AS ValueEnd12,
       UserData_13.TimeEnd                                     AS ValueEnd13,
       UserData_14.TimeEnd                                     AS ValueEnd14,
       UserData_15.TimeEnd                                     AS ValueEnd15,
       UserData_16.TimeEnd                                     AS ValueEnd16,
       UserData_17.TimeEnd                                     AS ValueEnd17,
       UserData_18.TimeEnd                                     AS ValueEnd18,
       UserData_19.TimeEnd                                     AS ValueEnd19,
       UserData_20.TimeEnd                                     AS ValueEnd20,
       UserData_21.TimeEnd                                     AS ValueEnd21,
       UserData_22.TimeEnd                                     AS ValueEnd22,
       UserData_23.TimeEnd                                     AS ValueEnd23,
       UserData_24.TimeEnd                                     AS ValueEnd24,
       UserData_25.TimeEnd                                     AS ValueEnd25,
       UserData_26.TimeEnd                                     AS ValueEnd26,
       UserData_27.TimeEnd                                     AS ValueEnd27,
       UserData_28.TimeEnd                                     AS ValueEnd28,
       UserData_29.TimeEnd                                     AS ValueEnd29,
       UserData_30.TimeEnd                                     AS ValueEnd30,
       UserData_31.TimeEnd                                     AS ValueEnd31,

       UserData_01.PThortNameNext                        AS ValueNext1,
       UserData_02.PThortNameNext                        AS ValueNext2,
       UserData_03.PThortNameNext                        AS ValueNext3,
       UserData_04.PThortNameNext                        AS ValueNext4,
       UserData_05.PThortNameNext                        AS ValueNext5,
       UserData_06.PThortNameNext                        AS ValueNext6,
       UserData_07.PThortNameNext                        AS ValueNext7,
       UserData_08.PThortNameNext                        AS ValueNext8,
       UserData_09.PThortNameNext                        AS ValueNext9,
       UserData_10.PThortNameNext                        AS ValueNext10,
       UserData_11.PThortNameNext                        AS ValueNext11,
       UserData_12.PThortNameNext                        AS ValueNext12,
       UserData_13.PThortNameNext                        AS ValueNext13,
       UserData_14.PThortNameNext                        AS ValueNext14,
       UserData_15.PThortNameNext                        AS ValueNext15,
       UserData_16.PThortNameNext                        AS ValueNext16,
       UserData_17.PThortNameNext                        AS ValueNext17,
       UserData_18.PThortNameNext                        AS ValueNext18,
       UserData_19.PThortNameNext                        AS ValueNext19,
       UserData_20.PThortNameNext                        AS ValueNext20,
       UserData_21.PThortNameNext                        AS ValueNext21,
       UserData_22.PThortNameNext                        AS ValueNext22,
       UserData_23.PThortNameNext                        AS ValueNext23,
       UserData_24.PThortNameNext                        AS ValueNext24,
       UserData_25.PThortNameNext                        AS ValueNext25,
       UserData_26.PThortNameNext                        AS ValueNext26,
       UserData_27.PThortNameNext                        AS ValueNext27,
       UserData_28.PThortNameNext                        AS ValueNext28,
       UserData_29.PThortNameNext                        AS ValueNext29,
       UserData_30.PThortNameNext                        AS ValueNext30,
       UserData_31.PThortNameNext                        AS ValueNext31,

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
       zc_Color_White()                                        AS Color_Calc1,
       zc_Color_White()                                        AS Color_Calc2,
       zc_Color_White()                                        AS Color_Calc3,
       zc_Color_White()                                        AS Color_Calc4,
       zc_Color_White()                                        AS Color_Calc5,
       zc_Color_White()                                        AS Color_Calc6,
       zc_Color_White()                                        AS Color_Calc7,
       zc_Color_White()                                        AS Color_Calc8,
       zc_Color_White()                                        AS Color_Calc9,
       zc_Color_White()                                        AS Color_Calc10,
       zc_Color_White()                                        AS Color_Calc11,
       zc_Color_White()                                        AS Color_Calc12,
       zc_Color_White()                                        AS Color_Calc13,
       zc_Color_White()                                        AS Color_Calc14,
       zc_Color_White()                                        AS Color_Calc15,
       zc_Color_White()                                        AS Color_Calc16,
       zc_Color_White()                                        AS Color_Calc17,
       zc_Color_White()                                        AS Color_Calc18,
       zc_Color_White()                                        AS Color_Calc19,
       zc_Color_White()                                        AS Color_Calc20,
       zc_Color_White()                                        AS Color_Calc21,
       zc_Color_White()                                        AS Color_Calc22,
       zc_Color_White()                                        AS Color_Calc23,
       zc_Color_White()                                        AS Color_Calc24,
       zc_Color_White()                                        AS Color_Calc25,
       zc_Color_White()                                        AS Color_Calc26,
       zc_Color_White()                                        AS Color_Calc27,
       zc_Color_White()                                        AS Color_Calc28,
       zc_Color_White()                                        AS Color_Calc29,
       zc_Color_White()                                        AS Color_Calc30,
       zc_Color_White()                                        AS Color_Calc31,


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

          LEFT JOIN tmpUserData AS UserData_01
                                 ON UserData_01.Day = 1

          LEFT JOIN tmpUserData AS UserData_02
                                 ON UserData_02.Day = 2

          LEFT JOIN tmpUserData AS UserData_03
                                 ON UserData_03.Day = 3

          LEFT JOIN tmpUserData AS UserData_04
                                 ON UserData_04.Day = 4

          LEFT JOIN tmpUserData AS UserData_05
                                 ON UserData_05.Day = 5

          LEFT JOIN tmpUserData AS UserData_06
                                 ON UserData_06.Day = 6

          LEFT JOIN tmpUserData AS UserData_07
                                 ON UserData_07.Day = 7

          LEFT JOIN tmpUserData AS UserData_08
                                 ON UserData_08.Day = 8

          LEFT JOIN tmpUserData AS UserData_09
                                 ON UserData_09.Day = 9

          LEFT JOIN tmpUserData AS UserData_10
                                 ON UserData_10.Day = 10

          LEFT JOIN tmpUserData AS UserData_11
                                 ON UserData_11.Day = 11

          LEFT JOIN tmpUserData AS UserData_12
                                 ON UserData_12.Day = 12

          LEFT JOIN tmpUserData AS UserData_13
                                 ON UserData_13.Day = 13

          LEFT JOIN tmpUserData AS UserData_14
                                 ON UserData_14.Day = 14

          LEFT JOIN tmpUserData AS UserData_15
                                 ON UserData_15.Day = 15

          LEFT JOIN tmpUserData AS UserData_16
                                 ON UserData_16.Day = 16

          LEFT JOIN tmpUserData AS UserData_17
                                 ON UserData_17.Day = 17

          LEFT JOIN tmpUserData AS UserData_18
                                 ON UserData_18.Day = 18

          LEFT JOIN tmpUserData AS UserData_19
                                 ON UserData_19.Day = 19

          LEFT JOIN tmpUserData AS UserData_20
                                 ON UserData_20.Day = 20

          LEFT JOIN tmpUserData AS UserData_21
                                 ON UserData_21.Day = 21

          LEFT JOIN tmpUserData AS UserData_22
                                 ON UserData_22.Day = 22

          LEFT JOIN tmpUserData AS UserData_23
                                 ON UserData_23.Day = 23

          LEFT JOIN tmpUserData AS UserData_24
                                 ON UserData_24.Day = 24

          LEFT JOIN tmpUserData AS UserData_25
                                 ON UserData_25.Day = 25

          LEFT JOIN tmpUserData AS UserData_26
                                 ON UserData_26.Day = 26

          LEFT JOIN tmpUserData AS UserData_27
                                 ON UserData_27.Day = 27

          LEFT JOIN tmpUserData AS UserData_28
                                 ON UserData_28.Day = 28

          LEFT JOIN tmpUserData AS UserData_29
                                 ON UserData_29.Day = 29

          LEFT JOIN tmpUserData AS UserData_30
                                 ON UserData_30.Day = 30

          LEFT JOIN tmpUserData AS UserData_31
                                 ON UserData_31.Day = 31

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
 02.09.19                                                       *
 27.03.19                                                       *
*/

-- тест
--
select * from gpSelect_MovementItem_EmployeeSchedule_User(inSession := '11698275');