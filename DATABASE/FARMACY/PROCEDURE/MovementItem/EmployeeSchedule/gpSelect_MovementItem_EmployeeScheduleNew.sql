-- Function: gpSelect_MovementItem_EmployeeScheduleNew()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_EmployeeScheduleNew(Integer, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_EmployeeScheduleNew(
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
  DECLARE vbMovementId  Integer;
  DECLARE vbDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
--     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
      vbUserId:= lpGetUserBySession (inSession);

     inDate := DATE_TRUNC ('MONTH', inDate);

     IF EXISTS(SELECT 1 FROM Movement
                   WHERE Movement.OperDate = inDate - INTERVAL '1 MONTH'
                     AND Movement.OperDate >= '01.09.2019'
                     AND Movement.DescId = zc_Movement_EmployeeSchedule())
     THEN
       SELECT Movement.ID
       INTO vbMovementId
       FROM Movement
       WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
         AND Movement.OperDate >= '01.09.2019'
         AND Movement.OperDate = inDate - INTERVAL '1 MONTH';
     ELSE
       vbMovementId := 0;
     END IF;


     CREATE TEMP TABLE tmpUserData ON COMMIT DROP AS
     SELECT MIMaster.ID                                                                  AS ID
          , MIMaster.ObjectId                                                            AS UserID
          , (COALESCE(MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId) =
            COALESCE(MIChild.ObjectId, ObjectLink_Member_Unit.ChildObjectId))::Boolean   AS MainUnit
          , MIChild.ID                                                                   AS ChildID
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
          , ROW_NUMBER() OVER (PARTITION BY MIMaster.ID, MIChild.Amount
                               ORDER BY (COALESCE(MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId) =
                                         COALESCE(MIChild.ObjectId, ObjectLink_Member_Unit.ChildObjectId)) DESC, MIChild.ID) AS Ord

     FROM Movement

          INNER JOIN MovementItem AS MIMaster
                                  ON MIMaster.MovementId = Movement.id
                                 AND MIMaster.DescId = zc_MI_Master()

          LEFT JOIN ObjectLink AS ObjectLink_User_Member
                               ON ObjectLink_User_Member.ObjectId = MIMaster.ObjectId
                              AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

          LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                               ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                              AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

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

          LEFT JOIN MovementItemBoolean AS MIBoolean_ServiceExit
                                        ON MIBoolean_ServiceExit.MovementItemId = MIChild.Id
                                       AND MIBoolean_ServiceExit.DescId = zc_MIBoolean_ServiceExit()

     WHERE Movement.ID = inMovementId;
     ANALYSE tmpUserData;

     -- Придублировании в дне показываем только главные

     CREATE TEMP TABLE tmpUserDataPrev ON COMMIT DROP AS
     SELECT MIMaster.ID                                                                  AS ID
          , MIMaster.ObjectId                                                            AS UserID
          , (COALESCE(MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId) =
            COALESCE(MIChild.ObjectId, ObjectLink_Member_Unit.ChildObjectId))::Boolean   AS MainUnit
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
          , ROW_NUMBER() OVER (PARTITION BY MIMaster.ID, MIChild.Amount
                               ORDER BY (COALESCE(MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId) =
                                         COALESCE(MIChild.ObjectId, ObjectLink_Member_Unit.ChildObjectId)) DESC, MIChild.ID) AS Ord
     FROM Movement

          INNER JOIN MovementItem AS MIMaster
                                  ON MIMaster.MovementId = Movement.id
                                 AND MIMaster.DescId = zc_MI_Master()

          LEFT JOIN ObjectLink AS ObjectLink_User_Member
                               ON ObjectLink_User_Member.ObjectId = MIMaster.ObjectId
                              AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

          LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                               ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                              AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

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

          LEFT JOIN MovementItemBoolean AS MIBoolean_ServiceExit
                                        ON MIBoolean_ServiceExit.MovementItemId = MIChild.Id
                                       AND MIBoolean_ServiceExit.DescId = zc_MIBoolean_ServiceExit()

          INNER JOIN MovementItem AS MIMasterPrev
                                  ON MIMasterPrev.MovementId = vbMovementId
                                 AND MIMasterPrev.DescId = zc_MI_Master()
                                 AND MIMasterPrev.ObjectId = MIMaster.ObjectId

          LEFT JOIN MovementItem AS MIChildPrev
                                 ON MIChildPrev.MovementId = vbMovementId
                                AND MIChildPrev.ParentId = MIMasterPrev.ID
                                AND MIChildPrev.DescId = zc_MI_Child()
                                AND MIChildPrev.Amount = MIChild.Amount

          LEFT JOIN MovementItemLinkObject AS MILinkObject_PayrollTypePrev
                                           ON MILinkObject_PayrollTypePrev.MovementItemId = MIChildPrev.Id
                                          AND MILinkObject_PayrollTypePrev.DescId = zc_MILinkObject_PayrollType()

     WHERE Movement.ID = vbMovementId;
     ANALYSE tmpUserDataPrev;

     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
        SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inDate), DATE_TRUNC ('MONTH', inDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;

     vbDate := DATE_TRUNC ('MONTH', inDate) - INTERVAL '1 MONTH';

     CREATE TEMP TABLE tmpOperDatePrev ON COMMIT DROP AS
        SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', vbDate), DATE_TRUNC ('MONTH', vbDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;


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

     IF COALESCE(inMovementId, 0) = 0 OR inShowAll = TRUE OR
        NOT EXISTS(SELECT MovementItem.ObjectId
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId = zc_MI_Master())
     THEN


       OPEN cur3 FOR

       SELECT
         0                                                       AS ID,
         Object_User.Id                                          AS UserID,
         Object_User.IsErased                                    AS IsErased,
         Object_Member.ObjectCode                                AS PersonalCode,
         COALESCE (Object_Member.ValueData, Object_User.ValueData) AS PersonalName,
         Object_Position.ValueData                               AS PositionName,
         CASE WHEN COALESCE (ObjectBoolean_DismissedUser.ValueData, FALSE) = TRUE
              THEN zfCalc_Color( 192, 192, 192)
              ELSE zc_Color_Black() END::Integer                 AS Color_DismissedUser,
         COALESCE (ObjectBoolean_DismissedUser.ValueData, FALSE)     AS isDismissedUser,
         Object_Unit.ID                                          AS UnitID,
         Object_Unit.ObjectCode                                  AS UnitCode,
         Object_Unit.ValueData                                   AS UnitName,
         'Пр. месяц'::TVarChar                                   AS Name0,
         'Тип дня'::TVarChar                                     AS Name1,
         'Приход'::TVarChar                                      AS Name2,
         'Уход'::TVarChar                                        AS Name3,

         NULL::Integer                        AS ChildID1,
         NULL::Integer                        AS ChildID2,
         NULL::Integer                        AS ChildID3,
         NULL::Integer                        AS ChildID4,
         NULL::Integer                        AS ChildID5,
         NULL::Integer                        AS ChildID6,
         NULL::Integer                        AS ChildID7,
         NULL::Integer                        AS ChildID8,
         NULL::Integer                        AS ChildID9,
         NULL::Integer                        AS ChildID10,
         NULL::Integer                        AS ChildID11,
         NULL::Integer                        AS ChildID12,
         NULL::Integer                        AS ChildID13,
         NULL::Integer                        AS ChildID14,
         NULL::Integer                        AS ChildID15,
         NULL::Integer                        AS ChildID16,
         NULL::Integer                        AS ChildID17,
         NULL::Integer                        AS ChildID18,
         NULL::Integer                        AS ChildID19,
         NULL::Integer                        AS ChildID20,
         NULL::Integer                        AS ChildID21,
         NULL::Integer                        AS ChildID22,
         NULL::Integer                        AS ChildID23,
         NULL::Integer                        AS ChildID24,
         NULL::Integer                        AS ChildID25,
         NULL::Integer                        AS ChildID26,
         NULL::Integer                        AS ChildID27,
         NULL::Integer                        AS ChildID28,
         NULL::Integer                        AS ChildID29,
         NULL::Integer                        AS ChildID30,
         NULL::Integer                        AS ChildID31,

         NULL::TVarChar                        AS Value1,
         NULL::TVarChar                        AS Value2,
         NULL::TVarChar                        AS Value3,
         NULL::TVarChar                        AS Value4,
         NULL::TVarChar                        AS Value5,
         NULL::TVarChar                        AS Value6,
         NULL::TVarChar                        AS Value7,
         NULL::TVarChar                        AS Value8,
         NULL::TVarChar                        AS Value9,
         NULL::TVarChar                        AS Value10,
         NULL::TVarChar                        AS Value11,
         NULL::TVarChar                        AS Value12,
         NULL::TVarChar                        AS Value13,
         NULL::TVarChar                        AS Value14,
         NULL::TVarChar                        AS Value15,
         NULL::TVarChar                        AS Value16,
         NULL::TVarChar                        AS Value17,
         NULL::TVarChar                        AS Value18,
         NULL::TVarChar                        AS Value19,
         NULL::TVarChar                        AS Value20,
         NULL::TVarChar                        AS Value21,
         NULL::TVarChar                        AS Value22,
         NULL::TVarChar                        AS Value23,
         NULL::TVarChar                        AS Value24,
         NULL::TVarChar                        AS Value25,
         NULL::TVarChar                        AS Value26,
         NULL::TVarChar                        AS Value27,
         NULL::TVarChar                        AS Value28,
         NULL::TVarChar                        AS Value29,
         NULL::TVarChar                        AS Value30,
         NULL::TVarChar                        AS Value31,

         NULL::TVarChar                                   AS ValueStart1,
         NULL::TVarChar                                   AS ValueStart2,
         NULL::TVarChar                                   AS ValueStart3,
         NULL::TVarChar                                   AS ValueStart4,
         NULL::TVarChar                                   AS ValueStart5,
         NULL::TVarChar                                   AS ValueStart6,
         NULL::TVarChar                                   AS ValueStart7,
         NULL::TVarChar                                   AS ValueStart8,
         NULL::TVarChar                                   AS ValueStart9,
         NULL::TVarChar                                   AS ValueStart10,
         NULL::TVarChar                                   AS ValueStart11,
         NULL::TVarChar                                   AS ValueStart12,
         NULL::TVarChar                                   AS ValueStart13,
         NULL::TVarChar                                   AS ValueStart14,
         NULL::TVarChar                                   AS ValueStart15,
         NULL::TVarChar                                   AS ValueStart16,
         NULL::TVarChar                                   AS ValueStart17,
         NULL::TVarChar                                   AS ValueStart18,
         NULL::TVarChar                                   AS ValueStart19,
         NULL::TVarChar                                   AS ValueStart20,
         NULL::TVarChar                                   AS ValueStart21,
         NULL::TVarChar                                   AS ValueStart22,
         NULL::TVarChar                                   AS ValueStart23,
         NULL::TVarChar                                   AS ValueStart24,
         NULL::TVarChar                                   AS ValueStart25,
         NULL::TVarChar                                   AS ValueStart26,
         NULL::TVarChar                                   AS ValueStart27,
         NULL::TVarChar                                   AS ValueStart28,
         NULL::TVarChar                                   AS ValueStart29,
         NULL::TVarChar                                   AS ValueStart30,
         NULL::TVarChar                                   AS ValueStart31,

         NULL::TVarChar                                     AS ValueEnd1,
         NULL::TVarChar                                     AS ValueEnd2,
         NULL::TVarChar                                     AS ValueEnd3,
         NULL::TVarChar                                     AS ValueEnd4,
         NULL::TVarChar                                     AS ValueEnd5,
         NULL::TVarChar                                     AS ValueEnd6,
         NULL::TVarChar                                     AS ValueEnd7,
         NULL::TVarChar                                     AS ValueEnd8,
         NULL::TVarChar                                     AS ValueEnd9,
         NULL::TVarChar                                     AS ValueEnd10,
         NULL::TVarChar                                     AS ValueEnd11,
         NULL::TVarChar                                     AS ValueEnd12,
         NULL::TVarChar                                     AS ValueEnd13,
         NULL::TVarChar                                     AS ValueEnd14,
         NULL::TVarChar                                     AS ValueEnd15,
         NULL::TVarChar                                     AS ValueEnd16,
         NULL::TVarChar                                     AS ValueEnd17,
         NULL::TVarChar                                     AS ValueEnd18,
         NULL::TVarChar                                     AS ValueEnd19,
         NULL::TVarChar                                     AS ValueEnd20,
         NULL::TVarChar                                     AS ValueEnd21,
         NULL::TVarChar                                     AS ValueEnd22,
         NULL::TVarChar                                     AS ValueEnd23,
         NULL::TVarChar                                     AS ValueEnd24,
         NULL::TVarChar                                     AS ValueEnd25,
         NULL::TVarChar                                     AS ValueEnd26,
         NULL::TVarChar                                     AS ValueEnd27,
         NULL::TVarChar                                     AS ValueEnd28,
         NULL::TVarChar                                     AS ValueEnd29,
         NULL::TVarChar                                     AS ValueEnd30,
         NULL::TVarChar                                     AS ValueEnd31,

         UserDataPrev_01.PThortName                            AS ValuePrev1,
         UserDataPrev_02.PThortName                            AS ValuePrev2,
         UserDataPrev_03.PThortName                            AS ValuePrev3,
         UserDataPrev_04.PThortName                            AS ValuePrev4,
         UserDataPrev_05.PThortName                            AS ValuePrev5,
         UserDataPrev_06.PThortName                            AS ValuePrev6,
         UserDataPrev_07.PThortName                            AS ValuePrev7,
         UserDataPrev_08.PThortName                            AS ValuePrev8,
         UserDataPrev_09.PThortName                            AS ValuePrev9,
         UserDataPrev_10.PThortName                            AS ValuePrev10,
         UserDataPrev_11.PThortName                            AS ValuePrev11,
         UserDataPrev_12.PThortName                            AS ValuePrev12,
         UserDataPrev_13.PThortName                            AS ValuePrev13,
         UserDataPrev_14.PThortName                            AS ValuePrev14,
         UserDataPrev_15.PThortName                            AS ValuePrev15,
         UserDataPrev_16.PThortName                            AS ValuePrev16,
         UserDataPrev_17.PThortName                            AS ValuePrev17,
         UserDataPrev_18.PThortName                            AS ValuePrev18,
         UserDataPrev_19.PThortName                            AS ValuePrev19,
         UserDataPrev_20.PThortName                            AS ValuePrev20,
         UserDataPrev_21.PThortName                            AS ValuePrev21,
         UserDataPrev_22.PThortName                            AS ValuePrev22,
         UserDataPrev_23.PThortName                            AS ValuePrev23,
         UserDataPrev_24.PThortName                            AS ValuePrev24,
         UserDataPrev_25.PThortName                            AS ValuePrev25,
         UserDataPrev_26.PThortName                            AS ValuePrev26,
         UserDataPrev_27.PThortName                            AS ValuePrev27,
         UserDataPrev_28.PThortName                            AS ValuePrev28,
         UserDataPrev_29.PThortName                            AS ValuePrev29,
         UserDataPrev_30.PThortName                            AS ValuePrev30,
         UserDataPrev_31.PThortName                            AS ValuePrev31,

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

         zc_Color_White()                     AS Color_CalcUser1,
         zc_Color_White()                     AS Color_CalcUser2,
         zc_Color_White()                     AS Color_CalcUser3,
         zc_Color_White()                     AS Color_CalcUser4,
         zc_Color_White()                     AS Color_CalcUser5,
         zc_Color_White()                     AS Color_CalcUser6,
         zc_Color_White()                     AS Color_CalcUser7,
         zc_Color_White()                     AS Color_CalcUser8,
         zc_Color_White()                     AS Color_CalcUser9,
         zc_Color_White()                     AS Color_CalcUser10,
         zc_Color_White()                     AS Color_CalcUser11,
         zc_Color_White()                     AS Color_CalcUser12,
         zc_Color_White()                     AS Color_CalcUser13,
         zc_Color_White()                     AS Color_CalcUser14,
         zc_Color_White()                     AS Color_CalcUser15,
         zc_Color_White()                     AS Color_CalcUser16,
         zc_Color_White()                     AS Color_CalcUser17,
         zc_Color_White()                     AS Color_CalcUser18,
         zc_Color_White()                     AS Color_CalcUser19,
         zc_Color_White()                     AS Color_CalcUser20,
         zc_Color_White()                     AS Color_CalcUser21,
         zc_Color_White()                     AS Color_CalcUser22,
         zc_Color_White()                     AS Color_CalcUser23,
         zc_Color_White()                     AS Color_CalcUser24,
         zc_Color_White()                     AS Color_CalcUser25,
         zc_Color_White()                     AS Color_CalcUser26,
         zc_Color_White()                     AS Color_CalcUser27,
         zc_Color_White()                     AS Color_CalcUser28,
         zc_Color_White()                     AS Color_CalcUser29,
         zc_Color_White()                     AS Color_CalcUser30,
         zc_Color_White()                     AS Color_CalcUser31,

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
       FROM Object AS Object_User

            LEFT JOIN ObjectBoolean AS ObjectBoolean_DismissedUser
                                    ON ObjectBoolean_DismissedUser.ObjectId = Object_User.Id
                                   AND ObjectBoolean_DismissedUser.DescId = zc_ObjectBoolean_User_DismissedUser()

            INNER JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            INNER JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

            INNER JOIN ObjectLink AS ObjectLink_Member_Position
                                 ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
            INNER JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId


            INNER JOIN ObjectLink AS ObjectLink_Member_Unit
                                 ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()
            INNER JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Member_Unit.ChildObjectId

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_01
                                      ON UserDataPrev_01.Day = 1
                                     AND UserDataPrev_01.UserID = Object_User.Id
                                     AND UserDataPrev_01.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_02
                                      ON UserDataPrev_02.Day = 2
                                     AND UserDataPrev_02.UserID = Object_User.Id
                                     AND UserDataPrev_02.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_03
                                      ON UserDataPrev_03.Day = 3
                                     AND UserDataPrev_03.UserID = Object_User.Id
                                     AND UserDataPrev_03.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_04
                                      ON UserDataPrev_04.Day = 4
                                     AND UserDataPrev_04.UserID = Object_User.Id
                                     AND UserDataPrev_04.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_05
                                      ON UserDataPrev_05.Day = 5
                                     AND UserDataPrev_05.UserID = Object_User.Id
                                     AND UserDataPrev_05.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_06
                                      ON UserDataPrev_06.Day = 6
                                     AND UserDataPrev_06.UserID = Object_User.Id
                                     AND UserDataPrev_06.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_07
                                      ON UserDataPrev_07.Day = 7
                                     AND UserDataPrev_07.UserID = Object_User.Id
                                     AND UserDataPrev_07.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_08
                                      ON UserDataPrev_08.Day = 8
                                     AND UserDataPrev_08.UserID = Object_User.Id
                                     AND UserDataPrev_08.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_09
                                      ON UserDataPrev_09.Day = 9
                                     AND UserDataPrev_09.UserID = Object_User.Id
                                     AND UserDataPrev_09.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_10
                                      ON UserDataPrev_10.Day = 10
                                     AND UserDataPrev_10.UserID = Object_User.Id
                                     AND UserDataPrev_10.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_11
                                      ON UserDataPrev_11.Day = 11
                                     AND UserDataPrev_11.UserID = Object_User.Id
                                     AND UserDataPrev_11.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_12
                                      ON UserDataPrev_12.Day = 12
                                     AND UserDataPrev_12.UserID = Object_User.Id
                                     AND UserDataPrev_12.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_13
                                      ON UserDataPrev_13.Day = 13
                                     AND UserDataPrev_13.UserID = Object_User.Id
                                     AND UserDataPrev_13.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_14
                                      ON UserDataPrev_14.Day = 14
                                     AND UserDataPrev_14.UserID = Object_User.Id
                                     AND UserDataPrev_14.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_15
                                      ON UserDataPrev_15.Day = 15
                                     AND UserDataPrev_15.UserID = Object_User.Id
                                     AND UserDataPrev_15.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_16
                                      ON UserDataPrev_16.Day = 16
                                     AND UserDataPrev_16.UserID = Object_User.Id
                                     AND UserDataPrev_16.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_17
                                      ON UserDataPrev_17.Day = 17
                                     AND UserDataPrev_17.UserID = Object_User.Id
                                     AND UserDataPrev_17.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_18
                                      ON UserDataPrev_18.Day = 18
                                     AND UserDataPrev_18.UserID = Object_User.Id
                                     AND UserDataPrev_18.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_19
                                      ON UserDataPrev_19.Day = 19
                                     AND UserDataPrev_19.UserID = Object_User.Id
                                     AND UserDataPrev_19.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_20
                                      ON UserDataPrev_20.Day = 20
                                     AND UserDataPrev_20.UserID = Object_User.Id
                                     AND UserDataPrev_20.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_21
                                      ON UserDataPrev_21.Day = 21
                                     AND UserDataPrev_21.UserID = Object_User.Id
                                     AND UserDataPrev_21.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_22
                                      ON UserDataPrev_22.Day = 22
                                     AND UserDataPrev_22.UserID = Object_User.Id
                                     AND UserDataPrev_22.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_23
                                      ON UserDataPrev_23.Day = 23
                                     AND UserDataPrev_23.UserID = Object_User.Id
                                     AND UserDataPrev_23.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_24
                                      ON UserDataPrev_24.Day = 24
                                     AND UserDataPrev_24.UserID = Object_User.Id
                                     AND UserDataPrev_24.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_25
                                      ON UserDataPrev_25.Day = 25
                                     AND UserDataPrev_25.UserID = Object_User.Id
                                     AND UserDataPrev_25.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_26
                                      ON UserDataPrev_26.Day = 26
                                     AND UserDataPrev_26.UserID = Object_User.Id
                                     AND UserDataPrev_26.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_27
                                      ON UserDataPrev_27.Day = 27
                                     AND UserDataPrev_27.UserID = Object_User.Id
                                     AND UserDataPrev_27.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_28
                                      ON UserDataPrev_28.Day = 28
                                     AND UserDataPrev_28.UserID = Object_User.Id
                                     AND UserDataPrev_28.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_29
                                      ON UserDataPrev_29.Day = 29
                                     AND UserDataPrev_29.UserID = Object_User.Id
                                     AND UserDataPrev_29.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_30
                                      ON UserDataPrev_30.Day = 30
                                     AND UserDataPrev_30.UserID = Object_User.Id
                                     AND UserDataPrev_30.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_31
                                      ON UserDataPrev_31.Day = 31
                                     AND UserDataPrev_31.UserID = Object_User.Id
                                     AND UserDataPrev_31.Ord = 1

       WHERE Object_User.ID NOT IN (SELECT MovementItem.ObjectId
                                    FROM MovementItem
                                    WHERE MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId = zc_MI_Master())
         AND Object_User.DescId = zc_Object_User()
         AND (Object_User.IsErased = FALSE OR inIsErased = TRUE)

       UNION ALL

       SELECT
         MovementItem.Id                                         AS ID,
         MovementItem.ObjectId                                   AS UserID,
         MovementItem.IsErased                                   AS IsErased,
         Object_Member.ObjectCode                                AS PersonalCode,
         COALESCE (Object_Member.ValueData, Object_User.ValueData) AS PersonalName,
         Object_Position.ValueData                               AS PositionName,
         CASE WHEN COALESCE (ObjectBoolean_DismissedUser.ValueData, FALSE) = TRUE
              THEN zfCalc_Color( 192, 192, 192)
              ELSE zc_Color_Black() END::Integer                 AS Color_DismissedUser,
         COALESCE (ObjectBoolean_DismissedUser.ValueData, FALSE)     AS isDismissedUser,
         Object_Unit.ID                                          AS UnitID,
         Object_Unit.ObjectCode                                  AS UnitCode,
         Object_Unit.ValueData                                   AS UnitName,
         'Пр. месяц'::TVarChar                                   AS Name0,
         'Тип дня'::TVarChar                                     AS Name1,
         'Приход'::TVarChar                                      AS Name2,
         'Уход'::TVarChar                                        AS Name3,

         UserData_01.ChildID                        AS ChildID1,
         UserData_02.ChildID                        AS ChildID2,
         UserData_03.ChildID                        AS ChildID3,
         UserData_04.ChildID                        AS ChildID4,
         UserData_05.ChildID                        AS ChildID5,
         UserData_06.ChildID                        AS ChildID6,
         UserData_07.ChildID                        AS ChildID7,
         UserData_08.ChildID                        AS ChildID8,
         UserData_09.ChildID                        AS ChildID9,
         UserData_10.ChildID                        AS ChildID10,
         UserData_11.ChildID                        AS ChildID11,
         UserData_12.ChildID                        AS ChildID12,
         UserData_13.ChildID                        AS ChildID13,
         UserData_14.ChildID                        AS ChildID14,
         UserData_15.ChildID                        AS ChildID15,
         UserData_16.ChildID                        AS ChildID16,
         UserData_17.ChildID                        AS ChildID17,
         UserData_18.ChildID                        AS ChildID18,
         UserData_19.ChildID                        AS ChildID19,
         UserData_20.ChildID                        AS ChildID20,
         UserData_21.ChildID                        AS ChildID21,
         UserData_22.ChildID                        AS ChildID22,
         UserData_23.ChildID                        AS ChildID23,
         UserData_24.ChildID                        AS ChildID24,
         UserData_25.ChildID                        AS ChildID25,
         UserData_26.ChildID                        AS ChildID26,
         UserData_27.ChildID                        AS ChildID27,
         UserData_28.ChildID                        AS ChildID28,
         UserData_29.ChildID                        AS ChildID29,
         UserData_30.ChildID                        AS ChildID30,
         UserData_31.ChildID                        AS ChildID31,

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

         UserDataPrev_01.PThortName                            AS ValuePrev1,
         UserDataPrev_02.PThortName                            AS ValuePrev2,
         UserDataPrev_03.PThortName                            AS ValuePrev3,
         UserDataPrev_04.PThortName                            AS ValuePrev4,
         UserDataPrev_05.PThortName                            AS ValuePrev5,
         UserDataPrev_06.PThortName                            AS ValuePrev6,
         UserDataPrev_07.PThortName                            AS ValuePrev7,
         UserDataPrev_08.PThortName                            AS ValuePrev8,
         UserDataPrev_09.PThortName                            AS ValuePrev9,
         UserDataPrev_10.PThortName                            AS ValuePrev10,
         UserDataPrev_11.PThortName                            AS ValuePrev11,
         UserDataPrev_12.PThortName                            AS ValuePrev12,
         UserDataPrev_13.PThortName                            AS ValuePrev13,
         UserDataPrev_14.PThortName                            AS ValuePrev14,
         UserDataPrev_15.PThortName                            AS ValuePrev15,
         UserDataPrev_16.PThortName                            AS ValuePrev16,
         UserDataPrev_17.PThortName                            AS ValuePrev17,
         UserDataPrev_18.PThortName                            AS ValuePrev18,
         UserDataPrev_19.PThortName                            AS ValuePrev19,
         UserDataPrev_20.PThortName                            AS ValuePrev20,
         UserDataPrev_21.PThortName                            AS ValuePrev21,
         UserDataPrev_22.PThortName                            AS ValuePrev22,
         UserDataPrev_23.PThortName                            AS ValuePrev23,
         UserDataPrev_24.PThortName                            AS ValuePrev24,
         UserDataPrev_25.PThortName                            AS ValuePrev25,
         UserDataPrev_26.PThortName                            AS ValuePrev26,
         UserDataPrev_27.PThortName                            AS ValuePrev27,
         UserDataPrev_28.PThortName                            AS ValuePrev28,
         UserDataPrev_29.PThortName                            AS ValuePrev29,
         UserDataPrev_30.PThortName                            AS ValuePrev30,
         UserDataPrev_31.PThortName                            AS ValuePrev31,

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

         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_01.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_01.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser1,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_02.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_02.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser2,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_03.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_03.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser3,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_04.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_04.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser4,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_05.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_05.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser5,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_06.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_06.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser6,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_07.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_07.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser7,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_08.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_08.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser8,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_09.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_09.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser9,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_10.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_10.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser10,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_11.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_11.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser11,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_12.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_12.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser12,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_13.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_13.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser13,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_14.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_14.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser14,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_15.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_15.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser15,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_16.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_16.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser16,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_17.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_17.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser17,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_18.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_18.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser18,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_19.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_19.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser19,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_20.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_20.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser20,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_21.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_21.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser21,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_22.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_22.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser22,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_23.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_23.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser23,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_24.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_24.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser24,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_25.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_25.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser25,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_26.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_26.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser26,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_27.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_27.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser27,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_28.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_28.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser28,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_29.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_29.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser29,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_30.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_30.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser30,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_31.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_31.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser31,

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
         zc_Color_White()                                        AS Color_Calc31

       FROM Movement

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                   AND MovementItem.DescId = zc_MI_Master()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementItem.ObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_DismissedUser
                                    ON ObjectBoolean_DismissedUser.ObjectId = MovementItem.ObjectId
                                   AND ObjectBoolean_DismissedUser.DescId = zc_ObjectBoolean_User_DismissedUser()

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                 ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                 ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE(MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId)

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_Member_Unit.ChildObjectId
                                AND ObjectLink_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

            LEFT JOIN tmpUserData AS UserData_01
                                  ON UserData_01.Day = 1
                                 AND UserData_01.ID = MovementItem.Id
                                 AND UserData_01.Ord = 1

            LEFT JOIN tmpUserData AS UserData_02
                                  ON UserData_02.Day = 2
                                 AND UserData_02.ID = MovementItem.Id
                                 AND UserData_02.Ord = 1

            LEFT JOIN tmpUserData AS UserData_03
                                  ON UserData_03.Day = 3
                                 AND UserData_03.ID = MovementItem.Id
                                 AND UserData_03.Ord = 1

            LEFT JOIN tmpUserData AS UserData_04
                                  ON UserData_04.Day = 4
                                 AND UserData_04.ID = MovementItem.Id
                                 AND UserData_04.Ord = 1

            LEFT JOIN tmpUserData AS UserData_05
                                  ON UserData_05.Day = 5
                                 AND UserData_05.ID = MovementItem.Id
                                 AND UserData_05.Ord = 1

            LEFT JOIN tmpUserData AS UserData_06
                                  ON UserData_06.Day = 6
                                 AND UserData_06.ID = MovementItem.Id
                                 AND UserData_06.Ord = 1

            LEFT JOIN tmpUserData AS UserData_07
                                  ON UserData_07.Day = 7
                                 AND UserData_07.ID = MovementItem.Id
                                 AND UserData_07.Ord = 1

            LEFT JOIN tmpUserData AS UserData_08
                                  ON UserData_08.Day = 8
                                 AND UserData_08.ID = MovementItem.Id
                                 AND UserData_08.Ord = 1

            LEFT JOIN tmpUserData AS UserData_09
                                  ON UserData_09.Day = 9
                                 AND UserData_09.ID = MovementItem.Id
                                 AND UserData_09.Ord = 1

            LEFT JOIN tmpUserData AS UserData_10
                                  ON UserData_10.Day = 10
                                 AND UserData_10.ID = MovementItem.Id
                                 AND UserData_10.Ord = 1

            LEFT JOIN tmpUserData AS UserData_11
                                  ON UserData_11.Day = 11
                                 AND UserData_11.ID = MovementItem.Id
                                 AND UserData_11.Ord = 1

            LEFT JOIN tmpUserData AS UserData_12
                                  ON UserData_12.Day = 12
                                 AND UserData_12.ID = MovementItem.Id
                                 AND UserData_12.Ord = 1

            LEFT JOIN tmpUserData AS UserData_13
                                  ON UserData_13.Day = 13
                                 AND UserData_13.ID = MovementItem.Id
                                 AND UserData_13.Ord = 1

            LEFT JOIN tmpUserData AS UserData_14
                                  ON UserData_14.Day = 14
                                 AND UserData_14.ID = MovementItem.Id
                                 AND UserData_14.Ord = 1

            LEFT JOIN tmpUserData AS UserData_15
                                  ON UserData_15.Day = 15
                                 AND UserData_15.ID = MovementItem.Id
                                 AND UserData_15.Ord = 1

            LEFT JOIN tmpUserData AS UserData_16
                                  ON UserData_16.Day = 16
                                 AND UserData_16.ID = MovementItem.Id
                                 AND UserData_16.Ord = 1

            LEFT JOIN tmpUserData AS UserData_17
                                  ON UserData_17.Day = 17
                                 AND UserData_17.ID = MovementItem.Id
                                 AND UserData_17.Ord = 1

            LEFT JOIN tmpUserData AS UserData_18
                                  ON UserData_18.Day = 18
                                 AND UserData_18.ID = MovementItem.Id
                                 AND UserData_18.Ord = 1

            LEFT JOIN tmpUserData AS UserData_19
                                  ON UserData_19.Day = 19
                                 AND UserData_19.ID = MovementItem.Id
                                 AND UserData_19.Ord = 1

            LEFT JOIN tmpUserData AS UserData_20
                                  ON UserData_20.Day = 20
                                 AND UserData_20.ID = MovementItem.Id
                                 AND UserData_20.Ord = 1

            LEFT JOIN tmpUserData AS UserData_21
                                  ON UserData_21.Day = 21
                                 AND UserData_21.ID = MovementItem.Id
                                 AND UserData_21.Ord = 1

            LEFT JOIN tmpUserData AS UserData_22
                                  ON UserData_22.Day = 22
                                 AND UserData_22.ID = MovementItem.Id
                                 AND UserData_22.Ord = 1

            LEFT JOIN tmpUserData AS UserData_23
                                  ON UserData_23.Day = 23
                                 AND UserData_23.ID = MovementItem.Id
                                 AND UserData_23.Ord = 1

            LEFT JOIN tmpUserData AS UserData_24
                                  ON UserData_24.Day = 24
                                 AND UserData_24.ID = MovementItem.Id
                                 AND UserData_24.Ord = 1

            LEFT JOIN tmpUserData AS UserData_25
                                  ON UserData_25.Day = 25
                                 AND UserData_25.ID = MovementItem.Id
                                 AND UserData_25.Ord = 1

            LEFT JOIN tmpUserData AS UserData_26
                                  ON UserData_26.Day = 26
                                 AND UserData_26.ID = MovementItem.Id
                                 AND UserData_26.Ord = 1

            LEFT JOIN tmpUserData AS UserData_27
                                  ON UserData_27.Day = 27
                                 AND UserData_27.ID = MovementItem.Id
                                 AND UserData_27.Ord = 1

            LEFT JOIN tmpUserData AS UserData_28
                                  ON UserData_28.Day = 28
                                 AND UserData_28.ID = MovementItem.Id
                                 AND UserData_28.Ord = 1

            LEFT JOIN tmpUserData AS UserData_29
                                  ON UserData_29.Day = 29
                                 AND UserData_29.ID = MovementItem.Id
                                 AND UserData_29.Ord = 1

            LEFT JOIN tmpUserData AS UserData_30
                                  ON UserData_30.Day = 30
                                 AND UserData_30.ID = MovementItem.Id
                                 AND UserData_30.Ord = 1

            LEFT JOIN tmpUserData AS UserData_31
                                  ON UserData_31.Day = 31
                                 AND UserData_31.ID = MovementItem.Id
                                 AND UserData_31.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_01
                                      ON UserDataPrev_01.Day = 1
                                     AND UserDataPrev_01.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_01.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_02
                                      ON UserDataPrev_02.Day = 2
                                     AND UserDataPrev_02.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_02.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_03
                                      ON UserDataPrev_03.Day = 3
                                     AND UserDataPrev_03.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_03.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_04
                                      ON UserDataPrev_04.Day = 4
                                     AND UserDataPrev_04.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_04.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_05
                                      ON UserDataPrev_05.Day = 5
                                     AND UserDataPrev_05.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_05.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_06
                                      ON UserDataPrev_06.Day = 6
                                     AND UserDataPrev_06.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_06.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_07
                                      ON UserDataPrev_07.Day = 7
                                     AND UserDataPrev_07.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_07.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_08
                                      ON UserDataPrev_08.Day = 8
                                     AND UserDataPrev_08.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_08.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_09
                                      ON UserDataPrev_09.Day = 9
                                     AND UserDataPrev_09.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_09.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_10
                                      ON UserDataPrev_10.Day = 10
                                     AND UserDataPrev_10.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_10.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_11
                                      ON UserDataPrev_11.Day = 11
                                     AND UserDataPrev_11.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_11.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_12
                                      ON UserDataPrev_12.Day = 12
                                     AND UserDataPrev_12.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_12.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_13
                                      ON UserDataPrev_13.Day = 13
                                     AND UserDataPrev_13.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_13.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_14
                                      ON UserDataPrev_14.Day = 14
                                     AND UserDataPrev_14.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_14.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_15
                                      ON UserDataPrev_15.Day = 15
                                     AND UserDataPrev_15.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_15.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_16
                                      ON UserDataPrev_16.Day = 16
                                     AND UserDataPrev_16.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_16.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_17
                                      ON UserDataPrev_17.Day = 17
                                     AND UserDataPrev_17.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_17.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_18
                                      ON UserDataPrev_18.Day = 18
                                     AND UserDataPrev_18.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_18.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_19
                                      ON UserDataPrev_19.Day = 19
                                     AND UserDataPrev_19.UserID = Object_User.Id
                                     AND UserDataPrev_19.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_20
                                      ON UserDataPrev_20.Day = 20
                                     AND UserDataPrev_20.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_20.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_21
                                      ON UserDataPrev_21.Day = 21
                                     AND UserDataPrev_21.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_21.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_22
                                      ON UserDataPrev_22.Day = 22
                                     AND UserDataPrev_22.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_22.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_23
                                      ON UserDataPrev_23.Day = 23
                                     AND UserDataPrev_23.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_23.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_24
                                      ON UserDataPrev_24.Day = 24
                                     AND UserDataPrev_24.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_24.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_25
                                      ON UserDataPrev_25.Day = 25
                                     AND UserDataPrev_25.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_25.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_26
                                      ON UserDataPrev_26.Day = 26
                                     AND UserDataPrev_26.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_26.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_27
                                      ON UserDataPrev_27.Day = 27
                                     AND UserDataPrev_27.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_27.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_28
                                      ON UserDataPrev_28.Day = 28
                                     AND UserDataPrev_28.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_28.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_29
                                      ON UserDataPrev_29.Day = 29
                                     AND UserDataPrev_29.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_29.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_30
                                      ON UserDataPrev_30.Day = 30
                                     AND UserDataPrev_30.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_30.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_31
                                      ON UserDataPrev_31.Day = 31
                                     AND UserDataPrev_31.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_31.Ord = 1

       WHERE Movement.ID = inMovementId
         AND (MovementItem.IsErased = FALSE OR inIsErased = TRUE);
     ELSE
       OPEN cur3 FOR
       SELECT
         MovementItem.Id                                         AS ID,
         MovementItem.ObjectId                                   AS UserID,
         MovementItem.IsErased                                   AS IsErased,
         Object_Member.ObjectCode                                AS PersonalCode,
         COALESCE (Object_Member.ValueData, Object_User.ValueData) AS PersonalName,
         Object_Position.ValueData                               AS PositionName,
         CASE WHEN COALESCE (ObjectBoolean_DismissedUser.ValueData, FALSE) = TRUE
              THEN zfCalc_Color( 192, 192, 192)
              ELSE zc_Color_Black() END::Integer                 AS Color_DismissedUser,
         COALESCE (ObjectBoolean_DismissedUser.ValueData, FALSE)     AS isDismissedUser,
         Object_Unit.ID                                          AS UnitID,
         Object_Unit.ObjectCode                                  AS UnitCode,
         Object_Unit.ValueData                                   AS UnitName,
         'Пр. месяц'::TVarChar                                   AS Name0,
         'Тип дня'::TVarChar                                     AS Name1,
         'Приход'::TVarChar                                      AS Name2,
         'Уход'::TVarChar                                        AS Name3,

         UserData_01.ChildID                        AS ChildID1,
         UserData_02.ChildID                        AS ChildID2,
         UserData_03.ChildID                        AS ChildID3,
         UserData_04.ChildID                        AS ChildID4,
         UserData_05.ChildID                        AS ChildID5,
         UserData_06.ChildID                        AS ChildID6,
         UserData_07.ChildID                        AS ChildID7,
         UserData_08.ChildID                        AS ChildID8,
         UserData_09.ChildID                        AS ChildID9,
         UserData_10.ChildID                        AS ChildID10,
         UserData_11.ChildID                        AS ChildID11,
         UserData_12.ChildID                        AS ChildID12,
         UserData_13.ChildID                        AS ChildID13,
         UserData_14.ChildID                        AS ChildID14,
         UserData_15.ChildID                        AS ChildID15,
         UserData_16.ChildID                        AS ChildID16,
         UserData_17.ChildID                        AS ChildID17,
         UserData_18.ChildID                        AS ChildID18,
         UserData_19.ChildID                        AS ChildID19,
         UserData_20.ChildID                        AS ChildID20,
         UserData_21.ChildID                        AS ChildID21,
         UserData_22.ChildID                        AS ChildID22,
         UserData_23.ChildID                        AS ChildID23,
         UserData_24.ChildID                        AS ChildID24,
         UserData_25.ChildID                        AS ChildID25,
         UserData_26.ChildID                        AS ChildID26,
         UserData_27.ChildID                        AS ChildID27,
         UserData_28.ChildID                        AS ChildID28,
         UserData_29.ChildID                        AS ChildID29,
         UserData_30.ChildID                        AS ChildID30,
         UserData_31.ChildID                        AS ChildID31,

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

         UserDataPrev_01.PThortName                            AS ValuePrev1,
         UserDataPrev_02.PThortName                            AS ValuePrev2,
         UserDataPrev_03.PThortName                            AS ValuePrev3,
         UserDataPrev_04.PThortName                            AS ValuePrev4,
         UserDataPrev_05.PThortName                            AS ValuePrev5,
         UserDataPrev_06.PThortName                            AS ValuePrev6,
         UserDataPrev_07.PThortName                            AS ValuePrev7,
         UserDataPrev_08.PThortName                            AS ValuePrev8,
         UserDataPrev_09.PThortName                            AS ValuePrev9,
         UserDataPrev_10.PThortName                            AS ValuePrev10,
         UserDataPrev_11.PThortName                            AS ValuePrev11,
         UserDataPrev_12.PThortName                            AS ValuePrev12,
         UserDataPrev_13.PThortName                            AS ValuePrev13,
         UserDataPrev_14.PThortName                            AS ValuePrev14,
         UserDataPrev_15.PThortName                            AS ValuePrev15,
         UserDataPrev_16.PThortName                            AS ValuePrev16,
         UserDataPrev_17.PThortName                            AS ValuePrev17,
         UserDataPrev_18.PThortName                            AS ValuePrev18,
         UserDataPrev_19.PThortName                            AS ValuePrev19,
         UserDataPrev_20.PThortName                            AS ValuePrev20,
         UserDataPrev_21.PThortName                            AS ValuePrev21,
         UserDataPrev_22.PThortName                            AS ValuePrev22,
         UserDataPrev_23.PThortName                            AS ValuePrev23,
         UserDataPrev_24.PThortName                            AS ValuePrev24,
         UserDataPrev_25.PThortName                            AS ValuePrev25,
         UserDataPrev_26.PThortName                            AS ValuePrev26,
         UserDataPrev_27.PThortName                            AS ValuePrev27,
         UserDataPrev_28.PThortName                            AS ValuePrev28,
         UserDataPrev_29.PThortName                            AS ValuePrev29,
         UserDataPrev_30.PThortName                            AS ValuePrev30,
         UserDataPrev_31.PThortName                            AS ValuePrev31,

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

         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_01.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_01.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser1,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_02.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_02.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser2,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_03.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_03.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser3,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_04.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_04.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser4,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_05.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_05.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser5,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_06.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_06.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser6,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_07.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_07.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser7,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_08.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_08.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser8,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_09.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_09.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser9,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_10.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_10.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser10,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_11.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_11.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser11,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_12.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_12.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser12,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_13.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_13.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser13,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_14.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_14.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser14,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_15.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_15.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser15,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_16.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_16.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser16,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_17.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_17.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser17,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_18.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_18.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser18,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_19.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_19.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser19,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_20.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_20.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser20,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_21.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_21.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser21,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_22.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_22.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser22,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_23.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_23.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser23,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_24.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_24.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser24,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_25.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_25.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser25,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_26.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_26.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser26,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_27.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_27.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser27,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_28.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_28.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser28,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_29.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_29.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser29,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_30.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_30.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser30,
         CASE WHEN COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4) <> 4 THEN 12903679
              WHEN COALESCE(UserData_31.ID, 0) = 0 THEN zc_Color_White()
              WHEN COALESCE(UserData_31.MainUnit, False) = TRUE THEN zc_Color_Yelow() ELSE 65407 END AS Color_CalcUser31,

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
         zc_Color_White()                                        AS Color_Calc31

       FROM Movement

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                   AND MovementItem.DescId = zc_MI_Master()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementItem.ObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_DismissedUser
                                    ON ObjectBoolean_DismissedUser.ObjectId = MovementItem.ObjectId
                                   AND ObjectBoolean_DismissedUser.DescId = zc_ObjectBoolean_User_DismissedUser()

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                 ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                 ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE(MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId)

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_Member_Unit.ChildObjectId
                                AND ObjectLink_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

            LEFT JOIN tmpUserData AS UserData_01
                                  ON UserData_01.Day = 1
                                 AND UserData_01.ID = MovementItem.Id
                                 AND UserData_01.Ord = 1

            LEFT JOIN tmpUserData AS UserData_02
                                  ON UserData_02.Day = 2
                                 AND UserData_02.ID = MovementItem.Id
                                 AND UserData_02.Ord = 1

            LEFT JOIN tmpUserData AS UserData_03
                                  ON UserData_03.Day = 3
                                 AND UserData_03.ID = MovementItem.Id
                                 AND UserData_03.Ord = 1

            LEFT JOIN tmpUserData AS UserData_04
                                  ON UserData_04.Day = 4
                                 AND UserData_04.ID = MovementItem.Id
                                 AND UserData_04.Ord = 1

            LEFT JOIN tmpUserData AS UserData_05
                                  ON UserData_05.Day = 5
                                 AND UserData_05.ID = MovementItem.Id
                                 AND UserData_05.Ord = 1

            LEFT JOIN tmpUserData AS UserData_06
                                  ON UserData_06.Day = 6
                                 AND UserData_06.ID = MovementItem.Id
                                 AND UserData_06.Ord = 1

            LEFT JOIN tmpUserData AS UserData_07
                                  ON UserData_07.Day = 7
                                 AND UserData_07.ID = MovementItem.Id
                                 AND UserData_07.Ord = 1

            LEFT JOIN tmpUserData AS UserData_08
                                  ON UserData_08.Day = 8
                                 AND UserData_08.ID = MovementItem.Id
                                 AND UserData_08.Ord = 1

            LEFT JOIN tmpUserData AS UserData_09
                                  ON UserData_09.Day = 9
                                 AND UserData_09.ID = MovementItem.Id
                                 AND UserData_09.Ord = 1

            LEFT JOIN tmpUserData AS UserData_10
                                  ON UserData_10.Day = 10
                                 AND UserData_10.ID = MovementItem.Id
                                 AND UserData_10.Ord = 1

            LEFT JOIN tmpUserData AS UserData_11
                                  ON UserData_11.Day = 11
                                 AND UserData_11.ID = MovementItem.Id
                                 AND UserData_11.Ord = 1

            LEFT JOIN tmpUserData AS UserData_12
                                  ON UserData_12.Day = 12
                                 AND UserData_12.ID = MovementItem.Id
                                 AND UserData_12.Ord = 1

            LEFT JOIN tmpUserData AS UserData_13
                                  ON UserData_13.Day = 13
                                 AND UserData_13.ID = MovementItem.Id
                                 AND UserData_13.Ord = 1

            LEFT JOIN tmpUserData AS UserData_14
                                  ON UserData_14.Day = 14
                                 AND UserData_14.ID = MovementItem.Id
                                 AND UserData_14.Ord = 1

            LEFT JOIN tmpUserData AS UserData_15
                                  ON UserData_15.Day = 15
                                 AND UserData_15.ID = MovementItem.Id
                                 AND UserData_15.Ord = 1

            LEFT JOIN tmpUserData AS UserData_16
                                  ON UserData_16.Day = 16
                                 AND UserData_16.ID = MovementItem.Id
                                 AND UserData_16.Ord = 1

            LEFT JOIN tmpUserData AS UserData_17
                                  ON UserData_17.Day = 17
                                 AND UserData_17.ID = MovementItem.Id
                                 AND UserData_17.Ord = 1

            LEFT JOIN tmpUserData AS UserData_18
                                  ON UserData_18.Day = 18
                                 AND UserData_18.ID = MovementItem.Id
                                 AND UserData_18.Ord = 1

            LEFT JOIN tmpUserData AS UserData_19
                                  ON UserData_19.Day = 19
                                 AND UserData_19.ID = MovementItem.Id
                                 AND UserData_19.Ord = 1

            LEFT JOIN tmpUserData AS UserData_20
                                  ON UserData_20.Day = 20
                                 AND UserData_20.ID = MovementItem.Id
                                 AND UserData_20.Ord = 1

            LEFT JOIN tmpUserData AS UserData_21
                                  ON UserData_21.Day = 21
                                 AND UserData_21.ID = MovementItem.Id
                                 AND UserData_21.Ord = 1

            LEFT JOIN tmpUserData AS UserData_22
                                  ON UserData_22.Day = 22
                                 AND UserData_22.ID = MovementItem.Id
                                 AND UserData_22.Ord = 1

            LEFT JOIN tmpUserData AS UserData_23
                                  ON UserData_23.Day = 23
                                 AND UserData_23.ID = MovementItem.Id
                                 AND UserData_23.Ord = 1

            LEFT JOIN tmpUserData AS UserData_24
                                  ON UserData_24.Day = 24
                                 AND UserData_24.ID = MovementItem.Id
                                 AND UserData_24.Ord = 1

            LEFT JOIN tmpUserData AS UserData_25
                                  ON UserData_25.Day = 25
                                 AND UserData_25.ID = MovementItem.Id
                                 AND UserData_25.Ord = 1

            LEFT JOIN tmpUserData AS UserData_26
                                  ON UserData_26.Day = 26
                                 AND UserData_26.ID = MovementItem.Id
                                 AND UserData_26.Ord = 1

            LEFT JOIN tmpUserData AS UserData_27
                                  ON UserData_27.Day = 27
                                 AND UserData_27.ID = MovementItem.Id
                                 AND UserData_27.Ord = 1

            LEFT JOIN tmpUserData AS UserData_28
                                  ON UserData_28.Day = 28
                                 AND UserData_28.ID = MovementItem.Id
                                 AND UserData_28.Ord = 1

            LEFT JOIN tmpUserData AS UserData_29
                                  ON UserData_29.Day = 29
                                 AND UserData_29.ID = MovementItem.Id
                                 AND UserData_29.Ord = 1

            LEFT JOIN tmpUserData AS UserData_30
                                  ON UserData_30.Day = 30
                                 AND UserData_30.ID = MovementItem.Id
                                 AND UserData_30.Ord = 1

            LEFT JOIN tmpUserData AS UserData_31
                                  ON UserData_31.Day = 31
                                 AND UserData_31.ID = MovementItem.Id
                                 AND UserData_31.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_01
                                      ON UserDataPrev_01.Day = 1
                                     AND UserDataPrev_01.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_01.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_02
                                      ON UserDataPrev_02.Day = 2
                                     AND UserDataPrev_02.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_02.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_03
                                      ON UserDataPrev_03.Day = 3
                                     AND UserDataPrev_03.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_03.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_04
                                      ON UserDataPrev_04.Day = 4
                                     AND UserDataPrev_04.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_04.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_05
                                      ON UserDataPrev_05.Day = 5
                                     AND UserDataPrev_05.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_05.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_06
                                      ON UserDataPrev_06.Day = 6
                                     AND UserDataPrev_06.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_06.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_07
                                      ON UserDataPrev_07.Day = 7
                                     AND UserDataPrev_07.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_07.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_08
                                      ON UserDataPrev_08.Day = 8
                                     AND UserDataPrev_08.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_08.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_09
                                      ON UserDataPrev_09.Day = 9
                                     AND UserDataPrev_09.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_09.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_10
                                      ON UserDataPrev_10.Day = 10
                                     AND UserDataPrev_10.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_10.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_11
                                      ON UserDataPrev_11.Day = 11
                                     AND UserDataPrev_11.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_11.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_12
                                      ON UserDataPrev_12.Day = 12
                                     AND UserDataPrev_12.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_12.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_13
                                      ON UserDataPrev_13.Day = 13
                                     AND UserDataPrev_13.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_13.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_14
                                      ON UserDataPrev_14.Day = 14
                                     AND UserDataPrev_14.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_14.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_15
                                      ON UserDataPrev_15.Day = 15
                                     AND UserDataPrev_15.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_15.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_16
                                      ON UserDataPrev_16.Day = 16
                                     AND UserDataPrev_16.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_16.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_17
                                      ON UserDataPrev_17.Day = 17
                                     AND UserDataPrev_17.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_17.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_18
                                      ON UserDataPrev_18.Day = 18
                                     AND UserDataPrev_18.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_18.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_19
                                      ON UserDataPrev_19.Day = 19
                                     AND UserDataPrev_19.UserID = Object_User.Id
                                     AND UserDataPrev_19.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_20
                                      ON UserDataPrev_20.Day = 20
                                     AND UserDataPrev_20.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_20.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_21
                                      ON UserDataPrev_21.Day = 21
                                     AND UserDataPrev_21.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_21.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_22
                                      ON UserDataPrev_22.Day = 22
                                     AND UserDataPrev_22.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_22.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_23
                                      ON UserDataPrev_23.Day = 23
                                     AND UserDataPrev_23.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_23.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_24
                                      ON UserDataPrev_24.Day = 24
                                     AND UserDataPrev_24.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_24.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_25
                                      ON UserDataPrev_25.Day = 25
                                     AND UserDataPrev_25.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_25.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_26
                                      ON UserDataPrev_26.Day = 26
                                     AND UserDataPrev_26.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_26.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_27
                                      ON UserDataPrev_27.Day = 27
                                     AND UserDataPrev_27.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_27.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_28
                                      ON UserDataPrev_28.Day = 28
                                     AND UserDataPrev_28.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_28.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_29
                                      ON UserDataPrev_29.Day = 29
                                     AND UserDataPrev_29.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_29.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_30
                                      ON UserDataPrev_30.Day = 30
                                     AND UserDataPrev_30.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_30.Ord = 1

            LEFT JOIN tmpUserDataPrev AS UserDataPrev_31
                                      ON UserDataPrev_31.Day = 31
                                     AND UserDataPrev_31.UserID = MovementItem.ObjectId
                                     AND UserDataPrev_31.Ord = 1

       WHERE Movement.ID = inMovementId
         AND (MovementItem.IsErased = FALSE OR inIsErased = TRUE);
     END IF;

     RETURN NEXT cur3;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_EmployeeScheduleNew (Integer, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.03.19                                                       *
 08.12.18                                                       *
*/

-- тест
-- select * from gpSelect_MovementItem_EmployeeScheduleNew(inMovementId := 15869657 , inDate := ('01.10.2019')::TDateTime , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');

select * from gpSelect_MovementItem_EmployeeScheduleNew(inMovementId := 17692072 , inDate := ('01.08.2020')::TDateTime , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');