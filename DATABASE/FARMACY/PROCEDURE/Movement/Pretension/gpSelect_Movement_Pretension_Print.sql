-- Function: gpSelect_Movement_Pretension_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Pretension_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Pretension_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Pretension());
    vbUserId:= inSession;

    OPEN Cursor1 FOR
      SELECT
             Movement_Pretension_View.Id
           , Movement_Pretension_View.InvNumber
           , Movement_Pretension_View.OperDate
           , Movement_Pretension_View.StatusCode
           , Movement_Pretension_View.StatusName
           , Movement_Pretension_View.PriceWithVAT
           , Movement_Pretension_View.FromId
           , Movement_Pretension_View.FromName
           , Movement_Pretension_View.ToId
           , Movement_Pretension_View.ToName
           , Movement_Pretension_View.NDSKindId
           , Movement_Pretension_View.NDSKindName
           , Movement_Pretension_View.MovementIncomeId
           , Movement_Pretension_View.IncomeOperDate
           , Movement_Pretension_View.IncomeInvNumber
           , Movement_Pretension_View.JuridicalId
           , Movement_Pretension_View.JuridicalName
           , Movement_Pretension_View.Comment
           , Movement_Pretension_View.BranchDate
           , ObjectString_Unit_Phone.ValueData                    AS Phone
           , EXTRACT (DAY FROM Movement_Pretension_View.IncomeOperDate)::TVarChar             AS IncomeOperDateDay
           , zfCalc_MonthName (Movement_Pretension_View.IncomeOperDate)||' '||
             EXTRACT (YEAR FROM Movement_Pretension_View.IncomeOperDate)                   AS IncomeOperDateMonthYear

       FROM Movement_Pretension_View       

            LEFT JOIN ObjectString AS ObjectString_Unit_Phone
                                   ON ObjectString_Unit_Phone.ObjectId = Movement_Pretension_View.FromId
                                  AND ObjectString_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()
                                  
       WHERE Movement_Pretension_View.Id = inMovementId;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
    
        SELECT MI_Pretension.Id
             , MIFloat_MovementItemId.ValueData::Integer   AS ParentId
             , MI_Pretension.ObjectId           AS GoodsId
             , Object_Goods.ObjectCode          AS GoodsCode
             , Object_Goods.ValueData           AS GoodsName
             , MI_Pretension.Amount             AS Amount
             , MIFloat_AmountManual.ValueData   AS AmountManual
             , (COALESCE(MIFloat_AmountManual.ValueData, 0) - COALESCE(MI_Pretension.Amount,0))::TFloat AS AmountDiff
             , MIBoolean_Checked.ValueData      AS isChecked
             , MI_Pretension.isErased
             , ''::TVarChar                     AS Comment
        FROM Movement AS Movement_Pretension
             INNER JOIN MovementItem AS MI_Pretension
                                     ON MI_Pretension.MovementId = Movement_Pretension.Id
                                    AND MI_Pretension.isErased = FALSE
                                    AND MI_Pretension.DescId     = zc_MI_Master()
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Pretension.ObjectId

             LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                         ON MIFloat_MovementItemId.MovementItemId = MI_Pretension.Id
                                        AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                         ON MIFloat_AmountManual.MovementItemId = MI_Pretension.Id
                                        AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()

             LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                           ON MIBoolean_Checked.MovementItemId = MI_Pretension.Id
                                          AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
        WHERE Movement_Pretension.Id = inMovementId
          AND MIBoolean_Checked.ValueData = True;

    RETURN NEXT Cursor2;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Pretension_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.12.21                                                       *
*/


select * from gpSelect_Movement_Pretension_Print(inMovementId := 26008006 ,  inSession := '3');