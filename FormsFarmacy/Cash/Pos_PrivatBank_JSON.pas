unit Pos_PrivatBank_JSON;

{$I ..\..\DPR\dsdVer.inc }

interface

uses Winapi.Windows, Winapi.ActiveX, System.Variants, System.SysUtils, System.Win.ComObj,
     System.Classes, PosInterface, Vcl.Forms, DateUtils, System.TypInfo, ncSockets,
     Vcl.ExtCtrls, IdGlobal,
     {$IFDEF DELPHI103RIO} System.JSON {$ELSE} Data.DBXJSON {$ENDIF};

type
  TPos_PrivatBank_JSON = class(TInterfacedObject, IPos)
  private
    FTCPClient: TncTCPClient;
    FTimer: TTimer;
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
    FServiceMessage : Boolean;
    FRunServiceMessage: TDateTime;
    FRRN: String;

    procedure SetMsgDescriptionProc(Value: TMsgDescriptionProc);
    function GetMsgDescriptionProc: TMsgDescriptionProc;
    function GetLastPosError : string;
    function GetTextCheck : string;
    function GetProcessType : TPosProcessType;
    function GetProcessState : TPosProcessState;
    function GetCanceled : Boolean;
    function GetRRN : string;
    procedure OnReadData(Sender: TObject; aLine: TncLine; const aBuf: TBytes; aBufCount: Integer);
    procedure OnTimer(Sender: TObject);
  protected
    function CheckConnection : Boolean;
    function Payment(ASumma : Currency) : Boolean;
    function Refund(ASumma : Currency; ARRN : String) : Boolean;
    function ServiceMessage : Boolean;
    procedure Cancel;
  public
    constructor Create(APOSTerminalCode : Integer);
    function DoPayment(ASumma : Currency; ARefund : Boolean; ARRN : String) : Boolean;
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
  FRRN := '';
  FServiceMessage := False;
  FRunServiceMessage := IncSecond(Now, 3);
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

function TPos_PrivatBank_JSON.GetCanceled : Boolean;
begin
  Result := FCancel;
end;

function TPos_PrivatBank_JSON.GetRRN : string;
begin
  Result := FRRN;
end;

procedure TPos_PrivatBank_JSON.AfterConstruction;
begin
  inherited AfterConstruction;

  FTCPClient := TncTCPClient.Create(Nil);
  FTCPClient.OnReadData := OnReadData;
  FHost := iniPosHost(FPOSTerminalCode);
  FPort := iniPosPortNumber(FPOSTerminalCode);

  FTimer := TTimer.Create(Nil);
  FTimer.Enabled := False;
  FTimer.Interval := 300;
  FTimer.OnTimer := OnTimer;

  FCancel := False;
  FProcessState := ppsUndefined;
end;

procedure TPos_PrivatBank_JSON.BeforeDestruction;
begin
  try
    if FTCPClient.Active then FTCPClient.Active := False;
    FTCPClient.OnReadData := Nil;
    FreeAndNil(FTCPClient);
    FreeAndNil(FTimer);
    Add_PosLog('*** �������� ��������� ***');
  except on E:Exception do Add_PosLog('*** ������ �������� ���������: ' + e.Message + ' ***');
  end;
  inherited BeforeDestruction;
end;

procedure TPos_PrivatBank_JSON.OnTimer(Sender: TObject);
begin

  // �������� ������ �� ���������� � ����������
  if FServiceMessage and (FProcessState = ppsWaiting) and (FRunServiceMessage <= Now) then
  begin
    ServiceMessage;
    FRunServiceMessage := IncSecond(Now, 3);
  end;

end;

procedure TPos_PrivatBank_JSON.OnReadData(Sender: TObject; aLine: TncLine; const aBuf: TBytes; aBufCount: Integer);
var JSONObject, JSONParams: TJSONObject; S: String; Buffer: TIdBytes;

   function GetMasked_Pan(APan, AReceipt: TJSONPair) : string;
   begin
     Result := '';
     if (APan = nil) or (AReceipt = nil) then Exit;
     if Pos(Copy(APan.JsonValue.Value, 1, 4), AReceipt.JsonValue.Value) > 0 then
       Result := Copy(AReceipt.JsonValue.Value,
                      Pos(Copy(APan.JsonValue.Value, 1, 4), AReceipt.JsonValue.Value), 16);

   end;

begin

  Add_PosLog('������.');
  try
    SetLength(Buffer, aBufCount);
    Move(aBuf[0], Buffer[0], aBufCount);
    try
      FRadBufer:= FRadBufer +  IdGlobal.BytesToString(Buffer, IndyTextEncoding_UTF8);
    finally
      SetLength(Buffer, 0);
    end;
  except on E:Exception do FLastPosError := '������ ������ ������: ' + e.Message;
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
            if LowerCase(JSONObject.Get('method').JsonValue.Value) = LowerCase('PingDevice') then
              FProcessState := ppsOkConnection
            else if LowerCase(JSONObject.Get('method').JsonValue.Value) = LowerCase('Purchase') then
              FProcessState := ppsOkPayment
            else if LowerCase(JSONObject.Get('method').JsonValue.Value) = LowerCase('Refund') then
              FProcessState := ppsOkRefund
            else if LowerCase(JSONObject.Get('method').JsonValue.Value) = LowerCase('ServiceMessage') then
              FProcessState := FProcessState
            else FProcessState := ppsError;

            FTextCheck := '';

            if (LowerCase(JSONObject.Get('method').JsonValue.Value) = LowerCase('ServiceMessage')) then
            begin
              JSONParams := JSONObject.Get('params').JsonValue as TJSONObject;
              if JSONParams = nil then Exit;

              if (JSONParams.Get('msgType') <> nil) then
              begin
                if (LowerCase(JSONParams.Get('msgType').JsonValue.Value) = LowerCase('interruptTransmitted')) then
                begin
                  FLastPosError := '���������� �������� �������� �������������.';
                end else if (LowerCase(JSONParams.Get('msgType').JsonValue.Value) = LowerCase('deviceBusy')) then
                begin
                  // ���������� ������ ������� ���������
                end else if (LowerCase(JSONParams.Get('msgType').JsonValue.Value) = LowerCase('getLastStatMsgCode')) then
                begin
                  case StrToInt(JSONParams.Get('LastStatMsgCode').JsonValue.Value) of
                    0 : if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('��� ��������� ����������.');
                    1 : if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('����� ���� ���������');
                    2 : if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('����������� ���-�����');
                    3 : if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('���� �����������');
                    4 : if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('�������� �������� �������');
                    5 : if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('������ ����');
                    6 : if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('��������� ���� ��� ����');
                    7 : if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('����� �������');
                    8 : if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('������������ EMV');
                    9 : if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('�������� �����');
                    10 : if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('� ��������');
                    11 : if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('���������� ����������');
                  end;
                end else FLastPosError := '������ ��������� ���������.';
              end else FLastPosError := '������ ��������� ���������.';
              Exit;
            end;

            if (LowerCase(JSONObject.Get('method').JsonValue.Value) <> LowerCase('Purchase')) and
               (LowerCase(JSONObject.Get('method').JsonValue.Value) <> LowerCase('Refund')) then Exit;

            JSONParams := JSONObject.Get('params').JsonValue as TJSONObject;
            if (JSONParams = nil) or (JSONParams.Count <= 0) or
               (JSONParams.Get('merchant') = nil) or (JSONParams.Get('merchant').JsonValue.Value = '') then
            begin
              if (JSONObject.Get('errorDescription') <> nil) and (JSONObject.Get('errorDescription').JsonValue.Value <> '')  then
                FLastPosError := JSONObject.Get('errorDescription').JsonValue.Value
              else FLastPosError := '��� ���� ������...';
              Exit;
            end;

            FTextCheck := '            �����';
            FTextCheck := FTextCheck + #13'������� ';
            if (JSONParams.Get('merchant') <> nil) then
              FTextCheck := FTextCheck + JSONParams.Get('merchant').JsonValue.Value;
            if LowerCase(JSONObject.Get('method').JsonValue.Value) = LowerCase('Purchase') then
              FTextCheck := FTextCheck + #13'            ������';
            if LowerCase(JSONObject.Get('method').JsonValue.Value) = LowerCase('Refund') then
              FTextCheck := FTextCheck + #13'            ����������';
            FTextCheck := FTextCheck + #13'���� ';
            if (JSONParams.Get('amount') <> nil) then
              FTextCheck := FTextCheck + JSONParams.Get('amount').JsonValue.Value;
            if (JSONParams.Get('pan') <> nil) and (JSONParams.Get('pan').JsonValue.Value <> '') then
            begin
              FTextCheck := FTextCheck + #13'��� ';
              if LowerCase(JSONObject.Get('method').JsonValue.Value) = LowerCase('Purchase') then
                FTextCheck := FTextCheck + GetMasked_Pan(JSONParams.Get('pan'), JSONParams.Get('receipt'))
              else FTextCheck := FTextCheck + JSONParams.Get('pan').JsonValue.Value;
            end;
            FTextCheck := FTextCheck + #13'������� ������� ';
            if (JSONParams.Get('paymentSystem') <> nil) then
              FTextCheck := FTextCheck + JSONParams.Get('paymentSystem').JsonValue.Value;
            if (JSONParams.Get('approvalCode') <> nil) and (JSONParams.Get('approvalCode').JsonValue.Value <> '') then
            begin
              FTextCheck := FTextCheck + #13'��� ���������� ';
              FTextCheck := FTextCheck + JSONParams.Get('approvalCode').JsonValue.Value;
            end;
            if (JSONParams.Get('rrn') <> nil) and (JSONParams.Get('rrn').JsonValue.Value <> '') then
            begin
              FTextCheck := FTextCheck + #13'RRN ';
              FTextCheck := FTextCheck + JSONParams.Get('rrn').JsonValue.Value;
              FRRN := JSONParams.Get('rrn').JsonValue.Value;
            end;
            FTextCheck := FTextCheck + #13'��� ';
            if (JSONParams.Get('invoiceNumber') <> nil) then
              FTextCheck := FTextCheck + JSONParams.Get('invoiceNumber').JsonValue.Value;
            if (JSONParams.Get('date') <> nil) then
              FTextCheck := FTextCheck + ' ' + JSONParams.Get('date').JsonValue.Value;
            if (JSONParams.Get('time') <> nil) then
              FTextCheck := FTextCheck + ' ' + JSONParams.Get('time').JsonValue.Value;

          end else
          begin
            FLastPosError := '������: ';
            if (JSONObject.Get('errorDescription') <> nil) and (JSONObject.Get('errorDescription').JsonValue.Value <> '') then
              FLastPosError := ' ' + JSONObject.Get('errorDescription').JsonValue.Value
            else FLastPosError := FLastPosError + ' ��� �������� � ���.';
          end;
        finally
          JSONObject.Free;
        end;
      except on E:Exception do FLastPosError := '������ ��������� ������: ' + e.Message;
      end;
    finally
      if FLastPosError <> '' then Add_PosLog(FLastPosError);
      if FLastPosError <> '' then FProcessState := ppsError;
    end;
  end;
end;

function TPos_PrivatBank_JSON.CheckConnection : Boolean;
  var JSONObject: TJSONObject; aBuf: TBytes;
begin

  if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('�������� ����� � ����������');

  try
    JSONObject := TJSONObject.Create;
    JSONObject.AddPair('method', 'PingDevice');
    JSONObject.AddPair('step', TJSONNumber.Create(0));

    aBuf := TEncoding.UTF8.GetBytes(JSONObject.ToString + #0);
    try
      try
        FTCPClient.Host := FHost;
        FTCPClient.Port := FPort;
        Add_PosLog('���� - ' + FHost + '; ���� - ' + IntToStr(FPort));
        FTCPClient.Active := True;

        Add_PosLog(JSONObject.ToString);
        if FTCPClient.Active then
        begin
          FTCPClient.Send(aBuf);
          FTimer.Enabled := True;
          FProcessState := ppsWaiting;
        end;
      except on E:Exception do FLastPosError := '������ �������� ����� : ' + e.Message +
        '; ' + FTCPClient.Host + '; ' + IntToStr(FTCPClient.Port);
      end;
    finally
      JSONObject.Free;
      SetLength(aBuf, 0);
    end;
  except on E:Exception do FLastPosError := '������ �������� ����� : ' + e.Message;
  end;

  if FLastPosError <> '' then
  begin
    FProcessState := ppsError;
    Add_PosLog(FLastPosError);
  end;
end;

function TPos_PrivatBank_JSON.DoPayment(ASumma : Currency; ARefund : Boolean; ARRN : String) : Boolean;
  var JSONObject, JSONParams: TJSONObject; aBuf: TBytes;
begin

  try
    JSONParams := TJSONObject.Create;
    JSONParams.AddPair('amount', TJSONString.Create(FormatCurr('0.00', ASumma)));
    JSONParams.AddPair('discount', TJSONString.Create('0'));
    JSONParams.AddPair('merchantId', TJSONString.Create('0'));
    if ARefund then
    begin
      JSONParams.AddPair('rrn', TJSONString.Create(ARRN));
      JSONParams.AddPair('subMerchant', TJSONString.Create(''));
    end;

    JSONObject := TJSONObject.Create;
    if ARefund then JSONObject.AddPair('method', 'Refund')
    else JSONObject.AddPair('method', 'Purchase');
    JSONObject.AddPair('step', TJSONNumber.Create(0));
    JSONObject.AddPair('params', JSONParams);

    aBuf := TEncoding.UTF8.GetBytes(JSONObject.ToString + #0);
    try
      try

        Add_PosLog(JSONObject.ToString);
        if FTCPClient.Active then
        begin
          FTCPClient.Send(aBuf);
          FProcessState := ppsWaiting;
          FServiceMessage := True;
          FRunServiceMessage := IncSecond(Now, 3);
        end;

      except on E:Exception do FLastPosError := '������ ���������� ������ (��������) : ' + e.Message;
      end;
    finally
      JSONObject.Free;
      SetLength(aBuf, 0);
    end;
  except on E:Exception do FLastPosError := '������ ���������� ������ (��������) : ' + e.Message;
  end;

  if FLastPosError <> '' then
  begin
    FProcessState := ppsError;
    Add_PosLog(FLastPosError);
  end;
end;

function TPos_PrivatBank_JSON.Payment(ASumma : Currency) : Boolean;
begin

  if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('���������� ������ ����� ' + FormatCurr('0.00', ASumma));
  Add_PosLog('���������� ������ ����� ' + FormatCurr('0.00', ASumma));

  Result := DoPayment(ASumma, False, '');
end;

function TPos_PrivatBank_JSON.Refund(ASumma : Currency; ARRN : String) : Boolean;
begin
  if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('���������� �������� ����� ' + FormatCurr('0.00', ASumma));
  Add_PosLog('���������� �������� ����� ' + FormatCurr('0.00', ASumma));

  Result := DoPayment(ASumma, True, ARRN);
end;

function TPos_PrivatBank_JSON.ServiceMessage : Boolean;
  var JSONObject, JSONParams: TJSONObject; aBuf: TBytes;
begin

  if FCancel Then Exit;
  if FRadBufer <> '' Then Exit;

  try
    JSONParams := TJSONObject.Create;
    JSONParams.AddPair('msgType', TJSONString.Create('getLastStatMsgCode'));

    JSONObject := TJSONObject.Create;
    JSONObject.AddPair('method', 'ServiceMessage');
    JSONObject.AddPair('step', TJSONNumber.Create(0));
    JSONObject.AddPair('params', JSONParams);

    aBuf := TEncoding.UTF8.GetBytes(JSONObject.ToString + #0);
    try
      try

        Add_PosLog(JSONObject.ToString);
        if FTCPClient.Active then
        begin
          FTCPClient.Send(aBuf);
          FProcessState := ppsWaiting;
        end;

      except on E:Exception do FLastPosError := '������ ������ service message : ' + e.Message;
      end;
    finally
      JSONObject.Free;
      SetLength(aBuf, 0);
    end;
  except on E:Exception do FLastPosError := '������ ������ service message : ' + e.Message;
  end;

  if FLastPosError <> '' then
  begin
    FProcessState := ppsError;
    Add_PosLog(FLastPosError);
  end;
end;

procedure TPos_PrivatBank_JSON.Cancel;
  var JSONObject, JSONParams: TJSONObject; aBuf: TBytes;
begin

  if FCancel Then Exit;

  if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('���������� �������������� ��������.');

  try
    JSONParams := TJSONObject.Create;
    JSONParams.AddPair('msgType', TJSONString.Create('interrupt'));

    JSONObject := TJSONObject.Create;
    JSONObject.AddPair('method', 'ServiceMessage');
    JSONObject.AddPair('step', TJSONNumber.Create(0));
    JSONObject.AddPair('params', JSONParams);

    aBuf := TEncoding.UTF8.GetBytes(JSONObject.ToString + #0);
    try
      try

        Add_PosLog(JSONObject.ToString);
        if FTCPClient.Active then
        begin
          FTCPClient.Send(aBuf);
          FProcessState := ppsWaiting;
        end;

      except on E:Exception do FLastPosError := '������ ������ ���������� ������� : ' + e.Message;
      end;
    finally
      JSONObject.Free;
      SetLength(aBuf, 0);
    end;
  except on E:Exception do FLastPosError := '������ ������ ���������� ������� : ' + e.Message;
  end;

  if FLastPosError <> '' then
  begin
    FProcessState := ppsError;
    Add_PosLog(FLastPosError);
  end;

  FCancel := True;
end;

end.
