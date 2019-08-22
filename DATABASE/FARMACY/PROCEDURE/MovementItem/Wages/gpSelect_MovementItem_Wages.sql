-- Function: gpSelect_MovementItem_Wages()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Wages (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Wages(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, UserID Integer, Amount TFloat
             , PersonalCode Integer, PersonalName TVarChar, PositionName TVarChar
             , UnitID Integer, UnitCode Integer, UnitName TVarChar
             , isErased Boolean
             , Color_Calc Integer
              )
AS
$BODY$
    DECLARE vbUserId   Integer;
    DECLARE vbOperDate TDateTime;
    DECLARE vbSPKindId Integer;
    DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется данные
    SELECT Movement.OperDate
         , Movement.StatusId
    INTO vbOperDate, vbStatusId
    FROM Movement
    WHERE Movement.ID = inMovementId;

     -- Получение главніх аптек
     CREATE TEMP TABLE tmpMainUnit (UserId Integer, UnitId Integer) ON COMMIT DROP;

     WITH   tmpMain AS (SELECT
                               MovementItem.ObjectId      AS UserId
                             , MILinkObject_Unit.ObjectId AS UnitId
                        FROM Movement

                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                                    AND MovementItem.DescId = zc_MI_Master()

                             INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                               ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                        WHERE Movement.ID = inMovementId
                          AND (MovementItem.IsErased = FALSE OR inIsErased = TRUE)),

            tmpMainPrev AS (SELECT
                                   MovementItem.ObjectId      AS UserId
                                 , MILinkObject_Unit.ObjectId AS UnitId
                            FROM Movement

                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                                        AND MovementItem.DescId = zc_MI_Master()
                                                        AND MovementItem.ObjectId NOT IN (SELECT tmpMain.UserId FROM tmpMain)

                                 INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                   ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                            WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
                              AND Movement.OperDate = vbOperDate - INTERVAL '1 MONTH'
                              AND (MovementItem.IsErased = FALSE OR inIsErased = TRUE)),

            tmLogAll AS (SELECT count(*) as CountLog
                              , EmployeeWorkLog.UserId
                              , EmployeeWorkLog.UnitId
                         FROM EmployeeWorkLog
                         WHERE EmployeeWorkLog.DateLogIn >= vbOperDate - INTERVAL '1 MONTH' AND EmployeeWorkLog.DateLogIn < vbOperDate - INTERVAL '1 DAY'
                           AND EmployeeWorkLog.UserId NOT IN (SELECT tmpMain.UserId FROM tmpMain)
                           AND EmployeeWorkLog.UserId NOT IN (SELECT tmpMainPrev.UserId FROM tmpMainPrev)
                         GROUP BY EmployeeWorkLog.UserId, EmployeeWorkLog.UnitId),

            tmLog AS (SELECT ROW_NUMBER() OVER (PARTITION BY tmLogAll.UserId ORDER BY tmLogAll.CountLog DESC) AS Ord
                           , tmLogAll.UserId
                           , tmLogAll.UnitId
                      FROM tmLogAll),
            tmLogAllPrev AS (SELECT count(*) as CountLog
                              , EmployeeWorkLog.UserId
                              , EmployeeWorkLog.UnitId
                         FROM EmployeeWorkLog
                         WHERE EmployeeWorkLog.DateLogIn >= vbOperDate - INTERVAL '2 MONTH' AND EmployeeWorkLog.DateLogIn < vbOperDate - INTERVAL '1 DAY'
                           AND EmployeeWorkLog.UserId NOT IN (SELECT tmpMain.UserId FROM tmpMain)
                           AND EmployeeWorkLog.UserId NOT IN (SELECT tmpMainPrev.UserId FROM tmpMainPrev)
                           AND EmployeeWorkLog.UserId NOT IN (SELECT tmLog.UserId FROM tmLog)
                         GROUP BY EmployeeWorkLog.UserId, EmployeeWorkLog.UnitId),

            tmLogPrev AS (SELECT ROW_NUMBER() OVER (PARTITION BY tmLogAllPrev.UserId ORDER BY tmLogAllPrev.CountLog DESC) AS Ord
                           , tmLogAllPrev.UserId
                           , tmLogAllPrev.UnitId
                      FROM tmLogAllPrev)

     INSERT INTO tmpMainUnit (UserId, UnitId)
     SELECT tmpMain.UserId
          , tmpMain.UnitId
     FROM tmpMain
     UNION ALL
     SELECT tmpMainPrev.UserId
          , tmpMainPrev.UnitId
     FROM tmpMainPrev
     UNION ALL
     SELECT tmLog.UserId
          , tmLog.UnitId
     FROM tmLog
     WHERE tmLog.Ord = 1
     UNION ALL
     SELECT tmLogPrev.UserId
          , tmLogPrev.UnitId
     FROM tmLogPrev
     WHERE tmLogPrev.Ord = 1;


    -- Результат
    IF inShowAll THEN
        -- Результат такой
        RETURN QUERY
            WITH
                tmpPersonal_View AS (SELECT ROW_NUMBER() OVER (PARTITION BY Object_User.Id ORDER BY Object_Personal_View.IsErased) AS Ord
                                          , Object_User.Id                      AS UserID
                                          , Object_Personal_View.MemberId       AS MemberId
                                          , Object_Personal_View.PositionName   AS PositionName
                                     FROM Object AS Object_User

                                          INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                                ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

                                          LEFT JOIN Object_Personal_View ON Object_Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId

                                     WHERE Object_User.DescId = zc_Object_User()),
                tmpEmployeeSchedule AS (SELECT
                                               MovementItem.ObjectId      AS UserId
                                             , MILinkObject_Unit.ObjectId AS UnitId
                                             , MovementItem.isErased      AS isErased
                                        FROM Movement

                                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                                                    AND MovementItem.DescId = zc_MI_Master()
                                                                    AND MovementItem.ObjectId NOT IN (SELECT MovementItem.ObjectId FROM  MovementItem  WHERE MovementItem.MovementId = inMovementId)

                                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                              ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                                        WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
                                          AND Movement.OperDate = vbOperDate - INTERVAL '1 MONTH'
                                          AND (MovementItem.IsErased = FALSE OR inIsErased = TRUE))

            SELECT 0                                  AS Id
                 , tmpEmployeeSchedule.UserID         AS UserID
                 , NULL::TFloat                       AS Amount

                 , Object_Member.ObjectCode           AS PersonalCode
                 , Object_Member.ValueData            AS PersonalName
                 , Personal_View.PositionName         AS PositionName
                 , Object_Unit.ID                     AS UnitID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName
                 , tmpEmployeeSchedule.isErased       AS isErased
                 , zc_Color_Black()                   AS Color_Calc
            FROM  tmpEmployeeSchedule
                  LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                       ON ObjectLink_User_Member.ObjectId = tmpEmployeeSchedule.UserID
                                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                  LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId

                  LEFT JOIN tmpPersonal_View AS Personal_View
                                             ON Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId
                                            AND COALESCE (Personal_View.UserID, tmpEmployeeSchedule.UserID) =  tmpEmployeeSchedule.UserID
                                            AND Personal_View.Ord = 1

                  LEFT JOIN tmpMainUnit ON tmpMainUnit.UserId = tmpEmployeeSchedule.UserID

                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMainUnit.UnitID
            UNION ALL
            SELECT MovementItem.Id                    AS Id
                 , MovementItem.ObjectId              AS UserID
                 , MovementItem.Amount                AS Amount

                 , Object_Member.ObjectCode           AS PersonalCode
                 , Object_Member.ValueData            AS PersonalName
                 , Personal_View.PositionName         AS PositionName
                 , Object_Unit.ID                     AS UnitID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName
                 , MovementItem.isErased              AS isErased
                 , zc_Color_Black()                   AS Color_Calc
            FROM  MovementItem
                  LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                       ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                  LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId

                  LEFT JOIN tmpPersonal_View AS Personal_View
                                             ON Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId
                                            AND COALESCE (Personal_View.UserID, MovementItem.ObjectId) =  MovementItem.ObjectId
                                            AND Personal_View.Ord = 1

                  LEFT JOIN tmpMainUnit ON tmpMainUnit.UserId = MovementItem.ObjectId

                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMainUnit.UnitID
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Master()
              AND (MovementItem.isErased = FALSE OR inIsErased = TRUE);
    ELSE
        -- Результат другой
        RETURN QUERY
            WITH
                tmpPersonal_View AS (SELECT ROW_NUMBER() OVER (PARTITION BY Object_User.Id ORDER BY Object_Personal_View.IsErased) AS Ord
                                          , Object_User.Id                      AS UserID
                                          , Object_Personal_View.MemberId       AS MemberId
                                          , Object_Personal_View.PositionName   AS PositionName
                                     FROM Object AS Object_User

                                          INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                                ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

                                          INNER JOIN Object_Personal_View ON Object_Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId

                                     WHERE Object_User.DescId = zc_Object_User())

            SELECT MovementItem.Id                    AS Id
                 , MovementItem.ObjectId              AS UserID
                 , MovementItem.Amount                AS Amount

                 , Object_Member.ObjectCode           AS PersonalCode
                 , Object_Member.ValueData            AS PersonalName
                 , Personal_View.PositionName         AS PositionName
                 , Object_Unit.ID                     AS UnitID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName
                 , MovementItem.isErased              AS isErased
                 , zc_Color_Black()                   AS Color_Calc
            FROM  MovementItem

                  LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                       ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                  LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId

                  LEFT JOIN tmpPersonal_View AS Personal_View
                                             ON Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId
                                            AND COALESCE (Personal_View.UserID, MovementItem.ObjectId) =  MovementItem.ObjectId
                                            AND Personal_View.Ord = 1

                  LEFT JOIN tmpMainUnit ON tmpMainUnit.UserId = MovementItem.ObjectId

                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMainUnit.UnitID
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Master()
              AND (MovementItem.isErased = FALSE OR inIsErased = TRUE);

     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.08.19                                                        *
*/
--
select * from gpSelect_MovementItem_Wages(inMovementId := 15414488 , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');-- select * from gpSelect_MovementItem_Sale(inMovementId := 7784799 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');