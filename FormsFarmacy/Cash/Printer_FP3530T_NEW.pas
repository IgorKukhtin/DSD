unit Printer_FP3530T_NEW;

interface

uses Windows, PrinterInterface, FP3141_TLB;

type
  TPrinterFP3530T_NEW = class(TInterfacedObject, IPrinter)
  private
    FPrinter: IFiscPRN;
    FisFiscal: boolean;
    FLengNoFiscalText : integer;
  protected

    function OpenReceipt: boolean;
    function CloseReceipt: boolean;
    function PrintNotFiscalText(const PrintText: WideString): boolean;
    function PrintLine(const PrintText: WideString): boolean;
    function PrintSplitLine(const PrintText: WideString): boolean;
    function PrintText(const AText : WideString): boolean;
    function SerialNumber:String;
    procedure Anulirovt;

  public
    constructor Create;
    function LengNoFiscalText : integer;
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

  if (k='$0009')	then begin Add_Log_RRO('$0009 �� �������. ��������, ������� �������� ������������������� ������������ � �� ����� ���� ������ �� ��������� ����� (������ Z-������).'); 	 exit; end;   //
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

{ TPrinterFP3530T_NEW }
constructor TPrinterFP3530T_NEW.Create;
begin
  inherited Create;
  FLengNoFiscalText := 35;
  FPrinter := CoFiscPrn.Create;
  FPrinter.SETCOMPORT[StrToInt(iniPrinterPortNumber), StrToInt(iniPrinterPortSpeed)];
  �����������(FPrinter.GETERROR);
end;

function TPrinterFP3530T_NEW.OpenReceipt: boolean;
begin
  FPrinter.OPENCHECK[Password];
  result := �����������(FPrinter.GETERROR)
end;

function TPrinterFP3530T_NEW.CloseReceipt: boolean;
begin
  result := false;

  FPrinter.CLOSEFISKCHECK[1, Password];
  result := �����������(FPrinter.GETERROR)
end;

function TPrinterFP3530T_NEW.PrintNotFiscalText(const PrintText: WideString): boolean;
begin
  FPrinter.PRNCHECK[PrintText, Password];
  result := �����������(FPrinter.GETERROR)
end;

function TPrinterFP3530T_NEW.PrintSplitLine(const PrintText: WideString): boolean;
var I : Integer;
begin
  Result := False;
  I := 1;
  while COPY(PrintText, I, FLengNoFiscalText) <> '' do
  begin
    if not PrintNotFiscalText(COPY(PrintText, I, FLengNoFiscalText)) then Exit;
    I := I + FLengNoFiscalText;
  end;
  Result := True;
end;

function TPrinterFP3530T_NEW.PrintLine(const PrintText: WideString): boolean;
var I : Integer;
    L : WideString;
    N : WideString;
    Res: TArray<string>;
begin
  Result := False;
  L := '';
  Res := TRegEx.Split(PrintText, ' ');
  for I := 0 to High(Res) do
  begin
    if (Res[i] = '') or (L <> '') then L := L + ' ';
    if Res[i] <> '' then L := L + Res[i];
    if I < High(Res) then N := ' ' + Res[i + 1] else N := '';
    if Length(L + N) > FLengNoFiscalText then
    begin
      if not PrintSplitLine(L) then Exit;
      L := '';
    end;
  end;
  if L <> '' then if not PrintSplitLine(L) then Exit;
  Result := True;
end;

function TPrinterFP3530T_NEW.PrintText(const AText : WideString): boolean;
var I : Integer;
    Res: TArray<string>;
begin
  Result := False;
  try
    OpenReceipt;
    Res := TRegEx.Split(AText, #$D#$A);
    for I := 0 to High(Res) do
    begin
      if POS('https', Res[I]) = 0 then
        if not PrintLine(TrimRight(Res[I])) then Exit;
    end;
    Result := True;
  finally
    if Result then CloseReceipt
    else Anulirovt;
  end;
end;

function TPrinterFP3530T_NEW.SerialNumber:String;
begin
  Result := FPrinter.ZNUM[Password];
end;

procedure TPrinterFP3530T_NEW.Anulirovt;
begin
  try
    FPrinter.ANULIROVT[0, Password];
  except
  end;
end;

function TPrinterFP3530T_NEW.LengNoFiscalText : integer;
begin
  Result := FLengNoFiscalText;
end;

end.


