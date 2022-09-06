unit Cash_MINI_FP54;

interface
uses Windows, CashInterface, ecrmini_TLB, System.Classes, System.DateUtils;
type
  TCashMINI_FP54 = class(TInterfacedObject, ICash)
  private
    FAlwaysSold: boolean;
    FPrintSumma: boolean;
    FSumma : Currency;
    FPrinter: variant;
//    FModem: IICS_Modem;
    FisFiscal: boolean;
    FConnected: boolean;
    FLengNoFiscalText : integer;
    FReturn: boolean;
    FResult: TArray<string>;
    FResultCount: Integer;
    FOpenCommand: String;
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
    function OpenPort : Boolean;
    function ClosePort : Boolean;
    function SendCommand(ACommand : String) : Boolean;
    function ShowError: boolean;
  end;



implementation
uses Forms, SysUtils, Dialogs, Math, Variants, StrUtils, IniUtils, RegularExpressions, Log, ComObj;

const

  Password = '12321';

function CurrToStrPoint (ACurr : Currency) : String;
begin
  Result := StringReplace(FormatCurr('0.00', ACurr), FormatSettings.DecimalSeparator, '.', [rfReplaceAll, rfIgnoreCase])
end;

function AmountToStrPoint (ACurr : Currency) : String;
begin
  Result := StringReplace(FormatCurr('0.000', ACurr), FormatSettings.DecimalSeparator, '.', [rfReplaceAll, rfIgnoreCase])
end;

function StrToCurrPoint(AStr : String) : Currency;
begin
  if not TryStrToCurr(StringReplace(AStr, '.', FormatSettings.DecimalSeparator, [rfReplaceAll, rfIgnoreCase]), Result) then Result := 0;
end;

{ TCashMINI_FP54 }
constructor TCashMINI_FP54.Create;
  var Error : String;
begin
  inherited Create;
  FAlwaysSold:=false;
  FPrintSumma:=False;
  FReturn:=False;
  FLengNoFiscalText := 22;
  FConnected := False;
  FResultCount := 0;
  FOpenCommand := 'open_port;' + iniPortNumber + ';' + iniPortSpeed + ';';
  FSumma := 0;
  Error := '';
  try
    FPrinter := CreateOleObject('ecrmini.t400');
  except
    on E: Exception do  Error := E.Message
  end;

  if Error <> '' then
  begin
    ShowMessage('Ошибка. Возможно не установлен драйвер фискального принтера ecrT400.dll ' + Error);
    Raise Exception.Create('');
  end;

  if not SendCommand('') then
  begin
    Raise Exception.Create('');
  end;
end;

function TCashMINI_FP54.OpenPort : Boolean;
  var Command : String;
begin
  Result := False;
  try
    Command := FOpenCommand;
    if FConnected then Result := True
    else Result := FPrinter.T400me(Command);
    if not Result then ShowError;
  finally
    FConnected := Result;
  end;
end;

function TCashMINI_FP54.ClosePort : Boolean;
  var Command : String;
begin
  FConnected := False;
  Command := 'close_port;';
  Result := FPrinter.T400me(Command);
  if not Result then ShowError;
end;

function TCashMINI_FP54.SendCommand(ACommand : String) : Boolean;
  var Command : String; Connected : Boolean;
begin
  Result := False;
  Connected := FConnected;
  try
    Command := ACommand;
    Result := OpenPort;
    if not Result then Exit;
    if Result and (Command <> '') then Result := FPrinter.T400me(Command);
    if not Result then ShowError;
    FResult := TRegEx.Split(Command, ';');
    FResultCount := High(FResult);
  finally
    if not Connected then ClosePort;
  end;
end;

function TCashMINI_FP54.ShowError: boolean;
  var S : string;
begin
  Result := False;
  case FPrinter.Get_last_error of
    0 : S := 'нет ошибки';
    1 : S := ' нет возможности запустить команду';
    2 : S := 'невозможно обработать команду';
    3 : S := 'код команды отсутствует';
    4 : S := 'много данных в команде';
    5 : S := 'недостаточно данных в команде';
    6 : S := 'ошибка при приеме данных';
    7 : S := 'недопустимый идентификатор команды';
    8 : S := 'невозможно выполнить команду';
    10 : S := 'Ошибка ввода';
    11 : S := 'необходимо снять z1 отчет';
    12 : S := 'скидки/наценки запрещены';
    13 : S := 'переполнение по чеку';
    14 : S := 'команда запрещена';
    15 : S := 'кассир не зарегистрирован';
    16 : S := 'отрицательная сумма';
    17 : S := 'количество товара отрицательное';
    18 : S := 'время смены исчерпано';
    19 : S := 'неверный тип оплаты';
    20 : S := 'неправильная или отсутствующая цена';
    21 : S := 'неверный параметр на входе команды';
    22 : S := 'товар находится в открытом чеке, нельзя редактировать';
    23 : S := 'некорректно запрограммированный товар';
    24 : S := 'неверный или отсутствующий штрих-код товара';
    27 : S := 'неверный или отсутствующий код товара';
    28 : S := 'товар не весовой(штучный)';
    29 : S := 'ФП почти заполнена';
    30 : S := 'ФП заполнена';
    31 : S := 'память инициализаций заполнена';
    32 : S := 'есть отложенная операция, оплата запрещена';
    33 : S := 'карточка клиента не принята';
    34 : S := 'не хватает денег на сдачу';
    35 : S := 'запрещена комбинированная оплата';
    36 : S := 'неправильный номер кассира';
    37 : S := 'места недостаточно';
    38 : S := 'нет места в Журнале';
    39 : S := 'нет места в базе товаров';
    40 : S := 'нет места в Архиве';
    41 : S := 'запрещено, товар является комплексом';
    42 : S := 'код не принадлежит комплексу';
    43 : S := 'ЭККА занят и не может выполнить команду';
    44 : S := 'необходимо снять 501 отчет';
    45 : S := 'неправильный пароль кассира';
    46 : S := 'комплекс невозможно продать';
    47 : S := 'цена товара определена';
    48 : S := 'отмена запрещена';
    49 : S := 'продажа товара запрещена';
    50 : S := 'ошибка чтения ФП';
    51 : S := 'номер производителя неверен';
    52 : S := 'ошибка записи во флеш';
    54 : S := 'удаление товара запрещено';
    55 : S := 'нет данных в фискальной памяти';
    56 : S := 'неправильный пароль налогового инспектора';
    57 : S := 'не готов выполнить команду';
    58 : S := 'неправильный пароль администратора';
    60 : S := 'РРО заблокирован (72 часа не было передачи данных)';
    61 : S := 'РРО не персонализован';
    70 : S := 'отсутсвует вал термоголовки';
    79 : S := 'дата сервисного обслуживания превышена';
    80 : S := 'ошибка записи в ФП';
    81 : S := 'ошибка часов';
    82 : S := 'ошибка данных в интерфейсе';
    86 : S := 'отсутствует индикатор клиента';
    97 : S := 'отсутствует бумага';
    300 : S := 'неверная команда';
    301 : S := 'ошибка порта';
    302 : S := 'неверные параметры';
    303 : S := 'неверное количество параметров';
    304 : S := 'ошибка данных';
    305 : S := 'порт закрыт';
    306 : S := 'нет данных';
    307 : S := 'не поддерживается';
    308 : S := 'касса не доступна';
    309 : S := 'неизвестный код ошибки';
    310 : S := 'запись запрещена';
    311 : S := 'ошибка чтения';
    312 : S := 'ошибка записи';
    313 : S := 'неправильная запись НДС';
    314 : S := 'операция отменена';
    315 : S := 'неправильная модель кассового аппарата';
    316 : S := 'данные не существуют';
    317 : S := 'кассовый аппарат отключен';
    318 : S := 'файл не найден';
    319 : S := 'присутствует ошибка';
    320 : S := 'неверные данные';
    321 : S := 'команда отключена';
    322 : S := 'будет доступно в следующих версиях';
    323 : S := 'принтер не готов';
  end;
  ShowMessage(S);
end;

function TCashMINI_FP54.CloseReceipt: boolean;
begin
  result := True;
end;

function TCashMINI_FP54.CloseReceiptEx(out CheckId: String): boolean;
begin
  if FisFiscal then
  begin
    SendCommand('get_last_receipt_number;');
    if FResultCount >= 1 then CheckId := FResult[1];
  end else
  begin
    SendCommand('comment;0;1;0;0;1;1;;');
    ClosePort;
  end;
  result := True;
end;

function TCashMINI_FP54.GetLastCheckId: Integer;
  var I : integer;
begin
  Result := 0;
  SendCommand('get_last_receipt_number;');
  if FResultCount >= 1 then if TryStrToInt(FResult[1], I) then Result := I;
end;

function TCashMINI_FP54.GetAlwaysSold: boolean;
begin
  result:= FAlwaysSold;
end;

function TCashMINI_FP54.OpenReceipt(const isFiscal: boolean = true; const isPrintSumma: boolean = false; const isReturn: boolean = False): boolean;
begin
  FisFiscal := isFiscal;
  FPrintSumma := isPrintSumma;
  FReturn := isReturn;
  FSumma := 0;
  if not OpenPort then Exit;
  if FisFiscal then result := SendCommand('open_receipt;' + IfThen(isReturn, '1', '0') + ';')
  else result := SendCommand('comment;0;0;0;1;1;1;;');
end;

procedure TCashMINI_FP54.SetAlwaysSold(Value: boolean);
begin
  FAlwaysSold:= Value
end;

procedure TCashMINI_FP54.SetTime;
begin
  if SendCommand('set_date;' + IntToStr(DayOf(NOW)) + ';' + IntToStr(MonthOf(NOW)) + ';' + IntToStr(YearOf(NOW)) + ';') then
    SendCommand('set_time;' + IntToStr(HourOf(NOW)) + ';' + IntToStr(MinuteOf(NOW)) + ';' + IntToStr(SecondOf(NOW)) + ';');
end;

function TCashMINI_FP54.GetTime : TDateTime;
var S : String;
begin
  SendCommand('get_date_time;');

  S := FResult[1] + '  ' + FResult[2];

  S := StringReplace(S, '.', FormatSettings.DateSeparator, [rfReplaceAll]);
  Result := StrToDateTime(S);
end;

function TCashMINI_FP54.SoldCode(const GoodsCode: integer;
  const Amount: double; const Price: double = 0.00): boolean;
begin
  result := False;
  ShowMessage('Ошибка. Комманда SoldCode не разрешена.');
end;

function TCashMINI_FP54.SoldFromPC(const GoodsCode: integer; const GoodsName, UKTZED: string; const Amount, Price, NDS: double): boolean;
var NDSType: char;
    CashCode, nNDS: integer;
    I : Integer;
    L : string;
    Res: TArray<string>;
begin
  result := true;

    // печать нефискального чека
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

  Logger.AddToLog(' SALE (GoodsCode := ' + IntToStr(GoodsCode) + ', Amount := ' + ReplaceStr(FormatFloat('0.000', Amount), FormatSettings.DecimalSeparator, '.') +
      ', Price := ' + ReplaceStr(FormatFloat('0.00', Price), FormatSettings.DecimalSeparator, '.') + ')');

  // программируем товар
  if NDS = 20 then nNDS := 1
  else if NDS =  0 then nNDS := 3
  else nNDS := 2;

  result := SendCommand('add_plu;' + IntToStr(GoodsCode) + ';' + IntToStr(nNDS) + ';1;0;0;0;1;0.0;0;' +
    Copy(StringReplace(UKTZED + IfThen(UKTZED = '', '' , ' ') + GoodsName, ';', '\;', [rfReplaceAll, rfIgnoreCase]), 1, 48) + ';' + AmountToStrPoint(Ceil(Amount)) + ';');
  if not result then Exit;

  // Продажа
  result := SendCommand('sale_plu;0;0;1;' + AmountToStrPoint(Amount) + ';' + IntToStr(GoodsCode) + ';' + CurrToStrPoint(Price) + ';');
  if result and (FResultCount >= 2) then FSumma := FSumma + StrToCurrPoint(FResult[2]);

end;

function TCashMINI_FP54.ProgrammingGoods(const GoodsCode: integer;
  const GoodsName: string; const Price, NDS: double): boolean;
begin
  result := False;
  ShowMessage('Ошибка. Комманда GoodsCode не разрешена.');
end;

procedure TCashMINI_FP54.Anulirovt;
begin
  SendCommand('cancel_receipt;');
  ClosePort;
end;

function TCashMINI_FP54.CashInputOutput(const Summa: double): boolean;
begin
  SendCommand('in_out;0;0;0;' + IfThen(Summa > 0, '0', '1') + ';' + CurrToStrPoint(Abs(Summa)) + ';;;');
end;

function TCashMINI_FP54.TotalSumm(Summ, SummAdd: double; PaidType: TPaidType): boolean;
  var L : string;
begin
  result := True;

  if FisFiscal then
  begin

    if (PaidType=ptCardAdd) and (SummAdd <> 0) then
    begin
      result := SendCommand('pay;0;' + CurrToStrPoint(Abs(SummAdd)) + ';')
    end;

    if result then
    begin
      if PaidType=ptMoney then
      begin
        result := SendCommand('pay;0;' + CurrToStrPoint(Abs(Summ)) + ';')
      end else result := SendCommand('pay;2;' + CurrToStrPoint(Abs(Summ)) + ';')
    end;

   if not result then ShowError;
   if result then ClosePort else Anulirovt;

  end else
  begin
    if FPrintSumma then
    begin
      if not PrintNotFiscalText(StringOfChar('-' , FLengNoFiscalText)) then Exit;
      L := 'СУМА';
      L := L + StringOfChar(' ' , FLengNoFiscalText - Length(L + FormatCurr('0.00', FSumma)) - 1) + FormatCurr('0.00', FSumma);
      if not PrintNotFiscalText(L) then Exit;
    end;
  end;
end;

function TCashMINI_FP54.DiscountGoods(Summ: double): boolean;
begin
  if FisFiscal then
  begin
    result := SendCommand('discount_surcharge;0;0;' + IfThen(Summ > 0, '0', '1') + ';' + CurrToStrPoint(Abs(Summ)) + ';');
  end else result := True;
  FSumma := FSumma + Summ;
end;

function TCashMINI_FP54.ClosureFiscal: boolean;
begin
  result := SendCommand('execute_Z_report;' + Password + ';');
end;

function TCashMINI_FP54.DeleteArticules(const GoodsCode: integer): boolean;
begin
//  result := SendCommand('dps;2;');
end;

function TCashMINI_FP54.FiscalNumber: String;
begin
  result := '';
  if SendCommand('read_fm_table;1;1') and (FResultCount >= 5) then Result := FResult[5];
end;

function TCashMINI_FP54.SerialNumber:String;
begin
  result := '';
  if SendCommand('get_serial_num;') and (FResultCount >= 3)  then Result := FResult[3];
end;

function TCashMINI_FP54.XReport: boolean;
begin
  result := SendCommand('execute_X_report;' + Password + ';');
end;

function TCashMINI_FP54.ChangePrice(const GoodsCode: integer;
  const Price: double): boolean;
begin
end;

function TCashMINI_FP54.GetLastErrorCode: integer;
begin
  //result:= status
end;

function TCashMINI_FP54.GetArticulInfo(const GoodsCode: integer;
  var ArticulInfo: WideString): boolean;
var i: integer;
begin
end;

function TCashMINI_FP54.PrintNotFiscalText(
  const PrintText: WideString): boolean;
begin
  result := SendCommand('comment;0;0;0;0;1;1;' +
    StringReplace(PrintText, ';', '\;', [rfReplaceAll, rfIgnoreCase]) + ';');
end;

function TCashMINI_FP54.PrintFiscalText(
  const PrintText: WideString): boolean;
begin
  result := SendCommand('comment;0;0;0;0;1;1;' +
    StringReplace(PrintText, ';', '\;', [rfReplaceAll, rfIgnoreCase]) + ';');
  if not FConnected and result then SendCommand('paper_feed;5;');
end;

function TCashMINI_FP54.SubTotal(isPrint, isDisplay: WordBool; Percent,
  Disc: Double): boolean;
begin
  result := True;
end;


function TCashMINI_FP54.PrintFiscalMemoryByDate(inStart,
  inEnd: TDateTime): boolean;
var StartStr, EndStr: string;
begin

end;

function TCashMINI_FP54.PrintFiscalMemoryByNum(inStart,
  inEnd: Integer): boolean;
begin

end;

function TCashMINI_FP54.PrintReportByDate(inStart,
  inEnd: TDateTime): boolean;
begin

end;

function TCashMINI_FP54.PrintReportByNum(inStart, inEnd: Integer): boolean;
begin

end;

function TCashMINI_FP54.PrintZeroReceipt: boolean;
begin
  result := SendCommand('print_empty_receipt;');
end;


procedure TCashMINI_FP54.ClearArticulAttachment;
begin
end;

function TCashMINI_FP54.InfoZReport : string;
  var I, ZReport : integer; S : String;

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

//  SendCommand('get_dir;');
//  ShowMessage(FResult[1]);

  SendCommand('get_header;');

  for I := 0 to 12 do
  begin
    if FResult[1 + I * 3] = '' then Continue;
    Result := Result + Centr(FResult[1 + I * 3]) + #13#10;
  end;


  S := 'ЗН ' + SerialNumber;
  S := S + '  ФН ' + FiscalNumber + #13#10;
  Result := Result + Centr(S) + #13#10;

  SendCommand('get_ksef_status;');
  ZReport := StrToInt(FResult[18]);

  S := '           Z-звіт N ' + IntToStr(ZReport);
  Result := Result + S + #13#10;

  Result := Result + '              ЗАГАЛОМ' + #13#10;
//  Result := Result + '  ------      Повернення    Продаж' + #13#10;

  SendCommand('read_fm_table;3;' + IntToStr(ZReport) + ';');

//  Result := Result + '  Готівка  ' + Str(FPrinter.prDayRefundSumOnPayForm4 / 100, 13) + Str(FPrinter.prDaySaleSumOnPayForm4 / 100, 13) + #13#10;
//  Result := Result + '  Картка   ' + Str(FPrinter.prDayRefundSumOnPayForm1 / 100, 13) + Str(FPrinter.prDaySaleSumOnPayForm1 / 100, 13) + #13#10;
//  Result := Result + '  ВСЬОГО   ' + Str(FPrinter.prDayRefundSumOnPayForm10 / 100, 13) + Str(FPrinter.prDaySaleSumOnPayForm10 / 100, 13) + #13#10;
//
//
//  Result := Result + '  ------         Видача     Внесок'#13#10;
//  Result := Result + '  Готівка  ' + Str(FPrinter.prDayCashOutSum / 100, 13) + Str(FPrinter.prDayCashInSum / 100, 13) + #13#10;
//  Result := Result + '  Готівка в касі        ' + Str(FPrinter.prCashDrawerSum / 100, 13) + #13#10;
//

  Result := Result + '  ------        Податок       Обіг' + #13#10;
  Result := Result + '  ДОД. А   ' + Str(StrToCurrPoint(FResult[9]), 13) + Str(StrToCurrPoint(FResult[3]), 13) + #13#10;
  Result := Result + '  ДОД. Б   ' + Str(StrToCurrPoint(FResult[10]), 13) + Str(StrToCurrPoint(FResult[4]), 14) + #13#10;
  Result := Result + '  ДОД. В   ' + Str(StrToCurrPoint(FResult[11]), 13) + Str(StrToCurrPoint(FResult[5]), 15) + #13#10;
  Result := Result + '  Чеків продажу ' + FResult[39] + #13#10;

  Result := Result + '  ВІД. A   ' + Str(StrToCurrPoint(FResult[27]), 13) + Str(StrToCurrPoint(FResult[21]), 13) + #13#10;
  Result := Result + '  ВІД. Б   ' + Str(StrToCurrPoint(FResult[28]), 13) + Str(StrToCurrPoint(FResult[22]), 13) + #13#10;
  Result := Result + '  ВІД. В   ' + Str(StrToCurrPoint(FResult[29]), 13) + Str(StrToCurrPoint(FResult[23]), 13) + #13#10;
  Result := Result + '  Чеків повернення ' + FResult[40] + #13#10;

  SendCommand('read_fm_table;2;0;');

  Result := Result + '  Податок     від        ' + FResult[2] + #13#10;
  Result := Result + '            ПДВ_A (Вкл) A =    ' + Str(StrToCurrPoint(FResult[9]), 6) + '%' + #13#10;
  Result := Result + '            ПДВ_Б (Вкл) Б =    ' + Str(StrToCurrPoint(FResult[13]), 6) + '%' + #13#10;
  Result := Result + '            ПДВ_В (Вкл) В =    ' + Str(StrToCurrPoint(FResult[17]), 6) + '%' + #13#10;

  SendCommand('read_fm_table;3;' + IntToStr(ZReport) + ';');

  S := FResult[2] + '  ' + FResult[43];

  Result := Result + '                    ' + S  + #13#10;
  Result := Result + '         ФІСКАЛЬНИЙ ЧЕК' + #13#10;
  Result := Result + '  --------------------------------------' + #13#10;
  Result := Result + '  --------------------------------------' + #13#10;

end;

function TCashMINI_FP54.JuridicalName : string;
begin
  SendCommand('get_header;');
  Result :=  FResult[1];
end;

function TCashMINI_FP54.ZReport : Integer;
begin
  if SendCommand('execute_Z_report;' + Password + ';') then result := 1;
end;

function TCashMINI_FP54.SummaReceipt : Currency;
begin
//  result := FSumma;
  if SendCommand('show_subtotal;') then Result := StrToCurrPoint(FResult[1])
  else Result := 0;
end;

function TCashMINI_FP54.GetTaxRate : string;
  var I : Integer; S : string; C : Currency;
  const TaxName : String = 'АБВГ';
begin
  Result := '';
  if not SendCommand('get_taxes;') then Exit;
  for I := 0 to 3 do
  begin
    if Result <> '' then Result := Result + '; ';
    Result := Result + TaxName[I + 1] + ' ' + FormatCurr('0.00', StrToCurrPoint(FResult[6 + I * 3])) + '%';
  end;

end;

function TCashMINI_FP54.SensZReportBefore : boolean;
begin
  Result := False;
end;

function TCashMINI_FP54.SummaCash : Currency;
begin
  Result := 0;
end;

function TCashMINI_FP54.SummaCard : Currency;
begin
  Result := 0;
end;

function TCashMINI_FP54.ReceiptsSales : Integer;
begin
  SendCommand('get_header;');
  Result := StrToInt(FResult[39]);
end;

function TCashMINI_FP54.ReceiptsReturn : Integer;
begin
  SendCommand('get_header;');
  Result := StrToInt(FResult[40]);
end;

end.

