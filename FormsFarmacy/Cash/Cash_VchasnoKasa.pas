unit Cash_VchasnoKasa;

interface
uses Windows, VchasnoKasaAPI, CashInterface;
type

  TCashVchasnoKasa = class(TInterfacedObject, ICash)
  private
    FAlwaysSold: boolean;
    FPrintSumma: boolean;
    FPrinter: TVchasnoKasaAPI;
    FisFiscal: boolean;
    FLengNoFiscalText : integer;
    FSumma : Currency;
    procedure SetAlwaysSold(Value: boolean);
    function GetAlwaysSold: boolean;
  protected
    function SoldCode(const GoodsCode: integer; const Amount: double; const Price: double = 0.00): boolean;
    function SoldFromPC(const GoodsCode: integer; const GoodsName, UKTZED: string; const Amount, Price, NDS: double): boolean; //Продажа с компьютера
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
    destructor Destroy; override;
  end;



implementation
uses Forms, SysUtils, Dialogs, Math, Variants, StrUtils, IniUtils,
     RegularExpressions, Log;


{ TCashVchasnoKasa }
constructor TCashVchasnoKasa.Create;
begin
  inherited Create;
  FAlwaysSold:=false;
  FPrintSumma:=False;
  FLengNoFiscalText := 35;
  FPrinter := TVchasnoKasaAPI.Create;
  FPrinter.Init(6, iniVCBatchMode, iniVCURL, iniVCDevice_Name, iniVCAccess_Token);
end;

destructor TCashVchasnoKasa.Destroy;
begin
  FPrinter.Free;
end;

function TCashVchasnoKasa.CloseReceipt: boolean;
  var CheckId: String;
begin
  result := FPrinter.CloseReceip(CheckId);
end;

function TCashVchasnoKasa.CloseReceiptEx(out CheckId: String): boolean;
begin
  result := FPrinter.CloseReceip(CheckId);
end;

function TCashVchasnoKasa.GetLastCheckId: Integer;
begin
  Result := FPrinter.GetLastNumbersReceipt;
end;

function TCashVchasnoKasa.GetAlwaysSold: boolean;
begin
  result:= FAlwaysSold;
end;

function TCashVchasnoKasa.OpenReceipt(const isFiscal: boolean = true; const isPrintSumma: boolean = false; const isReturn: boolean = False): boolean;
begin
  Result:= False;
  FisFiscal := isFiscal;
  FPrintSumma := isPrintSumma;
  FSumma := 0;
  if FisFiscal then
     Result:= FPrinter.OpenReceipt(isReturn)
  else
     ShowMessage('Печать нефискальных чеков запрещена...');
end;

procedure TCashVchasnoKasa.SetAlwaysSold(Value: boolean);
begin
  FAlwaysSold:= Value
end;

procedure TCashVchasnoKasa.SetTime;
begin
  //  На сервере;
end;

function TCashVchasnoKasa.SoldCode(const GoodsCode: integer;
  const Amount: double; const Price: double = 0.00): boolean;
begin
  result := False;
end;

function TCashVchasnoKasa.SoldFromPC(const GoodsCode: integer; const GoodsName, UKTZED: string; const Amount, Price, NDS: double): boolean;
var NDSType: char;
    CashCode: integer;
    I : Integer;
    L : string;
    N : string;
    Res: TArray<string>;
begin

    // печать нефискального чека
  if not FisFiscal then
  begin

    L := '';
    Res := TRegEx.Split(StringReplace(UKTZED + IfThen(UKTZED = '', '' , ' ') + GoodsName, '%', 'проц.', [rfReplaceAll, rfIgnoreCase]), ' ');
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

    result := true;
    Exit;
  end;

  if FAlwaysSold then exit;
  Logger.AddToLog(' SALE (GoodsCode := ' + IntToStr(GoodsCode) + ', Amount := ' + ReplaceStr(FormatFloat('0.000', Amount), FormatSettings.DecimalSeparator, '.') +
      ', Price := ' + ReplaceStr(FormatFloat('0.00', Price), FormatSettings.DecimalSeparator, '.'));
  result := FPrinter.SoldFrom(GoodsCode, GoodsName, '', UKTZED, '', Amount, Price, NDS);
end;

function TCashVchasnoKasa.ProgrammingGoods(const GoodsCode: integer;
  const GoodsName: string; const Price, NDS: double): boolean;
begin
  Result := True;
end;

procedure TCashVchasnoKasa.Anulirovt;
begin
  FPrinter.AlwaysSold;
end;

function TCashVchasnoKasa.CashInputOutput(const Summa: double): boolean;
begin
  if Summa > 0 then Result := FPrinter.ServiceFee(Summa)
  else if Summa < 0 then Result := FPrinter.ServiceTakeaway(Abs(Summa))
  else Result := False;
end;

function TCashVchasnoKasa.TotalSumm(Summ, SummAdd: double; PaidType: TPaidType): boolean;
  var L : string;
begin
  if FisFiscal then
  begin
    if PaidType=ptMoney then
      result := FPrinter.TotalSumm(Summ, 0)
    else result := FPrinter.TotalSumm(Summ, 2);

    if result and (PaidType=ptCardAdd) and (SummAdd <> 0) then
    begin
      result := FPrinter.TotalSumm(SummAdd, 0);
    end;

  end else
  begin
    if not FisFiscal and FPrintSumma then
    begin
      if not PrintNotFiscalText(StringOfChar('-' , FLengNoFiscalText)) then Exit;
      L := 'СУМА';
      L := L + StringOfChar(' ' , FLengNoFiscalText - Length(L + FormatCurr('0.00', FSumma)) - 1) + FormatCurr('0.00', FSumma);
      if not PrintNotFiscalText(L) then Exit;
    end;

    result := True;
  end;
end;

function TCashVchasnoKasa.DiscountGoods(Summ: double): boolean;
begin
  if FisFiscal then
  begin
    result := FPrinter.DiscountGoods(Summ);
  end else
  begin
    if Summ > 0 then
    begin
      if not PrintNotFiscalText('Націнка' + StringOfChar(' ' , FLengNoFiscalText - Length('Націнка' + FormatCurr('0.00', Abs(Summ))) - 1) + FormatCurr('0.00', Abs(Summ))) then Exit;
    end else if not PrintNotFiscalText('Знижка' + StringOfChar(' ' , FLengNoFiscalText - Length('Знижка' + FormatCurr('0.00', Abs(Summ))) - 1) + FormatCurr('0.00', Abs(Summ))) then Exit;
    FSumma := FSumma + Summ;
  end;
  result := True;
end;

function TCashVchasnoKasa.ClosureFiscal: boolean;
begin
  result := FPrinter.ZReport;
end;

function TCashVchasnoKasa.DeleteArticules(const GoodsCode: integer): boolean;
begin
end;

function TCashVchasnoKasa.FiscalNumber: String;
begin
  Result := FPrinter.FiscalNumber;
end;

function TCashVchasnoKasa.SerialNumber:String;
begin
  Result := '';
end;

function TCashVchasnoKasa.XReport: boolean;
begin
  FPrinter.XReport;
end;

function TCashVchasnoKasa.ChangePrice(const GoodsCode: integer;
  const Price: double): boolean;
begin
end;

function TCashVchasnoKasa.GetLastErrorCode: integer;
begin
  //result:= status
end;

function TCashVchasnoKasa.GetArticulInfo(const GoodsCode: integer;
  var ArticulInfo: WideString): boolean;
var i: integer;
begin
end;

function TCashVchasnoKasa.PrintNotFiscalText(
  const PrintText: WideString): boolean;
begin
  FPrinter.PrintFiscalText(PrintText);
end;

function TCashVchasnoKasa.PrintFiscalText(
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

function TCashVchasnoKasa.SubTotal(isPrint, isDisplay: WordBool; Percent,
  Disc: Double): boolean;
begin
  result := True;
end;


function TCashVchasnoKasa.PrintFiscalMemoryByDate(inStart,
  inEnd: TDateTime): boolean;
var StartStr, EndStr: string;
begin

end;

function TCashVchasnoKasa.PrintFiscalMemoryByNum(inStart,
  inEnd: Integer): boolean;
begin

end;

function TCashVchasnoKasa.PrintReportByDate(inStart,
  inEnd: TDateTime): boolean;
begin

end;

function TCashVchasnoKasa.PrintZeroReceipt: boolean;
begin
  OpenReceipt;
  SubTotal(true, true, 0, 0);
  TotalSumm(0, 0, ptMoney);
  CloseReceipt;
end;

function TCashVchasnoKasa.PrintReportByNum(inStart, inEnd: Integer): boolean;
begin

end;

procedure TCashVchasnoKasa.ClearArticulAttachment;
begin
end;

function TCashVchasnoKasa.InfoZReport : string;
begin
  Result := FPrinter.GetLastZReport;
end;

function TCashVchasnoKasa.JuridicalName : string;
begin
  Result := FPrinter.GetName;
end;

function TCashVchasnoKasa.ZReport : Integer;
begin
  Result := FPrinter.GetZReport;
end;

function TCashVchasnoKasa.SummaReceipt : Currency;
begin
  Result := FPrinter.Summa;
end;

function TCashVchasnoKasa.GetTaxRate : string;
begin
  Result := '1 - 20%; 2 - Без ПДВ; 3 - 20% + 5%; 4 - 7%; 5 - 0%; 6 - Без ПДВ + 5%; 7 - Не є об`єктом ПДВ; 8 - 20% + 7,5%; 9 - 14%';
end;

function TCashVchasnoKasa.SensZReportBefore : boolean;
begin
  Result := False;
end;

function TCashVchasnoKasa.SummaCash : Currency;
begin
  Result := FPrinter.GetSummaCash;
end;

function TCashVchasnoKasa.SummaCard : Currency;
begin
  Result := FPrinter.GetSummaCard;
end;

function TCashVchasnoKasa.ReceiptsSales : Integer;
begin
  Result := FPrinter.GetReceiptsSales;
end;

function TCashVchasnoKasa.ReceiptsReturn : Integer;
begin
  Result := FPrinter.GetReceiptsReturn;
end;

end.

