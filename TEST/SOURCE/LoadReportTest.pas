unit LoadReportTest;

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
    procedure LoadReportFormTest;
  end;

implementation

uses Authentication, FormStorage, CommonData, Storage;

const
  ReportPath = '..\Reports';

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
  
procedure TLoadReportTest.LoadReportFormTest;
var
 i : integer;
begin
  // ������(�������)
  LoadReportFromFile('����� ���� �� ���������� (c ���������-���������)', ReportPath + '\������ (�������)\����� ���� �� ���������� (c ���������-���������).fr3');
  LoadReportFromFile('����� ���� �� ���������� (c ���������)', ReportPath + '\������ (�������)\����� ���� �� ���������� (c ���������).fr3');
  LoadReportFromFile('����� ���� �� ���������� (c ������)', ReportPath + '\������ (�������)\����� ���� �� ���������� (c ������).fr3');
  LoadReportFromFile('��� ������ (�������������) ����', ReportPath + '\������ (�������)\��� ������ (�������������) ����.fr3');
  LoadReportFromFile('����� ���� �� ���������� (��� ������)', ReportPath + '\������ (�������)\����� ���� �� ���������� (��� ������).fr3');

  // �������� ����� ���������
  LoadReportFromFile('PrintMovement_Sale1', ReportPath + '\�������� ����\PrintMovement_Sale1.fr3');
  LoadReportFromFile('PrintMovement_Sale2', ReportPath + '\�������� ����\PrintMovement_Sale2.fr3');
  LoadReportFromFile('PrintMovement_Tax', ReportPath + '\�������� ����\��������� ���������.fr3');
  LoadReportFromFile('PrintMovement_Bill', ReportPath + '\�������� ����\PrintMovement_Bill.fr3');
  LoadReportFromFile('PrintMovement_Bill01074874', ReportPath + '\�������� ����\PrintMovement_Bill01074874.fr3');

  TStrArrAdd(['35275230','30982361','30487219','37910513','32294926','01074874','32516492','35442481','36387249','32049199']);
  for i := Low(OKPO) to High(OKPO) do
    LoadReportFromFile('PrintMovement_Sale' + OKPO[i], ReportPath + '\�������� ����\PrintMovement_Sale' + OKPO[i] + '.fr3');

end;

procedure TLoadReportTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', '�����', gc_User);
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
