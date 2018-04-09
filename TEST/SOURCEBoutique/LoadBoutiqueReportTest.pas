unit LoadBoutiqueReportTest;

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
  ReportPath = '..\Reports\Boutique';

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
  LoadReportFromFile('PrintReport_Sale', ReportPath + '\PrintReport_Sale.fr3');
  LoadReportFromFile('PrintReport_ReturnIn', ReportPath + '\PrintReport_ReturnIn.fr3');
  LoadReportFromFile('PrintReport_Uniform', ReportPath + '\PrintReport_Uniform.fr3');
  LoadReportFromFile('PrintReport_Goods_RemainsCurrent', ReportPath + '\PrintReport_Goods_RemainsCurrent.fr3');
  LoadReportFromFile('Print_Check_GoodsAccount', ReportPath + '\Print_Check_GoodsAccount.fr3');
  LoadReportFromFile('Print_Check', ReportPath + '\Print_Check.fr3');
  LoadReportFromFile('�������� �� ���������� (��� ������)', ReportPath + '\�������� �� ���������� (��� ������).fr3');
  LoadReportFromFile('�������� �� ����������', ReportPath + '\�������� �� ����������.fr3');
  LoadReportFromFile('����� �� ��������', ReportPath + '\����� �� ��������.fr3');
  LoadReportFromFile('PrintMovement_Income', ReportPath + '\PrintMovement_Income.fr3');
//  LoadReportFromFile('PrintMovement_IncomeIn', ReportPath + '\������ �� ���������� �� ����.fr3');
  LoadReportFromFile('PrintMovement_ReturnOut', ReportPath + '\PrintMovement_ReturnOut.fr3');
  LoadReportFromFile('PrintMovement_Send', ReportPath + '\PrintMovement_Send.fr3');
  LoadReportFromFile('PrintMovement_SendIn', ReportPath + '\PrintMovement_SendIn.fr3');
  LoadReportFromFile('PrintMovement_Loss', ReportPath + '\PrintMovement_Loss.fr3');
  LoadReportFromFile('PrintMovement_IncomeSticker', ReportPath + '\PrintMovement_IncomeSticker.fr3');
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
