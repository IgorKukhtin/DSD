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

      , Amount1   TFloat
      , Amount2   TFloat
      , Amount3   TFloat
      , Amount4   TFloat
      , Amount5   TFloat
      , Amount6   TFloat
      , Amount7   TFloat
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
                   , ROW_NUMBER() OVER(ORDER BY MovementItem.Id) AS Ord
              FROM Movement
                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.DescId = zc_MI_Master()
                                         AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
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
  , tmpMIFloat_avg AS (SELECT SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan1(), zc_MIFloat_PlanBranch1()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan1
                            , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan2(), zc_MIFloat_PlanBranch2()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan2
                            , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan3(), zc_MIFloat_PlanBranch3()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan3
                            , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan4(), zc_MIFloat_PlanBranch4()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan4
                            , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan5(), zc_MIFloat_PlanBranch5()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan5
                            , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan6(), zc_MIFloat_PlanBranch6()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan6
                            , SUM (CASE WHEN tmpMIFloat.DescId IN (zc_MIFloat_Plan7(), zc_MIFloat_PlanBranch7()) THEN COALESCE (tmpMIFloat.ValueData,0) ELSE 0 END)/5 AS Plan7
                       FROM tmpMIFloat
                       )
  --даты продаж
  , tmpListDateSale AS (SELECT generate_series(vbStartSale::TDateTime, vbEndSale::TDateTime, '1 DAY'::interval) AS OperDate)
  
  -- считаем план на даты продаж акции
  , tmpCalc AS (SELECT SUM (CASE WHEN tmpWeekDay.Number = 1 THEN (SELECT tmp.Plan1 FROM tmpMIFloat_avg AS tmp) ELSE 0 END) Amount1
                     , SUM (CASE WHEN tmpWeekDay.Number = 2 THEN (SELECT tmp.Plan2 FROM tmpMIFloat_avg AS tmp) ELSE 0 END) Amount2
                     , SUM (CASE WHEN tmpWeekDay.Number = 3 THEN (SELECT tmp.Plan3 FROM tmpMIFloat_avg AS tmp) ELSE 0 END) Amount3
                     , SUM (CASE WHEN tmpWeekDay.Number = 4 THEN (SELECT tmp.Plan4 FROM tmpMIFloat_avg AS tmp) ELSE 0 END) Amount4
                     , SUM (CASE WHEN tmpWeekDay.Number = 5 THEN (SELECT tmp.Plan5 FROM tmpMIFloat_avg AS tmp) ELSE 0 END) Amount5
                     , SUM (CASE WHEN tmpWeekDay.Number = 6 THEN (SELECT tmp.Plan6 FROM tmpMIFloat_avg AS tmp) ELSE 0 END) Amount6
                     , SUM (CASE WHEN tmpWeekDay.Number = 7 THEN (SELECT tmp.Plan7 FROM tmpMIFloat_avg AS tmp) ELSE 0 END) Amount7
                     --кол-во дней ПН, ВТ, СР, ЧТ, ПТ, СБ, ВС
                     , SUM (CASE WHEN tmpWeekDay.Number = 1 THEN 1 ELSE 0 END) WeekDay1
                     , SUM (CASE WHEN tmpWeekDay.Number = 2 THEN 1 ELSE 0 END) WeekDay2
                     , SUM (CASE WHEN tmpWeekDay.Number = 3 THEN 1 ELSE 0 END) WeekDay3
                     , SUM (CASE WHEN tmpWeekDay.Number = 4 THEN 1 ELSE 0 END) WeekDay4
                     , SUM (CASE WHEN tmpWeekDay.Number = 5 THEN 1 ELSE 0 END) WeekDay5
                     , SUM (CASE WHEN tmpWeekDay.Number = 6 THEN 1 ELSE 0 END) WeekDay6
                     , SUM (CASE WHEN tmpWeekDay.Number = 7 THEN 1 ELSE 0 END) WeekDay7
                FROM tmpListDateSale
                    LEFT JOIN zfCalc_DayOfWeekName (tmpListDateSale.OperDate) AS tmpWeekDay ON 1=1
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

             , tmpCalc.Amount1   ::TFloat
             , tmpCalc.Amount2   ::TFloat
             , tmpCalc.Amount3   ::TFloat
             , tmpCalc.Amount4   ::TFloat
             , tmpCalc.Amount5   ::TFloat
             , tmpCalc.Amount6   ::TFloat
             , tmpCalc.Amount7   ::TFloat
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

             LEFT JOIN tmpCalc ON MovementItem.Ord = 1 --привязываем к 1 строке
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