-- Function: gpUpdateMI_OrderInternal_AmountForecast()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountForecast (Integer, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountForecast(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inStartDate           TDateTime , -- Дата документа
    IN inEndDate             TDateTime , -- Дата документа
    IN inFromId              Integer   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;

   DECLARE vbIsPack     Boolean;
   DECLARE vbIsBasis    Boolean;
   DECLARE vbIsTushenka Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());


    -- расчет, временно захардкодил - To = Цех Упаковки
    vbIsPack:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_To() AND MovementId = inMovementId AND ObjectId = 8451); -- Цех Упаковки
    -- расчет, временно захардкодил - From = ЦЕХ колбаса+дел-сы + ЦЕХ Тушенка
    vbIsBasis:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_From() AND MovementId = inMovementId AND (ObjectId IN (SELECT tmp.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS tmp) OR ObjectId = 2790412) ); -- ЦЕХ колбаса+дел-сы + ЦЕХ Тушенка
     -- расчет, временно захардкодил - To = ЦЕХ Тушенка
    vbIsTushenka:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_To() AND MovementId = inMovementId AND ObjectId = 2790412); -- ЦЕХ Тушенка



    -- !!!НАШЛИ!!!
    SELECT gpGet.StartDate, gpGet.EndDate
           INTO inStartDate, inEndDate
    FROM gpGet_Object_GoodsReportSaleInf (inSession) AS gpGet;

    -- сохранили свойство <Дата проноз с>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), inMovementId, inStartDate);
    -- сохранили свойство <Дата проноз по>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), inMovementId, inEndDate);


     -- таблица -
     CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountForecastOrder TFloat, AmountForecast TFloat, AmountOrderPromo TFloat, AmountSalePromo TFloat, AmountProductionOut TFloat) ON COMMIT DROP;

     --
                                 WITH tmpUnit AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup)
                                    , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                                                        , CASE WHEN Object_InfoMoney_View.InfoMoneyId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                                        , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                        , zc_Enum_InfoMoney_30102() -- Тушенка
                                                                                                        , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                         )
                                                                    THEN TRUE
                                                               ELSE FALSE
                                                          END AS isGoodsKind
                                                   FROM Object_InfoMoney_View
                                                        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                             ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                   WHERE ((Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30101()            -- Доходы + Продукция + Готовая продукция
                                                        OR Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30102()            -- Доходы + Продукция + Тушенка
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье : запечена...
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                          )
                                                         AND vbIsPack = FALSE AND vbIsBasis = FALSE AND vbIsTushenka = FALSE)

                                                      OR ((Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30102() -- Доходы + Продукция + Тушенка
                                                          )
                                                         AND vbIsPack = FALSE AND vbIsBasis = FALSE AND vbIsTushenka = TRUE)

                                                      OR ((Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30101()            -- Доходы + Продукция + Готовая продукция
                                                        OR Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30201()            -- Доходы + Мясное сырье + Мясное сырье
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                          )
                                                         AND vbIsPack = TRUE AND vbIsBasis = FALSE)

                                                      OR ((Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_10000() -- Основное сырье
                                                        -- OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21300() -- Незавершенное производство
                                                          )
                                                         AND vbIsPack = FALSE AND vbIsBasis = TRUE)
                                                     )
                                    , tmpMIAll AS
                                      (SELECT ObjectLink_Goods.ChildObjectId                                           AS GoodsId
                                            , CASE WHEN tmpGoods.isGoodsKind = TRUE AND COALESCE (ObjectLink_GoodsKind.ChildObjectId, 0) = 0
                                                        THEN zc_GoodsKind_Basis()
                                                   ELSE COALESCE (ObjectLink_GoodsKind.ChildObjectId, 0)
                                              END AS GoodsKindId

                                            , SUM (COALESCE (ObjectFloat_Order1.ValueData, 0)
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

                                                 + COALESCE (ObjectFloat_OrderBranch1.ValueData, 0)
                                                 + COALESCE (ObjectFloat_OrderBranch2.ValueData, 0)
                                                 + COALESCE (ObjectFloat_OrderBranch3.ValueData, 0)
                                                 + COALESCE (ObjectFloat_OrderBranch4.ValueData, 0)
                                                 + COALESCE (ObjectFloat_OrderBranch5.ValueData, 0)
                                                 + COALESCE (ObjectFloat_OrderBranch6.ValueData, 0)
                                                 + COALESCE (ObjectFloat_OrderBranch7.ValueData, 0)
                                                   ) AS AmountOrder

                                            , SUM (COALESCE (ObjectFloat_Amount1.ValueData, 0)
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

                                                 + COALESCE (ObjectFloat_Branch1.ValueData, 0)
                                                 + COALESCE (ObjectFloat_Branch2.ValueData, 0)
                                                 + COALESCE (ObjectFloat_Branch3.ValueData, 0)
                                                 + COALESCE (ObjectFloat_Branch4.ValueData, 0)
                                                 + COALESCE (ObjectFloat_Branch5.ValueData, 0)
                                                 + COALESCE (ObjectFloat_Branch6.ValueData, 0)
                                                 + COALESCE (ObjectFloat_Branch7.ValueData, 0)
                                                   ) AS AmountSale

                                            , SUM (COALESCE (ObjectFloat_OrderPromo1.ValueData, 0)
                                                 + COALESCE (ObjectFloat_OrderPromo2.ValueData, 0)
                                                 + COALESCE (ObjectFloat_OrderPromo3.ValueData, 0)
                                                 + COALESCE (ObjectFloat_OrderPromo4.ValueData, 0)
                                                 + COALESCE (ObjectFloat_OrderPromo5.ValueData, 0)
                                                 + COALESCE (ObjectFloat_OrderPromo6.ValueData, 0)
                                                 + COALESCE (ObjectFloat_OrderPromo7.ValueData, 0)
                                                  ) AS AmountOrderPromo
                                            , SUM (COALESCE (ObjectFloat_Promo1.ValueData, 0)
                                                 + COALESCE (ObjectFloat_Promo2.ValueData, 0)
                                                 + COALESCE (ObjectFloat_Promo3.ValueData, 0)
                                                 + COALESCE (ObjectFloat_Promo4.ValueData, 0)
                                                 + COALESCE (ObjectFloat_Promo5.ValueData, 0)
                                                 + COALESCE (ObjectFloat_Promo6.ValueData, 0)
                                                 + COALESCE (ObjectFloat_Promo7.ValueData, 0)
                                                  ) AS AmountSalePromo
                                            , 0 AS AmountProductionOut

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

                                       GROUP BY ObjectLink_Goods.ChildObjectId
                                              , CASE WHEN tmpGoods.isGoodsKind = TRUE AND COALESCE (ObjectLink_GoodsKind.ChildObjectId, 0) = 0
                                                          THEN zc_GoodsKind_Basis()
                                                     ELSE COALESCE (ObjectLink_GoodsKind.ChildObjectId, 0)
                                                END

                                       /*-- 1.1 Заявки
                                        SELECT MovementItem.ObjectId                                                    AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                            AS GoodsKindId
                                            , SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS AmountOrder
                                            , 0                                                                        AS AmountSale
                                       FROM Movement
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId
                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE
                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                                            AND tmpGoods.isGoodsKind = TRUE
                                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                         AND Movement.DescId = zc_Movement_OrderExternal()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                         AND vbIsBasis = FALSE
                                       GROUP BY MovementItem.ObjectId
                                              , MILinkObject_GoodsKind.ObjectId
                                       HAVING SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) <> 0
                                      UNION ALL
                                       -- 1.2 Продажи
                                       SELECT MovementItem.ObjectId                               AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                                            , 0                                                   AS AmountOrder
                                            , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountSale
                                       -- FROM MovementDate AS MovementDate_OperDatePartner
                                       FROM Movement
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                          ON MovementLinkObject_From.MovementId = Movement.Id -- MovementDate_OperDatePartner.MovementId
                                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_From.ObjectId
                                            --INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                            --                   AND Movement.DescId = zc_Movement_Sale()
                                            --                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE
                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                                            AND tmpGoods.isGoodsKind = TRUE
                                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                         AND Movement.DescId   = zc_Movement_Sale()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                       -- WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                                       --   AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                         AND vbIsBasis = FALSE
                                       GROUP BY MovementItem.ObjectId
                                              , MILinkObject_GoodsKind.ObjectId
                                       HAVING SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) <> 0
                                      UNION ALL
                                       -- 1.3 Перемещение на филиал
                                       SELECT MovementItem.ObjectId                               AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                                            , 0                                                   AS AmountOrder
                                            , SUM (COALESCE (MovementItem.Amount, 0))             AS AmountSale
                                       FROM Movement
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_From.ObjectId

                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE
                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                                            AND tmpGoods.isGoodsKind = TRUE
                                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                         AND Movement.DescId   = zc_Movement_SendOnPrice()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                         AND vbIsBasis = FALSE
                                       GROUP BY MovementItem.ObjectId
                                              , MILinkObject_GoodsKind.ObjectId
                                       HAVING SUM (COALESCE (MovementItem.Amount, 0)) <> 0*/

                                      UNION ALL
                                       -- 2. !!!!ПРОИЗВОДСТВО!!!
                                       SELECT MovementItem.ObjectId                               AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                                            , 0                                                   AS AmountOrder
                                            , SUM (COALESCE (MovementItem.Amount, 0))             AS AmountSale
                                            , 0                                                   AS AmountOrderPromo
                                            , 0                                                   AS AmountSalePromo
                                            , SUM (COALESCE (MovementItem.Amount, 0))             AS AmountProductionOut

                                       FROM Movement
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_From.ObjectId

                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                         AND MovementLinkObject_To.ObjectId = MovementLinkObject_From.ObjectId

                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Child()
                                                                   AND MovementItem.isErased   = FALSE
                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                         AND Movement.DescId = zc_Movement_ProductionUnion()
                                         AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                         AND vbIsBasis = TRUE
                                       GROUP BY MovementItem.ObjectId
                                              , MILinkObject_GoodsKind.ObjectId
                                       HAVING SUM (COALESCE (MovementItem.Amount, 0)) <> 0
                                      )


                               , tmpMI AS
                                      (SELECT MAX (MovementItem.Id)                         AS MovementItemId
                                            , MovementItem.ObjectId                         AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                       FROM MovementItem
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                       WHERE MovementItem.MovementId = inMovementId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE
                                       GROUP BY MovementItem.ObjectId
                                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                      )
       INSERT INTO tmpAll (MovementItemId, GoodsId, GoodsKindId, AmountForecastOrder, AmountForecast
                         , AmountOrderPromo, AmountSalePromo, AmountProductionOut
                          )
         SELECT tmpMI.MovementItemId
               , COALESCE (tmpMI.GoodsId,tmpAll.GoodsId)          AS GoodsId
               , COALESCE (tmpMI.GoodsKindId, tmpAll.GoodsKindId) AS GoodsKindId
               , COALESCE (tmpAll.AmountOrder, 0)                 AS AmountForecastOrder
               , COALESCE (tmpAll.AmountSale, 0)                  AS AmountForecast
               , COALESCE (tmpAll.AmountOrderPromo)               AS AmountOrderPromo
               , COALESCE (tmpAll.AmountSalePromo)                AS AmountSalePromo
               , COALESCE (tmpAll.AmountProductionOut)            AS AmountProductionOut
         FROM (SELECT tmpMIAll.GoodsId
                    , tmpMIAll.GoodsKindId
                    , SUM (tmpMIAll.AmountOrder)         AS AmountOrder
                    , SUM (tmpMIAll.AmountSale)          AS AmountSale
                    , SUM (tmpMIAll.AmountOrderPromo)    AS AmountOrderPromo
                    , SUM (tmpMIAll.AmountSalePromo)     AS AmountSalePromo
                    , SUM (tmpMIAll.AmountProductionOut) AS AmountProductionOut
               FROM tmpMIAll
               GROUP BY tmpMIAll.GoodsId
                      , tmpMIAll.GoodsKindId
              ) AS tmpAll
              FULL JOIN tmpMI ON tmpMI.GoodsId     = tmpAll.GoodsId
                             AND tmpMI.GoodsKindId = tmpAll.GoodsKindId
             ;

       -- сохранили
       PERFORM lpUpdate_MI_OrderInternal_Property (ioId                    := tmpAll.MovementItemId
                                                 , inMovementId            := inMovementId
                                                 , inGoodsId               := tmpAll.GoodsId
                                                 , inGoodsKindId           := tmpAll.GoodsKindId
                                                 , inAmount_Param          := tmpAll.AmountForecast * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_Param          := zc_MIFloat_AmountForecast()
                                                 , inAmount_ParamOrder     := CASE WHEN vbIsBasis = FALSE
                                                                                        THEN tmpAll.AmountForecastOrder * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                                                   ELSE NULL
                                                                              END
                                                 , inDescId_ParamOrder     := CASE WHEN vbIsBasis = FALSE
                                                                                        THEN zc_MIFloat_AmountForecastOrder()
                                                                                   ELSE NULL
                                                                              END
                                                 , inAmount_ParamSecond    := NULL
                                                 , inDescId_ParamSecond    := NULL
                                                   -- !!!не ошибка, здесь добавленный Расход на производство в статистику Продаж!!!
                                                 , inAmount_ParamAdd       := COALESCE (tmpAll.AmountProductionOut, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamAdd       := zc_MIFloat_Plan1()
                                                   -- !!!не ошибка, здесь заявки  Акции!!!
                                                 , inAmount_ParamNext      := COALESCE (tmpAll.AmountOrderPromo, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamNext      := zc_MIFloat_Promo1()
                                                   -- !!!не ошибка, здесь продажи Акции!!!
                                                 , inAmount_ParamNextPromo := COALESCE (tmpAll.AmountSalePromo, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamNextPromo := zc_MIFloat_Promo2()
                                                   --
                                                 , inIsPack                := CASE WHEN vbIsBasis = FALSE THEN vbIsPack ELSE NULL  END
                                                 , inIsParentMulti         := CASE WHEN vbIsBasis = FALSE THEN TRUE     ELSE FALSE END
                                                 , inUserId                := vbUserId
                                                  )
       FROM tmpAll
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpAll.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpAll.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
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
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountForecast (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
