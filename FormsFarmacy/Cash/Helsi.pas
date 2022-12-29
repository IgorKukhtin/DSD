unit Helsi;

interface

uses
  Windows, System.SysUtils, System.Variants, System.Classes, System.JSON,
  Vcl.Dialogs, REST.Types, REST.Client, REST.Response.Adapter,
  Vcl.Forms, ShellApi, IdHTTP, IdSSLOpenSSL;

type

  THelsiApi = class(TObject)
  private
    FRESTResponse: TRESTResponse;
    FRESTRequest: TRESTRequest;
    FRESTClient: TRESTClient;

    // Данные текущего пользователя
    FUserId : Integer;
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

    FReject_Reason : String;
    FReject_Reason_Code : String;

    // Номер рецепта
    FNumber : String;

    // Данные из рецепта
    FMedication_ID : string;            // dosage_id что выписано
    FMedication_ID_List : String;       // ID что выписано
    FMedication_Name : string;          // Название
    FMedication_Qty : currency;         // Количество выписано

    FMedication_request_id : String;    // ID рецепта
    FMedical_program_id : String;       // ID соц. программы программы
    FMedical_program_Name : String;     // Название соц. программы программы

    FRequest_number : String;           // Номер рецепта из чека
    FStatus : string;                   // Статус чека
    FCreated_at : TDateTime;            // Дата создания
    FDispense_valid_from : TDateTime;   // Действителен с
    FDispense_valid_to : TDateTime;     // по

    FMulti_Medication_Dispense_Allowed : boolean; // Частичного погашения рецепта.
    FSkip_Medication_Dispense_Sign : boolean; // Возможность погашения рецепта без применения КЭП

    //

    FSell_Medication_ID : string;
    FProgram_Medication_Id : string;
    FSell_qty : Currency;
    FSell_price : Currency;
    FSell_amount : Currency;
    FDiscount_amount : Currency;
    FDispensed_Code : string;

    FDispense_ID : string;

    FPayment_id : string;
    FPayment_amount : currency;

    FDispense_sign_ID : string;

    FShow_eHealth : Boolean;
    FShow_Location : String;
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
    function IntegrationClientGetKeyInfo(ABase64Key, AKeyPassword : String; var AKey_expireDate : TDateTime) : boolean;
    function IntegrationClientSign : boolean;
    function ProcessSignedDispense : boolean;
    function GetHTTPLocation : Boolean;
    function GetStateReceipt : boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function InitSession : boolean;
    function ShowError(AText : string) : string;
  end;

function GetHelsiReceipt(const AReceipt : String; var AID, AIDList, AName : string;
  var AQty : currency; var ADate : TDateTime; var AProgramId, AProgramName : String;
  var APartialPrescription, ASkipDispenseSign : Boolean) : boolean;

function GetHelsiReceiptState(const AReceipt : String; var AState, AProgramMedicationId  : string; var AIniError : boolean) : boolean;

function CreateNewDispense(AIDSP, AProgramIdSP : string; AQty, APrice, ASell_amount, ADiscount_amount, ASum : currency;
  ACode : string) : boolean;  overload;
function CreateNewDispense : boolean; overload;

function RejectDispense : boolean;

function SetPayment(AID : string; ASum : currency) : boolean; overload;
function SetPayment : boolean; overload;

function IntegrationClientSign : boolean;

function ProcessSignedDispense : boolean;

function CheckRequest_Number(ANumber : string) : boolean;

function GetStateReceipt : boolean;

function GetKey_expireDate(var AUserId : integer; var AKey_expireDate : TDateTime) : boolean;

function GetKey_User_expireDate(ABase64Key, AKeyPassword : String; var AKey_expireDate : TDateTime) : boolean;

function IsActiveHelsiApi : boolean;

implementation

uses MainCash2, RegularExpressions, System.Generics.Collections, Soap.EncdDecd,
     DBClient, LocalWorkUnit, CommonData, ChoiceHelsiUserName;

var HelsiApi : THelsiApi;

const arError : array [0..19, 0..1] of string =
  (('Active medication dispense already exists', 'Наразі здійснюється погашення цього рецепту'),
  ('Legal entity is not verified',  'Увага! Ваш заклад не веріфіковано. Зверніться до керівництва Вашого закладу.'),
  ('Can''t update medication dispense status from PROCESSED to REJECTED', 'Диспенс заекспайрится (рецепт разблокируется) автоматически через 10 мин.'),
  ('Medication request is not active', 'Увага! Рецепт не може бути погашено, адже дата закінчення лікування за ним прошла. Рекомендуйте пацієнту звернутися до лікаря для виписки нового рецепту із більш тривалим терміном лікування.'),
  ('Division should be participant of a contract to create dispense', 'Увага! Аптеку в якій Ви працюєте, не включено в діючий договір за програмою "Доступні ліки" з Національною службою здоров''я України. Зверніться до керівництва Вашого закладу'),
  ('Medication request can not be dispensed. Invoke qualify medication request API to get detailed info', 'Неможливо погасити цей рецепт за програмою "Доступні ліки"! Пацієнту щойно було видано препарат з такою же діючою речовиною. Поки що цей рецепт може бути відпущено тільки поза програмою реімбурсації.'),
  ('Program cannot be used - no active contract exists', 'Увага! За Вашим закладом відсутній діючий договір за програмою "Доступні ліки" з Національною службою здоров''я України. Зверніться до керівництва Вашого закладу'),
  ('Can''t update medication dispense status from EXPIRED to PROCESSED', 'Необхідно повторити операцію погашення'),
  ('Can''t update medication dispense status from REJECTED to PROCESSED', 'Необхідно повторити операцію погашення'),
  ('Can''t update medication dispense status from REJECTED to REJECTED', 'Необхідно повторити операцію погашення'),
  ('Does not match the legal entity', 'Помилка! Підпис КЕП не належить юридичній особі. Повторіть спробу використовуючи Ваш коректний КЕП'),
  ('Does not match the signer drfo', 'Помилка! Підпис КЕП належить іншому співробітнику. Повторіть спробу використовуючи Ваш коректний КЕП'),
  ('Does not match the signer last name', 'Помилка! Проблема з співставленням прізвища підписувача. Повторіть спробу використовуючи Ваш коректний КЕП'),
  ('document must contain 1 signature and 0 stamps but contains 0 signatures and 1 stamp', 'Помилка! При підписанні Ви використовуєте не власний КЕП. Повторіть спробу використовуючи Ваш коректний КЕП'),
  ('Requested discount price does not satisfy allowed reimbursement amount', 'Помилка! Невідповідність суми реімбурсації до умов програми "Доступні ліки".'),
  ('Medication request is not valid', 'Некоректні параметри запиту на отримання рецепту'),
  ('Incorrect code', 'Неправельный код подтверждения'),
  ('Invalid dispense period', 'Увага! Сплив термін дії рецепту. Пацієнту потрібно звернутися до лікаря для виписки нового рецепту'),
  ('dispensed medication quantity must be equal to medication quantity in Medication Request', 'Количество отпускаемого лекарства должно быть равно количеству выписанного в рецепте лекарства'),
  ('Certificate verificaton failed', 'Не удалось подтвердить сертификат. Повторите попытку погашения чека.'));


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
    if not Result then ShowMessage ('Ошибка.<Регистрационный номер рецепта>'#13#10#13#10 +
      'Номер должен содержать 19 символов в 4 блока по 4 символа разделенных символом "-"'#13#10 +
      'Cодержать только цыфры и буквы латинского алфовита'#13#10 +
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
  FUserId := 0;
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

  if (jValue.FindValue('error') <> Nil) then
  begin
    j := jValue.FindValue('error');

    if j.FindValue('message') <> Nil then
    begin
      cMessage := j.FindValue('message').Value;
    end else cMessage := '';

    if j.FindValue('type') <> Nil then
    begin
      cType := j.FindValue('type').Value;
    end else cType := '';

    if j.FindValue('invalid') <> Nil then
    begin
      JSONA := J.GetValue<TJSONArray>('invalid');
      JSONA := JSONA.Items[0].GetValue<TJSONArray>('rules');
      if JSONA.Items[0].FindValue('description') <> Nil then
      begin
        cDescription := JSONA.Items[0].FindValue('description').Value;
      end;
    end;
    if cDescription = '' then cDescription := cMessage;

    for I := 0 to 19 do if (LowerCase(arError[I, 0]) = LowerCase(cDescription)) then
    begin
      cError := arError[I, 1];
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
  if not Result then
  begin
    if FRESTResponse.StatusCode = 0 then
      ShowMessage('Ошибка подключения к eSign Integration client:'#13#10'Не был запущен Веб-сервер, запустите!')
    else ShowMessage('Ошибка подключения к eSign Integration client:'#13#10 +
                     IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText);
  end;
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
      FAccess_Token := jValue.FindValue('access_token').Value;
      FRefresh_Token := jValue.FindValue('refresh_token').Value;
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
      FAccess_Token := jValue.FindValue('access_token').Value;
      FRefresh_Token := jValue.FindValue('refresh_token').Value;
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
        FUser_FullName := FUser_FullName + jValue.FindValue('lastName').Value +  ' ';
      if jValue.FindValue('firstName') <> Nil then
        FUser_FullName := FUser_FullName + jValue.FindValue('firstName').Value +  ' ';
      if jValue.FindValue('middleName') <> Nil then
        FUser_FullName := FUser_FullName + jValue.FindValue('middleName').Value;
      FUser_FullName := Trim(FUser_FullName);

      if jValue.FindValue('taxId') <> Nil then
        FUser_taxId := jValue.FindValue('taxId').Value;
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
  JSONA: TJSONArray;
  I : integer; s : string;
begin
  Result := False;
  FDispense_sign_ID := '';
  FDispense_ID := '';
  FRequest_number := '';
  FMedication_request_id := '';
  FMedication_ID_List := '';
  HelsiApi.FReject_Reason_Code := '';
  FMulti_Medication_Dispense_Allowed := False;
  FSkip_Medication_Dispense_Sign := False;

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

//  ShowMessage(FHelsi_be + '/receipts/' + FNumber);
//  ShowMessage(IntToStr(FRESTResponse.StatusCode) + ' ' + FRESTResponse.StatusText + #13#10 + FRESTResponse.Content);

//  if FRESTResponse.JSONValue <> Nil then InputBox('11', s, FHelsi_be + #13#10 + IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText + #13#10 + FRESTResponse.JSONValue.ToString)
//  else InputBox('11', s, FHelsi_be + #13#10 + IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText + #13#10 + FRESTResponse.Content);

  if (FRESTResponse.StatusCode = 200) and (FRESTResponse.ContentType = 'application/json') then
  begin
    try
      jValue := FRESTResponse.JSONValue;
      if jValue.FindValue('data') <> Nil then
      begin
        jValue := jValue.FindValue('data');

        if jValue.FindValue('medical_program') <> Nil then
        begin
          j := jValue.FindValue('medical_program');
          FMedical_program_id := j.FindValue('id').Value;
          FMedical_program_Name := j.FindValue('name').Value;

          if j.FindValue('medical_program_settings') <> Nil then
          begin
            j := j.FindValue('medical_program_settings');
            if j.FindValue('multi_medication_dispense_allowed') <> Nil then
              FMulti_Medication_Dispense_Allowed := TJSONBool(j.FindValue('multi_medication_dispense_allowed')).AsBoolean;
            if j.FindValue('skip_medication_dispense_sign') <> Nil then
              FSkip_Medication_Dispense_Sign := TJSONBool(j.FindValue('skip_medication_dispense_sign')).AsBoolean;
          end;
        end else FMedical_program_id := '';

        if jValue.FindValue('reject_reason_code') <> Nil then
        begin
          FReject_Reason := jValue.FindValue('reject_reason').Value;
          FReject_Reason_Code := jValue.FindValue('reject_reason_code').Value;
          Exit;
        end;

        if jValue.FindValue('medication_info') <> Nil then
        begin
          j := jValue.FindValue('medication_info');
          FMedication_ID := j.FindValue('medication_id').Value;
          FMedication_Name := j.FindValue('medication_name').Value;
          FMedication_Qty := TJSONNumber(j.FindValue('medication_qty')).AsDouble;
          if j.FindValue('medication_remaining_qty') <> Nil then
            FMedication_Qty := TJSONNumber(j.FindValue('medication_remaining_qty')).AsDouble;

          FMedication_request_id := jValue.FindValue('id').Value;
          FStatus := jValue.FindValue('status').Value;
          if not StrToDateSite(jValue.FindValue('created_at').Value, FCreated_at) then Exit;
          if not StrToDateSite(jValue.FindValue('dispense_valid_from').Value, FDispense_valid_from) then Exit;
          if not StrToDateSite(jValue.FindValue('dispense_valid_to').Value, FDispense_valid_to) then Exit;

          if jValue.FindValue('qualify') <> Nil then
          begin
            JSONA := jValue.GetValue<TJSONArray>('qualify');
            if JSONA.Count > 0 then
            begin

              if (FMedical_program_id = '') and (JSONA.Items[0].FindValue('program_id') <> Nil) then
              begin
                FMedical_program_id := JSONA.Items[0].FindValue('program_id').Value;
                FMedical_program_Name := JSONA.Items[0].FindValue('program_name').Value;
              end;

              if JSONA.Items[0].FindValue('participants') <> Nil then
              begin
                JSONA := JSONA.Items[0].GetValue<TJSONArray>('participants');
                for I := 0 to JSONA.Count - 1 do if JSONA.Items[I].FindValue('medication_id') <> Nil then
                begin
                  if FMedication_ID_List = '' then FMedication_ID_List := JSONA.Items[I].FindValue('medication_id').Value
                  else FMedication_ID_List := FMedication_ID_List + FormatSettings.ListSeparator + JSONA.Items[I].FindValue('medication_id').Value;
                end;
              end;
            end;
          end;

          FRequest_number := jValue.FindValue('request_number').Value;

          Result := True;
        end;
      end;
    except
    end
  end else if ((FRESTResponse.StatusCode = 200) or (FRESTResponse.StatusCode = 302)) and (FRESTResponse.ContentType = 'text/html') then
  begin
    if GetHTTPLocation then Result := True;
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
    jsonTemp.AddPair('program_medication_id', FProgram_Medication_Id);

    JSONA := TJSONArray.Create;
    JSONA.AddElement(jsonTemp);

    jsonTemp := TJSONObject.Create;
    jsonTemp.AddPair('medication_request_id', FMedication_request_id);
    jsonTemp.AddPair('dispensed_at', FormatDateTime('YYYY-MM-DD', Date));
    jsonTemp.AddPair('dispensed_by', FUser_FullName);
    jsonTemp.AddPair('medical_program_id', FMedical_program_id);
    if FSkip_Medication_Dispense_Sign then
      jsonTemp.AddPair('payment_amount', TJSONNumber.Create(FPayment_amount));
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
                FDispense_ID := jValue.FindValue('id').Value;
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
                FDispense_sign_ID := jValue.FindValue('signId').Value;
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
  if FDispense_ID = '' then Exit;

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

  case FRESTResponse.StatusCode of
    204 : begin
            Result := True;
            FDispense_ID := '';
          end
    else ShowError('Ошибка запроса на отмену запроса на погашения')
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
                 FKey_taxId := jValue.FindValue('drfo').Value;
                 if not StrToDateSite(jValue.FindValue('startDate').Value, FKey_startDate) then Exit;
                 if not StrToDateSite(jValue.FindValue('expireDate').Value, FKey_expireDate) then Exit;
                 Result := True;
               end;
            end;
          end;
    else
      cError := '';
      jValue := FRESTResponse.JSONValue ;
      if jValue.FindValue('Message') <> Nil then
      begin
        cError := jValue.FindValue('Message').Value;
      end else cError := IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText;
      ShowMessage('Ошибка подписи оплаты рецепта:'#13#10 + cError);
  end;
end;

function THelsiApi.IntegrationClientGetKeyInfo(ABase64Key, AKeyPassword : String; var AKey_expireDate : TDateTime) : boolean;
var
  jValue : TJSONValue;
  jsonBody: TJSONObject;
  JSONA: TJSONArray;
  cError : string;
begin

  Result := False;

  jsonBody := TJSONObject.Create;
  try
    jsonBody.AddPair('base64Key', ABase64Key);
    jsonBody.AddPair('password', AKeyPassword);

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
                 FKey_taxId := jValue.FindValue('drfo').Value;
                 if not StrToDateSite(jValue.FindValue('expireDate').Value, AKey_expireDate) then Exit;
                 Result := True;
               end;
            end;
          end;
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
  except on E: Exception do
         Begin
           if FRESTResponse.JSONValue <> Nil then
             ShowMessage('Ошибка подписи оплаты рецепта:'#13#10 + E.Message + #13#10 + FRESTResponse.JSONValue.Tostring)
           else ShowMessage('Ошибка подписи оплаты рецепта:'#13#10 + E.Message);
           Exit;
         End;
  end;

  case FRESTResponse.StatusCode of
    200 : Result := True;
    else
    begin
      cError := '';
      if FRESTResponse.ContentType = 'application/json' then
      begin
        jValue := FRESTResponse.JSONValue ;
        if jValue.FindValue('Message') <> Nil then
        begin
          cError := jValue.FindValue('Message').Value;
        end else cError := IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText;
      end else cError := IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText;
      ShowMessage('Ошибка подписи оплаты рецепта:'#13#10 + cError);
    end;
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

function THelsiApi.GetHTTPLocation : Boolean;
  var  mStream: TMemoryStream;
       IdHTTP: TIdHTTP;
       IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
       S : String;

begin
  Result := False;

  IdHTTP := TIdHTTP.Create(Nil);
  IdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(Nil);
  IdHTTP.IOHandler := IdSSLIOHandlerSocketOpenSSL;
  mStream := TMemoryStream.Create;

  try
    IdHTTP.Request.ContentType := 'application/json';
    IdHTTP.Request.ContentEncoding := 'utf-8';
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.Add('Authorization:Bearer ' + FAccess_Token);

    try
      S := IdHTTP.Get(FHelsi_be + 'dispenses');
    except
    end;

    case IdHTTP.ResponseCode of
      302 : if IdHTTP.Response.RawHeaders.IndexOfName('Location') >= 0 then
            begin
              Result := True;
              FShow_eHealth := True;
              FShow_Location := IdHTTP.Response.RawHeaders.Values['Location'];
            end;
    end;
  finally
    mStream.Free;
    IdHTTP.Free;
    IdSSLIOHandlerSocketOpenSSL.Free;
  end;
end;

function THelsiApi.GetStateReceipt : boolean;
var
  jValue, j : TJSONValue;
  JSONA: TJSONArray;
  I : integer;
begin
  Result := False;

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

  if (FRESTResponse.StatusCode = 200) and (FRESTResponse.ContentType = 'application/json') then
  begin
    try
      jValue := FRESTResponse.JSONValue ;
      if jValue.FindValue('data') <> Nil then
      begin
        jValue := jValue.FindValue('data');

        if jValue.FindValue('medical_program') <> Nil then
        begin
          j := jValue.FindValue('medical_program');

          if j.FindValue('medical_program_settings') <> Nil then
          begin
            j := j.FindValue('medical_program_settings');
            if j.FindValue('multi_medication_dispense_allowed') <> Nil then
              FMulti_Medication_Dispense_Allowed := TJSONBool(j.FindValue('multi_medication_dispense_allowed')).AsBoolean;
            if j.FindValue('skip_medication_dispense_sign') <> Nil then
              FSkip_Medication_Dispense_Sign := TJSONBool(j.FindValue('skip_medication_dispense_sign')).AsBoolean;
          end;
        end else FMedical_program_id := '';

        if FSkip_Medication_Dispense_Sign = True then
          Result := True
        else if jValue.FindValue('medication_info') <> Nil then
        begin
          Result := jValue.FindValue('status').Value = 'COMPLETED';
        end;
      end;
    except
    end
  end else if ((FRESTResponse.StatusCode = 200) or (FRESTResponse.StatusCode = 302)) and (FRESTResponse.ContentType = 'text/html') then
  begin
    GetHTTPLocation;
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

    if (gc_User.Session = '3') then
    begin
      Result := True;
      Exit;
    end;

    if FUser_taxId <> FKey_taxId then
    begin
      ShowMessage('Учетные данные сотрудника не соответствуют ключу !...'#13#10#13#10 +
                  'INN в учетных данных сотрудника ' + FUser_taxId + #13#10 +
                  'INN в файловом ключе сотрудника ' + FKey_taxId);
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


function InitHelsiApi : boolean;
  var I : integer;
      ds : TClientDataSet;
      S : string;
       // временно
      fileStream: TFileStream;
      base64Stream: TStringStream;
begin

  Result := False;

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

        HelsiApi.FUserId := ds.FieldByName('Id').AsInteger;
        HelsiApi.FUserName := ds.FieldByName('UserName').AsString;
        HelsiApi.FPassword := DecodeString(ds.FieldByName('UserPassword').AsString);
        HelsiApi.FBase64Key := ds.FieldByName('Key').AsString;
        HelsiApi.FKeyPassword := DecodeString(ds.FieldByName('KeyPassword').AsString);

        // временно
        if HelsiApi.FUserName = 'roza.y+gonchar@helsi.me' then
        begin
          fileStream := TFileStream.Create('Копия.ZS2', fmOpenRead);
          base64Stream := TStringStream.Create;
          try
            EncodeStream(fileStream, base64Stream);
            HelsiApi.FBase64Key := base64Stream.DataString;
          finally
            FreeAndNil(fileStream);
            FreeAndNil(base64Stream);
          end;
        end;

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

  Result := True;
end;


function GetHelsiReceipt(const AReceipt : String; var AID, AIDList, AName : string;
  var AQty : currency; var ADate : TDateTime; var AProgramId, AProgramName : String;
  var APartialPrescription, ASkipDispenseSign : Boolean) : boolean;
  var I : integer;
begin
  Result := False;

  if not CheckRequest_Number(AReceipt) then Exit;

  if not InitHelsiApi then Exit;

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
    if HelsiApi.FReject_Reason_Code <> '' then Break;
  end;

  if HelsiApi.FShow_eHealth then
  begin
    ShellExecute(Screen.ActiveForm.Handle, 'open', PChar(HelsiApi.FShow_Location), nil, nil, SW_SHOWNORMAL);
    HelsiApi.FShow_eHealth := False;
    HelsiApi.FShow_Location := '';
    Exit;
  end;

  if HelsiApi.FReject_Reason_Code <> '' then
  begin
    ShowMessage('Ошибка получения информации о рецепте с сайта Хелси...'#13#10#13#10 +
      HelsiApi.FReject_Reason);
    Exit;
  end;

  if AReceipt <> HelsiApi.FRequest_number then
  begin
    ShowMessage('Ошибка получения информации о рецепте с сайта Хелси...'#13#10 +
      'Неправельный номер рецепта.');
    Exit;
  end;

  if HelsiApi.FDispense_valid_to < Date then
  begin
    ShowMessage('Срок действия рецепта истек...');
    Exit;
  end;

  if HelsiApi.FStatus = 'ACTIVE' then
  begin

    if HelsiApi.FMedical_program_id = '' then
    begin
      ShowMessage('Нет в чеке информации о соц проекте...');
      Exit;
    end;

    AID := HelsiApi.FMedication_ID;
    AIDList := HelsiApi.FMedication_ID_List;
    AName := HelsiApi.FMedication_Name;
    AQty := HelsiApi.FMedication_Qty;
    ADate := HelsiApi.FCreated_at;
    AprogramId := HelsiApi.FMedical_program_id;
    AprogramName := HelsiApi.FMedical_program_Name;
    APartialPrescription := HelsiApi.FMulti_Medication_Dispense_Allowed;
    ASkipDispenseSign := HelsiApi.FSkip_Medication_Dispense_Sign;
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

function GetHelsiReceiptState(const AReceipt : String; var AState, AProgramMedicationId : string; var AIniError : boolean) : boolean;
  var I : integer; bIniError : boolean;
begin
  Result := False;
  bIniError := AIniError;
  AState := 'Error';

  if not CheckRequest_Number(AReceipt) then Exit;

  if not InitHelsiApi then
  begin
    AIniError := True;
    Exit;
  end;

  HelsiApi.FNumber := AReceipt;

  for I := 1 to 3 do
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

  if HelsiApi.FShow_eHealth then
  begin
    if not bIniError then ShellExecute(Screen.ActiveForm.Handle, 'open', PChar(HelsiApi.FShow_Location), nil, nil, SW_SHOWNORMAL);
    HelsiApi.FShow_eHealth := False;
    HelsiApi.FShow_Location := '';
    Exit;
  end;

  if AReceipt <> HelsiApi.FRequest_number then Exit;

  AState := HelsiApi.FStatus;
  AProgramMedicationId := HelsiApi.FMedical_program_id;
  Result := True;
end;


function CreateNewDispense(AIDSP, AProgramIdSP : string; AQty, APrice, ASell_amount, ADiscount_amount, ASum : currency;
  ACode : string) : boolean;
begin

  Result := False;

  if not Assigned(HelsiApi) or (HelsiApi.FRequest_number = '') then
  begin
    ShowMessage('Ошибка не получена информация о рецепте с сайта Хелси...');
    Exit;
  end;

  HelsiApi.FSell_Medication_ID := AIDSP;
  HelsiApi.FProgram_Medication_Id := AProgramIdSP;
  HelsiApi.FSell_qty := AQty;
  HelsiApi.FSell_price := APrice;
  HelsiApi.FSell_amount := ASell_amount;
  HelsiApi.FPayment_amount := ASum;
  if HelsiApi.FSkip_Medication_Dispense_Sign then HelsiApi.FDiscount_amount := 0
  else HelsiApi.FDiscount_amount := ADiscount_amount;
  HelsiApi.FDispensed_Code := ACode;

  Result := HelsiApi.CreateNewDispense;
end;

function CreateNewDispense : boolean;
begin
  Result := False;

  if not Assigned(HelsiApi) or (HelsiApi.FRequest_number = '') then
  begin
    ShowMessage('Ошибка не получена информация о рецепте с сайта Хелси...');
    Exit;
  end;

  Result := HelsiApi.CreateNewDispense;
end;

function SetPayment(AID : string; ASum : currency) : boolean;
begin
  Result := False;

  if HelsiApi.FSkip_Medication_Dispense_Sign then
  begin
    Result := True;
    Exit;
  end;

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

function SetPayment : boolean; overload;
begin
  Result := False;

  if HelsiApi.FSkip_Medication_Dispense_Sign then
  begin
    Result := True;
    Exit;
  end;

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

  if HelsiApi.FDispense_ID = '' then Exit;

  Result := HelsiApi.RejectDispense;
end;

function IntegrationClientSign : boolean;
begin
  Result := False;

//  HelsiApi.IntegrationClientKeyInfo;

  if HelsiApi.FSkip_Medication_Dispense_Sign then
  begin
    Result := True;
    Exit;
  end;

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

  if HelsiApi.FSkip_Medication_Dispense_Sign then
  begin
    Result := True;
    Exit;
  end;

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

function GetStateReceipt : boolean;
begin
  Result := False;

  if not Assigned(HelsiApi) or (HelsiApi.FRequest_number = '') then
  begin
    ShowMessage('Ошибка не получена информация о рецепте с сайта Хелси...');
    Exit;
  end;

  Result := HelsiApi.GetStateReceipt;

  if HelsiApi.FShow_eHealth then
  begin
    ShellExecute(Screen.ActiveForm.Handle, 'open', PChar(HelsiApi.FShow_Location), nil, nil, SW_SHOWNORMAL);
    HelsiApi.FShow_eHealth := False;
    HelsiApi.FShow_Location := '';
    Exit;
  end;
end;

function GetKey_expireDate(var AUserId : integer; var AKey_expireDate : TDateTime) : boolean;
begin
  Result := False;
  if not Assigned(HelsiApi) then Exit;

  if HelsiApi.FUserId = 0 then Exit;

  AUserId := HelsiApi.FUserId;
  AKey_expireDate := HelsiApi.FKey_expireDate;
  Result := True;
end;

function GetKey_User_expireDate(ABase64Key, AKeyPassword : String; var AKey_expireDate : TDateTime) : boolean;
begin
  Result := False;

  if not Assigned(HelsiApi) then
  begin
    ShowMessage('Не активирован модуль работы с Хелси...');
    raise Exception.Create('Не активирован модуль работы с Хелси');
  end;

  Result := HelsiApi.IntegrationClientGetKeyInfo(ABase64Key, AKeyPassword, AKey_expireDate);
end;


function IsActiveHelsiApi : boolean;
begin
  Result := Assigned(HelsiApi);
end;

initialization
  HelsiApi := Nil;

finalization
  if Assigned(HelsiApi) then FreeAndNil(HelsiApi);

end.
