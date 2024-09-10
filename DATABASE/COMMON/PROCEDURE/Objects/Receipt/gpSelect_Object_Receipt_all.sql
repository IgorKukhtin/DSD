-- Function: gpSelect_Object_Receipt()

DROP FUNCTION IF EXISTS gpSelect_Object_Receipt_all (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Receipt_all(
    IN inReceiptId    Integer,
    IN inGoodsId      Integer,
    IN inGoodsKindId  Integer,
    IN inShowAll      Boolean,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ReceiptCode TVarChar, Comment TVarChar,
               Value TFloat, ValueWeight TFloat, ValueCost TFloat, TaxExit TFloat, TaxExitCheck TFloat, TaxLoss TFloat, PartionValue TFloat, PartionCount TFloat, WeightPackage TFloat,
               TotalWeightMain TFloat, TotalWeight TFloat, 
               TaxLossCEH TFloat, TaxLossTRM TFloat, TaxLossVPR TFloat, RealDelicShp TFloat, TaxLossCEHTRM TFloat, ValuePF TFloat,
               StartDate TDateTime, EndDate TDateTime,
               isMain Boolean,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar,
               GoodsKindCompleteId Integer, GoodsKindCompleteCode Integer, GoodsKindCompleteName TVarChar, GoodsKindCompleteId_calc Integer, GoodsKindCompleteName_calc TVarChar,
               ReceiptCostId Integer, ReceiptCostCode Integer, ReceiptCostName TVarChar,
               ReceiptKindId Integer, ReceiptKindCode Integer, ReceiptKindName TVarChar,
               MeasureName TVarChar
             , Code_Parent Integer, Name_Parent TVarChar, ReceiptCode_Parent TVarChar, isMain_Parent Boolean
             , GoodsCode_Parent Integer, GoodsName_Parent TVarChar, MeasureName_Parent TVarChar
             , GoodsKindName_Parent TVarChar, GoodsKindCompleteName_Parent TVarChar  
             , Code_Parent_old Integer, Name_Parent_old TVarChar, ReceiptCode_Parent_old TVarChar 
             , GoodsCode_Parent_old Integer, GoodsName_Parent_old TVarChar 
             , GoodsKindName_Parent_old  TVarChar, EndDate_Parent_old TDateTime                          
             , GoodsGroupNameFull TVarChar, GoodsGroupAnalystName TVarChar, GoodsTagName TVarChar, TradeMarkName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isCheck_Parent Boolean
             , Check_Weight TFloat, Check_PartionValue TFloat, Check_TaxExit TFloat
             , isParentMulti Boolean
             , isDisabled Boolean, Color_Disabled Integer
             , isIrna Boolean
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsIrna Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Receipt());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Ирна!!!
     vbIsIrna:= zfCalc_User_isIrna (vbUserId);


   RETURN QUERY
     WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)
     SELECT
           Object_Receipt.Id         AS Id
         , Object_Receipt.ObjectCode AS Code
         , Object_Receipt.ValueData  AS Name

         , ObjectString_Code.ValueData    AS ReceiptCode
         , ObjectString_Comment.ValueData AS Comment

         , ObjectFloat_Value.ValueData         AS Value
         , (ObjectFloat_Value.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) :: TFloat AS ValueWeight
         , ObjectFloat_ValueCost.ValueData     AS ValueCost
         , ObjectFloat_TaxExit.ValueData       AS TaxExit
         , ObjectFloat_TaxExitCheck.ValueData  AS TaxExitCheck
         , ObjectFloat_TaxLoss.ValueData       AS TaxLoss
         , ObjectFloat_PartionValue.ValueData  AS PartionValue
         , ObjectFloat_PartionCount.ValueData  AS PartionCount
         , ObjectFloat_WeightPackage.ValueData AS WeightPackage
         , ObjectFloat_TotalWeightMain.ValueData AS TotalWeightMain
         , ObjectFloat_TotalWeight.ValueData     AS TotalWeight

         , ObjectFloat_TaxLossCEH.ValueData   ::TFloat AS TaxLossCEH
         , ObjectFloat_TaxLossTRM.ValueData   ::TFloat AS TaxLossTRM
         , ObjectFloat_TaxLossVPR.ValueData   ::TFloat AS TaxLossVPR
         , ObjectFloat_RealDelicShp.ValueData ::TFloat AS RealDelicShp
         , (COALESCE (ObjectFloat_TaxLossCEH.ValueData,0) + COALESCE (ObjectFloat_TaxLossTRM.ValueData,0))   ::TFloat AS TaxLossCEHTRM 
         , ObjectFloat_ValuePF.ValueData      ::TFloat AS ValuePF

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
         , COALESCE (Object_GoodsKindComplete.Id, Object_GoodsKindComplete_basis.Id) :: Integer                AS GoodsKindCompleteId_calc
         , COALESCE (Object_GoodsKindComplete.ValueData, Object_GoodsKindComplete_basis.ValueData) :: TVarChar AS GoodsKindCompleteName_calc


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

         , Object_InfoMoney_View.InfoMoneyCode
         , Object_InfoMoney_View.InfoMoneyGroupName
         , Object_InfoMoney_View.InfoMoneyDestinationName
         , Object_InfoMoney_View.InfoMoneyName
       
         , Object_Insert.ValueData   AS InsertName
         , Object_Update.ValueData   AS UpdateName
         , ObjectDate_Protocol_Insert.ValueData AS InsertDate
         , ObjectDate_Protocol_Update.ValueData AS UpdateDate
         
         , CASE WHEN Object_Goods.Id <> Object_Goods_Parent.Id THEN TRUE ELSE FALSE END AS isCheck_Parent

         , CASE WHEN COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) IN (0, zc_GoodsKind_WorkProgress())
                     THEN (COALESCE (ObjectFloat_Value.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                        - COALESCE (ObjectFloat_TotalWeight.ValueData, 0)
                ELSE 0
           END :: TFloat AS Check_Weight

         , CASE WHEN COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) IN (0, zc_GoodsKind_WorkProgress())
                     THEN (COALESCE (ObjectFloat_Value.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                        - COALESCE (ObjectFloat_PartionValue.ValueData, 0)
                ELSE ObjectFloat_PartionValue.ValueData
           END :: TFloat AS Check_PartionValue

         , CASE WHEN ObjectLink_Receipt_GoodsKind.ChildObjectId = zc_GoodsKind_WorkProgress()
                     THEN COALESCE (ObjectFloat_TaxExit.ValueData, 0) - COALESCE (ObjectFloat_TaxExitCheck.ValueData, 0)
                WHEN ObjectLink_Receipt_Parent.ChildObjectId > 0 AND ObjectLink_Receipt_GoodsKind_Parent.ChildObjectId = zc_GoodsKind_WorkProgress()
                 AND COALESCE (ObjectFloat_TaxExit_Parent.ValueData, 0) <> COALESCE (ObjectFloat_TaxExit.ValueData, 0)
                     THEN COALESCE (ObjectFloat_TaxExit_Parent.ValueData, 0) - COALESCE (ObjectFloat_TaxExit.ValueData, 0)
                WHEN ObjectLink_Receipt_Parent.ChildObjectId > 0
                     THEN (COALESCE (ObjectFloat_Value.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                        - COALESCE (ObjectFloat_TaxExit.ValueData, 0)
                ELSE COALESCE (ObjectFloat_TaxExit.ValueData, 0) - 100
           END :: TFloat AS Check_TaxExit


         , COALESCE (ObjectBoolean_ParentMulti.ValueData, FALSE) :: Boolean AS isParentMulti
         , COALESCE (ObjectBoolean_Disabled.ValueData, FALSE)    :: Boolean AS isDisabled
         , CASE WHEN COALESCE (ObjectBoolean_Disabled.ValueData, FALSE) = TRUE THEN zc_Color_Red() ELSE 0 END :: Integer AS Color_Disabled

         , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE)   :: Boolean AS isIrna
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
          ---

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

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

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
          LEFT JOIN Object AS Object_GoodsKindComplete_basis ON Object_GoodsKindComplete_basis.Id = zc_GoodsKind_Basis()
                                                            AND Object_InfoMoney_View.InfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_10000() -- Основное сырье

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

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_ParentMulti
                                  ON ObjectBoolean_ParentMulti.ObjectId = Object_Receipt.Id
                                 AND ObjectBoolean_ParentMulti.DescId = zc_ObjectBoolean_Receipt_ParentMulti()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Disabled
                                  ON ObjectBoolean_Disabled.ObjectId  = Object_Receipt.Id
                                 AND ObjectBoolean_Disabled.DescId    = zc_ObjectBoolean_Receipt_Disabled()
                                 AND ObjectBoolean_Disabled.ValueData = TRUE

          LEFT JOIN ObjectString AS ObjectString_Code
                                 ON ObjectString_Code.ObjectId = Object_Receipt.Id
                                AND ObjectString_Code.DescId = zc_ObjectString_Receipt_Code()
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Receipt.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Receipt_Comment()

          LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                ON ObjectFloat_Value.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()

          LEFT JOIN ObjectFloat AS ObjectFloat_ValueCost
                                ON ObjectFloat_ValueCost.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_ValueCost.DescId = zc_ObjectFloat_Receipt_ValueCost()

          LEFT JOIN ObjectFloat AS ObjectFloat_TaxExitCheck
                                ON ObjectFloat_TaxExitCheck.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_TaxExitCheck.DescId = zc_ObjectFloat_Receipt_TaxExitCheck()
          LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit
                                ON ObjectFloat_TaxExit.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_TaxExit.DescId = zc_ObjectFloat_Receipt_TaxExit()
          LEFT JOIN ObjectFloat AS ObjectFloat_TaxLoss
                                ON ObjectFloat_TaxLoss.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_TaxLoss.DescId = zc_ObjectFloat_Receipt_TaxLoss()

          LEFT JOIN ObjectFloat AS ObjectFloat_PartionValue
                                ON ObjectFloat_PartionValue.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_PartionValue.DescId = zc_ObjectFloat_Receipt_PartionValue()

          LEFT JOIN ObjectFloat AS ObjectFloat_PartionCount
                                ON ObjectFloat_PartionCount.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_PartionCount.DescId = zc_ObjectFloat_Receipt_PartionCount()

          LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                ON ObjectFloat_WeightPackage.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_Receipt_WeightPackage()

          LEFT JOIN ObjectFloat AS ObjectFloat_TotalWeightMain
                                ON ObjectFloat_TotalWeightMain.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_TotalWeightMain.DescId = zc_ObjectFloat_Receipt_TotalWeightMain()
          LEFT JOIN ObjectFloat AS ObjectFloat_TotalWeight
                                ON ObjectFloat_TotalWeight.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_TotalWeight.DescId = zc_ObjectFloat_Receipt_TotalWeight()

          LEFT JOIN ObjectFloat AS ObjectFloat_TaxLossCEH
                                ON ObjectFloat_TaxLossCEH.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_TaxLossCEH.DescId = zc_ObjectFloat_Receipt_TaxLossCEH()
          LEFT JOIN ObjectFloat AS ObjectFloat_TaxLossTRM
                                ON ObjectFloat_TaxLossTRM.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_TaxLossTRM.DescId = zc_ObjectFloat_Receipt_TaxLossTRM()
          LEFT JOIN ObjectFloat AS ObjectFloat_TaxLossVPR
                                ON ObjectFloat_TaxLossVPR.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_TaxLossVPR.DescId = zc_ObjectFloat_Receipt_TaxLossVPR()
          LEFT JOIN ObjectFloat AS ObjectFloat_RealDelicShp
                                ON ObjectFloat_RealDelicShp.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_RealDelicShp.DescId = zc_ObjectFloat_Receipt_RealDelicShp()

          LEFT JOIN ObjectFloat AS ObjectFloat_ValuePF
                                ON ObjectFloat_ValuePF.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_ValuePF.DescId = zc_ObjectFloat_Receipt_ValuePF()
                               
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

          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                             ON ObjectDate_Protocol_Insert.ObjectId = Object_Receipt.Id
                            AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                             ON ObjectDate_Protocol_Update.ObjectId = Object_Receipt.Id
                            AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                             ON ObjectLink_Insert.ObjectId = Object_Receipt.Id 
                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   

          LEFT JOIN ObjectLink AS ObjectLink_Update
                             ON ObjectLink_Update.ObjectId = Object_Receipt.Id 
                            AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId   

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                  ON ObjectBoolean_Guide_Irna.ObjectId = Object_Receipt.Id
                                 AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()
     WHERE Object_Receipt.DescId = zc_Object_Receipt()
       AND (Object_Receipt.Id = inReceiptId OR inReceiptId = 0)
       AND (ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)
       AND (ObjectLink_Receipt_GoodsKind.ChildObjectId = inGoodsKindId OR inGoodsKindId = 0)
       AND (ObjectBoolean_Disabled.ObjectId IS NULL OR inShowAll = TRUE)
       AND (COALESCE (vbIsIrna, FALSE) = FALSE
         OR (vbIsIrna = TRUE  AND ObjectBoolean_Guide_Irna.ValueData = TRUE)
           )
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 10.09.24        *
 03.08.24        *
 14.09.20        * _all
 10.09.20        * add isDisabled
 21.03.15                                       * add inReceiptId
 23.02.15        * add 
 14.02.15                                      *all
 19.07.13        * reName zc_ObjectDate_
 10.07.13        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Receipt_all (0, 0, 0, FALSE, zfCalc_UserAdmin())

--select * from gpSelect_Object_Receipt_all(inReceiptId := 0 , inGoodsId := 112643 , inGoodsKindId := 0 , inShowAll := 'False' ,  inSession := '9457');