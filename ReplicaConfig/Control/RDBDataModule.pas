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
* RDBDataModule.pas - data module for configurator                             *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit RDBDataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Stan.Async, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Moni.Base, FireDAC.Moni.RemoteClient, RDBClass,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script,
  FireDAC.VCLUI.Script, FireDAC.Comp.UI;

type
  TRDB = class(TDataModule)
    master_conn: TFDConnection;
    FDManager: TFDManager;
    FDMoniRemoteClientLink: TFDMoniRemoteClientLink;
    slave_conn: TFDConnection;
    sql_tables: TFDQuery;
    sql_fields: TFDQuery;
    sql_indexes: TFDQuery;
    sql_idx_fields: TFDQuery;
    sql_schema: TFDQuery;
    FDScript: TFDScript;
    FDGUIxScriptDialog: TFDGUIxScriptDialog;
    FDQuery: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    FReplicaSchemaUsed: array [TMapKind] of Boolean;
    { Private declarations }
    function GetReplicaSchemaUsed(kind: TMapKind): Boolean;
  public
    { Public declarations }
    function LoadShcema(schemas: TMetaSchemaList; FullLoad: Boolean = true): Integer;
    function LoadTables(schema: TMetaSchema; FullLoad: Boolean = true): Integer;
    function LoadFields(table: TMetaTable): Integer; overload;
    function LoadFields(tables: TMetaTableList): Integer; overload;
    function LoadIndexes(table: TMetaTable; FullLoad: Boolean = true): Integer;
    function LoadIndexFields(index: TMetaIndex): Integer;
    procedure SwitchConnectionMaster(kind: TMapKind);
    procedure ExecuteScript(const script: string; Kind: TMapKind);
    procedure Reconnect(FileName, Master, Slave: string);
    procedure GetConnectionInfo(var Srv, DB, User, Pwd: string; Kind: TMapKind);
    procedure CheckReplicaSchema;
    property ReplicaSchemaUsed[kind: TMapKind]: Boolean read GetReplicaSchemaUsed;
  end;

  const
    DefConnectionMaster = 'postgress_master';
    DefConnectionSlave  = 'postgress_slave';
    DefConnectionFile   = 'ConnDef.ini';
    DefSettingsMaster  =
      'INSERT INTO _replica.settings (name, value) VALUES (''version'', ''1.0'') '+
      'ON CONFLICT (name) DO NOTHING;';
    DefSettingsSlave  =
      'INSERT INTO _replica.settings (name, value) VALUES (''client_id'', ''%s'') '+
      'ON CONFLICT (name) DO UPDATE SET value = ''%0:s'';';

var
  RDB: TRDB;
  ConnectionMaster: string;
  ConnectionSlave: string;
  ConnectionFile: string;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
FireDAC.Phys.PGCli, FireDAC.Phys.PGWrapper, typInfo,System.Diagnostics;

function GetDataTypePG(conn: TFDCustomConnection; ASQLTypeOID: Oid): Integer;
var
  oRow: TFDDatSRow;
  eType: TFDDataType;
  eAttrs: TFDDataAttributes;
  iTypeOid: Oid;
  iAttrs: Word;
  iLen: LongWord;
  iPrec: Integer;
  iScale: Integer;
  oType: TPgType;
  c: TPgConnection;
  AType: TFDDataType;
  //cmd: TFDPhysPgCommand;
begin
  c := TPgConnection(conn.ConnectionIntf.CliObj);
  case ASQLTypeOid of
  SQL_INT2,
  SQL_SMGR:
    AType := dtInt16;
  SQL_INT4:
    AType := dtInt32;
  SQL_INT8:
    AType := dtInt64;
  SQL_FLOAT4:
    AType := dtSingle;
  SQL_FLOAT8:
    AType := dtDouble;
  SQL_CASH:
    begin
      AType := dtCurrency;
    end;
  SQL_NUMERIC:
    begin
        AType := dtBCD;
    end;
  SQL_CHAR,
  SQL_BPCHAR,
  SQL_VARCHAR,
  SQL_NAME,
  SQL_ACLITEM,
  SQL_VOID:
      if c.Encoder.Encoding = ecUTF8 then
        AType := dtWideString  // dtWideMemo
      else
        AType := dtAnsiString; //dtMemo

  SQL_MACADDR,
  SQL_MACADDR8,
  SQL_CIDR,
  SQL_INET:
      if c.Encoder.Encoding = ecUTF8 then
        AType := dtWideString
      else
        AType := dtAnsiString;
  SQL_BIT:
    begin
      AType := dtByteString;
    end;
  SQL_VARBIT:
    begin
      AType := dtByteString;
    end;
  SQL_UNKNOWN:
    begin
      if c.Encoder.Encoding = ecUTF8 then
        AType := dtWideString
      else
        AType := dtAnsiString;
    end;
  SQL_TEXT,
  SQL_JSON,
  SQL_JSONB:
    begin
      if c.Encoder.Encoding = ecUTF8 then
        AType := dtWideMemo
      else
        AType := dtMemo;
    end;
  SQL_XML:
    begin
      AType := dtXML;
    end;
  SQL_BYTEA:
    begin
      AType := dtBlob;
    end;
  SQL_ANY:
    begin
      AType := dtByteString;
    end;
  SQL_DATE:
    AType := dtDate;
  SQL_TIME,
  SQL_TIMETZ:
    begin
      AType := dtTime;
    end;
  SQL_TIMESTAMP,
  SQL_TIMESTAMPTZ,
  SQL_RELTIME,
  SQL_ABSTIME:
    begin
      AType := dtDateTimeStamp;
    end;
  SQL_INTERVAL:
    begin
      AType := dtTimeIntervalFull;
    end;
  SQL_BOOL:
    AType := dtBoolean;
  SQL_OID:
      AType := dtUInt32;
  SQL_XID,
  SQL_CID,
  SQL_REGPROC,
  SQL_REGPROCEDURE,
  SQL_REGOPER,
  SQL_REGOPERATOR,
  SQL_REGCLASS,
  SQL_REGTYPE:
    AType := dtUInt32;
  SQL_TID:
    begin
      AType := dtByteString;
    end;
  SQL_REFCURSOR:
    AType := dtCursorRef;
  SQL_UUID:
    AType := dtGUID;
  else
    oType := c.TypesManager.Types[ASQLTypeOID];
    if paArray in oType.Attrs then
      Integer(aType) := GetDataTypePG(conn, oType.Members[0].TypeOid)
    else if paEnum in oType.Attrs then begin
      if c.Encoder.Encoding = ecUTF8 then
        AType := dtWideString
      else
        AType := dtAnsiString;
    end
    else if (paRecord in oType.Attrs) {and (AParamType <> ptResult)} or
            (paRange in oType.Attrs) then begin
      AType := dtRowRef;
    end
    else if ASQLTypeOID <> oType.Id then begin
      Integer(aType) := GetDataTypePG(conn, oType.Id);
    end
    else begin
      ASQLTypeOid := c.UnknownFormat;
      if (ASQLTypeOid = 0) and (paBlob in oType.Attrs) then
        if paString in oType.Attrs then
          ASQLTypeOid := SQL_TEXT
        else
          ASQLTypeOid := SQL_BYTEA;
      if ASQLTypeOid = 0 then
        AType := dtUnknown
      else
        Integer(aType) := GetDataTypePG(conn, ASQLTypeOid);
    end;
  end;

  Result := Integer(AType);
  exit;

  c := TPgConnection(RDb.master_conn.ConnectionIntf.CliObj);
  oType := c.TypesManager.Types[ASQLTypeOID];
  Result := oType.Id;
    if paArray in oType.Attrs then
      oType := c.TypesManager.Types[oType.Members[0].TypeOid]
    else if paEnum in oType.Attrs then
      begin
        if c.Encoder.Encoding = ecUTF8 then
          Result := Integer(dtWideString)
        else
          Result := Integer(dtAnsiString);
    end
    else if (paRecord in oType.Attrs)  or
            (paRange in oType.Attrs) then begin
      Result := Integer(dtRowRef);
    end
    else if ASQLTypeOID <> oType.Id then begin
//      if ASQLLen = 0 then
//        ASQLLen := oType.PGSize;
//      SQL2FDColInfo(oType.Id, ASQLLen, ASQLPrec, ASQLScale, AParamType,
//        AType, AAttrs, ALen, APrec, AScale, AFmtOpts);
    end
    else begin
      ASQLTypeOid := c.UnknownFormat;
      if (ASQLTypeOid = 0) and (paBlob in oType.Attrs) then
        if paString in oType.Attrs then
          ASQLTypeOid := SQL_TEXT
        else
          ASQLTypeOid := SQL_BYTEA;
      if ASQLTypeOid = 0 then
        Result := Integer(dtUnknown)
      else
//        SQL2FDColInfo(ASQLTypeOid, ASQLLen, ASQLPrec, ASQLScale, AParamType,
//          AType, AAttrs, ALen, APrec, AScale, AFmtOpts);
    end;
end;



procedure TRDB.CheckReplicaSchema;
var
  q: TFDQuery;
  c: TFDCustomConnection;
begin
  q := sql_schema;
  if q.Tag <> NativeInt(TMetaSchema) then
    begin
      q.SQL.LoadFromFile('..\scripts\getSchema.sql');
      q.Tag := NativeInt(TMetaSchema);
    end;
  c := q.Connection;
  q.Connection := master_conn;
  q.Open();
  FReplicaSchemaUsed[mkMaster] := q.Locate('Name', '_replica', []);
  q.Connection := slave_conn;
  q.Open();
  FReplicaSchemaUsed[mkSlave] := q.Locate('Name', '_replica', []);
  q.Close
end;

procedure TRDB.DataModuleCreate(Sender: TObject);
var
  s: string;
begin
  if FindCmdLineSwitch('file', s)  then
    ConnectionFile := s;
  if FindCmdLineSwitch('master', s)  then
    ConnectionMaster := s;
  if FindCmdLineSwitch('slave', s)  then
    ConnectionSlave := s;
  Reconnect('', '', '');
end;

procedure TRDB.ExecuteScript(const script: string; Kind: TMapKind);
begin
  if Kind = mkMaster then
    FDScript.Connection := master_conn else
    FDScript.Connection := slave_conn;
    FDScript.SQLScripts.Clear;
  if FDScript.SQLScripts.Count = 0 then
    FDScript.SQLScripts.Add;
  FDScript.SQLScripts[0].SQL.Text := script;
  FDScript.Connection.StartTransaction;
  try
//FDQuery.SQL.Text := script;
//FDQuery.ExecSQL;
    FDScript.ExecuteAll;
    FDScript.Connection.Commit;
  except
    FDScript.Connection.Rollback;
    raise;
  end;
end;

procedure TRDB.GetConnectionInfo(var Srv, DB, User, Pwd: string;
  Kind: TMapKind);
var
  c: IFDStanConnectionDef;
begin
  case Kind of
    mkMaster: c := FDManager.ConnectionDefs.ConnectionDefByName(ConnectionMaster);
    mkSlave:  c := FDManager.ConnectionDefs.ConnectionDefByName(ConnectionSlave);
  end;
  Srv := TFDPhysPGConnectionDefParams(c.Params).Server;
  DB  := c.Params.Database;
  User:= c.Params.UserName;
  Pwd := c.Params.Password;
  c := nil;
end;

function TRDB.GetReplicaSchemaUsed(kind: TMapKind): Boolean;
begin
  Result := FReplicaSchemaUsed[kind]
end;

function TRDB.LoadFields(tables: TMetaTableList): Integer;
var
  I: Integer;
begin
  for I := 0 to tables.Count-1 do
    LoadFields(tables[i])
end;

function TRDB.LoadFields(table: TMetaTable): Integer;
var
  i: Integer;
  t: TFDQuery;
  field: TMetaField;
begin
  table.Fields.BeginUpdate;
  try
  t := sql_fields;
  if t.Tag <> NativeInt(TMetaField) then
    begin
      t.SQL.LoadFromFile('..\scripts\getFields.sql');
      t.Tag := NativeInt(TMetaField);
    end;
  t.Close();
  t.Params[0].AsString := table.Name;
  t.Open();
  Result := t.RecordCount;
  for I := 0 to Result - 1 do
    begin
      field := table.Fields.Add;
      //field.Index := << t.FieldByName('COLUMN_POSITION').AsInteger;
      field.Table          := table;
      field.Name           := t.FieldByName('COLUMN_NAME').AsString;
      field.DataTypeOrigin := t.FieldByName('COLUMN_DATATYPE').AsInteger;
      field.DataType       := GetDataTypePG(t.Connection, field.DataTypeOrigin);
      field.TypeName       := t.FieldByName('COLUMN_TYPENAME').AsString;
      t.Next
    end;
  finally
    table.Fields.EndUpdate;
  end;
  t.Close;
end;

function TRDB.LoadIndexes(table: TMetaTable; FullLoad: Boolean): Integer;
var
  i: Integer;
  t: TFDQuery;
  index: TMetaIndex;
begin
  table.Indexes.BeginUpdate;
  try
  t := sql_indexes;
  if t.Tag <> NativeInt(TMetaIndex) then
    begin
      t.SQL.LoadFromFile('..\scripts\getIndexes.sql');
      t.Tag := NativeInt(TMetaIndex);
    end;
  t.Close();
  t.Params[0].AsString := table.Name;
  t.Open();
  Result := t.RecordCount;
  for I := 0 to Result - 1 do
    begin
      index := table.Indexes.Add;
      index.Table := table;
      index.Name := t.FieldByName('INDEX_NAME').AsString;
      index.Kind := TMetaIndexKind(t.FieldByName('INDEX_TYPE').AsInteger);
      if FullLoad then
          LoadIndexFields(index);
      t.Next;
    end;
  finally
    table.Indexes.EndUpdate;
  end;
  t.Close;
end;

function TRDB.LoadIndexFields(index: TMetaIndex): Integer;
var
  i: Integer;
  t: TFDQuery;
  f: TMetaField;
begin
  index.Fields.BeginUpdate;
  try
  t := sql_idx_fields;
  if t.Tag <> NativeInt(TMetaIndex) + NativeInt(TMetaField) then
    begin
      t.SQL.LoadFromFile('..\scripts\getIndexFields.sql');
      t.Tag := NativeInt(TMetaIndex) + NativeInt(TMetaField);
    end;
  t.Close();
  t.Params[0].AsString := index.Name;
  t.Open();
  Result := t.RecordCount;
  for I := 0 to Result - 1 do
    begin
      f := index.Table.Fields[t.FieldByName('COLUMN_POSITION').AsInteger-1];
      Index.Fields.Add(f);
      if Index.Kind = ikPrimaryKey then
        f.PK := true;
      t.Next;
    end;
  finally
    index.Fields.EndUpdate;
  end;
  t.Close;
end;

function TRDB.LoadShcema(schemas: TMetaSchemaList; FullLoad: Boolean): Integer;
var
  I: Integer;
  q: TFDQuery;
  schema: TMetaSchema;
  pb: PBoolean;
begin
  if sql_schema.Connection = master_conn then
    pb := @FReplicaSchemaUsed[mkMaster] else
    pb := @FReplicaSchemaUsed[mkSlave];
  pb^ := false;
  schemas.BeginUpdate;
  try
  q := sql_schema;
  if q.Tag <> NativeInt(TMetaSchema) then
    begin
      q.SQL.LoadFromFile('..\scripts\getSchema.sql');
      q.Tag := NativeInt(TMetaSchema);
    end;
  q.Open();
  Result := q.RecordCount;
  for I := 0 to Result-1 do
    begin
      if q.FieldByName('Name').AsString <> '_replica' then
        begin
          schema := schemas.Add;
          schema.Name  := q.FieldByName('Name').AsString;
          schema.User  := q.FieldByName('Owner').AsString;
          schema.Privileges  := q.FieldByName('Access privileges').AsString;
          schema.Description := q.FieldByName('Description').AsString;
          if FullLoad then
            begin
              LoadTables(schema);
            end;
        end
      else
        pb^ := true;
      q.Next;
    end;
  q.Close();
  finally
    schemas.EndUpdate;
  end;
end;

function TRDB.LoadTables(schema: TMetaSchema;
  FullLoad: Boolean): Integer;
var
  i: Integer;
  t: TFDQuery;
  table: TMetaTable;
begin
  t := sql_tables;
  if t.Tag <> NativeInt(TMetaTable) then
    begin
      t.SQL.LoadFromFile('..\scripts\getTables.sql');
      t.Tag := NativeInt(TMetaTable);
    end;
  t.Close();
  t.Params[0].AsString := schema.Name;
  t.Open();
  Result := t.RecordCount;
  schema.Tables.BeginUpdate;
  try
  for I := 0 to Result - 1 do
    begin
      table := schema.Tables.Add;
      table.Schema := schema;
      table.Name := t.FieldByName('TABLE_NAME').AsString;
      table.Kind := TMetaTableKind(t.FieldByName('TABLE_TYPE').AsInteger);
      table.User := t.FieldByName('USER').AsString;
      if FullLoad then
        begin
          LoadFields(table);
          LoadIndexes(table);
        end;
      t.Next
    end;
  finally
    schema.Tables.EndUpdate;
  end;
  t.Close;
end;

procedure TRDB.Reconnect(FileName, Master, Slave: string);
begin
  if FileName = '' then
    FileName := DefConnectionFile;
  if Master = '' then
    master := DefConnectionMaster;
  if Slave = '' then
    Slave := DefConnectionSlave;

  FDManager.Close;
  FDManager.ConnectionDefFileName := FileName;
  FDManager.Open;
  master_conn.ConnectionDefName := Master;
  slave_conn.ConnectionDefName := Slave;

  ConnectionFile := FileName;
  ConnectionMaster := master;
  ConnectionSlave := slave;
//  BuildTree;
end;

procedure TRDB.SwitchConnectionMaster(kind: TMapKind);
begin
  if kind = mkMaster then
    begin
      sql_tables.Connection     := master_conn;
      sql_fields.Connection     := master_conn;
      sql_indexes.Connection    := master_conn;
      sql_idx_fields.Connection := master_conn;
      sql_schema.Connection     := master_conn;
    end
  else
    begin
      sql_tables.Connection     := slave_conn;
      sql_fields.Connection     := slave_conn;
      sql_indexes.Connection    := slave_conn;
      sql_idx_fields.Connection := slave_conn;
      sql_schema.Connection     := slave_conn;
    end;
end;

end.
