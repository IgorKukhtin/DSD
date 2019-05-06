unit Helsi;

interface

uses
  Windows, System.SysUtils, System.Variants, System.Classes, System.JSON,
  Vcl.Dialogs, REST.Types, REST.Client, REST.Response.Adapter;

type

  THelsiApi = class(TObject)
  private
    FRESTResponse: TRESTResponse;
    FRESTRequest: TRESTRequest;
    FRESTClient: TRESTClient;

    // Данные текущего пользователя
    FUserName : String;
    FPassword : String;
    FBase64Key : String;
    FKeyPassword : String;

    // Адреса сайтоа Хелси
    FHelsi_Id : String;
    FHelsi_be : String;
    // Адреса сайтоа подписи рецепта
    FIntegrationClient : String;

    // Базовые параметры подключения
    FClientId : String;
    FClientSecret : String;

    // Токены доступа
    FAccess_Token : String;
    FRefresh_Token : String;

    // Информация о сортруднике (по логину)
    FUser_FullName : String;
    FUser_taxId : String;
    FUser_blocked : Boolean;

    // Информация ключа сортруднике
    FKey_taxId : String;
    FKey_index : Int64;
    FKey_startDate : TDateTime;
    FKey_expireDate : TDateTime;

    // Номер рецепта
    FNumber : String;

    // Данные из рецепта
    FMedication_ID : string;            // dosage_id что выписано
    FMedication_Name : string;          // Название
    FMedication_Qty : currency;         // Количество выписано

    FMedication_request_id : String;    // ID рецепта
    FMedical_program_id : String;       // ID соц. программы программы

    FRequest_number : String;           // Номер рецепта из чека
    FStatus : string;                   // Статус чека
    FCreated_at : TDateTime;            // Дата создания
    FDispense_valid_from : TDateTime;   // Действителен с
    FDispense_valid_to : TDateTime;     // по

    //

    FSell_Medication_ID : string;
    FSell_qty : Currency;
    FSell_price : Currency;
    FSell_amount : Currency;
    FDiscount_amount : Currency;
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
    function IntegrationClientKeyInfo : boolean;
    function IntegrationClientSign : boolean;
    function ProcessSignedDispense : boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function InitSession : boolean;
    function ShowError(AText : string) : string;
  end;

function GetHelsiReceipt(const AReceipt : String; var AID, AName : string;
  var AQty : currency; var ADate : TDateTime) : boolean;

function CreateNewDispense(IDSP : string; AQty, APrice, ASell_amount, ADiscount_amount : currency;
  ACode : string) : boolean;

function RejectDispense : boolean;

function SetPayment(AID : string; ASum : currency) : boolean;

function IntegrationClientSign : boolean;

function ProcessSignedDispense : boolean;

implementation

uses MainCash2, RegularExpressions, System.Generics.Collections, Soap.EncdDecd,
     DBClient, LocalWorkUnit, CommonData, ChoiceHelsiUserName;

var HelsiApi : THelsiApi;

const arError : array [0..13, 0..2] of string =
  (('Active medication dispense already exists', 'forbidden', 'Наразі здійснюється погашення цього рецепту'),
  ('Legal entity is not verified', 'request_conflict', 'Увага! Ваш заклад не веріфіковано. Зверніться до керівництва Вашого закладу.'),
  ('Can''t update medication dispense status from PROCESSED to REJECTED', 'request_conflict', 'Диспенс заекспайрится (рецепт разблокируется) автоматически через 10 мин.'),
  ('Medication request is not active', 'request_conflict', 'Увага! Рецепт не може бути погашено, адже дата закінчення лікування за ним прошла. Рекомендуйте пацієнту звернутися до лікаря для виписки нового рецепту із більш тривалим терміном лікування.'),
  ('Division should be participant of a contract to create dispense', 'request_conflict', 'Увага! Аптеку в якій Ви працюєте, не включено в діючий договір за програмою "Доступні ліки" з Національною службою здоров''я України. Зверніться до керівництва Вашого закладу'),
  ('Medication request can not be dispensed. Invoke qualify medication request API to get detailed info', 'request_conflict', 'Неможливо погасити цей рецепт за програмою "Доступні ліки"! Пацієнту щойно було видано препарат з такою же діючою речовиною. Поки що цей рецепт може бути відпущено тільки поза програмою реімбурсації.'),
  ('Program cannot be used - no active contract exists', 'request_conflict', 'Увага! За Вашим закладом відсутній діючий договір за програмою "Доступні ліки" з Національною службою здоров''я України. Зверніться до керівництва Вашого закладу'),
  ('Can''t update medication dispense status from EXPIRED to PROCESSED', 'request_conflict', 'Необхідно повторити операцію погашення'),
  ('Does not match the legal entity', 'request_malformed', 'Помилка! Підпис КЕП не належить юридичній особі. Повторіть спробу використовуючи Ваш коректний КЕП'),
  ('Does not match the signer drfo', 'request_malformed', 'Помилка! Підпис КЕП належить іншому співробітнику. Повторіть спробу використовуючи Ваш коректний КЕП'),
  ('Does not match the signer last name', 'request_malformed', 'Помилка! Проблема з співставленням прізвища підписувача. Повторіть спробу використовуючи Ваш коректний КЕП'),
  ('document must contain 1 signature and 0 stamps but contains 0 signatures and 1 stamp', 'request_malformed', 'Помилка! При підписанні Ви використовуєте не власний КЕП. Повторіть спробу використовуючи Ваш коректний КЕП'),
  ('Requested discount price does not satisfy allowed reimbursement amount', 'validation_failed', 'Помилка! Невідповідність суми реімбурсації до умов програми "Доступні ліки".'),
  ('Medication request is not valid', 'validation_failed', 'Некоректні параметри запиту на отримання рецепту'));


function DelDoubleQuote(AStr : string) : string;
begin
  Result := StringReplace(AStr, '"', '', [rfReplaceAll]);
end;

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

      for J := 1 to 4 do if not CharInSet(Res[I][J], ['0'..'9','A'..'Z']) then exit;
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
    Res := TRegEx.Split(DelDoubleQuote(ADateStr), '-');
    if High(Res) <> 2 then exit;
    try
      ADate := EncodeDate(StrToInt(Res[0]), StrToInt(Res[1]), StrToInt(Copy(Res[2], 1, 2)));
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
end;

destructor THelsiApi.Destroy;
begin
  FRESTResponse.Free;
  FRESTRequest.Free;
  FRESTClient.Free;
end;

function THelsiApi.ShowError(AText : string) : string;
var
  jValue, j : TJSONValue;
  JSONA: TJSONArray;
  cMessage, cType, cDescription, cError : string;
  I : integer;
begin
  cError := ''; cDescription := '';
  jValue := FRESTResponse.JSONValue ;
  if jValue.FindValue('error') <> Nil then
  begin
    j := jValue.FindValue('error');

    if j.FindValue('message') <> Nil then
    begin
      cMessage := DelDoubleQuote(j.FindValue('message').ToString);
    end else cMessage := '';

    if j.FindValue('type') <> Nil then
    begin
      cType := DelDoubleQuote(j.FindValue('type').ToString);
    end else cType := '';

    if j.FindValue('invalid') <> Nil then
    begin
      JSONA := J.GetValue<TJSONArray>('invalid');
      JSONA := JSONA.Items[0].GetValue<TJSONArray>('rules');
      if JSONA.Items[0].FindValue('description') <> Nil then
      begin
        cDescription := DelDoubleQuote(JSONA.Items[0].FindValue('description').ToString);
      end;
    end;
    if cDescription = '' then cDescription := cMessage;

    for I := 0 to 13 do if (LowerCase(arError[I, 0]) = LowerCase(cDescription)) and (LowerCase(arError[I, 1]) = LowerCase(cType)) then
    begin
      cError := arError[I, 2];
      Break;
    end;

    if cError = '' then
      for I := 0 to 13 do if (LowerCase(arError[I, 0]) = LowerCase(cDescription)) then
      begin
        cError := arError[I, 2];
        Break;
      end;

    if (cError = '') and (cDescription <> '') then cError := cDescription
  end;

  if cError = '' then
    case FRESTResponse.StatusCode of
      401 : cError := 'Користувач не авторизований в helsi';
      403 : cError := 'Доступ заборонено';
      404 : cError := 'Рецепт не знайдено';
      else cError := IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText;
    end;

  ShowMessage(AText + ':'#13#10 + cError);
end;

function THelsiApi.CheckIntegrationClient : boolean;
begin

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
      FAccess_Token := DelDoubleQuote(jValue.FindValue('access_token').ToString);
      FRefresh_Token := DelDoubleQuote(jValue.FindValue('refresh_token').ToString);
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
      FAccess_Token := DelDoubleQuote(jValue.FindValue('access_token').ToString);
      FRefresh_Token := DelDoubleQuote(jValue.FindValue('refresh_token').ToString);
      Result := FAccess_Token <> '';
    end;
  end;
end;

function THelsiApi.InitReinitSession : boolean;
var
  jValue : TJSONValue;
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
  try
    FRESTRequest.Execute;
  except
  end;

  if FRESTResponse.StatusCode = 200 then
  begin
    try
      jValue := FRESTResponse.JSONValue ;
      FUser_FullName := '';
      if jValue.FindValue('lastName') <> Nil then
        FUser_FullName := FUser_FullName + DelDoubleQuote(jValue.FindValue('lastName').ToString) +  ' ';
      if jValue.FindValue('firstName') <> Nil then
        FUser_FullName := FUser_FullName + DelDoubleQuote(jValue.FindValue('firstName').ToString) +  ' ';
      if jValue.FindValue('middleName') <> Nil then
        FUser_FullName := FUser_FullName + DelDoubleQuote(jValue.FindValue('middleName').ToString);
      FUser_FullName := Trim(FUser_FullName);

      if jValue.FindValue('taxId') <> Nil then
        FUser_taxId := DelDoubleQuote(jValue.FindValue('taxId').ToString);
      if jValue.FindValue('blocked') <> Nil then
        FUser_blocked := jValue.FindValue('blocked').ClassNameIs('TJSONTrue');
      Result := True;
    except
    end
  end;

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
          FMedical_program_id := DelDoubleQuote(j.FindValue('id').ToString);
        end else Exit;

        if jValue.FindValue('medication_info') <> Nil then
        begin
          j := jValue.FindValue('medication_info');
          FMedication_ID := DelDoubleQuote(j.FindValue('medication_id').ToString);
          FMedication_Name := DelDoubleQuote(j.FindValue('medication_name').ToString);
          FMedication_Qty := StrToCurr(StringReplace(StringReplace(j.FindValue('medication_qty').ToString,
                            ',', FormatSettings.DecimalSeparator, [rfReplaceAll]),
                            '.', FormatSettings.DecimalSeparator, [rfReplaceAll]));

          FMedication_request_id := DelDoubleQuote(jValue.FindValue('id').ToString);
          FStatus := DelDoubleQuote(jValue.FindValue('status').ToString);
          if not StrToDateSite(jValue.FindValue('created_at').ToString, FCreated_at) then Exit;
          if not StrToDateSite(jValue.FindValue('dispense_valid_from').ToString, FDispense_valid_from) then Exit;
          if not StrToDateSite(jValue.FindValue('dispense_valid_to').ToString, FDispense_valid_to) then Exit;
          FRequest_number := DelDoubleQuote(jValue.FindValue('request_number').ToString);

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

  jsonBody := TJSONObject.Create;
  try
    jsonTemp := TJSONObject.Create;
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
    jsonTemp.AddPair('dispensed_by', FUser_FullName);
    jsonTemp.AddPair('medical_program_id', FMedical_program_id);
    jsonTemp.AddPair('dispense_details', JSONA);

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
                FDispense_ID := DelDoubleQuote(jValue.FindValue('id').ToString);
                Result := True;
              end;
            end;
          end;
    else ShowError('Ошибка создания запроса на погашение рецепта');
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
                FDispense_sign_ID := DelDoubleQuote(jValue.FindValue('signId').ToString);
                Result := True;
              end;
            end;
          end;
    else ShowError('Ошибка запроса оплаты рецепта')
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
    204 : Result := True;
    else ShowError('Ошибка запроса оплаты рецепта')
  end;
end;

function THelsiApi.IntegrationClientKeyInfo : boolean;
var
  jValue : TJSONValue;
  jsonBody: TJSONObject;
  JSONA: TJSONArray;
  cError : string;
begin

  Result := False;

  jsonBody := TJSONObject.Create;
  try
    jsonBody.AddPair('base64Key', FBase64Key);
    jsonBody.AddPair('password', FKeyPassword);

    FRESTClient.BaseURL := FIntegrationClient;
    FRESTClient.ContentType := 'application/json';

    FRESTRequest.ClearBody;
    FRESTRequest.Method := TRESTRequestMethod.rmPOST;
    FRESTRequest.Resource := '/api/v1/keyinfo';
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
    200 : begin
            JSONA := FRESTResponse.JSONValue.GetValue<TJSONArray>;
            jValue := JSONA.Items[0];
            if jValue.FindValue('index') <> Nil then
              FKey_index := jValue.GetValue<TJSONNumber>('index').AsInt64;

            if jValue.FindValue('certificates') <> Nil then
            begin
               jValue := jValue.FindValue('certificates');
               JSONA := jValue.GetValue<TJSONArray>;
               jValue := JSONA.Items[0];
               if jValue.FindValue('drfo') <> Nil then
               begin
                 FKey_taxId := DelDoubleQuote(jValue.FindValue('drfo').ToString);
                 if not StrToDateSite(jValue.FindValue('startDate').ToString, FKey_startDate) then Exit;
                 if not StrToDateSite(jValue.FindValue('expireDate').ToString, FKey_expireDate) then Exit;
                 Result := True;
               end;
            end;
          end;
    else
      cError := '';
      jValue := FRESTResponse.JSONValue ;
      if jValue.FindValue('Message') <> Nil then
      begin
        cError := DelDoubleQuote(jValue.FindValue('Message').ToString);
      end else cError := IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText;
      ShowMessage('Ошибка подписи оплаты рецепта:'#13#10 + cError);
  end;
end;

function THelsiApi.IntegrationClientSign : boolean;
var
  jValue : TJSONValue;
  jsonBody: TJSONObject;
  cError : string;
begin

  Result := False;

  if HelsiApi.FRequest_number = '' then Exit;

  jsonBody := TJSONObject.Create;
  try
    jsonBody.AddPair('index', TJSONNumber.Create(FKey_index));
    jsonBody.AddPair('base64Key', FBase64Key);
    jsonBody.AddPair('password', FKeyPassword);

    FRESTClient.BaseURL := FIntegrationClient;
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
    else
      cError := '';
      jValue := FRESTResponse.JSONValue ;
      if jValue.FindValue('Message') <> Nil then
      begin
        cError := DelDoubleQuote(jValue.FindValue('Message').ToString);
      end else cError := IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText;
      ShowMessage('Ошибка подписи оплаты рецепта:'#13#10 + cError);
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
    200 : Result := True;
    else ShowError('Ошибка погашения запроса на погашения рецепта');
  end;
end;

function THelsiApi.InitSession : boolean;
  var I : integer;
begin

  Result := False;
  FNumber := '';
  FRequest_number := '';
  FAccess_Token := '';

  if not CheckIntegrationClient then Exit;

  for I := 1 to 3 do
  begin
    if GetToken and InitReinitSession then Break;
    Sleep(1000);
  end;

  if FAccess_Token = '' then
  begin
    ShowMessage('Ошибка получения ключа для доступа к сайту Хелси...');
    Exit;
  end;

  if InitReinitSession then
  begin
    if FUser_blocked then
    begin
      ShowMessage('Учетная запись сотрудника'#13#10 + FUser_FullName + #13#10'Заблокирована !...');
      Exit;
    end;
  end else Exit;

  if IntegrationClientKeyInfo then
  begin

    if FUser_taxId <> FKey_taxId then
    begin
      ShowMessage('Учетные данные сотрудника не соответствуют ключу !...');
      Exit;
    end;

    if FKey_startDate > Date then
    begin
      ShowMessage('Файловый ключ не вступил в действие !...');
      Exit;
    end;

    if FKey_expireDate < Date then
    begin
      ShowMessage('Файловый ключ просрочен !...');
      Exit;
    end;

    Result := True;
  end;
end;


//------------------------

function GetHelsiReceipt(const AReceipt : String; var AID, AName : string;
  var AQty : currency; var ADate : TDateTime) : boolean;
  var I : integer;
      ds : TClientDataSet;
begin
  Result := False;

  if not CheckRequest_Number(AReceipt) then Exit;

  if not Assigned(HelsiApi) then
  begin
    HelsiApi := THelsiApi.Create;

    HelsiApi.FHelsi_Id := MainCashForm.UnitConfigCDS.FieldByName('Helsi_Id').AsString;
    HelsiApi.FHelsi_be := MainCashForm.UnitConfigCDS.FieldByName('Helsi_be').AsString;
    HelsiApi.FIntegrationClient := MainCashForm.UnitConfigCDS.FieldByName('Helsi_IntegrationClient').AsString;

    HelsiApi.FClientId := MainCashForm.UnitConfigCDS.FieldByName('Helsi_ClientId').AsString;
    HelsiApi.FClientSecret := MainCashForm.UnitConfigCDS.FieldByName('Helsi_ClientSecret').AsString;

    if (HelsiApi.FHelsi_Id = '') or (HelsiApi.FHelsi_be = '') or (HelsiApi.FIntegrationClient = '')  then
    begin
      FreeAndNil(HelsiApi);
      ShowMessage('Ошибка не заполнены данные для подключения к сайтам Хелси...');
      Exit;
    end;

    if (HelsiApi.FClientId = '') or (HelsiApi.FClientSecret = '')  then
    begin
      FreeAndNil(HelsiApi);
      ShowMessage('Ошибка не заполнены ID или секрет клиента...');
      Exit;
    end;

    try
      ds := TClientDataSet.Create(nil);
      try
        WaitForSingleObject(MutexUserHelsi, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
        try
          LoadLocalData(ds,UserHelsi_lcl);
        finally
          ReleaseMutex(MutexUserHelsi);
        end;

        if ds.RecordCount <= 0 then
        begin
          FreeAndNil(HelsiApi);
          ShowMessage('По подразделению нет сотрудников для закрытия рецептов...');
          Exit;
        end;

        if not ds.Locate('ID', gc_User.Session, []) then
        begin
          if not ChoiceHelsiUserNameExecute(ds) then
          begin
            FreeAndNil(HelsiApi);
            Exit;
          end;
        end;

        HelsiApi.FUserName := ds.FieldByName('UserName').AsString;
        HelsiApi.FPassword := DecodeString(ds.FieldByName('UserPassword').AsString);
        HelsiApi.FBase64Key := ds.FieldByName('Key').AsString;
        HelsiApi.FKeyPassword := DecodeString(ds.FieldByName('KeyPassword').AsString);

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        FreeAndNil(HelsiApi);
        ShowMessage('Ошибка получения учетных данных сотрудника: ' + E.Message);
        Exit;
      end;
    end;

    if not HelsiApi.InitSession then
    begin
      FreeAndNil(HelsiApi);
      Exit;
    end;
  end else if not HelsiApi.IntegrationClientKeyInfo then Exit;

  HelsiApi.FNumber := AReceipt;

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
    ShowMessage('Ошибка получения информации о рецепте с сайта Хелси...'#13#10 +
      'Неправельный номер рецепта или обрыв соеденения.');
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
  end else if HelsiApi.FStatus = 'COMPLETED' then
  begin
    HelsiApi.FRequest_number := '';
    ShowMessage('Ошибка чек погашен.');
  end else
  begin
    HelsiApi.FRequest_number := '';
    ShowMessage('Ошибка неизвестный статус чека.');
  end;
end;

function CreateNewDispense(IDSP : string; AQty, APrice, ASell_amount, ADiscount_amount : currency;
  ACode : string) : boolean;
begin

  Result := False;

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

//  HelsiApi.IntegrationClientKeyInfo;

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
