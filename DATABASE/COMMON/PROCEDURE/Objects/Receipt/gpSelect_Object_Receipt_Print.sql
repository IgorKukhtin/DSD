-- Function: gpselect_object_receipt_print(integer, integer, integer, boolean, tvarchar)

 DROP FUNCTION if exists gpselect_object_receipt_print(integer, integer, integer, boolean, tvarchar);

CREATE OR REPLACE FUNCTION gpselect_object_receipt_print(
    IN inreceiptid integer, 
    IN ingoodsid integer, 
    IN ingoodskindid integer, 
    IN inshowall boolean,
    IN insession tvarchar
    )
  RETURNS TABLE(receiptid integer, code integer, name tvarchar, receiptcode tvarchar, isMain Boolean
              , value tfloat, ValueWeight TFloat, taxexit tfloat, partionvalue tfloat, partioncount tfloat, weightpackage tfloat
              , startdate tdatetime
              , GoodsGroupName tvarchar, goodsid integer, goodsCode integer, goodsname tvarchar, goodskindname tvarchar
              , measurename tvarchar
              , infomoneyname tvarchar
              , ChildValueWeight TFloat
              , isWeightMain Boolean, isTaxExit Boolean, isWeightTotal Boolean
  
              , GoodsChildcode integer, GoodsChildName tvarchar , MeasureChildName_calc TVarChar
            
              , groupnumber integer
              , ChildInfoMoneyName tvarchar
              ) 
AS
$BODY$
    DECLARE Cursor1 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Receipt());
 RETURN QUERY
       --OPEN Cursor1 FOR
--ReceiptId;GroupNumber;InfoMoneyName;GoodsName
     SELECT
           Object_Receipt.Id     ::Integer    AS ReceiptId
         , Object_Receipt.ObjectCode AS Code
         , Object_Receipt.ValueData  AS Name

         , ObjectString_Code.ValueData    AS ReceiptCode
         , ObjectBoolean_Main.ValueData   AS isMain
        
         , ObjectFloat_Value.ValueData   ::TFloat      AS Value
         , (ObjectFloat_Value.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) :: TFloat AS ValueWeight         
         , ObjectFloat_TaxExit.ValueData ::TFloat      AS TaxExit

         , ObjectFloat_PartionValue.ValueData ::TFloat AS PartionValue
         , ObjectFloat_PartionCount.ValueData ::TFloat AS PartionCount
         , ObjectFloat_WeightPackage.ValueData::TFloat AS WeightPackage

         , ObjectDate_StartDate.ValueData  AS StartDate
      
         , Object_GoodsGroup.ValueData   AS GoodsGroupName
         , Object_Goods.Id               AS GoodsId
         , Object_Goods.ObjectCode       AS GoodsCode
         , Object_Goods.ValueData        AS GoodsName
         , Object_GoodsKind.ValueData    AS GoodsKindName
         , Object_Measure.ValueData      AS MeasureName
         , Object_InfoMoney_View.InfoMoneyName ::TVarChar as InfoMoneyName

         , tmpReceiptChild.ValueWeight ::TFloat AS ChildValueWeight

         , tmpReceiptChild.isWeightMain ::Boolean AS isWeightMain
         , tmpReceiptChild.isTaxExit ::Boolean AS isTaxExit
         , tmpReceiptChild.isWeightTotal ::Boolean AS isWeightTotal
         
         , Object_GoodsChild.ObjectCode       AS GoodsChildCode
         , CASE WHEN Object_GoodsKindChild.Id <> zc_GoodsKind_WorkProgress() AND Object_GoodsKindChild.ObjectCode = 0
                     THEN Object_GoodsChild.ValueData || ' ' || Object_GoodsKindChild.ValueData
                WHEN Object_GoodsKindChild.Id <> zc_GoodsKind_WorkProgress()
                     THEN Object_GoodsChild.ValueData || ' ' || Object_GoodsKindChild.ValueData
                ELSE Object_GoodsChild.ValueData
           END :: TVarChar AS GoodsChildName

         , COALESCE (Object_MeasureChild_calc.ValueData, Object_MeasureChild.ValueData) :: TVarChar AS MeasureChildName_calc
         , tmpReceiptChild.GroupNumber :: integer As GroupNumber

         , CASE WHEN Object_Goods.Id = zc_Goods_WorkIce() THEN NULL ELSE tmpReceiptChild.InfoMoneyName            END :: TVarChar   AS ChildInfoMoneyName

     FROM Object AS Object_Receipt

          LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                               ON ObjectLink_Receipt_Goods.ObjectId = Object_Receipt.Id
                              AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Receipt_Goods.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

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

          LEFT JOIN ObjectDate AS ObjectDate_StartDate
                               ON ObjectDate_StartDate.ObjectId = Object_Receipt.Id
                              AND ObjectDate_StartDate.DescId = zc_ObjectDate_Receipt_Start()

          LEFT JOIN ObjectDate AS ObjectDate_EndDate
                               ON ObjectDate_EndDate.ObjectId = Object_Receipt.Id
                              AND ObjectDate_EndDate.DescId = zc_ObjectDate_Receipt_End()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()

          LEFT JOIN ObjectString AS ObjectString_Code
                                 ON ObjectString_Code.ObjectId = Object_Receipt.Id
                                AND ObjectString_Code.DescId = zc_ObjectString_Receipt_Code()
 
          LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                ON ObjectFloat_Value.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_Receipt_Value()

          LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit
                                ON ObjectFloat_TaxExit.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_TaxExit.DescId = zc_ObjectFloat_Receipt_TaxExit()

          LEFT JOIN ObjectFloat AS ObjectFloat_PartionValue
                                ON ObjectFloat_PartionValue.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_PartionValue.DescId = zc_ObjectFloat_Receipt_PartionValue()

          LEFT JOIN ObjectFloat AS ObjectFloat_PartionCount
                                ON ObjectFloat_PartionCount.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_PartionCount.DescId = zc_ObjectFloat_Receipt_PartionCount()

          LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                ON ObjectFloat_WeightPackage.ObjectId = Object_Receipt.Id
                               AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_Receipt_WeightPackage()

          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN (SELECT Object_ReceiptChild.Id                          AS Id
                          , Object_Receipt.Id                               AS ReceiptId
                          , Object_Receipt.ValueData                        AS ReceiptName
                          , ObjectLink_ReceiptChild_Goods.ChildObjectId     AS GoodsId
                          , ObjectLink_ReceiptChild_GoodsKind.ChildObjectId AS GoodsKindId
                          , ObjectLink_Goods_Measure.ChildObjectId          AS MeasureId
                          , zfCalc_ReceiptChild_GroupNumber (inGoodsId      := ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                 , inGoodsKindId            := ObjectLink_ReceiptChild_GoodsKind.ChildObjectId
                                                 , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                 , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                 , inIsWeightMain           := ObjectBoolean_WeightMain.ValueData
                                                 , inIsTaxExit              := ObjectBoolean_TaxExit.ValueData
                                                  ) AS GroupNumber
                          , zfCalc_ReceiptChild_isWeightTotal (inGoodsId      := ObjectLink_ReceiptChild_Goods.ChildObjectId
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

                          , Object_InfoMoney_View.InfoMoneyCode
                          , Object_InfoMoney_View.InfoMoneyGroupName
                          , Object_InfoMoney_View.InfoMoneyDestinationName
                          , Object_InfoMoney_View.InfoMoneyName

           FROM Object AS Object_ReceiptChild
                LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                     ON ObjectLink_ReceiptChild_Receipt.ObjectId = Object_ReceiptChild.Id
                                    AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_ReceiptChild_Receipt.ChildObjectId
               
                LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                        ON ObjectBoolean_WeightMain.ObjectId = Object_ReceiptChild.Id
                                       AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                        ON ObjectBoolean_TaxExit.ObjectId = Object_ReceiptChild.Id
                                       AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()
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
           WHERE Object_ReceiptChild.DescId = zc_Object_ReceiptChild()
             AND Object_ReceiptChild.isErased = FALSE
           
             ) AS tmpReceiptChild on tmpReceiptChild.ReceiptId = Object_Receipt.Id

                 LEFT JOIN Object AS Object_GoodsChild ON Object_GoodsChild.Id = tmpReceiptChild.GoodsId
                 LEFT JOIN Object AS Object_GoodsKindChild ON Object_GoodsKindChild.Id = tmpReceiptChild.GoodsKindId
 
                 LEFT JOIN Object AS Object_MeasureChild ON Object_MeasureChild.Id = tmpReceiptChild.MeasureId
                 LEFT JOIN Object AS Object_MeasureChild_calc ON Object_MeasureChild_calc.Id = zc_Measure_Kg() AND Object_MeasureChild.Id = zc_Measure_Sh()
  
     WHERE Object_Receipt.DescId = zc_Object_Receipt()
      AND (Object_Receipt.Id = inReceiptId OR inReceiptId = 0)
      AND (ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)
      AND (ObjectLink_Receipt_GoodsKind.ChildObjectId = inGoodsKindId OR inGoodsKindId = 0)
      AND Object_Receipt.isErased = False
      AND tmpReceiptChild.ValueWeight <> 0
       
    ;

   -- RETURN NEXT Cursor1;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.07.15        *
*/

-- тест
-- SELECT * FROM gpselect_object_receipt_print (0, 5163, 8345, TRUE, zfCalc_UserAdmin())
