unit MediCard.Dsgn;

interface

uses
  System.Contnrs, System.SysUtils, System.Classes, Soap.EncdDecd, Web.HTTPApp,
  httpsend,
  MediCard.Intf;

type
  TMCCasualCache = class(TInterfacedObject, IMCCasualCache)
  private
    FCasualList: TObjectList;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function GenerateCasual: string;
    function Find(AMorionCode: Integer): string;
    procedure Delete(AMorionCode: Integer);
    procedure Save(AMorionCode: Integer; ACasual: string);
    procedure Clear;
  end;

  TMCDesigner = class(TInterfacedObject, IMCDesigner)
  private
    FURL: string;
    FClasses: TClassList;
    FCasualCache: IMCCasualCache;
    function GetClasses: TClassList;
    function GetCasualCache: IMCCasualCache;

    function GetURL: string;
    procedure SetURL(const Value: string);
    procedure HTTPSetHeader(AHTTP: THTTPSend);
    procedure HTTPCheckResult(const AResult: Integer);
    function HTTPMethod(const AMethod, ABody: string; var AResponse: string): Integer;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    procedure RegisterClasses(AClasses: array of TInterfacedClass);
    function FindClass(const IID: TGUID): TInterfacedClass;
    function CreateObject(const IID: TGUID): TInterfacedObject;

    function HTTPPost(const ABody: string; var AResponse: string): Integer;

    property URL: string read GetURL write SetURL;
    property Classes: TClassList read GetClasses;
    property CasualCache: IMCCasualCache read GetCasualCache;
  end;

implementation

type
  TMCCasualItem = class
  private
    FMorionCode: Integer;
    FCasual: string;
    function GetMorionCode: Integer;
    function GetCasual: string;
  public
    constructor Create(AMorionCode: Integer; ACasual: string);
    property MorionCode: Integer read GetMorionCode;
    property Casual: string read GetCasual;
  end;

{ TMCDesigner }

procedure TMCDesigner.AfterConstruction;
begin
  inherited AfterConstruction;
  FURL := '';
  FClasses := TClassList.Create;
  FCasualCache := nil;
end;

procedure TMCDesigner.BeforeDestruction;
begin
  FClasses.Free;
  inherited BeforeDestruction;
end;

function TMCDesigner.CreateObject(const IID: TGUID): TInterfacedObject;
var
  InterfacedClass: TInterfacedClass;
begin
  Result := nil;

  InterfacedClass := FindClass(IID);

  if InterfacedClass <> nil then
    Result := InterfacedClass.Create;
end;

function TMCDesigner.FindClass(const IID: TGUID): TInterfacedClass;
var
  I: Integer;
begin
  Result := nil;

  for I := 0 to Pred(Classes.Count) do
    if Classes[I].InheritsFrom(TInterfacedObject) then
    begin
      Result := TInterfacedClass(Classes[I]);

      if Supports(Result, IID) then
        Break;

      Result := nil;
    end;
end;

function TMCDesigner.GetCasualCache: IMCCasualCache;
begin
  if FCasualCache = nil then
    TMCCasualCache.Create.GetInterface(IMCCasualCache, FCasualCache);

  Result := FCasualCache;
end;

function TMCDesigner.GetClasses: TClassList;
begin
  Result := FClasses;
end;

function TMCDesigner.GetURL: string;
begin
  if FURL = '' then
    raise EMCException.Create('Адрес сервиса Медикард не установлен');

  Result := FURL;
end;

procedure TMCDesigner.HTTPCheckResult(const AResult: Integer);
var
  ErrorText: string;
begin
  ErrorText := '';

  if AResult <> 200 then
    ErrorText := Format('Ошибка выполнения запроса к сервису %s (%d)', [URL, AResult]);

  if ErrorText <> '' then
    raise EMCException.Create(ErrorText);
end;

function TMCDesigner.HTTPMethod(const AMethod, ABody: string; var AResponse: string): Integer;
var
  HTTP: THTTPSend;
  TryCount, TryIndex, TryTimeOut: Integer;
  Body, BodyBase64, Resp, RespBase64: TStringStream;
  S: AnsiString;
begin
  if Pos(AMethod, '#POST#') = 0 then
    raise EMCException.CreateFmt('HTTP метод "%s" не поддерживается.', [AMethod]);

  HTTP := THTTPSend.Create;
  Body := TStringStream.Create;
  Resp := TStringStream.Create;

  BodyBase64 := TStringStream.Create;
  RespBase64 := TStringStream.Create;

  Body.WriteString(ABody);
  Body.Position := 0;
  EncodeStream(Body, BodyBase64);
  Body.Clear;
  Body.WriteString('medicard=' + HTTPEncode(BodyBase64.DataString));

  TryCount   := 3;
  TryIndex   := 0;
  TryTimeOut := 1000;

  try
    repeat
      HTTP.Clear;
      HTTPSetHeader(HTTP);
      HTTP.Document.Write(Body.Memory^, Body.Size);
      HTTP.HTTPMethod(AMethod, URL);
      Result := HTTP.ResultCode;

      if (Result = 0) or (Result = 500) then
        Sleep(TryTimeOut);

      Inc(TryIndex);
    until ((Result <> 0) and (Result <> 500)) or (TryIndex >= TryCount);

    if Result = 200 then
    begin
      HTTP.Document.Position := 0;
      SetLength(S, HTTP.Document.Size);
      HTTP.Document.Read(Pointer(S)^, HTTP.Document.Size);
      RespBase64.WriteString(S);
      RespBase64.Position := 0;
      DecodeStream(RespBase64, Resp);
      AResponse := Resp.DataString;
    end else
      HTTPCheckResult(Result);
  finally
    RespBase64.Free;
    BodyBase64.Free;
    Resp.Free;
    Body.Free;
    HTTP.Free;
  end;
end;

function TMCDesigner.HTTPPost(const ABody: string; var AResponse: string): Integer;
begin
  Result := HTTPMethod('POST', ABody, AResponse);
end;

procedure TMCDesigner.HTTPSetHeader(AHTTP: THTTPSend);
begin
  AHTTP.MimeType := 'application/x-www-form-urlencoded';
end;

procedure TMCDesigner.RegisterClasses(AClasses: array of TInterfacedClass);
var
  I: Integer;
begin
  for I := Low(AClasses) to High(AClasses) do
    if Assigned(AClasses[I]) then
      Classes.Add(AClasses[I]);
end;

procedure TMCDesigner.SetURL(const Value: string);
begin
  FURL := Value;
end;

{ TMCCasualCache }

procedure TMCCasualCache.AfterConstruction;
begin
  inherited AfterConstruction;
  FCasualList := TObjectList.Create;
end;

procedure TMCCasualCache.BeforeDestruction;
begin
  FCasualList.Free;
  inherited BeforeDestruction;
end;

procedure TMCCasualCache.Clear;
begin
  FCasualList.Clear;
end;

procedure TMCCasualCache.Delete(AMorionCode: Integer);
var
  I, Res: Integer;
begin
  Res := -1;

  for I := 0 to Pred(FCasualList.Count) do
    if (FCasualList[I] as TMCCasualItem).MorionCode = AMorionCode then
    begin
      Res := I;
      Break;
    end;

  if Res <> -1 then
    FCasualList.Delete(Res);
end;

function TMCCasualCache.Find(AMorionCode: Integer): string;
var
  I: Integer;
  CasualItem: TMCCasualItem;
begin
  Result := '';

  for I := 0 to Pred(FCasualList.Count) do
  begin
    CasualItem := FCasualList[I] as TMCCasualItem;
    if CasualItem.MorionCode = AMorionCode then
    begin
      Result := CasualItem.Casual;
      Break;
    end;
  end;
end;

function TMCCasualCache.GenerateCasual: string;
var
  GUID: TGUID;
begin
  CreateGUID(GUID);
  Result := StringReplace(LowerCase(GUIDToString(GUID)), '-', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '{', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '}', '', [rfReplaceAll, rfIgnoreCase]);
end;

procedure TMCCasualCache.Save(AMorionCode: Integer; ACasual: string);
begin
  if (AMorionCode = 0) or (Trim(ACasual) = '') then
    raise EMCException.CreateFmt('Invalid data (MorionCode: %d, Casual: "%s")', [AMorionCode, ACasual]);

  Delete(AMorionCode);
  FCasualList.Add(TMCCasualItem.Create(AMorionCode, ACasual));
end;

{ TMCCasualItem }

constructor TMCCasualItem.Create(AMorionCode: Integer; ACasual: string);
begin
  inherited Create;
  FMorionCode := AMorionCode;
  FCasual := ACasual;
end;

function TMCCasualItem.GetCasual: string;
begin
  Result := FCasual;
end;

function TMCCasualItem.GetMorionCode: Integer;
begin
  Result := FMorionCode;
end;

initialization
  TMCDesigner.Create.GetInterface(IMCDesigner, MCDesigner);
finalization
  MCDesigner := nil;
end.
