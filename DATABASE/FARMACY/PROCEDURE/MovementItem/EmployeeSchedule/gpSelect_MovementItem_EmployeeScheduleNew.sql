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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     
     inDate := DATE_TRUNC ('MONTH', inDate);

     CREATE TEMP TABLE tmpUserData ON COMMIT DROP AS
     SELECT MIMaster.ID                                                                  AS ID
          , MIMaster.ObjectId                                                            AS UserID
          , (COALESCE(MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId) =
            COALESCE(MIChild.ObjectId, ObjectLink_Member_Unit.ChildObjectId))::Boolean   AS MainUnit
          , MIChild.ObjectId                                                             AS UnitID
          , MIChild.Amount                                                               AS Day
          , MILinkObject_PayrollType.ObjectId                                            AS PayrollTypeID
          , PayrollType_ShortName.ValueData                                              AS PThortName
          , TO_CHAR(MIDate_Start.ValueData, 'HH24:mi')                                   AS TimeStart
          , TO_CHAR(MIDate_End.ValueData, 'HH24:mi')                                     AS TimeEnd
          , NULL::TVarChar                                                               AS PThortNamePrev
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

     WHERE Movement.ID = inMovementId;

     ANALYSE tmpUserData;

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
         Object_Unit.ID                                          AS UnitID,
         Object_Unit.ObjectCode                                  AS UnitCode,
         Object_Unit.ValueData                                   AS UnitName,

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

         UserData_01.PThortNamePrev                        AS ValuePrev1,
         UserData_02.PThortNamePrev                        AS ValuePrev2,
         UserData_03.PThortNamePrev                        AS ValuePrev3,
         UserData_04.PThortNamePrev                        AS ValuePrev4,
         UserData_05.PThortNamePrev                        AS ValuePrev5,
         UserData_06.PThortNamePrev                        AS ValuePrev6,
         UserData_07.PThortNamePrev                        AS ValuePrev7,
         UserData_08.PThortNamePrev                        AS ValuePrev8,
         UserData_09.PThortNamePrev                        AS ValuePrev9,
         UserData_10.PThortNamePrev                        AS ValuePrev10,
         UserData_11.PThortNamePrev                        AS ValuePrev11,
         UserData_12.PThortNamePrev                        AS ValuePrev12,
         UserData_13.PThortNamePrev                        AS ValuePrev13,
         UserData_14.PThortNamePrev                        AS ValuePrev14,
         UserData_15.PThortNamePrev                        AS ValuePrev15,
         UserData_16.PThortNamePrev                        AS ValuePrev16,
         UserData_17.PThortNamePrev                        AS ValuePrev17,
         UserData_18.PThortNamePrev                        AS ValuePrev18,
         UserData_19.PThortNamePrev                        AS ValuePrev19,
         UserData_20.PThortNamePrev                        AS ValuePrev20,
         UserData_21.PThortNamePrev                        AS ValuePrev21,
         UserData_22.PThortNamePrev                        AS ValuePrev22,
         UserData_23.PThortNamePrev                        AS ValuePrev23,
         UserData_24.PThortNamePrev                        AS ValuePrev24,
         UserData_25.PThortNamePrev                        AS ValuePrev25,
         UserData_26.PThortNamePrev                        AS ValuePrev26,
         UserData_27.PThortNamePrev                        AS ValuePrev27,
         UserData_28.PThortNamePrev                        AS ValuePrev28,
         UserData_29.PThortNamePrev                        AS ValuePrev29,
         UserData_30.PThortNamePrev                        AS ValuePrev30,
         UserData_31.PThortNamePrev                        AS ValuePrev31,

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

            LEFT JOIN tmpUserData AS UserData_01
                                  ON UserData_01.Day = 1
                                  AND UserData_01.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_02
                                   ON UserData_02.Day = 2
                                  AND UserData_02.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_03
                                   ON UserData_03.Day = 3
                                  AND UserData_03.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_04
                                   ON UserData_04.Day = 4
                                  AND UserData_04.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_05
                                   ON UserData_05.Day = 5
                                  AND UserData_05.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_06
                                   ON UserData_06.Day = 6
                                  AND UserData_06.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_07
                                   ON UserData_07.Day = 7
                                  AND UserData_07.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_08
                                   ON UserData_08.Day = 8
                                  AND UserData_08.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_09
                                   ON UserData_09.Day = 9
                                  AND UserData_09.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_10
                                   ON UserData_10.Day = 10
                                  AND UserData_10.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_11
                                   ON UserData_11.Day = 11
                                  AND UserData_11.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_12
                                   ON UserData_12.Day = 12
                                  AND UserData_12.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_13
                                   ON UserData_13.Day = 13
                                  AND UserData_13.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_14
                                   ON UserData_14.Day = 14
                                  AND UserData_14.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_15
                                   ON UserData_15.Day = 15
                                  AND UserData_15.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_16
                                   ON UserData_16.Day = 16
                                  AND UserData_16.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_17
                                   ON UserData_17.Day = 17
                                  AND UserData_17.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_18
                                   ON UserData_18.Day = 18
                                  AND UserData_18.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_19
                                   ON UserData_19.Day = 19
                                  AND UserData_19.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_20
                                   ON UserData_20.Day = 20
                                  AND UserData_20.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_21
                                   ON UserData_21.Day = 21
                                  AND UserData_21.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_22
                                   ON UserData_22.Day = 22
                                  AND UserData_22.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_23
                                   ON UserData_23.Day = 23
                                  AND UserData_23.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_24
                                   ON UserData_24.Day = 24
                                  AND UserData_24.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_25
                                   ON UserData_25.Day = 25
                                  AND UserData_25.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_26
                                   ON UserData_26.Day = 26
                                  AND UserData_26.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_27
                                   ON UserData_27.Day = 27
                                  AND UserData_27.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_28
                                   ON UserData_28.Day = 28
                                  AND UserData_28.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_29
                                   ON UserData_29.Day = 29
                                  AND UserData_29.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_30
                                   ON UserData_30.Day = 30
                                  AND UserData_30.UserID = Object_User.Id

            LEFT JOIN tmpUserData AS UserData_31
                                   ON UserData_31.Day = 31
                                  AND UserData_31.UserID = Object_User.Id

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
         Object_Unit.ID                                          AS UnitID,
         Object_Unit.ObjectCode                                  AS UnitCode,
         Object_Unit.ValueData                                   AS UnitName,
         'Пр. месяц'::TVarChar                                   AS Name0,
         'Тип дня'::TVarChar                                     AS Name1,
         'Приход'::TVarChar                                      AS Name2,
         'Уход'::TVarChar                                        AS Name3,

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

         UserData_01.PThortNamePrev                        AS ValuePrev1,
         UserData_02.PThortNamePrev                        AS ValuePrev2,
         UserData_03.PThortNamePrev                        AS ValuePrev3,
         UserData_04.PThortNamePrev                        AS ValuePrev4,
         UserData_05.PThortNamePrev                        AS ValuePrev5,
         UserData_06.PThortNamePrev                        AS ValuePrev6,
         UserData_07.PThortNamePrev                        AS ValuePrev7,
         UserData_08.PThortNamePrev                        AS ValuePrev8,
         UserData_09.PThortNamePrev                        AS ValuePrev9,
         UserData_10.PThortNamePrev                        AS ValuePrev10,
         UserData_11.PThortNamePrev                        AS ValuePrev11,
         UserData_12.PThortNamePrev                        AS ValuePrev12,
         UserData_13.PThortNamePrev                        AS ValuePrev13,
         UserData_14.PThortNamePrev                        AS ValuePrev14,
         UserData_15.PThortNamePrev                        AS ValuePrev15,
         UserData_16.PThortNamePrev                        AS ValuePrev16,
         UserData_17.PThortNamePrev                        AS ValuePrev17,
         UserData_18.PThortNamePrev                        AS ValuePrev18,
         UserData_19.PThortNamePrev                        AS ValuePrev19,
         UserData_20.PThortNamePrev                        AS ValuePrev20,
         UserData_21.PThortNamePrev                        AS ValuePrev21,
         UserData_22.PThortNamePrev                        AS ValuePrev22,
         UserData_23.PThortNamePrev                        AS ValuePrev23,
         UserData_24.PThortNamePrev                        AS ValuePrev24,
         UserData_25.PThortNamePrev                        AS ValuePrev25,
         UserData_26.PThortNamePrev                        AS ValuePrev26,
         UserData_27.PThortNamePrev                        AS ValuePrev27,
         UserData_28.PThortNamePrev                        AS ValuePrev28,
         UserData_29.PThortNamePrev                        AS ValuePrev29,
         UserData_30.PThortNamePrev                        AS ValuePrev30,
         UserData_31.PThortNamePrev                        AS ValuePrev31,

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
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Member_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_Member_Unit.ChildObjectId
                                AND ObjectLink_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

            LEFT JOIN tmpUserData AS UserData_01
                                  ON UserData_01.Day = 1
                                  AND UserData_01.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_02
                                   ON UserData_02.Day = 2
                                  AND UserData_02.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_03
                                   ON UserData_03.Day = 3
                                  AND UserData_03.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_04
                                   ON UserData_04.Day = 4
                                  AND UserData_04.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_05
                                   ON UserData_05.Day = 5
                                  AND UserData_05.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_06
                                   ON UserData_06.Day = 6
                                  AND UserData_06.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_07
                                   ON UserData_07.Day = 7
                                  AND UserData_07.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_08
                                   ON UserData_08.Day = 8
                                  AND UserData_08.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_09
                                   ON UserData_09.Day = 9
                                  AND UserData_09.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_10
                                   ON UserData_10.Day = 10
                                  AND UserData_10.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_11
                                   ON UserData_11.Day = 11
                                  AND UserData_11.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_12
                                   ON UserData_12.Day = 12
                                  AND UserData_12.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_13
                                   ON UserData_13.Day = 13
                                  AND UserData_13.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_14
                                   ON UserData_14.Day = 14
                                  AND UserData_14.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_15
                                   ON UserData_15.Day = 15
                                  AND UserData_15.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_16
                                   ON UserData_16.Day = 16
                                  AND UserData_16.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_17
                                   ON UserData_17.Day = 17
                                  AND UserData_17.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_18
                                   ON UserData_18.Day = 18
                                  AND UserData_18.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_19
                                   ON UserData_19.Day = 19
                                  AND UserData_19.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_20
                                   ON UserData_20.Day = 20
                                  AND UserData_20.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_21
                                   ON UserData_21.Day = 21
                                  AND UserData_21.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_22
                                   ON UserData_22.Day = 22
                                  AND UserData_22.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_23
                                   ON UserData_23.Day = 23
                                  AND UserData_23.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_24
                                   ON UserData_24.Day = 24
                                  AND UserData_24.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_25
                                   ON UserData_25.Day = 25
                                  AND UserData_25.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_26
                                   ON UserData_26.Day = 26
                                  AND UserData_26.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_27
                                   ON UserData_27.Day = 27
                                  AND UserData_27.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_28
                                   ON UserData_28.Day = 28
                                  AND UserData_28.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_29
                                   ON UserData_29.Day = 29
                                  AND UserData_29.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_30
                                   ON UserData_30.Day = 30
                                  AND UserData_30.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_31
                                   ON UserData_31.Day = 31
                                  AND UserData_31.ID = MovementItem.Id

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
         Object_Unit.ID                                          AS UnitID,
         Object_Unit.ObjectCode                                  AS UnitCode,
         Object_Unit.ValueData                                   AS UnitName,
         'Пр. месяц'::TVarChar                                   AS Name0,
         'Тип дня'::TVarChar                                     AS Name1,
         'Приход'::TVarChar                                      AS Name2,
         'Уход'::TVarChar                                        AS Name3,

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

         UserData_01.PThortNamePrev                        AS ValuePrev1,
         UserData_02.PThortNamePrev                        AS ValuePrev2,
         UserData_03.PThortNamePrev                        AS ValuePrev3,
         UserData_04.PThortNamePrev                        AS ValuePrev4,
         UserData_05.PThortNamePrev                        AS ValuePrev5,
         UserData_06.PThortNamePrev                        AS ValuePrev6,
         UserData_07.PThortNamePrev                        AS ValuePrev7,
         UserData_08.PThortNamePrev                        AS ValuePrev8,
         UserData_09.PThortNamePrev                        AS ValuePrev9,
         UserData_10.PThortNamePrev                        AS ValuePrev10,
         UserData_11.PThortNamePrev                        AS ValuePrev11,
         UserData_12.PThortNamePrev                        AS ValuePrev12,
         UserData_13.PThortNamePrev                        AS ValuePrev13,
         UserData_14.PThortNamePrev                        AS ValuePrev14,
         UserData_15.PThortNamePrev                        AS ValuePrev15,
         UserData_16.PThortNamePrev                        AS ValuePrev16,
         UserData_17.PThortNamePrev                        AS ValuePrev17,
         UserData_18.PThortNamePrev                        AS ValuePrev18,
         UserData_19.PThortNamePrev                        AS ValuePrev19,
         UserData_20.PThortNamePrev                        AS ValuePrev20,
         UserData_21.PThortNamePrev                        AS ValuePrev21,
         UserData_22.PThortNamePrev                        AS ValuePrev22,
         UserData_23.PThortNamePrev                        AS ValuePrev23,
         UserData_24.PThortNamePrev                        AS ValuePrev24,
         UserData_25.PThortNamePrev                        AS ValuePrev25,
         UserData_26.PThortNamePrev                        AS ValuePrev26,
         UserData_27.PThortNamePrev                        AS ValuePrev27,
         UserData_28.PThortNamePrev                        AS ValuePrev28,
         UserData_29.PThortNamePrev                        AS ValuePrev29,
         UserData_30.PThortNamePrev                        AS ValuePrev30,
         UserData_31.PThortNamePrev                        AS ValuePrev31,

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
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Member_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_Member_Unit.ChildObjectId
                                AND ObjectLink_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

            LEFT JOIN tmpUserData AS UserData_01
                                  ON UserData_01.Day = 1
                                  AND UserData_01.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_02
                                   ON UserData_02.Day = 2
                                  AND UserData_02.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_03
                                   ON UserData_03.Day = 3
                                  AND UserData_03.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_04
                                   ON UserData_04.Day = 4
                                  AND UserData_04.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_05
                                   ON UserData_05.Day = 5
                                  AND UserData_05.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_06
                                   ON UserData_06.Day = 6
                                  AND UserData_06.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_07
                                   ON UserData_07.Day = 7
                                  AND UserData_07.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_08
                                   ON UserData_08.Day = 8
                                  AND UserData_08.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_09
                                   ON UserData_09.Day = 9
                                  AND UserData_09.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_10
                                   ON UserData_10.Day = 10
                                  AND UserData_10.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_11
                                   ON UserData_11.Day = 11
                                  AND UserData_11.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_12
                                   ON UserData_12.Day = 12
                                  AND UserData_12.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_13
                                   ON UserData_13.Day = 13
                                  AND UserData_13.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_14
                                   ON UserData_14.Day = 14
                                  AND UserData_14.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_15
                                   ON UserData_15.Day = 15
                                  AND UserData_15.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_16
                                   ON UserData_16.Day = 16
                                  AND UserData_16.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_17
                                   ON UserData_17.Day = 17
                                  AND UserData_17.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_18
                                   ON UserData_18.Day = 18
                                  AND UserData_18.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_19
                                   ON UserData_19.Day = 19
                                  AND UserData_19.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_20
                                   ON UserData_20.Day = 20
                                  AND UserData_20.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_21
                                   ON UserData_21.Day = 21
                                  AND UserData_21.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_22
                                   ON UserData_22.Day = 22
                                  AND UserData_22.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_23
                                   ON UserData_23.Day = 23
                                  AND UserData_23.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_24
                                   ON UserData_24.Day = 24
                                  AND UserData_24.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_25
                                   ON UserData_25.Day = 25
                                  AND UserData_25.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_26
                                   ON UserData_26.Day = 26
                                  AND UserData_26.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_27
                                   ON UserData_27.Day = 27
                                  AND UserData_27.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_28
                                   ON UserData_28.Day = 28
                                  AND UserData_28.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_29
                                   ON UserData_29.Day = 29
                                  AND UserData_29.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_30
                                   ON UserData_30.Day = 30
                                  AND UserData_30.ID = MovementItem.Id

            LEFT JOIN tmpUserData AS UserData_31
                                   ON UserData_31.Day = 31
                                  AND UserData_31.ID = MovementItem.Id

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
-- select * from gpSelect_MovementItem_EmployeeScheduleNew(inMovementId := 15463866 , inDate := ('01.09.2019')::TDateTime , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');