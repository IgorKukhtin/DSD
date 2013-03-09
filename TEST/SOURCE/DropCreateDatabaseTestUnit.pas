unit DropCreateDatabaseTestUnit;

interface

uses TestFramework, ZConnection, ZDataset;

type
  TDropCreateDataBase = class (TTestCase)
  private
    ZConnection: TZConnection;
    ZQuery: TZQuery;
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure DropDataBase;
    procedure CreateDataBase;
  end;

implementation

{ TCheckDataBaseStructure }
uses UtilUnit;

const
  StructurePath = '..\DATABASE\COMMON\STRUCTURE\';

procedure TDropCreateDataBase.CreateDataBase;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'CreateDataBase.sql');
  ZQuery.ExecSQL;
end;

procedure TDropCreateDataBase.DropDataBase;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'KIllSession.sql');
  ZQuery.ExecSQL;
  ZQuery.SQL.LoadFromFile(StructurePath + 'DropDataBase.sql');
  ZQuery.ExecSQL;
end;

procedure TDropCreateDataBase.SetUp;
begin
  inherited;
  ZConnection := TConnectionFactory.GetConnection;
  ZConnection.Database := '';
  ZConnection.Connected := true;
  ZQuery := TZQuery.Create(nil);
  ZQuery.Connection := ZConnection;
end;

procedure TDropCreateDataBase.TearDown;
begin
  inherited;
  ZConnection.Free;
  ZQuery.Free;
end;

initialization
  TestFramework.RegisterTest('DropCreateDataBase', TDropCreateDataBase.Suite);

end.
