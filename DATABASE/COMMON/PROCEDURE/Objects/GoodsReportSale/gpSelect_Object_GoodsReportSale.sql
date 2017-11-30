-- Function: gpSelect_Object_GoodsReportSale()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsReportSale(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsReportSale(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar, GoodsId Integer
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , MeasureName TVarChar, Weight TFloat
 
             , GoodsGroupName        TVarChar
             , GoodsGroupNameFull    TVarChar
             , TradeMarkName         TVarChar
             , GoodsTagName          TVarChar
             , GoodsPlatformName     TVarChar
             , GoodsGroupAnalystName TVarChar
             , InfoMoneyCode         Integer
             , InfoMoneyName         TVarChar
 
             , Amount1 TFloat
             , Amount2 TFloat
             , Amount3 TFloat
             , Amount4 TFloat
             , Amount5 TFloat
             , Amount6 TFloat
             , Amount7 TFloat
 
             , Promo1 TFloat
             , Promo2 TFloat
             , Promo3 TFloat
             , Promo4 TFloat
             , Promo5 TFloat
             , Promo6 TFloat
             , Promo7 TFloat
 
             , Branch1 TFloat
             , Branch2 TFloat
             , Branch3 TFloat
             , Branch4 TFloat
             , Branch5 TFloat
             , Branch6 TFloat
             , Branch7 TFloat
 
             , Order1 TFloat
             , Order2 TFloat
             , Order3 TFloat
             , Order4 TFloat
             , Order5 TFloat
             , Order6 TFloat
             , Order7 TFloat
 
             , OrderPromo1 TFloat
             , OrderPromo2 TFloat
             , OrderPromo3 TFloat
             , OrderPromo4 TFloat
             , OrderPromo5 TFloat
             , OrderPromo6 TFloat
             , OrderPromo7 TFloat
 
             , OrderBranch1 TFloat
             , OrderBranch2 TFloat
             , OrderBranch3 TFloat
             , OrderBranch4 TFloat
             , OrderBranch5 TFloat
             , OrderBranch6 TFloat
             , OrderBranch7 TFloat
 
             , PromoPlan1       TFloat
             , PromoPlan2       TFloat
             , PromoPlan3       TFloat
             , PromoPlan4       TFloat
             , PromoPlan5       TFloat
             , PromoPlan6       TFloat
             , PromoPlan7       TFloat
             , TotalPromoPlan   TFloat           

             , PromoBranchPlan1      TFloat
             , PromoBranchPlan2      TFloat
             , PromoBranchPlan3      TFloat
             , PromoBranchPlan4      TFloat
             , PromoBranchPlan5      TFloat
             , PromoBranchPlan6      TFloat
             , PromoBranchPlan7      TFloat
             , TotalPromoBranchPlan  TFloat
             
             , TotalAmount           TFloat
             , TotalPromo            TFloat
             , TotalBranch           TFloat
             , TotalOrder            TFloat
             , TotalOrderPromo       TFloat
             , TotalOrderBranch      TFloat
             , TotalAmountWithPromo  TFloat
             , TotalOrderWithPromo   TFloat
 --
             , AmountPromoBranch1      TFloat
             , AmountPromoBranch2      TFloat
             , AmountPromoBranch3      TFloat
             , AmountPromoBranch4      TFloat
             , AmountPromoBranch5      TFloat
             , AmountPromoBranch6      TFloat
             , AmountPromoBranch7      TFloat
             , TotalAmountPromoBranch  TFloat
 
             , OrderPromoBranch1       TFloat
             , OrderPromoBranch2       TFloat
             , OrderPromoBranch3       TFloat
             , OrderPromoBranch4       TFloat
             , OrderPromoBranch5       TFloat
             , OrderPromoBranch6       TFloat
             , OrderPromoBranch7       TFloat
             , TotalOrderPromoBranch   TFloat
 
             , AnalysisAmount1      TFloat
             , AnalysisAmount2      TFloat
             , AnalysisAmount3      TFloat
             , AnalysisAmount4      TFloat
             , AnalysisAmount5      TFloat
             , AnalysisAmount6      TFloat
             , AnalysisAmount7      TFloat
             , TotalAnalysisAmount  TFloat
 
             , AnalysisOrder1      TFloat
             , AnalysisOrder2      TFloat
             , AnalysisOrder3      TFloat
             , AnalysisOrder4      TFloat
             , AnalysisOrder5      TFloat
             , AnalysisOrder6      TFloat
             , AnalysisOrder7      TFloat
             , TotalAnalysisOrder  TFloat

             , AnalysisPromoPlan1      TFloat
             , AnalysisPromoPlan2      TFloat
             , AnalysisPromoPlan3      TFloat
             , AnalysisPromoPlan4      TFloat
             , AnalysisPromoPlan5      TFloat
             , AnalysisPromoPlan6      TFloat
             , AnalysisPromoPlan7      TFloat
             , TotalAnalysisPromoPlan  TFloat

             , Key_UnitGoods       TVarChar

             ) AS
$BODY$
   DECLARE vbWeek      TFloat;
BEGIN
       vbWeek := (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.DescId = zc_ObjectFloat_GoodsReportSaleInf_Week());

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

       RETURN QUERY
       SELECT Object_Unit.Id                       AS UnitId
            , Object_Unit.ValueData                AS UnitName
            , Object_Goods.Id                      AS GoodsId
            , Object_Goods.ObjectCode              AS GoodsCode
            , Object_Goods.ValueData               AS GoodsName
            , Object_GoodsKind.Id                  AS GoodsKindId
            , Object_GoodsKind.ValueData           AS GoodsKindName

            , Object_Measure.ValueData             AS MeasureName
            , COALESCE (ObjectFloat_Weight.ValueData, 0) :: TFloat AS Weight

            , Object_GoodsGroup.ValueData          AS GoodsGroupName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_TradeMark.ValueData           AS TradeMarkName
            , Object_GoodsTag.ValueData            AS GoodsTagName
            , Object_GoodsPlatform.ValueData       AS GoodsPlatformName
            , Object_GoodsGroupAnalyst.ValueData   AS GoodsGroupAnalystName
            , Object_InfoMoney.ObjectCode          AS InfoMoneyCode
            , Object_InfoMoney.ValueData           AS InfoMoneyName

            , ((ObjectFloat_Amount1.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Amount1
            , ((ObjectFloat_Amount2.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Amount2
            , ((ObjectFloat_Amount3.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Amount3
            , ((ObjectFloat_Amount4.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Amount4
            , ((ObjectFloat_Amount5.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Amount5
            , ((ObjectFloat_Amount6.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Amount6
            , ((ObjectFloat_Amount7.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Amount7

            , ((ObjectFloat_Promo1.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Promo1
            , ((ObjectFloat_Promo2.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Promo2
            , ((ObjectFloat_Promo3.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Promo3
            , ((ObjectFloat_Promo4.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Promo4
            , ((ObjectFloat_Promo5.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Promo5
            , ((ObjectFloat_Promo6.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Promo6
            , ((ObjectFloat_Promo7.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Promo7

            , ((ObjectFloat_Branch1.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Branch1
            , ((ObjectFloat_Branch2.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Branch2
            , ((ObjectFloat_Branch3.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Branch3
            , ((ObjectFloat_Branch4.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Branch4
            , ((ObjectFloat_Branch5.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Branch5
            , ((ObjectFloat_Branch6.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Branch6
            , ((ObjectFloat_Branch7.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat       AS Branch7

            , ((ObjectFloat_Order1.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Order1
            , ((ObjectFloat_Order2.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Order2
            , ((ObjectFloat_Order3.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Order3
            , ((ObjectFloat_Order4.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Order4
            , ((ObjectFloat_Order5.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Order5
            , ((ObjectFloat_Order6.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Order6
            , ((ObjectFloat_Order7.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS Order7

            , ((ObjectFloat_OrderPromo1.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat  AS OrderPromo1
            , ((ObjectFloat_OrderPromo2.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat  AS OrderPromo2
            , ((ObjectFloat_OrderPromo3.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat  AS OrderPromo3
            , ((ObjectFloat_OrderPromo4.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat  AS OrderPromo4
            , ((ObjectFloat_OrderPromo5.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat  AS OrderPromo5
            , ((ObjectFloat_OrderPromo6.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat  AS OrderPromo6
            , ((ObjectFloat_OrderPromo7.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat  AS OrderPromo7

            , ((ObjectFloat_OrderBranch1.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat  AS OrderBranch1
            , ((ObjectFloat_OrderBranch2.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat  AS OrderBranch2
            , ((ObjectFloat_OrderBranch3.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat  AS OrderBranch3
            , ((ObjectFloat_OrderBranch4.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat  AS OrderBranch4
            , ((ObjectFloat_OrderBranch5.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat  AS OrderBranch5
            , ((ObjectFloat_OrderBranch6.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat  AS OrderBranch6
            , ((ObjectFloat_OrderBranch7.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)  ::TFloat  AS OrderBranch7

            , ((ObjectFloat_PromoPlan1.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoPlan1
            , ((ObjectFloat_PromoPlan2.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoPlan2
            , ((ObjectFloat_PromoPlan3.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoPlan3
            , ((ObjectFloat_PromoPlan4.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoPlan4
            , ((ObjectFloat_PromoPlan5.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoPlan5
            , ((ObjectFloat_PromoPlan6.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoPlan6
            , ((ObjectFloat_PromoPlan7.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoPlan7

              -- Итого Кол-во план в реализации только Акции
            , ((COALESCE (ObjectFloat_PromoPlan1.ValueData, 0)
              + COALESCE (ObjectFloat_PromoPlan2.ValueData, 0)
              + COALESCE (ObjectFloat_PromoPlan3.ValueData, 0)
              + COALESCE (ObjectFloat_PromoPlan4.ValueData, 0)
              + COALESCE (ObjectFloat_PromoPlan5.ValueData, 0)
              + COALESCE (ObjectFloat_PromoPlan6.ValueData, 0)
              + COALESCE (ObjectFloat_PromoPlan7.ValueData, 0)
               )
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
              ) :: TFloat AS TotalPromoPlan

            , ((ObjectFloat_PromoBranchPlan1.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoBranchPlan1
            , ((ObjectFloat_PromoBranchPlan2.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoBranchPlan2
            , ((ObjectFloat_PromoBranchPlan3.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoBranchPlan3
            , ((ObjectFloat_PromoBranchPlan4.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoBranchPlan4
            , ((ObjectFloat_PromoBranchPlan5.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoBranchPlan5
            , ((ObjectFloat_PromoBranchPlan6.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoBranchPlan6
            , ((ObjectFloat_PromoBranchPlan7.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) / vbWeek)   ::TFloat       AS PromoBranchPlan7

              -- Итого Кол-во план в расходе на филиал только Акции
            , ((COALESCE (ObjectFloat_PromoBranchPlan1.ValueData, 0)
              + COALESCE (ObjectFloat_PromoBranchPlan2.ValueData, 0)
              + COALESCE (ObjectFloat_PromoBranchPlan3.ValueData, 0)
              + COALESCE (ObjectFloat_PromoBranchPlan4.ValueData, 0)
              + COALESCE (ObjectFloat_PromoBranchPlan5.ValueData, 0)
              + COALESCE (ObjectFloat_PromoBranchPlan6.ValueData, 0)
              + COALESCE (ObjectFloat_PromoBranchPlan7.ValueData, 0)
               )
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
              ) :: TFloat AS TotalPromoBranchPlan
              
              -- Кол-во Реализация со склада без Акций
            , ((COALESCE (ObjectFloat_Amount1.ValueData, 0)
              + COALESCE (ObjectFloat_Amount2.ValueData, 0)
              + COALESCE (ObjectFloat_Amount3.ValueData, 0)
              + COALESCE (ObjectFloat_Amount4.ValueData, 0)
              + COALESCE (ObjectFloat_Amount5.ValueData, 0)
              + COALESCE (ObjectFloat_Amount6.ValueData, 0)
              + COALESCE (ObjectFloat_Amount7.ValueData, 0)
               )
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
              ) :: TFloat AS TotalAmount
              -- Кол-во Реализация со склада только Акции
            , ((COALESCE (ObjectFloat_Promo1.ValueData, 0)
              + COALESCE (ObjectFloat_Promo2.ValueData, 0)
              + COALESCE (ObjectFloat_Promo3.ValueData, 0)
              + COALESCE (ObjectFloat_Promo4.ValueData, 0)
              + COALESCE (ObjectFloat_Promo5.ValueData, 0)
              + COALESCE (ObjectFloat_Promo6.ValueData, 0)
              + COALESCE (ObjectFloat_Promo7.ValueData, 0)
               )
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
              )  :: TFloat AS TotalPromo


              -- ИТОГО Кол-во Расход со склада на Филиал
            , ((COALESCE (ObjectFloat_Branch1.ValueData, 0)
              + COALESCE (ObjectFloat_Branch2.ValueData, 0)
              + COALESCE (ObjectFloat_Branch3.ValueData, 0)
              + COALESCE (ObjectFloat_Branch4.ValueData, 0)
              + COALESCE (ObjectFloat_Branch5.ValueData, 0)
              + COALESCE (ObjectFloat_Branch6.ValueData, 0)
              + COALESCE (ObjectFloat_Branch7.ValueData, 0)
               )
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
              ) :: TFloat AS TotalBranch
         

              -- Кол-во Заявка Покупателей без Акций
            , ((COALESCE (ObjectFloat_Order1.ValueData, 0)
              + COALESCE (ObjectFloat_Order2.ValueData, 0)
              + COALESCE (ObjectFloat_Order3.ValueData, 0)
              + COALESCE (ObjectFloat_Order4.ValueData, 0)
              + COALESCE (ObjectFloat_Order5.ValueData, 0)
              + COALESCE (ObjectFloat_Order6.ValueData, 0)
              + COALESCE (ObjectFloat_Order7.ValueData, 0)
               )
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
              ) :: TFloat AS TotalOrder
              -- Кол-во Заявка Покупателей только Акции
            , ((COALESCE (ObjectFloat_OrderPromo1.ValueData, 0)
              + COALESCE (ObjectFloat_OrderPromo2.ValueData, 0)
              + COALESCE (ObjectFloat_OrderPromo3.ValueData, 0)
              + COALESCE (ObjectFloat_OrderPromo4.ValueData, 0)
              + COALESCE (ObjectFloat_OrderPromo5.ValueData, 0)
              + COALESCE (ObjectFloat_OrderPromo6.ValueData, 0)
              + COALESCE (ObjectFloat_OrderPromo7.ValueData, 0)
               )
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
              ) ::TFloat AS TotalOrderPromo

              -- ИТОГО Кол-во Заявка с Филиала
            , ((COALESCE (ObjectFloat_OrderBranch1.ValueData, 0)
              + COALESCE (ObjectFloat_OrderBranch2.ValueData, 0)
              + COALESCE (ObjectFloat_OrderBranch3.ValueData, 0)
              + COALESCE (ObjectFloat_OrderBranch4.ValueData, 0)
              + COALESCE (ObjectFloat_OrderBranch5.ValueData, 0)
              + COALESCE (ObjectFloat_OrderBranch6.ValueData, 0)
              + COALESCE (ObjectFloat_OrderBranch7.ValueData, 0)
               )
            * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
              ) :: TFloat AS TotalOrderBranch

              -- ИТОГО Кол-во Реализация со склада + Акции
            , ((COALESCE (ObjectFloat_Amount1.ValueData, 0)
              + COALESCE (ObjectFloat_Amount2.ValueData, 0)
              + COALESCE (ObjectFloat_Amount3.ValueData, 0)
              + COALESCE (ObjectFloat_Amount4.ValueData, 0)
              + COALESCE (ObjectFloat_Amount5.ValueData, 0)
              + COALESCE (ObjectFloat_Amount6.ValueData, 0)
              + COALESCE (ObjectFloat_Amount7.ValueData, 0)
              + COALESCE (ObjectFloat_Promo1.ValueData, 0)
              + COALESCE (ObjectFloat_Promo2.ValueData, 0)
              + COALESCE (ObjectFloat_Promo3.ValueData, 0)
              + COALESCE (ObjectFloat_Promo4.ValueData, 0)
              + COALESCE (ObjectFloat_Promo5.ValueData, 0)
              + COALESCE (ObjectFloat_Promo6.ValueData, 0)
              + COALESCE (ObjectFloat_Promo7.ValueData, 0)
               )
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
              ) :: TFloat AS TotalAmountWithPromo

              -- ИТОГО Кол-во Заявка Покупателей + Акции
            , ((COALESCE (ObjectFloat_Order1.ValueData, 0)
              + COALESCE (ObjectFloat_Order2.ValueData, 0)
              + COALESCE (ObjectFloat_Order3.ValueData, 0)
              + COALESCE (ObjectFloat_Order4.ValueData, 0)
              + COALESCE (ObjectFloat_Order5.ValueData, 0)
              + COALESCE (ObjectFloat_Order6.ValueData, 0)
              + COALESCE (ObjectFloat_Order7.ValueData, 0)
              + COALESCE (ObjectFloat_OrderPromo1.ValueData, 0)
              + COALESCE (ObjectFloat_OrderPromo2.ValueData, 0)
              + COALESCE (ObjectFloat_OrderPromo3.ValueData, 0)
              + COALESCE (ObjectFloat_OrderPromo4.ValueData, 0)
              + COALESCE (ObjectFloat_OrderPromo5.ValueData, 0)
              + COALESCE (ObjectFloat_OrderPromo6.ValueData, 0)
              + COALESCE (ObjectFloat_OrderPromo7.ValueData, 0)
               )
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
              ) :: TFloat AS TotalOrderWithPromo



              -- Итого Кол-во Реализация со склада + Акции + Расход на Филиал - ПО ДНЯМ
            , ((COALESCE (ObjectFloat_Amount1.ValueData, 0) + COALESCE (ObjectFloat_Promo1.ValueData, 0) + COALESCE (ObjectFloat_Branch1.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AmountPromoBranch1
            , ((COALESCE (ObjectFloat_Amount2.ValueData, 0) + COALESCE (ObjectFloat_Promo2.ValueData, 0) + COALESCE (ObjectFloat_Branch2.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AmountPromoBranch2
            , ((COALESCE (ObjectFloat_Amount3.ValueData, 0) + COALESCE (ObjectFloat_Promo3.ValueData, 0) + COALESCE (ObjectFloat_Branch3.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AmountPromoBranch3
            , ((COALESCE (ObjectFloat_Amount4.ValueData, 0) + COALESCE (ObjectFloat_Promo4.ValueData, 0) + COALESCE (ObjectFloat_Branch4.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AmountPromoBranch4
            , ((COALESCE (ObjectFloat_Amount5.ValueData, 0) + COALESCE (ObjectFloat_Promo5.ValueData, 0) + COALESCE (ObjectFloat_Branch5.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AmountPromoBranch5
            , ((COALESCE (ObjectFloat_Amount6.ValueData, 0) + COALESCE (ObjectFloat_Promo6.ValueData, 0) + COALESCE (ObjectFloat_Branch6.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AmountPromoBranch6
            , ((COALESCE (ObjectFloat_Amount7.ValueData, 0) + COALESCE (ObjectFloat_Promo7.ValueData, 0) + COALESCE (ObjectFloat_Branch7.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AmountPromoBranch7
              -- Итого Кол-во Реализация со склада + Акции + Расход на Филиал
            , ((COALESCE (ObjectFloat_Amount1.ValueData, 0) + COALESCE (ObjectFloat_Promo1.ValueData, 0) + COALESCE (ObjectFloat_Branch1.ValueData, 0)
              + COALESCE (ObjectFloat_Amount2.ValueData, 0) + COALESCE (ObjectFloat_Promo2.ValueData, 0) + COALESCE (ObjectFloat_Branch2.ValueData, 0)
              + COALESCE (ObjectFloat_Amount3.ValueData, 0) + COALESCE (ObjectFloat_Promo3.ValueData, 0) + COALESCE (ObjectFloat_Branch3.ValueData, 0)
              + COALESCE (ObjectFloat_Amount4.ValueData, 0) + COALESCE (ObjectFloat_Promo4.ValueData, 0) + COALESCE (ObjectFloat_Branch4.ValueData, 0)
              + COALESCE (ObjectFloat_Amount5.ValueData, 0) + COALESCE (ObjectFloat_Promo5.ValueData, 0) + COALESCE (ObjectFloat_Branch5.ValueData, 0)
              + COALESCE (ObjectFloat_Amount6.ValueData, 0) + COALESCE (ObjectFloat_Promo6.ValueData, 0) + COALESCE (ObjectFloat_Branch6.ValueData, 0)
              + COALESCE (ObjectFloat_Amount7.ValueData, 0) + COALESCE (ObjectFloat_Promo7.ValueData, 0) + COALESCE (ObjectFloat_Branch7.ValueData, 0)
               )
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
              ) :: TFloat AS TotalAmountPromoBranch

              -- ИТОГО Кол-во Заявка Покупателей + Акции + с Филиала - ПО ДНЯМ
            , ((COALESCE (ObjectFloat_Order1.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo1.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch1.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS OrderPromoBranch1
            , ((COALESCE (ObjectFloat_Order2.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo2.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch2.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS OrderPromoBranch2
            , ((COALESCE (ObjectFloat_Order3.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo3.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch3.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS OrderPromoBranch3
            , ((COALESCE (ObjectFloat_Order4.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo4.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch4.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS OrderPromoBranch4
            , ((COALESCE (ObjectFloat_Order5.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo5.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch5.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS OrderPromoBranch5
            , ((COALESCE (ObjectFloat_Order6.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo6.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch6.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS OrderPromoBranch6
            , ((COALESCE (ObjectFloat_Order7.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo7.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch7.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS OrderPromoBranch7
              -- ИТОГО Кол-во Заявка Покупателей + Акции + с Филиала
            , ((COALESCE (ObjectFloat_Order1.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo1.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch1.ValueData, 0)
              + COALESCE (ObjectFloat_Order2.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo2.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch2.ValueData, 0)
              + COALESCE (ObjectFloat_Order3.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo3.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch3.ValueData, 0)
              + COALESCE (ObjectFloat_Order4.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo4.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch4.ValueData, 0)
              + COALESCE (ObjectFloat_Order5.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo5.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch5.ValueData, 0)
              + COALESCE (ObjectFloat_Order6.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo6.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch6.ValueData, 0)
              + COALESCE (ObjectFloat_Order7.ValueData, 0) + COALESCE (ObjectFloat_OrderPromo7.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch7.ValueData, 0)
               )
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
              ) :: TFloat AS TotalOrderPromoBranch



              -- Итого для СТАТИСТИКИ Кол-во Реализация со склада + Расход на Филиал - ПО ДНЯМ
            , ((COALESCE (ObjectFloat_Amount1.ValueData, 0) + COALESCE (ObjectFloat_Branch1.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisAmount1
            , ((COALESCE (ObjectFloat_Amount2.ValueData, 0) + COALESCE (ObjectFloat_Branch2.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisAmount2
            , ((COALESCE (ObjectFloat_Amount3.ValueData, 0) + COALESCE (ObjectFloat_Branch3.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisAmount3
            , ((COALESCE (ObjectFloat_Amount4.ValueData, 0) + COALESCE (ObjectFloat_Branch4.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisAmount4
            , ((COALESCE (ObjectFloat_Amount5.ValueData, 0) + COALESCE (ObjectFloat_Branch5.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisAmount5
            , ((COALESCE (ObjectFloat_Amount6.ValueData, 0) + COALESCE (ObjectFloat_Branch6.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisAmount6
            , ((COALESCE (ObjectFloat_Amount7.ValueData, 0) + COALESCE (ObjectFloat_Branch7.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisAmount7
               -- Итого для СТАТИСТИКИ Кол-во Реализация со склада + Расход на Филиал
            , ((COALESCE (ObjectFloat_Amount1.ValueData, 0)  + COALESCE (ObjectFloat_Branch1.ValueData, 0)
              + COALESCE (ObjectFloat_Amount2.ValueData, 0)  + COALESCE (ObjectFloat_Branch2.ValueData, 0)
              + COALESCE (ObjectFloat_Amount3.ValueData, 0)  + COALESCE (ObjectFloat_Branch3.ValueData, 0)
              + COALESCE (ObjectFloat_Amount4.ValueData, 0)  + COALESCE (ObjectFloat_Branch4.ValueData, 0)
              + COALESCE (ObjectFloat_Amount5.ValueData, 0)  + COALESCE (ObjectFloat_Branch5.ValueData, 0)
              + COALESCE (ObjectFloat_Amount6.ValueData, 0)  + COALESCE (ObjectFloat_Branch6.ValueData, 0)
              + COALESCE (ObjectFloat_Amount7.ValueData, 0)  + COALESCE (ObjectFloat_Branch7.ValueData, 0)
               )
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
              ) :: TFloat AS TotalAnalysisAmount

              -- ИТОГО для СТАТИСТИКИ Кол-во Заявка Покупателей + с Филиала - ПО ДНЯМ
            , ((COALESCE (ObjectFloat_Order1.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch1.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisOrder1
            , ((COALESCE (ObjectFloat_Order2.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch2.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisOrder2
            , ((COALESCE (ObjectFloat_Order3.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch3.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisOrder3
            , ((COALESCE (ObjectFloat_Order4.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch4.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisOrder4
            , ((COALESCE (ObjectFloat_Order5.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch5.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisOrder5
            , ((COALESCE (ObjectFloat_Order6.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch6.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisOrder6
            , ((COALESCE (ObjectFloat_Order7.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch7.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisOrder7
              -- ИТОГО для СТАТИСТИКИ Кол-во Заявка Покупателей + с Филиала
            , ((COALESCE (ObjectFloat_Order1.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch1.ValueData, 0)
              + COALESCE (ObjectFloat_Order2.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch2.ValueData, 0)
              + COALESCE (ObjectFloat_Order3.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch3.ValueData, 0)
              + COALESCE (ObjectFloat_Order4.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch4.ValueData, 0)
              + COALESCE (ObjectFloat_Order5.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch5.ValueData, 0)
              + COALESCE (ObjectFloat_Order6.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch6.ValueData, 0)
              + COALESCE (ObjectFloat_Order7.ValueData, 0) + COALESCE (ObjectFloat_OrderBranch7.ValueData, 0)
               )
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
              ) :: TFloat AS TotalAnalysisOrder
             
              -- Итого для СТАТИСТИКИ Кол-во план в реализации только Акции + Кол-во план в расходе на филиал только Акции - ПО ДНЯМ
            , ((COALESCE (ObjectFloat_PromoPlan1.ValueData, 0) + COALESCE (ObjectFloat_PromoBranchPlan1.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisPromoPlan1
            , ((COALESCE (ObjectFloat_PromoPlan2.ValueData, 0) + COALESCE (ObjectFloat_PromoBranchPlan2.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisPromoPlan2
            , ((COALESCE (ObjectFloat_PromoPlan3.ValueData, 0) + COALESCE (ObjectFloat_PromoBranchPlan3.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisPromoPlan3
            , ((COALESCE (ObjectFloat_PromoPlan4.ValueData, 0) + COALESCE (ObjectFloat_PromoBranchPlan4.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisPromoPlan4
            , ((COALESCE (ObjectFloat_PromoPlan5.ValueData, 0) + COALESCE (ObjectFloat_PromoBranchPlan5.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisPromoPlan5
            , ((COALESCE (ObjectFloat_PromoPlan6.ValueData, 0) + COALESCE (ObjectFloat_PromoBranchPlan6.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisPromoPlan6
            , ((COALESCE (ObjectFloat_PromoPlan7.ValueData, 0) + COALESCE (ObjectFloat_PromoBranchPlan7.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeek ) ::TFloat AS AnalysisPromoPlan7
 
               -- ИТОГО Кол-во план в реализации только Акции + Кол-во план в расходе на филиал только Акции
            , ((COALESCE (ObjectFloat_PromoPlan1.ValueData, 0)
              + COALESCE (ObjectFloat_PromoPlan2.ValueData, 0)
              + COALESCE (ObjectFloat_PromoPlan3.ValueData, 0)
              + COALESCE (ObjectFloat_PromoPlan4.ValueData, 0)
              + COALESCE (ObjectFloat_PromoPlan5.ValueData, 0)
              + COALESCE (ObjectFloat_PromoPlan6.ValueData, 0)
              + COALESCE (ObjectFloat_PromoPlan7.ValueData, 0)
              + COALESCE (ObjectFloat_PromoBranchPlan1.ValueData, 0)
              + COALESCE (ObjectFloat_PromoBranchPlan2.ValueData, 0)
              + COALESCE (ObjectFloat_PromoBranchPlan3.ValueData, 0)
              + COALESCE (ObjectFloat_PromoBranchPlan4.ValueData, 0)
              + COALESCE (ObjectFloat_PromoBranchPlan5.ValueData, 0)
              + COALESCE (ObjectFloat_PromoBranchPlan6.ValueData, 0)
              + COALESCE (ObjectFloat_PromoBranchPlan7.ValueData, 0)
               )
             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
              ) :: TFloat AS TotalAnalysisPromoPlan


            , (Object_Unit.Id||'_'||Object_Goods.Id||'_'||Object_GoodsKind.Id)  :: TVarChar AS Key_UnitGoods

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
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods
                                 ON ObjectLink_Goods.ObjectId = Object_GoodsReportSale.Id
                                AND ObjectLink_Goods.DescId = zc_ObjectLink_GoodsReportSale_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId


            LEFT JOIN ObjectLink AS ObjectLink_GoodsKind
                                 ON ObjectLink_GoodsKind.ObjectId = Object_GoodsReportSale.Id
                                AND ObjectLink_GoodsKind.DescId = zc_ObjectLink_GoodsReportSale_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsKind.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                 ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
            LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                 ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
            LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                 ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                 ON ObjectLink_Goods_GoodsPlatform.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
            LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Goods_InfoMoney.ChildObjectId

      WHERE Object_GoodsReportSale.DescId = zc_Object_GoodsReportSale()
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.11.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsReportSale ('2')
