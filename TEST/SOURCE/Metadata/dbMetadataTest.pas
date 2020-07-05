unit dbMetaDataTest;

interface

uses TestFramework, ZConnection, ZDataset;

type
  TdbMetaDataTest = class (TTestCase)
  private
    ZConnection: TZConnection;
    ZQuery: TZQuery;
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    // Очередность важна - по алфавиту не ставить!!!
    procedure CreateObjectDescFunction;
    procedure CreateContainerDescFunction;
    procedure CreateObjectHistoryDescFunction;
    procedure CreateMovementDescFunction;
    procedure CreateMovementItemDescFunction;
    procedure InsertMovementItemDesc;
    procedure CreateMovementItemContainerFunction;
    procedure CreateObjectCostFunction;
  end;

var
  MetadataPath: string = '..\DATABASE\COMMON\METADATA\';

implementation

uses zLibUtil;

{ TdbMetaDataTest }

procedure TdbMetaDataTest.CreateContainerDescFunction;
begin
  ExecFile(MetadataPath + 'Container\CreateContainerDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'Container\CreateContainerLinkObjectDescFunction.sql', ZQuery);
end;

procedure TdbMetaDataTest.CreateMovementDescFunction;
begin
  ExecFile(MetadataPath + 'Movement\CreateMovementDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'Movement\CreateMovementLinkObjectDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'Movement\CreateMovementFloatDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'Movement\CreateMovementDateDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'Movement\CreateMovementBooleanDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'Movement\CreateMovementLinkMovementDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'Movement\CreateMovementStringDescFunction.sql', ZQuery);
end;

procedure TdbMetaDataTest.CreateMovementItemDescFunction;
begin
  ExecFile(MetadataPath + 'MovementItem\CreateMovementItemDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'MovementItem\CreateMovementItemLinkObjectDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'MovementItem\CreateMovementItemFloatDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'MovementItem\CreateMovementItemBooleanDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'MovementItem\CreateMovementItemStringDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'MovementItem\CreateMovementItemDateDescFunction.sql', ZQuery);
end;

procedure TdbMetaDataTest.CreateMovementItemContainerFunction;
begin
  ExecFile(MetadataPath + 'MovementItemContainer\CreateMovementItemContainerDescFunction.sql', ZQuery);
end;

procedure TdbMetaDataTest.CreateObjectCostFunction;
begin
  ExecFile(MetadataPath + 'ObjectCost\CreateObjectCostDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'ObjectCost\CreateObjectCostLinkDescFunction.sql', ZQuery);
end;

procedure TdbMetaDataTest.InsertMovementItemDesc;
begin
  //ExecFile(MetadataPath + 'MovementItem\InsertMovementItemLinkObjectDesc.sql', ZQuery);
  // ExecFile(MetadataPath + 'MovementItem\InsertMovementItemBooleanDesc.sql', ZQuery);
end;

procedure TdbMetaDataTest.CreateObjectDescFunction;
begin
  ExecFile(MetadataPath + 'Object\CreateObjectDescFunction.sql', ZQuery);
  //ExecFile(MetadataPath + 'Object\InsertObjectDesc.sql', ZQuery);                 Новая схема 2
  ExecFile(MetadataPath + 'Object\CreateObjectStringDescFunction.sql', ZQuery);
  //ExecFile(MetadataPath + 'Object\InsertObjectStringDesc.sql', ZQuery);           Новая схема 2
  ExecFile(MetadataPath + 'Object\CreateObjectLinkDescFunction.sql', ZQuery);
  //ExecFile(MetadataPath + 'Object\InsertObjectLinkDesc.sql', ZQuery);             Новая схема 2
  ExecFile(MetadataPath + 'Object\CreateObjectBLOBDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'Object\CreateObjectFloatDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'Object\CreateObjectBooleanDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'Object\CreateObjectDateDescFunction.sql', ZQuery);
end;

procedure TdbMetaDataTest.CreateObjectHistoryDescFunction;
begin
  ExecFile(MetadataPath + 'ObjectHistory\CreateObjectHistoryDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'ObjectHistory\CreateObjectHistoryFloatDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'ObjectHistory\CreateObjectHistoryStringDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'ObjectHistory\CreateObjectHistoryLinkDescFunction.sql', ZQuery);
end;

procedure TdbMetaDataTest.SetUp;
begin
  inherited;
  ZConnection := TConnectionFactory.GetConnection;
  ZQuery := TZQuery.Create(nil);
  ZQuery.Connection := ZConnection;
end;

procedure TdbMetaDataTest.TearDown;
begin
  inherited;
  ZConnection.Free;
  ZQuery.Free;
end;

initialization
//  TestFramework.RegisterTest('Метаданные', TdbMetaDataTest.Suite);

end.
