unit uBayer;

interface

uses
  System.SysUtils, System.Variants, System.Classes, System.JSON, Data.DB,
  Vcl.Dialogs, REST.Types, REST.Client, REST.Response.Adapter,
  Winapi.Windows, Vcl.Forms, ShellApi, IdHTTP, IdSSLOpenSSL, System.IOUtils,
  Datasnap.DBClient;

type

  TBayerAPI = class(TObject)
  private
    FRESTResponse: TRESTResponse;
    FRESTRequest: TRESTRequest;
    FRESTClient: TRESTClient;

    FDistributorsCDS: TClientDataSet;
    FDrugsCDS: TClientDataSet;

    // Данные текущего пользователя
    FBaseURL : String;
    FErrorsText : String;

  protected
    function InitDistributorsCDS : boolean;
    function InitDrugsCDS : boolean;
  public
    constructor Create(FTest : boolean = False); virtual;
    destructor Destroy; override;

    function LoadDistributors(AToken : String) : boolean;
    function LoadDrugs(AToken : String) : boolean;

    function SendRemnants(AToken : String; ADrugs, Distributor, AAmount : Integer) : boolean;

    property DistributorsCDS: TClientDataSet read FDistributorsCDS;
    property DrugsCDS: TClientDataSet read FDrugsCDS;
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

  { TBayerAPI }

constructor TBayerAPI.Create(FTest : boolean = False);
begin
  FRESTClient := TRESTClient.Create('');
  FRESTResponse := TRESTResponse.Create(Nil);
  FRESTRequest := TRESTRequest.Create(Nil);
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;

  FDistributorsCDS := TClientDataSet.Create(Nil);
  FDrugsCDS := TClientDataSet.Create(Nil);

  if FTest then
    FBaseURL := 'http://dev.xap.com.ua/api'
  else FBaseURL := 'http://xap.com.ua/api';
end;

destructor TBayerAPI.Destroy;
begin
  FDrugsCDS.Free;
  FDistributorsCDS.Free;
  FRESTResponse.Free;
  FRESTRequest.Free;
  FRESTClient.Free;
end;

function TBayerAPI.InitDistributorsCDS : boolean;
begin
  try
    FDistributorsCDS.Close;
    FDistributorsCDS.FieldDefs.Clear;
    FDistributorsCDS.FieldDefs.Add('ID', TFieldType.ftInteger);
    FDistributorsCDS.FieldDefs.Add('DistributorName', TFieldType.ftString, 100);
    FDistributorsCDS.CreateDataSet;

    if not FDistributorsCDS.Active then FDistributorsCDS.Open;
  except
  end;
  Result := FDistributorsCDS.Active;
end;

function TBayerAPI.InitDrugsCDS : boolean;
begin
  try
    FDrugsCDS.Close;
    FDrugsCDS.FieldDefs.Clear;
    FDrugsCDS.FieldDefs.Add('ID', TFieldType.ftInteger);
    FDrugsCDS.FieldDefs.Add('DrugName', TFieldType.ftString, 100);
    FDrugsCDS.FieldDefs.Add('DrugBarcode', TFieldType.ftString, 50);
    FDrugsCDS.CreateDataSet;

    if not FDrugsCDS.Active then FDrugsCDS.Open;
  except
  end;
  Result := FDrugsCDS.Active;
end;

function TBayerAPI.LoadDistributors(AToken : String) : boolean;
  var jValue : TJSONValue;
      JSONA: TJSONArray;
      I : integer;
begin

  Result := False;
  FRESTClient.BaseURL := FBaseURL;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Resource := 'dictionaries/distributors';
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER,
                                                                          [TRESTRequestParameterOption.poDoNotEncode]);
  FRESTRequest.AddParameter('Authorization', 'Bearer ' + AToken, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                          [TRESTRequestParameterOption.poDoNotEncode]);

  try
    FRESTRequest.Execute;
  except
  end;

  if FRESTResponse.ContentType = 'application/json' then
  begin
    jValue := FRESTResponse.JSONValue;

    if jValue.FindValue('errors') <> Nil then
    begin
      FErrorsText := DelDoubleQuote(jValue.FindValue('errors'));
    end else if jValue.FindValue('data') <> Nil then
    begin

      if InitDistributorsCDS then
      begin
        JSONA := jValue.GetValue<TJSONArray>('data');
        for I := 0 to JSONA.Count - 1 do
        begin
          jValue := JSONA.Items[I];

          FDistributorsCDS.Last;
          FDistributorsCDS.Append;
          FDistributorsCDS.FieldByName('ID').AsInteger := StrToInt(jValue.FindValue('id').ToString);
          FDistributorsCDS.FieldByName('DistributorName').AsString := DelDoubleQuote(jValue.FindValue('DistributorName'));
          FDistributorsCDS.Post;
        end;
        Result := True;
      end;

    end else
    begin
      FErrorsText := 'Неизвестный результат запроса.';
    end;
  end;
end;

function TBayerAPI.LoadDrugs(AToken : String) : boolean;
  var jValue : TJSONValue;
      JSONA: TJSONArray;
      I : integer;
begin

  Result := False;
  FRESTClient.BaseURL := FBaseURL;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Resource := 'dictionaries/drugs';
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER,
                                                                          [TRESTRequestParameterOption.poDoNotEncode]);
  FRESTRequest.AddParameter('Authorization', 'Bearer ' + AToken, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                          [TRESTRequestParameterOption.poDoNotEncode]);

  try
    FRESTRequest.Execute;
  except
  end;

  if FRESTResponse.ContentType = 'application/json' then
  begin
    jValue := FRESTResponse.JSONValue;

    if jValue.FindValue('errors') <> Nil then
    begin
      FErrorsText := DelDoubleQuote(jValue.FindValue('errors'));
    end else if jValue.FindValue('data') <> Nil then
    begin

      if InitDrugsCDS then
      begin
        JSONA := jValue.GetValue<TJSONArray>('data');
        for I := 0 to JSONA.Count - 1 do
        begin
          jValue := JSONA.Items[I];

          FDrugsCDS.Last;
          FDrugsCDS.Append;
          FDrugsCDS.FieldByName('ID').AsInteger := StrToInt(jValue.FindValue('id').ToString);
          FDrugsCDS.FieldByName('DrugName').AsString := DelDoubleQuote(jValue.FindValue('DrugName'));
          FDrugsCDS.FieldByName('DrugBarcode').AsString := DelDoubleQuote(jValue.FindValue('DrugBarcode'));
          FDrugsCDS.Post;
        end;
        Result := True;
      end;

    end else
    begin
      FErrorsText := 'Неизвестный результат запроса.';
    end;
  end;
end;

function TBayerAPI.SendRemnants(AToken : String; ADrugs, Distributor, AAmount : Integer) : boolean;
  var jValue : TJSONValue;
      jsonBody: TJSONObject;
begin

  Result := False;

  jsonBody := TJSONObject.Create;
  try
    jsonBody.AddPair('drugs', TJSONNumber.Create(ADrugs));
    jsonBody.AddPair('date', TJSONString.Create(FormatDateTime('dd.mm.yyyy', Date)));
    jsonBody.AddPair('amount', TJSONNumber.Create(AAmount));
    jsonBody.AddPair('distributor', TJSONNumber.Create(Distributor));

    FRESTClient.BaseURL := FBaseURL;
    FRESTClient.ContentType := 'application/json';

    FRESTRequest.ClearBody;
    FRESTRequest.Method := TRESTRequestMethod.rmPOST;
    FRESTRequest.Resource := 'remnants/create';
    // required parameters
    FRESTRequest.Params.Clear;
    FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER,
                                                                            [TRESTRequestParameterOption.poDoNotEncode]);
    FRESTRequest.AddParameter('Authorization', 'Bearer ' + AToken, TRESTRequestParameterKind.pkHTTPHEADER,
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

    if jValue.FindValue('errors') <> Nil then
    begin
      FErrorsText := DelDoubleQuote(jValue.FindValue('errors'));
    end else if jValue.FindValue('status') <> Nil then
    begin
      case StrToInt(jValue.FindValue('status').ToString) of
         0 : FErrorsText := 'Дані не вдалося додати';
         1 : Result := True;
        -1 : FErrorsText := 'Невірний ключ авторизації "Authorization: Bearer {token}"';
        -2 : FErrorsText := 'Доступи аптеки відсутні або деактивовані';
        -3 : FErrorsText := 'Аптека деактивована';
        -4 : FErrorsText := 'Невірний ID дистриб’ютора';
        -5 : FErrorsText := 'Невірний ID препарату';
      end;
    end else
    begin
      FErrorsText := 'Ошибка сохранения остатка.'#13#10 + jValue.ToString;
    end;
  end;
end;


end.
