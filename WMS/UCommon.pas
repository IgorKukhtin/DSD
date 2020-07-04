unit UCommon;

interface

uses
  Vcl.Forms, Winapi.Windows;

  // ф-ии чтения атрибутов из XML
  function getStr(const AttrValue: OleVariant): string; overload;
  function getStr(const AttrValue: OleVariant; const ADefValue: string): string; overload;
  function getInt(const AttrValue: OleVariant; const ADefValue: Integer): Integer;
  function getFloat(const AttrValue: OleVariant; const ADefValue: Extended): Extended;

  // ф-ия позволяет исключить стандартные слова из текста сообщения об ошибке, например, "[FireDAC][Phys][PG][libpq]"
  function SkipSystemErrWords(const AErrMessage: string): string;

  function Coalesce(AValue1, AValue2: Variant): Variant;
  procedure WaitFor(const AInterval: Cardinal; const aWaitCondition: Boolean = True);
  function IsService: Boolean;

  // ф-ии TDateTime
  function TodayNearMidnight: TDateTime;
  function NearMidnight(const ADate: TDateTime): TDateTime;

implementation

uses
  System.Variants,
  System.SysUtils,
  UConstants;

function getFloat(const AttrValue: OleVariant; const ADefValue: Extended): Extended;
var
  tmpSettings: TFormatSettings;
  sValue: string;
begin
  if VarIsNull(AttrValue) then
    Exit(cErrXmlAttributeNotExists);

  tmpSettings := TFormatSettings.Create;
  sValue := AttrValue;

  if Pos('.', sValue) = 1 then // .044
   sValue := '0' + sValue;

  if tmpSettings.DecimalSeparator = ',' then
    sValue := StringReplace(sValue, '.', ',', []);

  Result := StrToFloatDef(sValue, ADefValue);
end;

function getInt(const AttrValue: OleVariant; const ADefValue: Integer): Integer;
begin
  if VarIsNull(AttrValue) then
    Exit(cErrXmlAttributeNotExists);

  Result := StrToIntDef(AttrValue, ADefValue);
end;

function getStr(const AttrValue: OleVariant; const ADefValue: string): string;
begin
  if not VarIsNull(AttrValue) then
    Result := AttrValue
  else
    Result := ADefValue;
end;

function getStr(const AttrValue: OleVariant): string;
begin
  if not VarIsNull(AttrValue) then
    Result := AttrValue
  else
    Result := cErrStrXmlAttributeNotExists;
end;

procedure WaitFor(const AInterval: Cardinal; const aWaitCondition: Boolean);
var
  crdStart: Cardinal;
begin
  crdStart := GetTickCount;

  while ((GetTickCount - crdStart) < AInterval) and aWaitCondition do
    Application.ProcessMessages;
end;

function IsService: Boolean;
var
  C: Cardinal;
  Data: USEROBJECTFLAGS;
begin
  GetUserObjectInformation(GetProcessWindowStation, UOI_FLAGS, @Data, SizeOf(Data), C);
  Result := (Data.dwFlags and WSF_VISIBLE <> WSF_VISIBLE)
  or FindCmdLineSwitch('INSTALL', ['-', '/'], True)
  or FindCmdLineSwitch('UNINSTALL', ['-', '/'], True);
end;

function TodayNearMidnight: TDateTime;
begin
  Result := Date + 1 - c1SecDate;
end;

function NearMidnight(const ADate: TDateTime): TDateTime;
var
  extDate: Extended;
begin
  extDate := Int(ADate);
  Result  := extDate + 1 - c1SecDate;
end;

function Coalesce(AValue1, AValue2: Variant): Variant;
begin
  Result := AValue1;

  if VarIsNull(AValue1) then Result := AValue2;
end;

function SkipSystemErrWords(const AErrMessage: string): string;
var
  I: Integer;
begin
  Result := AErrMessage;

  for I := Low(cSystemErrWords) to High(cSystemErrWords) do
    Result := StringReplace(Result, cSystemErrWords[I], EmptyStr, [rfIgnoreCase, rfReplaceAll]);
end;

end.
