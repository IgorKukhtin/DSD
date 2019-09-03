-- Function: gpSelect_MovementItem_Wages_Sign()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Wages_Sign (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Wages_Sign(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitID Integer, UnitCode Integer, UnitName TVarChar
             , SummaCleaning TFloat, SummaSP TFloat, SummaOther TFloat
             , SummaTotal TFloat
             , isIssuedBy Boolean, MIDateIssuedBy TDateTime
             , Comment TVarChar
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
                                  AND Object_Personal.isErased = FALSE)

            SELECT 0                                  AS Id
                 , Object_Unit.Id                     AS UserID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName

                 , NULL::TFloat                       AS SummaCleaning
                 , NULL::TFloat                       AS SummaSP
                 , NULL::TFloat                       AS SummaOther
                 , NULL::TFloat                       AS SummaTotal

                 , False                              AS isIssuedBy
                 , NULL::TDateTime                    AS DateIssuedBy
                 , NULL::TVarChar                     AS Comment

                 , Object_Unit.isErased               AS isErased
                 , zc_Color_Black()                   AS Color_Calc
            FROM Object AS Object_Unit
                 INNER JOIN ObjectLink AS ObjectLink_Unit_Parent
                                       ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                      AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                                      AND COALESCE(ObjectLink_Unit_Parent.ChildObjectId, 0) <> 0
            WHERE Object_Unit.DescId = zc_Object_Unit()
              AND (inIsErased = True OR Object_Unit.isErased = False)
              AND Object_Unit.ID NOT IN (SELECT MovementItem.ObjectId
                                         FROM  MovementItem
                                         WHERE MovementItem.MovementId = inMovementId
                                           AND MovementItem.DescId = zc_MI_Sign())
            UNION ALL
            SELECT MovementItem.Id                    AS Id
                 , MovementItem.ObjectId              AS UserID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName

                 , MIFloat_SummaCleaning.ValueData    AS SummaCleaning
                 , MIFloat_SummaSP.ValueData          AS SummaSP
                 , MIFloat_SummaOther.ValueData       AS SummaOther
                 , MovementItem.Amount                AS SummaTotal

                 , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy
                 , MIDate_IssuedBy.ValueData          AS DateIssuedBy
                 , MIS_Comment.ValueData              AS Comment

                 , MovementItem.isErased              AS isErased
                 , zc_Color_Black()                   AS Color_Calc
            FROM  MovementItem


                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaCleaning
                                              ON MIFloat_SummaCleaning.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaCleaning.DescId = zc_MIFloat_SummaCleaning()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaSP
                                              ON MIFloat_SummaSP.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaSP.DescId = zc_MIFloat_SummaSP()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaOther
                                              ON MIFloat_SummaOther.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaOther.DescId = zc_MIFloat_SummaOther()

                  LEFT JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                                ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                               AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

                  LEFT JOIN MovementItemDate AS MIDate_IssuedBy
                                             ON MIDate_IssuedBy.MovementItemId = MovementItem.Id
                                            AND MIDate_IssuedBy.DescId = zc_MIDate_IssuedBy()

                  LEFT JOIN MovementItemString AS MIS_Comment
                                               ON MIS_Comment.MovementItemId = MovementItem.Id
                                              AND MIS_Comment.DescId = zc_MIString_Comment()

            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Sign()
              AND (MovementItem.isErased = FALSE OR inIsErased = TRUE);
    ELSE
        -- Результат другой
        RETURN QUERY
            SELECT MovementItem.Id                    AS Id
                 , MovementItem.ObjectId              AS UserID
                 , Object_Unit.ObjectCode             AS UnitCode
                 , Object_Unit.ValueData              AS UnitName

                 , MIFloat_SummaCleaning.ValueData    AS SummaCleaning
                 , MIFloat_SummaSP.ValueData          AS SummaSP
                 , MIFloat_SummaOther.ValueData       AS SummaOther
                 , MovementItem.Amount                AS SummaTotal

                 , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy
                 , MIDate_IssuedBy.ValueData          AS DateIssuedBy
                 , MIS_Comment.ValueData              AS Comment

                 , MovementItem.isErased              AS isErased
                 , zc_Color_Black()                   AS Color_Calc
            FROM  MovementItem


                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaCleaning
                                              ON MIFloat_SummaCleaning.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaCleaning.DescId = zc_MIFloat_SummaCleaning()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaSP
                                              ON MIFloat_SummaSP.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaSP.DescId = zc_MIFloat_SummaSP()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummaOther
                                              ON MIFloat_SummaOther.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummaOther.DescId = zc_MIFloat_SummaOther()

                  LEFT JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                                ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                               AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

                  LEFT JOIN MovementItemDate AS MIDate_IssuedBy
                                             ON MIDate_IssuedBy.MovementItemId = MovementItem.Id
                                            AND MIDate_IssuedBy.DescId = zc_MIDate_IssuedBy()

                  LEFT JOIN MovementItemString AS MIS_Comment
                                               ON MIS_Comment.MovementItemId = MovementItem.Id
                                              AND MIS_Comment.DescId = zc_MIString_Comment()

            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Sign()
              AND (MovementItem.isErased = FALSE OR inIsErased = TRUE);

     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.089.19                                                        *
*/
-- select * from gpSelect_MovementItem_Wages_Sign(inMovementId := 15414488 , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');
