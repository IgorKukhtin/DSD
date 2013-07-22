-- Function: gpReport_HistoryCost()

-- DROP FUNCTION gpReport_HistoryCost (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_HistoryCost(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (ObjectCostId Integer
             , UnitParentCode Integer, UnitParentName TVarChar, UnitCode Integer, UnitName TVarChar, GoodsGroupCode Integer, GoodsGroupName TVarChar, GoodsKindCode Integer, GoodsKindName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyCode_Detail Integer, InfoMoneyName_Detail TVarChar
             , PartionGoodsName TVarChar
             , BusinessCode Integer, BusinessName TVarChar, JuridicalBasisCode Integer, JuridicalBasisName TVarChar
             , BranchCode Integer, BranchName TVarChar, PersonalCode Integer, PersonalName TVarChar, AssetCode Integer, AssetName TVarChar
             , CountStart TFloat, CountDebet TFloat, CountKredit TFloat, CountEnd TFloat
             , CountStart_calc TFloat, CountDebet_calc TFloat, CountKredit_calc TFloat, CountEnd_calc TFloat
             , SummStart TFloat, SummDebet TFloat, SummKredit TFloat, SummEnd TFloat
             , SummStart_calc TFloat, SummDebet_calc TFloat, SummKredit_calc TFloat, SummEnd_calc TFloat
              )
AS
$BODY$BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_HistoryCost());

     RETURN QUERY 
       SELECT
             ContainerObjectCost.ObjectCostId

           , Object_UnitParent.ObjectCode AS UnitParentCode
           , Object_UnitParent.ValueData AS UnitParentName
           , Object_Unit.ObjectCode AS UnitCode
           , Object_Unit.ValueData AS UnitName

           , Object_GoodsGroup.ObjectCode AS GoodsGroupCode
           , Object_GoodsGroup.ValueData AS GoodsGroupName
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData AS GoodsName
           , Object_GoodsKind.ObjectCode AS GoodsKindCode
           , Object_GoodsKind.ValueData AS GoodsKindName

           , lfObject_InfoMoney.InfoMoneyCode
           , lfObject_InfoMoney.InfoMoneyName
           , lfObject_InfoMoney_Detail.InfoMoneyCode AS InfoMoneyCode_Detail
           , lfObject_InfoMoney_Detail.InfoMoneyName AS InfoMoneyName_Detail

           , Object_PartionGoods.ValueData AS PartionGoodsName

           , Object_Business.ObjectCode AS BusinessCode
           , Object_Business.ValueData AS BusinessName
           , Object_JuridicalBasis.ObjectCode AS JuridicalBasisCode
           , Object_JuridicalBasis.ValueData AS JuridicalBasisName
           , Object_Branch.ObjectCode AS BranchCode
           , Object_Branch.ValueData AS BranchName
           , Object_Personal.ObjectCode AS PersonalCode
           , Object_Personal.ValueData AS PersonalName
           , Object_Asset.ObjectCode AS AssetCode
           , Object_Asset.ValueData AS AssetName

       FROM ContainerObjectCost
            LEFT JOIN ObjectCostLink AS ObjectCostLink_Unit
                                     ON ObjectCostLink_Unit.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_Unit.DescId = zc_ObjectCostLink_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectCostLink_Unit.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                 ON ObjectLink_Unit_Parent.ObjectId = ObjectCostLink_Unit.ObjectId
                                AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
            LEFT JOIN Object AS Object_UnitParent ON Object_UnitParent.Id = ObjectLink_Unit_Parent.ChildObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_Goods
                                     ON ObjectCostLink_Goods.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_Goods.DescId = zc_ObjectCostLink_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectCostLink_Goods.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectCostLink_Goods.ObjectId
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_GoodsKind
                                     ON ObjectCostLink_GoodsKind.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_GoodsKind.DescId = zc_ObjectCostLink_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectCostLink_GoodsKind.ObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_InfoMoney
                                     ON ObjectCostLink_InfoMoney.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_InfoMoney.DescId = zc_ObjectCostLink_InfoMoney()
            LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ObjectCostLink_InfoMoney.ObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_InfoMoneyDetail
                                     ON ObjectCostLink_InfoMoneyDetail.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_InfoMoneyDetail.DescId = zc_ObjectCostLink_InfoMoneyDetail()
            LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney_Detail ON lfObject_InfoMoney_Detail.InfoMoneyId = ObjectCostLink_InfoMoneyDetail.ObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_PartionGoods
                                     ON ObjectCostLink_PartionGoods.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_PartionGoods.DescId = zc_ObjectCostLink_PartionGoods()
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = ObjectCostLink_PartionGoods.ObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_Business
                                     ON ObjectCostLink_Business.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_Business.DescId = zc_ObjectCostLink_Business()
            LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectCostLink_Business.ObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_JuridicalBasis
                                     ON ObjectCostLink_JuridicalBasis.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_JuridicalBasis.DescId = zc_ObjectCostLink_JuridicalBasis()
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = ObjectCostLink_JuridicalBasis.ObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_Branch
                                     ON ObjectCostLink_Branch.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_Branch.DescId = zc_ObjectCostLink_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectCostLink_Branch.ObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_Personal
                                     ON ObjectCostLink_Personal.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_Personal.DescId = zc_ObjectCostLink_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectCostLink_Personal.ObjectId

            LEFT JOIN ObjectCostLink AS ObjectCostLink_AssetTo
                                     ON ObjectCostLink_AssetTo.ObjectCostId = ContainerObjectCost.ObjectCostId
                                    AND ObjectCostLink_AssetTo.DescId = zc_ObjectCostLink_AssetTo()
            LEFT JOIN Object AS Object_AssetTo ON Object_AssetTo.Id = ObjectCostLink_AssetTo.ObjectId

            LEFT JOIN Object AS Object_AssetTo ON Object_AssetTo.Id = ObjectCostLink_AssetTo.ObjectId

       WHERE ContainerObjectCost.DescId = zc_ObjectCost_Basis() 
  
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_HistoryCost (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.07.13                                        * add optimize
 08.07.13                                        * add ByObjectName
 08.07.13                                        * add AccountOnComplete
 04.07.13                                        *
*/

-- тест
-- SELECT * FROM gpReport_HistoryCost (inStartDate:= '01.01.2013', inEndDate:= '01.01.2013', inSession:= '2')
