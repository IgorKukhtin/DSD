unit LikiDniproeHealth;

interface

uses
  Windows, System.SysUtils, System.Variants, System.Classes, System.JSON,
  Vcl.Dialogs, REST.Types, REST.Client, REST.Response.Adapter, Data.DB,
  Vcl.Forms, ShellApi, IdHTTP, IdSSLOpenSSL, Datasnap.DBClient;

type

  TLikiDniproeHealthApi = class(TObject)
  private
    FRESTResponse: TRESTResponse;
    FRESTRequest: TRESTRequest;
    FRESTClient: TRESTClient;

    // Данные текущего пользователя
    FUserEmail : String;
    FPassword : String;
    FBase64Key : String;
    FKeyPassword : String;

    // Адреса сайтоа
    FLikiDnepr : String;

    // Токены доступа
    FAccess_Token : String;

    // Рецепт
    FNumber : String;

    // ID погашения рецепта
    FDispense_ID : string;

    // Данные из рецепта
    FMedication_ID : string;            // dosage_id что выписано
    FMedication_ID_List : String;       // ID что выписано
    FMedication_Name : string;          // Название
    FMedication_Qty : currency;         // Количество выписано

    FMedication_request_id : String;    // ID рецепта
    FMedical_program_id : String;       // ID соц. программы программы

    FRequest_number : String;           // Номер рецепта из чека
    FStatus : string;                   // Статус чека
    FCreated_at : TDateTime;            // Дата создания
    FDispense_valid_from : TDateTime;   // Действителен с
    FDispense_valid_to : TDateTime;     // по

    FSell_Medication_ID : string;
    FProgram_Medication_Id : string;
    FSell_qty : Currency;
    FSell_price : Currency;
    FSell_amount : Currency;
    FDiscount_amount : Currency;
    FDispensed_Code : string;

    // Необходимо лргироваться
    FShow_eHealth : Boolean;
    FShow_Location : String;
  protected
    function GetReceiptId : boolean;
    function GetDrugList : boolean;
    function dispenseRecipe : boolean;
    function signRecipe : boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function ShowError(AText : string = 'Ошибка получение информации о рецепте') : string;

  end;

function CheckLikiDniproeHealth_Number(ANumber : string) : boolean;

function GetLikiDniproeHealthReceipt(const AReceipt : String; var AID, AIDList, AName : string;
  var AQty : currency; var ADate : TDateTime) : boolean;

function CreateLikiDniproeHealthNewDispense(AIDSP, AProgramIdSP : string; AQty, APrice, ASell_amount, ADiscount_amount : currency;
  ACode : string) : boolean;

var LikiDniproeHealthApi : TLikiDniproeHealthApi;

implementation

uses RegularExpressions, System.Generics.Collections, Soap.EncdDecd , MainCash2,
     LocalWorkUnit, ChoiceHelsiUserName, CommonData;

function DelDoubleQuote(AStr : string) : string;
begin
  Result := StringReplace(AStr, '"', '', [rfReplaceAll]);
end;

function DelDoubleQuoteVar(AStr : string) : string;
begin
  Result := StringReplace(AStr, '"', '', [rfReplaceAll]);
  if Result = 'null' then Result := '';
end;

function CheckLikiDniproeHealth_Number(ANumber : string) : boolean;
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

  { TLikiDniproeHealthApi }
constructor TLikiDniproeHealthApi.Create;
begin
  FRESTClient := TRESTClient.Create('');
  FRESTResponse := TRESTResponse.Create(Nil);
  FRESTRequest := TRESTRequest.Create(Nil);
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;

  FLikiDnepr := '';
  FAccess_Token := '';
  FUserEmail := '';
  FShow_eHealth := False;
  FShow_Location := '';

end;

destructor TLikiDniproeHealthApi.Destroy;
begin
  FRESTResponse.Free;
  FRESTRequest.Free;
  FRESTClient.Free;
end;

function TLikiDniproeHealthApi.ShowError(AText : string = 'Ошибка получение информации о рецепте') : string;
var
  jValue : TJSONValue;
  JSONA: TJSONArray;
  cError : string;
begin
  cError := '';
  jValue := FRESTResponse.JSONValue ;
  if jValue.FindValue('message') <> Nil then
  begin
    cError := DelDoubleQuote(jValue.FindValue('message').ToString);
  end else if jValue.FindValue('error') <> Nil then
  begin
    jValue := jValue.FindValue('error') ;

    if jValue.FindValue('invalid') <> Nil then
    begin
      JSONA := jValue.GetValue<TJSONArray>('invalid');
      JSONA := JSONA.Items[0].GetValue<TJSONArray>('rules');
      if JSONA.Items[0].FindValue('description') <> Nil then
      begin
        cError := DelDoubleQuote(JSONA.Items[0].FindValue('description').ToString);
      end;
    end;
  end;

  if cError = '' then cError := IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText;

  ShowMessage(AText + ':'#13#10 + cError);
end;

function TLikiDniproeHealthApi.GetReceiptId : boolean;
var
  jValue, j : TJSONValue;
  JSONA, JSONAR: TJSONArray;
  I, L : integer;
begin
  Result := False;
  FRequest_number := '';
  FMedication_request_id := '';
  FMedication_ID_List := '';
  FDispense_ID := '';

  FRESTClient.BaseURL := FLikiDnepr;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';
//  FRESTClient.ContentType := 'application/json';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.Resource := 'medications/get-recipe/'+ FNumber;
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('Authorization', 'Bearer ' + FAccess_Token, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                        [TRESTRequestParameterOption.poDoNotEncode]);
  FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER);
  FRESTRequest.AddParameter('employee_email', FUserEmail, TRESTRequestParameterKind.pkGETorPOST);
  try
    FRESTRequest.Execute;
  except
  end;

  if (FRESTResponse.StatusCode = 200) and (FRESTResponse.ContentType = 'application/json') then
  begin
    Result := False;
    try
      jValue := FRESTResponse.JSONValue;
      if jValue.FindValue('medical_program') <> Nil then
      begin

        if jValue.FindValue('medical_program') <> Nil then
        begin
          j := jValue.FindValue('medical_program');
          FMedical_program_id := DelDoubleQuote(j.FindValue('id').ToString);
        end else FMedical_program_id := '';

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
      end else if (jValue.FindValue('error') <> Nil) and (DelDoubleQuote(jValue.FindValue('error').ToString) = 'auth') then
      begin
        FShow_eHealth := True;
      end else ShowError;
    except
    end
  end else ShowError;
end;

function TLikiDniproeHealthApi.GetDrugList : boolean;
var
  jValue, j : TJSONValue;
  JSONA, JSONAR: TJSONArray;
  I, L : integer;
begin
  Result := False;

  if (FMedication_request_id = '') or (FMedical_program_id = '') then Exit;

  FRESTClient.BaseURL := FLikiDnepr;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';
//  FRESTClient.ContentType := 'application/json';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.Resource := 'medications/get-drug-list/' + FMedication_request_id + '/' + FMedical_program_id + '/' + CurrToStr(FMedication_Qty);

  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('Authorization', 'Bearer ' + FAccess_Token, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                        [TRESTRequestParameterOption.poDoNotEncode]);
  FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER);
  FRESTRequest.AddParameter('employee_email', FUserEmail, TRESTRequestParameterKind.pkGETorPOST);
  try
    FRESTRequest.Execute;
  except
  end;

  if (FRESTResponse.StatusCode = 200) and (FRESTResponse.ContentType = 'application/json') then
  begin
    Result := False;
    try
      JSONA := FRESTResponse.JSONValue.GetValue<TJSONArray>;

        for I := 0 to JSONA.Count - 1 do if JSONA.Items[I].FindValue('medication_id') <> Nil then
        begin
          if FMedication_ID_List = '' then FMedication_ID_List := DelDoubleQuote(JSONA.Items[I].FindValue('medication_id').ToString)
          else FMedication_ID_List := FMedication_ID_List + ',' + DelDoubleQuote(JSONA.Items[I].FindValue('medication_id').ToString);
        end;

      Result := True;
    except
    end
  end else ShowError;
end;

function TLikiDniproeHealthApi.dispenseRecipe : boolean;
var
  jValue, j : TJSONValue;
  JSONA, JSONAR: TJSONArray;
  jsonBody: TJSONObject;
  jsonTemp: TJSONObject;
  I, L : integer;
begin
  Result := False;

  if (FMedication_request_id = '') or (FMedical_program_id = '') then Exit;

  FRESTClient.BaseURL := FLikiDnepr;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';
//  FRESTClient.ContentType := 'application/json';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.Resource := 'medications/dispense-recipe/' + FDispensed_Code;

  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('Authorization', 'Bearer ' + FAccess_Token, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                        [TRESTRequestParameterOption.poDoNotEncode]);
  FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER);
  FRESTRequest.AddParameter('employee_email', FUserEmail, TRESTRequestParameterKind.pkGETorPOST);

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
    jsonTemp.AddPair('medical_program_id', FMedical_program_id);
    jsonTemp.AddPair('dispense_details', JSONA);

    jsonBody.AddPair('medication_dispense', jsonTemp);

    FRESTRequest.AddParameter('data', jsonBody.ToString, TRESTRequestParameterKind.pkGETorPOST);
  //  FRESTRequest.Body.Add(jsonBody.ToString, TRESTContentType.ctAPPLICATION_JSON);
  finally
    jsonBody.Destroy;
  end;

  try
    FRESTRequest.Execute;
  except
  end;

  if (FRESTResponse.StatusCode = 200) and (FRESTResponse.ContentType = 'application/json') then
  begin
    Result := False;
    try
      jValue := FRESTResponse.JSONValue;
      if jValue.FindValue('id') <> Nil then
      begin
        FDispense_ID := DelDoubleQuote(jValue.FindValue('id').ToString);
        Result := True;
      end;
    except
    end
  end else ShowError;
end;

function TLikiDniproeHealthApi.signRecipe : boolean;
var
  jValue, j : TJSONValue;
  JSONA, JSONAR: TJSONArray;
  jsonBody: TJSONObject;
  jsonTemp: TJSONObject;
  I, L : integer;
begin
  Result := False;

  if (FMedication_request_id = '') or (FMedical_program_id = '') then Exit;

  FRESTClient.BaseURL := FLikiDnepr;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';
//  FRESTClient.ContentType := 'application/json';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.Resource := 'medications/dispense-recipe/' + FDispensed_Code;

  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('employee_email', FDispense_ID, TRESTRequestParameterKind.pkGETorPOST);


  try
    FRESTRequest.Execute;
  except
  end;

  if (FRESTResponse.StatusCode = 200) and (FRESTResponse.ContentType = 'application/json') then
  begin
    Result := False;
    try
      jValue := FRESTResponse.JSONValue;
      if jValue.FindValue('medical_program') <> Nil then
      begin
        if jValue.FindValue('id') <> Nil then
        begin
          FDispense_ID := DelDoubleQuote(jValue.FindValue('id').ToString);
          Result := True;
        end;
      end;

    except
    end
  end else ShowError;
end;

function InitLikiDniproeHealthApi : boolean;
  var I : integer;
      ds : TClientDataSet;
      S : string;
begin

  Result := False;

  if (MainCashForm.UnitConfigCDS.FieldByName('LikiDneproURL').AsString = '') or
     (MainCashForm.UnitConfigCDS.FieldByName('LikiDneproToken').AsString = '')  then
  begin
    ShowMessage('Ошибка не установлены параметры для подключения к серверу LikiDnepro.');
    Exit;
  end;


  if not Assigned(LikiDniproeHealthApi) then
  begin
    LikiDniproeHealthApi := TLikiDniproeHealthApi.Create;
//    LikiDniproeHealthApi.FLikiDnepr := 'https://api.preprod.ciet-holding.com/api/v1/medications';
//    LikiDniproeHealthApi.FAccess_Token := '3bc48397885c039ee40586f4781d10006e3c01b0ba4776f4df5ec1f64af38f2a';
//    LikiDniproeHealthApi.FAccess_Token := '98bfd760a1b65cd45641ca2e1d59247d2f846f5a6e75a5d50dc44a213b7f8242';
//    LikiDniproeHealthApi.FEmployee_Email := 'provizor2@yopmail.com';
//    LikiDniproeHealthApi.FShow_Location := 'https://preprod.ciet-holding.com/login';


    LikiDniproeHealthApi.FLikiDnepr := MainCashForm.UnitConfigCDS.FieldByName('LikiDneproeHealthURL').AsString;
    LikiDniproeHealthApi.FAccess_Token := MainCashForm.UnitConfigCDS.FieldByName('LikiDneproeHealthToken').AsString;
   // LikiDniproeHealthApi.FPharmacy_Id := MainCashForm.UnitConfigCDS.FieldByName('LikiDneproId').AsInteger;

    try
      ds := TClientDataSet.Create(nil);
      try
        WaitForSingleObject(MutexUserLikiDnipro, INFINITE); // только для формы2;  защищаем так как есть в приложениее и сервисе
        try
          LoadLocalData(ds,UserLikiDnipro_lcl);
        finally
          ReleaseMutex(MutexUserLikiDnipro);
        end;

        if ds.RecordCount <= 0 then
        begin
          FreeAndNil(LikiDniproeHealthApi);
          ShowMessage('По подразделению нет сотрудников для закрытия рецептов...');
          Exit;
        end;

        if not ds.Locate('ID', gc_User.Session, []) then
        begin
          if not ChoiceHelsiUserNameExecute(ds) then
          begin
            FreeAndNil(LikiDniproeHealthApi);
            Exit;
          end;
        end;

        LikiDniproeHealthApi.FUserEmail := ds.FieldByName('UserEmail').AsString;
        LikiDniproeHealthApi.FPassword := DecodeString(ds.FieldByName('UserPassword').AsString);
        LikiDniproeHealthApi.FBase64Key := ds.FieldByName('Key').AsString;
        LikiDniproeHealthApi.FKeyPassword := DecodeString(ds.FieldByName('KeyPassword').AsString);

      finally
        ds.free;
      end;
    except
      on E: Exception do
      begin
        FreeAndNil(LikiDniproeHealthApi);
        ShowMessage('Ошибка получения учетных данных сотрудника: ' + E.Message);
        Exit;
      end;
    end;
  end;

  Result := True;
end;

function GetLikiDniproeHealthReceipt(const AReceipt : String; var AID, AIDList, AName : string;
  var AQty : currency; var ADate : TDateTime) : boolean;
begin
  Result := False;

  if not CheckLikiDniproeHealth_Number(AReceipt) then Exit;

  if not InitLikiDniproeHealthApi then Exit;

  LikiDniproeHealthApi.FNumber := AReceipt;

  Result := LikiDniproeHealthApi.GetReceiptId;

  if LikiDniproeHealthApi.FShow_eHealth then
  begin
    ShellExecute(Screen.ActiveForm.Handle, 'open', PChar(LikiDniproeHealthApi.FShow_Location), nil, nil, SW_SHOWNORMAL);
    LikiDniproeHealthApi.FShow_eHealth := False;
    Exit;
  end;

  if AReceipt <> LikiDniproeHealthApi.FRequest_number then
  begin
    ShowMessage('Ошибка получения информации о рецепте с сайта Хелси...'#13#10 +
      'Неправельный номер рецепта.');
    Exit;
  end;

//  if LikiDniproeHealthApi.FDispense_valid_to < Date then
//  begin
//    ShowMessage('Срок действия рецепта истек...');
//    Exit;
//  end;

  if LikiDniproeHealthApi.FStatus = 'ACTIVE' then
  begin

    if LikiDniproeHealthApi.FMedical_program_id = '' then
    begin
      ShowMessage('Нет в чеке информации о соц проекте...');
      Exit;
    end;

    if not LikiDniproeHealthApi.GetDrugList then Exit;

    AID := LikiDniproeHealthApi.FMedication_ID;
    AIDList := LikiDniproeHealthApi.FMedication_ID_List;
    AName := LikiDniproeHealthApi.FMedication_Name;
    AQty := LikiDniproeHealthApi.FMedication_Qty;
    ADate := LikiDniproeHealthApi.FCreated_at;
    Result := True;
  end else if LikiDniproeHealthApi.FStatus = 'EXPIRED' then
  begin
    LikiDniproeHealthApi.FRequest_number := '';
    ShowMessage('Ошибка чек пророчен.');
  end else if LikiDniproeHealthApi.FStatus = 'COMPLETED' then
  begin
    LikiDniproeHealthApi.FRequest_number := '';
    ShowMessage('Ошибка чек погашен.');
  end else
  begin
    LikiDniproeHealthApi.FRequest_number := '';
    ShowMessage('Ошибка неизвестный статус чека.');
  end;
end;

function CreateLikiDniproeHealthNewDispense(AIDSP, AProgramIdSP : string; AQty, APrice, ASell_amount, ADiscount_amount : currency;
  ACode : string) : boolean;
begin

  Result := False;

  if not Assigned(LikiDniproeHealthApi) or (LikiDniproeHealthApi.FRequest_number = '') then
  begin
    ShowMessage('Ошибка не получена информация о рецепте с сайта МИС "Каштан"...');
    Exit;
  end;

  LikiDniproeHealthApi.FSell_Medication_ID := AIDSP;
  LikiDniproeHealthApi.FProgram_Medication_Id := AProgramIdSP;
  LikiDniproeHealthApi.FSell_qty := AQty;
  LikiDniproeHealthApi.FSell_price := APrice;
  LikiDniproeHealthApi.FSell_amount := ASell_amount;
  LikiDniproeHealthApi.FDiscount_amount := ADiscount_amount;
  LikiDniproeHealthApi.FDispensed_Code := ACode;

  Result := LikiDniproeHealthApi.dispenseRecipe;

  Result := False;
end;


initialization
  LikiDniproeHealthApi := Nil;

finalization
  if Assigned(LikiDniproeHealthApi) then FreeAndNil(LikiDniproeHealthApi);
end.
