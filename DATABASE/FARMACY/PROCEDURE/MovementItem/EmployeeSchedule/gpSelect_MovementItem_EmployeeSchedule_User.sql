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
          , COALESCE (MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId)  AS MainUnitID
          , MIChild.ObjectId                                                             AS UnitID
          , MIChild.Amount                                                               AS Day
          , MILinkObject_PayrollType.ObjectId                                            AS PayrollTypeID
          , CASE WHEN COALESCE(MIBoolean_ServiceExit.ValueData, FALSE) = FALSE
            THEN PayrollType_ShortName.ValueData  ELSE 'СВ' END                          AS PThortName
          , CASE WHEN COALESCE(MIBoolean_ServiceExit.ValueData, FALSE) = FALSE
            THEN TO_CHAR(MIDate_Start.ValueData, 'HH24:mi')  ELSE '' END                 AS TimeStart
          , CASE WHEN COALESCE(MIBoolean_ServiceExit.ValueData, FALSE) = FALSE
            THEN TO_CHAR(MIDate_End.ValueData, 'HH24:mi')  ELSE '' END                   AS TimeEnd
          , COALESCE(MIBoolean_ServiceExit.ValueData, FALSE)                             AS ServiceExit
          , NULL::TVarChar                                                               AS PThortNameNext
     FROM Movement

          INNER JOIN MovementItem AS MIMaster
                                  ON MIMaster.MovementId = Movement.id
                                 AND MIMaster.DescId = zc_MI_Master()
                                 AND MIMaster.ObjectId = vbUserId

          LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                           ON MILinkObject_Unit.MovementItemId = MIMaster.Id
                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

          LEFT JOIN ObjectLink AS ObjectLink_User_Member
                               ON ObjectLink_User_Member.ObjectId = MIMaster.ObjectId
                              AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

          LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                               ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                              AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

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

          LEFT JOIN MovementItemBoolean AS MIBoolean_ServiceExit
                                        ON MIBoolean_ServiceExit.MovementItemId = MIChild.Id
                                       AND MIBoolean_ServiceExit.DescId = zc_MIBoolean_ServiceExit()

     WHERE Movement.ID = vbMovementId;


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
       MIMaster.Id                                             AS ID,
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


       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont1,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont2,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont3,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont4,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont5,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont6,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont7,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont8,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont9,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont10,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont11,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont12,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont13,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont14,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont15,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont16,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont17,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont18,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont19,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont20,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont21,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont22,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont23,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont24,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont25,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont26,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont27,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont28,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont29,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont30,
       CASE WHEN MIMaster.Id = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont31
     FROM Movement

          INNER JOIN MovementItem AS MIMaster
                                  ON MIMaster.MovementId = Movement.id
                                 AND MIMaster.DescId = zc_MI_Master()
                                 AND MIMaster.ObjectId = vbUserId

          LEFT JOIN tmpUserData AS UserData_01
                                ON UserData_01.Day = 1
                               AND UserData_01.MainUnitID = UserData_01.UnitID

          LEFT JOIN tmpUserData AS UserData_02
                                ON UserData_02.Day = 2
                               AND UserData_02.MainUnitID = UserData_02.UnitID

          LEFT JOIN tmpUserData AS UserData_03
                                ON UserData_03.Day = 3
                               AND UserData_03.MainUnitID = UserData_03.UnitID

          LEFT JOIN tmpUserData AS UserData_04
                                ON UserData_04.Day = 4
                               AND UserData_04.MainUnitID = UserData_04.UnitID

          LEFT JOIN tmpUserData AS UserData_05
                                ON UserData_05.Day = 5
                               AND UserData_05.MainUnitID = UserData_05.UnitID

          LEFT JOIN tmpUserData AS UserData_06
                                ON UserData_06.Day = 6
                               AND UserData_06.MainUnitID = UserData_06.UnitID

          LEFT JOIN tmpUserData AS UserData_07
                                ON UserData_07.Day = 7
                               AND UserData_07.MainUnitID = UserData_07.UnitID

          LEFT JOIN tmpUserData AS UserData_08
                                ON UserData_08.Day = 8
                               AND UserData_08.MainUnitID = UserData_08.UnitID

          LEFT JOIN tmpUserData AS UserData_09
                                ON UserData_09.Day = 9
                               AND UserData_09.MainUnitID = UserData_09.UnitID

          LEFT JOIN tmpUserData AS UserData_10
                                ON UserData_10.Day = 10
                               AND UserData_10.MainUnitID = UserData_10.UnitID

          LEFT JOIN tmpUserData AS UserData_11
                                ON UserData_11.Day = 11
                               AND UserData_11.MainUnitID = UserData_11.UnitID

          LEFT JOIN tmpUserData AS UserData_12
                                ON UserData_12.Day = 12
                               AND UserData_12.MainUnitID = UserData_12.UnitID

          LEFT JOIN tmpUserData AS UserData_13
                                ON UserData_13.Day = 13
                               AND UserData_13.MainUnitID = UserData_13.UnitID

          LEFT JOIN tmpUserData AS UserData_14
                                ON UserData_14.Day = 14
                               AND UserData_14.MainUnitID = UserData_14.UnitID

          LEFT JOIN tmpUserData AS UserData_15
                                ON UserData_15.Day = 15
                               AND UserData_15.MainUnitID = UserData_15.UnitID

          LEFT JOIN tmpUserData AS UserData_16
                                ON UserData_16.Day = 16
                               AND UserData_16.MainUnitID = UserData_16.UnitID

          LEFT JOIN tmpUserData AS UserData_17
                                ON UserData_17.Day = 17
                               AND UserData_17.MainUnitID = UserData_17.UnitID

          LEFT JOIN tmpUserData AS UserData_18
                                ON UserData_18.Day = 18
                               AND UserData_18.MainUnitID = UserData_18.UnitID

          LEFT JOIN tmpUserData AS UserData_19
                                ON UserData_19.Day = 19
                               AND UserData_19.MainUnitID = UserData_19.UnitID

          LEFT JOIN tmpUserData AS UserData_20
                                ON UserData_20.Day = 20
                               AND UserData_20.MainUnitID = UserData_20.UnitID

          LEFT JOIN tmpUserData AS UserData_21
                                ON UserData_21.Day = 21
                               AND UserData_21.MainUnitID = UserData_21.UnitID

          LEFT JOIN tmpUserData AS UserData_22
                                ON UserData_22.Day = 22
                               AND UserData_22.MainUnitID = UserData_22.UnitID

          LEFT JOIN tmpUserData AS UserData_23
                                ON UserData_23.Day = 23
                               AND UserData_23.MainUnitID = UserData_23.UnitID

          LEFT JOIN tmpUserData AS UserData_24
                                ON UserData_24.Day = 24
                               AND UserData_24.MainUnitID = UserData_24.UnitID

          LEFT JOIN tmpUserData AS UserData_25
                                ON UserData_25.Day = 25
                               AND UserData_25.MainUnitID = UserData_25.UnitID

          LEFT JOIN tmpUserData AS UserData_26
                                ON UserData_26.Day = 26
                               AND UserData_26.MainUnitID = UserData_26.UnitID

          LEFT JOIN tmpUserData AS UserData_27
                                ON UserData_27.Day = 27
                               AND UserData_27.MainUnitID = UserData_27.UnitID

          LEFT JOIN tmpUserData AS UserData_28
                                ON UserData_28.Day = 28
                               AND UserData_28.MainUnitID = UserData_28.UnitID

          LEFT JOIN tmpUserData AS UserData_29
                                ON UserData_29.Day = 29
                               AND UserData_29.MainUnitID = UserData_29.UnitID

          LEFT JOIN tmpUserData AS UserData_30
                                ON UserData_30.Day = 30
                               AND UserData_30.MainUnitID = UserData_30.UnitID

          LEFT JOIN tmpUserData AS UserData_31
                                ON UserData_31.Day = 31
                               AND UserData_31.MainUnitID = UserData_31.UnitID
     WHERE Movement.ID = vbMovementId
     ORDER BY ID;

     RETURN NEXT cur3;

     OPEN cur4 FOR
     SELECT
       UserData.UnitID                                         AS ID,
       'Тип дня '||zfCalc_MonthName(CURRENT_DATE)              AS Note,
       'Приход '||zfCalc_MonthName(CURRENT_DATE)               AS NoteStart,
       'Уход '||zfCalc_MonthName(CURRENT_DATE)                 AS NoteEnd,
       'Тип дня '||zfCalc_MonthName(vbDate)                    AS NoteNext,

       Object_Unit.ID                                          AS UnitID,
       Object_Unit.ObjectCode                                  AS UnitCode,
       Object_Unit.ValueData                                   AS UnitName,

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

       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont1,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont2,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont3,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont4,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont5,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont6,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont7,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont8,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont9,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont10,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont11,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont12,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont13,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont14,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont15,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont16,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont17,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont18,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont19,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont20,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont21,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont22,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont23,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont24,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont25,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont26,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont27,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont28,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont29,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont30,
       CASE WHEN UserData.UnitID = 1 THEN zc_Color_Black() ELSE 32768 END AS Color_CalcFont31

     FROM (SELECT DISTINCT tmpUserData.UnitID FROM tmpUserData WHERE tmpUserData.MainUnitID <> tmpUserData.UnitID) AS UserData

          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = UserData.UnitID

          LEFT JOIN tmpUserData AS UserData_01
                                ON UserData_01.Day = 1
                               AND UserData.UnitID = UserData_01.UnitID

          LEFT JOIN tmpUserData AS UserData_02
                                ON UserData_02.Day = 2
                               AND UserData.UnitID = UserData_02.UnitID

          LEFT JOIN tmpUserData AS UserData_03
                                ON UserData_03.Day = 3
                               AND UserData.UnitID = UserData_03.UnitID

          LEFT JOIN tmpUserData AS UserData_04
                                ON UserData_04.Day = 4
                               AND UserData.UnitID = UserData_04.UnitID

          LEFT JOIN tmpUserData AS UserData_05
                                ON UserData_05.Day = 5
                               AND UserData.UnitID = UserData_05.UnitID

          LEFT JOIN tmpUserData AS UserData_06
                                ON UserData_06.Day = 6
                               AND UserData.UnitID = UserData_06.UnitID

          LEFT JOIN tmpUserData AS UserData_07
                                ON UserData_07.Day = 7
                               AND UserData.UnitID = UserData_07.UnitID

          LEFT JOIN tmpUserData AS UserData_08
                                ON UserData_08.Day = 8
                               AND UserData.UnitID = UserData_08.UnitID

          LEFT JOIN tmpUserData AS UserData_09
                                ON UserData_09.Day = 9
                               AND UserData.UnitID = UserData_09.UnitID

          LEFT JOIN tmpUserData AS UserData_10
                                ON UserData_10.Day = 10
                               AND UserData.UnitID = UserData_10.UnitID

          LEFT JOIN tmpUserData AS UserData_11
                                ON UserData_11.Day = 11
                               AND UserData.UnitID = UserData_11.UnitID

          LEFT JOIN tmpUserData AS UserData_12
                                ON UserData_12.Day = 12
                               AND UserData.UnitID = UserData_12.UnitID

          LEFT JOIN tmpUserData AS UserData_13
                                ON UserData_13.Day = 13
                               AND UserData.UnitID = UserData_13.UnitID

          LEFT JOIN tmpUserData AS UserData_14
                                ON UserData_14.Day = 14
                               AND UserData.UnitID = UserData_14.UnitID

          LEFT JOIN tmpUserData AS UserData_15
                                ON UserData_15.Day = 15
                               AND UserData.UnitID = UserData_15.UnitID

          LEFT JOIN tmpUserData AS UserData_16
                                ON UserData_16.Day = 16
                               AND UserData.UnitID = UserData_16.UnitID

          LEFT JOIN tmpUserData AS UserData_17
                                ON UserData_17.Day = 17
                               AND UserData.UnitID = UserData_17.UnitID

          LEFT JOIN tmpUserData AS UserData_18
                                ON UserData_18.Day = 18
                               AND UserData.UnitID = UserData_18.UnitID

          LEFT JOIN tmpUserData AS UserData_19
                                ON UserData_19.Day = 19
                               AND UserData.UnitID = UserData_19.UnitID

          LEFT JOIN tmpUserData AS UserData_20
                                ON UserData_20.Day = 20
                               AND UserData.UnitID = UserData_20.UnitID

          LEFT JOIN tmpUserData AS UserData_21
                                ON UserData_21.Day = 21
                               AND UserData.UnitID = UserData_21.UnitID

          LEFT JOIN tmpUserData AS UserData_22
                                ON UserData_22.Day = 22
                               AND UserData.UnitID = UserData_22.UnitID

          LEFT JOIN tmpUserData AS UserData_23
                                ON UserData_23.Day = 23
                               AND UserData_23.MainUnitID = UserData_23.UnitID

          LEFT JOIN tmpUserData AS UserData_24
                                ON UserData_24.Day = 24
                               AND UserData.UnitID = UserData_24.UnitID

          LEFT JOIN tmpUserData AS UserData_25
                                ON UserData_25.Day = 25
                               AND UserData.UnitID = UserData_25.UnitID

          LEFT JOIN tmpUserData AS UserData_26
                                ON UserData_26.Day = 26
                               AND UserData_26.MainUnitID = UserData_26.UnitID

          LEFT JOIN tmpUserData AS UserData_27
                                ON UserData_27.Day = 27
                               AND UserData.UnitID = UserData_27.UnitID

          LEFT JOIN tmpUserData AS UserData_28
                                ON UserData_28.Day = 28
                               AND UserData.UnitID = UserData_28.UnitID

          LEFT JOIN tmpUserData AS UserData_29
                                ON UserData_29.Day = 29
                               AND UserData.UnitID = UserData_29.UnitID

          LEFT JOIN tmpUserData AS UserData_30
                                ON UserData_30.Day = 30
                               AND UserData.UnitID = UserData_30.UnitID

          LEFT JOIN tmpUserData AS UserData_31
                                ON UserData_31.Day = 31
                               AND UserData.UnitID = UserData_31.UnitID

     ORDER BY ID;

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
-- select * from gpSelect_MovementItem_EmployeeSchedule_User(inSession := '11698275');