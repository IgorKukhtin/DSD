unit PrinterFactory;

interface

uses PrinterInterface;

type
  TPrinterFactory = class
    class function GetPrinter(PrinterType: string): IPrinter;
  end;

implementation

uses Printer_FP3530T_NEW, Printer_Emulation, SysUtils;

{ TCashFactory }
class function TPrinterFactory.GetPrinter(PrinterType: string): IPrinter;
begin
  if PrinterType = '' then Exit;

  if PrinterType = 'FP3530T_NEW' then
     result := TPrinterFP3530T_NEW.Create;
  if PrinterType = 'Emulation' then
     result := TPrinterEmulation.Create;
  if not Assigned(Result) then
     raise Exception.Create('Не правильно указан тип принтера в Ini файле');

end;

end.
