unit LoadBoatReportTest;

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
  end;

implementation

uses Authentication, FormStorage, CommonData, Storage, UtilConst;

const
  ReportPath = '..\Reports\Boat';

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

procedure TLoadReportTest.LoadAllReportFormTest;
var
 i : integer;
begin
    {
    LoadReportFromFile('Отчет Движение по комплектующим (кол-во)', ReportPath + '\Отчет Движение по комплектующим (кол-во).fr3');
    LoadReportFromFile('Отчет Движение по комплектующим (вх цена)', ReportPath + '\Отчет Движение по комплектующим (вх цена).fr3');
    exit;

    LoadReportFromFile('PrintMovement_Send_2', ReportPath + '\PrintMovement_Send_2.fr3');
    LoadReportFromFile('PrintMovement_Send', ReportPath + '\PrintMovement_Send.fr3');
    LoadReportFromFile('PrintMovement_IncomeSticker', ReportPath + '\PrintMovement_IncomeSticker.fr3');
    exit;
    LoadReportFromFile('PrintReport_ProductionPersonal', ReportPath + '\PrintReport_ProductionPersonal.fr3');
    exit;

    LoadReportFromFile('PrintObject_Personal_barcode', ReportPath + '\PrintObject_Personal_barcode.fr3');
    LoadReportFromFile('PrintMovement_OrderClientBarcode', ReportPath + '\PrintMovement_OrderClientBarcode.fr3');

    LoadReportFromFile('PrintMovement_ProductionPersonal', ReportPath + '\PrintMovement_ProductionPersonal.fr3');
    exit;
    }
    //LoadReportFromFile('PrintReceiptGoods_StructureGoods', ReportPath + '\PrintReceiptGoods_StructureGoods.fr3');
    //LoadReportFromFile('PrintReceiptProdModel_StructureGoods', ReportPath + '\PrintReceiptProdModel_StructureGoods.fr3');
    LoadReportFromFile('PrintReceiptProdModel_Structure', ReportPath + '\PrintReceiptProdModel_Structure.fr3');
    exit;
    LoadReportFromFile('PrintProduct_StructureGoods', ReportPath + '\PrintProduct_StructureGoods.fr3');
    exit;
    LoadReportFromFile('PrintProduct_OrderConfirmation', ReportPath + '\PrintProduct_OrderConfirmation.fr3');
    LoadReportFromFile('PrintProduct_Structure', ReportPath + '\PrintProduct_Structure.fr3');
    LoadReportFromFile('PrintProduct_Offer', ReportPath + '\PrintProduct_Offer.fr3');
//  LoadReportFromFile('Анализ продаж1', ReportPath + '\Анализ продаж1.fr3');
//  LoadReportFromFile('Анализ продаж (группа)', ReportPath + '\Анализ продаж (группа).fr3');
//  LoadReportFromFile('Анализ продаж (линия_группа)', ReportPath + '\Анализ продаж (линия_группа).fr3');
//  LoadReportFromFile('Анализ продаж (торговая марка)', ReportPath + '\Анализ продаж (торговая марка).fr3');
//
//  LoadReportFromFile('PrintReport_SaleReturnIn_BarCode', ReportPath + '\PrintReport_SaleReturnIn_BarCode.fr3');
//  LoadReportFromFile('PrintReport_SaleReturnIn', ReportPath + '\PrintReport_SaleReturnIn.fr3');
//  LoadReportFromFile('PrintReport_ClientDebt', ReportPath + '\PrintReport_ClientDebt.fr3');
//  LoadReportFromFile('PrintReport_Sale', ReportPath + '\PrintReport_Sale.fr3');
//  LoadReportFromFile('PrintReport_ReturnIn', ReportPath + '\PrintReport_ReturnIn.fr3');
//  LoadReportFromFile('PrintReport_Uniform', ReportPath + '\PrintReport_Uniform.fr3');
//  LoadReportFromFile('PrintReport_Goods_RemainsCurrent', ReportPath + '\PrintReport_Goods_RemainsCurrent.fr3');
//  LoadReportFromFile('Print_Check_GoodsAccount', ReportPath + '\Print_Check_GoodsAccount.fr3');
//  LoadReportFromFile('Print_Check', ReportPath + '\Print_Check.fr3');
//  LoadReportFromFile('Движение по покупателю (Акт сверки)', ReportPath + '\Движение по покупателю (Акт сверки).fr3');
//  LoadReportFromFile('Движение по покупателю', ReportPath + '\Движение по покупателю.fr3');
//  LoadReportFromFile('Отчет по расчетам', ReportPath + '\Отчет по расчетам.fr3');
//  LoadReportFromFile('PrintMovement_Income', ReportPath + '\PrintMovement_Income.fr3');
//  LoadReportFromFile('PrintMovement_IncomeIn', ReportPath + '\Приход от поставщика вх цена.fr3');
//  LoadReportFromFile('PrintMovement_ReturnOut', ReportPath + '\PrintMovement_ReturnOut.fr3');
//  LoadReportFromFile('PrintMovement_Send', ReportPath + '\PrintMovement_Send.fr3');
//  LoadReportFromFile('PrintMovement_SendIn', ReportPath + '\PrintMovement_SendIn.fr3');
//  LoadReportFromFile('PrintMovement_Loss', ReportPath + '\PrintMovement_Loss.fr3');
//  LoadReportFromFile('PrintMovement_IncomeSticker', ReportPath + '\PrintMovement_IncomeSticker.fr3');
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
