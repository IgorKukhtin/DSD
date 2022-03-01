unit UtilTelegram;

interface

uses
  System.SysUtils, System.Variants, System.Classes, System.JSON, Data.DB,
  Vcl.Dialogs, REST.Types, REST.Client, REST.Response.Adapter,
  Winapi.Windows, Vcl.Forms, ShellApi, IdHTTP, IdSSLOpenSSL, System.IOUtils,
  Datasnap.DBClient;

type

  TTelegramBot = class(TObject)
  private
    FRESTResponse: TRESTResponse;
    FRESTRequest: TRESTRequest;
    FRESTClient: TRESTClient;

    FChatIdCDS: TClientDataSet;


    // Данные текущего пользователя
    FToken : String;
    FBaseURL : String;
    FFileNameChatId : String;

    FID : integer;
    Fid_bot : Boolean;
    Ffirst_name : String;
    Fusername : String;
    Fcan_join_groups : Boolean;
    Fcan_read_all_group_messages : Boolean;
    Fsupports_inline_queries : Boolean;

    Fupdate_id : Int64;
    FError : String;

    FMessagesTelegramCDS : TClientDataSet;

  protected
    procedure InitCDS;
    procedure InitBot;
    function GetUpdates : integer;
    function GetErrorText : string;
  public
    constructor Create(AToken : String); virtual;
    destructor Destroy; override;

    procedure LoadChatId;

    function SendMessage(AChatId : string; AMessage : string) : boolean;
    function SendDocument(AChatId : string; ADocument, ACaption : string) : boolean;
    function SendPhoto(AChatId : string; APhoto, ACaption : string) : boolean;

    property ChatIdCDS: TClientDataSet read FChatIdCDS;
    property Id : Integer read FId;
    property FileNameChatId : String read FFileNameChatId write FFileNameChatId;
    property ErrorText: String read GetErrorText;
    property MessagesTelegramCDS: TClientDataSet read FMessagesTelegramCDS write FMessagesTelegramCDS;
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

  { TTelegramBot }

constructor TTelegramBot.Create(AToken : String);
begin
  FRESTClient := TRESTClient.Create('');
  FRESTResponse := TRESTResponse.Create(Nil);
  FRESTRequest := TRESTRequest.Create(Nil);
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;

  FChatIdCDS := TClientDataSet.Create(Nil);
  FFileNameChatId := 'ChatId.xml';

  FToken := AToken;
  FBaseURL := 'https://api.telegram.org/bot' + FToken;

  InitBot;
end;

destructor TTelegramBot.Destroy;
begin
  FChatIdCDS.Free;
  FRESTResponse.Free;
  FRESTRequest.Free;
  FRESTClient.Free;
end;

function TTelegramBot.GetErrorText : string;
begin
   Result := FError;
   FError := '';
end;

procedure TTelegramBot.InitBot;
  var jValue : TJSONValue;
begin

  FRESTClient.BaseURL := FBaseURL;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Resource := '/GetMe';
  // required parameters
  FRESTRequest.Params.Clear;

  try
    FRESTRequest.Execute;
  except
  end;

  if FRESTResponse.ContentType = 'application/json' then
  begin
    jValue := FRESTResponse.JSONValue;

    if jValue.FindValue('ok') = Nil then
    begin
      FError := jValue.ToString;
      Exit;
    end;
    if not jValue.FindValue('ok').ClassNameIs('TJSONTrue') then
    begin
      FError := DelDoubleQuote(jValue.FindValue('description'));
      Exit;
    end;

    jValue := jValue.FindValue('result');

    FID := StrToInt64(jValue.FindValue('id').ToString);
    Fid_bot := jValue.FindValue('is_bot').ClassNameIs('TJSONTrue');
    Ffirst_name := DelDoubleQuote(jValue.FindValue('first_name'));
    Fusername := DelDoubleQuote(jValue.FindValue('username'));
    Fcan_join_groups := jValue.FindValue('can_join_groups').ClassNameIs('TJSONTrue');
    Fcan_read_all_group_messages := jValue.FindValue('can_read_all_group_messages').ClassNameIs('TJSONTrue');
    Fsupports_inline_queries := jValue.FindValue('supports_inline_queries').ClassNameIs('TJSONTrue');

  end else FError := FRESTResponse.StatusText;
end;

procedure TTelegramBot.InitCDS;
begin
  if FileExists(FFileNameChatId) then
  try
    FChatIdCDS.LoadFromFile(FFileNameChatId);
  except
  end;

  try
    if FChatIdCDS.FieldDefs.Count <> 4 then
    begin
      if FChatIdCDS.Active then FChatIdCDS.Close;
      FChatIdCDS.Close;
      FChatIdCDS.FieldDefs.Clear;
      FChatIdCDS.FieldDefs.Add('ID', TFieldType.ftLargeint);
      FChatIdCDS.FieldDefs.Add('FirstName', TFieldType.ftString, 250);
      FChatIdCDS.FieldDefs.Add('LastName', TFieldType.ftString, 250);
      FChatIdCDS.FieldDefs.Add('UserName', TFieldType.ftString, 250);
      FChatIdCDS.CreateDataSet;
    end;

    if not FChatIdCDS.Active then FChatIdCDS.Open;
  except
  end;

  if Assigned(FMessagesTelegramCDS) then
  begin
    if not FMessagesTelegramCDS.Active then
    begin
      if FMessagesTelegramCDS.Active then FMessagesTelegramCDS.Close;
      FMessagesTelegramCDS.Close;
      FMessagesTelegramCDS.FieldDefs.Clear;
      FMessagesTelegramCDS.FieldDefs.Add('ChatId', TFieldType.ftLargeint);
      FMessagesTelegramCDS.FieldDefs.Add('Text', TFieldType.ftMemo, 0);
      FMessagesTelegramCDS.CreateDataSet;
    end;
  end
end;

function TTelegramBot.GetUpdates : integer;
  var jValue : TJSONValue;
      JSONA: TJSONArray;
      I : integer;

  procedure AddChatId (AValue : TJSONValue; AText : TJSONValue);
  begin
    if AValue = nil then Exit;

    if FChatIdCDS.Locate('ID', StrToInt64(AValue.FindValue('id').ToString), []) then
    begin
      if (FChatIdCDS.FieldByName('FirstName').AsString <> DelDoubleQuote(AValue.FindValue('first_name'))) or
         (FChatIdCDS.FieldByName('LastName').AsString <> DelDoubleQuote(AValue.FindValue('last_name'))) or
         (FChatIdCDS.FieldByName('UserName').AsString <> DelDoubleQuote(AValue.FindValue('username'))) then
      begin
        FChatIdCDS.Edit;
        FChatIdCDS.FieldByName('ID').AsLargeInt := StrToInt64(AValue.FindValue('id').ToString);
        FChatIdCDS.FieldByName('FirstName').AsString := DelDoubleQuote(AValue.FindValue('first_name'));
        FChatIdCDS.FieldByName('LastName').AsString := DelDoubleQuote(AValue.FindValue('last_name'));
        FChatIdCDS.FieldByName('UserName').AsString := DelDoubleQuote(AValue.FindValue('username'));
        FChatIdCDS.Post;
      end;
    end else
    if (DelDoubleQuote(AValue.FindValue('username')) <> '') and
       FChatIdCDS.Locate('UserName', DelDoubleQuote(AValue.FindValue('username')), [loCaseInsensitive]) then
    begin
      if (FChatIdCDS.FieldByName('FirstName').AsString <> DelDoubleQuote(AValue.FindValue('first_name'))) or
         (FChatIdCDS.FieldByName('ID').AsLargeInt <> StrToInt64(AValue.FindValue('id').ToString)) then
      begin
        FChatIdCDS.Edit;
        FChatIdCDS.FieldByName('ID').AsLargeInt := StrToInt64(AValue.FindValue('id').ToString);
        FChatIdCDS.FieldByName('FirstName').AsString := DelDoubleQuote(AValue.FindValue('first_name'));
        FChatIdCDS.FieldByName('LastName').AsString := DelDoubleQuote(AValue.FindValue('last_name'));
        FChatIdCDS.FieldByName('UserName').AsString := DelDoubleQuote(AValue.FindValue('username'));
        FChatIdCDS.Post;
      end;
    end else
    begin
      FChatIdCDS.Last;
      FChatIdCDS.Append;
      FChatIdCDS.FieldByName('ID').AsLargeInt := StrToInt64(AValue.FindValue('id').ToString);
      FChatIdCDS.FieldByName('FirstName').AsString := DelDoubleQuote(AValue.FindValue('first_name'));
      FChatIdCDS.FieldByName('LastName').AsString := DelDoubleQuote(AValue.FindValue('last_name'));
      FChatIdCDS.FieldByName('UserName').AsString := DelDoubleQuote(AValue.FindValue('username'));
      FChatIdCDS.Post;
    end;

    if Assigned(FMessagesTelegramCDS) and (AText <> Nil) then
    begin
      FMessagesTelegramCDS.Last;
      FMessagesTelegramCDS.Append;
      FMessagesTelegramCDS.FieldByName('ChatId').AsLargeInt := StrToInt64(AValue.FindValue('id').ToString);
      FMessagesTelegramCDS.FieldByName('Text').AsString := DelDoubleQuote(AText);
      FMessagesTelegramCDS.Post;
    end;

  end;


begin

  Result := 0;
  FRESTClient.BaseURL := FBaseURL;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Resource := '/getUpdates';
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('offset', IntToStr(Fupdate_id + 1), TRESTRequestParameterKind.pkGETorPOST);

  try
    FRESTRequest.Execute;
  except
  end;

  if FRESTResponse.ContentType = 'application/json' then
  begin
    jValue := FRESTResponse.JSONValue;

    if jValue.FindValue('ok') = Nil then
    begin
      FError := jValue.ToString;
      Exit;
    end;
    if not jValue.FindValue('ok').ClassNameIs('TJSONTrue') then
    begin
      FError := DelDoubleQuote(jValue.FindValue('description'));
      Exit;
    end;

    JSONA := jValue.GetValue<TJSONArray>('result');
    Result := JSONA.Count;
    for I := 0 to JSONA.Count - 1 do
    begin
      jValue := JSONA.Items[I];
      Fupdate_id := StrToInt64(jValue.FindValue('update_id').ToString);
      jValue := jValue.FindValue('message');
      if jValue = nil then Continue;
      if jValue.FindValue('from') <> nil then AddChatId(jValue.FindValue('from'), jValue.FindValue('text'));
      if jValue.FindValue('chat') <> nil then AddChatId(jValue.FindValue('chat'), nil);
    end;

  end else FError := FRESTResponse.StatusText;;
end;

procedure TTelegramBot.LoadChatId;
begin

  Fupdate_id := 0;
  InitCDS;
  if not FChatIdCDS.Active then Exit;

  while GetUpdates > 0 do ;

  FChatIdCDS.SaveToFile(FFileNameChatId, dfXML);

end;

function TTelegramBot.SendMessage(AChatId : string; AMessage : string) : boolean;
  var jValue : TJSONValue;
begin
  Result := False;

  FRESTClient.BaseURL := FBaseURL;
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.Resource := '/sendMessage';
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('chat_id', AChatId, TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('text', AMessage, TRESTRequestParameterKind.pkGETorPOST);

  try
    FRESTRequest.Execute;
  except
  end;

  if FRESTResponse.ContentType = 'application/json' then
  begin
    jValue := FRESTResponse.JSONValue;

    if jValue.FindValue('ok') = Nil then
    begin
      FError := jValue.ToString;
      Exit;
    end;
    Result := jValue.FindValue('ok').ClassNameIs('TJSONTrue');

    if not Result then
      FError := DelDoubleQuote(jValue.FindValue('description'));
  end else FError := FRESTResponse.StatusText;;
end;

function TTelegramBot.SendDocument(AChatId : string; ADocument, ACaption : string) : boolean;
  var jValue : TJSONValue;
begin
  Result := False;


  FRESTClient.BaseURL := FBaseURL;
  FRESTClient.ContentType := 'multipart/form-data';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.Resource := '/sendDocument';
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('chat_id', AChatId, TRESTRequestParameterKind.pkGETorPOST);
  if ACaption <> '' then
    FRESTRequest.AddParameter('caption', ACaption, TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('document', ADocument, TRESTRequestParameterKind.pkFILE);
  try
    FRESTRequest.Execute;
  except
  end;

  if FRESTResponse.ContentType = 'application/json' then
  begin
    jValue := FRESTResponse.JSONValue;

    if jValue.FindValue('ok') = Nil then
    begin
      FError := jValue.ToString;
      Exit;
    end;
    Result := jValue.FindValue('ok').ClassNameIs('TJSONTrue');

    if not Result then
      FError := DelDoubleQuote(jValue.FindValue('description'));
  end else FError := FRESTResponse.StatusText;;

end;

function TTelegramBot.SendPhoto(AChatId : string; APhoto, ACaption : string) : boolean;
  var jValue : TJSONValue;
begin
  Result := False;


  FRESTClient.BaseURL := FBaseURL;
  FRESTClient.ContentType := 'multipart/form-data';

  FRESTRequest.ClearBody;
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.Resource := '/sendPhoto';
  // required parameters
  FRESTRequest.Params.Clear;
  FRESTRequest.AddParameter('chat_id', AChatId, TRESTRequestParameterKind.pkGETorPOST);
  if ACaption <> '' then
    FRESTRequest.AddParameter('caption', ACaption, TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('photo', APhoto, TRESTRequestParameterKind.pkFILE);
  try
    FRESTRequest.Execute;
  except
  end;

  if FRESTResponse.ContentType = 'application/json' then
  begin
    jValue := FRESTResponse.JSONValue;

    if jValue.FindValue('ok') = Nil then
    begin
      FError := jValue.ToString;
      Exit;
    end;
    Result := jValue.FindValue('ok').ClassNameIs('TJSONTrue');

    if not Result then
      FError := DelDoubleQuote(jValue.FindValue('description'));
  end else FError := FRESTResponse.StatusText;;

end;

end.
