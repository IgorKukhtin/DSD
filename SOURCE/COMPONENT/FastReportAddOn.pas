unit FastReportAddOn;

interface


{Принимает число, род существительного, и три формы,
например male, рубль, рубля, рублей. Возвращает число прописью}
//function SpellNumber(n:Int64; g:gender; wrd:wordForms):String;

{Принимает сумму цифрами, вид валюты и необязательный параметр писать ли с большой буквы,
по умолчанию не писать
TStas}
//function CurrencyToStr(x:Currency; d:denezhka; mode:Boolean=true):String;


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
  gender = (male, fimale, gay); //Род существительного
  wordForms = Array[1..3] of String[20];
  denezhka = (RUR, USD, EUR);

    digit = 0..9;
    plur = 1..3;
    thousand = 0..999;
    razr = record
      wrd:wordForms; //Формы слова
      gend:gender; //род слова
    end;
    money = record
      rublik:razr;
      kopeechka:wordForms;
    end;

  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass; const
MethodName: String; var Params: Variant): Variant;
  public
    constructor Create(AScript: TfsScript); override;
  end;

const
  handrids:Array[0..9] of String[10] = ('', 'сто', 'двести', 'триста', 'четыреста', 'пятьсот', 'шестьсот', 'семьсот', 'восемьсот', 'девятьсот');
  tens:Array[2..9] of String[15] = ('двадцать', 'тридцать', 'сорок', 'пятьдесят', 'шестьдесят', 'семьдесят', 'восемьдесят', 'девяносто');
  teens:Array[0..9] of String[15] = ('десять', 'одиннадцать', 'двенадцать', 'тринадцать', 'четырнадцать', 'пятнадцать', 'шестнадцать', 'семнадцать', 'восемнадцать', 'девятнадцать');
  units:Array[3..9] of String[10] = ('три', 'четыре', 'пять', 'шесть', 'семь', 'восемь', 'девять');

  tys:razr = (wrd:('тысяча', 'тысячи', 'тысяч'); gend:fimale);
  mln:razr = (wrd:('миллион', 'миллиона', 'миллионов'); gend:male);
  mlrd:razr = (wrd:('миллиард', 'миллиарда', 'миллиардов'); gend:male);
  trln:razr = (wrd:('триллион', 'триллиона', 'триллионов'); gend:male);
  quln:razr = (wrd:('квадриллион', 'квадриллиона', 'квадриллионов'); gend:male);

  rup:razr = (wrd:('рубль', 'рубля', 'рублей'); gend:male);
  buck:razr = (wrd:('доллар', 'доллара', 'долларов'); gend:male);
  evrik:razr = (wrd:('евро', 'евро', 'евро'); gend:gay);

  kopek:wordForms = ('копейка', 'копейки', 'копеек');
  cent:wordForms = ('цент', 'цента', 'центов');





//-------------------------------------------------------------Сумма Евро
function GetUnitString(n:digit; x:gender):String;
begin
case n of
0: Result:='';
1:
  begin
  case x of
    male: Result:='один';
    gay: Result:='одно';
    fimale: Result:='одна';
    end;
  end;
2:
  begin
  case x of
    male: Result:='два';
    gay: Result:='два';
    fimale: Result:='две';
    end;
  end;
else Result:=units[n]
end; //of case
end;

function GetPlur(n:Byte):plur;
var
  n1, n10:digit;
begin
n:=n mod 100;
n1:=n mod 10;
n:=n div 10;
if n10=1 then Result:=3
else //Если дворой разряд не 1
  begin
  case n1 of
  1: Result:=1;
  2, 3, 4: Result:=2;
  else result:=3;
  end; //of case
  end;
end;

function GetThousands(n:thousand; g:Gender; ss:wordForms):String;
var
  n1, n10, n100:Digit;
  pl:plur;
begin
if n=0 then
  begin
  Result:='';
  Exit;
  end;
n1:=digit(n mod 10);
n:=n div 10;
n10:=digit(n mod 10);
n:=n div 10;
n100:=digit(n mod 10);
n:=n div 10;

Result:=handrids[n100]+' ';
if n10<>1 then
  begin
  if n10<>0 then Result:=Result+tens[n10]+' '+GetUnitString(n1, g)
  else Result:=Result+GetUnitString(n1, g);
  end
else //Если 10..19
  begin
  Result:=Result+teens[n1];
  end;

Result:=Result+' '; //Пробел перед словом
pl:=GetPlur(10*n10+n1);
Result:=Result+ss[pl];
end;

function SpellNumber(n:Int64; g:gender; wrd:wordForms):String;
var
  n1, n2, n3, n4, n5, n6, m:word;
  s:String;

begin
if n=0 then
  begin
  Result:='ноль '+wrd[3];
  Exit;
  end;

if n<0 then n:=-n;

n1:=n mod 1000;
n:=n div 1000;
n2:=n mod 1000;
n:=n div 1000;
n3:=n mod 1000;
n:=n div 1000;
n4:=n mod 1000;
n:=n div 1000;
n5:=n mod 1000;
n:=n div 1000;
n6:=n mod 1000;
n:=n div 1000;

Result:=GetThousands(n1, g, wrd);
if Result='' then Result:=wrd[3];
Result:=GetThousands(n2, tys.gend, tys.wrd)+' '+Result;
Result:=GetThousands(n3, mln.gend, mln.wrd)+' '+Result;
Result:=GetThousands(n4, mlrd.gend, mlrd.wrd)+' '+Result;
Result:=GetThousands(n5, trln.gend, trln.wrd)+' '+Result;
Result:=GetThousands(n6, quln.gend, quln.wrd)+' '+Result;

repeat  //Удаление двойных пробелов
  begin
  m:=Pos('  ', Result);
  if m<>0 then Delete(Result, m, 1);
  end
until m=0;

while Result[1]=' ' do Delete(Result, 1, 1); //Удаление передних пробелов

end;

function CurrencyToStr(x:Currency; d:denezhka; mode:Boolean=true):String;
var
  ar:Array[denezhka] of money;
  r:razr;
  w:wordForms;
  x1:Int64;
  b:Byte;
  s:String;
  plr:plur;
begin
ar[rur].rublik:=rup;
ar[rur].kopeechka:=kopek;
ar[usd].rublik:=buck;
ar[usd].kopeechka:=cent;
ar[EUR].rublik:=evrik;
ar[EUR].kopeechka:=cent;

r:=ar[d].rublik;
w:=ar[d].kopeechka;

x:=abs(x);

x1:=Trunc(x);
Result:=SpellNumber(x1, r.gend, r.wrd);
Result:=Result+' '; //Получаю сумму прописью пока без копеек

x:=frac(x)*100;
b:=Byte(round(x)); //Двузначное число копеек

s:=IntToStr(b);
if length(s)=1 then s:='0'+s;
s:=s+' '; //число копеек цифрами

Result:=result+s;

plr:=GetPlur(b);
s:=w[plr]; //слово "копеек"
Result:=result+s;

if mode then
  begin
  s:=AnsiUppercase(Result[1]);
  Result[1]:=s[1];
  end;

end;
//------------------------------------------------------------------------


function SummaToText(n: Double): string;
const
ed1 : array[1..9] of string = ('одна','двi','три','чотири','п`ять','шiсть','сiм','вiсiм','дев`ять');
ed2 : array[1..2] of string = ('одна','двi');
des : array[1..18] of string =
      ('десять','одиннадцять','дванадцять','тринадцять','чотирнадцять',
       'п`ятнадцять','шiстнадцять','сiмнадцять','вiсiмнадцять',
       'дев`ятнадцять','двадцять','тридцять','сорок','п`ятдесят',
       'шiстдесят','сiмдесят','вiсiмдесят','дев`яносто');
sot : array[1..9] of string = ('сто','двiстi','триста','чотириста','п`ятсот', 'шiстсот','сiмсот','вiсiмсот','дев`ятсот');
tis1 : array[1..4] of string = ('тисяча','мiлiон'  ,'мiлiард'  ,'трилiон'  );
tis2 : array[1..4] of string = ('тисяч' ,'мiлiонiв','мiлiардiв','трилiонiв');
tis3 : array[1..4] of string = ('тисячi','мiлiона' ,'мiлiарда' ,'трилiона' );

{ed1 : array[1..9] of string = ('одна','две','три','четыре','пять','шесть','семь','восемь','девять');
ed2 : array[1..2] of string = ('одна','две');
des : array[1..18] of string =
      ('десять','одиннадцать','двенадцать','тринадцать','четырнадцать',
       'пятнадцать','шестнадцать','семнадцать','восемнадцать',
       'девятнадцать','двадцать','тридцать','сорок','пятьдесят',
       'шестьдесят','семдесят','восемдесят','девяносто');
sot : array[1..9] of string = ('сто','двести','триста','четыреста','пятьсот', 'шестьсот','семсот','восемсот','девятсот');
tis1 : array[1..4] of string = ('тысяча','милион'  ,'милиард'  ,'трилион'  );
tis2 : array[1..4] of string = ('тысяч' ,'милионов','милиардов','трилионов');
tis3 : array[1..4] of string = ('тысячи','милиона' ,'милиарда' ,'трилиона' );
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
{ed1 : array[1..9] of string = ('одна','двi','три','чотири','п`ять','шiсть','сiм','вiсiм','дев`ять');
ed2 : array[1..2] of string = ('одна','двi');
des : array[1..18] of string =
      ('десять','одиннадцять','дванадцять','тринадцять','чотирнадцять',
       'п`ятнадцять','шiстнадцять','сiмнадцять','вiсiмнадцять',
       'дев`ятнадцять','двадцять','тридцять','сорок','п`ятдесят',
       'шiстдесят','сiмдесят','вiсiмдесят','дев`яносто');
sot : array[1..9] of string = ('сто','двiстi','триста','чотириста','п`ятсот', 'шiстсот','сiмсот','вiсiмсот','дев`ятсот');
tis1 : array[1..4] of string = ('тисяча','мiлiон'  ,'мiлiард'  ,'трилiон'  );
tis2 : array[1..4] of string = ('тисяч' ,'мiлiонiв','мiлiардiв','трилiонiв');
tis3 : array[1..4] of string = ('тисячi','мiлiона' ,'мiлiарда' ,'трилiона' );}
ed1 : array[1..9] of string = ('одна','две','три','четыре','пять','шесть','семь','восемь','девять');
ed2 : array[1..2] of string = ('одна','две');
des : array[1..18] of string =
      ('десять','одиннадцать','двенадцать','тринадцать','четырнадцать',
       'пятнадцать','шестнадцать','семнадцать','восемнадцать',
       'девятнадцать','двадцать','тридцать','сорок','пятьдесят',
       'шестьдесят','семдесят','восемдесят','девяносто');
sot : array[1..9] of string = ('сто','двести','триста','четыреста','пятьсот', 'шестьсот','семсот','восемсот','девятсот');
tis1 : array[1..4] of string = ('тысяча','милион'  ,'милиард'  ,'трилион'  );
tis2 : array[1..4] of string = ('тысяч' ,'милионов','милиардов','трилионов');
tis3 : array[1..4] of string = ('тысячи','милиона' ,'милиарда' ,'трилиона' );

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
      =('один ','два ','три ','четыре ','пять ','шесть ','семь ','восемь ','девять ');
const f1: array [1..9] of string
      =('одна ','две ','три ','четыре ','пять ','шесть ','семь ','восемь ','девять ');
const n10: array [1..9] of string
      =('десять ','двадцать ','тридцать ','сорок ','пятьдесят ','шестьдесят ',
       'семьдесят ','восемьдесят ','девяносто ');
const first10: array [11..19] of string
      =('одиннадцать ','двенадцать ','тринадцать ','четырнадцать ','пятнадцать ',
        'шестнадцать ','семнадцать ','восемнадцать ','девятнадцать ');
const n100: array [1..9] of string
      = ('сто ','двести ','триста ', 'четыреста ','пятьсот ','шестьсот ','семьсот ',
         'восемьсот ','девятьсот ');
const kop: array [1..3] of string = ('копейка','копейки','копеек');
      rub: array [1..3] of string = ('рубль ','рубля ','рублей ');
      tsd: array [1..3] of string = ('тысяча ','тысячи ','тысяч ');
      mln: array [1..3] of string = ('миллион ','миллиона ','миллионов ');
      mrd: array [1..3] of string = ('миллиapд ','миллиаpдa ','миллиapдoв ');
      trl: array [1..3] of string = ('триллион ','триллионa ','триллионoв ');
      cnt: array [1..3] of string = ('тысяча ','тысячи ','тысяч ');

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
          result:='00 центов'
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
    else if Curr = 'EUR' then
     Result := CurrencyToStr(n, EUR, false)
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
              CallMethod, 'Мои функции', 'Сумма прописью укр');
    AddMethod('function SummaToTextRu(Money: Double): String',
              CallMethod, 'Мои функции', 'Сумма прописью рус');
    AddMethod('function SummaCurToTextRu(Money: Double, Curr: String): String',
              CallMethod, 'Мои функции', 'Сумма вал прописью рус');

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

