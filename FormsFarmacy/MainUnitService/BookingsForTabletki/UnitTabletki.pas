unit UnitTabletki;

interface

uses
  System.SysUtils, System.Variants, System.Classes, System.JSON, Data.DB,
  Vcl.Dialogs, REST.Types, REST.Client, REST.Response.Adapter,
  Winapi.Windows, Vcl.Forms, ShellApi, IdHTTP, IdSSLOpenSSL, System.IOUtils,
  Datasnap.DBClient, Soap.EncdDecd, Soap.XSBuiltIns;

type

  TTabletkiAPI = class(TObject)
  private
    FRESTResponse: TRESTResponse;
    FRESTRequest: TRESTRequest;
    FRESTClient: TRESTClient;

    FBookingsHeadCDS: TClientDataSet;
    FBookingsBodyCDS: TClientDataSet;

    // Данные текущего пользователя
    FUserName : String;
    FPassword : String;

    FBaseURL : String;
    FErrorsText : String;

  protected
    function InitCDS : boolean;
  public
    constructor Create(AUserName, APassword : String; ATest : Boolean = False); virtual;
    destructor Destroy; override;

    function LoadBookings(ASerialNumber : Integer) : boolean;
    function LoadСancelledOrders(ASerialNumber : Integer) : boolean;

    function CancelReason(ASerialNumber : Integer; ABookingId : String; ACancelReasonId : Integer;
                          AJSONAItems: TJSONArray) : boolean;

    function UpdateStaus(ASerialNumber : Integer;
                         ABookingId, AId, AStatusNew, ACode, ACustomer, ACustomerPhone, ACancelReason : String;
                         ADate : TDateTime;
                         AJSONAItems: TJSONArray) : boolean;

    property BookingsHeadCDS: TClientDataSet read FBookingsHeadCDS;
    property BookingsBodyCDS: TClientDataSet read FBookingsBodyCDS;

    property ErrorsText : String read FErrorsText;
  end;

implementation

function DelDoubleQuote(Value : TJSONValue) : string;
begin
  if Value <> Nil then
    Result := StringReplace(Value.ToString, '"', '', [rfReplaceAll])
  else Result := '';
end;

function JSONStrToDate(Value : TJSONValue) : TDateTime;
  var S : String;
begin
  with TXSDateTime.Create do
  try
    XSToNative(DelDoubleQuote(Value));
    result := AsUTCDateTime;
  finally
    Free;
  end;
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

function EncodeBase64(const Input: TBytes): string;
const
  Base64: array[0..63] of Char =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

  function Encode3Bytes(const Byte1, Byte2, Byte3: Byte): string;
  begin
    Result := Base64[Byte1 shr 2]
      + Base64[((Byte1 shl 4) or (Byte2 shr 4)) and $3F]
      + Base64[((Byte2 shl 2) or (Byte3 shr 6)) and $3F]
      + Base64[Byte3 and $3F];
  end;

  function EncodeLast2Bytes(const Byte1, Byte2: Byte): string;
  begin
    Result := Base64[Byte1 shr 2]
      + Base64[((Byte1 shl 4) or (Byte2 shr 4)) and $3F]
      + Base64[(Byte2 shl 2) and $3F] + '=';
  end;

  function EncodeLast1Byte(const Byte1: Byte): string;
  begin
    Result := Base64[Byte1 shr 2]
      + Base64[(Byte1 shl 4) and $3F] + '==';
  end;

var
  i, iLength: Integer;
begin
  Result := '';
  iLength := Length(Input);
  i := 0;
  while i < iLength do
  begin
    case iLength - i of
      3..MaxInt:
        Result := Result + Encode3Bytes(Input[i], Input[i+1], Input[i+2]);
      2:
        Result := Result + EncodeLast2Bytes(Input[i], Input[i+1]);
      1:
        Result := Result + EncodeLast1Byte(Input[i]);
    end;
    Inc(i, 3);
  end;
end;

  { TTabletkiAPI }

constructor TTabletkiAPI.Create(AUserName, APassword : String; ATest : Boolean = False);
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
  FErrorsText := '';

  if ATest then
    FBaseURL := 'https://reserve.tabletki.ua/api/testorders'
  else FBaseURL := 'https://reserve.tabletki.ua/api/orders';
end;

destructor TTabletkiAPI.Destroy;
begin
  FBookingsBodyCDS.Free;
  FBookingsHeadCDS.Free;
  FRESTResponse.Free;
  FRESTRequest.Free;
  FRESTClient.Free;
end;

function TTabletkiAPI.InitCDS : boolean;
begin
  try
    FBookingsHeadCDS.Close;
    FBookingsHeadCDS.FieldDefs.Clear;
    FBookingsHeadCDS.FieldDefs.Add('bookingId', TFieldType.ftString, 100);
    FBookingsHeadCDS.FieldDefs.Add('code', TFieldType.ftInteger);
    FBookingsHeadCDS.FieldDefs.Add('statusID', TFieldType.ftString, 10);
    FBookingsHeadCDS.FieldDefs.Add('dateTimeCreated', TFieldType.ftDateTime);
    FBookingsHeadCDS.FieldDefs.Add('customer', TFieldType.ftString, 100);
    FBookingsHeadCDS.FieldDefs.Add('customerPhone', TFieldType.ftString, 100);
    FBookingsHeadCDS.FieldDefs.Add('customerEmail', TFieldType.ftString, 100);
    FBookingsHeadCDS.FieldDefs.Add('branchID', TFieldType.ftString, 100);
    FBookingsHeadCDS.FieldDefs.Add('externalNmb', TFieldType.ftString, 100);
    FBookingsHeadCDS.FieldDefs.Add('docAdditionalInfo', TFieldType.ftString, 100);
    FBookingsHeadCDS.FieldDefs.Add('customerAdditionalInfo', TFieldType.ftString, 100);
    FBookingsHeadCDS.FieldDefs.Add('reserveSource', TFieldType.ftString, 100);
    FBookingsHeadCDS.FieldDefs.Add('cancelReason', TFieldType.ftString, 100);

    FBookingsHeadCDS.CreateDataSet;

    if not FBookingsHeadCDS.Active then FBookingsHeadCDS.Open;

    FBookingsBodyCDS.Close;
    FBookingsBodyCDS.FieldDefs.Clear;
    FBookingsBodyCDS.FieldDefs.Add('bookingId', TFieldType.ftString, 100);
    FBookingsBodyCDS.FieldDefs.Add('goodsCode', TFieldType.ftInteger);
    FBookingsBodyCDS.FieldDefs.Add('goodsName', TFieldType.ftString, 100);
    FBookingsBodyCDS.FieldDefs.Add('goodsProducer', TFieldType.ftString, 100);
    FBookingsBodyCDS.FieldDefs.Add('qty', TFieldType.ftCurrency);
    FBookingsBodyCDS.FieldDefs.Add('price', TFieldType.ftCurrency);
    FBookingsBodyCDS.FieldDefs.Add('qtyShip', TFieldType.ftCurrency);
    FBookingsBodyCDS.FieldDefs.Add('priceShip', TFieldType.ftCurrency);
    FBookingsBodyCDS.FieldDefs.Add('needOrder', TFieldType.ftInteger);
    FBookingsBodyCDS.CreateDataSet;

    if not FBookingsBodyCDS.Active then FBookingsBodyCDS.Open;
  except
  end;
  Result := FBookingsHeadCDS.Active and FBookingsBodyCDS.Active;
end;

function TTabletkiAPI.LoadBookings(ASerialNumber : Integer) : boolean;
  var jValue : TJSONValue;
      JSONA: TJSONArray;
      JSONAI: TJSONArray;
      I, J : integer;
      bookingId, S : string;
begin

  Result := False;
  FErrorsText := '';
  S := FUserName + ':' + FPassword;

  FRESTClient.BaseURL := FBaseURL;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Resource := IntToStr(ASerialNumber) + '/0';
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER,
                                                                          [TRESTRequestParameterOption.poDoNotEncode]);
  FRESTRequest.AddParameter('Authorization', 'Basic ' + EncodeBase64(BytesOf(S)), TRESTRequestParameterKind.pkHTTPHEADER,
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
        for I := 0 to JSONA.Count - 1 do
        begin
          jValue := JSONA.Items[I];

          bookingId := DelDoubleQuote(jValue.FindValue('id'));

          FBookingsHeadCDS.Last;
          FBookingsHeadCDS.Append;
          FBookingsHeadCDS.FieldByName('bookingId').AsString := bookingId;
          FBookingsHeadCDS.FieldByName('code').AsInteger := jValue.GetValue<TJSONNumber>('code').AsInt;
          FBookingsHeadCDS.FieldByName('statusID').AsString := DelDoubleQuote(jValue.FindValue('statusID'));
          FBookingsHeadCDS.FieldByName('dateTimeCreated').AsDateTime := JSONStrToDate(jValue.FindValue('dateTimeCreated'));
          FBookingsHeadCDS.FieldByName('customer').AsString := DelDoubleQuote(jValue.FindValue('customer'));
          FBookingsHeadCDS.FieldByName('customerPhone').AsString := DelDoubleQuote(jValue.FindValue('customerPhone'));
          FBookingsHeadCDS.FieldByName('customerEmail').AsString := DelDoubleQuote(jValue.FindValue('customerEmail'));
          FBookingsHeadCDS.FieldByName('branchID').AsString := DelDoubleQuote(jValue.FindValue('branchID'));
          FBookingsHeadCDS.FieldByName('externalNmb').AsString := DelDoubleQuote(jValue.FindValue('externalNmb'));
          FBookingsHeadCDS.FieldByName('docAdditionalInfo').AsString := DelDoubleQuote(jValue.FindValue('docAdditionalInfo'));
          FBookingsHeadCDS.FieldByName('customerAdditionalInfo').AsString := DelDoubleQuote(jValue.FindValue('customerAdditionalInfo'));
          FBookingsHeadCDS.FieldByName('reserveSource').AsString := DelDoubleQuote(jValue.FindValue('reserveSource'));
          FBookingsHeadCDS.FieldByName('cancelReason').AsString := DelDoubleQuote(jValue.FindValue('cancelReason'));

          FBookingsHeadCDS.Post;

          JSONAI := jValue.GetValue<TJSONArray>('rows');
          for J := 0 to JSONAI.Count - 1 do
          begin
            jValue := JSONAI.Items[J];

            FBookingsBodyCDS.Last;
            FBookingsBodyCDS.Append;
            FBookingsBodyCDS.FieldByName('bookingId').AsString := bookingId;
            FBookingsBodyCDS.FieldByName('goodsCode').AsInteger := StrToInt(DelDoubleQuote(jValue.FindValue('goodsCode')));
            FBookingsBodyCDS.FieldByName('goodsName').AsString := DelDoubleQuote(jValue.FindValue('goodsName'));
            FBookingsBodyCDS.FieldByName('goodsProducer').AsString := DelDoubleQuote(jValue.FindValue('goodsProducer'));
            FBookingsBodyCDS.FieldByName('qty').AsCurrency := jValue.GetValue<TJSONNumber>('qty').AsDouble;
            FBookingsBodyCDS.FieldByName('price').AsCurrency := jValue.GetValue<TJSONNumber>('price').AsDouble;
            FBookingsBodyCDS.FieldByName('qtyShip').AsCurrency := jValue.GetValue<TJSONNumber>('qtyShip').AsDouble;
            FBookingsBodyCDS.FieldByName('priceShip').AsCurrency := jValue.GetValue<TJSONNumber>('priceShip').AsDouble;
            FBookingsBodyCDS.FieldByName('needOrder').AsInteger := jValue.GetValue<TJSONNumber>('needOrder').AsInt;
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
      FErrorsText := 'Ошибка получения заказов.'#13#10 + jValue.ToString;
    end;

  end else
  begin
    FErrorsText := 'Ошибка получения заказов.'#13#10 + FRESTResponse.Content;
  end;

end;

function TTabletkiAPI.LoadСancelledOrders(ASerialNumber : Integer) : boolean;
  var jValue : TJSONValue;
      JSONA: TJSONArray;
      JSONAI: TJSONArray;
      I, J : integer;
      bookingId, S : string;
begin

  Result := False;
  FErrorsText := '';
  S := FUserName + ':' + FPassword;

  FRESTClient.BaseURL := FBaseURL;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Resource := 'cancelledOrdersByCustomer/' + IntToStr(ASerialNumber);
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER,
                                                                          [TRESTRequestParameterOption.poDoNotEncode]);
  FRESTRequest.AddParameter('Authorization', 'Basic ' + EncodeBase64(BytesOf(S)), TRESTRequestParameterKind.pkHTTPHEADER,
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
        for I := 0 to JSONA.Count - 1 do
        begin
          jValue := JSONA.Items[I];

          bookingId := DelDoubleQuote(jValue.FindValue('id'));

          FBookingsHeadCDS.Last;
          FBookingsHeadCDS.Append;
          FBookingsHeadCDS.FieldByName('bookingId').AsString := bookingId;
          FBookingsHeadCDS.FieldByName('code').AsInteger := jValue.GetValue<TJSONNumber>('code').AsInt;
          FBookingsHeadCDS.FieldByName('statusID').AsString := DelDoubleQuote(jValue.FindValue('statusID'));
          FBookingsHeadCDS.FieldByName('dateTimeCreated').AsDateTime := JSONStrToDate(jValue.FindValue('dateTimeCreated'));
          FBookingsHeadCDS.FieldByName('customer').AsString := DelDoubleQuote(jValue.FindValue('customer'));
          FBookingsHeadCDS.FieldByName('customerPhone').AsString := DelDoubleQuote(jValue.FindValue('customerPhone'));
          FBookingsHeadCDS.FieldByName('customerEmail').AsString := DelDoubleQuote(jValue.FindValue('customerEmail'));
          FBookingsHeadCDS.FieldByName('branchID').AsString := DelDoubleQuote(jValue.FindValue('branchID'));
          FBookingsHeadCDS.FieldByName('externalNmb').AsString := DelDoubleQuote(jValue.FindValue('externalNmb'));
          FBookingsHeadCDS.FieldByName('docAdditionalInfo').AsString := DelDoubleQuote(jValue.FindValue('docAdditionalInfo'));
          FBookingsHeadCDS.FieldByName('customerAdditionalInfo').AsString := DelDoubleQuote(jValue.FindValue('customerAdditionalInfo'));
          FBookingsHeadCDS.FieldByName('reserveSource').AsString := DelDoubleQuote(jValue.FindValue('reserveSource'));
          FBookingsHeadCDS.FieldByName('cancelReason').AsString := DelDoubleQuote(jValue.FindValue('cancelReason'));

          FBookingsHeadCDS.Post;

          JSONAI := jValue.GetValue<TJSONArray>('rows');
          for J := 0 to JSONAI.Count - 1 do
          begin
            jValue := JSONAI.Items[J];

            FBookingsBodyCDS.Last;
            FBookingsBodyCDS.Append;
            FBookingsBodyCDS.FieldByName('bookingId').AsString := bookingId;
            FBookingsBodyCDS.FieldByName('goodsCode').AsInteger := StrToInt(DelDoubleQuote(jValue.FindValue('goodsCode')));
            FBookingsBodyCDS.FieldByName('goodsName').AsString := DelDoubleQuote(jValue.FindValue('goodsName'));
            FBookingsBodyCDS.FieldByName('goodsProducer').AsString := DelDoubleQuote(jValue.FindValue('goodsProducer'));
            FBookingsBodyCDS.FieldByName('qty').AsCurrency := jValue.GetValue<TJSONNumber>('qty').AsDouble;
            FBookingsBodyCDS.FieldByName('price').AsCurrency := jValue.GetValue<TJSONNumber>('price').AsDouble;
            FBookingsBodyCDS.FieldByName('qtyShip').AsCurrency := jValue.GetValue<TJSONNumber>('qtyShip').AsDouble;
            FBookingsBodyCDS.FieldByName('priceShip').AsCurrency := jValue.GetValue<TJSONNumber>('priceShip').AsDouble;
            FBookingsBodyCDS.FieldByName('needOrder').AsInteger := jValue.GetValue<TJSONNumber>('needOrder').AsInt;
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
      FErrorsText := 'Ошибка получения заказов.'#13#10 + jValue.ToString;
    end;

  end else
  begin
    FErrorsText := 'Ошибка получения заказов.'#13#10 + FRESTResponse.Content;
  end;

end;

function TTabletkiAPI.CancelReason(ASerialNumber : Integer; ABookingId : String; ACancelReasonId : Integer;
                      AJSONAItems: TJSONArray) : boolean;
  var jValue : TJSONValue;
      jsonBody: TJSONArray;
      jsonItem: TJSONObject;
      JSONA: TJSONArray;
      S : string;
begin

  Result := False;
  FErrorsText := '';
  S := FUserName + ':' + FPassword;

  jsonBody := TJSONArray.Create;
  try
    jsonItem := TJSONObject.Create;
    jsonItem.AddPair('id', TJSONString.Create(AbookingId)).
             AddPair('id_CancelReason', TJSONNumber.Create(ACancelReasonId)).
             AddPair('rows', AJSONAItems);
    jsonBody.AddElement(jsonItem);

    FRESTClient.BaseURL := FBaseURL;
    FRESTClient.ContentType := 'application/json';

    FRESTRequest.ClearBody;
    FRESTRequest.Method := TRESTRequestMethod.rmPOST;
    FRESTRequest.Resource := 'cancelledOrders';
    // required parameters
    FRESTRequest.Params.Clear;
    FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER,
                                                                            [TRESTRequestParameterOption.poDoNotEncode]);
    FRESTRequest.AddParameter('Authorization', 'Basic ' + EncodeBase64(BytesOf(S)), TRESTRequestParameterKind.pkHTTPHEADER,
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

    if (jValue.FindValue('processedDocs') <> Nil) and (not jValue.FindValue('processedDocs').Null) then
    begin
      JSONA := jValue.GetValue<TJSONArray>('processedDocs');
      if JSONA.Count > 0 then
      begin
        jValue := JSONA.Items[0];
        Result := ABookingId = DelDoubleQuote(jValue.FindValue('id'));
      end;
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


function TTabletkiAPI.UpdateStaus(ASerialNumber : Integer;
                                  ABookingId, AId, AStatusNew, ACode, ACustomer, ACustomerPhone, ACancelReason : String;
                                  ADate : TDateTime;
                                  AJSONAItems: TJSONArray) : boolean;
  var jValue : TJSONValue;
      jsonBody: TJSONArray;
      jsonItem: TJSONObject;
      JSONA: TJSONArray;
      S : string;
begin

  Result := False;
  S := FUserName + ':' + FPassword;

  jsonBody := TJSONArray.Create;
  try
    jsonItem := TJSONObject.Create;
    jsonItem.AddPair('id', TJSONString.Create(AbookingId)).
             AddPair('code', TJSONNumber.Create(ACode)).
             AddPair('statusID', TJSONNumber.Create(AStatusNew)).
             AddPair('dateTimeCreated', TJSONString.Create(FormatDateTime('yyyy''-''mm''-''dd''T''hh'':''nn'':''ss', ADate))).
             AddPair('customer', TJSONString.Create(ACustomer)).
             AddPair('customerPhone', TJSONString.Create(ACustomerPhone)).
             AddPair('customerEmail', TJSONString.Create('')).
             AddPair('branchID', TJSONString.Create(IntToStr(ASerialNumber))).
             AddPair('externalNmb', TJSONString.Create(AId)).
             AddPair('docAdditionalInfo', TJSONString.Create('')).
             AddPair('customerAdditionalInfo', TJSONString.Create('')).
             AddPair('reserveSource', TJSONString.Create('FSource')).
             AddPair('cancelReason', TJSONString.Create(ACancelReason)).
             AddPair('rows', AJSONAItems);
    jsonBody.AddElement(jsonItem);

    FRESTClient.BaseURL := FBaseURL;
    FRESTClient.ContentType := 'application/json';

    FRESTRequest.ClearBody;
    FRESTRequest.Method := TRESTRequestMethod.rmPOST;
    FRESTRequest.Resource := '';
    // required parameters
    FRESTRequest.Params.Clear;
    FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER,
                                                                            [TRESTRequestParameterOption.poDoNotEncode]);
    FRESTRequest.AddParameter('Authorization', 'Basic ' + EncodeBase64(BytesOf(S)), TRESTRequestParameterKind.pkHTTPHEADER,
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

    if (jValue.FindValue('processedDocs') <> Nil) and (not jValue.FindValue('processedDocs').Null) then
    begin
      JSONA := jValue.GetValue<TJSONArray>('processedDocs');
      if JSONA.Count > 0 then
      begin
        jValue := JSONA.Items[0];
        Result := ABookingId = DelDoubleQuote(jValue.FindValue('id'));
      end;
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

end.
