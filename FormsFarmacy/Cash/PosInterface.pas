unit PosInterface;

interface

type

   TMsgDescriptionProc = procedure(AMsgDescription : string) of object;
   TPosProcessType = (pptProcess, pptThread);
   TPosProcessState = (ppsUndefined, ppsWaiting, ppsOkConnection, ppsOkPayment, ppsOkRefund, ppsError);

   IPos = interface
      procedure SetMsgDescriptionProc(Value: TMsgDescriptionProc);
      function GetMsgDescriptionProc: TMsgDescriptionProc;
      function GetLastPosError : string;
      function GetProcessType : TPosProcessType;
      function GetProcessState : TPosProcessState;

      function CheckConnection : Boolean;
      function Payment(ASumma : Currency) : Boolean;
      function Refund(ASumma : Currency) : Boolean;
      procedure Cancel;
      property OnMsgDescriptionProc: TMsgDescriptionProc read GetMsgDescriptionProc write SetMsgDescriptionProc;
      property LastPosError : String read GetLastPosError;
      property ProcessType : TPosProcessType read GetProcessType;
      property ProcessState : TPosProcessState read GetProcessState;
   end;

implementation

end.
