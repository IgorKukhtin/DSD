unit MainCash2;

interface

uses System.SysUtils, dsdDB;

type

TMainCash = class(TObject)
  FormParams: TdsdFormParams;
end;

function GetPrice(Price, Discount: Currency): Currency;
function GetSumm(Amount, Price: Currency; Down: Boolean): Currency;
function GetSummFull(Amount, Price: Currency): Currency;

var MainCashForm : TMainCash;

implementation

function GetPrice(Price, Discount: Currency): Currency;
var
  D, P, RI: Int64;
  S1: String;
begin
  if (Price = 0) then
  Begin
    Result := 0;
    exit;
  End;
  D := trunc(Discount * 100);
  P := trunc(Price * 100);
  RI := P * (10000 - D);
  S1 := IntToStr(RI);
  if Length(S1) < 5 then
    RI := 0
  else
    RI := StrToInt(Copy(S1, 1, Length(S1) - 4));
  if (Length(S1) >= 4) AND (StrToInt(S1[Length(S1) - 3]) >= 5) then
    RI := RI + 1;
  Result := (RI / 100);
end;

function GetSumm(Amount, Price: Currency; Down: Boolean): Currency;
var
  A, P, RI: Int64;
  S1: String;
begin
  if (Amount = 0) or (Price = 0) then
  Begin
    Result := 0;
    exit;
  End;
  A := trunc(Amount * 1000);
  P := trunc(Price * 100);
  RI := A * P;
  S1 := IntToStr(RI);
  if Down then
  begin
    if Length(S1) <= 4 then
      RI := 0
    else
      RI := StrToInt(Copy(S1, 1, Length(S1) - 4));
    Result := (RI / 10);
  end
  else
  begin
    if Length(S1) <= 4 then
      RI := 0
    else
      RI := StrToInt(Copy(S1, 1, Length(S1) - 4));
    if (Length(S1) >= 4) AND (StrToInt(S1[Length(S1) - 3]) >= 5) then
      RI := RI + 1;
    Result := (RI / 10);
  end;
end;

function GetSummFull(Amount, Price: Currency): Currency;
var
  A, P, RI: Int64;
  S1: String;
begin
  if (Amount = 0) or (Price = 0) then
  Begin
    Result := 0;
    exit;
  End;
  A := trunc(Amount * 1000);
  P := trunc(Price * 100);
  RI := A * P;
  S1 := IntToStr(RI);
  if Length(S1) < 4 then
    RI := 0
  else
    RI := StrToInt(Copy(S1, 1, Length(S1) - 3));
  if (Length(S1) >= 3) AND (StrToInt(S1[Length(S1) - 2]) >= 5) then
    RI := RI + 1;
  Result := (RI / 100);
end;


end.
