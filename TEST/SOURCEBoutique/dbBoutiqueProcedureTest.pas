unit dbBoutiqueProcedureTest;

interface
uses TestFramework, ZConnection, ZDataset, dbTest;

type
  TdbProcedureTest = class (TdbTest)
  published
    procedure CreateFunction;
    procedure CreateDefaultProcedure;
    procedure CreateHistoryProcedure;
    procedure CreateMovementProcedure;
    procedure CreateMovementItemProcedure;
    procedure CreateMovementItemContainerProcedure;
    procedure CreateProtocolProcedure;
    procedure CreateOvjectToolsProcedure;
    procedure CreateObjectProcedure;


  end;


implementation

uses zLibUtil;

const
  CommonFunctionPath = '..\DATABASE\Boutique\FUNCTION\';
  CommonProcedurePath = '..\DATABASE\Boutique\PROCEDURE\';
  CommonReportsPath = '..\DATABASE\Boutique\REPORTS\';


{ TdbProcedureTest }



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



procedure TdbProcedureTest.CreateMovementItemContainerProcedure;
begin
  ScriptDirectory := CommonProcedurePath + 'MovementItemContainer\_COMMON\';
  ProcedureLoad;
end;

procedure TdbProcedureTest.CreateMovementItemProcedure;
begin
  ScriptDirectory := CommonProcedurePath + 'MovementItem\_COMMON\';
  ProcedureLoad;
end;

procedure TdbProcedureTest.CreateMovementProcedure;
begin
  ScriptDirectory := CommonProcedurePath + 'Movement\_COMMON\';
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



procedure TdbProcedureTest.CreateProtocolProcedure;
begin
  ScriptDirectory := CommonProcedurePath + 'Protocol\';
  ProcedureLoad;
end;


procedure TdbProcedureTest.CreateOvjectToolsProcedure;
begin
  DirectoryLoad(CommonProcedurePath + 'ObjectsTools\');

end;

initialization
  TestFramework.RegisterTest('Процедуры', TdbProcedureTest.Suite);


end.
