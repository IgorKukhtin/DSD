unit Pos_PrivatBank_JSON;

{$I ..\..\DPR\dsdVer.inc }

interface

uses Winapi.Windows, Winapi.ActiveX, System.Variants, System.SysUtils, System.Win.ComObj,
     System.Classes, PosInterface, IdHTTP, Vcl.Forms, Vcl.Dialogs,
     {$IFDEF DELPHI103RIO} System.JSON {$ELSE} Data.DBXJSON {$ENDIF};

type
  TPos_PrivatBank_JSON = class(TInterfacedObject, IPos)
  private
    FIdHTTP: TIdHTTP;
    FLastPosError : String;
    FHost : String;
    FCancel : Boolean;
    FMsgDescriptionProc : TMsgDescriptionProc;
    FPOSTerminalCode : integer;

    procedure SetMsgDescriptionProc(Value: TMsgDescriptionProc);
    function GetMsgDescriptionProc: TMsgDescriptionProc;
    function GetLastPosError : string;
  protected
    function Payment(ASumma : Currency) : Boolean;
    function Refund(ASumma : Currency) : Boolean;
    procedure Cancel;
  public
    constructor Create(APOSTerminalCode : Integer);
    function CheckConnection : Boolean;
    function DoPayment(ASumma : Currency; ARefund : Boolean) : Boolean;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    property LastPosError : String read GetLastPosError;
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

procedure TPos_PrivatBank_JSON.AfterConstruction;
begin
  inherited AfterConstruction;

  FIdHTTP := TIdHTTP.Create;
  FHost := iniPosHost(FPOSTerminalCode);
  FCancel := False;
end;

procedure TPos_PrivatBank_JSON.BeforeDestruction;
begin
  FreeAndNil(FIdHTTP);
  inherited BeforeDestruction;
end;

function TPos_PrivatBank_JSON.CheckConnection : Boolean;
  var S : String; JSONObject: TJSONObject; JSONPair: TJSONPair;
      JsonToSend: TStringStream;
begin

  if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('Проверка связи с терминалом');

  try
    JSONObject := TJSONObject.Create;
    JSONObject.AddPair('method', 'CheckConnection');
    JSONObject.AddPair('step', TJSONNumber.Create(0));

    JsonToSend := TStringStream.Create(JSONObject.ToString, TEncoding.UTF8);
    try
      try
        FIdHTTP.Request.Clear;
        FIdHTTP.Request.ContentType := 'application/json';
        FIdHTTP.Request.Accept := 'application/json';
        FIdHTTP.Request.ContentEncoding := 'utf-8';
        S := FIdHTTP.Post(FHost , JsonToSend);
      except on E:EIdHTTPProtocolException do FLastPosError := 'Ошибка проверки связи : ' + e.ErrorMessage;
      end;
    finally
      JSONObject.Free;
      JsonToSend.Free;
    end;
  except on E:Exception do FLastPosError := 'Ошибка проверки связи : ' + e.Message;
  end;

  Add_PosLog(IntToStr(FIdHTTP.ResponseCode) + ' : ' + FIdHTTP.ResponseText);
  if S <> '' then Add_PosLog(S);
  if FLastPosError <> '' then Add_PosLog(FLastPosError);

  if FLastPosError = '' then
  begin
    try
      try
        if S <> '' then
        begin
          JSONObject := TJSONObject.ParseJSONValue(S) as TJSONObject;
          try
            JSONPair := JSONObject.Get('error');
            if (JSONPair <> nil) and (JSONPair.Value = 'false')  then
            begin
              Result := True;
            end else
            begin
              FLastPosError := 'Ошибка проверки связи с терминалом.';
              JSONPair := JSONObject.Get('errorDescription');
              if JSONPair <> nil  then FLastPosError := ' ' + JSONPair.Value;
            end;
          finally
            JSONObject.Free;
          end;
        end else FLastPosError := 'Ошибка проверки связи с терминалом.';
      except on E:Exception do FLastPosError := e.Message;
      end;
    finally
      if FLastPosError <> '' then Add_PosLog(FLastPosError);
    end;
  end;
end;

function TPos_PrivatBank_JSON.DoPayment(ASumma : Currency; ARefund : Boolean) : Boolean;
  var S : String; JSONObject, JSONParams: TJSONObject; JSONPair: TJSONPair;
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

    JsonToSend := TStringStream.Create(JSONObject.ToString, TEncoding.UTF8);
    try
      try
        FIdHTTP.Request.Clear;
        FIdHTTP.Request.ContentType := 'application/json';
        FIdHTTP.Request.Accept := 'application/json';
        FIdHTTP.Request.ContentEncoding := 'utf-8';
        S := FIdHTTP.Post(FHost , JsonToSend);
      except on E:EIdHTTPProtocolException do FLastPosError := 'Ошибка выполнения оплаты (возврата) : ' + e.ErrorMessage;
      end;
    finally
      JSONObject.Free;
      JsonToSend.Free;
    end;
  except on E:Exception do FLastPosError := 'Ошибка выполнения оплаты (возврата) : ' + e.Message;
  end;

  Add_PosLog(IntToStr(FIdHTTP.ResponseCode) + ' : ' + FIdHTTP.ResponseText);
  if S <> '' then Add_PosLog(S);
  if FLastPosError <> '' then Add_PosLog(FLastPosError);

  if FLastPosError = '' then
  begin
    try
      try
        if S <> '' then
        begin
          JSONObject := TJSONObject.ParseJSONValue(S) as TJSONObject;
          try
            JSONPair := JSONObject.Get('error');
            if (JSONPair <> nil) and (JSONPair.Value = 'false')  then
            begin
              Result := True;
            end else
            begin
              FLastPosError := 'Ошибка получения данных с терминала.';
              JSONPair := JSONObject.Get('errorDescription');
              if JSONPair <> nil  then FLastPosError := ' ' + JSONPair.Value;
            end;
          finally
            JSONObject.Free;
          end;
        end else FLastPosError := 'Ошибка получения данных с терминала.';
      except on E:Exception do FLastPosError := e.Message;
      end;
    finally
      if FLastPosError <> '' then Add_PosLog(FLastPosError);
    end;
  end;
end;

function TPos_PrivatBank_JSON.Payment(ASumma : Currency) : Boolean;
begin

  if not CheckConnection then Exit;

  if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('Выполнение оплаты');

  Result := DoPayment(ASumma, False);
end;

function TPos_PrivatBank_JSON.Refund(ASumma : Currency) : Boolean;
begin
  if not CheckConnection then Exit;

  if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('Выполнение возврата');

  Result := DoPayment(ASumma, True);
end;

procedure TPos_PrivatBank_JSON.Cancel;
begin
  FCancel := True;
end;

end.
