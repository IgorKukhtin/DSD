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
      , AmountPlanBranch1   TFloat -- Кол-во план отгрузки за пн.
      , AmountPlanBranch2   TFloat -- Кол-во план отгрузки за вт.
      , AmountPlanBranch3   TFloat -- Кол-во план отгрузки за ср.
      , AmountPlanBranch4   TFloat -- Кол-во план отгрузки за чт.
      , AmountPlanBranch5   TFloat -- Кол-во план отгрузки за пт.
      , AmountPlanBranch6   TFloat -- Кол-во план отгрузки за сб.
      , AmountPlanBranch7   TFloat -- Кол-во план отгрузки за вс.
      , AmountPlan          TFloat -- Итого Кол-во план отгрузки

      , Amount1   TFloat
      , Amount2   TFloat
      , Amount3   TFloat
      , Amount4   TFloat
      , Amount5   TFloat
      , Amount6   TFloat
      , Amount7   TFloat
      , TotalAmount_Avg  TFloat  -- Итого по ср.за период акции (Сумма (ср.значение дня недели * кол.дней недели) )
      , Koef      TFloat
      , WeekDay1  TFloat
      , WeekDay2  TFloat
      , WeekDay3  TFloat
      , WeekDay4  TFloat
      , WeekDay5  TFloat
      , WeekDay6  TFloat
      , WeekDay7  TFloat
      , isErased            Boolean  --удален
)
AS
$BODY$
    DECLARE vbUserId    Integer;
    DECLARE vbStartSale TDateTime;
    DECLARE vbEndSale   TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoGoods());
    vbUserId:= lpGetUserBySession (inSession);

    SELECT MovementDate_StartSale.ValueData AS StartSale
         , MovementDate_EndSale.ValueData   AS EndSale
   INTO vbStartSale, vbEndSale
    FROM Movement
        LEFT JOIN MovementDate AS MovementDate_StartSale
                               ON MovementDate_StartSale.MovementId = Movement.Id
                              AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
        LEFT JOIN MovementDate AS MovementDate_EndSale
                               ON MovementDate_EndSale.MovementId = Movement.Id
                              AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
    WHERE Movement.Id = inMovementId;

    RETURN QUERY
    WITH
    tmpMI AS (SELECT MovementItem.*
                   , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                   , ROW_NUMBER() OVER(PARTITION BY MovementItem.ObjectId , MILinkObject_GoodsKind.ObjectId ORDER BY MovementItem.Id) AS Ord
              FROM Movement
                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.DescId = zc_MI_Master()
                                         AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind 
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                  --LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
              WHERE Movement.DescId = zc_Movement_PromoStat()
                AND Movement.ParentId = inMovementId
              )
  , tmpMIFloat AS (SELECT MovementItemFloat.*
                   FROM MovementItemFloat
                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                     AND MovementItemFloat.DescId IN (zc_MIFloat_Plan1(), zc_MIFloat_Plan2(), zc_MIFloat_Plan3(), zc_MIFloat_Plan4(), zc_MIFloat_Plan5(), zc_MIFloat_Plan6(), zc_MIFloat_Plan7()
                                                    , zc_MIFloat_PlanBranch1(), zc_MIFloat_PlanBranch2(), zc_MIFloat_PlanBranch3(), zc_MIFloat_PlanBranch4(), zc_MIFloat_PlanBranch5(), zc_MIFloat_PlanBranch6(), zc_MIFloat_PlanBranch7())
                  )
  -- выбираем данные план и находим среднее значение за 1 день, план выбирался за 5 недель, поэтому /5
  , tmpMIFloat_avg AS (SELECT tmpMI.ObjectId
                            , tmpMI.GoodsKindId
                            , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan1(), zc_MIFloat_PlanBranch1()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan1
                            , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan2(), zc_MIFloat_PlanBranch2()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan2
                            , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan3(), zc_MIFloat_PlanBranch3()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan3
                            , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan4(), zc_MIFloat_PlanBranch4()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan4
                            , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan5(), zc_MIFloat_PlanBranch5()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan5
                            , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan6(), zc_MIFloat_PlanBranch6()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan6
                            , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan7(), zc_MIFloat_PlanBranch7()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan7
                       FROM tmpMIFloat
                            LEFT JOIN tmpMI ON tmpMI.Id = tmpMIFloat.MovementItemId
                       GROUP BY tmpMI.ObjectId
                              , tmpMI.GoodsKindId
                       )
  --даты продаж
  , tmpListDateSale AS (SELECT generate_series(vbStartSale::TDateTime, vbEndSale::TDateTime, '1 DAY'::interval) AS OperDate)
  
  -- считаем план на даты продаж акции
  , tmpCalc AS (SELECT tmpGoods.ObjectId AS GoodsId
                     , tmpGoods.GoodsKindId
                     , SUM (CASE WHEN tmpWeekDay.Number = 1 THEN COALESCE (tmpMIFloat_avg.Plan1,0) ELSE 0 END) Amount1
                     , SUM (CASE WHEN tmpWeekDay.Number = 2 THEN COALESCE (tmpMIFloat_avg.Plan2,0) ELSE 0 END) Amount2
                     , SUM (CASE WHEN tmpWeekDay.Number = 3 THEN COALESCE (tmpMIFloat_avg.Plan3,0) ELSE 0 END) Amount3
                     , SUM (CASE WHEN tmpWeekDay.Number = 4 THEN COALESCE (tmpMIFloat_avg.Plan4,0) ELSE 0 END) Amount4
                     , SUM (CASE WHEN tmpWeekDay.Number = 5 THEN COALESCE (tmpMIFloat_avg.Plan5,0) ELSE 0 END) Amount5
                     , SUM (CASE WHEN tmpWeekDay.Number = 6 THEN COALESCE (tmpMIFloat_avg.Plan6,0) ELSE 0 END) Amount6
                     , SUM (CASE WHEN tmpWeekDay.Number = 7 THEN COALESCE (tmpMIFloat_avg.Plan7,0) ELSE 0 END) Amount7
                     --кол-во дней ПН, ВТ, СР, ЧТ, ПТ, СБ, ВС
                     , SUM (CASE WHEN tmpWeekDay.Number = 1 AND COALESCE (tmpMIFloat_avg.Plan1,0) <> 0 THEN 1 ELSE 0 END) WeekDay1
                     , SUM (CASE WHEN tmpWeekDay.Number = 2 AND COALESCE (tmpMIFloat_avg.Plan2,0) <> 0 THEN 1 ELSE 0 END) WeekDay2
                     , SUM (CASE WHEN tmpWeekDay.Number = 3 AND COALESCE (tmpMIFloat_avg.Plan3,0) <> 0 THEN 1 ELSE 0 END) WeekDay3
                     , SUM (CASE WHEN tmpWeekDay.Number = 4 AND COALESCE (tmpMIFloat_avg.Plan4,0) <> 0 THEN 1 ELSE 0 END) WeekDay4
                     , SUM (CASE WHEN tmpWeekDay.Number = 5 AND COALESCE (tmpMIFloat_avg.Plan5,0) <> 0 THEN 1 ELSE 0 END) WeekDay5
                     , SUM (CASE WHEN tmpWeekDay.Number = 6 AND COALESCE (tmpMIFloat_avg.Plan6,0) <> 0 THEN 1 ELSE 0 END) WeekDay6
                     , SUM (CASE WHEN tmpWeekDay.Number = 7 AND COALESCE (tmpMIFloat_avg.Plan7,0) <> 0 THEN 1 ELSE 0 END) WeekDay7
                     --
                     , SUM (CASE WHEN tmpWeekDay.Number = 1 THEN COALESCE (tmpMIFloat_avg.Plan1,0) ELSE 0 END
                          + CASE WHEN tmpWeekDay.Number = 2 THEN COALESCE (tmpMIFloat_avg.Plan2,0) ELSE 0 END
                          + CASE WHEN tmpWeekDay.Number = 3 THEN COALESCE (tmpMIFloat_avg.Plan3,0) ELSE 0 END
                          + CASE WHEN tmpWeekDay.Number = 4 THEN COALESCE (tmpMIFloat_avg.Plan4,0) ELSE 0 END
                          + CASE WHEN tmpWeekDay.Number = 5 THEN COALESCE (tmpMIFloat_avg.Plan5,0) ELSE 0 END
                          + CASE WHEN tmpWeekDay.Number = 6 THEN COALESCE (tmpMIFloat_avg.Plan6,0) ELSE 0 END
                          + CASE WHEN tmpWeekDay.Number = 7 THEN COALESCE (tmpMIFloat_avg.Plan7,0) ELSE 0 END) TotalAmount
                FROM tmpListDateSale
                    LEFT JOIN zfCalc_DayOfWeekName (tmpListDateSale.OperDate) AS tmpWeekDay ON 1=1
                    LEFT JOIN (SELECT tmpMI.ObjectId, tmpMI.GoodsKindId FROM tmpMI WHERE tmpMI.Ord = 1) AS tmpGoods ON  1=1
                    LEFT JOIN tmpMIFloat_avg ON tmpMIFloat_avg.ObjectId = tmpGoods.ObjectId
                GROUP BY tmpGoods.ObjectId
                       , tmpGoods.GoodsKindId
                )
  --для товара береи AmountPlanMax из док Акция, для получения коэф.расчета 
  , tmpMI_Promo AS (SELECT MovementItem.ObjectId AS GoodsId
                         , SUM (COALESCE (MIFloat_AmountPlanMax.ValueData,0)) AS AmountPlanMax
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                                     ON MIFloat_AmountPlanMax.MovementItemId = MovementItem.Id
                                                    AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.isErased = FALSE
                    GROUP BY MovementItem.ObjectId
                    )
                       

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

             , (COALESCE (MIFloat_Plan1.ValueData,0)
              + COALESCE (MIFloat_Plan2.ValueData,0)
              + COALESCE (MIFloat_Plan3.ValueData,0)
              + COALESCE (MIFloat_Plan4.ValueData,0)
              + COALESCE (MIFloat_Plan5.ValueData,0)
              + COALESCE (MIFloat_Plan6.ValueData,0)
              + COALESCE (MIFloat_Plan7.ValueData,0)
              + COALESCE (MIFloat_PlanBranch1.ValueData,0)
              + COALESCE (MIFloat_PlanBranch2.ValueData,0)
              + COALESCE (MIFloat_PlanBranch3.ValueData,0)
              + COALESCE (MIFloat_PlanBranch4.ValueData,0)
              + COALESCE (MIFloat_PlanBranch5.ValueData,0)
              + COALESCE (MIFloat_PlanBranch6.ValueData,0)
              + COALESCE (MIFloat_PlanBranch7.ValueData,0)) ::TFloat AS AmountPlan

             , tmpMIFloat_avg.Plan1 ::TFloat AS Amount1   
             , tmpMIFloat_avg.Plan2 ::TFloat AS Amount2
             , tmpMIFloat_avg.Plan3 ::TFloat AS Amount3
             , tmpMIFloat_avg.Plan4 ::TFloat AS Amount4
             , tmpMIFloat_avg.Plan5 ::TFloat AS Amount5
             , tmpMIFloat_avg.Plan6 ::TFloat AS Amount6
             , tmpMIFloat_avg.Plan7 ::TFloat AS Amount7
             /*, (COALESCE (tmpCalc.Amount1,0)
              + COALESCE (tmpCalc.Amount2,0)
              + COALESCE (tmpCalc.Amount3,0)
              + COALESCE (tmpCalc.Amount4,0)
              + COALESCE (tmpCalc.Amount5,0)
              + COALESCE (tmpCalc.Amount6,0)
              + COALESCE (tmpCalc.Amount7,0)) ::TFloat AS TotalAmount_Avg*/

             , tmpCalc.TotalAmount ::TFloat AS TotalAmount_Avg
             , CASE WHEN COALESCE (tmpCalc.TotalAmount,0) <> 0 THEN tmpMI_Promo.AmountPlanMax/tmpCalc.TotalAmount ELSE 0 END ::TFloat AS Koef

             , tmpCalc.WeekDay1  ::TFloat
             , tmpCalc.WeekDay2  ::TFloat
             , tmpCalc.WeekDay3  ::TFloat
             , tmpCalc.WeekDay4  ::TFloat
             , tmpCalc.WeekDay5  ::TFloat
             , tmpCalc.WeekDay6  ::TFloat
             , tmpCalc.WeekDay7  ::TFloat
             


             , MovementItem.isErased                  AS isErased            -- Удален
        FROM tmpMI AS MovementItem
             LEFT JOIN MovementItemDate AS MIDate_Start
                                        ON MIDate_Start.MovementItemId = MovementItem.Id
                                       AND MIDate_Start.DescId = zc_MIDate_Start()
             LEFT JOIN MovementItemDate AS MIDate_End
                                        ON MIDate_End.MovementItemId = MovementItem.Id
                                       AND MIDate_End.DescId = zc_MIDate_End()

             LEFT JOIN tmpMIFloat AS MIFloat_Plan1
                                  ON MIFloat_Plan1.MovementItemId = MovementItem.Id 
                                 AND MIFloat_Plan1.DescId = zc_MIFloat_Plan1()
             LEFT JOIN tmpMIFloat AS MIFloat_Plan2
                                  ON MIFloat_Plan2.MovementItemId = MovementItem.Id 
                                 AND MIFloat_Plan2.DescId = zc_MIFloat_Plan2()
             LEFT JOIN tmpMIFloat AS MIFloat_Plan3
                                  ON MIFloat_Plan3.MovementItemId = MovementItem.Id 
                                 AND MIFloat_Plan3.DescId = zc_MIFloat_Plan3()
             LEFT JOIN tmpMIFloat AS MIFloat_Plan4
                                  ON MIFloat_Plan4.MovementItemId = MovementItem.Id 
                                 AND MIFloat_Plan4.DescId = zc_MIFloat_Plan4()
             LEFT JOIN tmpMIFloat AS MIFloat_Plan5
                                  ON MIFloat_Plan5.MovementItemId = MovementItem.Id 
                                 AND MIFloat_Plan5.DescId = zc_MIFloat_Plan5()
             LEFT JOIN tmpMIFloat AS MIFloat_Plan6
                                  ON MIFloat_Plan6.MovementItemId = MovementItem.Id 
                                 AND MIFloat_Plan6.DescId = zc_MIFloat_Plan6()
             LEFT JOIN tmpMIFloat AS MIFloat_Plan7
                                  ON MIFloat_Plan7.MovementItemId = MovementItem.Id 
                                 AND MIFloat_Plan7.DescId = zc_MIFloat_Plan7() 

             LEFT JOIN tmpMIFloat AS MIFloat_PlanBranch1
                                  ON MIFloat_PlanBranch1.MovementItemId = MovementItem.Id 
                                 AND MIFloat_PlanBranch1.DescId = zc_MIFloat_PlanBranch1()
             LEFT JOIN tmpMIFloat AS MIFloat_PlanBranch2
                                  ON MIFloat_PlanBranch2.MovementItemId = MovementItem.Id 
                                 AND MIFloat_PlanBranch2.DescId = zc_MIFloat_PlanBranch2()
             LEFT JOIN tmpMIFloat AS MIFloat_PlanBranch3
                                  ON MIFloat_PlanBranch3.MovementItemId = MovementItem.Id 
                                 AND MIFloat_PlanBranch3.DescId = zc_MIFloat_PlanBranch3()
             LEFT JOIN tmpMIFloat AS MIFloat_PlanBranch4
                                  ON MIFloat_PlanBranch4.MovementItemId = MovementItem.Id 
                                 AND MIFloat_PlanBranch4.DescId = zc_MIFloat_PlanBranch4()
             LEFT JOIN tmpMIFloat AS MIFloat_PlanBranch5
                                  ON MIFloat_PlanBranch5.MovementItemId = MovementItem.Id 
                                 AND MIFloat_PlanBranch5.DescId = zc_MIFloat_PlanBranch5()
             LEFT JOIN tmpMIFloat AS MIFloat_PlanBranch6
                                  ON MIFloat_PlanBranch6.MovementItemId = MovementItem.Id 
                                 AND MIFloat_PlanBranch6.DescId = zc_MIFloat_PlanBranch6()
             LEFT JOIN tmpMIFloat AS MIFloat_PlanBranch7
                                  ON MIFloat_PlanBranch7.MovementItemId = MovementItem.Id 
                                 AND MIFloat_PlanBranch7.DescId = zc_MIFloat_PlanBranch7() 

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MovementItem.GoodsKindId

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

             LEFT JOIN tmpCalc ON tmpCalc.GoodsId = MovementItem.ObjectId
                              AND tmpCalc.GoodsKindId = MovementItem.GoodsKindId
                              AND MovementItem.Ord = 1 --привязываем к 1 строке

             LEFT JOIN tmpMIFloat_avg ON tmpMIFloat_avg.ObjectId = MovementItem.ObjectId
                                     AND MovementItem.Ord = 1 --привязываем к 1 строке
             LEFT JOIN tmpMI_Promo ON tmpMI_Promo.GoodsId = MovementItem.ObjectId
                                  AND MovementItem.Ord = 1 --привязываем к 1 строке
            ;

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