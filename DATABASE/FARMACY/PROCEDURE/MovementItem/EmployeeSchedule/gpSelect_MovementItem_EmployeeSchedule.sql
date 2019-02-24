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
  DECLARE vbDefaultValue TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

     --
     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
        SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inDate), DATE_TRUNC ('MONTH', inDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;


     -- возвращаем заголовки столбцов и даты
     OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime,
                          ((EXTRACT(DAY FROM tmpOperDate.OperDate))||case when tmpCalendar.Working = False then ' *' else ' ' END||tmpWeekDay.DayOfWeekName) ::TVarChar AS ValueField,
                          ''::TVarChar   AS ValueFieldUser
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
       OPEN cur2 FOR
       WITH tmpPersonal AS (SELECT
                               ROW_NUMBER() OVER (PARTITION BY MemberId ORDER BY IsErased) AS Ord
                             , Object_Personal_View.MemberId
                             , Object_Personal_View.PersonalCode
                             , Object_Personal_View.PersonalName
                             , Object_Personal_View.PositionName
                        FROM Object_Personal_View),

            tmpUser AS (SELECT DISTINCT
                              MovementItem.ObjectId                       AS UserID
                            , Object_Member.Id                            AS MemberID
                            , Object_Member.ObjectCode                    AS MemberCode
                            , Object_Member.ValueData                     AS MemberName

                            , Object_Unit.ID                              AS UnitID
                            , Object_Unit.ObjectCode                      AS UnitCode
                            , Object_Unit.ValueData                       AS UnitName

                            , tmpPersonal.PositionName


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

                           LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectid
                                                AND tmpPersonal.Ord = 1

                      WHERE Movement.OperDate >= inDate - INTERVAL '3 MONTH'
                        AND Movement.DescId = zc_Movement_KPU())

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
         31                                   AS TypeId31
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
         tmpPersonal.PersonalCode                                AS PersonalCode,
         tmpPersonal.PersonalName                                AS PersonalName,
         tmpPersonal.PositionName                                AS PositionName,
         tmpUser.UnitID                                          AS UnitID,
         tmpUser.UnitCode                                        AS UnitCode,
         tmpUser.UnitName                                        AS UnitName,
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
         31                                                      AS TypeId31
       FROM Movement

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                   AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN tmpUser ON tmpUser.UserID = MovementItem.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectid

            LEFT JOIN (SELECT
                               ROW_NUMBER() OVER (PARTITION BY MemberId ORDER BY IsErased) AS Ord
                             , Object_Personal_View.MemberId
                             , Object_Personal_View.PersonalCode
                             , Object_Personal_View.PersonalName
                             , Object_Personal_View.PositionName
                        FROM Object_Personal_View) AS tmpPersonal
                                                   ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectid
                                                  AND tmpPersonal.Ord = 1

            INNER JOIN MovementItemString AS MIString_ComingValueDay
                                          ON MIString_ComingValueDay.DescId = zc_MIString_ComingValueDay()
                                         AND MIString_ComingValueDay.MovementItemId = MovementItem.Id

            LEFT JOIN MovementItemString AS MIString_ComingValueDayUser
                                         ON MIString_ComingValueDayUser.DescId = zc_MIString_ComingValueDayUser()
                                        AND MIString_ComingValueDayUser.MovementItemId = MovementItem.Id

       WHERE Movement.ID = inMovementId
         AND (MovementItem.IsErased = FALSE OR inIsErased = TRUE)

       ORDER BY 5;
     ELSE
       OPEN cur2 FOR
       WITH tmpPersonal AS (SELECT
                                 ROW_NUMBER() OVER (PARTITION BY MemberId ORDER BY IsErased) AS Ord
                               , Object_Personal_View.MemberId
                               , Object_Personal_View.PersonalCode
                               , Object_Personal_View.PersonalName
                               , Object_Personal_View.PositionName
                            FROM Object_Personal_View),

            tmpUser AS (SELECT DISTINCT
                              MovementItem.ObjectId                       AS UserID
                            , Object_Member.Id                            AS MemberID
                            , Object_Member.ObjectCode                    AS MemberCode
                            , Object_Member.ValueData                     AS MemberName

                            , Object_Unit.ID                              AS UnitID
                            , Object_Unit.ObjectCode                      AS UnitCode
                            , Object_Unit.ValueData                       AS UnitName

                            , tmpPersonal.PositionName


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

                           LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectid
                                                AND tmpPersonal.Ord = 1

                      WHERE Movement.OperDate >= inDate - INTERVAL '3 MONTH'
                        AND Movement.DescId = zc_Movement_KPU())

       SELECT
         MovementItem.Id                                         AS ID,
         MovementItem.ObjectId                                   AS UserID,
         MovementItem.IsErased                                   AS IsErased,
         tmpPersonal.PersonalCode                                AS PersonalCode,
         tmpPersonal.PersonalName                                AS PersonalName,
         tmpPersonal.PositionName                                AS PositionName,
         tmpUser.UnitID                                          AS UnitID,
         tmpUser.UnitCode                                        AS UnitCode,
         tmpUser.UnitName                                        AS UnitName,
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
         31                                                      AS TypeId31
       FROM Movement

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                   AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN tmpUser ON tmpUser.UserID = MovementItem.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectid

            LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectid
                                 AND tmpPersonal.Ord = 1

            INNER JOIN MovementItemString AS MIString_ComingValueDay
                                          ON MIString_ComingValueDay.DescId = zc_MIString_ComingValueDay()
                                         AND MIString_ComingValueDay.MovementItemId = MovementItem.Id

            LEFT JOIN MovementItemString AS MIString_ComingValueDayUser
                                         ON MIString_ComingValueDayUser.DescId = zc_MIString_ComingValueDayUser()
                                        AND MIString_ComingValueDayUser.MovementItemId = MovementItem.Id

       WHERE Movement.ID = inMovementId
         AND (MovementItem.IsErased = FALSE OR inIsErased = TRUE)
       ORDER BY tmpPersonal.PersonalName;
     END IF;

     RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_EmployeeSchedule (Integer, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.12.18                                                       *
*/

-- тест
-- select * from gpSelect_MovementItem_EmployeeSchedule(inMovementId := 12110225 , inDate := ('30.11.2018 22:00:00')::TDateTime , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');
