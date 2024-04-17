-- Function: gpUpdateMI_OrderInternal_AmountForecastPromo()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountForecastPromo (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountForecastPromo(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inStartDate           TDateTime , -- Дата документа
    IN inEndDate             TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbNumberStart  Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());


    -- !!!НАШЛИ!!!
    SELECT gpGet.StartDate, gpGet.EndDate
           INTO inStartDate, inEndDate
    FROM gpGet_Object_GoodsReportSaleInf (inSession) AS gpGet;

    -- !!!определили + сдвинули на завтрашний день!!!
    vbNumberStart:= (SELECT EXTRACT (DOW FROM Movement.OperDate + INTERVAL '1 DAY') FROM Movement WHERE Movement.Id = inMovementId);
    IF vbNumberStart = 0 THEN vbNumberStart:= 7; END IF;

    -- сохранили свойство <Дата проноз с>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), inMovementId, inStartDate);
    -- сохранили свойство <Дата проноз по>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), inMovementId, inEndDate);


     -- таблица -
     CREATE TEMP TABLE tmpAll (MovementItemId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, AmountForecastOrder TFloat, AmountForecastOrderPromo TFloat, AmountForecast TFloat, AmountForecastPromo TFloat
                             , Value1 TFloat, Value2 TFloat, Value3 TFloat, Value4 TFloat, Value5 TFloat, Value6 TFloat, Value7 TFloat
                             , Promo1 TFloat, Promo2 TFloat, Promo3 TFloat, Promo4 TFloat, Promo5 TFloat, Promo6 TFloat, Promo7 TFloat
                              ) ON COMMIT DROP;
         WITH -- хардкодим - Склады База + Реализации
              tmpUnit AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect_Object_Unit_byGroup)
              -- хардкодим - товары ГП
            , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                           FROM Object_InfoMoney_View
                                INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                      ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                     AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
                           WHERE Object_InfoMoney_View.InfoMoneyId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                     , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                     , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                      )
                          )
            , tmpMIAll AS
              (SELECT ObjectLink_Goods.ChildObjectId                                           AS GoodsId
                    , COALESCE (ObjectLink_GoodsKind.ChildObjectId, 0)                         AS GoodsKindId

                    ,     COALESCE (ObjectFloat_Order1.ValueData, 0)        AS Order1
                    ,     COALESCE (ObjectFloat_Order2.ValueData, 0)        AS Order2
                    ,     COALESCE (ObjectFloat_Order3.ValueData, 0)        AS Order3
                    ,     COALESCE (ObjectFloat_Order4.ValueData, 0)        AS Order4
                    ,     COALESCE (ObjectFloat_Order5.ValueData, 0)        AS Order5
                    ,     COALESCE (ObjectFloat_Order6.ValueData, 0)        AS Order6
                    ,     COALESCE (ObjectFloat_Order7.ValueData, 0)        AS Order7

                    ,     COALESCE (ObjectFloat_OrderBranch1.ValueData, 0)  AS OrderBranch1
                    ,     COALESCE (ObjectFloat_OrderBranch2.ValueData, 0)  AS OrderBranch2
                    ,     COALESCE (ObjectFloat_OrderBranch3.ValueData, 0)  AS OrderBranch3
                    ,     COALESCE (ObjectFloat_OrderBranch4.ValueData, 0)  AS OrderBranch4
                    ,     COALESCE (ObjectFloat_OrderBranch5.ValueData, 0)  AS OrderBranch5
                    ,     COALESCE (ObjectFloat_OrderBranch6.ValueData, 0)  AS OrderBranch6
                    ,     COALESCE (ObjectFloat_OrderBranch7.ValueData, 0)  AS OrderBranch7

                    ,     COALESCE (ObjectFloat_Amount1.ValueData, 0)       AS Amount1
                    ,     COALESCE (ObjectFloat_Amount2.ValueData, 0)       AS Amount2
                    ,     COALESCE (ObjectFloat_Amount3.ValueData, 0)       AS Amount3
                    ,     COALESCE (ObjectFloat_Amount4.ValueData, 0)       AS Amount4
                    ,     COALESCE (ObjectFloat_Amount5.ValueData, 0)       AS Amount5
                    ,     COALESCE (ObjectFloat_Amount6.ValueData, 0)       AS Amount6
                    ,     COALESCE (ObjectFloat_Amount7.ValueData, 0)       AS Amount7

                    ,     COALESCE (ObjectFloat_Branch1.ValueData, 0)       AS Branch1
                    ,     COALESCE (ObjectFloat_Branch2.ValueData, 0)       AS Branch2
                    ,     COALESCE (ObjectFloat_Branch3.ValueData, 0)       AS Branch3
                    ,     COALESCE (ObjectFloat_Branch4.ValueData, 0)       AS Branch4
                    ,     COALESCE (ObjectFloat_Branch5.ValueData, 0)       AS Branch5
                    ,     COALESCE (ObjectFloat_Branch6.ValueData, 0)       AS Branch6
                    ,     COALESCE (ObjectFloat_Branch7.ValueData, 0)       AS Branch7

                    ,     (COALESCE (ObjectFloat_Order1.ValueData, 0)
                         + COALESCE (ObjectFloat_Order2.ValueData, 0)
                         + COALESCE (ObjectFloat_Order3.ValueData, 0)
                         + COALESCE (ObjectFloat_Order4.ValueData, 0)
                         + COALESCE (ObjectFloat_Order5.ValueData, 0)
                         + COALESCE (ObjectFloat_Order6.ValueData, 0)
                         + COALESCE (ObjectFloat_Order7.ValueData, 0)

                         + COALESCE (ObjectFloat_OrderBranch1.ValueData, 0)
                         + COALESCE (ObjectFloat_OrderBranch2.ValueData, 0)
                         + COALESCE (ObjectFloat_OrderBranch3.ValueData, 0)
                         + COALESCE (ObjectFloat_OrderBranch4.ValueData, 0)
                         + COALESCE (ObjectFloat_OrderBranch5.ValueData, 0)
                         + COALESCE (ObjectFloat_OrderBranch6.ValueData, 0)
                         + COALESCE (ObjectFloat_OrderBranch7.ValueData, 0)
                          ) AS AmountOrder
                    ,     (COALESCE (ObjectFloat_OrderPromo1.ValueData, 0)
                         + COALESCE (ObjectFloat_OrderPromo2.ValueData, 0)
                         + COALESCE (ObjectFloat_OrderPromo3.ValueData, 0)
                         + COALESCE (ObjectFloat_OrderPromo4.ValueData, 0)
                         + COALESCE (ObjectFloat_OrderPromo5.ValueData, 0)
                         + COALESCE (ObjectFloat_OrderPromo6.ValueData, 0)
                         + COALESCE (ObjectFloat_OrderPromo7.ValueData, 0)
                          ) AS AmountOrderPromo

                    ,     (COALESCE (ObjectFloat_Amount1.ValueData, 0)
                         + COALESCE (ObjectFloat_Amount2.ValueData, 0)
                         + COALESCE (ObjectFloat_Amount3.ValueData, 0)
                         + COALESCE (ObjectFloat_Amount4.ValueData, 0)
                         + COALESCE (ObjectFloat_Amount5.ValueData, 0)
                         + COALESCE (ObjectFloat_Amount6.ValueData, 0)
                         + COALESCE (ObjectFloat_Amount7.ValueData, 0)

                         + COALESCE (ObjectFloat_Branch1.ValueData, 0)
                         + COALESCE (ObjectFloat_Branch2.ValueData, 0)
                         + COALESCE (ObjectFloat_Branch3.ValueData, 0)
                         + COALESCE (ObjectFloat_Branch4.ValueData, 0)
                         + COALESCE (ObjectFloat_Branch5.ValueData, 0)
                         + COALESCE (ObjectFloat_Branch6.ValueData, 0)
                         + COALESCE (ObjectFloat_Branch7.ValueData, 0)
                          ) AS AmountSale
                    ,     (COALESCE (ObjectFloat_Promo1.ValueData, 0)
                         + COALESCE (ObjectFloat_Promo2.ValueData, 0)
                         + COALESCE (ObjectFloat_Promo3.ValueData, 0)
                         + COALESCE (ObjectFloat_Promo4.ValueData, 0)
                         + COALESCE (ObjectFloat_Promo5.ValueData, 0)
                         + COALESCE (ObjectFloat_Promo6.ValueData, 0)
                         + COALESCE (ObjectFloat_Promo7.ValueData, 0)
                          ) AS AmountSalePromo

               FROM tmpGoods
                    INNER JOIN ObjectLink AS ObjectLink_Goods
                                          ON ObjectLink_Goods.ChildObjectId = tmpGoods.GoodsId
                                         AND ObjectLink_Goods.DescId        = zc_ObjectLink_GoodsReportSale_Goods()
                    INNER JOIN ObjectLink AS ObjectLink_Unit
                                          ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                         AND ObjectLink_Unit.DescId        = zc_ObjectLink_GoodsReportSale_Unit()
                    INNER JOIN tmpUnit ON tmpUnit.UnitId = ObjectLink_Unit.ChildObjectId
                    LEFT JOIN ObjectLink AS ObjectLink_GoodsKind
                                         ON ObjectLink_GoodsKind.ObjectId = ObjectLink_Goods.ObjectId
                                        AND ObjectLink_GoodsKind.DescId   = zc_ObjectLink_GoodsReportSale_GoodsKind()

                    -- 1.1 Продажи
                    LEFT JOIN ObjectFloat AS ObjectFloat_Amount1
                                          ON ObjectFloat_Amount1.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Amount1.DescId = zc_ObjectFloat_GoodsReportSale_Amount1()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Amount2
                                          ON ObjectFloat_Amount2.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Amount2.DescId = zc_ObjectFloat_GoodsReportSale_Amount2()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Amount3
                                          ON ObjectFloat_Amount3.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Amount3.DescId = zc_ObjectFloat_GoodsReportSale_Amount3()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Amount4
                                          ON ObjectFloat_Amount4.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Amount4.DescId = zc_ObjectFloat_GoodsReportSale_Amount4()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Amount5
                                          ON ObjectFloat_Amount5.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Amount5.DescId = zc_ObjectFloat_GoodsReportSale_Amount5()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Amount6
                                          ON ObjectFloat_Amount6.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Amount6.DescId = zc_ObjectFloat_GoodsReportSale_Amount6()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Amount7
                                          ON ObjectFloat_Amount7.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Amount7.DescId = zc_ObjectFloat_GoodsReportSale_Amount7()
                    -- 1.2 Продажи
                    LEFT JOIN ObjectFloat AS ObjectFloat_Promo1
                                          ON ObjectFloat_Promo1.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Promo1.DescId = zc_ObjectFloat_GoodsReportSale_Promo1()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Promo2
                                          ON ObjectFloat_Promo2.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Promo2.DescId = zc_ObjectFloat_GoodsReportSale_Promo2()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Promo3
                                          ON ObjectFloat_Promo3.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Promo3.DescId = zc_ObjectFloat_GoodsReportSale_Promo3()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Promo4
                                          ON ObjectFloat_Promo4.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Promo4.DescId = zc_ObjectFloat_GoodsReportSale_Promo4()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Promo5
                                          ON ObjectFloat_Promo5.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Promo5.DescId = zc_ObjectFloat_GoodsReportSale_Promo5()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Promo6
                                          ON ObjectFloat_Promo6.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Promo6.DescId = zc_ObjectFloat_GoodsReportSale_Promo6()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Promo7
                                          ON ObjectFloat_Promo7.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Promo7.DescId = zc_ObjectFloat_GoodsReportSale_Promo7()
                    -- 1.3 Перемещение на филиал
                    LEFT JOIN ObjectFloat AS ObjectFloat_Branch1
                                          ON ObjectFloat_Branch1.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Branch1.DescId = zc_ObjectFloat_GoodsReportSale_Branch1()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Branch2
                                          ON ObjectFloat_Branch2.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Branch2.DescId = zc_ObjectFloat_GoodsReportSale_Branch2()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Branch3
                                          ON ObjectFloat_Branch3.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Branch3.DescId = zc_ObjectFloat_GoodsReportSale_Branch3()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Branch4
                                          ON ObjectFloat_Branch4.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Branch4.DescId = zc_ObjectFloat_GoodsReportSale_Branch4()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Branch5
                                          ON ObjectFloat_Branch5.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Branch5.DescId = zc_ObjectFloat_GoodsReportSale_Branch5()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Branch6
                                          ON ObjectFloat_Branch6.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Branch6.DescId = zc_ObjectFloat_GoodsReportSale_Branch6()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Branch7
                                          ON ObjectFloat_Branch7.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Branch7.DescId = zc_ObjectFloat_GoodsReportSale_Branch7()
                    -- 2.1 Заявки
                    LEFT JOIN ObjectFloat AS ObjectFloat_Order1
                                          ON ObjectFloat_Order1.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Order1.DescId = zc_ObjectFloat_GoodsReportSale_Order1()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Order2
                                          ON ObjectFloat_Order2.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Order2.DescId = zc_ObjectFloat_GoodsReportSale_Order2()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Order3
                                          ON ObjectFloat_Order3.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Order3.DescId = zc_ObjectFloat_GoodsReportSale_Order3()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Order4
                                          ON ObjectFloat_Order4.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Order4.DescId = zc_ObjectFloat_GoodsReportSale_Order4()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Order5
                                          ON ObjectFloat_Order5.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Order5.DescId = zc_ObjectFloat_GoodsReportSale_Order5()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Order6
                                          ON ObjectFloat_Order6.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Order6.DescId = zc_ObjectFloat_GoodsReportSale_Order6()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Order7
                                          ON ObjectFloat_Order7.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_Order7.DescId = zc_ObjectFloat_GoodsReportSale_Order7()
                    -- 2.2 Заявки
                    LEFT JOIN ObjectFloat AS ObjectFloat_OrderPromo1
                                          ON ObjectFloat_OrderPromo1.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_OrderPromo1.DescId = zc_ObjectFloat_GoodsReportSale_OrderPromo1()
                    LEFT JOIN ObjectFloat AS ObjectFloat_OrderPromo2
                                          ON ObjectFloat_OrderPromo2.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_OrderPromo2.DescId = zc_ObjectFloat_GoodsReportSale_OrderPromo2()
                    LEFT JOIN ObjectFloat AS ObjectFloat_OrderPromo3
                                          ON ObjectFloat_OrderPromo3.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_OrderPromo3.DescId = zc_ObjectFloat_GoodsReportSale_OrderPromo3()
                    LEFT JOIN ObjectFloat AS ObjectFloat_OrderPromo4
                                          ON ObjectFloat_OrderPromo4.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_OrderPromo4.DescId = zc_ObjectFloat_GoodsReportSale_OrderPromo4()
                    LEFT JOIN ObjectFloat AS ObjectFloat_OrderPromo5
                                          ON ObjectFloat_OrderPromo5.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_OrderPromo5.DescId = zc_ObjectFloat_GoodsReportSale_OrderPromo5()
                    LEFT JOIN ObjectFloat AS ObjectFloat_OrderPromo6
                                          ON ObjectFloat_OrderPromo6.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_OrderPromo6.DescId = zc_ObjectFloat_GoodsReportSale_OrderPromo6()
                    LEFT JOIN ObjectFloat AS ObjectFloat_OrderPromo7
                                          ON ObjectFloat_OrderPromo7.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_OrderPromo7.DescId = zc_ObjectFloat_GoodsReportSale_OrderPromo7()
                    -- 2.3 Заявки
                    LEFT JOIN ObjectFloat AS ObjectFloat_OrderBranch1
                                          ON ObjectFloat_OrderBranch1.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_OrderBranch1.DescId = zc_ObjectFloat_GoodsReportSale_OrderBranch1()
                    LEFT JOIN ObjectFloat AS ObjectFloat_OrderBranch2
                                          ON ObjectFloat_OrderBranch2.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_OrderBranch2.DescId = zc_ObjectFloat_GoodsReportSale_OrderBranch2()
                    LEFT JOIN ObjectFloat AS ObjectFloat_OrderBranch3
                                          ON ObjectFloat_OrderBranch3.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_OrderBranch3.DescId = zc_ObjectFloat_GoodsReportSale_OrderBranch3()
                    LEFT JOIN ObjectFloat AS ObjectFloat_OrderBranch4
                                          ON ObjectFloat_OrderBranch4.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_OrderBranch4.DescId = zc_ObjectFloat_GoodsReportSale_OrderBranch4()
                    LEFT JOIN ObjectFloat AS ObjectFloat_OrderBranch5
                                          ON ObjectFloat_OrderBranch5.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_OrderBranch5.DescId = zc_ObjectFloat_GoodsReportSale_OrderBranch5()
                    LEFT JOIN ObjectFloat AS ObjectFloat_OrderBranch6
                                          ON ObjectFloat_OrderBranch6.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_OrderBranch6.DescId = zc_ObjectFloat_GoodsReportSale_OrderBranch6()
                    LEFT JOIN ObjectFloat AS ObjectFloat_OrderBranch7
                                          ON ObjectFloat_OrderBranch7.ObjectId = ObjectLink_Goods.ObjectId
                                         AND ObjectFloat_OrderBranch7.DescId = zc_ObjectFloat_GoodsReportSale_OrderBranch7()

               -- GROUP BY ObjectLink_Goods.ChildObjectId
               --        , ObjectLink_GoodsKind.ChildObjectId
              )

         , tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                          , MovementItem.ObjectId                         AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                          , COALESCE (MIFloat_ContainerId.ValueData, 0)   AS ContainerId
                     FROM MovementItem
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                          LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                      ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                     AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.DescId     = zc_MI_Master()
                       AND MovementItem.isErased   = FALSE
                    )
    -- Не упаковывать
  , tmpGoodsByGoodsKind_not AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId          AS GoodsId
                                     , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId      AS GoodsKindId
                                FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                     JOIN Object AS Object_GoodsByGoodsKind
                                                 ON Object_GoodsByGoodsKind.Id       = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                AND Object_GoodsByGoodsKind.isErased = FALSE
                                     JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                     ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                     JOIN ObjectBoolean AS ObjectBoolean_NotPack
                                                        ON ObjectBoolean_NotPack.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                       AND ObjectBoolean_NotPack.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_NotPack()
                                                       AND ObjectBoolean_NotPack.ValueData = TRUE
                                WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                  AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId <> zc_GoodsKind_Basis()
                                --AND 1=0
                               )
        -- Результат
        INSERT INTO tmpAll (MovementItemId, ContainerId, GoodsId, GoodsKindId, AmountForecastOrder, AmountForecastOrderPromo, AmountForecast, AmountForecastPromo
                          , Value1, Value2, Value3, Value4, Value5, Value6, Value7
                          , Promo1, Promo2, Promo3, Promo4, Promo5, Promo6, Promo7
                           )
          SELECT tmpMI.MovementItemId
               , tmpMI.ContainerId
               , tmpMI.GoodsId
               , tmpMI.GoodsKindId
               , tmpMI.AmountForecastOrder
               , tmpMI.AmountForecastOrderPromo
               , tmpMI.AmountForecast
               , tmpMI.AmountForecastPromo
               , tmpMI.Value1
               , tmpMI.Value2
               , tmpMI.Value3
               , tmpMI.Value4
               , tmpMI.Value5
               , tmpMI.Value6
               , tmpMI.Value7
               , tmpMI.Promo1
               , tmpMI.Promo2
               , tmpMI.Promo3
               , tmpMI.Promo4
               , tmpMI.Promo5
               , tmpMI.Promo6
               , tmpMI.Promo7

          FROM (SELECT tmpMI.MovementItemId                             AS MovementItemId
                     , COALESCE (tmpMI.ContainerId, 0)                  AS ContainerId
                     , COALESCE (tmpMI.GoodsId, tmpAll.GoodsId)         AS GoodsId
                     , COALESCE (tmpMI.GoodsKindId, tmpAll.GoodsKindId) AS GoodsKindId
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.AmountOrder, 0)      END AS AmountForecastOrder
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.AmountOrderPromo, 0) END AS AmountForecastOrderPromo
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.AmountSale, 0)       END AS AmountForecast
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.AmountSalePromo, 0)  END AS AmountForecastPromo
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.Value1, 0)           END AS Value1
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.Value2, 0)           END AS Value2
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.Value3, 0)           END AS Value3
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.Value4, 0)           END AS Value4
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.Value5, 0)           END AS Value5
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.Value6, 0)           END AS Value6
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.Value7, 0)           END AS Value7
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.Promo1, 0)           END AS Promo1
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.Promo2, 0)           END AS Promo2
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.Promo3, 0)           END AS Promo3
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.Promo4, 0)           END AS Promo4
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.Promo5, 0)           END AS Promo5
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.Promo6, 0)           END AS Promo6
                     , CASE WHEN tmpMI.ContainerId > 0 THEN 0 ELSE COALESCE (tmpAll.Promo7, 0)           END AS Promo7
                FROM (SELECT tmpMIAll.GoodsId
                           , tmpMIAll.GoodsKindId
                           , SUM (tmpMIAll.AmountOrder)      AS AmountOrder
                           , SUM (tmpMIAll.AmountOrderPromo) AS AmountOrderPromo
                           , SUM (tmpMIAll.AmountSale)       AS AmountSale
                           , SUM (tmpMIAll.AmountSalePromo)  AS AmountSalePromo
                             -- !!!Приоритет - по продаже!!!
                           /*, MAX (CASE WHEN tmpMIAll.AmountSale > 0 THEN tmpMIAll.Amount1 + tmpMIAll.Branch1 ELSE tmpMIAll.Order1 + tmpMIAll.OrderBranch1 END) AS Value1
                           , MAX (CASE WHEN tmpMIAll.AmountSale > 0 THEN tmpMIAll.Amount2 + tmpMIAll.Branch2 ELSE tmpMIAll.Order2 + tmpMIAll.OrderBranch2 END) AS Value2
                           , MAX (CASE WHEN tmpMIAll.AmountSale > 0 THEN tmpMIAll.Amount3 + tmpMIAll.Branch3 ELSE tmpMIAll.Order3 + tmpMIAll.OrderBranch3 END) AS Value3
                           , MAX (CASE WHEN tmpMIAll.AmountSale > 0 THEN tmpMIAll.Amount4 + tmpMIAll.Branch4 ELSE tmpMIAll.Order4 + tmpMIAll.OrderBranch4 END) AS Value4
                           , MAX (CASE WHEN tmpMIAll.AmountSale > 0 THEN tmpMIAll.Amount5 + tmpMIAll.Branch5 ELSE tmpMIAll.Order5 + tmpMIAll.OrderBranch5 END) AS Value5
                           , MAX (CASE WHEN tmpMIAll.AmountSale > 0 THEN tmpMIAll.Amount6 + tmpMIAll.Branch6 ELSE tmpMIAll.Order6 + tmpMIAll.OrderBranch6 END) AS Value6
                           , MAX (CASE WHEN tmpMIAll.AmountSale > 0 THEN tmpMIAll.Amount7 + tmpMIAll.Branch7 ELSE tmpMIAll.Order7 + tmpMIAll.OrderBranch7 END) AS Value7
                           */
                             -- !!!Приоритет - по Заявке!!!
                           , MAX (CASE WHEN tmpMIAll.AmountOrder = 0 THEN tmpMIAll.Amount1 + tmpMIAll.Branch1 ELSE tmpMIAll.Order1 + tmpMIAll.OrderBranch1 END) AS Value1
                           , MAX (CASE WHEN tmpMIAll.AmountOrder = 0 THEN tmpMIAll.Amount2 + tmpMIAll.Branch2 ELSE tmpMIAll.Order2 + tmpMIAll.OrderBranch2 END) AS Value2
                           , MAX (CASE WHEN tmpMIAll.AmountOrder = 0 THEN tmpMIAll.Amount3 + tmpMIAll.Branch3 ELSE tmpMIAll.Order3 + tmpMIAll.OrderBranch3 END) AS Value3
                           , MAX (CASE WHEN tmpMIAll.AmountOrder = 0 THEN tmpMIAll.Amount4 + tmpMIAll.Branch4 ELSE tmpMIAll.Order4 + tmpMIAll.OrderBranch4 END) AS Value4
                           , MAX (CASE WHEN tmpMIAll.AmountOrder = 0 THEN tmpMIAll.Amount5 + tmpMIAll.Branch5 ELSE tmpMIAll.Order5 + tmpMIAll.OrderBranch5 END) AS Value5
                           , MAX (CASE WHEN tmpMIAll.AmountOrder = 0 THEN tmpMIAll.Amount6 + tmpMIAll.Branch6 ELSE tmpMIAll.Order6 + tmpMIAll.OrderBranch6 END) AS Value6
                           , MAX (CASE WHEN tmpMIAll.AmountOrder = 0 THEN tmpMIAll.Amount7 + tmpMIAll.Branch7 ELSE tmpMIAll.Order7 + tmpMIAll.OrderBranch7 END) AS Value7
                             -- !!!акции - план на 1 неделю вперед!!!
                           , 0 AS Promo1
                           , 0 AS Promo2
                           , 0 AS Promo3
                           , 0 AS Promo4
                           , 0 AS Promo5
                           , 0 AS Promo6
                           , 0 AS Promo7
                      FROM tmpMIAll
                      GROUP BY tmpMIAll.GoodsId
                             , tmpMIAll.GoodsKindId
                      ) AS tmpAll
                      FULL JOIN tmpMI ON tmpMI.GoodsId     = tmpAll.GoodsId
                                     AND tmpMI.GoodsKindId = tmpAll.GoodsKindId
               ) AS tmpMI
            LEFT JOIN tmpGoodsByGoodsKind_not ON tmpGoodsByGoodsKind_not.GoodsId     = tmpMI.GoodsId
                                             AND tmpGoodsByGoodsKind_not.GoodsKindId = tmpMI.GoodsKindId
       WHERE tmpGoodsByGoodsKind_not.GoodsId IS NULL

      UNION ALL
       SELECT tmpMI.MovementItemId
            , tmpMI.ContainerId
            , tmpMI.GoodsId
            , tmpMI.GoodsKindId
            , 0 AS AmountForecastOrder
            , 0 AS AmountForecastOrderPromo
            , 0 AS AmountForecast
            , 0 AS AmountForecastPromo
            , 0 AS Value1
            , 0 AS Value2
            , 0 AS Value3
            , 0 AS Value4
            , 0 AS Value5
            , 0 AS Value6
            , 0 AS Value7
            , 0 AS Promo1
            , 0 AS Promo2
            , 0 AS Promo3
            , 0 AS Promo4
            , 0 AS Promo5
            , 0 AS Promo6
            , 0 AS Promo7
       FROM tmpMI
            INNER JOIN tmpGoodsByGoodsKind_not ON tmpGoodsByGoodsKind_not.GoodsId     = tmpMI.GoodsId
                                              AND tmpGoodsByGoodsKind_not.GoodsKindId = tmpMI.GoodsKindId
      ;



       -- сохранили
       PERFORM lpUpdate_MI_OrderInternal_Property (ioId                 := tmpAll.MovementItemId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := tmpAll.GoodsId
                                                 , inGoodsKindId        := tmpAll.GoodsKindId
                                                 , inAmount_Param       := tmpAll.AmountForecast -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_Param       := zc_MIFloat_AmountForecast()
                                                 , inAmount_ParamOrder  := tmpAll.AmountForecastPromo -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamOrder  := zc_MIFloat_AmountForecastPromo()
                                                 , inAmount_ParamSecond := tmpAll.AmountForecastOrder -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamSecond := zc_MIFloat_AmountForecastOrder()
                                                 , inAmount_ParamAdd    := tmpAll.AmountForecastOrderPromo -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamAdd    := zc_MIFloat_AmountForecastOrderPromo()
                                                 , inIsPack             := NULL
                                                 , inUserId             := vbUserId
                                                  )
       FROM tmpAll
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpAll.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpAll.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
      ;

       -- сохранили св-ва
       --  !!!здесь !!!сдвигаем!!! на НУЖНЫЙ день недели
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan1(), tmpMI.Id, CASE WHEN vbNumberStart = 1 THEN COALESCE (tmpAll.Value1, 0)
                                                                                WHEN vbNumberStart = 2 THEN COALESCE (tmpAll.Value2, 0)
                                                                                WHEN vbNumberStart = 3 THEN COALESCE (tmpAll.Value3, 0)
                                                                                WHEN vbNumberStart = 4 THEN COALESCE (tmpAll.Value4, 0)
                                                                                WHEN vbNumberStart = 5 THEN COALESCE (tmpAll.Value5, 0)
                                                                                WHEN vbNumberStart = 6 THEN COALESCE (tmpAll.Value6, 0)
                                                                                WHEN vbNumberStart = 7 THEN COALESCE (tmpAll.Value7, 0)
                                                                           END)
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan2(), tmpMI.Id, CASE WHEN vbNumberStart = 1 THEN COALESCE (tmpAll.Value2, 0)
                                                                                WHEN vbNumberStart = 2 THEN COALESCE (tmpAll.Value3, 0)
                                                                                WHEN vbNumberStart = 3 THEN COALESCE (tmpAll.Value4, 0)
                                                                                WHEN vbNumberStart = 4 THEN COALESCE (tmpAll.Value5, 0)
                                                                                WHEN vbNumberStart = 5 THEN COALESCE (tmpAll.Value6, 0)
                                                                                WHEN vbNumberStart = 6 THEN COALESCE (tmpAll.Value7, 0)
                                                                                WHEN vbNumberStart = 7 THEN COALESCE (tmpAll.Value1, 0)
                                                                           END)
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan3(), tmpMI.Id, CASE WHEN vbNumberStart = 1 THEN COALESCE (tmpAll.Value3, 0)
                                                                                WHEN vbNumberStart = 2 THEN COALESCE (tmpAll.Value4, 0)
                                                                                WHEN vbNumberStart = 3 THEN COALESCE (tmpAll.Value5, 0)
                                                                                WHEN vbNumberStart = 4 THEN COALESCE (tmpAll.Value6, 0)
                                                                                WHEN vbNumberStart = 5 THEN COALESCE (tmpAll.Value7, 0)
                                                                                WHEN vbNumberStart = 6 THEN COALESCE (tmpAll.Value1, 0)
                                                                                WHEN vbNumberStart = 7 THEN COALESCE (tmpAll.Value2, 0)
                                                                           END)
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan4(), tmpMI.Id, CASE WHEN vbNumberStart = 1 THEN COALESCE (tmpAll.Value4, 0)
                                                                                WHEN vbNumberStart = 2 THEN COALESCE (tmpAll.Value5, 0)
                                                                                WHEN vbNumberStart = 3 THEN COALESCE (tmpAll.Value6, 0)
                                                                                WHEN vbNumberStart = 4 THEN COALESCE (tmpAll.Value7, 0)
                                                                                WHEN vbNumberStart = 5 THEN COALESCE (tmpAll.Value1, 0)
                                                                                WHEN vbNumberStart = 6 THEN COALESCE (tmpAll.Value2, 0)
                                                                                WHEN vbNumberStart = 7 THEN COALESCE (tmpAll.Value3, 0)
                                                                           END)
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan5(), tmpMI.Id, CASE WHEN vbNumberStart = 1 THEN COALESCE (tmpAll.Value5, 0)
                                                                                WHEN vbNumberStart = 2 THEN COALESCE (tmpAll.Value6, 0)
                                                                                WHEN vbNumberStart = 3 THEN COALESCE (tmpAll.Value7, 0)
                                                                                WHEN vbNumberStart = 4 THEN COALESCE (tmpAll.Value1, 0)
                                                                                WHEN vbNumberStart = 5 THEN COALESCE (tmpAll.Value2, 0)
                                                                                WHEN vbNumberStart = 6 THEN COALESCE (tmpAll.Value3, 0)
                                                                                WHEN vbNumberStart = 7 THEN COALESCE (tmpAll.Value4, 0)
                                                                           END)
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan6(), tmpMI.Id, CASE WHEN vbNumberStart = 1 THEN COALESCE (tmpAll.Value6, 0)
                                                                                WHEN vbNumberStart = 2 THEN COALESCE (tmpAll.Value7, 0)
                                                                                WHEN vbNumberStart = 3 THEN COALESCE (tmpAll.Value1, 0)
                                                                                WHEN vbNumberStart = 4 THEN COALESCE (tmpAll.Value2, 0)
                                                                                WHEN vbNumberStart = 5 THEN COALESCE (tmpAll.Value3, 0)
                                                                                WHEN vbNumberStart = 6 THEN COALESCE (tmpAll.Value4, 0)
                                                                                WHEN vbNumberStart = 7 THEN COALESCE (tmpAll.Value5, 0)
                                                                           END)
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Plan7(), tmpMI.Id, CASE WHEN vbNumberStart = 1 THEN COALESCE (tmpAll.Value7, 0)
                                                                                WHEN vbNumberStart = 2 THEN COALESCE (tmpAll.Value1, 0)
                                                                                WHEN vbNumberStart = 3 THEN COALESCE (tmpAll.Value2, 0)
                                                                                WHEN vbNumberStart = 4 THEN COALESCE (tmpAll.Value3, 0)
                                                                                WHEN vbNumberStart = 5 THEN COALESCE (tmpAll.Value4, 0)
                                                                                WHEN vbNumberStart = 6 THEN COALESCE (tmpAll.Value5, 0)
                                                                                WHEN vbNumberStart = 7 THEN COALESCE (tmpAll.Value6, 0)
                                                                           END)
               -- Теперь Акции
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Promo1(), tmpMI.Id, CASE WHEN vbNumberStart = 1 THEN COALESCE (tmpAll.Promo1, 0)
                                                                                 WHEN vbNumberStart = 2 THEN COALESCE (tmpAll.Promo2, 0)
                                                                                 WHEN vbNumberStart = 3 THEN COALESCE (tmpAll.Promo3, 0)
                                                                                 WHEN vbNumberStart = 4 THEN COALESCE (tmpAll.Promo4, 0)
                                                                                 WHEN vbNumberStart = 5 THEN COALESCE (tmpAll.Promo5, 0)
                                                                                 WHEN vbNumberStart = 6 THEN COALESCE (tmpAll.Promo6, 0)
                                                                                 WHEN vbNumberStart = 7 THEN COALESCE (tmpAll.Promo7, 0)
                                                                            END)
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Promo2(), tmpMI.Id, CASE WHEN vbNumberStart = 1 THEN COALESCE (tmpAll.Promo2, 0)
                                                                                 WHEN vbNumberStart = 2 THEN COALESCE (tmpAll.Promo3, 0)
                                                                                 WHEN vbNumberStart = 3 THEN COALESCE (tmpAll.Promo4, 0)
                                                                                 WHEN vbNumberStart = 4 THEN COALESCE (tmpAll.Promo5, 0)
                                                                                 WHEN vbNumberStart = 5 THEN COALESCE (tmpAll.Promo6, 0)
                                                                                 WHEN vbNumberStart = 6 THEN COALESCE (tmpAll.Promo7, 0)
                                                                                 WHEN vbNumberStart = 7 THEN COALESCE (tmpAll.Promo1, 0)
                                                                            END)
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Promo3(), tmpMI.Id, CASE WHEN vbNumberStart = 1 THEN COALESCE (tmpAll.Promo3, 0)
                                                                                 WHEN vbNumberStart = 2 THEN COALESCE (tmpAll.Promo4, 0)
                                                                                 WHEN vbNumberStart = 3 THEN COALESCE (tmpAll.Promo5, 0)
                                                                                 WHEN vbNumberStart = 4 THEN COALESCE (tmpAll.Promo6, 0)
                                                                                 WHEN vbNumberStart = 5 THEN COALESCE (tmpAll.Promo7, 0)
                                                                                 WHEN vbNumberStart = 6 THEN COALESCE (tmpAll.Promo1, 0)
                                                                                 WHEN vbNumberStart = 7 THEN COALESCE (tmpAll.Promo2, 0)
                                                                            END)
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Promo4(), tmpMI.Id, CASE WHEN vbNumberStart = 1 THEN COALESCE (tmpAll.Promo4, 0)
                                                                                 WHEN vbNumberStart = 2 THEN COALESCE (tmpAll.Promo5, 0)
                                                                                 WHEN vbNumberStart = 3 THEN COALESCE (tmpAll.Promo6, 0)
                                                                                 WHEN vbNumberStart = 4 THEN COALESCE (tmpAll.Promo7, 0)
                                                                                 WHEN vbNumberStart = 5 THEN COALESCE (tmpAll.Promo1, 0)
                                                                                 WHEN vbNumberStart = 6 THEN COALESCE (tmpAll.Promo2, 0)
                                                                                 WHEN vbNumberStart = 7 THEN COALESCE (tmpAll.Promo3, 0)
                                                                            END)
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Promo5(), tmpMI.Id, CASE WHEN vbNumberStart = 1 THEN COALESCE (tmpAll.Promo5, 0)
                                                                                 WHEN vbNumberStart = 2 THEN COALESCE (tmpAll.Promo6, 0)
                                                                                 WHEN vbNumberStart = 3 THEN COALESCE (tmpAll.Promo7, 0)
                                                                                 WHEN vbNumberStart = 4 THEN COALESCE (tmpAll.Promo1, 0)
                                                                                 WHEN vbNumberStart = 5 THEN COALESCE (tmpAll.Promo2, 0)
                                                                                 WHEN vbNumberStart = 6 THEN COALESCE (tmpAll.Promo3, 0)
                                                                                 WHEN vbNumberStart = 7 THEN COALESCE (tmpAll.Promo4, 0)
                                                                            END)
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Promo6(), tmpMI.Id, CASE WHEN vbNumberStart = 1 THEN COALESCE (tmpAll.Promo6, 0)
                                                                                 WHEN vbNumberStart = 2 THEN COALESCE (tmpAll.Promo7, 0)
                                                                                 WHEN vbNumberStart = 3 THEN COALESCE (tmpAll.Promo1, 0)
                                                                                 WHEN vbNumberStart = 4 THEN COALESCE (tmpAll.Promo2, 0)
                                                                                 WHEN vbNumberStart = 5 THEN COALESCE (tmpAll.Promo3, 0)
                                                                                 WHEN vbNumberStart = 6 THEN COALESCE (tmpAll.Promo4, 0)
                                                                                 WHEN vbNumberStart = 7 THEN COALESCE (tmpAll.Promo5, 0)
                                                                            END)
             , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Promo7(), tmpMI.Id, CASE WHEN vbNumberStart = 1 THEN COALESCE (tmpAll.Promo7, 0)
                                                                                 WHEN vbNumberStart = 2 THEN COALESCE (tmpAll.Promo1, 0)
                                                                                 WHEN vbNumberStart = 3 THEN COALESCE (tmpAll.Promo2, 0)
                                                                                 WHEN vbNumberStart = 4 THEN COALESCE (tmpAll.Promo3, 0)
                                                                                 WHEN vbNumberStart = 5 THEN COALESCE (tmpAll.Promo4, 0)
                                                                                 WHEN vbNumberStart = 6 THEN COALESCE (tmpAll.Promo5, 0)
                                                                                 WHEN vbNumberStart = 7 THEN COALESCE (tmpAll.Promo6, 0)
                                                                            END)
       FROM (SELECT MovementItem.Id                               AS Id
                  , MovementItem.ObjectId                         AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , COALESCE (MIFloat_ContainerId.ValueData, 0)   AS ContainerId
             FROM MovementItem
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                  LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                              ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                             AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE
            ) AS tmpMI
            LEFT JOIN tmpAll ON tmpAll.GoodsId     = tmpMI.GoodsId
                            AND tmpAll.GoodsKindId = tmpMI.GoodsKindId
                            AND tmpAll.ContainerId = 0
                            AND tmpMI.ContainerId  = 0
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.06.15                                        * расчет, временно захардкодил
 19.06.15                                        * all
 03.03.15         *
*/

-- тест
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountForecastPromo (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
