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

    // ������ �������� ������������
    FUserEmail : String;
    FPassword : String;
    FBase64Key : String;
    FKeyPassword : String;

    // ������ ������
    FLikiDnepr : String;

    // ������ �������
    FAccess_Token : String;

    // ������
    FNumber : String;

    // ID ��������� �������
    FDispense_ID : string;
    FDispense_Data : string;

    // ����������� ������
    FSign_Data : string;

    // ������ �� �������
    FMedication_ID : string;            // dosage_id ��� ��������
    FMedication_ID_List : String;       // ID ��� ��������
    FMedication_Name : string;          // ��������
    FMedication_Qty : currency;         // ���������� ��������

    FMedication_request_id : String;    // ID �������
    FMedical_program_id : String;       // ID ���. ��������� ���������

    FRequest_number : String;           // ����� ������� �� ����
    FStatus : string;                   // ������ ����
    FCreated_at : TDateTime;            // ���� ��������
    FDispense_valid_from : TDateTime;   // ������������ �
    FDispense_valid_to : TDateTime;     // ��

    FSell_Medication_ID : string;
    FProgram_Medication_Id : string;
    FSell_qty : Currency;
    FSell_price : Currency;
    FSell_amount : Currency;
    FDiscount_amount : Currency;
    FDispensed_Code : string;

    // ���������� ������������
    FShow_eHealth : Boolean;
    FShow_Location : String;

    FHTTP_Port : Integer;
    FInterval : Integer;
  protected
    function GetReceiptId : boolean;
    function GetDrugList : boolean;
    function dispenseRecipe : boolean;
    function signRecipe : boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function ShowError(AText : string = '������ ��������� ���������� � �������') : string;

  end;

function CheckLikiDniproeHealth_Number(ANumber : string) : boolean;

function GetLikiDniproeHealthState(const AReceipt : String; var AState : string) : boolean;

function GetLikiDniproeHealthReceipt(const AReceipt : String; var AID, AIDList, AName : string;
  var AQty : currency; var ADate : TDateTime) : boolean;

function CreateLikiDniproeHealthNewDispense(AIDSP, AProgramIdSP : string; AQty, APrice, ASell_amount, ADiscount_amount : currency;
  ACode : string) : boolean;

function SignRecipeLikiDniproeHealth : boolean;

var LikiDniproeHealthApi : TLikiDniproeHealthApi;

implementation

uses RegularExpressions, System.Generics.Collections, Soap.EncdDecd , MainCash2,
     LocalWorkUnit, ChoiceHelsiUserName, CommonData, Clipbrd, CallbackHandler;

const arError : array [0..19, 0..1] of string =
  (('Active medication dispense already exists', '����� ����������� ��������� ����� �������'),
  ('Legal entity is not verified',  '�����! ��� ������ �� �����������. ��������� �� ���������� ������ �������.'),
  ('Can''t update medication dispense status from PROCESSED to REJECTED', '������� ������������� (������ ��������������) ������������� ����� 10 ���.'),
  ('Medication request is not active', '�����! ������ �� ���� ���� ��������, ���� ���� ��������� �������� �� ��� ������. ������������ �������� ���������� �� ����� ��� ������� ������ ������� �� ���� �������� ������� ��������.'),
  ('Division should be participant of a contract to create dispense', '�����! ������ � ��� �� ��������, �� �������� � ����� ������ �� ��������� "������� ���" � ������������ ������� ������''� ������. ��������� �� ���������� ������ �������'),
  ('Medication request can not be dispensed. Invoke qualify medication request API to get detailed info', '��������� �������� ��� ������ �� ��������� "������� ���"! �������� ����� ���� ������ �������� � ����� �� ����� ���������. ���� �� ��� ������ ���� ���� �������� ����� ���� ��������� �����������.'),
  ('Program cannot be used - no active contract exists', '�����! �� ����� �������� ������� ����� ������ �� ��������� "������� ���" � ������������ ������� ������''� ������. ��������� �� ���������� ������ �������'),
  ('Can''t update medication dispense status from EXPIRED to PROCESSED', '��������� ��������� �������� ���������'),
  ('Can''t update medication dispense status from REJECTED to PROCESSED', '��������� ��������� �������� ���������'),
  ('Can''t update medication dispense status from REJECTED to REJECTED', '��������� ��������� �������� ���������'),
  ('Does not match the legal entity', '�������! ϳ���� ��� �� �������� �������� ����. �������� ������ �������������� ��� ��������� ���'),
  ('Does not match the signer drfo', '�������! ϳ���� ��� �������� ������ �����������. �������� ������ �������������� ��� ��������� ���'),
  ('Does not match the signer last name', '�������! �������� � ������������� ������� ����������. �������� ������ �������������� ��� ��������� ���'),
  ('document must contain 1 signature and 0 stamps but contains 0 signatures and 1 stamp', '�������! ��� �������� �� ������������� �� ������� ���. �������� ������ �������������� ��� ��������� ���'),
  ('Requested discount price does not satisfy allowed reimbursement amount', '�������! ������������ ���� ����������� �� ���� �������� "������� ���".'),
  ('Medication request is not valid', '��������� ��������� ������ �� ��������� �������'),
  ('Incorrect code', '������������ ��� �������������'),
  ('Invalid dispense period', '�����! ����� ����� 䳿 �������. �������� ������� ���������� �� ����� ��� ������� ������ �������'),
  ('dispensed medication quantity must be equal to medication quantity in Medication Request', '���������� ������������ ��������� ������ ���� ����� ���������� ����������� � ������� ���������'),
  ('Certificate verificaton failed', '�� ������� ����������� ����������. ��������� ������� ��������� ����.'));

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
    if not Result then ShowMessage ('������.<��������������� ����� �������>'#13#10#13#10 +
      '����� ������ ��������� 19 �������� � 4 ����� �� 4 ������� ����������� �������� "-"'#13#10 +
      'C�������� ������ ����� � ����� ���������� ��������'#13#10 +
      '� ���� XXXX-XXXX-XXXX-XXXX ...');
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
    if not Result then ShowMessage('������ �������������� ���� �������.');
  end;
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

function TextEncodeBase64(AText : String) : String;
  var
      fileStream: TFileStream;
      base64Stream: TStringStream;
      S : String;
begin
   base64Stream := TStringStream.Create(AText);
   try
   Result := EncodeBase64(BytesOf(base64Stream.DataString));
   finally
     FreeAndNil(base64Stream);
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
  FHTTP_Port := 7046;
  FInterval := 60000;

end;

destructor TLikiDniproeHealthApi.Destroy;
begin
  FRESTResponse.Free;
  FRESTRequest.Free;
  FRESTClient.Free;
end;

function TLikiDniproeHealthApi.ShowError(AText : string = '������ ��������� ���������� � �������') : string;
var
  jValue : TJSONValue;
  JSONA: TJSONArray;
  cError : string;
  I : Integer;
begin
  cError := '';
  jValue := FRESTResponse.JSONValue ;
  if jValue <> Nil then
  begin
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
  end;

  if cError = '' then cError := IntToStr(FRESTResponse.StatusCode) + ' - ' + FRESTResponse.StatusText;

  for I := 0 to 19 do if (LowerCase(arError[I, 0]) = LowerCase(cError)) then
  begin
    cError := arError[I, 1];
    Break;
  end;

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
  FDispense_Data := '';
  FSign_Data := '';

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

  if (FRESTResponse.StatusCode = 200) and (FRESTResponse.JSONValue <> nil) then
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
      end else ShowError('������ ��������� ���������� �� ������� �� ��������� ��');
    except
    end
  end else ShowError('������ ��������� ���������� �� ������� �� ��������� ��');
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
  end else ShowError('������ ��������� ������ �������� ��� ��������� �������');
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
        FDispense_Data := EncodeBase64(TBytes(AnsiToUtf8(jValue.ToString)));
        Result := True;
      end else ShowError('������ ��������� ������� ���������� �����������');;
    except
    end
  end else ShowError('������ ��������� ������� ���������� �����������');
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
  FRESTRequest.Resource := 'medications/signed-medication-dispense/' + FDispense_ID;

  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('Authorization', 'Bearer ' + FAccess_Token, TRESTRequestParameterKind.pkHTTPHEADER,
                                                                        [TRESTRequestParameterOption.poDoNotEncode]);
  FRESTRequest.AddParameter('Accept', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER);
  FRESTRequest.AddParameter('employee_email', FUserEmail, TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('data', FSign_Data, TRESTRequestParameterKind.pkGETorPOST, [TRESTRequestParameterOption.poDoNotEncode]);

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
          Result := True;
        end;
      end else ShowError('������ �������� � eHealth ������������ ����������� �������');

    except
    end
  end else ShowError('������ �������� � eHealth ������������ ����������� �������');
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
    ShowMessage('������ �� ����������� ��������� ��� ����������� � ������� LikiDnepro.');
    Exit;
  end;


  if not Assigned(LikiDniproeHealthApi) then
  begin
    LikiDniproeHealthApi := TLikiDniproeHealthApi.Create;
    LikiDniproeHealthApi.FLikiDnepr := MainCashForm.UnitConfigCDS.FieldByName('LikiDneproeHealthURL').AsString;
    LikiDniproeHealthApi.FShow_Location := MainCashForm.UnitConfigCDS.FieldByName('LikiDneproeLocation').AsString;
    LikiDniproeHealthApi.FAccess_Token := MainCashForm.UnitConfigCDS.FieldByName('LikiDneproeHealthToken').AsString;

    try
      ds := TClientDataSet.Create(nil);
      try
        WaitForSingleObject(MutexUserLikiDnipro, INFINITE); // ������ ��� �����2;  �������� ��� ��� ���� � ����������� � �������
        try
          LoadLocalData(ds,UserLikiDnipro_lcl);
        finally
          ReleaseMutex(MutexUserLikiDnipro);
        end;

        if ds.RecordCount <= 0 then
        begin
          FreeAndNil(LikiDniproeHealthApi);
          ShowMessage('�� ������������� ��� ����������� ��� �������� ��������...');
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
        ShowMessage('������ ��������� ������� ������ ����������: ' + E.Message);
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
    Clipboard.AsText := LikiDniproeHealthApi.FUserEmail;
    ShellExecute(Screen.ActiveForm.Handle, 'open', PChar(LikiDniproeHealthApi.FShow_Location), nil, nil, SW_SHOWNORMAL);
    Sleep(500);
    MessageDlg('��������� ������ � ����� ������...', mtInformation, [mbOK], 0);
    Clipboard.AsText := LikiDniproeHealthApi.FPassword;
    LikiDniproeHealthApi.FShow_eHealth := False;
    Exit;
  end;

  if AReceipt <> LikiDniproeHealthApi.FRequest_number then
  begin
    ShowMessage('������ ��������� ���������� � ������� � ����� �����...'#13#10 +
      '������������ ����� �������.');
    Result := False;
    Exit;
  end;

  if LikiDniproeHealthApi.FDispense_valid_to < Date then
  begin
    ShowMessage('���� �������� ������� �����...');
    Result := False;
    Exit;
  end;

  if LikiDniproeHealthApi.FStatus = 'ACTIVE' then
  begin

    if LikiDniproeHealthApi.FMedical_program_id = '' then
    begin
      ShowMessage('��� � ���� ���������� � ��� �������...');
      Result := False;
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
    Result := False;
    LikiDniproeHealthApi.FRequest_number := '';
    ShowMessage('������ ��� ��������.');
  end else if LikiDniproeHealthApi.FStatus = 'COMPLETED' then
  begin
    Result := False;
    LikiDniproeHealthApi.FRequest_number := '';
    ShowMessage('������ ��� �������.');
  end else
  begin
    Result := False;
    LikiDniproeHealthApi.FRequest_number := '';
    ShowMessage('������ ����������� ������ ����.');
  end;
end;

function GetLikiDniproeHealthState(const AReceipt : String; var AState : string) : boolean;
begin
  Result := False;

  if not CheckLikiDniproeHealth_Number(AReceipt) then Exit;

  if not InitLikiDniproeHealthApi then Exit;

  LikiDniproeHealthApi.FNumber := AReceipt;

  Result := LikiDniproeHealthApi.GetReceiptId;

  if LikiDniproeHealthApi.FShow_eHealth then
  begin
    Clipboard.AsText := LikiDniproeHealthApi.FUserEmail;
    ShellExecute(Screen.ActiveForm.Handle, 'open', PChar(LikiDniproeHealthApi.FShow_Location), nil, nil, SW_SHOWNORMAL);
    Sleep(500);
    MessageDlg('��������� ������ � ����� ������...', mtInformation, [mbOK], 0);
    Clipboard.AsText := LikiDniproeHealthApi.FPassword;
    LikiDniproeHealthApi.FShow_eHealth := False;
    Exit;
  end;

  if AReceipt <> LikiDniproeHealthApi.FRequest_number then
  begin
    ShowMessage('������ ��������� ���������� � ������� � ����� �����...'#13#10 +
      '������������ ����� �������.');
    Exit;
  end;

  if LikiDniproeHealthApi.FDispense_valid_to < Date then
  begin
    AState := 'EXPIRED';
    Exit;
  end;

  AState := LikiDniproeHealthApi.FStatus;
  Result := True;
end;



function CreateLikiDniproeHealthNewDispense(AIDSP, AProgramIdSP : string; AQty, APrice, ASell_amount, ADiscount_amount : currency;
  ACode : string) : boolean;
  var fileStream: TMemoryStream;
      base64Stream: TStringStream;
begin

  Result := False;

  if not Assigned(LikiDniproeHealthApi) or (LikiDniproeHealthApi.FRequest_number = '') then
  begin
    ShowMessage('������ �� �������� ���������� � ������� � ����� ��� "������"...');
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

  if Result then
  try
    Clipboard.AsText := LikiDniproeHealthApi.FKeyPassword;

    try
      fileStream := TMemoryStream.Create;
      base64Stream := TStringStream.Create(LikiDniproeHealthApi.FBase64Key);
      try
        DecodeStream(base64Stream, fileStream);
        fileStream.SaveToFile('Key-6.dat');
      finally
        FreeAndNil(fileStream);
        FreeAndNil(base64Stream);
      end;
    except
      Result := False;
      ShowMessage('������ ���������� ��������� �����.');
      Exit;
    end;

    if ShowCallbackHandler(LikiDniproeHealthApi.FLikiDnepr +
      '/sign3?employee_id=00000000-0001-1001-0110-000000000000#{"callback_url":"http://localhost:' + IntToStr(LikiDniproeHealthApi.FHTTP_Port) +
      '","data":["' + LikiDniproeHealthApi.FDispense_Data + '"]}',
      '�������� ������� �������.', '��������� ������ ���', LikiDniproeHealthApi.FHTTP_Port, LikiDniproeHealthApi.FInterval, LikiDniproeHealthApi.FSign_Data) then
    begin
      if LikiDniproeHealthApi.FSign_Data = '' then
      begin
        Result := False;
        ShowMessage('������ ������� �������.');
      end;
    end;
  finally
    if FileExists('Key-6.dat') then DeleteFile('Key-6.dat');
  end;
end;

function SignRecipeLikiDniproeHealth : boolean;
begin
  Result := False;

  if not Assigned(LikiDniproeHealthApi) or (LikiDniproeHealthApi.FSign_Data = '') then
  begin
    ShowMessage('������ �� ����������� ������� �������...');
    Exit;
  end;

  Result := LikiDniproeHealthApi.signRecipe;
end;

initialization
  LikiDniproeHealthApi := Nil;

finalization
  if Assigned(LikiDniproeHealthApi) then FreeAndNil(LikiDniproeHealthApi);
end.
