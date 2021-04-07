unit Cash_Emulation;

interface
uses Windows, CashInterface;
type

  TPrinterEmulation = class(TObject)
    FFiscal : Boolean;
    FReturn : Boolean;
    FSummaCheck : Currency;

    procedure Sale(AGoodsCode : Integer; AAmount, APrice : Currency);
    procedure OpenFiscCheck(AReturn : Boolean);
    procedure OpenCheck;
    procedure Discount(ASum : Currency);
  end;

  TCashEmulation = class(TInterfacedObject, ICash)
  private
    FAlwaysSold: boolean;
    FPrintSumma: boolean;
    FPrinter: TPrinterEmulation;
    FisFiscal: boolean;
    FLengNoFiscalText : integer;
    FSumma : Currency;
    procedure SetAlwaysSold(Value: boolean);
    function GetAlwaysSold: boolean;
  protected
    function SoldCode(const GoodsCode: integer; const Amount: double; const Price: double = 0.00): boolean;
    function SoldFromPC(const GoodsCode: integer; const GoodsName: string; const Amount, Price, NDS: double): boolean; //Продажа с компьютера
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
    function ReceiptsSales : Integer;
    function ReceiptsReturn : Integer;
  public
    constructor Create;
    destructor Destroy; override;
  end;



implementation
uses Forms, SysUtils, Dialogs, Math, Variants, StrUtils, IniUtils, RegularExpressions, Log;

{ TPrinterEmulation }
procedure TPrinterEmulation.Sale(AGoodsCode : Integer; AAmount, APrice : Currency);
begin
  if FReturn then FSummaCheck := FSummaCheck - RoundTo(AAmount * APrice, - 2)
  else FSummaCheck := FSummaCheck + RoundTo(AAmount * APrice, - 2);
end;

procedure TPrinterEmulation.OpenFiscCheck(AReturn : Boolean);
begin
  FSummaCheck := 0;
  FFiscal := True;
  FReturn := AReturn;
end;

procedure TPrinterEmulation.OpenCheck;
begin
  FSummaCheck := 0;
  FFiscal := False;
  FReturn := False;
end;

procedure TPrinterEmulation.Discount(ASum : Currency);
begin
  if FReturn then FSummaCheck := FSummaCheck - ASum
  else FSummaCheck := FSummaCheck + ASum;
end;

{ TCashEmulation }
constructor TCashEmulation.Create;
begin
  inherited Create;
  FAlwaysSold:=false;
  FPrintSumma:=False;
  FLengNoFiscalText := 35;
  FPrinter := TPrinterEmulation.Create;
//  FPrinter.SETCOMPORT[StrToInt(iniPortNumber), StrToInt(iniPortSpeed)];
end;

destructor TCashEmulation.Destroy;
begin
  FPrinter.Free;
end;

function TCashEmulation.CloseReceipt: boolean;
begin
  result := True;
  FPrinter.FSummaCheck := 0;

//  FPrinter.CLOSECHECK[1, Password];
end;

function TCashEmulation.CloseReceiptEx(out CheckId: String): boolean;
begin
  result := True;
  FPrinter.FSummaCheck := 0;
//  CheckId := FPrinter.CLOSEFISKCHECK[1, Password];
end;

function TCashEmulation.GetLastCheckId: Integer;
begin
  Result := 0;
end;

function TCashEmulation.GetAlwaysSold: boolean;
begin
  result:= FAlwaysSold;
end;

function TCashEmulation.OpenReceipt(const isFiscal: boolean = true; const isPrintSumma: boolean = false; const isReturn: boolean = False): boolean;
begin
  FisFiscal := isFiscal;
  FPrintSumma := isPrintSumma;
  FSumma := 0;
  if FisFiscal then
     FPrinter.OpenFiscCheck(isReturn)
  else
     FPrinter.OpenCheck;
  result:= True;
end;

procedure TCashEmulation.SetAlwaysSold(Value: boolean);
begin
  FAlwaysSold:= Value
end;

procedure TCashEmulation.SetTime;
begin
//  FPrinter.SETDT[FormatDateTime('DDMMYYHHNN', Now), Password];
end;

function TCashEmulation.SoldCode(const GoodsCode: integer;
  const Amount: double; const Price: double = 0.00): boolean;
begin
  Logger.AddToLog(' SALE (GoodsCode := ' + IntToStr(GoodsCode) + ', Amount := ' + ReplaceStr(FormatFloat('0.000', Amount), FormatSettings.DecimalSeparator, '.') +
      ', Price := ' + ReplaceStr(FormatFloat('0.00', Price), FormatSettings.DecimalSeparator, '.'));
  FPrinter.Sale(GoodsCode, RoundTo(Amount, - 3), RoundTo(Price, -2 ));
  result := true;
end;

function TCashEmulation.SoldFromPC(const GoodsCode: integer; const GoodsName: string; const Amount, Price, NDS: double): boolean;
var NDSType: char;
    CashCode: integer;
    I : Integer;
    L : string;
    N : string;
    Res: TArray<string>;
begin
  result := true;

    // печать нефискального чека
  if not FisFiscal then
  begin

    L := '';
    Res := TRegEx.Split(StringReplace(GoodsName, '%', 'проц.', [rfReplaceAll, rfIgnoreCase]), ' ');
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
  ProgrammingGoods(GoodsCode, Copy(GoodsName, 1, 40) , Price, NDS);
  result := SoldCode(GoodsCode, Amount, Price);
end;

function TCashEmulation.ProgrammingGoods(const GoodsCode: integer;
  const GoodsName: string; const Price, NDS: double): boolean;
var NDSType: Integer;
begin//  if NDS = 0 then NDSType := 1 .033.+else NDSType := 0;

  if NDS = 20 then NDSType := 0
  else if NDS =  0 then NDSType := 2
  else NDSType := 1;

  // программирование артикула
  Logger.AddToLog(' WRITEARTICLE (GoodsCode := ' + IntToStr(GoodsCode) +
                 ', GoodsName := ' + GoodsName +
                 ', NDSType := ' + IntToStr(NDSType));
//  FPrinter.WRITEARTICLE[GoodsCode, GoodsName, NDSType, 1, 1, '.', Password];

end;

procedure TCashEmulation.Anulirovt;
begin
  FPrinter.FSummaCheck := 0;
//  FPrinter.ANULIROVT[0, Password];
end;

function TCashEmulation.CashInputOutput(const Summa: double): boolean;
begin
//  FPrinter.MONEY[1, ReplaceStr(FormatFloat('0.00', Summa), FormatSettings.DecimalSeparator, '.'), Password];
end;

function TCashEmulation.TotalSumm(Summ, SummAdd: double; PaidType: TPaidType): boolean;
  var L : string;
begin
  if FisFiscal then
  begin
//    if PaidType=ptMoney then
//      FPrinter.PAYMENT[0, ReplaceStr(FormatFloat('0.00', Summ), FormatSettings.DecimalSeparator, '.'), Password]
//    else FPrinter.PAYMENT[1, ReplaceStr(FormatFloat('0.00', Summ), FormatSettings.DecimalSeparator, '.'), Password];
//
//    if result and (PaidType=ptCardAdd) and (SummAdd <> 0) then
//    begin
//      FPrinter.PAYMENT[0, ReplaceStr(FormatFloat('0.00', SummAdd), FormatSettings.DecimalSeparator, '.'), Password];
//    end;

    result := True;
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

function TCashEmulation.DiscountGoods(Summ: double): boolean;
begin
  if FisFiscal then
  begin
    FPrinter.Discount(RoundTo(Summ, - 2));
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

function TCashEmulation.ClosureFiscal: boolean;
begin
//  FPrinter.ZREPORT[Password];
end;

function TCashEmulation.DeleteArticules(const GoodsCode: integer): boolean;
begin
end;

function TCashEmulation.FiscalNumber: String;
begin
  Result := '3000007988';
end;

function TCashEmulation.SerialNumber:String;
begin
//  Result := FPrinter.ZNUM[Password];
end;

function TCashEmulation.XReport: boolean;
begin
//  FPrinter.XREPORT[Password];
end;

function TCashEmulation.ChangePrice(const GoodsCode: integer;
  const Price: double): boolean;
begin
end;

function TCashEmulation.GetLastErrorCode: integer;
begin
  //result:= status
end;

function TCashEmulation.GetArticulInfo(const GoodsCode: integer;
  var ArticulInfo: WideString): boolean;
var i: integer;
begin
end;

function TCashEmulation.PrintNotFiscalText(
  const PrintText: WideString): boolean;
begin
//  FPrinter.PRNCHECK[PrintText, Password];
end;

function TCashEmulation.PrintFiscalText(
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

function TCashEmulation.SubTotal(isPrint, isDisplay: WordBool; Percent,
  Disc: Double): boolean;
begin
  if FisFiscal then
  begin
//    FPrinter.PRNTOTAL[1, Password];

    if result and (Disc <> 0) then
    begin
//      FPrinter.DISCOUNTTOTAL[ReplaceStr(FormatFloat('0.00', Disc), FormatSettings.DecimalSeparator, '.'), Password];
    end;
    result := True;
  end else result := True;
end;


function TCashEmulation.PrintFiscalMemoryByDate(inStart,
  inEnd: TDateTime): boolean;
var StartStr, EndStr: string;
begin

end;

function TCashEmulation.PrintFiscalMemoryByNum(inStart,
  inEnd: Integer): boolean;
begin

end;

function TCashEmulation.PrintReportByDate(inStart,
  inEnd: TDateTime): boolean;
begin

end;

function TCashEmulation.PrintZeroReceipt: boolean;
begin
  OpenReceipt;
  SubTotal(true, true, 0, 0);
  TotalSumm(0, 0, ptMoney);
  CloseReceipt;
end;

function TCashEmulation.PrintReportByNum(inStart, inEnd: Integer): boolean;
begin

end;

procedure TCashEmulation.ClearArticulAttachment;
begin
end;

function TCashEmulation.InfoZReport : string;
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

//  for I := 0 to 9 do
//  begin
//    S := Trim(FPrinter.READPROGCHECK[I, 1, Password]);
//    if Trim(S) <> ';0' then Result := Result + Centr(S) + #13#10;
//  end;
//
//  S := 'ЗН ' + FPrinter. ZNUM[Password];
//  S := S + '  ФН ' + FPrinter.FNUM[Password] + #13#10;
//  Result := Result + Centr(S) + #13#10;
//
//  S := '           Z-звіт N ' + IntToStr(FPrinter.COUNTERSDAY[0, Password]);
//  Result := Result + S + #13#10;
//
//  Result := Result + '              ЗАГАЛОМ' + #13#10;
//  Result := Result + '  ------      Повернення    Продаж' + #13#10;
//
//  S := FPrinter.SUMDAY[2, 0, 0, 1, Password];
//  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[0]) then nSum[0] := 0;
//
//  S := FPrinter.SUMDAY[2, 1, 0, 1, Password];
//  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[1]) then nSum[1] := 0;
//
//  S := FPrinter.SUMDAY[2, 0, 0, 2, Password];
//  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[2]) then nSum[2] := 0;
//
//  S := FPrinter.SUMDAY[2, 1, 0, 2, Password];
//  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[3]) then nSum[3] := 0;
//
//  Result := Result + '  Готівка  ' + Str(nSum[2], 13) + Str(nSum[0], 13) + #13#10;
//  Result := Result + '  Картка   ' + Str(nSum[3], 13) + Str(nSum[1], 13) + #13#10;
//  Result := Result + '  ВСЬОГО   ' + Str(nSum[2] + nSum[3], 13) + Str(nSum[0] + nSum[1], 13) + #13#10;
//
//  nTotal := nSum[0] + nSum[1];
//
//  S := FPrinter.SUMDAY[3, 1, 0, 2, Password];
//  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[0]) then nSum[0] := 0;
//
//  S := FPrinter.SUMDAY[3, 1, 0, 1, Password];
//  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[1]) then nSum[1] := 0;
//
//  S := FPrinter.SUMDAY[3, 0, 0, 1, Password];
//  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[2]) then nSum[2] := 0;
//
//  Result := Result + '  ------         Видача     Внесок'#13#10;
//  Result := Result + '  Готівка  ' + Str(-nSum[0], 13) + Str(nSum[1], 13) + #13#10;
//  Result := Result + '  Готівка в касі        ' + Str(nSum[2], 13) + #13#10;
//
//  for I := 1 to 10 do
//  begin
//
//    S := FPrinter.SUMDAY[0, 0, 0, 1, Password];
//    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[0]) then nSum[0] := 0;
//
//    S := FPrinter.SUMDAY[0, 1 , 0, 1, Password];
//    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[1]) then nSum[1] := 0;
//
//    S := FPrinter.SUMDAY[0, 2 , 0, 1, Password];
//    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[2]) then nSum[2] := 0;
//
//    S := FPrinter.SUMDAY[1, 0, 0, 1, Password];
//    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[3]) then nSum[3] := 0;
//
//    S := FPrinter.SUMDAY[1, 1 , 0, 1, Password];
//    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[4]) then nSum[4] := 0;
//
//    S := FPrinter.SUMDAY[1, 2 , 0, 1, Password];
//    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[5]) then nSum[5] := 0;
//
//    if nTotal = (nSum[0] + nSum[1] + nSum[2]) then Break;
//  end;
//
//  Result := Result + '  ------        Податок       Обіг' + #13#10;
//  Result := Result + '  ДОД. А   ' + Str(nSum[3], 13) + Str(nSum[0], 13) + #13#10;
//  Result := Result + '  ДОД. Б   ' + Str(nSum[4], 13) + Str(nSum[1], 13) + #13#10;
//  Result := Result + '  ДОД. В   ' + Str(nSum[5], 13) + Str(nSum[2], 13) + #13#10;
//  Result := Result + '  Чеків продажу ' + IntToStr(FPrinter.COUNTERSDAY[1, Password]) + #13#10;
//
//  S := FPrinter.SUMDAY[0, 0, 0, 2, Password];
//  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[0]) then nSum[0] := 0;
//
//  S := FPrinter.SUMDAY[0, 1 , 0, 2, Password];
//  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[1]) then nSum[1] := 0;
//
//  S := FPrinter.SUMDAY[0, 3 , 0, 2, Password];
//  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[2]) then nSum[2] := 0;
//
//  S := FPrinter.SUMDAY[1, 0, 0, 2, Password];
//  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[3]) then nSum[3] := 0;
//
//  S := FPrinter.SUMDAY[1, 1, 0, 2, Password];
//  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[4]) then nSum[4] := 0;
//
//  S := FPrinter.SUMDAY[1, 3, 0, 2, Password];
//  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[5]) then nSum[5] := 0;
//
//  Result := Result + '  ВІД. A   ' + Str(nSum[3], 13) + Str(nSum[0], 13) + #13#10;
//  Result := Result + '  ВІД. Б   ' + Str(nSum[4], 13) + Str(nSum[1], 13) + #13#10;
//  Result := Result + '  ВІД. В   ' + Str(nSum[5], 13) + Str(nSum[2], 13) + #13#10;
//  Result := Result + '  Чеків повернення ' + IntToStr(FPrinter.COUNTERSDAY[2, Password]) + #13#10;
//
//  S := FPrinter.READTAXRATE[0, 2, Password];
//  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[0]) then nSum[0] := 0;
//
//  S := FPrinter.READTAXRATE[1, 2, Password];
//  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[1]) then nSum[1] := 0;
//
//  S := FPrinter.READTAXRATE[2, 2, Password];
//  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[2]) then nSum[2] := 0;
//
//  Result := Result + '  Податок     від        10.10.2017' + #13#10;
//  Result := Result + '            ПДВ_A (Вкл) A =    ' + Str(nSum[0], 6) + '%' + #13#10;
//  Result := Result + '            ПДВ_Б (Вкл) Б =    ' + Str(nSum[1], 6) + '%' + #13#10;
//  Result := Result + '            ПДВ_В (Вкл) В =    ' + Str(nSum[2], 6) + '%' + #13#10;
//
//  S := FPrinter.RETDT[1, Password];
//  S := S + '  ' + FPrinter.RETDT[0, Password];
//  S := COPY(S, 1, 2) + '.' + COPY(S, 3, 2) +  '.20' + COPY(S, 5, 6) +  ':' + COPY(S, 11, 2);

  Result := Result + '                    ' + S  + #13#10;
  Result := Result + '         ФІСКАЛЬНИЙ ЧЕК' + #13#10;
  Result := Result + '  --------------------------------------' + #13#10;
  Result := Result + '  --------------------------------------' + #13#10;

end;

function TCashEmulation.JuridicalName : string;
begin
//  Result := Trim(FPrinter.READPROGCHECK[0, 1, Password]);
end;

function TCashEmulation.ZReport : Integer;
begin
//  Result := FPrinter.COUNTERSDAY[0, Password];
end;

function TCashEmulation.SummaReceipt : Currency;
begin
  Result := FPrinter.FSummaCheck;
end;

function TCashEmulation.GetTaxRate : string;
  var I : Integer; S : string; C : Currency;
  const TaxName : String = 'АБВГ';
begin
  Result := '';

  for I := 0 to 3 do
  begin
//    S := FPrinter.READTAXRATE[I, 2, Password];
    if TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), C) then
    begin
      if Result <> '' then Result := Result + '; ';
      Result := Result + TaxName[I + 1] + ' ' + FormatCurr('0.00', C) + '%';
    end;
  end;

end;

function TCashEmulation.SensZReportBefore : boolean;
begin
  Result := True;
end;

function TCashEmulation.SummaCash : Currency;
begin
  Result := 19999;
end;

function TCashEmulation.ReceiptsSales : Integer;
begin
  Result := 20;
end;

function TCashEmulation.ReceiptsReturn : Integer;
begin
  Result := 1;
end;

end.

