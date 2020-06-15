unit UCommon;

interface
  // ф-ии чтения атрибутов из XML
  function getStr(const AttrValue: OleVariant): string; overload;
  function getStr(const AttrValue: OleVariant; const ADefValue: string): string; overload;
  function getInt(const AttrValue: OleVariant; const ADefValue: Integer): Integer;
  function getFloat(const AttrValue: OleVariant; const ADefValue: Extended): Extended;


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

end.
