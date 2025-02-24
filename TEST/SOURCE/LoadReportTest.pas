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
  LoadReportFromFile('�����', ReportPath + '\�������� ����\PrintMovement_Promo.fr3');

  }
  LoadReportFromFile('����������� ���������� �����', ReportPath + '\�������� ����\PrintMovement_Promo_Calc.fr3');
  {
  LoadReportFromFile('�����_��_������', ReportPath + '\������ (��������)\�����_��_������.fr3');

  LoadReportFromFile('�����_��_������(��� ��������� ������)', ReportPath + '\������ (��������)\�����_��_������(��� ��������� ������).fr3');
  LoadReportFromFile('�����_��_������(��� ���������� �����)', ReportPath + '\������ (��������)\�����_��_������(��� ���������� �����).fr3');
  exit;
  LoadReportFromFile('����� ���������� ������� �����', ReportPath + '\������ (��������)\����� ���������� ������� �����.fr3');
  }
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
  {
  LoadReportFromFile('����� ������� ���������� (������)', ReportPath + '\���������\����� ������� ���������� (������).fr3');
  exit;

  LoadReportFromFile('����� �� ���', ReportPath + '\���������\����� �� ���.fr3');
  exit;
 }
  LoadReportFromFile('������� ���� (���. ����� 2)', ReportPath + '\���������\������� ���� (���. ����� 2).fr3');
  exit;

  LoadReportFromFile('������� ���� - ����', ReportPath + '\���������\������� ���� - ����.fr3');
  LoadReportFromFile('��������� ������� �������', ReportPath + '\���������\��������� ������� �������.fr3');
  LoadReportFromFile('������ ������� � �������� ����������', ReportPath + '\���������\������ ������� � �������� ����������.fr3');
end;

procedure TLoadReportTest.LoadWageFormTest;
begin
  LoadReportFromFile('PrintMovement_PersonalGroup', ReportPath + '\��������\PrintMovement_PersonalGroup.fr3');
 { exit;

  LoadReportFromFile('���������_��_��������_1', ReportPath + '\��������\���������_��_��������_1.fr3');
  LoadReportFromFile('���������_��_��������_2', ReportPath + '\��������\���������_��_��������_2.fr3');
  }
end;

procedure TLoadReportTest.LoadSticker;
begin
  // 1
  LoadReportFromFile('������ + �� ���� - ����������.Sticker',          ReportPath + '\��������\������ + �� ���� - ����������.fr3');
  // 2
  LoadReportFromFile('������ + �� ���� ��� - ����������.Sticker',      ReportPath + '\��������\������ + �� ���� ��� - ����������.fr3');
  // 3
  LoadReportFromFile('������ + �� ����� (�����) - ����������.Sticker', ReportPath + '\��������\������ + �� ����� (�����) - ����������.fr3');
  // 4
  LoadReportFromFile('������ + �� ���� ������� - ����������.Sticker',  ReportPath + '\��������\������ + �� ���� ������� - ����������.fr3');
  // 5+
  // 6+
  LoadReportFromFile('������ + �� Գ���� ������ - ����������.Sticker',  ReportPath + '\��������\������ + �� Գ���� ������ - ����������.fr3');
  // 7+
  LoadReportFromFile('������ + �� ����� ���� (�����) - ����������.Sticker',  ReportPath + '\��������\������ + �� ����� ���� (�����) - ����������.fr3');
  // 8+
  LoadReportFromFile('������ + �� ����� (�����) - ����������.Sticker',  ReportPath + '\��������\������ + �� ����� (�����) - ����������.fr3');
  // 9+
  LoadReportFromFile('������ + �� ���� - ����������.Sticker',  ReportPath + '\��������\������ + �� ���� - ����������.fr3');
  // 10+
  LoadReportFromFile('������ + �� ճ� ������� (���.������) - ����������.Sticker',  ReportPath + '\��������\������ + �� ճ� ������� (���.������) - ����������.fr3');

end;

procedure TLoadReportTest.LoadAllReportFormTest;
var
 i : integer;
begin

  {
  LoadReportFromFile('PrintMovement_Income_Reestr', ReportPath + '\�������� ����\PrintMovement_Income_Reestr.fr3');
  exit;

  LoadReportFromFile('PrintMovement_Income_Sklad', ReportPath + '\�������� ����\PrintMovement_Income_Sklad.fr3');
  exit;
  LoadReportFromFile('PrintMovement_Income_wp_ActDiff', ReportPath + '\�������� ����\PrintMovement_Income_wp_ActDiff.fr3');
  exit;
  LoadReportFromFile('PrintMovement_WeighingPartner', ReportPath + '\�������� ����\PrintMovement_WeighingPartner.fr3');
  exit;
  LoadReportFromFile('PrintMovement_Income_ActDiff', ReportPath + '\�������� ����\PrintMovement_Income_ActDiff.fr3');
  exit;

  LoadReportFromFile('PrintMovement_SaleAsset', ReportPath + '\�������� ����\PrintMovement_SaleAsset.fr3');
  exit;
  LoadReportFromFile('PrintMovement_PromoTrade', ReportPath + '\�������� ����\PrintMovement_PromoTrade.fr3');
  exit;

  LoadReportFromFile('������_������ � �������� � ����� ������', ReportPath + '\������ (��������)\������_������ � �������� � ����� ������.fr3');
  exit;
  LoadReportFromFile('PrintUser_Badge', ReportPath + '\�����������\PrintUser_Badge.fr3');

  LoadReportFromFile('������_�����������_��������', ReportPath + '\�����������\������_�����������_��������.fr3');
  exit;

  LoadReportFromFile('������ �������� ������(������)', ReportPath + '\�������� ����\������ �������� ������(������).fr3');
  exit;
  LoadReportFromFile('������_ �����������', ReportPath + '\�����������\������_ �����������.fr3');
  exit;
  LoadReportFromFile('������ �������� ������', ReportPath + '\�������� ����\������ �������� ������.fr3');
  exit;
  }
  //LoadReportFromFile('������ ����� �� ������� ��������(�������)', ReportPath + '\������ (��������)\������ ����� �� ������� ��������(�������).fr3');
  //exit;
  {
  LoadReportFromFile('������ ����� �� ������� ��������', ReportPath + '\������ (��������)\������ ����� �� ������� ��������.fr3');
  exit;

  LoadReportFromFile('�����_������ ������ �� ������������', ReportPath + '\������ (������������)\�����_������ ������ �� ������������.fr3');
  exit;

  LoadReportFromFile('�����_������ ������ �� ������������', ReportPath + '\�������� ����\�����_������ ������ �� ������������.fr3');
  exit;

  LoadReportFromFile('����� - ������ (������ �����)', ReportPath + '\������ (��������)\����� - ������ (������ �����).fr3');
  LoadReportFromFile('����� - ������ (������ �����) ���� ����', ReportPath + '\������ (��������)\����� - ������ (������ �����) ���� ����.fr3');

  //LoadReportFromFile('PrintMovement_Sale1_test', ReportPath + '\�������� ����\PrintMovement_Sale1_test.fr3');
  //exit;
 // LoadReportFromFile('������ ������ (���������� �� ��������)', ReportPath + '\�������� ����\������ ������ (���������� �� ��������).fr3');
 // LoadReportFromFile('������ ������ ������ ����� (���������� �� ��������)', ReportPath + '\�������� ����\������ ������ ������ ����� (���������� �� ��������).fr3');
 // exit;
  LoadReportFromFile('������ ������� ������ (���������� �� ��������)��������', ReportPath + '\�������� ����\������ ������� ������ (���������� �� ��������)��������.fr3');
  LoadReportFromFile('������ ������� ������ (���������� �� ��������)3��� ����', ReportPath + '\�������� ����\������ ������� ������ (���������� �� ��������)3��� ����.fr3');
  LoadReportFromFile('������ ������� ������ (���������� �� ��������)3���', ReportPath + '\�������� ����\������ ������� ������ (���������� �� ��������)3���.fr3');

  LoadReportFromFile('������ ������� ������ (���������� �� ��������)', ReportPath + '\�������� ����\������ ������� ������ (���������� �� ��������).fr3');
  exit;

  LoadReportFromFile('PrintMovement_OrderReturnTare', ReportPath + '\�������� ����\PrintMovement_OrderReturnTare.fr3');
  exit;

  LoadReportFromFile('����� ������������_������ ���', ReportPath + '\������ (������������)\����� ������������_������ ���.fr3');
  exit;

  LoadReportFromFile('������� ���� (�������)', ReportPath + '\���������\������� ���� (�������).fr3');
  exit;

  LoadReportFromFile('����� ������ ��������� ����������� (���)', ReportPath + '\������ (������������)\����� ������ ��������� ����������� (���).fr3');
  exit;

  LoadReportFromFile('PrintMovement_OrderGoods', ReportPath + '\�������� ����\PrintMovement_OrderGoods.fr3');
  exit;

  LoadReportFromFile('����� ������� ��� ��������', ReportPath + '\������ (������������)\����� ������� ��� ��������.fr3');
  exit;

  LoadReportFromFile('�������� ���������� �� ������� ��� �������(��������)', ReportPath + '\������ (�������)\�������� ���������� �� ������� ��� �������(��������).fr3');
  exit;
  LoadReportFromFile('PrintMovement_Sale32437180', ReportPath + '\�������� ����\PrintMovement_Sale32437180.fr3');
   exit;

   LoadReportFromFile('������ ���������� ���������� �� �������', ReportPath + '\������ (�������)\������ ���������� ���������� �� �������.fr3');

  LoadReportFromFile('�������� ���������� �� ������� (�����)', ReportPath + '\������ (�������)\�������� ���������� �� ������� (�����).fr3');
  //exit;

  LoadReportFromFile('����� ������� �������', ReportPath + '\������ (��������)\����� ������� �������.fr3');
  //exit;

  LoadReportFromFile('�������� ���������� �� ������� ��� �������', ReportPath + '\������ (�������)\�������� ���������� �� ������� ��� �������.fr3');
  exit;

  //LoadReportFromFile('�������� ���������� �� ������� �����������', ReportPath + '\������ (�������)\�������� ���������� �� ������� �����������.fr3');
  //exit;

  LoadReportFromFile('�������� ���������� �� �������', ReportPath + '\������ (�������)\�������� ���������� �� �������.fr3');
  exit;

  LoadReportFromFile('������� �� ����� � ����� (������ �����)', ReportPath + '\������ (�������)\������� �� ����� � ����� (������ �����).fr3');
  exit;

  LoadReportFromFile('PrintMovement_SendAsset', ReportPath + '\�������� ����\PrintMovement_SendAsset.fr3');
  exit;

  LoadReportFromFile('Print_Object_BarCodeBox', ReportPath + '\�������� ����\Print_Object_BarCodeBox.fr3');
  exit;

  LoadReportFromFile('PrintMovement_WeighingProductionStikerKVK', ReportPath + '\�������� ����\PrintMovement_WeighingProductionStikerKVK.fr3');
  exit;

  LoadReportFromFile('PrintMovement_WeighingProductionBarCode', ReportPath + '\�������� ����\PrintMovement_WeighingProductionBarCode.fr3');
  exit;

  LoadReportFromFile('PrintMovement_WeighingProduction', ReportPath + '\�������� ����\PrintMovement_WeighingProduction.fr3');
  LoadReportFromFile('PrintMovement_WeighingProductionWmsSticker', ReportPath + '\�������� ����\PrintMovement_WeighingProductionWmsSticker.fr3');
  exit;


  LoadReportFromFile('PrintMI_WeighingProductionPassport', ReportPath + '\�������� ����\PrintMI_WeighingProductionPassport.fr3');
  exit;

  LoadReportFromFile('������� �� ���������', ReportPath + '\������ (�������)\������� �� ���������.fr3');
  exit;

  LoadReportFromFile('���������� �����(�����)', ReportPath + '\���������� ����\���������� �����(�����).fr3');
  LoadReportFromFile('���������� �����', ReportPath + '\���������� ����\���������� �����.fr3');
  exit;

  LoadReportFromFile('�� ����� (�� �������)', ReportPath + '\���������� ����\�� ����� (�� �������).fr3');
  exit;

  LoadReportFromFile('PrintMovement_MemberHoliday', ReportPath + '\��������\PrintMovement_MemberHoliday.fr3');
  exit;

  LoadReportFromFile('�� ����� (� �������������)', ReportPath + '\���������� ����\�� ����� (� �������������).fr3');
  exit;

  LoadReportFromFile('PrintMovementGoodsBarCode', ReportPath + '\�������� ����\PrintMovementGoodsBarCode.fr3');

  LoadReportFromFile('������ ������������� � Scale', ReportPath + '\�����������\������ ������������� � Scale.fr3');
  exit;

  LoadReportFromFile('PrintMovement_SaleJuridicalInvoice', ReportPath + '\�������� ����\PrintMovement_SaleJuridicalInvoice.fr3');
  exit;

  LoadReportFromFile('PrintMovement_IncomeSticker', ReportPath + '\�������� ����\PrintMovement_IncomeSticker.fr3');
  exit;

  LoadReportFromFile('����� �������� �� ������ (������ ���+����)', ReportPath + '\������ (��������)\����� �������� �� ������ (������ ���+����).fr3');
  exit;

  LoadReportFromFile('����� �������� �� ������ (������ ��������)', ReportPath + '\������ (��������)\����� �������� �� ������ (������ ��������).fr3');
  exit;

  LoadReportFromFile('����� ������ �������� (������ ������)', ReportPath + '\������ (��������)\����� ������ �������� (������ ������).fr3');
  exit;

  LoadReportFromFile('����� �������� �� ��', ReportPath + '\������ (��������)\����� �������� �� ��.fr3');
  exit;

  LoadReportFromFile('����� �������� �� ������ (��)', ReportPath + '\������ (��������)\����� �������� �� ������ (��).fr3');
  LoadReportFromFile('����� �������� �� ������ (�����)', ReportPath + '\������ (��������)\����� �������� �� ������ (�����).fr3');
  LoadReportFromFile('����� �������� �� ������ (��)', ReportPath + '\������ (��������)\����� �������� �� ������ (��).fr3');
  LoadReportFromFile('����� �������� �� ������ (����)', ReportPath + '\������ (��������)\����� �������� �� ������ (����).fr3');

  LoadReportFromFile('����� �������� �� ������ (�� ��������������)', ReportPath + '\������ (��������)\����� �������� �� ������ (�� ��������������).fr3');
  exit;

  // ������
  LoadReportFromFile('������ �� ������ ��������', ReportPath + '\������ (��������)\������ �� ������ ��������.fr3');

  // ������(�������)
  LoadReportFromFile('����� ���� �� ���������� (c ���������-��������� ����������)', ReportPath + '\������ (�������)\����� ���� �� ���������� (c ���������-��������� ����������).fr3');
  LoadReportFromFile('����� ���� �� ���������� (c ���������-���������)', ReportPath + '\������ (�������)\����� ���� �� ���������� (c ���������-���������).fr3');
  LoadReportFromFile('����� ���� �� ���������� (c ���������)', ReportPath + '\������ (�������)\����� ���� �� ���������� (c ���������).fr3');

  LoadReportFromFile('����� ���� �� ���������� (c ���������365)', ReportPath + '\������ (�������)\����� ���� �� ���������� (c ���������365).fr3');

  LoadReportFromFile('����� ���� �� ���������� (c ���������365-���������)', ReportPath + '\������ (�������)\����� ���� �� ���������� (c ���������365-���������).fr3');

  LoadReportFromFile('����� ���������� c ��������� (���������)', ReportPath + '\������ (�������)\����� ���������� c ��������� (���������).fr3');
  exit;

  LoadReportFromFile('������� �� �� ����� - ����������(����)', ReportPath + '\������ (�������)\������� �� �� ����� - ����������(����).fr3');
  LoadReportFromFile('������� �� �� ����� - ����������(����)', ReportPath + '\������ (�������)\������� �� �� ����� - ����������(����).fr3');
  LoadReportFromFile('������� �� ������������ (����)', ReportPath + '\������ (�������)\������� �� ������������ (����).fr3');

  LoadReportFromFile('������� �� �� ����� - ����������(����)', ReportPath + '\������ (�������)\������� �� �� ����� - ����������(����).fr3');
  LoadReportFromFile('������� �� ������������ - ����������(����)', ReportPath + '\������ (�������)\������� �� ������������ - ����������(����).fr3');

  LoadReportFromFile('������� �� ������������ - ����������(������)', ReportPath + '\������ (�������)\������� �� ������������ - ����������(������).fr3');
  exit;

  LoadReportFromFile('A�� ������ �� ����������� (����)', ReportPath + '\������ (��������)\A�� ������ �� ����������� (����).fr3');
  exit;

    LoadReportFromFile('��� ������ (�������������)�����', ReportPath + '\������ (�������)\��� ������ (�������������)�����.fr3');
  exit;


  LoadReportFromFile('��� ������ (�������������)', ReportPath + '\������ (�������)\��� ������ (�������������).fr3');
  exit;
  LoadReportFromFile('��� ������ (� ������)', ReportPath + '\������ (�������)\��� ������ (� ������).fr3');
  LoadReportFromFile('����� ���� �� ���������� (��� ������)', ReportPath + '\������ (�������)\����� ���� �� ���������� (��� ������).fr3');
  exit;

  LoadReportFromFile('������� �� ���� ������', ReportPath + '\������ (�������)\������� �� ���� ������.fr3');

  LoadReportFromFile('������� �� ���������� �����', ReportPath + '\������ (�������)\������� �� ���������� �����.fr3');
  exit;

  LoadReportFromFile('������� �� �����', ReportPath + '\������ (�������)\������� �� �����.fr3');
  exit;

  LoadReportFromFile('������� �� ����� (�� ���������)', ReportPath + '\������ (�������)\������� �� ����� (�� ���������).fr3');

  LoadReportFromFile('������� �� ����� (� �������������)', ReportPath + '\������ (�������)\������� �� ����� (� �������������).fr3');

  LoadReportFromFile('������� �� ����� (�� �����)', ReportPath + '\������ (�������)\������� �� ����� (�� �����).fr3');
   exit;

  LoadReportFromFile('������� �� �����������', ReportPath + '\������ (�������)\������� �� �����������.fr3');
  LoadReportFromFile('������� �� ����������� - ���������', ReportPath + '\������ (�������)\������� �� ����������� - ���������.fr3');

  LoadReportFromFile('����� �� ������', ReportPath + '\������ (�������)\����� �� ������.fr3');
  exit;

  LoadReportFromFile('PrintObject_ReportCollation', ReportPath + '\������ (�������)\PrintObject_ReportCollation.fr3');

  //  ���������� ����
  LoadReportFromFile('�������� ����', ReportPath + '\���������� ����\�������� ����.fr3');

  LoadReportFromFile('PrintMovement_Invoice', ReportPath + '\���������� ����\PrintMovement_Invoice.fr3');

  LoadReportFromFile('������� � �������', ReportPath + '\������ (��������)\������� � �������.fr3');
  LoadReportFromFile('������� � ������� �� �������', ReportPath + '\������ (��������)\������� � ������� �� �������.fr3');

  LoadReportFromFile('����� �� ������ ����������', ReportPath + '\������ (��������)\����� �� ������ ����������.fr3');
  exit;

  LoadReportFromFile('������� � ������� �����������', ReportPath + '\������ (��������)\������� � ������� �����������.fr3');

  LoadReportFromFile('����� �������� �� ������ (��� ����)', ReportPath + '\������ (��������)\����� �������� �� ������ (��� ����).fr3');
  LoadReportFromFile('����� �������� �� ������ (����� ��)', ReportPath + '\������ (��������)\����� �������� �� ������ (����� ��).fr3');
  exit;

  LoadReportFromFile('����� �������� �� ������ (�������)', ReportPath + '\������ (��������)\����� �������� �� ������ (�������).fr3');
  LoadReportFromFile('����� �� ������ �� ���������', ReportPath + '\������ (��������)\����� �� ������ �� ���������.fr3');
  LoadReportFromFile('����� �������� �� ��', ReportPath + '\������ (��������)\����� �������� �� ��.fr3');

  LoadReportFromFile('��� ������-�������� (�� ��������)', ReportPath + '\������ (��������)\��� ������-�������� (�� ��������).fr3');
  LoadReportFromFile('��� ������-�������� (�� �� ��������)', ReportPath + '\������ (��������)\��� ������-�������� (�� �� ��������).fr3');
   exit;

  LoadReportFromFile('����� �������� �� ������ (��)', ReportPath + '\������ (��������)\����� �������� �� ������ (��).fr3');
  LoadReportFromFile('����� �������� �� ������ (�����)', ReportPath + '\������ (��������)\����� �������� �� ������ (�����).fr3');

  LoadReportFromFile('����� �������� �� ������ (��� ��������)', ReportPath + '\������ (��������)\����� �������� �� ������ (��� ��������).fr3');
  LoadReportFromFile('����� �������� �� ������ (���)', ReportPath + '\������ (��������)\����� �������� �� ������ (���).fr3');

  LoadReportFromFile('����� �� �������� ������', ReportPath + '\������ (��������)\����� �� �������� ������.fr3');
  LoadReportFromFile('����� �� �������� ������ (��������)', ReportPath + '\������ (��������)\����� �� �������� ������ (��������).fr3');

  LoadReportFromFile('����� �� �������� ������ (�������� �� �������)', ReportPath + '\������ (��������)\����� �� �������� ������ (�������� �� �������).fr3');
  exit;
  LoadReportFromFile('����� �� �������� ������ (�������)', ReportPath + '\������ (��������)\����� �� �������� ������ (�������).fr3');
  LoadReportFromFile('����� �� �������� ������ (����� ��)', ReportPath + '\������ (��������)\����� �� �������� ������ (����� ��).fr3');
  LoadReportFromFile('����� �� �������� ������ (������� ��������)', ReportPath + '\������ (��������)\����� �� �������� ������ (������� ��������).fr3');
  LoadReportFromFile('����� �� �������� ������ (��������)', ReportPath + '\������ (��������)\����� �� �������� ������ (��������).fr3');

  LoadReportFromFile('����� �� �������� ������ (�� �� ��� ����)', ReportPath + '\������ (��������)\����� �� �������� ������ (�� �� ��� ����).fr3');
  exit;

  LoadReportFromFile('����� �� ������ (������� �� �����������)', ReportPath + '\������ (������ (��������)\����� �� ������ (������� �� �����������).fr3');

  LoadReportFromFile('����� �� ������ (������ �� ����������)', ReportPath + '\������ (��������)\����� �� ������ (������ �� ����������).fr3');
  exit;

  LoadReportFromFile('����� �� ������ (����������)', ReportPath + '\������ (��������)\����� �� ������ (����������).fr3');

  LoadReportFromFile('����� �� ������ (������ ��������)', ReportPath + '\������ (��������)\����� �� ������ (������ ��������).fr3');

  LoadReportFromFile('����� �� ������ (������ ��������)_�����', ReportPath + '\������ (��������)\����� �� ������ (������ ��������)_�����.fr3');
  exit;

  LoadReportFromFile('����� �� ������ (�������� ������ ������)', ReportPath + '\������ (��������)\����� �� ������ (�������� ������ ������).fr3');
  exit;
  LoadReportFromFile('����� �� ������ (����������)', ReportPath + '\������ (��������)\����� �� ������ (����������).fr3');
  exit;

  LoadReportFromFile('����� �� ���������', ReportPath + '\������ (������ (��������)\����� �� ���������.fr3');

  LoadReportFromFile('����� �� ���������', ReportPath + '\������ (��������)\����� �� ���������.fr3');

  // ������ ��
  LoadReportFromFile('����� �� ����', ReportPath + '\������ (��)\����� �� ����.fr3');

  LoadReportFromFile('����� �� ���� (�������)', ReportPath + '\������ (��)\����� �� ���� (�������).fr3');
  exit;

  LoadReportFromFile('����� �� ������', ReportPath + '\������ (��)\����� �� ������.fr3');

  LoadReportFromFile('����� �� ������ (����� ������)', ReportPath + '\������ (��)\����� �� ������ (����� ������).fr3');
  exit;

  LoadReportFromFile('����� �� ������ (����� ������) ��������', ReportPath + '\������ (��)\����� �� ������ (����� ������) ��������.fr3');
  exit;

  // ������ ������������


  LoadReportFromFile('�����_��_�������', ReportPath + '\������ (������������)\�����_��_�������.fr3');
  LoadReportFromFile('�����_��_�������(���)', ReportPath + '\������ (������������)\�����_��_�������(���).fr3');
  LoadReportFromFile('�����_��_�������(��������)', ReportPath + '\������ (������������)\�����_��_�������(��������).fr3');
  LoadReportFromFile('�����_������������_��������_new', ReportPath + '\������ (������������)\�����_������������_��������_new.fr3');
    exit;

  LoadReportFromFile('�����_������_������_������������_����������', ReportPath + '\������ (������������)\�����_������_������_������������_����������.fr3');
    exit;

  LoadReportFromFile('�����_������_������_������������_����������_����', ReportPath + '\������ (������������)\�����_������_������_������������_����������_����.fr3');
   exit;

  LoadReportFromFile('������������ �����������', ReportPath + '\������ (������������)\������������ �����������.fr3');
  exit;

  LoadReportFromFile('������������ � ������� ������ (�����)', ReportPath + '\������ (������������)\������������ � ������� ������ (�����).fr3');
  LoadReportFromFile('������������ � ������� ������ (������)', ReportPath + '\������ (������������)\������������ � ������� ������ (������).fr3');
  LoadReportFromFile('������ �� ����� � ������� ������ (�����)', ReportPath + '\������ (������������)\������ �� ����� � ������� ������ (�����).fr3');

  LoadReportFromFile('�������� �������', ReportPath + '\������ (������������)\�������� �������.fr3');
  LoadReportFromFile('�������� ������� (����)', ReportPath + '\������ (������������)\�������� ������� (����).fr3');
  LoadReportFromFile('�������� ������� (���� ������������� � �������)', ReportPath + '\������ (������������)\�������� ������� (���� ������������� � �������).fr3');

  LoadReportFromFile('�������� ������� (���� ������������� � �������) �� ���� �����', ReportPath + '\������ (������������)\�������� ������� (���� ������������� � �������) �� ���� �����.fr3');
   exit;
  LoadReportFromFile('�������� ������� (���� ������������� � ������� � �����)', ReportPath + '\������ (������������)\�������� ������� (���� ������������� � ������� � �����).fr3');
  LoadReportFromFile('�������� ������� (���� ������������� � �������)', ReportPath + '\������ (������������)\�������� ������� (���� ������������� � �������).fr3');
  LoadReportFromFile('�������� ������� (���� ������������� ���������)', ReportPath + '\������ (������������)\�������� ������� (���� ������������� ���������).fr3');
  LoadReportFromFile('�������� ������� (��������� ���)', ReportPath + '\������ (������������)\�������� ������� (��������� ���).fr3');
  LoadReportFromFile('�������� ������� (��������� ��� �������������)', ReportPath + '\������ (������������)\�������� ������� (��������� ��� �������������).fr3');

    LoadReportFromFile('�������� ������� (���� ������������� � �������)�����5', ReportPath + '\������ (������������)\�������� ������� (���� ������������� � �������)�����5.fr3');
    LoadReportFromFile('�������� ������� (���� ������������� � �������)�����6', ReportPath + '\������ (������������)\�������� ������� (���� ������������� � �������)�����6.fr3');
  exit;


  LoadReportFromFile('�������� ������� (������ �������)', ReportPath + '\������ (������������)\�������� ������� (������ �������).fr3');
  exit;

  LoadReportFromFile('������������ ���� ������ �����', ReportPath + '\������ (������������)\������������ ���� ������ �����.fr3');

  LoadReportFromFile('������������ ���� � ���� ������ �����', ReportPath + '\������ (������������)\������������ ���� � ���� ������ �����.fr3');
  exit;

  LoadReportFromFile('������������ ���� � ���� ����� ���', ReportPath + '\������ (������������)\������������ ���� � ���� ����� ���.fr3');

  LoadReportFromFile('����� �� �������� ��� ���������', ReportPath + '\������ (������������)\����� �� �������� ��� ���������.fr3');
  LoadReportFromFile('����� �� �������� ��� ���������(���������)', ReportPath + '\������ (������������)\����� �� �������� ��� ���������(���������).fr3');
  LoadReportFromFile('����� �� �������� �� ���� ������', ReportPath + '\������ (������������)\����� �� �������� �� ���� ������.fr3');

  LoadReportFromFile('����� �� ������� �� �����_����������� (����)', ReportPath + '\������ (������������)\����� �� ������� �� �����_����������� (����).fr3');
  LoadReportFromFile('����� �� ������� �� ����� (����)', ReportPath + '\������ (������������)\����� �� ������� �� ����� (����).fr3');
  exit;

  LoadReportFromFile('��������� �� �������', ReportPath + '\������ (������������)\��������� �� �������.fr3');


  LoadReportFromFile('���������(����)', ReportPath + '\������ (������������)\���������(����).fr3');
  exit;

  LoadReportFromFile('����� �� ��������', ReportPath + '\������ (������������)\����� �� ��������.fr3');
  exit;

  LoadReportFromFile('����� �� ���������������', ReportPath + '\������ (������������)\����� �� ���������������.fr3');

  LoadReportFromFile('��������� � ���������� ���� ������������ �� �����_1', ReportPath + '\������ (������������)\��������� � ���������� ���� ������������ �� �����_1.fr3');
  LoadReportFromFile('��������� � ���������� ���� ������������ ��� �������� ��� �� �����_1', ReportPath + '\������ (������������)\��������� � ���������� ���� ������������ ��� �������� ��� �� �����_1.fr3');
  exit;

  LoadReportFromFile('��� �������', ReportPath + '\������������\��� �������.fr3');

  LoadReportFromFile('��� ������� (4001)', ReportPath + '\������������\��� ������� (4001).fr3');
  exit;


  LoadReportFromFile('��������� �� �������', ReportPath + '\������������\��������� �� �������.fr3');
  exit;
  LoadReportFromFile('��������� �� ����������� �������', ReportPath + '\������������\��������� �� ����������� �������.fr3');

   LoadReportFromFile('������������ (�� ���� ��� �����) � �������', ReportPath + '\������������\������������ (�� ���� ��� �����) � �������.fr3');
   LoadReportFromFile('������������ (�� ���� ��� �����)', ReportPath + '\������������\������������ (�� ���� ��� �����).fr3');
   //LoadReportFromFile('������������ (�� ���� ��� ������)', ReportPath + '\������������\������������ (�� ���� ��� ������).fr3');
   //LoadReportFromFile('������������ (�� ���� ��� ��������)', ReportPath + '\������������\������������ (�� ���� ��� ��������).fr3');
    exit;

  LoadReportFromFile('������ �� ������������', ReportPath + '\������������\������ �� ������������.fr3');
   exit;

  LoadReportFromFile('������ �� ��������', ReportPath + '\������������\������ �� ��������.fr3');

  LoadReportFromFile('������ �� �����', ReportPath + '\������������\������ �� �����.fr3');
  exit;

  LoadReportFromFile('������ �� �������� (�������)', ReportPath + '\������������\������ �� �������� (�������).fr3');

  LoadReportFromFile('������ �� �������� (������� ��������)', ReportPath + '\������������\������ �� �������� (������� ��������).fr3');
  LoadReportFromFile('������ �� �������� (������� ��������)2', ReportPath + '\������������\������ �� �������� (������� ��������)2.fr3');

  exit;

  LoadReportFromFile('������ �� �������� (������ ������)', ReportPath + '\������������\������ �� �������� (������ ������).fr3');

  LoadReportFromFile('������ �� ������������ (����)', ReportPath + '\������������\������ �� ������������ (����).fr3');
  LoadReportFromFile('������ �� �������� (����)', ReportPath + '\������������\������ �� �������� (����).fr3');

  LoadReportFromFile('������ �� ����� (����)', ReportPath + '\������������\������ �� ����� (����).fr3');
   exit;

  LoadReportFromFile('������ �� �������� (������)', ReportPath + '\������������\������ �� �������� (������).fr3');
  exit;

  // ������ ������
  LoadReportFromFile('����� - ������ (��� ��������)', ReportPath + '\������ (��������)\����� - ������ (��� ��������).fr3');
  exit;

  LoadReportFromFile('����� - ������ (�� �����������-���)', ReportPath + '\������ (��������)\����� - ������ (�� �����������-���).fr3');
  LoadReportFromFile('����� - ������ (�� ������������)', ReportPath + '\������ (��������)\����� - ������ (�� ������������).fr3');
  exit;
  LoadReportFromFile('����� - ������ (�� ���� ������)', ReportPath + '\������ (��������)\����� - ������ (�� ���� ������).fr3');
  LoadReportFromFile('����� - ������ (�� ���� � ������ ������)', ReportPath + '\������ (��������)\����� - ������ (�� ���� � ������ ������).fr3');
  LoadReportFromFile('����� - ������ (�� ���������-��������)', ReportPath + '\������ (��������)\����� - ������ (�� ���������-��������).fr3');
  LoadReportFromFile('����� - ������ (�� ���������-�����)', ReportPath + '\������ (��������)\����� - ������ (�� ���������-�����).fr3');
  LoadReportFromFile('����� - ������ (�����)', ReportPath + '\������ (��������)\����� - ������ (�����).fr3');

  LoadReportFromFile('����� - ������ (�������)', ReportPath + '\������ (��������)\����� - ������ (�������).fr3');
  exit;
  LoadReportFromFile('����� - ������ (�� ��������� �� ����)', ReportPath + '\������ (��������)\����� - ������ (�� ��������� �� ����).fr3');
  exit;

  // �������� ����� ���������

   LoadReportFromFile('PrintMovement_ReestrIncome', ReportPath + '\�������� ����\PrintMovement_ReestrIncome.fr3');
   LoadReportFromFile('PrintMovement_ReestrIncomePeriod', ReportPath + '\�������� ����\PrintMovement_ReestrIncomePeriod.fr3');
   LoadReportFromFile('PrintMovement_ReestrIncomeStartPeriod', ReportPath + '\�������� ����\PrintMovement_ReestrIncomeStartPeriod.fr3');
   LoadReportFromFile('PrintMovement_ReestrIncomeDriver', ReportPath + '\�������� ����\PrintMovement_ReestrIncomeDriver.fr3');
   exit;

   LoadReportFromFile('PrintMovement_ReestrReturn', ReportPath + '\�������� ����\PrintMovement_ReestrReturn.fr3');
   LoadReportFromFile('PrintMovement_ReestrReturnPeriod', ReportPath + '\�������� ����\PrintMovement_ReestrReturnPeriod.fr3');
   LoadReportFromFile('PrintMovement_ReestrReturnStartPeriod', ReportPath + '\�������� ����\PrintMovement_ReestrReturnStartPeriod.fr3');

   LoadReportFromFile('PrintMovement_ReestrTransportGoods', ReportPath + '\�������� ����\PrintMovement_ReestrTransportGoods.fr3');
   LoadReportFromFile('PrintMovement_ReestrTransportGoodsStartPeriod', ReportPath + '\�������� ����\PrintMovement_ReestrTransportGoodsStartPeriod.fr3');
   LoadReportFromFile('PrintMovement_ReestrTransportGoodsPeriod', ReportPath + '\�������� ����\PrintMovement_ReestrTransportGoodsPeriod.fr3');

   LoadReportFromFile('PrintMovement_Reestr', ReportPath + '\�������� ����\PrintMovement_Reestr.fr3');
   LoadReportFromFile('PrintMovement_ReestrDriver', ReportPath + '\�������� ����\PrintMovement_ReestrDriver.fr3');

   LoadReportFromFile('PrintMovement_ReestrPeriod', ReportPath + '\�������� ����\PrintMovement_ReestrPeriod.fr3');
   LoadReportFromFile('PrintMovement_ReestrStartPeriod', ReportPath + '\�������� ����\PrintMovement_ReestrStartPeriod.fr3');
   exit;

  LoadReportFromFile('PrintMovement_TransferDebtOut', ReportPath + '\�������� ����\PrintMovement_TransferDebtOut.fr3');
  LoadReportFromFile('PrintMovement_Sale1', ReportPath + '\�������� ����\PrintMovement_Sale1.fr3');

  LoadReportFromFile('PrintMovement_Sale43094673', ReportPath + '\�������� ����\PrintMovement_Sale43094673.fr3');
  exit;
  LoadReportFromFile('PrintMovement_Sale2', ReportPath + '\�������� ����\PrintMovement_Sale2.fr3');
  LoadReportFromFile('PrintMovement_Sale2DiscountPrice', ReportPath + '\�������� ����\PrintMovement_Sale2DiscountPrice.fr3');
  LoadReportFromFile('PrintMovement_Sale2PriceWithVAT', ReportPath + '\�������� ����\PrintMovement_Sale2PriceWithVAT.fr3');
  exit;
  }
  LoadReportFromFile('PrintMovement_SalePackWeightTotal', ReportPath + '\�������� ����\PrintMovement_SalePackWeightTotal.fr3');
  exit;
  {
  LoadReportFromFile('PrintMovement_SalePackWeight', ReportPath + '\�������� ����\PrintMovement_SalePackWeight.fr3');
  LoadReportFromFile('PrintMovement_SalePackWeight_Fozzy', ReportPath + '\�������� ����\PrintMovement_SalePackWeight_Fozzy.fr3');





  LoadReportFromFile('PrintMovement_Sale2_3683763', ReportPath + '\�������� ����\PrintMovement_Sale2_3683763.fr3');
  exit;

  LoadReportFromFile('PrintMovement_SaleInvoice', ReportPath + '\�������� ����\PrintMovement_SaleInvoice.fr3');
  LoadReportFromFile('PrintMovement_SaleSpec', ReportPath + '\�������� ����\PrintMovement_SaleSpec.fr3');
  LoadReportFromFile('PrintMovement_SalePack', ReportPath + '\�������� ����\PrintMovement_SalePack.fr3');
  exit;
  LoadReportFromFile('PrintMovement_SaleTotal', ReportPath + '\�������� ����\PrintMovement_SaleTotal.fr3');
//  LoadReportFromFile('PrintMovement_SendOnPriceIn', ReportPath + '\�������� ����\PrintMovement_SendOnPriceIn.fr3');
//  LoadReportFromFile('PrintMovement_SendOnPriceOut', ReportPath + '\�������� ����\PrintMovement_SendOnPriceOut.fr3');

  LoadReportFromFile('PrintMovement_SendOnPrice', ReportPath + '\�������� ����\PrintMovement_SendOnPrice.fr3');
  exit;

  LoadReportFromFile('PrintMovement_Quality', ReportPath + '\�������� ����\PrintMovement_Quality.fr3');

  LoadReportFromFile('PrintMovement_Quality32049199', ReportPath + '\�������� ����\PrintMovement_Quality32049199.fr3');

  LoadReportFromFile('PrintMovement_Quality32049199_2393', ReportPath + '\�������� ����\PrintMovement_Quality32049199_2393.fr3');
  exit;

  LoadReportFromFile('PrintMovement_Quality32294926', ReportPath + '\�������� ����\PrintMovement_Quality32294926.fr3');
  exit;

  LoadReportFromFile('PrintMovement_ReturnInAkt', ReportPath + '\�������� ����\PrintMovement_ReturnInAkt.fr3');
  exit;

  LoadReportFromFile('PrintMovement_ReturnIn', ReportPath + '\�������� ����\PrintMovement_ReturnIn.fr3');
  LoadReportFromFile('PrintMovement_ReturnIn32049199', ReportPath + '\�������� ����\PrintMovement_ReturnIn32049199.fr3');
  LoadReportFromFile('PrintMovement_ReturnIn32516492', ReportPath + '\�������� ����\PrintMovement_ReturnIn32516492.fr3');
  LoadReportFromFile('PrintMovement_ReturnIn35442481', ReportPath + '\�������� ����\PrintMovement_ReturnIn35442481.fr3');


  LoadReportFromFile('PrintMovement_ReturnInDay', ReportPath + '\�������� ����\PrintMovement_ReturnInDay.fr3');
  exit;

  LoadReportFromFile('PrintMovement_ReturnIn_corr', ReportPath + '\�������� ����\PrintMovement_ReturnIn_corr.fr3');
  exit;

  LoadReportFromFile('PrintMovement_PriceCorrective35442481', ReportPath + '\�������� ����\PrintMovement_PriceCorrective35442481.fr3');
  LoadReportFromFile('PrintMovement_PriceCorrective32049199', ReportPath + '\�������� ����\PrintMovement_PriceCorrective32049199.fr3');
  LoadReportFromFile('PrintMovement_Tax', ReportPath + '\�������� ����\PrintMovement_Tax.fr3');
  LoadReportFromFile('PrintMovement_Tax1214', ReportPath + '\�������� ����\PrintMovement_Tax1214.fr3');
  LoadReportFromFile('PrintMovement_Tax0115', ReportPath + '\�������� ����\PrintMovement_Tax0115.fr3');
  LoadReportFromFile('PrintMovement_Tax0416', ReportPath + '\�������� ����\PrintMovement_Tax0416.fr3');

  LoadReportFromFile('PrintMovement_Tax0317', ReportPath + '\�������� ����\PrintMovement_Tax0317.fr3');
  LoadReportFromFile('PrintMovement_Tax1218', ReportPath + '\�������� ����\PrintMovement_Tax1218.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective1218', ReportPath + '\�������� ����\PrintMovement_TaxCorrective1218.fr3');

  LoadReportFromFile('PrintMovement_Tax160321', ReportPath + '\�������� ����\PrintMovement_Tax160321.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective160321', ReportPath + '\�������� ����\PrintMovement_TaxCorrective160321.fr3');
  exit;

  LoadReportFromFile('PrintMovement_Tax010423', ReportPath + '\�������� ����\PrintMovement_Tax010423.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective010423', ReportPath + '\�������� ����\PrintMovement_TaxCorrective010423.fr3');
  exit;

  LoadReportFromFile('PrintMovement_Tax010823', ReportPath + '\�������� ����\PrintMovement_Tax010823.fr3');

  LoadReportFromFile('PrintMovement_TaxCorrective010823', ReportPath + '\�������� ����\PrintMovement_TaxCorrective010823.fr3');
  exit;

  LoadReportFromFile('PrintMovement_Tax170222', ReportPath + '\�������� ����\PrintMovement_Tax170222.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective170222', ReportPath + '\�������� ����\PrintMovement_TaxCorrective170222.fr3');
  exit;

  LoadReportFromFile('PrintMovement_Tax011024', ReportPath + '\�������� ����\PrintMovement_Tax011024.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective011024', ReportPath + '\�������� ����\PrintMovement_TaxCorrective011024.fr3');
  exit;

  LoadReportFromFile('PrintMovement_Tax0321', ReportPath + '\�������� ����\PrintMovement_Tax0321.fr3');
  exit;

  LoadReportFromFile('PrintMovement_TaxCorrective', ReportPath + '\�������� ����\PrintMovement_TaxCorrective.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective1214', ReportPath + '\�������� ����\PrintMovement_TaxCorrective1214.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective0115', ReportPath + '\�������� ����\PrintMovement_TaxCorrective0115.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrective0416', ReportPath + '\�������� ����\PrintMovement_TaxCorrective0416.fr3');

  LoadReportFromFile('PrintMovement_TaxCorrective0317', ReportPath + '\�������� ����\PrintMovement_TaxCorrective0317.fr3');

  LoadReportFromFile('PrintMovement_Bill', ReportPath + '\�������� ����\PrintMovement_Bill.fr3');

    LoadReportFromFile('PrintMovement_Bill_WithVAT', ReportPath + '\�������� ����\PrintMovement_Bill_WithVAT.fr3');
    exit;

  LoadReportFromFile('PrintMovement_TaxCorrective0321', ReportPath + '\�������� ����\PrintMovement_TaxCorrective0321.fr3');
    exit;

  LoadReportFromFile('PrintMovement_Bill01074874', ReportPath + '\�������� ����\PrintMovement_Bill01074874.fr3');
  LoadReportFromFile('PrintMovement_TaxCorrectiveReestr', ReportPath + '\�������� ����\PrintMovement_TaxCorrectiveReestr.fr3');


  LoadReportFromFile('PrintMovement_TTN_43233918', ReportPath + '\�������� ����\PrintMovement_TTN_43233918.fr3');
  exit;
  }
  LoadReportFromFile('PrintMovement_TTN_03012025', ReportPath + '\�������� ����\PrintMovement_TTN_03012025.fr3');
  LoadReportFromFile('PrintMovement_TTN_43233918_03012025', ReportPath + '\�������� ����\PrintMovement_TTN_43233918_03012025.fr3');
  exit;
  {
  LoadReportFromFile('PrintMovement_TTN_071021', ReportPath + '\�������� ����\PrintMovement_TTN_071021.fr3');

  LoadReportFromFile('PrintMovement_TTN', ReportPath + '\�������� ����\PrintMovement_TTN.fr3');
  exit;

  LoadReportFromFile('PrintMovement_SalePackGross', ReportPath + '\�������� ����\PrintMovement_SalePackGross.fr3');
  exit;

  LoadReportFromFile('PrintMovement_SalePack21', ReportPath + '\�������� ����\PrintMovement_SalePack21.fr3');

  LoadReportFromFile('PrintMovement_Sale32294926', ReportPath + '\�������� ����\PrintMovement_Sale32294926.fr3');
  exit;

  LoadReportFromFile('PrintMovement_Sale32490244', ReportPath + '\�������� ����\PrintMovement_Sale32490244.fr3');
   exit;

  LoadReportFromFile('PrintMovement_SalePack22', ReportPath + '\�������� ����\PrintMovement_SalePack22.fr3');

  LoadReportFromFile('PrintMovement_ReturnIn_By_TaxCorrective', ReportPath + '\�������� ����\PrintMovement_ReturnIn_By_TaxCorrective.fr3');

  LoadReportFromFile('PrintMovement_OrderIncomeSnab', ReportPath + '\�������� ����\PrintMovement_OrderIncomeSnab.fr3');
  exit;

  LoadReportFromFile('PrintMovement_OrderExternal', ReportPath + '\�������� ����\PrintMovement_OrderExternal.fr3');

  LoadReportFromFile('PrintMovement_OrderExternal_Cell', ReportPath + '\�������� ����\PrintMovement_OrderExternal_Cell.fr3');
  exit;

  LoadReportFromFile('PrintMovement_OrderExternalQty', ReportPath + '\�������� ����\PrintMovement_OrderExternalQty.fr3');


  LoadReportFromFile('PrintMovement_Loss', ReportPath + '\�������� ����\PrintMovement_Loss.fr3');
  exit;
  LoadReportFromFile('PrintMovement_Income', ReportPath + '\�������� ����\PrintMovement_Income.fr3');
  LoadReportFromFile('PrintMovement_IncomeAsset', ReportPath + '\�������� ����\PrintMovement_IncomeAsset.fr3');
  LoadReportFromFile('PrintMovement_IncomeFuel', ReportPath + '\�������� ����\PrintMovement_IncomeFuel.fr3');

  LoadReportFromFile('PrintMovement_ReturnOut', ReportPath + '\�������� ����\PrintMovement_ReturnOut.fr3');

  LoadReportFromFile('PrintMovement_Send', ReportPath + '\�������� ����\PrintMovement_Send.fr3');
  exit;

  LoadReportFromFile('PrintMovement_Inventory', ReportPath + '\�������� ����\PrintMovement_Inventory.fr3');

  LoadReportFromFile('PrintMovement_Sale_Order', ReportPath + '\�������� ����\PrintMovement_Sale_Order.fr3');
  exit;

  LoadReportFromFile('PrintMovement_ProductionUnion', ReportPath + '\�������� ����\PrintMovement_ProductionUnion.fr3');
  exit;
  }
  LoadReportFromFile('PrintMovement_PersonalServiceGrid', ReportPath + '\��������\PrintMovement_PersonalServiceGrid.fr3');
  exit;

  LoadReportFromFile('PrintMovement_PersonalServiceNum', ReportPath + '\��������\PrintMovement_PersonalServiceNum.fr3');
  exit;
  LoadReportFromFile('PrintMovement_PersonalService', ReportPath + '\��������\PrintMovement_PersonalService.fr3');
  exit;
  {
  LoadReportFromFile('PrintMovement_PersonalServiceDetail', ReportPath + '\��������\PrintMovement_PersonalServiceDetail.fr3');
  exit;

  LoadReportFromFile('����������7', ReportPath + '\������(�������)\����������7.fr3');

  LoadReportFromFile('����������7 �����', ReportPath + '\������(�������)\����������7 �����.fr3');

  LoadReportFromFile('����������1', ReportPath + '\������(�������)\����������1.fr3');
  LoadReportFromFile('����������1_test', ReportPath + '\������(�������)\����������1_test.fr3');
  exit;

  LoadReportFromFile('����� �������', ReportPath + '\������(�������)\����� �������.fr3');
  exit;

  LoadReportFromFile('PrintObjectHistory_PriceListItem', ReportPath + '\�����������\PrintObjectHistory_PriceListItem.fr3');

  LoadReportFromFile('PrintMovement_SaleJuridicalInvoice', ReportPath + '\�������� ����\PrintMovement_SaleJuridicalInvoice.fr3');

  TStrArrAdd(['35275230','30982361','30487219','37910513','32294926','01074874','32516492','35442481','36387249'
             ,'32049199', '31929492', '22447463', '36003603', '39118745', '2902403938', '32294926']);
  for i := Low(OKPO) to High(OKPO) do
    LoadReportFromFile('PrintMovement_Sale' + OKPO[i], ReportPath + '\�������� ����\PrintMovement_Sale' + OKPO[i] + '.fr3');
  exit;

  LoadReportFromFile('PrintMovement_Transport', ReportPath + '\�������� ����\PrintMovement_Transport.fr3');

  TStrArrAdd(['32516492','39135315','32049199','36003603','36387249', '36387233', '38916558' ]);
  for i := Low(OKPO) to High(OKPO) do
    LoadReportFromFile('PrintMovement_Transport' + OKPO[i], ReportPath + '\�������� ����\PrintMovement_Transport' + OKPO[i] + '.fr3');

  TStrArrAdd(['01074874','31929492']);
  for i := Low(OKPO) to High(OKPO) do
    LoadReportFromFile('PrintMovement_Sale' + OKPO[i], ReportPath + '\�������� ����\PrintMovement_Sale' + OKPO[i] + '.fr3');
}
  TStrArrAdd(['41750857']);
  for i := Low(OKPO) to High(OKPO) do
    LoadReportFromFile('PrintMovement_Sale' + OKPO[i], ReportPath + '\�������� ����\PrintMovement_Sale' + OKPO[i] + '.fr3');

end;

procedure TLoadReportTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', 'asdasxq1', gc_User);
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
