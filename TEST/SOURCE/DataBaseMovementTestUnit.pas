unit DataBaseMovementTestUnit;

interface
uses TestFramework, ZConnection, ZDataset;

type
  TDataBaseMovementTest = class (TTestCase)
  private
    ZConnection: TZConnection;
    ZQuery: TZQuery;
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
  end;

implementation

//uses ZDbcIntfs, SysUtils, StorageUnit, DBClient, XMLDoc;
uses UtilUnit;

{ TDataBaseObjectTest }
{------------------------------------------------------------------------------}
procedure TDataBaseMovementTest.TearDown;
begin
  inherited;
  ZConnection.Rollback;
  ZConnection.Connected := false;
  ZConnection.Free;
  ZQuery.Free;
end;
{------------------------------------------------------------------------------}
procedure TDataBaseMovementTest.SetUp;
begin
  inherited;
  ZConnection := TConnectionFactory.GetConnection;
  ZQuery := TZQuery.Create(nil);
  ZQuery.Connection := ZConnection;
//  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', lUser);
end;
{------------------------------------------------------------------------------}
initialization
  TestFramework.RegisterTest('DataBaseMovementTest', TDataBaseMovementTest.Suite);

end.

implementation

end.
