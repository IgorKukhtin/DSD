unit LoadReportTest;

interface

uses
  TestFramework, frxClass, frxDBSet, Classes, frxDesgn;

type

  TLoadReportTest = class (TTestCase)
  private
    Stream: TStringStream;
    Report: TfrxReport;
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

procedure TLoadReportTest.LoadReportFormTest;
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
