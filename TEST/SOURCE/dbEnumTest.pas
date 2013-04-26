unit dbEnumTest;

interface

uses TestFramework, ZConnection, ZDataset;

type
  TdbEnumTest = class (TTestCase)
  private
    ZConnection: TZConnection;
    ZQuery: TZQuery;
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure InsertObjectEnum;
  end;

implementation

{ TdbEnumTest }

uses zLibUtil;

const
  MetadataPath = '..\DATABASE\COMMON\METADATA\Enum\';

procedure TdbEnumTest.InsertObjectEnum;
begin
  ZQuery.SQL.LoadFromFile(MetadataPath + 'CreateObjectEnumFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(MetadataPath + 'InsertObjectEnum.sql');
  ZQuery.ExecSQL;
end;

procedure TdbEnumTest.SetUp;
begin
  inherited;
  ZConnection := TConnectionFactory.GetConnection;
  ZConnection.Connected := true;
  ZQuery := TZQuery.Create(nil);
  ZQuery.Connection := ZConnection;
end;

procedure TdbEnumTest.TearDown;
begin
  inherited;
  ZConnection.Free;
  ZQuery.Free;
end;

initialization
  TestFramework.RegisterTest('Перечисления и служебные', TdbEnumTest.Suite);

end.
