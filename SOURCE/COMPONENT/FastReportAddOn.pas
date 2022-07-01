unit FastReportAddOn;

interface


{ѕринимает число, род существительного, и три формы,
например male, рубль, рубл€, рублей. ¬озвращает число прописью}
//function SpellNumber(n:Int64; g:gender; wrd:wordForms):String;

{ѕринимает сумму цифрами, вид валюты и необ€зательный параметр писать ли с большой буквы,
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
  gender = (male, fimale, gay); //–од существительного
  wordForms = Array[1..3] of String[20];
  denezhka = (RUR, USD, EUR);

    digit = 0..9;
    plur = 1..3;
    thousand = 0..999;
    razr = record
      wrd:wordForms; //‘ормы слова
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
  handrids:Array[0..9] of String[10] = ('', 'сто', 'двести', 'триста', 'четыреста', 'п€тьсот', 'шестьсот', 'семьсот', 'восемьсот', 'дев€тьсот');
  tens:Array[2..9] of String[15] = ('двадцать', 'тридцать', 'сорок', 'п€тьдес€т', 'шестьдес€т', 'семьдес€т', 'восемьдес€т', 'дев€носто');
  teens:Array[0..9] of String[15] = ('дес€ть', 'одиннадцать', 'двенадцать', 'тринадцать', 'четырнадцать', 'п€тнадцать', 'шестнадцать', 'семнадцать', 'восемнадцать', 'дев€тнадцать');
  units:Array[3..9] of String[10] = ('три', 'четыре', 'п€ть', 'шесть', 'семь', 'восемь', 'дев€ть');

  tys:razr = (wrd:('тыс€ча', 'тыс€чи', 'тыс€ч'); gend:fimale);
  mln:razr = (wrd:('миллион', 'миллиона', 'миллионов'); gend:male);
  mlrd:razr = (wrd:('миллиард', 'миллиарда', 'миллиардов'); gend:male);
  trln:razr = (wrd:('триллион', 'триллиона', 'триллионов'); gend:male);
  quln:razr = (wrd:('квадриллион', 'квадриллиона', 'квадриллионов'); gend:male);

  rup:razr = (wrd:('рубль', 'рубл€', 'рублей'); gend:male);
  buck:razr = (wrd:('доллар', 'доллара', 'долларов'); gend:male);
  evrik:razr = (wrd:('евро', 'евро', 'евро'); gend:gay);

  kopek:wordForms = ('копейка', 'копейки', 'копеек');
  cent:wordForms = ('цент', 'цента', 'центов');
  {------------------------------------------------------------------}
  nfFull    = 0; // ѕолное название триад:  тыс€ча, миллион, ...
  nfShort   = 4; //  раткое название триад:  тыс., млн., ...

  nfMale    = 0; // ћужской род
  nfFemale  = 1; // ∆енский род
  nfMiddle  = 2; // —редний род

{ Ёти константы можно объедин€ть с помощью "or". ‘ункци€ G_NumToStr возвращает
  номер формы, в которой должно сто€ть следующее за данным числом слово, т.е.
  одно из следующих значений: }

  rfFirst  = 1;  // ѕерва€ форма: "один слон" или "двадцать одна кошка"
  rfSecond = 2;  // ¬тора€ форма: "три слона" или "четыре кошки"
  rfThird  = 3;  // “реть€ форма: "шесть слонов" или "восемь кошек"

//---------------------------
function G_ModDiv10(var V: LongWord): Integer;
const
Base10: Integer = 10;
asm
{$IFDEF CPUX64 }
      MOV     EAX,[RCX].LongWord
      XOR     EDX,EDX
      DIV     Base10
      MOV     [RCX].LongWord,EAX
      MOV     EAX,EDX
{$ELSE }
      MOV     ECX,EAX
      MOV     EAX,[EAX]
      XOR     EDX,EDX
      DIV     Base10
      MOV     [ECX],EAX
      MOV     EAX,EDX
{$ENDIF }
end;
//----------------------------


function G_NumToStr(N: Int64; var S: string; FormatFlags: LongInt): Integer;

const

  M_Ed: array [1..9] of string =
    ('один ','два ','три ','чотири ','п`€ть ','шiсть ','сiм ','вiсiм ','дев`€ть ');
  W_Ed: array [1..9] of string =
    ('одна ','двi ','три ','чотири ','п`€ть ','шiсть ','сiм ','вiсiм ','дев`€ть ');
  G_Ed: array [1..9] of string =
    ('одне ','два ','три ','чотири ','п`€ть ','шiсть ','сiм ','вiсiм ','дев`€ть ');
  E_Ds: array [0..9] of string =
    ('дес€ть ','одиннадц€ть ','дванадц€ть ','тринадц€ть ','чотирнадц€ть ',
     'п`€тнадц€ть ','шiстнадц€ть ','сiмнадц€ть ','вiсiмнадц€ть ','дев`€тнадц€ть ');
  D_Ds: array [2..9] of string =
    ('двадц€ть ','тридц€ть ','сорок ','п`€тдес€т ','шiстдес€т ','сiмдес€т ',
     'вiсiмдес€т ','дев`€носто ');
  U_Hd: array [1..9] of string =
    ('сто ','двiстi ','триста ','чотириста ','п`€тсот ','шiстсот ','сiмсот ',
     'вiсiмсот ','дев`€тсот ');
  M_Tr: array[1..6,0..3] of string =
    (('тис. ','тис€ча ','тис€чi ','тис€ч '),
     ('млн. ','мiлiон ','мiлiона ','мiлiонiв '),
     ('млрд. ','мiлiард ','мiлiарда ','мiлiардiв '),
     ('трлн. ','трилiон ','трилiона ','трилiонiв '),
     ('квадр. ','квадр≥лл≥он ','квадрильйона ','квадрильйон≥в '),
     ('кв≥нт. ','кв≥нтильйон ','кв≥нтильйони ','кв≥нтильйон≥в '));
var
  V1: Int64;
  VArr: array[0..6] of Integer;
  I, E, D, H, Count: Integer;
  SB: TStringBuilder;
begin
  Result := 3;
  if N = 0 then
  begin
    S := 'нуль ';
    Exit;
  end;
  if N > 0 then
    SB := TStringBuilder.Create(120)
  else if N <> $8000000000000000 then
  begin
    N := -N;
    SB := TStringBuilder.Create('м≥нус ');
  end else
  begin                                 { -9.223.372.036.854.775.808 }
    if FormatFlags and nfShort = 0 then
      S := 'м≥нус дев`€ть кв≥нтильйон≥в дв≥ст≥ двадц€ть три квадрильйона'+
        ' триста с≥мдес€т два трильйони тридц€ть ш≥сть м≥ль€рд≥в'+
        ' в≥с≥мсот п`€тьдес€т чотири м≥льйони с≥мсот с≥мдес€т п`€ть'+
        ' тис€ч в≥с≥мсот в≥с≥м '
    else
      S := 'м≥нус дев`€ть кв≥нт. дв≥ст≥ двадц€ть три квадр. триста'+
        ' с≥мдес€т два трлн. тридц€ть ш≥сть млрд. в≥с≥мсот п`€тьдес€т'+
        ' чотири млн. с≥мсот с≥мдес€т п`€ть тис. в≥с≥мсот в≥с≥м ';
    Exit;
  end;
  Count := 0;
  repeat
    V1 := N div 1000;
    VArr[Count] := N - (V1 * 1000);
    N := V1;
    Inc(Count);
  until V1 = 0;
  for I := Count - 1 downto 0 do
  begin
    H := VArr[I];
    Result := 3;
    if H <> 0 then
    begin
      E := G_ModDiv10(LongWord(H));
      D := G_ModDiv10(LongWord(H));
      if D <> 1 then
      begin
        if E = 1 then
          Result := 1
        else if (E >= 2) and (E <= 4) then
          Result := 2;
        if (H <> 0) and (D <> 0) then
          SB.Append(U_Hd[H]).Append(D_Ds[D])
        else if H <> 0 then
          SB.Append(U_Hd[H])
        else if D <> 0 then
          SB.Append(D_Ds[D]);
        if E <> 0 then
          if I = 0 then
            case FormatFlags and 3 of
              0: SB.Append(M_Ed[E]);
              1: SB.Append(W_Ed[E]);
              2: SB.Append(G_Ed[E]);
            else
              SB.Append('#### ');
            end
          else if I = 1 then
            SB.Append(W_Ed[E])
          else
            SB.Append(M_Ed[E]);
      end else
        if H = 0 then
          SB.Append(E_Ds[E])
        else
          SB.Append(U_Hd[H]).Append(E_Ds[E]);
      if I <> 0 then
      begin
        if FormatFlags and nfShort = 0 then
          SB.Append(M_Tr[I, Result])
        else
          SB.Append(M_Tr[I, 0]);
      end;
    end;
  end;
  S := SB.ToString;
  SB.Free;
end;


function NumToStr(N: Int64; FormatFlags: LongInt): string;
var
  l_str: string;
begin
  G_NumToStr(N, l_str, FormatFlags);
  Result := l_str;
end;

//-------------------------------------------------------------—умма ≈вро
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
n10:=n div 10;
if n10=1 then Result:=3
else //≈сли дворой разр€д не 1
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

Result:=handrids[n100]+' ';
if n10<>1 then
  begin
  if n10<>0 then Result:=Result+tens[n10]+' '+GetUnitString(n1, g)
  else Result:=Result+GetUnitString(n1, g);
  end
else //≈сли 10..19
  begin
  Result:=Result+teens[n1];
  end;

Result:=Result+' '; //ѕробел перед словом
pl:=GetPlur(10*n10+n1);
Result:=Result+ss[pl];
end;

function SpellNumber(n:Int64; g:gender; wrd:wordForms):String;
var
  n1, n2, n3, n4, n5, n6, m:word;

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

Result:=GetThousands(n1, g, wrd);
if Result='' then Result:=wrd[3];
Result:=GetThousands(n2, tys.gend, tys.wrd)+' '+Result;
Result:=GetThousands(n3, mln.gend, mln.wrd)+' '+Result;
Result:=GetThousands(n4, mlrd.gend, mlrd.wrd)+' '+Result;
Result:=GetThousands(n5, trln.gend, trln.wrd)+' '+Result;
Result:=GetThousands(n6, quln.gend, quln.wrd)+' '+Result;

repeat  //”даление двойных пробелов
  begin
  m:=Pos('  ', Result);
  if m<>0 then Delete(Result, m, 1);
  end
until m=0;

while Result[1]=' ' do Delete(Result, 1, 1); //”даление передних пробелов

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
Result:=Result+' '; //ѕолучаю сумму прописью пока без копеек

x:=frac(x)*100;
b:=Byte(round(x)); //ƒвузначное число копеек

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
ed1 : array[1..9] of string = ('одна','двi','три','чотири','п`€ть','шiсть','сiм','вiсiм','дев`€ть');
ed2 : array[1..2] of string = ('одна','двi');
ed3 : array[1..9] of string = ('один','два','три','чотири','п`€ть','шiсть','сiм','вiсiм','дев`€ть');
des : array[1..18] of string =
      ('дес€ть','одиннадц€ть','дванадц€ть','тринадц€ть','чотирнадц€ть',
       'п`€тнадц€ть','шiстнадц€ть','сiмнадц€ть','вiсiмнадц€ть',
       'дев`€тнадц€ть','двадц€ть','тридц€ть','сорок','п`€тдес€т',
       'шiстдес€т','сiмдес€т','вiсiмдес€т','дев`€носто');
sot : array[1..9] of string = ('сто','двiстi','триста','чотириста','п`€тсот', 'шiстсот','сiмсот','вiсiмсот','дев`€тсот');
tis1 : array[1..4] of string = ('тис€ча','м≥льйон'  ,'м≥ль€рд'  ,'трильйон'  );
tis2 : array[1..4] of string = ('тис€ч' ,'м≥льйонiв','м≥ль€рдiв','трильйонiв');
tis3 : array[1..4] of string = ('тис€чi','м≥льйона' ,'м≥ль€рда' ,'трильйона' );

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
  function _3toScript_mln(n : Word; male : Boolean) : String;
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
      Result:= Result+ed3[_3]+' '
    else
      Result:= Result+ed3[_3]+' ';
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
      if Count > 2
      then
         Result:= _3toScript_mln(tmp, Male)+Str+' '+Result
      else
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


function WeightToText(n: Double): string;
const
ed1 : array[1..9] of string = ('один','два','три','чотири','п`€ть','шiсть','сiм','вiсiм','дев`€ть');
ed2 : array[1..2] of string = ('один','два');
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
    Result := Result+'кг.';
    Result[1] := AnsiUpperCase(Result[1])[1];
    Result := Result + ' ' + FormatFloat('000', Round(Frac(SavTmp)*1000 ))+' гр.';
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
    else if (Curr = 'RUR') OR (Curr = 'RUB') then
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
              CallMethod, 'ћои функции', '—умма прописью укр');
    AddMethod('function SummaToTextRu(Money: Double): String',
              CallMethod, 'ћои функции', '—умма прописью рус');
    AddMethod('function SummaCurToTextRu(Money: Double, Curr: String): String',
              CallMethod, 'ћои функции', '—умма вал прописью рус');
    AddMethod('function NumToStr(N: Int64; FormatFlags: LongInt): String',
              CallMethod, 'ћои функции', '„исло прописью укр');
    AddMethod('function WeightToText(Money: Double): String',
              CallMethod, 'ћои функции', '¬ес прописью укр');

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
  if MethodName = 'NUMTOSTR' then
    Result := NumToStr(Params[0], Params[1]);
  if MethodName = 'WEIGHTTOTEXT' then
    Result := WEIGHTToText(Params[0]);

end;
initialization
  fsRTTIModules.Add(TFunctions);
end.

