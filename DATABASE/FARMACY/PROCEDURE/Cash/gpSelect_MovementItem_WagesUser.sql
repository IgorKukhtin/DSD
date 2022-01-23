-- Function: gpSelect_MovementItem_Wages()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_WagesUser (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_WagesUser(
    IN inOperDate    TDateTime      , -- ключ Документа
    IN inSession     TVarChar         -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitID Integer, AmountAccrued TFloat
             , UnitCode Integer, UnitName TVarChar
             , PayrollTypeID Integer, PayrollTypeCode Integer, PayrollTypeName TVarChar
             , DateCalculation TDateTime, SummaBase TFloat, Formula TVarChar
             , isErased Boolean
             , Color_Calc Integer
              )
AS
$BODY$
    DECLARE vbUserId     Integer;
    DECLARE vbMovementId Integer;
    DECLARE vbParentID   Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);
    inOperDate := date_trunc('month', inOperDate);
    
    IF vbUserId = 3
    THEN
      vbUserId  := 12113514;
    END IF;

    IF EXISTS(SELECT 1 FROM Movement WHERE Movement.OperDate = inOperDate AND Movement.DescId = zc_Movement_Wages())
    THEN
      SELECT MAX(Movement.ID)
      INTO vbMovementId  
      FROM Movement 
      WHERE Movement.OperDate = inOperDate 
        AND Movement.DescId = zc_Movement_Wages();
    ELSE 
       RAISE EXCEPTION 'Не найден расчет з.п. за %', zfCalc_MonthYearName(inOperDate);
    END IF;

    IF EXISTS(SELECT 1 FROM MovementItem 
              WHERE MovementItem.MovementId = vbMovementId
                AND MovementItem.ObjectId = vbUserId
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE)
    THEN
      SELECT MovementItem.ID
      INTO vbParentID  
      FROM MovementItem 
      WHERE MovementItem.MovementId = vbMovementId
        AND MovementItem.ObjectId = vbUserId
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.isErased = FALSE;
    ELSE 
       RAISE EXCEPTION 'Не найден по вам расчет з.п. за %', zfCalc_MonthYearName(inOperDate);
    END IF;

    -- Результат
    RETURN QUERY
        SELECT MovementItem.Id                    AS Id
             , MovementItem.ObjectId              AS UnitID
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

        WHERE MovementItem.MovementId = vbMovementId
          AND MovementItem.ParentId = vbParentID
          AND MovementItem.DescId = zc_MI_Child()
          AND MovementItem.isErased = FALSE
        ORDER BY MIDate_Calculation.ValueData;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.08.19                                                        *
*/
-- select * from gpSelect_MovementItem_WagesUser(inOperDate := '01.08.2019',  inSession := '3');