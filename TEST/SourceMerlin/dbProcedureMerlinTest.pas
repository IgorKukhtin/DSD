unit dbProcedureMerlinTest;

interface

uses TestFramework, ZConnection, ZDataset, dbTest;

type
  TdbProcedureTest = class(TdbTest)
  published
    procedure CreateDefault;
    procedure CreateProtocol;
    procedure CreateObjectTools;
    procedure CreareSystem;
  end;

type
  TdbObjectHistoryProcedureTest = class(TdbTest)
  published
    procedure CreateCOMMON;
    procedure CreatePriceListItem;
    procedure CreateDiscountPeriodItem;
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
  end;

implementation

uses zLibUtil;

const

  CommonProcedurePath = '..\DATABASE\Merlin\PROCEDURE\';
  MetadataPath = '..\DATABASE\Merlin\METADATA\';
  ReportsPath = '..\DATABASE\Merlin\REPORTS\';
  ProcessPath = '..\DATABASE\Merlin\Process\';
  { TdbProcedureTest }

procedure TdbProcedureTest.CreareSystem;
begin
 DirectoryLoad(CommonProcedurePath + 'System\');
end;

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
procedure TdbObjectHistoryProcedureTest.CreatePriceListItem;
begin
  DirectoryLoad(CommonProcedurePath + 'ObjectHistory\PriceListItem\');
end;

procedure TdbObjectHistoryProcedureTest.CreateDiscountPeriodItem;
begin
  DirectoryLoad(CommonProcedurePath + 'ObjectHistory\DiscountPeriodItem\');
end;

{ TdbMovementProcedureTest }
procedure TdbMovementProcedureTest.CreateCOMMON;
begin
  DirectoryLoad(CommonProcedurePath + 'Movement\_COMMON\');
end;

{ TdbObjectProcedureTest }

procedure TdbObjectProcedureTest.CreateCOMMON;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\_COMMON\');
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

TestFramework.RegisterTest('���������', TdbProcedureTest.Suite);
TestFramework.RegisterTest('���������', TdbObjectHistoryProcedureTest.Suite);
TestFramework.RegisterTest('���������', TdbMovementProcedureTest.Suite);
TestFramework.RegisterTest('���������', TdbMovementItemProcedureTest.Suite);
TestFramework.RegisterTest('���������', TdbMovementItemContainerProcedureTest.Suite);
TestFramework.RegisterTest('���������', TdbObjectProcedureTest.Suite);

end.
