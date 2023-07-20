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
    FRadBufer: String;
    FTextCheck: String;

    procedure SetMsgDescriptionProc(Value: TMsgDescriptionProc);
    function GetMsgDescriptionProc: TMsgDescriptionProc;
    function GetLastPosError : string;
    function GetTextCheck : string;
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
  FRadBufer := '';
  FTextCheck := '';
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

function TPos_PrivatBank_JSON.GetTextCheck : string;
begin
  Result := FTextCheck;
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
  try
    if FidThreadComponent.Active then FidThreadComponent.Active := False;
    FreeAndNil(FIdTCPClient);
    FreeAndNil(FIdThreadComponent);
  except on E:Exception do Add_PosLog('Ошибка закрытия обработки: ' + e.Message);
  end;
  inherited BeforeDestruction;
end;

procedure TPos_PrivatBank_JSON.IdThreadComponentRun(Sender: TIdThreadComponent);
var JSONObject, JSONParams: TJSONObject;
    Buffer: TIdBytes; S: String;

   function GetMasked_Pan(APan, AReceipt: TJSONPair) : string;
   begin
     Result := '';
     if (APan = nil) or (AReceipt = nil) then Exit;
     if Pos(Copy(APan.JsonValue.Value, 1, 4), AReceipt.JsonValue.Value) > 0 then
       Result := Copy(AReceipt.JsonValue.Value,
                      Pos(Copy(APan.JsonValue.Value, 1, 4), AReceipt.JsonValue.Value), 16);

   end;

begin
  // ... read message from server
  if not FIdTCPClient.IOHandler.CheckForDataOnSource then Exit;

  Add_PosLog('Читаем.');
  try
    try
      FIdTCPClient.IOHandler.ReadBytes(Buffer, -1, false);
      FRadBufer:= FRadBufer + IdGlobal.BytesToString(Buffer, IndyTextEncoding_UTF8);
    finally
      SetLength(Buffer, 0);
    end;
  except on E:Exception do FLastPosError := e.Message;
  end;

  if FLastPosError <> '' then
  begin
    FProcessState := ppsError;
    Add_PosLog(FLastPosError);
    Exit;
  end;

  if Pos(#0, FRadBufer) > 0 then
  begin
    S := Copy(FRadBufer, 1, Pos(#0, FRadBufer) - 1);
    FRadBufer := Copy(FRadBufer, Length(S) + 2,  Length(FRadBufer));
    Add_PosLog(S);

    try
      try
        JSONObject := TJSONObject.ParseJSONValue(S) as TJSONObject;
        try
          if (JSONObject.Get('error') <> nil) and (JSONObject.Get('error').JsonValue.Value = 'false')  then
          begin
            if LowerCase(JSONObject.Get('method').JsonValue.Value) = LowerCase('CheckConnection') then
              FProcessState := ppsOkConnection
            else if LowerCase(JSONObject.Get('method').JsonValue.Value) = LowerCase('Purchase') then
              FProcessState := ppsOkPayment
            else if LowerCase(JSONObject.Get('method').JsonValue.Value) = LowerCase('Refund') then
              FProcessState := ppsOkRefund
            else FProcessState := ppsError;

            FTextCheck := '';

            if (LowerCase(JSONObject.Get('method').JsonValue.Value) <> LowerCase('Purchase')) and
               (LowerCase(JSONObject.Get('method').JsonValue.Value) <> LowerCase('Refund')) then Exit;
            JSONParams := JSONObject.Get('params').JsonValue as TJSONObject;
            if JSONParams = nil then Exit;

            FTextCheck := '            Карта';
            FTextCheck := FTextCheck + #13'Термінал ';
            if (JSONParams.Get('merchant') <> nil) then
              FTextCheck := FTextCheck + JSONParams.Get('merchant').JsonValue.Value;
            if LowerCase(JSONObject.Get('method').JsonValue.Value) = LowerCase('Purchase') then
              FTextCheck := FTextCheck + #13'            Продаж';
            if LowerCase(JSONObject.Get('method').JsonValue.Value) = LowerCase('Refund') then
              FTextCheck := FTextCheck + #13'            Повернення';
            FTextCheck := FTextCheck + #13'Сума ';
            if (JSONParams.Get('amount') <> nil) then
              FTextCheck := FTextCheck + JSONParams.Get('amount').JsonValue.Value;
            FTextCheck := FTextCheck + #13'ЕПЗ ';
            if (JSONParams.Get('pan') <> nil) then
              FTextCheck := FTextCheck + GetMasked_Pan(JSONParams.Get('pan'), JSONParams.Get('receipt'));
            FTextCheck := FTextCheck + #13'Платіжна система ';
            if (JSONParams.Get('paymentSystem') <> nil) then
              FTextCheck := FTextCheck + JSONParams.Get('paymentSystem').JsonValue.Value;
            FTextCheck := FTextCheck + #13'Код авторізації ';
            if (JSONParams.Get('approvalCode') <> nil) then
              FTextCheck := FTextCheck + JSONParams.Get('approvalCode').JsonValue.Value;
            FTextCheck := FTextCheck + #13'PRN ';
            if (JSONParams.Get('rrn') <> nil) then
              FTextCheck := FTextCheck + JSONParams.Get('rrn').JsonValue.Value;
            FTextCheck := FTextCheck + #13'Чек ';
            if (JSONParams.Get('invoiceNumber') <> nil) then
              FTextCheck := FTextCheck + JSONParams.Get('invoiceNumber').JsonValue.Value;
            if (JSONParams.Get('date') <> nil) then
              FTextCheck := FTextCheck + ' ' + JSONParams.Get('date').JsonValue.Value;
            if (JSONParams.Get('time') <> nil) then
              FTextCheck := FTextCheck + ' ' + JSONParams.Get('time').JsonValue.Value;

          end else
          begin
            FLastPosError := 'Ошибка: ';
            if JSONObject.Get('errorDescription') <> nil  then
              FLastPosError := ' ' + JSONObject.Get('errorDescription').JsonValue.Value;
          end;
        finally
          JSONObject.Free;
        end;
      except on E:Exception do FLastPosError := 'Ошибка обработки ответа: ' + e.Message;
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

  try
    JSONObject := TJSONObject.Create;
    JSONObject.AddPair('method', 'CheckConnection');
    JSONObject.AddPair('step', TJSONNumber.Create(0));

    JsonToSend := TStringStream.Create(JSONObject.ToString + #0, TEncoding.UTF8);
    try
      try
        FIdTCPClient.Host := FHost;
        FIdTCPClient.Port := FPort;
        FIdTCPClient.ConnectTimeout := 4000;
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

  if FLastPosError <> '' then
  begin
    FProcessState := ppsError;
    Add_PosLog(FLastPosError);
  end;
end;

function TPos_PrivatBank_JSON.DoPayment(ASumma : Currency; ARefund : Boolean) : Boolean;
  var JSONObject, JSONParams: TJSONObject; JSONPair: TJSONPair;
      JsonToSend: TStringStream;
begin

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

  if FLastPosError <> '' then
  begin
    FProcessState := ppsError;
    Add_PosLog(FLastPosError);
  end;
end;

function TPos_PrivatBank_JSON.Payment(ASumma : Currency) : Boolean;
begin

  if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('Выполнение оплаты сумма ' + FormatCurr('0.00', ASumma));
  Add_PosLog('Выполнение оплаты сумма ' + FormatCurr('0.00', ASumma));

  Result := DoPayment(ASumma, False);
end;

function TPos_PrivatBank_JSON.Refund(ASumma : Currency) : Boolean;
begin
  if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('Выполнение возврата сумма ' + FormatCurr('0.00', ASumma));
  Add_PosLog('Выполнение возврата сумма ' + FormatCurr('0.00', ASumma));

  Result := DoPayment(ASumma, True);
end;

procedure TPos_PrivatBank_JSON.Cancel;
begin
  FCancel := True;
end;

end.
