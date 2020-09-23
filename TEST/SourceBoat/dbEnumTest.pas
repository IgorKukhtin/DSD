unit dbEnumTest;

interface

uses TestFramework, ZConnection, ZDataset;

type
  TdbEnumTest = class (TTestCase)
  private
    ZConnection: TZConnection;
    ZQuery: TZQuery;
  protected
    // �������������� ������ ��� ������������
    procedure SetUp; override;
    // ���������� ������ ��� ������������
    procedure TearDown; override;
  published
    procedure InsertObjectEnum;
  end;

 var

   EnumPath: string = '..\DATABASE\Boat\METADATA\Enum\';


implementation

{ TdbEnumTest }

uses zLibUtil, UtilConst;

procedure TdbEnumTest.InsertObjectEnum;
begin
  ExecFile(EnumPath + 'CreateObjectEnumFunction.sql', ZQuery);
  ExecFile(EnumPath + 'InsertObjectEnum.sql', ZQuery);

  ExecFile(EnumPath + '_InfoMoney.sql', ZQuery);
  ExecFile(EnumPath + '_InfoMoney.sql', ZQuery);
  ExecFile(EnumPath + '_Account.sql', ZQuery);
  ExecFile(EnumPath + '_Account.sql', ZQuery);
  ExecFile(EnumPath + '_ProfitLoss.sql', ZQuery);
  ExecFile(EnumPath + '_ProfitLoss.sql', ZQuery);

  ExecFile(EnumPath + 'InsertObjectEnum_01.sql', ZQuery);
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
  TestFramework.RegisterTest('������������ � ���������', TdbEnumTest.Suite);

end.
