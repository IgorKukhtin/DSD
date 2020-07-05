unit dbProcedureBoutiqueTest;

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
    procedure CreatePeriodCloseProcedure;
    procedure CreateReportProcedure;
  end;


implementation

uses zLibUtil, utilConst;

const
  FunctionPath = '..\DATABASE\Boutique\FUNCTION\';
  ReportsPath = '..\DATABASE\Boutique\REPORTS\';
  ProcedurePath = '..\DATABASE\Boutique\PROCEDURE\';
{ TdbProcedureTest }

procedure TdbProcedureTest.CreateHistoryProcedure;
begin
  ExecFile(ProcedurePath + 'ObjectHistory\PriceListItem\gpInsertUpdate_ObjectHistory_PriceListItem.sql', ZQuery);
end;

procedure TdbProcedureTest.CreateMovementItemProcedure;
begin
//  ExecFile(ProcedurePath + 'MovementItem\Income\gpInsertUpdate_MovementItem_Income.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\Income\gpSelect_MovementItem_Income.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'MovementItem\Income\gpInsertUpdate_MovementItem_IncomeFuel.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\Income\gpSelect_MovementItem_IncomeFuel.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\Income\lpInsertUpdate_MovementItem_IncomeFuel.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'MovementItem\ProductionUnion\gpInsertUpdate_MI_ProductionUnion_Child.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\ProductionUnion\gpInsertUpdate_MI_ProductionUnion_Master.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\ProductionUnion\gpSelect_MI_ProductionUnion.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\ProductionUnion\gpSelect_MI_ProductionUnion_Master.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'MovementItem\ProductionSeparate\gpInsertUpdate_MI_ProductionSeparate_Child.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\ProductionSeparate\gpInsertUpdate_MI_ProductionSeparate_Master.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\ProductionSeparate\gpSelect_MI_ProductionSeparate.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\ProductionSeparate\gpSelect_MI_ProductionSeparate_Master.sql', ZQuery);
//
//
//  ExecFile(ProcedurePath + 'MovementItem\Send\gpInsertUpdate_MovementItem_Send.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\Send\gpSelect_MovementItem_Send.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'MovementItem\SendOnPrice\gpInsertUpdate_MovementItem_SendOnPrice.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\SendOnPrice\gpSelect_MovementItem_SendOnPrice.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'MovementItem\Sale\gpInsertUpdate_MovementItem_Sale.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\Sale\gpSelect_MovementItem_Sale.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'MovementItem\ReturnOut\gpInsertUpdate_MovementItem_ReturnOut.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\ReturnOut\gpSelect_MovementItem_ReturnOut.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'MovementItem\ReturnIn\gpInsertUpdate_MovementItem_ReturnIn.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\ReturnIn\gpSelect_MovementItem_ReturnIn.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'MovementItem\Loss\gpInsertUpdate_MovementItem_Loss.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\Loss\gpSelect_MovementItem_Loss.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'MovementItem\Inventory\gpInsertUpdate_MovementItem_Inventory.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\Inventory\gpSelect_MovementItem_Inventory.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'MovementItem\OrderExternal\gpInsertUpdate_MovementItem_OrderExternal.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\OrderExternal\gpSelect_MovementItem_OrderExternal.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\OrderExternal\gpMovementItem_OrderExternal_SetErased.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\OrderExternal\gpMovementItem_OrderExternal_SetUnErased.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'MovementItem\OrderInternal\gpInsertUpdate_MovementItem_OrderInternal.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\OrderInternal\gpSelect_MovementItem_OrderInternal.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\OrderInternal\gpMovementItem_OrderInternal_SetErased.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\OrderInternal\gpMovementItem_OrderInternal_SetUnErased.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'MovementItem\PriceCorrective\gpInsertUpdate_MovementItem_PriceCorrective.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\PriceCorrective\gpSelect_MovementItem_PriceCorrective.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\PriceCorrective\lpInsertUpdate_MovementItem_PriceCorrective.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\PriceCorrective\gpMovementItem_PriceCorrective_SetErased.sql', ZQuery);
//  ExecFile(ProcedurePath + 'MovementItem\PriceCorrective\gpMovementItem_PriceCorrective_SetUnErased.sql', ZQuery);
//
//  ScriptDirectory := ProcedurePath + 'MovementItem\Cash\';
//  ProcedureLoad;
end;

procedure TdbProcedureTest.CreateMovementProcedure;
begin
  ScriptDirectory := ProcedurePath + 'Movement\';
  ProcedureLoad;
end;

procedure TdbProcedureTest.CreateObjectProcedure;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\_Common\';
  ProcedureLoad;

  ExecFile(ProcedurePath + 'OBJECTS\User\gpInsertUpdate_Object_User.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\User\gpSelect_Object_User.sql', ZQuery);
  ExecFile(ProcedurePath + 'OBJECTS\User\gpGet_Object_User.sql', ZQuery);

//  ExecFile(ProcedurePath + 'OBJECTS\Form\gpInsertUpdate_Object_Form.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Form\gpGet_Object_Form.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\UserFormSettings\gpInsertUpdate_Object_UserFormSettings.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\UserFormSettings\gpGet_Object_UserFormSettings.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\AccountDirection\lfSelect_Object_AccountDirection.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\AccountDirection\gpInsertUpdate_Object_AccountDirection.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\AccountDirection\gpSelect_Object_AccountDirection.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\AccountDirection\gpGet_Object_AccountDirection.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\AccountGroup\gpInsertUpdate_Object_AccountGroup.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\AccountGroup\gpSelect_Object_AccountGroup.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\AccountGroup\gpGet_Object_AccountGroup.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\ArticleLoss\gpInsertUpdate_Object_ArticleLoss.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ArticleLoss\gpSelect_Object_ArticleLoss.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ArticleLoss\gpGet_Object_ArticleLoss.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\Bank\gpInsertUpdate_Object_Bank.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Bank\gpSelect_Object_Bank.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Bank\gpGet_Object_Bank.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\BankAccount\gpInsertUpdate_Object_BankAccount.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\BankAccount\gpSelect_Object_BankAccount.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\BankAccount\gpGet_Object_BankAccount.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\BankAccountContract\gpInsertUpdate_Object_BankAccountContract.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\BankAccountContract\gpSelect_Object_BankAccountContract.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\BankAccountContract\gpGet_Object_BankAccountContract.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\Branch\gpInsertUpdate_Object_Branch.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Branch\gpSelect_Object_Branch.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Branch\gpGet_Object_Branch.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\Business\gpInsertUpdate_Object_Business.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Business\gpSelect_Object_Business.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Business\gpGet_Object_Business.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\Car\gpInsertUpdate_Object_Car.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Car\gpSelect_Object_Car.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Car\gpGet_Object_Car.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\CarModel\gpInsertUpdate_Object_CarModel.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\CarModel\gpSelect_Object_CarModel.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\CarModel\gpGet_Object_CarModel.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\Contract\gpInsertUpdate_Object_Contract.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Contract\gpSelect_Object_Contract.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Contract\gpGet_Object_Contract.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\ContractKind\gpInsertUpdate_Object_ContractKind.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ContractKind\gpSelect_Object_ContractKind.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ContractKind\gpGet_Object_ContractKind.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\Currency\gpInsertUpdate_Object_Currency.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Currency\gpSelect_Object_Currency.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Currency\gpGet_Object_Currency.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\Goods\gpInsertUpdate_Object_Goods.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Goods\gpSelect_Object_Goods.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Goods\gpGet_Object_Goods.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Goods\gpInsertUpdate_ObjectBoolean_Goods_Partion.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\Founder\gpInsertUpdate_Object_Founder.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Founder\gpSelect_Object_Founder.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Founder\gpGet_Object_Founder.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\GoodsGroup\gpInsertUpdate_Object_GoodsGroup.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\GoodsGroup\gpSelect_Object_GoodsGroup.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\GoodsGroup\gpGet_Object_GoodsGroup.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\GoodsGroupStat\gpInsertUpdate_Object_GoodsGroupStat.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\GoodsGroupStat\gpSelect_Object_GoodsGroupStat.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\GoodsGroupStat\gpGet_Object_GoodsGroupStat.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\GoodsKind\gpInsertUpdate_Object_GoodsKind.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\GoodsKind\gpSelect_Object_GoodsKind.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\GoodsKind\gpGet_Object_GoodsKind.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\GoodsProperty\gpInsertUpdate_Object_GoodsProperty.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\GoodsProperty\gpSelect_Object_GoodsProperty.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\GoodsProperty\gpGet_Object_GoodsProperty.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\GoodsPropertyValue\gpInsertUpdate_Object_GoodsPropertyValue.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\GoodsPropertyValue\gpSelect_Object_GoodsPropertyValue.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\GoodsPropertyValue\gpGet_Object_GoodsPropertyValue.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\InfoMoneyDestination\gpInsertUpdate_Object_InfoMoneyDestination.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\InfoMoneyDestination\gpSelect_Object_InfoMoneyDestination.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\InfoMoneyDestination\gpGet_Object_InfoMoneyDestination.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\InfoMoneyDestination\lfSelect_Object_InfoMoneyDestination.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\InfoMoneyGroup\gpInsertUpdate_Object_InfoMoneyGroup.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\InfoMoneyGroup\gpSelect_Object_InfoMoneyGroup.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\InfoMoneyGroup\gpGet_Object_InfoMoneyGroup.sql', ZQuery);
//
////  ExecFile(ProcedurePath + 'OBJECTS\Juridical\gpInsertUpdate_Object_Juridical.sql', ZQuery);
////  ExecFile(ProcedurePath + 'OBJECTS\Juridical\gpSelect_Object_Juridical.sql', ZQuery);
////  ExecFile(ProcedurePath + 'OBJECTS\Juridical\gpGet_Object_Juridical.sql', ZQuery);
//  ScriptDirectory := ProcedurePath + 'OBJECTS\Juridical\';
//  ProcedureLoad;
//
//  ExecFile(ProcedurePath + 'OBJECTS\JuridicalGroup\gpInsertUpdate_Object_JuridicalGroup.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\JuridicalGroup\gpSelect_Object_JuridicalGroup.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\JuridicalGroup\gpGet_Object_JuridicalGroup.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\Measure\gpInsertUpdate_Object_Measure.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Measure\gpSelect_Object_Measure.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Measure\gpGet_Object_Measure.sql', ZQuery);
//
////  ExecFile(ProcedurePath + 'OBJECTS\Partner\gpInsertUpdate_Object_Partner.sql', ZQuery);
////  ExecFile(ProcedurePath + 'OBJECTS\Partner\gpSelect_Object_Partner.sql', ZQuery);
////  ExecFile(ProcedurePath + 'OBJECTS\Partner\gpGet_Object_Partner.sql', ZQuery);
//  ScriptDirectory := ProcedurePath + 'OBJECTS\Partner\';
//  ProcedureLoad;
//
//  ExecFile(ProcedurePath + 'OBJECTS\PriceList\gpInsertUpdate_Object_PriceList.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\PriceList\gpSelect_Object_PriceList.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\PriceList\gpGet_Object_PriceList.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\PriceListItem\lpGetInsert_Object_PriceListItem.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\Route\gpInsertUpdate_Object_Route.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Route\gpSelect_Object_Route.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Route\gpGet_Object_Route.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\RouteSorting\gpInsertUpdate_Object_RouteSorting.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\RouteSorting\gpSelect_Object_RouteSorting.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\RouteSorting\gpGet_Object_RouteSorting.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\PaidKind\gpInsertUpdate_Object_PaidKind.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\PaidKind\gpSelect_Object_PaidKind.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\PaidKind\gpGet_Object_PaidKind.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\DocumentTaxKind\gpInsertUpdate_Object_DocumentTaxKind.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\DocumentTaxKind\gpSelect_Object_DocumentTaxKind.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\DocumentTaxKind\gpGet_Object_DocumentTaxKind.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\ProfitLoss\lfSelect_Object_ProfitLoss.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ProfitLoss\gpInsertUpdate_Object_ProfitLoss.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ProfitLoss\gpSelect_Object_ProfitLoss.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ProfitLoss\gpGet_Object_ProfitLoss.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\ProfitLossDirection\lfSelect_Object_ProfitLossDirection.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ProfitLossDirection\gpInsertUpdate_Object_ProfitLossDirection.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ProfitLossDirection\gpSelect_Object_ProfitLossDirection.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ProfitLossDirection\gpGet_Object_ProfitLossDirection.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\ProfitLossGroup\gpInsertUpdate_Object_ProfitLossGroup.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ProfitLossGroup\gpSelect_Object_ProfitLossGroup.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ProfitLossGroup\gpGet_Object_ProfitLossGroup.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\ProfitLoss\gpInsertUpdate_Object_ProfitLoss.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ProfitLoss\gpSelect_Object_ProfitLoss.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ProfitLoss\gpGet_Object_ProfitLoss.sql', ZQuery);
//
////  ExecFile(ProcedurePath + 'OBJECTS\Member\gpInsertUpdate_Object_Member.sql', ZQuery);
////  ExecFile(ProcedurePath + 'OBJECTS\Member\gpSelect_Object_Member.sql', ZQuery);
////  ExecFile(ProcedurePath + 'OBJECTS\Member\gpGet_Object_Member.sql', ZQuery);
//  ScriptDirectory := ProcedurePath + 'OBJECTS\Member\';
//  ProcedureLoad;
//
//  ExecFile(ProcedurePath + 'OBJECTS\Position\gpInsertUpdate_Object_Position.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Position\gpSelect_Object_Position.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Position\gpGet_Object_Position.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\Personal\gpInsertUpdate_Object_Personal.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Personal\gpSelect_Object_Personal.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Personal\gpGet_Object_Personal.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\AssetGroup\gpInsertUpdate_Object_AssetGroup.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\AssetGroup\gpSelect_Object_AssetGroup.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\AssetGroup\gpGet_Object_AssetGroup.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\Asset\gpInsertUpdate_Object_Asset.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Asset\gpSelect_Object_Asset.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Asset\gpGet_Object_Asset.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\PartionGoods\lfGet_Object_PartionGoods_InvNumber.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\PartionGoods\lpInsertFind_Object_PartionGoods - InvNumber.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\PartionGoods\lpInsertFind_Object_PartionGoods - PartionDate.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\PartionGoods\lpInsertFind_Object_PartionGoods - PartionString.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\PartionMovement\lpInsertFind_Object_PartionMovement.sql', ZQuery);
//
//  //ExecFile(ProcedurePath + 'OBJECTS\GoodsByGoodsKind\lfSelect_Object_GoodsByGoodsKind.sql', ZQuery);
//  //ExecFile(ProcedurePath + 'OBJECTS\GoodsByGoodsKind\lpInsert_Object_GoodsByGoodsKind.sql', ZQuery);
//  ScriptDirectory := ProcedurePath + 'OBJECTS\GoodsByGoodsKind\';
//  ProcedureLoad;
//
//  ExecFile(ProcedurePath + 'OBJECTS\ReceiptCost\gpInsertUpdate_Object_ReceiptCost.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ReceiptCost\gpSelect_Object_ReceiptCost.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ReceiptCost\gpGet_Object_ReceiptCost.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\ReceiptChild\gpInsertUpdate_Object_ReceiptChild.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ReceiptChild\gpSelect_Object_ReceiptChild.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\ReceiptChild\gpGet_Object_ReceiptChild.sql', ZQuery);
//
//  ExecFile(ProcedurePath + 'OBJECTS\Receipt\gpInsertUpdate_Object_Receipt.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Receipt\gpSelect_Object_Receipt.sql', ZQuery);
//  ExecFile(ProcedurePath + 'OBJECTS\Receipt\gpGet_Object_Receipt.sql', ZQuery);
//
//  ScriptDirectory := ProcedurePath + 'OBJECTS\StreetKind\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\Street\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\Region\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\ProvinceCity\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\Province\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\ContactPersonKind\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\ContactPerson\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\City\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\CityKind\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\Storage\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\AreaContract\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\Retail\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\RetailReport\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\PartnerTag\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\GoodsGroupAnalyst\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\ContractTagGroup\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\GoodsTag\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\ContractTag\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\ContractPartner\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\ContractGoods\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\Quality\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\OrderType\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\GoodsPlatform\';
//  ProcedureLoad;
//  ScriptDirectory := ProcedurePath + 'OBJECTS\RouteGroup\';
//  ProcedureLoad;
end;

procedure TdbProcedureTest.CreatePeriodCloseProcedure;
begin
  ScriptDirectory := ProcedurePath + 'PeriodClose\';
  ProcedureLoad;
end;

procedure TdbProcedureTest.CreateReportProcedure;
begin
  DirectoryLoad(ReportsPath);
end;

initialization
//  TestFramework.RegisterTest('Процедуры', TdbProcedureTest.Suite);


end.
