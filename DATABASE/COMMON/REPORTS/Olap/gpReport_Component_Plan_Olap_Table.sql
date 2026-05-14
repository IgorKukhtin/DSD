-- Function: gpReport_Component_Plan_Olap_Table()

DROP FUNCTION IF EXISTS gpReport_Component_Plan_Olap_Table (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Component_Plan_Olap_Table (
    IN inStartDate          TDateTime ,
    IN inEndDate            TDateTime ,
    IN inGoodsGroupId       Integer   ,
    IN inInfoMoneyId        Integer   ,    -- уп статья (zc_ObjectLink_Goods_InfoMoney) - ограничиваем только Назв Товар Расход + вид
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId  Integer
             , OperDate    TDateTime
             , MonthDate   TDateTime
             , Year        Integer
             , WeekNumber  Integer
             --
             , UnitId           Integer
             , UnitName         TVarChar
             , PartnerInId      Integer
             , PartnerInName    TVarChar

             --ТОвар ГП
             , GoodsId_gp          Integer
             , GoodsCode_gp        Integer
             , GoodsName_gp        TVarChar
             , GoodsKindId_gp      Integer
             , GoodsKindName_gp    TVarChar
             --Товар Расход
             , GoodsId             Integer
             , GoodsCode           Integer
             , GoodsName           TVarChar
             , GoodsKindId         Integer
             , GoodsKindName       TVarChar

             , AmountSale_rk_sh            TFloat  -- 1.1.Продано Покуп с РК - ГП
             , AmountSale_rk               TFloat
             , AmountSendOnPrice_rk_sh     TFloat  -- 1.2.Расход на филиалы с РК - ГП
             , AmountSendOnPrice_rk        TFloat
             , Amount_rk_sh                TFloat  -- 1. Продано с РК 1.1 + 1.2 - ГП
             , Amount_rk                   TFloat

             , Amount_prod_in_sh           TFloat  -- Приход ПФ-ГП - факт - ГП
             , Amount_prod_in              TFloat

             , Amount_prod_in_calc_sh TFloat  -- Приход ПФ-ГП - Расчет - ГП
             , Amount_prod_in_calc    TFloat

               -- Расчет расх на производство - Компоненты
             , Amount_prod_out_calc        TFloat

             , Amount_prod_out             TFloat  -- 2.1 - Компоненты
             , Amount_sale                 TFloat  -- 2.4 - Компоненты
             , Amount_loss                 TFloat  -- 2.2 - Компоненты
             , Amount_inv                  TFloat  -- 2.3 - Компоненты
             , Amount_fact                 TFloat  -- 2.ФАКТ ИТОГО Расход 2.1+2+3+4 - Компоненты

             , Amount_income               TFloat  -- Кол-во приход - Компоненты
             , Summ_income                 TFloat  -- Сумма приход - Компоненты

             -- Товар ГП
             , MeasureId_gp                Integer
             , MeasureName_gp              TVarChar
             , GoodsGroupId_gp             Integer
             , GoodsGroupName_gp           TVarChar
             , GoodsGroupNameFull_gp       TVarChar
             , TradeMarkId_gp              Integer
             , TradeMarkName_gp            TVarChar
             , InfoMoneyCode_gp            Integer
             , InfoMoneyGroupName_gp       TVarChar
             , InfoMoneyDestinationName_gp TVarChar
             , InfoMoneyName_gp            TVarChar
             , InfoMoneyName_all_gp        TVarChar
             , InfoMoneyId_gp              Integer
             --Товар расход
             , MeasureId                   Integer
             , MeasureName                 TVarChar
             , GoodsGroupId                Integer
             , GoodsGroupName              TVarChar
             , GoodsGroupNameFull          TVarChar
             , InfoMoneyCode               Integer
             , InfoMoneyGroupName          TVarChar
             , InfoMoneyDestinationName    TVarChar
             , InfoMoneyName               TVarChar
             , InfoMoneyName_all           TVarChar
             , InfoMoneyId                 Integer
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

   --zc_Unit_RK()
    -- Результат
    RETURN QUERY
      WITH
      tmpGoods AS (SELECT tmp.GoodsId
                        FROM (SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup
                              WHERE inGoodsGroupId > 0
                             UNION
                              SELECT Object.Id
                              FROM Object
                              WHERE Object.DescId = zc_Object_Goods()
                                AND COALESCE (inGoodsGroupId, 0) = 0
                             ) AS tmp
                             INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   ON ObjectLink_Goods_InfoMoney.ObjectId = tmp.GoodsId
                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                  AND (ObjectLink_Goods_InfoMoney.ChildObjectId = inInfoMoneyId OR inInfoMoneyId = 0)
                       )

           --две группы - ГП (1832) + Тушенка     (1979)
         , tmpGoods_gp AS (SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (1832) AS lfObject_Goods_byGoodsGroup
                          UNION
                           SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (1979) AS lfObject_Goods_byGoodsGroup
                          )
    --данные из таблицы
    , tmpData AS (SELECT tmp.* 
                  FROM _bi_Table_Component_Plan AS tmp
                      LEFT JOIN tmpGoods_gp ON tmpGoods_gp.GoodsId = tmp.GoodsId_gp
                      LEFT JOIN tmpGoods    ON tmpGoods.GoodsId    = tmp.GoodsId
                  WHERE tmp.OperDate BETWEEN inStartDate AND inEndDate
                    AND (tmpGoods.GoodsId IS NOT NULL OR tmpGoods_gp.GoodsId IS NOT NULL)
                  )
    
      -- Результат
      SELECT tmpData.MovementId                      :: Integer   AS MovementId
           , tmpData.OperDate                        :: TDateTime AS OperDate
           , DATE_TRUNC ('MONTH', tmpData.OperDate)  :: TDateTime AS MonthDate
           , EXTRACT (YEAR FROM tmpData.OperDate)    :: Integer AS Year
           , EXTRACT (WEEK FROM tmpData.OperDate)    :: Integer AS WeekNumber
           --
           , Object_Unit.Id             ::Integer  AS UnitId
           , Object_Unit.ValueData      ::TVarChar AS UnitName
           , Object_PartnerIn.Id        ::Integer  AS PartnerInId
           , Object_PartnerIn.ValueData ::TVarChar AS PartnerInName

           --ТОвар ГП
           , Object_Goods_gp.Id               AS GoodsId_gp
           , Object_Goods_gp.ObjectCode       AS GoodsCode_gp
           , Object_Goods_gp.ValueData        AS GoodsName_gp
           , Object_GoodsKind_gp.Id           AS GoodsKindId_gp
           , Object_GoodsKind_gp.ValueData    AS GoodsKindName_gp
           --Товар Расход
           , Object_Goods.Id                  AS GoodsId
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName
           , Object_GoodsKind.Id              AS GoodsKindId
           , Object_GoodsKind.ValueData       AS GoodsKindName

             -- 1.1.Продано Покуп с РК - ГП
           , tmpData.AmountSale_rk_sh         ::TFloat
           , tmpData.AmountSale_rk            ::TFloat
             -- 1.2.Расход на филиалы с РК - ГП
           , tmpData.AmountSendOnPrice_rk_sh  ::TFloat
           , tmpData.AmountSendOnPrice_rk     ::TFloat
             -- 1. Продано с РК 1.1 + 1.2 - ГП
           , (COALESCE (tmpData.AmountSale_rk_sh,0) + COALESCE (tmpData.AmountSendOnPrice_rk_sh,0)) ::TFloat AS Amount_rk_sh
           , (COALESCE (tmpData.AmountSale_rk,0)    + COALESCE (tmpData.AmountSendOnPrice_rk,0))    ::TFloat AS Amount_rk

             -- Приход ПФ-ГП - факт - ГП
           , tmpData.Amount_prod_in_sh        ::TFloat AS Amount_prod_in_sh
           , tmpData.Amount_prod_in           ::TFloat AS Amount_prod_in
             -- Приход ПФ-ГП - Расчет - ГП
           , tmpData.Amount_prod_in_calc_sh   ::TFloat AS Amount_prod_in_calc_sh
           , tmpData.Amount_prod_in_calc      ::TFloat AS Amount_prod_in_calc

            -- Расчет расх на производство - Компоненты
           , tmpData.Amount_prod_out_calc     ::TFloat AS Amount_prod_out_calc

             -- 2.1 - Компоненты
           , tmpData.Amount_prod_out          ::TFloat AS Amount_prod_out
             -- 2.4 - Компоненты
           , tmpData.Amount_sale              ::TFloat AS Amount_sale
             -- 2.2 - Компоненты
           , tmpData.Amount_loss              ::TFloat AS Amount_loss
             -- 2.3 - Компоненты
           , tmpData.Amount_inv               ::TFloat AS Amount_inv
             --2. ФАКТ ИТОГО Расход 2.1+2+3+4 - Компоненты
           , (COALESCE (tmpData.Amount_prod_out,0) 
            + COALESCE (tmpData.Amount_sale,0)
            + COALESCE (tmpData.Amount_loss,0)
            + COALESCE (tmpData.Amount_inv))  ::TFloat AS Amount_fact

             -- Кол-во приход - Компоненты
           , tmpData.Amount_income                ::TFloat AS Amount_income
             -- Сумма приход - Компоненты
           , tmpData.Summ_income                  ::TFloat AS Summ_income

             -- Товар ГП
           , Object_Measure_gp.Id                         AS MeasureId_gp
           , Object_Measure_gp.ValueData                  AS MeasureName_gp
           , Object_GoodsGroup.Id                         AS GoodsGroupId_gp
           , Object_GoodsGroup.ValueData                  AS GoodsGroupName_gp
           , ObjectString_Goods_GoodsGroupFull.ValueData  AS GoodsGroupNameFull_gp
           , Object_TradeMark_gp.Id                       AS TradeMarkId_gp
           , Object_TradeMark_gp.ValueData                AS TradeMarkName_gp
           , Object_InfoMoney_gp.InfoMoneyCode            AS InfoMoneyCode_gp
           , Object_InfoMoney_gp.InfoMoneyGroupName       AS InfoMoneyGroupName_gp
           , Object_InfoMoney_gp.InfoMoneyDestinationName AS InfoMoneyDestinationName_gp
           , Object_InfoMoney_gp.InfoMoneyName            AS InfoMoneyName_gp
           , Object_InfoMoney_gp.InfoMoneyName_all        AS InfoMoneyName_all_gp
           , Object_InfoMoney_gp.InfoMoneyId              AS InfoMoneyId_gp
             -- Товар Компоненты
           , Object_Measure.Id                              AS MeasureId
           , Object_Measure.ValueData                       AS MeasureName
           , Object_GoodsGroup_gp.Id                        AS GoodsGroupId
           , Object_GoodsGroup_gp.ValueData                 AS GoodsGroupName
           , ObjectString_Goods_GoodsGroupFull_gp.ValueData AS GoodsGroupNameFull
           , Object_InfoMoney.InfoMoneyCode
           , Object_InfoMoney.InfoMoneyGroupName
           , Object_InfoMoney.InfoMoneyDestinationName
           , Object_InfoMoney.InfoMoneyName
           , Object_InfoMoney.InfoMoneyName_all
           , Object_InfoMoney.InfoMoneyId

        FROM tmpData
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
             LEFT JOIN Object AS Object_PartnerIn ON Object_PartnerIn.Id = tmpData.PartnerId
             --
             LEFT JOIN Object AS Object_Goods_gp ON Object_Goods_gp.Id = tmpData.GoodsId_gp
             LEFT JOIN Object AS Object_GoodsKind_gp ON Object_GoodsKind_gp.Id = tmpData.GoodsKindId_gp
             LEFT JOIN Object AS Object_Measure_gp ON Object_Measure_gp.Id = tmpData.MeasureId_gp
             LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney_gp ON Object_InfoMoney_gp.InfoMoneyId = tmpData.InfoMoneyId_gp
             LEFT JOIN Object AS Object_TradeMark_gp ON Object_TradeMark_gp.Id = tmpData.TradeMarkId_gp

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup_gp
                                  ON ObjectLink_Goods_GoodsGroup_gp.ObjectId = tmpData.GoodsId_gp
                                 AND ObjectLink_Goods_GoodsGroup_gp.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup_gp ON Object_GoodsGroup_gp.Id = ObjectLink_Goods_GoodsGroup_gp.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull_gp
                                    ON ObjectString_Goods_GoodsGroupFull_gp.ObjectId = tmpData.GoodsId_gp
                                   AND ObjectString_Goods_GoodsGroupFull_gp.DescId = zc_ObjectString_Goods_GroupNameFull()
             --
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpData.MeasureId
             LEFT JOIN Object_InfoMoney_View AS Object_InfoMoney ON Object_InfoMoney.InfoMoneyId = tmpData.InfoMoneyId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpData.GoodsId
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpData.GoodsId
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
  ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.26         *
*/

-- тест
-- SELECT * FROM gpReport_Component_Plan_Olap_Table (inStartDate:= '01.04.2026', inEndDate:= '03.04.2026', inGoodsGroupId:= 0/*1928*/, inInfoMoneyId:= 8911, inSession:= zfCalc_UserAdmin())
