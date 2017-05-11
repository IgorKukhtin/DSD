{***************************************************************************)
{ TMS FMX WebGMaps component                                                    }
{ for Delphi & C++Builder                                                   }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2012 - 2017                                        }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of the author.                                      }
{***************************************************************************}
unit FMX.TMSWebGMapsCommonFunctions;

interface

{$I TMSDEFS.INC}

{$IFNDEF FMXLIB}
{$HPPEMIT ''}
{$HPPEMIT '#pragma link "wininet.lib"'}
{$HPPEMIT ''}
{$ENDIF}

uses
  Classes
  {$IFNDEF FMXLIB}
  , Windows
  {$ENDIF}
  , FMX.Controls, SysUtils, FMX.Graphics, StrUtils
  {$IFDEF FMXLIB}
  , UITypes
  {$ENDIF}
{$IFDEF DELPHIXE_LVL}
{$IFDEF DELPHIXE6_LVL}
  , JSON
{$ELSE}
  , DBXJSON
{$ENDIF}
{$ENDIF}
  , FMX.TMSWebGMapsCommon;

type
  {$IFNDEF MSWINDOWS}
  AChar = #0..'ÿ';
  PAChar = ^AChar;
  AnsiChar = AChar;
  AnsiString = string;
  UTF8String = string;
  rawbytestring = string;
  {$ENDIF}

  TLocation = class(TPersistent)
  private
    FLatitude: double;
    FLongitude: double;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Latitude : double read FLatitude write FLatitude;
    property Longitude : double read FLongitude write FLongitude;
  end;

  TBounds = class(TPersistent)
  private
    FNorthEast: TLocation;
    FSouthWest: TLocation;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property NorthEast : TLocation read FNorthEast write FNorthEast;
    property SouthWest : TLocation read FSouthWest write FSouthWest;
  end;


  function URLEncode(const Url: String): String;
  function ColorToHTML(Color: TAlphaColor): String;
  {$IFNDEF FMXLIB}
  function HttpsGet(const Url: string): ansistring;
  {$ENDIF}
  function ConvertCoordinateToString(Coordinate: Double): String;
  function ConvertStringToCoordinate(Coordinate: String): Double;
  function Convert255To1(value: integer): string;
  {$IFDEF DELPHIXE_LVL}
  function GetJSONProp(O: TJSONOBject; ID: string): string;
  function GetJSONValue(O: TJSONObject; ID: string): TJSONValue;
  function GetJSONDouble(O: TJSONOBject; ID: string): double;
  function CleanUpJSON(Value: ansistring): ansistring;
  {$ENDIF}


implementation

{$IFDEF FMXLIB}
uses
  Character;
{$ENDIF}
{$IFNDEF FMXLIB}
uses
  WinInet
{$IFDEF DELPHIXE6_LVL}
  ,Character
{$ENDIF}
  ;
{$ENDIF}

{ TLocation }

procedure TLocation.Assign(Source: TPersistent);
begin
  if (Source is TLocation) then
  begin
    FLatitude := (Source as TLocation).Latitude;
    FLongitude := (Source as TLocation).Longitude;
  end;
end;

constructor TLocation.Create;
begin
  inherited;
  FLatitude := 0;
  FLongitude := 0;
end;

destructor TLocation.Destroy;
begin
  inherited;
end;

{ TBounds }

procedure TBounds.Assign(Source: TPersistent);
begin
  if (Source is TBounds) then
  begin
    FNorthEast.Assign((Source as TBounds).NorthEast);
    FSouthWest.Assign((Source as TBounds).SouthWest);
  end;
end;

constructor TBounds.Create;
begin
  inherited;
  FNorthEast := TLocation.Create;
  FSouthWest := TLocation.Create;
end;

destructor TBounds.Destroy;
begin
  FNorthEast.Free;
  FSouthWest.Free;
  inherited;
end;

{$IFNDEF FMXLIB}
function URLEncode(const Url: string): string;
var
  i: Integer;
  UrlA: ansistring;
  res: ansistring;
begin
  res := '';
  UrlA := ansistring(UTF8Encode(Url));

  for i := 1 to Length(UrlA) do
  begin
    case UrlA[i] of
      'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.':
        res := res + UrlA[i];
    else
        res := res + '%' + ansistring(IntToHex(Ord(UrlA[i]), 2));
    end;
  end;

  Result := string(res);
end;

function ColorToHTML(Color: Tcolor): String;
var
  ColorRGB:Integer;
begin
  ColorRGB:=ColorToRGB(Color);
  Result := Format('#%0.2X%0.2X%0.2X',
                   [GetRValue(ColorRGB),
                    GetGValue(ColorRGB),
                    GetBValue(ColorRGB)]);
end;

function HttpsGet(const Url: string): ansistring;
var
  NetHandle: HINTERNET;
  UrlHandle: HINTERNET;
  Buffer: array[0..1024] of AnsiChar;
  BytesRead: dWord;
  FAgent: string;
begin
  //Log('HTTPS GET: ' + URL);
  FAgent := 'Mozilla/5.001 (windows; U; NT4.0; en-US; rv:1.0) Gecko/25250101';
  Result := '';
  NetHandle := InternetOpen(PChar(FAgent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);

  if Assigned(NetHandle) then
  begin
    UrlHandle := InternetOpenUrl(NetHandle, PChar(Url), nil, 0, INTERNET_FLAG_RELOAD, 0);

    if Assigned(UrlHandle) then
    begin
      repeat
        BytesRead := 0;
        InternetReadFile(UrlHandle, @Buffer, SizeOf(Buffer) - 1, BytesRead);
        buffer[BytesRead] := #0;
        Result := Result + buffer;
      until (BytesRead = 0);
      InternetCloseHandle(UrlHandle);
    end
    else
      raise Exception.CreateFmt('Cannot open URL %s', [Url]);

    InternetCloseHandle(NetHandle);
  end
  else
    raise Exception.Create('Unable to initialize Wininet');
end;
{$ENDIF}

{$IFDEF FMXLIB}
function URLEncode(const Url: string): string;
var
  I: Integer;
  B: TBytes;
  {$IFDEF DELPHIXE6_LVL}
  a: array of Char;
  cu: Char;
  {$ENDIF}
  c: Char;
begin
  Result := '';
  B := TEncoding.UTF8.GetBytes(Url);
  {$IFDEF DELPHIXE6_LVL}
  SetLength(a, 36);
  for I := 0 to 25 do
    a[I] := Chr(65 + I);
  for I := 0 to 9 do
    a[I + 26] := Chr(48 + I);
  {$ENDIF}

  for I := Low(B) to High(B) do
  begin
    c := Chr(B[I]);
    {$IFDEF DELPHIXE6_LVL}
    cu := c.ToUpper;
    if cu.IsInArray(a) or c.IsInArray(['-','_','.']) then
    {$ELSE}
    if CharInSet(c , ['A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.']) then
    {$ENDIF}
      Result := Result + c
    else
      Result := Result + '%' + IntToHex(Ord(B[I]),2);
  end;
end;

function ColorToHTML(Color: TAlphaColor): String;
begin
  Result := Format('#%0.2X%0.2X%0.2X',
                   [TAlphaColorRec(Color).R,
                    TAlphaColorRec(Color).G,
                    TAlphaColorRec(Color).B]);
end;
{$ENDIF}

function ConvertCoordinateToString(Coordinate: Double): String;
begin
  Result := FloatToStr(Coordinate);
  Result := Replacetext(Result,',','.');
end;

function ConvertStringToCoordinate(Coordinate: String): Double;
begin
  {$IFDEF DELPHIXE_LVL}
  Coordinate := Replacetext(Coordinate,'.',FormatSettings.DecimalSeparator);
  {$ELSE}
  Coordinate := Replacetext(Coordinate,'.',DecimalSeparator);
  {$ENDIF}
  Result := StrToFloat(Coordinate);
end;

function Convert255To1(value: integer): string;
begin
  //convert from 0 -> 255 value to value between 0 -> 1
  {$IFDEF DELPHIXE_LVL}
  result := StringReplace(FloatToStr(Round((1 / 255) * value * 100) / 100), FormatSettings.DecimalSeparator, '.', [rfReplaceAll]);
  {$ELSE}
  result := StringReplace(FloatToStr(Round((1 / 255) * value * 100) / 100), DecimalSeparator, '.', [rfReplaceAll]);
  {$ENDIF}
end;

{$IFDEF DELPHIXE_LVL}

function GetJSONProp(O: TJSONOBject; ID: string): string;
var
  p: TJSONPair;
begin
  Result := '';
  p := o.Get(ID);
  if Assigned(p) then
    Result := p.JsonValue.Value;
end;

function GetJSONValue(O: TJSONObject; ID: string): TJSONValue;
var
  p: TJSONPair;
begin
  Result := nil;
  p := o.Get(ID);
  if Assigned(p) then
  begin
    Result := p.JsonValue;
  end;
end;

function CleanUpJSON(Value: ansistring): ansistring;
const
  JSONStart: ansistring = '{';
  JSONEnd: ansistring = '}';
var
  i: integer;
  res: ansistring;

begin
  res := Value;
  i := Pos(JSONStart,res);

  // trim first chars
  if i > 1 then
    System.Delete(res,1,i - 1);

  {$IFDEF DELPHI_LLVM}
  i := length(res) - 1;
  while (i > 0) and (res[i] <> JSONEnd) do
  begin
    dec(i);
  end;
  {$ELSE}
  i := length(res);
  while (i > 1) and (res[i] <> JSONEnd) do
  begin
    dec(i);
  end;
  {$ENDIF}

  System.Delete(res,i + 1, length(res) - i);

  Result := res;
end;

function FixupJSON(Value: ansistring): ansistring;
var
  i: integer;
begin
  Result := '';
  {$IFDEF DELPHI_LLVM}
  for i := 0 to Length(Value) - 1 do
  {$ELSE}
  for i := 1 to Length(Value) do
  {$ENDIF}
  begin
    if not ((Value[i]=#10) or (Value[i]=#13) or (Value[i]=#9)) then
      Result := Result + Value[i];
  end;
end;

function GetJSONDouble(O: TJSONOBject; ID: string): double;
var
  jv: TJSONValue;
begin
  jv := GetJSONValue(O,ID);
  if (jv is TJSONNumber) then
    Result := (jv as TJSONNumber).AsDouble
  else
    Result := 0;
end;

{$ENDIF}

end.
