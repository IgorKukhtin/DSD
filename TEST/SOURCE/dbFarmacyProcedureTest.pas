unit dbFarmacyProcedureTest;

interface
uses TestFramework, ZConnection, ZDataset;

type
  TdbProcedureTest = class (TTestCase)
  private
    ZConnection: TZConnection;
    ZQuery: TZQuery;
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure CreateFunction;
    procedure CreateContainerProcedure;
    procedure CreateHistoryProcedure;
    procedure CreateMovementProcedure;
    procedure CreateMovementItemProcedure;
    procedure CreateMovementItemContainerProcedure;
    procedure CreateObjectProcedure;
    procedure CreateProtocolProcedure;
    procedure CreateReportProcedure;
  end;


implementation

uses zLibUtil;

const
  CommonFunctionPath = '..\DATABASE\COMMON\FUNCTION\';
  CommonProcedurePath = '..\DATABASE\COMMON\PROCEDURE\';
  CommonReportsPath = '..\DATABASE\COMMON\REPORTS\';

  FarmacyFunctionPath = '..\DATABASE\Farmacy\FUNCTION\';
  FarmacyProcedurePath = '..\DATABASE\Farmacy\PROCEDURE\';
  FarmacyReportsPath = '..\DATABASE\Farmacy\REPORTS\';

{ TdbProcedureTest }

procedure TdbProcedureTest.CreateContainerProcedure;
begin
{  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Container\Get\lpGet_Container1.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Container\Get\lpGet_Container2.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Container\Get\lpGet_Container3.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Container\Get\lpGet_Container4.sql');
  ZQuery.ExecSQL;}
end;

procedure TdbProcedureTest.CreateFunction;
begin
  ZQuery.SQL.LoadFromFile(CommonFunctionPath + 'ConstantFunction.sql');
  ZQuery.ExecSQL;
end;

procedure TdbProcedureTest.CreateHistoryProcedure;
begin
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'ObjectHistory\InsertUpdate\lpInsertUpdate_ObjectHistory.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'ObjectHistory\InsertUpdate\lpInsertUpdate_ObjectHistoryFloat.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'ObjectHistory\Delete\lpDelete_ObjectHistory.sql');
  ZQuery.ExecSQL;

//  ZQuery.SQL.LoadFromFile(ProcedurePath + 'ObjectHistory\_PriceListItem\gpInsertUpdate_ObjectHistory_PriceListItem.sql');
//  ZQuery.ExecSQL;

end;

procedure TdbProcedureTest.CreateMovementItemContainerProcedure;
begin            {
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItemContainer\InsertUpdate\lpInsertUpdate_MovementItemContainer.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItemContainer\Delete\lpDelete_MovementItemContainer.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItemContainer\gpUnComplete_Movement.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItemContainer\gpSelect_MovementItemContainer_Movement.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItemContainer\_Income\gpComplete_Movement_Income.sql');
  ZQuery.ExecSQL;
                  }
end;

procedure TdbProcedureTest.CreateMovementItemProcedure;
begin              {
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\InsertUpdate\lpInsertUpdate_MovementItem.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\InsertUpdate\lpInsertUpdate_MovementItemLinkObject.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\InsertUpdate\lpInsertUpdate_MovementItemFloat.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\InsertUpdate\lpInsertUpdate_MovementItemDate.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\InsertUpdate\lpInsertUpdate_MovementItemBoolean.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\InsertUpdate\lpInsertUpdate_MovementItemString.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\Delete\lpDelete_MovementItem.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\_Income\gpInsertUpdate_MovementItem_Income.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\_Income\gpSelect_MovementItem_Income.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\_ProductionUnion\gpInsertUpdate_MovementItem_In.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\_ProductionUnion\gpInsertUpdate_MovementItem_Out.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'MovementItem\_ProductionUnion\gpSelect_MovementItem_ProductionUnion.sql');
  ZQuery.ExecSQL;   }
end;

procedure TdbProcedureTest.CreateMovementProcedure;
begin               {
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\InsertUpdate\lpInsertUpdate_Movement.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\InsertUpdate\lpInsertUpdate_MovementLinkObject.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\InsertUpdate\lpInsertUpdate_MovementFloat.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\InsertUpdate\lpInsertUpdate_MovementDate.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\InsertUpdate\lpInsertUpdate_MovementBoolean.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\InsertUpdate\lpInsertUpdate_MovementString.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\Delete\lpDelete_Movement.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\gpSetErased_Movement.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\_Income\gpInsertUpdate_Movement_Income.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\_Income\gpGet_Movement_Income.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\_Income\gpSelect_Movement_Income.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\_ProductionUnion\gpInsertUpdate_Movement_ProductionUnion.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\_ProductionUnion\gpGet_Movement_ProductionUnion.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'Movement\_ProductionUnion\gpSelect_Movement_ProductionUnion.sql');
  ZQuery.ExecSQL;    }
end;

procedure TdbProcedureTest.CreateObjectProcedure;
begin
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'OBJECTS\Constraint\lpCheckUnique_Object_ValueData.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'OBJECTS\Constraint\lpCheckUnique_Object_ObjectCode.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'OBJECTS\Constraint\lpCheckUnique_ObjectString_ValueData.sql');
  ZQuery.ExecSQL;

  ExecFile(CommonProcedurePath + 'OBJECTS\Constraint\lpCheck_Object_CycleLink.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\Constraint\lfGet_ObjectCode.sql', ZQuery);

  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_Object.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_ObjectString.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_ObjectBLOB.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_ObjectFloat.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_ObjectBoolean.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'OBJECTS\InsertUpdate\lpInsertUpdate_ObjectLink.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'OBJECTS\Delete\lpDelete_Object.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'OBJECTS\gpUpdateObjectIsErased.sql');
  ZQuery.ExecSQL;

  ExecFile(CommonProcedurePath + 'OBJECTS\_User\gpInsertUpdate_Object_User.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\_User\gpSelect_Object_User.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\_User\gpGet_Object_User.sql', ZQuery);

  ExecFile(CommonProcedurePath + 'OBJECTS\_Form\gpInsertUpdate_Object_Form.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\_Form\gpGet_Object_Form.sql', ZQuery);

  ExecFile(CommonProcedurePath + 'OBJECTS\_UserFormSettings\gpInsertUpdate_Object_UserFormSettings.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\_UserFormSettings\gpGet_Object_UserFormSettings.sql', ZQuery);

  ExecFile(CommonProcedurePath + 'OBJECTS\lpCheckRight.sql', ZQuery);
  ExecFile(CommonProcedurePath + 'OBJECTS\gpCheckLogin.sql', ZQuery);

  {
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Account\gpInsertUpdate_Object_Account.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Account\lpFind_Object_Account.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Bank\gpInsertUpdate_Object_Bank.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Bank\gpSelect_Object_Bank.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Bank\gpGet_Object_Bank.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_BankAccount\gpInsertUpdate_Object_BankAccount.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_BankAccount\gpSelect_Object_BankAccount.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_BankAccount\gpGet_Object_BankAccount.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Branch\gpInsertUpdate_Object_Branch.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Branch\gpSelect_Object_Branch.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Branch\gpGet_Object_Branch.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Business\gpInsertUpdate_Object_Business.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Business\gpSelect_Object_Business.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Business\gpGet_Object_Business.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Car\gpInsertUpdate_Object_Car.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Car\gpSelect_Object_Car.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Car\gpGet_Object_Car.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_CarModel\gpInsertUpdate_Object_CarModel.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_CarModel\gpSelect_Object_CarModel.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_CarModel\gpGet_Object_CarModel.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Cash\gpInsertUpdate_Object_Cash.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Cash\gpSelect_Object_Cash.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Cash\gpGet_Object_Cash.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Contract\gpInsertUpdate_Object_Contract.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Contract\gpSelect_Object_Contract.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Contract\gpGet_Object_Contract.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_ContractKind\gpInsertUpdate_Object_ContractKind.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_ContractKind\gpSelect_Object_ContractKind.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_ContractKind\gpGet_Object_ContractKind.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Currency\gpInsertUpdate_Object_Currency.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Currency\gpSelect_Object_Currency.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Currency\gpGet_Object_Currency.sql');
  ZQuery.ExecSQL;
}
  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'OBJECTS\_Goods\gpInsertUpdate_Object_Goods.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'OBJECTS\_Goods\gpSelect_Object_Goods.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'OBJECTS\_Goods\gpGet_Object_Goods.sql');
  ZQuery.ExecSQL;

{  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsGroup\gpInsertUpdate_Object_GoodsGroup.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsGroup\gpSelect_Object_GoodsGroup.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsGroup\gpGet_Object_GoodsGroup.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsKind\gpInsertUpdate_Object_GoodsKind.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsKind\gpSelect_Object_GoodsKind.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsKind\gpGet_Object_GoodsKind.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsProperty\gpInsertUpdate_Object_GoodsProperty.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsProperty\gpSelect_Object_GoodsProperty.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsProperty\gpGet_Object_GoodsProperty.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsPropertyValue\gpInsertUpdate_Object_GoodsPropertyValue.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsPropertyValue\gpSelect_Object_GoodsPropertyValue.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_GoodsPropertyValue\gpGet_Object_GoodsPropertyValue.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_InfoMoneyGroup\gpInsertUpdate_Object_InfoMoneyGroup.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_InfoMoneyGroup\gpSelect_Object_InfoMoneyGroup.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_InfoMoneyGroup\gpGet_Object_InfoMoneyGroup.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_InfoMoneyDestination\gpInsertUpdate_Object_InfoMoneyDestination.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_InfoMoneyDestination\gpSelect_Object_InfoMoneyDestination.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_InfoMoneyDestination\gpGet_Object_InfoMoneyDestination.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_InfoMoney\gpInsertUpdate_Object_InfoMoney.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_InfoMoney\gpSelect_Object_InfoMoney.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_InfoMoney\gpGet_Object_InfoMoney.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Juridical\gpInsertUpdate_Object_Juridical.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Juridical\gpSelect_Object_Juridical.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Juridical\gpGet_Object_Juridical.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_JuridicalGroup\gpInsertUpdate_Object_JuridicalGroup.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_JuridicalGroup\gpSelect_Object_JuridicalGroup.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_JuridicalGroup\gpGet_Object_JuridicalGroup.sql');
  ZQuery.ExecSQL;
   }

  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'OBJECTS\_ExtraChargeCategories\gpInsertUpdate_Object_ExtraChargeCategories.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'OBJECTS\_ExtraChargeCategories\gpSelect_Object_ExtraChargeCategories.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'OBJECTS\_ExtraChargeCategories\gpGet_Object_ExtraChargeCategories.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'OBJECTS\_Measure\gpInsertUpdate_Object_Measure.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'OBJECTS\_Measure\gpSelect_Object_Measure.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'OBJECTS\_Measure\gpGet_Object_Measure.sql');
  ZQuery.ExecSQL;

    {
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Partner\gpInsertUpdate_Object_Partner.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Partner\gpSelect_Object_Partner.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Partner\gpGet_Object_Partner.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_PriceList\gpInsertUpdate_Object_PriceList.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_PriceList\gpSelect_Object_PriceList.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_PriceList\gpGet_Object_PriceList.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_PriceListItem\lpGetInsert_Object_PriceListItem.sql');
  ZQuery.ExecSQL;}

  ExecFile(FarmacyProcedurePath + 'OBJECTS\_Unit\gpInsertUpdate_Object_Unit.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\_Unit\gpSelect_Object_Unit.sql', ZQuery);
  ExecFile(FarmacyProcedurePath + 'OBJECTS\_Unit\gpGet_Object_Unit.sql', ZQuery);

  {ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_UnitGroup\gpInsertUpdate_Object_UnitGroup.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_UnitGroup\gpSelect_Object_UnitGroup.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_UnitGroup\gpGet_Object_UnitGroup.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Route\gpInsertUpdate_Object_Route.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Route\gpSelect_Object_Route.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_Route\gpGet_Object_Route.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\Constraint\lpCheckUnique_Object_ObjectCode.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_RouteSorting\gpInsertUpdate_Object_RouteSorting.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_RouteSorting\gpSelect_Object_RouteSorting.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_RouteSorting\gpGet_Object_RouteSorting.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_PaidKind\gpInsertUpdate_Object_PaidKind.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_PaidKind\gpSelect_Object_PaidKind.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(ProcedurePath + 'OBJECTS\_PaidKind\gpGet_Object_PaidKind.sql');
  ZQuery.ExecSQL;
     }
end;

procedure TdbProcedureTest.CreateProtocolProcedure;
begin
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'Protocol\lpInsert_ObjectProtocol.sql');
  ZQuery.ExecSQL;
end;

procedure TdbProcedureTest.CreateReportProcedure;
begin
  {ZQuery.SQL.LoadFromFile(ReportsPath + 'gpReport_Balance.sql');
  ZQuery.ExecSQL;}
end;

procedure TdbProcedureTest.SetUp;
begin
  inherited;
  ZConnection := TConnectionFactory.GetConnection;
  ZConnection.Connected := true;
  ZQuery := TZQuery.Create(nil);
  ZQuery.Connection := ZConnection;
end;

procedure TdbProcedureTest.TearDown;
begin
  inherited;
  ZConnection.Free;
  ZQuery.Free;
end;

initialization
  TestFramework.RegisterTest('Процедуры', TdbProcedureTest.Suite);


end.
