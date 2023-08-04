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
      function GetTextCheck : string;
      function GetProcessType : TPosProcessType;
      function GetProcessState : TPosProcessState;
      function GetCanceled : Boolean;
      function GetRRN : string;

      function CheckConnection : Boolean;
      function Payment(ASumma : Currency) : Boolean;
      function Refund(ASumma : Currency; ARRN : String) : Boolean;
      function ServiceMessage : Boolean;
      procedure Cancel;
      property OnMsgDescriptionProc: TMsgDescriptionProc read GetMsgDescriptionProc write SetMsgDescriptionProc;
      property LastPosError : String read GetLastPosError;
      property ProcessType : TPosProcessType read GetProcessType;
      property ProcessState : TPosProcessState read GetProcessState;
      property TextCheck : String read GetTextCheck;
      property Canceled : Boolean read GetCanceled;
      property RRN : String read GetRRN;
   end;

implementation

end.

