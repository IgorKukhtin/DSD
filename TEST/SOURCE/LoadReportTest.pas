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
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
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
  // Загрузка из файла в репорт
  Report.LoadFromFile(ReportPath);

  // Сохранение отчета в базу
  Stream.Clear;
  Report.SaveToStream(Stream);
  Stream.Position := 0;
  TdsdFormStorageFactory.GetStorage.SaveReport(Stream, ReportName);

  // Считывание отчета из базы
  Report.LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport(ReportName));
end;
  
procedure TLoadReportTest.LoadReportFormTest;
var
 i : integer;
begin
  // Отчеты(Финансы)
  LoadReportFromFile('Отчет Итог по покупателю (c отсрочкой-накладные)', ReportPath + '\Отчеты (финансы)\Отчет Итог по покупателю (c отсрочкой-накладные).fr3');
  LoadReportFromFile('Отчет Итог по покупателю (c отсрочкой)', ReportPath + '\Отчеты (финансы)\Отчет Итог по покупателю (c отсрочкой).fr3');
  LoadReportFromFile('Отчет Итог по покупателю (c долгом)', ReportPath + '\Отчеты (финансы)\Отчет Итог по покупателю (c долгом).fr3');
  LoadReportFromFile('Акт сверки (бухгалтерский) АЛАН', ReportPath + '\Отчеты (финансы)\Акт сверки (бухгалтерский) АЛАН.fr3');
  LoadReportFromFile('Отчет Итог по покупателю (Акт сверки)', ReportPath + '\Отчеты (финансы)\Отчет Итог по покупателю (Акт сверки).fr3');

  // Печатные формы накладных
  LoadReportFromFile('PrintMovement_Sale1', ReportPath + '\Товарный Учет\PrintMovement_Sale1.fr3');
  LoadReportFromFile('PrintMovement_Sale2', ReportPath + '\Товарный Учет\PrintMovement_Sale2.fr3');
  LoadReportFromFile('PrintMovement_Tax', ReportPath + '\Товарный Учет\Налоговая накладная.fr3');
  LoadReportFromFile('PrintMovement_Bill', ReportPath + '\Товарный Учет\PrintMovement_Bill.fr3');
  LoadReportFromFile('PrintMovement_Bill01074874', ReportPath + '\Товарный Учет\PrintMovement_Bill01074874.fr3');

  TStrArrAdd(['35275230','30982361','30487219','37910513','32294926','01074874','32516492','35442481','36387249','32049199']);
  for i := Low(OKPO) to High(OKPO) do
    LoadReportFromFile('PrintMovement_Sale' + OKPO[i], ReportPath + '\Товарный Учет\PrintMovement_Sale' + OKPO[i] + '.fr3');

end;

procedure TLoadReportTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
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
  TestFramework.RegisterTest('Загрузка отчетов', TLoadReportTest.Suite);

end.
