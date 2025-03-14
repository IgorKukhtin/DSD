unit Cash_IKC_E810T;

interface
uses Windows, CashInterface, NeoFiscalPrinterDriver_TLB;
type
  TCashIKC_E810T = class(TInterfacedObject, ICash)
  private
    FAlwaysSold: boolean;
    FPrintSumma: boolean;
    FSumma : Currency;
    FPrinter: IICS_EP_11;
//    FModem: IICS_Modem;
    FisFiscal: boolean;
    FLengNoFiscalText : integer;
    FReturn: boolean;
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
    function PrintZeroReceipt: boolean;
    function PrintReportByDate(inStart, inEnd: TDateTime): boolean;
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
    function ShowError: boolean;
  end;



implementation
uses Forms, SysUtils, Dialogs, Math, Variants, StrUtils, IniUtils, RegularExpressions, Log;


const

  Password = 000000;

{ TCashIKC_E810T }
constructor TCashIKC_E810T.Create;
begin
  inherited Create;
  FAlwaysSold:=false;
  FPrintSumma:=False;
  FReturn:=False;
  FLengNoFiscalText := 37;
  FPrinter := CoFiscPrn.Create_EP_11;
  if FPrinter.FPInitialize = 0 then
  begin
    if not FPrinter.FPOpen(StrToInt(iniPortNumber), StrToInt(iniPortSpeed), 3, 3) then
    begin
      ShowError;
      Raise Exception.Create('');
    end;
  end else
  begin
    ShowMessage(SysErrorMessage(GetLastError));
    Raise Exception.Create('');
  end;

//  FModem := CoFiscPrn.CreateModem;
//  if FModem.ModemInitialize('COM' + iniPortNumber) <> 0 then
//  begin
//    ShowMessage(SysErrorMessage(GetLastError));
//    Raise Exception.Create('');
//  end;
end;


function TCashIKC_E810T.ShowError: boolean;
  var S : string;
begin
  Result := False;
  S := FPrinter.prGetErrorText;
  ShowMessage(S);
end;

function TCashIKC_E810T.CloseReceipt: boolean;
begin
  result := True;
end;

function TCashIKC_E810T.CloseReceiptEx(out CheckId: String): boolean;
begin
  result := True;
end;

function TCashIKC_E810T.GetLastCheckId: Integer;
begin
  Result := FPrinter.prKSEFPacket
end;

function TCashIKC_E810T.GetAlwaysSold: boolean;
begin
  result:= FAlwaysSold;
end;

function TCashIKC_E810T.OpenReceipt(const isFiscal: boolean = true; const isPrintSumma: boolean = false; const isReturn: boolean = False): boolean;
begin
  FisFiscal := isFiscal;
  FPrintSumma := isPrintSumma;
  FReturn := isReturn;
  FSumma := 0;
  result := True;
end;

procedure TCashIKC_E810T.SetAlwaysSold(Value: boolean);
begin
  FAlwaysSold:= Value
end;

procedure TCashIKC_E810T.SetTime;
begin
  FPrinter.FPSetCurrentDate(Date);
  if not FPrinter.FPSetCurrentTime(Now) then ShowError;
end;

function TCashIKC_E810T.GetTime : TDateTime;
begin
  FPrinter.FPGetCurrentDate;
  FPrinter.FPGetCurrentTime;

  Result := FPrinter.prCurrentDate +  FPrinter.prCurrentTime;
  if not FPrinter.FPSetCurrentTime(Now) then ShowError;
end;

function TCashIKC_E810T.SoldCode(const GoodsCode: integer;
  const Amount: double; const Price: double = 0.00): boolean;
begin
  result := False;
  ShowMessage('������. �������� SoldCode �� ���������.');
end;

function TCashIKC_E810T.SoldFromPC(const GoodsCode: integer; const GoodsName, UKTZED: string; const Amount, Price, NDS: double): boolean;
var NDSType: char;
    CashCode, nNDS: integer;
    I : Integer;
    L : string;
    Res: TArray<string>;
begin
  result := true;

    // ������ ������������� ����
  if not FisFiscal then
  begin

    L := '';
    Res := TRegEx.Split(UKTZED + IfThen(UKTZED = '', '' , ' ') + GoodsName, ' ');
    for I := 0 to High(Res) do
    begin
      if L <> '' then L := L + ' ';
      L := L + Res[i];
      if (I < High(Res)) and (Length(L + Res[i]) > FLengNoFiscalText) then
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
            if not PrintNotFiscalText(L) then Exit;
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

  if NDS = 20 then nNDS := 0
  else if NDS =  0 then nNDS := 2
  else nNDS := 1;

  Logger.AddToLog(' SALE (GoodsCode := ' + IntToStr(GoodsCode) + ', Amount := ' + ReplaceStr(FormatFloat('0.000', Amount), FormatSettings.DecimalSeparator, '.') +
      ', Price := ' + ReplaceStr(FormatFloat('0.00', Price), FormatSettings.DecimalSeparator, '.') + ')');
  if Amount = 1 then
    result := FPrinter.FPSaleItem(Round(Amount * 1000), 3, False, True, False, Round(Price * 100), nNDS, Copy(UKTZED + IfThen(UKTZED = '', '' , ' ') + GoodsName, 1, 75), GoodsCode)
  else result := FPrinter.FPSaleItem(Round(Amount * 1000), 3, False, False, False, Round(Price * 100), nNDS, Copy(UKTZED + IfThen(UKTZED = '', '' , ' ') + GoodsName, 1, 75), GoodsCode);

  if not result then ShowError;
end;

function TCashIKC_E810T.ProgrammingGoods(const GoodsCode: integer;
  const GoodsName: string; const Price, NDS: double): boolean;
begin
  result := False;
  ShowMessage('������. �������� SoldCode �� ���������.');
end;

procedure TCashIKC_E810T.Anulirovt;
begin
  if not FPrinter.FPAnnulReceipt then ShowError;
end;

function TCashIKC_E810T.CashInputOutput(const Summa: double): boolean;
begin
  if Summa > 0 then
    result := FPrinter.FPCashIn(Round(Summa * 100))
  else result := FPrinter.FPCashOut(Round(Abs(Summa) * 100));
  if not result then ShowError;
end;

function TCashIKC_E810T.TotalSumm(Summ, SummAdd: double; PaidType: TPaidType): boolean;
  var L : string;
begin
  result := True;

  if FisFiscal then
  begin

    if (PaidType=ptCardAdd) and (SummAdd <> 0) then
    begin
      result := FPrinter.FPPayment(4, Round(SummAdd * 100), False, True, '');
    end;

    if result then
    begin
      if PaidType=ptMoney then
      begin
        result := FPrinter.FPPayment(4, Round(Summ * 100), True, True, '');
      end else result := FPrinter.FPPayment(1, Round(Summ * 100), True, True, '');
    end;

   if not result then ShowError;
   if not result then FPrinter.FPAnnulReceipt;

  end else
  begin
    if FPrintSumma then
    begin
      if not PrintNotFiscalText(StringOfChar('-' , FLengNoFiscalText)) then Exit;
      L := '����';
      L := L + StringOfChar(' ' , FLengNoFiscalText - Length(L + FormatCurr('0.00', FSumma)) - 1) + FormatCurr('0.00', FSumma);
      if not PrintNotFiscalText(L) then Exit;
    end;

    FPrinter.FPCloseServiceReport;
  end;

end;

function TCashIKC_E810T.DiscountGoods(Summ: double): boolean;
begin
  if FisFiscal then
  begin
    if Summ > 0 then
      result := FPrinter.FPMakeMarkup(False, True, Round(Summ * 100), '')
    else result := FPrinter.FPMakeDiscount(False, True, Round(Abs(Summ) * 100), '');
    if not result then ShowError;
  end else result := True;
end;

function TCashIKC_E810T.ClosureFiscal: boolean;
begin
  result := FPrinter.FPMakeZReport(Password);
  if not result then ShowError;
end;

function TCashIKC_E810T.DeleteArticules(const GoodsCode: integer): boolean;
begin
end;

function TCashIKC_E810T.FiscalNumber: String;
begin
  if FPrinter.FPGetCurrentStatus then
    Result := FPrinter.prFiscalNumber
  else ShowError;
end;

function TCashIKC_E810T.SerialNumber:String;
begin
  if FPrinter.FPGetCurrentStatus then
    Result := FPrinter.prSerialNumber
  else ShowError;
end;

function TCashIKC_E810T.XReport: boolean;
begin
  result := FPrinter.FPMakeXReport(Password);
  if not result then ShowError;
end;

function TCashIKC_E810T.ChangePrice(const GoodsCode: integer;
  const Price: double): boolean;
begin
end;

function TCashIKC_E810T.GetLastErrorCode: integer;
begin
  //result:= status
end;

function TCashIKC_E810T.GetArticulInfo(const GoodsCode: integer;
  var ArticulInfo: WideString): boolean;
var i: integer;
begin
end;

function TCashIKC_E810T.PrintNotFiscalText(
  const PrintText: WideString): boolean;
begin
  result := FPrinter.FPPrintServiceReportByLine(PrintText);
  if not result then ShowError
end;

function TCashIKC_E810T.PrintFiscalText(
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
        if not FPrinter.FPCommentLine(L, True) then Exit;
        L := '';
      end;
    end;
    if L <> '' then FPrinter.FPCommentLine(L, True);
  end;
end;

function TCashIKC_E810T.SubTotal(isPrint, isDisplay: WordBool; Percent,
  Disc: Double): boolean;
begin
  result := True;
end;


function TCashIKC_E810T.PrintFiscalMemoryByDate(inStart,
  inEnd: TDateTime): boolean;
var StartStr, EndStr: string;
begin

end;

function TCashIKC_E810T.PrintFiscalMemoryByNum(inStart,
  inEnd: Integer): boolean;
begin

end;

function TCashIKC_E810T.PrintReportByDate(inStart,
  inEnd: TDateTime): boolean;
begin

end;

function TCashIKC_E810T.PrintReportByNum(inStart, inEnd: Integer): boolean;
begin

end;

function TCashIKC_E810T.PrintZeroReceipt: boolean;
begin
  result := FPrinter.FPPrintZeroReceipt;
  if not result then ShowError
end;


procedure TCashIKC_E810T.ClearArticulAttachment;
begin
end;

function TCashIKC_E810T.InfoZReport : string;
  var I : integer; S : String;

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

//  FModem.prKsefSavePath := 'd:\DSD\BIN\ZRepot';
//  FModem.ModemReadKsefByZReport(9);
//  if FModem.ModemFindPacket(15, 0, 0) then FModem.ModemReadKsefPacket(FModem.prFoundPacket);


  FPrinter.FPGetCurrentStatus;

  if FPrinter.prHeadLine1 <> '' then  Result := Result + Centr(FPrinter.prHeadLine1) + #13#10;
  if FPrinter.prHeadLine2 <> '' then  Result := Result + Centr(FPrinter.prHeadLine2) + #13#10;
  if FPrinter.prHeadLine3 <> '' then  Result := Result + Centr(FPrinter.prHeadLine3) + #13#10;

  S := '�� ' + FPrinter.prSerialNumber;
  S := S + '  �� ' + FPrinter.prFiscalNumber + #13#10;
  Result := Result + Centr(S) + #13#10;


  FPrinter.FPGetDayReportProperties;

  S := '           Z-��� N ' + IntToStr(FPrinter.prCurrentZReport);
  Result := Result + S + #13#10;

  Result := Result + '              �������' + #13#10;
  Result := Result + '  ------      ����������    ������' + #13#10;

  FPrinter.FPGetDayReportData;
  FPrinter.FPGetDaySumOfAddTaxes;
  FPrinter.FPGetCashDrawerSum;

  Result := Result + '  ������  ' + Str(FPrinter.prDayRefundSumOnPayForm4 / 100, 13) + Str(FPrinter.prDaySaleSumOnPayForm4 / 100, 13) + #13#10;
  Result := Result + '  ������   ' + Str(FPrinter.prDayRefundSumOnPayForm1 / 100, 13) + Str(FPrinter.prDaySaleSumOnPayForm1 / 100, 13) + #13#10;
  Result := Result + '  ������   ' + Str(FPrinter.prDayRefundSumOnPayForm10 / 100, 13) + Str(FPrinter.prDaySaleSumOnPayForm10 / 100, 13) + #13#10;


  Result := Result + '  ------         ������     ������'#13#10;
  Result := Result + '  ������  ' + Str(FPrinter.prDayCashOutSum / 100, 13) + Str(FPrinter.prDayCashInSum / 100, 13) + #13#10;
  Result := Result + '  ������ � ���        ' + Str(FPrinter.prCashDrawerSum / 100, 13) + #13#10;

  Result := Result + '  ------        �������       ���' + #13#10;
  Result := Result + '  ���. �   ' + Str(FPrinter.prDaySumAddTaxOfSale1 / 100, 13) + Str(FPrinter.prDaySaleSumOnTax1 / 100, 13) + #13#10;
  Result := Result + '  ���. �   ' + Str(FPrinter.prDaySumAddTaxOfSale2 / 100, 13) + Str(FPrinter.prDaySaleSumOnTax2 / 100, 13) + #13#10;
  Result := Result + '  ���. �   ' + Str(FPrinter.prDaySumAddTaxOfSale3 / 100, 13) + Str(FPrinter.prDaySaleSumOnTax3 / 100, 13) + #13#10;
  Result := Result + '  ���� ������� ' + IntToStr(FPrinter.prDaySaleReceiptsCount) + #13#10;

  Result := Result + '  ²�. A   ' + Str(FPrinter.prDaySumAddTaxOfRefund1 / 100, 13) + Str(FPrinter.prDayRefundSumOnTax1 / 100, 13) + #13#10;
  Result := Result + '  ²�. �   ' + Str(FPrinter.prDaySumAddTaxOfRefund2 / 100, 13) + Str(FPrinter.prDayRefundSumOnTax2 / 100, 13) + #13#10;
  Result := Result + '  ²�. �   ' + Str(FPrinter.prDaySumAddTaxOfRefund4 / 100, 13) + Str(FPrinter.prDayRefundSumOnTax3 / 100, 13) + #13#10;
  Result := Result + '  ���� ���������� ' + IntToStr(FPrinter.prDayRefundReceiptsCount) + #13#10;

  FPrinter.FPGetTaxRates;
  Result := Result + '  �������     ��        ' + FormatDateTime('dd.mm.yyyy', FPrinter.prTaxRatesDate) + #13#10;
  Result := Result + '            ���_A (���) A =    ' + Str(FPrinter.prTaxRate1 / 100, 6) + '%' + #13#10;
  Result := Result + '            ���_� (���) � =    ' + Str(FPrinter.prTaxRate2 / 100, 6) + '%' + #13#10;
  Result := Result + '            ���_� (���) � =    ' + Str(FPrinter.prTaxRate3 / 100, 6) + '%' + #13#10;

  FPrinter.FPGetCurrentDate;
  FPrinter.FPGetCurrentTime;

  S := FormatDateTime('dd.mm.yyyy', FPrinter.prCurrentDate) + '  ' + FormatDateTime('hh:nn', FPrinter.prCurrentTime);

  Result := Result + '                    ' + S  + #13#10;
  Result := Result + '         Բ�������� ���' + #13#10;
  Result := Result + '  --------------------------------------' + #13#10;
  Result := Result + '  --------------------------------------' + #13#10;

end;

function TCashIKC_E810T.JuridicalName : string;
begin
  if FPrinter.FPGetCurrentStatus then
    Result := FPrinter.prHeadLine1
  else ShowError;
end;

function TCashIKC_E810T.ZReport : Integer;
begin
  Result := 0;
  if FPrinter.FPGetDayReportProperties then Result := FPrinter.prCurrentZReport
  else ShowError;
end;

function TCashIKC_E810T.SummaReceipt : Currency;
begin
  Result := FPrinter.prSumTotal / 100;
end;

function TCashIKC_E810T.GetTaxRate : string;
begin
  Result := '';
  if not FPrinter.FPGetTaxRates then Exit;
  Result := Result + 'A =    ' + FormatCurr('0.00', FPrinter.prTaxRate1 / 100) + '%;';
  Result := Result + '� =    ' + FormatCurr('0.00', FPrinter.prTaxRate2 / 100) + '%;';
  Result := Result + '� =    ' + FormatCurr('0.00', FPrinter.prTaxRate3 / 100) + '%;';
  Result := Result + '� =    ' + FormatCurr('0.00', FPrinter.prTaxRate4 / 100) + '%;';
end;

function TCashIKC_E810T.SensZReportBefore : boolean;
begin
  Result := True;
end;

function TCashIKC_E810T.SummaCash : Currency;
begin
  FPrinter.FPGetDayReportData;
  Result := (FPrinter.prDaySaleSumOnPayForm4 - FPrinter.prDayRefundSumOnPayForm4) / 100;
end;

function TCashIKC_E810T.SummaCard : Currency;
begin
  FPrinter.FPGetDayReportData;
  Result := (FPrinter.prDaySaleSumOnPayForm1 - FPrinter.prDayRefundSumOnPayForm1) / 100;
end;

function TCashIKC_E810T.ReceiptsSales : Integer;
begin
  FPrinter.FPGetDayReportData;
  Result := FPrinter.prDaySaleReceiptsCount;
end;

function TCashIKC_E810T.ReceiptsReturn : Integer;
begin
  FPrinter.FPGetDayReportData;
  Result := FPrinter.prDayRefundReceiptsCount;
end;

end.

// FPGetCurrentReceiptData
