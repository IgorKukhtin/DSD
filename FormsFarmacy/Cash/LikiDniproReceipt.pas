unit LikiDniproReceipt;

interface

uses
  Windows, System.SysUtils, System.Variants, System.Classes, System.JSON,
  Vcl.Dialogs, REST.Types, REST.Client, REST.Response.Adapter, Data.DB,
  Vcl.Forms, ShellApi, IdHTTP, IdSSLOpenSSL, Datasnap.DBClient;

type

  TRecipe  = Record
    // Рецепт
    FRecipe_Number : String;
    FRecipe_Created : Variant;
    FRecipe_Valid_From : Variant;
    FRecipe_Valid_To : Variant;
    FRecipe_Type : Integer;

    FCategory_1303_Id : Integer;
    FCategory_1303_Name : String;
    FCategory_1303_Discount_Percent : Currency;

    // Пациент
    FPatient_Id : Integer;
    FPatient_Name : String;
    FPatient_Age : String;

    // Медецинское учереждение
    FInstitution_Id : Integer;
    FInstitution_Name : String;
    FInstitution_Edrpou : String;

    // Доктор
    FDoctor_Id : Integer;
    FDoctor_Name : String;
    FDoctor_INN : String;
    FDoctor_Speciality : String;
  end;

  TLikiDniproReceiptApi = class(TObject)
  private
    FRESTResponse: TRESTResponse;
    FRESTRequest: TRESTRequest;
    FRESTClient: TRESTClient;

    // Адреса сайтоа
    FLikiDnepr : String;

    // Токены доступа
    FAccess_Token : String;
    FPharmacy_Id : Integer;
    FPharmacy_Name : String;
    FPharmacist : String;
    FPharmacy_Order_Id : String;

    // Рецепт
    FNumber : String;

    // Информация по рецепту
    FRecipe : TRecipe;

    // Сопержимое рецепта
    FPositionCDS: TClientDataSet;
    // Данные для погашения
    FDrugsCDS: TClientDataSet;

  protected
    function GetReceiptId : boolean;
    function OrdersСreate : boolean;
    function InitCDS : boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function ShowError(AText : string = 'Ошибка получение информации о рецепте') : string;

    property Recipe : TRecipe read FRecipe ;
    property PositionCDS: TClientDataSet read FPositionCDS;
    property DrugsCDS: TClientDataSet read FDrugsCDS;
  end;

function GetReceipt1303(const AReceipt : String) : boolean;
function ClearReceipt1303 : boolean;
function OrdersСreate1303(const CheckNumber : String; const CheckCDS: TClientDataSet) : boolean;
function CheckLikiDniproReceipt_Number(ANumber : string) : boolean;

var LikiDniproReceiptApi : TLikiDniproReceiptApi;

implementation

uses RegularExpressions, System.Generics.Collections, Soap.EncdDecd, MainCash2,
     dsdDB, PUSHMessageCash, CommonData;

function DelDoubleQuote(AStr : string) : string;
begin
  Result := StringReplace(AStr, '"', '', [rfReplaceAll]);
end;

function DelDoubleQuoteVar(AStr : string) : string;
begin
  Result := StringReplace(AStr, '"', '', [rfReplaceAll]);
  if Result = 'null' then Result := '';
end;

function CheckLikiDniproReceipt_Number(ANumber : string) : boolean;
  var Res: TArray<string>; I, J : Integer;
begin
  Result := False;
  try
    if (Length(ANumber) < 17) or (Length(ANumber) > 19) then exit;

    Res := TRegEx.Split(ANumber, '-');

    if High(Res) <> 3 then exit;

    for I := 0 to High(Res) do
    begin
      if (I <= 1) and (Length(Res[I]) <> 4) then exit;
      if (I = 2) and (Length(Res[I]) <> 2) then exit;
      if (I = 3) and (Length(Res[I]) < 4) then exit;

      for J := 1 to Length(Res[I]) do if not CharInSet(Res[I][J], ['0'..'9','A'..'Z']) then exit;
    end;
    Result := True;
  finally
    if not Result then ShowMessage ('Ошибка.<Регистрационный номер рецепта>'#13#10#13#10 +
      'Номер должен содержать 19 символов в 4 блока первых два 4 символа, третий 2 символа и четвертый 4..6 символов разделенных символом "-"'#13#10 +
      'Cодержать только цыфры и буквы латинского алфовита'#13#10 +
      'В виде XXXX-XXXX-XX-XXXXXX ...');
  end;
end;

function StrToDateSite(ADateStr : string; var ADate : Variant) : Boolean;
  var Res: TArray<string>;
begin
  Result := False;
  try
    if DelDoubleQuote(ADateStr) = 'null' then
    begin
      ADate := Null;
      Result := True;
      Exit;
    end;

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


  { TLikiDniproReceiptApi }
constructor TLikiDniproReceiptApi.Create;
begin
  FRESTClient := TRESTClient.Create('');
  FRESTResponse := TRESTResponse.Create(Nil);
  FRESTRequest := TRESTRequest.Create(Nil);
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;

  FPositionCDS := TClientDataSet.Create(Nil);
  FDrugsCDS := TClientDataSet.Create(Nil);

  FLikiDnepr := '';
  FAccess_Token := '';
  FPharmacy_Id := 0;
end;

destructor TLikiDniproReceiptApi.Destroy;
begin
  FDrugsCDS.Free;
  FPositionCDS.Free;
  FRESTResponse.Free;
  FRESTRequest.Free;
  FRESTClient.Free;
end;

function TLikiDniproReceiptApi.InitCDS : boolean;
begin
  try
    FPositionCDS.Close;
    FPositionCDS.FieldDefs.Clear;
    FPositionCDS.FieldDefs.Add('position_id', TFieldType.ftInteger);
    FPositionCDS.FieldDefs.Add('position', TFieldType.ftString, 250);
    FPositionCDS.FieldDefs.Add('name_inn_ua', TFieldType.ftString, 250);
    FPositionCDS.FieldDefs.Add('name_inn_lat', TFieldType.ftString, 250);
    FPositionCDS.FieldDefs.Add('name_reg_ua', TFieldType.ftString, 250);
    FPositionCDS.FieldDefs.Add('comment', TFieldType.ftString, 250);
    FPositionCDS.FieldDefs.Add('is_drug', TFieldType.ftString, 250);
    FPositionCDS.FieldDefs.Add('drugs_need_bought', TFieldType.ftString, 100);
    FPositionCDS.FieldDefs.Add('drugs_need_bought_int', TFieldType.ftInteger);
    FPositionCDS.FieldDefs.Add('doctor_recommended_manufacturer', TFieldType.ftString, 100);
    FPositionCDS.FieldDefs.Add('inn_name_lat', TFieldType.ftString, 100);
    FPositionCDS.FieldDefs.Add('id_morion', TFieldType.ftString, 100);
    FPositionCDS.FieldDefs.Add('qpack_int', TFieldType.ftString, 100);

    FPositionCDS.CreateDataSet;

    if not FPositionCDS.Active then FPositionCDS.Open;

  except
  end;
  Result := FPositionCDS.Active;
end;

function TLikiDniproReceiptApi.ShowError(AText : string = 'Ошибка получение информации о рецепте') : string;
var
  jValue : TJSONValue;
  cError : string;
begin
  cError := '';
  jValue := FRESTResponse.JSONValue ;
  if jValue.FindValue('errors') <> Nil then
  begin
    cError := DelDoubleQuote(jValue.FindValue('errors').ToString);
  end else if jValue.FindValue('message') <> Nil then
  begin
    cError := DelDoubleQuote(jValue.FindValue('message').ToString);
  end;

  if cError = '' then cError := IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText;

  ShowMessage(AText + ':'#13#10 + cError);
end;

function TLikiDniproReceiptApi.GetReceiptId : boolean;
var
  jValue, j : TJSONValue;
  JSONA, JSONAR: TJSONArray;
  I, L, drugs_need_bought_Int : integer;
begin
  Result := False;
  FRecipe.FRecipe_Number := '';

  FRESTClient.BaseURL := FLikiDnepr;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Resource := 'get-recipes';
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('Authorization', 'Bearer ' + FAccess_Token, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                        [TRESTRequestParameterOption.poDoNotEncode]);
  FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER);
  FRESTRequest.AddParameter('pharmacy_id', IntToStr(FPharmacy_Id), TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('recipe_number', FNumber, TRESTRequestParameterKind.pkGETorPOST);
  try
    FRESTRequest.Execute;
  except
  end;

  if (FRESTResponse.StatusCode = 200) and (FRESTResponse.ContentType = 'application/json') then
  begin
    Result := False;
    try
      jValue := FRESTResponse.JSONValue;
      if (jValue.FindValue('status') = Nil) or (DelDoubleQuote(jValue.FindValue('status').ToString) <> 'success') then
      begin
        ShowError;
        Exit;
      end;

      if jValue.FindValue('message') <> Nil then
      begin
        ShowError;
        Exit;
      end else if jValue.FindValue('data') <> Nil then
      begin

        InitCDS;
        JSONA := jValue.GetValue<TJSONArray>('data');
        for I := 0 to JSONA.Count - 1 do
        begin
          j :=  JSONA.Items[I];

          if DelDoubleQuote(j.FindValue('recipe_number').ToString) <> FNumber then Continue;

          if FRecipe.FRecipe_Number = '' then
          begin
            // Рецепт
            FRecipe.FRecipe_Number := DelDoubleQuote(j.FindValue('recipe_number').ToString);
            if not StrToDateSite(j.FindValue('recipe_created').ToString, FRecipe.FRecipe_Created) then Exit;
            if not StrToDateSite(j.FindValue('recipe_valid_from').ToString, FRecipe.FRecipe_Valid_From) then Exit;
            if not StrToDateSite(j.FindValue('recipe_valid_to').ToString, FRecipe.FRecipe_Valid_To) then Exit;
            FRecipe.FRecipe_Type := j.GetValue<TJSONNumber>('recipe_type').AsInt;

            if DelDoubleQuote(j.FindValue('category_1303_id').ToString) = 'null' then FRecipe.FCategory_1303_Id := 0
            else FRecipe.FCategory_1303_Id := j.GetValue<TJSONNumber>('category_1303_id').AsInt;
            if DelDoubleQuote(j.FindValue('category_1303_name').ToString) = 'null' then FRecipe.FCategory_1303_Name := ''
            else FRecipe.FCategory_1303_Name := DelDoubleQuote(j.FindValue('category_1303_name').ToString);
            if DelDoubleQuote(j.FindValue('category_1303_discount_percent').ToString) = 'null' then FRecipe.FCategory_1303_Discount_Percent := 0
            else FRecipe.FCategory_1303_Discount_Percent := j.GetValue<TJSONNumber>('category_1303_discount_percent').AsDouble;

            // Пациент
            FRecipe.FPatient_Id := j.GetValue<TJSONNumber>('patient_id').AsInt;
            FRecipe.FPatient_Name := DelDoubleQuote(j.FindValue('patient_name').ToString);
            FRecipe.FPatient_Age := DelDoubleQuote(j.FindValue('patient_age').ToString);

            // Медецинское учереждение
            FRecipe.FInstitution_Id := j.GetValue<TJSONNumber>('institution_id').AsInt;
            FRecipe.FInstitution_Name := DelDoubleQuote(j.FindValue('institution_name').ToString);
            FRecipe.FInstitution_Edrpou := DelDoubleQuote(j.FindValue('institution_edrpou').ToString);

            // Доктор
            FRecipe.FDoctor_Id := j.GetValue<TJSONNumber>('doctor_id').AsInt;
            FRecipe.FDoctor_Name := DelDoubleQuote(j.FindValue('doctor_name').ToString);
            FRecipe.FDoctor_INN := DelDoubleQuote(j.FindValue('doctor_inn').ToString);
            FRecipe.FDoctor_Speciality := DelDoubleQuote(j.FindValue('doctor_speciality').ToString);
          end;

          // Медикамент
          FPositionCDS.Last;
          FPositionCDS.Append;
          FPositionCDS.FieldByName('position_id').AsInteger := j.GetValue<TJSONNumber>('position_id').AsInt;
          FPositionCDS.FieldByName('position').AsString := DelDoubleQuoteVar(j.FindValue('position').ToString);
          FPositionCDS.FieldByName('name_inn_ua').AsString := DelDoubleQuoteVar(j.FindValue('name_inn_ua').ToString);
          FPositionCDS.FieldByName('name_inn_lat').AsString := DelDoubleQuoteVar(j.FindValue('name_inn_lat').ToString);
          FPositionCDS.FieldByName('name_reg_ua').AsString := DelDoubleQuoteVar(j.FindValue('name_reg_ua').ToString);
          FPositionCDS.FieldByName('comment').AsString := DelDoubleQuoteVar(j.FindValue('comment').ToString);
          FPositionCDS.FieldByName('is_drug').AsString := DelDoubleQuoteVar(j.FindValue('is_drug').ToString);
          FPositionCDS.FieldByName('drugs_need_bought').AsString := DelDoubleQuoteVar(j.FindValue('drugs_need_bought').ToString);
          if not TryStrToInt(FPositionCDS.FieldByName('drugs_need_bought').AsString, drugs_need_bought_Int) then drugs_need_bought_Int := 1;
          FPositionCDS.FieldByName('drugs_need_bought_Int').AsInteger := drugs_need_bought_Int;
          FPositionCDS.FieldByName('doctor_recommended_manufacturer').AsString := DelDoubleQuoteVar(j.FindValue('doctor_recommended_manufacturer').ToString);
          FPositionCDS.FieldByName('inn_name_lat').AsString := '';
          FPositionCDS.FieldByName('id_morion').AsString := '';

          JSONAR := j.GetValue<TJSONArray>('reimbursement');
          for L := 0 to JSONAR.Count - 1 do
          begin
            if (JSONAR.Items[L].FindValue('inn_name_lat') <> Nil) and (DelDoubleQuoteVar(JSONAR.Items[L].FindValue('inn_name_lat').ToString) <> '') then
            begin
              if FPositionCDS.FieldByName('inn_name_lat').AsString <> '' then FPositionCDS.FieldByName('inn_name_lat').AsString := FPositionCDS.FieldByName('inn_name_lat').AsString + ',';
              FPositionCDS.FieldByName('inn_name_lat').AsString := FPositionCDS.FieldByName('inn_name_lat').AsString + DelDoubleQuoteVar(JSONAR.Items[L].FindValue('inn_name_lat').ToString);
            end;
            if (JSONAR.Items[L].FindValue('id_morion') <> Nil) and (DelDoubleQuoteVar(JSONAR.Items[L].FindValue('id_morion').ToString) <> '') then
            begin
              if FPositionCDS.FieldByName('id_morion').AsString <> '' then FPositionCDS.FieldByName('id_morion').AsString := FPositionCDS.FieldByName('id_morion').AsString + ',';
              FPositionCDS.FieldByName('id_morion').AsString  := FPositionCDS.FieldByName('id_morion').AsString + DelDoubleQuoteVar(JSONAR.Items[L].FindValue('id_morion').ToString);
              if FPositionCDS.FieldByName('qpack_int').AsString <> '' then FPositionCDS.FieldByName('qpack_int').AsString := FPositionCDS.FieldByName('qpack_int').AsString + ',';
              if (JSONAR.Items[L].FindValue('qpack_int') <> Nil) and (DelDoubleQuoteVar(JSONAR.Items[L].FindValue('qpack_int').ToString) <> '') then
              begin
                FPositionCDS.FieldByName('qpack_int').AsString  := FPositionCDS.FieldByName('qpack_int').AsString + DelDoubleQuoteVar(JSONAR.Items[L].FindValue('qpack_int').ToString);
              end else FPositionCDS.FieldByName('qpack_int').AsString  := FPositionCDS.FieldByName('qpack_int').AsString + '1';
            end;
          end;
          FPositionCDS.Post
        end;
        if FPositionCDS.IsEmpty then
        begin
          if FRecipe.FRecipe_Number = '' then ShowMessage('Ошибка рецепт не найден.')
          else ShowMessage('Ошибка в рецепте не описаны медикаменты.');
        end else Result := True;
      end else ShowError;
    except
    end
  end else ShowError;
end;

function TLikiDniproReceiptApi.OrdersСreate : boolean;
var
  jValue, j : TJSONValue;
  JSONA, JSONAR, jsonBody: TJSONArray;
  jsonTemp: TJSONObject;
  I, L : integer;
begin
  Result := False;
  FDrugsCDS.FindFirst;

  FRESTClient.BaseURL := FLikiDnepr;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.Resource := 'orders-create';
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('Authorization', 'Bearer ' + FAccess_Token, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                        [TRESTRequestParameterOption.poDoNotEncode]);
  FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER);

  FRESTRequest.AddParameter('position_id', FPositionCDS.FieldByName('position_id').AsString, TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('morion_id', FDrugsCDS.FieldByName('MorionCode').AsString, TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('tradename', FPositionCDS.FieldByName('name_inn_ua').AsString, TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('release_form', '', TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('dosage', '', TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('unit', '', TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('pharmacy_order_id', FPharmacy_Order_Id, TRESTRequestParameterKind.pkGETorPOST);

  FRESTRequest.AddParameter('pharmacy_id', IntToStr(FPharmacy_Id), TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('pharmacy_name', FPharmacy_Name, TRESTRequestParameterKind.pkGETorPOST);

  FRESTRequest.AddParameter('pharmacist_id', '', TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('pharmacist', FPharmacist, TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('code_eds', '', TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('order_date', FormatDateTime('YYYY-MM-DD HH:NN:SS', Now), TRESTRequestParameterKind.pkGETorPOST);

  jsonBody := TJSONArray.Create;
  try
    while not FDrugsCDS.Eof do
    begin
      jsonTemp := TJSONObject.Create;
      jsonTemp.AddPair('count', FDrugsCDS.FieldByName('count').AsString);
      jsonTemp.AddPair('retail_price_without_vat', StringReplace(FDrugsCDS.FieldByName('retail_price_without_vat').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll]));
      jsonTemp.AddPair('retail_price_with_vat', StringReplace(FDrugsCDS.FieldByName('retail_price_with_vat').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll]));
      jsonTemp.AddPair('price_without_vat', StringReplace(FDrugsCDS.FieldByName('price_without_vat').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll]));
      jsonTemp.AddPair('price_with_vat', StringReplace(FDrugsCDS.FieldByName('price_with_vat').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll]));
      jsonTemp.AddPair('amount_without_vat', StringReplace(FDrugsCDS.FieldByName('amount_without_vat').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll]));
      jsonTemp.AddPair('amount_with_vat', StringReplace(FDrugsCDS.FieldByName('amount_with_vat').AsString, FormatSettings.DecimalSeparator, '.', [rfReplaceAll]));
      jsonTemp.AddPair('drug_series', FDrugsCDS.FieldByName('drug_series').AsString);
      jsonTemp.AddPair('series_expiration_date',  FormatDateTime('DD.MM.YYYY', FDrugsCDS.FieldByName('series_expiration_date').AsDateTime));

      jsonBody.AddElement(jsonTemp);

      FDrugsCDS.Next;
    end;

    FRESTRequest.AddParameter('drugs', jsonBody.ToString, TRESTRequestParameterKind.pkGETorPOST);
    // FRESTRequest.Body.Add(jsonBody.ToString, TRESTContentType.ctAPPLICATION_JSON);
  finally
    jsonBody.Destroy;
  end;

  try
    FRESTRequest.Execute;
  except
  end;

  if (FRESTResponse.StatusCode = 200) and (FRESTResponse.ContentType = 'application/json') then
  begin
    try
      jValue := FRESTResponse.JSONValue;
      if (jValue.FindValue('status') = Nil) or (DelDoubleQuote(jValue.FindValue('status').ToString) <> 'success') then
      begin
        ShowError('Ошибка погашения рецепта');
      end else Result := True;

    except
      ShowError('Ошибка погашения рецепта');
    end
  end else ShowError('Ошибка погашения рецепта');

end;

function InitLikiDniproReceiptApi : boolean;
  var I : integer;
      ds : TClientDataSet;
      S : string;
begin

  Result := False;

  if (MainCashForm.UnitConfigCDS.FieldByName('LikiDneproId').AsInteger = 0) or
     (MainCashForm.UnitConfigCDS.FieldByName('LikiDneproURL').AsString = '') or
     (MainCashForm.UnitConfigCDS.FieldByName('LikiDneproToken').AsString = '')  then
  begin
    ShowMessage('Ошибка не установлены параметры для подключения к серверу LikiDnepro.');
    Exit;
  end;


  if not Assigned(LikiDniproReceiptApi) then
  begin
    LikiDniproReceiptApi := TLikiDniproReceiptApi.Create;
    LikiDniproReceiptApi.FLikiDnepr := MainCashForm.UnitConfigCDS.FieldByName('LikiDneproURL').AsString;
    LikiDniproReceiptApi.FAccess_Token := MainCashForm.UnitConfigCDS.FieldByName('LikiDneproToken').AsString;
    LikiDniproReceiptApi.FPharmacy_Id := MainCashForm.UnitConfigCDS.FieldByName('LikiDneproId').AsInteger;
    LikiDniproReceiptApi.FPharmacy_Name := MainCashForm.UnitConfigCDS.FieldByName('Name').AsString;
    LikiDniproReceiptApi.FPharmacist := gc_User.Login;
  end;

  Result := True;
end;

function GetReceipt1303(const AReceipt : String) : boolean;
   var cResult : String;
begin
  Result := False;

  if not CheckLikiDniproReceipt_Number(AReceipt) then Exit;

  if not InitLikiDniproReceiptApi then Exit;

  LikiDniproReceiptApi.FNumber := AReceipt;

  Result := LikiDniproReceiptApi.GetReceiptId;

  if Result and (LikiDniproReceiptApi.Recipe.FRecipe_Type = 2) then
  begin
    if (LikiDniproReceiptApi.PositionCDS.RecordCount <> 1) then
    begin
      ShowMessage('Ошибка в рецепте по постановлению 1303 должен быть один товар.');
      ClearReceipt1303;
      Result := False;
      Exit;
    end;

    if LikiDniproReceiptApi.FPositionCDS.FieldByName('id_morion').AsString = '' then
    begin
      ShowPUSHMessageCash('Рецепт не может быть отпущен! Обратитесь к Ирине Колеуш для внесения недостающих данных..'#13#13 +
        'Чеке номер: ' + LikiDniproReceiptApi.Recipe.FRecipe_Number + #13 +
        'В чеке товар: ' + LikiDniproReceiptApi.PositionCDS.FieldByName('position').AsString, cResult);
      ClearReceipt1303;
      Result := False;
      Exit;
    end;

  end;
end;

function ClearReceipt1303 : boolean;
begin
  Result := True;

  if not Assigned(LikiDniproReceiptApi) then Exit;

  LikiDniproReceiptApi.FRecipe.FRecipe_Type := 0;
  LikiDniproReceiptApi.FRecipe.FRecipe_Number := '';
  LikiDniproReceiptApi.FRecipe.FRecipe_Created := Null;
  LikiDniproReceiptApi.FRecipe.FRecipe_Valid_From := Null;
  LikiDniproReceiptApi.FRecipe.FRecipe_Valid_To := Null;
  LikiDniproReceiptApi.FRecipe.FRecipe_Type := 0;

end;

function OrdersСreate1303(const CheckNumber : String; const CheckCDS: TClientDataSet) : boolean;
  var sp : TdsdStoredProc; cResult: String;
begin
  Result := True;

  if not Assigned(LikiDniproReceiptApi) then Exit;
  if LikiDniproReceiptApi.Recipe.FRecipe_Type <> 2 then Exit;

  Result := False;
  LikiDniproReceiptApi.FPharmacy_Order_Id := CheckNumber;

  if (CheckCDS.RecordCount <> 1) then
  begin
    ShowMessage('Ошибка в рецепте по постановлению 1303 товар должен отпускаться одной строкой.');
    ClearReceipt1303;
    Exit;
  end;

  if not ShowPUSHMessageCash('Провести продажу по соц. проекту 1303 на сумму ' + CheckCDS.FieldByName('Summ').AsString + ' грн.?', cResult) then Exit;

  // Получаес датасет с партиями

  sp := TdsdStoredProc.Create(nil);
  try
    sp.OutputType := otDataSet;
    sp.DataSet := LikiDniproReceiptApi.FDrugsCDS;

    sp.StoredProcName := 'gpSelect_Goods_LikiDnipro1303';
    sp.Params.Clear;
    sp.Params.AddParam('inGoodsId', ftInteger, ptInput, CheckCDS.FieldByName('GoodsId').AsInteger);
    sp.Params.AddParam('inAmount', ftFloat, ptInput, CheckCDS.FieldByName('Amount').AsCurrency);
    sp.Params.AddParam('inPrice', ftFloat, ptInput, CheckCDS.FieldByName('Price').AsCurrency);
    sp.Params.AddParam('inPriceSale', ftFloat, ptInput, CheckCDS.FieldByName('PriceSale').AsCurrency);
    sp.Params.AddParam('inSumm', ftFloat, ptInput, CheckCDS.FieldByName('Summ').AsCurrency);
    sp.Params.AddParam('inBught_Int', ftInteger, ptInput, LikiDniproReceiptApi.FPositionCDS.FieldByName('drugs_need_bought_Int').AsInteger);
    sp.Params.AddParam('inMorion', ftString, ptInput, LikiDniproReceiptApi.FPositionCDS.FieldByName('id_morion').AsString);
    sp.Params.AddParam('inqpack_int', ftString, ptInput, LikiDniproReceiptApi.FPositionCDS.FieldByName('qpack_int').AsString);
    sp.Execute;

  finally
    freeAndNil(sp);
  end;

  if (LikiDniproReceiptApi.FDrugsCDS.RecordCount < 1) then
  begin
    ShowMessage('Ошибка получения партий товара для погашения рецепта.');
    ClearReceipt1303;
    Exit;
  end;

  Result := LikiDniproReceiptApi.OrdersСreate;

end;

initialization
  LikiDniproReceiptApi := Nil;

finalization
  if Assigned(LikiDniproReceiptApi) then FreeAndNil(LikiDniproReceiptApi);
end.
