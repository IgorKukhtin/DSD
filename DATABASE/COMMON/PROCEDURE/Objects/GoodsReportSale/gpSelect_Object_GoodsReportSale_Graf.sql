-- Function: gpSelect_Object_GoodsReportSale()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsReportSale_Graf(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsReportSale_Graf(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Key_UnitGoods       TVarchar
             , NumDays             TVarchar
             , AnalysisAmount      TFloat
             , AnalysisOrder       TFloat
             , AmountPromoBranch   TFloat
             , OrderPromoBranch    TFloat
             , AmountBranch        TFloat
             , AmountOrder         TFloat
             
             , PromoPlan          TFloat
             , PromoBranchPlan    TFloat
             , AnalysisPromoPlan  TFloat
             ) AS
$BODY$
   DECLARE vbWeek      TFloat;
BEGIN
       vbWeek := (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.DescId = zc_ObjectFloat_GoodsReportSaleInf_Week());

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

       RETURN QUERY
       WITH
       tmpData AS (SELECT (ObjectLink_Unit.ChildObjectId||'_'||ObjectLink_Goods.ChildObjectId||'_'||ObjectLink_GoodsKind.ChildObjectId)  :: TVarChar AS Key_UnitGoods
            --
                        , ((ObjectFloat_Branch1.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Branch1
                        , ((ObjectFloat_Branch2.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Branch2
                        , ((ObjectFloat_Branch3.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Branch3
                        , ((ObjectFloat_Branch4.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Branch4
                        , ((ObjectFloat_Branch5.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Branch5
                        , ((ObjectFloat_Branch6.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Branch6
                        , ((ObjectFloat_Branch7.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Branch7
            --
                        , ((ObjectFloat_Order1.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Order1
                        , ((ObjectFloat_Order2.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Order2
                        , ((ObjectFloat_Order3.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Order3
                        , ((ObjectFloat_Order4.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Order4
                        , ((ObjectFloat_Order5.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Order5
                        , ((ObjectFloat_Order6.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Order6
                        , ((ObjectFloat_Order7.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Order7
            
            --
                          -- Итого Кол-во Реализация со склада + Акции + Расход на Филиал - ПО ДНЯМ
                        , ((COALESCE (ObjectFloat_Amount1.ValueData, 0) + COALESCE (ObjectFloat_Promo1.ValueData, 0) + COALESCE (ObjectFloat_Branch1.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AmountPromoBranch1
                        , ((COALESCE (ObjectFloat_Amount2.ValueData, 0) + COALESCE (ObjectFloat_Promo2.ValueData, 0) + COALESCE (ObjectFloat_Branch2.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AmountPromoBranch2
                        , ((COALESCE (ObjectFloat_Amount3.ValueData, 0) + COALESCE (ObjectFloat_Promo3.ValueData, 0) + COALESCE (ObjectFloat_Branch3.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AmountPromoBranch3
                        , ((COALESCE (ObjectFloat_Amount4.ValueData, 0) + COALESCE (ObjectFloat_Promo4.ValueData, 0) + COALESCE (ObjectFloat_Branch4.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AmountPromoBranch4
                        , ((COALESCE (ObjectFloat_Amount5.ValueData, 0) + COALESCE (ObjectFloat_Promo5.ValueData, 0) + COALESCE (ObjectFloat_Branch5.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AmountPromoBranch5
                        , ((COALESCE (ObjectFloat_Amount6.ValueData, 0) + COALESCE (ObjectFloat_Promo6.ValueData, 0) + COALESCE (ObjectFloat_Branch6.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AmountPromoBranch6
                        , ((COALESCE (ObjectFloat_Amount7.ValueData, 0) + COALESCE (ObjectFloat_Promo7.ValueData, 0) + COALESCE (ObjectFloat_Branch7.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AmountPromoBranch7
            --
                          -- ИТОГО Кол-во Заявка Покупателей + Акции + с Филиала - ПО ДНЯМ
                        , ((COALESCE (ObjectFloat_Order1.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo1.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch1.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS OrderPromoBranch1
                        , ((COALESCE (ObjectFloat_Order2.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo2.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch2.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS OrderPromoBranch2
                        , ((COALESCE (ObjectFloat_Order3.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo3.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch3.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS OrderPromoBranch3
                        , ((COALESCE (ObjectFloat_Order4.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo4.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch4.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS OrderPromoBranch4
                        , ((COALESCE (ObjectFloat_Order5.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo5.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch5.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS OrderPromoBranch5
                        , ((COALESCE (ObjectFloat_Order6.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo6.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch6.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS OrderPromoBranch6
                        , ((COALESCE (ObjectFloat_Order7.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo7.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch7.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS OrderPromoBranch7
            
            --
                          -- Итого для СТАТИСТИКИ Кол-во Реализация со склада + Расход на Филиал - ПО ДНЯМ
                        , ((COALESCE (ObjectFloat_Amount1.ValueData, 0) + COALESCE (ObjectFloat_Branch1.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisAmount1
                        , ((COALESCE (ObjectFloat_Amount2.ValueData, 0) + COALESCE (ObjectFloat_Branch2.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisAmount2
                        , ((COALESCE (ObjectFloat_Amount3.ValueData, 0) + COALESCE (ObjectFloat_Branch3.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisAmount3
                        , ((COALESCE (ObjectFloat_Amount4.ValueData, 0) + COALESCE (ObjectFloat_Branch4.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisAmount4
                        , ((COALESCE (ObjectFloat_Amount5.ValueData, 0) + COALESCE (ObjectFloat_Branch5.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisAmount5
                        , ((COALESCE (ObjectFloat_Amount6.ValueData, 0) + COALESCE (ObjectFloat_Branch6.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisAmount6
                        , ((COALESCE (ObjectFloat_Amount7.ValueData, 0) + COALESCE (ObjectFloat_Branch7.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisAmount7
            --
                          -- ИТОГО для СТАТИСТИКИ Кол-во Заявка Покупателей + с Филиала - ПО ДНЯМ
                        , ((COALESCE (ObjectFloat_Order1.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch1.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisOrder1
                        , ((COALESCE (ObjectFloat_Order2.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch2.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisOrder2
                        , ((COALESCE (ObjectFloat_Order3.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch3.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisOrder3
                        , ((COALESCE (ObjectFloat_Order4.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch4.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisOrder4
                        , ((COALESCE (ObjectFloat_Order5.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch5.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisOrder5
                        , ((COALESCE (ObjectFloat_Order6.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch6.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisOrder6
                        , ((COALESCE (ObjectFloat_Order7.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch7.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisOrder7

                        , ((ObjectFloat_PromoPlan1.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoPlan1
                        , ((ObjectFloat_PromoPlan2.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoPlan2
                        , ((ObjectFloat_PromoPlan3.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoPlan3
                        , ((ObjectFloat_PromoPlan4.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoPlan4
                        , ((ObjectFloat_PromoPlan5.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoPlan5
                        , ((ObjectFloat_PromoPlan6.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoPlan6
                        , ((ObjectFloat_PromoPlan7.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoPlan7
            
                        , ((ObjectFloat_PromoBranchPlan1.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoBranchPlan1
                        , ((ObjectFloat_PromoBranchPlan2.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoBranchPlan2
                        , ((ObjectFloat_PromoBranchPlan3.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoBranchPlan3
                        , ((ObjectFloat_PromoBranchPlan4.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoBranchPlan4
                        , ((ObjectFloat_PromoBranchPlan5.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoBranchPlan5
                        , ((ObjectFloat_PromoBranchPlan6.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoBranchPlan6
                        , ((ObjectFloat_PromoBranchPlan7.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoBranchPlan7
            
                         -- Итого для СТАТИСТИКИ Кол-во план в реализации только Акции + Кол-во план в расходе на филиал только Акции - ПО ДНЯМ
                        , ((COALESCE (ObjectFloat_PromoPlan1.ValueData, 0) + COALESCE (ObjectFloat_PromoBranchPlan1.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisPromoPlan1
                        , ((COALESCE (ObjectFloat_PromoPlan2.ValueData, 0) + COALESCE (ObjectFloat_PromoBranchPlan2.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisPromoPlan2
                        , ((COALESCE (ObjectFloat_PromoPlan3.ValueData, 0) + COALESCE (ObjectFloat_PromoBranchPlan3.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisPromoPlan3
                        , ((COALESCE (ObjectFloat_PromoPlan4.ValueData, 0) + COALESCE (ObjectFloat_PromoBranchPlan4.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisPromoPlan4
                        , ((COALESCE (ObjectFloat_PromoPlan5.ValueData, 0) + COALESCE (ObjectFloat_PromoBranchPlan5.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisPromoPlan5
                        , ((COALESCE (ObjectFloat_PromoPlan6.ValueData, 0) + COALESCE (ObjectFloat_PromoBranchPlan6.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisPromoPlan6
                        , ((COALESCE (ObjectFloat_PromoPlan7.ValueData, 0) + COALESCE (ObjectFloat_PromoBranchPlan7.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisPromoPlan7

                   FROM Object AS Object_GoodsReportSale
            
                        LEFT JOIN ObjectFloat AS ObjectFloat_Amount1
                                              ON ObjectFloat_Amount1.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Amount1.DescId = zc_ObjectFloat_GoodsReportSale_Amount1()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Amount2
                                              ON ObjectFloat_Amount2.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Amount2.DescId = zc_ObjectFloat_GoodsReportSale_Amount2()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Amount3
                                              ON ObjectFloat_Amount3.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Amount3.DescId = zc_ObjectFloat_GoodsReportSale_Amount3()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Amount4
                                              ON ObjectFloat_Amount4.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Amount4.DescId = zc_ObjectFloat_GoodsReportSale_Amount4()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Amount5
                                              ON ObjectFloat_Amount5.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Amount5.DescId = zc_ObjectFloat_GoodsReportSale_Amount5()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Amount6
                                              ON ObjectFloat_Amount6.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Amount6.DescId = zc_ObjectFloat_GoodsReportSale_Amount6()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Amount7
                                              ON ObjectFloat_Amount7.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Amount7.DescId = zc_ObjectFloat_GoodsReportSale_Amount7()
            --
                        LEFT JOIN ObjectFloat AS ObjectFloat_Promo1
                                              ON ObjectFloat_Promo1.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Promo1.DescId = zc_ObjectFloat_GoodsReportSale_Promo1()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Promo2
                                              ON ObjectFloat_Promo2.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Promo2.DescId = zc_ObjectFloat_GoodsReportSale_Promo2()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Promo3
                                              ON ObjectFloat_Promo3.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Promo3.DescId = zc_ObjectFloat_GoodsReportSale_Promo3()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Promo4
                                              ON ObjectFloat_Promo4.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Promo4.DescId = zc_ObjectFloat_GoodsReportSale_Promo4()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Promo5
                                              ON ObjectFloat_Promo5.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Promo5.DescId = zc_ObjectFloat_GoodsReportSale_Promo5()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Promo6
                                              ON ObjectFloat_Promo6.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Promo6.DescId = zc_ObjectFloat_GoodsReportSale_Promo6()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Promo7
                                              ON ObjectFloat_Promo7.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Promo7.DescId = zc_ObjectFloat_GoodsReportSale_Promo7()
            --
                        LEFT JOIN ObjectFloat AS ObjectFloat_Branch1
                                              ON ObjectFloat_Branch1.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Branch1.DescId = zc_ObjectFloat_GoodsReportSale_Branch1()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Branch2
                                              ON ObjectFloat_Branch2.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Branch2.DescId = zc_ObjectFloat_GoodsReportSale_Branch2()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Branch3
                                              ON ObjectFloat_Branch3.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Branch3.DescId = zc_ObjectFloat_GoodsReportSale_Branch3()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Branch4
                                              ON ObjectFloat_Branch4.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Branch4.DescId = zc_ObjectFloat_GoodsReportSale_Branch4()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Branch5
                                              ON ObjectFloat_Branch5.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Branch5.DescId = zc_ObjectFloat_GoodsReportSale_Branch5()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Branch6
                                              ON ObjectFloat_Branch6.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Branch6.DescId = zc_ObjectFloat_GoodsReportSale_Branch6()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Branch7
                                              ON ObjectFloat_Branch7.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Branch7.DescId = zc_ObjectFloat_GoodsReportSale_Branch7()
            --
                        LEFT JOIN ObjectFloat AS ObjectFloat_Order1
                                              ON ObjectFloat_Order1.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Order1.DescId = zc_ObjectFloat_GoodsReportSale_Order1()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Order2
                                              ON ObjectFloat_Order2.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Order2.DescId = zc_ObjectFloat_GoodsReportSale_Order2()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Order3
                                              ON ObjectFloat_Order3.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Order3.DescId = zc_ObjectFloat_GoodsReportSale_Order3()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Order4
                                              ON ObjectFloat_Order4.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Order4.DescId = zc_ObjectFloat_GoodsReportSale_Order4()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Order5
                                              ON ObjectFloat_Order5.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Order5.DescId = zc_ObjectFloat_GoodsReportSale_Order5()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Order6
                                              ON ObjectFloat_Order6.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Order6.DescId = zc_ObjectFloat_GoodsReportSale_Order6()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Order7
                                              ON ObjectFloat_Order7.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_Order7.DescId = zc_ObjectFloat_GoodsReportSale_Order7()
            --
                        LEFT JOIN ObjectFloat AS ObjectFloat_OrderPromo1
                                              ON ObjectFloat_OrderPromo1.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_OrderPromo1.DescId = zc_ObjectFloat_GoodsReportSale_OrderPromo1()
                        LEFT JOIN ObjectFloat AS ObjectFloat_OrderPromo2
                                              ON ObjectFloat_OrderPromo2.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_OrderPromo2.DescId = zc_ObjectFloat_GoodsReportSale_OrderPromo2()
                        LEFT JOIN ObjectFloat AS ObjectFloat_OrderPromo3
                                              ON ObjectFloat_OrderPromo3.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_OrderPromo3.DescId = zc_ObjectFloat_GoodsReportSale_OrderPromo3()
                        LEFT JOIN ObjectFloat AS ObjectFloat_OrderPromo4
                                              ON ObjectFloat_OrderPromo4.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_OrderPromo4.DescId = zc_ObjectFloat_GoodsReportSale_OrderPromo4()
                        LEFT JOIN ObjectFloat AS ObjectFloat_OrderPromo5
                                              ON ObjectFloat_OrderPromo5.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_OrderPromo5.DescId = zc_ObjectFloat_GoodsReportSale_OrderPromo5()
                        LEFT JOIN ObjectFloat AS ObjectFloat_OrderPromo6
                                              ON ObjectFloat_OrderPromo6.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_OrderPromo6.DescId = zc_ObjectFloat_GoodsReportSale_OrderPromo6()
                        LEFT JOIN ObjectFloat AS ObjectFloat_OrderPromo7
                                              ON ObjectFloat_OrderPromo7.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_OrderPromo7.DescId = zc_ObjectFloat_GoodsReportSale_OrderPromo7()
            --
                        LEFT JOIN ObjectFloat AS ObjectFloat_OrderBranch1
                                              ON ObjectFloat_OrderBranch1.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_OrderBranch1.DescId = zc_ObjectFloat_GoodsReportSale_OrderBranch1()
                        LEFT JOIN ObjectFloat AS ObjectFloat_OrderBranch2
                                              ON ObjectFloat_OrderBranch2.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_OrderBranch2.DescId = zc_ObjectFloat_GoodsReportSale_OrderBranch2()
                        LEFT JOIN ObjectFloat AS ObjectFloat_OrderBranch3
                                              ON ObjectFloat_OrderBranch3.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_OrderBranch3.DescId = zc_ObjectFloat_GoodsReportSale_OrderBranch3()
                        LEFT JOIN ObjectFloat AS ObjectFloat_OrderBranch4
                                              ON ObjectFloat_OrderBranch4.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_OrderBranch4.DescId = zc_ObjectFloat_GoodsReportSale_OrderBranch4()
                        LEFT JOIN ObjectFloat AS ObjectFloat_OrderBranch5
                                              ON ObjectFloat_OrderBranch5.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_OrderBranch5.DescId = zc_ObjectFloat_GoodsReportSale_OrderBranch5()
                        LEFT JOIN ObjectFloat AS ObjectFloat_OrderBranch6
                                              ON ObjectFloat_OrderBranch6.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_OrderBranch6.DescId = zc_ObjectFloat_GoodsReportSale_OrderBranch6()
                        LEFT JOIN ObjectFloat AS ObjectFloat_OrderBranch7
                                              ON ObjectFloat_OrderBranch7.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_OrderBranch7.DescId = zc_ObjectFloat_GoodsReportSale_OrderBranch7()
--
                        LEFT JOIN ObjectFloat AS ObjectFloat_PromoPlan1
                                              ON ObjectFloat_PromoPlan1.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_PromoPlan1.DescId = zc_ObjectFloat_GoodsReportSale_PromoPlan1()
                        LEFT JOIN ObjectFloat AS ObjectFloat_PromoPlan2
                                              ON ObjectFloat_PromoPlan2.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_PromoPlan2.DescId = zc_ObjectFloat_GoodsReportSale_PromoPlan2()
                        LEFT JOIN ObjectFloat AS ObjectFloat_PromoPlan3
                                              ON ObjectFloat_PromoPlan3.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_PromoPlan3.DescId = zc_ObjectFloat_GoodsReportSale_PromoPlan3()
                        LEFT JOIN ObjectFloat AS ObjectFloat_PromoPlan4
                                              ON ObjectFloat_PromoPlan4.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_PromoPlan4.DescId = zc_ObjectFloat_GoodsReportSale_PromoPlan4()
                        LEFT JOIN ObjectFloat AS ObjectFloat_PromoPlan5
                                              ON ObjectFloat_PromoPlan5.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_PromoPlan5.DescId = zc_ObjectFloat_GoodsReportSale_PromoPlan5()
                        LEFT JOIN ObjectFloat AS ObjectFloat_PromoPlan6
                                              ON ObjectFloat_PromoPlan6.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_PromoPlan6.DescId = zc_ObjectFloat_GoodsReportSale_PromoPlan6()
                        LEFT JOIN ObjectFloat AS ObjectFloat_PromoPlan7
                                              ON ObjectFloat_PromoPlan7.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_PromoPlan7.DescId = zc_ObjectFloat_GoodsReportSale_PromoPlan7()
--
                        LEFT JOIN ObjectFloat AS ObjectFloat_PromoBranchPlan1
                                              ON ObjectFloat_PromoBranchPlan1.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_PromoBranchPlan1.DescId = zc_ObjectFloat_GoodsReportSale_PromoBranchPlan1()
                        LEFT JOIN ObjectFloat AS ObjectFloat_PromoBranchPlan2
                                              ON ObjectFloat_PromoBranchPlan2.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_PromoBranchPlan2.DescId = zc_ObjectFloat_GoodsReportSale_PromoBranchPlan2()
                        LEFT JOIN ObjectFloat AS ObjectFloat_PromoBranchPlan3
                                              ON ObjectFloat_PromoBranchPlan3.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_PromoBranchPlan3.DescId = zc_ObjectFloat_GoodsReportSale_PromoBranchPlan3()
                        LEFT JOIN ObjectFloat AS ObjectFloat_PromoBranchPlan4
                                              ON ObjectFloat_PromoBranchPlan4.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_PromoBranchPlan4.DescId = zc_ObjectFloat_GoodsReportSale_PromoBranchPlan4()
                        LEFT JOIN ObjectFloat AS ObjectFloat_PromoBranchPlan5
                                              ON ObjectFloat_PromoBranchPlan5.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_PromoBranchPlan5.DescId = zc_ObjectFloat_GoodsReportSale_PromoBranchPlan5()
                        LEFT JOIN ObjectFloat AS ObjectFloat_PromoBranchPlan6
                                              ON ObjectFloat_PromoBranchPlan6.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_PromoBranchPlan6.DescId = zc_ObjectFloat_GoodsReportSale_PromoBranchPlan6()
                        LEFT JOIN ObjectFloat AS ObjectFloat_PromoBranchPlan7
                                              ON ObjectFloat_PromoBranchPlan7.ObjectId = Object_GoodsReportSale.Id
                                             AND ObjectFloat_PromoBranchPlan7.DescId = zc_ObjectFloat_GoodsReportSale_PromoBranchPlan7()
            --
                        LEFT JOIN ObjectLink AS ObjectLink_Unit
                                             ON ObjectLink_Unit.ObjectId = Object_GoodsReportSale.Id
                                            AND ObjectLink_Unit.DescId = zc_ObjectLink_GoodsReportSale_Unit()
                        
                        LEFT JOIN ObjectLink AS ObjectLink_Goods
                                             ON ObjectLink_Goods.ObjectId = Object_GoodsReportSale.Id
                                            AND ObjectLink_Goods.DescId = zc_ObjectLink_GoodsReportSale_Goods()
                        
                        LEFT JOIN ObjectLink AS ObjectLink_GoodsKind
                                             ON ObjectLink_GoodsKind.ObjectId = Object_GoodsReportSale.Id
                                            AND ObjectLink_GoodsKind.DescId = zc_ObjectLink_GoodsReportSale_GoodsKind()

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                             ON ObjectLink_Goods_Measure.ObjectId = ObjectLink_Goods.ChildObjectId
                                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
            
                        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                              ON ObjectFloat_Weight.ObjectId = ObjectLink_Goods.ChildObjectId
                                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                                                     
                   WHERE Object_GoodsReportSale.DescId = zc_Object_GoodsReportSale()
                  )
                  
         SELECT tmpData.Key_UnitGoods
              , 'за 1'          :: TVarchar AS NumDays
              , tmpData.AnalysisAmount1     AS AnalysisAmount
              , tmpData.AnalysisOrder1      AS AnalysisOrder
              , tmpData.AmountPromoBranch1  AS AmountPromoBranch
              , tmpData.OrderPromoBranch1   AS OrderPromoBranch
              , tmpData.Branch1             AS AmountBranch
              , tmpData.Order1              AS AmountOrder
              , tmpData.PromoPlan1          AS PromoPlan        
              , tmpData.PromoBranchPlan1    AS PromoBranchPlan   
              , tmpData.AnalysisPromoPlan1  AS AnalysisPromoPlan
              
         FROM tmpData 
       UNION 
         SELECT tmpData.Key_UnitGoods
              , 'за 2'          :: TVarchar AS NumDays
              , tmpData.AnalysisAmount2     AS AnalysisAmount
              , tmpData.AnalysisOrder2      AS AnalysisOrder
              , tmpData.AmountPromoBranch2  AS AmountPromoBranch
              , tmpData.OrderPromoBranch2   AS OrderPromoBranch
              , tmpData.Branch2             AS AmountBranch
              , tmpData.Order2              AS AmountOrder
              , tmpData.PromoPlan2          AS PromoPlan        
              , tmpData.PromoBranchPlan2    AS PromoBranchPlan   
              , tmpData.AnalysisPromoPlan2  AS AnalysisPromoPlan
         FROM tmpData      
       UNION 
         SELECT tmpData.Key_UnitGoods
              , 'за 3'          :: TVarchar AS NumDays
              , tmpData.AnalysisAmount3     AS AnalysisAmount
              , tmpData.AnalysisOrder3      AS AnalysisOrder
              , tmpData.AmountPromoBranch3  AS AmountPromoBranch
              , tmpData.OrderPromoBranch3   AS OrderPromoBranch
              , tmpData.Branch3             AS AmountBranch
              , tmpData.Order3              AS AmountOrder
              , tmpData.PromoPlan3          AS PromoPlan        
              , tmpData.PromoBranchPlan3    AS PromoBranchPlan   
              , tmpData.AnalysisPromoPlan3  AS AnalysisPromoPlan
         FROM tmpData 
       UNION 
         SELECT tmpData.Key_UnitGoods
              , 'за 4'          :: TVarchar AS NumDays
              , tmpData.AnalysisAmount4     AS AnalysisAmount
              , tmpData.AnalysisOrder4      AS AnalysisOrder
              , tmpData.AmountPromoBranch4  AS AmountPromoBranch
              , tmpData.OrderPromoBranch4   AS OrderPromoBranch
              , tmpData.Branch4             AS AmountBranch
              , tmpData.Order4              AS AmountOrder
              , tmpData.PromoPlan4          AS PromoPlan        
              , tmpData.PromoBranchPlan4    AS PromoBranchPlan   
              , tmpData.AnalysisPromoPlan4  AS AnalysisPromoPlan
         FROM tmpData 
       UNION 
         SELECT tmpData.Key_UnitGoods
              , 'за 5'          :: TVarchar AS NumDays
              , tmpData.AnalysisAmount5     AS AnalysisAmount
              , tmpData.AnalysisOrder5      AS AnalysisOrder
              , tmpData.AmountPromoBranch5  AS AmountPromoBranch
              , tmpData.OrderPromoBranch5   AS OrderPromoBranch
              , tmpData.Branch5             AS AmountBranch
              , tmpData.Order5              AS AmountOrder
              , tmpData.PromoPlan5          AS PromoPlan        
              , tmpData.PromoBranchPlan5    AS PromoBranchPlan   
              , tmpData.AnalysisPromoPlan5  AS AnalysisPromoPlan
         FROM tmpData 
       UNION 
         SELECT tmpData.Key_UnitGoods
              , 'за 6'          :: TVarchar AS NumDays
              , tmpData.AnalysisAmount6     AS AnalysisAmount
              , tmpData.AnalysisOrder6      AS AnalysisOrder
              , tmpData.AmountPromoBranch6  AS AmountPromoBranch
              , tmpData.OrderPromoBranch6   AS OrderPromoBranch
              , tmpData.Branch6             AS AmountBranch
              , tmpData.Order6              AS AmountOrder
              , tmpData.PromoPlan6          AS PromoPlan        
              , tmpData.PromoBranchPlan6    AS PromoBranchPlan   
              , tmpData.AnalysisPromoPlan6  AS AnalysisPromoPlan
         FROM tmpData 
       UNION 
         SELECT tmpData.Key_UnitGoods
              , 'за 7'          :: TVarchar AS NumDays
              , tmpData.AnalysisAmount7     AS AnalysisAmount
              , tmpData.AnalysisOrder7      AS AnalysisOrder
              , tmpData.AmountPromoBranch7  AS AmountPromoBranch
              , tmpData.OrderPromoBranch7   AS OrderPromoBranch
              , tmpData.Branch7             AS AmountBranch
              , tmpData.Order7              AS AmountOrder
              , tmpData.PromoPlan7          AS PromoPlan        
              , tmpData.PromoBranchPlan7    AS PromoBranchPlan   
              , tmpData.AnalysisPromoPlan7  AS AnalysisPromoPlan
         FROM tmpData 
       ORDER BY 1,2
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.11.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsReportSale_Graf ('2')
