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
    // �������������� ������ ��� ������������
    procedure SetUp; override;
    // ���������� ������ ��� ������������
    procedure TearDown; override;
  published
    procedure LoadAllReportFormTest;
    procedure LoadTransportReportFormTest;
    procedure LoadReceiptFormTest;
    procedure LoadPromoFormTest;
    procedure LoadWageFormTest;
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
  LoadReportFromFile('�����', ReportPath + '\�������� ����\PrintMovement_Promo.fr3');
  LoadReportFromFile('�����_��_������', ReportPath + '\������ (��������)\�����_��_������.fr3');
end;

procedure TLoadReportTest.LoadReceiptFormTest;
begin
  LoadReportFromFile('������_��������', ReportPath + '\�������\������_��������.fr3');
  LoadReportFromFile('������_��������_���������', ReportPath + '\�������\������_��������_���������.fr3');
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

procedure TLoadReportTest.LoadTransportReportFormTest;
begin
  // ���������
  LoadReportFromFile('������� ���� - ����', ReportPath + '\���������\������� ���� - ����.fr3');
  LoadReportFromFile('��������� ������� �������', ReportPath + '\���������\��������� ������� �������.fr3');
  LoadReportFromFile('������ ������� � �������� ����������', ReportPath + '\���������\������ ������� � �������� ����������.fr3');
end;

procedure TLoadReportTest.LoadWageFormTest;
begin
  LoadReportFromFile('���������_��_��������_1', ReportPath + '\��������\���������_��_��������_1.fr3');
  LoadReportFromFile('���������_��_��������_2', ReportPath + '\��������\���������_��_��������_2.fr3');
end;

procedure TLoadReportTest.LoadAllReportFormTest;
var
 i : integer;
begin
 {
  // ������ ��
  LoadReportFromFile('����� �� ����', ReportPath + '\������ (��)\����� �� ����.fr3');
  LoadReportFromFile('����� �� ������', ReportPath + '\������ (��)\����� �� ������.fr3');
  LoadReportFromFile('����� �� ������ (����� ������)', ReportPath + '\������ (��)\����� �� ������ (����� ������).fr3');
  exit;
   LoadReportFromFile('PrintMovement_Reestr', ReportPath + '\�������� ����\PrintMovement_Reestr.fr3');
   LoadReportFromFile('PrintMovement_ReestrPeriod', ReportPath + '\�������� ����\PrintMovement_ReestrPeriod.fr3');
   LoadReportFromFile('PrintMovement_ReestrStartPeriod', ReportPath + '\�������� ����\PrintMovement_ReestrStartPeriod.fr3');
  exit;
   {
  LoadReportFromFile('����� �������� �� ��', ReportPath + '\������ (��������)\����� �������� �� ��.fr3');
  LoadReportFromFile('����� �������� �� ������ (��)', ReportPath + '\������ (��������)\����� �������� �� ������ (��).fr3');
  LoadReportFromFile('����� �������� �� ������ (�����)', ReportPath + '\������ (��������)\����� �������� �� ������ (�����).fr3');

  LoadReportFromFile('����� �������� �� ������ (��)', ReportPath + '\������ (��������)\����� �������� �� ������ (��).fr3');
  LoadReportFromFile('����� �������� �� ������ (����)', ReportPath + '\������ (��������)\����� �������� �� ������ (����).fr3');


  // ������
  LoadReportFromFile('������ �� ������ ��������', ReportPath + '\������ (��������)\������ �� ������ ��������.fr3');

  // ������(�������)
  LoadReportFromFile('����� ���� �� ���������� (c ���������-��������� ����������)', ReportPath + '\������ (�������)\����� ���� �� ���������� (c ���������-��������� ����������).fr3');
  LoadReportFromFile('����� ���� �� ���������� (c ���������-���������)', ReportPath + '\������ (�������)\����� ���� �� ���������� (c ���������-���������).fr3');
  LoadReportFromFile('����� ���� �� ���������� (c ���������)', ReportPath + '\������ (�������)\����� ���� �� ���������� (c ���������).fr3');

  LoadReportFromFile('������� �� �� ����� - ����������(����)', ReportPath + '\������ (�������)\������� �� �� ����� - ����������(����).fr3');
  LoadReportFromFile('������� �� �� ����� - ����������(����)', ReportPath + '\������ (�������)\������� �� �� ����� - ����������(����).fr3');
  LoadReportFromFile('������� �� ������������ (����)', ReportPath + '\������ (�������)\������� �� ������������ (����).fr3');

  LoadReportFromFile('������� �� �� ����� - ����������(����)', ReportPath + '\������ (�������)\������� �� �� ����� - ����������(����).fr3');
  LoadReportFromFile('������� �� ������������ - ����������(����)', ReportPath + '\������ (�������)\������� �� ������������ - ����������(����).fr3');

  LoadReportFromFile('A�� ������ �� ����������� (����)', ReportPath + '\������ (��������)\A�� ������ �� ����������� (����).fr3');
  LoadReportFromFile('��� ������ (�������������)', ReportPath + '\������ (�������)\��� ������ (�������������).fr3');
  LoadReportFromFile('��� ������ (� ������)', ReportPath + '\������ (�������)\��� ������ (� ������).fr3');
  LoadReportFromFile('����� ���� �� ���������� (��� ������)', ReportPath + '\������ (�������)\����� ���� �� ���������� (��� ������).fr3');
  LoadReportFromFile('������� �� ���� ������', ReportPath + '\������ (�������)\������� �� ���� ������.fr3');
  LoadReportFromFile('������� �� ���������� �����', ReportPath + '\������ (�������)\������� �� ���������� �����.fr3');
  LoadReportFromFile('������� �� �����', ReportPath + '\������ (�������)\������� �� �����.fr3');
  LoadReportFromFile('������� �� ����� (�� ���������)', ReportPath + '\������ (�������)\������� �� ����� (�� ���������).fr3');
  LoadReportFromFile('������� �� ����� (� �������������)', ReportPath + '\������ (�������)\������� �� ����� (� �������������).fr3');
  LoadReportFromFile('������� �� �����������', ReportPath + '\������ (�������)\������� �� �����������.fr3');
  LoadReportFromFile('������� �� ����������� - ���������', ReportPath + '\������ (�������)\������� �� ����������� - ���������.fr3');
  LoadReportFromFile('����� �� ������', ReportPath + '\������ (�������)\����� �� ������.fr3');

  LoadReportFromFile('PrintObject_ReportCollation', ReportPath + '\������ (�������)\PrintObject_ReportCollation.fr3');
  //exit;
  //  ���������� ����

  LoadReportFromFile('�������� ����', ReportPath + '\���������� ����\�������� ����.fr3');
   // exit;
  LoadReportFromFile('PrintMovement_Invoice', ReportPath + '\���������� ����\PrintMovement_Invoice.fr3');

  LoadReportFromFile('������� � �������', ReportPath + '\������ (��������)\������� � �������.fr3');
  LoadReportFromFile('������� � ������� �� �������', ReportPath + '\������ (��������)\������� � ������� �� �������.fr3');
  LoadReportFromFile('����� �� ������ ����������', ReportPath + '\������ (��������)\����� �� ������ ����������.fr3');
  LoadReportFromFile('������� � ������� �����������', ReportPath + '\������ (��������)\������� � ������� �����������.fr3');

  LoadReportFromFile('����� �������� �� ������ (��� ����)', ReportPath + '\������ (��������)\����� �������� �� ������ (��� ����).fr3');
  LoadReportFromFile('����� �������� �� ������ (����� ��)', ReportPath + '\������ (��������)\����� �������� �� ������ (����� ��).fr3');
  LoadReportFromFile('����� �������� �� ������ (�������)', ReportPath + '\������ (��������)\����� �������� �� ������ (�������).fr3');
  LoadReportFromFile('����� �� ������ �� ���������', ReportPath + '\������ (��������)\����� �� ������ �� ���������.fr3');
  LoadReportFromFile('����� �������� �� ��', ReportPath + '\������ (��������)\����� �������� �� ��.fr3');
  LoadReportFromFile('����� �������� �� ������ (��)', ReportPath + '\������ (��������)\����� �������� �� ������ (��).fr3');
  LoadReportFromFile('����� �������� �� ������ (�����)', ReportPath + '\������ (��������)\����� �������� �� ������ (�����).fr3');

  LoadReportFromFile('����� �������� �� ������ (��� ��������)', ReportPath + '\������ (��������)\����� �������� �� ������ (��� ��������).fr3');
  LoadReportFromFile('����� �������� �� ������ (���)', ReportPath + '\������ (��������)\����� �������� �� ������ (���).fr3');

  LoadReportFromFile('����� �� �������� ������', ReportPath + '\������ (��������)\����� �� �������� ������.fr3');
  LoadReportFromFile('����� �� �������� ������ (��������)', ReportPath + '\������ (��������)\����� �� �������� ������ (��������).fr3');
  LoadReportFromFile('����� �� �������� ������ (�������)', ReportPath + '\������ (��������)\����� �� �������� ������ (�������).fr3');
  LoadReportFromFile('����� �� �������� ������ (����� ��)', ReportPath + '\������ (��������)\����� �� �������� ������ (����� ��).fr3');
  LoadReportFromFile('����� �� �������� ������ (������� ��������)', ReportPath + '\������ (��������)\����� �� �������� ������ (������� ��������).fr3');
  LoadReportFromFile('����� �� �������� ������ (��������)', ReportPath + '\������ (��������)\����� �� �������� ������ (��������).fr3');

  LoadReportFromFile('����� �� ������ (������� �� �����������)', ReportPath + '\������ (������ (��������)\����� �� ������ (������� �� �����������).fr3');
  LoadReportFromFile('����� �� ������ (������ �� ����������)', ReportPath + '\������ (��������)\����� �� ������ (������ �� ����������).fr3');
  LoadReportFromFile('����� �� ������ (����������)', ReportPath + '\������ (��������)\����� �� ������ (����������).fr3');

  LoadReportFromFile('����� �� ���������', ReportPath + '\������ (������ (��������)\����� �� ���������.fr3');

  LoadReportFromFile('����� �� ���������', ReportPath + '\������ (��������)\����� �� ���������.fr3');

  // ������ ��
  LoadReportFromFile('����� �� ����', ReportPath + '\������ (��)\����� �� ����.fr3');
  LoadReportFromFile('����� �� ������', ReportPath + '\������ (��)\����� �� ������.fr3');
  exit;
  // ������ ������������
  LoadReportFromFile('�����_������_������_������������_����������', ReportPath + '\������ (������������)\�����_������_������_������������_����������.fr3');
  LoadReportFromFile('�����_������_������_������������_����������_����', ReportPath + '\������ (������������)\�����_������_������_������������_����������_����.fr3');

  LoadReportFromFile('������������ � ������� ������ (�����)', ReportPath + '\������ (������������)\������������ � ������� ������ (�����).fr3');
  LoadReportFromFile('������������ � ������� ������ (������)', ReportPath + '\������ (������������)\������������ � ������� ������ (������).fr3');
  LoadReportFromFile('������ �� ����� � ������� ������ (�����)', ReportPath + '\������ (������������)\������ �� ����� � ������� ������ (�����).fr3');

  LoadReportFromFile('�������� �������', ReportPath + '\������ (������������)\�������� �������.fr3');
  LoadReportFromFile('�������� ������� (����)', ReportPath + '\������ (������������)\�������� ������� (����).fr3');
  LoadReportFromFile('�������� ������� (���� ������������� � �������)', ReportPath + '\������ (������������)\�������� ������� (���� ������������� � �������).fr3');
  LoadReportFromFile('�������� ������� (���� ������������� � ������� � �����)', ReportPath + '\������ (������������)\�������� ������� (���� ������������� � ������� � �����).fr3');
  LoadReportFromFile('�������� ������� (���� ������������� � �������)', ReportPath + '\������ (������������)\�������� ������� (���� ������������� � �������).fr3');
  LoadReportFromFile('�������� ������� (���� ������������� ���������)', ReportPath + '\������ (������������)\�������� ������� (���� ������������� ���������).fr3');
  LoadReportFromFile('�������� ������� (��������� ���)', ReportPath + '\������ (������������)\�������� ������� (��������� ���).fr3');
  LoadReportFromFile('�������� ������� (��������� ��� �������������)', ReportPath + '\������ (������������)\�������� ������� (��������� ��� �������������).fr3');

  LoadReportFromFile('������������ ���� � ���� ������ �����', ReportPath + '\������ (������������)\������������ ���� � ���� ������ �����.fr3');
  LoadReportFromFile('������������ ���� � ���� ����� ���', ReportPath + '\������ (������������)\������������ ���� � ���� ����� ���.fr3');

  LoadReportFromFile('��������� �� �������', ReportPath + '\������ (������������)\��������� �� �������.fr3');
  LoadReportFromFile('���������(����)', ReportPath + '\������ (������������)\���������(����).fr3');
  LoadReportFromFile('����� �� ��������', ReportPath + '\������ (������������)\����� �� ��������.fr3');
  LoadReportFromFile('����� �� ���������������', ReportPath + '\������ (������������)\����� �� ���������������.fr3');
  LoadReportFromFile('��������� � ���������� ���� ������������ �� �����_1', ReportPath + '\������ (������������)\��������� � ���������� ���� ������������ �� �����_1.fr3');


  LoadReportFromFile('��� �������', ReportPath + '\������������\��� �������.fr3');
  LoadReportFromFile('��������� �� �������', ReportPath + '\������������\��������� �� �������.fr3');
  LoadReportFromFile('��������� �� ����������� �������', ReportPath + '\������������\��������� �� ����������� �������.fr3');
  LoadReportFromFile('������ �� ������������', ReportPath + '\������������\������ �� ������������.fr3');
  LoadReportFromFile('������ �� ��������', ReportPath + '\������������\������ �� ��������.fr3');
  LoadReportFromFile('������ �� �����', ReportPath + '\������������\������ �� �����.fr3');

  // ������ ������
  LoadReportFromFile('����� - ������ (��� ��������)', ReportPath + '\������ (��������)\����� - ������ (��� ��������).fr3');
  LoadReportFromFile('����� - ������ (�� �����������-���)', ReportPath + '\������ (��������)\����� - ������ (�� �����������-���).fr3');
  LoadReportFromFile('����� - ������ (�� ������������)', ReportPath + '\������ (��������)\����� - ������ (�� ������������).fr3');
  LoadReportFromFile('����� - ������ (�� ���� ������)', ReportPath + '\������ (��������)\����� - ������ (�� ���� ������).fr3');
  LoadReportFromFile('����� - ������ (�� ���������-��������)', ReportPath + '\������ (��������)\����� - ������ (�� ���������-��������).fr3');
  LoadReportFromFile('����� - ������ (�� ���������-�����)', ReportPath + '\������ (��������)\����� - ������ (�� ���������-�����).fr3');
  LoadReportFromFile('����� - ������ (�����)', ReportPath + '\������ (��������)\����� - ������ (�����).fr3');

  // �������� ����� ���������
   LoadReportFromFile('PrintMovement_Reestr', ReportPath + '\�������� ����\PrintMovement_Reestr.fr3');
   LoadReportFromFile('PrintMovement_ReestrPeriod', ReportPath + '\�������� ����\PrintMovement_ReestrPeriod.fr3');
   LoadReportFromFile('PrintMovement_ReestrStartPeriod', ReportPath + '\�������� ����\PrintMovement_ReestrStartPeriod.fr3');
 }
  LoadReportFromFile('PrintMovement_TransferDebtOut', ReportPath + '\�������� ����\PrintMovement_TransferDebtOut.fr3');
  LoadReportFromFile('PrintMovement_Sale1', ReportPath + '\�������� ����\PrintMovement_Sale1.fr3');
  LoadReportFromFile('PrintMovement_Sale2', ReportPath + '\�������� ����\PrintMovement_Sale2.fr3');
  LoadReportFromFile('PrintMovement_Sale2DiscountPrice', ReportPath + '\�������� ����\PrintMovement_Sale2DiscountPrice.fr3');
  LoadReportFromFile('PrintMovement_Sale2PriceWithVAT', ReportPath + '\�������� ����\PrintMovement_Sale2PriceWithVAT.fr3');
   exit;
  LoadReportFromFile('PrintMovement_SaleInvoice', ReportPath + '\�������� ����\PrintMovement_SaleInvoice.fr3');
  LoadReportFromFile('PrintMovement_SaleSpec', ReportPath + '\�������� ����\PrintMovement_SaleSpec.fr3');

  LoadReportFromFile('PrintMovement_SaleTotal', ReportPath + '\�������� ����\PrintMovement_SaleTotal.fr3');
//  LoadReportFromFile('PrintMovement_SendOnPriceIn', ReportPath + '\�������� ����\PrintMovement_SendOnPriceIn.fr3');
//  LoadReportFromFile('PrintMovement_SendOnPriceOut', ReportPath + '\�������� ����\PrintMovement_SendOnPriceOut.fr3');
  LoadReportFromFile('PrintMovement_SendOnPrice', ReportPath + '\�������� ����\PrintMovement_SendOnPrice.fr3');

  LoadReportFromFile('PrintMovement_SalePack', ReportPath + '\�������� ����\PrintMovement_SalePack.fr3');

  LoadReportFromFile('PrintMovement_Quality', ReportPath + '\�������� ����\PrintMovement_Quality.fr3');

  LoadReportFromFile('PrintMovement_ReturnIn', ReportPath + '\�������� ����\PrintMovement_ReturnIn.fr3');
  LoadReportFromFile('PrintMovement_ReturnIn32049199', ReportPath + '\�������� ����\PrintMovement_ReturnIn32049199.fr3');
  LoadReportFromFile('PrintMovement_ReturnIn32516492', ReportPath + '\�������� ����\PrintMovement_ReturnIn32516492.fr3');
  LoadReportFromFile('PrintMovement_ReturnIn35442481', ReportPath + '\�������� ����\PrintMovement_ReturnIn35442481.fr3');
  LoadReportFromFile('PrintMovement_ReturnInDay', ReportPath + '\�������� ����\PrintMovement_ReturnInDay.fr3');
  LoadReportFromFile('PrintMovement_PriceCorrective35442481', ReportPath + '\�������� ����\PrintMovement_PriceCorrective35442481.fr3');
  LoadReportFromFile('PrintMovement_PriceCorrective32049199', ReportPath + '\�������� ����\PrintMovement_PriceCorrective32049199.fr3');
  LoadReportFromFile('PrintMovement_Tax', ReportPath + '\�������� ����\PrintMovement_Tax.fr3');
  LoadReportFromFile('PrintMovement_Tax1214', ReportPath + '\�������� ����\PrintMovement_Tax1214.fr3');
  LoadReportFromFile('PrintMovement_Tax0115', ReportPath + '\�������� ����\PrintMovement_Tax0115.fr3');
  LoadReportFromFile('PrintMovement_Tax0416', ReportPath + '\�������� ����\PrintMovement_Tax0416.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective', ReportPath + '\�������� ����\PrintMovement_TaxCorrective.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective1214', ReportPath + '\�������� ����\PrintMovement_TaxCorrective1214.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective0115', ReportPath + '\�������� ����\PrintMovement_TaxCorrective0115.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective0416', ReportPath + '\�������� ����\PrintMovement_TaxCorrective0416.fr3');
  LoadReportFromFile('PrintMovement_Bill', ReportPath + '\�������� ����\PrintMovement_Bill.fr3');
  LoadReportFromFile('PrintMovement_Bill01074874', ReportPath + '\�������� ����\PrintMovement_Bill01074874.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrectiveReestr', ReportPath + '\�������� ����\PrintMovement_TaxCorrectiveReestr.fr3');
  LoadReportFromFile('PrintMovement_TTN', ReportPath + '\�������� ����\PrintMovement_TTN.fr3');

  LoadReportFromFile('PrintMovement_SalePack21', ReportPath + '\�������� ����\PrintMovement_SalePack21.fr3');
  LoadReportFromFile('PrintMovement_SalePack22', ReportPath + '\�������� ����\PrintMovement_SalePack22.fr3');

  LoadReportFromFile('PrintMovement_ReturnIn_By_TaxCorrective', ReportPath + '\�������� ����\PrintMovement_ReturnIn_By_TaxCorrective.fr3');

  LoadReportFromFile('PrintMovement_OrderExternal', ReportPath + '\�������� ����\PrintMovement_OrderExternal.fr3');
  LoadReportFromFile('PrintMovement_Loss', ReportPath + '\�������� ����\PrintMovement_Loss.fr3');
  LoadReportFromFile('PrintMovement_Income', ReportPath + '\�������� ����\PrintMovement_Income.fr3');
  LoadReportFromFile('PrintMovement_IncomeAsset', ReportPath + '\�������� ����\PrintMovement_IncomeAsset.fr3');
  LoadReportFromFile('PrintMovement_IncomeFuel', ReportPath + '\�������� ����\PrintMovement_IncomeFuel.fr3');
  LoadReportFromFile('PrintMovement_ReturnOut', ReportPath + '\�������� ����\PrintMovement_ReturnOut.fr3');
  LoadReportFromFile('PrintMovement_Send', ReportPath + '\�������� ����\PrintMovement_Send.fr3');

  LoadReportFromFile('PrintMovement_Inventory', ReportPath + '\�������� ����\PrintMovement_Inventory.fr3');
  LoadReportFromFile('PrintMovement_Sale_Order', ReportPath + '\�������� ����\PrintMovement_Sale_Order.fr3');
  LoadReportFromFile('PrintMovement_ProductionUnion', ReportPath + '\�������� ����\PrintMovement_ProductionUnion.fr3');

  LoadReportFromFile('PrintMovement_PersonalService', ReportPath + '\��������\PrintMovement_PersonalService.fr3');

  LoadReportFromFile('����������7', ReportPath + '\������(�������)\����������7.fr3');
  LoadReportFromFile('����������7 �����', ReportPath + '\������(�������)\����������7 �����.fr3');
  LoadReportFromFile('����������1', ReportPath + '\������(�������)\����������1.fr3');
  LoadReportFromFile('����� �������', ReportPath + '\������(�������)\����� �������.fr3');

  LoadReportFromFile('PrintObjectHistory_PriceListItem', ReportPath + '\�����������\PrintObjectHistory_PriceListItem.fr3');

  TStrArrAdd(['35275230','30982361','30487219','37910513','32294926','01074874','32516492','35442481','36387249','32049199', '31929492', '22447463', '36003603', '39118745']);
  for i := Low(OKPO) to High(OKPO) do
    LoadReportFromFile('PrintMovement_Sale' + OKPO[i], ReportPath + '\�������� ����\PrintMovement_Sale' + OKPO[i] + '.fr3');

  LoadReportFromFile('PrintMovement_Transport', ReportPath + '\�������� ����\PrintMovement_Transport.fr3');

  TStrArrAdd(['32516492','39135315','32049199','36003603','36387249', '36387233', '38916558' ]);
  for i := Low(OKPO) to High(OKPO) do
    LoadReportFromFile('PrintMovement_Transport' + OKPO[i], ReportPath + '\�������� ����\PrintMovement_Transport' + OKPO[i] + '.fr3');


end;

procedure TLoadReportTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', 'qsxqsxw1', gc_User);
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
