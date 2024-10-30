-- Function: gpReport_HistoryCost_Compare()

/*
  Новый отчет - сравнение цен с/с за 2 периода - табл HistoryCost - колонка Price, 4 входящих параметра месяц1 и месяц2 + товар (если нет, тогда по всем)
  + по товару да/нет (тогда группируется GoodsId + GoodsKindId, иначе по ContainerId),

   из первого периода всегда sum (HistoryCost.Price) с группировкой GoodsId + GoodsKindId или GoodsId + GoodsKindId
   + zc_ContainerLinkObject_Unit + zc_ContainerLinkObject_InfoMoneyDetail,
    в результате у нас Товар + вид+ ContainerId (если нет галки да/нет) + UnitId + InfoMoneyDetailId - из второго периода
     и поиск цены для Товар + вид + UnitId + InfoMoneyDetailId из первого периода

*/

DROP FUNCTION IF EXISTS gpReport_HistoryCost_Compare (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_HistoryCost_Compare (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_HistoryCost_Compare (
    IN inMonth1             TDateTime , --   прошлый период
    IN inMonth2             TDateTime , --   текущий период
    IN inUnitId             Integer,    --
    IN inGoodId             Integer,    --
    IN inisGoods            Boolean,    --
    IN inSession            TVarChar   -- пользователь
)
RETURNS TABLE (ContainerId Integer, PartionGoodsId Integer
             , AccountName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
             , UnitId Integer, UnitName TVarChar
             , InfoMoneyDetailName TVarChar
             , PartionGoods TVarChar, PartionGoodsDate TDateTime
             , Price_1        TFloat   --цена себестоимость период 1
             , Price_2        TFloat   --цена себестоимость период 2
             , Price_diff     TFloat   --
             , Price_Tax      TFloat   --
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbStartDate1 TDateTime;
  DECLARE vbStartDate2 TDateTime;
  DECLARE vbEndDate1 TDateTime;
  DECLARE vbEndDate2 TDateTime;

BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());
    vbUserId:= lpGetUserBySession (inSession);


    vbStartDate1 := DATE_TRUNC ('MONTH', inMonth1);
    vbEndDate1   := vbStartDate1 + INTERVAL '1 Month' - INTERVAL '1 Day';
    vbStartDate2 := DATE_TRUNC ('MONTH', inMonth2);
    vbEndDate2   := vbStartDate2 + INTERVAL '1 Month' - INTERVAL '1 Day';

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (vbStartDate1, vbEndDate1, NULL, NULL, NULL, vbUserId);


    RETURN QUERY
    WITH
        -- первый период
        tmpHistoryCost1_all AS (SELECT DISTINCT
                                       HistoryCost.Price                          AS Price
                                     , COALESCE (CLO_InfoMoneyDetail.ObjectId, 0) AS InfoMoneyDetailId
                                     , CLO_Unit.ObjectId                          AS UnitId
                                     , Container_count.ObjectId                   AS GoodsId
                                     , COALESCE (CLO_GoodsKind.ObjectId, 0)       AS GoodsKindId
                                   --, Container_sum.ObjectId       AS AccountId
                                FROM HistoryCost
                                    JOIN Container AS Container_sum ON Container_sum.Id     = HistoryCost.ContainerId
                                                                   AND Container_sum.DescId = zc_Container_Summ()

                                    JOIN Container AS Container_count ON Container_count.Id     = Container_sum.ParentId
                                                                     AND Container_count.DescId = zc_Container_Count()
                                    LEFT JOIN ContainerLinkObject AS CLO_Account
                                                                  ON CLO_Account.ContainerId = Container_count.Id
                                                                 AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()
                                    LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                                  ON CLO_Unit.ContainerId = Container_sum.Id
                                                                 AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                    LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                                                  ON CLO_InfoMoneyDetail.ContainerId = Container_sum.Id
                                                                 AND CLO_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
                                    LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                  ON CLO_GoodsKind.ContainerId = Container_sum.Id
                                                                 AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                WHERE HistoryCost.StartDate <= vbEndDate1
                                  AND HistoryCost.EndDate   >= vbStartDate1
                                  AND (Container_count.ObjectId = inGoodId OR inGoodId = 0)
                                  AND (CLO_Unit.ObjectId = inUnitId OR inUnitId = 0)
                                  -- без Товар в пути
                                  AND CLO_Account.ObjectId IS NULL
                               )
          , tmpHistoryCost1 AS (SELECT
                                      SUM (tmpHistoryCost1_all.Price)  AS Price
                                    , CASE WHEN inIsGoods = TRUE THEN 0 ELSE tmpHistoryCost1_all.InfoMoneyDetailId END AS InfoMoneyDetailId
                                    , tmpHistoryCost1_all.UnitId
                                    , tmpHistoryCost1_all.GoodsId
                                    , tmpHistoryCost1_all.GoodsKindId
                                FROM tmpHistoryCost1_all
                                GROUP BY CASE WHEN inIsGoods = TRUE THEN 0 ELSE tmpHistoryCost1_all.InfoMoneyDetailId END
                                       , tmpHistoryCost1_all.UnitId
                                       , tmpHistoryCost1_all.GoodsId
                                       , tmpHistoryCost1_all.GoodsKindId
                               )
        -- второй переиод
      , tmpHistoryCost2_all AS (SELECT DISTINCT
                                       HistoryCost.Price                          AS Price
                                     , COALESCE (CLO_InfoMoneyDetail.ObjectId, 0) AS InfoMoneyDetailId
                                     , CLO_Unit.ObjectId                          AS UnitId
                                     , Container_count.ObjectId                   AS GoodsId
                                     , COALESCE (CLO_GoodsKind.ObjectId, 0)       AS GoodsKindId
                                     , CASE WHEN inIsGoods = TRUE THEN 0 ELSE HistoryCost.ContainerId   END AS ContainerId
                                     , CASE WHEN inIsGoods = TRUE THEN 0 ELSE CLO_PartionGoods.ObjectId END AS PartionGoodsId
                                     , Container_sum.ObjectId                     AS AccountId
                                FROM HistoryCost
                                     JOIN Container AS Container_sum ON Container_sum.Id     = HistoryCost.ContainerId
                                                                    AND Container_sum.DescId = zc_Container_Summ()
                                     JOIN Container AS Container_count ON Container_count.Id     = Container_sum.ParentId
                                                                      AND Container_count.DescId = zc_Container_Count()

                                     --LEFT JOIN ContainerLinkObject AS CLO_Account
                                     --                              ON CLO_Account.ContainerId = Container_count.Id
                                     --                             AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()
                                     LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                                   ON CLO_Unit.ContainerId = Container_sum.Id
                                                                  AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                     LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                                                   ON CLO_InfoMoneyDetail.ContainerId = Container_sum.Id
                                                                  AND CLO_InfoMoneyDetail.DescId      = zc_ContainerLinkObject_InfoMoneyDetail()
                                     LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                   ON CLO_GoodsKind.ContainerId = Container_sum.Id
                                                                  AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                   ON CLO_PartionGoods.ContainerId = Container_sum.Id
                                                                  AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                WHERE HistoryCost.StartDate <= vbEndDate2
                                  AND HistoryCost.EndDate >= vbStartDate2
                                  AND (Container_count.ObjectId = inGoodId OR inGoodId = 0)
                                  AND (CLO_Unit.ObjectId = inUnitId OR inUnitId = 0)
                                  -- без Товар в пути
                                  --AND CLO_Account.ObjectId IS NULL
                               )

          , tmpHistoryCost2 AS (SELECT SUM (tmpHistoryCost2_all.Price)  AS Price
                                     , CASE WHEN inIsGoods = TRUE THEN 0 ELSE tmpHistoryCost2_all.InfoMoneyDetailId END AS InfoMoneyDetailId
                                     , tmpHistoryCost2_all.UnitId
                                     , tmpHistoryCost2_all.GoodsId
                                     , tmpHistoryCost2_all.GoodsKindId
                                     , tmpHistoryCost2_all.ContainerId
                                     , tmpHistoryCost2_all.PartionGoodsId
                                     , tmpHistoryCost2_all.AccountId
                                FROM tmpHistoryCost2_all
                                GROUP BY CASE WHEN inIsGoods = TRUE THEN 0 ELSE tmpHistoryCost2_all.InfoMoneyDetailId END
                                       , tmpHistoryCost2_all.UnitId
                                       , tmpHistoryCost2_all.GoodsId
                                       , tmpHistoryCost2_all.GoodsKindId
                                       , tmpHistoryCost2_all.ContainerId
                                       , tmpHistoryCost2_all.PartionGoodsId
                                       , tmpHistoryCost2_all.AccountId
                              )

      , tmpResult AS (SELECT tmpHistoryCost2.GoodsId
                           , tmpHistoryCost2.GoodsKindId
                           , tmpHistoryCost2.UnitId
                           , tmpHistoryCost2.InfoMoneyDetailId
                           , tmpHistoryCost2.ContainerId
                           , tmpHistoryCost2.PartionGoodsId
                           , tmpHistoryCost2.AccountId
                           , tmpHistoryCost1.Price      AS Price_1
                           , tmpHistoryCost2.Price      AS Price_2
                      FROM tmpHistoryCost2
                          LEFT JOIN tmpHistoryCost1 ON tmpHistoryCost1.GoodsId           = tmpHistoryCost2.GoodsId
                                                   AND tmpHistoryCost1.GoodsKindId       = tmpHistoryCost2.GoodsKindId
                                                   AND tmpHistoryCost1.UnitId            = tmpHistoryCost2.UnitId
                                                   AND tmpHistoryCost1.InfoMoneyDetailId = tmpHistoryCost2.InfoMoneyDetailId
                      )
   --
   SELECT tmpResult.ContainerId          AS ContainerId
        , tmpResult.PartionGoodsId
        , ('(' || Object_Account.ObjectCode :: TVarChar || ') ' || Object_Account.ValueData) :: TVarChar AS AccountName
        , Object_GoodsGroup.Id           AS GoodsGroupId
        , Object_GoodsGroup.ValueData    AS GoodsGroupName
        , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
        , Object_Goods.Id                AS GoodsId
        , Object_Goods.ObjectCode        AS GoodsCode
        , Object_Goods.ValueData         AS GoodsName
        , Object_GoodsKind.Id            AS GoodsKindId
        , Object_GoodsKind.ValueData     AS GoodsKindName
        , Object_Measure.ValueData       AS MeasureName

        , Object_Unit.Id                 AS UnitId
        , Object_Unit.ValueData          AS UnitName

        , Object_InfoMoneyDetail.ValueData  AS InfoMoneyDetailName
        , Object_PartionGoods.ValueData     AS PartionGoods
        , ObjectDate_PartionGoods.ValueData AS PartionGoodsDate

        , tmpResult.Price_1 ::TFloat     AS Price_1
        , tmpResult.Price_2 ::TFloat     AS Price_2
        , (COALESCE (tmpResult.Price_1,0) - COALESCE (tmpResult.Price_2,0)):: TFloat AS Price_diff

        , CASE WHEN tmpResult.Price_2 <> 0 AND tmpResult.Price_1 <> 0
                    THEN 100 * tmpResult.Price_1 / tmpResult.Price_2 - 100
               WHEN COALESCE (tmpResult.Price_2, 0) <> 0 AND COALESCE (tmpResult.Price_1, 0) = 0
                    THEN -100
               WHEN COALESCE (tmpResult.Price_2, 0) = 0  AND COALESCE (tmpResult.Price_1, 0) <> 0
                    THEN 100
               ELSE 0
                    
          END :: TFloat AS Price_Tax
        

   FROM tmpResult

        LEFT JOIN Object AS Object_Account ON Object_Account.Id = tmpResult.AccountId
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsId
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpResult.GoodsKindId
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpResult.UnitId
        LEFT JOIN Object AS Object_InfoMoneyDetail ON Object_InfoMoneyDetail.Id = tmpResult.InfoMoneyDetailId
        LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpResult.PartionGoodsId
        LEFT JOIN ObjectDate AS ObjectDate_PartionGoods
                             ON ObjectDate_PartionGoods.ObjectId = tmpResult.PartionGoodsId
                            AND ObjectDate_PartionGoods.DescId   = zc_ObjectDate_PartionGoods_Value()

        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                               ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                              AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.10.24         *
*/

-- тест
-- SELECT * FROM gpReport_HistoryCost_Compare (inMonth1 := '01.08.2024' ::TDateTime, inMonth2 := '01.09.2024' ::TDateTime, inUnitId:= 8459, inGoodId:= 2062, inisGoods:= false, inSession := zfCalc_UserAdmin() )
