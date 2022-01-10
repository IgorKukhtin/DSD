unit ObjectTest;

interface

uses Classes, TestFramework, Authentication, Db, XMLIntf, dsdDB;

type
  TObjectTest = class
  private
    FspInsertUpdate: string;
    FspSelect: string;
    FspGet: string;
    FIdentity: integer;
  protected
    FdsdStoredProc: TdsdStoredProc;
    FParams: TdsdParams;
    property spGet: string read FspGet write FspGet;
    property spSelect: string read FspSelect write FspSelect;
    property spInsertUpdate: string read FspInsertUpdate write FspInsertUpdate;
    function InsertUpdate(dsdParams: TdsdParams): Integer;
    procedure InsertUpdateInList(Id: integer); virtual;
    function InsertDefault: integer; virtual;
    procedure SetDataSetParam; virtual;
  public
    procedure DeleteRecord(Id: Integer); virtual;
    function GetDefault: integer;
    function GetDataSet: TDataSet; virtual;
    function GetRecord(Id: integer): TDataSet; virtual;
    procedure Delete(Id: Integer); virtual;
    constructor Create; virtual;
    destructor Destoy;
  end;

  TMovementTest = class(TObjectTest)
  protected
    spCompleteProcedure: string;
    spUnCompleteProcedure: string;
    procedure InsertUpdateInList(Id: integer); override;
    procedure DocumentComplete(Id: integer);
    procedure DocumentUncomplete(Id: integer);
    procedure DeleteRecord(Id: Integer); override;
    procedure SetDataSetParam; override;
  public
    constructor Create; override;
    procedure Delete(Id: Integer); override;
  end;

  TMovementItemTest = class (TObjectTest)
  protected
    procedure InsertUpdateInList(Id: integer); override;
    procedure DeleteRecord(Id: Integer); override;
  public
    procedure Delete(Id: Integer); override;
  end;


implementation

uses Storage,  dbTest, SysUtils, DbClient;
{ TObjectTest }

constructor TObjectTest.Create;
begin
  FdsdStoredProc := TdsdStoredProc.Create(nil);
  FParams := TdsdParams.Create(nil, TdsdParam);
end;

procedure TObjectTest.DeleteRecord(Id: Integer);
const
   pXML =
  '<xml Session = "">' +
    '<lpDelete_Object OutputType="otResult">' +
       '<inId DataType="ftInteger" Value="%d"/>' +
    '</lpDelete_Object>' +
  '</xml>';
var i: integer;
begin
  TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [Id]));
  for i := 0 to DefaultValueList.Count - 1 do
      if DefaultValueList.Values[DefaultValueList.Names[i]] = IntToStr(Id) then begin
         DefaultValueList.Values[DefaultValueList.Names[i]] := '';
         break;
      end;
end;

procedure TObjectTest.Delete(Id: Integer);
var Index: Integer;
begin
  if InsertedIdObjectList.Find(IntToStr(Id), Index) then begin
     // здесь мы разрешаем удалять ТОЛЬКО вставленные в момент теста данные
     DeleteRecord(Id);
     InsertedIdObjectList.Delete(Index);
  end
  else
     raise Exception.Create('Попытка удалить запись, вставленную вне теста!!!');
end;

destructor TObjectTest.Destoy;
var i: integer;
begin
  FdsdStoredProc.Free;
end;

function TObjectTest.GetDataSet: TDataSet;
begin
  with FdsdStoredProc do begin
    if (DataSets.Count = 0) or not Assigned(DataSets[0].DataSet) then
       DataSets.Add.DataSet := TClientDataSet.Create(nil);
    StoredProcName := FspSelect;
    OutputType := otDataSet;
    FParams.Clear;
    SetDataSetParam;
    if FspSelect='gpSelect_Object_Partner' then FParams.AddParam('inJuridicalId', ftInteger, ptInput, 0);
    Params.Assign(FParams);
    Execute;
    result := DataSets[0].DataSet;
  end;
end;

function TObjectTest.GetDefault: integer;
begin
   if DefaultValueList.Values[ClassName] = '' then
      DefaultValueList.Values[ClassName] := IntToStr(InsertDefault);
   result := StrToInt(DefaultValueList.Values[ClassName]);
end;

function TObjectTest.GetRecord(Id: integer): TDataSet;
begin
  with FdsdStoredProc do begin
    DataSets.Add.DataSet := TClientDataSet.Create(nil);
    StoredProcName := spGet;
    OutputType := otDataSet;
    Params.Clear;
    Params.AddParam('ioId', ftInteger, ptInputOutput, Id);
    if spGet='gpGet_Object_Partner' then Params.AddParam('inJuridicalId', ftInteger, ptInput, 0);
    Execute;
    result := DataSets[0].DataSet;
  end;
end;

function TObjectTest.InsertDefault: integer;
begin
  DefaultValueList.Values[ClassName] := IntToStr(FIdentity);
end;

function TObjectTest.InsertUpdate(dsdParams: TdsdParams): Integer;
var OldId: integer;
begin
  with FdsdStoredProc do begin
    StoredProcName := FspInsertUpdate;
    OutputType := otResult;
    Params.Clear;
    Params.Assign(dsdParams);
    OldId := StrToInt(ParamByName('ioId').Value);
    Execute;
    Result := StrToInt(ParamByName('ioId').Value);
    FIdentity := Result;
    if OldId <> Result then
       InsertUpdateInList(Result)
  end;
end;

procedure TObjectTest.InsertUpdateInList(Id: integer);
begin
  InsertedIdObjectList.Add(IntToStr(Id));
end;

procedure TObjectTest.SetDataSetParam;
begin
  FdsdStoredProc.Params.Clear;
end;


{ TMovementTest }

constructor TMovementTest.Create;
begin
  inherited;
  spUnCompleteProcedure := 'gpUnComplete_Movement';
end;

procedure TMovementTest.Delete(Id: Integer);
var Index: Integer;
begin
  if InsertedIdMovementList.Find(IntToStr(Id), Index) then begin
     // здесь мы разрешаем удалять ТОЛЬКО вставленные в момент теста данные
     DeleteRecord(Id);
     InsertedIdMovementList.Delete(Index);
  end
  else
     raise Exception.Create('Попытка удалить запись, вставленную вне теста!!!');
end;

procedure TMovementTest.DeleteRecord(Id: Integer);
const
  pXML =
  '<xml Session = "">' +
    '<lpDelete_Movement OutputType="otResult">' +
       '<inId DataType="ftInteger" Value="%d"/>' +
    '</lpDelete_Movement>' +
  '</xml>';
var i: integer;
begin
  TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [Id]));
  for i := 0 to DefaultValueList.Count - 1 do
      if DefaultValueList.Values[DefaultValueList.Names[i]] = IntToStr(Id) then begin
         DefaultValueList.Values[DefaultValueList.Names[i]] := '';
         break;
      end;
end;

procedure TMovementTest.DocumentComplete(Id: integer);
begin
  with FdsdStoredProc do begin
    StoredProcName := spCompleteProcedure;
    OutputType := otResult;
    Params.Clear;
    Params.AddParam('inMovementId', ftInteger, ptInput, Id);
    Execute;
  end;
end;

procedure TMovementTest.DocumentUncomplete(Id: integer);
begin
  with FdsdStoredProc do begin
    StoredProcName := spUnCompleteProcedure;
    OutputType := otResult;
    Params.Clear;
    Params.AddParam('inMovementId', ftInteger, ptInput, Id);
    Execute;
  end;
end;

procedure TMovementTest.InsertUpdateInList(Id: integer);
begin
  InsertedIdMovementList.Add(IntToStr(Id));
end;

procedure TMovementTest.SetDataSetParam;
begin
  inherited;
  FParams.AddParam('inStartDate', ftDateTime, ptInput, FloatToDateTime(Date - 1));
  FParams.AddParam('inEndDate', ftDateTime, ptInput, Date);
end;


{ TMovementItemTest }

procedure TMovementItemTest.Delete(Id: Integer);
var Index: Integer;
begin
  if InsertedIdMovementItemList.Find(IntToStr(Id), Index) then begin
     // здесь мы разрешаем удалять ТОЛЬКО вставленные в момент теста данные
     DeleteRecord(Id);
     InsertedIdMovementItemList.Delete(Index);
  end
  else
     raise Exception.Create('Попытка удалить запись, вставленную вне теста!!!');
end;

procedure TMovementItemTest.DeleteRecord(Id: Integer);
const
   pXML =
  '<xml Session = "">' +
    '<lpDelete_MovementItem OutputType="otResult">' +
       '<inId DataType="ftInteger" Value="%d"/>' +
    '</lpDelete_MovementItem>' +
  '</xml>';
var i: integer;
begin
  TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [Id]));
  for i := 0 to DefaultValueList.Count - 1 do
      if DefaultValueList.Values[DefaultValueList.Names[i]] = IntToStr(Id) then begin
         DefaultValueList.Values[DefaultValueList.Names[i]] := '';
         break;
      end;
end;

procedure TMovementItemTest.InsertUpdateInList(Id: integer);
begin
  InsertedIdMovementItemList.Add(IntToStr(Id));
end;



end.
