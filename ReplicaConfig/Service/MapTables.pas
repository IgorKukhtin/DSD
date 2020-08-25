{==============================================================================*
* Copyright © 2020, Pukhkiy Igor                                               *
* All rights reserved.                                                         *
*==============================================================================*
* This Source Code Form is subject to the terms of the Mozilla                 *
* Public License, v. 2.0. If a copy of the MPL was not distributed             *
* with this file, You can obtain one at http://mozilla.org/MPL/2.0/.           *
*==============================================================================*
* The Initial Developer of the Original Code is Pukhkiy Igor (Ukraine).        *
* Contacts: nspytnik-programming@yahoo.com                                     *
*==============================================================================*
* DESCRIPTION:                                                                 *
* MapTables.pas - map tables for replication                                   *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit MapTables;

interface
uses
  Windows, SysUtils, Classes, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param;
type
  ETableRelationError = class(Exception);
  TTableNode = class;
  TSlaveTableNode = class;
  TMasterTableNode = class;
  TArrayListNode = array of TTableNode;
  TArrayOfString = TArray<string>;
  TArrayOfVariant = array of Variant;
  TArrayOfFieldType = array of TFieldType;
  TArrayOfFields = array of TField;
  TArrayOfParams = array of TFDParam;


  TDMLOperation = (dmlUnknown, dmlInsert, dmlUpdate, dmlDelete);
  //reqSI = request select for Insert
  //reqSU = request select for Delete
  TTypeRuquest = (reqSI, reqSU, reqU, reqI, reqD);
  PRequest = ^TRequest;
  TRequest = record
    _type: TTypeRuquest;
    query: TFDQuery;
    map_params: TArrayOfParams;
  end;
  TMapKind = (mkMaster, mkSlave);

  TCreateMapQuery = function (RequestType: TTypeRuquest): TFDQuery of object;
  TDataChangedDDL = record
    query: string;
    last_modified: TDateTime;
  end;



  PDataChangedInfo = ^TDataChangedInfo;
  TDataChangedInfo = record
    id: Integer;
    schema_name: string;
    table_name: string;
    key_names: TArrayOfString;
    key_values: TArrayOfString;
    changed_fields: TArrayOfString;
    operation: TDMLOperation;
    last_modified: TDateTime;
    transaction_id: Int64;
    user_name: string;
    root: Boolean;
    next: PDataChangedInfo;
  end;

  TListChangedDLL = array of TDataChangedDDL;
  TListTDataChangedInfo = array of TDataChangedInfo;
  TListAffectedRows = array [TDMLOperation] of Integer;

  PFieldInfo = ^TFieldInfo;
  TFieldInfo = record
    FieldName: string;
    FieldType: TFieldType;
  end;

  TTableNode = class
  private
    FTable: string;
    FSchema: string;
    FName: string;
    FPrimaryKeys: array of TFieldInfo;
    FFields: array of TFieldInfo;
    FFieldCount: Integer;
    FFieldDefsUpdated: Boolean;
    FNormalizedName: string;
    FFieldList: string;
    FFixUPField: string;
    function GetField(Index: Integer): PFieldInfo;
    function GetPrimaryCount: Integer;
    function GetPrimaryKey(Index: Integer): PFieldInfo;
    function GetFieldCount: Integer;
  public

    property Table: string read FTable write FTable;
    property Schema: string read FSchema write FSchema;
    property Name: string read FName write FName;
    property NormalizedName: string read FNormalizedName write FNormalizedName;


    procedure UpdatePrimaryKeys(v: TFieldDefs);
    procedure UpdateFields(v: TFieldDefs);
    property FixUPField: string read FFixUPField write FFixUPField;
    function FixUP: Boolean;
    function FixUPOperator: string;
    function ContainsField(const FieldName: string): Boolean;
    function GetPGClassFieldFrom(f: PFieldInfo): string;
    function GetPGClassFieldInto(f: PFieldInfo): string;
    function FieldByName(const FieldName: string): PFieldInfo;
    property PrimaryKey[Index: Integer]: PFieldInfo read GetPrimaryKey;
    property PrimaryCount: Integer read GetPrimaryCount;
    property FieldList: string read FFieldList write FFieldList;
    property Fields[Index: Integer]: PFieldInfo read GetField;
    property FieldCount: Integer read GetFieldCount;
    property FieldDefsUpdated: Boolean read FFieldDefsUpdated write FFieldDefsUpdated;
  end;

  TMasterTableNode = class (TTableNode)
  private
    FSlave: TSlaveTableNode;
  public
    procedure AddSlave(node: TSlaveTableNode);
    property Slave: TSlaveTableNode read FSlave write FSlave;
  end;
  
  TSlaveTableNode = class (TTableNode)
  private
    FRequests: array [TTypeRuquest] of TRequest;
    FForeignTables: TArrayListNode;
    FParentCount: Integer;
    FSubling: TSlaveTableNode;
    FGetMapQuery: TCreateMapQuery;
    FID: Integer;
    FCODE: int64;
    FLastRowID: Int64;
    FDownLoaded: Boolean;
    FLastModified: TDateTime;
    FMaster: TMasterTableNode;
    FChanged: Boolean;
    procedure AddForeign(Node: TSlaveTableNode);
    procedure AddSubling(Node: TSlaveTableNode);
    function GetRequest(RequestType: TTypeRuquest): PRequest;
    procedure SetDownLoaded(const Value: Boolean);
    procedure SetLastModified(const Value: TDateTime);
    function GetForeign(const Index: Integer): TSlaveTableNode;
    procedure SetLastRowID(const Value: Int64);

  public
    Data: PDataChangedInfo;
    rows: TListAffectedRows;
    prev_changed_fields: TArrayOfString;

    destructor Destroy; override;
    function GetSubling(var Node: TSlaveTableNode): Boolean;
    procedure ResetRequests;
    function CastPKValue(Index: Integer; const Value: string): Variant;
    procedure ReindexRequestParam(RequestType: TTypeRuquest);
    procedure ResetStateChanges;

    property Changed: Boolean read FChanged write FChanged;
    property Request[RequestType: TTypeRuquest]: PRequest read GetRequest;
    property ForeignTables[const Index: Integer]: TSlaveTableNode read GetForeign;
    property ParentCount: Integer read FParentCount;
    property CreateMapQueryFunc: TCreateMapQuery read FGetMapQuery write FGetMapQuery;
    property Master: TMasterTableNode read FMaster write FMaster;
    
    property ID: Integer read FID write FID;
    property CODE: Int64 read FCODE write FCODE;
    property last_row_id: Int64 read FLastRowID write SetLastRowID;
    property DownLoaded: Boolean read FDownLoaded write SetDownLoaded;
    property last_modified: TDateTime read FLastModified write SetLastModified;
    
  end;



  TRelationNodeList = class
  private
    FSlaves: TArrayListNode;
    FMasters: TArrayListNode;
    FCountSlave: Integer;
    FCountMaster: Integer;
    FSorted: Boolean;
    FCapacity: Integer;
    FRelationShipUpdated: Boolean;
    procedure SetCapacity(const Value: Integer);
    procedure Grow;
    procedure Error(Msg: PResStringRec; Data: Integer); overload;
    procedure Error(Msg: PResStringRec); overload;
    function Find(const list: TArrayListNode; const MasterName: string): TTableNode; overload;
    function Find(const list: TArrayListNode; const MasterName: string; var Index: Integer): Boolean; overload;
    function GetMaster(const Index: Integer): TMasterTableNode;
    function GetSlave(const Index: Integer): TSlaveTableNode;
    procedure Sort;
  public
    constructor Create(ACapacity: Integer);
    destructor Destroy; override;
    function IndexOfMaster(const Name: string): Integer;
    procedure Pack;
    procedure Clear;
    property Capacity: Integer read FCapacity write SetCapacity;
    property CountSlave: Integer read FCountSlave;
    property CountMaster: Integer read FCountMaster;
    procedure BuildRelationShip(const Owners, Childs: array of string);
    function NodeByMaster(const Name: string): TSlaveTableNode;
    function CreateNode(const MasterSchema, MasterTable, SlaveSchema, SlaveTable: string): TSlaveTableNode;
    property Slaves[const Index: Integer]: TSlaveTableNode read GetSlave;
    property Masters[const Index: Integer]: TMasterTableNode read GetMaster;
    property RelationShipUpdated: Boolean read FRelationShipUpdated write FRelationShipUpdated;

  end;


implementation

resourcestring
  rsMapCapacityError = 'List capacity out of bounds (%d)';
  rsSlaveNameEpty = 'Slave name not must by nil';
  rsMasterNameEpty = 'Master name not must by nil';
  //[] [00:00] Mike Oldfield - Ambient Guitars   </44 kHz/49 kbps/0 B/>
 // [] [00:00] Blank And Jones With Delerium And Rani - Fallen (Chillout Mix)   </44 kHz/49 kbps/0 B/>
{ TNaryNodeList }



procedure TRelationNodeList.BuildRelationShip(const Owners, Childs: array of string);
var
  I, C, J, K: Integer;
  owner, child: TSlaveTableNode;
begin
  if (Length(Owners) <> Length(Childs)) then
    raise Exception.Create('Size  must be equal');

  for I := 0 to FCountSlave-1 do
    begin
      child := TSlaveTableNode(FSlaves[i]);
      SetLength(child.FForeignTables, 0);
      child.FParentCount := 0;
    end;

  for I := 0 to Length(Owners)-1 do
    for J := 0 to FCountSlave-1 do
      if FSlaves[J].FName = Owners[i] then
        begin
          owner := TSlaveTableNode(FSlaves[J]);
          for K := 0 to FCountSlave-1 do
            if (K <> J) and (FSlaves[K].FName = Childs[i]) then
              begin
                child := TSlaveTableNode(FSlaves[K]);
                c := child.FParentCount;
                child.FParentCount := c + 1;
                SetLength(child.FForeignTables, child.FParentCount);
                child.FForeignTables[c] := owner;
              end;
        end;

  RelationShipUpdated := true;
end;

procedure TRelationNodeList.Clear;
var
  i: Integer;
begin
  for I := 0 to FCountSlave-1 do
    FSlaves[i].Free;
  for I := 0 to FCountMaster-1 do
    FMasters[i].Free;
  SetLength(FMasters, 0);
  SetLength(FSlaves, 0);
  FCountSlave  := 0;
  FCountMaster := 0;
  FCapacity := 0;
end;

constructor TRelationNodeList.Create(ACapacity: Integer);
begin
  inherited Create;
  SetCapacity(ACapacity);
end;

function TRelationNodeList.CreateNode(const MasterSchema, MasterTable,
  SlaveSchema, SlaveTable: string): TSlaveTableNode;
var
  Index: Integer;

begin
  if (FCountSlave = FCapacity) or (FCountMaster = FCapacity) then Grow;
//  MasterSchema, MasterTable,
//  SlaveSchema, SlaveTable check empty names
//  if Slave.Name = '' then
//    Error(@rsSlaveNameEpty);
//  if Master = '' then
//    Error(@rsSlaveNameEpty);
    
    
  Index :=  IndexOfMaster(MasterSchema+'.'+MasterTable);
  if Index = -1 then
    begin
      FMasters[FCountMaster]         := TMasterTableNode.Create;
      FMasters[FCountMaster].FName   := MasterSchema+'.'+MasterTable;
      FMasters[FCountMaster].FSchema := MasterSchema;
      FMasters[FCountMaster].FTable  := MasterTable;
      Index := FCountMaster;
      Inc(FCountMaster);
      FSorted := false;
    end;
  FSlaves[FCountSlave]         := TSlaveTableNode.Create;
  FSlaves[FCountSlave].FName   := SlaveSchema+'.'+SlaveTable;
  FSlaves[FCountSlave].FSchema := SlaveSchema;
  FSlaves[FCountSlave].FTable  := SlaveTable;
  TMasterTableNode(FMasters[Index]).AddSlave(TSlaveTableNode(FSlaves[FCountSlave]));
  Result  := TSlaveTableNode(FSlaves[FCountSlave]);
  Inc(FCountSlave);
  Sort;
end;

destructor TRelationNodeList.Destroy;
begin
  Clear;
  inherited;
end;

procedure TRelationNodeList.Error(Msg: PResStringRec);
begin
  raise ETableRelationError.Create(LoadResString(Msg)) at
    PPointer(PByte(@Msg) + SizeOf(Msg) + SizeOf(Self) + SizeOf(Pointer))^;
end;

procedure TRelationNodeList.Error(Msg: PResStringRec; Data: Integer);
begin
  raise ETableRelationError.CreateFmt(LoadResString(Msg), [Data]) at
    PPointer(PByte(@Msg) + SizeOf(Msg) + SizeOf(Self) + SizeOf(Pointer))^;
end;

function TRelationNodeList.Find(const list: TArrayListNode; const MasterName: string;
  var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  L := 0;
  H := FCountMaster - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C :=  CompareText(list[I].FName, MasterName);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        L := I; // < unique, abort
      end;
    end;
  end;
  Index := L;

end;

function TRelationNodeList.Find(const list: TArrayListNode;
  const MasterName: string): TTableNode;
var
  L, H, I, C: Integer;
begin
  Result := nil;
  L := 0;
  H := FCountMaster - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C :=  CompareText(list[I].FName, MasterName);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := list[I];
        L := I; // < unique
      end;
    end;
  end;

end;

function TRelationNodeList.GetMaster(const Index: Integer): TMasterTableNode;
begin
  Result := TMasterTableNode(FMasters[Index])  
end;

function TRelationNodeList.GetSlave(const Index: Integer): TSlaveTableNode;
begin
  Result := TSlaveTableNode(FSlaves[Index])
end;

procedure TRelationNodeList.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 then Delta := FCapacity div 4 else
    if FCapacity > 8 then Delta := 16 else
      Delta := 4;
  SetCapacity(FCapacity + Delta);

end;

function TRelationNodeList.IndexOfMaster(const Name: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  if FSorted then
    begin
      if Find(FMasters, Name, I) then Result := I;
    end
  else
    for I := 0 to FCountMaster-1 do
       if FMasters[I].Name = Name then
         begin
           Result := I;
           break;
         end;
end;

function TRelationNodeList.NodeByMaster(const Name: string): TSlaveTableNode;
var
  n: TMasterTableNode;
begin
  n := TMasterTableNode(Find(FMasters, Name));
  if n <> nil then
    Result := n.Slave else
    Result := nil;
end;

procedure TRelationNodeList.Pack;
begin
  SetLength(FSlaves, FCountSlave);
  SetLength(FMasters, FCountMaster);
  if FCountSlave > FCountMaster then
    FCapacity := FCountSlave else
    FCapacity := FCountMaster;
end;

procedure TRelationNodeList.SetCapacity(const Value: Integer);
begin
  if (Value < FCountSlave) or (Value < FCountMaster) then
    Error(@rsMapCapacityError, Value);
  if Value <> FCapacity then
  begin
    SetLength(FSlaves, Value);
    SetLength(FMasters, Value);
    FCapacity := Value;
  end;
end;

procedure TRelationNodeList.Sort;

  procedure _Exchange(var list: TArrayListNode; Index1, Index2: Integer);
  var
    Temp: TTableNode;
  begin
    Temp := list[Index1];
    list[Index1] := list[Index2];
    list[Index2] := Temp;
  end;

  procedure _BinarySort(var list: TArrayListNode; L, R: Integer);
  var
    I, J, P: Integer;
  begin
    repeat
      I := L;
      J := R;
      P := (L + R) shr 1;
      repeat
        while CompareText(list[I].FName, list[P].FName) < 0 do Inc(I);
        while CompareText(list[J].FName, list[P].FName) > 0 do Dec(J);
        if I <= J then
        begin
          if I <> J then
            _Exchange(list, I, J);
          if P = I then
            P := J
          else if P = J then
            P := I;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then _BinarySort(list, L, J);
      L := I;
    until I >= R;
  end;
begin
  if not FSorted and (FCountSlave > 0) then
    begin
      _BinarySort(FMasters, 0, FCountMaster - 1);
    end;
  FSorted := true;

end;

{ TTableNode }

procedure TSlaveTableNode.AddForeign(Node: TSlaveTableNode);
begin
  SetLength(FForeignTables, FParentCount + 1);
  FForeignTables[FParentCount] := Node;
  FParentCount := FParentCount + 1;
end;

procedure TSlaveTableNode.AddSubling(Node: TSlaveTableNode);
var
  n: TSlaveTableNode;
begin
  n := Self;
  while n.GetSubling(n) do ;
  n.FSubling := Node;
end;

function TSlaveTableNode.CastPKValue(Index: Integer; const Value: string): Variant;
begin
  try
    case PrimaryKey[Index].FieldType of
      ftInteger, ftSmallint, ftAutoInc,
      ftLargeint, ftLongWord, ftWord,
      ftByte, ftShortint : Result := StrToInt(Value);
      ftBoolean : Result := StrToBool(Value);
      ftFloat, ftCurrency, ftExtended, ftSingle: Result := StrToFloat(Value);
    else
      Result := Value;
    end;
  except
    //log error
    Result := Value;
  end;
end;

destructor TSlaveTableNode.Destroy;
begin
  inherited;
end;

function TSlaveTableNode.GetSubling(var Node: TSlaveTableNode): Boolean;
begin
  Result := FSubling <> nil;
  if Result then
    Node := FSubling;
end;

function TSlaveTableNode.GetForeign(const Index: Integer): TSlaveTableNode;
begin
  Result := TSlaveTableNode(FForeignTables[Index]);
end;

function TSlaveTableNode.GetRequest(RequestType: TTypeRuquest): PRequest;
begin
  Result := @FRequests[RequestType];
  if not Assigned(Result^.query) and Assigned(FGetMapQuery) then
    begin
      FRequests[RequestType]._type := RequestType;
      Result^.query := FGetMapQuery(RequestType);
     // FQueries[TypeQuery] := Result;
    end;
end;

procedure TSlaveTableNode.ReindexRequestParam(RequestType: TTypeRuquest);
var
  params: ^TArrayOfParams;
  query: TFDQuery;
  I: Integer;
begin
  params := @FRequests[RequestType].map_params;
  query  := FRequests[RequestType].query;
  SetLength(params^, query.ParamCount);
  for I := 0 to PrimaryCount-1 do
    params^[i] := query.ParamByName(PrimaryKey[i].FieldName);
end;

procedure TSlaveTableNode.ResetRequests;
var
  RequestType: TTypeRuquest;
begin
  for RequestType := Low(TTypeRuquest) to High(TTypeRuquest) do
    begin
      FRequests[RequestType].query.Free;
      FRequests[RequestType].query := nil;
      SetLength(FRequests[RequestType].map_params, 0);
    end;
  prev_changed_fields := nil;
  FillChar(rows, SizeOf(rows), 0);
end;

procedure TSlaveTableNode.ResetStateChanges;
begin
  FChanged := false;
end;

procedure TSlaveTableNode.SetDownLoaded(const Value: Boolean);
begin
  FDownLoaded := Value;
  FChanged := true;
end;

procedure TSlaveTableNode.SetLastModified(const Value: TDateTime);
begin
  FLastModified := Value;
  FChanged := true;
end;

procedure TSlaveTableNode.SetLastRowID(const Value: Int64);
begin
  FLastRowID := Value;
  FChanged   := true;
end;

{ TFieldSchema }

function TTableNode.ContainsField(const FieldName: string): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I := 0 to Length(FFields)-1 do
    begin
      Result := SameText(FFields[i].FieldName, FieldName);
      if Result then break;
    end;
end;

function TTableNode.FieldByName(const FieldName: string): PFieldInfo;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Length(FFields)-1 do
    if SameText(FFields[i].FieldName, FieldName) then
      begin
        Result := @FFields[i];
        break;
      end;
end;

function TTableNode.FixUP: Boolean;
begin
  Result := FFixUPField <> '';
end;

function TTableNode.FixUPOperator: string;
begin
  if FFixUPField <> '' then
    Result := '=' else Result := '';
end;

function TTableNode.GetField(Index: Integer): PFieldInfo;
begin
  Result := @FFields[Index]
end;

function TTableNode.GetFieldCount: Integer;
begin
  Result := Length(FFields);
end;

function TTableNode.GetPGClassFieldFrom(f: PFieldInfo): string;
begin
  case f.FieldType of
    ftDateTime, ftTime,
    ftTimeStamp, ftTimeStampOffset: Result := '::TEXT';
  else
    Result := '';
  end;
end;

function TTableNode.GetPGClassFieldInto(f: PFieldInfo): string;
begin
  case f.FieldType of
    ftDateTime, ftTime,
    ftTimeStamp, ftTimeStampOffset: Result := '::TIMESTAMP';
  else
    Result := '';
  end;
end;

function TTableNode.GetPrimaryCount: Integer;
begin
  Result := Length(FPrimaryKeys);
end;

function TTableNode.GetPrimaryKey(Index: Integer): PFieldInfo;
begin
  Result := @FPrimaryKeys[Index]
end;

procedure TTableNode.UpdateFields(v: TFieldDefs);
var
  i: Integer;
begin
  SetLength(FFields, v.Count);
  for i := 0 to v.Count-1 do
    begin
      FFields[i].FieldName := v[i].Name;
      FFields[i].FieldType := v[i].DataType;
    end;
end;

procedure TTableNode.UpdatePrimaryKeys(v: TFieldDefs);
var
  i: Integer;
begin
  SetLength(FPrimaryKeys, v.Count);
  for i := 0 to v.Count-1 do
    begin
      FPrimaryKeys[i].FieldName := v[i].Name;
      FPrimaryKeys[i].FieldType := v[i].DataType;
    end;
end;

{ TMasterTableNode }

procedure TMasterTableNode.AddSlave(node: TSlaveTableNode);
begin
  if FSlave = nil then
    FSlave := node else
    FSlave.AddSubling(node);
  Node.FMaster := Self;
end;

end.
