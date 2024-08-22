-- Function: gpReport_GoodsRemains_byPack ()

DROP FUNCTION IF EXISTS gpReport_GoodsRemains_byPack (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsRemains_byPack (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsRemains_byPack (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsRemains_byPack(
    IN inStartDate          TDateTime ,
    IN inEndDate            TDateTime ,
    IN inUnitId             Integer   , 
    IN inGoodsGroupId       Integer,    -- группа товара
    IN inGoodsId            Integer,    -- товар
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE ( GoodsId Integer
              , GoodsCode Integer
              , GoodsName TVarChar
              , GoodsKindName TVarChar
              , GoodsCode_basis Integer, GoodsName_basis TVarChar
              , GoodsGroupId Integer
              , GoodsGroupName TVarChar
              , GoodsGroupNameFull TVarChar
              , MeasureName TVarChar, Weight TFloat
              , RemainsStart             TFloat -- Остатки на начало
              , RemainsStart_Weight      TFloat -- Остатки на начало
              , RemainsEnd               TFloat -- Остатки на конец
              , RemainsEnd_Weight        TFloat -- Остатки на конец
              , CountIn              TFloat -- Приходы
              , CountIn_Weight       TFloat -- Приходы
              , CountIn_pack         TFloat
              , CountIn_pack_Weight  TFloat
              , CountIn_dop          TFloat -- Потребление
              , CountIn_dop_Weight   TFloat -- Потребление
              , CountOut             TFloat
              , CountOut_Weight      TFloat
              , CountOut_sale        TFloat
              , CountOut_sale_Weight TFloat
              , CountOut_pack        TFloat
              , CountOut_pack_Weight TFloat
              , AmountPartner             TFloat
              , AmountPartner_Weight      TFloat
              , AmountPartnerPrior        TFloat
              , AmountPartnerPrior_Weight TFloat

              , RemainsEnd_calc        TFloat --остаток без за 
              , RemainsEnd_calc_Weight TFloat

              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    -- !!!Нет прав!!! - Ограниченние - нет доступа к Отчету по остаткам
    IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11086934)
    THEN
        RAISE EXCEPTION 'Ошибка.Нет прав.';
    END IF;


    -- группа товаров или товар или все товары 
    CREATE TEMP TABLE tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0 AND COALESCE (inGoodsId, 0) = 0
    THEN
        INSERT INTO tmpGoods (GoodsId)
           SELECT lfSelect.GoodsId 
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
           ;
    ELSE 
        INSERT INTO tmpGoods (GoodsId)
           SELECT Object.Id
           FROM Object
           WHERE Object.DescId = zc_Object_Goods()
             AND Object.isErased = False
             AND (Object.Id = inGoodsId OR inGoodsId = 0) 
           ;
    END IF;

    -- Результат
    RETURN QUERY
         --
    WITH 
    /*tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                 FROM Object_InfoMoney_View
                      LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                           ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                          AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                 WHERE Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ГП   zc_Enum_InfoMoney_30101() -- Готовая продукция
                 )
  ,*/ tmpAccountNo AS (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE Object_Account_View.AccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
    -- Склад Реализации
  , tmpUnit_SKLAD AS (SELECT UnitId, FALSE AS isContainer FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect_Object_Unit_byGroup) --8457 базы+ реализ   --8459 реализ
    -- Цех Упаковки
  , tmpUnit_PACK  AS (SELECT 8451 AS UnitId)

  , tmpContainer AS (SELECT CLO_Unit.ContainerId
                          , tmpUnit_SKLAD.UnitId
                          , tmpGoods.GoodsId
                          , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                          , COALESCE (Container.Amount,0)        AS Amount
                     FROM tmpUnit_SKLAD
                          INNER JOIN ContainerLinkObject AS CLO_Unit
                                                         ON CLO_Unit.ObjectId = tmpUnit_SKLAD.UnitId
                                                        AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                          LEFT JOIN Container ON Container.Id = CLO_Unit.ContainerId
                                             AND Container.DescId = zc_Container_Count()
          
                          INNER JOIN tmpGoods ON tmpGoods.GoodsId = Container.ObjectId
                          
                          LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                        ON CLO_GoodsKind.ContainerId = Container.Id
                                                       AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                     )

  , tmpMIContainer AS (SELECT tmpContainer.ContainerId
                            , tmpContainer.UnitId
                            , tmpContainer.GoodsId
                            , tmpContainer.GoodsKindId
 
                             -- Приход 
                           , SUM (CASE WHEN COALESCE (MIContainer.Amount,0) > 0 AND MIContainer.MovementDescId NOT IN (zc_Movement_Inventory())
                                       THEN MIContainer.Amount
                                       ELSE 0
                                  END) AS CountIn
                             -- Приход c цеха Упаковки
                           , SUM (CASE WHEN (COALESCE (MIContainer.Amount,0) > 0 AND MIContainer.MovementDescId NOT IN (zc_Movement_Inventory())) AND MIContainer.ObjectExtId_Analyzer = 8451
                                       THEN MIContainer.Amount
                                       ELSE 0
                                  END) AS CountIn_pack
                           -- весь расход 
                           , SUM (CASE WHEN (COALESCE (MIContainer.Amount,0) < 0) AND MIContainer.MovementDescId NOT IN (zc_Movement_Inventory())
                                            THEN MIContainer.Amount * (-1)
                                       ELSE 0
                                  END) AS CountOut
                           -- расход реализ + перем. по цене 
                           , SUM (CASE WHEN COALESCE (MIContainer.Amount,0) < 0 AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                            THEN MIContainer.Amount * (-1)
                                       ELSE 0
                                  END) AS CountOut_sale
                           , SUM (CASE WHEN ((COALESCE (MIContainer.Amount,0) < 0) OR MIContainer.MovementDescId IN (zc_Movement_Inventory())) AND MIContainer.ObjectExtId_Analyzer = 8451
                                            THEN MIContainer.Amount * (-1)
                                       ELSE 0
                                  END) AS CountOut_pack

                                   -- ***REMAINS***
                           , -1 * SUM (CASE WHEN MIContainer.OperDate >= inStartDate THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) AS RemainsStart
                           , -1 * SUM (CASE WHEN MIContainer.OperDate > inEndDate    THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) AS RemainsEnd
                       FROM tmpContainer
                            INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                           AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                       WHERE COALESCE (MIContainer.AccountId, 0) NOT IN (SELECT tmpAccountNo.AccountId FROM tmpAccountNo)-- zc_Enum_Account_110101()-- товар в пути
                       GROUP BY tmpContainer.ContainerId
                              , tmpContainer.UnitId
                              , tmpContainer.GoodsId
                              , tmpContainer.GoodsKindId
                       HAVING SUM (CASE WHEN COALESCE (MIContainer.Amount,0) > 0 AND MIContainer.MovementDescId NOT IN (zc_Movement_Inventory())
                                       THEN MIContainer.Amount
                                       ELSE 0
                                  END) <> 0
                           OR SUM (CASE WHEN (COALESCE (MIContainer.Amount,0) > 0 AND MIContainer.MovementDescId NOT IN (zc_Movement_Inventory())) AND MIContainer.ObjectExtId_Analyzer = 8451
                                       THEN MIContainer.Amount
                                       ELSE 0
                                  END) <> 0
                            --
                           OR SUM (CASE WHEN (COALESCE (MIContainer.Amount,0) < 0) AND MIContainer.MovementDescId  NOT IN (zc_Movement_Inventory())
                                            THEN MIContainer.Amount * (-1)
                                       ELSE 0
                                  END) <> 0
                           OR SUM (CASE WHEN COALESCE (MIContainer.Amount,0) < 0 AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                            THEN MIContainer.Amount * (-1)
                                       ELSE 0
                                  END) <> 0
                           OR SUM (CASE WHEN ((COALESCE (MIContainer.Amount,0) < 0) AND MIContainer.MovementDescId NOT IN (zc_Movement_Inventory())) AND MIContainer.ObjectExtId_Analyzer = 8451
                                            THEN MIContainer.Amount * (-1)
                                       ELSE 0
                                  END) <> 0
                             -- ***REMAINS***
                           OR SUM (CASE WHEN MIContainer.OperDate >= inStartDate THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) <> 0
                           OR SUM (CASE WHEN MIContainer.OperDate > inEndDate    THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) <> 0
                      UNION ALL
                       --для расчета остатков
                       SELECT tmpContainer.ContainerId
                            , tmpContainer.UnitId
                            , tmpContainer.GoodsId
                            , tmpContainer.GoodsKindId
 
                              -- ***COUNT***
                            , 0 AS CountIn
                            , 0 AS CountIn_pack
                            , 0 AS CountOut
                            , 0 AS CountOut_sale
                            , 0 AS CountOut_pack
                              -- ***REMAINS***
                           , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                           , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsEnd
 
                       FROM tmpContainer
                            LEFT JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                           AND MIContainer.OperDate > inEndDate
                       WHERE COALESCE (MIContainer.AccountId, 0) NOT IN (SELECT tmpAccountNo.AccountId FROM tmpAccountNo)-- zc_Enum_Account_110101()-- товар в пути
                       GROUP BY tmpContainer.ContainerId
                              , tmpContainer.UnitId
                              , tmpContainer.GoodsId
                              , tmpContainer.GoodsKindId
                              , tmpContainer.Amount
                       HAVING tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                     )
   --отгруженные / не отгруженные заявки
  , tmpOrder_all AS (SELECT MovementItem.ObjectId                                                    AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())         AS GoodsKindId
                          , SUM (CASE WHEN Movement.OperDate >= inStartDate THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPartner
                          , SUM (CASE WHEN Movement.OperDate < inStartDate
                                       AND MovementDate_OperDatePartner.ValueData >= inEndDate
                                           THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                      ELSE 0
                                 END) AS AmountPartnerPrior
                     FROM Movement 
                          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                 ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                          INNER JOIN tmpUnit_SKLAD ON tmpUnit_SKLAD.UnitId = MovementLinkObject_To.ObjectId
                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = FALSE
                          INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                          LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                      ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                     AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                     WHERE Movement.OperDate BETWEEN (inStartDate - INTERVAL '7 DAY') AND inEndDate + INTERVAL '0 DAY'
                       AND MovementDate_OperDatePartner.ValueData >= inStartDate
                       AND Movement.DescId   = zc_Movement_OrderExternal()
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                     GROUP BY MovementItem.ObjectId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())
                     HAVING SUM (CASE WHEN Movement.OperDate >= inStartDate THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) <> 0
                         OR SUM (CASE WHEN Movement.OperDate < inStartDate
                                       AND MovementDate_OperDatePartner.ValueData >= inEndDate
                                           THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                      ELSE 0
                                 END)  <> 0
                     )

  , tmpUnion AS (SELECT tmpMIContainer.GoodsId
                      , tmpMIContainer.GoodsKindId
                      , SUM (tmpMIContainer.RemainsStart)      ::TFloat AS RemainsStart
                      , SUM (tmpMIContainer.RemainsEnd)        ::TFloat AS RemainsEnd
                      , SUM (tmpMIContainer.CountIn)       ::TFloat AS CountIn
                      , SUM (tmpMIContainer.CountIn_pack)       ::TFloat AS CountIn_pack
                      , SUM (tmpMIContainer.CountOut)   ::TFloat AS CountOut
                      , SUM (tmpMIContainer.CountOut_sale)   ::TFloat AS CountOut_sale
                      , SUM (tmpMIContainer.CountOut_pack)   ::TFloat AS CountOut_pack
                      , 0 AS AmountPartner
                      , 0 AS AmountPartnerPrior
                 FROM tmpMIContainer
                 GROUP BY tmpMIContainer.GoodsId
                        , tmpMIContainer.GoodsKindId
               UNION
                 SELECT tmpOrder_all.GoodsId
                      , tmpOrder_all.GoodsKindId
                      , 0      ::TFloat AS RemainsStart
                      , 0      ::TFloat AS RemainsEnd
                      , 0      ::TFloat AS CountIn
                      , 0      ::TFloat AS CountIn_pack
                      , 0      ::TFloat AS CountOut
                      , 0      ::TFloat AS CountOut_sale
                      , 0      ::TFloat AS CountOut_pack
                      , SUM (tmpOrder_all.AmountPartner)      ::TFloat AS AmountPartner
                      , SUM (tmpOrder_all.AmountPartnerPrior) ::TFloat AS AmountPartnerPrior
                 FROM tmpOrder_all
                 GROUP BY tmpOrder_all.GoodsId
                        , tmpOrder_all.GoodsKindId
                 )

  , tmpRez AS (SELECT tmpUnion.GoodsId
                    , tmpUnion.GoodsKindId

                    , Object_Measure.ValueData       :: TVarChar AS MeasureName-- MovementDesc.ItemName  :: TVarChar AS MeasureName--
                    , ObjectFloat_Weight.ValueData   :: TFloat   AS Weight

                    , SUM (tmpUnion.RemainsStart)      ::TFloat AS RemainsStart
                    , SUM ((tmpUnion.RemainsStart * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)) ::TFloat AS RemainsStart_Weight
                    , SUM (tmpUnion.RemainsEnd)        ::TFloat AS RemainsEnd
                    , SUM ((tmpUnion.RemainsEnd   * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)) ::TFloat AS RemainsEnd_Weight

                    , SUM (tmpUnion.CountIn)       ::TFloat AS CountIn
                    , SUM ((tmpUnion.CountIn * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)) ::TFloat AS CountIn_Weight

                    , SUM (tmpUnion.CountIn_pack)       ::TFloat AS CountIn_pack
                    , SUM ((tmpUnion.CountIn_pack * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)) ::TFloat AS CountIn_pack_Weight

                    , SUM (tmpUnion.CountOut)   ::TFloat AS CountOut
                    , SUM ((tmpUnion.CountOut * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)) ::TFloat AS CountOut_Weight

                    , SUM (tmpUnion.CountOut_sale)   ::TFloat AS CountOut_sale
                    , SUM ((tmpUnion.CountOut_sale * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)) ::TFloat AS CountOut_sale_Weight

                    , SUM (tmpUnion.CountOut_pack)   ::TFloat AS CountOut_pack
                    , SUM ((tmpUnion.CountOut_pack * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)) ::TFloat AS CountOut_pack_Weight

                    , SUM (tmpUnion.AmountPartner)   ::TFloat AS AmountPartner
                    , SUM ((tmpUnion.AmountPartner * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)) ::TFloat AS AmountPartner_Weight

                    , SUM (tmpUnion.AmountPartnerPrior)   ::TFloat AS AmountPartnerPrior
                    , SUM ((tmpUnion.AmountPartnerPrior * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)) ::TFloat AS AmountPartnerPrior_Weight

                FROM tmpUnion
                    LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                          ON ObjectFloat_Weight.ObjectId = tmpUnion.GoodsId
                                         AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

                    LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                         ON ObjectLink_Goods_Measure.ObjectId = tmpUnion.GoodsId
                                        AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                    LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                GROUP BY tmpUnion.GoodsId
                       , tmpUnion.GoodsKindId
                       , Object_Measure.ValueData
                       , ObjectFloat_Weight.ValueData
               )

           , tmpReceipt AS (SELECT tmpRez.GoodsId
                                 , tmpRez.GoodsKindId
                                 , MAX (Object_Receipt.Id) AS ReceiptId
                                 , MAX (COALESCE (ObjectLink_Receipt_Goods_Parent_0.ChildObjectId, 0)) AS GoodsId_basis
                                 , MAX (COALESCE (ObjectLink_Receipt_Parent_0.ChildObjectId, 0))       AS ReceiptId_basis
                            FROM (SELECT DISTINCT
                                         tmpRez.GoodsId
                                       , tmpRez.GoodsKindId
                                  FROM tmpRez) AS tmpRez
                                 INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                       ON ObjectLink_Receipt_Goods.ChildObjectId = tmpRez.GoodsId
                                                      AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                                 INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                       ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                      AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                                      AND ObjectLink_Receipt_GoodsKind.ChildObjectId = tmpRez.GoodsKindId
                                 INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                    AND Object_Receipt.isErased = FALSE
                                 INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                          ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                         AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                         AND ObjectBoolean_Main.ValueData = TRUE
                                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_0
                                                      ON ObjectLink_Receipt_Parent_0.ObjectId = Object_Receipt.Id
                                                     AND ObjectLink_Receipt_Parent_0.DescId = zc_ObjectLink_Receipt_Parent()
                                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_Parent_0
                                                      ON ObjectLink_Receipt_Goods_Parent_0.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                     AND ObjectLink_Receipt_Goods_Parent_0.DescId = zc_ObjectLink_Receipt_Goods()
                            GROUP BY tmpRez.GoodsId
                                   , tmpRez.GoodsKindId
                          )
           , tmpReceipt_find AS (-- взяли данные - у товара нет прямой ссылки - из чего он делается
                                 SELECT tmpReceipt.GoodsId
                                      , tmpReceipt.GoodsKindId
                                      , tmpReceipt.ReceiptId
                                      , MAX (COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)) AS GoodsId_basis
                                 FROM tmpReceipt
                                      INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                           ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = tmpReceipt.ReceiptId
                                                          AND ObjectLink_ReceiptChild_Receipt.DescId        = zc_ObjectLink_ReceiptChild_Receipt()
                                      INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id       = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                              AND Object_ReceiptChild.isErased = FALSE
                                      LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                           ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                          AND ObjectLink_ReceiptChild_Goods.DescId   = zc_ObjectLink_ReceiptChild_Goods()
                                      INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                             ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                            AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                            AND ObjectFloat_Value.ValueData <> 0
                                      LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                           ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                          AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                      INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                      AND (Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000()             -- Доходы
                                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                                          )
                                 WHERE tmpReceipt.ReceiptId_basis = 0
                                 GROUP BY tmpReceipt.GoodsId
                                        , tmpReceipt.GoodsKindId
                                        , tmpReceipt.ReceiptId
                                )

         -- Результат
         SELECT Object_Goods.Id                            AS GoodsId
              , Object_Goods.ObjectCode                    AS GoodsCode
              , Object_Goods.ValueData     :: TVarChar     AS GoodsName
              , Object_GoodsKind.ValueData ::TVarChar      AS GoodsKindName
              , Object_Goods_basis.ObjectCode              AS GoodsCode_basis
              , Object_Goods_basis.ValueData               AS GoodsName_basis
              , Object_GoodsGroup.Id                       AS GoodsGroupId
              , Object_GoodsGroup.ValueData                AS GoodsGroupName
              , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull

              , tmpData.MeasureName  :: TVarChar
              , tmpData.Weight       :: TFloat  

              , tmpData.RemainsStart        ::TFloat
              , tmpData.RemainsStart_Weight ::TFloat
              , tmpData.RemainsEnd          ::TFloat
              , tmpData.RemainsEnd_Weight   ::TFloat

              , tmpData.CountIn             ::TFloat
              , tmpData.CountIn_Weight      ::TFloat
              , tmpData.CountIn_pack        ::TFloat
              , tmpData.CountIn_pack_Weight ::TFloat
              , (COALESCE (tmpData.CountIn,0) - COALESCE (tmpData.CountIn_pack,0)) ::TFloat AS CountIn_dop
              , (COALESCE (tmpData.CountIn_Weight,0) - COALESCE (tmpData.CountIn_pack_Weight,0)) ::TFloat AS CountIn_dop_Weight
              , tmpData.CountOut                ::TFloat
              , tmpData.CountOut_Weight         ::TFloat
              , tmpData.CountOut_sale           ::TFloat
              , tmpData.CountOut_sale_Weight    ::TFloat
              , tmpData.CountOut_pack           ::TFloat
              , tmpData.CountOut_pack_Weight    ::TFloat

              , tmpData.AmountPartner             ::TFloat
              , tmpData.AmountPartner_Weight      ::TFloat
              , tmpData.AmountPartnerPrior        ::TFloat
              , tmpData.AmountPartnerPrior_Weight ::TFloat
              
              , (COALESCE (tmpData.RemainsEnd,0) - COALESCE (tmpData.AmountPartner,0)) ::TFloat AS RemainsEnd_calc
              , (COALESCE (tmpData.RemainsEnd_Weight,0) - COALESCE (tmpData.AmountPartner_Weight,0)) ::TFloat AS RemainsEnd_calc_Weight
         FROM tmpRez AS tmpData
              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
              LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId

              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                   ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
              LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

              LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                     ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                    AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

              LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId     = tmpData.GoodsId
                                  AND tmpReceipt.GoodsKindId = tmpData.GoodsKindId
                                  AND tmpReceipt.GoodsId_basis <> 0
              LEFT JOIN tmpReceipt_find ON tmpReceipt_find.GoodsId     = tmpData.GoodsId
                                       AND tmpReceipt_find.GoodsKindId = tmpData.GoodsKindId
                                       AND tmpReceipt_find.GoodsId_basis <> 0

              LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = COALESCE (tmpReceipt.GoodsId_basis, COALESCE (tmpReceipt_find.GoodsId_basis, tmpData.GoodsId))
      ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.06.21         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsRemains_byPack(inStartDate:= '31.05.2021', inEndDate:= '31.05.2021', inUnitId := 8457, inGoodsGroupId := 0,inGoodsId := 8457, inSession:= zfCalc_UserAdmin()) where goodsid = 2157 --3713924
