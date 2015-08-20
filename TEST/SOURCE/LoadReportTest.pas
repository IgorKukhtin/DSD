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
    procedure LoadAllReportFormTest;
    procedure LoadTransportReportFormTest;
    procedure LoadReceiptFormTest;
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

procedure TLoadReportTest.LoadReceiptFormTest;
begin
  LoadReportFromFile('Печать_рецептов', ReportPath + '\Рецепты\Печать_рецептов.fr3');
  LoadReportFromFile('Печать_рецептов_детальная', ReportPath + '\Рецепты\Печать_рецептов_детальная.fr3');
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

procedure TLoadReportTest.LoadTransportReportFormTest;
begin
  // Транспорт
  LoadReportFromFile('Путевой лист - Сбыт', ReportPath + '\Транспорт\Путевой лист - Сбыт.fr3');
  LoadReportFromFile('Ведомость расхода топлива', ReportPath + '\Транспорт\Ведомость расхода топлива.fr3');
end;

procedure TLoadReportTest.LoadAllReportFormTest;
var
 i : integer;
begin
  LoadReportFromFile('Плановая Прибыль (сравнение цен себестоимости)', ReportPath + '\Отчеты (производство)\Плановая Прибыль (сравнение цен себестоимости).fr3');
 exit;
  // Другие
  LoadReportFromFile('Шаблон по точкам доставки', ReportPath + '\Отчеты (товарные)\Шаблон по точкам доставки.fr3');

  // Отчеты(Финансы)
  LoadReportFromFile('Отчет Итог по покупателю (c отсрочкой-накладные реализация)', ReportPath + '\Отчеты (финансы)\Отчет Итог по покупателю (c отсрочкой-накладные реализация).fr3');
  LoadReportFromFile('Отчет Итог по покупателю (c отсрочкой-накладные)', ReportPath + '\Отчеты (финансы)\Отчет Итог по покупателю (c отсрочкой-накладные).fr3');
  LoadReportFromFile('Отчет Итог по покупателю (c отсрочкой)', ReportPath + '\Отчеты (финансы)\Отчет Итог по покупателю (c отсрочкой).fr3');

  LoadReportFromFile('Обороты по юр лицам - покупатели(бухг)', ReportPath + '\Отчеты (финансы)\Обороты по юр лицам - покупатели(бухг).fr3');
  LoadReportFromFile('Обороты по юр лицам - покупатели(факт)', ReportPath + '\Отчеты (финансы)\Обороты по юр лицам - покупатели(факт).fr3');
  LoadReportFromFile('Обороты по контрагентам (факт)', ReportPath + '\Отчеты (финансы)\Обороты по контрагентам (факт).fr3');

  LoadReportFromFile('Обороты по юр лицам - поставщики(факт)', ReportPath + '\Отчеты (финансы)\Обороты по юр лицам - поставщики(факт).fr3');
  LoadReportFromFile('Обороты по контрагентам - поставщики(факт)', ReportPath + '\Отчеты (финансы)\Обороты по контрагентам - поставщики(факт).fr3');

  LoadReportFromFile('Акт сверки (бухгалтерский)', ReportPath + '\Отчеты (финансы)\Акт сверки (бухгалтерский).fr3');
  LoadReportFromFile('Акт сверки (в валюте)', ReportPath + '\Отчеты (финансы)\Акт сверки (в валюте).fr3');
  LoadReportFromFile('Отчет Итог по покупателю (Акт сверки)', ReportPath + '\Отчеты (финансы)\Отчет Итог по покупателю (Акт сверки).fr3');
  LoadReportFromFile('Обороты из акта сверки', ReportPath + '\Отчеты (финансы)\Обороты из акта сверки.fr3');
  LoadReportFromFile('Обороты по расчетному счету', ReportPath + '\Отчеты (финансы)\Обороты по расчетному счету.fr3');
  LoadReportFromFile('Обороты по кассе', ReportPath + '\Отчеты (финансы)\Обороты по кассе.fr3');
  LoadReportFromFile('Обороты по кассе (по элементам)', ReportPath + '\Отчеты (финансы)\Обороты по кассе (по элементам).fr3');
  LoadReportFromFile('Обороты по кассе (с комментариями)', ReportPath + '\Отчеты (финансы)\Обороты по кассе (с комментариями).fr3');

  //  Финансовый учет
  LoadReportFromFile('Платежка Банк', ReportPath + '\Финансовый Учет\Платежка Банк.fr3');


  LoadReportFromFile('Продажа и возврат', ReportPath + '\Отчеты (товарные)\Продажа и возврат.fr3');
  LoadReportFromFile('Продажа и возврат по юрлицам', ReportPath + '\Отчеты (товарные)\Продажа и возврат по юрлицам.fr3');
  LoadReportFromFile('Отчет по группе статистики', ReportPath + '\Отчеты (товарные)\Отчет по группе статистики.fr3');

  LoadReportFromFile('Отчет движение по товару (для всех)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (для всех).fr3');
  LoadReportFromFile('Отчет движение по товару (склад ГП)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (склад ГП).fr3');
  LoadReportFromFile('Отчет движение по товару (остаток)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (остаток).fr3');
  LoadReportFromFile('Отчет по товару по накладным', ReportPath + '\Отчеты (товарные)\Отчет по товару по накладным.fr3');


  LoadReportFromFile('Отчет движение по товару (цех упаковки)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (цех упаковки).fr3');
  LoadReportFromFile('Отчет движение по товару (цех)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (цех).fr3');

  LoadReportFromFile('Отчет по остаткам товара', ReportPath + '\Отчеты (товарные)\Отчет по остаткам товара.fr3');
  LoadReportFromFile('Отчет по остаткам товара (движение)', ReportPath + '\Отчеты (товарные)\Отчет по остаткам товара (движение).fr3');
  LoadReportFromFile('Отчет по остаткам товара (текущий)', ReportPath + '\Отчеты (товарные)\Отчет по остаткам товара (текущий).fr3');
  LoadReportFromFile('Отчет по остаткам товара (выход ГП)', ReportPath + '\Отчеты (товарные)\Отчет по остаткам товара (выход ГП).fr3');
  LoadReportFromFile('Отчет по остаткам товара (процент списания)', ReportPath + '\Отчеты (товарные)\Отчет по остаткам товара (процент списания).fr3');

  LoadReportFromFile('Отчет по товару (продажа по покупателям)', ReportPath + '\Отчеты (Отчеты (товарные)\Отчет по товару (продажа по покупателям).fr3');
  LoadReportFromFile('Отчет по товару (приход от поставщика)', ReportPath + '\Отчеты (товарные)\Отчет по товару (приход от поставщика).fr3');
  LoadReportFromFile('Отчет по товару (внутренний)', ReportPath + '\Отчеты (товарные)\Отчет по товару (внутренний).fr3');

  LoadReportFromFile('Отчет по просрочке', ReportPath + '\Отчеты (Отчеты (товарные)\Отчет по просрочке.fr3');

  // Отчеты производство
  LoadReportFromFile('Отчет_Приход_Расход_производство_разделение_по_документам_1', ReportPath + '\Отчеты (производство)\Отчет_Приход_Расход_производство_разделение_по_документам_1.fr3');
  LoadReportFromFile('Производство и процент выхода (итоги)', ReportPath + '\Отчеты (производство)\Производство и процент выхода (итоги).fr3');
  LoadReportFromFile('Производство и процент выхода (Анализ)', ReportPath + '\Отчеты (производство)\Производство и процент выхода (Анализ).fr3');
  LoadReportFromFile('Приход на склад и процент потерь (итоги)', ReportPath + '\Отчеты (производство)\Приход на склад и процент потерь (итоги).fr3');

  LoadReportFromFile('Плановая Прибыль', ReportPath + '\Отчеты (производство)\Плановая Прибыль.fr3');
  LoadReportFromFile('Плановая Прибыль (Факт)', ReportPath + '\Отчеты (производство)\Плановая Прибыль (Факт).fr3');
  LoadReportFromFile('Плановая Прибыль (Факт себестоимость и расходы)', ReportPath + '\Отчеты (производство)\Плановая Прибыль (Факт себестоимость и расходы).fr3');
  LoadReportFromFile('Плановая Прибыль (Факт себестоимость и расходы и прайс)', ReportPath + '\Отчеты (производство)\Плановая Прибыль (Факт себестоимость и расходы и прайс).fr3');
  LoadReportFromFile('Плановая Прибыль (цена себестоимость и расходы)', ReportPath + '\Отчеты (производство)\Плановая Прибыль (цена себестоимость и расходы).fr3');
  LoadReportFromFile('Плановая Прибыль (цена себестоимость сравнение)', ReportPath + '\Отчеты (производство)\Плановая Прибыль (цена себестоимость сравнение).fr3');
  LoadReportFromFile('Плановая Прибыль (сравнение цен)', ReportPath + '\Отчеты (производство)\Плановая Прибыль (сравнение цен).fr3');
  LoadReportFromFile('Плановая Прибыль (сравнение цен себестоимости)', ReportPath + '\Отчеты (производство)\Плановая Прибыль (сравнение цен себестоимости).fr3');

  LoadReportFromFile('Производство План и Факт расход сырья', ReportPath + '\Отчеты (производство)\Производство План и Факт расход сырья.fr3');
  LoadReportFromFile('Производство План и Факт запас цен', ReportPath + '\Отчеты (производство)\Производство План и Факт запас цен.fr3');

  LoadReportFromFile('Дефростер по партиям', ReportPath + '\Отчеты (производство)\Дефростер по партиям.fr3');
  LoadReportFromFile('Дефростер(итог)', ReportPath + '\Отчеты (производство)\Дефростер(итог).fr3');
  LoadReportFromFile('Отчет по упаковке', ReportPath + '\Отчеты (производство)\Отчет по упаковке.fr3');
  LoadReportFromFile('Отчет по комплектовщикам', ReportPath + '\Отчеты (производство)\Отчет по комплектовщикам.fr3');

  LoadReportFromFile('Акт обвалки', ReportPath + '\Производство\Акт обвалки.fr3');
  LoadReportFromFile('Накладная по обвалке', ReportPath + '\Производство\Накладная по обвалке.fr3');
  LoadReportFromFile('Заявка на производство', ReportPath + '\Производство\Заявка на производство.fr3');
  LoadReportFromFile('Заявка на упаковку', ReportPath + '\Производство\Заявка на упаковку.fr3');
  LoadReportFromFile('Заявка на сырье', ReportPath + '\Производство\Заявка на сырье.fr3');

  // Отчеты Заявки
  LoadReportFromFile('Отчет - заявки (для Упаковки)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (для Упаковки).fr3');
  LoadReportFromFile('Отчет - заявки (по Покупателям-все)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (по Покупателям-все).fr3');
  LoadReportFromFile('Отчет - заявки (на Производство)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (на Производство).fr3');
  LoadReportFromFile('Отчет - заявки (по виду товара)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (по виду товара).fr3');
  LoadReportFromFile('Отчет - заявки (по Маршрутам-детально)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (по Маршрутам-детально).fr3');
  LoadReportFromFile('Отчет - заявки (по Маршрутам-итого)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (по Маршрутам-итого).fr3');
  LoadReportFromFile('Отчет - заявки (кросс)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (кросс).fr3');

  // Печатные формы накладных
  LoadReportFromFile('PrintMovement_TransferDebtOut', ReportPath + '\Товарный Учет\PrintMovement_TransferDebtOut.fr3');
  LoadReportFromFile('PrintMovement_Sale1', ReportPath + '\Товарный Учет\PrintMovement_Sale1.fr3');
  LoadReportFromFile('PrintMovement_Sale2', ReportPath + '\Товарный Учет\PrintMovement_Sale2.fr3');
  LoadReportFromFile('PrintMovement_SaleInvoice', ReportPath + '\Товарный Учет\PrintMovement_SaleInvoice.fr3');
  LoadReportFromFile('PrintMovement_SaleSpec', ReportPath + '\Товарный Учет\PrintMovement_SaleSpec.fr3');

//  LoadReportFromFile('PrintMovement_SendOnPriceIn', ReportPath + '\Товарный Учет\PrintMovement_SendOnPriceIn.fr3');
//  LoadReportFromFile('PrintMovement_SendOnPriceOut', ReportPath + '\Товарный Учет\PrintMovement_SendOnPriceOut.fr3');
  LoadReportFromFile('PrintMovement_SendOnPrice', ReportPath + '\Товарный Учет\PrintMovement_SendOnPrice.fr3');

  LoadReportFromFile('PrintMovement_SalePack', ReportPath + '\Товарный Учет\PrintMovement_SalePack.fr3');

  LoadReportFromFile('PrintMovement_Quality', ReportPath + '\Товарный Учет\PrintMovement_Quality.fr3');

  LoadReportFromFile('PrintMovement_ReturnIn', ReportPath + '\Товарный Учет\PrintMovement_ReturnIn.fr3');
  LoadReportFromFile('PrintMovement_ReturnIn32049199', ReportPath + '\Товарный Учет\PrintMovement_ReturnIn32049199.fr3');
  LoadReportFromFile('PrintMovement_ReturnIn32516492', ReportPath + '\Товарный Учет\PrintMovement_ReturnIn32516492.fr3');
  LoadReportFromFile('PrintMovement_ReturnIn35442481', ReportPath + '\Товарный Учет\PrintMovement_ReturnIn35442481.fr3');
  LoadReportFromFile('PrintMovement_Tax', ReportPath + '\Товарный Учет\PrintMovement_Tax.fr3');
  LoadReportFromFile('PrintMovement_Tax1214', ReportPath + '\Товарный Учет\PrintMovement_Tax1214.fr3');
  LoadReportFromFile('PrintMovement_Tax0115', ReportPath + '\Товарный Учет\PrintMovement_Tax0115.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective', ReportPath + '\Товарный Учет\PrintMovement_TaxCorrective.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective1214', ReportPath + '\Товарный Учет\PrintMovement_TaxCorrective1214.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective0115', ReportPath + '\Товарный Учет\PrintMovement_TaxCorrective0115.fr3');
  LoadReportFromFile('PrintMovement_Bill', ReportPath + '\Товарный Учет\PrintMovement_Bill.fr3');
  LoadReportFromFile('PrintMovement_Bill01074874', ReportPath + '\Товарный Учет\PrintMovement_Bill01074874.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrectiveReestr', ReportPath + '\Товарный Учет\PrintMovement_TaxCorrectiveReestr.fr3');
  LoadReportFromFile('PrintMovement_TTN', ReportPath + '\Товарный Учет\PrintMovement_TTN.fr3');

  LoadReportFromFile('PrintMovement_SalePack21', ReportPath + '\Товарный Учет\PrintMovement_SalePack21.fr3');
  LoadReportFromFile('PrintMovement_SalePack22', ReportPath + '\Товарный Учет\PrintMovement_SalePack22.fr3');

  LoadReportFromFile('PrintMovement_ReturnIn_By_TaxCorrective', ReportPath + '\Товарный Учет\PrintMovement_ReturnIn_By_TaxCorrective.fr3');

  LoadReportFromFile('PrintMovement_OrderExternal', ReportPath + '\Товарный Учет\PrintMovement_OrderExternal.fr3');
  LoadReportFromFile('PrintMovement_Loss', ReportPath + '\Товарный Учет\PrintMovement_Loss.fr3');
  LoadReportFromFile('PrintMovement_Income', ReportPath + '\Товарный Учет\PrintMovement_Income.fr3');
  LoadReportFromFile('PrintMovement_ReturnOut', ReportPath + '\Товарный Учет\PrintMovement_ReturnOut.fr3');
  LoadReportFromFile('PrintMovement_Send', ReportPath + '\Товарный Учет\PrintMovement_Send.fr3');

  LoadReportFromFile('PrintMovement_Inventory', ReportPath + '\Товарный Учет\PrintMovement_Inventory.fr3');
  LoadReportFromFile('PrintMovement_Sale_Order', ReportPath + '\Товарный Учет\PrintMovement_Sale_Order.fr3');
  LoadReportFromFile('PrintMovement_ProductionUnion', ReportPath + '\Товарный Учет\PrintMovement_ProductionUnion.fr3');

  LoadReportFromFile('PrintMovement_PersonalService', ReportPath + '\Персонал\PrintMovement_PersonalService.fr3');



  TStrArrAdd(['35275230','30982361','30487219','37910513','32294926','01074874','32516492','35442481','36387249','32049199', '31929492']);
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
