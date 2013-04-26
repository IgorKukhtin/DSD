unit dbCreateStructureTest;

interface

uses TestFramework, ZConnection, ZDataset;

type
  TdbCreateStructureTest = class (TTestCase)
  private
    ZConnection: TZConnection;
    ZQuery: TZQuery;
  protected
    // подготавливаем данные дл€ тестировани€
    procedure SetUp; override;
    // возвращаем данные дл€ тестировани€
    procedure TearDown; override;
  published
    procedure CreateDataBase;
    procedure CreateType;
    procedure CreateObject;
    procedure CreateContainer;
    procedure CreateMovement;
    procedure CreateMovementItem;
    procedure CreateMovementItemContainer;
    procedure CreateHistory;
    procedure CreateProtocol;
  end;

implementation

{ TdbCreateStructureTest }
uses zLibUtil;

const
  StructurePath = '..\DATABASE\COMMON\STRUCTURE\';

procedure TdbCreateStructureTest.CreateContainer;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'Container\ContainerDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Container\Container.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Container\ContainerLinkObjectDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Container\ContainerLinkObject.sql');
  ZQuery.ExecSQL;
end;

procedure TdbCreateStructureTest.CreateDataBase;
begin
  ZConnection.Connected := false;
  ZConnection.Database := '';
  ZConnection.Connected := true;
  try
    // ≈сли база существует, то сначала надо ее удалить
    ZQuery.SQL.LoadFromFile(StructurePath + 'KIllSession.sql');
    ZQuery.ExecSQL;
    ZQuery.SQL.LoadFromFile(StructurePath + 'DropDataBase.sql');
    ZQuery.ExecSQL;
  except

  end;
  ZQuery.SQL.LoadFromFile(StructurePath + 'CreateDataBase.sql');
  ZQuery.ExecSQL;
end;

procedure TdbCreateStructureTest.CreateHistory;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistory.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryStringDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryString.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryFloatDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryFloat.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryDateDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryDate.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryLinkDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'ObjectHistory\ObjectHistoryLink.sql');
  ZQuery.ExecSQL;
end;

procedure TdbCreateStructureTest.CreateMovement;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\MovementDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\Movement.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\MovementLinkObjectDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\MovementLinkObject.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\MovementFloatDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\MovementFloat.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\MovementBooleanDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\MovementBoolean.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\MovementDateDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\MovementDate.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\MovementStringDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Movement\MovementString.sql');
  ZQuery.ExecSQL;
end;

procedure TdbCreateStructureTest.CreateMovementItem;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItem\MovementItemDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItem\MovementItem.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItem\MovementItemLinkObjectDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItem\MovementItemLinkObject.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItem\MovementItemFloatDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItem\MovementItemFloat.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItem\MovementItemBooleanDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItem\MovementItemBoolean.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItem\MovementItemDateDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItem\MovementItemDate.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItem\MovementItemStringDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItem\MovementItemString.sql');
  ZQuery.ExecSQL;
end;

procedure TdbCreateStructureTest.CreateMovementItemContainer;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItemContainer\MovementItemContainerDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'MovementItemContainer\MovementItemContainer.sql');
  ZQuery.ExecSQL;
end;

procedure TdbCreateStructureTest.CreateObject;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\Object.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectStringDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectString.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectFloatDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectFloat.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectDateDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectDate.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectBLOBDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectBLOB.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectBooleanDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectBoolean.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectLinkDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'Object\ObjectLink.sql');
  ZQuery.ExecSQL;
end;

procedure TdbCreateStructureTest.CreateProtocol;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'Protocol\ObjectProtocol.sql');
  ZQuery.ExecSQL;
end;

procedure TdbCreateStructureTest.CreateType;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'Type\CreateType.sql');
  ZQuery.ExecSQL;
end;

procedure TdbCreateStructureTest.SetUp;
begin
  inherited;
  ZConnection := TConnectionFactory.GetConnection;
  try
    ZConnection.Connected := true;
  except

  end;
  ZQuery := TZQuery.Create(nil);
  ZQuery.Connection := ZConnection;
end;

procedure TdbCreateStructureTest.TearDown;
begin
  inherited;
  ZConnection.Free;
  ZQuery.Free;
end;

initialization
  TestFramework.RegisterTest('—оздание базы', TdbCreateStructureTest.Suite);

end.
