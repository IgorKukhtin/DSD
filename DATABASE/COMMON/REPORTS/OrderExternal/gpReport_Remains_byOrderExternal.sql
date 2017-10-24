-- Function: gpReport_OrderExternal()

DROP FUNCTION IF EXISTS gpReport_Remains_byOrderExternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Remains_byOrderExternal(
    IN inMovementId         Integer   , -- 
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (FromCode Integer, FromName TVarChar
             , GoodsCode_Main Integer, GoodsName_Main TVarChar, GoodsKindName_Main  TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName  TVarChar
             , MeasureName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , PartionGoods TVarChar
             , Amount             TFloat
             , AmountSecond       TFloat
             , Amount_Prev        TFloat
             , AmountSecond_Prev  TFloat
             , Amount_Next        TFloat
             , AmountSecond_Next  TFloat
             , Remains_8457       TFloat
             , Remains_8446       TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbFromId Integer;
BEGIN
     -- определяется
     SELECT Movement.OperDate
          , ObjectLink_Juridical_Retail.ChildObjectId --  берем торг.сеть  вместо покупателя  -MovementLinkObject_From.ObjectId
           INTO vbOperDate, vbFromId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId --Object_Partner.Id
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
 
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
     WHERE Movement.Id = inMovementId;

     RETURN QUERY
     WITH 
            -- хардкодим - ЦЕХ колбаса+дел-сы (производство)
            tmpUnit_CEH AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect_Object_Unit_byGroup)
            -- хардкодим - Склады База + Реализации
          , tmpUnit_SKLAD   AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect_Object_Unit_byGroup)
            -- хардкодим - Склады База + Реализации
          , tmpUnit_all   AS (SELECT UnitId FROM tmpUnit_CEH UNION SELECT UnitId FROM tmpUnit_SKLAD)

            -- данные - наша Заявка
          , tmpMI AS(SELECT vbFromId                                      AS FromId
                           , MovementItem.ObjectId                         AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) AS Amount
                      FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                       ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     )
            -- поиск рецептур - что из чего делается
          , tmpReceipt AS (SELECT tmpGoods.GoodsId, tmpGoods.GoodsKindId
                                  -- нашли Рецепт - Цех (т.е. в приходе ПФ_ГП, в расходе СЫРЬЕ)
                                , CASE WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_0.ChildObjectId
                                       WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_1.ChildObjectId
                                       WHEN ObjectLink_Receipt_GoodsKind_Parent_2.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_2.ChildObjectId
                                       WHEN ObjectLink_Receipt_GoodsKind_Parent_3.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_3.ChildObjectId
                                  END AS ReceiptId_basis

                                  -- нашли Рецепт - какой товар идет На Упаковку (т.е. в приходе ВЕС, в расходе ПФ_ГП)
                                , CASE WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                            THEN ObjectLink_Receipt_Parent_0.ChildObjectId
                                       ELSE 0 -- т.е. этот товар НЕ идет через упаковку, или уровней больше чем надо
                                  END AS ReceiptId_pack

                                  -- Главный рецепт - информативно
                                , Object_Receipt.Id AS ReceiptId

                           FROM tmpMI AS tmpGoods
                                -- Рецепт для Товара из заявки, т.е. из чего он делается (как правило это Упаковка)
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                     ON ObjectLink_Receipt_Goods.ChildObjectId = tmpGoods.GoodsId
                                                    AND ObjectLink_Receipt_Goods.DescId        = zc_ObjectLink_Receipt_Goods()
                                INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                      ON ObjectLink_Receipt_GoodsKind.ObjectId      = ObjectLink_Receipt_Goods.ObjectId
                                                     AND ObjectLink_Receipt_GoodsKind.DescId        = zc_ObjectLink_Receipt_GoodsKind()
                                                     AND ObjectLink_Receipt_GoodsKind.ChildObjectId = tmpGoods.GoodsKindId
                                INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_Receipt_Goods.ObjectId
                                                                   AND Object_Receipt.isErased = FALSE
                                -- Только Главный рецепт
                                INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                         ON ObjectBoolean_Main.ObjectId  = Object_Receipt.Id
                                                        AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_Receipt_Main()
                                                        AND ObjectBoolean_Main.ValueData = TRUE

                                -- Поднялись на 0 уровень - т.е. из чего делается Товар для Упаковки (как правило это уже ВЕС из ПФ_ГП)
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_0
                                                     ON ObjectLink_Receipt_Parent_0.ObjectId = Object_Receipt.Id
                                                    AND ObjectLink_Receipt_Parent_0.DescId   = zc_ObjectLink_Receipt_Parent()
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_0
                                                     ON ObjectLink_Receipt_GoodsKind_Parent_0.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                    AND ObjectLink_Receipt_GoodsKind_Parent_0.DescId   = zc_ObjectLink_Receipt_GoodsKind()
  
                                -- Поднялись на 1 уровень - т.е. из чего делается ПФ_ГП (как правило это ЦЕХ и делается из СЫРЬЯ)
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_1
                                                     ON ObjectLink_Receipt_Parent_1.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                    AND ObjectLink_Receipt_Parent_1.DescId   = zc_ObjectLink_Receipt_Parent()
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_1
                                                     ON ObjectLink_Receipt_GoodsKind_Parent_1.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                    AND ObjectLink_Receipt_GoodsKind_Parent_1.DescId   = zc_ObjectLink_Receipt_GoodsKind()
  
                                -- Поднялись на 2 уровень - т.е. если предыдущий это НЕ Цех
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_2
                                                     ON ObjectLink_Receipt_Parent_2.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                    AND ObjectLink_Receipt_Parent_2.DescId   = zc_ObjectLink_Receipt_Parent()
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_2
                                                     ON ObjectLink_Receipt_GoodsKind_Parent_2.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                    AND ObjectLink_Receipt_GoodsKind_Parent_2.DescId   = zc_ObjectLink_Receipt_GoodsKind()
  
                                -- Поднялись на 3 уровень - т.е. если предыдущий это НЕ Цех
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_3
                                                     ON ObjectLink_Receipt_Parent_3.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                    AND ObjectLink_Receipt_Parent_3.DescId   = zc_ObjectLink_Receipt_Parent()
                                LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_3
                                                     ON ObjectLink_Receipt_GoodsKind_Parent_3.ObjectId = ObjectLink_Receipt_Parent_3.ChildObjectId
                                                    AND ObjectLink_Receipt_GoodsKind_Parent_3.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                          )
            -- здесь уже товары - что из чего делается
          , tmpGoodsBasis AS (SELECT tmpReceipt.GoodsId
                                   , tmpReceipt.GoodsKindId
                                   , tmpReceipt.ReceiptId

                                   , tmpReceipt.ReceiptId_basis                 AS ReceiptId_basis
                                   , ObjectLink_Receipt_Goods.ChildObjectId     AS GoodsId_Basis
                                   , ObjectLink_Receipt_GoodsKind.ChildObjectId AS GoodsKindId_Basis

                                   , tmpReceipt.ReceiptId_pack                       AS ReceiptId_pack
                                   , ObjectLink_Receipt_Goods_pack.ChildObjectId     AS GoodsKindId_pack
                                   , ObjectLink_Receipt_GoodsKind_pack.ChildObjectId AS GoodsKindId_pack
                              FROM tmpReceipt
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                        ON ObjectLink_Receipt_Goods.ObjectId = tmpReceipt.ReceiptId_basis
                                                       AND ObjectLink_Receipt_Goods.DescId   = zc_ObjectLink_Receipt_Goods()
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                        ON ObjectLink_Receipt_GoodsKind.ObjectId = tmpReceipt.ReceiptId_basis
                                                       AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_pack
                                                        ON ObjectLink_Receipt_Goods_pack.ObjectId = tmpReceipt.ReceiptId_pack
                                                       AND ObjectLink_Receipt_Goods_pack.DescId   = zc_ObjectLink_Receipt_Goods()
                                   LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_pack
                                                        ON ObjectLink_Receipt_GoodsKind_pack.ObjectId = tmpReceipt.ReceiptId_pack
                                                       AND ObjectLink_Receipt_GoodsKind_pack.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                             )
                             
            -- список товаров - по ним получим Остатки на Складе + в Цехе
          , tmpGoods AS (SELECT DISTINCT tmpMI.GoodsId                 AS GoodsId FROM tmpMI
                        UNION 
                         SELECT DISTINCT tmpGoodsBasis.GoodsBasisId     AS GoodsId FROM tmpGoodsBasis 
                        UNION 
                         SELECT DISTINCT tmpGoodsBasis.GoodsKindId_pack AS GoodsId FROM tmpGoodsBasis 
                         )
            -- остатки на НАЧАЛО ДНЯ - на Складе + в Цехе
          , tmpRemains_All AS (SELECT Container.Id         AS ContainerId
                                    , CLO_Unit.ObjectId    AS UnitId
                                    , tmpGoods.GoodsId     AS GoodsId
                                    , COALESCE (MIContainer.ObjectIntId_Analyzer, 0) AS GoodsKindId
--                                    , Container.Amount      AS Amount
                                    , Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount
                               FROM tmpGoods
                                    INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                                        AND Container.DescId   = zc_Container_Count()
                                                        -- AND Container.Amount <> 0
                                    INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                   ON CLO_Unit.ContainerId = Container.Id
                                                                  AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                    INNER JOIN tmpUnit_all ON tmpUnit_all.UnitId = CLO_Unit.ObjectId

                                    LEFT JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.ContainerId = Container.Id
                                                                   AND MIContainer.OperDate >= vbOperDate
                                                                                     
                                    -- LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                    --                               ON CLO_GoodsKind.ContainerId = Container.Id
                                    --                              AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                    LEFT JOIN ContainerLinkObject AS CLO_Account
                                                                  ON CLO_Account.ContainerId = Container.Id
                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                               WHERE CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                               GROUP BY Container.Id
                                      , CLO_Unit.ObjectId 
                                      , tmpGoods.GoodsId
                                      , MIContainer.ObjectIntId_Analyzer
                                      , Container.Amount
                               HAVING  Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) <> 0
                              )
                              
            -- остатки на НАЧАЛО ДНЯ - в Цехе
          , tmpRemains_CEH AS (SELECT tmpRemains_All.GoodsId
                                    , tmpRemains_All.GoodsKindId
                                    , tmpRemains_All.UnitId   AS FromId
                                    , COALESCE (ContainerLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                                    , SUM (tmpRemains_All.Amount) AS Amount
                               FROM tmpRemains_All
                                    INNER JOIN tmpUnit_CEH  ON tmpUnit_CEH.UnitId = tmpRemains_All.UnitId
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_PartionGoods
                                                                  ON ContainerLO_PartionGoods.ContainerId = tmpRemains_All.ContainerId
                                                                 AND ContainerLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                               GROUP BY tmpRemains_All.GoodsId
                                      , tmpRemains_All.GoodsKindId
                                      , tmpRemains_All.UnitId
                                      , COALESCE (ContainerLO_PartionGoods.ObjectId, 0)
                              )
            -- остатки на НАЧАЛО ДНЯ - на Складе
          , tmpRemains_SKLAD AS (SELECT tmpRemains_All.GoodsId
                                      , tmpRemains_All.GoodsKindId
                                      , tmpRemains_All.UnitId       AS FromId
                                      , SUM (tmpRemains_All.Amount) AS Amount
                                 FROM tmpRemains_All
                                      INNER JOIN tmpUnit_SKLAD ON tmpUnit_SKLAD.UnitId = tmpRemains_All.UnitId
                                      -- INNER JOIN tmpMI ON tmpMI.GoodsId      = tmpRemains_All.GoodsId
                                      --                 AND tmpMI.GoodsKindId  = tmpRemains_All.GoodsKindId
                                 GROUP BY tmpRemains_All.GoodsId
                                        , tmpRemains_All.GoodsKindId
                                        , tmpRemains_All.UnitId
                                )
            -- ВСЕ Заявки от Покупателя - только Документы
          , tmpOrderExternal AS (SELECT MovementLinkObject_From.ObjectId    AS FromId
                                      , Movement.Id                         AS MovementId
                                      , Movement.OperDate 
                                 FROM Movement
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                 WHERE Movement.OperDate BETWEEN vbOperDate - INTERVAL '1 DAY' AND vbOperDate
                                   AND Movement.DescId   = zc_Movement_OrderExternal()
                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                   AND Movement.Id       <> inMovementId
                                )
            -- ВСЕ Заявки от Покупателя - Товары
          , tmpOrderExternal_MI AS (SELECT Movement.FromId         AS FromId
                                         , Movement.OperDate       AS OperDate
                                         -- , MovementItem.Id         AS MovementItemId
                                         , MovementItem.ObjectId   AS GoodsId
                                         , COALESCE (MILinkObject_GoodsKind.GoodsKindId, 0) AS GoodsKindId
                                         , MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) AS Amount
          
                                    FROM tmpOrderExternal AS Movement
                                         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.MovementId
                                                                AND MovementItem.DescId     = zc_MI_Master()
                                                                AND MovementItem.isErased   = False
                                         INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                         AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                         LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                     ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
                                   )
                                    
          /*, tmpGoodsKind AS (SELECT MILinkObject_GoodsKind.*
                             FROM MovementItemLinkObject AS MILinkObject_GoodsKind
                             WHERE MILinkObject_GoodsKind.MovementItemId IN (SELECT DISTINCT tmpOrderExternal_MI.MovementItemId FROM tmpOrderExternal_MI)
                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             )
               
          , tmpMIFloat_AmountSecond AS (SELECT MIFloat_AmountSecond.*
                             FROM MovementItemFloat AS MIFloat_AmountSecond
                             WHERE MIFloat_AmountSecond.MovementItemId IN (SELECT DISTINCT tmpOrderExternal_MI.MovementItemId FROM tmpOrderExternal_MI)
                               AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                             )*/

            -- ВСЕ Заявки от Покупателя - собрали по 2-м периодам
          , tmpOrderExternal_Its AS (SELECT Movement.FromId                               AS FromId
                                          , Movement.GoodsId                              AS GoodsId
                                          , Movement.GoodsKindId                          AS GoodsKindId
                                          , SUM (CASE WHEN Movement.OperDate = vbOperDate - INTERVAL '1 DAY' THEN Movement.Amount ELSE 0 END) AS Amount_Prev
                                          , SUM (CASE WHEN Movement.OperDate >= vbOperDate THEN Movement.Amount ELSE 0 END)                   AS Amount_Next
                                     FROM tmpOrderExternal_MI AS Movement
                                           /*INNER JOIN tmpGoodsKind AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = Movement.MovementItemId
                                                                  AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = COALESCE (Movement.GoodsKindId, 0)
                                           LEFT JOIN tmpMIFloat_AmountSecond AS MIFloat_AmountSecond
                                                                             ON MIFloat_AmountSecond.MovementItemId = Movement.MovementItemId*/
                                     GROUP BY Movement.FromId
                                            , Movement.GoodsId 
                                            , Movement.GoodsKindId
                                    )
            -- ВСЯ ИНФА
          , tmpData AS (SELECT tmp.GoodsId
                             , tmp.GoodsKindId
                             , tmp.GoodsId_Main
                             , tmp.GoodsKindId_Main
                             , tmp.FromId
                             , tmp.PartionGoods
                             , SUM (tmp.Amount)             AS Amount
                             , SUM (tmp.AmountSecond)       AS AmountSecond
                             , SUM (tmp.Amount_Prev)        AS Amount_Prev
                             , SUM (tmp.AmountSecond_Prev)  AS AmountSecond_Prev
                             , SUM (tmp.Amount_Next)        AS Amount_Next
                             , SUM (tmp.AmountSecond_Next)  AS AmountSecond_Next
                             , SUM (tmp.Remains_8457)       AS Remains_8457
                             , SUM (tmp.Remains_8446)       AS Remains_8446
                             
                        FROM (-- Текущая заявка
                              SELECT tmp.GoodsId         AS GoodsId
                                   , tmp.GoodsKindId     AS GoodsKindId
                                   , 0                   AS GoodsId_Main
                                   , 0                   AS GoodsKindId_Main
                                   , tmp.FromId          AS FromId
                                   , tmp.Amount          AS Amount
                                   , tmp.AmountSecond    AS AmountSecond
                                   , 0                   AS Amount_Prev
                                   , 0                   AS AmountSecond_Prev
                                   , 0                   AS Amount_Next
                                   , 0                   AS AmountSecond_Next
                                   , 0                   AS Remains_8457
                                   , 0                   AS Remains_8446
                                   , NULL ::TVarChar       AS PartionGoods
                              FROM tmpMI AS tmp
                            UNION 
                              -- ВСе заявки
                              SELECT tmp.GoodsId           AS GoodsId
                                   , tmp.GoodsKindId       AS GoodsKindId
                                   , 0                     AS GoodsId_Main
                                   , 0                     AS GoodsKindId_Main
                                   , tmp.FromId            AS FromId
                                   , 0                     AS Amount
                                   , 0                     AS AmountSecond
                                   , tmp.Amount_Prev       AS Amount_Prev
                                   , tmp.AmountSecond_Prev AS AmountSecond_Prev
                                   , tmp.Amount_Next       AS Amount_Next
                                   , tmp.AmountSecond_Next AS AmountSecond_Next
                                   , 0                     AS Remains_8457
                                   , 0                     AS Remains_8446
                                   , NULL ::TVarChar       AS PartionGoods
                              FROM tmpOrderExternal_Its AS tmp
                            UNION 
                              -- Остаток - Склад
                              SELECT tmp.GoodsId           AS GoodsId
                                   , tmp.GoodsKindId       AS GoodsKindId
                                   , 0                     AS GoodsId_Main
                                   , 0                     AS GoodsKindId_Main
                                   , tmp.FromId            AS FromId
                                   , 0                     AS Amount
                                   , 0                     AS AmountSecond
                                   , 0                     AS Amount_Prev
                                   , 0                     AS AmountSecond_Prev
                                   , 0                     AS Amount_Next
                                   , 0                     AS AmountSecond_Next
                                   , tmp.Amount            AS Remains_8457
                                   , 0                     AS Remains_8446
                                   , NULL ::TVarChar       AS PartionGoods
                              FROM tmpRemains_SKLAD AS tmp
                            UNION 
                              -- Остаток - Цех
                              SELECT tmp.GoodsId           AS GoodsId
                                   , tmp.GoodsKindId       AS GoodsKindId
                                   , tmp.GoodsId           AS GoodsId_Main
                                   , tmp.GoodsKindId       AS GoodsKindId_Main
                                   , tmp.FromId            AS FromId
                                   , 0                     AS Amount
                                   , 0                     AS AmountSecond
                                   , 0                     AS Amount_Prev
                                   , 0                     AS AmountSecond_Prev
                                   , 0                     AS Amount_Next
                                   , 0                     AS AmountSecond_Next
                                   , 0                     AS Remains_8457
                                   , tmp.Amount            AS Remains_8446
                                   , Object_PartionGoods.ValueData AS PartionGoods
                              FROM tmpRemains_CEH AS tmp
                                   LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmp.PartionGoodsId
                              ) AS tmp
                        GROUP BY tmp.GoodsId
                               , tmp.GoodsKindId
                               , tmp.GoodsId_Main
                               , tmp.GoodsKindId_Main
                               , tmp.FromId
                               , tmp.PartionGoods
                       )
      , tmpRetail AS (SELECT tmpData.FromId
                           , COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0 /*tmpData.FromId*/)     AS RetailId
                      FROM (SELECT DISTINCT tmpData.FromId FROM tmpData) AS tmpData
                           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                ON ObjectLink_Partner_Juridical.ObjectId = tmpData.FromId
                                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                      )         
      , tmpData_Retail AS (SELECT tmpRetail.RetailId                AS FromId
                                , tmpData.GoodsId                   AS GoodsId
                                , tmpData.GoodsKindId               AS GoodsKindId
                                , tmpData.PartionGoods              AS PartionGoods
                                , tmpData.GoodsId_Main              AS GoodsId_Main
                     
                                , SUM (tmpData.Amount)              AS Amount
                                , SUM (tmpData.AmountSecond)        AS AmountSecond
                                , SUM (tmpData.Amount_Prev)         AS Amount_Prev
                                , SUM (tmpData.AmountSecond_Prev)   AS AmountSecond_Prev
                                , SUM (tmpData.Amount_Next)         AS Amount_Next
                                , SUM (tmpData.AmountSecond_Next)   AS AmountSecond_Next
                                , SUM (tmpData.Remains_8457)        AS Remains_8457
                                , SUM (tmpData.Remains_8446)        AS Remains_8446
                           FROM tmpData
                                LEFT JOIN tmpRetail ON tmpRetail.FromId = tmpData.FromId
                           GROUP By tmpRetail.RetailId
                                  , tmpData.GoodsId
                                  , tmpData.GoodsKindId
                                  , tmpData.PartionGoods
                                  , tmpData.GoodsId_Main
                           )
                       
      -- Результат
       SELECT Object_From.ObjectCode                     AS FromCode
            , COALESCE (Object_From.ValueData, 'НЕТ Сети') :: TVarChar AS FromName
            
            , Object_GoodsBasis.ObjectCode               AS GoodsCode_Main
            , Object_GoodsBasis.ValueData                AS GoodsName_Main
            , Object_GoodsKindBasis.ValueData            AS GoodsKindName_Main

            , Object_Goods.ObjectCode                    AS GoodsCode
            , Object_Goods.ValueData                     AS GoodsName
            , Object_GoodsKind.ValueData                 AS GoodsKindName
            
            , Object_Measure.ValueData                   AS MeasureName
            , Object_GoodsGroup.ValueData                AS GoodsGroupName
            , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
            
            , tmpData.PartionGoods             ::TVarChar
 
            , tmpData.Amount                   :: TFloat AS OrderAmount
            , tmpData.AmountSecond             :: TFloat AS OrderAmountSecond
                                               
            , tmpData.Amount_Prev              :: TFloat
            , tmpData.AmountSecond_Prev        :: TFloat
            , tmpData.Amount_Next              :: TFloat
            , tmpData.AmountSecond_Next        :: TFloat
            , tmpData.Remains_8457             :: TFloat
            , tmpData.Remains_8446             :: TFloat
                                      
       FROM tmpData_Retail AS tmpData
          LEFT JOIN tmpGoodsBasis ON tmpGoodsBasis.GoodsId = tmpData.GoodsId
          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.FromId
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId
          
          LEFT JOIN Object AS Object_GoodsBasis ON Object_GoodsBasis.Id = COALESCE (tmpGoodsBasis.GoodsBasisId, tmpData.GoodsId_Main)
          LEFT JOIN Object AS Object_GoodsKindBasis ON Object_GoodsKindBasis.Id = COALESCE (tmpGoodsBasis.GoodsKindId, tmpData.GoodsKindId)
          
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                                
          ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.10.17         *
*/

-- тест
-- SELECT * FROM gpReport_Remains_byOrderExternal (inMovementId:= 4944965 , inSession:= zfCalc_UserAdmin())
 --select * from gpReport_Remains_byOrderExternal(inMovementId := 7278777 ,  inSession := '5'::TVarChar);