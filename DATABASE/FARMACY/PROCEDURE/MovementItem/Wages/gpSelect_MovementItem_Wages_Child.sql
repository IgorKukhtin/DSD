-- Function: gpSelect_MovementItem_Wages()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Wages_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Wages_Child(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitID Integer, ParentID Integer, AmountAccrued TFloat
             , UnitCode Integer, UnitName TVarChar
             , PayrollTypeID Integer, PayrollTypeCode Integer, PayrollTypeName TVarChar
             , DateCalculation TDateTime, SummaBase TFloat, Formula TVarChar
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
    RETURN QUERY
        SELECT MovementItem.Id                    AS Id
             , MovementItem.ObjectId              AS UnitID
             , MovementItem.ParentID              AS ParentID
             , MovementItem.Amount                AS AmountAccrued

             , Object_Unit.ObjectCode             AS UnitCode
             , Object_Unit.ValueData              AS UnitName

             , Object_PayrollType.ID              AS PayrollTypeID
             , Object_PayrollType.ObjectCode      AS PayrollTypeCode
             , Object_PayrollType.ValueData       AS PayrollTypeName
             
             , MIDate_Calculation.ValueData       AS DateCalculation

             , MIF_SummaBase.ValueData            AS SummaBase
             
             , MIS_Formula.ValueData              AS Formula

             , MovementItem.isErased              AS isErased
             , zc_Color_Black()                   AS Color_Calc
        FROM  MovementItem

              LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId

              LEFT JOIN MovementItemLinkObject AS MILO_PayrollType
                                               ON MILO_PayrollType.MovementItemId = MovementItem.Id
                                              AND MILO_PayrollType.DescId = zc_MILinkObject_PayrollType()
              LEFT JOIN Object AS Object_PayrollType ON Object_PayrollType.Id = MILO_PayrollType.ObjectId

              LEFT JOIN MovementItemFloat AS MIF_SummaBase
                                          ON MIF_SummaBase.MovementItemId = MovementItem.Id
                                         AND MIF_SummaBase.DescId = zc_MIFloat_SummaBase()

              LEFT JOIN MovementItemString AS MIS_Formula
                                          ON MIS_Formula.MovementItemId = MovementItem.Id
                                         AND MIS_Formula.DescId = zc_MIString_Comment()

              LEFT JOIN MovementItemDate AS MIDate_Calculation
                                         ON MIDate_Calculation.MovementItemId = MovementItem.Id
                                        AND MIDate_Calculation.DescId = zc_MIDate_Calculation()

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Child()
          AND (MovementItem.isErased = FALSE OR inIsErased = TRUE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.08.19                                                        *
*/
-- select * from gpSelect_MovementItem_Wages_Child(inMovementId := 15414488 , inIsErased := 'False' ,  inSession := '3');