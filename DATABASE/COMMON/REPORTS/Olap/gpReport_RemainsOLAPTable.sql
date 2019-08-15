-- Function: gpReport_RemainsOLAPTable ()

DROP FUNCTION IF EXISTS gpReport_RemainsOLAPTable (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_RemainsOLAPTable (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inUnitId             Integer   ,    -- от кого, может быть группа
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inIsDay              Boolean   ,
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (tmpData.OperDate           TDateTime
             , DayOfWeekName              TVarChar
             , MonthName                  TVarChar
             , Year                       TVarChar
             , UnitCode                   Integer
             , UnitName                   TVarChar
             , GoodsGroupNameFull         TVarChar
             , GoodsGroupAnalystName      TVarChar
             , TradeMarkName              TVarChar
             , GoodsTagName               TVarChar
             , GoodsPlatformName          TVarChar
             , GoodsGroupName             TVarChar
             , GoodsName_basis            TVarChar
             , GoodsName_main             TVarChar
             , GoodsCode                  Integer
             , GoodsName                  TVarChar
             , GoodsKindName              TVarChar
             , AmountStart_inf            TFloat
             , AmountEnd_inf              TFloat
             , AmountStart                TFloat
             , AmountEnd                  TFloat
             , AmountIncome               TFloat
             , AmountReturnOut            TFloat
             , AmountSendIn               TFloat
             , AmountSendOut              TFloat
             , AmountSendOnPriceIn        TFloat
             , AmountSendOnPriceOut       TFloat
             , AmountSendOnPriceOut_10900 TFloat
             , AmountSendOnPrice_10500    TFloat
             , AmountSendOnPrice_40200    TFloat
             , AmountSale                 TFloat
             , AmountSale_10500           TFloat
             , AmountSale_40208           TFloat
             , AmountSaleReal             TFloat
             , AmountSaleReal_10500       TFloat
             , AmountSaleReal_40208       TFloat
             , AmountReturnIn             TFloat
             , AmountReturnIn_40208       TFloat
             , AmountReturnInReal         TFloat
             , AmountReturnInReal_40208   TFloat
             , AmountLoss                 TFloat
             , AmountInventory            TFloat
             , AmountProductionIn         TFloat
             , AmountProductionOut        TFloat
             )   
AS
$BODY$
BEGIN

    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
 
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
          SELECT GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE IF inGoodsId <> 0
         THEN
             INSERT INTO _tmpGoods (GoodsId)
              SELECT inGoodsId;
         ELSE
             INSERT INTO _tmpGoods (GoodsId)
               SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
         END IF;
    END IF;

    -- ограничения по ОТ КОГО
    IF inUnitId <> 0
    THEN
        INSERT INTO _tmpUnit (UnitId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect_Object_Unit_byGroup;
    ELSE
         INSERT INTO _tmpUnit (UnitId)
          SELECT Id FROM Object WHERE Object.DescId = zc_Object_Unit();
    END IF;
  
    -- Результат
    RETURN QUERY
      WITH 
           
           -- данные из таблицы RemainsOLAPTable
           tmpTable AS (SELECT *
                        FROM RemainsOLAPTable AS tmp
                             INNER JOIN _tmpUnit  ON _tmpUnit.UnitId   = tmp.UnitId
                             INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = tmp.GoodsId
                        WHERE tmp.OperDate BETWEEN inStartDate AND inEndDate
                        )

          -- группируем полученные данные по условиям отчета
         , tmpData AS (SELECT CASE WHEN inIsDay = TRUE THEN tmp.OperDate ELSE inStartDate END AS OperDate
                            , tmp.UnitId
                            , tmp.GoodsId
                            , tmp.GoodsKindId
                            , CASE WHEN inIsDay = TRUE THEN tmp.AmountStart ELSE CASE WHEN tmp.OperDate = inStartDate THEN tmp.AmountStart ELSE 0 END END AS AmountStart_inf
                            , CASE WHEN inIsDay = TRUE THEN tmp.AmountEnd ELSE CASE WHEN tmp.OperDate = inEndDate THEN tmp.AmountEnd ELSE 0 END END AS AmountEnd_inf
                            , SUM (tmp.AmountStart)                AS AmountStart
                            , SUM (tmp.AmountEnd)                  AS AmountEnd
                            , SUM (tmp.AmountIncome)               AS AmountIncome
                            , SUM (tmp.AmountReturnOut)            AS AmountReturnOut
                            , SUM (tmp.AmountSendIn)               AS AmountSendIn
                            , SUM (tmp.AmountSendOut)              AS AmountSendOut
                            , SUM (tmp.AmountSendOnPriceIn)        AS AmountSendOnPriceIn
                            , SUM (tmp.AmountSendOnPriceOut)       AS AmountSendOnPriceOut
                            , SUM (tmp.AmountSendOnPriceOut_10900) AS AmountSendOnPriceOut_10900
                            , SUM (tmp.AmountSendOnPrice_10500)    AS AmountSendOnPrice_10500
                            , SUM (tmp.AmountSendOnPrice_40200)    AS AmountSendOnPrice_40200
                            , SUM (tmp.AmountSale)                 AS AmountSale
                            , SUM (tmp.AmountSale_10500)           AS AmountSale_10500
                            , SUM (tmp.AmountSale_40208)           AS AmountSale_40208
                            , SUM (tmp.AmountSaleReal)             AS AmountSaleReal
                            , SUM (tmp.AmountSaleReal_10500)       AS AmountSaleReal_10500
                            , SUM (tmp.AmountSaleReal_40208)       AS AmountSaleReal_40208
                            , SUM (tmp.AmountReturnIn)             AS AmountReturnIn
                            , SUM (tmp.AmountReturnIn_40208)       AS AmountReturnIn_40208
                            , SUM (tmp.AmountReturnInReal)         AS AmountReturnInReal
                            , SUM (tmp.AmountReturnInReal_40208)   AS AmountReturnInReal_40208
                            , SUM (tmp.AmountLoss)                 AS AmountLoss
                            , SUM (tmp.AmountInventory)            AS AmountInventory
                            , SUM (tmp.AmountProductionIn)         AS AmountProductionIn
                            , SUM (tmp.AmountProductionOut)        AS AmountProductionOut
                        FROM tmpTable AS tmp
                        GROUP BY CASE WHEN inIsDay = TRUE THEN tmp.OperDate ELSE inStartDate END
                               , tmp.UnitId
                               , tmp.GoodsId
                               , tmp.GoodsKindId
                               , CASE WHEN inIsDay = TRUE THEN tmp.AmountStart ELSE CASE WHEN tmp.OperDate = inStartDate THEN tmp.AmountStart ELSE 0 END END
                               , CASE WHEN inIsDay = TRUE THEN tmp.AmountEnd ELSE CASE WHEN tmp.OperDate = inEndDate THEN tmp.AmountEnd ELSE 0 END END
                       )

         , tmpGoodsParam AS (SELECT tmpGoods.GoodsId
                                  , Object_Goods_main.ValueData                  AS GoodsName_main        --
                                  , Object_Goods_basis.ValueData                 AS GoodsName_basis       --
                                  , Object_GoodsGroup.ValueData                  AS GoodsGroupName        --
                                  , ObjectLink_Goods_Measure.ChildObjectId       AS MeasureId
                                  , ObjectFloat_Weight.ValueData                 AS Weight
                                  , ObjectString_Goods_GoodsGroupFull.ValueData  AS GoodsGroupNameFull    --
                                  , Object_GoodsGroupAnalyst.ValueData           AS GoodsGroupAnalystName --
                                  , Object_TradeMark.ValueData                   AS TradeMarkName         --
                                  , Object_GoodsTag.ValueData                    AS GoodsTagName          --
                                  , Object_GoodsPlatform.ValueData               AS GoodsPlatformName     --
                             FROM (SELECT DISTINCT tmpData.GoodsId FROM tmpData) AS tmpGoods
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                       ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                  LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                       ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                                  LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                        ON ObjectFloat_Weight.ObjectId = tmpGoods.GoodsId
                                                       AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                                  LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                         ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                                        AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                                       ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
                                  LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                       ON ObjectLink_Goods_TradeMark.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                                  LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                                       ON ObjectLink_Goods_GoodsTag.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                                  LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                                       ON ObjectLink_Goods_GoodsPlatform.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
                                  LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsMain
                                                       ON ObjectLink_Goods_GoodsMain.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_GoodsMain.DescId   = zc_ObjectLink_Goods_GoodsMain()
                                  LEFT JOIN Object AS Object_Goods_main ON Object_Goods_main.Id = ObjectLink_Goods_GoodsMain.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsBasis
                                                       ON ObjectLink_Goods_GoodsBasis.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_GoodsBasis.DescId   = zc_ObjectLink_Goods_GoodsBasis()
                                  LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = ObjectLink_Goods_GoodsBasis.ChildObjectId
                            )


      -- Результат 
      SELECT tmpData.OperDate
           , tmpWeekDay.DayOfWeekName_Full ::TVarChar  AS DayOfWeekName
           , zfCalc_MonthName (DATE_TRUNC ('Month', tmpData.OperDate)) ::TVarChar AS MonthName
           , DATE_TRUNC ('YEAR', tmpData.OperDate) ::TVarChar AS Year

           , Object_Unit.ObjectCode          AS UnitCode
           , Object_Unit.ValueData           AS UnitName  

           , tmpGoodsParam.GoodsGroupNameFull
           , tmpGoodsParam.GoodsGroupAnalystName
           , tmpGoodsParam.TradeMarkName
           , tmpGoodsParam.GoodsTagName
           , tmpGoodsParam.GoodsPlatformName
           , tmpGoodsParam.GoodsGroupName
           , tmpGoodsParam.GoodsName_basis
           , tmpGoodsParam.GoodsName_main
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName  
           , Object_GoodsKind.ValueData       AS GoodsKindName

           , tmpData.AmountStart_inf            ::TFloat
           , tmpData.AmountEnd_inf              ::TFloat
           , tmpData.AmountStart                ::TFloat
           , tmpData.AmountEnd                  ::TFloat
           , tmpData.AmountIncome               ::TFloat
           , tmpData.AmountReturnOut            ::TFloat
           , tmpData.AmountSendIn               ::TFloat
           , tmpData.AmountSendOut              ::TFloat
           , tmpData.AmountSendOnPriceIn        ::TFloat
           , tmpData.AmountSendOnPriceOut       ::TFloat
           , tmpData.AmountSendOnPriceOut_10900 ::TFloat
           , tmpData.AmountSendOnPrice_10500    ::TFloat
           , tmpData.AmountSendOnPrice_40200    ::TFloat
           , tmpData.AmountSale                 ::TFloat
           , tmpData.AmountSale_10500           ::TFloat
           , tmpData.AmountSale_40208           ::TFloat
           , tmpData.AmountSaleReal             ::TFloat
           , tmpData.AmountSaleReal_10500       ::TFloat
           , tmpData.AmountSaleReal_40208       ::TFloat
           , tmpData.AmountReturnIn             ::TFloat
           , tmpData.AmountReturnIn_40208       ::TFloat
           , tmpData.AmountReturnInReal         ::TFloat
           , tmpData.AmountReturnInReal_40208   ::TFloat
           , tmpData.AmountLoss                 ::TFloat
           , tmpData.AmountInventory            ::TFloat
           , tmpData.AmountProductionIn         ::TFloat
           , tmpData.AmountProductionOut        ::TFloat

        FROM tmpData

             LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpData.GoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId
       
             LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = tmpData.GoodsId
             
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId

             LEFT JOIN zfCalc_DayOfWeekName (tmpData.OperDate) AS tmpWeekDay ON 1=1
        ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.07.18         *
*/

-- тест-
 -- SELECT * FROM gpReport_RemainsOLAPTable (inStartDate:= '01.06.2018', inEndDate:= '01.06.2018', inStartDate2:= '05.06.2017', inEndDate2:= '05.06.2017', inIsMovement:= FALSE, inIsPartion:= FALSE, inGoodsGroupId:= 0, inGoodsId:= 0, inUnitId:= 0, inSession:= zfCalc_UserAdmin()) limit 1;