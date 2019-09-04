-- Function: gpSelect_MovementItem_Wages()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Wages (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Wages(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, UserID Integer, AmountAccrued TFloat
             , Marketing TFloat, AmountCard TFloat, AmountHand TFloat
             , MemberCode Integer, MemberName TVarChar, PositionName TVarChar
             , UnitID Integer, UnitCode Integer, UnitName TVarChar
             , isIssuedBy Boolean
             , isErased Boolean
             , Color_Calc Integer
              )
AS
$BODY$
    DECLARE vbUserId   Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    IF inShowAll THEN
        -- Результат такой
        RETURN QUERY
            WITH
                tmpPersonal_View AS (SELECT ROW_NUMBER() OVER (PARTITION BY Object_User.Id ORDER BY Object_Personal_View.IsErased) AS Ord
                                          , Object_User.Id                      AS UserID
                                          , Object_Personal_View.MemberId       AS MemberId
                                          , Object_Personal_View.PositionName   AS PositionName
                                          , Object_Personal_View.UnitId         AS UnitId
                                     FROM Object AS Object_User

                                          INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                                ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

                                          LEFT JOIN Object_Personal_View ON Object_Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId

                                     WHERE Object_User.DescId = zc_Object_User()),
                tmpPersonal AS (SELECT
                                       Object_Personal.Id                 AS PersonalId
                                     , ObjectLink_User_Member.ObjectId    AS UserID
                                     , Object_Personal.isErased           AS isErased
                                FROM Object AS Object_Personal

                                     INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                          ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                                                         AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

                                     INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                         ON ObjectLink_User_Member.ChildObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                         AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                                         AND ObjectLink_User_Member.ObjectId  NOT IN (SELECT MovementItem.ObjectId FROM  MovementItem  WHERE MovementItem.MovementId = inMovementId)

                                WHERE Object_Personal.DescId = zc_Object_Personal()
                                  AND Object_Personal.isErased = FALSE),
                tmpAdditionalExpenses AS (SELECT MovementItem.ObjectId                                    AS UnitID
                                               , MovementItem.Amount                                      AS SummaTotal
                                               , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy
                                               , MovementItem.isErased                                    AS isErased
                                          FROM  MovementItem

                                                LEFT JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                                                              ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                                                             AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

                                          WHERE MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId = zc_MI_Sign()
                                            AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                                            AND MovementItem.Amount <> 0)

            SELECT 0                                  AS Id
                 , tmpPersonal.UserID                 AS UserID
                 , NULL::TFloat                       AS Amount

                 , NULL::TFloat                       AS Marketing
                 , NULL::TFloat                       AS AmountCard
                 , NULL::TFloat                       AS AmountHand

                 , Object_Member.ObjectCode           AS MemberCode
                 , Object_Member.ValueData            AS MemberName
                 , Personal_View.PositionName         AS PositionName
                 , Object_Unit.ID                     AS UnitID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName
                 , False                              AS isIssuedBy
                 , tmpPersonal.isErased               AS isErased
                 , zc_Color_Black()                   AS Color_Calc
            FROM  tmpPersonal
                  INNER JOIN ObjectLink AS ObjectLink_User_Member
                                       ON ObjectLink_User_Member.ObjectId = tmpPersonal.UserID
                                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                  INNER JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId

                  LEFT JOIN tmpPersonal_View AS Personal_View
                                             ON Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId
                                            AND Personal_View.Ord = 1

                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Personal_View.UnitID

                  LEFT JOIN tmpAdditionalExpenses AS AdditionalExpenses
                                                  ON AdditionalExpenses.UnitID = Object_Unit.ID
            UNION ALL
            SELECT MovementItem.Id                    AS Id
                 , MovementItem.ObjectId              AS UserID
                 , MovementItem.Amount                AS AmountAccrued

                 , MIFloat_Marketing.ValueData        AS Marketing
                 , MIF_AmountCard.ValueData           AS AmountCard
                 , (MovementItem.Amount +
                    COALESCE (MIFloat_Marketing.ValueData, 0) -
                    COALESCE (MIF_AmountCard.ValueData, 0))::TFloat AS AmountHand

                 , Object_Member.ObjectCode           AS MemberCode
                 , Object_Member.ValueData            AS MemberName
                 , Personal_View.PositionName         AS PositionName
                 , Object_Unit.ID                     AS UnitID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName
                 , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy

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

                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Personal_View.UnitID

                  LEFT JOIN MovementItemFloat AS MIFloat_Marketing
                                              ON MIFloat_Marketing.MovementItemId = MovementItem.Id
                                             AND MIFloat_Marketing.DescId = zc_MIFloat_Marketing()

                  LEFT JOIN MovementItemFloat AS MIF_AmountCard
                                              ON MIF_AmountCard.MovementItemId = MovementItem.Id
                                             AND MIF_AmountCard.DescId = zc_MIFloat_AmountCard()

                  LEFT JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                                ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                               AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

                  LEFT JOIN tmpAdditionalExpenses AS AdditionalExpenses
                                                  ON AdditionalExpenses.UnitID = Object_Unit.ID

            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Master()
              AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
            UNION ALL
            SELECT Null::Integer                      AS Id
                 , Null::Integer                      AS UserID
                 , tmpAdditionalExpenses.SummaTotal   AS AmountAccrued

                 , Null::TFloat                       AS Marketing
                 , Null::TFloat                       AS AmountCard
                 , tmpAdditionalExpenses.SummaTotal   AS AmountHand

                 , Null::Integer                      AS MemberCode
                 , 'Дополнительные расходы'::TVarChar AS MemberName
                 , Null::TVarChar                     AS PositionName
                 , Object_Unit.ID                     AS UnitID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName
                 , tmpAdditionalExpenses.isIssuedBy   AS isIssuedBy

                 , tmpAdditionalExpenses.isErased     AS isErased
                 , zc_Color_Black()                   AS Color_Calc
            FROM  tmpAdditionalExpenses

                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpAdditionalExpenses.UnitID
            ;
    ELSE
        -- Результат другой
        RETURN QUERY
            WITH
                tmpPersonal_View AS (SELECT ROW_NUMBER() OVER (PARTITION BY Object_User.Id ORDER BY Object_Personal_View.IsErased) AS Ord
                                          , Object_User.Id                      AS UserID
                                          , Object_Personal_View.MemberId       AS MemberId
                                          , Object_Personal_View.PositionName   AS PositionName
                                          , Object_Personal_View.UnitId         AS UnitId
                                     FROM Object AS Object_User

                                          INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                                ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

                                          INNER JOIN Object_Personal_View ON Object_Personal_View.MemberId = ObjectLink_User_Member.ChildObjectId

                                     WHERE Object_User.DescId = zc_Object_User())
              , tmpAdditionalExpenses AS (SELECT MovementItem.ObjectId                                    AS UnitID
                                               , MovementItem.Amount                                      AS SummaTotal
                                               , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy
                                               , MovementItem.isErased                                    AS isErased
                                          FROM  MovementItem

                                                LEFT JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                                                              ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                                                             AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

                                          WHERE MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId = zc_MI_Sign()
                                            AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                                            AND MovementItem.Amount <> 0)

            SELECT MovementItem.Id                    AS Id
                 , MovementItem.ObjectId              AS UserID
                 , MovementItem.Amount                AS AmountAccrued

                 , MIFloat_Marketing.ValueData        AS Marketing
                 , MIF_AmountCard.ValueData           AS AmountCard
                 , (MovementItem.Amount +
                    COALESCE (MIFloat_Marketing.ValueData, 0) -
                    COALESCE (MIF_AmountCard.ValueData, 0))::TFloat AS AmountHand

                 , Object_Member.ObjectCode           AS MemberCode
                 , Object_Member.ValueData            AS MemberName
                 , Personal_View.PositionName         AS PositionName
                 , Object_Unit.ID                     AS UnitID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName
                 , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy

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

                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Personal_View.UnitID

                  LEFT JOIN MovementItemFloat AS MIFloat_Marketing
                                              ON MIFloat_Marketing.MovementItemId = MovementItem.Id
                                             AND MIFloat_Marketing.DescId = zc_MIFloat_Marketing()

                  LEFT JOIN MovementItemFloat AS MIF_AmountCard
                                              ON MIF_AmountCard.MovementItemId = MovementItem.Id
                                             AND MIF_AmountCard.DescId = zc_MIFloat_AmountCard()

                  LEFT JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                                ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                               AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

                  LEFT JOIN tmpAdditionalExpenses AS AdditionalExpenses
                                                  ON AdditionalExpenses.UnitID = Object_Unit.ID

            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Master()
              AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
            UNION ALL
            SELECT Null::Integer                      AS Id
                 , Null::Integer                      AS UserID
                 , tmpAdditionalExpenses.SummaTotal   AS AmountAccrued

                 , Null::TFloat                       AS Marketing
                 , Null::TFloat                       AS AmountCard
                 , tmpAdditionalExpenses.SummaTotal   AS AmountHand

                 , Null::Integer                      AS MemberCode
                 , 'Дополнительные расходы'::TVarChar AS MemberName
                 , Null::TVarChar                     AS PositionName
                 , Object_Unit.ID                     AS UnitID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName
                 , tmpAdditionalExpenses.isIssuedBy   AS isIssuedBy

                 , tmpAdditionalExpenses.isErased     AS isErased
                 , zc_Color_Black()                   AS Color_Calc
            FROM  tmpAdditionalExpenses

                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpAdditionalExpenses.UnitID
            ;

     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.08.19                                                        *
*/
--select * from gpSelect_MovementItem_Wages(inMovementId := 15414488 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');