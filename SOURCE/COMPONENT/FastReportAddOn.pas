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

function SummaCurToTextRu(n: Double; curr:string): string;
const m1: array [1..9] of string
      =('один ','два ','три ','четыре ','п€ть ','шесть ','семь ','восемь ','дев€ть ');
const f1: array [1..9] of string
      =('одна ','две ','три ','четыре ','п€ть ','шесть ','семь ','восемь ','дев€ть ');
const n10: array [1..9] of string
      =('дес€ть ','двадцать ','тридцать ','сорок ','п€тьдес€т ','шестьдес€т ',
       'семьдес€т ','восемьдес€т ','дев€носто ');
const first10: array [11..19] of string
      =('одиннадцать ','двенадцать ','тринадцать ','четырнадцать ','п€тнадцать ',
        'шестнадцать ','семнадцать ','восемнадцать ','дев€тнадцать ');
const n100: array [1..9] of string
      = ('сто ','двести ','триста ', 'четыреста ','п€тьсот ','шестьсот ','семьсот ',
         'восемьсот ','дев€тьсот ');
const kop: array [1..3] of string = ('копейка','копейки','копеек');
      rub: array [1..3] of string = ('рубль ','рубл€ ','рублей ');
      tsd: array [1..3] of string = ('тыс€ча ','тыс€чи ','тыс€ч ');
      mln: array [1..3] of string = ('миллион ','миллиона ','миллионов ');
      mrd: array [1..3] of string = ('миллиapд ','миллиаpдa ','миллиapдoв ');
      trl: array [1..3] of string = ('триллион ','триллионa ','триллионoв ');
      cnt: array [1..3] of string = ('тыс€ча ','тыс€чи ','тыс€ч ');

const cent: array [1..3] of string = ('цент','цента','центов');
      doll: array [1..3] of string = ('доллар ','доллара ','долларов ');
{-----------------------------------------------------------------------------}
function Triada(I,n:Integer;k:boolean;usd:boolean):string;
var a,gender,sfx:integer;
begin
  Result:='';
  sfx:=3;
  if n=2 then gender:=0 else gender:=1;

  a:= I div 100;
  if (a>0)
  then begin
         Result:=Result+n100[a];
         I:=I-a*100;
       end;

  if (I>19)
  then begin
         a:= I div 10;
         if (a>0)
         then begin
                Result:=Result+n10[a];
                I:=I-a*10;
                if I>0 then
                  begin
                    if k then gender:=0;
                    if gender=1 then Result:=Result+m1[I]
                                else Result:=Result+f1[I];
                    case I of
                        1: sfx:=1;
                     2..4: sfx:=2;
                     5..9: sfx:=3;
                    end;
                  end;
              end;
       end
  else begin
         case I of
            1:begin
                if k then gender:=0;
                if gender=1 then Result:=Result+m1[I]
                            else Result:=Result+f1[I];
                sfx:=1;
              end;
         2..4:begin
                if k then gender:=0;
                if gender=1 then Result:=Result+m1[I]
                            else Result:=Result+f1[I];
                sfx:=2;
              end;
         5..9:begin
                if k then gender:=0;
                if gender=1 then Result:=Result+m1[I]
                            else Result:=Result+f1[I];
                sfx:=3;
              end;
           10:begin
                Result:=Result+n10[1];
                sfx:=3;
              end;
       11..19:begin
                Result:=Result+first10[I];
                sfx:=3;
              end;
         end;
       end;
  case n of
    1: if not k then
         if usd then
           result:=result+doll[sfx]
          else
           Result:=Result+rub[sfx]
        else
         if usd then
           result:=result+cent[sfx]
          else
           Result:=Result+kop[sfx];
    2: if not k then
         Result:=Result+tsd[sfx]
        else
         if usd then
           result:=result+cent[sfx]
          else
           Result:=Result+kop[sfx];
    3: if not k then
         Result:=Result+mln[sfx]
        else
         if usd then
           result:=result+cent[sfx]
          else
           Result:=Result+kop[sfx];
    4: if not k then
         Result:=Result+mrd[sfx]
        else
         if usd then
           result:=result+cent[sfx]
          else
           Result:=Result+kop[sfx];
    5: if not k then
         Result:=Result+trl[sfx]
        else
         if usd then
           result:=result+cent[sfx]
          else
           Result:=Result+kop[sfx];
  end;
end; // function Triada(I,n:Integer;k:boolean;usd:boolean):string;

function TriadaK(I:integer;kpk:boolean;usd:boolean):string;
var sfx,H:integer;
begin
  if kpk then
    begin
      Result:='';
      sfx:=3;
      H:=(I mod 10);
      case H of
           1: sfx:=1;
        2..4: sfx:=2;
      end;
      if (I in [11..19]) then sfx:=3;
      if usd then
        begin
          if I<10 then Result:='0'+IntToStr(I)+' '+cent[sfx]
                  else Result:=IntToStr(I)+' '+cent[sfx];
        end
      else
        begin
          if I<10 then Result:='0'+IntToStr(I)+' '+kop[sfx]
                  else Result:=IntToStr(I)+' '+kop[sfx];
        end;
    end
  else
    begin
      if i=0 then
        if usd then
          result:='00 центов —Ўј'
         else
          result:='00 копеек'
       else
        result:=triada(i,1,true,usd);
    end;
end; // function TriadaK(I:integer;kpk:boolean;usd:boolean):string;
function MoneyToString(S:Currency; kpk:boolean; usd:boolean):string;
var I,H:LongInt;
    V:string;
    f,l:String;
    s1:Currency;
    dH: Currency;
begin
  V:='';
  s1:=S;

  dH:=1e12;
  I:=Trunc(S/dH);
  if (I>0)
  then begin
         V:=Triada(I,5,false,usd);
         S:=S-Trunc(S/dH)*dH;
       end;

  dH:=1000000000;
  I:=Trunc(S/dH);
  if (I>0)
  then begin
         V:=V+Triada(I,4,false,usd);
         S:=S-Trunc(S/dH)*dH;
       end;

  H:=1000000;
  I:=Trunc(S/H);
  if (I>0)
  then begin
         V:=V+Triada(I,3,false,usd);
         S:=S-Trunc(S/H)*H;
       end;

  H:=1000;
  I:=Trunc(S/H);
  if (I>0)
  then begin
         V:=V+Triada(I,2,false,usd);
         S:=S-Trunc(S/H)*H;
       end;

  H:=1;
  I:=Trunc(S/H);
  if (I>0)
  then begin
       V:=V+Triada(I,1,false,usd);
       S:=S-Trunc(S/H)*H;
       end
  else
   if usd then
    v:=v+doll[3]
   else
    V:=V+rub[3];

  I:=Trunc(S*100);
  V:=V+TriadaK(I,kpk,usd);
  if s1 < 1 then  V:='ноль '+V;
  f:=AnsiUpperCase(Copy(V,1,1));
  l:=Copy(V,2,256);
  V:=f+l;
  Result:=V;
end; // function MoneyToString(S:Currency; kpk:boolean; usd:boolean):string;

{------------------------------------------------------------------------------}
begin
    if Curr = 'USD' then
     Result := MoneyToString(n, true, true)
    else if Curr = 'RUR' then
     Result := MoneyToString(n, true, false)
    else if Curr = 'UAH' then
     Result := SummaToTextRu(n);

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
    AddMethod('function SummaCurToTextRu(Money: Double, Curr: String): String',
              CallMethod, 'ћои функции', '—умма вал прописью рус');

  end;
end;
function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
const MethodName: String; var Params: Variant): Variant;
begin
  if MethodName = 'SUMMATOTEXT' then
    Result := SummaToText(Params[0]);
  if MethodName = 'SUMMATOTEXTRU' then
    Result := SummaToTextRu(Params[0]);
  if MethodName = 'SUMMACURTOTEXTRU' then
    Result := SummaCurToTextRu(Params[0], Params[1]);

end;
initialization
  fsRTTIModules.Add(TFunctions);
end.

