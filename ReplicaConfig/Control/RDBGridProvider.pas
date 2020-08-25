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
* RDBGridProvider.pas - module helper for print tables                         *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit RDBGridProvider;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Grids, RDBGrid, RDBClass;

const
  FIRST_COLUMNT_INDEX = 0;


type
  TMetaListProvider = class;
  TMapFieldsProvider = class;
  TMetaFieldsProvider = class;
  TMetaTablesProvider = class;

 TMetaListProviderClass = class of TMetaListProvider;
 TMetaListProvider = class(TDrawGridProvider)
  private
    FList: TMetaClassList;
    FDetails: TMetaListProvider;
    procedure SetList(const Value: TMetaClassList);
    procedure SetSelected(Schema: TMetaClass); virtual;
  protected
    function GetChecked(ARow: Integer): Boolean; override;
    procedure SetChecked(ARow: Integer; const Value: Boolean); override;
    procedure PrepareCanvas(Sender: TObject; ACol, ARow: Integer); override;
    procedure GetPickList (Sender: TObject; ACol, ARow: Integer;
      Values: TStrings); override;
    function Validate(Sender: TObject; ACol, ARow: Longint;
      const Value: string): Boolean; override;
    procedure DrawCell(Canvas: TCanvas; ACol, ARow: Integer;
      ARect: TRect; AState: TGridDrawState; var Processed: Boolean); override;
    function SelectRow(Sender: TObject; ARow: Integer): Boolean; override;
  public
    constructor Create(AList: TMetaClassList; ADetails: TMetaListProvider); virtual;
    destructor Destroy; override;
    property List: TMetaClassList read FList write SetList;
    property Details: TMetaListProvider read FDetails;
 end;

 TMetaSchemasProvider = class(TMetaListProvider)
  private
    FSchema: TMetaSchema; // current;
    procedure SetSelected(Schema: TMetaClass); override;
    function GetList: TMetaSchemaList;
  protected
    procedure InitGrid(const Value: TDrawGrid); override;
  public
    function GetText(Sender: TObject; ACol, ARow: Integer; EditText: Boolean): string; override;
    function GetHeaderText(Sender: TObject; ACol: Integer): string; override;
//    property List: TMetaSchemaList read GetList write SetList;
    property Current: TMetaSchema read FSchema;
  end;

  TMetaTablesProvider = class(TMetaListProvider)
  private
    FTable: TMetaTable; // current;
    procedure SetSelected(Table: TMetaClass); override;
  protected
    procedure InitGrid(const Value: TDrawGrid); override;
  public
    function GetText(Sender: TObject; ACol, ARow: Integer; EditText: Boolean): string; override;
    function GetHeaderText(Sender: TObject; ACol: Integer): string; override;
//    property List: TMetaTableList read FList write SetList;
    property Current: TMetaTable read FTable;
  end;

  TMetaFieldsProvider = class(TMetaListProvider)
  private
    FList: TMetaFieldList;
    //FField: TMetaField;
  protected
    procedure InitGrid(const Value: TDrawGrid); override;
  public
    function GetText(Sender: TObject; ACol, ARow: Integer; EditText: Boolean): string; override;
    function GetHeaderText(Sender: TObject; ACol: Integer): string; override;
//    property List: TMetaFieldList read FList write SetList;
  end;

  TMapMetaListProvider = class(TMetaListProvider)
  private
    FMap: TMapMeta; // current;
    FPick: array [0..1] of Boolean;
    FDetails: TMapFieldsProvider;
    procedure SetSelected(Map: TMetaClass); override;
  protected
    procedure InitGrid(const Value: TDrawGrid); override;
  public
    function GetText(Sender: TObject; ACol, ARow: Integer; EditText: Boolean): string; override;
    function GetHeaderText(Sender: TObject; ACol: Integer): string; override;
    function CanEdit(Sender: TObject; ACol, ARow: Integer): Boolean; override;
    procedure SetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string); override;
    procedure GetPickList (Sender: TObject; ACol, ARow: Integer;
      Values: TStrings); override;
//    property List: TMapMetaTableList read FList write SetList;
    property Details: TMapFieldsProvider read FDetails write FDetails;
    property Current: TMapMeta read FMap;
  end;

  TMapFieldsProvider = class(TDrawGridProvider)
  private
    FMap: TMapMeta; // current;
    FPick: array [0..1] of Boolean;
    procedure SetMap(const Value: TMapMeta);
  protected
    procedure InitGrid(const Value: TDrawGrid); override;
  public
    constructor Create(AMap: TMapMeta); virtual;
    destructor Destroy; override;
    procedure PrepareCanvas(Sender: TObject; ACol, ARow: Integer); override;
    function GetText(Sender: TObject; ACol, ARow: Integer; EditText: Boolean): string; override;
    function GetHeaderText(Sender: TObject; ACol: Integer): string; override;
    procedure SetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string); override;
    function CanEdit(Sender: TObject; ACol, ARow: Integer): Boolean; override;
    procedure GetPickList (Sender: TObject; ACol, ARow: Integer;
      Values: TStrings); override;
    function Validate(Sender: TObject; ACol, ARow: Longint;
      const Value: string): Boolean; override;
    procedure DrawCell(Canvas: TCanvas; ACol, ARow: Integer;
      ARect: TRect; AState: TGridDrawState; var Processed: Boolean); override;
    function SelectRow(Sender: TObject; ARow: Integer): Boolean; override;
    property Map: TMapMeta read FMap write SetMap;
  end;
implementation
uses
  TypInfo, FireDAC.Stan.Intf;

{ **************************************************************************** }
{                               TMetaClassProvider                             }
{ **************************************************************************** }
function TMetaTablesProvider.GetHeaderText(Sender: TObject;
  ACol: Integer): string;
begin
    case ACol of
      0: Result := 'Schema';
      1: Result := 'Name';
      2: Result := 'Type';
      3: Result := 'User';
    end;
end;

function TMetaTablesProvider.GetText(Sender: TObject; ACol,
  ARow: Integer; EditText: Boolean): string;
var
  list: TMetaTableList;
begin
  inherited;
  list := TMetaTableList(FList);
  if Assigned(List) then
    case ACol of
      0: Result := List[ARow].Schema.Name;
      1: Result := List[ARow].Name;
      2: Result := GetEnumName(TypeInfo(TMetaTableKind), Integer(List[ARow].Kind));
      3: Result := List[ARow].User;
    end;
end;

procedure TMetaTablesProvider.InitGrid(const Value: TDrawGrid);
begin
  inherited;
  Value.SetColumnsWidth([175, 300, 70, 75]);
  if Assigned(FList) then
    Value.RecordCount := FList.Count else
    Value.RecordCount := 0;
end;

procedure TMetaTablesProvider.SetSelected(Table: TMetaClass);
begin
  if FTable <> Table then
    begin
      if Assigned(FDetails) then
        FDetails.SetList(TMetaTable(Table).Fields);
      FTable := TMetaTable(Table);
    end;
end;

{ **************************************************************************** }
{                               TMetaFieldsProvider                            }
{ **************************************************************************** }


function TMetaFieldsProvider.GetHeaderText(Sender: TObject;
  ACol: Integer): string;
begin
    case ACol of
      0: Result := 'Name';
      1: Result := 'Type';
    end;
end;

function TMetaFieldsProvider.GetText(Sender: TObject; ACol,
  ARow: Integer; EditText: Boolean): string;
begin
  inherited;
  if Assigned(FList) then
    case ACol of
      0: Result := FList[ARow].Name;
      1: Result := FList[ARow].TypeName;
    end;
end;

procedure TMetaFieldsProvider.InitGrid(const Value: TDrawGrid);
begin
  inherited;
  Value.SetColumnsWidth([300, 300, 70]);
  if Assigned(FList) then
    Value.RecordCount := FList.Count else
    Value.RecordCount := 0;
end;


{ **************************************************************************** }
{                               TMapMetaListProvider                           }
{ **************************************************************************** }


function TMapMetaListProvider.CanEdit(Sender: TObject; ACol,
  ARow: Integer): Boolean;
begin
  Result := ACol in [0, 2];
end;
function TMapMetaListProvider.GetHeaderText(Sender: TObject;
  ACol: Integer): string;
begin
    case ACol of
      0: Result := 'Master';
      1: Result := 'Type';
      2: Result := 'Slave';
      3: Result := 'Type';
    end;
end;

procedure TMapMetaListProvider.GetPickList(Sender: TObject; ACol, ARow: Integer;
  Values: TStrings);
var
  L: TStrings;
  List: TMapMetaTableList;
begin
  inherited;
  list := TMapMetaTableList(FList);
  if not Assigned(List) then exit;
  L := nil;
  case ACol of
    0: if not FPick[0] then
         begin
          L := List[ARow].Tables[mkMaster].Schema.Tables.Strings;
          FPick[0] := true;
          Values.Clear;
         end;
    2: if not FPick[1] then
         begin
          L := List[ARow].Tables[mkSlave].Schema.Tables.Strings;
          FPick[1] := true;
          Values.Clear;
         end;
  end;
 if L <> nil then
   values.Assign(L);
end;

function TMapMetaListProvider.GetText(Sender: TObject; ACol,
  ARow: Integer; EditText: Boolean): string;
var
  t: TMetaTable;
  List: TMapMetaTableList;
begin
  inherited;
  list := TMapMetaTableList(FList);
  if not Assigned(List) then exit;
  t := nil;
  case ACol of
    0, 1: t := List[ARow].Tables[mkMaster];
    2, 3: t := List[ARow].Tables[mkSlave];
  end;
  if t <> nil then
    if not Odd(ACol) then
      Result := t.Name else
      Result := GetEnumName(TypeInfo(TMetaTableKind), Integer(t.Kind));
end;

procedure TMapMetaListProvider.InitGrid(const Value: TDrawGrid);
begin
  inherited;
  Value.SetColumnsWidth([300, 70, 300, 70, 92]);
  Value.DropDownRows := 8;
  Value.ColumnEditStyle[0] := esPickList;
  Value.ColumnEditStyle[2] := esPickList;
  if Assigned(FList) then
    Value.RecordCount := FList.Count else
    Value.RecordCount := 0;
end;


procedure TMapMetaListProvider.SetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
begin
  inherited;
  if not Assigned(FMap) then exit;
  case ACol of
    0: FMap.Tables[mkMaster] := TMetaTable(FMap.Tables[mkMaster].Schema.Tables.ItemsByName[Value]);
    2: FMap.Tables[mkSlave] := TMetaTable(FMap.Tables[mkSlave].Schema.Tables.ItemsByName[Value]);
  else
    exit;
  end;
  InvalidateRecord(ARow);
  if Assigned(FDetails) then
    begin
      TMapFieldsProvider(FDetails).SetMap(nil);
      TMapFieldsProvider(FDetails).SetMap(FMap);
    end;
end;

procedure TMapMetaListProvider.SetSelected(Map: TMetaClass);
begin
  if FMap <> Map then
    begin
      if Assigned(FDetails) then
        TMapFieldsProvider(FDetails).SetMap(TMapMeta(Map));
      FMap := TMapMeta(Map);
    end;
end;

{ **************************************************************************** }
{                               TMapFieldsProvider                             }
{ **************************************************************************** }


function TMapFieldsProvider.CanEdit(Sender: TObject; ACol,
  ARow: Integer): Boolean;
begin
  Result := ACol in [0, 2]
end;

constructor TMapFieldsProvider.Create(AMap: TMapMeta);
begin
  inherited Create;
  FMap := AMap;
end;

destructor TMapFieldsProvider.Destroy;
begin
  FMap := nil;
  inherited;
end;

procedure TMapFieldsProvider.DrawCell(Canvas: TCanvas; ACol, ARow: Integer;
  ARect: TRect; AState: TGridDrawState; var Processed: Boolean);
begin
  inherited;

end;

function TMapFieldsProvider.GetHeaderText(Sender: TObject;
  ACol: Integer): string;
begin
    case ACol of
      0: Result := 'Master';
      1: Result := 'Type';
      2: Result := 'Slave';
      3: Result := 'Type';
    end;
end;

procedure TMapFieldsProvider.GetPickList(Sender: TObject; ACol, ARow: Integer;
  Values: TStrings);
var
  L: TStrings;
begin
  inherited;
  if Assigned(FMap) then
    begin
      case ACol of
      0: if not FPick[0] then
           begin
            L := FMap.Tables[mkMaster].Fields.Strings;
            FPick[0] := true;
            Values.Clear;
           end;
      2: if not FPick[1] then
           begin
            L := FMap.Tables[mkSlave].Fields.Strings;
            FPick[1] := true;
            Values.Clear;
           end;
      end;
      if L <> nil then
        values.Assign(L);
    end;
end;

function TMapFieldsProvider.GetText(Sender: TObject; ACol, ARow: Integer;
  EditText: Boolean): string;
var
  f: TMetaField;
begin
  Result := '';
  if not Assigned(FMap) then exit;

  if FMap.FieldCount = 0 then
      begin
        Result := '<empty>';
        exit;
      end;
  f := nil;
    case ACol of
      0, 1: f := FMap.Fields[mkMaster, ARow];
      2, 3: f := FMap.Fields[mkSlave, ARow];
    end;
    if f <> nil then
      if not Odd(ACol) then
        Result := f.Name + ': '+ GetEnumName(TypeInfo(TFDDataType), f.DataType) else
        Result := f.TypeName;
end;

procedure TMapFieldsProvider.InitGrid(const Value: TDrawGrid);
begin
  inherited;
  Value.CheckBoxes := false;
  Value.SetColumnsWidth([200, 70, 200, 70]);
  Value.DropDownRows := 8;
  Value.ColumnEditStyle[0] := esPickList;
  Value.ColumnEditStyle[2] := esPickList;

  if Assigned(FMap) then
    Value.RecordCount := FMap.FieldCount else
    Value.RecordCount := 0;
end;

procedure TMapFieldsProvider.PrepareCanvas(Sender: TObject; ACol,
  ARow: Integer);
begin
  inherited;

end;

function TMapFieldsProvider.SelectRow(Sender: TObject; ARow: Integer): Boolean;
begin
  inherited;
  Result := true;
end;

procedure TMapFieldsProvider.SetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
var
  kind: TMapKind;
  t: TMetaTable;
begin
  inherited;
  if not Assigned(FMap)then exit;
  case ACol of
    0: kind := mkMaster;
    2: kind := mkSlave;
  else
    exit;
  end;
  t := FMap.Tables[kind];
  if t <> nil then
    begin
      FMap.Fields[kind, ARow] := TMetaField(t.Fields.ItemsByName[Value]);
      InvalidateRecord(ARow);
    end;
end;

procedure TMapFieldsProvider.SetMap(const Value: TMapMeta);
begin
  if Map <> Value then
    begin
      FMap := nil;
      if Assigned(Value) then
        Grid.RecordCount := Value.FieldCount else
        Grid.RecordCount := 0;
      FMap := Value;
      if Assigned(Value) then
        Grid.Invalidate
    end;
end;

function TMapFieldsProvider.Validate(Sender: TObject; ACol, ARow: Longint;
  const Value: string): Boolean;
begin

end;

{ **************************************************************************** }
{                               TMetaSchemasProvider                           }
{ **************************************************************************** }

function TMetaSchemasProvider.GetHeaderText(Sender: TObject;
  ACol: Integer): string;
begin
    case ACol of
      0: Result := 'Name';
      1: Result := 'Privileges';
      2: Result := 'Description';
      3: Result := 'User';
    end;
end;

function TMetaSchemasProvider.GetList: TMetaSchemaList;
begin
  Result := TMetaSchemaList(Flist);
end;

function TMetaSchemasProvider.GetText(Sender: TObject; ACol, ARow: Integer;
  EditText: Boolean): string;
var
  list: TMetaSchemaList;
begin
  inherited;
  list := TMetaSchemaList(FList);
  if Assigned(list) then
    case ACol of
      0: Result := list[ARow].Name;
      1: Result := list[ARow].Privileges;
      2: Result := list[ARow].Description;
      3: Result := list[ARow].User;
    end;
end;

procedure TMetaSchemasProvider.InitGrid(const Value: TDrawGrid);
begin
  inherited;
  Value.SetColumnsWidth([175, 300, 70, 75]);
  if Assigned(FList) then
    Value.RecordCount := FList.Count else
    Value.RecordCount := 0;
end;

procedure TMetaSchemasProvider.SetSelected(Schema: TMetaClass);
begin
  if FSchema <> Schema then
    begin
      if Assigned(Details) then
        Details.SetList(TMetaSchema(Schema).Tables);
      FSchema := TMetaSchema(Schema);
    end;
end;


{ **************************************************************************** }
{                               TMetaListProvider                              }
{ **************************************************************************** }


constructor TMetaListProvider.Create(AList: TMetaClassList;
  ADetails: TMetaListProvider);
begin
  inherited Create;
  FDetails := ADetails;
  SetList(AList);
end;

destructor TMetaListProvider.Destroy;
begin
  FList := nil;
  inherited;
end;

procedure TMetaListProvider.DrawCell(Canvas: TCanvas; ACol, ARow: Integer;
  ARect: TRect; AState: TGridDrawState; var Processed: Boolean);
begin
  inherited;

end;

function TMetaListProvider.GetChecked(ARow: Integer): Boolean;
begin
  Result := Assigned(FList) and FList[ARow].Checked;
end;

procedure TMetaListProvider.GetPickList(Sender: TObject; ACol, ARow: Integer;
  Values: TStrings);
begin
  inherited;

end;

procedure TMetaListProvider.PrepareCanvas(Sender: TObject; ACol, ARow: Integer);
begin
  inherited;

end;

function TMetaListProvider.SelectRow(Sender: TObject; ARow: Integer): Boolean;
begin
  inherited;
  Result := true;
  if Assigned(FList) then
    SetSelected(FList[ARow]);
end;

procedure TMetaListProvider.SetChecked(ARow: Integer; const Value: Boolean);
begin
  if Assigned(FList) then
    FList[ARow].Checked := Value;
end;

procedure TMetaListProvider.SetList(const Value: TMetaClassList);
begin
  if FList <> Value then
    begin
      SetSelected(nil);
      FList := nil;
      if Assigned(Value) then
        Grid.RecordCount := Value.Count else
        Grid.RecordCount := 0;
      FList := Value;
      if Assigned(Value) then
        begin
          if Value.Count > 0 then
            SetSelected(FList[0]);
          Grid.Invalidate;
        end;
    end;

end;

procedure TMetaListProvider.SetSelected(Schema: TMetaClass);
begin

end;

function TMetaListProvider.Validate(Sender: TObject; ACol, ARow: Longint;
  const Value: string): Boolean;
begin

end;

end.
