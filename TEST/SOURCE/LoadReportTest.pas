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
    procedure LoadPromoFormTest;
    procedure LoadWageFormTest;
    procedure LoadSticker;
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

procedure TLoadReportTest.LoadPromoFormTest;
begin
  {
  LoadReportFromFile('Акция', ReportPath + '\Товарный Учет\PrintMovement_Promo.fr3');

  }
  LoadReportFromFile('Планируемые результаты акции', ReportPath + '\Товарный Учет\PrintMovement_Promo_Calc.fr3');
  {
  LoadReportFromFile('Отчет_по_акциям', ReportPath + '\Отчеты (товарные)\Отчет_по_Акциям.fr3');

  LoadReportFromFile('Отчет_по_акциям(для торгового отдела)', ReportPath + '\Отчеты (товарные)\Отчет_по_Акциям(для торгового отдела).fr3');
  LoadReportFromFile('Отчет_по_акциям(для внутренних служб)', ReportPath + '\Отчеты (товарные)\Отчет_по_Акциям(для внутренних служб).fr3');
  exit;
  LoadReportFromFile('Отчет Результаты ценовых акций', ReportPath + '\Отчеты (товарные)\Отчет Результаты ценовых акций.fr3');
  }
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
  {
  LoadReportFromFile('Отчет Затраты транспорта (реестр)', ReportPath + '\Транспорт\Отчет Затраты транспорта (реестр).fr3');
  exit;

  LoadReportFromFile('Отчет по ГСМ', ReportPath + '\Транспорт\Отчет по ГСМ.fr3');
  exit;
 }
  LoadReportFromFile('Путевой лист (тип. форма 2)', ReportPath + '\Транспорт\Путевой лист (тип. форма 2).fr3');
  exit;

  LoadReportFromFile('Путевой лист - Сбыт', ReportPath + '\Транспорт\Путевой лист - Сбыт.fr3');
  LoadReportFromFile('Ведомость расхода топлива', ReportPath + '\Транспорт\Ведомость расхода топлива.fr3');
  LoadReportFromFile('Реестр путевых и наемного транспорта', ReportPath + '\Транспорт\Реестр путевых и наемного транспорта.fr3');
end;

procedure TLoadReportTest.LoadWageFormTest;
begin
  LoadReportFromFile('Ведомость_по_зарплате_1', ReportPath + '\Персонал\Ведомость_по_зарплате_1.fr3');
  LoadReportFromFile('Ведомость_по_зарплате_2', ReportPath + '\Персонал\Ведомость_по_зарплате_2.fr3');
end;

procedure TLoadReportTest.LoadSticker;
begin
  // 1
  LoadReportFromFile('ШАБЛОН + тм АЛАН - Український.Sticker',          ReportPath + '\Этикетки\ШАБЛОН + тм АЛАН - Український.fr3');
  // 2
  LoadReportFromFile('ШАБЛОН + тм СПЕЦ ЦЕХ - Український.Sticker',      ReportPath + '\Этикетки\ШАБЛОН + тм СПЕЦ ЦЕХ - Український.fr3');
  // 3
  LoadReportFromFile('ШАБЛОН + тм ВАРТО (Варус) - Український.Sticker', ReportPath + '\Этикетки\ШАБЛОН + тм ВАРТО (Варус) - Український.fr3');
  // 4
  LoadReportFromFile('ШАБЛОН + тм НАШИ КОВБАСИ - Український.Sticker',  ReportPath + '\Этикетки\ШАБЛОН + тм НАШИ КОВБАСИ - Український.fr3');
  // 5+
  // 6+
  LoadReportFromFile('ШАБЛОН + тм Фітнес Формат - Український.Sticker',  ReportPath + '\Этикетки\ШАБЛОН + тм Фітнес Формат - Український.fr3');
  // 7+
  LoadReportFromFile('ШАБЛОН + тм Повна Чаша (Фоззи) - Український.Sticker',  ReportPath + '\Этикетки\ШАБЛОН + тм Повна Чаша (Фоззи) - Український.fr3');
  // 8+
  LoadReportFromFile('ШАБЛОН + тм Премія (Фоззи) - Український.Sticker',  ReportPath + '\Этикетки\ШАБЛОН + тм Премія (Фоззи) - Український.fr3');
  // 9+
  LoadReportFromFile('ШАБЛОН + тм Ашан - Український.Sticker',  ReportPath + '\Этикетки\ШАБЛОН + тм Ашан - Український.fr3');
  // 10+
  LoadReportFromFile('ШАБЛОН + ТМ Хіт продукт (Вел.Кишеня) - Український.Sticker',  ReportPath + '\Этикетки\ШАБЛОН + ТМ Хіт продукт (Вел.Кишеня) - Український.fr3');

end;


procedure TLoadReportTest.LoadAllReportFormTest;
var
 i : integer;
begin
 { LoadReportFromFile('PrintMovement_Sale32437180', ReportPath + '\Товарный Учет\PrintMovement_Sale32437180.fr3');
   exit;
   LoadReportFromFile('Печать документов начислений по бонусам', ReportPath + '\Отчеты (финансы)\Печать документов начислений по бонусам.fr3');
  exit;
  LoadReportFromFile('Проверка начислений по бонусам (итоги)', ReportPath + '\Отчеты (финансы)\Проверка начислений по бонусам (итоги).fr3');
  //exit;

  LoadReportFromFile('Отчет внешние продажи', ReportPath + '\Отчеты (товарные)\Отчет внешние продажи.fr3');
  //exit;

  LoadReportFromFile('Проверка начислений по бонусам для подписи', ReportPath + '\Отчеты (финансы)\Проверка начислений по бонусам для подписи.fr3');
  //exit;

  //LoadReportFromFile('Проверка начислений по бонусам поставщиков', ReportPath + '\Отчеты (финансы)\Проверка начислений по бонусам поставщиков.fr3');
  //exit;

  LoadReportFromFile('Проверка начислений по бонусам', ReportPath + '\Отчеты (финансы)\Проверка начислений по бонусам.fr3');
  exit;

  LoadReportFromFile('Обороты по кассе и счету (Прямой метод)', ReportPath + '\Отчеты (финансы)\Обороты по кассе и счету (Прямой метод).fr3');
  exit;

  LoadReportFromFile('PrintMovement_SendAsset', ReportPath + '\Товарный Учет\PrintMovement_SendAsset.fr3');
  exit;

  LoadReportFromFile('Print_Object_BarCodeBox', ReportPath + '\Товарный Учет\Print_Object_BarCodeBox.fr3');
  exit;

  LoadReportFromFile('PrintMovement_WeighingProductionBarCode', ReportPath + '\Товарный Учет\PrintMovement_WeighingProductionBarCode.fr3');
  exit;

  LoadReportFromFile('PrintMovement_WeighingProduction', ReportPath + '\Товарный Учет\PrintMovement_WeighingProduction.fr3');
  LoadReportFromFile('PrintMovement_WeighingProductionWmsSticker', ReportPath + '\Товарный Учет\PrintMovement_WeighingProductionWmsSticker.fr3');
  exit;

  LoadReportFromFile('Обороты по подотчету', ReportPath + '\Отчеты (финансы)\Обороты по подотчету.fr3');
  exit;

  LoadReportFromFile('Начисления услуг(итоги)', ReportPath + '\Финансовый Учет\Начисления услуг(итоги).fr3');
  LoadReportFromFile('Начисления услуг', ReportPath + '\Финансовый Учет\Начисления услуг.fr3');
  exit;
  LoadReportFromFile('По кассе (по услугам)', ReportPath + '\Финансовый Учет\По кассе (по услугам).fr3');
  exit;

  LoadReportFromFile('PrintMovement_MemberHoliday', ReportPath + '\Персонал\PrintMovement_MemberHoliday.fr3');
  exit;
  LoadReportFromFile('По кассе (с комментариями)', ReportPath + '\Финансовый Учет\По кассе (с комментариями).fr3');
  exit;

  LoadReportFromFile('PrintMovementGoodsBarCode', ReportPath + '\Товарный Учет\PrintMovementGoodsBarCode.fr3');

  LoadReportFromFile('Пароли подтверждения в Scale', ReportPath + '\Справочники\Пароли подтверждения в Scale.fr3');
  exit;

  LoadReportFromFile('PrintMovement_SaleJuridicalInvoice', ReportPath + '\Товарный Учет\PrintMovement_SaleJuridicalInvoice.fr3');
  exit;

  LoadReportFromFile('PrintMovement_IncomeSticker', ReportPath + '\Товарный Учет\PrintMovement_IncomeSticker.fr3');
  exit;

  LoadReportFromFile('Отчет движение по товару (партии ТМЦ+МНМА)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (партии ТМЦ+МНМА).fr3');
  exit;

  LoadReportFromFile('Отчет Заявка Отгрузка (меньше заявки)', ReportPath + '\Отчеты (товарные)\Отчет Заявка Отгрузка (меньше заявки).fr3');
  exit;

  LoadReportFromFile('Отчет движение по ОС', ReportPath + '\Отчеты (товарные)\Отчет движение по ОС.fr3');
  exit;

  LoadReportFromFile('Отчет движение по товару (МО)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (МО).fr3');
  LoadReportFromFile('Отчет движение по товару (Итого)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (Итого).fr3');
  LoadReportFromFile('Отчет движение по товару (МО)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (МО).fr3');
  LoadReportFromFile('Отчет движение по товару (Авто)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (Авто).fr3');

  LoadReportFromFile('Отчет движение по товару (по подразделениям)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (по подразделениям).fr3');
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

  LoadReportFromFile('Обороты по контрагентам - поставщики(статьи)', ReportPath + '\Отчеты (финансы)\Обороты по контрагентам - поставщики(статьи).fr3');
  exit;
  LoadReportFromFile('Aкт сверки по контрагенту (тара)', ReportPath + '\Отчеты (товарные)\Aкт сверки по контрагенту (тара).fr3');
  exit;

  LoadReportFromFile('Акт сверки (бухгалтерский)', ReportPath + '\Отчеты (финансы)\Акт сверки (бухгалтерский).fr3');
  exit;
  LoadReportFromFile('Акт сверки (в валюте)', ReportPath + '\Отчеты (финансы)\Акт сверки (в валюте).fr3');
  LoadReportFromFile('Отчет Итог по покупателю (Акт сверки)', ReportPath + '\Отчеты (финансы)\Отчет Итог по покупателю (Акт сверки).fr3');
  exit;

  LoadReportFromFile('Обороты из акта сверки', ReportPath + '\Отчеты (финансы)\Обороты из акта сверки.fr3');
  LoadReportFromFile('Обороты по расчетному счету', ReportPath + '\Отчеты (финансы)\Обороты по расчетному счету.fr3');

  LoadReportFromFile('Обороты по кассе', ReportPath + '\Отчеты (финансы)\Обороты по кассе.fr3');
  exit;

  LoadReportFromFile('Обороты по кассе (по элементам)', ReportPath + '\Отчеты (финансы)\Обороты по кассе (по элементам).fr3');

  LoadReportFromFile('Обороты по кассе (с комментариями)', ReportPath + '\Отчеты (финансы)\Обороты по кассе (с комментариями).fr3');

  LoadReportFromFile('Обороты по кассе (по датам)', ReportPath + '\Отчеты (финансы)\Обороты по кассе (по датам).fr3');
   exit;

  LoadReportFromFile('Обороты по учредителям', ReportPath + '\Отчеты (финансы)\Обороты по учредителям.fr3');
  LoadReportFromFile('Обороты по учредителям - детальный', ReportPath + '\Отчеты (финансы)\Обороты по учредителям - детальный.fr3');

  LoadReportFromFile('Отчет по счетам', ReportPath + '\Отчеты (финансы)\Отчет по счетам.fr3');
  exit;

  LoadReportFromFile('PrintObject_ReportCollation', ReportPath + '\Отчеты (финансы)\PrintObject_ReportCollation.fr3');

  //  Финансовый учет
  LoadReportFromFile('Платежка Банк', ReportPath + '\Финансовый Учет\Платежка Банк.fr3');

  LoadReportFromFile('PrintMovement_Invoice', ReportPath + '\Финансовый Учет\PrintMovement_Invoice.fr3');

  LoadReportFromFile('Продажа и возврат', ReportPath + '\Отчеты (товарные)\Продажа и возврат.fr3');
  LoadReportFromFile('Продажа и возврат по юрлицам', ReportPath + '\Отчеты (товарные)\Продажа и возврат по юрлицам.fr3');

  LoadReportFromFile('Отчет по группе статистики', ReportPath + '\Отчеты (товарные)\Отчет по группе статистики.fr3');
  exit;

  LoadReportFromFile('Продажа и возврат контрагенты', ReportPath + '\Отчеты (товарные)\Продажа и возврат контрагенты.fr3');

  LoadReportFromFile('Отчет движение по товару (для всех)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (для всех).fr3');
  LoadReportFromFile('Отчет движение по товару (склад ГП)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (склад ГП).fr3');
  LoadReportFromFile('Отчет движение по товару (остаток)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (остаток).fr3');
  LoadReportFromFile('Отчет по товару по накладным', ReportPath + '\Отчеты (товарные)\Отчет по товару по накладным.fr3');
  LoadReportFromFile('Отчет движение по ОС', ReportPath + '\Отчеты (товарные)\Отчет движение по ОС.fr3');
  LoadReportFromFile('Отчет движение по товару (МО)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (МО).fr3');
  LoadReportFromFile('Отчет движение по товару (Итого)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (Итого).fr3');

  LoadReportFromFile('Отчет движение по товару (цех упаковки)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (цех упаковки).fr3');
  LoadReportFromFile('Отчет движение по товару (цех)', ReportPath + '\Отчеты (товарные)\Отчет движение по товару (цех).fr3');

  LoadReportFromFile('Отчет по остаткам товара', ReportPath + '\Отчеты (товарные)\Отчет по остаткам товара.fr3');
  LoadReportFromFile('Отчет по остаткам товара (движение)', ReportPath + '\Отчеты (товарные)\Отчет по остаткам товара (движение).fr3');

  LoadReportFromFile('Отчет по остаткам товара (движение по батонам)', ReportPath + '\Отчеты (товарные)\Отчет по остаткам товара (движение по батонам).fr3');
  exit;
  LoadReportFromFile('Отчет по остаткам товара (текущий)', ReportPath + '\Отчеты (товарные)\Отчет по остаткам товара (текущий).fr3');
  LoadReportFromFile('Отчет по остаткам товара (выход ГП)', ReportPath + '\Отчеты (товарные)\Отчет по остаткам товара (выход ГП).fr3');
  LoadReportFromFile('Отчет по остаткам товара (процент списания)', ReportPath + '\Отчеты (товарные)\Отчет по остаткам товара (процент списания).fr3');
  LoadReportFromFile('Отчет по остаткам товара (штрихкод)', ReportPath + '\Отчеты (товарные)\Отчет по остаткам товара (штрихкод).fr3');

  LoadReportFromFile('Отчет по остаткам товара (по МО или Авто)', ReportPath + '\Отчеты (товарные)\Отчет по остаткам товара (по МО или Авто).fr3');
  exit;

  LoadReportFromFile('Отчет по товару (продажа по покупателям)', ReportPath + '\Отчеты (Отчеты (товарные)\Отчет по товару (продажа по покупателям).fr3');

  LoadReportFromFile('Отчет по товару (приход от поставщика)', ReportPath + '\Отчеты (товарные)\Отчет по товару (приход от поставщика).fr3');
  exit;

  LoadReportFromFile('Отчет по товару (внутренний)', ReportPath + '\Отчеты (товарные)\Отчет по товару (внутренний).fr3');

  LoadReportFromFile('Отчет по товару (статьи списания)', ReportPath + '\Отчеты (товарные)\Отчет по товару (статьи списания).fr3');

  LoadReportFromFile('Отчет по товару (статьи списания)_Прайс', ReportPath + '\Отчеты (товарные)\Отчет по товару (статьи списания)_Прайс.fr3');
  exit;

  LoadReportFromFile('Отчет по товару (списание группа товара)', ReportPath + '\Отчеты (товарные)\Отчет по товару (списание группа товара).fr3');
  exit;
  LoadReportFromFile('Отчет по товару (примечание)', ReportPath + '\Отчеты (товарные)\Отчет по товару (примечание).fr3');
  exit;

  LoadReportFromFile('Отчет по просрочке', ReportPath + '\Отчеты (Отчеты (товарные)\Отчет по просрочке.fr3');

  LoadReportFromFile('Отчет По Отгрузкам', ReportPath + '\Отчеты (товарные)\Отчет По Отгрузкам.fr3');

  // Отчеты УП
  LoadReportFromFile('Отчет УП ОПиУ', ReportPath + '\Отчеты (УП)\Отчет УП ОПиУ.fr3');

  LoadReportFromFile('Отчет УП ОПиУ (филиалы)', ReportPath + '\Отчеты (УП)\Отчет УП ОПиУ (филиалы).fr3');
  exit;

  LoadReportFromFile('Отчет УП Баланс', ReportPath + '\Отчеты (УП)\Отчет УП Баланс.fr3');

  LoadReportFromFile('Отчет УП Баланс (Дебет Кредит)', ReportPath + '\Отчеты (УП)\Отчет УП Баланс (Дебет Кредит).fr3');
  exit;

  LoadReportFromFile('Отчет УП Баланс (Дебет Кредит) свернуто', ReportPath + '\Отчеты (УП)\Отчет УП Баланс (Дебет Кредит) свернуто.fr3');
  exit;

  // Отчеты производство
  LoadReportFromFile('Отчет_Приход_Расход_производство_разделение', ReportPath + '\Отчеты (производство)\Отчет_Приход_Расход_производство_разделение.fr3');
    exit;

  LoadReportFromFile('Отчет_Приход_Расход_производство_разделение_Итог', ReportPath + '\Отчеты (производство)\Отчет_Приход_Расход_производство_разделение_Итог.fr3');
   exit;

  LoadReportFromFile('Производство и процент выхода (итоги)', ReportPath + '\Отчеты (производство)\Производство и процент выхода (итоги).fr3');
  LoadReportFromFile('Производство и процент выхода (Анализ)', ReportPath + '\Отчеты (производство)\Производство и процент выхода (Анализ).fr3');
  LoadReportFromFile('Приход на склад и процент потерь (итоги)', ReportPath + '\Отчеты (производство)\Приход на склад и процент потерь (итоги).fr3');

  LoadReportFromFile('Плановая Прибыль', ReportPath + '\Отчеты (производство)\Плановая Прибыль.fr3');
  LoadReportFromFile('Плановая Прибыль (Факт)', ReportPath + '\Отчеты (производство)\Плановая Прибыль (Факт).fr3');
  LoadReportFromFile('Плановая Прибыль (Факт себестоимость и расходы)', ReportPath + '\Отчеты (производство)\Плановая Прибыль (Факт себестоимость и расходы).fr3');

  LoadReportFromFile('Плановая Прибыль (Факт себестоимость и расходы) по дате покуп', ReportPath + '\Отчеты (производство)\Плановая Прибыль (Факт себестоимость и расходы) по дате покуп.fr3');
   exit;
  LoadReportFromFile('Плановая Прибыль (Факт себестоимость и расходы и прайс)', ReportPath + '\Отчеты (производство)\Плановая Прибыль (Факт себестоимость и расходы и прайс).fr3');
  LoadReportFromFile('Плановая Прибыль (цена себестоимость и расходы)', ReportPath + '\Отчеты (производство)\Плановая Прибыль (цена себестоимость и расходы).fr3');
  LoadReportFromFile('Плановая Прибыль (цена себестоимость сравнение)', ReportPath + '\Отчеты (производство)\Плановая Прибыль (цена себестоимость сравнение).fr3');
  LoadReportFromFile('Плановая Прибыль (сравнение цен)', ReportPath + '\Отчеты (производство)\Плановая Прибыль (сравнение цен).fr3');
  LoadReportFromFile('Плановая Прибыль (сравнение цен себестоимости)', ReportPath + '\Отчеты (производство)\Плановая Прибыль (сравнение цен себестоимости).fr3');

  LoadReportFromFile('Плановая Прибыль (чистая прибыль)', ReportPath + '\Отчеты (производство)\Плановая Прибыль (чистая прибыль).fr3');
  exit;

  LoadReportFromFile('Производство Факт расход сырья', ReportPath + '\Отчеты (производство)\Производство Факт расход сырья.fr3');

  LoadReportFromFile('Производство План и Факт расход сырья', ReportPath + '\Отчеты (производство)\Производство План и Факт расход сырья.fr3');
  exit;

  LoadReportFromFile('Производство План и Факт запас цен', ReportPath + '\Отчеты (производство)\Производство План и Факт запас цен.fr3');

  LoadReportFromFile('Отчет по остаткам для снабжения', ReportPath + '\Отчеты (производство)\Отчет по остаткам для снабжения.fr3');
  LoadReportFromFile('Отчет по остаткам для снабжения(поставщик)', ReportPath + '\Отчеты (производство)\Отчет по остаткам для снабжения(поставщик).fr3');
  LoadReportFromFile('Отчет по движению по дням недели', ReportPath + '\Отчеты (производство)\Отчет по движению по дням недели.fr3');

  LoadReportFromFile('Отчет по заявкам по сырью_перемещение (Олап)', ReportPath + '\Отчеты (производство)\Отчет по заявкам по сырью_перемещение (Олап).fr3');
  LoadReportFromFile('Отчет по заявкам по сырью (Олап)', ReportPath + '\Отчеты (производство)\Отчет по заявкам по сырью (Олап).fr3');
  exit;

  LoadReportFromFile('Дефростер по партиям', ReportPath + '\Отчеты (производство)\Дефростер по партиям.fr3');
  LoadReportFromFile('Дефростер(итог)', ReportPath + '\Отчеты (производство)\Дефростер(итог).fr3');
  exit;

  LoadReportFromFile('Отчет по упаковке', ReportPath + '\Отчеты (производство)\Отчет по упаковке.fr3');
  exit;

  LoadReportFromFile('Отчет по комплектовщикам', ReportPath + '\Отчеты (производство)\Отчет по комплектовщикам.fr3');

  LoadReportFromFile('Рецептуры с разворотом всех составляющих по ценам_1', ReportPath + '\Отчеты (производство)\Рецептуры с разворотом всех составляющих по ценам_1.fr3');
  exit;

  LoadReportFromFile('Акт обвалки', ReportPath + '\Производство\Акт обвалки.fr3');


  LoadReportFromFile('Накладная по обвалке', ReportPath + '\Производство\Накладная по обвалке.fr3');
  exit;
  LoadReportFromFile('Накладная по взвешиванию куттера', ReportPath + '\Производство\Накладная по взвешиванию куттера.fr3');

   LoadReportFromFile('Производство (по дням для сырья)', ReportPath + '\Производство\Производство (по дням для сырья).fr3');
   //LoadReportFromFile('Производство (по дням для специй)', ReportPath + '\Производство\Производство (по дням для специй).fr3');
   //LoadReportFromFile('Производство (по дням для оболочки)', ReportPath + '\Производство\Производство (по дням для оболочки).fr3');
    exit;

  LoadReportFromFile('Заявка на производство', ReportPath + '\Производство\Заявка на производство.fr3');
   exit;

  LoadReportFromFile('Заявка на упаковку', ReportPath + '\Производство\Заявка на упаковку.fr3');

  LoadReportFromFile('Заявка на сырье', ReportPath + '\Производство\Заявка на сырье.fr3');
  exit;

  LoadReportFromFile('Заявка на упаковку (остатки)', ReportPath + '\Производство\Заявка на упаковку (остатки).fr3');

  LoadReportFromFile('Заявка на упаковку (меньше заказа)', ReportPath + '\Производство\Заявка на упаковку (меньше заказа).fr3');

  LoadReportFromFile('Заявка на производство (скан)', ReportPath + '\Производство\Заявка на производство (скан).fr3');
  LoadReportFromFile('Заявка на упаковку (скан)', ReportPath + '\Производство\Заявка на упаковку (скан).fr3');

  LoadReportFromFile('Заявка на сырье (скан)', ReportPath + '\Производство\Заявка на сырье (скан).fr3');
   exit;

  LoadReportFromFile('Заявка на упаковку (пленка)', ReportPath + '\Производство\Заявка на упаковку (пленка).fr3');
  exit;
  }
  // Отчеты Заявки
  LoadReportFromFile('Отчет - заявки (для Упаковки)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (для Упаковки).fr3');
  exit;
  {
  LoadReportFromFile('Отчет - заявки (по Покупателям-все)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (по Покупателям-все).fr3');
  LoadReportFromFile('Отчет - заявки (на Производство)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (на Производство).fr3');
  exit;
  LoadReportFromFile('Отчет - заявки (по виду товара)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (по виду товара).fr3');
  LoadReportFromFile('Отчет - заявки (по виду и группе товара)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (по виду и группе товара).fr3');
  LoadReportFromFile('Отчет - заявки (по Маршрутам-детально)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (по Маршрутам-детально).fr3');
  LoadReportFromFile('Отчет - заявки (по Маршрутам-итого)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (по Маршрутам-итого).fr3');
  LoadReportFromFile('Отчет - заявки (кросс)', ReportPath + '\Отчеты (товарные)\Отчет - заявки (кросс).fr3');
  exit;

  // Печатные формы накладных

   LoadReportFromFile('PrintMovement_ReestrIncome', ReportPath + '\Товарный Учет\PrintMovement_ReestrIncome.fr3');
   LoadReportFromFile('PrintMovement_ReestrIncomePeriod', ReportPath + '\Товарный Учет\PrintMovement_ReestrIncomePeriod.fr3');
   LoadReportFromFile('PrintMovement_ReestrIncomeStartPeriod', ReportPath + '\Товарный Учет\PrintMovement_ReestrIncomeStartPeriod.fr3');
   LoadReportFromFile('PrintMovement_ReestrIncomeDriver', ReportPath + '\Товарный Учет\PrintMovement_ReestrIncomeDriver.fr3');
   exit;

   LoadReportFromFile('PrintMovement_ReestrReturn', ReportPath + '\Товарный Учет\PrintMovement_ReestrReturn.fr3');
   LoadReportFromFile('PrintMovement_ReestrReturnPeriod', ReportPath + '\Товарный Учет\PrintMovement_ReestrReturnPeriod.fr3');
   LoadReportFromFile('PrintMovement_ReestrReturnStartPeriod', ReportPath + '\Товарный Учет\PrintMovement_ReestrReturnStartPeriod.fr3');

   LoadReportFromFile('PrintMovement_ReestrTransportGoods', ReportPath + '\Товарный Учет\PrintMovement_ReestrTransportGoods.fr3');
   LoadReportFromFile('PrintMovement_ReestrTransportGoodsStartPeriod', ReportPath + '\Товарный Учет\PrintMovement_ReestrTransportGoodsStartPeriod.fr3');
   LoadReportFromFile('PrintMovement_ReestrTransportGoodsPeriod', ReportPath + '\Товарный Учет\PrintMovement_ReestrTransportGoodsPeriod.fr3');

   LoadReportFromFile('PrintMovement_Reestr', ReportPath + '\Товарный Учет\PrintMovement_Reestr.fr3');
   LoadReportFromFile('PrintMovement_ReestrDriver', ReportPath + '\Товарный Учет\PrintMovement_ReestrDriver.fr3');

   LoadReportFromFile('PrintMovement_ReestrPeriod', ReportPath + '\Товарный Учет\PrintMovement_ReestrPeriod.fr3');
   LoadReportFromFile('PrintMovement_ReestrStartPeriod', ReportPath + '\Товарный Учет\PrintMovement_ReestrStartPeriod.fr3');
   exit;

  LoadReportFromFile('PrintMovement_TransferDebtOut', ReportPath + '\Товарный Учет\PrintMovement_TransferDebtOut.fr3');
  LoadReportFromFile('PrintMovement_Sale1', ReportPath + '\Товарный Учет\PrintMovement_Sale1.fr3');
  LoadReportFromFile('PrintMovement_Sale2', ReportPath + '\Товарный Учет\PrintMovement_Sale2.fr3');
  LoadReportFromFile('PrintMovement_Sale2DiscountPrice', ReportPath + '\Товарный Учет\PrintMovement_Sale2DiscountPrice.fr3');
  LoadReportFromFile('PrintMovement_Sale2PriceWithVAT', ReportPath + '\Товарный Учет\PrintMovement_Sale2PriceWithVAT.fr3');
  LoadReportFromFile('PrintMovement_SalePackWeight', ReportPath + '\Товарный Учет\PrintMovement_SalePackWeight.fr3');
  LoadReportFromFile('PrintMovement_SalePackWeight_Fozzy', ReportPath + '\Товарный Учет\PrintMovement_SalePackWeight_Fozzy.fr3');

  LoadReportFromFile('PrintMovement_Sale2_3683763', ReportPath + '\Товарный Учет\PrintMovement_Sale2_3683763.fr3');
  exit;

  LoadReportFromFile('PrintMovement_SaleInvoice', ReportPath + '\Товарный Учет\PrintMovement_SaleInvoice.fr3');
  LoadReportFromFile('PrintMovement_SaleSpec', ReportPath + '\Товарный Учет\PrintMovement_SaleSpec.fr3');

  LoadReportFromFile('PrintMovement_SaleTotal', ReportPath + '\Товарный Учет\PrintMovement_SaleTotal.fr3');
//  LoadReportFromFile('PrintMovement_SendOnPriceIn', ReportPath + '\Товарный Учет\PrintMovement_SendOnPriceIn.fr3');
//  LoadReportFromFile('PrintMovement_SendOnPriceOut', ReportPath + '\Товарный Учет\PrintMovement_SendOnPriceOut.fr3');

  LoadReportFromFile('PrintMovement_SendOnPrice', ReportPath + '\Товарный Учет\PrintMovement_SendOnPrice.fr3');
  exit;

  LoadReportFromFile('PrintMovement_SalePack', ReportPath + '\Товарный Учет\PrintMovement_SalePack.fr3');

  LoadReportFromFile('PrintMovement_Quality', ReportPath + '\Товарный Учет\PrintMovement_Quality.fr3');
  exit;

  LoadReportFromFile('PrintMovement_Quality32049199', ReportPath + '\Товарный Учет\PrintMovement_Quality32049199.fr3');

  LoadReportFromFile('PrintMovement_Quality32294926', ReportPath + '\Товарный Учет\PrintMovement_Quality32294926.fr3');
  exit;

  LoadReportFromFile('PrintMovement_ReturnInAkt', ReportPath + '\Товарный Учет\PrintMovement_ReturnInAkt.fr3');
  exit;

  LoadReportFromFile('PrintMovement_ReturnIn', ReportPath + '\Товарный Учет\PrintMovement_ReturnIn.fr3');
  LoadReportFromFile('PrintMovement_ReturnIn32049199', ReportPath + '\Товарный Учет\PrintMovement_ReturnIn32049199.fr3');
  LoadReportFromFile('PrintMovement_ReturnIn32516492', ReportPath + '\Товарный Учет\PrintMovement_ReturnIn32516492.fr3');
  LoadReportFromFile('PrintMovement_ReturnIn35442481', ReportPath + '\Товарный Учет\PrintMovement_ReturnIn35442481.fr3');
  LoadReportFromFile('PrintMovement_ReturnInDay', ReportPath + '\Товарный Учет\PrintMovement_ReturnInDay.fr3');
  LoadReportFromFile('PrintMovement_PriceCorrective35442481', ReportPath + '\Товарный Учет\PrintMovement_PriceCorrective35442481.fr3');
  LoadReportFromFile('PrintMovement_PriceCorrective32049199', ReportPath + '\Товарный Учет\PrintMovement_PriceCorrective32049199.fr3');
  LoadReportFromFile('PrintMovement_Tax', ReportPath + '\Товарный Учет\PrintMovement_Tax.fr3');
  LoadReportFromFile('PrintMovement_Tax1214', ReportPath + '\Товарный Учет\PrintMovement_Tax1214.fr3');
  LoadReportFromFile('PrintMovement_Tax0115', ReportPath + '\Товарный Учет\PrintMovement_Tax0115.fr3');
  LoadReportFromFile('PrintMovement_Tax0416', ReportPath + '\Товарный Учет\PrintMovement_Tax0416.fr3');

  LoadReportFromFile('PrintMovement_Tax0317', ReportPath + '\Товарный Учет\PrintMovement_Tax0317.fr3');
  LoadReportFromFile('PrintMovement_Tax1218', ReportPath + '\Товарный Учет\PrintMovement_Tax1218.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective1218', ReportPath + '\Товарный Учет\PrintMovement_TaxCorrective1218.fr3');


  LoadReportFromFile('PrintMovement_Tax0321', ReportPath + '\Товарный Учет\PrintMovement_Tax0321.fr3');
  exit;

  LoadReportFromFile('PrintMovement_TaxCorrective', ReportPath + '\Товарный Учет\PrintMovement_TaxCorrective.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective1214', ReportPath + '\Товарный Учет\PrintMovement_TaxCorrective1214.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective0115', ReportPath + '\Товарный Учет\PrintMovement_TaxCorrective0115.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective0416', ReportPath + '\Товарный Учет\PrintMovement_TaxCorrective0416.fr3');

  LoadReportFromFile('PrintMovement_TaxCorrective0317', ReportPath + '\Товарный Учет\PrintMovement_TaxCorrective0317.fr3');

  LoadReportFromFile('PrintMovement_Bill', ReportPath + '\Товарный Учет\PrintMovement_Bill.fr3');

  LoadReportFromFile('PrintMovement_TaxCorrective0321', ReportPath + '\Товарный Учет\PrintMovement_TaxCorrective0321.fr3');
    exit;

  LoadReportFromFile('PrintMovement_Bill01074874', ReportPath + '\Товарный Учет\PrintMovement_Bill01074874.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrectiveReestr', ReportPath + '\Товарный Учет\PrintMovement_TaxCorrectiveReestr.fr3');


  LoadReportFromFile('PrintMovement_TTN', ReportPath + '\Товарный Учет\PrintMovement_TTN.fr3');
  exit;

  LoadReportFromFile('PrintMovement_SalePackGross', ReportPath + '\Товарный Учет\PrintMovement_SalePackGross.fr3');
  exit;

  LoadReportFromFile('PrintMovement_SalePack21', ReportPath + '\Товарный Учет\PrintMovement_SalePack21.fr3');
  LoadReportFromFile('PrintMovement_Sale32294926', ReportPath + '\Товарный Учет\PrintMovement_Sale32294926.fr3');

  LoadReportFromFile('PrintMovement_Sale32490244', ReportPath + '\Товарный Учет\PrintMovement_Sale32490244.fr3');
   exit;

  LoadReportFromFile('PrintMovement_SalePack22', ReportPath + '\Товарный Учет\PrintMovement_SalePack22.fr3');

  LoadReportFromFile('PrintMovement_ReturnIn_By_TaxCorrective', ReportPath + '\Товарный Учет\PrintMovement_ReturnIn_By_TaxCorrective.fr3');

  LoadReportFromFile('PrintMovement_OrderIncomeSnab', ReportPath + '\Товарный Учет\PrintMovement_OrderIncomeSnab.fr3');
  exit;

  LoadReportFromFile('PrintMovement_OrderExternal', ReportPath + '\Товарный Учет\PrintMovement_OrderExternal.fr3');
  //exit;

  LoadReportFromFile('PrintMovement_Loss', ReportPath + '\Товарный Учет\PrintMovement_Loss.fr3');
  exit;
  LoadReportFromFile('PrintMovement_Income', ReportPath + '\Товарный Учет\PrintMovement_Income.fr3');
  LoadReportFromFile('PrintMovement_IncomeAsset', ReportPath + '\Товарный Учет\PrintMovement_IncomeAsset.fr3');
  LoadReportFromFile('PrintMovement_IncomeFuel', ReportPath + '\Товарный Учет\PrintMovement_IncomeFuel.fr3');

  LoadReportFromFile('PrintMovement_ReturnOut', ReportPath + '\Товарный Учет\PrintMovement_ReturnOut.fr3');

  LoadReportFromFile('PrintMovement_Send', ReportPath + '\Товарный Учет\PrintMovement_Send.fr3');
  exit;

  LoadReportFromFile('PrintMovement_Inventory', ReportPath + '\Товарный Учет\PrintMovement_Inventory.fr3');

  LoadReportFromFile('PrintMovement_Sale_Order', ReportPath + '\Товарный Учет\PrintMovement_Sale_Order.fr3');
  exit;

  LoadReportFromFile('PrintMovement_ProductionUnion', ReportPath + '\Товарный Учет\PrintMovement_ProductionUnion.fr3');
  exit;

  LoadReportFromFile('PrintMovement_PersonalService', ReportPath + '\Персонал\PrintMovement_PersonalService.fr3');

  LoadReportFromFile('PrintMovement_PersonalServiceDetail', ReportPath + '\Персонал\PrintMovement_PersonalServiceDetail.fr3');
  exit;

  LoadReportFromFile('Приложение7', ReportPath + '\Отчеты(филиалы)\Приложение7.fr3');

  LoadReportFromFile('Приложение7 Новое', ReportPath + '\Отчеты(филиалы)\Приложение7 Новое.fr3');

  LoadReportFromFile('Приложение1', ReportPath + '\Отчеты(филиалы)\Приложение1.fr3');
  LoadReportFromFile('Приложение1_test', ReportPath + '\Отчеты(филиалы)\Приложение1_test.fr3');
  exit;

  LoadReportFromFile('Касса филиалы', ReportPath + '\Отчеты(филиалы)\Касса Филиалы.fr3');
  exit;

  LoadReportFromFile('PrintObjectHistory_PriceListItem', ReportPath + '\Справочники\PrintObjectHistory_PriceListItem.fr3');

  LoadReportFromFile('PrintMovement_SaleJuridicalInvoice', ReportPath + '\Товарный Учет\PrintMovement_SaleJuridicalInvoice.fr3');

  TStrArrAdd(['35275230','30982361','30487219','37910513','32294926','01074874','32516492','35442481','36387249'
             ,'32049199', '31929492', '22447463', '36003603', '39118745', '2902403938', '32294926']);
  for i := Low(OKPO) to High(OKPO) do
    LoadReportFromFile('PrintMovement_Sale' + OKPO[i], ReportPath + '\Товарный Учет\PrintMovement_Sale' + OKPO[i] + '.fr3');
  exit;

  LoadReportFromFile('PrintMovement_Transport', ReportPath + '\Товарный Учет\PrintMovement_Transport.fr3');

  TStrArrAdd(['32516492','39135315','32049199','36003603','36387249', '36387233', '38916558' ]);
  for i := Low(OKPO) to High(OKPO) do
    LoadReportFromFile('PrintMovement_Transport' + OKPO[i], ReportPath + '\Товарный Учет\PrintMovement_Transport' + OKPO[i] + '.fr3');

  TStrArrAdd(['01074874','31929492']);
  for i := Low(OKPO) to High(OKPO) do
    LoadReportFromFile('PrintMovement_Sale' + OKPO[i], ReportPath + '\Товарный Учет\PrintMovement_Sale' + OKPO[i] + '.fr3');
}

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
