unit dbFarmacyProcedureTest;

interface
uses TestFramework, ZConnection, ZDataset, dbTest;

type
  TdbProcedureTest = class (TdbTest)
  published
    procedure CreateFunction;
    procedure CreateContainerProcedure;
    procedure CreateDefaultProcedure;
    procedure CreateHistoryProcedure;
    procedure CreateMovementProcedure;
    procedure CreateMovementItemProcedure;
    procedure CreateMovementItemContainerProcedure;
    procedure CreateCheckProcedure;
    procedure CreateObjectProcedure;
    procedure CreateProtocolProcedure;
    procedure CreatePeriodCloseProcedure;
    procedure CreateReportProcedure;
    procedure CreateSystemProcedure;
    procedure CreateLoadProcedure;
    procedure CreateUpdatePromoCodeProcedures;
    procedure CreateJSONProcedures;
  end;


implementation

uses zLibUtil;

const
  CommonFunctionPath = '..\DATABASE\COMMON\FUNCTION\';
  CommonProcedurePath = '..\DATABASE\COMMON\PROCEDURE\';
  CommonReportsPath = '..\DATABASE\COMMON\REPORTS\';
  CommonViewPath = '..\DATABASE\COMMON\VIEW\';

  FarmacyFunctionPath = '..\DATABASE\Farmacy\FUNCTION\';
  FarmacyProcedurePath = '..\DATABASE\Farmacy\PROCEDURE\';
  FarmacyReportsPath = '..\DATABASE\Farmacy\REPORTS\';

{ TdbProcedureTest }

procedure TdbProcedureTest.CreateCheckProcedure;
begin
  ScriptDirectory := FarmacyProcedurePath + 'Cash\';
  ProcedureLoad;
end;

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

procedure TdbProcedureTest.CreateDefaultProcedure;
begin
  ScriptDirectory := CommonProcedurePath + 'Default\';
  ProcedureLoad;
end;

procedure TdbProcedureTest.CreateFunction;
begin
  ZQuery.SQL.LoadFromFile(CommonFunctionPath + 'ConstantFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'FUNCTION\zfCalc_SalePrice.sql');
  ZQuery.ExecSQL;
end;

procedure TdbProcedureTest.CreateHistoryProcedure;
begin
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'ObjectHistory\_COMMON\InsertUpdate\lpInsertUpdate_ObjectHistory.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'ObjectHistory\_COMMON\InsertUpdate\lpInsertUpdate_ObjectHistoryFloat.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'ObjectHistory\_COMMON\Delete\lpDelete_ObjectHistory.sql');
  ZQuery.ExecSQL;

//  ZQuery.SQL.LoadFromFile(ProcedurePath + 'ObjectHistory\_PriceListItem\gpInsertUpdate_ObjectHistory_PriceListItem.sql');
//  ZQuery.ExecSQL;

end;

procedure TdbProcedureTest.CreateJSONProcedures;
begin
  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'Load\LoadPriceList\gpInsertUpdate_Movement_LoadPriceList_JSON_1Contract.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'Load\LoadPriceList\gpInsertUpdate_Movement_LoadPriceList_JSON_2Contract.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'Load\LoadPriceList\gpInsertUpdate_Movement_LoadPriceList_JSON_3Contract.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'Load\LoadPriceList\lpInsertUpdate_Movement_LoadPriceList_JSON.sql');
  ZQuery.ExecSQL;

  ZQuery.ParamCheck := false;
  ZQuery.SQL.LoadFromFile(CommonViewPath + '01Object\Object_ImportSettings_View.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(CommonViewPath + '01Object\Object_ImportSettingsItems_View.sql');
  ZQuery.ExecSQL;
end;

procedure TdbProcedureTest.CreateLoadProcedure;
begin
  ScriptDirectory := FarmacyProcedurePath + 'Load\';
  ProcedureLoad;
end;

procedure TdbProcedureTest.CreateUpdatePromoCodeProcedures;
begin
  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'Movement\Check\gpInsertUpdate_Movement_Check_ver2.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'Movement\PromoCode\gpGet_IsGoodsInPromo.sql');
  ZQuery.ExecSQL;

  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'Movement\PromoCode\gpGet_PromoCode_by_GUID.sql');
  ZQuery.ExecSQL;
end;

procedure TdbProcedureTest.CreateMovementItemContainerProcedure;
begin
  ScriptDirectory := FarmacyProcedurePath + 'MovementItemContainer\_COMMON\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItemContainer\Income\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItemContainer\Check\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItemContainer\Inventory\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItemContainer\Loss\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItemContainer\Send\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItemContainer\ReturnOut\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItemContainer\Sale\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItemContainer\LossDebt\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItemContainer\BankAccount\';
  ProcedureLoad;

            {
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
begin
  ScriptDirectory := FarmacyProcedurePath + 'MovementItem\Income\';
  ProcedureLoad;
 // ScriptDirectory := FarmacyProcedurePath + 'MovementItem\Check\';
 // ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItem\Inventory\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItem\Loss\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItem\Send\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItem\ReturnOut\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItem\Sale\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItem\LossDebt\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItem\BankAccount\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItem\SheetWorkTime\';
  ProcedureLoad;

  {
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
begin
  ScriptDirectory := FarmacyProcedurePath + 'Movement\Income\';
  ProcedureLoad;
  //ScriptDirectory := FarmacyProcedurePath + 'Movement\Check\';
  //ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'Movement\Inventory\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'Movement\Loss\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'Movement\Send\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'Movement\ReturnOut\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'Movement\Sale\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'Movement\LossDebt\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'Movement\BankAccount\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'Movement\SheetWorkTime\';
  ProcedureLoad;
{
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
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\_COMMON\');
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\FileTypeKind\');
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\ImportSettings\');
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\ImportSettingsItems\');
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\ImportType\');
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\NDSKind\');
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Role\');

  DirectoryLoad(FarmacyProcedurePath + 'OBJECTS\Union\');

  DirectoryLoad(FarmacyProcedurePath + 'OBJECTS\Contract\');
  DirectoryLoad(FarmacyProcedurePath + 'OBJECTS\Personal\');
  DirectoryLoad(FarmacyProcedurePath + 'OBJECTS\PersonalGroup\');
  DirectoryLoad(FarmacyProcedurePath + 'OBJECTS\Position\');
  DirectoryLoad(FarmacyProcedurePath + 'OBJECTS\Education\');
  DirectoryLoad(FarmacyProcedurePath + 'OBJECTS\Calendar\');
  DirectoryLoad(FarmacyProcedurePath + 'OBJECTS\Member\');

  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'OBJECTS\PartionGoods\gpSelect_Object_PartionGoods.sql');
  ZQuery.ExecSQL;
end;

procedure TdbProcedureTest.CreatePeriodCloseProcedure;
begin
  ScriptDirectory := CommonProcedurePath + 'PeriodClose\';
  ProcedureLoad;
end;

procedure TdbProcedureTest.CreateProtocolProcedure;
begin
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'Protocol\lpInsert_ObjectProtocol.sql');
  ZQuery.ExecSQL;
end;

procedure TdbProcedureTest.CreateReportProcedure;
begin
  ScriptDirectory := FarmacyReportsPath + 'Remains\';
  ProcedureLoad;
  ScriptDirectory := FarmacyReportsPath + 'Goods\';
  ProcedureLoad;
  ScriptDirectory := FarmacyReportsPath + 'Check\';
  ProcedureLoad;
  ScriptDirectory := FarmacyReportsPath + 'Sold\';
  ProcedureLoad;
  ScriptDirectory := FarmacyReportsPath + 'Juridical\';
  ProcedureLoad;
  ZQuery.SQL.LoadFromFile(CommonReportsPath + 'Balance\gpReport_Balance.sql');
  ZQuery.ExecSQL;
  ScriptDirectory := FarmacyReportsPath + 'Upload\';
  ProcedureLoad;
end;

procedure TdbProcedureTest.CreateSystemProcedure;
begin
  DirectoryLoad(CommonProcedurePath + 'Objects\Program\');
end;

initialization
  TestFramework.RegisterTest('Процедуры', TdbProcedureTest.Suite);


end.
