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
    procedure CreateObjectHistoryDescFunction;
    procedure InsertObjectHistoryDesc;
    procedure CreateMovementDescFunction;
    procedure InsertMovementDesc;
    procedure CreateMovementItemDescFunction;
    procedure InsertMovementItemDesc;
    procedure CreateMovementItemContainerFunction;
    procedure InsertMovementItemContainerDesc;
  end;

var
  MetadataPath: string = '..\DATABASE\COMMON\METADATA\Desc\';

implementation

uses zLibUtil;

{ TdbMetaDataTest }

procedure TdbMetaDataTest.InsertObjectDesc;
begin
  ExecFile(MetadataPath + 'InsertObjectDesc.sql', ZQuery);
  ExecFile(MetadataPath + 'InsertObjectStringDesc.sql', ZQuery);
  ExecFile(MetadataPath + 'InsertObjectBLOBDesc.sql', ZQuery);
  ExecFile(MetadataPath + 'InsertObjectFloatDesc.sql', ZQuery);
  ExecFile(MetadataPath + 'InsertObjectBooleanDesc.sql', ZQuery);
  ExecFile(MetadataPath + 'InsertObjectLinkDesc.sql', ZQuery);
end;

procedure TdbMetaDataTest.InsertObjectHistoryDesc;
begin
  ExecFile(MetadataPath + 'InsertObjectHistoryDesc.sql', ZQuery);
  ExecFile(MetadataPath + 'InsertObjectHistoryFloatDesc.sql', ZQuery);
end;

procedure TdbMetaDataTest.InsertContainerDesc;
begin
  ExecFile(MetadataPath + 'InsertContainerDesc.sql', ZQuery);
  ExecFile(MetadataPath + 'InsertContainerLinkObjectDesc.sql', ZQuery);
end;

procedure TdbMetaDataTest.CreateContainerDescFunction;
begin
  ExecFile(MetadataPath + 'CreateContainerDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'CreateContainerLinkObjectDescFunction.sql', ZQuery);
end;

procedure TdbMetaDataTest.InsertMovementDesc;
begin
  ExecFile(MetadataPath + 'InsertMovementDesc.sql', ZQuery);
  ExecFile(MetadataPath + 'InsertMovementLinkObjectDesc.sql', ZQuery);
  ExecFile(MetadataPath + 'InsertMovementFloatDesc.sql', ZQuery);
  ExecFile(MetadataPath + 'InsertMovementDateDesc.sql', ZQuery);
  ExecFile(MetadataPath + 'InsertMovementBooleanDesc.sql', ZQuery);
  ExecFile(MetadataPath + 'InsertMovementStringDesc.sql', ZQuery);
end;

procedure TdbMetaDataTest.CreateMovementDescFunction;
begin
  ExecFile(MetadataPath + 'CreateMovementDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'CreateMovementLinkObjectDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'CreateMovementFloatDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'CreateMovementDateDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'CreateMovementBooleanDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'CreateMovementStringDescFunction.sql', ZQuery);
end;

procedure TdbMetaDataTest.CreateMovementItemContainerFunction;
begin
  ExecFile(MetadataPath + 'CreateMovementItemContainerDescFunction.sql', ZQuery);
end;

procedure TdbMetaDataTest.CreateMovementItemDescFunction;
begin
  ExecFile(MetadataPath + 'CreateMovementItemDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'CreateMovementItemLinkObjectDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'CreateMovementItemFloatDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'CreateMovementItemBooleanDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'CreateMovementItemStringDescFunction.sql', ZQuery);
end;

procedure TdbMetaDataTest.InsertMovementItemContainerDesc;
begin
  ExecFile(MetadataPath + 'InsertMovementItemContainerDesc.sql', ZQuery);
end;

procedure TdbMetaDataTest.InsertMovementItemDesc;
begin
  ExecFile(MetadataPath + 'InsertMovementItemDesc.sql', ZQuery);
  ExecFile(MetadataPath + 'InsertMovementItemLinkObjectDesc.sql', ZQuery);
  ExecFile(MetadataPath + 'InsertMovementItemFloatDesc.sql', ZQuery);
  ExecFile(MetadataPath + 'InsertMovementItemBooleanDesc.sql', ZQuery);
  ExecFile(MetadataPath + 'InsertMovementItemStringDesc.sql', ZQuery);
end;

procedure TdbMetaDataTest.CreateObjectDescFunction;
begin
  ExecFile(MetadataPath + 'CreateObjectDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'CreateObjectStringDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'CreateObjectLinkDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'CreateObjectBLOBDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'CreateObjectFloatDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'CreateObjectBooleanDescFunction.sql', ZQuery);
end;

procedure TdbMetaDataTest.CreateObjectHistoryDescFunction;
begin
  ExecFile(MetadataPath + 'CreateObjectHistoryDescFunction.sql', ZQuery);
  ExecFile(MetadataPath + 'CreateObjectHistoryFloatDescFunction.sql', ZQuery);
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
