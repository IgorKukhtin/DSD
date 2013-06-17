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

 var

   EnumPath: string = '..\DATABASE\COMMON\METADATA\Enum\';

implementation

{ TdbEnumTest }

uses zLibUtil;

procedure TdbEnumTest.InsertObjectEnum;
begin
  ZQuery.SQL.LoadFromFile(EnumPath + 'CreateObjectEnumFunction.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(EnumPath + 'InsertObjectEnum.sql');
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
