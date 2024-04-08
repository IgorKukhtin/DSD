-- FunctiON: Report_Goods_byMovementReal ()

DROP FUNCTION IF EXISTS gpReport_Goods_byMovementReal (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods_byMovementReal (
    IN inStartDate           TDateTime ,
    IN inEndDate             TDateTime ,
    IN inUnitId              Integer   , --
    IN inUnitGroupId         Integer   ,
    IN inGoodsGroupGPId      Integer   ,
    IN inGoodsGroupId        Integer   ,
    IN inWeek                Boolean   , -- график по неделям
    IN inMonth               Boolean   , -- график по месяцам
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;
    DECLARE vbCountDays TFloat;

    DECLARE vbIsCost Boolean;

    DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
 
     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoods')
     THEN
         DELETE FROM _tmpGoods;
         DELETE FROM _tmpUnit;
     ELSE
         -- таблица -
         CREATE TEMP TABLE _tmpGoods (GroupNum Integer, GoodsId Integer, MeasureId Integer, Weight TFloat, GoodsPlatformId Integer, TradeMarkId Integer, GoodsTagId Integer) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpData (OperDate TDateTime
                                   , GroupNum Integer, GoodsId Integer, SaleAmount TFloat, SaleAmountPartner TFloat, ReturnAmount TFloat, ReturnAmountPartner TFloat
                                                                      , SaleAmountDay TFloat, SaleAmountPartnerDay TFloat, ReturnAmountDay TFloat, ReturnAmountPartnerDay TFloat
                                                                      , SaleAmountSh TFloat, SaleAmountPartnerSh TFloat, ReturnAmountSh TFloat, ReturnAmountPartnerSh TFloat
                                                                      , SaleAmountDaySh TFloat, SaleAmountPartnerDaySh TFloat, ReturnAmountDaySh TFloat, ReturnAmountPartnerDaySh TFloat
                                                                      , OrderAmount TFloat, MoreAmount TFloat, UnderAmount TFloat, DiffAmount TFloat
                                                                      , OrderAmountSh TFloat, MoreAmountSh TFloat, UnderAmountSh TFloat, DiffAmountSh TFloat
                                                                      , GoodsPlatformId Integer, TradeMarkId Integer, GoodsTagId Integer
                                   , ColorRecord_TradeMark Integer, ColorRecord_GoodsTag Integer) ON COMMIT DROP;

     END IF;

     vbCountDays := (SELECT EXTRACT (DAY  FROM (inEndDate - inStartDate)) +1 )   ::TFloat ;

     IF COALESCE (inUnitGroupId,0) <> 0
     THEN
         INSERT INTO _tmpUnit (UnitId)
           SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect
          UNION
           SELECT inUnitId
          ;
     ELSE
         INSERT INTO _tmpUnit (UnitId)
           SELECT Object.Id
           FROM Object
                INNER JOIN ObjectLink AS OL_Unit_Branch ON OL_Unit_Branch.ObjectId = Object.Id AND OL_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch() AND OL_Unit_Branch.ChildObjectId > 0
           WHERE Object.DescId = zc_Object_Unit()
          UNION
           SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8460) AS lfSelect
          UNION
           SELECT Object.Id
           FROM Object
           WHERE Object.Id     = 8459
             AND Object.DescId = zc_Object_Unit()
          ;
     END IF;


    -- Ограничения по товару
    IF inGoodsGroupGPId <> 0
    THEN
        INSERT INTO _tmpGoods (GroupNum, GoodsId, MeasureId, Weight, GoodsPlatformId, TradeMarkId, GoodsTagId)
          WITH tmpGoods AS(
           SELECT 1 AS GroupNum, lfSelect.GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupGPId) AS lfSelect
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
          UNION
           SELECT 2, lfSelect.GoodsId, ObjectLink_Goods_Measure.ChildObjectId AS MeasureId, ObjectFloat_Weight.ValueData AS Weight
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = lfSelect.GoodsId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = lfSelect.GoodsId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                           )
               SELECT tmpGoods.GroupNum
                    , tmpGoods.GoodsId
                    , tmpGoods.MeasureId
                    , tmpGoods.Weight
                    , ObjectLink_Goods_GoodsPlatform.ChildObjectId AS GoodsPlatformName
                    , ObjectLink_Goods_TradeMark.ChildObjectId     AS TradeMarkId
                    , ObjectLink_Goods_GoodsTag.ChildObjectId      AS GoodsTagId
               FROM tmpGoods
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                         ON ObjectLink_Goods_GoodsPlatform.ObjectId = tmpGoods.GoodsId
                                        AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                         ON ObjectLink_Goods_TradeMark.ObjectId = tmpGoods.GoodsId
                                        AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                         ON ObjectLink_Goods_GoodsTag.ObjectId = tmpGoods.GoodsId
                                        AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                    ;
    END IF;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpGoods;
    ANALYZE _tmpUnit;


    WITH -- Документы - что считаем "продажей"
         tmpMovSale AS (SELECT Movement.DescId                            AS MovementDescId
                             , Movement.Id                                AS MovementId
                             , MovementDate_OperDatePartner.ValueData     AS OperDate
                             , MovementLinkMovement_Order.MovementChildId AS MovementId_Order
                        FROM MovementDate AS MovementDate_OperDatePartner
                             INNER JOIN Movement ON Movement.Id       = MovementDate_OperDatePartner.MovementId
                                                AND Movement.DescId   = zc_Movement_Sale()
                                                AND Movement.StatusId = zc_Enum_Status_Complete()
                             INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                                          AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                             INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MovementLinkObject_From.ObjectId
                             -- связь с заявкой от покупателя
                             LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                    ON MovementLinkMovement_Order.MovementId = Movement.Id       --5078302 --
                                   AND MovementLinkMovement_Order.DescId     = zc_MovementLinkMovement_Order()

                        WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                          AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                       )
        -- Документы - что считаем "возвратом"
      , tmpMovRet AS (SELECT Movement.DescId                       AS MovementDescId
                           , Movement.Id                           AS MovementId
                           , MovementDate_OperDatePartner.ValueData AS OperDate
                      FROM MovementDate AS MovementDate_OperDatePartner
                           INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                              AND Movement.DescId = zc_Movement_ReturnIn()
                                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                                        AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                           INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MovementLinkObject_To.ObjectId   -- ограничили складами возврата

                      WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                        AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                     )

        -- Элементы - что считаем "продажей"
      , tmpMI_Sale_byOrder AS (SELECT tmpMovSale.OperDate
                                    , tmpMovSale.MovementId
                                    , tmpMovSale.MovementId_Order
                                    , MovementItem.ObjectId AS GoodsId

                                 -- , SUM (COALESCE (MIFloat_AmountChangePercent.ValueData, 0))  AS Amount
                                    , SUM (COALESCE (MovementItem.Amount, 0))                    AS Amount
                                    , SUM (COALESCE (MIFloat_AmountPartner.ValueData,0))         AS AmountPartner

                               FROM tmpMovSale
                                    INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovSale.MovementId
                                           AND MovementItem.DescId     = zc_MI_Master()
                                           AND MovementItem.isErased   = FALSE
                                    INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId

                                    LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                                                ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                                               AND MIFloat_AmountChangePercent.DescId         = zc_MIFloat_AmountChangePercent()
                                    LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                                ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                               AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                               GROUP BY tmpMovSale.OperDate
                                      , tmpMovSale.MovementId
                                      , MovementItem.ObjectId
                                      , tmpMovSale.MovementId_Order
                       )

      , tmpMI_Sale AS (SELECT tmpMI_Sale_byOrder.GoodsId
                            , tmpMI_Sale_byOrder.OperDate
                            , SUM (COALESCE (tmpMI_Sale_byOrder.Amount, 0))       AS Amount
                            , SUM (COALESCE (tmpMI_Sale_byOrder.AmountPartner,0)) AS AmountPartner

                            , SUM (CASE WHEN tmpMI_Sale_byOrder.OperDate = inEndDate THEN COALESCE (tmpMI_Sale_byOrder.Amount, 0) ELSE 0 END)        AS DayAmount
                            , SUM (CASE WHEN tmpMI_Sale_byOrder.OperDate = inEndDate THEN COALESCE (tmpMI_Sale_byOrder.AmountPartner, 0) ELSE 0 END) AS DayAmountPartner
                       FROM tmpMI_Sale_byOrder
                       GROUP BY tmpMI_Sale_byOrder.GoodsId, tmpMI_Sale_byOrder.OperDate
                       )
        -- Элементы - что считаем "возвратом"
      , tmpMI_Ret AS (SELECT MovementItem.ObjectId AS GoodsId
                           , tmp.OperDate
                           , SUM (COALESCE (CASE WHEN tmp.MovementDescId = zc_Movement_SendOnPrice() THEN MIFloat_AmountPartner.ValueData ELSE MovementItem.Amount END, 0))  AS Amount
                           , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner

                           , SUM (CASE WHEN tmp.OperDate = inEndDate THEN COALESCE (CASE WHEN tmp.MovementDescId = zc_Movement_SendOnPrice() THEN MIFloat_AmountPartner.ValueData ELSE MovementItem.Amount END, 0) ELSE 0 END)  AS DayAmount
                           , SUM (CASE WHEN tmp.OperDate = inEndDate THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS DayAmountPartner
                      FROM tmpMovRet AS tmp
                           INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                           INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId

                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                       ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                      GROUP BY MovementItem.ObjectId, tmp.OperDate
                      )
      , tmpMI_OrderAll AS (SELECT Movement.Id
                                -- , MovementDate_OperDatePartner.ValueData  AS OperDatePartner
                                -- , (MovementDate_OperDatePartner.ValueData + (COALESCE (ObjectFloat_DocumentDayCount.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime AS OperDatePartner
                                , tmpMovement.OperDate                    AS OperDatePartner
                                , MovementItem.ObjectId                   AS GoodsId
                                , SUM (MovementItem.Amount)               AS Amount
                                , SUM((MIFloat_AmountSecond.ValueData ))  AS Amount_Dozakaz
                           FROM (SELECT tmpMovSale.MovementId_Order, MAX (tmpMovSale.OperDate) AS OperDate FROM tmpMovSale GROUP BY tmpMovSale.MovementId_Order
                                ) AS tmpMovement
                                INNER JOIN Movement ON Movement.Id = tmpMovement.MovementId_Order
                                                   AND Movement.DescId = zc_Movement_OrderExternal()
                                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                /*INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                                             AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()*/
                                                          -- AND MovementLinkObject_To.ObjectId   = inUnitId --8459

                                /*INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                        ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                                       AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()*/
                                                   -- AND MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate

                                /*LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount ON ObjectFloat_DocumentDayCount.ObjectId = MovementLinkObject_From.ObjectId AND ObjectFloat_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()*/

                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                                INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                                LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                            ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                           -- WHERE Movement.DescId = zc_Movement_OrderExternal()
                           --   AND Movement.StatusId = zc_Enum_Status_Complete()
                           GROUP BY MovementItem.ObjectId
                                  -- , MovementDate_OperDatePartner.ValueData
                                  , Movement.Id
                                  -- , ObjectFloat_DocumentDayCount.ValueData
                                  , tmpMovement.OperDate
                          )
        -- кол-во в заявках и отклонения от продаж
        , tmpMI_Order AS (SELECT tmpMI_OrderAll.OperDatePartner AS OperDate
                               , tmpMI_OrderAll.GoodsId
                               , SUM (tmpMI_OrderAll.Amount) AS Amount
                               , SUM (CASE WHEN COALESCE (tmpMI_Sale_byOrder.Amount,0) > tmpMI_OrderAll.Amount THEN (COALESCE (tmpMI_Sale_byOrder.Amount,0) - tmpMI_OrderAll.Amount) ELSE 0 END) AS Amount_More  -- сверх заказа
                               , SUM (CASE WHEN COALESCE (tmpMI_Sale_byOrder.Amount,0) < tmpMI_OrderAll.Amount THEN (tmpMI_OrderAll.Amount - COALESCE (tmpMI_Sale_byOrder.Amount,0)) ELSE 0 END) AS Amount_Under -- меньше заказа
                              -- , SUM (COALESCE (tmpMI_Sale_byOrder.Amount,0) - tmpMI_OrderAll.Amount)                                                                                            AS Amount_Diff
                               , 0 AS Amount_Diff
                          FROM tmpMI_OrderAll
                               LEFT JOIN tmpMI_Sale_byOrder ON tmpMI_Sale_byOrder.MovementId_Order = tmpMI_OrderAll.Id
                                                           AND tmpMI_Sale_byOrder.GoodsId = tmpMI_OrderAll.GoodsId
                          GROUP BY tmpMI_OrderAll.OperDatePartner
                                 , tmpMI_OrderAll.GoodsId
                          )

          -- Элементы - что считаем "возвратом"
        , tmpData  AS (SELECT tmp.GoodsId
                            , tmp.OperDate
                            , SUM (tmp.SaleAmount)           AS SaleAmount
                            , SUM (tmp.SaleAmountPartner)    AS SaleAmountPartner
                            , SUM (tmp.ReturnAmount)         AS ReturnAmount
                            , SUM (tmp.ReturnAmountPartner)  AS ReturnAmountPartner

                            , SUM (tmp.SaleAmountDay)           AS SaleAmountDay
                            , SUM (tmp.SaleAmountPartnerDay)    AS SaleAmountPartnerDay
                            , SUM (tmp.ReturnAmountDay)         AS ReturnAmountDay
                            , SUM (tmp.ReturnAmountPartnerDay)  AS ReturnAmountPartnerDay

                            , SUM (tmp.Amount_Order)            AS Amount_Order
                            , SUM (tmp.Amount_More)             AS Amount_More
                            , SUM (tmp.Amount_Under)            AS Amount_Under
                            , SUM (tmp.SaleAmount - tmp.Amount_Order) AS Amount_Diff

                       FROM (SELECT tmp.GoodsId
                                  , tmp.OperDate
                                  , tmp.Amount              AS SaleAmount
                                  , tmp.AmountPartner       AS SaleAmountPartner
                                  , tmp.DayAmount           AS SaleAmountDay
                                  , tmp.DayAmountPartner    AS SaleAmountPartnerDay
                                  , 0 AS ReturnAmount
                                  , 0 AS ReturnAmountPartner
                                  , 0 AS ReturnAmountDay
                                  , 0 AS ReturnAmountPartnerDay
                                  , 0 AS Amount_Order
                                  , 0 AS Amount_More
                                  , 0 AS Amount_Under
                                  , 0 AS Amount_Diff
                             FROM tmpMI_Sale AS tmp
                           UNION
                             SELECT tmp.GoodsId
                                  , tmp.OperDate
                                  , 0 AS SaleAmount
                                  , 0 AS SaleAmountPartner
                                  , 0 AS SaleAmountDay
                                  , 0 AS SaleAmountPartnerDay
                                  , tmp.Amount           AS ReturnAmount
                                  , tmp.AmountPartner    AS ReturnAmountPartner
                                  , tmp.DayAmount        AS ReturnAmountDay
                                  , tmp.DayAmountPartner AS ReturnAmountPartnerDay
                                  , 0 AS Amount_Order
                                  , 0 AS Amount_More
                                  , 0 AS Amount_Under
                                  , 0 AS Amount_Diff
                             FROM tmpMI_Ret AS tmp
                           UNION
                             SELECT tmp.GoodsId
                                  , tmp.OperDate
                                  , 0 AS SaleAmount
                                  , 0 AS SaleAmountPartner
                                  , 0 AS SaleAmountDay
                                  , 0 AS SaleAmountPartnerDay
                                  , 0 AS ReturnAmount
                                  , 0 AS ReturnAmountPartner
                                  , 0 AS ReturnAmountDay
                                  , 0 AS ReturnAmountPartnerDay
                                  , tmp.Amount
                                  , tmp.Amount_More
                                  , tmp.Amount_Under
                                  , tmp.Amount_Diff
                             FROM tmpMI_Order AS tmp
                             ) AS tmp
                       GROUP BY tmp.GoodsId, tmp.OperDate
                      )
          -- Результат
          INSERT INTO _tmpData (OperDate
                               ,GroupNum, GoodsPlatformId, TradeMarkId, GoodsTagId, GoodsId, SaleAmount,      SaleAmountPartner,      ReturnAmount,      ReturnAmountPartner
                                                                                           , SaleAmountDay,   SaleAmountPartnerDay,   ReturnAmountDay,   ReturnAmountPartnerDay
                                                                                           , SaleAmountSh,    SaleAmountPartnerSh,    ReturnAmountSh,    ReturnAmountPartnerSh
                                                                                           , SaleAmountDaySh, SaleAmountPartnerDaySh, ReturnAmountDaySh, ReturnAmountPartnerDaySh
                                                                                           , OrderAmount,     MoreAmount,             UnderAmount,       DiffAmount
                                                                                           , OrderAmountSh,   MoreAmountSh,           UnderAmountSh,     DiffAmountSh
                                )

                       SELECT tmp.OperDate
                            , _tmpGoods.GroupNum
                            , _tmpGoods.GoodsPlatformId
                            , _tmpGoods.TradeMarkId
                            , _tmpGoods.GoodsTagId
                            , CASE WHEN _tmpGoods.GroupNum = 2 THEN tmp.GoodsId ELSE 0 END AS GoodsId
                            , (SUM (tmp.SaleAmount          * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)  ) AS SaleAmount
                            , (SUM (tmp.SaleAmountPartner   * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)  ) AS SaleAmountPartner
                            , (SUM (tmp.ReturnAmount        * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)  ) AS ReturnAmount
                            , (SUM (tmp.ReturnAmountPartner * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)  ) AS ReturnAmountPartner

                            , (SUM (tmp.SaleAmountDay          * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)  ) AS SaleAmountDay
                            , (SUM (tmp.SaleAmountPartnerDay   * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)  ) AS SaleAmountPartnerDay
                            , (SUM (tmp.ReturnAmountDay        * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)  ) AS ReturnAmountDay
                            , (SUM (tmp.ReturnAmountPartnerDay * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)  ) AS ReturnAmountPartnerDay

                            , (SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                         THEN tmp.SaleAmount
                                         -- перевод в шт. для Тушенки
                                         WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                         THEN tmp.SaleAmount / _tmpGoods.Weight
                                         ELSE 0
                                    END)) AS SaleAmountSh
                            , (SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                         THEN tmp.SaleAmountPartner
                                         -- перевод в шт. для Тушенки
                                         WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                         THEN tmp.SaleAmountPartner / _tmpGoods.Weight
                                         ELSE 0
                                    END)) AS SaleAmountPartnerSh
                            , (SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                         THEN tmp.ReturnAmount
                                         -- перевод в шт. для Тушенки
                                         WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                         THEN tmp.ReturnAmount / _tmpGoods.Weight
                                         ELSE 0
                                    END)) AS ReturnAmountSh
                            , (SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                         THEN tmp.ReturnAmountPartner
                                         -- перевод в шт. для Тушенки
                                         WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                         THEN tmp.ReturnAmountPartner / _tmpGoods.Weight
                                         ELSE 0
                                    END)) AS ReturnAmountPartnerSh

                            , (SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                         THEN tmp.SaleAmountDay
                                         -- перевод в шт. для Тушенки
                                         WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                         THEN tmp.SaleAmountDay / _tmpGoods.Weight
                                         ELSE 0
                                    END)) AS SaleAmountDaySh
                            , (SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                         THEN tmp.SaleAmountPartnerDay
                                         -- перевод в шт. для Тушенки
                                         WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                         THEN tmp.SaleAmountPartnerDay / _tmpGoods.Weight
                                         ELSE 0
                                    END)) AS SaleAmountPartnerDaySh
                            , (SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                         THEN tmp.ReturnAmountDay
                                         -- перевод в шт. для Тушенки
                                         WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                         THEN tmp.ReturnAmountDay / _tmpGoods.Weight
                                         ELSE 0
                                    END)) AS ReturnAmountDaySh
                            , (SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                         THEN tmp.ReturnAmountPartnerDay
                                         -- перевод в шт. для Тушенки
                                         WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                         THEN tmp.ReturnAmountPartnerDay / _tmpGoods.Weight
                                         ELSE 0
                                    END)) AS ReturnAmountPartnerDaySh

                            -- данные из заявок
                            , (SUM (tmp.Amount_Order * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)) AS OrderAmount
                            , (SUM (tmp.Amount_More  * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END))  AS MoreAmount
                            , (SUM (tmp.Amount_Under * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END)) AS UnderAmount
                            , (SUM (tmp.Amount_Diff  * CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh() THEN _tmpGoods.Weight ELSE 1 END))  AS DiffAmount

                            , (SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                         THEN tmp.Amount_Order
                                         -- перевод в шт. для Тушенки
                                         WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                         THEN tmp.Amount_Order / _tmpGoods.Weight
                                         ELSE 0
                                    END)           ) AS OrderAmountSh
                            , (SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                         THEN tmp.Amount_More
                                         -- перевод в шт. для Тушенки
                                         WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                         THEN tmp.Amount_More / _tmpGoods.Weight
                                         ELSE 0
                                    END)            ) AS MoreAmountSh
                            , (SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                         THEN tmp.Amount_Under
                                         -- перевод в шт. для Тушенки
                                         WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                         THEN tmp.Amount_Under / _tmpGoods.Weight
                                         ELSE 0
                                    END)           ) AS UnderAmountSh
                            , (SUM (CASE WHEN _tmpGoods.MeasureId = zc_Measure_Sh()
                                         THEN tmp.Amount_Diff
                                         -- перевод в шт. для Тушенки
                                         WHEN _tmpGoods.Weight > 0 AND _tmpGoods.GroupNum = 2
                                         THEN tmp.Amount_Diff / _tmpGoods.Weight
                                         ELSE 0
                                    END)            ) AS DiffAmountSh

                      FROM tmpData AS tmp
                           LEFT JOIN _tmpGoods  ON _tmpGoods.GoodsId = tmp.GoodsId
                      GROUP BY _tmpGoods.GroupNum
                             , _tmpGoods.GoodsPlatformId
                             , _tmpGoods.TradeMarkId
                             , _tmpGoods.GoodsTagId
                             , CASE WHEN _tmpGoods.GroupNum = 2 THEN tmp.GoodsId ELSE 0 END
                             , tmp.OperDate
                     ;


    -- Результат для 1-ой страницы
    OPEN Cursor1 FOR
       WITH tmpData AS (SELECT _tmpData.* FROM _tmpData  WHERE _tmpData.GroupNum = 1)

       SELECT *
            , CAST (ROW_NUMBER() OVER ( ORDER BY tmp.Num, tmp.Num2) AS Integer) AS NumLine
            , FALSE AS BoldRecord
       FROM
         (-- 1.1.
          SELECT '    Итого продано колбасы'        :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner
               , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , FALSE AS isTop
               , zc_Color_Red() :: Integer AS ColorRecord
               , 1 AS Num
               , 1 AS Num2
          FROM tmpData

        UNION ALL
          -- 1.2.
          SELECT Object_GoodsPlatform.ValueData    :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner
               , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , FALSE AS isTop
               , zc_Color_Black()  :: Integer AS ColorRecord
               , 1 AS Num
               , 2 AS Num2
          FROM tmpData
               LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = tmpData.GoodsPlatformId
          GROUP BY Object_GoodsPlatform.ValueData

        UNION ALL
          -- 1.3.
          SELECT 'за сутки Алан'             :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmountDay)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartnerDay)    :: TFloat   AS SaleAmountPartner
               , SUM (tmpData.ReturnAmountDay)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartnerDay)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmountDay - tmpData.ReturnAmountDay)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartnerDay - tmpData.ReturnAmountPartnerDay) :: TFloat AS AmountPartner

               , FALSE AS isTop
               , zc_Color_Red() :: Integer AS ColorRecord
               , 1 AS Num
               , 3 AS Num2
          FROM tmpData
          WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'

        UNION ALL
          -- 1.4.
          SELECT 'сред. Кг/сутки Алан'                             :: TVarChar AS GroupName
               , (SUM (tmpData.SaleAmount)          / vbCountDays) :: TFloat   AS SaleAmount
               , (SUM (tmpData.SaleAmountPartner)   / vbCountDays) :: TFloat   AS SaleAmountPartner
               , (SUM (tmpData.ReturnAmount)        / vbCountDays) :: TFloat   AS ReturnAmount
               , (SUM (tmpData.ReturnAmountPartner) / vbCountDays) :: TFloat   AS ReturnAmountPartner
               , (SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               / vbCountDays) :: TFloat AS Amount
               , (SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) / vbCountDays) :: TFloat AS AmountPartner
               , FALSE AS isTop
               , zc_Color_Red() :: Integer AS ColorRecord
               , 1 AS Num
               , 4 AS Num2
          FROM tmpData
               LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpData.TradeMarkId
          WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'

        UNION ALL
          -- 2.1.
          SELECT '    В разрезе торговых марок'     :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner
               , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , TRUE AS isTop
               , zc_Color_Blue() :: Integer AS ColorRecord
               , 2 AS Num
               , 0 AS Num2
          FROM tmpData
          WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'

        UNION ALL
          -- 2.2.
          SELECT Object_TradeMark.ValueData        :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner
               , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , FALSE AS isTop
               , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black()) :: Integer  AS ColorRecord
               , 2 AS Num
               , CAST (ROW_NUMBER() OVER (ORDER BY Object_TradeMark.ValueData)   AS Integer) AS Num2
          FROM tmpData
               LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpData.TradeMarkId
               LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                                     ON ObjectFloat_ColorReport.ObjectId = Object_TradeMark.Id
                                    AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_TradeMark_ColorReport()
          WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'
          GROUP BY Object_TradeMark.ValueData, COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black())

        UNION ALL
          -- 3.1.
          SELECT '    В разрезе групп товаров'      :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner
               , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , TRUE AS isTop
               , zc_Color_Blue()  :: Integer AS ColorRecord
               , 3 AS Num
               , 0 AS Num2
          FROM tmpData
          WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'

        UNION ALL
          -- 3.2.
          SELECT Object_GoodsTag.ValueData          :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner
               , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , FALSE AS isTop
               , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black()) :: Integer  AS ColorRecord
               , 3 AS Num
               , CAST (ROW_NUMBER() OVER (ORDER BY Object_GoodsTag.ValueData)   AS Integer) AS Num2
          FROM tmpData
               LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = tmpData.GoodsTagId
               LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                                     ON ObjectFloat_ColorReport.ObjectId = Object_GoodsTag.Id
                                    AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_GoodsTag_ColorReport()
          WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'
          GROUP BY Object_GoodsTag.ValueData, COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black())

          ) AS tmp;

    RETURN NEXT Cursor1;


    -- Результат для 2-ой страницы
    OPEN Cursor2 FOR
       WITH tmpData AS (SELECT _tmpData.* FROM _tmpData  WHERE _tmpData.GroupNum = 2)

       SELECT *
            , CAST (ROW_NUMBER() OVER (ORDER BY tmp.Num, tmp.Num2) AS Integer) AS NumLine
            , FALSE AS BoldRecord
       FROM
          -- 1.1.
         (SELECT '    Итого продано Чапли'                  :: TVarChar AS GroupName
               , SUM (tmpData.SaleAmountSh)           :: TFloat   AS SaleAmountSh
               , SUM (tmpData.SaleAmountPartnerSh)    :: TFloat   AS SaleAmountPartnerSh
               , SUM (tmpData.ReturnAmountSh)         :: TFloat   AS ReturnAmountSh
               , SUM (tmpData.ReturnAmountPartnerSh)  :: TFloat   AS ReturnAmountPartnerSh
               , SUM (tmpData.SaleAmountSh - tmpData.ReturnAmountSh)               :: TFloat AS AmountSh
               , SUM (tmpData.SaleAmountPartnerSh - tmpData.ReturnAmountPartnerSh) :: TFloat AS AmountPartnerSh

               , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
               , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner
               , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
               , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
               , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
               , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , FALSE AS isTop
               , zc_Color_Red()  :: Integer AS ColorRecord
               , 1 AS Num
               , 1 AS Num2
          FROM tmpData

      UNION ALL
          -- 1.2.
          SELECT 'за сутки Чапли'             :: TVarChar AS GroupName
                , SUM (tmpData.SaleAmountDaySh)           :: TFloat   AS SaleAmountSh
                , SUM (tmpData.SaleAmountPartnerDaySh)    :: TFloat   AS SaleAmountPartnerSh
                , SUM (tmpData.ReturnAmountDaySh)         :: TFloat   AS ReturnAmountSh
                , SUM (tmpData.ReturnAmountPartnerDaySh)  :: TFloat   AS ReturnAmountPartnerSh
                , SUM (tmpData.SaleAmountDaySh - tmpData.ReturnAmountDaySh)               :: TFloat AS AmountSh
                , SUM (tmpData.SaleAmountPartnerDaySh - tmpData.ReturnAmountPartnerDaySh) :: TFloat AS AmountPartnerSh

                , SUM (tmpData.SaleAmountDay)           :: TFloat   AS SaleAmount
                , SUM (tmpData.SaleAmountPartnerDay)    :: TFloat   AS SaleAmountPartner
                , SUM (tmpData.ReturnAmountDay)         :: TFloat   AS ReturnAmount
                , SUM (tmpData.ReturnAmountPartnerDay)  :: TFloat   AS ReturnAmountPartner
                , SUM (tmpData.SaleAmountDay - tmpData.ReturnAmountDay)               :: TFloat AS Amount
                , SUM (tmpData.SaleAmountPartnerDay - tmpData.ReturnAmountPartnerDay) :: TFloat AS AmountPartner
                , FALSE AS isTop
                , zc_Color_Red()  :: Integer AS ColorRecord
                , 1 AS Num
                , 2 AS Num2
          FROM tmpData

      UNION ALL
          -- 1.3.
          SELECT 'сред. шт/сутки Чапли'                                 :: TVarChar AS GroupName
                , (SUM (tmpData.SaleAmountSh) / vbCountDays           ) :: TFloat   AS SaleAmountSh
                , (SUM (tmpData.SaleAmountPartnerSh) / vbCountDays    ) :: TFloat   AS SaleAmountPartnerSh
                , (SUM (tmpData.ReturnAmountSh) / vbCountDays         ) :: TFloat   AS ReturnAmountSh
                , (SUM (tmpData.ReturnAmountPartnerSh) / vbCountDays  ) :: TFloat   AS ReturnAmountPartnerSh
                , (SUM (tmpData.SaleAmountSh - tmpData.ReturnAmountSh) / vbCountDays)                :: TFloat AS AmountSh
                , (SUM (tmpData.SaleAmountPartnerSh - tmpData.ReturnAmountPartnerSh) / vbCountDays)  :: TFloat AS AmountPartnerSh

                , (SUM (tmpData.SaleAmount) / vbCountDays           ) :: TFloat   AS SaleAmount
                , (SUM (tmpData.SaleAmountPartner) / vbCountDays    ) :: TFloat   AS SaleAmountPartner
                , (SUM (tmpData.ReturnAmount) / vbCountDays         ) :: TFloat   AS ReturnAmount
                , (SUM (tmpData.ReturnAmountPartner) / vbCountDays  ) :: TFloat   AS ReturnAmountPartner
                , (SUM (tmpData.SaleAmount - tmpData.ReturnAmount) / vbCountDays              ) :: TFloat AS Amount
                , (SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) / vbCountDays) :: TFloat AS AmountPartner
                , FALSE AS isTop
                , zc_Color_Red()  :: Integer AS ColorRecord
                , 1 AS Num
                , 3 AS Num2
           FROM tmpData

        UNION ALL
          -- 2.1.
          SELECT '    В разрезе торговых марок'    :: TVarChar AS GroupName
                , SUM (tmpData.SaleAmountSh)           :: TFloat   AS SaleAmountSh
                , SUM (tmpData.SaleAmountPartnerSh)    :: TFloat   AS SaleAmountPartnerSh
                , SUM (tmpData.ReturnAmountSh)         :: TFloat   AS ReturnAmountSh
                , SUM (tmpData.ReturnAmountPartnerSh)  :: TFloat   AS ReturnAmountPartnerSh
                , SUM (tmpData.SaleAmountSh - tmpData.ReturnAmountSh)               :: TFloat AS AmountSh
                , SUM (tmpData.SaleAmountPartnerSh - tmpData.ReturnAmountPartnerSh) :: TFloat AS AmountPartnerSh

                , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner
                , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
                , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
                , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
                , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , TRUE AS isTop
               , zc_Color_Blue()  :: Integer AS ColorRecord
               , 2 AS Num
               , 0 AS Num2
          FROM tmpData

        UNION ALL
           -- 2.2.
           SELECT Object_TradeMark.ValueData        :: TVarChar AS GroupName
                , SUM (tmpData.SaleAmountSh)           :: TFloat   AS SaleAmountSh
                , SUM (tmpData.SaleAmountPartnerSh)    :: TFloat   AS SaleAmountPartnerSh
                , SUM (tmpData.ReturnAmountSh)         :: TFloat   AS ReturnAmountSh
                , SUM (tmpData.ReturnAmountPartnerSh)  :: TFloat   AS ReturnAmountPartnerSh
                , SUM (tmpData.SaleAmountSh - tmpData.ReturnAmountSh)               :: TFloat AS AmountSh
                , SUM (tmpData.SaleAmountPartnerSh - tmpData.ReturnAmountPartnerSh) :: TFloat AS AmountPartnerSh

                , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner
                , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
                , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
                , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
                , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
                , FALSE AS isTop
                , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black()) :: Integer  AS ColorRecord
                , 2 AS Num
                , CAST (ROW_NUMBER() OVER (ORDER BY Object_TradeMark.ValueData)   AS Integer) AS Num2
           FROM tmpData
                LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpData.TradeMarkId
                LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                                      ON ObjectFloat_ColorReport.ObjectId = Object_TradeMark.Id
                                     AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_TradeMark_ColorReport()
           GROUP BY Object_TradeMark.ValueData, COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black())

        UNION ALL
          -- 3.1.
          SELECT '    В разрезе групп товаров'    :: TVarChar AS GroupName
                , SUM (tmpData.SaleAmountSh)          :: TFloat   AS SaleAmountSh
                , SUM (tmpData.SaleAmountPartnerSh)   :: TFloat   AS SaleAmountPartnerSh
                , SUM (tmpData.ReturnAmountSh)        :: TFloat   AS ReturnAmountSh
                , SUM (tmpData.ReturnAmountPartnerSh) :: TFloat   AS ReturnAmountPartnerSh
                , SUM (tmpData.SaleAmountSh - tmpData.ReturnAmountSh)               :: TFloat AS AmountSh
                , SUM (tmpData.SaleAmountPartnerSh - tmpData.ReturnAmountPartnerSh) :: TFloat AS AmountPartnerSh

                , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner
                , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
                , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
                , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
                , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , TRUE AS isTop
               , zc_Color_Blue()  :: Integer AS ColorRecord
               , 3 AS Num
               , 0 AS Num2
           FROM tmpData

        UNION ALL
          -- 3.2.
           SELECT Object_GoodsTag.ValueData           :: TVarChar AS GroupName
                , SUM (tmpData.SaleAmountSh)          :: TFloat   AS SaleAmountSh
                , SUM (tmpData.SaleAmountPartnerSh)   :: TFloat   AS SaleAmountPartnerSh
                , SUM (tmpData.ReturnAmountSh)        :: TFloat   AS ReturnAmountSh
                , SUM (tmpData.ReturnAmountPartnerSh) :: TFloat   AS ReturnAmountPartnerSh
                , SUM (tmpData.SaleAmountSh - tmpData.ReturnAmountSh)               :: TFloat AS AmountSh
                , SUM (tmpData.SaleAmountPartnerSh - tmpData.ReturnAmountPartnerSh) :: TFloat AS AmountPartnerSh

                , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner
                , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
                , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
                , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
                , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
                , FALSE AS isTop
                , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black()) :: Integer  AS ColorRecord
                , 3 AS Num
                , CAST (ROW_NUMBER() OVER (ORDER BY Object_GoodsTag.ValueData)   AS Integer) AS Num2
           FROM tmpData
                LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = tmpData.GoodsTagId
                LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                                      ON ObjectFloat_ColorReport.ObjectId = Object_GoodsTag.Id
                                     AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_GoodsTag_ColorReport()
           GROUP BY Object_GoodsTag.ValueData, COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black())

        UNION ALL
          -- 4.1.
          SELECT '    В разрезе товаров'    :: TVarChar AS GroupName
                , SUM (tmpData.SaleAmountSh)          :: TFloat   AS SaleAmountSh
                , SUM (tmpData.SaleAmountPartnerSh)   :: TFloat   AS SaleAmountPartnerSh
                , SUM (tmpData.ReturnAmountSh)        :: TFloat   AS ReturnAmountSh
                , SUM (tmpData.ReturnAmountPartnerSh) :: TFloat   AS ReturnAmountPartnerSh
                , SUM (tmpData.SaleAmountSh - tmpData.ReturnAmountSh)               :: TFloat AS AmountSh
                , SUM (tmpData.SaleAmountPartnerSh - tmpData.ReturnAmountPartnerSh) :: TFloat AS AmountPartnerSh

                , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner
                , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
                , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
                , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
                , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
               , TRUE AS isTop
               , zc_Color_Blue()  :: Integer AS ColorRecord
               , 4 AS Num
               , 0 AS Num2
           FROM tmpData

        UNION ALL
          -- 4.2.
           SELECT Object_Goods.ValueData              :: TVarChar AS GroupName
                , SUM (tmpData.SaleAmountSh)          :: TFloat   AS SaleAmountSh
                , SUM (tmpData.SaleAmountPartnerSh)   :: TFloat   AS SaleAmountPartnerSh
                , SUM (tmpData.ReturnAmountSh)        :: TFloat   AS ReturnAmountSh
                , SUM (tmpData.ReturnAmountPartnerSh) :: TFloat   AS ReturnAmountPartnerSh
                , SUM (tmpData.SaleAmountSh - tmpData.ReturnAmountSh)               :: TFloat AS AmountSh
                , SUM (tmpData.SaleAmountPartnerSh - tmpData.ReturnAmountPartnerSh) :: TFloat AS AmountPartnerSh

                , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                , SUM (tmpData.SaleAmountPartner)    :: TFloat   AS SaleAmountPartner
                , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount
                , SUM (tmpData.ReturnAmountPartner)  :: TFloat   AS ReturnAmountPartner
                , SUM (tmpData.SaleAmount - tmpData.ReturnAmount)               :: TFloat AS Amount
                , SUM (tmpData.SaleAmountPartner - tmpData.ReturnAmountPartner) :: TFloat AS AmountPartner
                , FALSE AS isTop
                , zc_Color_Black()  :: Integer AS ColorRecord
                , 4 AS Num
                , CAST (ROW_NUMBER() OVER (ORDER BY Object_Goods.ValueData)   AS Integer) AS Num2
           FROM tmpData
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
           GROUP BY Object_Goods.ValueData

           ) AS tmp
    ;

  RETURN NEXT Cursor2;

    -- Результат для 3-ой страницы Данные для графика
    OPEN Cursor3 FOR

       WITH tmpData AS (SELECT _tmpData.*
                             , CASE WHEN inMonth = TRUE THEN DATE_TRUNC ('MONTH', _tmpData.OperDate)
                                    WHEN inWeek  = TRUE THEN (_tmpData.OperDate - (((DATE_PART ('DoW', _tmpData.OperDate)::int)-1)|| 'day')::interval)
                                    ELSE _tmpData.OperDate
                               END  :: tdatetime AS StartDate
                             , CASE WHEN inMonth = TRUE THEN (DATE_TRUNC ('MONTH', _tmpData.OperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
                                    WHEN inWeek  = TRUE THEN (_tmpData.OperDate + ((7-(DATE_PART ('DoW', _tmpData.OperDate)::int))|| 'day')::interval)
                                    ELSE _tmpData.OperDate
                               END  :: tdatetime AS EndDate
                        FROM _tmpData)
     , tmp_All AS (
                    SELECT tmp.*
                         , CAST (ROW_NUMBER() OVER (PARTITION BY tmp.GroupNum, tmp.StartDate, tmp.EndDate  ORDER BY tmp.StartDate, tmp.EndDate, tmp.GroupNum, tmp.Num, tmp.Num2 , GroupName) AS Integer) AS NumLine

                    FROM
                        (-- 1.1.
                        SELECT '    Итого продано '        :: TVarChar AS GroupName
                             , tmpData.StartDate
                             , tmpData.EndDate
                             , tmpData.GroupNum
                             , SUM (tmpData.SaleAmountSh)         :: TFloat   AS SaleAmountSh
                             , SUM (tmpData.ReturnAmountSh)       :: TFloat   AS ReturnAmountSh
                             , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                             , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount

                             , SUM (tmpData.OrderAmount)          :: TFloat   AS OrderAmount
                             , SUM (tmpData.MoreAmount)           :: TFloat   AS MoreAmount
                             , SUM (tmpData.UnderAmount)          :: TFloat   AS UnderAmount
                             , SUM (tmpData.DiffAmount)           :: TFloat   AS DiffAmount

                             , SUM (tmpData.OrderAmountSh)        :: TFloat   AS OrderAmountSh
                             , SUM (tmpData.MoreAmountSh)         :: TFloat   AS MoreAmountSh
                             , SUM (tmpData.UnderAmountSh)        :: TFloat   AS UnderAmountSh
                             , SUM (tmpData.DiffAmountSh)         :: TFloat   AS DiffAmountSh
                             , 1 AS Num
                             , 1 AS Num2
                       FROM tmpData
                       GROUP BY tmpData.StartDate
                              , tmpData.EndDate
                              , tmpData.GroupNum
                     UNION ALL
                       -- 1.2.
                       SELECT Object_GoodsPlatform.ValueData    :: TVarChar AS GroupName
                            , tmpData.StartDate
                            , tmpData.EndDate
                            , tmpData.GroupNum
                            , SUM (tmpData.SaleAmountSh)         :: TFloat   AS SaleAmountSh
                            , SUM (tmpData.ReturnAmountSh)       :: TFloat   AS ReturnAmountSh
                            , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                            , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount

                             , SUM (tmpData.OrderAmount)          :: TFloat   AS OrderAmount
                             , SUM (tmpData.MoreAmount)           :: TFloat   AS MoreAmount
                             , SUM (tmpData.UnderAmount)          :: TFloat   AS UnderAmount
                             , SUM (tmpData.DiffAmount)           :: TFloat   AS DiffAmount

                             , SUM (tmpData.OrderAmountSh)        :: TFloat   AS OrderAmountSh
                             , SUM (tmpData.MoreAmountSh)         :: TFloat   AS MoreAmountSh
                             , SUM (tmpData.UnderAmountSh)        :: TFloat   AS UnderAmountSh
                             , SUM (tmpData.DiffAmountSh)         :: TFloat   AS DiffAmountSh

                            , 1 AS Num
                            , 2 AS Num2
                       FROM tmpData
                            LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = tmpData.GoodsPlatformId
                       WHERE COALESCE (Object_GoodsPlatform.ValueData,'')<>''
                         AND tmpData.GroupNum = 1
                       GROUP BY Object_GoodsPlatform.ValueData
                            , tmpData.StartDate
                            , tmpData.EndDate
                            , tmpData.GroupNum
                     UNION ALL
                        -- 2.2.--
                        SELECT trim(Object_TradeMark.ObjectCode :: TVarChar )  :: TVarChar AS GroupName
                             , tmpData.StartDate
                             , tmpData.EndDate
                             , tmpData.GroupNum
                             , SUM (tmpData.SaleAmountSh)         :: TFloat   AS SaleAmountSh
                             , SUM (tmpData.ReturnAmountSh)       :: TFloat   AS ReturnAmountSh
                             , SUM (tmpData.SaleAmount)           :: TFloat   AS SaleAmount
                             , SUM (tmpData.ReturnAmount)         :: TFloat   AS ReturnAmount

                             , SUM (tmpData.OrderAmount)          :: TFloat   AS OrderAmount
                             , SUM (tmpData.MoreAmount)           :: TFloat   AS MoreAmount
                             , SUM (tmpData.UnderAmount)          :: TFloat   AS UnderAmount
                             , SUM (tmpData.DiffAmount)           :: TFloat   AS DiffAmount

                             , SUM (tmpData.OrderAmountSh)        :: TFloat   AS OrderAmountSh
                             , SUM (tmpData.MoreAmountSh)         :: TFloat   AS MoreAmountSh
                             , SUM (tmpData.UnderAmountSh)        :: TFloat   AS UnderAmountSh
                             , SUM (tmpData.DiffAmountSh)         :: TFloat   AS DiffAmountSh

                             , 2 AS Num
                             , CAST (ROW_NUMBER() OVER (ORDER BY Object_TradeMark.ObjectCode)   AS Integer) AS Num2
                        FROM tmpData
                             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = tmpData.TradeMarkId
                        WHERE tmpData.GoodsPlatformId = 416935 ---'%Алан%'
                           OR tmpData.GroupNum = 2             --- тушенка
                        GROUP BY Object_TradeMark.ObjectCode
                               , tmpData.StartDate
                               , tmpData.EndDate
                               , tmpData.GroupNum
                        ) as tmp
                )

         SELECT --tmp.OperDate
                tmp.StartDate
              , tmp.EndDate
              , tmpWeekDay_Start.DayOfWeekName AS DOW_StartDate
              , tmpWeekDay_End.DayOfWeekName   AS DOW_EndDate
              -- итого колбаса
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.NumLine = 1 THEN tmp.SaleAmount ELSE 0 END)    AS SaleAmount_11
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.NumLine = 1 THEN tmp.ReturnAmount ELSE 0 END)  AS ReturnAmount_11
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.NumLine = 1 THEN tmp.OrderAmount ELSE 0 END)   AS OrderAmount_11
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.NumLine = 1 THEN tmp.MoreAmount ELSE 0 END)    AS MoreAmount_11
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.NumLine = 1 THEN tmp.UnderAmount ELSE 0 END)   AS UnderAmount_11
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.NumLine = 1 THEN tmp.DiffAmount ELSE 0 END)    AS DiffAmount_11
              -- алан
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.NumLine = 2 THEN tmp.SaleAmount ELSE 0 END)   AS SaleAmount_12
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.NumLine = 2 THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_12
              -- ирна
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.NumLine = 3 THEN tmp.SaleAmount ELSE 0 END)   AS SaleAmount_13
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.NumLine = 3 THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_13
              -- торговые марки колбаса
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '1' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Alan
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '1' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Alan
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '2' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_SpecCeh
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '2' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_SpecCeh
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '3' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Varto
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '3' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Varto
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '4' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Nashi
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '4' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Nashi
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '5' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Amstor
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '5' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Amstor
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '6' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Fitness
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '6' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Fitness
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '7' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_PovnaChasha
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '7' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_PovnaChasha
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '8' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Premiya
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '8' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Premiya
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '9' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Irna
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '9' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Irna
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '10' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Ashan
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '10' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Ashan
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '11' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Horeca
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '11' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Horeca
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '12' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Aro
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '12' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Aro
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '13' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Hit
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '13' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Hit
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '14' THEN tmp.SaleAmount ELSE 0 END) AS SaleAmount_1_Num1
              , SUM (CASE WHEN tmp.GroupNum = 1 AND tmp.GroupName = '14' THEN tmp.ReturnAmount ELSE 0 END) AS ReturnAmount_1_Num1

              -- итого тушенка
              , SUM (CASE WHEN tmp.GroupNum = 2 AND tmp.NumLine = 1 THEN tmp.SaleAmountSh ELSE 0 END)   AS SaleAmount_21
              , SUM (CASE WHEN tmp.GroupNum = 2 AND tmp.NumLine = 1 THEN tmp.ReturnAmountSh ELSE 0 END) AS ReturnAmount_21
              , SUM (CASE WHEN tmp.GroupNum = 2 AND tmp.NumLine = 1 THEN tmp.OrderAmountSh ELSE 0 END)  AS OrderAmount_21
              , SUM (CASE WHEN tmp.GroupNum = 2 AND tmp.NumLine = 1 THEN tmp.MoreAmountSh ELSE 0 END)   AS MoreAmount_21
              , SUM (CASE WHEN tmp.GroupNum = 2 AND tmp.NumLine = 1 THEN tmp.UnderAmountSh ELSE 0 END)  AS UnderAmount_21
              , SUM (CASE WHEN tmp.GroupNum = 2 AND tmp.NumLine = 1 THEN tmp.DiffAmountSh ELSE 0 END)   AS DiffAmount_21

              -- торговые марки тушенка
              , SUM (CASE WHEN tmp.GroupNum = 2 AND tmp.GroupName = '1' THEN tmp.SaleAmountSh ELSE 0 END) AS SaleAmount_2_Alan
              , SUM (CASE WHEN tmp.GroupNum = 2 AND tmp.GroupName = '1' THEN tmp.ReturnAmountSh ELSE 0 END) AS ReturnAmount_2_Alan
              , SUM (CASE WHEN tmp.GroupNum = 2 AND tmp.GroupName = '4' THEN tmp.SaleAmountSh ELSE 0 END) AS SaleAmount_2_Nashi
              , SUM (CASE WHEN tmp.GroupNum = 2 AND tmp.GroupName = '4' THEN tmp.ReturnAmountSh ELSE 0 END) AS ReturnAmount_2_Nashi

         FROM tmp_All AS tmp
              LEFT JOIN zfCalc_DayOfWeekName(tmp.StartDate) AS tmpWeekDay_Start ON 1=1
              LEFT JOIN zfCalc_DayOfWeekName(tmp.EndDate) AS tmpWeekDay_End ON 1=1
         GROUP BY tmp.StartDate, tmp.EndDate
                , tmpWeekDay_Start.DayOfWeekName
                , tmpWeekDay_End.DayOfWeekName
;

  RETURN NEXT Cursor3;

     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     /*INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum: VACUUM' in query) = 1) AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , NULL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpReport_Goods_byMovementReal'
               -- ProtocolData
             , zfConvert_DateToString (inStartDate)
    || ', ' || zfConvert_DateToString (inEndDate)
    || ', ' || inUnitId           :: TVarChar
    || ', ' || inUnitGroupId      :: TVarChar
    || ', ' || inGoodsGroupGPId   :: TVarChar
    || ', ' || inGoodsGroupId     :: TVarChar
    || ', ' || inWeek             :: TVarChar
    || ', ' || inMonth            :: TVarChar
    || ', ' || inSession
              ;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.12.18         * на проводках
 21.12.18         * по дате покупателя
 30.01.17         *
 02.12.16         *
*/

-- тест
-- SELECT * FROM gpReport_Goods_byMovementReal (inStartDate := ('01.12.2023')::TDateTime , inEndDate := ('25.12.2023')::TDateTime , inUnitId := 8459 , inUnitGroupId := 8460 , inGoodsGroupGPId := 1832 , inGoodsGroupId := 1979 , inWeek := 'False' ::Boolean, inMonth := 'False'::Boolean ,  inSession := '5' ::TVarChar);
