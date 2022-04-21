unit EDM;

interface

uses
  Windows, System.SysUtils, System.Variants, System.Classes, System.JSON,
  Vcl.Dialogs, REST.Types, REST.Client, REST.Response.Adapter,
  Vcl.Forms, ShellApi, IdHTTP, IdSSLOpenSSL;

type

  TEDMApi = class(TObject)
  private
    FRESTResponse: TRESTResponse;
    FRESTRequest: TRESTRequest;
    FRESTClient: TRESTClient;

    // Адреса компа с ПРРО
    FEDM_Id : String;
    // Токены доступа
    FAccess_Token : String;
    //Версия схемы
    FVer : Integer;
    // Имя устройства
    FDevice_Name : String;

    // Статус смены
    FShift_Status : Boolean;

    // Номер ПРРО
    FFisId : String;
    // Печататная форма
    FPF_Text : String;
    // Текст ошибки
    FPF_Error : String;

  protected
    function PostData(var jsonFiscal : TJSONObject; AType : Integer = 1) : boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  // Возврат текст ошибки
function GetErrorEDM : String;
  // Возврат текст для печати
function GetTxtEDM : String;

  // 0 - открытие смены
function OpenWorkShiftEDM : boolean;

  // 3 - служебный внос денег
function ServiceFeeEDM(ASUM : Currency) : boolean;
  // 4 - служебный вынос денег
function ServiceTakeawayEDM(ASUM : Currency) : boolean;

  // 10 - X-отчет
function XReportEDM : boolean;

  // 18 - Статус фискальника
function StatusEDM : boolean;
  // 20 - Возврат номера фискального аппарата
function FiscalNumberEDM : String;

implementation

uses RegularExpressions, System.Generics.Collections,
     DBClient, LocalWorkUnit, CommonData, IdGlobal, IdCoderMIME;

var EDMApi : TEDMApi;

function DelDoubleQuote(AStr : string) : string;
begin
  Result := StringReplace(AStr, '"', '', [rfReplaceAll]);
end;

  { TEDMApi }
constructor TEDMApi.Create;
begin
  FRESTClient := TRESTClient.Create('');
  FRESTResponse := TRESTResponse.Create(Nil);
  FRESTRequest := TRESTRequest.Create(Nil);
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;

  FVer := 6;
  FAccess_Token := '';
  FDevice_Name := '';
  FPF_Text := '';
  FPF_Error := '';
end;

destructor TEDMApi.Destroy;
begin
  FRESTResponse.Free;
  FRESTRequest.Free;
  FRESTClient.Free;
end;

function TEDMApi.PostData(var jsonFiscal : TJSONObject; AType : Integer = 1) : boolean;
var
  jsonData : TJSONObject;
  jValue : TJSONValue;
  task : Integer;
  S : String;
begin
  Result := False;
  FPF_Text := '';
  FPF_Error := '';
  if not TryStrToInt(jsonFiscal.FindValue('task').ToString, task) then
  begin
    ShowMessage('Не передан: "Тип фискального задания"');
    jsonFiscal.Destroy;
    Exit;
  end;

  FRESTClient.BaseURL := FEDM_Id;
  FRESTClient.ContentType := 'application/json';

  FRESTRequest.ClearBody;
  FRESTRequest.Params.Clear;
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.Resource := 'execute';

  jsonData := TJSONObject.Create;
  try
    jsonData := TJSONObject.Create;
    jsonData.AddPair('ver', TJSONNumber.Create(FVer));
    jsonData.AddPair('token', TJSONString.Create(FAccess_Token));
    jsonData.AddPair('source', TJSONString.Create('ERP1'));
    jsonData.AddPair('device', TJSONString.Create(FDevice_Name));
    jsonData.AddPair('tag', TJSONString.Create(''));
    jsonData.AddPair('dt', TJSONString.Create(FormatDateTime('YYYYMMDDHHNNSSZZZ', NOW)));
    jsonData.AddPair('type', TJSONNumber.Create(AType));
    jsonData.AddPair('need_pf_txt', TJSONNumber.Create(2));

    jsonData.AddPair('fiscal', jsonFiscal);

    FRESTRequest.Body.Add(jsonData.ToString, TRESTContentType.ctAPPLICATION_JSON);
  finally
    jsonData.Destroy;
  end;

  try
    FRESTRequest.Execute;
  except
  end;

  if FRESTResponse.StatusCode = 200 then
  begin
    jValue := FRESTResponse.JSONValue ;
    if (jValue.FindValue('errortxt') <> Nil) and (DelDoubleQuote(jValue.FindValue('errortxt').ToString) <> '') then
    begin
       FPF_Error := DelDoubleQuote(jValue.FindValue('errortxt').ToString);
       ShowMessage(FPF_Error);
       Exit;
    end;

    if (jValue.FindValue('pf_text') <> Nil) and (DelDoubleQuote(jValue.FindValue('pf_text').ToString) <> '') then
    begin
      try
        S := DelDoubleQuote(jValue.FindValue('pf_text').ToString);
        S := COPY(S, POS('base64', S) + 7, Length(S));
        FPF_Text := TIdDecoderMIME.DecodeString(S, IndyTextEncoding_OSDefault);
      except
      end;
    end;

    case task of
      0  : if (jValue.FindValue('info') <> Nil) then
           begin
             jValue := jValue.FindValue('info');
             if (jValue.FindValue('fisid') <> Nil) then FFisId := DelDoubleQuote(jValue.FindValue('fisid').ToString);
             if (jValue.FindValue('shift_status') <> Nil) then FShift_Status  := DelDoubleQuote(jValue.FindValue('shift_status').ToString) = '1';
           end;
      3  : if (jValue.FindValue('info') <> Nil) then
           begin
             jValue := jValue.FindValue('info');
             if (jValue.FindValue('fisid') <> Nil) then FFisId := DelDoubleQuote(jValue.FindValue('fisid').ToString);
           end;
      4  : if (jValue.FindValue('info') <> Nil) then
           begin
             jValue := jValue.FindValue('info');
             if (jValue.FindValue('fisid') <> Nil) then FFisId := DelDoubleQuote(jValue.FindValue('fisid').ToString);
           end;
      10 : if (jValue.FindValue('info') <> Nil) then
           begin
             jValue := jValue.FindValue('info');
             if (jValue.FindValue('fisid') <> Nil) then FFisId := DelDoubleQuote(jValue.FindValue('fisid').ToString);
           end;
      18 : if (jValue.FindValue('info') <> Nil) then
           begin
             jValue := jValue.FindValue('info');
             if (jValue.FindValue('fisid') <> Nil) then FFisId := DelDoubleQuote(jValue.FindValue('fisid').ToString);
             if (jValue.FindValue('shift_status') <> Nil) then FShift_Status  := DelDoubleQuote(jValue.FindValue('shift_status').ToString) = '1';
           end;
      20 : if (jValue.FindValue('info') <> Nil) then
           begin
             jValue := jValue.FindValue('info');
             if (jValue.FindValue('fisid') <> Nil) then FFisId := DelDoubleQuote(jValue.FindValue('fisid').ToString);
           end;
    else
        ShowMessage('Обработка "Тип фискального задания" не описана.');
        Exit;
    end;

    Result := True;
  end;
end;


//------------------------


function InitEDMApi : boolean;
  var I : integer;
      ds : TClientDataSet;
      S : string;
begin

  Result := False;

  if not Assigned(EDMApi) then
  begin
    EDMApi := TEDMApi.Create;

    EDMApi.FVer := 6;
    EDMApi.FEDM_Id := 'http://localhost:3939/dm';
    EDMApi.FAccess_Token := 'npjnU9SiYzbLtXfZyqNfM1rMCMwcUSGE';
    EDMApi.FDevice_Name := 'Тестовая касса';
  end;

  Result := True;
end;

  // Возврат текст ошибки
function GetErrorEDM : String;
begin
  Result := '';

  if Assigned(EDMApi) then Result := EDMApi.FPF_Error;
end;

  // Возврат текст для печати
function GetTxtEDM : String;
begin
  Result := '';

  if Assigned(EDMApi) then Result := EDMApi.FPF_Text;
end;

  // 0 - открытие смены
function OpenWorkShiftEDM : boolean;
var
  jsonFiscal: TJSONObject;
begin
  Result := False;

  if not Assigned(EDMApi) then
  begin
    if not InitEDMApi then Exit;
  end;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(0));

  Result := EDMApi.PostData(jsonFiscal);
end;

  // 3 - служебный внос денег
function ServiceFeeEDM(ASUM : Currency) : boolean;
var
  jsonFiscal: TJSONObject;
  jsonCash: TJSONObject;
begin
  Result := False;

  if not Assigned(EDMApi) then
  begin
    if not InitEDMApi then Exit;
  end;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(3));

  jsonCash := TJSONObject.Create;
  jsonCash.AddPair('type', TJSONNumber.Create(0));
  jsonCash.AddPair('sum', TJSONNumber.Create(ASUM));

  jsonFiscal.AddPair('cash', jsonCash);

  Result := EDMApi.PostData(jsonFiscal);
end;

  // 4 - служебный вынос денег
function ServiceTakeawayEDM(ASUM : Currency) : boolean;
var
  jsonFiscal: TJSONObject;
  jsonCash: TJSONObject;
begin
  Result := False;

  if not Assigned(EDMApi) then
  begin
    if not InitEDMApi then Exit;
  end;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(4));

  jsonCash := TJSONObject.Create;
  jsonCash.AddPair('type', TJSONNumber.Create(0));
  jsonCash.AddPair('sum', TJSONNumber.Create(ASUM));

  jsonFiscal.AddPair('cash', jsonCash);

  Result := EDMApi.PostData(jsonFiscal);
end;

  // 10 - X-отчет
function XReportEDM : boolean;
var
  jsonFiscal: TJSONObject;
begin
  Result := False;

  if not Assigned(EDMApi) then
  begin
    if not InitEDMApi then Exit;
  end;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(10));

  Result := EDMApi.PostData(jsonFiscal);
end;

  // 18 - Статус фискальника
function StatusEDM : boolean;
var
  jsonFiscal: TJSONObject;
begin
  Result := False;

  if not Assigned(EDMApi) then
  begin
    if not InitEDMApi then Exit;
  end;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(18));

  Result := EDMApi.PostData(jsonFiscal);
end;

  // 20 - Возврат номера фискального аппарата
function FiscalNumberEDM : String;
var
  jsonFiscal: TJSONObject;
begin
  Result := '';

  if not Assigned(EDMApi) then
  begin
    if not InitEDMApi then Exit;
  end;

  jsonFiscal := TJSONObject.Create;
  jsonFiscal.AddPair('task', TJSONNumber.Create(20));

  if EDMApi.PostData(jsonFiscal) then Result := EDMApi.FFisId;
end;

initialization
  EDMApi := Nil;

finalization
  if Assigned(EDMApi) then FreeAndNil(EDMApi);

end.
