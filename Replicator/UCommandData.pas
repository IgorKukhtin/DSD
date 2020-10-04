unit UCommandData;

interface

uses
  System.SysUtils,
  Data.DB,
  {$IFDEF DEV_LOG}ULog,{$ENDIF}
  UDefinitions;

type
  TCommandData = class
  strict private
    FPos: Int64;
    FRecArray: TDataRecArray;
    FMaxId: Int64;
  strict private
    function GetCount: Int64;
    function GetEOF: Boolean;
    function NearestId(const AId, ARange: Int64): Int64;
    function GetPosition(const AId: Int64): Int64;
    function GetId(const APos: Int64): Int64;
  public
    procedure Add(const AId, ATransId: Int64; const ASQL: string);
    procedure BuildData(ADataSet: TDataSet);
    procedure Clear;
    procedure First;
    procedure Last;
    procedure Next;

    function Data: TDataRec;
    function GetMaxId(const AId, ARange: Int64): Int64;
    function MinMaxTransId(const AMinId, AMaxId: Int64): TMinMaxTransId;
    function MoveToId(const AId: Int64): Int64;// ������ ������� ������ � AId � ������� FRecArray
    function RecordCount(const AStartId, AEndId: Int64): Int64;

    property EOF: Boolean read GetEOF;
    property Count: Int64 read GetCount;
  end;

  ECommandData = class(Exception);
    EIdNotFound = ECommandData;


implementation

uses
  System.Math;

{$IFDEF DEV_LOG}
var
  mLog: TLog;
{$ENDIF}

function ProvideSemicolon(const AStr: string): string;
var
  iLen: Int64;
begin
  Result := AStr;
  iLen := Length(AStr);

  if (iLen > 0) and (AStr[iLen] <> ';') then
    Result := AStr + ';';
end;

{ TCommandData }

procedure TCommandData.Add(const AId, ATransId: Int64; const ASQL: string);
begin
  SetLength(FRecArray, Length(FRecArray) + 1);

  with FRecArray[High(FRecArray)] do
  begin
    Id      := AId;
    TransId := ATransId;
    SQL     := ASQL;
  end;

  if FPos < 0 then FPos := 0;
end;

procedure TCommandData.BuildData(ADataSet: TDataSet);
var
  I, idxId, idxTran, idxResult: Int64;
  iId, iTranId, iPrevTranId: Int64;
  sSQL, sPrevSQL: string;
begin
  Assert(ADataSet <> nil, '��������� ADataSet <> nil');
  Assert(ADataSet.Active, '���������, ��� ADataSet ��� ������');

  Clear;

  // ��������� � FieldByName � ����� ��������� ���������� ���������. ����� ������������ Fields[Index]
  // ��������� ������� ����� 'Id', 'Transaction_Id', 'Result'
  idxId := -1;
  idxTran := -1;
  idxResult := -1;

  for I := 0 to Pred(ADataSet.FieldCount) do
    if      LowerCase(ADataSet.Fields[I].FieldName) = 'id'             then idxId := I
    else if LowerCase(ADataSet.Fields[I].FieldName) = 'transaction_id' then idxTran := I
    else if LowerCase(ADataSet.Fields[I].FieldName) = 'result'         then idxResult := I;


  sPrevSQL := '';
  iPrevTranId := 0;
  SetLength(FRecArray, 0);

  with ADataSet do
  begin
    First;
    while not Eof do
    begin
      // ����� ����� ��������� ���������� �������. ���� ������� ����� �� ��� � ���������� � � ��� ����� �� TransId,
      // ����� ��������� �� �� ����.
      sSQL    := Fields[idxResult].AsString;
      iId     := Fields[idxId].AsLargeInt;
      iTranId := Fields[idxTran].AsLargeInt;

      if not ((iTranId = iPrevTranId) and (sSQL = sPrevSQL)) then
      begin
        SetLength(FRecArray, Length(FRecArray) + 1);
        I := High(FRecArray);
        FRecArray[I].Id      := iId;
        FRecArray[I].TransId := iTranId;
        FRecArray[I].SQL     := sSQL + ';';
      end;

      {$IFDEF DEV_LOG}
      if (iTranId = iPrevTranId) and (sSQL = sPrevSQL) then
        mLog.Write('Same records.txt', 'Id= ' + IntToStr(iId) + ' iTranId= ' + IntToStr(iTranId) + ' sSQL= ' + sSQL);
      {$ENDIF}


      sPrevSQL    := sSQL;
      iPrevTranId := iTranId;
      Next;
    end;
  end;

  FPos := 0;

  {$IFDEF DEV_LOG}
  for I := Low(FRecArray) to High(FRecArray) do
     mLog.Write('CommandData.txt', 'Id= ' + IntToStr(FRecArray[I].Id) +
                ' TransId= ' + IntToStr(FRecArray[I].TransId) + ' sSQL= ' + FRecArray[I].SQL);
  {$ENDIF}
end;

procedure TCommandData.Clear;
begin
  SetLength(FRecArray, 0);
  FPos := -1;
  FMaxId := -1;
end;

function TCommandData.Data: TDataRec;
begin
  if Length(FRecArray) > 0 then
    if (FPos >= Low(FRecArray)) and (FPos <= High(FRecArray)) then
      Result := FRecArray[FPos];
end;

procedure TCommandData.First;
begin
  FPos := Low(FRecArray);
end;

function TCommandData.GetCount: Int64;
begin
  Result := Length(FRecArray);
end;

function TCommandData.GetEOF: Boolean;
begin
  Result := FPos > High(FRecArray);
end;

function TCommandData.GetId(const APos: Int64): Int64;
var
  iPos: Int64;
begin
  iPos := Min(APos, High(FRecArray));
  iPos := Max(iPos, 0);

  Result := FRecArray[iPos].Id;
end;

function TCommandData.GetMaxId(const AId, ARange: Int64): Int64;
var
  iPos, iRange: Int64;
begin
  // BuildData �� ��������� ��������� ������, ������� �������� ������ ������ ������ ����� ���� ������ ARange
  // ����� �������������� ������
  iPos := GetPosition(AId) + ARange - 100;
  iRange := GetId(iPos) - AId;

  Result := NearestId(AId, iRange);
end;

procedure TCommandData.Last;
begin
  FPos := High(FRecArray);
end;

function TCommandData.MinMaxTransId(const AMinId, AMaxId: Int64): TMinMaxTransId;
var
  I: Int64;
begin
  Result.Min := High(Int64);
  Result.Max := -1;

  for I := Low(FRecArray) to High(FRecArray) do
    if (FRecArray[I].Id >= AMinId) and (FRecArray[I].Id <= AMaxId) then
    begin
      Result.Min := Min(Result.Min, FRecArray[I].TransId);
      Result.Max := Max(Result.Max, FRecArray[I].TransId);
    end;
end;

function TCommandData.MoveToId(const AId: Int64): Int64; // ������ ������� ������ � AId � ������� FRecArray
var
  I: Int64;
  bFound: Boolean;
const
  cErrMsg = 'Id = %d �� ������ � ������� ������ TCommandData';
begin
  Result := -1;
  bFound := False;

  for I := Low(FRecArray) to High(FRecArray) do
    if FRecArray[I].Id = AId then
    begin
      FPos := I;
      Result := FPos;
      Exit;
    end;

  if not bFound then
    raise EIdNotFound.CreateFmt(cErrMsg, [AId]);
end;

function TCommandData.NearestId(const AId, ARange: Int64): Int64;
var
  I, iIndx, iMaxId, iNewTransId: Int64;
  str:string;
begin
  Assert(AId > 0, '��������� AId > 0');
  Assert(ARange > 0, '��������� ARange > 0');
  Assert(Length(FRecArray) > 0, '��������� Length(FRecArray) > 0');

  Result := AId + ARange;

  // Result �� ������ ��������� ������������ �������� Id � ������� FRecArray
  iMaxId := FRecArray[High(FRecArray)].Id;

  if Result >= iMaxId then
    Exit(iMaxId);

  // �������� ������� FRecArray ����������� �� Id, �� ����� ����� ������� � ������������������.
  // ���� �������, ������� �������� ������ � ��������� ��������
  iIndx := -1;
  iNewTransId := 0;
  str:=' ***';
  for I := Low(FRecArray) to High(FRecArray) do
    if FRecArray[I].Id >= Result then
    begin
      iIndx := I;
      Result := FRecArray[I].Id;
      iNewTransId := FRecArray[I].TransId;
      str:= IntToStr(iIndx) + ' ' + IntToStr(iNewTransId);
      Break;
    end;
  Assert(iIndx > 0, '��������� iIndx > 0');
  Assert(iNewTransId > 0, '��������� iNewTransId > 0 ��� ����������: '
   + ' Low(FRecArray) = ' + IntToStr(Low(FRecArray))
   + ' High(FRecArray) = ' + IntToStr(High(FRecArray))
   + ' Result = ' + IntToStr(Result)
   + ' FRecArray[Low(FRecArray)].Id = ' + IntToStr(FRecArray[Low(FRecArray)].Id)
   + ' FRecArray[Low(FRecArray)].TransId = ' + IntToStr(FRecArray[Low(FRecArray)].Id)
   + ' FRecArray[High(FRecArray)].Id = ' + IntToStr(FRecArray[High(FRecArray)].TransId)
   + ' FRecArray[High(FRecArray)].TransId = ' + IntToStr(FRecArray[High(FRecArray)].TransId)

   + ' FRecArray[I-1].Id = ' + IntToStr(FRecArray[I-1].TransId)
   + ' FRecArray[I-1].TransId = ' + IntToStr(FRecArray[I-1].TransId)

   + ' FRecArray[I].Id = ' + IntToStr(FRecArray[I].TransId)
   + ' FRecArray[I].TransId = ' + IntToStr(FRecArray[I].TransId)

   + ' FRecArray[I+1].Id = ' + IntToStr(FRecArray[I+1].TransId)
   + ' FRecArray[I+1].TransId = ' + IntToStr(FRecArray[I+1].TransId)

   + ' FRecArray[1].Id = ' + IntToStr(FRecArray[1].TransId)
   + ' FRecArray[1].TransId = ' + IntToStr(FRecArray[1].TransId)

   + ' FRecArray[2].Id = ' + IntToStr(FRecArray[2].TransId)
   + ' FRecArray[2].TransId = ' + IntToStr(FRecArray[2].TransId)

   + ' I = ' + IntToStr(I)

   + ' iIndx = ' + IntToStr(iIndx)

   + ' str = ' + str

   + ' AId = ' + IntToStr(AId)
   + ' ARange = ' + IntToStr(ARange)
   + ' iMaxId = ' + IntToStr(iMaxId)

       );

  // ����� ��������� TransId �������, ��������� �� iIndx. ���� � ��� ����� �� TransId, ����� ����� ������� ��� ������
  for I := iIndx + 1 to High(FRecArray) do
    if FRecArray[I].TransId = iNewTransId then
      Result := FRecArray[I].Id
    else
      Exit;
end;

procedure TCommandData.Next;
begin
  Inc(FPos);
end;

function TCommandData.GetPosition(const AId: Int64): Int64;
var
  I: Int64;
begin
  Result := -1;
  for I := Low(FRecArray) to High(FRecArray) do
    if FRecArray[I].Id = AId then
      Exit(I);
end;

function TCommandData.RecordCount(const AStartId, AEndId: Int64): Int64;
var
  prevPos, iStartPos, iEndPos: Int64;
begin
  prevPos := FPos;

  try
    try
      iStartPos := MoveToId(AStartId);
      iEndPos   := MoveToId(AEndId);

      Result := iEndPos - iStartPos + 1;// ��������, ��� ������ ����� 100 � 101. 101 - 100 = 1
    except
      Result := 0;
    end;
  finally
    FPos := prevPos;
  end;
end;

{$IFDEF DEV_LOG}
initialization
  mLog := TLog.Create;

finalization
  FreeAndNil(mLog);
{$ENDIF}


end.
