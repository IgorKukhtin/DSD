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

const
  StructurePath = '..\DATABASE\STRUCTURE\';

procedure TDropCreateDataBase.CreateDataBase;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'CreateDataBase.sql');
  ZQuery.ExecSQL;
end;

procedure TDropCreateDataBase.DropDataBase;
begin
  ZQuery.SQL.LoadFromFile(StructurePath + 'DropDataBase.sql');
  ZQuery.ExecSQL;
end;

procedure TDropCreateDataBase.SetUp;
begin
  inherited;
  ZConnection := TZConnection.Create(nil);
  ZConnection.HostName := 'localhost';
  ZConnection.Port := 5432;
  ZConnection.Protocol := 'postgresql-9';
  ZConnection.User := 'postgres';
  ZConnection.Connected := true;
  ZQuery := TZQuery.Create(nil);
  ZQuery.Connection := ZConnection;
end;

procedure TDropCreateDataBase.TearDown;
begin
  inherited;

end;

initialization
  TestFramework.RegisterTest('DropCreateDataBase', TDropCreateDataBase.Suite);

end.
