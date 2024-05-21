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
   {
    LoadReportFromFile('PrintMovement_Invoice_Pay', ReportPath + '\PrintMovement_Invoice_Pay.fr3');
    LoadReportFromFile('PrintMovement_Invoice_PrePay', ReportPath + '\PrintMovement_Invoice_PrePay.fr3');
    LoadReportFromFile('PrintMovement_Invoice_PrePay2', ReportPath + '\PrintMovement_Invoice_PrePay2.fr3');
    LoadReportFromFile('PrintMovement_Invoice_Return', ReportPath + '\PrintMovement_Invoice_Return.fr3');
    LoadReportFromFile('PrintMovement_Invoice_Master', ReportPath + '\PrintMovement_Invoice_Master.fr3');
    exit;
    }
    {
    LoadReportFromFile('PrintMovement_IncomePrice', ReportPath + '\PrintMovement_IncomePrice.fr3');
    exit;

    LoadReportFromFile('PrintMovement_Income', ReportPath + '\PrintMovement_Income.fr3');
    exit;

    LoadReportFromFile('PrintUser_Badge', ReportPath + '\PrintUser_Badge.fr3');

    LoadReportFromFile('PrintMovement_OrderInternalSticker', ReportPath + '\PrintMovement_OrderInternalSticker.fr3');

    LoadReportFromFile('PrintMovement_Invoice_Pay', ReportPath + '\PrintMovement_Invoice_Pay.fr3');
    LoadReportFromFile('PrintMovement_Invoice_PrePay', ReportPath + '\PrintMovement_Invoice_PrePay.fr3');
    LoadReportFromFile('PrintMovement_Invoice_PrePay2', ReportPath + '\PrintMovement_Invoice_PrePay2.fr3');
    LoadReportFromFile('PrintMovement_Invoice_Return', ReportPath + '\PrintMovement_Invoice_Return.fr3');
    LoadReportFromFile('PrintMovement_Invoice_Master', ReportPath + '\PrintMovement_Invoice_Master.fr3');
    exit;


    LoadReportFromFile('PrintMovement_Invoice', ReportPath + '\PrintMovement_Invoice.fr3');
    exit;

    LoadReportFromFile('PrintReport_OrderClientByBoatGoods', ReportPath + '\PrintReport_OrderClientByBoatGoods.fr3');
    exit;
    LoadReportFromFile('PrintReport_OrderClientByBoat', ReportPath + '\PrintReport_OrderClientByBoat.fr3');
    LoadReportFromFile('PrintReport_OrderClientByBoatMov', ReportPath + '\PrintReport_OrderClientByBoatMov.fr3');

    LoadReportFromFile('PrintMovement_ProductionUnionCalc', ReportPath + '\PrintMovement_ProductionUnionCalc.fr3');

    LoadReportFromFile('PrintMovement_ProductionUnion', ReportPath + '\PrintMovement_ProductionUnion.fr3');

    LoadReportFromFile('PrintMovement_OrderInternal', ReportPath + '\PrintMovement_OrderInternal.fr3');
    exit;

    LoadReportFromFile('����� �������� �� ������������� (������ �����)', ReportPath + '\����� �������� �� ������������� (������ �����).fr3');

    LoadReportFromFile('����� �������� �� ������������� (���-��)', ReportPath + '\����� �������� �� ������������� (���-��).fr3');
    exit;

    LoadReportFromFile('����� �������� �� ������������� (�� ����)', ReportPath + '\����� �������� �� ������������� (�� ����).fr3');


    LoadReportFromFile('PrintMovement_Send_3', ReportPath + '\PrintMovement_Send_3.fr3');


    LoadReportFromFile('PrintMovement_Send_2', ReportPath + '\PrintMovement_Send_2.fr3');
    LoadReportFromFile('PrintMovement_Send', ReportPath + '\PrintMovement_Send.fr3');
    LoadReportFromFile('PrintMovement_IncomeSticker', ReportPath + '\PrintMovement_IncomeSticker.fr3');
    exit;
    LoadReportFromFile('PrintReport_ProductionPersonal', ReportPath + '\PrintReport_ProductionPersonal.fr3');

    LoadReportFromFile('PrintObject_Personal_barcode', ReportPath + '\PrintObject_Personal_barcode.fr3');
    LoadReportFromFile('PrintMovement_OrderClientBarcode', ReportPath + '\PrintMovement_OrderClientBarcode.fr3');

    LoadReportFromFile('PrintMovement_ProductionPersonal', ReportPath + '\PrintMovement_ProductionPersonal.fr3');
     }
    LoadReportFromFile('PrintReceiptGoods_Structure', ReportPath + '\PrintReceiptGoods_Structure.fr3');
    exit;
    {
    //LoadReportFromFile('PrintReceiptProdModel_StructureGoods', ReportPath + '\PrintReceiptProdModel_StructureGoods.fr3');
    LoadReportFromFile('PrintReceiptProdModelGoods_Structure', ReportPath + '\PrintReceiptProdModelGoods_Structure.fr3');
    LoadReportFromFile('PrintReceiptProdModel_Structure', ReportPath + '\PrintReceiptProdModel_Structure.fr3');

    LoadReportFromFile('PrintProduct_StructureGoods', ReportPath + '\PrintProduct_StructureGoods.fr3');
   }
    LoadReportFromFile('PrintProduct_OrderConfirmation', ReportPath + '\PrintProduct_OrderConfirmation.fr3');
    LoadReportFromFile('PrintProduct_OrderConfirmation_Discount', ReportPath + '\PrintProduct_OrderConfirmation_Discount.fr3');
    //LoadReportFromFile('PrintProduct_Structure', ReportPath + '\PrintProduct_Structure.fr3');

    LoadReportFromFile('PrintProduct_Offer', ReportPath + '\PrintProduct_Offer.fr3');
    LoadReportFromFile('PrintProduct_Offer_Discount', ReportPath + '\PrintProduct_Offer_Discount.fr3');
    exit;
    LoadReportFromFile('PrintUser_Badge', ReportPath + '\PrintUser_Badge.fr3');
//  LoadReportFromFile('������ ������1', ReportPath + '\������ ������1.fr3');
//  LoadReportFromFile('������ ������ (������)', ReportPath + '\������ ������ (������).fr3');
//  LoadReportFromFile('������ ������ (�����_������)', ReportPath + '\������ ������ (�����_������).fr3');
//  LoadReportFromFile('������ ������ (�������� �����)', ReportPath + '\������ ������ (�������� �����).fr3');
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
//  LoadReportFromFile('�������� �� ���������� (��� ������)', ReportPath + '\�������� �� ���������� (��� ������).fr3');
//  LoadReportFromFile('�������� �� ����������', ReportPath + '\�������� �� ����������.fr3');
//  LoadReportFromFile('����� �� ��������', ReportPath + '\����� �� ��������.fr3');
//  LoadReportFromFile('PrintMovement_Income', ReportPath + '\PrintMovement_Income.fr3');
//  LoadReportFromFile('PrintMovement_IncomeIn', ReportPath + '\������ �� ���������� �� ����.fr3');
//  LoadReportFromFile('PrintMovement_ReturnOut', ReportPath + '\PrintMovement_ReturnOut.fr3');
//  LoadReportFromFile('PrintMovement_Send', ReportPath + '\PrintMovement_Send.fr3');
//  LoadReportFromFile('PrintMovement_SendIn', ReportPath + '\PrintMovement_SendIn.fr3');
//  LoadReportFromFile('PrintMovement_Loss', ReportPath + '\PrintMovement_Loss.fr3');
//  LoadReportFromFile('PrintMovement_IncomeSticker', ReportPath + '\PrintMovement_IncomeSticker.fr3');
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
