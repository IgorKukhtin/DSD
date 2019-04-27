unit Helsi;

interface

uses
  System.SysUtils, System.Variants, System.Classes, System.JSON,
  Vcl.Dialogs, REST.Types, REST.Client, REST.Response.Adapter;

type

  THelsiApi = class(TObject)
  private
    FRESTResponse: TRESTResponse;
    FRESTRequest: TRESTRequest;
    FRESTClient: TRESTClient;

    FUserName : String;
    FPassword : String;
    FHelsi_Id : String;
    FHelsi_be : String;

    FClientId : String;
    FClientSecret : String;

    FAccess_Token : String;
    FRefresh_Token : String;

    FNumber : String;

    FMedication_ID : string;
    FMedication_Name : string;
    FMedication_Qty : currency;

    FMedication_request_id : String;
    FMedical_program_id : String;

    FRequest_number : String;
    FStatus : string;
    FCreated_at : TDateTime;
    FDispense_valid_from : TDateTime;
    FDispense_valid_to : TDateTime;

    FSell_Medication_ID : string;
    FSell_qty : Currency;
    FSell_price : Currency;
    FSell_amount : Currency;
    FDiscount_amount : Currency;
    FDispensed_by : String;
    FDispensed_Code : string;

    FDispense_ID : string;

    FPayment_id : string;
    FPayment_amount : currency;

    FDispense_sign_ID : string;
  protected
    function CheckIntegrationClient : boolean;
    function GetToken : boolean;
    function GetTokenRefresh : boolean;
    function InitReinitSession : boolean;
    function GetReceiptId : boolean;
    function CreateNewDispense : boolean;
    function SetPayment : boolean;
    function RejectDispense : boolean;
    function IntegrationClientSign : boolean;
    function ProcessSignedDispense : boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

function GetHelsiReceipt(const AReceipt : String; var AID, AName : string;
  var AQty : currency; var ADate : TDateTime) : boolean;

function CreateNewDispense(IDSP : string; AQty, APrice, ASell_amount, ADiscount_amount : currency;
  AWho : string; ACode : string) : boolean;

function RejectDispense : boolean;

function SetPayment(AID : string; ASum : currency) : boolean;

function IntegrationClientSign : boolean;

function ProcessSignedDispense : boolean;

implementation

uses RegularExpressions, System.Generics.Collections, Soap.EncdDecd, MainCash2;

var HelsiApi : THelsiApi;

function CheckRequest_Number(ANumber : string) : boolean;
  var Res: TArray<string>; I, J : Integer;
begin
  Result := False;
  try
    if Length(ANumber) <> 19 then exit;

    Res := TRegEx.Split(ANumber, '-');

    if High(Res) <> 3 then exit;

    for I := 0 to High(Res) do
    begin
      if Length(Res[I]) <> 4 then exit;

      for J := 1 to 4 do if not (Res[I][J] in ['0'..'9','A'..'Z']) then exit;
    end;
    Result := True;
  finally
    if not Result then ShowMessage ('Ошибка.<Регистрационный номер рецепта>'#13#10 +
      'Номер должен содержать 19 символов в 4 блока по 4 символа разделенных символом "-"'#13#10 +
      'Cодержать только цыфры и большие буквы латинского алфовита'#13#10 +
      'В виде XXXX-XXXX-XXXX-XXXX ...');
  end;
end;

function StrToDateSite(ADateStr : string; var ADate : TDateTime) : Boolean;
  var Res: TArray<string>;
begin
  Result := False;
  try
    Res := TRegEx.Split(ADateStr, '-');
    if High(Res) <> 2 then exit;
    try
      ADate := EncodeDate(StrToInt(Res[0]), StrToInt(Res[1]), StrToInt(Res[2]));
      Result := True;
    except
    end
  finally
    if not Result then ShowMessage('Ошибка преобразования даты рецепта.');
  end;
end;

  { THelsiApi }
constructor THelsiApi.Create;
begin
  FRESTClient := TRESTClient.Create('');
  FRESTResponse := TRESTResponse.Create(Nil);
  FRESTRequest := TRESTRequest.Create(Nil);
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;

  FAccess_Token := '';
  FRefresh_Token := '';

  FUserName := MainCashForm.UnitConfigCDS.FieldByName('Helsi_UserName').AsString;
  FPassword := MainCashForm.UnitConfigCDS.FieldByName('Helsi_Password').AsString;
  FHelsi_Id := MainCashForm.UnitConfigCDS.FieldByName('Helsi_Id').AsString;
  FHelsi_be := MainCashForm.UnitConfigCDS.FieldByName('Helsi_be').AsString;

  FClientId := MainCashForm.UnitConfigCDS.FieldByName('Helsi_ClientId').AsString;
  FClientSecret := MainCashForm.UnitConfigCDS.FieldByName('Helsi_ClientSecret').AsString;
end;

destructor THelsiApi.Destroy;
begin
  FRESTResponse.Free;
  FRESTRequest.Free;
  FRESTClient.Free;
end;

function THelsiApi.CheckIntegrationClient : boolean;
begin

  Result := False;

  FRESTClient.BaseURL := 'http://localhost:5000/swagger/index.html';
  FRESTClient.ContentType := '';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Resource := '';
  // required parameters
  FRESTRequest.Params.Clear;

  try
    FRESTRequest.Execute;
  except
  end;

  Result :=  FRESTResponse.StatusCode = 200;
  if not Result then ShowMessage('Ошибка подключения к eSign Integration client:'#13#10 +
                     IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText);
end;


function THelsiApi.GetToken : boolean;
var
  jValue : TJSONValue;
begin
  Result := False;
  FRESTClient.BaseURL := FHelsi_Id;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.Resource := 'connect/token';
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('grant_type', 'password', TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('client_id', FClientId, TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('client_secret', FClientSecret, TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('username', FUserName, TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('password', FPassword, TRESTRequestParameterKind.pkGETorPOST);

  try
    FRESTRequest.Execute;
  except
  end;

  if FRESTResponse.StatusCode = 200 then
  begin
    jValue := FRESTResponse.JSONValue ;
    if jValue.FindValue('access_token') <> Nil then
    begin
      FAccess_Token := StringReplace(jValue.FindValue('access_token').ToString, '"', '', [rfReplaceAll]);
      FRefresh_Token := StringReplace(jValue.FindValue('refresh_token').ToString, '"', '', [rfReplaceAll]);
      Result := FAccess_Token <> '';
    end;
  end;
end;

function THelsiApi.GetTokenRefresh : boolean;
var
  jValue : TJSONValue;
begin
  Result := False;
  FRESTClient.BaseURL := FHelsi_Id;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.Resource := 'connect/token';
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('grant_type', 'refresh_token', TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('client_id', FClientId, TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('client_secret', FClientSecret, TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('refresh_token', FRefresh_Token, TRESTRequestParameterKind.pkGETorPOST,
                                                             [TRESTRequestParameterOption.poDoNotEncode]);
  try
    FRESTRequest.Execute;
  except
  end;

  if FRESTResponse.StatusCode = 200 then
  begin
    jValue := FRESTResponse.JSONValue ;
    if jValue.FindValue('access_token') <> Nil then
    begin
      FAccess_Token := StringReplace(jValue.FindValue('access_token').ToString, '"', '', [rfReplaceAll]);
      FRefresh_Token := StringReplace(jValue.FindValue('refresh_token').ToString, '"', '', [rfReplaceAll]);
      Result := FAccess_Token <> '';
    end;
  end;
end;

function THelsiApi.InitReinitSession : boolean;
begin
  Result := False;
  FRESTClient.BaseURL := FHelsi_be;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Resource := 'user/me';
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('Authorization', 'bearer ' + FAccess_Token, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                        [TRESTRequestParameterOption.poDoNotEncode]);
  FRESTRequest.Execute;

  Result := FRESTResponse.StatusCode = 200;
end;

function THelsiApi.GetReceiptId : boolean;
var
  jValue, j : TJSONValue;
begin
  Result := False;
  FDispense_sign_ID := '';
  FDispense_ID := '';
  FRequest_number := '';
  FMedication_request_id := '';

  FRESTClient.BaseURL := FHelsi_be;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Resource := 'receipts/' + FNumber;
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('Authorization', 'bearer ' + FAccess_Token, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                        [TRESTRequestParameterOption.poDoNotEncode]);
  try
    FRESTRequest.Execute;
  except
  end;

  if FRESTResponse.StatusCode = 200 then
  begin
    try
      jValue := FRESTResponse.JSONValue ;
      if jValue.FindValue('data') <> Nil then
      begin
        jValue := jValue.FindValue('data');

        if jValue.FindValue('medical_program') <> Nil then
        begin
          j := jValue.FindValue('medical_program');
          FMedical_program_id := StringReplace(j.FindValue('id').ToString, '"', '', [rfReplaceAll]);
        end else Exit;

        if jValue.FindValue('medication_info') <> Nil then
        begin
          j := jValue.FindValue('medication_info');
          FMedication_ID := StringReplace(j.FindValue('medication_id').ToString, '"', '', [rfReplaceAll]);
          FMedication_Name := StringReplace(j.FindValue('medication_name').ToString, '"', '', [rfReplaceAll]);
          FMedication_Qty := StrToCurr(StringReplace(StringReplace(j.FindValue('medication_qty').ToString,
                            ',', FormatSettings.DecimalSeparator, [rfReplaceAll]),
                            '.', FormatSettings.DecimalSeparator, [rfReplaceAll]));

          FMedication_request_id := StringReplace(jValue.FindValue('id').ToString, '"', '', [rfReplaceAll]);
          FStatus := StringReplace(jValue.FindValue('status').ToString, '"', '', [rfReplaceAll]);
          if not StrToDateSite(StringReplace(jValue.FindValue('created_at').ToString, '"', '', [rfReplaceAll]), FCreated_at) then Exit;
          if not StrToDateSite(StringReplace(jValue.FindValue('dispense_valid_from').ToString, '"', '', [rfReplaceAll]), FDispense_valid_from) then Exit;
          if not StrToDateSite(StringReplace(jValue.FindValue('dispense_valid_to').ToString, '"', '', [rfReplaceAll]), FDispense_valid_to) then Exit;
          FRequest_number := StringReplace(jValue.FindValue('request_number').ToString, '"', '', [rfReplaceAll]);

          Result := True;
        end;
      end;
    except
    end
  end;
end;


function THelsiApi.CreateNewDispense : boolean;
var
  jValue, j : TJSONValue;
  jsonBody: TJSONObject;
  jsonTemp: TJSONObject;
  JSONA: TJSONArray;
  cError : string;
begin

  Result := False;

  if HelsiApi.FRequest_number = '' then Exit;

  jsonTemp := TJSONObject.Create;
  try
    jsonTemp.AddPair('medication_id', FSell_Medication_ID);
    jsonTemp.AddPair('medication_qty', TJSONNumber.Create(FSell_qty));
    jsonTemp.AddPair('sell_price', TJSONNumber.Create(FSell_price));
    jsonTemp.AddPair('sell_amount', TJSONNumber.Create(FSell_amount));
    jsonTemp.AddPair('discount_amount', TJSONNumber.Create(FDiscount_amount));

    JSONA := TJSONArray.Create;
    JSONA.AddElement(jsonTemp);

    jsonTemp := TJSONObject.Create;
    jsonTemp.AddPair('medication_request_id', FMedication_request_id);
    jsonTemp.AddPair('dispensed_at', FormatDateTime('YYYY-MM-DD', Date));
    jsonTemp.AddPair('dispensed_by', 'Test ' + FDispensed_by);
    jsonTemp.AddPair('medical_program_id', FMedical_program_id);
    jsonTemp.AddPair('dispense_details', JSONA);

    jsonBody := TJSONObject.Create;
    jsonBody.AddPair('medication_dispense', jsonTemp);
    jsonBody.AddPair('code', FDispensed_Code);

    FRESTClient.BaseURL := FHelsi_be;
    FRESTClient.ContentType := 'application/json';

    FRESTRequest.ClearBody;
    FRESTRequest.Method := TRESTRequestMethod.rmPOST;
    FRESTRequest.Resource := 'dispenses';
    // required parameters
    FRESTRequest.Params.Clear;
    FRESTRequest.AddParameter('Authorization', 'bearer ' + FAccess_Token, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                          [TRESTRequestParameterOption.poDoNotEncode]);

    FRESTRequest.Body.Add(jsonBody.ToString, TRESTContentType.ctAPPLICATION_JSON);
  finally
    jsonBody.Destroy;
  end;

  try
    FRESTRequest.Execute;
  except
  end;

  case FRESTResponse.StatusCode of
    201 : begin
            jValue := FRESTResponse.JSONValue ;
            if jValue.FindValue('data') <> Nil then
            begin
              jValue := jValue.FindValue('data');
              if jValue.FindValue('id') <> Nil then
              begin
                FDispense_ID := StringReplace(jValue.FindValue('id').ToString, '"', '', [rfReplaceAll]);
                Result := True;
              end;
            end;
          end;
    409, 422 : begin
            cError := '';
            jValue := FRESTResponse.JSONValue ;
            if jValue.FindValue('error') <> Nil then
            begin
              j := jValue.FindValue('error');

              if j.FindValue('invalid') <> Nil then
              begin
                JSONA := J.GetValue<TJSONArray>('invalid');
                JSONA := JSONA.Items[0].GetValue<TJSONArray>('rules');
                if JSONA.Items[0].FindValue('description') <> Nil then
                begin
                  cError := StringReplace(JSONA.Items[0].FindValue('description').ToString, '"', '', [rfReplaceAll]);
                end;
              end else if j.FindValue('message') <> Nil then
              begin
                cError := StringReplace(j.FindValue('message').ToString, '"', '', [rfReplaceAll]);
              end;
            end;
            ShowMessage('Ошибка создания запроса на погашение рецепта:'#13#10 + cError);
          end
  else
    ShowMessage('Ошибка создания запроса на погашение рецепта:'#13#10 +
                IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText);
  end;
end;

function THelsiApi.SetPayment : boolean;
var
  jValue, j : TJSONValue;
  jsonBody: TJSONObject;
  JSONA: TJSONArray;
  cError : string;
begin

  Result := False;

  if HelsiApi.FRequest_number = '' then Exit;

  jsonBody := TJSONObject.Create;
  try
    jsonBody.AddPair('payment_id', FPayment_id);
    jsonBody.AddPair('payment_amount', TJSONNumber.Create(FPayment_amount));

    FRESTClient.BaseURL := FHelsi_be;
    FRESTClient.ContentType := 'application/json';

    FRESTRequest.ClearBody;
    FRESTRequest.Method := TRESTRequestMethod.rmPUT;
    FRESTRequest.Resource := 'dispenses/' + FDispense_ID + '/payment';
    // required parameters
    FRESTRequest.Params.Clear;
    FRESTRequest.AddParameter('Authorization', 'bearer ' + FAccess_Token, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                          [TRESTRequestParameterOption.poDoNotEncode]);

    FRESTRequest.Body.Add(jsonBody.ToString, TRESTContentType.ctAPPLICATION_JSON);
  finally
    jsonBody.Destroy;
  end;

  try
    FRESTRequest.Execute;
  except
  end;

  case FRESTResponse.StatusCode of
    200 : begin
            jValue := FRESTResponse.JSONValue ;
            if jValue.FindValue('data') <> Nil then
            begin
              jValue := jValue.FindValue('data');
              if jValue.FindValue('signId') <> Nil then
              begin
                FDispense_sign_ID := StringReplace(jValue.FindValue('signId').ToString, '"', '', [rfReplaceAll]);
                Result := True;
              end;
            end;
          end;
    409, 422 : begin
            cError := '';
            jValue := FRESTResponse.JSONValue ;
            if jValue.FindValue('error') <> Nil then
            begin
              j := jValue.FindValue('error');

              if j.FindValue('invalid') <> Nil then
              begin
                JSONA := J.GetValue<TJSONArray>('invalid');
                JSONA := JSONA.Items[0].GetValue<TJSONArray>('rules');
                if JSONA.Items[0].FindValue('description') <> Nil then
                begin
                  cError := StringReplace(JSONA.Items[0].FindValue('description').ToString, '"', '', [rfReplaceAll]);
                end;
              end else if j.FindValue('message') <> Nil then
              begin
                cError := StringReplace(j.FindValue('message').ToString, '"', '', [rfReplaceAll]);
              end;
            end;
            ShowMessage('Ошибка запроса оплаты рецепта:'#13#10 + cError);
          end
  else
    ShowMessage('Ошибка запроса оплаты рецепта:'#13#10 +
                IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText);
  end;
end;

function THelsiApi.RejectDispense : boolean;
var
  jValue, j : TJSONValue;
  JSONA: TJSONArray;
  cError : string;
begin

  Result := False;

  if HelsiApi.FRequest_number = '' then Exit;

  FRESTClient.BaseURL := FHelsi_be;
  FRESTClient.ContentType := 'application/json';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmDELETE;
  FRESTRequest.Resource := 'dispenses/' + FDispense_ID;
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('Authorization', 'bearer ' + FAccess_Token, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                          [TRESTRequestParameterOption.poDoNotEncode]);

  try
    FRESTRequest.Execute;
  except
  end;

  Result := True;
  case FRESTResponse.StatusCode of
    204 : begin
            Result := True;
          end;
    409, 422 : begin
            cError := '';
            jValue := FRESTResponse.JSONValue ;
            if jValue.FindValue('error') <> Nil then
            begin
              j := jValue.FindValue('error');

              if j.FindValue('invalid') <> Nil then
              begin
                JSONA := J.GetValue<TJSONArray>('invalid');
                JSONA := JSONA.Items[0].GetValue<TJSONArray>('rules');
                if JSONA.Items[0].FindValue('description') <> Nil then
                begin
                  cError := StringReplace(JSONA.Items[0].FindValue('description').ToString, '"', '', [rfReplaceAll]);
                end else if j.FindValue('message') <> Nil then
                begin
                  cError := StringReplace(j.FindValue('message').ToString, '"', '', [rfReplaceAll]);
                end;
              end else if j.FindValue('message') <> Nil then
              begin
                cError := StringReplace(j.FindValue('message').ToString, '"', '', [rfReplaceAll]);
              end;
            end;
            ShowMessage('Ошибка отмены запроса на погашение рецепта:'#13#10 + cError);
          end
  else
    ShowMessage('Ошибка отмены запроса на погашение рецепта:'#13#10 +
                IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText);
  end;
end;

function THelsiApi.IntegrationClientSign : boolean;
var
  jValue, j : TJSONValue;
  jsonBody: TJSONObject;
  JSONA: TJSONArray;
  cError : string;
  fileStream: TFileStream;
  base64Stream: TStringStream;
  S : string;
begin

  Result := False;

  if HelsiApi.FRequest_number = '' then Exit;

  fileStream := TFileStream.Create('Key-6.dat', fmOpenRead);
  base64Stream := TStringStream.Create;
  try
    EncodeStream(fileStream, base64Stream);
    S := base64Stream.DataString;
  finally
    FreeAndNil(fileStream);
    FreeAndNil(base64Stream);
  end;

  jsonBody := TJSONObject.Create;
  try
    jsonBody.AddPair('index', TJSONNumber.Create(1663856895296));
    jsonBody.AddPair('base64Key',S);
    jsonBody.AddPair('password', '0013');

    FRESTClient.BaseURL := 'http://localhost:5000/';
    FRESTClient.ContentType := 'application/json';

    FRESTRequest.ClearBody;
    FRESTRequest.Method := TRESTRequestMethod.rmPOST;
    FRESTRequest.Resource := 'api/v1/' + FDispense_sign_ID + '/sign';
    // required parameters
    FRESTRequest.Params.Clear;

    FRESTRequest.Body.Add(jsonBody.ToString, TRESTContentType.ctAPPLICATION_JSON);
  finally
    jsonBody.Destroy;
  end;

  try
    FRESTRequest.Execute;
  except
  end;

  case FRESTResponse.StatusCode of
    200 : Result := True;
    400, 409, 422, 500 : begin
            cError := '';
            jValue := FRESTResponse.JSONValue ;
            if jValue.FindValue('Message') <> Nil then
            begin
              cError := StringReplace(jValue.FindValue('Message').ToString, '"', '', [rfReplaceAll]);
            end;
            ShowMessage('Ошибка подписи оплаты рецепта:'#13#10 + cError);
          end
  else
    ShowMessage('Ошибка подписи оплаты рецепта:'#13#10 +
                IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText);
  end;
end;


function THelsiApi.ProcessSignedDispense : boolean;
var
  jValue, j : TJSONValue;
  jsonBody: TJSONObject;
  JSONA: TJSONArray;
  cError : string;
begin

  Result := False;

  if HelsiApi.FRequest_number = '' then Exit;

  jsonBody := TJSONObject.Create;
  try
    jsonBody.AddPair('signid', FDispense_sign_ID);

    FRESTClient.BaseURL := FHelsi_be;
    FRESTClient.ContentType := 'application/json';

    FRESTRequest.ClearBody;
    FRESTRequest.Method := TRESTRequestMethod.rmPOST;
    FRESTRequest.Resource := 'dispenses/' + FDispense_ID + '/sign';
    // required parameters
    FRESTRequest.Params.Clear;
    FRESTRequest.AddParameter('Authorization', 'bearer ' + FAccess_Token, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                          [TRESTRequestParameterOption.poDoNotEncode]);

    FRESTRequest.Body.Add(jsonBody.ToString, TRESTContentType.ctAPPLICATION_JSON);
  finally
    jsonBody.Destroy;
  end;

  try
    FRESTRequest.Execute;
  except
  end;

  case FRESTResponse.StatusCode of
    200 : begin
            jValue := FRESTResponse.JSONValue ;
            if jValue.FindValue('data') <> Nil then
            begin
              jValue := jValue.FindValue('data');
              if jValue.FindValue('signId') <> Nil then
              begin
//                FDispense_sign_ID := StringReplace(jValue.FindValue('signId').ToString, '"', '', [rfReplaceAll]);
                Result := True;
              end;
            end;
          end;
    400, 409, 422 : begin
            cError := '';
            jValue := FRESTResponse.JSONValue ;
            if jValue.FindValue('error') <> Nil then
            begin
              j := jValue.FindValue('error');

              if j.FindValue('invalid') <> Nil then
              begin
                JSONA := J.GetValue<TJSONArray>('invalid');
                JSONA := JSONA.Items[0].GetValue<TJSONArray>('rules');
                if JSONA.Items[0].FindValue('description') <> Nil then
                begin
                  cError := StringReplace(JSONA.Items[0].FindValue('description').ToString, '"', '', [rfReplaceAll]);
                end else if j.FindValue('message') <> Nil then
                begin
                  cError := StringReplace(j.FindValue('message').ToString, '"', '', [rfReplaceAll]);
                end;
              end else if j.FindValue('message') <> Nil then
              begin
                cError := StringReplace(j.FindValue('message').ToString, '"', '', [rfReplaceAll]);
              end;
            end;
            ShowMessage('Ошибка погашения запроса на погашения рецепта:'#13#10 + cError);
          end
  else
    ShowMessage('Ошибка погашения запроса на погашения рецепта:'#13#10 +
                IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText);
  end;
end;


//------------------------

function GetHelsiReceipt(const AReceipt : String; var AID, AName : string;
  var AQty : currency; var ADate : TDateTime) : boolean;
  var I : integer;
begin
  Result := False;

  if not CheckRequest_Number(AReceipt) then Exit;

  if not Assigned(HelsiApi) then HelsiApi := THelsiApi.Create;

  if not HelsiApi.CheckIntegrationClient then Exit;

  HelsiApi.FNumber := AReceipt;
  HelsiApi.FRequest_number := '';


  if HelsiApi.FAccess_Token = '' then
  for I := 1 to 3 do
  begin
    if HelsiApi.GetToken and HelsiApi.InitReinitSession then Break;
    Sleep(1000);
  end;

  if HelsiApi.FAccess_Token = '' then
  begin
    ShowMessage('Ошибка получения ключа для доступа к сайту Хелси...');
    Exit;
  end;

  for I := 1 to 5 do
  begin
    if HelsiApi.GetReceiptId then Break;
    Sleep(1000);
    case I of
      1, 3 : begin
               HelsiApi.GetTokenRefresh;
               HelsiApi.InitReinitSession
             end;
      2 : begin
            HelsiApi.GetToken;
            HelsiApi.InitReinitSession
          end;
    end;
  end;

  if AReceipt <> HelsiApi.FRequest_number then
  begin
    ShowMessage('Ошибка получения информации о рецепте с сайта Хелси...');
    Exit;
  end;

  if HelsiApi.FStatus = 'ACTIVE' then
  begin
    AID := HelsiApi.FMedication_ID;
    AName := HelsiApi.FMedication_Name;
    AQty := HelsiApi.FMedication_Qty;
    ADate := HelsiApi.FCreated_at;
    Result := True;
  end else if HelsiApi.FStatus = 'EXPIRED' then
  begin
    HelsiApi.FRequest_number := '';
    ShowMessage('Ошибка чек пророчен.');
  end else
  begin
    HelsiApi.FRequest_number := '';
    ShowMessage('Ошибка неизвестный статус чека.');
  end;
end;

function CreateNewDispense(IDSP : string; AQty, APrice, ASell_amount, ADiscount_amount : currency;
  AWho : string; ACode : string) : boolean;
  var I : integer;
begin

  if not Assigned(HelsiApi) or (HelsiApi.FRequest_number = '') then
  begin
    ShowMessage('Ошибка не получена информация о рецепте с сайта Хелси...');
    Exit;
  end;

  HelsiApi.FSell_Medication_ID := IDSP;
  HelsiApi.FSell_qty := AQty;
  HelsiApi.FSell_price := APrice;
  HelsiApi.FSell_amount := ASell_amount;
  HelsiApi.FDiscount_amount := ADiscount_amount;
  HelsiApi.FDispensed_by := AWho;
  HelsiApi.FDispensed_Code := ACode;

  Result := HelsiApi.CreateNewDispense;
end;

function SetPayment(AID : string; ASum : currency) : boolean;
begin
  Result := False;

  if not Assigned(HelsiApi) or (HelsiApi.FRequest_number = '') then
  begin
    ShowMessage('Ошибка не получена информация о рецепте с сайта Хелси...');
    Exit;
  end;

  if HelsiApi.FDispense_ID = '' then
  begin
    ShowMessage('Ошибка не создан запрос на погашение рецепта...');
    Exit;
  end;

  HelsiApi.FPayment_id := AID;
  HelsiApi.FPayment_amount := ASum;

  Result := HelsiApi.SetPayment;
end;

function RejectDispense : boolean;
begin
  Result := False;

  if not Assigned(HelsiApi) or (HelsiApi.FRequest_number = '') then
  begin
    ShowMessage('Ошибка не получена информация о рецепте с сайта Хелси...');
    Exit;
  end;

  if HelsiApi.FDispense_ID = '' then
  begin
    ShowMessage('Ошибка не создан запрос на погашение рецепта...');
    Exit;
  end;

  Result := HelsiApi.RejectDispense;
end;

function IntegrationClientSign : boolean;
begin
  Result := False;

  if not Assigned(HelsiApi) or (HelsiApi.FRequest_number = '') then
  begin
    ShowMessage('Ошибка не получена информация о рецепте с сайта Хелси...');
    Exit;
  end;

  if HelsiApi.FDispense_sign_ID = '' then
  begin
    ShowMessage('Ошибка не произведена оплата рецепта...');
    Exit;
  end;

  Result := HelsiApi.IntegrationClientSign;
end;



function ProcessSignedDispense : boolean;
begin
  Result := False;

  if not Assigned(HelsiApi) or (HelsiApi.FRequest_number = '') then
  begin
    ShowMessage('Ошибка не получена информация о рецепте с сайта Хелси...');
    Exit;
  end;

  if HelsiApi.FDispense_sign_ID = '' then
  begin
    ShowMessage('Ошибка не произведена оплата рецепта...');
    Exit;
  end;

  Result := HelsiApi.ProcessSignedDispense;
end;


initialization
  HelsiApi := Nil;

finalization
  if Assigned(HelsiApi) then FreeAndNil(HelsiApi);

end.
