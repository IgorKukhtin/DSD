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
* RDBClass.pas - classes structure for table replication  and mapping          *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit RDBClass;

interface
uses
  Windows, SysUtils, Classes;

type

  TMetaTable = class;
  TMetaSchema = class;
  TMetaField = class;
  TMetaIndex = class;
  TMetaClassList = class;
  TMetaFieldList = class;
  TMetaIndexList = class;
  TMetaTableList = class;
  TMetaSchemaList = class;

  TMetaFlag = (mfApply, mfError, mfAlterIndex, mfUserSQL, mfUserModified, mfUnknown);
  TMetaFlags = set of TMetaFlag;
  TMetaClass = class
  private
    FRecNo: Integer;
    FIndex: Integer;
    FDisable: Boolean;
    FFlags: TMetaFlags;
    FChecked: Boolean;
    FName: string;
    FAlter: Boolean;
    FList: TMetaClassList;
    procedure SetName(const Value: string);
  public
    constructor Create; virtual;
    function TextValue(Index: Integer): string; virtual; abstract;
    property RecNo: Integer read FRecNo;
    property Name: string read FName write SetName;
    property Index: Integer read FIndex;
    property Disable: Boolean read FDisable write FDisable;
    property Checked: Boolean read FChecked write FChecked;
    property Flags: TMetaFlags read FFlags write FFlags;
    property Alter: Boolean read FAlter write FAlter;
  end;

  TMetaField = class(TMetaClass)
  private
    FTable: TMetaTable;
    FTypeName: string;
    FDataType: Integer;
    FPK: Boolean;
    FDataTypeOrigin: Integer;
  public
    function TextValue(Index: Integer): string; override;
    property Table: TMetaTable read FTable write FTable;
    property TypeName: string read FTypeName write FTypeName;
    property DataTypeOrigin: Integer read FDataTypeOrigin write FDataTypeOrigin;
    property DataType: Integer read FDataType write FDataType;
    property PK: Boolean read FPK write FPK;
  end;


  TMetaIndexKind = (ikNonUnique, ikUnique, ikPrimaryKey);
  TMetaIndex = class(TMetaClass)
  private
    FFields: TMetaFieldList;
    FKind: TMetaIndexKind;
    FTable: TMetaTable;
  public
    constructor Create; override;
    destructor Destroy; override;
    //property RecNo: Integer read FRecNo write FRecNo;
    property Table: TMetaTable read FTable write FTable;
    //property Name: string read FName write FName;
    property Kind: TMetaIndexKind read FKind write FKind;
    property Fields: TMetaFieldList read FFields write FFields;
  end;

  TMetaTableKind = (tkSynonym, tkTable, tkView, tkTempTable, tkLocalTable);
  TMetaTableKinds = set of TMetaTableKind;

  TMetaTable = class(TMetaClass)
  private
    FSchema: TMetaSchema;
    FKind: TMetaTableKind;
    FFields: TMetaFieldList;
    FIndexes: TMetaIndexList;
    FUser: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    function TextValue(Index: Integer): string; override;
    //property RecNo: Integer read FRecNo write FRecNo;
    property Schema: TMetaSchema read FSchema write FSchema;
    //property Name: string read FName write FName;
    property Kind: TMetaTableKind read FKind write FKind;
    property Fields: TMetaFieldList read FFields write FFields;
    property Indexes: TMetaIndexList read FIndexes write FIndexes;
    property User: string read FUser write FUser;
  end;

  TMetaSchema = class (TMetaClass)
  private
    FPrivileges: string;
    FUser: string;
    FDescription: string;
    FTables: TMetaTableList;
  public
    constructor Create; override;
    destructor Destroy; override;
    //property RecNo: Integer read FRecNo write FRecNo;
   // property Name: string read FName write FName;
    property User: string read FUser write FUser;
    property Privileges: string read FPrivileges write FPrivileges;
    property Description: string read FDescription write FDescription;
    property Tables: TMetaTableList read FTables write FTables;
  end;

  TMapKind = (mkMaster, mkSlave);

  TMapMetaFileds = class(TMetaClass)
    master: TMetaField;
    slave: TMetaField;
  end;

  TMapMetaTables = class(TMetaClass)
    master: TMetaTable;
    slave: TMetaTable;
  end;

  TMapMeta = class (TMetaClass)
  private
    FTables: array [TMapKind] of TMetaTable;
    FFields: array [TMapKind] of TMetaFieldList;
    FSQL: array [TMapKind, 0..3] of string;
    function GetField(const MapKind: TMapKind;
      const Index: Integer): TMetaField;
    function GetTable(const MapKind: TMapKind): TMetaTable;
    procedure SetField(const MapKind: TMapKind; const Index: Integer;
      const Value: TMetaField);
    procedure SetTable(const MapKind: TMapKind; const Value: TMetaTable);
    function GetSQL(const MapKind: TMapKind; const Index: Integer): string;
    procedure SetSQL(const MapKind: TMapKind; const Index: Integer;
      const Value: string);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AddTables(master, slave: TMetaTable);
    function AddFields(master, slave: TMetaField): Integer;
    function FieldCount: Integer;
    function IsTableApply: Boolean;
    procedure Clear;
    procedure ResetSQLs;
    procedure GeneraSQLs;
    function GetListField(MapKind: TMapKind): string;
    property Tables[const MapKind: TMapKind]: TMetaTable read GetTable write SetTable;
    property Fields[const MapKind: TMapKind;
                    const Index: Integer]: TMetaField read GetField write SetField;
    property SQLAlter[const MapKind: TMapKind]: string index 0 read GetSQL write SetSQL;
    property SQLSelect[const MapKind: TMapKind]: string index 1 read GetSQL write SetSQL;
    property SQLUpdate[const MapKind: TMapKind]: string index 2 read GetSQL write SetSQL;
    property SQLInsert[const MapKind: TMapKind]: string index 3 read GetSQL write SetSQL;


  end;

  TMetaClassList = class
  private
    FList: TStringList;
    FItems: array of TMetaClass;
    FCount: Integer;
    FOnwed: Boolean;
    FSetItemEnable: Boolean;
    procedure InitStringList; inline;
    function GetItemByName(const Name: string): TMetaClass;
    function GetItemByRecNo(const RecNo: Integer): TMetaClass;
    function GetItem(const Index: Integer): TMetaClass;
    procedure SetItem(const Index: Integer; const Value: TMetaClass);
    procedure UpdateMeta(MetaClass: TMetaClass);
  public
    constructor Create(Owned: Boolean);
    destructor Destroy; override;
    function Add(MetaClass: TMetaClass): Integer; overload;
    //function Add: TMetaClass; overload; virtual; abstract;

    procedure Clear;

    function Strings: TStrings;
    //function TextValue(Index: Integer): string; virtual; abstract;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure Pack;
    property Items[const Index: Integer]: TMetaClass read GetItem; default;// write SetItem; default;
    property ItemsByName[const Name: string]: TMetaClass read GetItemByName;
    property ItemsByRecNo[const RecNo: Integer]: TMetaClass read GetItemByRecNo;
    property Count: Integer read FCount;
  end;


  TMetaClassListEx<T: class> = class (TMetaClassList)
    private
      function GetItem(const Index: Integer): T; inline;
      procedure SetItem(const Index: Integer; const Value: T); inline;
      class function ReinterpretCast<U>(const Value): U;
    public
      function Add: T; overload;
      property Items[const Index: Integer]: T read GetItem; default;// write SetItem; default;
  end;
  TMetaClassClass = class of TMetaClass;
  TMetaClassListClass = class of TMetaClassList;
  TMetaFieldList = class (TMetaClassListEx<TMetaField>);
  TMetaIndexList = class (TMetaClassListEx<TMetaIndex>);
  TMetaTableList = class (TMetaClassListEx<TMetaTable>);
  TMetaSchemaList = class (TMetaClassListEx<TMetaSchema>);
  TMapMetaTableList = class (TMetaClassListEx<TMapMeta>);

implementation
uses
  TypInfo;
var
  UniqueRecNo: Integer = 1;


{ TMetaClass }

constructor TMetaClass.Create;
begin
  inherited;
  FRecNo := UniqueRecNo;
  Inc(UniqueRecNo);
  FChecked := true;
end;

procedure TMetaClass.SetName(const Value: string);
begin
  if (FName <> Value) then
    begin
      FName := Value;
      if Assigned(FList) then
        FList.UpdateMeta(Self);
    end;
end;

{ TMetaClassList }

function TMetaClassList.Add(MetaClass: TMetaClass): Integer;
var
  capacity: Integer;
begin
  capacity := 0;
  if Assigned(FList) then
    begin
      if not FList.Updating then
        if MetaClass <> nil then
           FList.AddObject(MetaClass.Name, MetaClass) else
           FList.AddObject('', nil);
      capacity := FList.Capacity;
    end;
 if capacity = 0 then
    capacity := FCount + 16;
  if FCount = Length(FItems) then
    SetLength(FItems, capacity);
  FItems[FCount] := MetaClass;
  if (MetaClass <> nil) and FOnwed then
    MetaClass.FIndex := FCount;
  Inc(FCount);
end;

procedure TMetaClassList.BeginUpdate;
begin
  if Assigned(FList) then
    begin
      FList.BeginUpdate;
      FList.Sorted := false;
    end;
end;

procedure TMetaClassList.Clear;
var
  I: Integer;
begin
  if Assigned(FList) then
    FList.Clear;
  if FOnwed then
    for I := 0 to FCount-1 do
      FItems[i].Free;
  SetLength(FItems, 0);
  FCount := 0;
end;

constructor TMetaClassList.Create(Owned: Boolean);
begin
  inherited Create;
  FOnwed := Owned;
  FSetItemEnable := false;
end;

destructor TMetaClassList.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

type
  TXStrings = class (TSTringList);
procedure TMetaClassList.EndUpdate;
begin
  if Assigned(FList) then
    begin
      if TXStrings(FList).UpdateCount = 1 then
        InitStringList;
      FList.EndUpdate;
      FList.Sorted := not FList.Updating;
    end;
end;

function TMetaClassList.GetItem(const Index: Integer): TMetaClass;
begin
  Result := FItems[Index];
end;

function TMetaClassList.GetItemByName(const Name: string): TMetaClass;
var
  i: Integer;
begin
  InitStringList;
  i := FList.IndexOf(Name);
  if i <> -1 then
    Result := TMetaClass(FList.Objects[i]) else
    Result := nil;
end;

function TMetaClassList.GetItemByRecNo(const RecNo: Integer): TMetaClass;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FCount-1 do
    if FItems[i].RecNo = RecNo then
      begin
        Result := FItems[i];
        break;
      end;
end;

procedure TMetaClassList.InitStringList;
var
  I: Integer;
begin
  if not Assigned(FList) or (FList.Count <> FCount) then
    begin
      if not Assigned(FList) then
        FList := TStringList.Create;
      FList.BeginUpdate;
      try
        FList.Clear;
        FList.Capacity := FCount;
        for I := 0 to FCount-1 do
          FList.AddObject(FItems[i].Name, FItems[i]);
      finally
        FList.EndUpdate;
      end;
      FList.Sorted := not FList.Updating;
    end;
end;

procedure TMetaClassList.Pack;
begin
  if Assigned(FList) then
    FList.Capacity := FCount;
  SetLength(FItems, FCount);
end;

procedure TMetaClassList.SetItem(const Index: Integer; const Value: TMetaClass);
begin
  if not FSetItemEnable then
    begin
      raise Exception.Create('List is read only. Set item not allowed');
    end;

  if FItems[Index] <> Value then
    begin
      if Assigned(Flist) and not FList.Updating then
        begin
          FList.Objects[Index] := Value;
          FList[Index] := Value.Name;
        end;
      FItems[Index] := Value;
    end;
end;

function TMetaClassList.Strings: TStrings;
begin
  InitStringList;
  Result := FList;
end;




procedure TMetaClassList.UpdateMeta(MetaClass: TMetaClass);
var
  i: Integer;
begin
  if Assigned(FList) and  not FList.Updating  then
    begin
      i := FList.IndexOfObject(MetaClass);
      if i <> -1 then
        FList[i] := MetaClass.Name else
        FLIst.AddObject(MetaClass.Name, MetaClass);

    end;

end;

{ **************************************************************************** }
{                               TMetaClassListEx<T>                            }
{ **************************************************************************** }



function TMetaClassListEx<T>.Add: T;
var
  o: TMetaClass;
begin
  o := TMetaClassClass(T).Create;
  Result := ReinterpretCast<T>(o);
  inherited Add(o);
end;

function TMetaClassListEx<T>.GetItem(const Index: Integer): T;
var
  v: TMetaClass;
begin
  v := inherited GetItem(Index);
  Result := ReinterpretCast<T>(v);
end;

class function TMetaClassListEx<T>.ReinterpretCast<U>(const Value): U;
begin
  Result := U(Value);
end;

procedure TMetaClassListEx<T>.SetItem(const Index: Integer; const Value: T);
var
  v: TMetaClass;
begin
  v := ReinterpretCast<TMetaClass>(Value);
  inherited SetItem(Index, V);
end;


{ TMetaIndex }

constructor TMetaIndex.Create;
begin
  inherited;
  Fields := TMetaFieldList.Create(false);
end;

destructor TMetaIndex.Destroy;
begin
  FFields.Free;
  inherited;
end;

{ TMetaTable }

constructor TMetaTable.Create;
begin
  inherited;
  FFields  := TMetaFieldList.Create(true);
  FIndexes := TMetaIndexList.Create(true);
end;

destructor TMetaTable.Destroy;
begin
  FFields.Free;
  FIndexes.Free;
  inherited;
end;

function TMetaTable.TextValue(Index: Integer): string;
var
  v: Integer;
begin
  case Index  of
    0: Result := IntToStr(Index);
    1: Result := Schema.Name;
    2: Result := Name;
    3: Result := GetEnumName(TypeInfo(TMetaTableKind), Integer(Kind));
    4: Result := User;
    5: Result := SetToString(PTypeInfo(TypeInfo(TMetaFlags)), PInteger(@Flags)^, true);
  end;
end;

{ TMetaSchema }

constructor TMetaSchema.Create;
begin
  inherited;
  FTables := TMetaTableList.Create(true);
end;

destructor TMetaSchema.Destroy;
begin
  FTables.Free;
  inherited;
end;

{ TMapMetaTables }

function TMapMeta.AddFields(master, slave: TMetaField): Integer;
begin
  Result := FFields[mkMaster].Add(master);
  FFields[mkSlave].Add(slave);
end;

procedure TMapMeta.AddTables(master, slave: TMetaTable);
begin
  Clear;
  FTables[mkMaster] := master;
  FTables[mkSlave]  := slave;
end;

procedure TMapMeta.Clear;
var
  I: Integer;
begin
  ResetSQLs;
  for I := 0 to FFields[mkMaster].Count-1 do
    begin
    if (FFields[mkMaster][i] <> nil) and FFields[mkMaster][i].Alter then
          FFields[mkMaster][i].Free;
    if (FFields[mkSlave][i] <> nil) and FFields[mkSlave][i].Alter then
          FFields[mkSlave][i].Free;
    end;
  FFields[mkMaster].Clear;
  FFields[mkSlave].Clear;
  FTables[mkMaster] := nil;
  FTables[mkSlave] := nil;
end;

constructor TMapMeta.Create;
begin
  inherited;
  FFields[mkMaster] := TMetaFieldList.Create(false);
  FFields[mkSlave] := TMetaFieldList.Create(false);
  FFields[mkMaster].FSetItemEnable := true;
  FFields[mkSlave].FSetItemEnable := true;

end;

destructor TMapMeta.Destroy;
begin
  Clear;
  FFields[mkMaster].Free;
  FFields[mkSlave].Free;
  inherited;
end;

function TMapMeta.FieldCount: Integer;
begin
  Result := FFields[mkMaster].Count
end;

procedure TMapMeta.GeneraSQLs;
begin

end;

function TMapMeta.GetField(const MapKind: TMapKind;
  const Index: Integer): TMetaField;
begin
  Result := FFields[MapKind][Index]
end;

function TMapMeta.GetListField(MapKind: TMapKind): string;
var
  l: TMetaFieldList;
  i: Integer;
begin
  l := FFields[MapKind];
  Result := '';
  for I := 0 to l.Count-1 do
    if i = 0 then
      Result := l[i].Name else
      Result := Result + ', '+l[i].Name
end;

function TMapMeta.GetSQL(const MapKind: TMapKind; const Index: Integer): string;
begin
  Result := FSQL[MapKind, Index];
end;

function TMapMeta.GetTable(const MapKind: TMapKind): TMetaTable;
begin
  Result := FTables[MapKind]
end;

function TMapMeta.IsTableApply: Boolean;
begin
  Result := Assigned(FTables[mkMaster]) and Assigned(FTables[mkSlave])
end;

procedure TMapMeta.ResetSQLs;
var
  I: Integer;
begin
  for I := 0 to Length(FSQL[mkMaster])-1 do
    begin
      FSQL[mkMaster, i] := '';
      FSQL[mkSlave, i] := '';
    end;
end;

procedure TMapMeta.SetField(const MapKind: TMapKind; const Index: Integer;
  const Value: TMetaField);
var
  i: Integer;
begin
  i := Index;
  if Index >= FFields[MapKind].Count then
    i := AddFields(nil, nil);
  FFields[MapKind].SetItem(i, Value);
end;

procedure TMapMeta.SetSQL(const MapKind: TMapKind; const Index: Integer;
  const Value: string);
begin
  FSQL[MapKind, Index] := Value;
end;

procedure TMapMeta.SetTable(const MapKind: TMapKind; const Value: TMetaTable);
begin
  if FTables[MapKind] <> Value then
    begin
      FTables[MapKind] := Value;
      FFields[mkMaster].Clear;
      FFields[mkSlave].Clear;
    end;
end;

{ TMetaField }

function TMetaField.TextValue(Index: Integer): string;
begin
  case Index  of
    0: Result := IntToStr(Index);
    1: Result := Name;
    2: Result := TypeName;
//    3: Result := GetEnumName(TypeInfo(TMetaTableKind), Integer(f.Kind));
  end;
end;

end.
