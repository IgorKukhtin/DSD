unit uCache;

interface

uses
  Data.DB, Datasnap.DBClient, System.SysUtils, System.Classes,
  uIntf;

type
  TDataSetCacheItem = class(TInterfacedObject, IDataSetCacheItem)
  private
    FName: string;
    FParams: TParams;
    FDataSet: TDataSet;

    function GetName: string;
    function GetParams: TParams;
    function GetDataSet: TDataSet;

    procedure SetParams(ASource: TParams);
    procedure SetDataSet(ASource: TDataSet);
  protected
    procedure SetData(AName: string; AParams: TParams; ASource: TDataSet);
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    function IsEqual(AName: string; AParams: TParams): Boolean;

    property Name: string read GetName;
    property Params: TParams read GetParams;
    property DataSet: TDataSet read GetDataSet;
  end;

  TDataSetCache = class(TInterfacedObject, IDataSetCache)
  private
    FItems: IInterfaceList;
    FActiveDataSet: TDataSet;

    function GetActiveDataSet: TDataSet;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    procedure Add(AName: string; AParams: TParams; ASource: TDataSet);
    function Find(AName: string; AParams: TParams): IDataSetCacheItem;
    procedure Clear;

    property ActiveDataSet: TDataSet read GetActiveDataSet;
  end;

implementation

procedure TDataSetCacheItem.AfterConstruction;
begin
  inherited AfterConstruction;
  FParams := nil;
  FDataSet := nil;
end;

procedure TDataSetCacheItem.BeforeDestruction;
begin
  if Assigned(FParams) then
    FreeAndNil(FParams);

  if Assigned(FDataSet) then
    FreeAndNil(FDataSet);

  inherited BeforeDestruction;
end;

function TDataSetCacheItem.GetName: string;
begin
  Result := FName;
end;

function TDataSetCacheItem.GetParams: TParams;
begin
  Result := FParams;
end;

function TDataSetCacheItem.GetDataSet: TDataSet;
begin
  Result := FDataSet;
end;

procedure TDataSetCacheItem.SetParams(ASource: TParams);
begin
  if Assigned(FParams) then
    FreeAndNil(FParams);

  if Assigned(ASource) then
  begin
    FParams := TParams.Create(nil);
    FParams.Assign(ASource);
  end else
    FParams := nil;
end;

procedure TDataSetCacheItem.SetDataSet(ASource: TDataSet);
var
  I: Integer;
  FieldDef: TFieldDef;
  FieldType: TFieldType;
begin
  if Assigned(FDataSet) then
    FreeAndNil(FDataSet);

  if Assigned(ASource) then
  begin
    FDataSet := TClientDataSet.Create(nil);

    if not ASource.Active then
      ASource.Open;

    for I := 0 to Pred(ASource.FieldDefs.Count) do
    begin
      FieldDef := ASource.FieldDefs[I];
      FieldType := FieldDef.DataType;

      if FieldType = ftWideString then
        FieldType := ftString;

      FDataSet.FieldDefs.Add(FieldDef.Name, FieldType, FieldDef.Size);
    end;

    (FDataSet as TClientDataSet).CreateDataSet;
    ASource.First;

    while not ASource.Eof do
    begin
      FDataSet.Append;
      FDataSet.CopyFields(ASource);
      FDataSet.Post;

      ASource.Next;
    end;
  end else
    FDataSet := nil;
end;

function TDataSetCacheItem.IsEqual(AName: string; AParams: TParams): Boolean;
var
  I: Integer;
  Param: TParam;
begin
  Result := (FName = AName);

  if Assigned(AParams) then
    Result := Result and Assigned(FParams)
  else
    Result := Result and (not Assigned(FParams));

  if Result and Assigned(AParams) and Assigned(FParams) then
  begin
    Result := Result and (AParams.Count = FParams.Count);

    if Result then
      for I := 0 to Pred(AParams.Count) do
      begin
        Param := FParams.FindParam(AParams[I].Name);
        Result := Result and Assigned(Param);

        if Result then
          Result := Result and (AParams[I].Value = Param.Value);

        if not Result then
          Exit;
      end;
  end;
end;

procedure TDataSetCacheItem.SetData(AName: string; AParams: TParams; ASource: TDataSet);
begin
  FName := AName;
  SetParams(AParams);
  SetDataSet(ASource);
end;

procedure TDataSetCache.AfterConstruction;
begin
  inherited AfterConstruction;
  TInterfaceList.Create.GetInterface(IInterfaceList, FItems);
  FActiveDataSet := nil;
end;

procedure TDataSetCache.BeforeDestruction;
begin
  FItems := nil;
  FActiveDataSet := nil;
  inherited BeforeDestruction;
end;

function TDataSetCache.GetActiveDataSet: TDataSet;
begin
  Result := FActiveDataSet;
end;

procedure TDataSetCache.Add(AName: string; AParams: TParams; ASource: TDataSet);
var
  Item: IDataSetCacheItem;
begin
  if Find(AName, AParams) <> nil then
    raise Exception.Create('Item is already exists.');

  with TDataSetCacheItem.Create do
  begin
    SetData(AName, AParams, ASource);
    FActiveDataSet := DataSet;
    GetInterface(IDataSetCacheItem, Item);
  end;

  FItems.Add(Item);
end;

function TDataSetCache.Find(AName: string; AParams: TParams): IDataSetCacheItem;
var
  I: Integer;
begin
  Result := nil;

  for I := 0 to Pred(FItems.Count) do
    if Supports(FItems[I], IDataSetCacheItem, Result) then
      if Result.IsEqual(AName, AParams) then
      begin
        FActiveDataSet := Result.DataSet;
        Break;
      end else
        Result := nil;
end;

procedure TDataSetCache.Clear;
begin
  FItems.Clear;
  FActiveDataSet := nil;
end;

initialization
  TDataSetCache.Create.GetInterface(IDataSetCache, DataSetCache);
finalization
  DataSetCache := nil;
end.
