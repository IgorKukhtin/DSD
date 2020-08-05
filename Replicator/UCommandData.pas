unit UCommandData;

interface

uses
  System.SysUtils,
  Data.DB,
  UDefinitions;

type
  TCommandData = class
  strict private
    FPos: Integer;
    FRecArray: TDataRecArray;
    FMaxIdArr: TMaxIdTransIdArray;
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
    function NearestId(const AId: Integer): Integer;
    function MoveToId(const AId: Integer): Integer;// вернет позицию записи с AId в массиве FRecArray
    function RecordCount(const AStartId, AEndId: Integer): Integer;

    property EOF: Boolean read GetEOF;
    property Count: Integer read GetCount;
  end;

  ECommandData = class(Exception);
    EIdNotFound = ECommandData;


implementation

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

  for I := Low(FMaxIdArr) to High(FMaxIdArr) do
    if FMaxIdArr[I].TransId = ATransId then
    begin
      if FMaxIdArr[I].MaxId < AId then FMaxIdArr[I].MaxId := AId;

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
  I: Integer;
begin
  Assert(ADataSet <> nil, 'Ожидается ADataSet <> nil');
  Assert(ADataSet.Active, 'Ожидается, что ADataSet уже открыт');

  Clear;
  I := 0;

  // ожидается, что выполнен ADataSet.Last и в датасет загружены все записи
  SetLength(FRecArray, ADataSet.RecordCount);

  with ADataSet do
  begin
    First;
    while not Eof do
    begin
      FRecArray[I].Id      := FieldByName('Id').AsInteger;
      FRecArray[I].TransId := FieldByName('Transaction_Id').AsInteger;
      FRecArray[I].SQL     := FieldByName('Result').AsString + ';';
//      FRecArray[I].SQL     := ProvideSemicolon(FieldByName('Result').AsString);

      AddToTMaxIdArr(FieldByName('Id').AsInteger, FieldByName('Transaction_Id').AsInteger);
      Inc(I);
      Next;
    end;
  end;

  FPos := 0;
end;

procedure TCommandData.Clear;
begin
  SetLength(FRecArray, 0);
  SetLength(FMaxIdArr, 0);
  FPos := -1;
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

function TCommandData.NearestId(const AId: Integer): Integer;
var
  I: Integer;
begin
  Result := 0;

  for I := Low(FMaxIdArr) to High(FMaxIdArr) do
    if AId <= FMaxIdArr[I].MaxId then
      Exit(FMaxIdArr[I].MaxId);

  // если данное значение AId превышает имеющиеся в массиве значения MaxId
  if (Result = 0) and (Length(FMaxIdArr) > 0) then
    Result := FMaxIdArr[High(FMaxIdArr)].MaxId;
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

end.
