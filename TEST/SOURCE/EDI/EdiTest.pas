unit EdiTest;

interface

uses TestFramework, dbTest;

type

  TdbEDITest = class (TdbTest)
  protected
    // �������������� ������ ��� ������������
    procedure SetUp; override;
    // ���������� ������ ��� ������������
    procedure TearDown; override;
  published
    procedure CreateDesadvTest;
  end;

implementation

uses SaleMovementItemTest, Authentication, Storage, CommonData, EDI;

{ TdbEDITest }

procedure TdbEDITest.CreateDesadvTest;
var SaleMovementItem: TSaleMovementItem;
    Id: Integer;
    EDI: TEDI;
begin
  { ������� �������� ���������� � ������ � ��� }
  // ������� ��������
  SaleMovementItem := TSaleMovementItem.Create;
  EDI := TEDI.Create(nil);
  // �������� ���������
  try
     Id := SaleMovementItem.InsertDefault;
     EDI.DESADV(Id);
     { ��������� ��������� �������� ��������� DESADV}
  finally
    EDI.Free;
    SaleMovementItem.Delete(Id);
  end;
end;

procedure TdbEDITest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', '�����', gc_User);
end;

procedure TdbEDITest.TearDown;
begin
  inherited;

end;

initialization

  TestFramework.RegisterTest('EDI', TdbEDITest.Suite);

end.
