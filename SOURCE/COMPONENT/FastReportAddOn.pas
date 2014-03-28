unit FastReportAddOn;

interface

uses Classes;

type
  TMyFunctions = class(TComponent);

procedure Register;

implementation

uses SysUtils, fs_iinterpreter;

procedure Register;
begin
  RegisterNoIcon([TMyFunctions]);
end;

type
  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass; const
MethodName: String; var Params: Variant): Variant;
  public
    constructor Create(AScript: TfsScript); override;
  end;

function SummaToText(n: Double): string;
const
ed1 : array[1..9] of string = ('одна','двi','три','чотири','п`€ть','шiсть','сiм','вiсiм','дев`€ть');
ed2 : array[1..2] of string = ('одна','двi');
des : array[1..18] of string =
      ('дес€ть','одиннадц€ть','дванадц€ть','тринадц€ть','чотирнадц€ть',
       'п`€тнадц€ть','шiстнадц€ть','сiмнадц€ть','вiсiмнадц€ть',
       'дев`€тнадц€ть','двадц€ть','тридц€ть','сорок','п`€тдес€т',
       'шiстдес€т','сiмдес€т','вiсiмдес€т','дев`€носто');
sot : array[1..9] of string = ('сто','двiстi','триста','чотириста','п`€тсот', 'шiстсот','сiмсот','вiсiмсот','дев`€тсот');
tis1 : array[1..4] of string = ('тис€ча','мiлiон'  ,'мiлiард'  ,'трилiон'  );
tis2 : array[1..4] of string = ('тис€ч' ,'мiлiонiв','мiлiардiв','трилiонiв');
tis3 : array[1..4] of string = ('тис€чi','мiлiона' ,'мiлiарда' ,'трилiона' );

{ed1 : array[1..9] of string = ('одна','две','три','четыре','п€ть','шесть','семь','восемь','дев€ть');
ed2 : array[1..2] of string = ('одна','две');
des : array[1..18] of string =
      ('дес€ть','одиннадцать','двенадцать','тринадцать','четырнадцать',
       'п€тнадцать','шестнадцать','семнадцать','восемнадцать',
       'дев€тнадцать','двадцать','тридцать','сорок','п€тьдес€т',
       'шестьдес€т','семдес€т','восемдес€т','дев€носто');
sot : array[1..9] of string = ('сто','двести','триста','четыреста','п€тьсот', 'шестьсот','семсот','восемсот','дев€тсот');
tis1 : array[1..4] of string = ('тыс€ча','милион'  ,'милиард'  ,'трилион'  );
tis2 : array[1..4] of string = ('тыс€ч' ,'милионов','милиардов','трилионов');
tis3 : array[1..4] of string = ('тыс€чи','милиона' ,'милиарда' ,'трилиона' );
}
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++}
  function _3toScript(n : Word; male : Boolean) : String;
  var _1, _2, _3 : Word;
  begin
    Result:= '';
    if n = 0 then begin
      Result:= ' '; exit;
    end;
    _1:= n div 100; if _1 <> 0 then Result:= sot[_1]+' ';
    _2:= (n mod 100) div 10;
    if _2 >= 2 then
      Result:= Result+des[9+_2]+' '
    else
      if _2 = 1 then begin
        _2:= n mod 100;
        Result:= Result+des[_2-9]+' '; exit;
      end;
    _3:= (n mod 100) mod 10;
    if _3 = 0 then
      exit;
    if (_3 <= 2) and not male then
      Result:= Result+ed2[_3]+' '
    else
      Result:= Result+ed1[_3]+' ';
  end;
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++}
var Male : Boolean;
    tmp, LastDig, _2dig : Word;
    Count : Byte;
    Str : String;
    TmpInt:String;
    SavTmp: Double;
begin
  TmpInt:=IntTostr(Trunc(n));
  SavTmp:=n;
  n:= Int(n); Result:= ''; Str:= ''; Count:= 0;
  while n > 0.1
    do begin
      Inc(Count);
      if Count = 2 then
        Male:= False
      else Male:= True;
        tmp:= Round(Frac(n/1000)*1000); n:= Int(n/1000);
        LastDig:= tmp mod 10; _2dig:= tmp mod 100;
        if Count >= 2 then
          if (_2dig >= 11) and (_2dig <= 19)  then
            Str:= tis2[Count-1]
          else
            if LastDig = 1 then
              Str:= tis1[Count-1]
            else
              if (LastDig >= 2) and (LastDig <= 4)  then
                Str:= tis3[Count-1]
              else
                Str:= tis2[Count-1];
         Result:= _3toScript(tmp, Male)+Str+' '+Result;
       end;
     if TmpInt = '0' then
        Result := 'ноль ';
    Result := Result+'грн.';
    Result[1] := AnsiUpperCase(Result[1])[1];
    Result := Result + ' ' + FormatFloat('00', Round(Frac(SavTmp)*100 ))+' коп.';
end;

function SummaToTextRu(n: Double): string;
const
{ed1 : array[1..9] of string = ('одна','двi','три','чотири','п`€ть','шiсть','сiм','вiсiм','дев`€ть');
ed2 : array[1..2] of string = ('одна','двi');
des : array[1..18] of string =
      ('дес€ть','одиннадц€ть','дванадц€ть','тринадц€ть','чотирнадц€ть',
       'п`€тнадц€ть','шiстнадц€ть','сiмнадц€ть','вiсiмнадц€ть',
       'дев`€тнадц€ть','двадц€ть','тридц€ть','сорок','п`€тдес€т',
       'шiстдес€т','сiмдес€т','вiсiмдес€т','дев`€носто');
sot : array[1..9] of string = ('сто','двiстi','триста','чотириста','п`€тсот', 'шiстсот','сiмсот','вiсiмсот','дев`€тсот');
tis1 : array[1..4] of string = ('тис€ча','мiлiон'  ,'мiлiард'  ,'трилiон'  );
tis2 : array[1..4] of string = ('тис€ч' ,'мiлiонiв','мiлiардiв','трилiонiв');
tis3 : array[1..4] of string = ('тис€чi','мiлiона' ,'мiлiарда' ,'трилiона' );}
ed1 : array[1..9] of string = ('одна','две','три','четыре','п€ть','шесть','семь','восемь','дев€ть');
ed2 : array[1..2] of string = ('одна','две');
des : array[1..18] of string =
      ('дес€ть','одиннадцать','двенадцать','тринадцать','четырнадцать',
       'п€тнадцать','шестнадцать','семнадцать','восемнадцать',
       'дев€тнадцать','двадцать','тридцать','сорок','п€тьдес€т',
       'шестьдес€т','семдес€т','восемдес€т','дев€носто');
sot : array[1..9] of string = ('сто','двести','триста','четыреста','п€тьсот', 'шестьсот','семсот','восемсот','дев€тсот');
tis1 : array[1..4] of string = ('тыс€ча','милион'  ,'милиард'  ,'трилион'  );
tis2 : array[1..4] of string = ('тыс€ч' ,'милионов','милиардов','трилионов');
tis3 : array[1..4] of string = ('тыс€чи','милиона' ,'милиарда' ,'трилиона' );

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++}
  function _3toScript(n : Word; male : Boolean) : String;
  var _1, _2, _3 : Word;
  begin
    Result:= '';
    if n = 0 then begin
      Result:= ' '; exit;
    end;
    _1:= n div 100; if _1 <> 0 then Result:= sot[_1]+' ';
    _2:= (n mod 100) div 10;
    if _2 >= 2 then
      Result:= Result+des[9+_2]+' '
    else
      if _2 = 1 then begin
        _2:= n mod 100;
        Result:= Result+des[_2-9]+' '; exit;
      end;
    _3:= (n mod 100) mod 10;
    if _3 = 0 then
      exit;
    if (_3 <= 2) and not male then
      Result:= Result+ed2[_3]+' '
    else
      Result:= Result+ed1[_3]+' ';
  end;
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++}
var Male : Boolean;
    tmp, LastDig, _2dig : Word;
    Count : Byte;
    Str : String;
    TmpInt:String;
    SavTmp: Double;
begin
  TmpInt:=IntTostr(Trunc(n));
  SavTmp:=n;
  n:= Int(n); Result:= ''; Str:= ''; Count:= 0;
  while n > 0.1
    do begin
      Inc(Count);
      if Count = 2 then
        Male:= False
      else Male:= True;
        tmp:= Round(Frac(n/1000)*1000); n:= Int(n/1000);
        LastDig:= tmp mod 10; _2dig:= tmp mod 100;
        if Count >= 2 then
          if (_2dig >= 11) and (_2dig <= 19)  then
            Str:= tis2[Count-1]
          else
            if LastDig = 1 then
              Str:= tis1[Count-1]
            else
              if (LastDig >= 2) and (LastDig <= 4)  then
                Str:= tis3[Count-1]
              else
                Str:= tis2[Count-1];
         Result:= _3toScript(tmp, Male)+Str+' '+Result;
       end;
     if TmpInt = '0' then
        Result := 'ноль ';
    Result := Result+'грн.';
    Result[1] := AnsiUpperCase(Result[1])[1];
    Result := Result + ' ' + FormatFloat('00', Round(Frac(SavTmp)*100 ))+' коп.';
end;

{ TFunctions }
constructor TFunctions.Create;
begin
  inherited Create(AScript);
  with AScript do
  begin
    AddMethod('function SummaToText(Money: Double): String',
              CallMethod, 'ћои функции', '—умма прописью укр');
    AddMethod('function SummaToTextRu(Money: Double): String',
              CallMethod, 'ћои функции', '—умма прописью рус');

  end;
end;
function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
const MethodName: String; var Params: Variant): Variant;
begin
  if MethodName = 'SUMMATOTEXT' then
    Result := SummaToText(Params[0])
  if MethodName = 'SUMMATOTEXTRU' then
    Result := SummaToTextRu(Params[0])

end;
initialization
  fsRTTIModules.Add(TFunctions);
end.

