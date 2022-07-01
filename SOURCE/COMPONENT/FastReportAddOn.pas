unit FastReportAddOn;

interface


{��������� �����, ��� ����������������, � ��� �����,
�������� male, �����, �����, ������. ���������� ����� ��������}
//function SpellNumber(n:Int64; g:gender; wrd:wordForms):String;

{��������� ����� �������, ��� ������ � �������������� �������� ������ �� � ������� �����,
�� ��������� �� ������
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
  gender = (male, fimale, gay); //��� ����������������
  wordForms = Array[1..3] of String[20];
  denezhka = (RUR, USD, EUR);

    digit = 0..9;
    plur = 1..3;
    thousand = 0..999;
    razr = record
      wrd:wordForms; //����� �����
      gend:gender; //��� �����
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
  handrids:Array[0..9] of String[10] = ('', '���', '������', '������', '���������', '�������', '��������', '�������', '���������', '���������');
  tens:Array[2..9] of String[15] = ('��������', '��������', '�����', '���������', '����������', '���������', '�����������', '���������');
  teens:Array[0..9] of String[15] = ('������', '�����������', '����������', '����������', '������������', '����������', '�����������', '����������', '������������', '������������');
  units:Array[3..9] of String[10] = ('���', '������', '����', '�����', '����', '������', '������');

  tys:razr = (wrd:('������', '������', '�����'); gend:fimale);
  mln:razr = (wrd:('�������', '��������', '���������'); gend:male);
  mlrd:razr = (wrd:('��������', '���������', '����������'); gend:male);
  trln:razr = (wrd:('��������', '���������', '����������'); gend:male);
  quln:razr = (wrd:('�����������', '������������', '�������������'); gend:male);

  rup:razr = (wrd:('�����', '�����', '������'); gend:male);
  buck:razr = (wrd:('������', '�������', '��������'); gend:male);
  evrik:razr = (wrd:('����', '����', '����'); gend:gay);

  kopek:wordForms = ('�������', '�������', '������');
  cent:wordForms = ('����', '�����', '������');
  {------------------------------------------------------------------}
  nfFull    = 0; // ������ �������� �����:  ������, �������, ...
  nfShort   = 4; // ������� �������� �����:  ���., ���., ...

  nfMale    = 0; // ������� ���
  nfFemale  = 1; // ������� ���
  nfMiddle  = 2; // ������� ���

{ ��� ��������� ����� ���������� � ������� "or". ������� G_NumToStr ����������
  ����� �����, � ������� ������ ������ ��������� �� ������ ������ �����, �.�.
  ���� �� ��������� ��������: }

  rfFirst  = 1;  // ������ �����: "���� ����" ��� "�������� ���� �����"
  rfSecond = 2;  // ������ �����: "��� �����" ��� "������ �����"
  rfThird  = 3;  // ������ �����: "����� ������" ��� "������ �����"

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
    ('���� ','��� ','��� ','������ ','�`��� ','�i��� ','�i� ','�i�i� ','���`��� ');
  W_Ed: array [1..9] of string =
    ('���� ','��i ','��� ','������ ','�`��� ','�i��� ','�i� ','�i�i� ','���`��� ');
  G_Ed: array [1..9] of string =
    ('���� ','��� ','��� ','������ ','�`��� ','�i��� ','�i� ','�i�i� ','���`��� ');
  E_Ds: array [0..9] of string =
    ('������ ','����������� ','���������� ','���������� ','������������ ',
     '�`��������� ','�i��������� ','�i�������� ','�i�i�������� ','���`��������� ');
  D_Ds: array [2..9] of string =
    ('�������� ','�������� ','����� ','�`������� ','�i������� ','�i������ ',
     '�i�i������ ','���`������ ');
  U_Hd: array [1..9] of string =
    ('��� ','��i��i ','������ ','��������� ','�`����� ','�i����� ','�i���� ',
     '�i�i���� ','���`����� ');
  M_Tr: array[1..6,0..3] of string =
    (('���. ','������ ','�����i ','����� '),
     ('���. ','�i�i�� ','�i�i��� ','�i�i��i� '),
     ('����. ','�i�i��� ','�i�i���� ','�i�i���i� '),
     ('����. ','����i�� ','����i��� ','����i��i� '),
     ('�����. ','��������� ','������������ ','������������ '),
     ('����. ','���������� ','����������� ','����������� '));
var
  V1: Int64;
  VArr: array[0..6] of Integer;
  I, E, D, H, Count: Integer;
  SB: TStringBuilder;
begin
  Result := 3;
  if N = 0 then
  begin
    S := '���� ';
    Exit;
  end;
  if N > 0 then
    SB := TStringBuilder.Create(120)
  else if N <> $8000000000000000 then
  begin
    N := -N;
    SB := TStringBuilder.Create('���� ');
  end else
  begin                                 { -9.223.372.036.854.775.808 }
    if FormatFlags and nfShort = 0 then
      S := '���� ���`��� ����������� ���� �������� ��� ������������'+
        ' ������ ������� ��� ��������� �������� ����� �������'+
        ' ������ �`�������� ������ ������� ����� ������� �`���'+
        ' ����� ������ ��� '
    else
      S := '���� ���`��� ����. ���� �������� ��� �����. ������'+
        ' ������� ��� ����. �������� ����� ����. ������ �`��������'+
        ' ������ ���. ����� ������� �`��� ���. ������ ��� ';
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

//-------------------------------------------------------------����� ����
function GetUnitString(n:digit; x:gender):String;
begin
case n of
0: Result:='';
1:
  begin
  case x of
    male: Result:='����';
    gay: Result:='����';
    fimale: Result:='����';
    end;
  end;
2:
  begin
  case x of
    male: Result:='���';
    gay: Result:='���';
    fimale: Result:='���';
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
else //���� ������ ������ �� 1
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
else //���� 10..19
  begin
  Result:=Result+teens[n1];
  end;

Result:=Result+' '; //������ ����� ������
pl:=GetPlur(10*n10+n1);
Result:=Result+ss[pl];
end;

function SpellNumber(n:Int64; g:gender; wrd:wordForms):String;
var
  n1, n2, n3, n4, n5, n6, m:word;

begin
if n=0 then
  begin
  Result:='���� '+wrd[3];
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

repeat  //�������� ������� ��������
  begin
  m:=Pos('  ', Result);
  if m<>0 then Delete(Result, m, 1);
  end
until m=0;

while Result[1]=' ' do Delete(Result, 1, 1); //�������� �������� ��������

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
Result:=Result+' '; //������� ����� �������� ���� ��� ������

x:=frac(x)*100;
b:=Byte(round(x)); //���������� ����� ������

s:=IntToStr(b);
if length(s)=1 then s:='0'+s;
s:=s+' '; //����� ������ �������

Result:=result+s;

plr:=GetPlur(b);
s:=w[plr]; //����� "������"
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
ed1 : array[1..9] of string = ('����','��i','���','������','�`���','�i���','�i�','�i�i�','���`���');
ed2 : array[1..2] of string = ('����','��i');
ed3 : array[1..9] of string = ('����','���','���','������','�`���','�i���','�i�','�i�i�','���`���');
des : array[1..18] of string =
      ('������','�����������','����������','����������','������������',
       '�`���������','�i���������','�i��������','�i�i��������',
       '���`���������','��������','��������','�����','�`�������',
       '�i�������','�i������','�i�i������','���`������');
sot : array[1..9] of string = ('���','��i��i','������','���������','�`�����', '�i�����','�i����','�i�i����','���`�����');
tis1 : array[1..4] of string = ('������','������'  ,'������'  ,'��������'  );
tis2 : array[1..4] of string = ('�����' ,'������i�','������i�','��������i�');
tis3 : array[1..4] of string = ('�����i','�������' ,'�������' ,'���������' );

{ed1 : array[1..9] of string = ('����','���','���','������','����','�����','����','������','������');
ed2 : array[1..2] of string = ('����','���');
des : array[1..18] of string =
      ('������','�����������','����������','����������','������������',
       '����������','�����������','����������','������������',
       '������������','��������','��������','�����','���������',
       '����������','��������','����������','���������');
sot : array[1..9] of string = ('���','������','������','���������','�������', '��������','������','��������','��������');
tis1 : array[1..4] of string = ('������','������'  ,'�������'  ,'�������'  );
tis2 : array[1..4] of string = ('�����' ,'��������','���������','���������');
tis3 : array[1..4] of string = ('������','�������' ,'��������' ,'��������' );
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
        Result := '���� ';
    Result := Result+'���.';
    Result[1] := AnsiUpperCase(Result[1])[1];
    Result := Result + ' ' + FormatFloat('00', Round(Frac(SavTmp)*100 ))+' ���.';
end;

function SummaToTextRu(n: Double): string;
const
{ed1 : array[1..9] of string = ('����','��i','���','������','�`���','�i���','�i�','�i�i�','���`���');
ed2 : array[1..2] of string = ('����','��i');
des : array[1..18] of string =
      ('������','�����������','����������','����������','������������',
       '�`���������','�i���������','�i��������','�i�i��������',
       '���`���������','��������','��������','�����','�`�������',
       '�i�������','�i������','�i�i������','���`������');
sot : array[1..9] of string = ('���','��i��i','������','���������','�`�����', '�i�����','�i����','�i�i����','���`�����');
tis1 : array[1..4] of string = ('������','�i�i��'  ,'�i�i���'  ,'����i��'  );
tis2 : array[1..4] of string = ('�����' ,'�i�i��i�','�i�i���i�','����i��i�');
tis3 : array[1..4] of string = ('�����i','�i�i���' ,'�i�i����' ,'����i���' );}
ed1 : array[1..9] of string = ('����','���','���','������','����','�����','����','������','������');
ed2 : array[1..2] of string = ('����','���');
des : array[1..18] of string =
      ('������','�����������','����������','����������','������������',
       '����������','�����������','����������','������������',
       '������������','��������','��������','�����','���������',
       '����������','��������','����������','���������');
sot : array[1..9] of string = ('���','������','������','���������','�������', '��������','������','��������','��������');
tis1 : array[1..4] of string = ('������','������'  ,'�������'  ,'�������'  );
tis2 : array[1..4] of string = ('�����' ,'��������','���������','���������');
tis3 : array[1..4] of string = ('������','�������' ,'��������' ,'��������' );

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
        Result := '���� ';
    Result := Result+'���.';
    Result[1] := AnsiUpperCase(Result[1])[1];
    Result := Result + ' ' + FormatFloat('00', Round(Frac(SavTmp)*100 ))+' ���.';
end;


function WeightToText(n: Double): string;
const
ed1 : array[1..9] of string = ('����','���','���','������','�`���','�i���','�i�','�i�i�','���`���');
ed2 : array[1..2] of string = ('����','���');
des : array[1..18] of string =
      ('������','�����������','����������','����������','������������',
       '�`���������','�i���������','�i��������','�i�i��������',
       '���`���������','��������','��������','�����','�`�������',
       '�i�������','�i������','�i�i������','���`������');
sot : array[1..9] of string = ('���','��i��i','������','���������','�`�����', '�i�����','�i����','�i�i����','���`�����');
tis1 : array[1..4] of string = ('������','�i�i��'  ,'�i�i���'  ,'����i��'  );
tis2 : array[1..4] of string = ('�����' ,'�i�i��i�','�i�i���i�','����i��i�');
tis3 : array[1..4] of string = ('�����i','�i�i���' ,'�i�i����' ,'����i���' );

{ed1 : array[1..9] of string = ('����','���','���','������','����','�����','����','������','������');
ed2 : array[1..2] of string = ('����','���');
des : array[1..18] of string =
      ('������','�����������','����������','����������','������������',
       '����������','�����������','����������','������������',
       '������������','��������','��������','�����','���������',
       '����������','��������','����������','���������');
sot : array[1..9] of string = ('���','������','������','���������','�������', '��������','������','��������','��������');
tis1 : array[1..4] of string = ('������','������'  ,'�������'  ,'�������'  );
tis2 : array[1..4] of string = ('�����' ,'��������','���������','���������');
tis3 : array[1..4] of string = ('������','�������' ,'��������' ,'��������' );
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
        Result := '���� ';
    Result := Result+'��.';
    Result[1] := AnsiUpperCase(Result[1])[1];
    Result := Result + ' ' + FormatFloat('000', Round(Frac(SavTmp)*1000 ))+' ��.';
end;



function SummaCurToTextRu(n: Double; curr:string): string;
const m1: array [1..9] of string
      =('���� ','��� ','��� ','������ ','���� ','����� ','���� ','������ ','������ ');
const f1: array [1..9] of string
      =('���� ','��� ','��� ','������ ','���� ','����� ','���� ','������ ','������ ');
const n10: array [1..9] of string
      =('������ ','�������� ','�������� ','����� ','��������� ','���������� ',
       '��������� ','����������� ','��������� ');
const first10: array [11..19] of string
      =('����������� ','���������� ','���������� ','������������ ','���������� ',
        '����������� ','���������� ','������������ ','������������ ');
const n100: array [1..9] of string
      = ('��� ','������ ','������ ', '��������� ','������� ','�������� ','������� ',
         '��������� ','��������� ');
const kop: array [1..3] of string = ('�������','�������','������');
      rub: array [1..3] of string = ('����� ','����� ','������ ');
      tsd: array [1..3] of string = ('������ ','������ ','����� ');
      mln: array [1..3] of string = ('������� ','�������� ','��������� ');
      mrd: array [1..3] of string = ('�����ap� ','������p�a ','�����ap�o� ');
      trl: array [1..3] of string = ('�������� ','��������a ','��������o� ');
      cnt: array [1..3] of string = ('������ ','������ ','����� ');

const cent: array [1..3] of string = ('����','�����','������');
      doll: array [1..3] of string = ('������ ','������� ','�������� ');
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
          result:='00 ������'
         else
          result:='00 ������'
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
  if s1 < 1 then  V:='���� '+V;
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
              CallMethod, '��� �������', '����� �������� ���');
    AddMethod('function SummaToTextRu(Money: Double): String',
              CallMethod, '��� �������', '����� �������� ���');
    AddMethod('function SummaCurToTextRu(Money: Double, Curr: String): String',
              CallMethod, '��� �������', '����� ��� �������� ���');
    AddMethod('function NumToStr(N: Int64; FormatFlags: LongInt): String',
              CallMethod, '��� �������', '����� �������� ���');
    AddMethod('function WeightToText(Money: Double): String',
              CallMethod, '��� �������', '��� �������� ���');

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

