{###############################################################################
                      https://github.com/wendelb/DelphiOTP
###############################################################################}
unit GoogleOTP;

interface

uses
  System.SysUtils, System.Math, System.DateUtils, IdGlobal, IdHMACSHA1;

(*

Test Case for the CalculateOTP function
---------------------------------------

Init key: AAAAAAAAAAAAAAAAAAAA
Timestamp: 1
BinCounter: 0000000000000001 (HEX-Representation)
Hash: eeb00b0bcc864679ff2d8dd30bec495cb5f2ee9e (HEX-Representation)
Offset: 14
Part 1: 73
Part 2: 92
Part 3: 181
Part 4: 242
One time password: 812658

Easy Display: Format('%.6d', [CalculateOTP(SECRET)]);
*)

function CalculateOTP(const Secret: String; const DateTime : TDateTime = 0; const Counter: Integer = -1): Integer;
function ValidateTOPT(const Secret: String; const Token: Integer; const DateTime : TDateTime = 0; const WindowSize: Integer = 4): Boolean;
function GenerateOTPSecret(len: Integer = -1): String;

implementation

Type
  OTPBytes = TIdBytes;

const
  otpLength = 6;
  keyRegeneration = 30;
  SecretLengthDef = 20;
  ValidChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

function Base32Decode(const source: String): String;
var
  UpperSource: String;
  p, i, l, n, j: Integer;
begin
  UpperSource := UpperCase(source);

  l := Length(source);
  n := 0; j := 0;
  Result := '';

  for i := 1 to l do
  begin
    n := n shl 5; 				// Move buffer left by 5 to make room

    p := Pos(UpperSource[i], ValidChars);
    if p >= 0 then
      n := n + (p - 1);         // Add value into buffer

		j := j + 5;				// Keep track of number of bits in buffer

    if (j >= 8) then
    begin
      j := j - 8;
      Result := Result + chr((n AND ($FF shl j)) shr j);
    end;
  end;
end;

function Base32Encode(source: string): string;
var
  i: integer;
  nr: int64;
begin
  result := '';
  while length(source) > 0 do
  begin
    nr := 0;
    for i := 1 to 5 do
    begin
      nr := (nr shl 8);
      if length(source)>=i then
        nr := nr + byte(source[i]);
    end;
    for i := 7 downto 0 do
      if ((length(source)<2) and (i<6)) or
         ((length(source)<3) and (i<4)) or
         ((length(source)<4) and (i<3)) or
         ((length(source)<5) and (i<1)) then
      result := result + '='
    else
      result := result + ValidChars[((nr shr (i*5)) and $1F)+1];
    delete(source, 1, 5);
  end;
end;

/// <summary>
///   Sign the Buffer with the given Key
/// </summary>
function HMACSHA1(const _Key: OTPBytes; const Buffer: OTPBytes): OTPBytes;
begin
  with TIdHMACSHA1.Create do
  begin
    Key := _Key;
    Result := HashValue(Buffer);
    Free;
  end;
end;

/// <summary>
///   Reverses TIdBytes (from low->high to high->low)
/// </summary>
function ReverseIdBytes(const inBytes: OTPBytes): OTPBytes;
var
  i: Integer;
begin
  //Result := [];
  SetLength(Result, Length(inBytes));
  for i := Low(inBytes) to High(inBytes) do
    Result[High(inBytes) - i] := inBytes[i];
end;

/// <summary>
///   My own ToBytes function. Something in the original one isn't working as expected.
/// </summary>
function StrToIdBytes(const inString: String): OTPBytes;
var
  ch: Char;
  i: Integer;
begin
  //Result := [];
  SetLength(Result, Length(inString));

  i := 0;
  for ch in inString do
  begin
    Result[i] := Ord(ch);
    inc(i);
  end;
end;

function CalculateOTP(const Secret: String; const DateTime : TDateTime = 0; const Counter: Integer = -1): Integer;
var
  BinSecret: String;
  Hash: String;
  Offset: Integer;
  Part1, Part2, Part3, Part4: Integer;
  Key: Integer;
  Time: Integer;
begin

  if Counter <> -1 then
    Time := Counter
  else
  if DateTime <> 0 then
    Time := DateTimeToUnix(DateTime) div keyRegeneration
  else
    Time := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now)) div keyRegeneration;

  BinSecret := Base32Decode(Secret);
  Hash := BytesToStringRaw(HMACSHA1(StrToIdBytes(BinSecret), ReverseIdBytes(ToBytes(Int64(Time)))));

  Offset := (ord(Hash[20]) AND $0F) + 1;
  Part1 := (ord(Hash[Offset+0]) AND $7F);
  Part2 := (ord(Hash[Offset+1]) AND $FF);
  Part3 := (ord(Hash[Offset+2]) AND $FF);
  Part4 := (ord(Hash[Offset+3]) AND $FF);

  Key := (Part1 shl 24) OR (Part2 shl 16) OR (Part3 shl 8) OR (Part4);
  Result := Key mod Trunc(IntPower(10, otpLength));
end;

function ValidateTOPT(const Secret: String; const Token: Integer; const DateTime : TDateTime = 0; const WindowSize: Integer = 4): Boolean;
var
  TimeStamp: Integer;
  TestValue: Integer;
begin
  Result := false;

  if DateTime <> 0 then
    TimeStamp := DateTimeToUnix(DateTime) div keyRegeneration
  else
    TimeStamp := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now)) div keyRegeneration;

  for TestValue  := Timestamp - WindowSize to TimeStamp + WindowSize do
  begin
    if (CalculateOTP(Secret, DateTime, TestValue) = Token) then
      Result := true;
  end;
end;

function GenerateOTPSecret(len: Integer = -1): String;
var
  i : integer;
  ValCharLen : integer;
begin
  Result := '';
  ValCharLen := Length(ValidChars);

  if (len < 1) then
    len := SecretLengthDef;

  for i := 1 to len do
  begin
    Result := Result + copy(ValidChars, Random(ValCharLen) + 1, 1);
  end;

  Result := Base32Encode(Result);

end;

end.
