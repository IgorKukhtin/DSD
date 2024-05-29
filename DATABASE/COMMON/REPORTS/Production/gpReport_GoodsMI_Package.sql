-- Function: gpReport_GoodsMI_Package ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_Package (TDateTime, TDateTime, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_GoodsMI_Package (TDateTime, TDateTime, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_GoodsMI_Package (TDateTime, TDateTime, Integer, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_GoodsMI_Package (TDateTime, TDateTime, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_Package (TDateTime, TDateTime, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_Package(
    IN inStartDate          TDateTime ,
    IN inEndDate            TDateTime ,
    IN inUnitId             Integer   ,
    IN inIsDate             Boolean   , -- по датам
    IN inIsPersonalGroup    Boolean   , -- по № бригады
    IN inisMovement         Boolean   , -- показать № накладной перемещения
    IN inisUnComplete       Boolean   , -- показать не проведенные
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , GoodsGroupNameFull TVarChar, GoodsGroupId Integer, GoodsGroupName TVarChar
             , GoodsCode_basis Integer, GoodsName_basis TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar, MeasureName TVarChar

             , ReceiptCode_code Integer, ReceiptCode TVarChar, ReceiptName TVarChar

             , Amount_Send_out TFloat, Weight_Send_out TFloat
             , Amount_Send_out_rk TFloat, Weight_Send_out_rk TFloat
             , Amount_Send_out_oth TFloat, Weight_Send_out_oth TFloat
             
             , Amount_Send_in TFloat, Weight_Send_in TFloat

             , Amount_Production TFloat, Weight_Production TFloat
             , CountPackage TFloat, WeightPackage TFloat, WeightPackage_one TFloat
             , CountPackage_calc TFloat, WeightPackage_calc TFloat

             , Weight_diff TFloat
             , WeightTotal TFloat -- Вес в упаковке - GoodsByGoodsKind
             
             , PersonalGroupId        Integer
             , PersonalGroupName      TVarChar
             
             , InvNumber TVarChar, MovementDescName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    -- Результат
    RETURN QUERY
         --
    WITH tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                      FROM Object_InfoMoney_View
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                               AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                      WHERE Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                          OR Object_InfoMoney_View.InfoMoneyGroupId      = zc_Enum_InfoMoneyGroup_30000()       -- Доходы
                          OR (inUnitId = 951601 -- ЦЕХ упаковки мясо
                          AND Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() --
                             )
                     )
   
   , tmpGoodsByGoodsKind_View AS (SELECT * FROM Object_GoodsByGoodsKind_View)
    
   , tmpMI_Union AS  (SELECT tmpMI.OperDate
                           , tmpMI.GoodsId
                           , tmpMI.GoodsKindId
                           , tmpMI.MeasureName
                           , tmpMI.Amount_Send_in
                           , tmpMI.Amount_Send_out
                           , tmpMI.Amount_Send_out_rk
                           , tmpMI.Amount_Send_out_oth
                           , tmpMI.Amount_Production
                           , tmpMI.CountPack
                           
                           , tmpMI.PersonalGroupId
                           , tmpMI.PersonalGroupName
                          -- , tmpMI.UnitName_PersonalGroup
                           , tmpMI.MovementId

                           , tmpMI.CountPackage_calc
                           , tmpMI.WeightPackage_calc
                           , tmpMI.WeightPackage_one
                           , tmpMI.WeightTotal
                      FROM (SELECT MIContainer.ObjectId_Analyzer                  AS GoodsId
                                 , COALESCE (MIContainer.ObjectIntId_Analyzer, 0) AS GoodsKindId 
                                 , Object_Measure.ValueData                       AS MeasureName
                                 , CASE WHEN inIsDate = TRUE OR inisMovement = TRUE THEN MIContainer.OperDate ELSE NULL END :: TDatetime AS OperDate
                                 
                                 , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset()) AND MIContainer.IsActive = TRUE  THEN      MIContainer.Amount ELSE 0 END
                                      + CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion()                  AND MIContainer.IsActive = TRUE AND MLO_DocumentKind.ObjectId > 0 AND MIContainer.ObjectExtId_Analyzer = inUnitId
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END
                                      + CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion() AND MIContainer.IsActive = TRUE AND MIContainer.ObjectExtId_Analyzer <> inUnitId AND inUnitId = 951601 -- ЦЕХ упаковки мясо
                                                  THEN MIContainer.Amount
                                             ELSE 0
                                        END) AS Amount_Send_in
                                 , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset()) AND MIContainer.IsActive = FALSE THEN -1 * COALESCE (MIContainer.Amount,0) ELSE 0 END) AS Amount_Send_out
                                 , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset()) AND MIContainer.IsActive = FALSE AND MIContainer.ObjectExtId_Analyzer  = zc_Unit_RK() THEN -1 * COALESCE (MIContainer.Amount,0) ELSE 0 END) AS Amount_Send_out_rk
                                 , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset()) AND MIContainer.IsActive = FALSE AND MIContainer.ObjectExtId_Analyzer <> zc_Unit_RK() THEN -1 * COALESCE (MIContainer.Amount,0) ELSE 0 END) AS Amount_Send_out_oth
                                 
                                 , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_Loss())
                                              AND MIContainer.IsActive       = FALSE
                                              AND (MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReWork()
                                                OR MLO_DocumentKind.ObjectId > 0
                                                OR MIContainer.ObjectExtId_Analyzer <> MIContainer.WhereObjectId_Analyzer
                                                OR MIContainer.MovementDescId = zc_Movement_Loss()
                                                  )
                                                  THEN -1 * COALESCE (MIContainer.Amount,0)
                                             ELSE 0
                                        END) AS Amount_Production
                                 , SUM (COALESCE (MIFloat_CountPack.ValueData ,0)) AS CountPack
                                 
                                 , CASE WHEN inIsPersonalGroup = FALSE THEN 0 ELSE COALESCE (Object_PersonalGroup.Id,0) END AS PersonalGroupId
                                 , CASE WHEN inIsPersonalGroup = FALSE THEN '' ELSE CASE WHEN COALESCE (Object_PersonalGroup.ValueData,'') <> '' THEN (COALESCE (Object_PersonalGroup.ValueData,'') ||' ('||COALESCE (Object_Unit_PersonalGroup.ValueData,'') ||')') ELSE '' END END AS PersonalGroupName
                                 --, STRING_AGG (DISTINCT CASE WHEN COALESCE (Object_PersonalGroup.ValueData,'') <> '' THEN (COALESCE (Object_PersonalGroup.ValueData,'') ||' ('||COALESCE (Object_Unit_PersonalGroup.ValueData,'') ||')') ELSE '' END, '; ')      AS PersonalGroupName
                                 
                                 , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementId ELSE 0 END MovementId

           -- Кол-во Упаковок (пакетов)
         , SUM (CASE WHEN ObjectFloat_WeightTotal.ValueData <> 0
                     THEN CAST (((CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset()) AND MIContainer.IsActive = FALSE THEN -1 * COALESCE (MIContainer.Amount,0) ELSE 0 END)
                               * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)
                              / ObjectFloat_WeightTotal.ValueData AS NUMERIC (16, 0))
                ELSE 0
           END) :: TFloat AS CountPackage_calc
           -- Вес Упаковок (пакетов)
         , SUM (CASE WHEN ObjectFloat_WeightTotal.ValueData <> 0
                     THEN CAST (((CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset()) AND MIContainer.IsActive = FALSE THEN -1 * COALESCE (MIContainer.Amount,0) ELSE 0 END)
                                * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)
                              / ObjectFloat_WeightTotal.ValueData AS NUMERIC (16, 0))
                        * COALESCE (ObjectFloat_WeightPackage.ValueData, 0)
                ELSE 0
           END) :: TFloat AS WeightPackage_calc
         , ObjectFloat_WeightPackage.ValueData                                                   AS WeightPackage_one
         , ObjectFloat_WeightTotal.ValueData AS WeightTotal
                            FROM MovementItemContainer AS MIContainer
                                 LEFT JOIN MovementLinkObject AS MLO_DocumentKind
                                                              ON MLO_DocumentKind.MovementId = MIContainer.MovementId
                                                             AND MLO_DocumentKind.DescId     = zc_MovementLinkObject_DocumentKind()
                                 LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                             ON MIFloat_CountPack.MovementItemId = MIContainer.MovementItemId
                                                            AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                                                            AND MIContainer.MovementDescId = zc_Movement_Send()
                                                            AND MIContainer.IsActive = FALSE

                                LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                                             ON MovementLinkObject_PersonalGroup.MovementId = MIContainer.MovementId
                                                            AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
                                LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MovementLinkObject_PersonalGroup.ObjectId

                                LEFT JOIN ObjectLink AS ObjectLink_PersonalGroup_Unit
                                                     ON ObjectLink_PersonalGroup_Unit.ObjectId = Object_PersonalGroup.Id
                                                    AND ObjectLink_PersonalGroup_Unit.DescId = zc_ObjectLink_PersonalGroup_Unit()
                                LEFT JOIN Object AS Object_Unit_PersonalGroup ON Object_Unit_PersonalGroup.Id = ObjectLink_PersonalGroup_Unit.ChildObjectId

                                 -- Товар и Вид товара
                                LEFT JOIN tmpGoodsByGoodsKind_View AS Object_GoodsByGoodsKind_View
                                                                   ON Object_GoodsByGoodsKind_View.GoodsId     = MIContainer.ObjectId_Analyzer
                                                                  AND Object_GoodsByGoodsKind_View.GoodsKindId = COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                                -- вес 1-ого пакета
                                LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                                      ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                     AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()
                                -- вес в упаковке: "чистый" вес + вес 1-ого пакета
                                LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                                      ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                     AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
                      
                                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                     ON ObjectLink_Goods_Measure.ObjectId = MIContainer.ObjectId_Analyzer
                                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                      
                                -- вес 1 шт, только для штучного товара, ???почему??? = вес в упаковке
                                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                      ON ObjectFloat_Weight.ObjectId = MIContainer.ObjectId_Analyzer
                                                     AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
 
                            WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                              AND MIContainer.DescId = zc_MIContainer_Count()
                              AND MIContainer.WhereObjectId_Analyzer = inUnitId
                              AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset(), zc_Movement_ProductionUnion(), zc_Movement_Loss())
                              -- AND MIContainer.Amount <> 0
                            GROUP BY MIContainer.ObjectId_Analyzer
                                   , MIContainer.ObjectIntId_Analyzer
                                   , CASE WHEN inIsDate = TRUE OR inisMovement = TRUE THEN MIContainer.OperDate ELSE NULL END
                                   , CASE WHEN inIsPersonalGroup = FALSE THEN '' ELSE CASE WHEN COALESCE (Object_PersonalGroup.ValueData,'') <> '' THEN (COALESCE (Object_PersonalGroup.ValueData,'') ||' ('||COALESCE (Object_Unit_PersonalGroup.ValueData,'') ||')') ELSE '' END END
                                   , CASE WHEN inIsPersonalGroup = FALSE THEN 0 ELSE COALESCE (Object_PersonalGroup.Id,0) END
                                   , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementId ELSE 0 END
                                   , Object_Measure.ValueData
                                   , ObjectFloat_WeightPackage.ValueData 
                                   , ObjectFloat_WeightTotal.ValueData
                         UNION
                            SELECT MovementItem.ObjectId AS GoodsId 
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                 , Object_Measure.ValueData                      AS MeasureName
                                 , CASE WHEN inIsDate = TRUE OR inisMovement = TRUE THEN Movement.OperDate ELSE NULL END :: TDatetime AS OperDate
                          
                                 , SUM (CASE WHEN MovementLinkObject_To.ObjectId = inUnitId   THEN COALESCE (MovementItem.Amount,0) ELSE 0 END) AS Amount_Send_in
                                 , SUM (CASE WHEN MovementLinkObject_From.ObjectId = inUnitId THEN COALESCE (MovementItem.Amount,0) ELSE 0 END) AS Amount_Send_out
                                 , SUM (CASE WHEN MovementLinkObject_From.ObjectId = inUnitId AND inUnitId  = zc_Unit_RK() THEN COALESCE (MovementItem.Amount,0) ELSE 0 END) AS Amount_Send_out_rk
                                 , SUM (CASE WHEN MovementLinkObject_From.ObjectId = inUnitId AND inUnitId <> zc_Unit_RK() THEN COALESCE (MovementItem.Amount,0) ELSE 0 END) AS Amount_Send_out_oth
                                 , 0 AS Amount_Production
                                 , 0 AS CountPack

                                 , CASE WHEN inIsPersonalGroup = FALSE THEN 0 ELSE COALESCE (Object_PersonalGroup.Id,0) END AS PersonalGroupId
                                 , CASE WHEN inIsPersonalGroup = FALSE THEN '' ELSE CASE WHEN COALESCE (Object_PersonalGroup.ValueData,'') <> '' THEN (COALESCE (Object_PersonalGroup.ValueData,'') ||' ('||COALESCE (Object_Unit_PersonalGroup.ValueData,'') ||')') ELSE '' END END AS PersonalGroupName

                                 , CASE WHEN inisMovement = TRUE THEN Movement.Id ELSE 0 END MovementId

                                   -- Кол-во Упаковок (пакетов)
                                 , SUM (CASE WHEN ObjectFloat_WeightTotal.ValueData <> 0
                                                  THEN CAST ( ((CASE WHEN MovementLinkObject_From.ObjectId = inUnitId THEN COALESCE (MovementItem.Amount,0) ELSE 0 END)
                                                             * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)
                                                           / ObjectFloat_WeightTotal.ValueData AS NUMERIC (16, 0) )
                                             ELSE 0
                                        END) :: TFloat AS CountPackage_calc
                                   -- Вес Упаковок (пакетов)
                                 , SUM (CASE WHEN ObjectFloat_WeightTotal.ValueData <> 0
                                                  THEN CAST ( ((CASE WHEN MovementLinkObject_From.ObjectId = inUnitId THEN COALESCE (MovementItem.Amount,0) ELSE 0 END)
                                                             * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)
                                                           / ObjectFloat_WeightTotal.ValueData AS NUMERIC (16, 0) )
                                                     * COALESCE (ObjectFloat_WeightPackage.ValueData, 0)
                                             ELSE 0
                                        END) :: TFloat AS WeightPackage_calc  
                                 , ObjectFloat_WeightPackage.ValueData                                                   AS WeightPackage_one
                                 , ObjectFloat_WeightTotal.ValueData AS WeightTotal
           
                            FROM Movement 
                                 INNER JOIN MovementFloat AS MovementFloat_MovementDesc
                                                         ON MovementFloat_MovementDesc.MovementId = Movement.Id
                                                        AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
                                                        AND MovementFloat_MovementDesc.ValueData = zc_Movement_Send()

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                 LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                                              ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                                             AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
                                 LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MovementLinkObject_PersonalGroup.ObjectId

                                 LEFT JOIN ObjectLink AS ObjectLink_PersonalGroup_Unit
                                                      ON ObjectLink_PersonalGroup_Unit.ObjectId = Object_PersonalGroup.Id
                                                     AND ObjectLink_PersonalGroup_Unit.DescId = zc_ObjectLink_PersonalGroup_Unit()
                                 LEFT JOIN Object AS Object_Unit_PersonalGroup ON Object_Unit_PersonalGroup.Id = ObjectLink_PersonalGroup_Unit.ChildObjectId
            
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId = zc_MI_Master()
                                                        AND MovementItem.isErased = FALSE

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

                                  -- Товар и Вид товара
                                 LEFT JOIN tmpGoodsByGoodsKind_View AS Object_GoodsByGoodsKind_View
                                                                    ON Object_GoodsByGoodsKind_View.GoodsId     = MovementItem.ObjectId
                                                                   AND Object_GoodsByGoodsKind_View.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                 -- вес 1-ого пакета
                                 LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                                       ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                      AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()
                                 -- вес в упаковке: "чистый" вес + вес 1-ого пакета
                                 LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                                       ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                      AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                      ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                     AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                 LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                       
                                 -- вес 1 шт, только для штучного товара, ???почему??? = вес в упаковке
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                       ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                      AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                               
                            WHERE Movement.DescId IN (zc_Movement_WeighingProduction(), zc_Movement_WeighingPartner())
                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              AND (MovementLinkObject_To.ObjectId = inUnitId OR MovementLinkObject_From.ObjectId = inUnitId)
                              AND inisUnComplete = TRUE
                            GROUP BY MovementItem.ObjectId 
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                   , CASE WHEN inIsDate = TRUE OR inisMovement = TRUE THEN Movement.OperDate ELSE NULL END
                                   , CASE WHEN inIsPersonalGroup = FALSE THEN 0 ELSE COALESCE (Object_PersonalGroup.Id,0) END
                                   , CASE WHEN inIsPersonalGroup = FALSE THEN '' ELSE CASE WHEN COALESCE (Object_PersonalGroup.ValueData,'') <> '' THEN (COALESCE (Object_PersonalGroup.ValueData,'') ||' ('||COALESCE (Object_Unit_PersonalGroup.ValueData,'') ||')') ELSE '' END END
                                   , CASE WHEN inisMovement = TRUE THEN Movement.Id ELSE 0 END
                                   , Object_Measure.ValueData 
                                   , ObjectFloat_WeightPackage.ValueData
                                   , ObjectFloat_WeightTotal.ValueData
                           ) AS tmpMI
                           INNER JOIN tmpGoods ON tmpGoods.GoodsId = tmpMI.GoodsId
                     )

           , tmpReceipt AS (SELECT tmpMI_Union.GoodsId
                                 , tmpMI_Union.GoodsKindId
                                 , MAX (Object_Receipt.Id) AS ReceiptId
                                 , MAX (COALESCE (ObjectLink_Receipt_Goods_Parent_0.ChildObjectId, 0)) AS GoodsId_basis
                                 , MAX (COALESCE (ObjectLink_Receipt_Parent_0.ChildObjectId, 0))       AS ReceiptId_basis
                            FROM (SELECT DISTINCT
                                         tmpMI_Union.GoodsId
                                       , tmpMI_Union.GoodsKindId
                                  FROM tmpMI_Union) AS tmpMI_Union
                                 INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                       ON ObjectLink_Receipt_Goods.ChildObjectId = tmpMI_Union.GoodsId
                                                      AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                                 INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                       ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                      AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                                      AND ObjectLink_Receipt_GoodsKind.ChildObjectId = tmpMI_Union.GoodsKindId
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
                            GROUP BY tmpMI_Union.GoodsId
                                   , tmpMI_Union.GoodsKindId
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
    SELECT tmpMI_Union.OperDate         :: TDateTime  AS OperDate
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_GoodsGroup.Id                       AS GoodsGroupId
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , Object_Goods_basis.ObjectCode              AS GoodsCode_basis
         , Object_Goods_basis.ValueData               AS GoodsName_basis
         , Object_Goods.Id                            AS GoodsId
         , Object_Goods.ObjectCode                    AS GoodsCode
         , Object_Goods.ValueData                     AS GoodsName
         , Object_GoodsKind.ValueData                 AS GoodsKindName
         , Object_Measure.ValueData                   AS MeasureName

         , Object_Receipt.ObjectCode           AS ReceiptCode_code
         , ObjectString_Receipt_Code.ValueData AS ReceiptCode
         , Object_Receipt.ValueData            AS ReceiptName

         , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpMI_Union.Amount_Send_out  ELSE 0 END                                    :: TFloat AS Amount_Send_out
         , (tmpMI_Union.Amount_Send_out * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)    :: TFloat AS Weight_Send_out
         
         , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpMI_Union.Amount_Send_out_rk  ELSE 0 END                                 :: TFloat AS Amount_Send_out_rk
         , (tmpMI_Union.Amount_Send_out_rk * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Weight_Send_out_rk

         , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpMI_Union.Amount_Send_out_oth  ELSE 0 END                                 :: TFloat AS Amount_Send_out_oth
         , (tmpMI_Union.Amount_Send_out_oth * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Weight_Send_out_oth

         , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpMI_Union.Amount_Send_in  ELSE 0 END                                     :: TFloat AS Amount_Send_in
         , (tmpMI_Union.Amount_Send_in * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)     :: TFloat AS Weight_Send_in

         , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpMI_Union.Amount_Production  ELSE 0 END                                  :: TFloat AS Amount_Production
         , (tmpMI_Union.Amount_Production * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)  :: TFloat AS Weight_Production

         , tmpMI_Union.CountPack                                                       :: TFloat AS CountPackage
         , (tmpMI_Union.CountPack * COALESCE (tmpMI_Union.WeightPackage_one, 0)) :: TFloat AS WeightPackage
         , tmpMI_Union.WeightPackage_one                                                   AS WeightPackage_one

         -- Кол-во Упаковок (пакетов)
         , tmpMI_Union.CountPackage_calc :: TFloat AS CountPackage_calc
           -- Вес Упаковок (пакетов)
         , tmpMI_Union.WeightPackage_calc :: TFloat AS WeightPackage_calc
 
         , ((tmpMI_Union.Amount_Send_out + tmpMI_Union.Amount_Production - tmpMI_Union.Amount_Send_in) * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
           ) :: TFloat AS Weight_diff

           -- Вес в упаковке - GoodsByGoodsKind
         , tmpMI_Union.WeightTotal AS WeightTotal
         
         , tmpMI_Union.PersonalGroupId        ::Integer
         , tmpMI_Union.PersonalGroupName      ::TVarChar
         
         , Movement.InvNumber    :: TVarChar
         , MovementDesc.ItemName :: TVarChar AS MovementDescName

     FROM tmpMI_Union
          LEFT JOIN Movement ON Movement.Id = tmpMI_Union.MovementId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

          LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId     = tmpMI_Union.GoodsId
                              AND tmpReceipt.GoodsKindId = tmpMI_Union.GoodsKindId
                              AND tmpReceipt.GoodsId_basis <> 0
          LEFT JOIN tmpReceipt_find ON tmpReceipt_find.GoodsId     = tmpMI_Union.GoodsId
                                   AND tmpReceipt_find.GoodsKindId = tmpMI_Union.GoodsKindId
                                   AND tmpReceipt_find.GoodsId_basis <> 0

          LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = COALESCE (tmpReceipt.GoodsId_basis, COALESCE (tmpReceipt_find.GoodsId_basis, tmpMI_Union.GoodsId))
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpMI_Union.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI_Union.GoodsKindId

          -- вес 1 шт, только для штучного товара, ???почему??? = вес в упаковке
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                               AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods_basis.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods_basis.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = COALESCE (tmpReceipt.ReceiptId, tmpReceipt_find.ReceiptId)
          LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                 ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.05.24         * zc_Unit_RK
 02.01.24         * 
 12.12.22         * inisUnComplete
 03.06.21         * inisMovement
 17.08.20         * inIsPersonalGroup
 29.04.20         * zc_Movement_SendAsset()
 07.06.18         * add inIsDate
 28.06.15                                        * ALL
 04.04.15         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_Package(inStartDate:= '01.08.2020', inEndDate:= '01.09.2020', inUnitId:= 8451, inIsDate:= False, inSession:= zfCalc_UserAdmin()) ORDER BY 7;
/*
 SELECT * FROM gpReport_GoodsMI_Package(inStartDate:= '01.08.2020', inEndDate:= '01.09.2020', inUnitId:= 8451, inIsDate:= False, inIsPersonalGroup:= true, inSession:= zfCalc_UserAdmin()) 
where goodsId = 2062
ORDER BY 7;


SELECT * FROM gpReport_GoodsMI_Package(inStartDate:= '01.08.2020', inEndDate:= '01.09.2020', inUnitId:= 8451, inIsDate:= False, inIsPersonalGroup:= False, inSession:= zfCalc_UserAdmin()) 
where goodsId = 2062
ORDER BY 7;

SELECT * FROM gpReport_GoodsMI_Package(inStartDate:= '01.11.2022', inEndDate:= '04.11.2022', inUnitId:= 8451, inIsDate:= False, inIsPersonalGroup:= False, inisMovement := true, inisUnComplete:= true, inSession:= zfCalc_UserAdmin()) 
where goodsId = 6694203

*/

