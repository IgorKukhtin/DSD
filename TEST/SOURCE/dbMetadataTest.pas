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
    procedure CreateContainerDescFunction;
    procedure InsertContainerDesc;
    procedure CreateObjectDescFunction;
    procedure InsertObjectDesc;
    procedure CreateMovementDescFunction;
    procedure InsertMovementDesc;
    procedure CreateMovementItemDescFunction;
    procedure InsertMovementItemDesc;
    procedure CreateMovementItemContainerFunction;
    procedure InsertMovementItemContainerDesc;
  end;

implementation

uses zLibUtil;

{ TdbMetaDataTest }

const
  MetadataPath = '..\DATABASE\COMMON\METADATA\Desc\';

procedure TdbMetaDataTest.InsertObjectDesc;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectStringDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectBLOBDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectFloatDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectBooleanDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectLinkDesc.sql');
  ZQuery.ExecSQL;
end;

procedure TdbMetaDataTest.InsertContainerDesc;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertContainerDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertContainerLinkObjectDesc.sql');
  ZQuery.ExecSQL;
end;

procedure TdbMetaDataTest.CreateContainerDescFunction;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateContainerDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateContainerLinkObjectDescFunction.sql');
  ZQuery.ExecSQL;
end;

procedure TdbMetaDataTest.InsertMovementDesc;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementLinkObjectDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementFloatDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementDateDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementBooleanDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementStringDesc.sql');
  ZQuery.ExecSQL;
end;

procedure TdbMetaDataTest.CreateMovementDescFunction;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementLinkObjectDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementFloatDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementDateDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementBooleanDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementStringDescFunction.sql');
  ZQuery.ExecSQL;
end;

procedure TdbMetaDataTest.CreateMovementItemContainerFunction;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementItemContainerDescFunction.sql');
  ZQuery.ExecSQL;
end;

procedure TdbMetaDataTest.CreateMovementItemDescFunction;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementItemDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementItemLinkObjectDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementItemFloatDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementItemBooleanDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateMovementItemStringDescFunction.sql');
  ZQuery.ExecSQL;
end;

procedure TdbMetaDataTest.InsertMovementItemContainerDesc;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementItemContainerDesc.sql');
  ZQuery.ExecSQL;
end;

procedure TdbMetaDataTest.InsertMovementItemDesc;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementItemDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementItemLinkObjectDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementItemFloatDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementItemBooleanDesc.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertMovementItemStringDesc.sql');
  ZQuery.ExecSQL;
end;

procedure TdbMetaDataTest.CreateObjectDescFunction;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectStringDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectLinkDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectBLOBDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectFloatDescFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectBooleanDescFunction.sql');
  ZQuery.ExecSQL;
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
  TestFramework.RegisterTest('Метаданные', TdbMetaDataTest.Suite);

end.
