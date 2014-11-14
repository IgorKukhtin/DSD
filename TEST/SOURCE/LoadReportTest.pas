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
  // Транспорт
  LoadReportFromFile('Путевой лист - Сбыт', ReportPath + '\Транспорт\Путевой лист - Сбыт.fr3');
  // Отчеты(Финансы)
  LoadReportFromFile('Отчет Итог по покупателю (c отсрочкой-накладные реализация)', ReportPath + '\Отчеты (финансы)\Отчет Итог по покупателю (c отсрочкой-накладные реализация).fr3');
  LoadReportFromFile('Отчет Итог по покупателю (c отсрочкой-накладные)', ReportPath + '\Отчеты (финансы)\Отчет Итог по покупателю (c отсрочкой-накладные).fr3');
  LoadReportFromFile('Отчет Итог по покупателю (c отсрочкой)', ReportPath + '\Отчеты (финансы)\Отчет Итог по покупателю (c отсрочкой).fr3');

  LoadReportFromFile('Обороты по юр лицам - покупатели(бухг)', ReportPath + '\Отчеты (финансы)\Обороты по юр лицам - покупатели(бухг).fr3');
  LoadReportFromFile('Обороты по юр лицам - покупатели(факт)', ReportPath + '\Отчеты (финансы)\Обороты по юр лицам - покупатели(факт).fr3');
  LoadReportFromFile('Обороты по контрагентам (факт)', ReportPath + '\Отчеты (финансы)\Обороты по контрагентам (факт).fr3');


  LoadReportFromFile('Акт сверки (бухгалтерский) АЛАН', ReportPath + '\Отчеты (финансы)\Акт сверки (бухгалтерский) АЛАН.fr3');
  LoadReportFromFile('Отчет Итог по покупателю (Акт сверки)', ReportPath + '\Отчеты (финансы)\Отчет Итог по покупателю (Акт сверки).fr3');
  LoadReportFromFile('Обороты из акта сверки', ReportPath + '\Отчеты (финансы)\Обороты из акта сверки.fr3');
  LoadReportFromFile('Обороты по счету', ReportPath + '\Отчеты (финансы)\Обороты по счету.fr3');
  LoadReportFromFile('Обороты по кассе', ReportPath + '\Отчеты (финансы)\Обороты по кассе.fr3');
  //LoadReportFromFile('Отчет по кассе (детальный)', ReportPath + '\Отчеты (финансы)\Отчет по кассе (детальный).fr3');

  LoadReportFromFile('Продажа и возврат', ReportPath + '\Отчеты (товарные)\Продажа и возврат.fr3');
  LoadReportFromFile('Продажа и возврат по юрлицам', ReportPath + '\Отчеты (товарные)\Продажа и возврат по юрлицам.fr3');
  LoadReportFromFile('Отчет по группе статистики', ReportPath + '\Отчеты (товарные)\Отчет по группе статистики.fr3');

  LoadReportFromFile('Отчет движение по товару (для всех)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (для всех).fr3');
  LoadReportFromFile('Отчет_Приход_Расход_производство_разделение_по_документам_1', ReportPath + '\Отчеты (производство)\Отчет_Приход_Расход_производство_разделение_по_документам_1.fr3');

  LoadReportFromFile('Отчет по просрочке', ReportPath + '\Отчеты (финансы)\Отчет по просрочке.fr3');

  // Печатные формы Заявки
  LoadReportFromFile('Отчет - заявки (для Упаковки)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (для Упаковки).fr3');
  LoadReportFromFile('Отчет - заявки (по Покупателям-все)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (по Покупателям-все).fr3');
  LoadReportFromFile('Отчет - заявки (на Производство)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (на Производство).fr3');
  LoadReportFromFile('Отчет - заявки (по виду товара)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (по виду товара).fr3');
  LoadReportFromFile('Отчет - заявки (по Маршрутам-детально)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (по Маршрутам-детально).fr3');
  LoadReportFromFile('Отчет - заявки (по Маршрутам-итого)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (по Маршрутам-итого).fr3');

  // Печатные формы накладных
  LoadReportFromFile('PrintMovement_TransferDebtOut', ReportPath + '\Товарный Учет\PrintMovement_TransferDebtOut.fr3');
  LoadReportFromFile('PrintMovement_Sale1', ReportPath + '\Товарный Учет\PrintMovement_Sale1.fr3');
  LoadReportFromFile('PrintMovement_Sale2', ReportPath + '\Товарный Учет\PrintMovement_Sale2.fr3');
  LoadReportFromFile('PrintMovement_SaleInvoice', ReportPath + '\Товарный Учет\PrintMovement_SaleInvoice.fr3');
  LoadReportFromFile('PrintMovement_SalePack', ReportPath + '\Товарный Учет\PrintMovement_SalePack.fr3');
  LoadReportFromFile('PrintMovement_ReturnIn', ReportPath + '\Товарный Учет\PrintMovement_ReturnIn.fr3');
  LoadReportFromFile('PrintMovement_ReturnIn32049199', ReportPath + '\Товарный Учет\PrintMovement_ReturnIn32049199.fr3');
  LoadReportFromFile('PrintMovement_Tax', ReportPath + '\Товарный Учет\PrintMovement_Tax.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective', ReportPath + '\Товарный Учет\PrintMovement_TaxCorrective.fr3');
  LoadReportFromFile('PrintMovement_Bill', ReportPath + '\Товарный Учет\PrintMovement_Bill.fr3');
  LoadReportFromFile('PrintMovement_Bill01074874', ReportPath + '\Товарный Учет\PrintMovement_Bill01074874.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrectiveReestr', ReportPath + '\Товарный Учет\PrintMovement_TaxCorrectiveReestr.fr3');

  LoadReportFromFile('PrintMovement_ReturnIn_By_TaxCorrective', ReportPath + '\Товарный Учет\PrintMovement_ReturnIn_By_TaxCorrective.fr3');

  LoadReportFromFile('PrintMovement_OrderExternal', ReportPath + '\Товарный Учет\PrintMovement_OrderExternal.fr3');
  LoadReportFromFile('PrintMovement_Loss', ReportPath + '\Товарный Учет\PrintMovement_Loss.fr3');

  TStrArrAdd(['35275230','30982361','30487219','37910513','32294926','01074874','32516492','35442481','36387249','32049199']);
  for i := Low(OKPO) to High(OKPO) do
    LoadReportFromFile('PrintMovement_Sale' + OKPO[i], ReportPath + '\Товарный Учет\PrintMovement_Sale' + OKPO[i] + '.fr3');

end;

procedure TLoadReportTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'qsxqsxw1', gc_User);
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
