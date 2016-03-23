unit LoadFarmacyReportTest;

interface

uses
  TestFramework, frxClass, frxDBSet, Classes, frxDesgn;

type

  TLoadReportTest = class (TTestCase)
  private
    Stream: TStringStream;
    Report: TfrxReport;
    OKPO : array of string;
    procedure LoadReportFromFile(ReportName, ReportPath: string);
    procedure TStrArrAdd(const A : array of string);
  protected
    // �������������� ������ ��� ������������
    procedure SetUp; override;
    // ���������� ������ ��� ������������
    procedure TearDown; override;
  published
    procedure LoadAllReportFormTest;
  end;

implementation

uses Authentication, FormStorage, CommonData, Storage, UtilConst;

const
  ReportPath = '..\Reports\Farmacy';

{ TLoadReportTest }

procedure TLoadReportTest.TStrArrAdd(const A : array of string);
var i : integer;
begin
  SetLength(OKPO, Length(a));
  for i := Low(A) to High(A) do
    OKPO[i] := A[i];
end;

procedure TLoadReportTest.LoadReportFromFile(ReportName, ReportPath: string);
begin
  // �������� �� ����� � ������
  Report.LoadFromFile(ReportPath);

  // ���������� ������ � ����
  Stream.Clear;
  Report.SaveToStream(Stream);
  Stream.Position := 0;
  TdsdFormStorageFactory.GetStorage.SaveReport(Stream, ReportName);

  // ���������� ������ �� ����
  Report.LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport(ReportName));
end;

procedure TLoadReportTest.LoadAllReportFormTest;
var
 i : integer;
begin
// exit;

  // ������
  LoadReportFromFile('���������_���������', ReportPath + '\���������_���������.fr3');
  LoadReportFromFile('���������_���������_���_���������', ReportPath + '\���������_���������_���_���������.fr3');
  LoadReportFromFile('��������������', ReportPath + '\��������������.fr3');
  LoadReportFromFile('��������', ReportPath + '\��������.fr3');
  LoadReportFromFile('�����������', ReportPath + '\�����������.fr3');
  LoadReportFromFile('�������', ReportPath + '\�������.fr3');
  LoadReportFromFile('������', ReportPath + '\������.fr3');
  LoadReportFromFile('����������_���������', ReportPath + '\����������_���������.fr3');
  LoadReportFromFile('����� �� �������� �� ������', ReportPath + '\����� �� �������� �� ������.fr3');
end;

procedure TLoadReportTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', gc_AdminPassword, gc_User);
  Report := TfrxReport.Create(nil);
  Stream := TStringStream.Create;
end;

procedure TLoadReportTest.TearDown;
begin
  inherited;
  Report.Free;
  Stream.Free
end;

initialization
  TestFramework.RegisterTest('�������� �������', TLoadReportTest.Suite);

end.
