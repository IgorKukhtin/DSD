-- Function: gpSelect_MovementItem_WagesSUN1()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_WagesSUN1 (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_WagesSUN1(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitID Integer, UnitCode Integer, UnitName TVarChar
             , SummaWeek1 TFloat, SummaWeek2 TFloat, SummaWeek3 TFloat, SummaWeek4 TFloat, SummaWeek5 TFloat
             , SummaSUN1 TFloat
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

    -- Результат другой
    RETURN QUERY
        SELECT MovementItem.Id                     AS Id
             , MovementItem.ObjectId               AS UnitID
             , Object_Unit.ObjectCode              AS UnitCode
             , Object_Unit.ValueData               AS UnitName

             , MIFloat_SummaWeek1.ValueData        AS SummaWeek1
             , MIFloat_SummaWeek2.ValueData        AS SummaWeek2
             , MIFloat_SummaWeek3.ValueData        AS SummaWeek3
             , MIFloat_SummaWeek4.ValueData        AS SummaWeek4
             , MIFloat_SummaWeek5.ValueData        AS SummaWeek5
             , MIFloat_SummaSUN1.ValueData         AS SummaSUN1

             , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy
             , MIDate_IssuedBy.ValueData           AS DateIssuedBy
             , MIS_Comment.ValueData               AS Comment

             , MovementItem.isErased               AS isErased
             , zc_Color_Black()                    AS Color_Calc
        FROM  MovementItem


              LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId

              LEFT JOIN MovementItemFloat AS MIFloat_SummaWeek1
                                          ON MIFloat_SummaWeek1.MovementItemId = MovementItem.Id
                                         AND MIFloat_SummaWeek1.DescId = zc_MIFloat_SummaWeek1()

              LEFT JOIN MovementItemFloat AS MIFloat_SummaWeek2
                                          ON MIFloat_SummaWeek2.MovementItemId = MovementItem.Id
                                         AND MIFloat_SummaWeek2.DescId = zc_MIFloat_SummaWeek2()

              LEFT JOIN MovementItemFloat AS MIFloat_SummaWeek3
                                          ON MIFloat_SummaWeek3.MovementItemId = MovementItem.Id
                                         AND MIFloat_SummaWeek3.DescId = zc_MIFloat_SummaWeek3()

              LEFT JOIN MovementItemFloat AS MIFloat_SummaWeek4
                                          ON MIFloat_SummaWeek4.MovementItemId = MovementItem.Id
                                         AND MIFloat_SummaWeek4.DescId = zc_MIFloat_SummaWeek4()

              LEFT JOIN MovementItemFloat AS MIFloat_SummaWeek5
                                          ON MIFloat_SummaWeek5.MovementItemId = MovementItem.Id
                                         AND MIFloat_SummaWeek5.DescId = zc_MIFloat_SummaWeek5()

              LEFT JOIN MovementItemFloat AS MIFloat_SummaSUN1
                                          ON MIFloat_SummaSUN1.MovementItemId = MovementItem.Id
                                         AND MIFloat_SummaSUN1.DescId = zc_MIFloat_SummaSUN1()

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

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.10.19                                                        *
 01.09.19                                                        *
*/
-- select * from gpSelect_MovementItem_WagesSUN1(inMovementId := 15414488 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');

