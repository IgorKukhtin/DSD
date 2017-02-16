unit dbBoutiqueProcedureTest;

interface

uses TestFramework, ZConnection, ZDataset, dbTest;

type
  TdbProcedureTest = class(TdbTest)
  published
    procedure CreateDefault;
    procedure CreateProtocol;
    procedure CreateObjectTools;
  end;

type
  TdbObjectHistoryProcedureTest = class(TdbTest)
  published
    procedure CreateCOMMON;
  end;

type
  TdbMovementProcedureTest = class(TdbTest)
  published
    procedure CreateCOMMON;
  end;

type
  TdbMovementItemProcedureTest = class(TdbTest)
  published
    procedure CreateCOMMON;
  end;

type
  TdbMovementItemContainerProcedureTest = class(TdbTest)
  published
    procedure CreateCOMMON;
  end;

type
  TdbObjectProcedureTest = class(TdbTest)
  published
    procedure CreateCOMMON;
    procedure CreateAccount;
    procedure CreateAccountDirection;
    procedure CreateAccountGroup;
    procedure CreateAccountKind;
    procedure CreateImportSettings;
    procedure CreateImportSettingsItems;
    procedure CreateMeasure;
    procedure CreateInfoMoney;
    procedure CreateInfoMoneyDestination;
    procedure CreateInfoMoneyGroup;
    procedure CreateCompositionGroup;
  end;

implementation

uses zLibUtil;

const

  CommonProcedurePath = '..\DATABASE\Boutique\PROCEDURE\';

  { TdbProcedureTest }

procedure TdbProcedureTest.CreateDefault;
begin
  DirectoryLoad(CommonProcedurePath + 'Default\');
end;



procedure TdbProcedureTest.CreateProtocol;
begin
  DirectoryLoad(CommonProcedurePath + 'Protocol\');
end;


procedure TdbProcedureTest.CreateObjectTools;
begin
  DirectoryLoad(CommonProcedurePath + 'ObjectsTools\');
end;

{ TdbObjectHistoryProcedureTest }
procedure TdbObjectHistoryProcedureTest.CreateCOMMON;
begin
  DirectoryLoad(CommonProcedurePath + 'ObjectHistory\_COMMON\');
end;

{ TdbMovementProcedureTest }
procedure TdbMovementProcedureTest.CreateCOMMON;
begin
  DirectoryLoad(CommonProcedurePath + 'Movement\_COMMON\');
end;


{ TdbObjectProcedureTest }
procedure TdbObjectProcedureTest.CreateAccountDirection;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\AccountDirection\');
end;

procedure TdbObjectProcedureTest.CreateAccountGroup;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\AccountGroup\');
end;

procedure TdbObjectProcedureTest.CreateAccountKind;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\AccountKind\');
end;

procedure TdbObjectProcedureTest.CreateAccount;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Account\');
end;

procedure TdbObjectProcedureTest.CreateCOMMON;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\_COMMON\');
end;

procedure TdbObjectProcedureTest.CreateCompositionGroup;
begin
 DirectoryLoad(CommonProcedurePath + 'OBJECTS\CompositionGroup\');
end;

procedure TdbObjectProcedureTest.CreateImportSettingsItems;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\ImportSettingsItems\');
end;

procedure TdbObjectProcedureTest.CreateInfoMoney;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\InfoMoney\');
end;

procedure TdbObjectProcedureTest.CreateInfoMoneyDestination;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\InfoMoneyDestination\');
end;

procedure TdbObjectProcedureTest.CreateInfoMoneyGroup;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\InfoMoneyGroup\');
end;

procedure TdbObjectProcedureTest.CreateMeasure;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Measure\');
end;

procedure TdbObjectProcedureTest.CreateImportSettings;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\ImportSettings\');
end;

{ TdbMovementItemProcedureTest }

procedure TdbMovementItemProcedureTest.CreateCOMMON;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItem\_COMMON\');
end;

{ TdbMovementItemContainerProcedureTest }

procedure TdbMovementItemContainerProcedureTest.CreateCOMMON;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItemContainer\_COMMON\');
end;

initialization

TestFramework.RegisterTest('Процедуры', TdbProcedureTest.Suite);
TestFramework.RegisterTest('Процедуры', TdbObjectHistoryProcedureTest.Suite);
TestFramework.RegisterTest('Процедуры', TdbMovementProcedureTest.Suite);
TestFramework.RegisterTest('Процедуры', TdbMovementItemProcedureTest.Suite);
TestFramework.RegisterTest('Процедуры', TdbMovementItemContainerProcedureTest.Suite);
TestFramework.RegisterTest('Процедуры', TdbObjectProcedureTest.Suite);

end.
