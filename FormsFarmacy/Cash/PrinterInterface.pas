unit PrinterInterface;

interface
type

   IPrinter = interface

     function PrintText(const AText : WideString): boolean;
     function SerialNumber:String;
     function LengNoFiscalText : integer;
   end;

implementation

end.
