unit Cash_FP3530T;

interface
uses Windows, CashInterface, DBClient, StrUtils;
type
  TCashFP3530T = class(TInterfacedObject, ICash)
  private
    Table: TClientDataSet;
    FAlwaysSold: boolean;
    FisFiscal: boolean;
    FLengNoFiscalText : integer;
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
uses Forms, SysUtils, Dialogs, Math, Variants, RegularExpressions, LocalWorkUnit;

type
  RetData = record
               Count: integer ;
               CmdCode: integer ;
               UserData: integer ;
               Status: integer ;
               CmdName: PChar ;
               SendStr: PChar ;
               Whole: PChar ;
               RetItem: array [1..20] of PChar ;
               OrigStat: array [1..6] of   byte	;
               end;

  n1RetData=  array [1..10] of byte;
  nRetData = ^ n1RetData;
  TMathFunc = procedure(const rt:RetData) stdcall;


function    GetStatus(hWin:HWND; fun:TMathFunc; par:LPARAM; int1: BOOL):integer; stdcall	;external 'fpl.dll' name 'GetStatus';
function    OpenFiscalReceipt(hWin:HWND; fun:TMathFunc; par:LPARAM;i1: DWORD;i2: LPSTR;i3: DWORD;i4: BOOL):integer;stdcall;external 'fpl.dll' name 'OpenFiscalReceipt';
function    OpenRepaymentReceipt(hWin:HWND; fun:TMathFunc; par:LPARAM;i1: DWORD;i2: LPSTR;i3: DWORD;i4: BOOL):integer;stdcall;external 'fpl.dll' name 'OpenRepaymentReceipt';
function    RegisterItem(hWin:HWND; fun:TMathFunc; par:LPARAM; n:LPSTR; n1: AnsiChar; n2:double; n3:double):integer;stdcall;external 'fpl.dll' name 'RegisterItem';
function    InitFPport(int1,int2:integer):integer;stdcall	; external 'fpl.dll' name 'InitFPport';
function    CloseFPport():integer;stdcall	; external 'fpl.dll' name 'CloseFPport';
function    PrintDiagnosticInfo(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall	;external 'fpl.dll' name 'PrintDiagnosticInfo';
function    SetDecimals(int1:integer):integer;stdcall;external 'fpl.dll' name 'SetDecimals';
function    dllSubTotal(hWin:HWND; fun:TMathFunc; par:LPARAM; n1:BOOL;n2:BOOL; n3:double; n4:double):integer; stdcall	;external 'fpl.dll' name 'SubTotal';
function    Total(hWin:HWND; fun:TMathFunc; par:LPARAM; n1:LPSTR;n2: AnsiChar; n3:double):integer; stdcall	;external 'fpl.dll' name 'Total';
function    CloseFiscalReceipt(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall	;external 'fpl.dll' name 'CloseFiscalReceipt';
function    FiscalClosure(hWin:HWND; fun:TMathFunc; par: LPARAM;n:LPSTR;s: AnsiChar):integer; stdcall;external 'fpl.dll' name 'FiscalClosure';
function    ServiceInputOutput(hWin:HWND; fun:TMathFunc; par:LPARAM ; sum:Double) :integer; stdcall	;external 'fpl.dll' name 'ServiceInputOutput';

function    dllPrintFiscalMemoryByNum(hWin:HWND; fun:TMathFunc; par: LPARAM; d1:LPSTR; n1: word; n2: word):integer; stdcall;external 'fpl.dll' name 'PrintFiscalMemoryByNum';
function    dllPrintFiscalMemoryByDate(hWin:HWND; fun:TMathFunc; par: LPARAM; pvd:LPSTR; d1:LPSTR; d2:LPSTR):integer; stdcall;external 'fpl.dll' name 'PrintFiscalMemoryByDate';

function    OpenDrawer(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall	;external 'fpl.dll' name 'OpenDrawer';
function    dllPrintFiscalText(hWin:HWND; fun:TMathFunc; par:LPARAM; int1: LPSTR):integer; stdcall	;external 'fpl.dll' name 'PrintFiscalText';
function    PrintNoFiscalText(hWin:HWND; fun:TMathFunc; par:LPARAM; int1: LPSTR):integer; stdcall	;external 'fpl.dll' name 'PrintNonfiscalText';
function    SaleArticleAndDisplay(hWin:HWND; fun:TMathFunc; par:LPARAM; sign: Boolean;  numart:integer; qwant,perc,dc:double ):integer; stdcall  ;external 'fpl.dll' name 'SaleArticleAndDisplay';
function    ProgrammingArticle(hWin:HWND; fun:TMathFunc; par:LPARAM; nal:Ansichar; gr:integer; cod:integer; Sena:double; pass:LPSTR; name:LPSTR):integer; stdcall  ;external 'fpl.dll' name 'ProgrammingArticle';
function    DeleteArticle(hWin:HWND; fun:TMathFunc; par:LPARAM; cod:integer; pass:LPSTR):integer; stdcall  ;external 'fpl.dll' name 'DeleteArticle';
function    ChangeArticlePrice(hWin:HWND; fun:TMathFunc; par:LPARAM; cod:integer;sena:Double; pass:LPSTR):integer; stdcall  ;external 'fpl.dll' name 'ChangeArticlePrice';
function    GetArticleInfo(hWin:HWND; fun:TMathFunc; par:LPARAM; cod:integer):integer; stdcall  ;external 'fpl.dll' name 'GetArticleInfo';
function    SetDateTime(hWin: HWND; fun: TMathFunc; par: LPARAM; n1, n2: LPSTR): integer; stdcall; external 'fpl.dll' name 'SetDateTime';
function    GetDateTime(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall;external 'fpl.dll' name 'GetDateTime';

function    OpenNonfiscalReceipt(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall; external 'fpl.dll' name 'OpenNonfiscalReceipt';
function    CloseNonfiscalReceipt(hWin:HWND; fun:TMathFunc; par:LPARAM):integer; stdcall; external 'fpl.dll' name 'CloseNonfiscalReceipt';

  CONST

  WM_FPRESPONSE = $1099;
  PREAMBLE = $01;
  NACK = $15;
  SYN = $16;
  TERMINATOR = $03;
  POSTAMBLE = $05;
  NOPAPER = $13;

  SYNTAX_ERROR = $00000001;
  INVALID_CMD = $00000002;
  INVALID_TIME = $00000004;
  PRINT_ERROR = $00000008;
  SUM_OVERFLOW = $00000010;
  CMD_NOT_ALLOWED = $00000020;
  RAM_CLEARED = $00000040;
  PRINT_RESTART = $00000080;
  RAM_DESTROYED = $00000100;
  PAPER_OUT = $00000200;
  FISCAL_OPEN = $00000400;
  NONFISCAL_OPEN = $00000800;
  SERVICE_OPEN = $00001000;
  F_ABSENT = $00002000;
  F_MODULE_NUM = $00004000;
  F_WRITE_ERROR = $00010000;
  F_FULL = $00020000;
  F_READ_ONLY = $00040000;
  F_CLOSE_ERROR = $00080000;
  F_LESS_30 = $00100000;
  F_FORMATTED = $00200000;
  F_FISCALIZED = $00400000;
  F_SER_NUM = $00800000;

  PROTOCOL_ERROR = $01000000;
  NACK_RECEIVED = $02000000;
  TIMEOUT_ERROR = $04000000;
  COMMON_ERROR = $08000000;
  F_COMMON_ERROR = $10000000;
  ADD_PAPER = $20000000;

  ANY_ERROR = $FF000000;

var s, status: integer;
    Unit_rt: RetData;
    //LogFile: text;


procedure PrinterResults(const rt:RetData)stdcall;
begin
  s:=1;
  Unit_rt:=rt;
  status := rt.Status;
  exit;
  if (SYNTAX_ERROR and rt.Status <> 0) then
     raise Exception.Create('Синтаксическая ошибка');
  //if (INVALID_CMD and rt.Status <> 0) then
    // raise Exception.Create('Неверная команда');
  if (INVALID_TIME and rt.Status <> 0) then
     raise Exception.Create('Дата и время неверны');
  if (PRINT_ERROR and rt.Status <> 0) then
     raise Exception.Create('Ошибка печати');
  if (SUM_OVERFLOW and rt.Status <> 0) then
     raise Exception.Create('Арифметическое переполнение');
  if (CMD_NOT_ALLOWED and rt.Status <> 0) then
     raise Exception.Create('Команда не разрешена');
  if (RAM_CLEARED and rt.Status <> 0) then
     raise Exception.Create('Обнуление ОЗУ');
  if (RAM_DESTROYED and rt.Status <> 0) then
     raise Exception.Create('Обнуление ОЗУ');
  if (PAPER_OUT and rt.Status <> 0) then
     raise Exception.Create('Нет бумаги');
  if (F_ABSENT and rt.Status <> 0) then
     raise Exception.Create('Не модуля фиск. памяти');
  if (F_LESS_30 and rt.Status <> 0) then
     raise Exception.Create('В фиск. памяти мало места');
  if (F_WRITE_ERROR and rt.Status <> 0) then
     raise Exception.Create('Ошибка записи в фиск. память');
  if (F_FULL and rt.Status <> 0) then
     raise Exception.Create('Фиск. память переполнена');
  if (F_READ_ONLY and rt.Status <> 0) then
     raise Exception.Create('Запись в фиск. память запрещена');
  if (F_CLOSE_ERROR and rt.Status <> 0) then
     raise Exception.Create('Ошибка последнего Z-отчета');
  if (PROTOCOL_ERROR and rt.Status <> 0) then
     raise Exception.Create('Ошибка протокола');
  if (NACK_RECEIVED and rt.Status <> 0) then
     raise Exception.Create('Ошибка приема команды');
  if (TIMEOUT_ERROR and rt.Status <> 0) then
     raise Exception.Create('Таймаут');
  if (COMMON_ERROR and rt.Status <> 0) then
     raise Exception.Create('Общая ошибка');
  if (F_COMMON_ERROR and rt.Status <> 0) then
     raise Exception.Create('Общая ошибка фиск. памяти');

end;

{ TCashFP3530T }
constructor TCashFP3530T.Create;
begin
  inherited Create;
  FAlwaysSold:=false;
  InitFPport(1, 19200);
  SetDecimals(2);
  FLengNoFiscalText := 35;
  Table:= TClientDataSet.Create(nil);
  if FileExists(CashAttachment_lcl) then LoadLocalData(Table,CashAttachment_lcl)
  else CreateCashAttachment(Table);
  {AssignFile(LogFile,'ToCash.Log');
  try
    Append(LogFile);
  except
    Rewrite(LogFile);
  end;}
end;

function TCashFP3530T.CloseReceipt: boolean;
begin
  result := true;
  try
    status:= 0;
    if FAlwaysSold then exit;
    s:=0;
    GetStatus(0, PrinterResults, 0,True);
    while s=0 do Application.ProcessMessages;

    s:=0;
    if FisFiscal then CloseFiscalReceipt(0, PrinterResults, 0)
    else CloseNonfiscalReceipt(0, PrinterResults, 0);
    while s=0 do Application.ProcessMessages;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;

function TCashFP3530T.CloseReceiptEx(out CheckId: String): boolean;
begin
  CheckId := '';
  result := CloseReceipt;
end;

function TCashFP3530T.GetLastCheckId: Integer;
begin
  Result := 0;
end;

function TCashFP3530T.GetAlwaysSold: boolean;
begin
  result:= FAlwaysSold;
end;

function TCashFP3530T.OpenReceipt(const isFiscal: boolean = true; const isPrintSumma: boolean = false; const isReturn: boolean = False): boolean;
begin
  result := true;
  try
    status:= 0;
    if FAlwaysSold then exit;
    s:=0;
    if FisFiscal then
    begin
      if isReturn then
        OpenRepaymentReceipt(0, PrinterResults, 0, 1,'0000',0, true)
      else OpenFiscalReceipt(0, PrinterResults, 0, 1,'0000',0, true)
    end else OpenNonfiscalReceipt(0, PrinterResults, 0);
    while s=0 do Application.ProcessMessages;

    s:=0;
    GetStatus(0, PrinterResults, 0,True);
    while s=0 do Application.ProcessMessages;
  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;

procedure TCashFP3530T.SetAlwaysSold(Value: boolean);
begin
  FAlwaysSold:= Value
end;

procedure TCashFP3530T.SetTime;
begin
 status:= 0;

 SetDateTime(0,PrinterResults, 0, PAnsiChar(AnsiString(FormatDateTime('dd-mm-yy', Now))), PAnsiChar(AnsiString(FormatDateTime('hh:nn:ss', Now))));
 while s=0 do Application.ProcessMessages;

 s:=0;
 GetStatus(0, PrinterResults, 0, True);
 while s=0 do Application.ProcessMessages;
end;

function TCashFP3530T.GetTime : TDateTime;
   var S1 : AnsiString;
begin
 status:= 0;

  GetDateTime(0,PrinterResults, 0);
  while s=0 do Application.ProcessMessages;

  S1 := Unit_rt.RetItem[1] + ' ' + Unit_rt.RetItem[2];
  S1 := StringReplace(S1, '-', FormatSettings.DateSeparator, [rfReplaceAll]);
  Result := StrToDateTime(String(S1));

 s:=0;
 GetStatus(0, PrinterResults, 0, True);
 while s=0 do Application.ProcessMessages;

end;


function TCashFP3530T.SoldCode(const GoodsCode: integer;
  const Amount: double; const Price: double = 0.00): boolean;
begin
  result := true;
  try
    // продать артикул
    s:=0;
    GetStatus(0, PrinterResults, 0,True);
    while s=0 do Application.ProcessMessages;

    s:=0;
    SaleArticleAndDisplay(0, PrinterResults, 0, True, GoodsCode, Amount,0,0);
    while s=0 do Application.ProcessMessages;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;

function TCashFP3530T.SoldFromPC(const GoodsCode: integer; const GoodsName, UKTZED: string; const Amount, Price, NDS: double): boolean;
var NDSType: char;
    CashCode: integer;
    I : Integer;
    L : string;
    Res: TArray<string>;
begin
  result := true;
  try

    status:= 0;
    result:= true;

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

      Exit;
    end;

    if FAlwaysSold then exit;

    // найти в таблице соответсвий
    if Table.Locate('GoodsCode;Price',VarArrayOf([GoodsCode, Price]),[]) then begin
       CashCode:=Table.FieldByName('CashCode').asInteger;
       //writeln(LogFile,FormatDateTime('dd-mm-yyyy hh:mm:ss',Now)+' Код в таблице найден  '+IntToStr(CashCode));
       //Flush(LogFile);
    end
    else begin
       {вводим новую связь и программируем}
       Table.Last;
       CashCode:=Table.FieldByName('CashCode').asInteger+1;
       Table.AppendRecord([GoodsCode, CashCode, Price]);
       SaveLocalData(Table,Goods_lcl);

       ProgrammingGoods(CashCode, UKTZED + IfThen(UKTZED = '', '' , ' ') + GoodsName, Price, NDS);
    end;

    // продать артикул
    s:=0;
    GetStatus(0, PrinterResults, 0,True);
    while s=0 do Application.ProcessMessages;

    s:=0;
    SaleArticleAndDisplay(0, PrinterResults, 0, True, CashCode, Amount,0,0);
    while s=0 do Application.ProcessMessages;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;

function TCashFP3530T.ProgrammingGoods(const GoodsCode: integer;
  const GoodsName: string; const Price, NDS: double): boolean;
var NDSType: Ansichar;
begin
  result := true;
  if not FisFiscal then Exit;
  try
    status:= 0;
    if NDS=0 then NDSType:='Б' else NDSType:='А';
   // программирование артикула
    s:=0;
    GetStatus(0, PrinterResults, 0,True);
    while(s=0)do begin end;

    s:=0;                                                       //группа
    ProgrammingArticle(0, PrinterResults, 0, NDSType, GoodsCode, 1, Price, '0000', PAnsiChar(AnsiString(AnsiUpperCase(copy(GoodsName,1,20)))));
    while s=0 do Application.ProcessMessages;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;

procedure TCashFP3530T.Anulirovt;
begin

end;

function TCashFP3530T.CashInputOutput(const Summa: double): boolean;
begin
  result := true;
  try
    status:= 0;
    s:=0;
    GetStatus(0, PrinterResults, 0, True);
    while s=0 do Application.ProcessMessages;

    s:=0;
    ServiceInputOutput(0,PrinterResults,1,summa);
    while s=0 do Application.ProcessMessages;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;

function TCashFP3530T.TotalSumm(Summ, SummAdd: double; PaidType: TPaidType): boolean;
begin
  result := true;
  try
    status:= 0;
    if FAlwaysSold then exit;
    // Олпата
    s:=0;
    GetStatus(0, PrinterResults, 0,True);
    while s=0 do Application.ProcessMessages;

    s:=0;
    if PaidType=ptMoney then
       Total(0, PrinterResults, 0, '', 'P', SimpleRoundTo(Summ, -2))
    else
       Total(0, PrinterResults, 0, '', 'D', SimpleRoundTo(Summ, -2));

    while s=0 do Application.ProcessMessages;

    if (PaidType = ptCardAdd) and (SummAdd <> 0) then
       Total(0, PrinterResults, 0, '', 'P', SimpleRoundTo(SummAdd, -2));

    while s=0 do Application.ProcessMessages;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;

function TCashFP3530T.DiscountGoods(Summ: double): boolean;
begin

end;

function TCashFP3530T.ClosureFiscal: boolean;
begin
  result := true;
  try
    status:= 0;
    s:=0;
    GetStatus(0, PrinterResults, 0, True);
    while s=0 do Application.ProcessMessages;

    s:=0;
    FiscalClosure(0, PrinterResults, 0, '0000', 'N') ;
    while s=0 do Application.ProcessMessages;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;

function TCashFP3530T.DeleteArticules(const GoodsCode: integer): boolean;
begin
  result := true;
  try
    status:= 0;
    s:=0;
    GetStatus(0, PrinterResults, 0,True);
    while s=0 do Application.ProcessMessages;

    s:=0;
    DeleteArticle(0, PrinterResults, 0, GoodsCode, '0000');
    while s=0 do Application.ProcessMessages;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;

function TCashFP3530T.FiscalNumber: String;
begin

end;

function TCashFP3530T.SerialNumber:String;
begin
  Result := '';
end;

function TCashFP3530T.XReport: boolean;
begin
  result := true;
  try
    status:= 0;
    s:=0;
    GetStatus(0, PrinterResults, 0, True);
    while s=0 do Application.ProcessMessages;

    s:=0;
    FiscalClosure(0, PrinterResults, 0, '0000', '2') ;
    while s=0 do Application.ProcessMessages;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;

function TCashFP3530T.ChangePrice(const GoodsCode: integer;
  const Price: double): boolean;
begin
  result := true;
  try
    status:= 0;
    s:=0;
    GetStatus(0, PrinterResults, 0,True);
    while(s=0)do Application.ProcessMessages;

    s:=0;
    ChangeArticlePrice(0, PrinterResults, 0, GoodsCode, Price, '0000');
    while s=0 do Application.ProcessMessages;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;

function TCashFP3530T.GetLastErrorCode: integer;
begin
  result:= status
end;

function TCashFP3530T.GetArticulInfo(const GoodsCode: integer;
  var ArticulInfo: WideString): boolean;
var i: integer;
begin
  result := true;
  try
    status:= 0;
    s:=0;
    GetStatus(0, PrinterResults, 0,True);
    while(s=0)do Application.ProcessMessages;

    ArticulInfo:='RetItem - ';
    s:=0;
    GetArticleInfo(0, PrinterResults, 0, GoodsCode);
    while s=0 do Application.ProcessMessages;
    for i:=1 to 20 do
        ArticulInfo:=ArticulInfo+Unit_rt.RetItem[i]+#10#13;

    ArticulInfo:=ArticulInfo+'  CmdName  ' +Unit_rt.CmdName+ '  SendStr  '+Unit_rt.SendStr+ '  Whole  '+Unit_rt.Whole;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;

function TCashFP3530T.PrintNotFiscalText(
  const PrintText: WideString): boolean;
begin
  result := true;
  try
    status:= 0;
    s:=0;
    GetStatus(0, PrinterResults, 0,True);
    while(s=0)do Application.ProcessMessages;

    s:=0;
    PrintNoFiscalText(0, PrinterResults, 0, PAnsiChar(AnsiString(PrintText)));
    while s=0 do Application.ProcessMessages;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;

function TCashFP3530T.PrintFiscalText(
  const PrintText: WideString): boolean;
var APrintText: String;
begin
  result := true;
  try
    status:= 0;
    s:=0;
    GetStatus(0, PrinterResults, 0,True);
    while(s=0)do Application.ProcessMessages;

    APrintText:= PrintText;

    s:=0;
    dllPrintFiscalText(0, PrinterResults, 0, PAnsiChar(AnsiString(APrintText)));
    while s=0 do Application.ProcessMessages;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;

function TCashFP3530T.SubTotal(isPrint, isDisplay: WordBool; Percent,
  Disc: Double): boolean;
begin
  result := true;
  try
    status:= 0;
    s:=0;
    GetStatus(0, PrinterResults, 0, True);
    while(s=0)do Application.ProcessMessages;

    s:=0;
    dllSubTotal(0, PrinterResults, 0, isPrint, isDisplay, Percent, Disc);

    while s=0 do Application.ProcessMessages;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;


function TCashFP3530T.PrintFiscalMemoryByDate(inStart,
  inEnd: TDateTime): boolean;
var StartStr, EndStr: string;
begin
  result := true;
  try

    StartStr:=FormatDateTime('DDMMYY', inStart);
    EndStr:=FormatDateTime('DDMMYY', inEnd);
    status:= 0;
    s:=0;
    GetStatus(0, PrinterResults, 0,True);
    while s=0 do Application.ProcessMessages;

    s:=0;
    dllPrintFiscalMemoryByDate(0, PrinterResults, 0, '0000', PAnsiChar(AnsiString(StartStr)), PAnsiChar(AnsiString(EndStr)));
    while s=0 do Application.ProcessMessages;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;

function TCashFP3530T.PrintFiscalMemoryByNum(inStart,
  inEnd: Integer): boolean;
begin
  result := true;
  try
    status:= 0;
    s:=0;
    GetStatus(0, PrinterResults, 0,True);
    while s=0 do Application.ProcessMessages;

    s:=0;
    dllPrintFiscalMemoryByNum(0, PrinterResults, 0, '0000', inStart, inEnd);
    while s=0 do Application.ProcessMessages;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;

function TCashFP3530T.PrintReportByDate(inStart,
  inEnd: TDateTime): boolean;
begin

end;

function TCashFP3530T.PrintZeroReceipt: boolean;
begin
  OpenReceipt;
  SubTotal(true, true, 0, 0);
  TotalSumm(0, 0, ptMoney);
  CloseReceipt;
end;

function TCashFP3530T.PrintReportByNum(inStart, inEnd: Integer): boolean;
begin

end;

procedure TCashFP3530T.ClearArticulAttachment;
begin
  Table.Close;
  if FileExists(CashAttachment_lcl) then DeleteFile(CashAttachment_lcl);
  Table.Open
end;

function TCashFP3530T.InfoZReport : string;
begin
  Result := '';
end;

function TCashFP3530T.JuridicalName : string;
begin
  Result := '';
end;

function TCashFP3530T.ZReport : Integer;
begin
  Result := 0;
end;

function TCashFP3530T.SummaReceipt : Currency;
begin
  Result := 0;
end;

function TCashFP3530T.GetTaxRate : string;
begin
  Result := '';
end;

function TCashFP3530T.SensZReportBefore : boolean;
begin
  Result := True;
end;

function TCashFP3530T.SummaCash : Currency;
begin
  Result := 0;
end;

function TCashFP3530T.SummaCard : Currency;
begin
  Result := 0;
end;

function TCashFP3530T.ReceiptsSales : Integer;
begin
  Result := 0;
end;

function TCashFP3530T.ReceiptsReturn : Integer;
begin
  Result := 0;
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




