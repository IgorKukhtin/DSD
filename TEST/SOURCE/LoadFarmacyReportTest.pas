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
    procedure LoadFileFromFile(FileName, FilePath: string);
    procedure TStrArrAdd(const A : array of string);
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure LoadAllReportFormTest;
    procedure LoadAllBlankFormTest;
    procedure LoadAllWAVFormTest;
  end;

implementation

uses Authentication, FormStorage, CommonData, Storage, UtilConst;

const
  ReportPath = '..\Reports\Farmacy';
  FarmacyBlankPath = '..\Reports\FarmacyBlank';
  FarmacyWAVPath = '..\Reports\FarmacyWAV';

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

procedure TLoadReportTest.LoadFileFromFile(FileName, FilePath: string);
begin

  // Сохранение файла в базу
  Stream.Clear;
  Stream.LoadFromFile(FilePath);
  Stream.Position := 0;
  TdsdFormStorageFactory.GetStorage.SaveReport(Stream, FileName);

  // Считывание отчета из базы
  Stream.LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadReport(FileName));
end;


procedure TLoadReportTest.LoadAllReportFormTest;
var
 i : integer;
begin
  LoadReportFromFile('Счет для страховой компании', ReportPath + '\Счет для страховой компании.fr3');
{
  LoadReportFromFile('Возвратная ТТН', ReportPath + '\Возвратная ТТН.fr3');
  Exit;

  LoadReportFromFile('Коммерческое предложение', ReportPath + '\Коммерческое предложение.fr3');
  LoadReportFromFile('Счет к безналу предприятия', ReportPath + '\Счет к безналу предприятия.fr3');
  Exit;

  LoadReportFromFile('Счет соц.проект', ReportPath + '\Счет соц.проект.fr3');
  //доп. соглащения Соц. проект
  LoadReportFromFile('PrintReport_CheckSP_8513005', ReportPath + '\PrintReport_CheckSP_8513005.fr3');

  LoadReportFromFile('PrintReport_CheckSP_9102200', ReportPath + '\PrintReport_CheckSP_9102200.fr3');
  LoadReportFromFile('PrintReport_CheckSP_9089478', ReportPath + '\PrintReport_CheckSP_9089478.fr3');
  LoadReportFromFile('PrintReport_CheckSP_9126996', ReportPath + '\PrintReport_CheckSP_9126996.fr3');

  LoadReportFromFile('PrintReport_CheckSP_4474509', ReportPath + '\PrintReport_CheckSP_4474509.fr3');
  LoadReportFromFile('PrintReport_CheckSP_4474508', ReportPath + '\PrintReport_CheckSP_4474508.fr3');
  LoadReportFromFile('PrintReport_CheckSP_4474307', ReportPath + '\PrintReport_CheckSP_4474307.fr3');
  LoadReportFromFile('PrintReport_CheckSP_4474556', ReportPath + '\PrintReport_CheckSP_4474556.fr3');
  LoadReportFromFile('PrintReport_CheckSP_4212299', ReportPath + '\PrintReport_CheckSP_4212299.fr3');

  LoadReportFromFile('Реестр лекарственных препаратов', ReportPath + '\Реестр лекарственных препаратов.fr3');


  LoadReportFromFile('Счет постановление 1303', ReportPath + '\Счет постановление 1303.fr3');
  LoadReportFromFile('Pеестр по постановлению 1303', ReportPath + '\Pеестр по постановлению 1303.fr3');
  LoadReportFromFile('Pеестр по постановлению 1303(счет)', ReportPath + '\Pеестр по постановлению 1303(счет).fr3');
  LoadReportFromFile('Pеестр по постановлению 1303(накладная)', ReportPath + '\Pеестр по постановлению 1303(накладная).fr3');

  exit;

  LoadReportFromFile('Отчет по продажам Соц.проекта', ReportPath + '\Отчет по продажам Соц.проекта.fr3');

  LoadReportFromFile('Отчет по продажам Соц.проекта(пост.152)', ReportPath + '\Отчет по продажам Соц.проекта(пост.152).fr3');
  exit;
  {
  LoadReportFromFile('PrintReport_CheckSP_4474558', ReportPath + '\PrintReport_CheckSP_4474558.fr3');
  exit;
  {
  LoadReportFromFile('Печать стикера самоклейки', ReportPath + '\Печать стикера самоклейки.fr3');
  LoadReportFromFile('Копия чека клиенту', ReportPath + '\Копия чека клиенту.fr3');
  LoadReportFromFile('Копия чека клиенту(продажа)', ReportPath + '\Копия чека клиенту(продажа).fr3');
   exit;
  // Другие
  LoadReportFromFile('Расходная_накладная', ReportPath + '\Расходная_накладная.fr3');
  LoadReportFromFile('Расходная_накладная_для_менеджера', ReportPath + '\Расходная_накладная_для_менеджера.fr3');
  LoadReportFromFile('Инвентаризация', ReportPath + '\Инвентаризация.fr3');
  LoadReportFromFile('Списание', ReportPath + '\Списание.fr3');

  LoadReportFromFile('Перемещение', ReportPath + '\Перемещение.fr3');
  exit;

  LoadReportFromFile('Продажа', ReportPath + '\Продажа.fr3');
  LoadReportFromFile('Оплаты', ReportPath + '\Оплаты.fr3');

  LoadReportFromFile('Возвратная_накладная(Оптима)', ReportPath + '\Возвратная_накладная(Оптима).fr3');
  LoadReportFromFile('Возвратная_накладная', ReportPath + '\Возвратная_накладная.fr3');
  LoadReportFromFile('Отчет по продажам на кассах', ReportPath + '\Отчет по продажам на кассах.fr3');
  LoadReportFromFile('Отчет Доходности', ReportPath + '\Отчет Доходности.fr3');
   }
end;

procedure TLoadReportTest.LoadAllBlankFormTest;
begin
  LoadFileFromFile('ИНВЕНТ_ОПИСЬ_на_каждый_месяц.doc', FarmacyBlankPath + '\ИНВЕНТ ОПИСЬ на каждый месяц.doc');
  LoadFileFromFile('Шаблон заявления на возврат товара.doc', FarmacyBlankPath + '\Шаблон заявления на возврат товара.doc');
end;

procedure TLoadReportTest.LoadAllWAVFormTest;
begin
  LoadFileFromFile('Bell0001.wav', FarmacyWAVPath + '\Bell0001.wav');
end;

procedure TLoadReportTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', gc_AdminPassword, gc_User);
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
