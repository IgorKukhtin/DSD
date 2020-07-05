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
   FarmacyEnumPath: string = '..\DATABASE\Farmacy\METADATA\Enum\';

implementation

{ TdbEnumTest }

uses zLibUtil, UtilConst;

procedure TdbEnumTest.InsertObjectEnum;
begin
  ExecFile(EnumPath + 'CreateObjectEnumFunction.sql', ZQuery);
  ExecFile(EnumPath + 'InsertObjectEnum.sql', ZQuery);
  if dsdProject = prFarmacy then
  Begin
    ExecFile(FarmacyEnumPath + 'CreateObjectEnumFunction.sql', ZQuery);
    ExecFile(FarmacyEnumPath + 'InsertObjectEnum.sql', ZQuery);
  End;

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
//  TestFramework.RegisterTest('Перечисления и служебные', TdbEnumTest.Suite);

end.
