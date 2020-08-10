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
    FMaxIdArr: TMaxIdTransIdArray;
    FMaxId: Integer;
  strict private
    procedure AddToTMaxIdArr(const AId, ATransId: Integer);
    function GetCount: Integer;
    function GetEOF: Boolean;
  public
    procedure Add(const AId, ATransId: Integer; const ASQL: string);
    procedure BuildData(ADataSet: TDataSet);
    procedure Clear;
    procedure First;
    procedure Last;
    procedure Next;

    function Data: TDataRec;
    function NearestId(const AId, ARange: Integer): Integer;
    function MinMaxTransId(const AMinId, AMaxId: Integer): TMinMaxTransId;
    function MoveToId(const AId: Integer): Integer;// вернет позицию записи с AId в массиве FRecArray
    function RecordCount(const AStartId, AEndId: Integer): Integer;

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

procedure TCommandData.Add(const AId, ATransId: Integer; const ASQL: string);
begin
  SetLength(FRecArray, Length(FRecArray) + 1);

  with FRecArray[High(FRecArray)] do
  begin
    Id      := AId;
    TransId := ATransId;
    SQL     := ASQL;
  end;

  AddToTMaxIdArr(AId, ATransId);

  if FPos < 0 then FPos := 0;
end;

procedure TCommandData.AddToTMaxIdArr(const AId, ATransId: Integer);
var
  I: Integer;
  bTransIdExists: Boolean;
begin
  bTransIdExists := False;
  FMaxId := Max(FMaxId, AId); // максимальное значение Id в массиве FMaxIdArr

  for I := Low(FMaxIdArr) to High(FMaxIdArr) do
    if FMaxIdArr[I].TransId = ATransId then
    begin
      if FMaxIdArr[I].MaxId < AId then
        FMaxIdArr[I].MaxId := AId;

      Exit;
    end;

  if not bTransIdExists then
  begin
    SetLength(FMaxIdArr, Length(FMaxIdArr) + 1);
    FMaxIdArr[High(FMaxIdArr)].MaxId := AId;
    FMaxIdArr[High(FMaxIdArr)].TransId := ATransId;
  end;
end;

procedure TCommandData.BuildData(ADataSet: TDataSet);
var
  I, iId, iTran, iResult: Integer;
  sSQL, sPrevSQL: string;
begin
  Assert(ADataSet <> nil, 'Ожидается ADataSet <> nil');
  Assert(ADataSet.Active, 'Ожидается, что ADataSet уже открыт');

  Clear;

  // Обращение к FieldByName в цикле замедляет выполнение программы. Лучше использовать Fields[Index]
  // Определим индексы полей 'Id', 'Transaction_Id', 'Result'
  iId := -1;
  iTran := -1;
  iResult := -1;

  for I := 0 to Pred(ADataSet.FieldCount) do
    if      LowerCase(ADataSet.Fields[I].FieldName) = 'id'             then iId := I
    else if LowerCase(ADataSet.Fields[I].FieldName) = 'transaction_id' then iTran := I
    else if LowerCase(ADataSet.Fields[I].FieldName) = 'result'         then iResult := I;


  sPrevSQL := '';
  SetLength(FRecArray, 0);

  with ADataSet do
  begin
    First;
    while not Eof do
    begin
      // Пакет может содержать одинаковые комманды. Если команда такая же как и предыдущая,
      // тогда добавлять ее не надо.
      sSQL := Fields[iResult].AsString;

      if sSQL <> sPrevSQL then
      begin
        SetLength(FRecArray, Length(FRecArray) + 1);
        I := High(FRecArray);
        FRecArray[I].Id      := Fields[iId].AsInteger;
        FRecArray[I].TransId := Fields[iTran].AsInteger;
        FRecArray[I].SQL     := sSQL + ';';
//        FRecArray[I].SQL     := ProvideSemicolon(sSQL);

        AddToTMaxIdArr(Fields[iId].AsInteger, Fields[iTran].AsInteger);
      end;

      sPrevSQL := sSQL;
      Next;
    end;
  end;

  FPos := 0;

  {$IFDEF DEV_LOG}
  for I := Low(FRecArray) to High(FRecArray) do
     mLog.Write('CommandData.txt', 'Id= ' + IntToStr(FRecArray[I].Id) + ' TransId= ' + IntToStr(FRecArray[I].TransId));

  for I := Low(FMaxIdArr) to High(FMaxIdArr) do
     mLog.Write('MaxIdArray.txt', 'Id= ' + IntToStr(FMaxIdArr[I].MaxId) + ' TransId= ' + IntToStr(FMaxIdArr[I].TransId));
  {$ENDIF}
end;

procedure TCommandData.Clear;
begin
  SetLength(FRecArray, 0);
  SetLength(FMaxIdArr, 0);
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

procedure TCommandData.Last;
begin
  FPos := High(FRecArray);
end;

function TCommandData.MinMaxTransId(const AMinId, AMaxId: Integer): TMinMaxTransId;
var
  I: Integer;
begin
  Result.Min := High(Integer);
  Result.Max := -1;

  for I := Low(FRecArray) to High(FRecArray) do
    if (FRecArray[I].Id >= AMinId) and (FRecArray[I].Id <= AMaxId) then
    begin
      Result.Min := Min(Result.Min, FRecArray[I].TransId);
      Result.Max := Max(Result.Max, FRecArray[I].TransId);
    end;
end;

function TCommandData.MoveToId(const AId: Integer): Integer; // вернет позицию записи с AId в массиве FRecArray
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

function TCommandData.NearestId(const AId, ARange: Integer): Integer;
var
  I, J, iDelta, iMaxId, iPrevMaxId: Integer;
  arrTransId: array of Integer;
const
  cStartDelta = High(Integer);
begin
  Result := 0;
  iDelta := cStartDelta;
  iMaxId := AId + ARange;

  // В массиве FMaxIdArr элементы не обязательно упорядочены по Id
  // Ищем элемент, который > AId и наиболее близок ему по значению.
  for I := Low(FMaxIdArr) to High(FMaxIdArr) do
    if iMaxId < FMaxIdArr[I].MaxId then
      iDelta := Min(iDelta, FMaxIdArr[I].MaxId - iMaxId);

  if iDelta < cStartDelta then
  begin
    iMaxId := iMaxId + iDelta;// новая правая граница

    repeat
      iPrevMaxId := iMaxId;

      // собираем все номера транзакций нового диапазона
      SetLength(arrTransId, 0);

      for I := Low(FRecArray) to High(FRecArray) do
        if (FRecArray[I].Id >= AId) and (FRecArray[I].Id <= iMaxId) then
        begin
          SetLength(arrTransId, Length(arrTransId) + 1);
          arrTransId[High(arrTransId)] := FRecArray[I].TransId;
        end;

      // найдем максимальное значение Id, которое может иметь транзакция из массива arrTransId
      for I := Low(arrTransId) to High(arrTransId) do
        for J := Low(FMaxIdArr) to High(FMaxIdArr) do
          if arrTransId[I] = FMaxIdArr[J].TransId  then
            iMaxId := Max(iMaxId, FMaxIdArr[J].MaxId);

      Result := iMaxId;

      // Снова проверяем правую границу для нового iMaxId.
      // Если iMaxId остался неизменным - выход.
    until iPrevMaxId = iMaxId;
  end;

  // если данное значение AId превышает имеющиеся в массиве значения MaxId
  if (Result = 0) and (Length(FMaxIdArr) > 0) then
    Result := FMaxId;
end;

procedure TCommandData.Next;
begin
  Inc(FPos);
end;

function TCommandData.RecordCount(const AStartId, AEndId: Integer): Integer;
var
  prevPos, iStartPos, iEndPos: Integer;
begin
  prevPos := FPos;

  try
    try
      iStartPos := MoveToId(AStartId);
      iEndPos   := MoveToId(AEndId);

      Result := iEndPos - iStartPos + 1;// например, две записи рядом 100 и 101. 101 - 100 = 1
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
