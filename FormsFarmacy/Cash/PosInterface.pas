unit PosInterface;

interface

type

   TMsgDescriptionProc = procedure(AMsgDescription : string) of object;

   IPos = interface
      procedure SetMsgDescriptionProc(Value: TMsgDescriptionProc);
      function GetMsgDescriptionProc: TMsgDescriptionProc;
      function GetLastPosError : string;

      function CheckConnection : Boolean;
      function Payment(ASumma : Currency) : Boolean;
      function Refund(ASumma : Currency) : Boolean;
      procedure Cancel;
      property OnMsgDescriptionProc: TMsgDescriptionProc read GetMsgDescriptionProc write SetMsgDescriptionProc;
      property LastPosError : String read GetLastPosError;
   end;

implementation

end.
