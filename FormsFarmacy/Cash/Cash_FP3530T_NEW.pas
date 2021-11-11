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
    function SummaCard : Currency;
    function ReceiptsSales : Integer;
    function ReceiptsReturn : Integer;
  public
    constructor Create;
  end;



implementation
uses Forms, SysUtils, Dialogs, Math, Variants, StrUtils, IniUtils, RegularExpressions, Log, UnitGetCash;

function СообщениеКА(k: string): boolean;
begin
  result := (k = '$0000') or (k = '');
  if result then
     exit;

  if (k='$0101') then begin Add_Log_RRO('$0101 Ошибка принтера');  exit;  end; //257
  if (k='$0201') then begin Add_Log_RRO('$0201 Ошибка RAM'); exit; end;    //
  if (k='$0301') then begin Add_Log_RRO('$0301 Ошибка Контрольная сумма памяти программ'); exit; end; ///
  if (k='$0401') then begin Add_Log_RRO('$0401 Ошибка flash памяти');  exit; end;                      //
  if (k='$0501') then begin Add_Log_RRO('$0501 Ошибка Дисплея');  exit; end;                           //
  if (k='$0601') then begin Add_Log_RRO('$0601 Ошибка часов');  exit; end;                             //
  if (k='$0701') then begin Add_Log_RRO('$0701 Ошибка возникла вследствие понижения питания');  exit; end; //
  if (k='$0002') then begin Add_Log_RRO('$0002 Неправильный код инструкции');  exit; end; 	          //

   //0xNN03	Формат поля неверен, где NN -Порядковый номер неверного поля
  if Copy(k, 3, 2) = '03'	then begin Add_Log_RRO('Формат поля неверен, где NN -Порядковый номер неверного поля (' + Copy(k, 1, 2) + ')');  exit; end;
   //0xNN04	Значение поля выходит за диапазон, где NN -Порядковый номер неверного поля
  if Copy(k, 3, 2) = '04'	then begin Add_Log_RRO('Значение поля выходит за диапазон, где NN -Порядковый номер неверного поля (' + Copy(k, 1, 2) + ')');  exit; end;
   //0xXX05 Ошибка ФП

  if (k='$0005')	then begin Add_Log_RRO('$0005 Нет свободного места для записи');   exit; end;  //
  if (k='$0105')	then begin Add_Log_RRO('$0105 Ошибка записи в ФП');  exit; end;                //
  if (k='$0205')	then begin Add_Log_RRO('$0205 Заводской номер неустановлен');    exit; end;    //
  if (k='$0305')	then begin Add_Log_RRO('$0305 Дата последней записи в ФП более поздняя, чем та, что пытаемся установить');  exit; end; //
  if (k='$0405')	then begin Add_Log_RRO('$0405 Нельзя выходить за пределы суток');  exit; end; //
  if (k='$0505')	then begin Add_Log_RRO('$0505 Сбой данных в ФП');  exit; end; //
  if (k='$0605')	then begin Add_Log_RRO('$0605 фискальная память исчерпана(Запись запрещена)');  exit; end; //
  if (k='$0705')	then begin Add_Log_RRO('$0705 ЭККР не в фискальном режиме');  exit; end; //
  if (k='$0805')	then begin Add_Log_RRO('$0805 дата и время не были установлены с момента последнего аварийного обнуления ОЗУ');  exit; end; //
  if (k='$0905')	then begin Add_Log_RRO('$0905 С начала смены прошло более чем 24 часа');  exit; end; //
  if (k='$0A05')	then begin Add_Log_RRO('$0A05 необходимо скорректировать время');  exit; end; //
  if (k='$0B05')	then begin Add_Log_RRO('$0B05 Ошибка в таблице налоговых ставок');  exit; end; //
  if (k='$0006')	then begin Add_Log_RRO('$0006 Неверный пароль');  exit; end; //
   //0xXX07 ошибка режима
  if (k='$0007')	then begin Add_Log_RRO('$0007 Команда в данном режиме регистратора невыполнима');  exit; end; 	//
  if (k='$0107')	then begin Add_Log_RRO('$0107 Команда в данном состоянии смены невыполнима');   exit; end; 	    //
  if (k='$0008')	then begin Add_Log_RRO('$0008 Переполнение математики'); 	 exit; end;                         //
  if (k='$0009')	then begin Add_Log_RRO('$0009 Не обнулено'); 	 exit; end;                                     //
   //0xXX0A Ошибки при работе с базой товаров
  if (k='$000A')	then begin Add_Log_RRO('$000A Недостаточно свободного места для выполнения команды');  exit; end; //
  if (k='$010A')	then begin Add_Log_RRO('$010A Длина записи больше максимума'); 	 exit; end;                   //
  if (k='$020A')	then begin Add_Log_RRO('$020A Артикул с данным кодом не найден');  exit; end; 	                  //
  if (k='$030A')	then begin Add_Log_RRO('$030A Индекс за пределами базы');  exit; end; 	                          //
  if (k='$040A')	then begin Add_Log_RRO('$040A Артикул/отдел с данным кодом существует');  exit; end; 	          //
  if (k='$050A')	then begin Add_Log_RRO('$050A Запрещенная налоговая группа');  exit; end; 	                      //
   //0хХX0B Ошибка при работе с цепочкой продаж                                                     //
  if (k='$000B')	then begin Add_Log_RRO('$000B Неверное состояние документа');  exit; end; 	                      //
  if (k='$010B')	then begin Add_Log_RRO('$010B Недостаточно свободного места для выполнения команды');  exit; end; //
  if (k='$020B')	then begin Add_Log_RRO('$020B Неизвестный тип записи продажи');  exit; end; 	                  //
  if (k='$030B')	then begin Add_Log_RRO('$030B Аннулирование не может начинаться с данной операции');  exit; end;  //
  if (k='$040B')	then begin Add_Log_RRO('$040B Данная операция в чеке не найдена');  exit; end; 	                  //
  if (k='$050B')	then begin Add_Log_RRO('$050B последовательность неполная (за последней операцией есть еще команды которые с ней связаны)');  exit; end; //
  if (k='$060B')	then begin Add_Log_RRO('$060B Аннулировать нечего'); 	 exit; end;                               //
  if (k='$070B')	then begin Add_Log_RRO('$070B Копия чека недоступна'); 	 exit; end;                               //
  if (k='$080B')	then begin Add_Log_RRO('$080B Недостаточно наличности для выполнения операции'); 	 exit; end;   //
  if (k='$090B')	then begin Add_Log_RRO('$090B Данная форма оплаты в этом чеке запрещена'); 	 exit; end;           //
  if (k='$0A0B')	then begin Add_Log_RRO('$0A0B Данная сдача с данной формы оплаты (в данном типе чека) запрещена');  exit; end; 	//
  if (k='$0B0B')	then begin Add_Log_RRO('$0B0B Значение скидки вышло за пределы');  exit; end; 	                                //
  if (k='$0C0B')	then begin Add_Log_RRO('$0C0B Переполнение итога по чеку');  exit; end; 	                                    //
  if (k='$0D0B')	then begin Add_Log_RRO('$0D0B Переполнение по оплатам');  exit; end; 	                                        //
  if (k='$0E0B')	then begin Add_Log_RRO('$0E0B Вышли за пределы буфера'); 	 exit; end;                                         //
  if (k='$000C')	then begin Add_Log_RRO('$000C Ошибки временного буфера');   exit; end; 	                                        //
  if (k='$010C')	then begin Add_Log_RRO('$010C Данные не совпали с ранее сохраненными');   exit; end;

  Add_Log_RRO(k + ' Недокументированная ошибка!!! Свяжитесь с разработчиком')
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
  СообщениеКА(FPrinter.GETERROR);

end;

function TCashFP3530T_NEW.CloseReceipt: boolean;
begin
  result := false;

  FPrinter.CLOSECHECK[1, Password];
  result := СообщениеКА(FPrinter.GETERROR)
end;

function TCashFP3530T_NEW.CloseReceiptEx(out CheckId: String): boolean;
begin
  result := false;
  FPrinter.CLOSEFISKCHECK[1, Password];
  result := СообщениеКА(FPrinter.GETERROR);
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
  result := СообщениеКА(FPrinter.GETERROR)
end;

procedure TCashFP3530T_NEW.SetAlwaysSold(Value: boolean);
begin
  FAlwaysSold:= Value
end;

procedure TCashFP3530T_NEW.SetTime;
begin
  FPrinter.SETDT[FormatDateTime('DDMMYYHHNN', Now), Password];
  СообщениеКА(FPrinter.GETERROR)
end;

function TCashFP3530T_NEW.SoldCode(const GoodsCode: integer;
  const Amount: double; const Price: double = 0.00): boolean;
begin
  Logger.AddToLog(' SALE (GoodsCode := ' + IntToStr(GoodsCode) + ', Amount := ' + ReplaceStr(FormatFloat('0.000', Amount), FormatSettings.DecimalSeparator, '.') +
      ', Price := ' + ReplaceStr(FormatFloat('0.00', Price), FormatSettings.DecimalSeparator, '.') + ', Password := ' + Password);
  FPrinter.SALE[GoodsCode, ReplaceStr(FormatFloat('0.000', Amount), FormatSettings.DecimalSeparator, '.'), ReplaceStr(FormatFloat('0.00', Price), FormatSettings.DecimalSeparator, '.') , Password];
  result := СообщениеКА(FPrinter.GETERROR)
end;

function TCashFP3530T_NEW.SoldFromPC(const GoodsCode: integer; const GoodsName: string; const Amount, Price, NDS: double): boolean;
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

function TCashFP3530T_NEW.ProgrammingGoods(const GoodsCode: integer;
  const GoodsName: string; const Price, NDS: double): boolean;
var NDSType: Integer;
begin//  if NDS = 0 then NDSType := 1 .033.+else NDSType := 0;

  if NDS = 20 then NDSType := 0
  else if NDS =  0 then NDSType := 2
  else NDSType := 1;

  // программирование артикула
  Logger.AddToLog(' WRITEARTICLE (GoodsCode := ' + IntToStr(GoodsCode) +
                 ', GoodsName := ' + GoodsName +
                 ', NDSType := ' + IntToStr(NDSType) +
                 ', Password := ' + Password);
  FPrinter.WRITEARTICLE[GoodsCode, GoodsName, NDSType, 1, 1, '.', Password];

  result := СообщениеКА(FPrinter.GETERROR)
end;

procedure TCashFP3530T_NEW.Anulirovt;
begin
  FPrinter.ANULIROVT[0, Password];
  СообщениеКА(FPrinter.GETERROR)
end;

function TCashFP3530T_NEW.CashInputOutput(const Summa: double): boolean;
begin
  FPrinter.MONEY[1, ReplaceStr(FormatFloat('0.00', Summa), FormatSettings.DecimalSeparator, '.'), Password];
  result := СообщениеКА(FPrinter.GETERROR)
end;

function TCashFP3530T_NEW.TotalSumm(Summ, SummAdd: double; PaidType: TPaidType): boolean;
  var L : string;
begin
  if FisFiscal then
  begin
    if PaidType=ptMoney then
      FPrinter.PAYMENT[0, ReplaceStr(FormatFloat('0.00', Summ), FormatSettings.DecimalSeparator, '.'), Password]
    else FPrinter.PAYMENT[1, ReplaceStr(FormatFloat('0.00', Summ), FormatSettings.DecimalSeparator, '.'), Password];
    result := СообщениеКА(FPrinter.GETERROR);

    if result and (PaidType=ptCardAdd) and (SummAdd <> 0) then
    begin
      FPrinter.PAYMENT[0, ReplaceStr(FormatFloat('0.00', SummAdd), FormatSettings.DecimalSeparator, '.'), Password];
      result := СообщениеКА(FPrinter.GETERROR);
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

function TCashFP3530T_NEW.DiscountGoods(Summ: double): boolean;
begin
  if FisFiscal then
  begin
    FPrinter.DISCOUNT[ReplaceStr(FormatFloat('0.00', Summ), FormatSettings.DecimalSeparator, '.'), Password];
    result := СообщениеКА(FPrinter.GETERROR);
  end else
  begin
    if Summ > 0 then
    begin
      if not PrintNotFiscalText('Націнка' + StringOfChar(' ' , FLengNoFiscalText - Length('Націнка' + FormatCurr('0.00', Abs(Summ))) - 1) + FormatCurr('0.00', Abs(Summ))) then Exit;
    end else if not PrintNotFiscalText('Знижка' + StringOfChar(' ' , FLengNoFiscalText - Length('Знижка' + FormatCurr('0.00', Abs(Summ))) - 1) + FormatCurr('0.00', Abs(Summ))) then Exit;
    FSumma := FSumma + Summ;
    result := True;
  end;
end;

function TCashFP3530T_NEW.ClosureFiscal: boolean;
begin
  FPrinter.ZREPORT[Password];
  result := СообщениеКА(FPrinter.GETERROR)
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
  result := СообщениеКА(FPrinter.GETERROR)
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
  result := СообщениеКА(FPrinter.GETERROR)
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
    result := СообщениеКА(FPrinter.GETERROR);

    if result and (Disc <> 0) then
    begin
      FPrinter.DISCOUNTTOTAL[ReplaceStr(FormatFloat('0.00', Disc), FormatSettings.DecimalSeparator, '.'), Password];
      result := СообщениеКА(FPrinter.GETERROR);
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
    if not СообщениеКА(FPrinter.GETERROR) then Exit;
    if Trim(S) <> ';0' then Result := Result + Centr(S) + #13#10;
  end;

  S := 'ЗН ' + FPrinter. ZNUM[Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  S := S + '  ФН ' + FPrinter.FNUM[Password] + #13#10;
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  Result := Result + Centr(S) + #13#10;

  S := '           Z-звіт N ' + IntToStr(FPrinter.COUNTERSDAY[0, Password]);
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  Result := Result + S + #13#10;

  Result := Result + '              ЗАГАЛОМ' + #13#10;
  Result := Result + '  ------      Повернення    Продаж' + #13#10;

  S := FPrinter.SUMDAY[2, 0, 0, 1, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[0]) then nSum[0] := 0;

  S := FPrinter.SUMDAY[2, 1, 0, 1, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[1]) then nSum[1] := 0;

  S := FPrinter.SUMDAY[2, 0, 0, 2, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[2]) then nSum[2] := 0;

  S := FPrinter.SUMDAY[2, 1, 0, 2, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[3]) then nSum[3] := 0;

  Result := Result + '  Готівка  ' + Str(nSum[2], 13) + Str(nSum[0], 13) + #13#10;
  Result := Result + '  Картка   ' + Str(nSum[3], 13) + Str(nSum[1], 13) + #13#10;
  Result := Result + '  ВСЬОГО   ' + Str(nSum[2] + nSum[3], 13) + Str(nSum[0] + nSum[1], 13) + #13#10;

  nTotal := nSum[0] + nSum[1];

  S := FPrinter.SUMDAY[3, 1, 0, 2, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[0]) then nSum[0] := 0;

  S := FPrinter.SUMDAY[3, 1, 0, 1, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[1]) then nSum[1] := 0;

  S := FPrinter.SUMDAY[3, 0, 0, 1, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[2]) then nSum[2] := 0;

  Result := Result + '  ------         Видача     Внесок'#13#10;
  Result := Result + '  Готівка  ' + Str(-nSum[0], 13) + Str(nSum[1], 13) + #13#10;
  Result := Result + '  Готівка в касі        ' + Str(nSum[2], 13) + #13#10;

  for I := 1 to 10 do
  begin

    S := FPrinter.SUMDAY[0, 0, 0, 1, Password];
    if not СообщениеКА(FPrinter.GETERROR) then Exit;
    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[0]) then nSum[0] := 0;

    S := FPrinter.SUMDAY[0, 1 , 0, 1, Password];
    if not СообщениеКА(FPrinter.GETERROR) then Exit;
    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[1]) then nSum[1] := 0;

    S := FPrinter.SUMDAY[0, 2 , 0, 1, Password];
    if not СообщениеКА(FPrinter.GETERROR) then Exit;
    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[2]) then nSum[2] := 0;

    S := FPrinter.SUMDAY[1, 0, 0, 1, Password];
    if not СообщениеКА(FPrinter.GETERROR) then Exit;
    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[3]) then nSum[3] := 0;

    S := FPrinter.SUMDAY[1, 1 , 0, 1, Password];
    if not СообщениеКА(FPrinter.GETERROR) then Exit;
    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[4]) then nSum[4] := 0;

    S := FPrinter.SUMDAY[1, 2 , 0, 1, Password];
    if not СообщениеКА(FPrinter.GETERROR) then Exit;
    if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[5]) then nSum[5] := 0;

    if nTotal = (nSum[0] + nSum[1] + nSum[2]) then Break;
  end;

  Result := Result + '  ------        Податок       Обіг' + #13#10;
  Result := Result + '  ДОД. А   ' + Str(nSum[3], 13) + Str(nSum[0], 13) + #13#10;
  Result := Result + '  ДОД. Б   ' + Str(nSum[4], 13) + Str(nSum[1], 13) + #13#10;
  Result := Result + '  ДОД. В   ' + Str(nSum[5], 13) + Str(nSum[2], 13) + #13#10;
  Result := Result + '  Чеків продажу ' + IntToStr(FPrinter.COUNTERSDAY[1, Password]) + #13#10;
  if not СообщениеКА(FPrinter.GETERROR) then Exit;

  S := FPrinter.SUMDAY[0, 0, 0, 2, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[0]) then nSum[0] := 0;

  S := FPrinter.SUMDAY[0, 1 , 0, 2, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[1]) then nSum[1] := 0;

  S := FPrinter.SUMDAY[0, 2 , 0, 2, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[2]) then nSum[2] := 0;

  S := FPrinter.SUMDAY[1, 0, 0, 2, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[3]) then nSum[3] := 0;

  S := FPrinter.SUMDAY[1, 1, 0, 2, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[4]) then nSum[4] := 0;

  S := FPrinter.SUMDAY[1, 2, 0, 2, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[5]) then nSum[5] := 0;

  Result := Result + '  ВІД. A   ' + Str(nSum[3], 13) + Str(nSum[0], 13) + #13#10;
  Result := Result + '  ВІД. Б   ' + Str(nSum[4], 13) + Str(nSum[1], 13) + #13#10;
  Result := Result + '  ВІД. В   ' + Str(nSum[5], 13) + Str(nSum[2], 13) + #13#10;
  Result := Result + '  Чеків повернення ' + IntToStr(FPrinter.COUNTERSDAY[2, Password]) + #13#10;
  if not СообщениеКА(FPrinter.GETERROR) then Exit;

  S := FPrinter.READTAXRATE[0, 2, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[0]) then nSum[0] := 0;

  S := FPrinter.READTAXRATE[1, 2, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[1]) then nSum[1] := 0;

  S := FPrinter.READTAXRATE[2, 2, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if not TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum[2]) then nSum[2] := 0;

  Result := Result + '  Податок     від        10.10.2017' + #13#10;
  Result := Result + '            ПДВ_A (Вкл) A =    ' + Str(nSum[0], 6) + '%' + #13#10;
  Result := Result + '            ПДВ_Б (Вкл) Б =    ' + Str(nSum[1], 6) + '%' + #13#10;
  Result := Result + '            ПДВ_В (Вкл) В =    ' + Str(nSum[2], 6) + '%' + #13#10;

  S := FPrinter.RETDT[1, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  S := S + '  ' + FPrinter.RETDT[0, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  S := COPY(S, 1, 2) + '.' + COPY(S, 3, 2) +  '.20' + COPY(S, 5, 6) +  ':' + COPY(S, 11, 2);

  Result := Result + '                    ' + S  + #13#10;
  Result := Result + '         ФІСКАЛЬНИЙ ЧЕК' + #13#10;
  Result := Result + '  --------------------------------------' + #13#10;
  Result := Result + '  --------------------------------------' + #13#10;

end;

function TCashFP3530T_NEW.JuridicalName : string;
begin
  Result := Trim(FPrinter.READPROGCHECK[0, 1, Password]);
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
end;

function TCashFP3530T_NEW.ZReport : Integer;
begin
  Result := FPrinter.COUNTERSDAY[0, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
end;

function TCashFP3530T_NEW.SummaReceipt : Currency;
  var nSum : Currency;
begin
  Result := 0;
  if TryStrToCurr(Trim(StringReplace(FPrinter.SUMCHEQUE[3, 1, Password], '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum) then Result := Result + nSum;
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
end;

function TCashFP3530T_NEW.GetTaxRate : string;
  var I : Integer; S : string; C : Currency;
  const TaxName : String = 'АБВГ';
begin
  Result := '';

  for I := 0 to 3 do
  begin
    S := FPrinter.READTAXRATE[I, 2, Password];
    if not СообщениеКА(FPrinter.GETERROR) then Exit;
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
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum) then Result := nSum;

  S := FPrinter.SUMDAY[2, 0, 0, 2, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum) then Result := Result - Abs(nSum);
end;

function TCashFP3530T_NEW.SummaCard : Currency;
  var S : string; nSum : Currency;
begin
  Result := 0;

  S := FPrinter.SUMDAY[2, 1, 0, 1, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
  if TryStrToCurr(Trim(StringReplace(S, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])), nSum) then Result := nSum;

  S := FPrinter.SUMDAY[2, 1, 0, 2, Password];
  if not СообщениеКА(FPrinter.GETERROR) then Exit;
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
Входные данные -
psw - пароль для снятия отчета (оператор 15)
Start - начальный номер Z-отчета (4 байта)
End - конечный номер Z-отчета (4 байта)
Выходные данные - нет
С помощью этой функции  печатается информация из фискальной памяти о Z-отчетах по номерам  (полный периодический отчет).



int CALLBACK  PrintFiscalMemoryByDate(HWND hwnd,void (CALLBACK *Fn), LPARAM UI, LPSTR psw, LPSTR Start,LPSTR End)
Входные данные -
psw - пароль для снятия отчета (оператор 15)
Start - начальная дата Z-отчета (DDMMYY, например 100500)
End - конечная дата Z-отчета (DDMMYY)
С помощью этой функции  печатается информация из фискальной памяти о Z-отчетах по датам  (полный периодический отчет).


4Fh(79)
Сокращенный периодический отчет (по дате) int
CALLBACK  PrintReportByDate(HWND hwnd,void (CALLBACK *Fn),LPARAM UI, LPSTR psw, LPSTR Start,LPSTR End)
Входные данные -
psw - пароль для снятия отчета (оператор 15)
Start - Начальная дата - 6 байт (DDMMYY)
End - Конечная дата - 6 байт (DDMMYY)
Выходные данные - нет
С помощью этой функции  печатается сокращенный периодический отчет за указанный период времени.



int CALLBACK  PrintReportByNum(HWND hwnd,void (CALLBACK *Fn),LPARAM UI, LPSTR psw, int Start,int End)
Входные данные -
psw - пароль для снятия отчета (оператор 15)
Start - начальный номер Z-отчета (4 байта)
End - конечный номер Z-отчета (4 байта)
Выходные данные - нет
С помощью этой функции  печатается сокращенный периодический отчет по указанным порядковым номерам Z-отчетов.






