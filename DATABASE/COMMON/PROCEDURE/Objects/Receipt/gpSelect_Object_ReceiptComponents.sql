-- Function: gpSelect_Object_ReceiptComponents()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptComponents (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptComponents(
    IN inReceiptId    Integer,
    IN inShowAll      Boolean,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (
               Id Integer, Code Integer, Name TVarChar, ReceiptCode TVarChar,
               Value TFloat, ValueWeight TFloat, ValueCost TFloat, TaxExit TFloat, TaxLoss TFloat,
               TotalWeightMain TFloat, TotalWeight TFloat,
               StartDate TDateTime, EndDate TDateTime,
               isMain Boolean,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar,
               GoodsKindCompleteId Integer, GoodsKindCompleteCode Integer, GoodsKindCompleteName TVarChar,
               ReceiptCostId Integer, ReceiptCostCode Integer, ReceiptCostName TVarChar,
               ReceiptKindId Integer, ReceiptKindCode Integer, ReceiptKindName TVarChar,
               MeasureName TVarChar,
               GoodsGroupNameFull TVarChar, GoodsGroupAnalystName TVarChar, GoodsTagName TVarChar, TradeMarkName TVarChar
             , Code_Parent_Receipt           Integer
             , Name_Parent_Receipt           TVarChar
             , ReceiptCode_Parent_Receipt    TVarChar
             , isMain_Parent_Receipt         Boolean
             , GoodsCode_Parent_Receipt      Integer
             , GoodsName_Parent_Receipt      TVarChar
             , MeasureName_Parent_Receipt    TVarChar
             , GoodsKindName_Parent_Receipt  TVarChar
             , Code_Parent_old          Integer 
             , Name_Parent_old          TVarChar
             , ReceiptCode_Parent_old   TVarChar  
             , GoodsCode_Parent_old     Integer   
             , GoodsName_Parent_old     TVarChar  
             , GoodsKindName_Parent_old TVarChar  
             , EndDate_Parent_old       TDateTime 
         
             , isErased Boolean,

               ReceiptChildId Integer, Value_Child TFloat, ValueWeight_Child TFloat, ValueWeight_calc_Child TFloat, isWeightMain_Child Boolean, isTaxExit_Child Boolean, isWeightTotal_Child Boolean, isReal_Child Boolean ,
               StartDate_Child TDateTime, EndDate_Child TDateTime, Comment TVarChar,
               GoodsId_Child Integer, GoodsCode_Child Integer, GoodsName_Child TVarChar,
               GoodsKindId_Child Integer, GoodsKindCode_Child Integer, GoodsKindName_Child TVarChar,
               MeasureName_Child TVarChar, MeasureName_calc_Child TVarChar,
               GroupNumber_Child Integer,
               ReceiptLevelId Integer, ReceiptLevelName TVarChar,
               
               InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar,
               Color_calc Integer,
               InsertName TVarChar, UpdateName TVarChar,
               InsertDate TDateTime, UpdateDate TDateTime,
               Code_Parent Integer, Name_Parent TVarChar, ReceiptCode_Parent TVarChar, isMain_Parent Boolean,
               GoodsCode_Parent Integer, GoodsName_Parent TVarChar, MeasureName_Parent TVarChar,
               GoodsKindName_Parent TVarChar, GoodsKindCompleteName_Parent TVarChar,
               isErased_Child Boolean
) AS

$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptChild());

   RETURN QUERY 
     WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

    , tmpReceipt AS (
      SELECT
           Object_Receipt.Id         AS Id
         , Object_Receipt.ObjectCode AS Code
         , Object_Receipt.ValueData  AS Name

         , ObjectString_Code.ValueData    AS ReceiptCode

         , ObjectFloat_Value.ValueData         AS Value
         , (ObjectFloat_Value.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) :: TFloat AS ValueWeight
         , ObjectFloat_ValueCost.ValueData     AS ValueCost
         , ObjectFloat_TaxExit.ValueData       AS TaxExit
        
         , ObjectFloat_TaxLoss.ValueData       AS TaxLoss
         , ObjectFloat_TotalWeightMain.ValueData AS TotalWeightMain
         , ObjectFloat_TotalWeight.ValueData     AS TotalWeight

         , ObjectDate_StartDate.ValueData AS StartDate
         , ObjectDate_EndDate.ValueData   AS EndDate

         , ObjectBoolean_Main.ValueData AS isMain

         , Object_Goods.Id          AS GoodsId
         , Object_Goods.ObjectCode  AS GoodsCode
         , Object_Goods.ValueData   AS GoodsName

         , Object_GoodsKind.Id         AS GoodsKindId
         , Object_GoodsKind.ObjectCode AS GoodsKindCode
         , Object_GoodsKind.ValueData  AS GoodsKindName

         , Object_GoodsKindComplete.Id          AS GoodsKindCompleteId
         , Object_GoodsKindComplete.ObjectCode  AS GoodsKindCompleteCode
         , Object_GoodsKindComplete.ValueData   AS GoodsKindCompleteName

         , Object_ReceiptCost.Id          AS ReceiptCostId
         , Object_ReceiptCost.ObjectCode  AS ReceiptCostCode
         , Object_ReceiptCost.ValueData   AS ReceiptCostName

         , Object_ReceiptKind.Id          AS ReceiptKindId
         , Object_ReceiptKind.ObjectCode  AS ReceiptKindCode
         , Object_ReceiptKind.ValueData   AS ReceiptKindName

         , Object_Measure.ValueData     AS MeasureName

         , Object_Receipt_Parent.ObjectCode      AS Code_Parent
         , Object_Receipt_Parent.ValueData       AS Name_Parent
         , ObjectString_Code_Parent.ValueData    AS ReceiptCode_Parent
         , ObjectBoolean_Main_Parent.ValueData   AS isMain_Parent
         , Object_Goods_Parent.ObjectCode              AS GoodsCode_Parent
         , Object_Goods_Parent.ValueData               AS GoodsName_Parent
         , Object_Measure_Parent.ValueData             AS MeasureName_Parent
         , Object_GoodsKind_Parent.ValueData           AS GoodsKindName_Parent
         , Object_GoodsKindComplete_Parent.ValueData   AS GoodsKindCompleteName_Parent

         , Object_Receipt_Parent_old.ObjectCode   ::Integer    AS Code_Parent_old
         , Object_Receipt_Parent_old.ValueData    ::TVarChar   AS Name_Parent_old
         , ObjectString_Code_Parent_old.ValueData ::TVarChar   AS ReceiptCode_Parent_old
         , Object_Goods_Parent_old.ObjectCode     ::Integer    AS GoodsCode_Parent_old
         , Object_Goods_Parent_old.ValueData      ::TVarChar   AS GoodsName_Parent_old
         , Object_GoodsKind_Parent_old.ValueData  ::TVarChar   AS GoodsKindName_Parent_old
         , ObjectDate_End_Parent_old.ValueData    ::TDateTime  AS EndDate_Parent_old

         , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
         , Object_GoodsGroupAnalyst.ValueData          AS GoodsGroupAnalystName
         , Object_GoodsTag.ValueData                   AS GoodsTagName
         , Object_TradeMark.ValueData                  AS TradeMarkName
         
         , Object_Receipt.isErased AS isErased

     FROM Object AS Object_Receipt
          INNER JOIN tmpIsErased ON tmpIsErased.isErased = Object_Receipt.isErased

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent
                               ON ObjectLink_Receipt_Parent.ObjectId = Object_Receipt.Id
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
                                 AND ObjectBoolean_Main_Parent.DescId = zc_ObjectBoolean_Receipt_Main()
          LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit_Parent
                                ON ObjectFloat_TaxExit_Parent.ObjectId = Object_Receipt_Parent.Id
                               AND ObjectFloat_TaxExit_Parent.DescId = zc_ObjectFloat_Receipt_TaxExit()

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                               ON ObjectLink_Receipt_Goods.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Receipt_Goods.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                               ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_Receipt_GoodsKind.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete
                               ON ObjectLink_Receipt_GoodsKindComplete.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_GoodsKindComplete.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()
          LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = ObjectLink_Receipt_GoodsKindComplete.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Receipt_ReceiptCost
                               ON ObjectLink_Receipt_ReceiptCost.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_ReceiptCost.DescId = zc_ObjectLink_Receipt_ReceiptCost()
          LEFT JOIN Object AS Object_ReceiptCost ON Object_ReceiptCost.Id = ObjectLink_Receipt_ReceiptCost.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_ReceiptKind
                               ON ObjectLink_Receipt_ReceiptKind.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_ReceiptKind.DescId = zc_ObjectLink_Receipt_ReceiptKind()
          LEFT JOIN Object AS Object_ReceiptKind ON Object_ReceiptKind.Id = ObjectLink_Receipt_ReceiptKind.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_StartDate
                               ON ObjectDate_StartDate.ObjectId = Object_Receipt.Id
                              AND ObjectDate_StartDate.DescId = zc_ObjectDate_Receipt_Start()

          LEFT JOIN ObjectDate AS ObjectDate_EndDate
                               ON ObjectDate_EndDate.ObjectId = Object_Receipt.Id
                              AND ObjectDate_EndDate.DescId = zc_ObjectDate_Receipt_End()

          --
          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_old
                               ON ObjectLink_Receipt_Parent_old.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_Parent_old.DescId = zc_ObjectLink_Receipt_Parent_old()
          LEFT JOIN Object AS Object_Receipt_Parent_old ON Object_Receipt_Parent_old.Id = ObjectLink_Receipt_Parent_old.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Code_Parent_old
                                 ON ObjectString_Code_Parent_old.ObjectId = Object_Receipt_Parent_old.Id
                                AND ObjectString_Code_Parent_old.DescId = zc_ObjectString_Receipt_Code()

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_Parent_old
                               ON ObjectLink_Receipt_Goods_Parent_old.ObjectId = Object_Receipt_Parent_old.Id
                              AND ObjectLink_Receipt_Goods_Parent_old.DescId = zc_ObjectLink_Receipt_Goods()
          LEFT JOIN Object AS Object_Goods_Parent_old ON Object_Goods_Parent_old.Id = ObjectLink_Receipt_Goods_Parent_old.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_old
                               ON ObjectLink_Receipt_GoodsKind_Parent_old.ObjectId = Object_Receipt_Parent_old.Id
                              AND ObjectLink_Receipt_GoodsKind_Parent_old.DescId = zc_ObjectLink_Receipt_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind_Parent_old ON Object_GoodsKind_Parent_old.Id = ObjectLink_Receipt_GoodsKind_Parent_old.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_End_Parent_old
                               ON ObjectDate_End_Parent_old.ObjectId = Object_Receipt.Id
                              AND ObjectDate_End_Parent_old.DescId = zc_ObjectDate_Receipt_End_Parent_old()
          --


          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()

          LEFT JOIN ObjectString AS ObjectString_Code
                                 ON ObjectString_Code.ObjectId = Object_Receipt.Id
                                AND ObjectString_Code.DescId = zc_ObjectString_Receipt_Code()

          LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                ON ObjectFloat_Value.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()

          LEFT JOIN ObjectFloat AS ObjectFloat_ValueCost
                                ON ObjectFloat_ValueCost.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_ValueCost.DescId = zc_ObjectFloat_Receipt_ValueCost()

          LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit
                                ON ObjectFloat_TaxExit.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_TaxExit.DescId = zc_ObjectFloat_Receipt_TaxExit()
          LEFT JOIN ObjectFloat AS ObjectFloat_TaxLoss
                                ON ObjectFloat_TaxLoss.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_TaxLoss.DescId = zc_ObjectFloat_Receipt_TaxLoss()

          LEFT JOIN ObjectFloat AS ObjectFloat_TotalWeightMain
                                ON ObjectFloat_TotalWeightMain.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_TotalWeightMain.DescId = zc_ObjectFloat_Receipt_TotalWeightMain()
          LEFT JOIN ObjectFloat AS ObjectFloat_TotalWeight
                                ON ObjectFloat_TotalWeight.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_TotalWeight.DescId = zc_ObjectFloat_Receipt_TotalWeight()

          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

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

      WHERE Object_Receipt.DescId = zc_Object_Receipt()
       AND (Object_Receipt.Id = inReceiptId OR inReceiptId = 0)
      )

, tmpReceiptChild AS (
     SELECT 
           tmpReceiptChild.Id
         , tmpReceiptChild.Value
         , tmpReceiptChild.ValueWeight
         , CASE WHEN tmpReceiptChild.isWeightTotal = TRUE THEN tmpReceiptChild.ValueWeight ELSE 0 END :: TFloat AS ValueWeight_calc

         , COALESCE (tmpReceiptChild.isWeightMain , FALSE) :: Boolean AS isWeightMain
         , COALESCE (tmpReceiptChild.isTaxExit,     FALSE) :: Boolean AS isTaxExit
         , COALESCE (tmpReceiptChild.isWeightTotal, FALSE) :: Boolean AS isWeightTotal
         , COALESCE (tmpReceiptChild.isReal,        FALSE) :: Boolean AS isReal

         , ObjectDate_StartDate.ValueData     AS StartDate
         , ObjectDate_EndDate.ValueData       AS EndDate
         , ObjectString_Comment.ValueData     AS Comment
 
         , tmpReceiptChild.ReceiptId
         , tmpReceiptChild.ReceiptName

         , Object_Goods.Id               AS GoodsId
         , Object_Goods.ObjectCode       AS GoodsCode
         , Object_Goods.ValueData        AS GoodsName

         , Object_GoodsKind.Id           AS GoodsKindId
         , Object_GoodsKind.ObjectCode   AS GoodsKindCode
         , Object_GoodsKind.ValueData    AS GoodsKindName

         , Object_Measure.ValueData      AS MeasureName
         , COALESCE (Object_Measure_calc.ValueData, Object_Measure.ValueData) :: TVarChar AS MeasureName_calc

         , tmpReceiptChild.GroupNumber

         , Object_ReceiptLevel.Id        AS ReceiptLevelId
         , Object_ReceiptLevel.ValueData AS ReceiptLevelName

         , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN NULL ELSE tmpReceiptChild.InfoMoneyCode            END :: Integer  AS InfoMoneyCode
         , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN NULL ELSE tmpReceiptChild.InfoMoneyGroupName       END :: TVarChar AS InfoMoneyGroupName
         , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN NULL ELSE tmpReceiptChild.InfoMoneyDestinationName END :: TVarChar AS InfoMoneyDestinationName
         , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN NULL ELSE tmpReceiptChild.InfoMoneyName            END :: TVarChar AS InfoMoneyName

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

         , Object_Insert.ValueData   AS InsertName
         , Object_Update.ValueData   AS UpdateName
         , ObjectDate_Protocol_Insert.ValueData AS InsertDate
         , ObjectDate_Protocol_Update.ValueData AS UpdateDate

         , Object_ReceiptChild_Parent.ObjectCode       AS Code_Parent
         , Object_ReceiptChild_Parent.ValueData        AS Name_Parent
         , ObjectString_Code_Parent.ValueData          AS ReceiptCode_Parent
         , ObjectBoolean_Main_Parent.ValueData         AS isMain_Parent
         , Object_Goods_Parent.ObjectCode              AS GoodsCode_Parent
         , Object_Goods_Parent.ValueData               AS GoodsName_Parent
         , Object_Measure_Parent.ValueData             AS MeasureName_Parent
         , Object_GoodsKind_Parent.ValueData           AS GoodsKindName_Parent
         , Object_GoodsKindComplete_Parent.ValueData   AS GoodsKindCompleteName_Parent

         , tmpReceiptChild.isErased
         
     FROM (SELECT Object_ReceiptChild.Id                          AS Id
                , Object_Receipt.Id                               AS ReceiptId
                , Object_Receipt.ValueData                        AS ReceiptName
                , ObjectLink_ReceiptChild_Goods.ChildObjectId     AS GoodsId
                , ObjectLink_ReceiptChild_GoodsKind.ChildObjectId AS GoodsKindId
                , ObjectLink_Goods_Measure.ChildObjectId          AS MeasureId
                , zfCalc_ReceiptChild_GroupNumber (inGoodsId                := ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                 , inGoodsKindId            := ObjectLink_ReceiptChild_GoodsKind.ChildObjectId
                                                 , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                 , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                 , inIsWeightMain           := ObjectBoolean_WeightMain.ValueData
                                                 , inIsTaxExit              := ObjectBoolean_TaxExit.ValueData
                                                  ) AS GroupNumber
                , zfCalc_ReceiptChild_isWeightTotal (inGoodsId                := ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                   , inGoodsKindId            := ObjectLink_ReceiptChild_GoodsKind.ChildObjectId
                                                   , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                   , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                   , inIsWeightMain           := ObjectBoolean_WeightMain.ValueData
                                                   , inIsTaxExit              := ObjectBoolean_TaxExit.ValueData
                                                    ) AS isWeightTotal
                , ObjectFloat_Value.ValueData :: TFloat AS Value
                , (ObjectFloat_Value.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) :: TFloat AS ValueWeight

                , ObjectBoolean_WeightMain.ValueData AS isWeightMain
                , ObjectBoolean_TaxExit.ValueData    AS isTaxExit
                , ObjectBoolean_Real.ValueData       AS isReal

                , ObjectLink_ReceiptChild_ReceiptLevel.ChildObjectId AS ReceiptLevelId

                , Object_InfoMoney_View.InfoMoneyCode
                , Object_InfoMoney_View.InfoMoneyGroupName
                , Object_InfoMoney_View.InfoMoneyDestinationName
                , Object_InfoMoney_View.InfoMoneyName

                , Object_ReceiptChild.isErased AS isErased

           FROM Object AS Object_ReceiptChild
                LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                     ON ObjectLink_ReceiptChild_Receipt.ObjectId = Object_ReceiptChild.Id
                                    AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_ReceiptChild_Receipt.ChildObjectId
                INNER JOIN tmpIsErased ON tmpIsErased.isErased = Object_Receipt.isErased

                LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                        ON ObjectBoolean_WeightMain.ObjectId = Object_ReceiptChild.Id
                                       AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                        ON ObjectBoolean_TaxExit.ObjectId = Object_ReceiptChild.Id
                                       AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()

                LEFT JOIN ObjectBoolean AS ObjectBoolean_Real
                                        ON ObjectBoolean_Real.ObjectId = Object_ReceiptChild.Id
                                       AND ObjectBoolean_Real.DescId = zc_ObjectBoolean_ReceiptChild_Real()

                LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                      ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                     AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()

                LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                     ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                    AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                     ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                    AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()

                LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                     ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                    AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                     ON ObjectLink_Goods_Measure.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_ReceiptLevel
                                     ON ObjectLink_ReceiptChild_ReceiptLevel.ObjectId = Object_ReceiptChild.Id
                                    AND ObjectLink_ReceiptChild_ReceiptLevel.DescId = zc_ObjectLink_ReceiptChild_ReceiptLevel()
           WHERE Object_ReceiptChild.DescId = zc_Object_ReceiptChild()
             AND (ObjectLink_ReceiptChild_Receipt.ChildObjectId = inReceiptId OR inReceiptId = 0)
          ) AS tmpReceiptChild

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Parent
                               ON ObjectLink_ReceiptChild_Parent.ObjectId = tmpReceiptChild.Id
                              AND ObjectLink_ReceiptChild_Parent.DescId = zc_ObjectLink_ReceiptChild_Parent()
          LEFT JOIN Object AS Object_ReceiptChild_Parent ON Object_ReceiptChild_Parent.Id = ObjectLink_ReceiptChild_Parent.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Code_Parent
                                 ON ObjectString_Code_Parent.ObjectId = Object_ReceiptChild_Parent.Id
                                AND ObjectString_Code_Parent.DescId = zc_ObjectString_Receipt_Code()

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_Parent
                               ON ObjectLink_Receipt_Goods_Parent.ObjectId = Object_ReceiptChild_Parent.Id
                              AND ObjectLink_Receipt_Goods_Parent.DescId = zc_ObjectLink_Receipt_Goods()
          LEFT JOIN Object AS Object_Goods_Parent ON Object_Goods_Parent.Id = ObjectLink_Receipt_Goods_Parent.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_Parent
                               ON ObjectLink_Goods_Measure_Parent.ObjectId = Object_Goods_Parent.Id 
                              AND ObjectLink_Goods_Measure_Parent.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure_Parent ON Object_Measure_Parent.Id = ObjectLink_Goods_Measure_Parent.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent
                               ON ObjectLink_Receipt_GoodsKind_Parent.ObjectId = Object_ReceiptChild_Parent.Id
                              AND ObjectLink_Receipt_GoodsKind_Parent.DescId = zc_ObjectLink_Receipt_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind_Parent ON Object_GoodsKind_Parent.Id = ObjectLink_Receipt_GoodsKind_Parent.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete_Parent
                               ON ObjectLink_Receipt_GoodsKindComplete_Parent.ObjectId = Object_ReceiptChild_Parent.Id
                              AND ObjectLink_Receipt_GoodsKindComplete_Parent.DescId = zc_ObjectLink_Receipt_GoodsKindComplete()
          LEFT JOIN Object AS Object_GoodsKindComplete_Parent ON Object_GoodsKindComplete_Parent.Id = ObjectLink_Receipt_GoodsKindComplete_Parent.ChildObjectId

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main_Parent
                                  ON ObjectBoolean_Main_Parent.ObjectId = Object_ReceiptChild_Parent.Id
                                 AND ObjectBoolean_Main_Parent.DescId = zc_ObjectBoolean_Receipt_Main()


          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpReceiptChild.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpReceiptChild.GoodsKindId
          LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = tmpReceiptChild.ReceiptLevelId
 
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpReceiptChild.MeasureId
          LEFT JOIN Object AS Object_Measure_calc ON Object_Measure_calc.Id = zc_Measure_Kg() AND Object_Measure.Id = zc_Measure_Sh()

          LEFT JOIN ObjectDate AS ObjectDate_StartDate 
                               ON ObjectDate_StartDate.ObjectId = tmpReceiptChild.Id
                              AND ObjectDate_StartDate.DescId = zc_ObjectDate_ReceiptChild_Start()
          LEFT JOIN ObjectDate AS ObjectDate_EndDate 
                               ON ObjectDate_EndDate.ObjectId = tmpReceiptChild.Id
                              AND ObjectDate_EndDate.DescId = zc_ObjectDate_ReceiptChild_End()
            
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = tmpReceiptChild.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptChild_Comment()

          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                             ON ObjectDate_Protocol_Insert.ObjectId = tmpReceiptChild.Id
                            AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                             ON ObjectDate_Protocol_Update.ObjectId = tmpReceiptChild.Id
                            AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                             ON ObjectLink_Insert.ObjectId = tmpReceiptChild.Id 
                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   

          LEFT JOIN ObjectLink AS ObjectLink_Update
                             ON ObjectLink_Update.ObjectId = tmpReceiptChild.Id 
                            AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId   
      )

   -- результат
    SELECT tmpReceipt.Id   AS Id
         , tmpReceipt.Code AS Code
         , tmpReceipt.Name AS Name
         , tmpReceipt.ReceiptCode
         , tmpReceipt.Value
         , tmpReceipt.ValueWeight
         , tmpReceipt.ValueCost
         , tmpReceipt.TaxExit
         , tmpReceipt.TaxLoss
         , tmpReceipt.TotalWeightMain
         , tmpReceipt.TotalWeight
         , tmpReceipt.StartDate
         , tmpReceipt.EndDate
         , tmpReceipt.isMain
         , tmpReceipt.GoodsId
         , tmpReceipt.GoodsCode
         , tmpReceipt.GoodsName
         , tmpReceipt.GoodsKindId
         , tmpReceipt.GoodsKindCode
         , tmpReceipt.GoodsKindName
         , tmpReceipt.GoodsKindCompleteId
         , tmpReceipt.GoodsKindCompleteCode
         , tmpReceipt.GoodsKindCompleteName
         , tmpReceipt.ReceiptCostId
         , tmpReceipt.ReceiptCostCode                   --25
         , tmpReceipt.ReceiptCostName
         , tmpReceipt.ReceiptKindId
         , tmpReceipt.ReceiptKindCode
         , tmpReceipt.ReceiptKindName
         , tmpReceipt.MeasureName
         , tmpReceipt.GoodsGroupNameFull
         , tmpReceipt.GoodsGroupAnalystName
         , tmpReceipt.GoodsTagName
         , tmpReceipt.TradeMarkName  
         
         , tmpReceipt.Code_Parent          AS Code_Parent_Receipt
         , tmpReceipt.Name_Parent          AS Name_Parent_Receipt 
         , tmpReceipt.ReceiptCode_Parent   AS ReceiptCode_Parent_Receipt
         , tmpReceipt.isMain_Parent        AS isMain_Parent_Receipt
         , tmpReceipt.GoodsCode_Parent     AS GoodsCode_Parent_Receipt 
         , tmpReceipt.GoodsName_Parent     AS GoodsName_Parent_Receipt 
         , tmpReceipt.MeasureName_Parent   AS MeasureName_Parent_Receipt  
         , tmpReceipt.GoodsKindName_Parent AS GoodsKindName_Parent_Receipt
                  
         , tmpReceipt.Code_Parent_old          ::Integer 
         , tmpReceipt.Name_Parent_old          ::TVarChar
         , tmpReceipt.ReceiptCode_Parent_old   ::TVarChar  
         , tmpReceipt.GoodsCode_Parent_old     ::Integer   
         , tmpReceipt.GoodsName_Parent_old     ::TVarChar  
         , tmpReceipt.GoodsKindName_Parent_old ::TVarChar  
         , tmpReceipt.EndDate_Parent_old       ::TDateTime 
         
         , tmpReceipt.isErased


         , tmpReceiptChild.Id                               AS ReceiptChildId
         , tmpReceiptChild.Value                            AS Value_Child
         , tmpReceiptChild.ValueWeight                      AS ValueWeight_Child
         , tmpReceiptChild.ValueWeight_calc                 AS ValueWeight_calc_Child
         , tmpReceiptChild.isWeightMain                     AS isWeightMain_Child
         , tmpReceiptChild.isTaxExit                        AS isTaxExit_Child
         , tmpReceiptChild.isWeightTotal                    AS isWeightTotal_Child
         , tmpReceiptChild.isReal                           AS isReal_Child
         , tmpReceiptChild.StartDate                        AS StartDate_Child
         , tmpReceiptChild.EndDate                          AS EndDate_Child
         , tmpReceiptChild.Comment
         , tmpReceiptChild.GoodsId                          AS GoodsId_Child
         , tmpReceiptChild.GoodsCode                        AS GoodsCode_Child
         , tmpReceiptChild.GoodsName                        AS GoodsName_Child
         , tmpReceiptChild.GoodsKindId                      AS GoodsKindId_Child
         , tmpReceiptChild.GoodsKindCode                    AS GoodsKindCode_Child
         , tmpReceiptChild.GoodsKindName                    AS GoodsKindName_Child
         , tmpReceiptChild.MeasureName                      AS MeasureName_Child
         , tmpReceiptChild.MeasureName_calc                 AS MeasureName_calc_Child
         , tmpReceiptChild.GroupNumber                      AS GroupNumber_Child

         , tmpReceiptChild.ReceiptLevelId
         , tmpReceiptChild.ReceiptLevelName

         , tmpReceiptChild.InfoMoneyCode
         , tmpReceiptChild.InfoMoneyGroupName
         , tmpReceiptChild.InfoMoneyDestinationName
         , tmpReceiptChild.InfoMoneyName
         , tmpReceiptChild.Color_calc
         , tmpReceiptChild.InsertName
         , tmpReceiptChild.UpdateName
         , tmpReceiptChild.InsertDate
         , tmpReceiptChild.UpdateDate
         , tmpReceiptChild.Code_Parent
         , tmpReceiptChild.Name_Parent
         , tmpReceiptChild.ReceiptCode_Parent
         , tmpReceiptChild.isMain_Parent
         , tmpReceiptChild.GoodsCode_Parent
         , tmpReceiptChild.GoodsName_Parent
         , tmpReceiptChild.MeasureName_Parent
         , tmpReceiptChild.GoodsKindName_Parent
         , tmpReceiptChild.GoodsKindCompleteName_Parent 
 
         , tmpReceiptChild.isErased                         AS isErased_Child

   FROM tmpReceipt
       LEFT JOIN tmpReceiptChild ON  tmpReceiptChild.ReceiptId = tmpReceipt.Id
   ORDER BY tmpReceipt.Id, tmpReceiptChild.GroupNumber

    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_ReceiptComponents (Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.09.22         * isReal_Child
 22.06.21         * ReceiptLevel
 26.02.16         *
*/

-- тест
--   SELECT * FROM gpSelect_Object_ReceiptComponents (353292, FALSE, '2') 
--ORDER BY GroupNumber
