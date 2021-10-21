-- Function: gpSelect_MI_PromoStat_Master()

DROP FUNCTION IF EXISTS gpSelect_MI_PromoStat_Master (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_PromoStat_Master(
    IN inMovementId  Integer      , -- ключ Документа Акция
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (
        Id                  Integer --идентификатор
      , MovementId          Integer --ИД документа <Акция>
      , GoodsId             Integer --ИД объекта <товар>
      , GoodsCode           Integer --код объекта  <товар>
      , GoodsName           TVarChar --наименование объекта <товар>
      , MeasureName         TVarChar --Единица измерения
      , TradeMarkName       TVarChar --Торговая марка
      , GoodsKindName       TVarChar --Наименование обьекта <Вид товара> 
      , GoodsWeight         TFloat -- 
      , StartDate           TDateTime
      , EndDate             TDateTime
      , AmountPlan1         TFloat -- Кол-во план отгрузки за пн.
      , AmountPlan2         TFloat -- Кол-во план отгрузки за вт.
      , AmountPlan3         TFloat -- Кол-во план отгрузки за ср.
      , AmountPlan4         TFloat -- Кол-во план отгрузки за чт.
      , AmountPlan5         TFloat -- Кол-во план отгрузки за пт.
      , AmountPlan6         TFloat -- Кол-во план отгрузки за сб.
      , AmountPlan7         TFloat -- Кол-во план отгрузки за вс.
      , AmountPlanBranch1         TFloat -- Кол-во план отгрузки за пн.
      , AmountPlanBranch2         TFloat -- Кол-во план отгрузки за вт.
      , AmountPlanBranch3         TFloat -- Кол-во план отгрузки за ср.
      , AmountPlanBranch4         TFloat -- Кол-во план отгрузки за чт.
      , AmountPlanBranch5         TFloat -- Кол-во план отгрузки за пт.
      , AmountPlanBranch6         TFloat -- Кол-во план отгрузки за сб.
      , AmountPlanBranch7         TFloat -- Кол-во план отгрузки за вс.
      , isErased            Boolean  --удален
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoGoods());
    vbUserId:= lpGetUserBySession (inSession);


    RETURN QUERY
                             
        SELECT MovementItem.Id                        AS Id                  --идентификатор
             , MovementItem.MovementId                AS MovementId          --ИД документа <Акция>
             , MovementItem.ObjectId                  AS GoodsId             --ИД объекта <товар>
             , Object_Goods.ObjectCode::Integer       AS GoodsCode           --код объекта  <товар>
             , Object_Goods.ValueData                 AS GoodsName           --наименование объекта <товар>
             , Object_Measure.ValueData               AS Measure             --Единица измерения
             , Object_TradeMark.ValueData             AS TradeMark           --Торговая марка
             , Object_GoodsKind.ValueData             AS GoodsKindName       --Наименование обьекта <Вид товара>
             , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END::TFloat as GoodsWeight -- Вес

             , MIDate_Start.ValueData                 AS StartDate
             , MIDate_End.ValueData                   AS EndDate

             , MIFloat_Plan1.ValueData                AS AmountPlan1
             , MIFloat_Plan2.ValueData                AS AmountPlan2
             , MIFloat_Plan3.ValueData                AS AmountPlan3
             , MIFloat_Plan4.ValueData                AS AmountPlan4
             , MIFloat_Plan5.ValueData                AS AmountPlan5
             , MIFloat_Plan6.ValueData                AS AmountPlan6
             , MIFloat_Plan7.ValueData                AS AmountPlan7 

             , MIFloat_PlanBranch1.ValueData          AS AmountPlanBranch1
             , MIFloat_PlanBranch2.ValueData          AS AmountPlanBranch2
             , MIFloat_PlanBranch3.ValueData          AS AmountPlanBranch3
             , MIFloat_PlanBranch4.ValueData          AS AmountPlanBranch4
             , MIFloat_PlanBranch5.ValueData          AS AmountPlanBranch5
             , MIFloat_PlanBranch6.ValueData          AS AmountPlanBranch6
             , MIFloat_PlanBranch7.ValueData          AS AmountPlanBranch7 
    
             , MovementItem.isErased                  AS isErased            -- Удален
        FROM Movement
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId = zc_MI_Master()
                                    AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)

             LEFT JOIN MovementItemDate AS MIDate_Start
                                        ON MIDate_Start.MovementItemId = MovementItem.Id
                                       AND MIDate_Start.DescId = zc_MIDate_Start()
             LEFT JOIN MovementItemDate AS MIDate_End
                                        ON MIDate_End.MovementItemId = MovementItem.Id
                                       AND MIDate_End.DescId = zc_MIDate_End()

             LEFT JOIN MovementItemFloat AS MIFloat_Plan1
                                         ON MIFloat_Plan1.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan1.DescId = zc_MIFloat_Plan1()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan2
                                         ON MIFloat_Plan2.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan2.DescId = zc_MIFloat_Plan2()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan3
                                         ON MIFloat_Plan3.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan3.DescId = zc_MIFloat_Plan3()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan4
                                         ON MIFloat_Plan4.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan4.DescId = zc_MIFloat_Plan4()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan5
                                         ON MIFloat_Plan5.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan5.DescId = zc_MIFloat_Plan5()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan6
                                         ON MIFloat_Plan6.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan6.DescId = zc_MIFloat_Plan6()
             LEFT JOIN MovementItemFloat AS MIFloat_Plan7
                                         ON MIFloat_Plan7.MovementItemId = MovementItem.Id 
                                        AND MIFloat_Plan7.DescId = zc_MIFloat_Plan7() 

             LEFT JOIN MovementItemFloat AS MIFloat_PlanBranch1
                                         ON MIFloat_PlanBranch1.MovementItemId = MovementItem.Id 
                                        AND MIFloat_PlanBranch1.DescId = zc_MIFloat_PlanBranch1()
             LEFT JOIN MovementItemFloat AS MIFloat_PlanBranch2
                                         ON MIFloat_PlanBranch2.MovementItemId = MovementItem.Id 
                                        AND MIFloat_PlanBranch2.DescId = zc_MIFloat_PlanBranch2()
             LEFT JOIN MovementItemFloat AS MIFloat_PlanBranch3
                                         ON MIFloat_PlanBranch3.MovementItemId = MovementItem.Id 
                                        AND MIFloat_PlanBranch3.DescId = zc_MIFloat_PlanBranch3()
             LEFT JOIN MovementItemFloat AS MIFloat_PlanBranch4
                                         ON MIFloat_PlanBranch4.MovementItemId = MovementItem.Id 
                                        AND MIFloat_PlanBranch4.DescId = zc_MIFloat_PlanBranch4()
             LEFT JOIN MovementItemFloat AS MIFloat_PlanBranch5
                                         ON MIFloat_PlanBranch5.MovementItemId = MovementItem.Id 
                                        AND MIFloat_PlanBranch5.DescId = zc_MIFloat_PlanBranch5()
             LEFT JOIN MovementItemFloat AS MIFloat_PlanBranch6
                                         ON MIFloat_PlanBranch6.MovementItemId = MovementItem.Id 
                                        AND MIFloat_PlanBranch6.DescId = zc_MIFloat_PlanBranch6()
             LEFT JOIN MovementItemFloat AS MIFloat_PlanBranch7
                                         ON MIFloat_PlanBranch7.MovementItemId = MovementItem.Id 
                                        AND MIFloat_PlanBranch7.DescId = zc_MIFloat_PlanBranch7() 

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind 
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                   AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
                              
             LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                         ON ObjectFloat_Goods_Weight.ObjectId = MovementItem.ObjectId
                                        AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()

        WHERE Movement.DescId = zc_Movement_PromoStat()
          AND Movement.ParentId = inMovementId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.10.21         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_PromoStat_Master (5083159 , FALSE, zfCalc_UserAdmin());