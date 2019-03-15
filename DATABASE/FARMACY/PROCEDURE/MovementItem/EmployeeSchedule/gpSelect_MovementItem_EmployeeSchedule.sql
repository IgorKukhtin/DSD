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
  DECLARE cur3 refcursor;
  DECLARE vbDefaultValue TVarChar;
  DECLARE vbCurrDay Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

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


     -- возвращаем заголовки столбцов и даты
     OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime,
                          ((EXTRACT(DAY FROM tmpOperDate.OperDate))||case when tmpCalendar.Working = False then ' *' else ' ' END||tmpWeekDay.DayOfWeekName) ::TVarChar AS ValueField,
                          EXTRACT(DAY FROM tmpOperDate.OperDate)::TVarChar   AS ValueFieldUser
               FROM tmpOperDate
                   LEFT JOIN zfCalc_DayOfWeekName (tmpOperDate.OperDate) AS tmpWeekDay ON 1=1
                   LEFT JOIN gpSelect_Object_Calendar(tmpOperDate.OperDate,tmpOperDate.OperDate,inSession) tmpCalendar ON 1=1

      ;
     RETURN NEXT cur1;

     vbDefaultValue := '0000000000000000000000000000000';

     IF COALESCE(inMovementId, 0) = 0 OR inShowAll = TRUE OR
        NOT EXISTS(SELECT MovementItem.ObjectId
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId = zc_MI_Master())
     THEN
       OPEN cur3 FOR
       WITH tmpUser AS (SELECT DISTINCT
                              ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
                            , MovementItem.ObjectId                       AS UserID
                            , Object_Member.Id                            AS MemberID
                            , Object_Member.ObjectCode                    AS MemberCode
                            , Object_Member.ValueData                     AS MemberName

                            , Object_Unit.ID                              AS UnitID
                            , Object_Unit.ObjectCode                      AS UnitCode
                            , Object_Unit.ValueData                       AS UnitName

                            , Object_Position.ValueData                   AS PositionName


                      FROM Movement

                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                                  AND MovementItem.DescId = zc_MI_Master()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                            ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                           LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectid

                           LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                ON ObjectLink_Personal_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                               AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

                           LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_Member.ObjectId
                                               AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                           LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId

                      WHERE Movement.OperDate >= inDate - INTERVAL '3 MONTH'
                        AND Movement.DescId = zc_Movement_KPU()),

            tmpEmployee AS (SELECT EmployeeWorkLog.UserId   AS UserId
                                 , EmployeeWorkLog.UnitId   AS UnitId
                                 , COUNT(*)                 AS CountLog
                            FROM EmployeeWorkLog
                            WHERE EmployeeWorkLog.DateLogIn >= inDate - INTERVAL '3 MONTH'
                            GROUP BY EmployeeWorkLog.UnitId, EmployeeWorkLog.UserId),

            tmpEmployeeUser AS (SELECT ROW_NUMBER() OVER (PARTITION BY tmpEmployee.UserId ORDER BY tmpEmployee.CountLog DESC) AS Ord
                                     , tmpEmployee.UserId   AS UserId
                                     , tmpEmployee.UnitId   AS UnitId
                                FROM tmpEmployee)

       SELECT
         0                                    AS ID,
         tmpUser.UserID                       AS UserID,
         NULL::Boolean                        AS IsErased,
         tmpUser.MemberCode                   AS PersonalCode,
         tmpUser.MemberName                   AS PersonalName,
         tmpUser.PositionName                 AS PositionName,
         tmpUser.UnitID                       AS UnitID,
         tmpUser.UnitCode                     AS UnitCode,
         tmpUser.UnitName                     AS UnitName,
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
       FROM tmpUser
       WHERE tmpUser.UserID NOT IN (SELECT MovementItem.ObjectId
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
         Object_Position.ValueData                               AS PositionName,
         COALESCE (tmpUser.UnitID, Object_Unit.ID)               AS UnitID,
         COALESCE (tmpUser.UnitCode, Object_Unit.ObjectCode)     AS UnitCode,
         COALESCE (tmpUser.UnitName, Object_Unit.ValueData)      AS UnitName,
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
         CASE WHEN vbCurrDay >= 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 1, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 1, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc1,
         CASE WHEN vbCurrDay >= 2 AND SUBSTRING(MIString_ComingValueDay.ValueData, 2, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 2, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc2,
         CASE WHEN vbCurrDay >= 3 AND SUBSTRING(MIString_ComingValueDay.ValueData, 3, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 3, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc3,
         CASE WHEN vbCurrDay >= 4 AND SUBSTRING(MIString_ComingValueDay.ValueData, 4, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 4, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc4,
         CASE WHEN vbCurrDay >= 5 AND SUBSTRING(MIString_ComingValueDay.ValueData, 5, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 5, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc5,
         CASE WHEN vbCurrDay >= 6 AND SUBSTRING(MIString_ComingValueDay.ValueData, 6, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 6, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc6,
         CASE WHEN vbCurrDay >= 7 AND SUBSTRING(MIString_ComingValueDay.ValueData, 7, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 7, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc7,
         CASE WHEN vbCurrDay >= 8 AND SUBSTRING(MIString_ComingValueDay.ValueData, 8, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 8, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc8,
         CASE WHEN vbCurrDay >= 9 AND SUBSTRING(MIString_ComingValueDay.ValueData, 9, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 9, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc9,
         CASE WHEN vbCurrDay >= 10 AND SUBSTRING(MIString_ComingValueDay.ValueData, 10, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 10, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc10,
         CASE WHEN vbCurrDay >= 11 AND SUBSTRING(MIString_ComingValueDay.ValueData, 11, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 11, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc11,
         CASE WHEN vbCurrDay >= 12 AND SUBSTRING(MIString_ComingValueDay.ValueData, 12, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 12, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc12,
         CASE WHEN vbCurrDay >= 13 AND SUBSTRING(MIString_ComingValueDay.ValueData, 13, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 13, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc13,
         CASE WHEN vbCurrDay >= 14 AND SUBSTRING(MIString_ComingValueDay.ValueData, 14, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 14, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc14,
         CASE WHEN vbCurrDay >= 15 AND SUBSTRING(MIString_ComingValueDay.ValueData, 15, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 15, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc15,
         CASE WHEN vbCurrDay >= 16 AND SUBSTRING(MIString_ComingValueDay.ValueData, 16, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 16, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc16,
         CASE WHEN vbCurrDay >= 17 AND SUBSTRING(MIString_ComingValueDay.ValueData, 17, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 17, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc17,
         CASE WHEN vbCurrDay >= 18 AND SUBSTRING(MIString_ComingValueDay.ValueData, 18, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 18, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc18,
         CASE WHEN vbCurrDay >= 19 AND SUBSTRING(MIString_ComingValueDay.ValueData, 19, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 19, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc19,
         CASE WHEN vbCurrDay >= 20 AND SUBSTRING(MIString_ComingValueDay.ValueData, 20, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 20, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc20,
         CASE WHEN vbCurrDay >= 21 AND SUBSTRING(MIString_ComingValueDay.ValueData, 21, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 21, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc21,
         CASE WHEN vbCurrDay >= 22 AND SUBSTRING(MIString_ComingValueDay.ValueData, 22, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 22, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc22,
         CASE WHEN vbCurrDay >= 23 AND SUBSTRING(MIString_ComingValueDay.ValueData, 23, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 23, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc23,
         CASE WHEN vbCurrDay >= 24 AND SUBSTRING(MIString_ComingValueDay.ValueData, 24, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 24, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc24,
         CASE WHEN vbCurrDay >= 25 AND SUBSTRING(MIString_ComingValueDay.ValueData, 25, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 25, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc25,
         CASE WHEN vbCurrDay >= 26 AND SUBSTRING(MIString_ComingValueDay.ValueData, 26, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 26, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc26,
         CASE WHEN vbCurrDay >= 27 AND SUBSTRING(MIString_ComingValueDay.ValueData, 27, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 27, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc27,
         CASE WHEN vbCurrDay >= 28 AND SUBSTRING(MIString_ComingValueDay.ValueData, 28, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 28, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc28,
         CASE WHEN vbCurrDay >= 29 AND SUBSTRING(MIString_ComingValueDay.ValueData, 29, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 29, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc29,
         CASE WHEN vbCurrDay >= 30 AND SUBSTRING(MIString_ComingValueDay.ValueData, 30, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 30, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc30,
         CASE WHEN vbCurrDay >= 31 AND SUBSTRING(MIString_ComingValueDay.ValueData, 31, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 31, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc31
       FROM Movement

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                   AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                 ON ObjectLink_Personal_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                 ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_Member.ObjectId
                                AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId

            LEFT JOIN tmpUser ON tmpUser.UserID = MovementItem.ObjectId
                             AND tmpUser.Ord = 1

            LEFT JOIN tmpEmployeeUser ON tmpEmployeeUser.UserID = MovementItem.ObjectId
                                     AND tmpEmployeeUser.Ord = 1
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpEmployeeUser.UnitID

            INNER JOIN MovementItemString AS MIString_ComingValueDay
                                          ON MIString_ComingValueDay.DescId = zc_MIString_ComingValueDay()
                                         AND MIString_ComingValueDay.MovementItemId = MovementItem.Id

            LEFT JOIN MovementItemString AS MIString_ComingValueDayUser
                                         ON MIString_ComingValueDayUser.DescId = zc_MIString_ComingValueDayUser()
                                        AND MIString_ComingValueDayUser.MovementItemId = MovementItem.Id

       WHERE Movement.ID = inMovementId
         AND (MovementItem.IsErased = FALSE OR inIsErased = TRUE);
     ELSE
       OPEN cur3 FOR
       WITH tmpUser AS (SELECT DISTINCT
                              ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
                            , MovementItem.ObjectId                       AS UserID
                            , Object_Member.Id                            AS MemberID
                            , Object_Member.ObjectCode                    AS MemberCode
                            , Object_Member.ValueData                     AS MemberName

                            , Object_Unit.ID                              AS UnitID
                            , Object_Unit.ObjectCode                      AS UnitCode
                            , Object_Unit.ValueData                       AS UnitName


                      FROM Movement

                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                                  AND MovementItem.DescId = zc_MI_Master()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                            ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                           LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectid

                      WHERE Movement.OperDate >= inDate - INTERVAL '3 MONTH'
                        AND Movement.DescId = zc_Movement_KPU()),

            tmpEmployee AS (SELECT EmployeeWorkLog.UserId   AS UserId
                                 , EmployeeWorkLog.UnitId   AS UnitId
                                 , COUNT(*)                 AS CountLog
                            FROM EmployeeWorkLog
                            WHERE EmployeeWorkLog.DateLogIn >= inDate - INTERVAL '3 MONTH'
                            GROUP BY EmployeeWorkLog.UnitId, EmployeeWorkLog.UserId),

            tmpEmployeeUser AS (SELECT ROW_NUMBER() OVER (PARTITION BY tmpEmployee.UserId ORDER BY tmpEmployee.CountLog DESC) AS Ord
                                     , tmpEmployee.UserId   AS UserId
                                     , tmpEmployee.UnitId   AS UnitId
                                FROM tmpEmployee)


       SELECT
         MovementItem.Id                                         AS ID,
         MovementItem.ObjectId                                   AS UserID,
         MovementItem.IsErased                                   AS IsErased,
         Object_Member.ObjectCode                                AS PersonalCode,
         Object_Member.ValueData                                 AS PersonalName,
         Object_Position.ValueData                               AS PositionName,
         COALESCE (tmpUser.UnitID, Object_Unit.ID)               AS UnitID,
         COALESCE (tmpUser.UnitCode, Object_Unit.ObjectCode)     AS UnitCode,
         COALESCE (tmpUser.UnitName, Object_Unit.ValueData)      AS UnitName,
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
         CASE WHEN vbCurrDay >= 1 AND SUBSTRING(MIString_ComingValueDay.ValueData, 1, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 1, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc1,
         CASE WHEN vbCurrDay >= 2 AND SUBSTRING(MIString_ComingValueDay.ValueData, 2, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 2, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc2,
         CASE WHEN vbCurrDay >= 3 AND SUBSTRING(MIString_ComingValueDay.ValueData, 3, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 3, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc3,
         CASE WHEN vbCurrDay >= 4 AND SUBSTRING(MIString_ComingValueDay.ValueData, 4, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 4, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc4,
         CASE WHEN vbCurrDay >= 5 AND SUBSTRING(MIString_ComingValueDay.ValueData, 5, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 5, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc5,
         CASE WHEN vbCurrDay >= 6 AND SUBSTRING(MIString_ComingValueDay.ValueData, 6, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 6, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc6,
         CASE WHEN vbCurrDay >= 7 AND SUBSTRING(MIString_ComingValueDay.ValueData, 7, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 7, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc7,
         CASE WHEN vbCurrDay >= 8 AND SUBSTRING(MIString_ComingValueDay.ValueData, 8, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 8, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc8,
         CASE WHEN vbCurrDay >= 9 AND SUBSTRING(MIString_ComingValueDay.ValueData, 9, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 9, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc9,
         CASE WHEN vbCurrDay >= 10 AND SUBSTRING(MIString_ComingValueDay.ValueData, 10, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 10, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc10,
         CASE WHEN vbCurrDay >= 11 AND SUBSTRING(MIString_ComingValueDay.ValueData, 11, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 11, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc11,
         CASE WHEN vbCurrDay >= 12 AND SUBSTRING(MIString_ComingValueDay.ValueData, 12, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 12, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc12,
         CASE WHEN vbCurrDay >= 13 AND SUBSTRING(MIString_ComingValueDay.ValueData, 13, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 13, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc13,
         CASE WHEN vbCurrDay >= 14 AND SUBSTRING(MIString_ComingValueDay.ValueData, 14, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 14, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc14,
         CASE WHEN vbCurrDay >= 15 AND SUBSTRING(MIString_ComingValueDay.ValueData, 15, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 15, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc15,
         CASE WHEN vbCurrDay >= 16 AND SUBSTRING(MIString_ComingValueDay.ValueData, 16, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 16, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc16,
         CASE WHEN vbCurrDay >= 17 AND SUBSTRING(MIString_ComingValueDay.ValueData, 17, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 17, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc17,
         CASE WHEN vbCurrDay >= 18 AND SUBSTRING(MIString_ComingValueDay.ValueData, 18, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 18, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc18,
         CASE WHEN vbCurrDay >= 19 AND SUBSTRING(MIString_ComingValueDay.ValueData, 19, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 19, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc19,
         CASE WHEN vbCurrDay >= 20 AND SUBSTRING(MIString_ComingValueDay.ValueData, 20, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 20, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc20,
         CASE WHEN vbCurrDay >= 21 AND SUBSTRING(MIString_ComingValueDay.ValueData, 21, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 21, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc21,
         CASE WHEN vbCurrDay >= 22 AND SUBSTRING(MIString_ComingValueDay.ValueData, 22, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 22, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc22,
         CASE WHEN vbCurrDay >= 23 AND SUBSTRING(MIString_ComingValueDay.ValueData, 23, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 23, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc23,
         CASE WHEN vbCurrDay >= 24 AND SUBSTRING(MIString_ComingValueDay.ValueData, 24, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 24, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc24,
         CASE WHEN vbCurrDay >= 25 AND SUBSTRING(MIString_ComingValueDay.ValueData, 25, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 25, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc25,
         CASE WHEN vbCurrDay >= 26 AND SUBSTRING(MIString_ComingValueDay.ValueData, 26, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 26, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc26,
         CASE WHEN vbCurrDay >= 27 AND SUBSTRING(MIString_ComingValueDay.ValueData, 27, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 27, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc27,
         CASE WHEN vbCurrDay >= 28 AND SUBSTRING(MIString_ComingValueDay.ValueData, 28, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 28, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc28,
         CASE WHEN vbCurrDay >= 29 AND SUBSTRING(MIString_ComingValueDay.ValueData, 29, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 29, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc29,
         CASE WHEN vbCurrDay >= 30 AND SUBSTRING(MIString_ComingValueDay.ValueData, 30, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 30, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc30,
         CASE WHEN vbCurrDay >= 31 AND SUBSTRING(MIString_ComingValueDay.ValueData, 31, 1) <>
           SUBSTRING(MIString_ComingValueDayUser.ValueData, 31, 1) THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc31
       FROM Movement

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                   AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                 ON ObjectLink_Personal_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                 ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_Member.ObjectId
                                AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId

            LEFT JOIN tmpUser ON tmpUser.UserID = MovementItem.ObjectId
                             AND tmpUser.Ord = 1

            LEFT JOIN tmpEmployeeUser ON tmpEmployeeUser.UserID = MovementItem.ObjectId
                                     AND tmpEmployeeUser.Ord = 1
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpEmployeeUser.UnitID

            INNER JOIN MovementItemString AS MIString_ComingValueDay
                                          ON MIString_ComingValueDay.DescId = zc_MIString_ComingValueDay()
                                         AND MIString_ComingValueDay.MovementItemId = MovementItem.Id

            LEFT JOIN MovementItemString AS MIString_ComingValueDayUser
                                         ON MIString_ComingValueDayUser.DescId = zc_MIString_ComingValueDayUser()
                                        AND MIString_ComingValueDayUser.MovementItemId = MovementItem.Id

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
-- select * from gpSelect_MovementItem_EmployeeSchedule(inMovementId := 12110225 , inDate := ('30.11.2018 22:00:00')::TDateTime , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');