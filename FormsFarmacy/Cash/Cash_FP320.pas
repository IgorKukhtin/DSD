unit Cash_FP320;

interface
uses Windows, CashInterface, OposFiscalPrinter_1_11_Lib_TLB, ComObj;

type
  TCashFP320 = class(TInterfacedObject, ICash)
  private
    FAlwaysSold: boolean;
    FPrinter: IOPOSFiscalPrinter; //Variant; //IFPT260Retail;
    Err: String;
    ErrCode: Integer;
    Connected: Boolean;
    FTotalSummaCheck: Currency;
    procedure SetAlwaysSold(Value: boolean);
    function GetAlwaysSold: boolean;
    function PrinterException(ACreateException: Boolean = False): Boolean;
  protected
    function SoldCode(const GoodsCode: integer; const Amount: double; const Price: double = 0.00): boolean;
    function SoldFromPC(const GoodsCode: integer; const GoodsName: string; const Amount, Price, NDS: double): boolean; //Продажа с компьютера
    function ChangePrice(const GoodsCode: integer; const Price: double): boolean;
    function OpenReceipt(const isFiscal: boolean = true; const isPrintSumma: boolean = false): boolean;
    function CloseReceipt: boolean;
    function CloseReceiptEx(out CheckId: String): boolean;
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
    function PrintReportByNum(inStart, inEnd: Integer): boolean;
    function PrintZeroReceipt: boolean;
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
  public
    constructor Create;
  end;
implementation

uses
  Forms, SysUtils, Dialogs, Math, Variants, StrUtils, IniUtils, Log;

const
  Password = '000000';

{ TCashFP320 }

procedure TCashFP320.Anulirovt;
begin

end;

function TCashFP320.CashInputOutput(const Summa: double): boolean;
begin
  result := False;
  if not Connected then exit;
  FPrinter.ResetPrinter();

  if Summa >= 0 then
    FPrinter.FiscalReceiptType := 1
  else
    FPrinter.FiscalReceiptType := 2;

  FPrinter.BeginFiscalReceipt(True);
  Result := not PrinterException;
  if not result then exit;

  FPrinter.PrintRecCash(Abs(Summa));

  Result := not PrinterException;
  if not result then exit;
  FPrinter.EndFiscalReceipt(True);
  Result := not PrinterException;
end;

function TCashFP320.ChangePrice(const GoodsCode: integer;
  const Price: double): boolean;
begin

end;

procedure TCashFP320.ClearArticulAttachment;
begin

end;

function TCashFP320.CloseReceipt: boolean;
begin
  Result := False;
	if FPrinter.PrinterState = 9 then
		FPrinter.EndNonFiscal()
  else
    FPrinter.EndFiscalReceipt(True);
  result := not PrinterException;
end;

function TCashFP320.CloseReceiptEx(out CheckId: String): boolean;
begin
  Result := CloseReceipt;
end;

function TCashFP320.ClosureFiscal: boolean;
begin
  result := False;
  if not Connected then exit;
  FPrinter.ResetPrinter();
	FPrinter.PrintZReport();
  Result := not PrinterException;
end;

constructor TCashFP320.Create;
begin
  inherited Create;
  err := '';
  FAlwaysSold:=false;
  Connected := False;

  FPrinter := CreateOleObject('OPOS.FiscalPrinter') as IOPOSFiscalPrinter;
  FPrinter.Open('FiscPrinter');
  if PrinterException(True) then exit;

  FPrinter.ClaimDevice(20);
  FPrinter.DeviceEnabled := WordBool(1);
  if PrinterException(True) then
  Begin
     FPrinter.Close;
     freeAndNil(Self);
     exit;
  End;
  FPrinter.ResetPrinter;
  Connected := True;
end;

function TCashFP320.DeleteArticules(const GoodsCode: integer): boolean;
begin

end;

function TCashFP320.FiscalNumber: String;
var
  arg: Integer;
  Data: WideString;
begin
  Result := iniCashSerialNumber;
end;

function TCashFP320.SerialNumber:String;
begin
  Result := '';
end;

function TCashFP320.GetAlwaysSold: boolean;
begin
  result:= FAlwaysSold;
end;

function TCashFP320.GetArticulInfo(const GoodsCode: integer;
  var ArticulInfo: WideString): boolean;
begin

end;

function TCashFP320.GetLastErrorCode: integer;
begin

end;

function TCashFP320.PrinterException(ACreateException: Boolean = False): Boolean;
begin
  ErrCode := FPrinter.ResultCode;
  err := FPrinter.Get_ErrorString;
  Result := ErrCode <> 0;
  if Result then
  Begin
    if ACreateException then
      raise Exception.Create(Err)
    else
      ShowMessage(Err);
  End;
end;

function TCashFP320.OpenReceipt(const isFiscal: boolean = true; const isPrintSumma: boolean = false): boolean;
begin
  Result := False;
  FTotalSummaCheck := 0;
  if not Connected then exit;

	FPrinter.ResetPrinter;
  FPrinter.FiscalReceiptType := 4;
  if isFiscal then
    FPrinter.BeginFiscalReceipt(True)
  else
		FPrinter.BeginNonFiscal;
	Result := not PrinterException;
end;

function TCashFP320.PrintFiscalMemoryByDate(inStart, inEnd: TDateTime): boolean;
begin

end;

function TCashFP320.PrintFiscalMemoryByNum(inStart, inEnd: Integer): boolean;
begin

end;

function TCashFP320.PrintFiscalText(const PrintText: WideString): boolean;
begin

end;

function TCashFP320.PrintNotFiscalText(const PrintText: WideString): boolean;
begin

end;

function TCashFP320.PrintReportByDate(inStart, inEnd: TDateTime): boolean;
begin

end;

function TCashFP320.PrintReportByNum(inStart, inEnd: Integer): boolean;
begin

end;

function TCashFP320.PrintZeroReceipt: boolean;
begin
  OpenReceipt;
  SubTotal(true, true, 0, 0);
  TotalSumm(0, 0, ptMoney);
  CloseReceipt;
end;

function TCashFP320.ProgrammingGoods(const GoodsCode: integer;
  const GoodsName: string; const Price, NDS: double): boolean;
begin

end;

procedure TCashFP320.SetAlwaysSold(Value: boolean);
begin
  FAlwaysSold:= Value
end;

procedure TCashFP320.SetTime;
begin
  if not Connected then exit;
  FPrinter.SetDate(FormatDateTime('DDMMYYYYhhmm',Now));
end;

function TCashFP320.SoldCode(const GoodsCode: integer; const Amount,
  Price: double): boolean;
begin

end;

function TCashFP320.SoldFromPC(const GoodsCode: integer;
  const GoodsName: string; const Amount, Price, NDS: double): boolean;
var
  NDSType: Integer;
  CashCode: integer;
  Name75: String;
begin
  result := True;
  if FAlwaysSold then exit;

  Name75 := Copy(GoodsName,1,75);

	if NDS = 20 Then
    NDSType := 0
	Else
    NDSType := iniTaxGroup7;

	If FPrinter.PrinterState = 9 then
		FPrinter.PrintNormal(2,GoodsName)
	else
  if (FPrinter.FiscalReceiptType = 4) or
     (FPrinter.FiscalReceiptType = 7) then
		FPrinter.PrintRecItem(Name75,Price,ROUND(Amount*1000),NDSType,Price,'')
	else
  Begin
    Result := False;
    ShowMessage('Неизвестное состояние фискального регистратора');
    exit;
  End;
  FTotalSummaCheck := FTotalSummaCheck + RoundTo(Amount*Price, -2);
  Result := not PrinterException;
end;

function TCashFP320.SubTotal(isPrint, isDisplay: WordBool; Percent,
  Disc: Double): boolean;
begin
  result := false;
  if not Connected then exit;

  if Disc <> 0 then
  begin
    if FPrinter.CheckTotal then
      FPrinter.CheckTotal := False;

    FPrinter.PrintRecSubtotal(FTotalSummaCheck);
    Result := not PrinterException;
    if not Result then Exit;

    if Disc < 0 then
      FPrinter.PrintRecSubtotalAdjustment(1, 'СКИДКА', Abs(Disc))
    else FPrinter.PrintRecSubtotalAdjustment(2, 'НАЦЕНКА', Disc);
    Result := not PrinterException;
  end else result := True;
end;

function TCashFP320.TotalSumm(Summ, SummAdd: double; PaidType: TPaidType): boolean;
var
  SSumm: WideString;
  pData: Integer;

begin
  if not Connected then exit;
  Result := True;

  if FPrinter.CheckTotal then
    FPrinter.CheckTotal := False;

	if PaidType = ptMoney then
  Begin
    FPrinter.PrintRecTotal(Summ, Summ, '0');
  End
  else
    FPrinter.PrintRecTotal(Summ, Summ, '1');
  Result := not PrinterException;

  if Result and (PaidType = ptCardAdd) and (SummAdd <> 0) then
  begin
    FPrinter.PrintRecTotal(SummAdd, SummAdd, '0');
    Result := not PrinterException;
  end;
end;

function TCashFP320.DiscountGoods(Summ: double): boolean;
begin

end;

function TCashFP320.XReport: boolean;
begin
  if not Connected then exit;
  FPrinter.ResetPrinter;
  Result := not PrinterException;
  if not result then exit;
  FPrinter.PrintXReport;
  Result := not PrinterException;
end;

function TCashFP320.InfoZReport : string;
begin
  Result := '';
end;

function TCashFP320.JuridicalName : string;
begin
  Result := '';
end;

function TCashFP320.ZReport : Integer;
begin
  Result := 0;
end;

function TCashFP320.SummaReceipt : Currency;
begin
  Result := 0;
end;

function TCashFP320.GetTaxRate : string;
begin
  Result := '';
end;

end.
