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

    // Рецепт
    FNumber : String;

    // Информация по рецепту
    FRecipe : TRecipe;

    // Сопержимое рецепта
    FPositionCDS: TClientDataSet;

  protected
    function GetReceiptId : boolean;
    function InitCDS : boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function ShowError(AText : string = 'Ошибка получение информации о рецепте') : string;

    property Recipe : TRecipe read FRecipe;
    property PositionCDS: TClientDataSet read FPositionCDS;
  end;

function GetReceipt1303(const AReceipt : String) : boolean;
function CheckLikiDniproReceipt_Number(ANumber : string) : boolean;

var LikiDniproReceiptApi : TLikiDniproReceiptApi;

implementation

uses RegularExpressions, System.Generics.Collections, Soap.EncdDecd;

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

  FLikiDnepr := 'https://liki-dnepr.nzt.su/api';

  FAccess_Token := '3bc48397885c039ee40586f4781d10006e3c01b0ba4776f4df5ec1f64af38f2a';

end;

destructor TLikiDniproReceiptApi.Destroy;
begin
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
    FPositionCDS.FieldDefs.Add('doctor_recommended_manufacturer', TFieldType.ftString, 100);
    FPositionCDS.FieldDefs.Add('inn_name_lat', TFieldType.ftString, 100);
    FPositionCDS.FieldDefs.Add('id_morion', TFieldType.ftString, 100);

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
  if jValue.FindValue('message') <> Nil then
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
  I, L : integer;
begin
  Result := False;

  FRESTClient.BaseURL := FLikiDnepr + '/get-recipes';
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Resource := '';
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('Authorization', 'Bearer ' + FAccess_Token, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                        [TRESTRequestParameterOption.poDoNotEncode]);
  FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER);
  FRESTRequest.AddParameter('pharmacy_id', '13', TRESTRequestParameterKind.pkGETorPOST);
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
      if (jValue.FindValue('status') = Nil) and (jValue.FindValue('status').ToString <> 'success') then
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
          FPositionCDS.FieldByName('doctor_recommended_manufacturer').AsString := DelDoubleQuoteVar(j.FindValue('doctor_recommended_manufacturer').ToString);
          FPositionCDS.FieldByName('inn_name_lat').AsString := '';
          FPositionCDS.FieldByName('id_morion').AsString := '';

          JSONAR := j.GetValue<TJSONArray>('reimbursement');
          for L := 0 to JSONAR.Count - 1 do
          begin
            if DelDoubleQuoteVar(JSONAR.Items[L].FindValue('inn_name_lat').ToString) <> '' then
            begin
              if FPositionCDS.FieldByName('inn_name_lat').AsString <> '' then FPositionCDS.FieldByName('inn_name_lat').AsString := FPositionCDS.FieldByName('inn_name_lat').AsString + ',';
              FPositionCDS.FieldByName('inn_name_lat').AsString := FPositionCDS.FieldByName('inn_name_lat').AsString + DelDoubleQuoteVar(JSONAR.Items[L].FindValue('inn_name_lat').ToString);
            end;
            if DelDoubleQuoteVar(JSONAR.Items[L].FindValue('id_morion').ToString) <> '' then
            begin
              if FPositionCDS.FieldByName('id_morion').AsString <> '' then FPositionCDS.FieldByName('id_morion').AsString := FPositionCDS.FieldByName('id_morion').AsString + ',';
              FPositionCDS.FieldByName('id_morion').AsString  := FPositionCDS.FieldByName('id_morion').AsString + DelDoubleQuoteVar(JSONAR.Items[L].FindValue('id_morion').ToString);
            end;
          end;
          FPositionCDS.Post
        end;
        if FPositionCDS.IsEmpty then
          ShowMessage('Ошибка не найдены медикаменты в рецепте.')
        else Result := True;
      end else ShowError;
    except
    end
  end else ShowError;
end;



function InitLikiDniproReceiptApi : boolean;
  var I : integer;
      ds : TClientDataSet;
      S : string;
begin

  Result := False;

  if not Assigned(LikiDniproReceiptApi) then
  begin
    LikiDniproReceiptApi := TLikiDniproReceiptApi.Create;
  end;

  Result := True;
end;

function GetReceipt1303(const AReceipt : String) : boolean;
begin
  Result := False;

//  if not CheckRequest_Number(AReceipt) then Exit;

  if not InitLikiDniproReceiptApi then Exit;

  LikiDniproReceiptApi.FNumber := AReceipt;

  Result := LikiDniproReceiptApi.GetReceiptId;

end;

initialization
  LikiDniproReceiptApi := Nil;

finalization
  if Assigned(LikiDniproReceiptApi) then FreeAndNil(LikiDniproReceiptApi);
end.
