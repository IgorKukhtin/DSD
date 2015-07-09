unit Cash_FP3530T;

interface
uses Windows, CashInterface, DBTables;
type
  TCashFP3530T = class(TInterfacedObject, ICash)
  private
    Table: TTable;
    FAlwaysSold: boolean;
    procedure SetAlwaysSold(Value: boolean);
    function GetAlwaysSold: boolean;
  protected
    function SoldCode(const GoodsCode: integer; const Amount: double; const Price: double = 0.00): boolean;
    function SoldFromPC(const GoodsCode: integer; const GoodsName: string; const Amount, Price, NDS: double): boolean; //������� � ����������
    function ChangePrice(const GoodsCode: integer; const Price: double): boolean;
    function OpenReceipt(const isFiscal: boolean = true): boolean;
    function CloseReceipt: boolean;
    function CashInputOutput(const Summa: double): boolean;
    function ProgrammingGoods(const GoodsCode: integer; const GoodsName: string; const Price, NDS: double): boolean;
    function ClosureFiscal: boolean;
    function TotalSumm(Summ: double; PaidType: TPaidType): boolean;
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
    function PrintReportByNum(inStart, inEnd: Integer): boolean;
    function FiscalNumber:String;
    procedure ClearArticulAttachment;
    procedure SetTime;
    procedure Anulirovt;
  public
    constructor Create;
  end;



implementation
uses Forms, SysUtils, Dialogs, Math, Variants, BDE;

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
     raise Exception.Create('�������������� ������');
  //if (INVALID_CMD and rt.Status <> 0) then
    // raise Exception.Create('�������� �������');
  if (INVALID_TIME and rt.Status <> 0) then
     raise Exception.Create('���� � ����� �������');
  if (PRINT_ERROR and rt.Status <> 0) then
     raise Exception.Create('������ ������');
  if (SUM_OVERFLOW and rt.Status <> 0) then
     raise Exception.Create('�������������� ������������');
  if (CMD_NOT_ALLOWED and rt.Status <> 0) then
     raise Exception.Create('������� �� ���������');
  if (RAM_CLEARED and rt.Status <> 0) then
     raise Exception.Create('��������� ���');
  if (RAM_DESTROYED and rt.Status <> 0) then
     raise Exception.Create('��������� ���');
  if (PAPER_OUT and rt.Status <> 0) then
     raise Exception.Create('��� ������');
  if (F_ABSENT and rt.Status <> 0) then
     raise Exception.Create('�� ������ ����. ������');
  if (F_LESS_30 and rt.Status <> 0) then
     raise Exception.Create('� ����. ������ ���� �����');
  if (F_WRITE_ERROR and rt.Status <> 0) then
     raise Exception.Create('������ ������ � ����. ������');
  if (F_FULL and rt.Status <> 0) then
     raise Exception.Create('����. ������ �����������');
  if (F_READ_ONLY and rt.Status <> 0) then
     raise Exception.Create('������ � ����. ������ ���������');
  if (F_CLOSE_ERROR and rt.Status <> 0) then
     raise Exception.Create('������ ���������� Z-������');
  if (PROTOCOL_ERROR and rt.Status <> 0) then
     raise Exception.Create('������ ���������');
  if (NACK_RECEIVED and rt.Status <> 0) then
     raise Exception.Create('������ ������ �������');
  if (TIMEOUT_ERROR and rt.Status <> 0) then
     raise Exception.Create('�������');
  if (COMMON_ERROR and rt.Status <> 0) then
     raise Exception.Create('����� ������');
  if (F_COMMON_ERROR and rt.Status <> 0) then
     raise Exception.Create('����� ������ ����. ������');

end;

{ TCashFP3530T }
constructor TCashFP3530T.Create;
begin
  inherited Create;
  FAlwaysSold:=false;
  InitFPport(1, 19200);
  SetDecimals(2);
  Table:= TTable.Create(nil);
  Table.TableName:='CashAttachment.db';
  Table.Open;
  Table.Filtered:=true;
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
    CloseFiscalReceipt(0, PrinterResults, 0);
    while s=0 do Application.ProcessMessages;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
end;

function TCashFP3530T.GetAlwaysSold: boolean;
begin
  result:= FAlwaysSold;
end;

function TCashFP3530T.OpenReceipt(const isFiscal: boolean = true): boolean;
begin
  result := true;
  try
    status:= 0;
    if FAlwaysSold then exit;
    s:=0;
    OpenFiscalReceipt(0, PrinterResults, 0, 1,'0000',0, true);
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

function TCashFP3530T.SoldCode(const GoodsCode: integer;
  const Amount: double; const Price: double = 0.00): boolean;
begin
  result := true;
  try
    // ������� �������
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

function TCashFP3530T.SoldFromPC(const GoodsCode: integer; const GoodsName: string; const Amount, Price, NDS: double): boolean;
var NDSType: char;
    CashCode: integer;
begin
  result := true;
  try

    status:= 0;
    result:= true;
    if FAlwaysSold then exit;

    // ����� � ������� �����������
    if Table.Locate('GoodsCode;Price',VarArrayOf([GoodsCode, Price]),[]) then begin
       CashCode:=Table.FieldByName('CashCode').asInteger;
       //writeln(LogFile,FormatDateTime('dd-mm-yyyy hh:mm:ss',Now)+' ��� � ������� ������  '+IntToStr(CashCode));
       //Flush(LogFile);
    end
    else begin
       {������ ����� ����� � �������������}
       Table.Last;
       CashCode:=Table.FieldByName('CashCode').asInteger+1;

       Table.AppendRecord([GoodsCode, CashCode, Price]);
       Table.Close;
       Table.Open;

        ProgrammingGoods(CashCode, GoodsName, Price, NDS);
    end;

    // ������� �������
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
  try
    status:= 0;
    if NDS=0 then NDSType:='�' else NDSType:='�';
   // ���������������� ��������
    s:=0;
    GetStatus(0, PrinterResults, 0,True);
    while(s=0)do begin end;

    s:=0;                                                       //������
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

function TCashFP3530T.TotalSumm(Summ: double; PaidType: TPaidType): boolean;
begin
  result := true;
  try
    status:= 0;
    if FAlwaysSold then exit;
    // ������
    s:=0;
    GetStatus(0, PrinterResults, 0,True);
    while s=0 do Application.ProcessMessages;

    s:=0;
    if PaidType=ptMoney then
       Total(0, PrinterResults, 0, '', 'P', SimpleRoundTo(Summ, -2))
    else
       Total(0, PrinterResults, 0, '', 'D', SimpleRoundTo(Summ, -2));
    while s=0 do Application.ProcessMessages;

  except
    on E: Exception do begin
       ShowMessage(E.Message);
       result := false;
    end;
  end;
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

function TCashFP3530T.PrintReportByNum(inStart, inEnd: Integer): boolean;
begin

end;

procedure TCashFP3530T.ClearArticulAttachment;
begin
  Table.Close;
  Table.EmptyTable;
  Table.Open
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




