unit dbProcedureTest;

interface
uses TestFramework, dbTest;

type
  TdbProcedureTest = class (TdbTest)
  private
    procedure CreateHistoryProcedure;
  published
    procedure CreateMovementProcedure;
    procedure CreateMovementItemProcedure;
    procedure CreateObjectProcedure;
    procedure CreateReportProcedure;
  end;


implementation

uses zLibUtil, utilConst;

const
  FunctionPath = '..\DATABASE\COMMON\FUNCTION\';
  ReportsPath = '..\DATABASE\COMMON\REPORTS\';

{ TdbProcedureTest }

procedure TdbProcedureTest.CreateHistoryProcedure;
begin
  ExecFile(ProcedurePath + 'ObjectHistory\_PriceListItem\gpInsertUpdate_ObjectHistory_PriceListItem.sql', ZQuery);
end;

procedure TdbProcedureTest.CreateMovementItemProcedure;
begin
  ExecFile(ProcedurePath + 'MovementItem\_Income\gpInsertUpdate_MovementItem_Income.sql', ZQuery);
  ExecFile(ProcedurePath + 'MovementItem\_Income\gpSelect_MovementItem_Income.sql', ZQuery);

  ExecFile(ProcedurePath + 'MovementItem\_ProductionUnion\gpInsertUpdate_MI_ProductionUnion_Child.sql', ZQuery);
  ExecFile(ProcedurePath + 'MovementItem\_ProductionUnion\gpInsertUpdate_MI_ProductionUnion_Master.sql', ZQuery);
  ExecFile(ProcedurePath + 'MovementItem\_ProductionUnion\gpSelect_MI_ProductionUnion.sql', ZQuery);
  ExecFile(ProcedurePath + 'MovementItem\_ProductionUnion\gpSelect_MI_ProductionUnion_Master.sql', ZQuery);

  ExecFile(ProcedurePath + 'MovementItem\_ProductionSeparate\gpInsertUpdate_MI_ProductionSeparate_Child.sql', ZQuery);
  ExecFile(ProcedurePath + 'MovementItem\_ProductionSeparate\gpInsertUpdate_MI_ProductionSeparate_Master.sql', ZQuery);
  ExecFile(ProcedurePath + 'MovementItem\_ProductionSeparate\gpSelect_MI_ProductionSeparate.sql', ZQuery);
  ExecFile(ProcedurePath + 'MovementItem\_ProductionSeparate\gpSelect_MI_ProductionSeparate_Master.sql', ZQuery);


  ExecFile(ProcedurePath + 'MovementItem\_Send\gpInsertUpdate_MovementItem_Send.sql', ZQuery);
  ExecFile(ProcedurePath + 'MovementItem\_Send\gpSelect_MovementItem_Send.sql', ZQuery);

  ExecFile(ProcedurePath + 'MovementItem\_SendOnPrice\gpInsertUpdate_MovementItem_SendOnPrice.sql', ZQuery);
  ExecFile(ProcedurePath + 'MovementItem\_SendOnPrice\gpSelect_MovementItem_SendOnPrice.sql', ZQuery);

  ExecFile(ProcedurePath + 'MovementItem\_Sale\gpInsertUpdate_MovementItem_Sale.sql', ZQuery);
  ExecFile(ProcedurePath + 'MovementItem\_Sale\gpSelect_MovementItem_Sale.sql', ZQuery);

  ExecFile(ProcedurePath + 'MovementItem\_ReturnOut\gpInsertUpdate_MovementItem_ReturnOut.sql', ZQuery);
  ExecFile(ProcedurePath + 'MovementItem\_ReturnOut\gpSelect_MovementItem_ReturnOut.sql', ZQuery);

  ExecFile(ProcedurePath + 'MovementItem\_ReturnIn\gpInsertUpdate_MovementItem_ReturnIn.sql', ZQuery);
  ExecFile(ProcedurePath + 'MovementItem\_ReturnIn\gpSelect_MovementItem_ReturnIn.sql', ZQuery);

  ExecFile(ProcedurePath + 'MovementItem\_Loss\gpInsertUpdate_MovementItem_Loss.sql', ZQuery);
  ExecFile(ProcedurePath + 'MovementItem\_Loss\gpSelect_MovementItem_Loss.sql', ZQuery);

  ExecFile(ProcedurePath + 'MovementItem\_Inventory\gpInsertUpdate_MovementItem_Inventory.sql', ZQuery);
  ExecFile(ProcedurePath + 'MovementItem\_Inventory\gpSelect_MovementItem_Inventory.sql', ZQuery);

  ExecFile(ProcedurePath + 'MovementItem\_ZakazExternal\gpInsertUpdate_MI_ZakazExternal.sql', ZQuery);
  ExecFile(ProcedurePath + 'MovementItem\_ZakazExternal\gpSelect_MI_ZakazExternal.sql', ZQuery);

  ExecFile(ProcedurePath + 'MovementItem\_ZakazInternal\gpInsertUpdate_MI_ZakazInternal.sql', ZQuery);
  ExecFile(ProcedurePath + 'MovementItem\_ZakazInternal\gpSelect_MI_ZakazInternal.sql', ZQuery);

end;

procedure TdbProcedureTest.CreateMovementProcedure;
begin
  ScriptDirectory := ProcedurePath + 'Movement\';
  ProcedureLoad;
end;

procedure TdbProcedureTest.CreateObjectProcedure;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Common\';
  ProcedureLoad;

  ExecFile(ProcedurePath + 'OBJECTS\_User\gpInsertUpdate_Object_User.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_User\gpSelect_Object_User.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_User\gpGet_Object_User.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_Form\gpInsertUpdate_Object_Form.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Form\gpGet_Object_Form.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_UserFormSettings\gpInsertUpdate_Object_UserFormSettings.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_UserFormSettings\gpGet_Object_UserFormSettings.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_AccountDirection\lfSelect_Object_AccountDirection.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_AccountDirection\gpInsertUpdate_Object_AccountDirection.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_AccountDirection\gpSelect_Object_AccountDirection.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_AccountDirection\gpGet_Object_AccountDirection.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_AccountGroup\gpInsertUpdate_Object_AccountGroup.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_AccountGroup\gpSelect_Object_AccountGroup.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_AccountGroup\gpGet_Object_AccountGroup.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_Bank\gpInsertUpdate_Object_Bank.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Bank\gpSelect_Object_Bank.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Bank\gpGet_Object_Bank.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_BankAccount\gpInsertUpdate_Object_BankAccount.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_BankAccount\gpSelect_Object_BankAccount.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_BankAccount\gpGet_Object_BankAccount.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_Branch\gpInsertUpdate_Object_Branch.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Branch\gpSelect_Object_Branch.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Branch\gpGet_Object_Branch.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_Business\gpInsertUpdate_Object_Business.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Business\gpSelect_Object_Business.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Business\gpGet_Object_Business.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_Car\gpInsertUpdate_Object_Car.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Car\gpSelect_Object_Car.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Car\gpGet_Object_Car.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_CarModel\gpInsertUpdate_Object_CarModel.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_CarModel\gpSelect_Object_CarModel.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_CarModel\gpGet_Object_CarModel.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_Contract\gpInsertUpdate_Object_Contract.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Contract\gpSelect_Object_Contract.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Contract\gpGet_Object_Contract.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_ContractKind\gpInsertUpdate_Object_ContractKind.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_ContractKind\gpSelect_Object_ContractKind.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_ContractKind\gpGet_Object_ContractKind.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_Currency\gpInsertUpdate_Object_Currency.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Currency\gpSelect_Object_Currency.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Currency\gpGet_Object_Currency.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_Goods\gpInsertUpdate_Object_Goods.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Goods\gpSelect_Object_Goods.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Goods\gpGet_Object_Goods.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Goods\gpInsertUpdate_ObjectBoolean_Goods_Partion.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_GoodsGroup\gpInsertUpdate_Object_GoodsGroup.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_GoodsGroup\gpSelect_Object_GoodsGroup.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_GoodsGroup\gpGet_Object_GoodsGroup.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_GoodsKind\gpInsertUpdate_Object_GoodsKind.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_GoodsKind\gpSelect_Object_GoodsKind.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_GoodsKind\gpGet_Object_GoodsKind.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_GoodsProperty\gpInsertUpdate_Object_GoodsProperty.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_GoodsProperty\gpSelect_Object_GoodsProperty.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_GoodsProperty\gpGet_Object_GoodsProperty.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_GoodsPropertyValue\gpInsertUpdate_Object_GoodsPropertyValue.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_GoodsPropertyValue\gpSelect_Object_GoodsPropertyValue.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_GoodsPropertyValue\gpGet_Object_GoodsPropertyValue.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_InfoMoneyDestination\gpInsertUpdate_Object_InfoMoneyDestination.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_InfoMoneyDestination\gpSelect_Object_InfoMoneyDestination.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_InfoMoneyDestination\gpGet_Object_InfoMoneyDestination.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_InfoMoneyDestination\lfSelect_Object_InfoMoneyDestination.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_InfoMoneyGroup\gpInsertUpdate_Object_InfoMoneyGroup.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_InfoMoneyGroup\gpSelect_Object_InfoMoneyGroup.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_InfoMoneyGroup\gpGet_Object_InfoMoneyGroup.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_Juridical\gpInsertUpdate_Object_Juridical.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Juridical\gpSelect_Object_Juridical.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Juridical\gpGet_Object_Juridical.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_JuridicalGroup\gpInsertUpdate_Object_JuridicalGroup.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_JuridicalGroup\gpSelect_Object_JuridicalGroup.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_JuridicalGroup\gpGet_Object_JuridicalGroup.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_Measure\gpInsertUpdate_Object_Measure.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Measure\gpSelect_Object_Measure.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Measure\gpGet_Object_Measure.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_Partner\gpInsertUpdate_Object_Partner.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Partner\gpSelect_Object_Partner.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Partner\gpGet_Object_Partner.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_PriceList\gpInsertUpdate_Object_PriceList.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_PriceList\gpSelect_Object_PriceList.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_PriceList\gpGet_Object_PriceList.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_PriceListItem\lpGetInsert_Object_PriceListItem.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_Route\gpInsertUpdate_Object_Route.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Route\gpSelect_Object_Route.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Route\gpGet_Object_Route.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_RouteSorting\gpInsertUpdate_Object_RouteSorting.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_RouteSorting\gpSelect_Object_RouteSorting.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_RouteSorting\gpGet_Object_RouteSorting.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_PaidKind\gpInsertUpdate_Object_PaidKind.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_PaidKind\gpSelect_Object_PaidKind.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_PaidKind\gpGet_Object_PaidKind.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_ProfitLoss\lfSelect_Object_ProfitLoss.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_ProfitLoss\gpInsertUpdate_Object_ProfitLoss.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_ProfitLoss\gpSelect_Object_ProfitLoss.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_ProfitLoss\gpGet_Object_ProfitLoss.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_ProfitLossDirection\lfSelect_Object_ProfitLossDirection.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_ProfitLossDirection\gpInsertUpdate_Object_ProfitLossDirection.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_ProfitLossDirection\gpSelect_Object_ProfitLossDirection.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_ProfitLossDirection\gpGet_Object_ProfitLossDirection.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_ProfitLossGroup\gpInsertUpdate_Object_ProfitLossGroup.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_ProfitLossGroup\gpSelect_Object_ProfitLossGroup.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_ProfitLossGroup\gpGet_Object_ProfitLossGroup.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_ProfitLoss\gpInsertUpdate_Object_ProfitLoss.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_ProfitLoss\gpSelect_Object_ProfitLoss.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_ProfitLoss\gpGet_Object_ProfitLoss.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_Member\gpInsertUpdate_Object_Member.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Member\gpSelect_Object_Member.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Member\gpGet_Object_Member.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_Position\gpInsertUpdate_Object_Position.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Position\gpSelect_Object_Position.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Position\gpGet_Object_Position.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_Personal\gpInsertUpdate_Object_Personal.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Personal\gpSelect_Object_Personal.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Personal\gpGet_Object_Personal.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_AssetGroup\gpInsertUpdate_Object_AssetGroup.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_AssetGroup\gpSelect_Object_AssetGroup.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_AssetGroup\gpGet_Object_AssetGroup.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_Asset\gpInsertUpdate_Object_Asset.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Asset\gpSelect_Object_Asset.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Asset\gpGet_Object_Asset.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_PartionGoods\lpInsertFind_Object_PartionGoods - Date.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_PartionGoods\lpInsertFind_Object_PartionGoods - String.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_PartionMovement\lpInsertFind_Object_PartionMovement.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_GoodsByGoodsKind\lfSelect_Object_GoodsByGoodsKind.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_GoodsByGoodsKind\lpInsert_Object_GoodsByGoodsKind.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_ReceiptCost\gpInsertUpdate_Object_ReceiptCost.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_ReceiptCost\gpSelect_Object_ReceiptCost.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_ReceiptCost\gpGet_Object_ReceiptCost.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_ReceiptChild\gpInsertUpdate_Object_ReceiptChild.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_ReceiptChild\gpSelect_Object_ReceiptChild.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_ReceiptChild\gpGet_Object_ReceiptChild.sql', ZQuery);

  ExecFile(ProcedurePath + 'OBJECTS\_Receipt\gpInsertUpdate_Object_Receipt.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Receipt\gpSelect_Object_Receipt.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\_Receipt\gpGet_Object_Receipt.sql', ZQuery);

end;

procedure TdbProcedureTest.CreateReportProcedure;
begin
  ExecFile(ReportsPath + '_Balance\gpReport_Balance.sql', ZQuery);
  ExecFile(ReportsPath + '_HistoryCost\gpReport_HistoryCost.sql', ZQuery);
  ExecFile(ReportsPath + '_MotionGoods\gpReport_MotionGoods.sql', ZQuery);
end;

initialization
  TestFramework.RegisterTest('Процедуры', TdbProcedureTest.Suite);


end.
