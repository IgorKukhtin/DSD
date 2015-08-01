-- Function: gpReport_GoodsMI_ProductionUnion_Tax ()

DROP FUNCTION IF EXISTS gpReport_ReceiptProductionAnalyze (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ReceiptProductionAnalyze (
    IN inStartDate        TDateTime ,  
    IN inEndDate          TDateTime ,
    IN inUnitFromId       Integer   , 
    IN inUnitToId         Integer   , 
    IN inGoodsGroupId     Integer   ,
    IN inPriceListId_1    Integer, 
    IN inPriceListId_2    Integer, 
    IN inPriceListId_3    Integer, 
    IN inPriceListId_sale Integer, 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor

AS
$BODY$
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN

     -- CREATE TEMP TABLE tmpReceiptTable (Id Integer) ON COMMIT DROP;
     CREATE TEMP TABLE tmpChildReceiptTable (ReceiptId_from Integer, ReceiptId Integer, GoodsId_in Integer, GoodsKindId_in Integer, Amount_in TFloat
                                           , ReceiptChildId integer, GoodsId_out Integer, GoodsKindId_out Integer, Amount_out TFloat, isStart Boolean, isCost Boolean
                                           , Price1 TFloat, Price2 TFloat, Price3 TFloat) ON COMMIT DROP;

     /*WITH RECURSIVE tmpGroup (GoodsGroupId, GoodsGroupParentId, GoodsName)
       AS (SELECT Id, NULL :: Integer, Object.ValueData AS GoodsName
           FROM Object 
           WHERE Object.Id = inGoodsGroupId
          UNION 
           SELECT Object_GoodsGroup.Id, tmpGroup.GoodsGroupId, Object_GoodsGroup.ValueData AS GoodsName
           FROM tmpGroup
                INNER JOIN ObjectLink AS ObjectLink_GoodsGroup
                                      ON ObjectLink_GoodsGroup.ChildObjectId = tmpGroup.GoodsGroupId
                                     AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                INNER JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_GoodsGroup.ObjectId
          )
     INSERT INTO tmpReceiptTable (Id)
        SELECT Object_Receipt.Id
        FROM tmpGroup
             INNER JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                   ON ObjectLink_Goods_GoodsGroup.ChildObjectId = tmpGroup.GoodsGroupId
                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                   ON ObjectLink_Receipt_Goods.ChildObjectId = ObjectLink_Goods_GoodsGroup.ObjectId
                                  AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
             INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                AND Object_Receipt.isErased = FALSE
       ;*/

                               
     INSERT INTO tmpChildReceiptTable (ReceiptId_from, ReceiptId, GoodsId_in, GoodsKindId_in, Amount_in
                                     , ReceiptChildId, GoodsId_out, GoodsKindId_out, Amount_out, isStart, isCost
                                     , Price1, Price2, Price3)
          SELECT lpSelect.ReceiptId_from, lpSelect.ReceiptId, lpSelect.GoodsId_in, lpSelect.GoodsKindId_in, lpSelect.Amount_in
               , lpSelect.ReceiptChildId, lpSelect.GoodsId_out, lpSelect.GoodsKindId_out, lpSelect.Amount_out, lpSelect.isStart, lpSelect.isCost
               , COALESCE (PriceList1.Price, 0),  COALESCE (PriceList2.Price, 0), COALESCE(PriceList3.Price, 0)
          FROM lpSelect_Object_ReceiptChildDetail () AS lpSelect
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList1 ON PriceList1.PriceListId = inPriceListId_1
                                                                       AND PriceList1.GoodsId = lpSelect.GoodsId_out
                                                                       AND inEndDate >= PriceList1.StartDate AND inEndDate < PriceList1.EndDate
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList2 ON PriceList2.PriceListId = inPriceListId_2
                                                                       AND PriceList2.GoodsId = lpSelect.GoodsId_out
                                                                       AND inEndDate >= PriceList2.StartDate AND inEndDate < PriceList2.EndDate
               LEFT JOIN ObjectHistory_PriceListItem_View AS PriceList3 ON PriceList3.PriceListId = inPriceListId_3
                                                                       AND PriceList3.GoodsId = lpSelect.GoodsId_out
                                                                       AND inEndDate >= PriceList3.StartDate AND inEndDate < PriceList3.EndDate
         ;


     -- Результат
     OPEN Cursor1 FOR
     WITH tmpMIContainer AS 
           (SELECT MIContainer.ObjectId_Analyzer AS GoodsId
                 , MIContainer.ContainerId       AS ContainerId
                 , MIReceipt.ObjectId            AS ReceiptId
                 , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount ELSE 0 END) AS OperCount
                 , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  THEN MIContainer.Amount ELSE 0 END) AS OperSumm
            FROM MovementItemContainer AS MIContainer
                 INNER JOIN MovementLinkObject AS MLO_From
                                               ON MLO_From.MovementId = MIContainer.MovementId
                                              AND MLO_From.DescId = zc_MovementLinkObject_From()
                                              AND MLO_From.ObjectId = inUnitFromId
                 INNER JOIN MovementItemLinkObject AS MIReceipt 
                                                   ON MIReceipt.MovementItemId = MIContainer.MovementItemId
                                                  AND MIReceipt.DescId = zc_MILinkObject_Receipt()
            WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate 
              AND MIContainer.WhereObjectId_Analyzer = inUnitToId
              AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
              AND MIContainer.IsActive = TRUE
              AND MIContainer.Amount <> 0
            GROUP BY MIContainer.ObjectId_Analyzer
                   , MIContainer.ContainerId
                   , MIReceipt.ObjectId
           )
        , tmpAll AS 
           (SELECT tmpMIContainer.ReceiptId
                 , tmpMIContainer.GoodsId
                 , COALESCE (CLO_GoodsKind.ObjectId, 0)                       AS GoodsKindId
                 , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)   AS GoodsKindId_complete
                 , SUM (tmpMIContainer.OperCount) AS OperCount
                 , SUM (tmpMIContainer.OperSumm)  AS OperSumm
                 , 0 AS Summ1
                 , 0 AS Summ2
                 , 0 AS Summ3
            FROM tmpMIContainer
                 LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = tmpMIContainer.ContainerId
                                                               AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                 LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = tmpMIContainer.ContainerId
                                                                  AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                 LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                      ON ObjectLink_GoodsKindComplete.ObjectId = CLO_PartionGoods.ObjectId
                                     AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
            GROUP BY tmpMIContainer.ReceiptId
                   , tmpMIContainer.GoodsId
                   , COALESCE (CLO_GoodsKind.ObjectId, 0)
                   , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)

           UNION ALL
            SELECT tmp.ReceiptId
                 , COALESCE (ObjectLink_Receipt_Goods.ChildObjectId, 0)               AS GoodsId
                 , COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0)           AS GoodsKindId
                 , COALESCE (ObjectLink_Receipt_GoodsKind_complete.ChildObjectId, 0)  AS GoodsKindId_complete
                 , 0  AS OperCount
                 , 0  AS OperSumm
                 , SUM (tmp.Summ1) AS Summ1
                 , SUM (tmp.Summ2) AS Summ2
                 , SUM (tmp.Summ3) AS Summ3
            FROM (SELECT tmpChildReceiptTable.ReceiptId
                       , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price1) AS Summ1
                       , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price2) AS Summ2
                       , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3) AS Summ3
                  FROM tmpChildReceiptTable
                  WHERE tmpChildReceiptTable.ReceiptId_from = 0
                  GROUP BY  tmpChildReceiptTable.ReceiptId
                 ) AS tmp
                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                      ON ObjectLink_Receipt_Goods.ObjectId = tmp.ReceiptId
                                     AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                      ON ObjectLink_Receipt_GoodsKind.ObjectId = tmp.ReceiptId
                                     AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_complete
                                      ON ObjectLink_Receipt_GoodsKind_complete.ObjectId = tmp.ReceiptId
                                     AND ObjectLink_Receipt_GoodsKind_complete.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()
            GROUP BY tmp.ReceiptId
                   , COALESCE (ObjectLink_Receipt_Goods.ChildObjectId, 0)
                   , COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0)
                   , COALESCE (ObjectLink_Receipt_GoodsKind_complete.ChildObjectId, 0)
           )

        , tmpResult AS 
           (SELECT tmpAll.ReceiptId
                 , tmpAll.GoodsId
                 , tmpAll.GoodsKindId
                 , tmpAll.GoodsKindId_complete
                 , SUM (tmpAll.OperCount) AS OperCount
                 , SUM (tmpAll.OperSumm)  AS OperSumm
                 , SUM (tmpAll.Summ1)     AS Summ1
                 , SUM (tmpAll.Summ2)     AS Summ2
                 , SUM (tmpAll.Summ3)     AS Summ3
            FROM tmpAll
            GROUP BY tmpAll.ReceiptId
                   , tmpAll.GoodsId
                   , tmpAll.GoodsKindId
                   , tmpAll.GoodsKindId_complete
           )
      -- Результат
      SELECT tmpResult.ReceiptId
           , Object_Receipt.ObjectCode      AS Code
           , ObjectString_Code.ValueData    AS ReceiptCode
           , ObjectString_Comment.ValueData AS Comment

           , ObjectFloat_Value.ValueData         AS Amount
           , (ObjectFloat_Value.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) :: TFloat AS Amount_Weight
           , ObjectFloat_TaxExit.ValueData       AS TaxExit
           , ObjectFloat_TaxLoss.ValueData       AS TaxLoss
           , ObjectBoolean_Main.ValueData        AS isMain

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroupAnalyst.ValueData          AS GoodsGroupAnalystName
           , Object_GoodsTag.ValueData                   AS GoodsTagName
           , Object_TradeMark.ValueData                  AS TradeMarkName
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , Object_GoodsKind.ValueData                  AS GoodsKindName
           , Object_GoodsKindComplete.ValueData          AS GoodsKindCompleteName
           , Object_Measure.ValueData                    AS MeasureName
           
           , Object_Receipt_Parent.ObjectCode      AS Code_Parent
           , ObjectString_Code_Parent.ValueData    AS ReceiptCode_Parent
           , ObjectBoolean_Main_Parent.ValueData   AS isMain_Parent
           , Object_Goods_Parent.ObjectCode              AS GoodsCode_Parent
           , Object_Goods_Parent.ValueData               AS GoodsName_Parent
           , Object_Measure_Parent.ValueData             AS MeasureName_Parent
           , Object_GoodsKind_Parent.ValueData           AS GoodsKindName_Parent
           , Object_GoodsKindComplete_Parent.ValueData   AS GoodsKindCompleteName_Parent

           , CAST (tmpResult.Summ1 / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) AS Price1
           , CAST (tmpResult.Summ2 / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) AS Price2
           , CAST (tmpResult.Summ3 / ObjectFloat_Value.ValueData AS NUMERIC (16, 3)) AS Price3
           , PriceListSale.Price * 1.2 AS Price_sale -- !!!захардкодил временно!!!
           , tmpResult.OperCount
           , tmpResult.OperCount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS OperCount_Weight
           , tmpResult.OperSumm
           , CAST (CASE WHEN tmpResult.OperCount <> 0 THEN tmpResult.OperSumm / tmpResult.OperCount ELSE 0 END AS NUMERIC (16, 3)) AS Price_in
             
           , CASE WHEN Object_Goods.Id <> Object_Goods_Parent.Id THEN TRUE ELSE FALSE END AS isCheck_Parent

       FROM tmpResult
            LEFT JOIN ObjectHistory_PriceListItem_View AS PriceListSale ON PriceListSale.PriceListId = inPriceListId_sale
                                                                       AND PriceListSale.GoodsId = tmpResult.GoodsId
                                                                       AND inEndDate BETWEEN PriceListSale.StartDate AND PriceListSale.EndDate
            LEFT JOIN Object AS Object_Receipt   ON Object_Receipt.Id   = tmpResult.ReceiptId
            LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpResult.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpResult.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = tmpResult.GoodsKindId_complete

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                 ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
            LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                 ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
            LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                 ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId


            LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                  ON ObjectFloat_Value.ObjectId = tmpResult.ReceiptId
                                 AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()
            LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit
                                  ON ObjectFloat_TaxExit.ObjectId = Object_Receipt.Id
                                 AND ObjectFloat_TaxExit.DescId = zc_ObjectFloat_Receipt_TaxExit()
            LEFT JOIN ObjectFloat AS ObjectFloat_TaxLoss
                                  ON ObjectFloat_TaxLoss.ObjectId = Object_Receipt.Id
                                 AND ObjectFloat_TaxLoss.DescId = zc_ObjectFloat_Receipt_TaxLoss()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                    ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                   AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
            LEFT JOIN ObjectString AS ObjectString_Code
                                   ON ObjectString_Code.ObjectId = tmpResult.ReceiptId
                                  AND ObjectString_Code.DescId = zc_ObjectString_Receipt_Code()
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = tmpResult.ReceiptId
                                  AND ObjectString_Comment.DescId = zc_ObjectString_Receipt_Comment()

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent
                               ON ObjectLink_Receipt_Parent.ObjectId = tmpResult.ReceiptId
                              AND ObjectLink_Receipt_Parent.DescId = zc_ObjectLink_Receipt_Parent()
          LEFT JOIN Object AS Object_Receipt_Parent ON Object_Receipt_Parent.Id = ObjectLink_Receipt_Parent.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Code_Parent
                                 ON ObjectString_Code_Parent.ObjectId = Object_Receipt_Parent.Id
                                AND ObjectString_Code_Parent.DescId = zc_ObjectString_Receipt_Code()

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_Parent
                               ON ObjectLink_Receipt_Goods_Parent.ObjectId = Object_Receipt_Parent.Id
                              AND ObjectLink_Receipt_Goods_Parent.DescId = zc_ObjectLink_Receipt_Goods()
          LEFT JOIN Object AS Object_Goods_Parent ON Object_Goods_Parent.Id = ObjectLink_Receipt_Goods_Parent.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_Parent
                               ON ObjectLink_Goods_Measure_Parent.ObjectId = Object_Goods_Parent.Id 
                              AND ObjectLink_Goods_Measure_Parent.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure_Parent ON Object_Measure_Parent.Id = ObjectLink_Goods_Measure_Parent.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent
                              ON ObjectLink_Receipt_GoodsKind_Parent.ObjectId = Object_Receipt_Parent.Id
                             AND ObjectLink_Receipt_GoodsKind_Parent.DescId = zc_ObjectLink_Receipt_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind_Parent ON Object_GoodsKind_Parent.Id = ObjectLink_Receipt_GoodsKind_Parent.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete_Parent
                               ON ObjectLink_Receipt_GoodsKindComplete_Parent.ObjectId = Object_Receipt_Parent.Id
                              AND ObjectLink_Receipt_GoodsKindComplete_Parent.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()
          LEFT JOIN Object AS Object_GoodsKindComplete_Parent ON Object_GoodsKindComplete_Parent.Id = ObjectLink_Receipt_GoodsKindComplete_Parent.ChildObjectId

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main_Parent
                                  ON ObjectBoolean_Main_Parent.ObjectId = Object_Receipt_Parent.Id
                                 AND ObjectBoolean_Main_Parent.DescId = zc_ObjectBoolean_Receipt_Main();
      -- Результат
      RETURN NEXT Cursor1;


     -- Результат
     OPEN Cursor2 FOR
       WITH tmpChild_calc AS (SELECT tmpChildReceiptTable.ReceiptId
                                   , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price1) AS Summ1
                                   , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price2) AS Summ2
                                   , SUM (tmpChildReceiptTable.Amount_out * tmpChildReceiptTable.Price3) AS Summ3
                              FROM (SELECT tmpChildReceiptTable.ReceiptId_from FROM tmpChildReceiptTable WHERE tmpChildReceiptTable.ReceiptId_from > 0 GROUP BY tmpChildReceiptTable.ReceiptId_from
                                   ) AS tmp
                                   INNER JOIN tmpChildReceiptTable ON tmpChildReceiptTable.ReceiptId = tmp.ReceiptId_from
                                                                  AND tmpChildReceiptTable.isCost = FALSE
                              GROUP BY tmpChildReceiptTable.ReceiptId
                             )
       SELECT tmpReceiptChild.ReceiptId
            , tmpReceiptChild.GroupNumber

            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_Goods.Objectcode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName  
            , Object_GoodsKind.ValueData  AS GoodsKindName
            , Object_Measure.ValueData    AS MeasureName

            , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN NULL ELSE tmpReceiptChild.InfoMoneyCode            END :: Integer  AS InfoMoneyCode
            , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN NULL ELSE tmpReceiptChild.InfoMoneyGroupName       END :: TVarChar AS InfoMoneyGroupName
            , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN NULL ELSE tmpReceiptChild.InfoMoneyDestinationName END :: TVarChar AS InfoMoneyDestinationName
            , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN NULL ELSE tmpReceiptChild.InfoMoneyName            END :: TVarChar AS InfoMoneyName

            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Amount_out ELSE 0 END AS Amount
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price1 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ1 / ObjectFloatReceipt_Value.ValueData ELSE 0 END AS Price1
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price2 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ2 / ObjectFloatReceipt_Value.ValueData ELSE 0 END AS Price2
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price3 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ3 / ObjectFloatReceipt_Value.ValueData ELSE 0 END AS Price3

            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Amount_out ELSE 0 END * tmpReceiptChild.Price1 AS Summ1
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Amount_out ELSE 0 END * tmpReceiptChild.Price2 AS Summ2
            , CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Amount_out ELSE 0 END * tmpReceiptChild.Price3 AS Summ3

            , tmpReceiptChild.isStart
            , CASE WHEN tmpReceiptChild.isStart = TRUE THEN tmpReceiptChild.Amount_out ELSE 0 END AS Amount_start
            , CASE WHEN tmpReceiptChild.isStart = TRUE THEN tmpReceiptChild.Amount_out * CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price1 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ1 / ObjectFloatReceipt_Value.ValueData ELSE 0 END ELSE 0 END AS Summ1_Start
            , CASE WHEN tmpReceiptChild.isStart = TRUE THEN tmpReceiptChild.Amount_out * CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price2 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ2 / ObjectFloatReceipt_Value.ValueData ELSE 0 END ELSE 0 END AS Summ2_Start
            , CASE WHEN tmpReceiptChild.isStart = TRUE THEN tmpReceiptChild.Amount_out * CASE WHEN tmpReceiptChild.ReceiptId_from = 0 THEN tmpReceiptChild.Price3 WHEN ObjectFloatReceipt_Value.ValueData > 0 THEN tmpChild_calc.Summ3 / ObjectFloatReceipt_Value.ValueData ELSE 0 END ELSE 0 END AS Summ3_Start

            , CASE tmpReceiptChild.GroupNumber
                      WHEN 6 THEN 15993821 -- _colorRecord_GoodsPropertyId_Ice           - inGoodsId = zc_Goods_WorkIce()
                      WHEN 1 THEN 14614528 -- _colorRecord_KindPackage_MaterialBasis     - inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                      WHEN 2 THEN 14614528 -- _colorRecord_KindPackage_MaterialBasis     - inInfoMoneyId = zc_Enum_InfoMoney_10105() -- Основное сырье + Мясное сырье + Прочее мясное сырье
                      WHEN 3 THEN 14614528 -- _colorRecord_KindPackage_PF                - inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                      WHEN 4 THEN 14614528 -- _colorRecord_KindPackage_PF                - inInfoMoneyDestinationId inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
                      WHEN 5 THEN 32896    -- _colorRecord_KindPackage_Composition_K_MB  -  zc_Enum_InfoMoney_10201() -- Основное сырье + Прочее сырье + Специи
                      WHEN 7 THEN 35980    -- _colorRecord_KindPackage_Composition_K     - zc_Enum_InfoMoney_10201() -- Основное сырье + Прочее сырье + Специи
                      WHEN 8 THEN 10965163 -- _colorRecord_KindPackage_Composition_Y     - inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье (осталось Оболочка + Упаковка + Прочее сырье)
                      ELSE 0 -- clBlack
              END :: Integer AS Color_calc

       FROM (SELECT tmpChildReceiptTable.*
                  , zfCalc_ReceiptChild_GroupNumber (inGoodsId                := tmpChildReceiptTable.GoodsId_out
                                                   , inGoodsKindId            := tmpChildReceiptTable.GoodsKindId_out
                                                   , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                   , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                   , inIsWeightMain           := ObjectBoolean_WeightMain.ValueData
                                                   , inIsTaxExit              := ObjectBoolean_TaxExit.ValueData
                                                    ) AS GroupNumber
                  , Object_InfoMoney_View.InfoMoneyCode
                  , Object_InfoMoney_View.InfoMoneyGroupName
                  , Object_InfoMoney_View.InfoMoneyDestinationName
                  , Object_InfoMoney_View.InfoMoneyName
             FROM tmpChildReceiptTable
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                       ON ObjectLink_Goods_InfoMoney.ObjectId = tmpChildReceiptTable.GoodsId_out
                                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                  LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                          ON ObjectBoolean_WeightMain.ObjectId = tmpChildReceiptTable.ReceiptChildId
                                         AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
                  LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                          ON ObjectBoolean_TaxExit.ObjectId = tmpChildReceiptTable.ReceiptChildId
                                         AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()
            ) AS tmpReceiptChild
            LEFT JOIN tmpChild_calc ON tmpChild_calc.ReceiptId = tmpReceiptChild.ReceiptId_from
            LEFT JOIN ObjectFloat AS ObjectFloatReceipt_Value
                                  ON ObjectFloatReceipt_Value.ObjectId = tmpReceiptChild.ReceiptId_from
                                 AND ObjectFloatReceipt_Value.DescId = zc_ObjectFloat_Receipt_Value()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpReceiptChild.GoodsId_out
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpReceiptChild.GoodsKindId_out

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId;
     
     RETURN NEXT Cursor2;
   
         
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_ReceiptProductionAnalyze (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.03.15                        *
*/

-- тест
-- SELECT * FROM gpReport_ReceiptProductionAnalyze (inStartDate:= '01.06.2014', inEndDate:= '01.06.2014', inUnitFromId:= 8447, inUnitToId:= 8447, inGoodsGroupId:= 0, inPriceListId_1:= 0, inPriceListId_2:= 0, inPriceListId_3:= 0, inPriceListId_sale:= 0, inSession:= zfCalc_UserAdmin())
