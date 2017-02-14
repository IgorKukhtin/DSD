unit dbEnumBoutiqueTest;

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

   EnumPath: string = '..\DATABASE\Boutique\METADATA\Enum\';
   BoutiqueEnumPath: string = '..\DATABASE\Boutique\METADATA\Enum\';

implementation

{ TdbEnumTest }

uses zLibUtil, UtilConst;

procedure TdbEnumTest.InsertObjectEnum;
begin
  ExecFile(EnumPath + 'CreateObjectEnumFunction.sql', ZQuery);
  ExecFile(EnumPath + 'InsertObjectEnum.sql', ZQuery);
//  �������� �� �������
//  if dsdProject = prBoutique then
//  Begin
//    ExecFile(BoutiqueEnumPath + 'CreateObjectEnumFunction.sql', ZQuery);
//    ExecFile(BoutiqueEnumPath + 'InsertObjectEnum.sql', ZQuery);
//  End;

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
