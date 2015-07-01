-- Function: gpReport_GoodsMI_Package ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_Package (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_Package(
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inUnitId       Integer   , 
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar
             , GoodsCode_basis Integer, GoodsName_basis TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar, MeasureName TVarChar

             , ReceiptCode_code Integer, ReceiptCode TVarChar, ReceiptName TVarChar

             , Amount_Send_out TFloat, Weight_Send_out TFloat
             , Amount_Send_in TFloat, Weight_Send_in TFloat
         
             , Amount_Production TFloat, Weight_Production TFloat
             , CountPackage TFloat, WeightPackage TFloat, WeightPackage_one TFloat
             , CountPackage_calc TFloat, WeightPackage_calc TFloat

             , Weight_diff TFloat
              )
AS
$BODY$
BEGIN

    -- Результат
    RETURN QUERY
         -- 
    WITH tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                      FROM Object_InfoMoney_View
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                               AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                      WHERE Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                         OR Object_InfoMoney_View.InfoMoneyGroupId       = zc_Enum_InfoMoneyGroup_30000() -- Доходы 
                     )
        , tmpMI_1 AS  (SELECT MIContainer.ContainerId                 AS ContainerId
                           , MIContainer.ObjectId_Analyzer           AS GoodsId
                           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Send()            AND MIContainer.IsActive = TRUE  THEN      MIContainer.Amount ELSE 0 END) AS Amount_Send_in
                           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Send()            AND MIContainer.IsActive = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Amount_Send_out
                           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion() AND MIContainer.IsActive = FALSE AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_ReWork() THEN -1 * MIContainer.Amount ELSE 0 END) AS Amount_Production
                           , SUM (COALESCE (MIFloat_CountPack.ValueData ,0)) AS CountPack
                      FROM MovementItemContainer AS MIContainer
                           INNER JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                           LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                       ON MIFloat_CountPack.MovementItemId = MIContainer.MovementItemId
                                                      AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                                                      AND MIContainer.MovementDescId = zc_Movement_Send()
                                                      AND MIContainer.IsActive = FALSE
                      WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                        AND MIContainer.DescId = zc_MIContainer_Count()
                        AND MIContainer.WhereObjectId_Analyzer = inUnitId
                        AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion())
                        -- AND MIContainer.Amount <> 0
                      GROUP BY MIContainer.ContainerId
                             , MIContainer.ObjectId_Analyzer
                      )
       
    
       , tmpMI_Union AS (SELECT tmpMI_1.GoodsId
                              , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                              , SUM (tmpMI_1.Amount_Send_in)         AS Amount_Send_in
                              , SUM (tmpMI_1.Amount_Send_out)        AS Amount_Send_out
                              , SUM (tmpMI_1.Amount_Production) AS Amount_Production
                              , SUM (tmpMI_1.CountPack)              AS CountPack
                         FROM tmpMI_1
                              LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                            ON CLO_GoodsKind.ContainerId = tmpMI_1.ContainerId
                                                           AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                         GROUP BY tmpMI_1.GoodsId, CLO_GoodsKind.ObjectId
                         )
           , tmpReceipt AS (SELECT tmpMI_Union.GoodsId
                                 , tmpMI_Union.GoodsKindId
                                 , MAX (Object_Receipt.Id) AS ReceiptId
                                 , MAX (COALESCE (ObjectLink_Receipt_Goods_Parent_0.ChildObjectId, 0)) AS GoodsId_basis
                            FROM tmpMI_Union
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
    -- Результат
    SELECT ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , Object_Goods_basis.ObjectCode              AS GoodsCode_basis
         , Object_Goods_basis.ValueData               AS GoodsName_basis
         , Object_Goods.ObjectCode                    AS GoodsCode
         , Object_Goods.ValueData                     AS GoodsName
         , Object_GoodsKind.ValueData                 AS GoodsKindName
         , Object_Measure.ValueData                   AS MeasureName

         , Object_Receipt.ObjectCode           AS ReceiptCode_code
         , ObjectString_Receipt_Code.ValueData AS ReceiptCode
         , Object_Receipt.ValueData            AS ReceiptName

         , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpMI_Union.Amount_Send_out  ELSE 0 END                                 :: TFloat AS Amount_Send_out
         , (tmpMI_Union.Amount_Send_out * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Weight_Send_out

         , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpMI_Union.Amount_Send_in  ELSE 0 END                                  :: TFloat AS Amount_Send_in
         , (tmpMI_Union.Amount_Send_in * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)  :: TFloat  AS Weight_Send_in
         
         , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpMI_Union.Amount_Production  ELSE 0 END                                 :: TFloat AS Amount_Production
         , (tmpMI_Union.Amount_Production * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Weight_Production

         , tmpMI_Union.CountPack                                                       :: TFloat AS CountPackage
         , (tmpMI_Union.CountPack * COALESCE (ObjectFloat_WeightPackage.ValueData, 0)) :: TFloat AS WeightPackage
         , ObjectFloat_WeightPackage.ValueData                                                   AS WeightPackage_one

         , CASE WHEN ObjectFloat_WeightTotal.ValueData <> 0
                     THEN CAST ((tmpMI_Union.Amount_Send_out * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)
                              / ObjectFloat_WeightTotal.ValueData AS NUMERIC (16, 0))
                ELSE 0
           END :: TFloat AS CountPackage_calc
         , CASE WHEN ObjectFloat_WeightTotal.ValueData <> 0
                     THEN CAST ((tmpMI_Union.Amount_Send_out * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)
                              / ObjectFloat_WeightTotal.ValueData AS NUMERIC (16, 0))
                        * COALESCE (ObjectFloat_WeightPackage.ValueData, 0)
                ELSE 0
           END :: TFloat AS WeightPackage_calc

         , ((tmpMI_Union.Amount_Send_out + tmpMI_Union.Amount_Production - tmpMI_Union.Amount_Send_in) * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
           ) :: TFloat AS Weight_diff

     FROM tmpMI_Union
          LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId     = tmpMI_Union.GoodsId
                              AND tmpReceipt.GoodsKindId = tmpMI_Union.GoodsKindId
                              AND tmpReceipt.GoodsId_basis <> 0

          LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = COALESCE (tmpReceipt.GoodsId_basis, tmpMI_Union.GoodsId)
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpMI_Union.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI_Union.GoodsKindId
          
          LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = tmpMI_Union.GoodsId
                                                AND Object_GoodsByGoodsKind_View.GoodsKindId = tmpMI_Union.GoodsKindId
         -- а теперь привязываю  zc_ObjectFloat_GoodsByGoodsKind_WeightPackage 
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()


          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                              AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                             
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

          LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpReceipt.ReceiptId
          LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                 ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()
    ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsMI_Package (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.06.15                                        * ALL
 04.04.15         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_Package(inStartDate:= '01.06.2015', inEndDate:= '01.06.2015', inUnitId:= 8451, inSession:= zfCalc_UserAdmin()) ORDER BY 2;
