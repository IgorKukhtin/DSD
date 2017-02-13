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
    procedure CreateOvjectToolsProcedure;
    procedure CreateObjectProcedure;
    procedure CreateProtocolProcedure;
    procedure CreatePeriodCloseProcedure;

    procedure CreateLoadProcedure;
  end;


implementation

uses zLibUtil;

const
  CommonFunctionPath = '..\DATABASE\Boutique\FUNCTION\';
  CommonProcedurePath = '..\DATABASE\Boutique\PROCEDURE\';
  CommonReportsPath = '..\DATABASE\Boutique\REPORTS\';

  FarmacyFunctionPath = '..\DATABASE\Boutique\FUNCTION\';
  FarmacyProcedurePath = '..\DATABASE\Boutique\PROCEDURE\';
  FarmacyReportsPath = '..\DATABASE\Boutique\REPORTS\';

{ TdbProcedureTest }

procedure TdbProcedureTest.CreateCheckProcedure;
begin
  ScriptDirectory := FarmacyProcedurePath + 'Protocol\';
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
//  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'FUNCTION\zfCalc_SalePrice.sql');
//  ZQuery.ExecSQL;
end;

procedure TdbProcedureTest.CreateHistoryProcedure;
begin
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'ObjectHistory\_COMMON\InsertUpdate\lpInsertUpdate_ObjectHistory.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'ObjectHistory\_COMMON\InsertUpdate\lpInsertUpdate_ObjectHistoryFloat.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'ObjectHistory\_COMMON\Delete\lpDelete_ObjectHistory.sql');
  ZQuery.ExecSQL;

end;

procedure TdbProcedureTest.CreateLoadProcedure;
begin
  ScriptDirectory := FarmacyProcedurePath + 'Load\';
  ProcedureLoad;
end;

procedure TdbProcedureTest.CreateMovementItemContainerProcedure;
begin
  ScriptDirectory := FarmacyProcedurePath + 'MovementItemContainer\_COMMON\InsertUpdate\';
  ProcedureLoad;
  ScriptDirectory := FarmacyProcedurePath + 'MovementItemContainer\_COMMON\';
  ProcedureLoad;
end;

procedure TdbProcedureTest.CreateMovementItemProcedure;
begin
  ScriptDirectory := FarmacyProcedurePath + 'MovementItem\_COMMON\';
  ProcedureLoad;


end;

procedure TdbProcedureTest.CreateMovementProcedure;
begin
  ScriptDirectory := FarmacyProcedurePath + 'Movement\_COMMON\';
  ProcedureLoad;

end;

procedure TdbProcedureTest.CreateObjectProcedure;
begin
  DirectoryLoad(CommonProcedurePath + 'Objects\');

//  DirectoryLoad(CommonProcedurePath + 'OBJECTS\_COMMON\');
//  DirectoryLoad(CommonProcedurePath + 'OBJECTS\FileTypeKind\');
//  DirectoryLoad(CommonProcedurePath + 'OBJECTS\ImportSettings\');
//  DirectoryLoad(CommonProcedurePath + 'OBJECTS\ImportSettingsItems\');
//  DirectoryLoad(FarmacyProcedurePath + 'OBJECTS\User\');
//  DirectoryLoad(FarmacyProcedurePath + 'OBJECTS\Role\');
//  DirectoryLoad(FarmacyProcedurePath + 'OBJECTS\Program\');
//  DirectoryLoad(FarmacyProcedurePath + 'OBJECTS\Process\');
//  DirectoryLoad(FarmacyProcedurePath + 'OBJECTS\Protocol\');
//  DirectoryLoad(FarmacyProcedurePath + 'OBJECTS\UserFormSettings\');
//  DirectoryLoad(FarmacyProcedurePath + 'OBJECTS\Action\');
//  DirectoryLoad(FarmacyProcedurePath + 'OBJECTS\Form\');


//  ZQuery.SQL.LoadFromFile(FarmacyProcedurePath + 'OBJECTS\PartionGoods\gpSelect_Object_PartionGoods.sql');
//  ZQuery.ExecSQL;
end;

procedure TdbProcedureTest.CreatePeriodCloseProcedure;
begin
//  ScriptDirectory := CommonProcedurePath + 'PeriodClose\';
//  ProcedureLoad;
end;

procedure TdbProcedureTest.CreateProtocolProcedure;
begin
//  ZQuery.SQL.LoadFromFile(CommonProcedurePath + 'Protocol\lpInsert_ObjectProtocol.sql');
//  ZQuery.ExecSQL;
end;


procedure TdbProcedureTest.CreateOvjectToolsProcedure;
begin
  DirectoryLoad(CommonProcedurePath + 'ObjectsTools\');

end;

initialization
  TestFramework.RegisterTest('Процедуры', TdbProcedureTest.Suite);


end.
