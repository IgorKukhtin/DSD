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

uses FormStorage;

const
  ReportPath = '..\Reports';

{ TLoadReportTest }

procedure TLoadReportTest.TStrArrAdd(const A : array of string);
var i : integer;
begin
  SetLength(OKPO,Length(a));
  for i:=Low(A) to High(A) do
    OKPO[i] := A[i];
end;

procedure TLoadReportTest.LoadReportFormTest;
var
 OKPO:array of string;
 i : integer;
begin



  // �������� �� ����� � ������
  Report.LoadFromFile(ReportPath + '\���������\��������� ���������.fr3');

  // ���������� ������ � ����
  Stream.Clear;
  Report.SaveToStream(Stream);
  Stream.Position := 0;
  TdsdFormStorageFactory.GetStorage.SaveReport(Stream, '��������� ���������');

  // ���������� ������ �� ����
  Report.LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport('��������� ���������'));
//=======================

  // �������� �� ����� � ������
  Report.LoadFromFile(ReportPath + '\�������� ����\��������� ��������� ��.fr3');

  // ���������� ������ � ����
  Stream.Clear;
  Report.SaveToStream(Stream);
  Stream.Position := 0;
  TdsdFormStorageFactory.GetStorage.SaveReport(Stream, 'PrintMovement_Sale1');

  // ���������� ������ �� ����
  Report.LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport('PrintMovement_Sale1'));

//=======================

  // �������� �� ����� � ������
  Report.LoadFromFile(ReportPath + '\�������� ����\��������� ��������� ���.fr3');

  // ���������� ������ � ����
  Stream.Clear;
  Report.SaveToStream(Stream);
  Stream.Position := 0;
  TdsdFormStorageFactory.GetStorage.SaveReport(Stream, 'PrintMovement_Sale2');

  // ���������� ������ �� ����
  Report.LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport('PrintMovement_Sale2'));

//==  ���� �� ����
{
 TStrArrAdd(['01074874','23193668','25288083','30487219','30982361',
             '32334104','19202597','32049199','32294926','32516492',
             '34356884','35231874','35275230','35442481','36387249',
             '36387233','37910513','37910542']);
   for i:=Low(OKPO) to High(OKPO) do
   begin
  // �������� �� ����� � ������
    Report.LoadFromFile(ReportPath + '\�������� ����\PrintMovement_Sale'+OKPO[i]+'.fr3');

  // ���������� ������ � ����
    Stream.Clear;
    Report.SaveToStream(Stream);
    Stream.Position := 0;
    TdsdFormStorageFactory.GetStorage.SaveReport(Stream, 'PrintMovement_Sale'+OKPO[i]);

  // ���������� ������ �� ����
    Report.LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport('PrintMovement_Sale'+OKPO[i]));
   end;
 }
 //END ==  ���� �� ����

end;

procedure TLoadReportTest.SetUp;
begin
  inherited;
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
