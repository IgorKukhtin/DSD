unit dbCreateStructureTest;

interface

uses TestFramework, ZConnection, ZDataset, dbTest;

type
  TdbCreateStructureTest = class (TdbTest)
  protected
    // �������������� ������ ��� ������������
    procedure SetUp; override;
  published
    procedure CreateDataBase;
    procedure CreateType;
    procedure CreateObject;
    procedure CreateContainer;
    procedure CreateObjectCost;
    procedure CreateMovement;
    procedure CreateMovementItem;
    procedure CreateMovementItemContainer;
    procedure CreateMovementItemReport;
    procedure CreateHistory;
    procedure CreateProtocol;
    procedure CreatePeriodClose;
    procedure CreateDefaults;
    procedure CreateLoad;
    procedure UpdateStructure;
    procedure CreateIndexes;
  end;

var
  CreateStructurePath: string = '..\DATABASE\COMMON\STRUCTURE\';

implementation

{ TdbCreateStructureTest }
uses zLibUtil, System.SysUtils;

const
  StructurePath = '..\DATABASE\COMMON\STRUCTURE\';
  UpdateStructurePath = '..\DATABASE\COMMON\UPDATESTRUCTURE\';


procedure TdbCreateStructureTest.CreateContainer;
begin
  ExecFile(StructurePath + 'Container\ContainerDesc.sql', ZQuery);
  ExecFile(StructurePath + 'Container\Container.sql', ZQuery);
  ExecFile(StructurePath + 'Container\ContainerLinkObjectDesc.sql', ZQuery);
  ExecFile(StructurePath + 'Container\ContainerLinkObject.sql', ZQuery);
end;

procedure TdbCreateStructureTest.CreateDataBase;
begin
  ZConnection.Connected := false;
  ZConnection.Database := 'postgres';
  ZConnection.Connected := true;

  if FileExists(CreateStructurePath + 'real_DROP_andCreate_Database = YES.txt') then
  begin
      try
        // ���� ���� ����������, �� ������� ���� �� �������
        // ExecFile(CreateStructurePath + 'KIllSession.sql', ZQuery);
        // ExecFile(CreateStructurePath + 'DropDataBase.sql', ZQuery);
      except
      end;
      //
      ExecFile(CreateStructurePath + 'CreateDataBase.sql', ZQuery);
  end
  else raise Exception.Create('������ real_DROP_andCreate_Database ');

end;

procedure TdbCreateStructureTest.CreateDefaults;
begin
  ExecFile(StructurePath + 'Default\DefaultKeys.sql', ZQuery);
  ExecFile(StructurePath + 'Default\DefaultValue.sql', ZQuery);
end;

procedure TdbCreateStructureTest.CreateHistory;
begin
  ExecFile(StructurePath + 'ObjectHistory\ObjectHistoryDesc.sql', ZQuery);
  ExecFile(StructurePath + 'ObjectHistory\ObjectHistory.sql', ZQuery);
  ExecFile(StructurePath + 'ObjectHistory\ObjectHistoryStringDesc.sql', ZQuery);
  ExecFile(StructurePath + 'ObjectHistory\ObjectHistoryString.sql', ZQuery);
  ExecFile(StructurePath + 'ObjectHistory\ObjectHistoryFloatDesc.sql', ZQuery);
  ExecFile(StructurePath + 'ObjectHistory\ObjectHistoryFloat.sql', ZQuery);
  ExecFile(StructurePath + 'ObjectHistory\ObjectHistoryDateDesc.sql', ZQuery);
  ExecFile(StructurePath + 'ObjectHistory\ObjectHistoryDate.sql', ZQuery);
  ExecFile(StructurePath + 'ObjectHistory\ObjectHistoryLinkDesc.sql', ZQuery);
  ExecFile(StructurePath + 'ObjectHistory\ObjectHistoryLink.sql', ZQuery);
end;

procedure TdbCreateStructureTest.CreateIndexes;
begin
  DirectoryLoad(StructurePath + 'INDEX\');
end;

procedure TdbCreateStructureTest.CreateLoad;
begin
  DirectoryLoad(CreateStructurePath + 'Load\');
end;

procedure TdbCreateStructureTest.CreateMovement;
begin
  ExecFile(StructurePath + 'Movement\MovementDesc.sql', ZQuery);
  ExecFile(StructurePath + 'Movement\Movement.sql', ZQuery);
  ExecFile(StructurePath + 'Movement\MovementLinkObjectDesc.sql', ZQuery);
  ExecFile(StructurePath + 'Movement\MovementLinkObject.sql', ZQuery);
  ExecFile(StructurePath + 'Movement\MovementFloatDesc.sql', ZQuery);
  ExecFile(StructurePath + 'Movement\MovementFloat.sql', ZQuery);
  ExecFile(StructurePath + 'Movement\MovementBlobDesc.sql', ZQuery);
  ExecFile(StructurePath + 'Movement\MovementBlob.sql', ZQuery);
  ExecFile(StructurePath + 'Movement\MovementBooleanDesc.sql', ZQuery);
  ExecFile(StructurePath + 'Movement\MovementBoolean.sql', ZQuery);
  ExecFile(StructurePath + 'Movement\MovementDateDesc.sql', ZQuery);
  ExecFile(StructurePath + 'Movement\MovementDate.sql', ZQuery);
  ExecFile(StructurePath + 'Movement\MovementStringDesc.sql', ZQuery);
  ExecFile(StructurePath + 'Movement\MovementString.sql', ZQuery);
end;

procedure TdbCreateStructureTest.CreateMovementItem;
begin
  ExecFile(StructurePath + 'MovementItem\MovementItemDesc.sql', ZQuery);
  ExecFile(StructurePath + 'MovementItem\MovementItem.sql', ZQuery);
  ExecFile(StructurePath + 'MovementItem\MovementItemLinkObjectDesc.sql', ZQuery);
  ExecFile(StructurePath + 'MovementItem\MovementItemLinkObject.sql', ZQuery);
  ExecFile(StructurePath + 'MovementItem\MovementItemFloatDesc.sql', ZQuery);
  ExecFile(StructurePath + 'MovementItem\MovementItemFloat.sql', ZQuery);
  ExecFile(StructurePath + 'MovementItem\MovementItemBooleanDesc.sql', ZQuery);
  ExecFile(StructurePath + 'MovementItem\MovementItemBoolean.sql', ZQuery);
  ExecFile(StructurePath + 'MovementItem\MovementItemDateDesc.sql', ZQuery);
  ExecFile(StructurePath + 'MovementItem\MovementItemDate.sql', ZQuery);
  ExecFile(StructurePath + 'MovementItem\MovementItemStringDesc.sql',ZQuery);
  ExecFile(StructurePath + 'MovementItem\MovementItemString.sql', ZQuery);
end;

procedure TdbCreateStructureTest.CreateMovementItemContainer;
begin
  ExecFile(StructurePath + 'MovementItemContainer\MovementItemContainerDesc.sql', ZQuery);
  ExecFile(StructurePath + 'MovementItemContainer\MovementItemContainer.sql', ZQuery);
end;

procedure TdbCreateStructureTest.CreateMovementItemReport;
begin
  ExecFile(StructurePath + 'MovementItemReport\ReportContainerSEQUENCE.sql', ZQuery);
  ExecFile(StructurePath + 'MovementItemReport\ReportContainerLink.sql', ZQuery);
  ExecFile(StructurePath + 'MovementItemReport\MovementItemReport.sql', ZQuery);
  ExecFile(StructurePath + 'MovementItemReport\ChildReportContainerSEQUENCE.sql', ZQuery);
  ExecFile(StructurePath + 'MovementItemReport\ChildReportContainerLink.sql', ZQuery);
end;

procedure TdbCreateStructureTest.CreateObject;
begin
  ExecFile(StructurePath + 'Object\ObjectDesc.sql', ZQuery);
  ExecFile(StructurePath + 'Object\Object.sql', ZQuery);
  ExecFile(StructurePath + 'Object\ObjectStringDesc.sql', ZQuery);
  ExecFile(StructurePath + 'Object\ObjectString.sql', ZQuery);
  ExecFile(StructurePath + 'Object\ObjectFloatDesc.sql', ZQuery);
  ExecFile(StructurePath + 'Object\ObjectFloat.sql', ZQuery);
  ExecFile(StructurePath + 'Object\ObjectDateDesc.sql', ZQuery);
  ExecFile(StructurePath + 'Object\ObjectDate.sql', ZQuery);
  ExecFile(StructurePath + 'Object\ObjectBLOBDesc.sql', ZQuery);
  ExecFile(StructurePath + 'Object\ObjectBLOB.sql', ZQuery);
  ExecFile(StructurePath + 'Object\ObjectBooleanDesc.sql', ZQuery);
  ExecFile(StructurePath + 'Object\ObjectBoolean.sql', ZQuery);
  ExecFile(StructurePath + 'Object\ObjectLinkDesc.sql', ZQuery);
  ExecFile(StructurePath + 'Object\ObjectLink.sql', ZQuery);
end;

procedure TdbCreateStructureTest.CreateObjectCost;
begin
  ExecFile(StructurePath + 'ObjectCost\ObjectCostDesc.sql', ZQuery);
  ExecFile(StructurePath + 'ObjectCost\ObjectCostLinkDesc.sql', ZQuery);
  ExecFile(StructurePath + 'ObjectCost\ObjectCostLink.sql', ZQuery);
  ExecFile(StructurePath + 'ObjectCost\ContainerObjectCost.sql', ZQuery);
  ExecFile(StructurePath + 'ObjectCost\HistoryCost.sql', ZQuery);
  ExecFile(StructurePath + 'ObjectCost\ObjectCostSEQUENCE.sql', ZQuery);
end;

procedure TdbCreateStructureTest.CreatePeriodClose;
begin
  ExecFile(StructurePath + 'PeriodClose\PeriodClose.sql', ZQuery);
end;

procedure TdbCreateStructureTest.CreateProtocol;
begin
  ExecFile(StructurePath + 'Protocol\ObjectProtocol.sql', ZQuery);
end;

procedure TdbCreateStructureTest.CreateType;
begin
  ExecFile(StructurePath + 'Type\CreateType.sql', ZQuery);
end;

procedure TdbCreateStructureTest.SetUp;
begin
  ZConnection := TConnectionFactory.GetConnection;
  try
    ZConnection.Connected := true;
  except

  end;
  ZQuery := TZQuery.Create(nil);
  ZQuery.Connection := ZConnection;
end;

procedure TdbCreateStructureTest.UpdateStructure;
begin
  if FileExists(CreateStructurePath + 'real_DROP_andCreate_Database = YES.txt')
  then DirectoryLoad(UpdateStructurePath)
  else raise Exception.Create('������ real_UpdateStructure_Database ');
end;

initialization
  TestFramework.RegisterTest('�������� ����', TdbCreateStructureTest.Suite);

end.
