unit MediCard.Dsgn;

interface

uses
  System.Contnrs, System.SysUtils, System.Classes, Soap.EncdDecd, Web.HTTPApp,
  httpsend,
  MediCard.Intf;

type
  TMCDesigner = class(TInterfacedObject, IMCDesigner)
  private
    FClasses: TClassList;
    function GetClasses: TClassList;

    procedure HTTPSetHeader(AHTTP: THTTPSend);
    procedure HTTPCheckResult(const AResult: Integer; AURL: string);
    function HTTPMethod(const AMethod, AURL, ABody: string; var AResponse: string): Integer;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    procedure RegisterClasses(AClasses: array of TInterfacedClass);
    function FindClass(const IID: TGUID): TInterfacedClass;
    function CreateObject(const IID: TGUID): TInterfacedObject; overload;

    function HTTPPost(const AURL, ABody: string; var AResponse: string): Integer;

    property Classes: TClassList read GetClasses;
  end;

implementation

{ TMCDesigner }

procedure TMCDesigner.AfterConstruction;
begin
  inherited AfterConstruction;
  FClasses := TClassList.Create;
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

function TMCDesigner.GetClasses: TClassList;
begin
  Result := FClasses;
end;

procedure TMCDesigner.HTTPCheckResult(const AResult: Integer; AURL: string);
var
  ErrorText: string;
begin
  ErrorText := '';

  if AResult <> 200 then
    ErrorText := Format('Ошибка выполнения запроса к сервису %s (%d)', [AURL, AResult]);

  if ErrorText <> '' then
    raise EMCException.Create(ErrorText);
end;

function TMCDesigner.HTTPMethod(const AMethod, AURL, ABody: string; var AResponse: string): Integer;
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
      HTTP.HTTPMethod(AMethod, AURL);
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
      HTTPCheckResult(Result, AURL);
  finally
    RespBase64.Free;
    BodyBase64.Free;
    Resp.Free;
    Body.Free;
    HTTP.Free;
  end;
end;

function TMCDesigner.HTTPPost(const AURL, ABody: string; var AResponse: string): Integer;
begin
  Result := HTTPMethod('POST', AURL, ABody, AResponse);
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

initialization
  TMCDesigner.Create.GetInterface(IMCDesigner, MCDesigner);
finalization
  MCDesigner := nil;
end.
