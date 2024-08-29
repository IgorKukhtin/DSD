-- Function: gpReport_GoodsMI_ProductionUnion_TaxExit () - <Производство и процент выхода (итоги) or (детально)>

DROP FUNCTION IF EXISTS gpReport_GoodsMI_ProductionUnion_TaxExit (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_ProductionUnion_TaxExit (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inFromId       Integer   , 
    IN inToId         Integer   , 
    IN inIsDetail     Boolean   , -- 
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName_Complete TVarChar, MeasureName TVarChar
             , PartionGoodsDate TDateTime
             , Amount_WorkProgress_in TFloat
             , CuterCount TFloat
             , RealWeight TFloat
             , RealWeightMsg TFloat
             , Amount_GP_in_calc TFloat
             , Amount_GP_in TFloat
             , AmountReceipt_out TFloat
             , TaxExit TFloat
             , TaxExit_calc TFloat
             , TaxExit_real TFloat
             , TaxLoss TFloat
             , TaxLoss_calc TFloat
             , TaxLoss_real TFloat
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- !!!Нет прав!!! - Ограничение - нет доступа к Отчету производства выхода ГП Итоги
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11190560)
        -- Дільниця термічної обробки
        AND (inFromId IN (8450) OR inToId IN (8450))
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав.';
     END IF;


    -- Результат
    RETURN QUERY
         
    WITH -- приходы п/ф ГП
         tmpMI_WorkProgress_in AS
                     (SELECT MIContainer.MovementId                  AS MovementId
                           , MIContainer.MovementItemId              AS MovementItemId
                           , MIContainer.ContainerId                 AS ContainerId
                           , MIContainer.ObjectId_Analyzer           AS GoodsId
                           , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                           , CASE WHEN MIContainer.IsActive = TRUE THEN MIContainer.Amount ELSE 0 END AS Amount
                      FROM MovementItemContainer AS MIContainer
                           /*INNER JOIN ContainerLinkObject AS CLO_GoodsKind
                                                          ON CLO_GoodsKind.ContainerId = MIContainer.ContainerId
                                                         AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                                         AND CLO_GoodsKind.ObjectId = zc_GoodsKind_WorkProgress() -- ограничение что это п/ф ГП*/
                           LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                         ON CLO_PartionGoods.ContainerId = MIContainer.ContainerId
                                                        AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                           LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                                     ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                    AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                                    AND MovementBoolean_Peresort.ValueData = TRUE
                      WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                        AND MIContainer.DescId = zc_MIContainer_Count()
                        --
                        AND MIContainer.WhereObjectId_Analyzer = inFromId
                        -- еще условие
                        AND MIContainer.ObjectExtId_Analyzer   = inFromId
                        --
                        AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                        AND MIContainer.IsActive = TRUE
                        AND MIContainer.Amount <> 0
                        -- !!!убрали Пересортицу!!!
                        AND MovementBoolean_Peresort.MovementId IS NULL
                        --
                        AND (MIContainer.ObjectIntId_Analyzer IN (zc_GoodsKind_WorkProgress(), zc_GoodsKind_Basis()) -- ограничение что это п/ф ГП
                              -- !!!захардкодил!!!
                          /*OR (MIContainer.WhereObjectId_Analyzer = 951601 -- ЦЕХ упаковки мясо
                          AND MIContainer.AnalyzerId             = 951601 -- ЦЕХ упаковки мясо
                            )*/)
                      )
         -- расходы п/ф ГП - что б отловить партии которых нет в tmpMI_WorkProgress_in
       , tmpMI_WorkProgress_find AS
                     (SELECT MIContainer.ContainerId                 AS ContainerId
                           , MIContainer.ObjectId_Analyzer           AS GoodsId
                           , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
                           , COALESCE (MIContainer.ObjectIntId_Analyzer, zc_GoodsKind_Basis()) AS GoodsKindId_Complete
                      FROM ObjectDate AS ObjectDate_PartionGoods_Value
                           INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                          ON CLO_PartionGoods.ObjectId = ObjectDate_PartionGoods_Value.ObjectId
                                                         AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                           INNER JOIN ContainerLinkObject AS CLO_Unit
                                                          ON CLO_Unit.ContainerId = CLO_PartionGoods.ContainerId
                                                         AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                         AND CLO_Unit.ObjectId = inFromId
                           INNER JOIN Container ON Container.Id = CLO_PartionGoods.ContainerId AND Container.DescId = zc_Container_Count()
                           LEFT JOIN tmpMI_WorkProgress_in ON tmpMI_WorkProgress_in.ContainerId = CLO_PartionGoods.ContainerId

                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = Container.Id
                                                           AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                           AND MIContainer.IsActive = FALSE
                                                           AND MIContainer.Amount <> 0
                           LEFT JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId
                           /*LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.ParentId
                                                           AND MILinkObject_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()*/
                      WHERE ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
                        AND ObjectDate_PartionGoods_Value.ValueData BETWEEN inStartDate AND inEndDate
                        AND tmpMI_WorkProgress_in.ContainerId IS NULL
                      GROUP BY MIContainer.ContainerId
                             , MIContainer.ObjectId_Analyzer
                             , CLO_PartionGoods.ObjectId
                             , MIContainer.ObjectIntId_Analyzer
                     )
         -- приходы п/ф ГП - сгруппировать
       , tmpMI_WorkProgress_in_group AS (SELECT ContainerId, GoodsId, PartionGoodsId FROM tmpMI_WorkProgress_in GROUP BY ContainerId, GoodsId, PartionGoodsId
                                   UNION SELECT ContainerId, GoodsId, PartionGoodsId FROM tmpMI_WorkProgress_find GROUP BY ContainerId, GoodsId, PartionGoodsId)
         -- расходы п/ф ГП в разрезе ParentId
       , tmpMI_WorkProgress_out AS
                     (SELECT MIContainer.ParentId
                           , tmpMI_WorkProgress_in_group.ContainerId
                           -- , 0 AS ContainerId
                           , tmpMI_WorkProgress_in_group.GoodsId
                           , tmpMI_WorkProgress_in_group.PartionGoodsId
                           , SUM (MIContainer.Amount) AS Amount
                      FROM tmpMI_WorkProgress_in_group
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = tmpMI_WorkProgress_in_group.ContainerId
                                                           AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                           AND MIContainer.IsActive = FALSE
                     GROUP BY MIContainer.ParentId
                            , tmpMI_WorkProgress_in_group.ContainerId
                            , tmpMI_WorkProgress_in_group.GoodsId
                            , tmpMI_WorkProgress_in_group.PartionGoodsId
                     )
         -- подразделения из группы 
       , tmpUnit_oth AS (-- "Участок мясного сырья", но исключения - !!!захардкодил!!!
                         SELECT tmpSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8439) AS tmpSelect
                         WHERE inFromId NOT IN (951601, 981821) -- ЦЕХ упаковки мясо + ЦЕХ шприц. мясо
                           AND tmpSelect.UnitId NOT IN (133049)-- "Склад реализации мясо"
                           /*AND (tmpSelect.UnitId NOT IN (133049)-- "Склад реализации мясо"
                             OR (inFromId         = 8448    -- ЦЕХ деликатесов
                             AND tmpSelect.UnitId = 133049) -- Склад реализации мясо
                               )*/
                           
                        UNION
                         -- "ЦЕХ колбаса+дел-сы"
                         SELECT tmpSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS tmpSelect
                        UNION
                         -- "ЦЕХ колбаса + деликатесы (Ирна)"
                         SELECT 8020711 AS UnitId
                        )
         -- расходы п/ф ГП в разрезе ParentId - если они ушли на "переработку"
       , tmpMI_WorkProgress_oth AS
                     (SELECT tmpMI_WorkProgress_out.ContainerId
                           , -1 * SUM (tmpMI_WorkProgress_out.Amount) AS Amount
                      FROM tmpMI_WorkProgress_out
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.Id = tmpMI_WorkProgress_out.ParentId
                           INNER JOIN tmpUnit_oth ON tmpUnit_oth.UnitId = MIContainer.WhereObjectId_Analyzer
                     GROUP BY tmpMI_WorkProgress_out.ContainerId
                     )
         -- приходы ГП в разрезе GoodsId (п/ф ГП) + GoodsKindId_Complete + !!!если "производство ГП"!!!
       , tmpMI_GP_in AS
                     (SELECT tmpMI_WorkProgress_out.GoodsId
                           , tmpMI_WorkProgress_out.PartionGoodsId
                           , COALESCE (MIContainer.ObjectIntId_Analyzer, zc_GoodsKind_Basis()) AS GoodsKindId_Complete
                           , SUM (MIContainer.Amount)             AS Amount
                           , SUM (CASE WHEN ObjectFloat_Value_master.ValueData <> 0 THEN COALESCE (ObjectFloat_Value_child.ValueData, 0) * MIContainer.Amount / ObjectFloat_Value_master.ValueData ELSE 0 END) AS AmountReceipt
                           , MAX (MIContainer.ContainerId) AS ContainerId_test
                      FROM tmpMI_WorkProgress_out
                           INNER JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.Id = tmpMI_WorkProgress_out.ParentId
                                                           AND MIContainer.WhereObjectId_Analyzer <> inFromId -- !!!если "производство ГП"!!!
                           /*LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                         ON CLO_GoodsKind.ContainerId = MIContainer.ContainerId
                                                        AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()*/
                           LEFT JOIN MovementItemLinkObject AS MILO_Receipt
                                                            ON MILO_Receipt.MovementItemId = MIContainer.MovementItemId
                                                           AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Value_master
                                                 ON ObjectFloat_Value_master.ObjectId = MILO_Receipt.ObjectId
                                                AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                           LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent
                                                ON ObjectLink_Receipt_Parent.ObjectId = MILO_Receipt.ObjectId
                                               AND ObjectLink_Receipt_Parent.DescId = zc_ObjectLink_Receipt_Parent()
                           LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_parent
                                                ON ObjectLink_Receipt_Goods_parent.ObjectId = ObjectLink_Receipt_Parent.ChildObjectId
                                               AND ObjectLink_Receipt_Goods_parent.DescId = zc_ObjectLink_Receipt_Goods()

                           LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = MILO_Receipt.ObjectId
                                               AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                           INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                 ON ObjectLink_ReceiptChild_Goods.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                                                AND ObjectLink_ReceiptChild_Goods.ChildObjectId = ObjectLink_Receipt_Goods_parent.ChildObjectId -- !!!т.е. товар - тот же самый!!!
                           INNER JOIN ObjectFloat AS ObjectFloat_Value_child
                                                  ON ObjectFloat_Value_child.ObjectId = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                 AND ObjectFloat_Value_child.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                 AND ObjectFloat_Value_child.ValueData <> 0

                        /*LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                             ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId*/

                      /*WHERE ObjectLink_ReceiptChild_Goods.ChildObjectId = ObjectLink_Receipt_Goods_parent.ChildObjectId
                         OR (inFromId = 951601 -- ЦЕХ упаковки мясо
                             AND Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                            )*/
                      GROUP BY tmpMI_WorkProgress_out.GoodsId
                             , tmpMI_WorkProgress_out.PartionGoodsId
                             , MIContainer.ObjectIntId_Analyzer

                     )
         -- результат - группируется
       , tmpMI_WorkProgress_in_gr AS
                     (SELECT tmpMI_WorkProgress_in.ContainerId
                           , tmpMI_WorkProgress_in.GoodsId
                           , tmpMI_WorkProgress_in.PartionGoodsId
                           , STRING_AGG (tmpMI_WorkProgress_in.MovementId :: TVarChar, ';') AS MovementId
                           , COALESCE (MILO_GoodsKindComplete.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId_Complete

                           , COALESCE (ObjectFloat_TaxExit.ValueData, 0)        AS TaxExit
                           , COALESCE (ObjectFloat_TotalWeight.ValueData, 0)    AS TotalWeight

                           , SUM (tmpMI_WorkProgress_in.Amount)                 AS Amount
                           , SUM (COALESCE (MIFloat_CuterCount.ValueData, 0))   AS CuterCount
                           , SUM (COALESCE (MIFloat_RealWeight.ValueData, 0))   AS RealWeight
                           , SUM (COALESCE (MIFloat_RealWeightMsg.ValueData,0)) AS RealWeightMsg

                           , MAX (COALESCE (MIString_Comment.ValueData, ''))    AS Comment

                      FROM tmpMI_WorkProgress_in
                           LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                       ON MIFloat_CuterCount.MovementItemId = tmpMI_WorkProgress_in.MovementItemId
                                                      AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                           LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                                       ON MIFloat_RealWeight.MovementItemId = tmpMI_WorkProgress_in.MovementItemId
                                                      AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()
                           LEFT JOIN MovementItemFloat AS MIFloat_RealWeightMsg
                                                       ON MIFloat_RealWeightMsg.MovementItemId = tmpMI_WorkProgress_in.MovementItemId
                                                      AND MIFloat_RealWeightMsg.DescId = zc_MIFloat_RealWeightMsg()

                           LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                                            ON MILO_GoodsKindComplete.MovementItemId = tmpMI_WorkProgress_in.MovementItemId
                                                           AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                           LEFT JOIN MovementItemLinkObject AS MILO_Receipt
                                                            ON MILO_Receipt.MovementItemId = tmpMI_WorkProgress_in.MovementItemId
                                                           AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
                           LEFT JOIN MovementItemString AS MIString_Comment
                                                        ON MIString_Comment.MovementItemId = tmpMI_WorkProgress_in.MovementItemId
                                                       AND MIString_Comment.DescId = zc_MIString_Comment()

                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit
                                                 ON ObjectFloat_TaxExit.ObjectId = MILO_Receipt.ObjectId
                                                AND ObjectFloat_TaxExit.DescId = zc_ObjectFloat_Receipt_TaxExit()
                           LEFT JOIN ObjectFloat AS ObjectFloat_TotalWeight
                                                 ON ObjectFloat_TotalWeight.ObjectId = MILO_Receipt.ObjectId
                                                AND ObjectFloat_TotalWeight.DescId = zc_ObjectFloat_Receipt_TotalWeight()
                      GROUP BY tmpMI_WorkProgress_in.ContainerId
                             , tmpMI_WorkProgress_in.GoodsId
                             , tmpMI_WorkProgress_in.PartionGoodsId
                             , COALESCE (MILO_GoodsKindComplete.ObjectId, zc_GoodsKind_Basis())
                             , COALESCE (ObjectFloat_TaxExit.ValueData, 0)
                             , COALESCE (ObjectFloat_TotalWeight.ValueData, 0)
                     )

         -- результат - группируется
       , tmpResult AS
                     (SELECT tmp.GoodsId
                           , tmp.PartionGoodsId
                           , tmp.GoodsKindId_Complete
                           , SUM (tmp.Amount_WorkProgress_in) AS Amount_WorkProgress_in
                           , SUM (tmp.CuterCount)             AS CuterCount
                           , SUM (tmp.RealWeight)             AS RealWeight
                           , SUM (tmp.RealWeightMsg)          AS RealWeightMsg
                           , SUM (tmp.Amount_GP_in_calc)      AS Amount_GP_in_calc
                           , SUM (tmp.Amount_GP_in)           AS Amount_GP_in
                           , SUM (tmp.AmountReceipt_out)      AS AmountReceipt_out
                           , SUM (tmp.calcIn)                 AS calcIn
                           , SUM (tmp.calcOut)                AS calcOut
                           , MAX (tmp.TaxExit)                AS TaxExit
                           , MAX (tmp.Comment)                AS Comment
                           , MAX (tmp.MovementId)             AS MovementId
                      FROM
                     (-- Производство п/ф ГП
                      SELECT tmpMI_WorkProgress_in.GoodsId
                           , tmpMI_WorkProgress_in.PartionGoodsId
                           , tmpMI_WorkProgress_in.GoodsKindId_Complete
                           , SUM (tmpMI_WorkProgress_in.Amount)        AS Amount_WorkProgress_in
                           , SUM (tmpMI_WorkProgress_in.CuterCount)    AS CuterCount
                           , SUM (tmpMI_WorkProgress_in.RealWeight)    AS RealWeight
                           , SUM (tmpMI_WorkProgress_in.RealWeightMsg) AS RealWeightMsg
                           , SUM (CASE WHEN tmpMI_WorkProgress_in.TotalWeight <> 0
                                            THEN (tmpMI_WorkProgress_in.Amount - COALESCE (tmpMI_WorkProgress_oth.Amount, 0)) * tmpMI_WorkProgress_in.TaxExit / tmpMI_WorkProgress_in.TotalWeight
                                       ELSE 0
                                  END)                                          AS Amount_GP_in_calc
                           , AVG (tmpMI_WorkProgress_in.TaxExit)  AS TaxExit
                           , SUM (tmpMI_WorkProgress_in.CuterCount * tmpMI_WorkProgress_in.TaxExit)     AS calcIn
                           , SUM (tmpMI_WorkProgress_in.CuterCount * tmpMI_WorkProgress_in.TotalWeight) AS calcOut
                           , MAX (tmpMI_WorkProgress_in.Comment)  AS Comment
                           , 0                                    AS Amount_GP_in
                           , 0                                    AS AmountReceipt_out
                           , MAX (tmpMI_WorkProgress_in.MovementId) AS MovementId
                      FROM tmpMI_WorkProgress_in_gr AS tmpMI_WorkProgress_in
                           LEFT JOIN tmpMI_WorkProgress_oth ON tmpMI_WorkProgress_oth.ContainerId = tmpMI_WorkProgress_in.ContainerId

                           /*LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMI_WorkProgress_in.GoodsId
                                                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight	
                                                 ON ObjectFloat_Weight.ObjectId = tmpMI_WorkProgress_in.GoodsId
                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()*/

                      GROUP BY tmpMI_WorkProgress_in.GoodsId
                             , tmpMI_WorkProgress_in.PartionGoodsId
                             , tmpMI_WorkProgress_in.GoodsKindId_Complete
                     UNION ALL
                      -- Приход ГП
                      SELECT tmpMI_GP_in.GoodsId
                           , tmpMI_GP_in.PartionGoodsId
                           , tmpMI_GP_in.GoodsKindId_Complete
                           , 0 AS Amount_WorkProgress_in
                           , 0 AS CuterCount
                           , 0 AS RealWeight
                           , 0 AS RealWeightMsg
                           , 0 AS Amount_GP_in_calc
                           , 0 AS TaxExit
                           , 0 AS calcIn
                           , 0 AS calcOut
                           , '' AS Comment
                           , tmpMI_GP_in.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS Amount_GP_in
                           , tmpMI_GP_in.AmountReceipt * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountReceipt_out
                           , '' AS MovementId
                      FROM tmpMI_GP_in
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMI_GP_in.GoodsId
                                                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight	
                                                 ON ObjectFloat_Weight.ObjectId = tmpMI_GP_in.GoodsId
                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                     UNION ALL
                      -- Партии п/ф ГП которых нет в производстве
                      SELECT tmpMI_WorkProgress_find.GoodsId
                           , tmpMI_WorkProgress_find.PartionGoodsId
                           , tmpMI_WorkProgress_find.GoodsKindId_Complete
                           , 0 AS Amount_WorkProgress_in
                           , 0 AS CuterCount
                           , 0 AS RealWeight
                           , 0 AS RealWeightMsg
                           , 0 AS Amount_GP_in_calc
                           , 0 AS TaxExit
                           , 0 AS calcIn
                           , 0 AS calcOut
                           , '' AS Comment
                           , 0 AS Amount_GP_in
                           , 0 AS AmountReceipt_out
                           , '' AS MovementId
                      FROM tmpMI_WorkProgress_find
                     ) AS tmp
                      GROUP BY tmp.GoodsId
                             , tmp.PartionGoodsId
                             , tmp.GoodsKindId_Complete
                     )
    -- 
    SELECT ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.ObjectCode                AS GoodsCode
         , (Object_Goods.ValueData || CASE WHEN vbUserId = 5 AND 1=0 THEN ' ' || tmpResult.MovementId ELSE '' END) :: TVarChar AS GoodsName
         , Object_GoodsKindComplete.ValueData     AS GoodsKindName_Complete
         , Object_Measure.ValueData               AS MeasureName
         , ObjectDate_PartionGoods.ValueData      AS PartionGoodsDate

         , tmpResult.Amount_WorkProgress_in :: TFloat   AS Amount_WorkProgress_in
         , tmpResult.CuterCount :: TFloat               AS CuterCount
         , CASE WHEN inFromId IN (951601, 981821) -- ЦЕХ упаковки мясо + ЦЕХ шприц. мясо
                     AND COALESCE (tmpResult.RealWeight, 0) = 0
                     THEN tmpResult.Amount_WorkProgress_in
                ELSE tmpResult.RealWeight
           END                         :: TFloat        AS RealWeight
         , tmpResult.RealWeightMsg     :: TFloat        AS RealWeightMsg  
         , tmpResult.Amount_GP_in_calc :: TFloat        AS Amount_GP_in_calc
         , tmpResult.Amount_GP_in :: TFloat             AS Amount_GP_in
         , tmpResult.AmountReceipt_out :: TFloat        AS AmountReceipt_out

         , tmpResult.TaxExit :: TFloat                  AS TaxExit
         , CASE WHEN tmpResult.CuterCount <> 0 AND tmpResult.calcOut <> 0
                     THEN (tmpResult.Amount_WorkProgress_in / tmpResult.CuterCount)
                        * (tmpResult.calcIn / tmpResult.CuterCount)
                        / (tmpResult.calcOut / tmpResult.CuterCount)
           END :: TFloat AS TaxExit_calc
         /*, CASE WHEN tmpResult.CuterCount <> 0 AND tmpResult.calcOut <> 0
                     THEN (tmpResult.Amount_WorkProgress_in / tmpResult.CuterCount)
                        * (tmpResult.Amount_GP_in / tmpResult.CuterCount)
                        / (tmpResult.calcOut / tmpResult.CuterCount)
           END :: TFloat AS TaxExit_real*/
         , CASE WHEN tmpResult.CuterCount <> 0
                     THEN (tmpResult.Amount_GP_in / tmpResult.CuterCount)
           END :: TFloat AS TaxExit_real

         , CASE WHEN tmpResult.AmountReceipt_out <> 0
                     THEN 100 - 100 * (tmpResult.Amount_GP_in / tmpResult.AmountReceipt_out)
           END :: TFloat AS TaxLoss
         , CASE WHEN tmpResult.RealWeight <> 0
                     THEN 100 - 100 * (tmpResult.Amount_GP_in / tmpResult.RealWeight)
           END :: TFloat AS TaxLoss_calc
         , CASE WHEN tmpResult.Amount_WorkProgress_in <> 0
                     THEN 100 - 100 * (tmpResult.Amount_GP_in / tmpResult.Amount_WorkProgress_in)
           END :: TFloat AS TaxLoss_real

         , tmpResult.Comment :: TVarChar                AS Comment

     FROM tmpResult
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpResult.GoodsId
          LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = tmpResult.GoodsKindId_Complete

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectDate AS ObjectDate_PartionGoods
                               ON ObjectDate_PartionGoods.ObjectId = tmpResult.PartionGoodsId
                              AND ObjectDate_PartionGoods.DescId = zc_ObjectDate_PartionGoods_Value()
    ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.12.20         * RealWeightMsg
 17.03.15                                        *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_ProductionUnion_TaxExit (inStartDate:= '01.06.2020', inEndDate:= '01.06.2020', inFromId:= 8447, inToId:= 0, inIsDetail:= FALSE, inSession:= zfCalc_UserAdmin()) ORDER BY 2;
