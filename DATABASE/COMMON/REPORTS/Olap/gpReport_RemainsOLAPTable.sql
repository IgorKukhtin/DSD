-- Function: gpReport_RemainsOLAPTable ()

--DROP FUNCTION IF EXISTS gpReport_RemainsOLAPTable (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_RemainsOLAPTable (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_RemainsOLAPTable (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inUnitId             Integer   ,    -- от кого, может быть группа
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inIsDay              Boolean   ,   -- по дням
    IN inIsMonth            Boolean   ,   -- по месяцам
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (OperDate                   TDateTime
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
             , MeasureName                TVarChar

             , AmountStart_Weight_sum            TFloat
             , AmountEnd_Weight_sum              TFloat
             , AmountStart_Weight                TFloat
             , AmountEnd_Weight                  TFloat
             , AmountIncome_Weight               TFloat
             , AmountReturnOut_Weight            TFloat
             , AmountSendIn_Weight               TFloat
             , AmountSendOut_Weight              TFloat
             , AmountSendOnPriceIn_Weight        TFloat
             , AmountSendOnPriceOut_Weight       TFloat
             , AmountSendOnPriceOut_10900_Weight TFloat
             , AmountSendOnPrice_10500_Weight    TFloat
             , AmountSendOnPrice_40200_Weight    TFloat
             , AmountSale_Weight                 TFloat
             , AmountSale_10500_Weight           TFloat
             , AmountSale_40208_Weight           TFloat
             , AmountSaleReal_Weight             TFloat
             , AmountSaleReal_10500_Weight       TFloat
             , AmountSaleReal_40208_Weight       TFloat
             , AmountReturnIn_Weight             TFloat
             , AmountReturnIn_40208_Weight       TFloat
             , AmountReturnInReal_Weight         TFloat
             , AmountReturnInReal_40208_Weight   TFloat
             , AmountLoss_Weight                 TFloat
             , AmountInventory_Weight            TFloat
             , AmountProductionIn_Weight         TFloat
             , AmountProductionOut_Weight        TFloat
             , AmountTotalIn_Weight              TFloat
             , AmountTotalOut_Weight             TFloat

             , AmountStart_sh             TFloat
             , AmountEnd_sh               TFloat
             
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
             , AmountTotalIn              TFloat
             , AmountTotalOut             TFloat
             , CountDays                  TFloat

             )   
AS
$BODY$
    DECLARE vbDays TFloat;
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
 
 --RAISE EXCEPTION 'Ошибка. <%>, <%>, <%>.', inGoodsGroupId, inGoodsId, inUnitId;

    IF COALESCE (inGoodsGroupId, 0) <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
          SELECT lfObject_Goods_byGoodsGroup.GoodsId
          FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup
          WHERE (lfObject_Goods_byGoodsGroup.GoodsId = inGoodsId OR inGoodsId = 0)
          ;
    ELSE IF COALESCE (inGoodsId,0) <> 0
         THEN
             INSERT INTO _tmpGoods (GoodsId)
              SELECT inGoodsId;
         ELSE
             INSERT INTO _tmpGoods (GoodsId)
               SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
         END IF;
    END IF;

    -- ограничения по подразделению
    IF COALESCE (inUnitId,0) <> 0
    THEN
        INSERT INTO _tmpUnit (UnitId)
           SELECT lfSelect_Object_Unit_byGroup.UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect_Object_Unit_byGroup;
    ELSE
         INSERT INTO _tmpUnit (UnitId)
          SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Unit();
    END IF;
    
   vbDays := (SELECT COALESCE (DATE_PART('DAY', inEndDate - inStartDate) :: TFloat, 0) + 1) ::TFloat;
   
    -- Результат
    RETURN QUERY
      WITH 
           
           -- данные из таблицы RemainsOLAPTable
           tmpTable AS (SELECT tmp.*
                        FROM RemainsOLAPTable AS tmp
                             INNER JOIN _tmpUnit  ON _tmpUnit.UnitId   = tmp.UnitId
                             INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = tmp.GoodsId
                        WHERE tmp.OperDate BETWEEN inStartDate AND inEndDate
                        )

          -- группируем полученные данные по условиям отчета
         , tmpData AS (SELECT CASE WHEN inIsDay = TRUE THEN tmp.OperDate 
                                   WHEN inIsMonth = TRUE THEN DATE_TRUNC ('Month', tmp.OperDate )
                                   ELSE inStartDate
                              END AS OperDate
                            , tmp.UnitId
                            , tmp.GoodsId
                            , tmp.GoodsKindId
                            ,  (CASE WHEN inIsDay = TRUE THEN tmp.AmountStart 
                                     WHEN inIsMonth = TRUE AND tmp.OperDate = DATE_TRUNC ('Month', tmp.OperDate) THEN tmp.AmountStart
                                     WHEN inIsDay = FALSE AND inIsDay = FALSE AND tmp.OperDate = inStartDate THEN tmp.AmountStart
                                     ELSE 0
                                END) AS AmountStart
                            ,  (CASE WHEN inIsDay = TRUE THEN tmp.AmountEnd 
                                     WHEN inIsMonth = TRUE AND tmp.OperDate = DATE_TRUNC ('Month', tmp.OperDate) + INTERVAL '1 Month' - INTERVAL '1 Day' THEN tmp.AmountEnd
                                     WHEN inIsDay = FALSE AND inIsDay = FALSE AND tmp.OperDate = inEndDate THEN tmp.AmountEnd 
                                     ELSE 0
                                END) AS AmountEnd
                            --,  (CASE WHEN tmp.OperDate = inStartDate THEN tmp.AmountStart ELSE 0 END)  AS AmountStart   -- остаток на начало периода
                            --,  (CASE WHEN tmp.OperDate = inEndDate THEN tmp.AmountEnd ELSE 0 END)      AS AmountEnd     -- остаток на конец периода
                            , (tmp.AmountStart)                AS AmountStart_inf
                            , (tmp.AmountEnd)                  AS AmountEnd_inf
                            , (tmp.AmountIncome)               AS AmountIncome
                            , (tmp.AmountReturnOut)            AS AmountReturnOut
                            , (tmp.AmountSendIn)               AS AmountSendIn
                            , (tmp.AmountSendOut)              AS AmountSendOut
                            , (tmp.AmountSendOnPriceIn)        AS AmountSendOnPriceIn
                            , (tmp.AmountSendOnPriceOut)       AS AmountSendOnPriceOut
                            , (tmp.AmountSendOnPriceOut_10900) AS AmountSendOnPriceOut_10900
                            , (tmp.AmountSendOnPrice_10500)    AS AmountSendOnPrice_10500
                            , (tmp.AmountSendOnPrice_40200)    AS AmountSendOnPrice_40200
                            , (tmp.AmountSale)                 AS AmountSale
                            , (tmp.AmountSale_10500)           AS AmountSale_10500
                            , (tmp.AmountSale_40208)           AS AmountSale_40208
                            , (tmp.AmountSaleReal)             AS AmountSaleReal
                            , (tmp.AmountSaleReal_10500)       AS AmountSaleReal_10500
                            , (tmp.AmountSaleReal_40208)       AS AmountSaleReal_40208
                            , (tmp.AmountReturnIn)             AS AmountReturnIn
                            , (tmp.AmountReturnIn_40208)       AS AmountReturnIn_40208
                            , (tmp.AmountReturnInReal)         AS AmountReturnInReal
                            , (tmp.AmountReturnInReal_40208)   AS AmountReturnInReal_40208
                            , (tmp.AmountLoss)                 AS AmountLoss
                            , (tmp.AmountInventory)            AS AmountInventory
                            , (tmp.AmountProductionIn)         AS AmountProductionIn
                            , (tmp.AmountProductionOut)        AS AmountProductionOut
                            --, SUM (tmp.AmountStart) OVER(PARTITION BY tmp.UnitId, tmp.GoodsId, tmp.GoodsKindId) AS AmountStart_sum
                            --, SUM (tmp.AmountEnd) OVER(PARTITION BY tmp.UnitId, tmp.GoodsId, tmp.GoodsKindId) AS AmountEnd_sum
                        FROM tmpTable AS tmp
                        /*GROUP BY CASE WHEN inIsDay = TRUE THEN tmp.OperDate ELSE inStartDate END
                               , tmp.UnitId
                               , tmp.GoodsId
                               , tmp.GoodsKindId
                               */
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
      SELECT tmpData.OperDate ::TDateTime
           , tmpWeekDay.DayOfWeekName_Full ::TVarChar  AS DayOfWeekName
           , (EXTRACT ( Month from tmpData.OperDate) ||'.'||zfCalc_MonthName (tmpData.OperDate)) ::TVarChar AS MonthName
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
           , Object_Measure.ValueData         AS MeasureName

           , SUM (tmpData.AmountStart_inf) OVER(PARTITION BY tmpData.UnitId, tmpData.GoodsId, tmpData.GoodsKindId, tmpData.OperDate) :: TFloat AS AmountStart_sum    --AmountStart_Weight_sum
           , SUM (tmpData.AmountEnd_inf)   OVER(PARTITION BY tmpData.UnitId, tmpData.GoodsId, tmpData.GoodsKindId, tmpData.OperDate) :: TFloat AS AmountEnd_sum      --AmountEnd_Weight_sum
           --, (tmpData.AmountStart_sum            * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountStart_Weight_sum
           --, (tmpData.AmountEnd_sum              * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountEnd_Weight_sum
           , (tmpData.AmountStart                * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountStart_Weight
           , (tmpData.AmountEnd                  * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountEnd_Weight
           , (tmpData.AmountIncome               * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountIncome_Weight
           , (tmpData.AmountReturnOut            * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountReturnOut_Weight
           , (tmpData.AmountSendIn               * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountSendIn_Weight
           , (tmpData.AmountSendOut              * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountSendOut_Weight
           , (tmpData.AmountSendOnPriceIn        * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountSendOnPriceIn_Weight
           , (tmpData.AmountSendOnPriceOut       * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountSendOnPriceOut_Weight
           , (tmpData.AmountSendOnPriceOut_10900 * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountSendOnPriceOut_10900_Weight
           , (tmpData.AmountSendOnPrice_10500    * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountSendOnPrice_10500_Weight
           , (tmpData.AmountSendOnPrice_40200    * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountSendOnPrice_40200_Weight
           , (tmpData.AmountSale                 * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountSale_Weight
           , (tmpData.AmountSale_10500           * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountSale_10500_Weight
           , (tmpData.AmountSale_40208           * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountSale_40208_Weight
           , (tmpData.AmountSaleReal             * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountSaleReal_Weight
           , (tmpData.AmountSaleReal_10500       * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountSaleReal_10500_Weight
           , (tmpData.AmountSaleReal_40208       * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountSaleReal_40208_Weight
           , (tmpData.AmountReturnIn             * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountReturnIn_Weight
           , (tmpData.AmountReturnIn_40208       * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountReturnIn_40208_Weight
           , (tmpData.AmountReturnInReal         * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountReturnInReal_Weight
           , (tmpData.AmountReturnInReal_40208   * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountReturnInReal_40208_Weight
           , (tmpData.AmountLoss                 * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountLoss_Weight
           , (tmpData.AmountInventory            * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountInventory_Weight
           , (tmpData.AmountProductionIn         * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountProductionIn_Weight
           , (tmpData.AmountProductionOut        * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END ))  :: TFloat AS AmountProductionOut_Weight

           , ((tmpData.AmountIncome
             + tmpData.AmountSendIn
             + tmpData.AmountSendOnPriceIn
             + tmpData.AmountReturnIn
             + tmpData.AmountReturnIn_40208
             + tmpData.AmountProductionIn) * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END )) :: TFloat AS AmountTotalIn_Weight
           , ((tmpData.AmountReturnOut
             + tmpData.AmountSendOut
             + tmpData.AmountSendOnPriceOut
             + tmpData.AmountSale
             + tmpData.AmountSale_10500
             - tmpData.AmountSale_40208
             + tmpData.AmountLoss
             + tmpData.AmountProductionOut) * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END )):: TFloat AS AmountTotalOut_Weight

           , (tmpData.AmountStart                * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN 1 ELSE 0 END ))  :: TFloat AS AmountStart_sh
           , (tmpData.AmountEnd                  * (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN 1 ELSE 0 END ))  :: TFloat AS AmountEnd_sh

           , tmpData.AmountStart                  :: TFloat AS AmountStart
           , tmpData.AmountEnd                    :: TFloat AS AmountEnd
           , tmpData.AmountIncome                 :: TFloat AS AmountIncome
           , tmpData.AmountReturnOut              :: TFloat AS AmountReturnOut
           , tmpData.AmountSendIn                 :: TFloat AS AmountSendIn
           , tmpData.AmountSendOut                :: TFloat AS AmountSendOut
           , tmpData.AmountSendOnPriceIn          :: TFloat AS AmountSendOnPriceIn
           , tmpData.AmountSendOnPriceOut         :: TFloat AS AmountSendOnPriceOut
           , tmpData.AmountSendOnPriceOut_10900   :: TFloat AS AmountSendOnPriceOut_10900
           , tmpData.AmountSendOnPrice_10500      :: TFloat AS AmountSendOnPrice_10500
           , tmpData.AmountSendOnPrice_40200      :: TFloat AS AmountSendOnPrice_40200
           , tmpData.AmountSale                   :: TFloat AS AmountSale
           , tmpData.AmountSale_10500             :: TFloat AS AmountSale_10500
           , tmpData.AmountSale_40208             :: TFloat AS AmountSale_40208
           , tmpData.AmountSaleReal               :: TFloat AS AmountSaleReal
           , tmpData.AmountSaleReal_10500         :: TFloat AS AmountSaleReal_10500
           , tmpData.AmountSaleReal_40208         :: TFloat AS AmountSaleReal_40208
           , tmpData.AmountReturnIn               :: TFloat AS AmountReturnIn
           , tmpData.AmountReturnIn_40208         :: TFloat AS AmountReturnIn_40208
           , tmpData.AmountReturnInReal           :: TFloat AS AmountReturnInReal
           , tmpData.AmountReturnInReal_40208     :: TFloat AS AmountReturnInReal_40208
           , tmpData.AmountLoss                   :: TFloat AS AmountLoss
           , tmpData.AmountInventory              :: TFloat AS AmountInventory
           , tmpData.AmountProductionIn           :: TFloat AS AmountProductionIn
           , tmpData.AmountProductionOut          :: TFloat AS AmountProductionOut

           , (tmpData.AmountIncome
            + tmpData.AmountSendIn
            + tmpData.AmountSendOnPriceIn
            + tmpData.AmountReturnIn
            + tmpData.AmountReturnIn_40208
            + tmpData.AmountProductionIn) :: TFloat  AS AmountTotalIn
           , (tmpData.AmountReturnOut
            + tmpData.AmountSendOut
            + tmpData.AmountSendOnPriceOut
            + tmpData.AmountSale
            + tmpData.AmountSale_10500
            - tmpData.AmountSale_40208
            + tmpData.AmountLoss
            + tmpData.AmountProductionOut):: TFloat  AS AmountTotalOut
           
           , CASE WHEN inIsDay = TRUE THEN 1 ELSE vbDays END :: TFloat AS CountDays 

        FROM tmpData

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId
       
             LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = tmpData.GoodsId
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpGoodsParam.MeasureId
             
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId

             LEFT JOIN zfCalc_DayOfWeekName (tmpData.OperDate) AS tmpWeekDay ON 1=1
        ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.11.22         *
 17.07.18         *
*/

-- тест-
-- select * from gpReport_RemainsOLAPTable(inStartDate := ('01.01.2019')::TDateTime , inEndDate := ('02.01.2019')::TDateTime , inUnitId:= 0, inGoodsGroupId := 0 , inGoodsId := 0 , inIsDay := FALSE , inIsMonth:=FALSE , inSession := '5');
     select * from gpReport_RemainsOLAPTable(inStartDate := ('01.01.2023')::TDateTime , inEndDate := ('01.01.2023')::TDateTime , inUnitId := 8459 , inGoodsGroupId := 1832 , inGoodsId := 2383 , inIsDay := 'False' , inisMonth := 'False' ,  inSession := '9457');