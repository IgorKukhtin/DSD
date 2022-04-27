unit Printer_Emulation;

interface

uses Windows, PrinterInterface;

type

  TPrinterEmulation = class(TInterfacedObject, IPrinter)
  private
  protected
    function PrintText(const AText : String): boolean;
    function SerialNumber:String;
  public
  end;

implementation

uses Forms, SysUtils, Dialogs, Math, Variants, StrUtils, RegularExpressions, Log;


{ TPrinterEmulation }

function TPrinterEmulation.PrintText(const AText : String): boolean;
begin
  Result := True;
  ShowMessage('Тестовый принтер'#13#10#13#10 + AText);
end;

function TPrinterEmulation.SerialNumber:String;
begin
  Result := '';
end;

end.

