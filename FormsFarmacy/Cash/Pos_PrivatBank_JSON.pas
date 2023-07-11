unit Pos_PrivatBank_JSON;

{$I ..\..\DPR\dsdVer.inc }

interface

uses Winapi.Windows, Winapi.ActiveX, System.Variants, System.SysUtils, System.Win.ComObj,
     System.Classes, PosInterface, IdTCPClient, IdThreadComponent, IdGlobal, Vcl.Forms,
     {$IFDEF DELPHI103RIO} System.JSON {$ELSE} Data.DBXJSON {$ENDIF};

type
  TPos_PrivatBank_JSON = class(TInterfacedObject, IPos)
  private
    FIdTCPClient: TIdTCPClient;
    FidThreadComponent: TIdThreadComponent;
    FLastPosError : String;
    FHost : String;
    FPort : Integer;
    FCancel : Boolean;
    FMsgDescriptionProc : TMsgDescriptionProc;
    FPOSTerminalCode : integer;
    FInvoiceNumber: String;
    FProcessState: TPosProcessState;

    procedure SetMsgDescriptionProc(Value: TMsgDescriptionProc);
    function GetMsgDescriptionProc: TMsgDescriptionProc;
    function GetLastPosError : string;
    function GetProcessType : TPosProcessType;
    function GetProcessState : TPosProcessState;
    procedure IdThreadComponentRun(Sender: TIdThreadComponent);
  protected
    function CheckConnection : Boolean;
    function Payment(ASumma : Currency) : Boolean;
    function Refund(ASumma : Currency) : Boolean;
    procedure Cancel;
  public
    constructor Create(APOSTerminalCode : Integer);
    function DoPayment(ASumma : Currency; ARefund : Boolean) : Boolean;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    property LastPosError : String read GetLastPosError;
    property Host : String read FHost write FHost;
    property Port : Integer read FPort write FPort;
  end;

implementation

uses IniUtils;

procedure Add_PosLog(AMessage: String);
  var F: TextFile;
begin
  try
    AssignFile(F,ChangeFileExt(Application.ExeName,'_PosJSON.log'));
    if not fileExists(ChangeFileExt(Application.ExeName,'_PosJSON.log')) then
    begin
      Rewrite(F);
    end
    else
      Append(F);
    //
    try  Writeln(F, DateTimeToStr(Now) + ': ' + AMessage);
    finally CloseFile(F);
    end;
  except
  end;
end;

constructor TPos_PrivatBank_JSON.Create(APOSTerminalCode : Integer);
begin
  inherited Create;
  FPOSTerminalCode := APOSTerminalCode;
end;

procedure TPos_PrivatBank_JSON.SetMsgDescriptionProc(Value: TMsgDescriptionProc);
begin
  FMsgDescriptionProc := Value;
end;

function TPos_PrivatBank_JSON.GetMsgDescriptionProc: TMsgDescriptionProc;
begin
  Result := FMsgDescriptionProc;
end;

function TPos_PrivatBank_JSON.GetLastPosError : string;
begin
  Result := FLastPosError;
end;

function TPos_PrivatBank_JSON.GetProcessType : TPosProcessType;
begin
  Result := pptThread;
end;

function TPos_PrivatBank_JSON.GetProcessState : TPosProcessState;
begin
  Result := FProcessState;
end;

procedure TPos_PrivatBank_JSON.AfterConstruction;
begin
  inherited AfterConstruction;

  FIdTCPClient := TIdTCPClient.Create;
  FHost := iniPosHost(FPOSTerminalCode);
  FPort := iniPosPortNumber(FPOSTerminalCode);

  FidThreadComponent := TIdThreadComponent.Create();
  FidThreadComponent.OnRun := IdThreadComponentRun;

  FCancel := False;
  FProcessState := ppsUndefined;
end;

procedure TPos_PrivatBank_JSON.BeforeDestruction;
begin
  if FidThreadComponent.Active then FidThreadComponent.Active := False;
  FreeAndNil(FIdTCPClient);
  FreeAndNil(FIdThreadComponent);
  inherited BeforeDestruction;
end;

procedure TPos_PrivatBank_JSON.IdThreadComponentRun(Sender: TIdThreadComponent);
var JSONObject: TJSONObject; JSONPair: TJSONPair;
    msgFromServer : string;
begin
  // ... read message from server
  Add_PosLog('Проверка буфера.');
  if not FIdTCPClient.IOHandler.CheckForDataOnSource then Exit;

  Add_PosLog('Читаем.');
  msgFromServer := FIdTCPClient.IOHandler.ReadLn(#0, IndyTextEncoding_UTF8);

  if msgFromServer = '' then
  begin
    Add_PosLog(msgFromServer);

    try
      try
          JSONObject := TJSONObject.ParseJSONValue(msgFromServer) as TJSONObject;
          try
            JSONPair := JSONObject.Get('error');
            if (JSONPair <> nil) and (JSONPair.Value = 'false')  then
            begin
              if LowerCase(JSONObject.Get('method').Value) = LowerCase('CheckConnection') then FProcessState := ppsOkConnection;
              if LowerCase(JSONObject.Get('method').Value) = LowerCase('Purchase') then FProcessState := ppsOkPayment;
              if LowerCase(JSONObject.Get('method').Value) = LowerCase('Refund') then FProcessState := ppsOkRefund;
            end else
            begin
              FLastPosError := 'Ошибка: ';
              JSONPair := JSONObject.Get('errorDescription');
              if JSONPair <> nil  then FLastPosError := ' ' + JSONPair.Value;
            end;
          finally
            JSONObject.Free;
          end;
      except on E:Exception do FLastPosError := e.Message;
      end;
    finally
      if FLastPosError <> '' then Add_PosLog(FLastPosError);
      if FLastPosError <> '' then FProcessState := ppsError;
    end;
  end;

end;

function TPos_PrivatBank_JSON.CheckConnection : Boolean;
  var JSONObject: TJSONObject; JSONPair: TJSONPair;
      JsonToSend: TStringStream;
begin

  if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('Проверка связи с терминалом');
//  FProcessState := ppsError;

  try
    JSONObject := TJSONObject.Create;
    JSONObject.AddPair('method', 'CheckConnection');
    JSONObject.AddPair('step', TJSONNumber.Create(0));

    JsonToSend := TStringStream.Create(JSONObject.ToString + #0, TEncoding.UTF8);
    try
      try
        FIdTCPClient.Host := FHost;
        FIdTCPClient.Port := FPort;
        FIdTCPClient.ConnectTimeout := 2000;
        FIdTCPClient.Connect;

        Add_PosLog(JsonToSend.DataString);
        if FIdTCPClient.Connected then
        begin
          FIdThreadComponent.Active  := True;
          FIdTCPClient.IOHandler.Write(JsonToSend);
          FProcessState := ppsWaiting;
        end;
      except on E:Exception do FLastPosError := 'Ошибка проверки связи : ' + e.Message;
      end;
    finally
      JSONObject.Free;
      JsonToSend.Free;
    end;
  except on E:Exception do FLastPosError := 'Ошибка проверки связи : ' + e.Message;
  end;

  if FLastPosError <> '' then Add_PosLog(FLastPosError);
end;

function TPos_PrivatBank_JSON.DoPayment(ASumma : Currency; ARefund : Boolean) : Boolean;
  var JSONObject, JSONParams: TJSONObject; JSONPair: TJSONPair;
      JsonToSend: TStringStream;
begin

//  FProcessState := ppsError;
  try
    JSONParams := TJSONObject.Create;
    JSONParams.AddPair('amount', TJSONString.Create(FormatCurr('0.00', ASumma)));
    JSONParams.AddPair('discount', TJSONString.Create('0'));
    JSONParams.AddPair('merchantId', TJSONString.Create('0'));

    JSONObject := TJSONObject.Create;
    if ARefund then JSONObject.AddPair('method', 'Refund')
    else JSONObject.AddPair('method', 'Purchase');
    JSONObject.AddPair('step', TJSONNumber.Create(0));
    JSONObject.AddPair('params', JSONParams);

    JsonToSend := TStringStream.Create(JSONObject.ToString + #0, TEncoding.UTF8);
    try
      try

        Add_PosLog(JsonToSend.DataString);
        if FIdTCPClient.Connected then
        begin
          FIdTCPClient.IOHandler.Write(JsonToSend);
          FProcessState := ppsWaiting;
        end;

      except on E:Exception do FLastPosError := 'Ошибка выполнения оплаты (возврата) : ' + e.Message;
      end;
    finally
      JSONObject.Free;
      JsonToSend.Free;
    end;
  except on E:Exception do FLastPosError := 'Ошибка выполнения оплаты (возврата) : ' + e.Message;
  end;

  if FLastPosError <> '' then Add_PosLog(FLastPosError);
end;

function TPos_PrivatBank_JSON.Payment(ASumma : Currency) : Boolean;
begin

  if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('Выполнение оплаты');

  Result := DoPayment(ASumma, False);
end;

function TPos_PrivatBank_JSON.Refund(ASumma : Currency) : Boolean;
begin
  if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('Выполнение возврата');

  Result := DoPayment(ASumma, True);
end;

procedure TPos_PrivatBank_JSON.Cancel;
begin
  FCancel := True;
end;

end.
