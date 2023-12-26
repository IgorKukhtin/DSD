unit uFillDataSet;

interface

uses DB, SysUtils, DateUtils, TypInfo;

type

  TFillDataSet = class
  private
    class function FieldToBin(AField: TField): RawByteString;
  public
    /// TODO: передавать указатель на строку
    class function PackDataset(ADataSet: TDataSet): RawByteString;
  end;

implementation

const
  cHeader: AnsiString = #150#25 + AnsiChar($E0) + AnsiChar($BD) + #1#0#0#0#24#0#0#0;
  cHeaderFooter = #3#0#0#0;
  cTypeHeader = #0#16#0#0#0;
  cProp = #0#0;

  cTypeInteger = #4#0#1 + cTypeHeader;
  cTypeBoolean = #2#0#3 + cTypeHeader;
  cTypeNumeric = #8#0#4 + cTypeHeader;
  cTypeDateTime = #8#0#8 + cTypeHeader;

  cTypeAnsiString = #2#0#73#0#16#0#1#0#5'WIDTH'#2#0#2#0;
  cTypeWideString = #2#0#74#0#16#0#1#0#5'WIDTH'#2#0#2#0;
  cTypeWideMemo = #4#0#75#0#16#0#1#0#7'SUBTYPE'#2#0#73#0#9#0'WideText'#0;
  cTypeAnsiMemo = #4#0#75#0#16#0#1#0#7'SUBTYPE'#2#0#73#0#5#0'Text'#0;

  cUnixMilliseconds = 62135683200000;

class function TFillDataSet.FieldToBin(AField: TField): RawByteString;
var
  LFieldSize: Int16;
begin
  case AField.DataType of
    ftInteger:
      Result := cTypeInteger;
    ftWideString:
      begin
        Result := cTypeWideString;
        LFieldSize := AField.Size;
        SetLength(Result, Length(Result) + SizeOf(LFieldSize));
        Move(LFieldSize, Result[Length(Result) - (SizeOf(LFieldSize) - 1)], SizeOf(LFieldSize));
      end;
    ftWideMemo:
      Result := cTypeWideMemo;
    ftString:
      begin
        Result := cTypeAnsiString;
        LFieldSize := AField.Size;
        SetLength(Result, Length(Result) + SizeOf(LFieldSize));
        Move(LFieldSize, Result[Length(Result) - (SizeOf(LFieldSize) - 1)], SizeOf(LFieldSize));
      end;
    ftMemo:
      Result := cTypeAnsiMemo;
    ftBoolean:
      Result := cTypeBoolean;
    ftFloat:
      Result := cTypeNumeric;
    ftDateTime:
      Result := cTypeDateTime;
  else
    raise Exception.Create('Unknown datatype in field "' + AField.FieldName + '"!');
  end;
end;

class function TFillDataSet.PackDataset(ADataSet: TDataSet): RawByteString;
var
  LField: TField;
  LByte, LRecordStatus: Byte;
  I, J: Integer;
  LFieldCount, LWordValue: Word;
  LLongWordValue: LongWord;
  LRecordCount: Cardinal;
  LIntValue: Integer;
  LFieldList, LRes, LStringValue: RawByteString;
  LFloatValue: Double;
  LDateTimeValue: Double;
begin
  Result := cHeader;
  LFieldCount := ADataSet.FieldCount;
  SetLength(Result, Length(Result) + SizeOf(LFieldCount));
  Move(LFieldCount, Result[Length(Result) - (SizeOf(LFieldCount) - 1)], SizeOf(LFieldCount));
  LRecordCount := ADataSet.RecordCount;
  SetLength(Result, Length(Result) + SizeOf(LRecordCount));
  Move(LRecordCount, Result[Length(Result) - (SizeOf(LRecordCount) - 1)], SizeOf(LRecordCount));
  Result := Result + cHeaderFooter;

  LRes := '';

  while not ADataSet.EOF do
  begin

    LRecordStatus := 0;
    SetLength(LRes, Length(LRes) + SizeOf(LRecordStatus));
    Move(LRecordStatus, LRes[Length(LRes) - (SizeOf(LRecordStatus) - 1)], SizeOf(LRecordStatus));

    for I := 0 to ((ADataSet.FieldCount - 1) div 4) do
    begin
      LByte := 0;
      for J := 0 to 3 do
        if (ADataSet.FieldCount > (I * 4 + J)) and (ADataSet.Fields[I * 4 + J].IsNull or
          (ADataSet.Fields[I * 4 + J].DataType = ftMemo) and (ADataSet.Fields[I * 4 + J].AsAnsiString = '')) then
          LByte := LByte or (1 shl (J * 2));
      LRes := LRes + AnsiChar(LByte);
    end;

    for LField in ADataSet.Fields do
    begin
      if not LField.IsNull then
        case LField.DataType of
          ftString, ftWideString:
            begin
              LStringValue := LField.AsAnsiString;
              LWordValue := Length(LStringValue);
              if LWordValue = 0 then
                LWordValue := 1;

              SetLength(LRes, Length(LRes) + SizeOf(LWordValue));
              Move(LWordValue, LRes[Length(LRes) - (SizeOf(LWordValue) - 1)], SizeOf(LWordValue));

              LRes := LRes + LStringValue;

              if Length(LStringValue) = 0 then
                LRes := LRes + #0
            end;
          ftMemo, ftWideMemo: if LField.AsAnsiString <> '' then
            begin
              LStringValue := LField.AsAnsiString;
              LLongWordValue := Length(LStringValue);
              if LLongWordValue = 0 then
                LLongWordValue := 1;

              SetLength(LRes, Length(LRes) + SizeOf(LLongWordValue));
              Move(LLongWordValue, LRes[Length(LRes) - (SizeOf(LLongWordValue) - 1)], SizeOf(LLongWordValue));

              LRes := LRes + LStringValue;

              if Length(LStringValue) = 0 then
                LRes := LRes + #0
            end;
          ftInteger:
            begin
              LIntValue := LField.AsInteger;
              SetLength(LRes, Length(LRes) + SizeOf(LIntValue));
              Move(LIntValue, LRes[Length(LRes) - (SizeOf(LIntValue) - 1)], SizeOf(LIntValue));
            end;
          ftBoolean:
            if LField.AsBoolean then
              LRes := LRes + #255#255
            else
              LRes := LRes + #0#0;
          ftFloat:
            begin
              LFloatValue := LField.AsFloat;
              SetLength(LRes, Length(LRes) + SizeOf(LFloatValue));
              Move(LFloatValue, LRes[Length(LRes) - (SizeOf(LFloatValue) - 1)], SizeOf(LFloatValue));
            end;
          ftDateTime:
            begin
              LDateTimeValue := MilliSecondsBetween(LField.AsDateTime, UnixDateDelta) + cUnixMilliseconds;
              SetLength(LRes, Length(LRes) + SizeOf(LDateTimeValue));
              Move(LDateTimeValue, LRes[Length(LRes) - (SizeOf(LDateTimeValue) - 1)], SizeOf(LDateTimeValue));
            end
        else
          raise Exception.Create('TFillDataSet.PackDataset: Field Name ' + LField.FieldName + '. Wrong type ' + GetEnumName(TypeInfo(TFieldType), ord(LField.DataType)));
        end;
    end;
    ADataSet.Next;
  end;

  LFieldList := '';
  for LField in ADataSet.Fields do
  begin
    LFieldList := LFieldList + AnsiChar(Length(LField.FieldName));
    LFieldList := LFieldList + RawByteString(LField.FieldName);
    LFieldList := LFieldList + FieldToBin(LField);
  end;
  LFieldCount := Length(LFieldList) + 26;

  SetLength(Result, Length(Result) + SizeOf(LFieldCount));
  Move(LFieldCount, Result[Length(Result) - (SizeOf(LFieldCount) - 1)], SizeOf(LFieldCount));

  Result := Result + LFieldList + cProp;

  Result := Result + LRes;
end;

end.
