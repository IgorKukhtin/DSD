unit UnitLiki24;

interface

uses
  System.SysUtils, System.Variants, System.Classes, System.JSON, Data.DB,
  Vcl.Dialogs, REST.Types, REST.Client, REST.Response.Adapter,
  Winapi.Windows, Vcl.Forms, ShellApi, IdHTTP, IdSSLOpenSSL, System.IOUtils,
  Datasnap.DBClient;

type

  TLiki24API = class(TObject)
  private
    FRESTResponse: TRESTResponse;
    FRESTRequest: TRESTRequest;
    FRESTClient: TRESTClient;

    FBookingsHeadCDS: TClientDataSet;
    FBookingsBodyCDS: TClientDataSet;

    // Данные текущего пользователя
    FUserName : String;
    FPassword : String;

    FToken : String;

    FBaseURL : String;
    FErrorsText : String;

  protected
    function Authenticate : boolean;

    function InitCDS : boolean;
  public
    constructor Create(AUserName, APassword : String; ATest : Boolean = False); virtual;
    destructor Destroy; override;

    function LoadBookings : boolean;

    function UpdateStaus(AbookingId, AexternalBookingId, AStatus, AbookingCode : String; AJSONAItems: TJSONArray) : boolean;

    function GetStaus(AbookingId : String; var AStatus : String) : boolean;

    property BookingsHeadCDS: TClientDataSet read FBookingsHeadCDS;
    property BookingsBodyCDS: TClientDataSet read FBookingsBodyCDS;

    property Token : String read FToken;
    property ErrorsText : String read FErrorsText;
  end;

implementation

function DelDoubleQuote(Value : TJSONValue) : string;
begin
  if Value <> Nil then
    Result := StringReplace(Value.ToString, '"', '', [rfReplaceAll])
  else Result := '';
end;

function BytesToStr(abytes: tbytes): string;
var
  abyte: byte;
begin
   for abyte in abytes do
   begin
      Result := result + IntToStr(abyte) + ',';
   end;
   Result := '[' + Copy(Result, 1, Length(Result) - 1) + ']';
end;

  { TLiki24API }

constructor TLiki24API.Create(AUserName, APassword : String; ATest : Boolean = False);
begin
  FRESTClient := TRESTClient.Create('');
  FRESTResponse := TRESTResponse.Create(Nil);
  FRESTRequest := TRESTRequest.Create(Nil);
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;

  FBookingsHeadCDS := TClientDataSet.Create(Nil);
  FBookingsBodyCDS := TClientDataSet.Create(Nil);

  FUserName := AUserName;
  FPassword := APassword;
  FToken := '';
  FErrorsText := '';

  if ATest then
    FBaseURL := 'https://liki24servdev.azurewebsites.net'
  else FBaseURL := 'https://liki24serv.azurewebsites.net';

  Authenticate;
end;

destructor TLiki24API.Destroy;
begin
  FBookingsBodyCDS.Free;
  FBookingsHeadCDS.Free;
  FRESTResponse.Free;
  FRESTRequest.Free;
  FRESTClient.Free;
end;


function TLiki24API.Authenticate : boolean;
  var jValue : TJSONValue;
      jsonBody: TJSONObject;
begin

  Result := False;

  jsonBody := TJSONObject.Create;
  try
    jsonBody.AddPair('userNameOrEmailAddress', TJSONString.Create(FUserName));
    jsonBody.AddPair('password', TJSONString.Create(FPassword));
    jsonBody.AddPair('rememberClient', TJSONTrue.Create());

    FRESTClient.BaseURL := FBaseURL;
    FRESTClient.ContentType := 'application/json';

    FRESTRequest.ClearBody;
    FRESTRequest.Method := TRESTRequestMethod.rmPOST;
    FRESTRequest.Resource := 'api/TokenAuth/Authenticate';
    // required parameters
    FRESTRequest.Params.Clear;
    FRESTRequest.Body.Add(jsonBody.ToString, TRESTContentType.ctAPPLICATION_JSON);

    try
      FRESTRequest.Execute;
    except
    end;
  finally
    jsonBody.Destroy;
  end;

  if FRESTResponse.ContentType = 'application/json' then
  begin
    jValue := FRESTResponse.JSONValue;

    if (jValue.FindValue('result') <> Nil) and (not jValue.FindValue('result').Null) then
    begin
      jValue := jValue.FindValue('result');
      FToken := DelDoubleQuote(jValue.FindValue('accessToken'));
    end else if (jValue.FindValue('error') <> Nil) and (not jValue.FindValue('error').Null) then
    begin
      jValue := jValue.FindValue('error');
      FErrorsText := DelDoubleQuote(jValue.FindValue('message')) + #13#10 +
                     DelDoubleQuote(jValue.FindValue('details'));
    end else
    begin
      FErrorsText := 'Ошибка получения токена.'#13#10 + jValue.ToString;
      FToken := '';
    end;
  end;
end;


function TLiki24API.InitCDS : boolean;
begin
  try
    FBookingsHeadCDS.Close;
    FBookingsHeadCDS.FieldDefs.Clear;
    FBookingsHeadCDS.FieldDefs.Add('bookingId', TFieldType.ftString, 100);
    FBookingsHeadCDS.FieldDefs.Add('status', TFieldType.ftString, 100);
    FBookingsHeadCDS.FieldDefs.Add('type', TFieldType.ftString, 100);
    FBookingsHeadCDS.FieldDefs.Add('pharmacyId', TFieldType.ftInteger);
    FBookingsHeadCDS.FieldDefs.Add('orderId', TFieldType.ftString, 100);
    FBookingsHeadCDS.FieldDefs.Add('orderNumber', TFieldType.ftInteger);
    FBookingsHeadCDS.CreateDataSet;

    if not FBookingsHeadCDS.Active then FBookingsHeadCDS.Open;

    FBookingsBodyCDS.Close;
    FBookingsBodyCDS.FieldDefs.Clear;
    FBookingsBodyCDS.FieldDefs.Add('bookingId', TFieldType.ftString, 100);
    FBookingsBodyCDS.FieldDefs.Add('itemId', TFieldType.ftString, 100);
    FBookingsBodyCDS.FieldDefs.Add('productId', TFieldType.ftInteger);
    FBookingsBodyCDS.FieldDefs.Add('quantity', TFieldType.ftCurrency);
    FBookingsBodyCDS.FieldDefs.Add('price', TFieldType.ftCurrency);
    FBookingsBodyCDS.CreateDataSet;

    if not FBookingsBodyCDS.Active then FBookingsBodyCDS.Open;
  except
  end;
  Result := FBookingsHeadCDS.Active and FBookingsBodyCDS.Active;
end;

function TLiki24API.LoadBookings : boolean;
  var jValue : TJSONValue;
      JSONA: TJSONArray;
      JSONAI: TJSONArray;
      I, J : integer;
      bookingId : string;
begin

  Result := False;
  FRESTClient.BaseURL := FBaseURL;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Resource := 'api/bookings/integration';
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER,
                                                                          [TRESTRequestParameterOption.poDoNotEncode]);
  FRESTRequest.AddParameter('Authorization', 'Bearer ' + FToken, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                          [TRESTRequestParameterOption.poDoNotEncode]);

  try
    FRESTRequest.Execute;
  except
  end;

  if FRESTResponse.ContentType = 'application/json' then
  begin
    jValue := FRESTResponse.JSONValue;

    if jValue is TJSONArray then
    begin
      JSONA := jValue.GetValue<TJSONArray>;

      if InitCDS then
      begin
        JSONA := jValue.GetValue<TJSONArray>;
        for I := 0 to JSONA.Count - 1 do
        begin
          jValue := JSONA.Items[I];

          bookingId := DelDoubleQuote(jValue.FindValue('bookingId'));

          FBookingsHeadCDS.Last;
          FBookingsHeadCDS.Append;
          FBookingsHeadCDS.FieldByName('bookingId').AsString := bookingId;
          FBookingsHeadCDS.FieldByName('status').AsString := DelDoubleQuote(jValue.FindValue('status'));
          FBookingsHeadCDS.FieldByName('type').AsString := DelDoubleQuote(jValue.FindValue('type'));
          FBookingsHeadCDS.FieldByName('pharmacyId').AsString := DelDoubleQuote(jValue.FindValue('pharmacyId'));
          FBookingsHeadCDS.FieldByName('orderId').AsString := DelDoubleQuote(jValue.FindValue('orderId'));
          FBookingsHeadCDS.FieldByName('orderNumber').AsInteger := StrToInt(DelDoubleQuote(jValue.FindValue('orderNumber')));
          FBookingsHeadCDS.Post;

          JSONAI := jValue.GetValue<TJSONArray>('items');
          for J := 0 to JSONAI.Count - 1 do
          begin
            jValue := JSONAI.Items[J];

            FBookingsBodyCDS.Last;
            FBookingsBodyCDS.Append;
            FBookingsBodyCDS.FieldByName('bookingId').AsString := bookingId;
            FBookingsBodyCDS.FieldByName('itemId').AsString := DelDoubleQuote(jValue.FindValue('itemId'));
            FBookingsBodyCDS.FieldByName('productId').AsString := DelDoubleQuote(jValue.FindValue('productId'));
            FBookingsBodyCDS.FieldByName('quantity').AsCurrency := jValue.GetValue<TJSONNumber>('quantity').AsDouble;
            FBookingsBodyCDS.FieldByName('price').AsCurrency := jValue.GetValue<TJSONNumber>('price').AsDouble;
            FBookingsBodyCDS.Post;
          end;
        end;
        Result := True;
      end;
    end else if (jValue.FindValue('error') <> Nil) and (not jValue.FindValue('error').Null) then
    begin
      jValue := jValue.FindValue('error');
      FErrorsText := DelDoubleQuote(jValue.FindValue('message')) + #13#10 +
                     DelDoubleQuote(jValue.FindValue('details'));
    end else
    begin
      FErrorsText := 'Ошибка получения бронирований.'#13#10 + jValue.ToString;
      FToken := '';
    end;

  end else
  begin
    FErrorsText := 'Ошибка получения бронирований.'#13#10 + FRESTResponse.Content;
  end;

end;

function TLiki24API.UpdateStaus(AbookingId, AexternalBookingId, AStatus, AbookingCode : String; AJSONAItems: TJSONArray) : boolean;
  var jValue : TJSONValue;
      jsonBody: TJSONObject;
begin

  Result := False;

  jsonBody := TJSONObject.Create;
  try
    jsonBody.AddPair('bookingId', TJSONString.Create(AbookingId));
    jsonBody.AddPair('externalBookingId', TJSONString.Create(AexternalBookingId));
    jsonBody.AddPair('status', TJSONString.Create(AStatus));
    jsonBody.AddPair('bookingCode', TJSONString.Create(AexternalBookingId));
    jsonBody.AddPair('items', AJSONAItems);

    FRESTClient.BaseURL := FBaseURL;
    FRESTClient.ContentType := 'application/json';

    FRESTRequest.ClearBody;
    FRESTRequest.Method := TRESTRequestMethod.rmPOST;
    FRESTRequest.Resource := 'api/bookings/integration/reportstatus';
    // required parameters
    FRESTRequest.Params.Clear;
    FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER,
                                                                            [TRESTRequestParameterOption.poDoNotEncode]);
    FRESTRequest.AddParameter('Authorization', 'Bearer ' + FToken, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                            [TRESTRequestParameterOption.poDoNotEncode]);
    FRESTRequest.Body.Add(jsonBody.ToString, TRESTContentType.ctAPPLICATION_JSON);

    try
      FRESTRequest.Execute;
    except
    end;
  finally
    jsonBody.Destroy;
  end;

  if FRESTResponse.ContentType = 'application/json' then
  begin
    jValue := FRESTResponse.JSONValue;

    if (jValue.FindValue('result') <> Nil) and (not jValue.FindValue('result').Null) then
    begin

    end else if (jValue.FindValue('error') <> Nil) and (not jValue.FindValue('error').Null) then
    begin
      jValue := jValue.FindValue('error');
      FErrorsText := DelDoubleQuote(jValue.FindValue('message')) + #13#10 +
                     DelDoubleQuote(jValue.FindValue('details'));
    end else
    begin
      FErrorsText := 'Ошибка изменения статуса.'#13#10 + jValue.ToString;
    end;
  end else if FRESTResponse.StatusCode = 200 then Result := True
  else FErrorsText := 'Ошибка изменения статуса.'#13#10 +  FRESTResponse.StatusText;

end;

function TLiki24API.GetStaus(AbookingId : String; var AStatus : String) : boolean;
  var jValue : TJSONValue;
begin

  Result := False;
  AStatus := '';

  try

    FRESTClient.BaseURL := FBaseURL;
    FRESTClient.ContentType := 'application/json';

    FRESTRequest.ClearBody;
    FRESTRequest.Method := TRESTRequestMethod.rmGET;
    FRESTRequest.Resource := 'api/bookings/integration/' + AbookingId;
    // required parameters
    FRESTRequest.Params.Clear;
    FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER,
                                                                            [TRESTRequestParameterOption.poDoNotEncode]);
    FRESTRequest.AddParameter('Authorization', 'Bearer ' + FToken, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                            [TRESTRequestParameterOption.poDoNotEncode]);

    try
      FRESTRequest.Execute;
    except
    end;
  finally
  end;

  if FRESTResponse.ContentType = 'application/json' then
  begin
    jValue := FRESTResponse.JSONValue;

    if (jValue.FindValue('status') <> Nil) and (not jValue.FindValue('status').Null) then
    begin
      AStatus := DelDoubleQuote(jValue.FindValue('status'));
      Result := True;
    end else if (jValue.FindValue('error') <> Nil) and (not jValue.FindValue('error').Null) then
    begin
      jValue := jValue.FindValue('error');
      FErrorsText := DelDoubleQuote(jValue.FindValue('message')) + #13#10 +
                     DelDoubleQuote(jValue.FindValue('details'));
    end else
    begin
      FErrorsText := 'Ошибка получения статуса.'#13#10 + jValue.ToString;
    end;
  end;
end;

end.
