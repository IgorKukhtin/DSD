unit Printer_Emulation;

interface

uses Windows, PrinterInterface;

type

  TPrinterEmulation = class(TInterfacedObject, IPrinter)
  private
    FText : String;
    FLengNoFiscalText : integer;
    function AddPrintLine(const PrintText: WideString): boolean;
    function PrintLine(const PrintText: WideString): boolean;
  protected
    function PrintText(const AText : WideString): boolean;
    function SerialNumber:String;
  public
    constructor Create;
    function LengNoFiscalText : integer;
  end;

implementation

uses Forms, SysUtils, Dialogs, Math, Variants, StrUtils, RegularExpressions, Log;


{ TPrinterEmulation }

constructor TPrinterEmulation.Create;
begin
  inherited Create;
  FLengNoFiscalText := 48;
end;

function TPrinterEmulation.AddPrintLine(const PrintText: WideString): boolean;
var I : Integer;
begin
  I := 1;
  while COPY(PrintText, I, FLengNoFiscalText) <> '' do
  begin
    FText := FText +  #13#10 + COPY(PrintText, I, FLengNoFiscalText);
    I := I + FLengNoFiscalText;
  end;
  Result := True;
end;

function TPrinterEmulation.PrintLine(const PrintText: WideString): boolean;
var I : Integer;
    L : WideString;
    N : WideString;
    Res: TArray<string>;
begin
  Result := False;
  L := '';
  Res := TRegEx.Split(TrimRight(PrintText), ' ');
  for I := 0 to High(Res) do
  begin
    if (Res[i] = '') or (L <> '') then L := L + ' ';
    if Res[i] <> '' then L := L + Res[i];
    if I < High(Res) then N := ' ' + Res[i + 1] else N := '';
    if Length(L + N) > FLengNoFiscalText then
    begin
      if not AddPrintLine(L) then Exit;
      L := '';
    end;
  end;
  if L <> '' then if not AddPrintLine(L) then Exit;
  Result := True;
end;

function TPrinterEmulation.PrintText(const AText : WideString): boolean;
var I : Integer;
    Res: TArray<string>;
begin
  Result := True;
  FText := '';
  Res := TRegEx.Split(AText, #$D#$A);
  for I := 0 to High(Res) do
  begin
    if not PrintLine(Res[I]) then Exit;
  end;

  ShowMessage('Тестовый принтер'#13#10 + FText);
end;

function TPrinterEmulation.SerialNumber:String;
begin
  Result := '';
end;

function TPrinterEmulation.LengNoFiscalText : integer;
begin
  Result := FLengNoFiscalText;
end;

end.

