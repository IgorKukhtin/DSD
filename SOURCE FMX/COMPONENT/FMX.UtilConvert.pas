unit FMX.UtilConvert;

interface

uses System.SysUtils, DB;

   {������� ����������� ����� � ������}
   function gfIntToStr(const inInt: integer): string; //tested
   {������� ����������� ������ � �����}
   function gfStrToInt(const inStr: string): integer; //tested
   {������� ����������� ����� � ������ ����������� �� DecimalSeparator.}
   function gfFloatToStr(const inFloat: Extended): string; //tested
   {����������� ������ � �����}
   function gfStrToFloat(const inStr: string): Extended; //tested
   {������� ����������� ���� � ������ ����������� �� ��������� �� ��������� �����������.}
   function gfDateToStr(const inDate: TDateTime): string; //tested
   {����������� ������ � ����}
   function gfStrToDate(const inStr: string): TDateTime; //tested
   {����������� ������ � ������� 8601 (2002-10-10T12:00:00+05:00) � ����}
   function gfXSStrToDate(const inStr: string): TDateTime;
   {������� ����������� ���������� �������� � ������ ����������� �� ��������� �� ��������� �����������.}
   function gfBooleanToStr(const inBool: Boolean): string; //tested
   {����������� ������ � ��������� ��������}
   function gfStrToBoolean(const inStr: string): Boolean; //tested

   {������� ������������ ������ ��� �������� � XML}
   function gfStrToXmlStr(const inStr: string): string;//tested
   {������� ������������ ������ XML � �������, ���������� ���� ������� �� �������}
   function gfStrXmlToStr(const inStr: string): string;

   {������� ���������� �������� ���� ���������� ��� ������}
   function gfFieldToString(const inField: TField): String; //tested
   {��������� ���������� �������� � ����}
   procedure gpStringToField(inField: TField; const inValue: String); //tested

   {������� ����������� ������ ������ ���������� � ������ ������� XML
   <Result ParamOne="sad" ParamTwo="11213"/> }
   function gfGetXMLFirstRecordFromDataSet(const inDataSet: TDataSet): String;//tested

   { ������� ����������� ������� ������ ���������� � ������ ������� XML
     ��� ���� ��������� ���������� ���� � ����������� �����������
     <Result ParamOne="sad" ParamTwo="11213"></Result>
   }
   function gfPutCurrentRecordFromDataSetToXML(const inDataSet: TDataSet; inOldResult: string): String;
   {���������� � ���� ������ �������� �� ��������� ��� ���������� ���� ������}
   function gfGetDefaultByType(inType: string): string;  //tested
   {������� ���������� ��� ������ �� ��� ���������� ��������}
   function gfStringToDataType(inType: String): TFieldType;  //tested
   // ������������ ������ � ����
   function gfStrFormatToDate (DateStr, Format: string): TDateTime;
   // ����������� � Base64
   function EncodeBase64(const Input: TBytes): string;
const
  cMainDecimalSeparator = '.';

implementation
uses XSBuiltIns, FMX.UtilConst, variants, StrUtils;
{-----------------------------------------------------------------------------------------------}
const
  cMainDateTimeFormat = 'dd-mm-yyyy HH:MM:SS';
  cMainDateFormat = 'dd.mm.yyyy';
  {��������� ����� ������}
  cftInteger = 'ftInteger';
  cftString = 'ftString';
  cftFloat = 'ftFloat';
  cftDateTime = 'ftDateTime';
  cftUnknown = 'ftUnknown';

  {��������� ����� ����������}
  cpdInput  = 'ptInput';
  cpdOutput = 'ptOutput';
  cpdInputOutput = 'ptInputOutput';

{-----------------------------------------------------------------------------------------------}
function gfStrFormatToDate (DateStr, Format: string): TDateTime;
{var
  i, k: integer;
  c: char;
  f: TFormatSettings;
  OldShortDateFormat: string;}
  (*GetLocaleFormatSettings (0, f);
  c := fmt [1];
  i := 1;
  while i <= Length (fmt) do begin
    if fmt [i] <> c then begin
      Insert (f.DateSeparator, fmt, i);
      Insert (f.DateSeparator, s, i);
      Inc (i);
    end;
    c := fmt [i];
    Inc (i);
  end;
  f.ShortDateFormat := fmt;
  Result := StrToDate (s, f);*)
Var
  PosD, PosM, PosY : Integer;
  sD, sM, sY       : String;

begin

  sd := '0';
  sm := '0';
  sy := '0';

  If Length(DateStr) = Length(Format) Then
    Begin
      Format := UpperCase(Format);
      PosD := Pos('D', Format);
      PosM := Pos('M', Format);
      PosY := Pos('Y', Format);

      sd := Copy(DateStr, PosD, 2);
      sm := Copy(DateStr, PosM, 2);

      if Length(DateStr) = 6 then
        begin
          sy := Copy(DateStr, PosY, 2);
          if StrToInt(sy) > 50 then
            sy := '19'+sy
          else
            sy := '20'+sy;
        end
      else
        sy := Copy(DateStr, Posy, 4);
    End;
  Result := EncodeDate(StrToInt(sY),
                       StrToInt(sM),
                       StrToInt(sD));
end;
{-----------------------------------------------------------------------------------------------}

function gfIntToStr(const inInt: Integer): string;
begin
  result:=IntToStr(inInt);
end;
{-----------------------------------------------------------------------------------------------}
function gfStrToInt(const inStr: string): integer;
const cProcName = '';
Begin
  result:=0;
  try
    result:=StrToInt(inStr);
  except
    on E: Exception do
       //gpRaiseError(gc_ecConvertStrToInt,[inStr], cProcName,E.Message);
  end;{except}
end;
{-----------------------------------------------------------------------------------------------}
function gfFloatToStr(const inFloat: Extended): string;
Begin
  result:=StringReplace(FloatToStr(inFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
end;
{-----------------------------------------------------------------------------------------------}
function gfStrToFloat(const inStr: string): Extended;
const cProcName = 'gfStrToFloat';
Begin
  result:=0;
  try
    result:=StrToFloat(ReplaceStr(ReplaceStr(inStr, '.', FormatSettings.DecimalSeparator), ',', FormatSettings.DecimalSeparator));
  except
    on E: Exception do
      // gpRaiseError(gc_ecConvertStrToFloat,[inStr], cProcName,E.Message);
  end;{except}
end;
{-----------------------------------------------------------------------------------------------}
{������� ����������� ���� � ������ ����������� �� ��������� �� ��������� �����������.}
function gfDateToStr(const inDate: TDateTime): string;
var pTime: TDateTime;
    Hour, Minute, Second, MSec: word;
begin
  pTime:=frac(inDate);
  {��������� ����� �� ������������}
  DecodeTime(pTime,Hour, Minute, Second, MSec);
  result :=gfFloatToStr(trunc(inDate)+EncodeTime(Hour, Minute, 0 ,0));
end;
{-----------------------------------------------------------------------------------------------}
{����������� ������ � ������� 8601 (2002-10-10T12:00:00+05:00) � ����}
function gfXSStrToDate(const inStr: string): TDateTime;
begin
  with TXSDateTime.Create() do
  try
    XSToNative(inStr); // convert from WideString
    result := AsUTCDateTime + HourOffset/24; // convert to TDateTime
  finally
    Free;
  end;
end;
{-----------------------------------------------------------------------------------------------}
{������� ����������� ������ � ���� ����������� �� ��������� �� ��������� �����������.}
function gfStrToDate(const inStr: string): TDateTime;
const cProcName = 'gfStrToDate';
Begin
  result:=Now;
  try
    {��� ���������-��������� � ������ ���������������� �������� ������� ������� �����}
    {$IFDEF FormEdit}
      try
        result:=gfStrToFloat(inStr);
      except
        result:=Now
      end;
    {$ELSE}
        result:=gfStrToFloat(inStr);
    {$ENDIF}
  except
    on E: Exception do
       //gpRaiseError(gc_ecConvertStrToDate,[inStr], cProcName,E.Message);
  end;{except}
end;
{-----------------------------------------------------------------------------------------------}
{������� ����������� ���������� �������� � ������ �������� ����������� �� ��������� �� ��������� �����������.}
function gfBooleanToStr(const inBool: Boolean): string;
Begin
  if inBool then
    result:=gcTrue
  else
    result:=gcFalse;
end;
{-----------------------------------------------------------------------------------------------}
function gfStrToBoolean(const inStr: string): Boolean;
Begin
  result := AnsiLowerCase(inStr)=gcTrue;
end;
{-----------------------------------------------------------------------------------------------}
{������� ������������ ������ ��� �������� � XML}
function gfStrToXmlStr(const inStr: string): string;
var pS: string;
begin
  pS := StringReplace(inStr, '&', '&amp;', [rfReplaceAll]);
  pS := StringReplace(pS, char(28), '', [rfReplaceAll]);
  pS := StringReplace(pS, '''', '&apos;', [rfReplaceAll]);
  pS := StringReplace(pS, '"', '&quot;', [rfReplaceAll]);
  pS := StringReplace(pS, #13#10, '&#13;&#10;', [rfReplaceAll]);
  pS := StringReplace(pS, '<', '&lt;', [rfReplaceAll]);
  result := StringReplace(pS, '>', '&gt;', [rfReplaceAll]);
end;
{-----------------------------------------------------------------------------------------------}
{������� ������������ ������ XML � �������, ���������� ���� ������� �� �������}
function gfStrXmlToStr(const inStr: string): string;
var pS: string;
begin
  pS := StringReplace(inStr, '&lt;', '<', [rfReplaceAll]);
  pS := StringReplace(pS, '&#xA;', #13#10, [rfReplaceAll]);
  pS := StringReplace(pS, '&#13;', #13, [rfReplaceAll]);
  pS := StringReplace(pS, '&#10;', #10, [rfReplaceAll]);
  pS := StringReplace(pS, '&quot;', '"', [rfReplaceAll]);
  pS := StringReplace(pS, '&amp;', '&', [rfReplaceAll]);
  pS := StringReplace(pS, '&apos;', '''', [rfReplaceAll]);
  result := StringReplace(pS, '&gt;', '>', [rfReplaceAll]);
end;
{-----------------------------------------------------------------------------------------------}
function gfFieldToString(const inField: TField): String;
const cProcName = 'gfFieldToString';
{������� ���������� �������� ���� ���������� ��� ������}
begin
  try
    case inField.DataType of
      ftGuid: Result:=inField.Value;
      ftFloat, ftCurrency, ftBCD: Result:=gfFloatToStr(inField.AsFloat);
      ftAutoInc, ftSmallint, ftInteger, ftWord: Result:=gfIntToStr(inField.AsInteger);
      ftDate, ftTime, ftDateTime: begin
                                     if inField.AsDateTime=0 then
                                       Result:=gfDateToStr(Now)
                                     else
                                       Result:=gfDateToStr(inField.AsDateTime);
                                  end;
      ftString, ftMemo, ftWideString: Result:= inField.AsString;
      ftBoolean: Result:= gfBooleanToStr(inField.AsBoolean);
      else //gpRaiseError(gc_ecUnknownType,['��� ���� ' + inField.FieldName],cProcName,'');
    end;
  except
    //on E:EProjectException do begin
     //  E.FunctionStack:=cProcName; raise;
    //end;{on}
  end{except}
end;
{--------------------------------------------------------------------------------------------------}
function gfGetXMLFirstRecordFromDataSet(const inDataSet: TDataSet): String;
const cProcName = 'gfGetXMLFirstRecordFromDataSet';
{������� ����������� ������ ������ ���������� � ������ ������� XML
 <Result ParamOne="sad" ParamTwo="11213"/> }
var i: integer;
    pFieldString: string;
begin
  try
    pFieldString:='';
    with inDataSet do begin
      {���� �� ������ ��� ��� �������, �� ��������� ������ XML }
      if (not Active) or (RecordCount=0) then
         result:=gcNodeStart+gcResult+gcNodeEnd
      {�������� �� ����� � �������� ���������}
      else begin
         for i:=0 to FieldCount-1 do begin
         //    pFieldString:=pFieldString+' '+Fields[i].FieldName+'="'+ReplaceStr(gfFieldToString(Fields[i]),gcQuot,'&quot;')+'" ';
//             gfStrToXmlStr(gfFieldToString(Fields[i]))
         end;
         result:=gcNodeStart+gcResult+pFieldString+gcNodeEnd;
      end;
    end;{with}
  except
  //  on E:EProjectException do begin
    //   E.FunctionStack:=cProcName; raise;
    //end;{on}
  end{except}
end;
{--------------------------------------------------------------------------------------------------}
function gfPutCurrentRecordFromDataSetToXML(const inDataSet: TDataSet; inOldResult: string): String;
const cProcName = 'gfPutCurrentRecordFromDataSetToXML';
{������� ����������� ������� ������ ���������� � ������ ������� XML
 <Result ParamOne="sad" ParamTwo="11213"/> }
var i: integer;
    pFieldString: string;
begin
  try
    pFieldString:='';
    with inDataSet do begin
      if (Active) and (RecordCount > 0) then begin
        {�������� �� ����� � �������� ���������}
        for i:=0 to FieldCount-1 do
  //        pFieldString:= pFieldString + ' ' + Fields[i].FieldName + '="' + ReplaceStr(gfFieldToString(Fields[i]),gcQuot,'&quot;') + '" ';
      end;{if}
      result:=gcNodeStart + gcResult + pFieldString + '>' + inOldResult + '</' + gcResult + '>';
    end;{with}
  except
   // on E:EProjectException do begin
     //  E.FunctionStack:=cProcName; raise;
    //end;{on}
  end{except}
end;
{--------------------------------------------------------------------------------------------------}
function gfGetDefaultByType(inType: string): string;
   {���������� � ���� ������ �������� �� ��������� ��� ���������� ���� ������}
const cProcName ='gfGetDefaultByType';
begin
  try
    if (inType = 'ftInteger') or (inType = 'ftFloat') then
      result := '0' else
      if inType = 'ftString' then
        result := '' else
        if inType = 'ftDate' then
          result := gfFloatToStr(real(Date)) else
          if inType = 'ftTime' then
            result := gfFloatToStr(real(Time)) else
            if inType = 'ftDateTime' then
              result := gfFloatToStr(real(Now))
              else
                //gpRaiseError(gc_ecUnknownType, [inType], cProcName, '' );
  except
    //on E:EProjectException do begin
      // E.FunctionStack:=cProcName; raise;
    //end;{on}
  end{except}
end;
{--------------------------------------------------------------------------------------------------}
function gfStringToDataType(inType: String): TFieldType;
{������� ���������� ��� ������ �� ��� ���������� ��������}
begin
  If inType = cftDateTime then result := ftDateTime
  else If inType = cftFloat then result := ftFloat
  else If inType = cftInteger then result := ftInteger
  else If inType = cftString then result := ftString
  else result := ftUnknown;
end;
{--------------------------------------------------------------------------------------------------}

(*function gfStringToParameterDirection(inType: String): TParameterDirection;
begin
  if inType = cpdInput then result := pdInput
  else if inType = cpdOutput then result := pdOutput
  else if inType = cpdInputOutput then result := pdInputOutput
  else result := pdUnknown;
end;   *)

{--------------------------------------------------------------------------------------------------}
procedure gpStringToField(inField: TField; const inValue: String);
const cProcName = 'gpStringToField';
{��������� ���������� �������� � ����}
begin
  try
    case inField.DataType of
      ftFloat, ftCurrency, ftBCD: inField.AsFloat:=gfStrToFloat(inValue);
      ftAutoInc, ftSmallint, ftInteger, ftWord: inField.AsInteger:=gfStrToInt(inValue);
      ftDate, ftTime, ftDateTime: inField.AsDateTime:=gfStrToDate(inValue);
      ftString: inField.AsString:=inValue;
      else //gpRaiseError(gc_ecUnknownType,[],cProcName,'');
    end;
  except
   // on E:EProjectException do begin
     //  E.FunctionStack:=cProcName; raise;
 //   end;{on}
  end{except}
end;
{--------------------------------------------------------------------------------------------------}
function EncodeBase64(const Input: TBytes): string;
const
  Base64: array[0..63] of Char =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

  function Encode3Bytes(const Byte1, Byte2, Byte3: Byte): string;
  begin
    Result := Base64[Byte1 shr 2]
      + Base64[((Byte1 shl 4) or (Byte2 shr 4)) and $3F]
      + Base64[((Byte2 shl 2) or (Byte3 shr 6)) and $3F]
      + Base64[Byte3 and $3F];
  end;

  function EncodeLast2Bytes(const Byte1, Byte2: Byte): string;
  begin
    Result := Base64[Byte1 shr 2]
      + Base64[((Byte1 shl 4) or (Byte2 shr 4)) and $3F]
      + Base64[(Byte2 shl 2) and $3F] + '=';
  end;

  function EncodeLast1Byte(const Byte1: Byte): string;
  begin
    Result := Base64[Byte1 shr 2]
      + Base64[(Byte1 shl 4) and $3F] + '==';
  end;

var
  i, iLength: Integer;
begin
  Result := '';
  iLength := Length(Input);
  i := 0;
  while i < iLength do
  begin
    case iLength - i of
      3..MaxInt:
        Result := Result + Encode3Bytes(Input[i], Input[i+1], Input[i+2]);
      2:
        Result := Result + EncodeLast2Bytes(Input[i], Input[i+1]);
      1:
        Result := Result + EncodeLast1Byte(Input[i]);
    end;
    Inc(i, 3);
  end;
end;
{--------------------------------------------------------------------------------------------------}

end.
