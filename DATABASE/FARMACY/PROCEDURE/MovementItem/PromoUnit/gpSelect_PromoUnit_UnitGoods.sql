-- Function: gpSelect_PromoUnit_UnitGoods()

DROP FUNCTION IF EXISTS gpSelect_PromoUnit_UnitGoods(TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PromoUnit_UnitGoods(
    IN inOperDate    TDateTime   ,    -- Дата расчета
    IN inSession     TVarChar         -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, GoodsId Integer, Amount TFloat) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

   RETURN QUERY 
      WITH tmpMovement AS (SELECT Movement.Id                                             AS Id
                                , MovementLinkObject_UnitCategory.ObjectId                AS UnitCategoryId
                            FROM Movement

                                 INNER JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                                               ON MovementLinkObject_UnitCategory.MovementId = Movement.Id
                                                              AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()

                           WHERE Movement.StatusId = zc_Enum_Status_Complete()
                             AND Movement.DescId = zc_Movement_PromoUnit()
                             AND Movement.OperDate = DATE_TRUNC ('MONTH', inOperDate)),
           tmpUnit AS (SELECT Object_Unit_View.Id AS UnitId
                       FROM Object_Unit_View
                       WHERE Object_Unit_View.iserased = False 
                         AND COALESCE (Object_Unit_View.ParentId, 0) <> 377612
                         AND Object_Unit_View.Id <> 389328
                         AND Object_Unit_View.Name NOT ILIKE 'Зачинена%'
                         AND COALESCE (Object_Unit_View.ParentId, 0) IN 
                            (SELECT DISTINCT U.Id FROM Object_Unit_View AS U WHERE U.isErased = False AND COALESCE (U.ParentId, 0) = 0)) 

      SELECT OL_UnitCategory.Objectid                AS UnitId
           , MI_Goods.Objectid                       AS GoodsId
           , COALESCE(NULLIF(MIFloat_AmountPlanMax.ValueData, 0), MI_Goods.Amount)::TFloat AS Amount

      FROM tmpMovement AS Movement

           INNER JOIN ObjectLink AS OL_UnitCategory
                                 ON OL_UnitCategory.DescId = zc_ObjectLink_Unit_Category()
                                AND OL_UnitCategory.ChildObjectId = Movement.UnitCategoryId
                                
           INNER JOIN tmpUnit ON tmpUnit.UnitId = OL_UnitCategory.Objectid

           INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                              AND MI_Goods.DescId = zc_MI_Master()
                                              AND MI_Goods.isErased = FALSE
                                            
           LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                       ON MIFloat_AmountPlanMax.MovementItemId = MI_Goods.Id
                                      AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()
                                                          
      WHERE COALESCE(NULLIF(MIFloat_AmountPlanMax.ValueData, 0), MI_Goods.Amount) > 0
        AND (SELECT count(*) FROM tmpMovement) > 1
      UNION ALL
      SELECT tmpUnit.UnitId                        AS UnitId
           , MI_Goods.Objectid                     AS GoodsId
           , COALESCE(NULLIF(MIFloat_AmountPlanMax.ValueData, 0), MI_Goods.Amount)::TFloat AS Amount

      FROM tmpMovement AS Movement

           INNER JOIN tmpUnit ON 1 = 1

           INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                              AND MI_Goods.DescId = zc_MI_Master()
                                              AND MI_Goods.isErased = FALSE
                                            
           LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                       ON MIFloat_AmountPlanMax.MovementItemId = MI_Goods.Id
                                      AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()
                                                          
      WHERE COALESCE(NULLIF(MIFloat_AmountPlanMax.ValueData, 0), MI_Goods.Amount) > 0
        AND (SELECT count(*) FROM tmpMovement) = 1;
        
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.07.22                                                       * 

*/

-- тест
-- 

SELECT * FROM gpSelect_PromoUnit_UnitGoods (inOperDate := CURRENT_DATE, inSession := '3')        