unit PrinterInterface;

interface
type

   IPrinter = interface

     function PrintText(const AText : String): boolean;
     function SerialNumber:String;
   end;

implementation

end.
