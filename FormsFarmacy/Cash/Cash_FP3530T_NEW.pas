unit Cash_FP3530T_NEW;

interface
uses Windows, CashInterface, FP3141_TLB;
type
  TCashFP3530T_NEW = class(TInterfacedObject, ICash)
  private
    FAlwaysSold: boolean;
    FPrintSumma: boolean;
    FPrinter: IFiscPRN;
    FisFiscal: boolean;
    FLengNoFiscalText : integer;
    FSumma : Currency;
    procedure SetAlwaysSold(Value: boolean);
    function GetAlwaysSold: boolean;
  protected
    function SoldCode(const GoodsCode: integer; const Amount: double; const Price: double = 0.00): boolean;
    function SoldFromPC(const GoodsCode: integer; const GoodsName, UKTZED: string; const Amount, Price, NDS: double): boolean; //������� � ����������
    function ChangePrice(const GoodsCode: integer; const Price: double): boolean;
    function OpenReceipt(const isFiscal: boolean = true; const isPrintSumma: boolean = false; const isReturn: boolean = False): boolean;
    function CloseReceipt: boolean;
    function CloseReceiptEx(out CheckId: String): boolean;
    function GetLastCheckId: Integer;
    function CashInputOutput(const Summa: double): boolean;
    function ProgrammingGoods(const GoodsCode: integer; const GoodsName: string; const Price, NDS: double): boolean;
    function ClosureFiscal: boolean;
    function TotalSumm(Summ, SummAdd: double; PaidType: TPaidType): boolean;
    function DiscountGoods(Summ: double): boolean;
    function DeleteArticules(const GoodsCode: integer): boolean;
    function XReport: boolean;
    function GetLastErrorCode: integer;
    function GetArticulInfo(const GoodsCode: integer; var ArticulInfo: WideString): boolean;
    function PrintNotFiscalText(const PrintText: WideString): boolean;
    function PrintFiscalText(const PrintText: WideString): boolean;
    function SubTotal(isPrint, isDisplay: WordBool; Percent, Disc: Double): boolean;
    function PrintFiscalMemoryByNum(inStart, inEnd: Integer): boolean;
    function PrintFiscalMemoryByDate(inStart, inEnd: TDateTime): boolean;
    function PrintReportByDate(inStart, inEnd: TDateTime): boolean;
    function PrintZeroReceipt: boolean;
    function PrintReportByNum(inStart, inEnd: Integer): boolean;
    function FiscalNumber:String;
    function SerialNumber:String;
    procedure ClearArticulAttachment;
    procedure SetTime;
    function GetTime : TDateTime;
    procedure Anulirovt;
    function InfoZReport : string;
    function JuridicalName : string;
    function ZReport : Integer;
    function SummaReceipt : Currency;
    function GetTaxRate : string;
    function SensZReportBefore : boolean;
    function SummaCash : Currency;
    function SummaCard : Currency;
    function ReceiptsSales : Integer;
    function ReceiptsReturn : Integer;
  public
    constructor Create;
  end;



implementation
uses Forms, SysUtils, Dialogs, Math, Variants, StrUtils, IniUtils, RegularExpressions, Log, UnitGetCash;

function �����������(k: string): boolean;
begin
  result := (k = '$0000') or (k = '');
  if result then
     exit;

  if (k='$0101') then begin Add_Log_RRO('$0101 ������ ��������');  exit;  end; //257
  if (k='$0201') then begin Add_Log_RRO('$0201 ������ RAM'); exit; end;//
  if (k='$0301') then begin Add_Log_RRO('$0301 ������ ����������� ����� ������ ��������'); exit; end; ///
  if (k='$0401') then begin Add_Log_RRO('$0401 ������ flash ������. ��� ����������� ������� � Flash ������.');  exit; end; //
  if (k='$0501') then begin Add_Log_RRO('$0501 ������ �������(������� �� ��������� � ������������)');  exit; end; //
  if (k='$0601') then begin Add_Log_RRO('$0601 ������ �����, ���������� ��������������� �����');  exit; end; //
  if (k='$0701') then begin Add_Log_RRO('$0701 ������ �������� ���������� ��������� ������� (�������� �������� ����).');  exit; end; //
  if (k='$0801') then begin Add_Log_RRO('$0801 SIM: ����� ������������. ��������� ������ ��� �������������� microSD ��������.');  exit; end; //
  if (k='$0901') then begin Add_Log_RRO('$0901 MMC: ����� ������������. ��������� ������ ��� �������������� microSD ��������.');  exit; end; //
  if (k='$0A01') then begin Add_Log_RRO('$0A01 ������ ���������� ������� �������� ������ �� ��������.');  exit; end; //
  if (k='$0002') then begin Add_Log_RRO('$0002 ��� ����� ������� � ����� ����� (�������� ������� ������ �������� ������ ������������ � ��)');  exit; end; 	  //
  if (k='$0102') then begin Add_Log_RRO('$0102 ������ ������� �� �������������� � ������ ������ ������������.');  exit; end; 	  //
  if (k='$0202') then begin Add_Log_RRO('$0202 � ��������� ��� ������)');  exit; end; 	  //
  if (k='$0302') then begin Add_Log_RRO('$0302 ������������ ������ ���������/�����������');  exit; end; 	  //
  if (k='$0402') then begin Add_Log_RRO('$0402 ������ ������ ������ ��������������� ������� ��������.');  exit; end; 	  //

   //0xNN03	������ ���� �������, ��� NN -���������� ����� ��������� ����
  if Copy(k, 3, 2) = '03'	then begin Add_Log_RRO('������ ���� �������, ��� NN -���������� ����� ��������� ���� (' + Copy(k, 1, 2) + ')');  exit; end;
   //0xNN04	�������� ���� ������� �� ��������, ��� NN -���������� ����� ��������� ����
  if Copy(k, 3, 2) = '04'	then begin Add_Log_RRO('�������� ���� ������� �� ��������, ��� NN -���������� ����� ��������� ���� (' + Copy(k, 1, 2) + ')');  exit; end;

   //0xXX05 ������ ��
  if (k='$0005')	then begin Add_Log_RRO('$0005 ��� ���������� ����� ��� ������ � ��');   exit; end;  //
  if (k='$0105')	then begin Add_Log_RRO('$0105 ������ ������ � ��');  exit; end;  //
  if (k='$0205')	then begin Add_Log_RRO('$0205 ��������� ����� ������������');    exit; end;//
  if (k='$0305')	then begin Add_Log_RRO('$0305 ���� ��������� ������ � �� ����� �������, ��� ��, ��� �������� ����������');  exit; end; //
  if (k='$0405')	then begin Add_Log_RRO('$0405 ������ �������� �� ������� �����');  exit; end; //
  if (k='$0505')	then begin Add_Log_RRO('$0505 ���� ������ � ��');  exit; end; //
  if (k='$0605')	then begin Add_Log_RRO('$0605 ���������� ������ ���������(������ ���������) ����� ���� ������ � ������������� ��������������� ��������� ����� (���������� ��������� ���������� ��������������� ��������� �����).');  exit; end; //
  if (k='$0705')	then begin Add_Log_RRO('$0705 ���� �� � ���������� ������');  exit; end; //
  if (k='$0805')	then begin Add_Log_RRO('$0805 ���� � ����� �� ���� ����������� � ������� ���������� ���������� ��������� ���');  exit; end; //
  if (k='$0905')	then begin Add_Log_RRO('$0905 � ������ ����� ������ ����� 24� �����. ���������� ��������� Z-�����.');  exit; end; //
  if (k='$0A05')	then begin Add_Log_RRO('$0A05 ���������� ��������������� �����. ���������� ������� �����.');  exit; end; //
  if (k='$0B05')	then begin Add_Log_RRO('$0B05 ������ � ������� ��������� ������');  exit; end; //
  if (k='$0C05')	then begin Add_Log_RRO('$0C05 ������ � ������� ����');  exit; end; //
  if (k='$0D05')	then begin Add_Log_RRO('$0D05 ������ � ������� �������');  exit; end; //
  if (k='$0E05')	then begin Add_Log_RRO('$0E05 ����� ��� �������� ���������� ������ ��������');  exit; end; //
  if (k='$0F05')	then begin Add_Log_RRO('$0F05 ���� �� ������������ ������� ��������� � ������� 72 ����� ��� �����');  exit; end; //

  if (k='$0006')	then begin Add_Log_RRO('$0006 �������� ������');  exit; end; //

   //0xXX07 ������ ������
  if (k='$0007')	then begin Add_Log_RRO('$0007 �������� ����� �������� (���������). ������� ����� ���� ��������� ������ � ��������� ������.');  exit; end; 	//
  if (k='$0107')	then begin Add_Log_RRO('$0107 � ������ ��������� ����� �� ���������. (��������, ��������� ��������� �������������� ��������� ����������� �����).');   exit; end; 	//
  if (k='$0207')	then begin Add_Log_RRO('$0207 ���������� ��������� ����������� ����� (��������/�����������).');   exit; end; 	//
  if (k='$0307')	then begin Add_Log_RRO('$0307 ������� ��������� � ���������� ������.');   exit; end; 	//
  if (k='$0407')	then begin Add_Log_RRO('$0407 ����� ������� �� �� ��������. (��������, ��������� ��������� �������������� ��������� ����������� �����).');   exit; end; 	//
  if (k='$0507')	then begin Add_Log_RRO('$0507 �������������� �� ���������.');   exit; end; 	//
  if (k='$0607')	then begin Add_Log_RRO('$0607 �� ��� ������ �������� �������� ����� ������ ��������� �������.');   exit; end; 	//
  if (k='$0707')	then begin Add_Log_RRO('$0707 ������ ����������� �� �� ������������. ��������� ���� ��������� ��.');   exit; end; 	//
  if (k='$0907')	then begin Add_Log_RRO('$0907 �������� ���� ��������� ������.');   exit; end; 	//
  if (k='$0A07')	then begin Add_Log_RRO('$0A07 ��������� ������ �� �����������.');   exit; end; 	//
  if (k='$0D07')	then begin Add_Log_RRO('$0D07 �������� ����������. ����������� �������������� ������� �� ������ �����.');   exit; end; 	//

  if (k='$0008')	then begin Add_Log_RRO('$0008 ����������� �������������� ������������.'); 	 exit; end; //

  if (k='$0009')	then begin Add_Log_RRO('$0009 �� �������. ��������, ������� �������� ������������������� ������������ � �� ����� ���� ������� �� ��������� ����� (������ Z-������).'); 	 exit; end;   //
  if (k='$0109')	then begin Add_Log_RRO('$0109 ������/������ �� ��������������������� ���������'); 	 exit; end;   //
  if (k='$0209')	then begin Add_Log_RRO('$0209 �����/�������� �� ��������� ����.'); 	 exit; end;   //
  if (k='$0309')	then begin Add_Log_RRO('$0309 ������� ������������� �����'); 	 exit; end;   //
  if (k='$0409')	then begin Add_Log_RRO('$0409 ������ ������'); 	 exit; end;   //

   //0xXX0A ������ ��� ������ � ����� �������
  if (k='$000A')	then begin Add_Log_RRO('$000A ������������ ���������� ����� ��� ���������� �������');  exit; end; //
  if (k='$010A')	then begin Add_Log_RRO('$010A ����� ������ ������ ��������� (>255)'); 	 exit; end;//
  if (k='$020A')	then begin Add_Log_RRO('$020A ������� � ������ ����� �� ������');  exit; end; 	  //
  if (k='$030A')	then begin Add_Log_RRO('$030A ������ �� ��������� ����');  exit; end; 	 //
  if (k='$040A')	then begin Add_Log_RRO('$040A �������/����� � ������ ����� ����������');  exit; end; 	  //
  if (k='$050A')	then begin Add_Log_RRO('$050A ����� ��������. ��������� �������� ������������ ���������������� ������� ��������� ������.');  exit; end; 	//
  if (k='$060A')	then begin Add_Log_RRO('$060A ������ �� ��������� ������ �� ����.');  exit; end; 	//
  if (k='$070A')	then begin Add_Log_RRO('$070A ������������� ������ ���� ������ ���������.');  exit; end; 	//

   //0��X0B ������ ��� ������ � �������� ������ //
  if (k='$000B')	then begin Add_Log_RRO('$000B �������� ��������� ��������� ����������� ������� �������� ������� ��������, ��� ����������� ������� ��������� ������� ��� ���������������� �������� ����.');  exit; end; 	//
  if (k='$010B')	then begin Add_Log_RRO('$010B ������������ ���������� ����� ��� ���������� �������');  exit; end; //
  if (k='$020B')	then begin Add_Log_RRO('$020B ����������� ��� ������ �������');  exit; end; 	  //
  if (k='$030B')	then begin Add_Log_RRO('$030B ���������: �� ����� ���������� � ������ ��������');  exit; end;  //
  if (k='$040B')	then begin Add_Log_RRO('$040B ���������: ������ �������� � ���� �� �������');  exit; end; 	  //
  if (k='$050B')	then begin Add_Log_RRO('$050B ���������: ������������������ ��������');  exit; end; //
  if (k='$060B')	then begin Add_Log_RRO('$060B ������������ ������'); 	 exit; end;//
  if (k='$070B')	then begin Add_Log_RRO('$070B ����� �������� ����� ����������'); 	 exit; end;//
  if (k='$080B')	then begin Add_Log_RRO('$080B ������������ ���������� ��� ���������� ��������'); 	 exit; end;   //
  if (k='$090B')	then begin Add_Log_RRO('$090B ������ ����� ������ � ���� ���� ���������'); 	 exit; end;  //
  if (k='$0A0B')	then begin Add_Log_RRO('$0A0B ������ ����� � ������ ����� ������ (� ������ ���� ����) ���������');  exit; end; 	//
  if (k='$0B0B')	then begin Add_Log_RRO('$0B0B �������� ������ ����� �� �������');  exit; end; 	  //
  if (k='$0C0B')	then begin Add_Log_RRO('$0C0B ������������ ����� �� ����');  exit; end; 	  //
  if (k='$0D0B')	then begin Add_Log_RRO('$0D0B ������������ �� �������');  exit; end; 	  //
  if (k='$0E0B')	then begin Add_Log_RRO('$0E0B ����� �� ������� ������'); 	 exit; end;  //
  if (k='$0F0B')	then begin Add_Log_RRO('$0F0B �������: ������ � ����������'); 	 exit; end;  //
  if (k='$100B')	then begin Add_Log_RRO('$100B �������: ������ � ����'); 	 exit; end;  //
  if (k='$110B')	then begin Add_Log_RRO('$110B ���������: ��������� ������������������ �������������'); 	 exit; end;  //
  if (k='$120B')	then begin Add_Log_RRO('$120B �������: ���������� ������������ ���������� ������� � ����(����������� ��������� ��� �������)'); 	 exit; end;  //
  if (k='$130B')	then begin Add_Log_RRO('$130B �������� ������������� ������� ����������� � ������������ ����������� ���������, � ��� �������� �� ��������� � ����������� ������������ (FP-320). ��. ��������� ���� ������.'); 	 exit; end;  //

   //0��X0C
  if (k='$00C0')	then begin Add_Log_RRO('$00C0 �TMPBuff: �� ������������� ���������');   exit; end; 	  //
  if (k='$01C0')	then begin Add_Log_RRO('$01C0 TMPBuff: ������ �� ������� � ����� ������������');   exit; end;
  if (k='$02C0')	then begin Add_Log_RRO('$02C0 TMPBuff: �� ��������� ������');   exit; end;

  //0��XD0
  if (k='$00D0')	then begin Add_Log_RRO('$00D0 SIM: ������������ ������� ���������� ����');   exit; end; 	  //
  if (k='$01D0')	then begin Add_Log_RRO('$01D0 SIM: ������� �� ���������');   exit; end; 	  //
  if (k='$02D0')	then begin Add_Log_RRO('$02D0 SIM: ������� �������� ���� �� ������������� ������������ � ��');   exit; end; 	  //
  if (k='$03D0')	then begin Add_Log_RRO('$03D0 SIM: ������ ��������� �����');   exit; end; 	  //
  if (k='$04D0')	then begin Add_Log_RRO('$04D0 SIM: ID_DEV �� ����������');   exit; end; 	  //
  if (k='$05D0')	then begin Add_Log_RRO('$05D0 SIM: �������� ��������� �����');   exit; end; 	  //
  if (k='$06D0')	then begin Add_Log_RRO('$06D0 SIM: ������ ������������');   exit; end; 	  //
  if (k='$07D0')	then begin Add_Log_RRO('$07D0 SIM: ������ ������� XML');   exit; end; 	  //
  if (k='$08D0')	then begin Add_Log_RRO('$08D0 SIM: ������ ������ �����');   exit; end; 	  //
  if (k='$09D0')	then begin Add_Log_RRO('$09D0 SIM: �������� ���������');   exit; end; 	  //
  if (k='$0AD0')	then begin Add_Log_RRO('$0AD0 SIM: �������� �������');   exit; end; 	  //
  if (k='$0BD0')	then begin Add_Log_RRO('$0BD0 SIM: �������� ������ ���������');   exit; end; 	  //
  if (k='$0CD0')	then begin Add_Log_RRO('$0CD0 SIM: ����� ��������� �������� �� ��������. ���� �������� ������.');   exit; end; 	  //

  //0��XD1
  if (k='$00D1')	then begin Add_Log_RRO('$00D1 MMC: �������� ���������� �������������');   exit; end; 	  //
  if (k='$01D1')	then begin Add_Log_RRO('$01D1 MMC: ������������ ���������� ����� ��� ���������� �������');   exit; end; 	  //
  if (k='$02D1')	then begin Add_Log_RRO('$02D1 MMC: ������ �������� �����, ���� � ����� ������ ��� ����������');   exit; end; 	  //
  if (k='$03D1')	then begin Add_Log_RRO('$03D1 MMC: ������ ������ �����, ����������� ������ �� ������ ������ ������������ ������� �����');   exit; end; 	  //
  if (k='$04D1')	then begin Add_Log_RRO('$04D1 MMC: ������� ���������� �������� � �������� ������');   exit; end; 	  //
  if (k='$05D1')	then begin Add_Log_RRO('$05D1 MMC: ������ �������� ����� - �� ������ ���� ��� ����������');   exit; end; 	  //
  if (k='$06D1')	then begin Add_Log_RRO('$06D1 MMC: AccessMode');   exit; end; 	  //
  if (k='$07D1')	then begin Add_Log_RRO('$07D1 MMC: rErrSD_PathLength');   exit; end; 	  //
  if (k='$08D1')	then begin Add_Log_RRO('$08D1 MMC: ������ ��������/�������� �����');   exit; end; 	  //
  if (k='$09D1')	then begin Add_Log_RRO('$09D1 MMC: ������ ������ �����');   exit; end; 	  //
  if (k='$0AD1')	then begin Add_Log_RRO('$0AD1 MMC: ���������� ���������� � ������ ������� (������ ������������� �������� ����).');   exit; end; 	  //
  if (k='$0BD1')	then begin Add_Log_RRO('$0BD1 MMC: ������ � ������� ����. ���������� ���������� � ������ �������');   exit; end; 	  //

  //0��XF0
  if (k='$00F0')	then begin Add_Log_RRO('$00F0 �������: ���������');   exit; end; 	  //
  if (k='$01F0')	then begin Add_Log_RRO('$01F0 �������: ��� ������');   exit; end; 	  //
  if (k='$02F0')	then begin Add_Log_RRO('$02F0 �������: ����� ������');   exit; end; 	  //
  if (k='$03F0')	then begin Add_Log_RRO('$03F0 �������: ������������');   exit; end; 	  //
  if (k='$04F0')	then begin Add_Log_RRO('$04F0 �������: ������� � ������');   exit; end; 	  //
  if (k='$05F0')	then begin Add_Log_RRO('$05F0 DBF: ������ ����� �������');   exit; end; 	  //
  if (k='$06F0')	then begin Add_Log_RRO('$06F0 DBF: ���������� ����� ������ �������������');   exit; end; 	  //
  if (k='$07F0')	then begin Add_Log_RRO('$07F0 DBF: ��������� � �������������� ������');   exit; end; 	  //
  if (k='$08F0')	then begin Add_Log_RRO('$08F0 DBF: ������������ ��� ����');   exit; end; 	  //
  if (k='$09F0')	then begin Add_Log_RRO('$09F0 DBF: �������� �������� � ����');   exit; end; 	  //
  if (k='$0AF0')	then begin Add_Log_RRO('$0AF0 DBF: �������� ��� ������ �� ������');   exit; end; 	  //
  if (k='$0BF0')	then begin Add_Log_RRO('$0BF0 DBF: ���� �� �������');   exit; end; 	  //

  //0��XF1
  if (k='$00F1')	then begin Add_Log_RRO('$00F1 ������ �����: �������� �� ���������');   exit; end; 	  //
  if (k='$01F1')	then begin Add_Log_RRO('$01F1 ������ �����: ������ ��������');   exit; end; 	  //
  if (k='$02F1')	then begin Add_Log_RRO('$02F1 �������� �������������');   exit; end; 	  //

  Add_Log_RRO(k + ' ������������������� ������!!! ��������� � �������������')
end;

const

  Password = '000000';

{ TCashFP3530T_NEW }
constructor TCashFP3530T_NEW.Create;
begin
  inherited Create;
  FAlwaysSold:=false;
  FPrintSumma:=False;
  FLengNoFiscalText := 35;
  FPrinter := CoFiscPrn.Create;
  FPrinter.SETCOMPORT[StrToInt(iniPortNumber), StrToInt(iniPortSpeed)];
  �����������(FPrinter.GETERROR);

end;

function TCashFP3530T_NEW.CloseReceipt: boolean;
begin
  result := false;

  FPrinter.CLOSECHECK[1, Password];
  result := �����������(FPrinter.GETERROR)
end;

function TCashFP3530T_NEW.CloseReceiptEx(out CheckId: String): boolean;
begin
  result := false;
  FPrinter.CLOSEFISKCHECK[1, Password];
  result := �����������(FPrinter.GETERROR);
  CheckId := IntToStr(FPrinter.COUNTERSDAY[3, Password]);
end;

function TCashFP3530T_NEW.GetLastCheckId: Integer;
begin
  Result := FPrinter.COUNTERSDAY[3, Password];
end;

function TCashFP3530T_NEW.GetAlwaysSold: boolean;
begin
  result:= FAlwaysSold;
end;

function TCashFP3530T_NEW.OpenReceipt(const isFiscal: boolean = true; const isPrintSumma: boolean = false; const isReturn: boolean = False): boolean;
begin
  FisFiscal := isFiscal;
  FPrintSumma := isPrintSumma;
  FSumma := 0;
  if FisFiscal then
  begin
     if isReturn then
       FPrinter.OPENFISKCHECK[1, 1, 1, Password]
     else FPrinter.OPENFISKCHECK[1, 1, 0, Password];
  end
  else
     FPrinter.OPENCHECK[Password];
  result := �����������(FPrinter.GETERROR)
end;

procedure TCashFP3530T_NEW.SetAlwaysSold(Value: boolean);
begin
  FAlwaysSold:= Value
end;

procedure TCashFP3530T_NEW.SetTime;
begin
  FPrinter.SETDT['', Password];
  �����������(FPrinter.GETERROR)
end;

function TCashFP3530T_NEW.GetTime : TDateTime;
var S : String;
begin
  S := FPrinter.RETDT[1, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  S := S + ' ' + FPrinter.RETDT[0, Password];
  if not �����������(FPrinter.GETERROR) then Exit;

  S := COPY(S, 1, 2) + FormatSettings.DateSeparator + COPY(S, 3, 2) +  FormatSettings.DateSeparator + '20' + COPY(S, 5, 2) + ' ' + COPY(S, 8, 2) +  FormatSettings.TimeSeparator + COPY(S, 10, 2);
  Result := StrToDateTime(S);
end;


function TCashFP3530T_NEW.SoldCode(const GoodsCode: integer;
  const Amount: double; const Price: double = 0.00): boolean;
begin
  Logger.AddToLog(' SALE (GoodsCode := ' + IntToStr(GoodsCode) + ', Amount := ' + ReplaceStr(FormatFloat('0.000', Amount), FormatSettings.DecimalSeparator, '.') +
      ', Price := ' + ReplaceStr(FormatFloat('0.00', Price), FormatSettings.DecimalSeparator, '.') + ', Password := ' + Password);
  FPrinter.SALE[GoodsCode, ReplaceStr(FormatFloat('0.000', Amount), FormatSettings.DecimalSeparator, '.'), ReplaceStr(FormatFloat('0.00', Price), FormatSettings.DecimalSeparator, '.') , Password];
  result := �����������(FPrinter.GETERROR)
end;

function TCashFP3530T_NEW.SoldFromPC(const GoodsCode: integer; const GoodsName, UKTZED: string; const Amount, Price, NDS: double): boolean;
var NDSType: char;
    CashCode: integer;
    I : Integer;
    L : string;
    N : string;
    Res: TArray<string>;
begin
  result := true;

  // ������ ������������� ����
  if not FisFiscal then
  begin

    L := '';
    Res := TRegEx.Split(StringReplace(UKTZED + IfThen(UKTZED = '', '' , ' ') + GoodsName, '%', '����.', [rfReplaceAll, rfIgnoreCase]), ' ');
    for I := 0 to High(Res) do
    begin
      if L <> '' then L := L + ' ';
      L := L + Res[i];
      if I < High(Res) then N := ' ' + Res[i + 1] else N := '';
      if Length(L + N) > FLengNoFiscalText then
      begin
        if not PrintNotFiscalText(L) then Exit;
        L := '';
      end;
      if I = High(Res) then
      begin
        if FPrintSumma then
        begin
          if L <> '' then if not PrintNotFiscalText(L) then Exit;
          L := FormatCurr('0.000', Amount) + ' x ' + FormatCurr('0.00', Price);
          L := L + StringOfChar(' ' , FLengNoFiscalText - Length(L + FormatCurr('0.00', RoundTo(Amount * Price, -1))) - 1) + FormatCurr('0.00', RoundTo(Amount * Price, -1));
          if not PrintNotFiscalText(L) then Exit;
          FSumma := FSumma + RoundTo(Amount * Price, -1);
        end else
        begin
          if (Length(L + FormatCurr('0.000', Amount)) + 3) >= FLengNoFiscalText then
          begin
            if not PrintNotFiscalText(L) then Exit;;
            L := StringOfChar(' ' , FLengNoFiscalText - Length(FormatCurr('0.000', Amount)) - 1) + FormatCurr('0.000', Amount);
            if not PrintNotFiscalText(L) then Exit;
          end else
          begin
            L := L + StringOfChar(' ' , FLengNoFiscalText - Length(L + FormatCurr('0.000', Amount)) - 1) + FormatCurr('0.000', Amount);
            if not PrintNotFiscalText(L) then Exit;
          end;
        end;
      end;
    end;

    Exit;
  end;

  if FAlwaysSold then exit;
  ProgrammingGoods(GoodsCode, Copy(UKTZED + IfThen(UKTZED = '', '' , ' ') + GoodsName, 1, 40) , Price, NDS);
  result := SoldCode(GoodsCode, Amount, Price);
end;

function TCashFP3530T_NEW.ProgrammingGoods(const GoodsCode: integer;
  const GoodsName: string; const Price, NDS: double): boolean;
var NDSType: Integer;
begin//  if NDS = 0 then NDSType := 1 .033.+else NDSType := 0;

  if NDS = 20 then NDSType := 0
  else if NDS =  0 then NDSType := 2
  else NDSType := 1;

  // ���������������� ��������
  Logger.AddToLog(' WRITEARTICLE (GoodsCode := ' + IntToStr(GoodsCode) +
                 ', GoodsName := ' + GoodsName +
                 ', NDSType := ' + IntToStr(NDSType) +
                 ', Password := ' + Password);
  FPrinter.WRITEARTICLE[GoodsCode, GoodsName, NDSType, 1, 1, '.', Password];

  result := �����������(FPrinter.GETERROR)
end;

procedure TCashFP3530T_NEW.Anulirovt;
begin
  FPrinter.ANULIROVT[0, Password];
  �����������(FPrinter.GETERROR)
end;

function TCashFP3530T_NEW.CashInputOutput(const Summa: double): boolean;
begin
  FPrinter.MONEY[1, ReplaceStr(FormatFloat('0.00', Summa), FormatSettings.DecimalSeparator, '.'), Password];
  result := �����������(FPrinter.GETERROR)
end;

function TCashFP3530T_NEW.TotalSumm(Summ, SummAdd: double; PaidType: TPaidType): boolean;
  var L : string;
begin
  if FisFiscal then
  begin
    if PaidType=ptMoney then
      FPrinter.PAYMENT[0, ReplaceStr(FormatFloat('0.00', Summ), FormatSettings.DecimalSeparator, '.'), Password]
    else FPrinter.PAYMENT[1, ReplaceStr(FormatFloat('0.00', Summ), FormatSettings.DecimalSeparator, '.'), Password];
    result := �����������(FPrinter.GETERROR);

    if result and (PaidType=ptCardAdd) and (SummAdd <> 0) then
    begin
      FPrinter.PAYMENT[0, ReplaceStr(FormatFloat('0.00', SummAdd), FormatSettings.DecimalSeparator, '.'), Password];
      result := �����������(FPrinter.GETERROR);
    end;

  end else
  begin
    if not FisFiscal and FPrintSumma then
    begin
      if not PrintNotFiscalText(StringOfChar('-' , FLengNoFiscalText)) then Exit;
      L := '����';
      L := L + StringOfChar(' ' , FLengNoFiscalText - Length(L + FormatCurr('0.00', FSumma)) - 1) + FormatCurr('0.00', FSumma);
      if not PrintNotFiscalText(L) then Exit;
    end;

    result := True;
  end;
end;

function TCashFP3530T_NEW.DiscountGoods(Summ: double): boolean;
begin
  if FisFiscal then
  begin
    FPrinter.DISCOUNT[ReplaceStr(FormatFloat('0.00', Summ), FormatSettings.DecimalSeparator, '.'), Password];
    result := �����������(FPrinter.GETERROR);
  end else
  begin
    if Summ > 0 then
    begin
      if not PrintNotFiscalText('�������' + StringOfChar(' ' , FLengNoFiscalText - Length('�������' + FormatCurr('0.00', Abs(Summ))) - 1) + FormatCurr('0.00', Abs(Summ))) then Exit;
    end else if not PrintNotFiscalText('������' + StringOfChar(' ' , FLengNoFiscalText - Length('������' + FormatCurr('0.00', Abs(Summ))) - 1) + FormatCurr('0.00', Abs(Summ))) then Exit;
    FSumma := FSumma + Summ;
    result := True;
  end;
end;

function TCashFP3530T_NEW.ClosureFiscal: boolean;
begin
  FPrinter.ZREPORT[Password];
  result := �����������(FPrinter.GETERROR)
end;

function TCashFP3530T_NEW.DeleteArticules(const GoodsCode: integer): boolean;
begin
end;

function TCashFP3530T_NEW.FiscalNumber: String;
begin
  Result := FPrinter.FNUM[Password];
end;

function TCashFP3530T_NEW.SerialNumber:String;
begin
  Result := FPrinter.ZNUM[Password];
end;

function TCashFP3530T_NEW.XReport: boolean;
begin
  FPrinter.XREPORT[Password];
  result := �����������(FPrinter.GETERROR)
end;

function TCashFP3530T_NEW.ChangePrice(const GoodsCode: integer;
  const Price: double): boolean;
begin
end;

function TCashFP3530T_NEW.GetLastErrorCode: integer;
begin
  //result:= status
end;

function TCashFP3530T_NEW.GetArticulInfo(const GoodsCode: integer;
  var ArticulInfo: WideString): boolean;
var i: integer;
begin
end;

function TCashFP3530T_NEW.PrintNotFiscalText(
  const PrintText: WideString): boolean;
begin
  FPrinter.PRNCHECK[PrintText, Password];
  result := �����������(FPrinter.GETERROR)
end;

function TCashFP3530T_NEW.PrintFiscalText(
  const PrintText: WideString): boolean;
var I : Integer;
    L : string;
    N : string;
    Res: TArray<string>;
begin
  Result := True;
  if POS(#13, PrintText) > 0 then
  begin
    Res := TRegEx.Split(StringReplace(PrintText, #10, '', [rfReplaceAll]), #13);
    for I := 0 to High(Res) do
    begin
      PrintFiscalText(Res[i])
    end;
  end else
  begin
    L := '';
    Res := TRegEx.Split(PrintText, ' ');
    for I := 0 to High(Res) do
    begin
      if L <> '' then L := L + ' ';
      L := L + Res[i];
      if I < High(Res) then N := ' ' + Res[i + 1] else N := '';
      if Length(L + N) > FLengNoFiscalText then
      begin
        if not PrintNotFiscalText(L) then Exit;
        L := '';
      end;
    end;
    if L <> '' then PrintNotFiscalText(L);
  end;
end;

function TCashFP3530T_NEW.SubTotal(isPrint, isDisplay: WordBool; Percent,
  Disc: Double): boolean;
begin
  if FisFiscal then
  begin
    FPrinter.PRNTOTAL[1, Password];
    result := �����������(FPrinter.GETERROR);

    if result and (Disc <> 0) then
    begin
      FPrinter.DISCOUNTTOTAL[ReplaceStr(FormatFloat('0.00', Disc), FormatSettings.DecimalSeparator, '.'), Password];
      result := �����������(FPrinter.GETERROR);
    end;
  end else result := True;
end;


function TCashFP3530T_NEW.PrintFiscalMemoryByDate(inStart,
  inEnd: TDateTime): boolean;
var StartStr, EndStr: string;
begin

end;

function TCashFP3530T_NEW.PrintFiscalMemoryByNum(inStart,
  inEnd: Integer): boolean;
begin

end;

function TCashFP3530T_NEW.PrintReportByDate(inStart,
  inEnd: TDateTime): boolean;
begin

end;

function TCashFP3530T_NEW.PrintZeroReceipt: boolean;
begin
  OpenReceipt;
  SubTotal(true, true, 0, 0);
  TotalSumm(0, 0, ptMoney);
  CloseReceipt;
end;

function TCashFP3530T_NEW.PrintReportByNum(inStart, inEnd: Integer): boolean;
begin

end;

procedure TCashFP3530T_NEW.ClearArticulAttachment;
begin
end;

function TCashFP3530T_NEW.InfoZReport : string;
  var I : integer; S : String;
      nSum : array [0..5] of Currency;
      nTotal : Currency;

  function Centr(AStr : string) : String;
  begin
    if Length(AStr) > 40 then
      Result := Copy(AStr, 1, 40) + #13#10 + Centr(Copy(AStr, 41, Length(AStr)))
    else if Length(AStr) = 40 then Result := AStr
    else Result := StringOfChar(' ', (40 - Length(AStr)) div 2) + AStr;
  end;

  function Str(ACur : Currency; AL : integer) : String;
  begin
    Result := FormatCurr('0.00', ACur);
    if AL > Length(Result) then Result := StringOfChar(' ', AL - Length(Result)) + Result;
    Result := StringReplace(Result, FormatSettings.DecimalSeparator, '.', [rfReplaceAll])
  end;

begin
  Result := '';

  for I := 0 to 9 do
  begin
    S := Trim(FPrinter.READPROGCHECK[I, 1, Password]);
    if not �����������(FPrinter.GETERROR) then Exit;
    if Trim(S) <> ';0' then Result := Result + Centr(S) + #13#10;
  end;

  S := '�� ' + FPrinter. ZNUM[Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  S := S + '  �� ' + FPrinter.FNUM[Password] + #13#10;
  if not �����������(FPrinter.GETERROR) then Exit;
  Result := Result + Centr(S) + #13#10;

  S := '           Z-��� N ' + IntToStr(FPrinter.COUNTERSDAY[0, Password]);
  if not �����������(FPrinter.GETERROR) then Exit;
  Result := Result + S + #13#10;

  Result := Result + '              �������' + #13#10;
  Result := Result + '  ------      ����������    ������' + #13#10;

  S := FPrinter.SUMDAY[2, 0, 0, 1, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[0]) then nSum[0] := 0;

  S := FPrinter.SUMDAY[2, 1, 0, 1, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[1]) then nSum[1] := 0;

  S := FPrinter.SUMDAY[2, 0, 0, 2, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[2]) then nSum[2] := 0;

  S := FPrinter.SUMDAY[2, 1, 0, 2, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[3]) then nSum[3] := 0;

  Result := Result + '  ������  ' + Str(nSum[2], 13) + Str(nSum[0], 13) + #13#10;
  Result := Result + '  ������   ' + Str(nSum[3], 13) + Str(nSum[1], 13) + #13#10;
  Result := Result + '  ������   ' + Str(nSum[2] + nSum[3], 13) + Str(nSum[0] + nSum[1], 13) + #13#10;

  nTotal := nSum[0] + nSum[1];

  S := FPrinter.SUMDAY[3, 1, 0, 2, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[0]) then nSum[0] := 0;

  S := FPrinter.SUMDAY[3, 1, 0, 1, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[1]) then nSum[1] := 0;

  S := FPrinter.SUMDAY[3, 0, 0, 1, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[2]) then nSum[2] := 0;

  Result := Result + '  ------         ������     ������'#13#10;
  Result := Result + '  ������  ' + Str(-nSum[0], 13) + Str(nSum[1], 13) + #13#10;
  Result := Result + '  ������ � ���        ' + Str(nSum[2], 13) + #13#10;

  for I := 1 to 10 do
  begin

    S := FPrinter.SUMDAY[0, 0, 0, 1, Password];
    if not �����������(FPrinter.GETERROR) then Exit;
    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[0]) then nSum[0] := 0;

    S := FPrinter.SUMDAY[0, 1 , 0, 1, Password];
    if not �����������(FPrinter.GETERROR) then Exit;
    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[1]) then nSum[1] := 0;

    S := FPrinter.SUMDAY[0, 2 , 0, 1, Password];
    if not �����������(FPrinter.GETERROR) then Exit;
    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[2]) then nSum[2] := 0;

    S := FPrinter.SUMDAY[1, 0, 0, 1, Password];
    if not �����������(FPrinter.GETERROR) then Exit;
    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[3]) then nSum[3] := 0;

    S := FPrinter.SUMDAY[1, 1 , 0, 1, Password];
    if not �����������(FPrinter.GETERROR) then Exit;
    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[4]) then nSum[4] := 0;

    S := FPrinter.SUMDAY[1, 2 , 0, 1, Password];
    if not �����������(FPrinter.GETERROR) then Exit;
    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[5]) then nSum[5] := 0;

    if nTotal = (nSum[0] + nSum[1] + nSum[2]) then Break;
  end;

  Result := Result + '  ------        �������       ���' + #13#10;
  Result := Result + '  ���. �   ' + Str(nSum[3], 13) + Str(nSum[0], 13) + #13#10;
  Result := Result + '  ���. �   ' + Str(nSum[4], 13) + Str(nSum[1], 13) + #13#10;
  Result := Result + '  ���. �   ' + Str(nSum[5], 13) + Str(nSum[2], 13) + #13#10;
  Result := Result + '  ���� ������� ' + IntToStr(FPrinter.COUNTERSDAY[1, Password]) + #13#10;
  if not �����������(FPrinter.GETERROR) then Exit;

  S := FPrinter.SUMDAY[0, 0, 0, 2, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[0]) then nSum[0] := 0;

  S := FPrinter.SUMDAY[0, 1 , 0, 2, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[1]) then nSum[1] := 0;

  S := FPrinter.SUMDAY[0, 2 , 0, 2, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[2]) then nSum[2] := 0;

  S := FPrinter.SUMDAY[1, 0, 0, 2, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[3]) then nSum[3] := 0;

  S := FPrinter.SUMDAY[1, 1, 0, 2, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[4]) then nSum[4] := 0;

  S := FPrinter.SUMDAY[1, 2, 0, 2, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[5]) then nSum[5] := 0;

  Result := Result + '  ²�. A   ' + Str(nSum[3], 13) + Str(nSum[0], 13) + #13#10;
  Result := Result + '  ²�. �   ' + Str(nSum[4], 13) + Str(nSum[1], 13) + #13#10;
  Result := Result + '  ²�. �   ' + Str(nSum[5], 13) + Str(nSum[2], 13) + #13#10;
  Result := Result + '  ���� ���������� ' + IntToStr(FPrinter.COUNTERSDAY[2, Password]) + #13#10;
  if not �����������(FPrinter.GETERROR) then Exit;

  S := FPrinter.READTAXRATE[0, 2, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[0]) then nSum[0] := 0;

  S := FPrinter.READTAXRATE[1, 2, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[1]) then nSum[1] := 0;

  S := FPrinter.READTAXRATE[2, 2, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[2]) then nSum[2] := 0;

  Result := Result + '  �������     ��        10.10.2017' + #13#10;
  Result := Result + '            ���_A (���) A =    ' + Str(nSum[0], 6) + '%' + #13#10;
  Result := Result + '            ���_� (���) � =    ' + Str(nSum[1], 6) + '%' + #13#10;
  Result := Result + '            ���_� (���) � =    ' + Str(nSum[2], 6) + '%' + #13#10;

  S := FPrinter.RETDT[1, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  S := S + '  ' + FPrinter.RETDT[0, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  S := COPY(S, 1, 2) + '.' + COPY(S, 3, 2) +  '.20' + COPY(S, 5, 6) +  ':' + COPY(S, 11, 2);

  Result := Result + '                    ' + S  + #13#10;
  Result := Result + '         Բ�������� ���' + #13#10;
  Result := Result + '  --------------------------------------' + #13#10;
  Result := Result + '  --------------------------------------' + #13#10;

end;

function TCashFP3530T_NEW.JuridicalName : string;
begin
  Result := Trim(FPrinter.READPROGCHECK[0, 1, Password]);
  if not �����������(FPrinter.GETERROR) then Exit;
end;

function TCashFP3530T_NEW.ZReport : Integer;
begin
  Result := FPrinter.COUNTERSDAY[0, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
end;

function TCashFP3530T_NEW.SummaReceipt : Currency;
  var nSum : Currency;
begin
  Result := 0;
  if TryStrToCurr(Trim(StringReplace(FPrinter.SUMCHEQUE[3, 1, Password], '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum) then Result := Result + nSum;
  if not �����������(FPrinter.GETERROR) then Exit;
end;

function TCashFP3530T_NEW.GetTaxRate : string;
  var I : Integer; S : string; C : Currency;
  const TaxName : String = '����';
begin
  Result := '';

  for I := 0 to 3 do
  begin
    S := FPrinter.READTAXRATE[I, 2, Password];
    if not �����������(FPrinter.GETERROR) then Exit;
    if TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), C) then
    begin
      if Result <> '' then Result := Result + '; ';
      Result := Result + TaxName[I + 1] + ' ' + FormatCurr('0.00', C) + '%';
    end;
  end;

end;

function TCashFP3530T_NEW.SensZReportBefore : boolean;
begin
  Result := True;
end;

function TCashFP3530T_NEW.SummaCash : Currency;
  var S : string; nSum : Currency;
begin
  Result := 0;

  S := FPrinter.SUMDAY[2, 0, 0, 1, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum) then Result := nSum;

  S := FPrinter.SUMDAY[2, 0, 0, 2, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum) then Result := Result - Abs(nSum);
end;

function TCashFP3530T_NEW.SummaCard : Currency;
  var S : string; nSum : Currency;
begin
  Result := 0;

  S := FPrinter.SUMDAY[2, 1, 0, 1, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum) then Result := nSum;

  S := FPrinter.SUMDAY[2, 1, 0, 2, Password];
  if not �����������(FPrinter.GETERROR) then Exit;
  if TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum) then Result := Result - Abs(nSum);
end;

function TCashFP3530T_NEW.ReceiptsSales : Integer;
begin
  Result := FPrinter.COUNTERSDAY[1, Password];
end;

function TCashFP3530T_NEW.ReceiptsReturn : Integer;
begin
  Result := FPrinter.COUNTERSDAY[2, Password];
end;

end.


(*

int CALLBACK  PrintFiscalMemoryByNum(HWND hwnd,void (CALLBACK *Fn), LPARAM UI, LPSTR psw, int Start, int End)
������� ������ -
psw - ������ ��� ������ ������ (�������� 15)
Start - ��������� ����� Z-������ (4 �����)
End - �������� ����� Z-������ (4 �����)
�������� ������ - ���
� ������� ���� �������  ���������� ���������� �� ���������� ������ � Z-������� �� �������  (������ ������������� �����).



int CALLBACK  PrintFiscalMemoryByDate(HWND hwnd,void (CALLBACK *Fn), LPARAM UI, LPSTR psw, LPSTR Start,LPSTR End)
������� ������ -
psw - ������ ��� ������ ������ (�������� 15)
Start - ��������� ���� Z-������ (DDMMYY, �������� 100500)
End - �������� ���� Z-������ (DDMMYY)
� ������� ���� �������  ���������� ���������� �� ���������� ������ � Z-������� �� �����  (������ ������������� �����).


4Fh(79)
����������� ������������� ����� (�� ����) int
CALLBACK  PrintReportByDate(HWND hwnd,void (CALLBACK *Fn),LPARAM UI, LPSTR psw, LPSTR Start,LPSTR End)
������� ������ -
psw - ������ ��� ������ ������ (�������� 15)
Start - ��������� ���� - 6 ���� (DDMMYY)
End - �������� ���� - 6 ���� (DDMMYY)
�������� ������ - ���
� ������� ���� �������  ���������� ����������� ������������� ����� �� ��������� ������ �������.



int CALLBACK  PrintReportByNum(HWND hwnd,void (CALLBACK *Fn),LPARAM UI, LPSTR psw, int Start,int End)
������� ������ -
psw - ������ ��� ������ ������ (�������� 15)
Start - ��������� ����� Z-������ (4 �����)
End - �������� ����� Z-������ (4 �����)
�������� ������ - ���
� ������� ���� �������  ���������� ����������� ������������� ����� �� ��������� ���������� ������� Z-�������.






