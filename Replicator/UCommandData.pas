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
    FPos: Integer;
    FRecArray: TDataRecArray;
    FMaxId: Int64;
  strict private
    function GetCount: Integer;
    function GetEOF: Boolean;
    function NearestId(const AId: Int64; const ARange: Integer): Int64;
    function GetPosition(const AId: Int64): Integer;
    function GetId(const APos: Integer): Int64;
  public
    procedure Add(const AId, ATransId: Int64; const ASQL: string);
    procedure BuildData(ADataSet: TDataSet);
    procedure Clear;
    procedure First;
    procedure Last;
    procedure Next;

    function Data: TDataRec;
    function GetMaxId(const AId: Int64; const ARange: Integer): Int64;
    function MinMaxTransId(const AMinId, AMaxId: Int64): TMinMaxTransId;
    function MoveToId(const AId: Int64): Integer;// вернет позицию записи с AId в массиве FRecArray
    function RecordCount(const AStartId, AEndId: Int64): Integer;

    property EOF: Boolean read GetEOF;
    property Count: Integer read GetCount;
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
  iLen: Integer;
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
type
  TDataTemp = record
    Id: Int64;
    TransId: Int64;
    SQL: string;
    IsDuplicate: Boolean;
  end;
var
  I, J, iUniqSize, idxId, idxTran, idxResult: Integer;
  sSQL, sPrevSQL: string;
  arrTemp: array of TDataTemp;
//  fakeArr: TDataRecArray;
begin
  Assert(ADataSet <> nil, 'ќжидаетс€ ADataSet <> nil');
  Assert(ADataSet.Active, 'ќжидаетс€, что ADataSet уже открыт');

  Clear;

  if ADataSet.RecordCount = 0 then Exit;

  // ќбращение к FieldByName в цикле замедл€ет выполнение программы. Ћучше использовать Fields[Index]
  // ќпределим индексы полей 'Id', 'Transaction_Id', 'Result'
  idxId := -1;
  idxTran := -1;
  idxResult := -1;

  for I := 0 to Pred(ADataSet.FieldCount) do
    if      SameText(ADataSet.Fields[I].FieldName, 'id')             then idxId := I
    else if SameText(ADataSet.Fields[I].FieldName, 'transaction_id') then idxTran := I
    else if SameText(ADataSet.Fields[I].FieldName, 'result')         then idxResult := I;


  I := 0;
  iUniqSize := 0;
  sPrevSQL  := '';
  SetLength(FRecArray, 0);
  SetLength(arrTemp, ADataSet.RecordCount);

  with ADataSet do
  begin
    First;
    while not Eof do
    begin
      // ѕакет может содержать одинаковые команды. ћожно за один проход определ€ть дубликаты и записывать
      // только уникальные команды, но тогда придетс€ выдел€ть пам€ть дл€ нового элемента массива при каждой итерации,
      // а это очень замедлит выполнение. ƒл€ увеличени€ скорости сначала один раз выдел€ем пам€ть дл€ временного массива
      // и записываем в него данные из датасета, дл€ дубликатов делаем пометку в IsDuplicate. ѕотом запишем в FRecArray только уникальные записи.

      sSQL := Fields[idxResult].AsString;

      arrTemp[I].Id          := Fields[idxId].AsLargeInt;
      arrTemp[I].TransId     := Fields[idxTran].AsLargeInt;
      arrTemp[I].SQL         := sSQL;
      arrTemp[I].IsDuplicate := SameText(sSQL, sPrevSQL);

      if not arrTemp[I].IsDuplicate then Inc(iUniqSize);// сразу подсчитываем размер массива с уникальными командами

      {$IFDEF DEV_LOG}
      if SameText(sSQL, sPrevSQL) then
        mLog.Write('Same records.txt', 'Id= ' + IntToStr(iId) + ' iTranId= ' + IntToStr(iTranId) + ' sSQL= ' + sSQL);
      {$ENDIF}

      Inc(I);
      sPrevSQL := sSQL;
      Next;
    end;
  end;

  // записываем уникальные команды в массив FRecArray
  J := 0;
  SetLength(FRecArray, iUniqSize);

  for I := Low(arrTemp) to High(arrTemp) do
    if not arrTemp[I].IsDuplicate then
    begin
      FRecArray[J].Id      := arrTemp[I].Id;
      FRecArray[J].TransId := arrTemp[I].TransId;
      FRecArray[J].SQL     := arrTemp[I].SQL + ';';
      Inc(J);
    end;


  FPos := 0;

  {$IFDEF DEV_LOG}
  for I := Low(FRecArray) to High(FRecArray) do
     mLog.Write('CommandData.txt', 'Id= ' + IntToStr(FRecArray[I].Id) +
                ' TransId= ' + IntToStr(FRecArray[I].TransId) + ' sSQL= ' + FRecArray[I].SQL);
  {$ENDIF}

//  SetLength(fakeArr, 1);
//  fakeArr[0].Id := FRecArray[0].Id;
//  fakeArr[0].TransId := FRecArray[0].TransId;
//  fakeArr[0].SQL := FRecArray[0].SQL;
//
//  SetLength(FRecArray, 1);
//  FRecArray[0].Id := fakeArr[0].Id;
//  FRecArray[0].TransId := fakeArr[0].TransId;
//  FRecArray[0].SQL := fakeArr[0].SQL;
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

function TCommandData.GetCount: Integer;
begin
  Result := Length(FRecArray);
end;

function TCommandData.GetEOF: Boolean;
begin
  Result := FPos > High(FRecArray);
end;

function TCommandData.GetId(const APos: Integer): Int64;
var
  iPos: Integer;
begin
  Assert(Length(FRecArray) > 0, 'ќжидаетс€ Length(FRecArray) > 0');
  iPos := Min(APos, High(FRecArray));
  iPos := Max(iPos, 0);

  Result := FRecArray[iPos].Id;
end;

function TCommandData.GetMaxId(const AId: Int64; const ARange: Integer): Int64;
var
  iPos, iRange: Integer;
begin
  // BuildData не сохран€ет дубликаты команд, поэтому реальный размер нового пакета может быть меньше ARange
  // Ќужно скоректировать размер
  iPos := GetPosition(AId);

  if iPos = -1 then Exit(-1);

  iPos := iPos + ARange - 100;
  iRange := GetId(iPos) - AId;

  Result := NearestId(AId, iRange);
end;

procedure TCommandData.Last;
begin
  FPos := High(FRecArray);
end;

function TCommandData.MinMaxTransId(const AMinId, AMaxId: Int64): TMinMaxTransId;
var
  I: Integer;
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

function TCommandData.MoveToId(const AId: Int64): Integer; // вернет позицию записи с AId в массиве FRecArray
var
  I: Integer;
  bFound: Boolean;
const
  cErrMsg = 'Id = %d не найден в массиве данных TCommandData';
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

function TCommandData.NearestId(const AId: Int64; const ARange: Integer): Int64;
var
  I, iIndx: Integer;
  iMaxId, iNewTransId: Int64;
begin
  Result := -1;

  if Length(FRecArray) = 0 then Exit;

  Assert(AId > 0, 'ќжидаетс€ AId > 0, имеем AId= ' + IntToStr(AId));
  Assert(ARange >= 0, 'ќжидаетс€ ARange >= 0, имеем ARange= ' + IntToStr(ARange));
  Assert(Length(FRecArray) > 0, 'ќжидаетс€ Length(FRecArray) > 0');

  Result := AId + ARange;

  // Result не должен превышать максимальное значение Id в массиве FRecArray
  iMaxId := FRecArray[High(FRecArray)].Id;

  if Result >= iMaxId then
    Exit(iMaxId);

  // Ёлементы массива FRecArray упор€дочены по Id, но могут иметь разрывы в последовательности.
  // »щем элемент, который наиболее близок к заданному значению
  iIndx := -1;
  iNewTransId := 0;
  for I := Low(FRecArray) to High(FRecArray) do
    if FRecArray[I].Id >= Result then
    begin
      iIndx := I;
      Result := FRecArray[I].Id;
      iNewTransId := FRecArray[I].TransId;
      Break;
    end;
  Assert(iIndx > 0, 'ќжидаетс€ iIndx > 0');
  Assert(iNewTransId > 0, 'ќжидаетс€ iNewTransId > 0');

  // Ќужно проверить TransId записей, следующих за iIndx. ≈сли у них такой же TransId, тогда нужно выбрать эти записи
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

function TCommandData.GetPosition(const AId: Int64): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := Low(FRecArray) to High(FRecArray) do
    if FRecArray[I].Id = AId then
      Exit(I);
end;

function TCommandData.RecordCount(const AStartId, AEndId: Int64): Integer;
var
  prevPos, iStartPos, iEndPos: Integer;
begin
  prevPos := FPos;

  try
    try
      iStartPos := MoveToId(AStartId);
      iEndPos   := MoveToId(AEndId);

      Result := iEndPos - iStartPos + 1;// например, две записи р€дом 100 и 101. 101 - 100 = 1
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
