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
* RDBData.pas - module replication data between databases                      *
*             - using low-level acces to postgress database                    *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.3d                                                       *
*==============================================================================}

unit RDBData;
{$define PRINT_TIMER_TRANSACTION}

interface
uses
  Winapi.Windows, System.Classes, System.SysUtils, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Option, FireDAC.Stan.Intf, FireDAC.Stan.Param,
  FireDAC.Phys.Intf, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.PGWrapper, FireDAC.Phys.PGCli, // << native access
  MapTables;
type
  TDBReplicationEx = class;
  TProgressMethodEvent = procedure (Position, Max: Integer; const Info: string) of object;


  TRDBOperation = (opInsertUpdate, opDelete);
  PDBReplicationContext = ^TDBReplicationContext;
  TDBReplicationContext = record
    operation: TRDBOperation;
    TableName: string;
  end;

  TErrorList = record
    list: array of array of variant;
    count: Integer;
    dim: Integer;
    procedure Reset(dimCount: Integer);
    procedure Add(row, col: Integer; const Value: Variant);
    function AddRow: Integer;
  end;

  TChangedDataParams = record
    last_id: Integer;
    last_modified: TDateTime;
    cur_txid: int64;
    cur_rows: Integer;
    total_rows: Integer;
    txids: array of int64;
    index: Integer;
    rows: array of Integer;
    min_id: array of Integer;
    max_id: array of Integer;
    count: Integer;
  end;

  TDBReplicationEx = class
  private
    FDestCon, FSourceCon: TFDCustomConnection;

    FQueryData: TFDQuery;
    FLastIDCommand: IFDPhysCommand;
    FSaveTableInfo: IFDPhysCommand;
    FTables: TRelationNodeList;
    FErrors: TErrorList;
    FLastChangedID: Integer;
    FLastModified: TDateTime;
    FFullDownLoaded: Boolean;
    FChangedDataFields: array of TField;
    FTerminate: Boolean;
    FClientID: string;
    FProcessing: Boolean;
    FNeedVisit: Boolean;
    procedure SetDestCon(const Value: TFDCustomConnection);
    procedure SetSourceCon(const Value: TFDCustomConnection);
    function CreateMapQuery(RequestType: TTypeRuquest): TFDQuery;
    function NormalizeName(const Name: string): string;
    procedure StartTransaction;
    procedure CommitTransaction;
    procedure RollbackTransaction;

    function EncodeTimeSQLParam(value: TDateTime; Quoted: Boolean = true): string;
    function EncodeSQLTableName(table: TTableNode): string;


    procedure ResetTableList;
    procedure UpdateTableList;
    procedure UpdateRelationShip;
    procedure PrepareUpdateDateLastID;
    procedure PrepareSaveTableInfo;
    procedure UpdateTableFieldDefs(table: TSlaveTableNode);


    procedure SaveQuerySlaveInfo(table: TSlaveTableNode);
    procedure SaveLastID(last_id: Integer);

    function GetSQLSelectByFields(table: TSlaveTableNode; const explicit: TArrayOfString; BuildWhere: Boolean = false): string;
    function GetSQLSelectByFieldsNative(table: TSlaveTableNode; const explicit: TArrayOfString; BuildWhere: Boolean = false): string;
    function GetSQLInsertByFields(table: TSlaveTableNode): string;
    function GetSQLInsertByFieldsNative(table: TSlaveTableNode): string;
    function GetSQLUpdateByFields(table: TSlaveTableNode; const explicit: TArrayOfString): string;
    function GetSQLDelete(table: TSlaveTableNode): string;

    procedure FDQueryExecuteError(ASender: TObject; ATimes, AOffset: Integer;
      AError: EFDDBEngineException; var AAction: TFDErrorAction);

    // * функция первичной закачки таблицы, а так же ее родителей.
    function CheckBigTable(table: TSlaveTableNode; var ApproximateCount: Integer): Boolean;
    function ExecuteDownLoadBigTable(table: TSlaveTableNode; var RowAffected: Integer): Boolean;
    function ExecuteDownloadData(table: TSlaveTableNode): Integer;
    function ExecuteDownLoadBlobTableNative(table: TSlaveTableNode; var RowAffected: Integer): Boolean;
    procedure RestoreSequenses;

    function GetChangedData(var Params: TChangedDataParams;
      var Data: TListTDataChangedInfo): Boolean;
    function GetChangedDataScript(var Params: TChangedDataParams): Boolean;
    function GetChangedDDL(var Data: TListChangedDLL; last_modified: TDateTime): Boolean;

    function ExecuteInsert(Table: TSlaveTableNode): Integer;
    function ExecuteUpdate(Table: TSlaveTableNode): Integer;
    function ExecuteDelete(Table: TSlaveTableNode): Integer;

    function ExecuteEx(Table: TSlaveTableNode): Boolean; overload;


  public
    constructor Create(DestConn, SourceCon: TFDCustomConnection);
    destructor Destroy; override;

    function ExecuteEx(const SchemaName, TableName: string): Boolean; overload;
    procedure ExecuteDDL();
    procedure Terminate;
    function VisitClient: Boolean;
    property Destination: TFDCustomConnection read FDestCon write SetDestCon;
    property Source: TFDCustomConnection read FSourceCon write SetSourceCon;
    property Tables: TRelationNodeList read FTables;
    property ClientID: string read FClientID;
  end;


const
  ROWSET_SIZE_UPDATE_DATA = 1000;
implementation
uses
  Variants, System.Diagnostics, System.DateUtils, Logger, CrtUtils, FixNativePG;
const
FIXUP_PKEYS_TABLES: array [0..23, 0..1] of string = (
  ('containerlinkobject', 'containerid'),
  ('movementblob', 'movementid'),
  ('movementboolean', 'movementid'),
  ('movementdate', 'movementid'),
  ('movementfloat', 'movementid'),
  ('movementitemboolean', 'movementitemid'),
  ('movementitemdate', 'movementitemid'),
  ('movementitemfloat', 'movementitemid'),
  ('movementitemlinkobject', 'movementitemid'),
  ('movementitemstring', 'movementitemid'),
  ('movementlinkmovement', 'movementid'),
  ('movementlinkobject', 'movementid'),
  ('movementstring', 'movementid'),
  ('objectblob', 'objectid'),
  ('objectboolean', 'objectid'),
  ('objectcostlink', 'objectcostid'),
  ('objectdate', 'objectid'),
  ('objectfloat', 'objectid'),
  ('objecthistorydate', 'objecthistoryid'),
  ('objecthistoryfloat', 'objecthistoryid'),
  ('objecthistorylink', 'objecthistoryid'),
  ('objecthistorystring', 'objecthistoryid'),
  ('objectlink', 'objectid'),
  ('objectstring', 'objectid'));


  function FixupPKTable(var field: string; table: TTableNode): Boolean;
  var
    i: Integer;
  begin
    Result := false;
    for I := 0 to Length(FIXUP_PKEYS_TABLES)-1 do
      if FIXUP_PKEYS_TABLES[i, 0] = table.Table then
        begin
          field := FIXUP_PKEYS_TABLES[i, 1];
          Result :=true;
          break;
        end;
  end;

{ **************************************************************************** }
{                               TDBReplicationEx                               }
{ **************************************************************************** }

procedure TDBReplicationEx.StartTransaction;
begin
  if not FDestCon.InTransaction then
    FDestCon.StartTransaction;
end;


function TDBReplicationEx.CheckBigTable(table: TSlaveTableNode; var ApproximateCount: Integer): Boolean;
const
  LIMIT_BIGTABLE_VALUE = 50000000;  // 50 млн. << значение определяет считать ли таблицу огромной.
var
  v: Variant;
begin
  ApproximateCount := 0;
  v := FSourceCon.ExecSQLScalar(Format(
    'SELECT reltuples::bigint AS count FROM pg_class WHERE oid = ''%s''::regclass', [table.Master.Name]));
  if not VarIsNull(V) then
    ApproximateCount := V;
  Result := ApproximateCount > LIMIT_BIGTABLE_VALUE;
end;

procedure TDBReplicationEx.CommitTransaction;
begin
  if FDestCon.InTransaction then
    try
      FDestCon.Commit;
    except
      FDestCon.Rollback;
      raise
    end;
end;

procedure TDBReplicationEx.RollbackTransaction;
begin
  if FDestCon.InTransaction then
    FDestCon.Rollback;
end;

constructor TDBReplicationEx.Create(DestConn, SourceCon: TFDCustomConnection);
begin
  inherited Create;
  FDestCon     := DestConn;
  FSourceCon   := SourceCon;

  FQueryData := TFDQuery.Create(nil);
  FQueryData.Connection := SourceCon;
  FQueryData.FetchOptions.RowsetSize := ROWSET_SIZE_UPDATE_DATA;
  //FQueryData.FetchOptions.Mode := fmManual;
  FQueryData.FetchOptions.Mode := fmOnDemand;
  FQueryData.FetchOptions.CursorKind := ckForwardOnly;
  FQueryData.FetchOptions.Unidirectional := true;
  FQueryData.UpdateOptions.RequestLive := false;
  FQueryData.FetchOptions.Items := [fiDetails, fiBlobs];
end;

destructor TDBReplicationEx.Destroy;
begin
  FTables.Free;
  FQueryData.Free;
  FLastIDCommand := nil;
  FSaveTableInfo := nil;
  inherited;
end;

function TDBReplicationEx.EncodeSQLTableName(table: TTableNode): string;
begin
  Result := FDestCon.EncodeObjectName('', table.Schema, '', table.Table);
end;

function TDBReplicationEx.EncodeTimeSQLParam(value: TDateTime; Quoted: Boolean): string;
begin
  if Quoted then
    Result := QuotedStr(FormatDateTime('YYYY-MM-DD HH:NN:SS.ZZZ', value)) else
    Result := FormatDateTime('YYYY-MM-DD HH:NN:SS.ZZZ', value);
end;

procedure TDBReplicationEx.ExecuteDDL();
var
  query: TFDQuery;
  dcis: TListChangedDLL;
  LastModified: TDateTime;
  I: Integer;
begin
  exit;
  if not GetChangedDDL(dcis, LastModified) then exit;
  for I := 0 to Length(dcis)-1 do
    begin
      if dcis[i].last_modified > LastModified then
        LastModified := dcis[i].last_modified;
      FDestCon.ExecSQL(dcis[i].query);
    end;
end;

function TDBReplicationEx.ExecuteDelete(Table: TSlaveTableNode): Integer;
var
  s_query: TFDQuery;
  data: PDataChangedInfo;
  I: Integer;
  params: TArrayOfParams;
begin
  Result := 0;
  if (Table = nil) or (table.data = nil)   then exit;
  data := Table.data;
  s_query := table.Request[reqD].query;
  if not s_query.Prepared then
    begin
      s_query.SQL.Text := GetSQLDelete(table);
      table.ReindexRequestParam(reqD);
    end;
  params := table.Request[reqD].map_params;

  while data <> nil do
    begin
      for I := 0 to Length(data.key_names)-1 do
        params[i].Value := table.CastPKValue(i, data.key_values[i]);
      s_query.Execute();
      Inc(Result, s_query.RowsAffected);
      data := data.next;
    end;
end;

function TDBReplicationEx.GetChangedDataScript(
  var Params: TChangedDataParams): Boolean;
var
  i, cur_rows, cnt: integer;
  cmd_tud, cmd_req, cmd_gen: TFDQuery;
  oFtch: TFDFetchOptions;
  oRes: TFDResourceOptions;
  oCmd: IFDPhysCommand;
  table: TSlaveTableNode;
  sql: TSTringList;

begin

  Result := false;
  if FTerminate then exit;

  Params.last_id := FLastChangedID;
  Params.last_modified := FLastModified;

  FDestCon.ConnectionIntf.CreateCommand(oCmd);
  oFtch := oCmd.Options.FetchOptions;
  oFtch.AutoClose := False;
  oFtch.AutoFetchAll := afAll;
  oFtch.Items := [];
  oRes := oCmd.Options.ResourceOptions;
  if oRes.CmdExecMode = amAsync then
    oRes.CmdExecMode := amBlocking;
  oRes.DirectExecute := True;
  oRes.MacroCreate := False;
  oRes.MacroExpand := false;
  oRes.Persistent := False;
  sql := TStringList.Create;
  cmd_tud := TFDQuery.Create(nil);
  try
  cmd_tud.Connection := FSourceCon;
  //cmd_tud.FetchOptions.RowsetSize     := ROWSET_SIZE_UPDATE_DATA;
  //cmd_tud.FetchOptions.Mode           := fmOnDemand;
//  cmd_tud.FetchOptions.CursorKind     := ckForwardOnly;
//  cmd_tud.FetchOptions.Unidirectional := true;
  cmd_tud.FetchOptions.Mode := fmAll;
  cmd_tud.UpdateOptions.RequestLive   := false;
  cmd_tud.FetchOptions.Items          := [];

  cmd_req := TFDQuery.Create(cmd_tud);
  cmd_req.Connection := FSourceCon;
  //cmd_req.FetchOptions.RowsetSize     := ROWSET_SIZE_UPDATE_DATA;
  cmd_req.FetchOptions.Mode           := fmOnDemand;
  cmd_req.FetchOptions.CursorKind     := ckForwardOnly;
  cmd_req.FetchOptions.Unidirectional := true;
  cmd_req.UpdateOptions.RequestLive   := false;
  cmd_req.FetchOptions.Items          := [fiBlobs];
  cmd_req.ResourceOptions.DirectExecute := true;

  cmd_tud.SQL.Text := 'select Count(*) as cnt, transaction_id, min(id) as min_id, max(id) as max_id FROM _replica.table_update_data'+sLineBreak+
                                  '	where (id > :id) AND (last_modified > :last_modified)  GROUP BY transaction_id order by min_id ASC';

  cmd_tud.Params[0].AsInteger  := Params.last_id;
  cmd_tud.Params[1].AsDateTime := IncSecond(Params.last_modified, -1);
  cmd_tud.Open();
  if cmd_tud.IsEmpty then exit;

  SetLength(Params.txids, cmd_tud.RecordCount);
  SetLength(Params.rows, cmd_tud.RecordCount);
  Params.count := cmd_tud.RecordCount;
  Params.index := 0;
  i := 0;
  while not cmd_tud.Eof do
    begin
      if FTerminate then exit;
      Params.txids[i] := cmd_tud.Fields[1].AsLargeInt;
      Params.rows[i]  := cmd_tud.Fields[0].AsInteger;
      Params.total_rows  := Params.total_rows + Params.rows[i];
      cmd_tud.Next;
      Inc(i);
    end;

  try
  i := 0;
  cnt := Params.total_rows;
  Progress(i, cnt, 'update/execute requests', false);
  cmd_tud.First;
  while not cmd_tud.Eof do
    begin
      if FTerminate then exit;
      cmd_req.SQL.Text := 'SELECT  * FROM _replica.gpSelect_Replica_union(:id_start, :id_end)';
      cmd_req.Params[0].AsInteger := cmd_tud.Fields[2].AsInteger;
      cmd_req.Params[1].AsInteger := cmd_tud.Fields[3].AsInteger;
      cmd_req.Open();
      // собираем запрос
      sql.Clear;
      while not cmd_req.Eof do
        begin
          sql.Add(cmd_req.Fields[2].AsString);
          cmd_req.Next;
        end;
     // sql.SaveToFile('test.sql');
      cmd_req.Close;
      cmd_req.Open(sql.Text);
      StartTransaction;
      cur_rows := 0;
      while not cmd_req.Eof do
        begin
          if FTerminate then exit;
          table := FTables.NodeByMaster('public.'+cmd_req.Fields[2].AsString);
          table.last_row_id   := cmd_req.Fields[0].AsInteger;
          table.last_modified := cmd_req.Fields[3].AsDateTime;
          Params.last_id := table.last_row_id;
          Params.last_modified := table.last_modified;
          oCmd.CommandText  := cmd_req.Fields[4].AsString;
          oCmd.Execute();
          cmd_req.Next;
          Inc(i);
          Inc(cur_rows);
          Progress(i, cnt, 'update/execute requests', false, false);
        end;

      SaveQuerySlaveInfo(table);
      SaveLastID(table.last_row_id);
      CommitTransaction;
      FLastChangedID := Params.last_id;
      FLastModified := Params.last_modified;
      LogI('<·· Transaction = %d, Rows updated: %d, Rows expected: %d ··>', [cmd_tud.Fields[1].AsLargeInt, cur_rows, Params.rows[Params.index]]);
      Inc(Params.index);
      cmd_tud.Next;
    end;
  except
    RollbackTransaction;
    raise;
  end;
  LogI('<·· RECEIVED %d, Expected: %d ··>', [i, Params.total_rows]);
  finally
    Progress(0, 0, '', true);
    cmd_tud.Free;
    sql.Free;
  end;
end;

function TDBReplicationEx.ExecuteEx(Table: TSlaveTableNode): Boolean;
var
  dcis: TListTDataChangedInfo;
  I, recs, last_rows: Integer;
  counts: ^TListAffectedRows;
  params: TChangedDataParams;
  LastTXID: Int64;

  procedure ProcessChangedData;
  label
    UKViolatedStart;
  var
    k: Integer;
    UKViolated: Boolean;
    s1, s2: string;
  begin
    k := 0;
  UKViolatedStart:
    UKViolated := false;
    try
      for k := k to Length(dcis)-1 do
        begin
          Inc(recs);
          Progress(recs, params.total_rows, 'receiving records', false);
          if FTerminate then break;
          if (dcis[k].root) then
            begin
              s1 := dcis[k].schema_name + '.' + dcis[k].table_name;
              if s2 <> s1 then
                begin
                  table := FTables.NodeByMaster(s1);
                  s2 := s1;
                end;
              if table = nil then Continue;
              if not table.FieldDefsUpdated then
                UpdateTableFieldDefs(table);

              repeat
                if FTerminate then  break;
                if not table.downloaded then Continue;
                counts := @table.rows;
                table.data := @dcis[k];
                with dcis[k] do
                  case operation of
                    dmlUnknown: ;
                    dmlInsert: counts[operation] := counts[operation] + ExecuteInsert(table);
                    dmlUpdate: counts[operation] := counts[operation] + ExecuteUpdate(table);
                    dmlDelete: counts[operation] := counts[operation] + ExecuteDelete(table);
                  end;
                table.last_modified := dcis[k].last_modified;
                params.last_modified:= table.last_modified;
                Params.last_id      := dcis[k].id;
              until not table.GetSubling(table);
            end;
        end;


    except
      on E: EFDDBEngineException do
        begin
          Progress(0, 0, '', true);
          if (EFDDBEngineException(E).Kind = ekUKViolated) then
            begin
              LogE('table: %s ->  %s %s',  [table.Name, E.Message, EFDDBEngineException(E).SQL]);
              Inc(k);
              UKViolated := true;
              //CommitTransaction;
              //SaveLastID(last_id);
              //FLastChangedID := last_id;
            end
          else
            begin
              Progress(0, 0, '', true);
              RollbackTransaction;
              raise;
            end;
        end;
      on E: Exception do
        begin
          Progress(0, 0, '', true);
          RollbackTransaction;
          raise;
        end;
    end;
    if UKViolated then goto UKViolatedStart;
  end;


  procedure UpdateCommitTransaction(finish: Boolean);
  var
    i: Integer;
  begin
    if ((LastTXID = -1) or (LastTXID = params.cur_txid)) and not finish then exit;
    if FTerminate then
      begin
        RollbackTransaction;
        LogW('<·· ROLLBACK by user, Transaction = %d, LastID = %D ··>', [LastTXID, FLastChangedID]);
        exit;
      end;
    for I := 0 to Tables.CountSlave-1 do
      begin
        table := tables.Slaves[I];
        if table.Changed then
          SaveQuerySlaveInfo(table);
      end;
     SaveLastID(Params.last_id);
     CommitTransaction;
     FLastChangedID := params.last_id;
     FLastModified := params.last_modified;
    if not finish then
      StartTransaction;
    for I := 0 to Tables.CountSlave-1 do
      begin
        table := tables.Slaves[I];
        repeat
        counts := @table.rows;
        if (counts[dmlInsert] > 0) or
           (counts[dmlUpdate] > 0) or
           (counts[dmlDelete] > 0) then
           begin
             LogI('table: %s ins: %d upd: %d del: %d', [table.Name, counts[dmlInsert], counts[dmlUpdate], counts[dmlDelete]]);
           end;
        FillChar(counts^, SizeOf(TListAffectedRows), 0);

        until not table.GetSubling(table);
      end;
    LogI('<·· Transaction = %d, Records: %d, LastID = %D ··>', [LastTXID, last_rows, FLastChangedID]);
  end;

  procedure _ResetRequests;
  var
    i: Integer;
  begin
    for I := 0 to Tables.CountSlave-1 do
      Tables.Slaves[i].ResetRequests;
  end;

begin
  FProcessing := true;
  try
    if not FFullDownLoaded then
      begin
        UpdateRelationShip;
        if FLastModified = 0 then
          FLastModified := TTimeZone.Local.ToUniversalTime(Now);
        for I := 0 to Tables.CountSlave-1 do
          begin
            if FTerminate then exit;
            table := tables.Slaves[I];
            if not table.Downloaded then
              ExecuteDownloadData(table);
            //  самую малеьнкую дату, чтобы охватить все таблицы.
            //  во время скачивания каждой, могли измениться данные.
            if FLastModified > table.last_modified then
              FLastModified := table.last_modified;
          end;
        RestoreSequenses;
      end;
    FFullDownLoaded := true;

    FillChar(params, SizeOf(params), 0);
    FSourceCon.StartTransaction;
    if FindCmdLineSwitch('use_generate_script') then
      begin
        GetChangedDataScript(params);
      end
    else
      begin

      params.last_id := FLastChangedID;
      params.last_modified := FLastModified;
      LastTXID := -1;
      recs := 0;
      StartTransaction;
      while GetChangedData(params,  dcis) do
        begin
          if FTerminate then break;
          UpdateCommitTransaction(false);
          LastTXID := params.cur_txid;
          last_rows :=params.cur_rows;
          ProcessChangedData();
        end;
      UpdateCommitTransaction(true);
      Progress(0, 0, '', true);
      if recs > 0  then
        LogI('Received records = %d', [recs]);
    end;
  finally
    if FSourceCon.InTransaction then
      FSourceCon.Commit;
    _ResetRequests;
    FProcessing := false;
  end;

  if FNeedVisit then
    VisitClient;


end;

function TDBReplicationEx.ExecuteEx(const SchemaName, TableName: string): Boolean;
var
  t: TSlaveTableNode;
begin
  if not Assigned(FTables) then UpdateTableList;

  if (SchemaName = '') and (TableName = '') then
    ExecuteEx(nil) else
    begin
      t := FTables.NodeByMaster(SchemaName + '.' +TableName);
      if t <> nil then
        ExecuteEx(t);
    end;
end;

function TDBReplicationEx.ExecuteInsert(Table: TSlaveTableNode): Integer;
var
  m_query, s_query: TFDQuery;
  data: PDataChangedInfo;
  I: Integer;
  mFields: TArrayOfFields;
  mParams: TArrayOfParams;
begin
  Result := 0;
  if (Table = nil) or (table.data = nil)   then exit;
  data := Table.data;
  m_query := table.Request[reqSI].query;
  s_query := Table.Request[reqI].query;

  //  подготовка запроса, происходит один раз, для инсерта
  //  всегда один и тот же запрос. Индексация параметров
  if not s_query.Prepared  then
    begin
      m_query.SQL.Text := GetSQLSelectByFields(table, [], true);
      s_query.SQL.Text := GetSQLInsertByFields(table);
      table.ReindexRequestParam(reqSI);
    end;

  mParams := table.Request[reqSI].map_params;
  m_query.Close;
  while data <> nil do
    begin
      //  заполнение параметров мастера
      for I := 0 to Length(data.key_names)-1 do
        mParams[i].Value := table.CastPKValue(i, data.key_values[i]);
      m_query.Open;
      if m_query.IsEmpty then
        begin
          data := data.next;
          Continue;
        end;
      //  индексация полей мастера. Close() вызывает DestroyFields
      SetLength(mFields, s_query.ParamCount);
      for I := 0 to Length(mFields)-1 do
        begin
          mFields[i] := m_query.FindField(s_query.Params[i].Name);
          if mFields[i] <> nil then
            s_query.Params[I].DataType := mFields[i].DataType;
        end;

      // обработка записей, while наверное лишний
      while not m_query.Eof do
        begin
          for I := 0 to s_query.ParamCount-1 do
            begin
              if mFields[i] <> nil then
                s_query.Params[I].Value := mFields[i].Value;
              if s_query.Params[i].DataType = ftUnknown then
                s_query.Params[i].DataType := ftString;
            end;
          //  исполнение
          s_query.Execute();
          Inc(Result, s_query.RowsAffected);
          m_query.Next;
        end;
      m_query.Close;
      data := data.next;
    end;

end;

function TDBReplicationEx.ExecuteUpdate(Table: TSlaveTableNode): Integer;
var
  m_query, s_query: TFDQuery;
  data: PDataChangedInfo;
  I: Integer;
  mFields: TArrayOfFields;
  mParams, sParams: TArrayOfParams;

  function EqualChangedFields(const a, b: TArrayOfString): Boolean;
  var
    k: Integer;
  begin
    Result := Length(a) = Length(b);
    if Result then
      for k := 0 to Length(a)-1 do
        if a[k] <> b[k] then
          begin
            Result := false;
            break;
          end;
  end;
begin
  Result := 0;
  if (Table = nil) or (table.data = nil)   then exit;
  data := Table.data;
  m_query := table.Request[reqSU].query;
  s_query := Table.Request[reqU].query;
  s_query.Close;
  m_query.Close;
  while data <> nil do
    begin
      // подготовка запроса, если не был подготовлен или параметры изменились
      if not s_query.Prepared or not EqualChangedFields(data.changed_fields, table.prev_changed_fields) then
        begin
          table.prev_changed_fields := data.changed_fields;
          m_query.SQL.Text := GetSQLSelectByFields(table, data.changed_fields, true);
          s_query.SQL.Text := GetSQLUpdateByFields(table, data.changed_fields);
          // Индексация параметров
          Table.ReindexRequestParam(reqSU);
          Table.ReindexRequestParam(reqU);
        end;
      m_query.Close;
      // подготовка параметров
      mParams := table.Request[reqSU].map_params;
      sParams := table.Request[reqU].map_params;
      for I := 0 to Length(data.key_names)-1 do
        mParams[i].Value := table.CastPKValue(i, data.key_values[i]);

      m_query.Open;
      if m_query.IsEmpty then
        begin
          data := data.next;
          Continue;
        end;
      // индексация полей
      SetLength(mFields, s_query.ParamCount);
      for I := 0 to Length(mFields)-1 do
        begin
          mFields[i] := m_query.FindField(s_query.Params[i].Name);
          if mFields[i] <> nil then
            s_query.Params[I].DataType := mFields[i].DataType;
        end;

      while not m_query.Eof do
        begin
          for I := 0 to Length(mParams)-1 do
            sParams[i].Value := mParams[i].Value;
          for I := 0 to s_query.Params.Count-1 do
            begin
              if mFields[i] <> nil then
                s_query.Params[I].Value := mFields[i].Value;
              if s_query.Params[i].DataType = ftUnknown then
                s_query.Params[i].DataType := ftString;
            end;
          s_query.Execute();
          Inc(Result, s_query.RowsAffected);
          m_query.Next;
        end;
      m_query.Close;
      data := data.next;
    end;
end;


procedure TDBReplicationEx.FDQueryExecuteError(ASender: TObject; ATimes,
  AOffset: Integer; AError: EFDDBEngineException; var AAction: TFDErrorAction);
var
  i, r, idx: Integer;
begin
  if AError.Errors[0].Kind =  ekFKViolated then
    begin
      r := FErrors.AddRow;
      idx := AError.Errors[0].RowIndex;
      with TFDQuery(ASender) do
        for I := 0 to TFDQuery(ASender).ParamCount-1 do
          FErrors.Add(r, i, Params[i].Values[idx]);
      AAction := eaSkip;
    end
  else if AError.Errors[0].Kind = ekUKViolated  then
    AAction := eaSkip;
end;


function TDBReplicationEx.ExecuteDownLoadBigTable(table: TSlaveTableNode;
  var RowAffected: Integer): Boolean;
const
  SRC_ROWSET_RANGE  = 500000;      //<<  диапазон выборки строк из мастера
  SRC_ROWSET_SIZE   = 1000;        //<<  диапазон выборки строк из мастера
  DST_ROWSET_SIZE   = 200;        //<<  размер массива параметров для вызова одной операции Write
  DST_ROWSET_COMMIT = 1000;       //<<  кол-во записей, по достижение которого проиходит Commit


var
  pgConSrc, pgConDst: TPgConnection;
  pgStmtSrc, pgStmtDst: TPgStatement;
  I, J, Count, Counter, RowCommit, ParamCnt, RowScip, Size: Integer;
  UseGibridRowID: Integer;
  RowIDIndexField: Integer;
  InfoProgress, CheckFieldName: string;
  Buf: Pointer;
  Len, LenID: LongWord;
  id, idRaw: Int64;
  sql_insert, sql_select: string;
  oids: array of OID;
  {$ifdef PRINT_TIMER_TRANSACTION}
  t, total: TStopwatch;
  {$endif}

    procedure MoveRotate(ASrc, ADest: Pointer; ALen: Cardinal);
    var
      pSrc, pDest: PByte;
    begin
      pSrc := ASrc;
      pDest := PByte(ADest) + ALen - 1;
      while ALen > 0 do begin
        pDest^ := pSrc^;
        Inc(pSrc);
        Dec(pDest);
        Dec(ALen);
      end;
    end;

  function GetSQLSelectSyncEx(const sql: string): string;
  var
    s, o, w: string;
    I: Integer;
  begin
    o := '';
    s := '';
    w := '';
    UseGibridRowID := 1;
    if ((table.Master.PrimaryCount = 1) and
       (table.Master.PrimaryKey[0].FieldType in [ftInteger, ftLargeint, ftLongWord, ftSmallint, ftWord])) or
       table.FixUP then
      begin
        if table.FixUP then
          o := table.FixUPField else
          o := NormalizeName(table.Master.PrimaryKey[0].FieldName);
        //if table.last_row_id > 0 then
        w := ' WHERE ' + o +' >' + table.FixUPOperator + ' %d';//+IntToStr(table.last_row_id);
        Result := sql + w + ' ORDER BY ' + o + ' ASC LIMIT %d';//  OFFSET %d';
        UseGibridRowID := 0;
        exit;
      end;

    for I := 0 to table.Master.PrimaryCount-1 do
      if i = 0 then
        o := NormalizeName(table.Master.PrimaryKey[i].FieldName) else
        o := o + ', ' + NormalizeName(table.Master.PrimaryKey[i].FieldName);

    //if table.last_row_id > 0 then
    w := ' WHERE row_id > %d';//+IntToStr(table.last_row_id);

    s := Copy(sql, Pos(' ', sql) + 1, Length(sql));
    Result := 'SELECT * FROM ( '+sLineBreak +
         ' 	SELECT ROW_NUMBER() OVER(ORDER BY '+o+') AS row_id, '+ s + sLineBreak +
         ') AS data '+ w + ' ORDER BY 1 LIMIT %d';// OFFSET %d';

  end;

  function SQLInsertBatch(const sql: string; rowset_size: Integer): string;
  var
    i, j, pcount: Integer;
    p, pi: PChar;
    si: string;
  begin
      if rowset_size = 1 then
        begin
          Result := sql;
          exit;
        end;
      SetLength(Result, rowset_size * 10 * table.FieldCount);
      p := Pointer(Result);
      pcount := 0;
      for I := 1 to rowset_size-1 do
        begin
          P^ := '('; Inc(P); Inc(pcount);
          for j := 1 to table.FieldCount do
            begin
              si := IntToStr(i * table.FieldCount + j);
              pi := Pointer(si);
              P^ := '$'; Inc(P);
              Inc(pcount);
              while pi^ <> #0 do
                begin
                  p^ := pi^; Inc(p); Inc(pi); Inc(pcount);
                end;
              P^ := ','; Inc(P); P^ := ' '; Inc(P); Inc(pcount, 2);
            end;
          (P-2)^ := ')';  (P-1)^ := ',';  P^ := ' '; Inc(P); Inc(pcount);
        end;
      Dec(pcount, 2);
      SetLength(Result, pcount);
      if table.FixUP then
        Result := Result + ' ON CONFLICT DO NOTHING;';
      Result := sql + ', '+Result;
  end;

begin
  Result := false;
  if table.Downloaded or FTerminate then exit;
  if not CheckBigTable(table, Count) then exit;
  Result := true;
  RowAffected := 0;
  pgConSrc := TPgConnection(FSourceCon.ConnectionIntf.CliObj);
  pgConDst := TPgConnection(FDestCon.ConnectionIntf.CliObj);
  pgStmtDst := TPgStatement.Create(pgConDst, Self);
  pgStmtSrc := TPgStatement.Create(pgConSrc, Self);

  try
    //table.last_row_id := 2611799;
    PatchPgParams(pgStmtDst.Params);
    pgConSrc.ExecuteQuery('BEGIN ISOLATION LEVEL REPEATABLE READ');
    pgStmtSrc.RowsetSize := SRC_ROWSET_SIZE;
    sql_select := GetSQLSelectSyncEx(GetSQLSelectByFieldsNative(table, []));
    {$ifdef PRINT_TIMER_TRANSACTION}
      t := TStopwatch.StartNew;
    {$endif}
    pgStmtSrc.PrepareSQL(Format(sql_select, [table.last_row_id, SRC_ROWSET_RANGE]));
    pgStmtSrc.Execute;
    {$ifdef PRINT_TIMER_TRANSACTION}
      t.Stop;
    {$endif}
    pgStmtSrc.DescribeFields;

    if table.last_modified = 0 then
      table.last_modified := TTimeZone.Local.ToUniversalTime(Now);

    LogI('table: %s start downloading. Last Row ID = %d', [table.Name, table.last_row_id]);
    LogI('BIG TABLE DETECTED, number of records %d (precision abt ~90%%)', [Count]);
    {$ifdef PRINT_TIMER_TRANSACTION}
      LogI('OPEN ROWSET/LIMIT %d/%d = %s', [SRC_ROWSET_SIZE, SRC_ROWSET_RANGE, t.Elapsed.ToString]);
      LogI('INSERT ROWSET/COMMIT %d/%d', [DST_ROWSET_SIZE, DST_ROWSET_COMMIT]);
    {$endif}

    InfoProgress := table.Name;
    Progress(0, Count, InfoProgress, false);
    ParamCnt := pgStmtSrc.Fields.Count - UseGibridRowID;
    if Count < DST_ROWSET_SIZE  then
      Size := Count else
      Size := DST_ROWSET_SIZE;
    pgStmtDst.Params.Count :=  ParamCnt * Size;

    for I := 0 to Size-1 do
      begin
        for j := 0 to ParamCnt-1 do
          begin
            pgStmtDst.Params[i * ParamCnt + J].TypeOid   := pgStmtSrc.Fields[J+UseGibridRowID].TypeOid;
            pgStmtDst.Params[i * ParamCnt + J].DumpLabel := pgStmtSrc.Fields[J+UseGibridRowID].Name;
          end;
      end;
    try
      StartTransaction;//pgConDst.ExecuteQuery('BEGIN');
      sql_insert := SQLInsertBatch(GetSQLInsertByFieldsNative(table), Size);
      pgStmtDst.PrepareSQL(sql_insert);

      Counter   := 0;
      RowCommit := 0;
      Size      := 0;
      RowIDIndexField := -1;
      if table.FixUP then
        CheckFieldName := table.FixUPField else
        CheckFieldName := table.Master.PrimaryKey[0].FieldName;
      SetLength(oids, pgStmtSrc.Fields.Count);
      for I := 0 to pgStmtSrc.Fields.Count-1 do
        begin
          oids[i] := pgStmtSrc.Fields[i].TypeOid;
          pgStmtSrc.Fields[i].TypeOid := SQL_ANY;
          if (UseGibridRowID = 0) and (RowIDIndexField = -1) then
            if pgStmtSrc.Fields[i].Name = CheckFieldName then
              RowIDIndexField := I;
        end;
     if RowIDIndexField = -1 then
      RowIDIndexField := 0;

      for I := 0 to pgStmtDst.Params.Count-1 do
        pgStmtDst.Params[i].TypeOid := SQL_ANY;
      pgConDst.ExecuteQuery('ALTER TABLE '+EncodeSQLTableName(table)+' DISABLE TRIGGER ALL');
      {$ifdef PRINT_TIMER_TRANSACTION}
        t.Reset;
        t.Start;
        total := TStopwatch.StartNew;
      {$endif}
      pgStmtSrc.Fetch;
      while not pgStmtSrc.Eof do
        begin
          if FTerminate then break;
          for I := 0 to DST_ROWSET_SIZE-1 do
            begin
              if FTerminate then break;
              for j := 0 to ParamCnt-1 do
                begin
                  buf := nil;
                  len := 0;
                  pgStmtSrc.Fields[J+UseGibridRowID].GetData(buf, len, true);
                  pgStmtDst.Params[i * ParamCnt + J].SetData(buf, len, false);
                end;
              idRaw := 0;
              LenID := 0;
              pgStmtSrc.Fields[RowIDIndexField].GetData(@idRaw, LenID);
              Inc(Counter);
              Inc(RowCommit);
              Inc(Size);
              if not pgStmtSrc.Fetch then break;
            end;
          id := 0;
          MoveRotate(@idRaw, @id, LenID);
          table.last_row_id := id;
          if FTerminate then break;

          if Size < DST_ROWSET_SIZE then
            begin
              sql_insert := SQLInsertBatch(GetSQLInsertByFieldsNative(table), Size);
              pgStmtDst.Params.Count := ParamCnt * Size;
              for I := 0 to Size-1 do
                for j := 0 to ParamCnt-1 do
                  TPgParamEx(pgStmtDst.Params[i * ParamCnt + J]).SetTypeOidSilent(oids[J+UseGibridRowID]);
                pgStmtDst.PrepareSQL(sql_insert);
                // если в этом блоке, то это уже последние данные. Остаток.
                pgStmtDst.Execute;
                Inc(RowAffected, pgStmtDst.RowsAffected);
                Progress(RowAffected, Count, InfoProgress, false, false);
                break;
            end;
          Size      := 0;
          pgStmtDst.Execute;
          Inc(RowAffected, pgStmtDst.RowsAffected);
          Progress(RowAffected, Count, InfoProgress, false, false);
          if RowCommit = DST_ROWSET_COMMIT then
            begin
              RowCommit := 0;
              SaveQuerySlaveInfo(table);
              pgConDst.ExecuteQuery('COMMIT');
              {$ifdef PRINT_TIMER_TRANSACTION}
                t.Stop;
                LogI('Commit: %d, %.3f ms, %f/rps, %f s',
                  [Counter, t.Elapsed.Ticks / t.Elapsed.TicksPerMillisecond, Counter / total.Elapsed.Ticks * total.Elapsed.TicksPerSecond, total.Elapsed.Ticks / total.Elapsed.TicksPerSecond]);
              {$endif}
              pgConDst.ExecuteQuery('BEGIN');
              {$ifdef PRINT_TIMER_TRANSACTION}
                t.Reset;
                t.Start;
              {$endif}
            end;

          if pgStmtSrc.Eof and not FTerminate then
            begin
                RowScip := RowScip + SRC_ROWSET_RANGE;
                pgStmtSrc.Close;
                pgStmtSrc.Unprepare;
              {$ifdef PRINT_TIMER_TRANSACTION}
                t.Stop;
                t.Reset;
                t.Start;
              {$endif}
                pgStmtSrc.PrepareSQL(Format(sql_select, [table.last_row_id, SRC_ROWSET_RANGE]));
                pgStmtSrc.Execute;
                pgStmtSrc.DescribeFields;
                for I := 0 to pgStmtSrc.Fields.Count-1 do
                  pgStmtSrc.Fields[i].TypeOid := SQL_ANY;
                if not pgStmtSrc.Fetch then break;

              {$ifdef PRINT_TIMER_TRANSACTION}
                t.Stop;
                LogI('OPEN ROWSET/LIMIT %d/%d = %s', [pgStmtSrc.RowsetSize, SRC_ROWSET_RANGE, t.Elapsed.ToString]);
                t.Reset;
                t.Start;
              {$endif}
            end;
        end;
      table.Downloaded := not FTerminate;
    {$ifdef PRINT_TIMER_TRANSACTION}
      t.Stop;
      total.stop;
    {$endif}
      FDestCon.ExecSQL('ALTER TABLE '+EncodeSQLTableName(table)+' ENABLE TRIGGER ALL');
      // when an exception occurs, always trying to commit an already received data.
      SaveQuerySlaveInfo(table);
      CommitTransaction;//pgConDst.ExecuteQuery('COMMIT');
      Progress(Counter, Count, InfoProgress, false, false);
    except
      RollbackTransaction; //pgConDst.ExecuteQuery('ROLLBACK');
      raise;
    end;
  finally
    pgStmtDst.Free;
    pgStmtSrc.Free;
    pgConSrc.ExecuteQuery('COMMIT');
    Progress(0, 0, '', true);
    LogI('table: %s full: %s downloaded: %d', [table.Name, BoolToStr(table.Downloaded, true), RowAffected]);
  end;
end;

function TDBReplicationEx.ExecuteDownLoadBlobTableNative(table: TSlaveTableNode;
  var RowAffected: Integer): Boolean;
const
  SRC_ROWSET_RANGE  = 1000;      //<<  диапазон выборки строк из мастера
  SRC_ROWSET_SIZE   = 1;        //<<  диапазон выборки строк из мастера
  DST_ROWSET_SIZE   = 1;        //<<  размер массива параметров для вызова одной операции Write
  DST_ROWSET_COMMIT = 100;       //<<  кол-во записей, по достижение которого проиходит Commit


var
  pgConSrc, pgConDst: TPgConnection;
  pgStmtSrc, pgStmtDst: TPgStatement;
  I, J, Count, Counter, RowCommit, ParamCnt: Integer;
  UseGibridRowID: Integer;
  RowIDIndexField: Integer;
  InfoProgress, CheckFieldName: string;
  Buf: Pointer;
  Len, LenID: LongWord;
  id, idRaw: Int64;
  sql_insert, sql_select: string;
  oids: array of OID;
  {$ifdef PRINT_TIMER_TRANSACTION}
  t, total: TStopwatch;
  {$endif}

    procedure MoveRotate(ASrc, ADest: Pointer; ALen: Cardinal);
    var
      pSrc, pDest: PByte;
    begin
      pSrc := ASrc;
      pDest := PByte(ADest) + ALen - 1;
      while ALen > 0 do begin
        pDest^ := pSrc^;
        Inc(pSrc);
        Dec(pDest);
        Dec(ALen);
      end;
    end;

  function GetSQLSelectSyncEx(const sql: string): string;
  var
    s, o, w: string;
    I: Integer;
  begin
    o := '';
    s := '';
    w := '';
    UseGibridRowID := 1;
    if ((table.Master.PrimaryCount = 1) and
       (table.Master.PrimaryKey[0].FieldType in [ftInteger, ftLargeint, ftLongWord, ftSmallint, ftWord])) or
        table.FixUP then
      begin
        if table.FixUP then
          o := table.FixUPField else
          o := NormalizeName(table.Master.PrimaryKey[0].FieldName);

        w := ' WHERE ' + o +' > %d';//+IntToStr(table.last_row_id);
        Result := sql + w + ' ORDER BY ' + o + ' ASC LIMIT %d';//  OFFSET %d';
        UseGibridRowID := 0;
        exit;
      end;

    for I := 0 to table.Master.PrimaryCount-1 do
      if i = 0 then
        o := NormalizeName(table.Master.PrimaryKey[i].FieldName) else
        o := o + ', ' + NormalizeName(table.Master.PrimaryKey[i].FieldName);

    //if table.last_row_id > 0 then
    w := ' WHERE row_id > %d';//+IntToStr(table.last_row_id);

    s := Copy(sql, Pos(' ', sql) + 1, Length(sql));
    Result := 'SELECT * FROM ( '+sLineBreak +
         ' 	SELECT ROW_NUMBER() OVER(ORDER BY '+o+') AS row_id, '+ s + sLineBreak +
         ') AS data '+ w + ' ORDER BY 1 LIMIT %d';// OFFSET %d';

  end;

function GetCountEx(const sql: string): Integer;
  var
    s, w, o: string;
    I: Integer;
  begin
    Result := 0;
    if ((table.Master.PrimaryCount = 1) and
        (table.Master.PrimaryKey[0].FieldType in [ftInteger, ftLargeint, ftLongWord, ftSmallint, ftWord])) or
        table.FixUP then
      begin
        if table.FixUP then
          o := table.FixUPField else
          o := NormalizeName(table.Master.PrimaryKey[0].FieldName);
        if table.last_row_id > 0 then
          w := ' WHERE ' + o +'>' + table.FixUPOperator +IntToStr(table.last_row_id) +';' else
          w := ';';
        s := 'SELECT Count(*) FROM '+ EncodeSQLTableName(table) + w; //sql
      end
    else
      begin
        for  I := 0 to table.Master.PrimaryCount-1 do
          if i = 0 then
            o := NormalizeName(table.Master.PrimaryKey[i].FieldName) else
            o := o + ', ' + NormalizeName(table.Master.PrimaryKey[i].FieldName);
        if table.last_row_id  > 0 then
          w := ' WHERE row_id '+'>'+IntToStr(table.last_row_id) + ';' else
          w := ';';
        s := Copy(sql, Pos(' ', sql) + 1, Length(sql));
        s := 'SELECT Count(*) FROM ( '+sLineBreak +
             ' 	SELECT ROW_NUMBER() OVER(ORDER BY '+o+') AS row_id, '+ s + sLineBreak +
             ') AS data '+w;
      end;
    pgStmtSrc.ExecuteDirect(s);
    pgStmtSrc.DescribeFields;
    if pgStmtSrc.Fetch then
      pgStmtSrc.Fields[0].GetData(@Result, Len);
    pgStmtSrc.Close;
    //Result := FSourceCon.ExecSQLScalar(s);

  end;

begin
  Result := false;
  if table.Downloaded or FTerminate then exit;
  if not CheckBigTable(table, Count) then Count := -1;
  Result := true;
  RowAffected := 0;
  pgConSrc := TPgConnection(FSourceCon.ConnectionIntf.CliObj);
  pgConDst := TPgConnection(FDestCon.ConnectionIntf.CliObj);
  pgStmtDst := TPgStatement.Create(pgConDst, Self);
  pgStmtSrc := TPgStatement.Create(pgConSrc, Self);

  try
    PatchPgParams(pgStmtDst.Params);
    pgConSrc.ExecuteQuery('BEGIN ISOLATION LEVEL REPEATABLE READ');
    pgStmtSrc.RowsetSize := SRC_ROWSET_SIZE;
    if Count < 0 then
      Count := GetCountEx(GetSQLSelectByFieldsNative(table, []));

    sql_select := GetSQLSelectSyncEx(GetSQLSelectByFieldsNative(table, []));
    {$ifdef PRINT_TIMER_TRANSACTION}
      t := TStopwatch.StartNew;
    {$endif}
    pgStmtSrc.PrepareSQL(Format(sql_select, [table.last_row_id, SRC_ROWSET_RANGE]));
    pgStmtSrc.Execute;
    {$ifdef PRINT_TIMER_TRANSACTION}
      t.Stop;
    {$endif}
    pgStmtSrc.DescribeFields;

    if table.last_modified = 0 then
      table.last_modified := TTimeZone.Local.ToUniversalTime(Now);

    LogI('table: %s start downloading. Last Row ID = %d', [table.Name, table.last_row_id]);
    LogI('BLOB TABLE DETECTED ...');
    {$ifdef PRINT_TIMER_TRANSACTION}
      LogI('OPEN ROWSET/LIMIT %d/%d = %s', [SRC_ROWSET_SIZE, SRC_ROWSET_RANGE, t.Elapsed.ToString]);
      LogI('INSERT ROWSET/COMMIT %d/%d', [DST_ROWSET_SIZE, DST_ROWSET_COMMIT]);
    {$endif}

    InfoProgress := table.Name;
    Progress(0, Count, InfoProgress, false);
    ParamCnt := pgStmtSrc.Fields.Count - UseGibridRowID;
    pgStmtDst.Params.Count :=  ParamCnt;

    for j := 0 to ParamCnt-1 do
      begin
        pgStmtDst.Params[J].TypeOid   := pgStmtSrc.Fields[J+UseGibridRowID].TypeOid;
        pgStmtDst.Params[J].DumpLabel := pgStmtSrc.Fields[J+UseGibridRowID].Name;
      end;

    try
      StartTransaction;//pgConDst.ExecuteQuery('BEGIN');
      sql_insert := GetSQLInsertByFieldsNative(table);
      pgStmtDst.PrepareSQL(sql_insert);

      Counter   := 0;
      RowCommit := 0;
      RowIDIndexField := -1;
      if table.FixUP then
        CheckFieldName := table.FixUPField else
        CheckFieldName := table.Master.PrimaryKey[0].FieldName;
      SetLength(oids, pgStmtSrc.Fields.Count);
      for I := 0 to pgStmtSrc.Fields.Count-1 do
        begin
          oids[i] := pgStmtSrc.Fields[i].TypeOid;
          pgStmtSrc.Fields[i].TypeOid := SQL_ANY;
          if (UseGibridRowID = 0) and (RowIDIndexField = -1) then
            if pgStmtSrc.Fields[i].Name = CheckFieldName then
              RowIDIndexField := I;
        end;
     if RowIDIndexField = -1 then
      RowIDIndexField := 0;

      for I := 0 to pgStmtDst.Params.Count-1 do
        pgStmtDst.Params[i].TypeOid := SQL_ANY;
      pgConDst.ExecuteQuery('ALTER TABLE '+EncodeSQLTableName(table)+' DISABLE TRIGGER ALL');
      {$ifdef PRINT_TIMER_TRANSACTION}
        t.Reset;
        t.Start;
        total := TStopwatch.StartNew;
      {$endif}
      if pgStmtSrc.Fetch then
      while not pgStmtSrc.Eof do
        begin
          if FTerminate then break;
          for j := 0 to ParamCnt-1 do
            begin
              buf := nil;
              len := 0;
              pgStmtSrc.Fields[J+UseGibridRowID].GetData(buf, len, true);
              pgStmtDst.Params[J].SetData(buf, len, true);
            end;
          idRaw := 0;
          LenID := 0;
          Inc(Counter);
          Inc(RowCommit);
          pgStmtSrc.Fields[RowIDIndexField].GetData(@idRaw, LenID);
          id := 0;
          MoveRotate(@idRaw, @id, LenID);
          table.last_row_id := id;
          if FTerminate then break;
          pgStmtDst.Execute;
          Inc(RowAffected, pgStmtDst.RowsAffected);
          Progress(RowAffected, Count, InfoProgress, false, false);
          if RowCommit = DST_ROWSET_COMMIT then
            begin
              RowCommit := 0;
              SaveQuerySlaveInfo(table);
              pgConDst.ExecuteQuery('COMMIT');
              {$ifdef PRINT_TIMER_TRANSACTION}
                t.Stop;
                LogI('Commit: %d, %.3f ms, %f/rps, %f s',
                  [Counter, t.Elapsed.Ticks / t.Elapsed.TicksPerMillisecond, Counter / total.Elapsed.Ticks * total.Elapsed.TicksPerSecond, total.Elapsed.Ticks / total.Elapsed.TicksPerSecond]);
              {$endif}
              pgConDst.ExecuteQuery('BEGIN');
              {$ifdef PRINT_TIMER_TRANSACTION}
                t.Reset;
                t.Start;
              {$endif}
            end;

          if not pgStmtSrc.Fetch and not FTerminate then
            begin
                pgStmtSrc.Close;
                pgStmtSrc.Unprepare;
              {$ifdef PRINT_TIMER_TRANSACTION}
                t.Stop;
                t.Reset;
                t.Start;
              {$endif}
                pgStmtSrc.PrepareSQL(Format(sql_select, [table.last_row_id, SRC_ROWSET_RANGE]));
                pgStmtSrc.Execute;
                pgStmtSrc.DescribeFields;
                for I := 0 to pgStmtSrc.Fields.Count-1 do
                  pgStmtSrc.Fields[i].TypeOid := SQL_ANY;
                if not pgStmtSrc.Fetch then break;

              {$ifdef PRINT_TIMER_TRANSACTION}
                t.Stop;
                LogI('OPEN ROWSET/LIMIT %d/%d = %s', [pgStmtSrc.RowsetSize, SRC_ROWSET_RANGE, t.Elapsed.ToString]);
                t.Reset;
                t.Start;
              {$endif}
            end;
        end;
      table.Downloaded := not FTerminate;
    {$ifdef PRINT_TIMER_TRANSACTION}
      t.Stop;
      total.stop;
    {$endif}
      FDestCon.ExecSQL('ALTER TABLE '+EncodeSQLTableName(table)+' ENABLE TRIGGER ALL');
      // when an exception occurs, always trying to commit an already received data.
      SaveQuerySlaveInfo(table);
      CommitTransaction;//pgConDst.ExecuteQuery('COMMIT');
      Progress(Counter, Count, InfoProgress, false, false);
    except
      RollbackTransaction; //pgConDst.ExecuteQuery('ROLLBACK');
      raise;
    end;
  finally
    pgStmtDst.Free;
    pgStmtSrc.Free;
    pgConSrc.ExecuteQuery('COMMIT');
    Progress(0, 0, '', true);
    LogI('table: %s full: %s downloaded: %d', [table.Name, BoolToStr(table.Downloaded, true), RowAffected]);
  end;

end;

function TDBReplicationEx.ExecuteDownloadData(
  table: TSlaveTableNode): Integer;
const
  SRC_ROWSET_RANGE  = 500000;      //<<  диапазон выборки строк из мастера
  SRC_ROWSET_SIZE   = 1000;        //<<  диапазон выборки строк из мастера
  DST_ROWSET_SIZE   = 200;        //<<  размер массива параметров для вызова одной операции Write
  DST_ROWSET_COMMIT = 1000;       //<<  кол-во записей, по достижение которого проиходит Commit

var
  pgConSrc, pgConDst: TPgConnection;
  pgStmtSrc, pgStmtDst: TPgStatement;
  I, J, Count, Counter, RowCommit, ParamCnt, Size: Integer;
  UseGibridRowID: Integer;
  RowIDIndexField: Integer;
  InfoProgress, CheckFieldName: string;
  Buf: Pointer;
  Len, LenID: LongWord;
  id, idRaw: int64;
  sql_insert, sql_select: string;
  oids: array of OID;
  IsTableFixup: Boolean;
  {$ifdef PRINT_TIMER_TRANSACTION}
  t, total: TStopwatch;
  {$endif}

    procedure MoveRotate(ASrc, ADest: Pointer; ALen: Cardinal);
    var
      pSrc, pDest: PByte;
    begin
      pSrc := ASrc;
      pDest := PByte(ADest) + ALen - 1;
      while ALen > 0 do begin
        pDest^ := pSrc^;
        Inc(pSrc);
        Dec(pDest);
        Dec(ALen);
      end;
    end;

  function GetCountEx(const sql: string): Integer;
  var
    s, w, o: string;
    I: Integer;
  begin
    Result := 0;
    if ((table.Master.PrimaryCount = 1) and
        (table.Master.PrimaryKey[0].FieldType in [ftInteger, ftLargeint, ftLongWord, ftSmallint, ftWord])) or
        table.FixUP then
      begin
        if table.FixUP then
          o := table.FixUPField else
          o := NormalizeName(table.Master.PrimaryKey[0].FieldName);
        if table.last_row_id > 0 then
          w := ' WHERE ' + o +'>' + table.FixUPOperator + IntToStr(table.last_row_id) +';' else
          w := ';';
        s := 'SELECT Count(*) FROM '+ EncodeSQLTableName(table) + w; //sql
      end
    else
      begin
        for  I := 0 to table.Master.PrimaryCount-1 do
          if i = 0 then
            o := NormalizeName(table.Master.PrimaryKey[i].FieldName) else
            o := o + ', ' + NormalizeName(table.Master.PrimaryKey[i].FieldName);
        if table.last_row_id  > 0 then
          w := ' WHERE row_id '+'>'+IntToStr(table.last_row_id) + ';' else
          w := ';';
        s := Copy(sql, Pos(' ', sql) + 1, Length(sql));
        s := 'SELECT Count(*) FROM ( '+sLineBreak +
             ' 	SELECT ROW_NUMBER() OVER(ORDER BY '+o+') AS row_id, '+ s + sLineBreak +
             ') AS data '+w;
      end;
    pgStmtSrc.ExecuteDirect(s);
    pgStmtSrc.DescribeFields;
    if pgStmtSrc.Fetch then
      pgStmtSrc.Fields[0].GetData(@Result, Len);
    pgStmtSrc.Close;
    //Result := FSourceCon.ExecSQLScalar(s);

  end;

  function GetSQLSelectSyncEx(const sql: string): string;
  var
    s, o, w: string;
    I: Integer;
  begin
    o := '';
    s := '';
    w := '';
    UseGibridRowID := 1;
    if ((table.Master.PrimaryCount = 1) and
        (table.Master.PrimaryKey[0].FieldType in [ftInteger, ftLargeint, ftLongWord, ftSmallint, ftWord])) or
        table.FixUP then
      begin
        if table.FixUP then
          o := table.FixUPField else
          o := NormalizeName(table.Master.PrimaryKey[0].FieldName);
        if table.last_row_id > 0 then
          w := ' WHERE ' + o +' >' + table.FixUPOperator + IntToStr(table.last_row_id);
        Result := sql + w + ' ORDER BY ' + o + ' ASC';
        UseGibridRowID := 0;
        exit;
      end;

    for I := 0 to table.Master.PrimaryCount-1 do
      if i = 0 then
        o := NormalizeName(table.Master.PrimaryKey[i].FieldName) else
        o := o + ', ' + NormalizeName(table.Master.PrimaryKey[i].FieldName);

    if table.last_row_id > 0 then
      w := ' WHERE row_id > '+IntToStr(table.last_row_id);

    s := Copy(sql, Pos(' ', sql) + 1, Length(sql));
    Result := 'SELECT * FROM ( '+sLineBreak +
         ' 	SELECT ROW_NUMBER() OVER(ORDER BY '+o+') AS row_id, '+ s + sLineBreak +
         ') AS data '+ w + ' ORDER BY 1';

  end;

  function SQLInsertBatch(const sql: string; rowset_size: Integer): string;
  var
    i, j, pcount: Integer;
    p, pi: PChar;
    si: string;
  begin
      if rowset_size = 1 then
        begin
          Result := sql;
          exit;
        end;
      SetLength(Result, rowset_size * 10 * table.FieldCount);
      p := Pointer(Result);
      pcount := 0;
      for I := 1 to rowset_size-1 do
        begin
          P^ := '('; Inc(P); Inc(pcount);
          for j := 1 to table.FieldCount do
            begin
              si := IntToStr(i * table.FieldCount + j);
              pi := Pointer(si);
              P^ := '$'; Inc(P);
              Inc(pcount);
              while pi^ <> #0 do
                begin
                  p^ := pi^; Inc(p); Inc(pi); Inc(pcount);
                end;
              P^ := ','; Inc(P); P^ := ' '; Inc(P); Inc(pcount, 2);
            end;
          (P-2)^ := ')';  (P-1)^ := ',';  P^ := ' '; Inc(P); Inc(pcount);
        end;
      Dec(pcount, 2);
      SetLength(Result, pcount);
      if table.FixUP then
        Result := Result + ' ON CONFLICT DO NOTHING;';
      Result := sql + ', '+Result;
  end;

begin
  Result := 0;

  // Проверка родительских таблиц
  for I := 0 to table.ParentCount-1 do
    if table.ForeignTables[i] <> table then
      ExecuteDownloadData(table.ForeignTables[i]);

  if table.Downloaded or FTerminate then exit;

  //  Обновление типов полей
  if not table.FieldDefsUpdated then
    UpdateTableFieldDefs(table);

  if table.Table = 'objectblob' then
    begin
      ExecuteDownLoadBlobTableNative(table, Result);
      exit;
    end;
  if ExecuteDownLoadBigTable(table, Result) then exit;


  pgConSrc := TPgConnection(FSourceCon.ConnectionIntf.CliObj);
  pgConDst := TPgConnection(FDestCon.ConnectionIntf.CliObj);
  pgStmtDst := TPgStatement.Create(pgConDst, Self);
  pgStmtSrc := TPgStatement.Create(pgConSrc, Self);

  try
    pgConSrc.ExecuteQuery('BEGIN ISOLATION LEVEL REPEATABLE READ');
    pgStmtSrc.RowsetSize := SRC_ROWSET_SIZE;
    Count := GetCountEx(GetSQLSelectByFieldsNative(table, []));
    if Count = 0 then
      begin
        Progress(0, 0, '', true);
        table.Downloaded := true;
        StartTransaction;
        SaveQuerySlaveInfo(table);
        CommitTransaction;
        exit;
      end;
    {$ifdef PRINT_TIMER_TRANSACTION}
      t := TStopwatch.StartNew;
    {$endif}
    sql_select := GetSQLSelectSyncEx(GetSQLSelectByFieldsNative(table, []));
    pgStmtSrc.PrepareSQL(sql_select);
    pgStmtSrc.Execute;
    {$ifdef PRINT_TIMER_TRANSACTION}
      t.Stop;
    {$endif}
    pgStmtSrc.DescribeFields;

    if table.last_modified = 0 then
      table.last_modified := TTimeZone.Local.ToUniversalTime(Now);

    LogI('table: %s start downloading. Last Row ID = %d', [table.Name, table.last_row_id]);
    {$ifdef PRINT_TIMER_TRANSACTION}
      LogI('OPEN ROWSET/LIMIT %d/%d = %s', [SRC_ROWSET_SIZE, SRC_ROWSET_RANGE, t.Elapsed.ToString]);
      LogI('INSERT ROWSET/COMMIT %d/%d', [DST_ROWSET_SIZE, DST_ROWSET_COMMIT]);
    {$endif}

    InfoProgress := table.Name;
    Progress(0, Count, InfoProgress, false);
    ParamCnt := pgStmtSrc.Fields.Count - UseGibridRowID;
    if Count < DST_ROWSET_SIZE  then
      Size := Count else
      Size := DST_ROWSET_SIZE;
    pgStmtDst.Params.Count :=  ParamCnt * Size;


    for I := 0 to Size-1 do
      begin
        for j := 0 to ParamCnt-1 do
          begin
            pgStmtDst.Params[i * ParamCnt + J].TypeOid   := pgStmtSrc.Fields[J+UseGibridRowID].TypeOid;
            pgStmtDst.Params[i * ParamCnt + J].DumpLabel := pgStmtSrc.Fields[J+UseGibridRowID].Name;
          end;
      end;

    try
      StartTransaction;// pgConDst.ExecuteQuery('BEGIN');
      pgConDst.ExecuteQuery('ALTER TABLE '+EncodeSQLTableName(table)+' DISABLE TRIGGER ALL');
      sql_insert := SQLInsertBatch(GetSQLInsertByFieldsNative(table), Size);
      pgStmtDst.PrepareSQL(sql_insert);

      Counter   := 0;
      RowCommit := 0;
      Size      := Count;
      RowIDIndexField := -1;
      if table.FixUP then
        CheckFieldName := table.FixUPField else
        CheckFieldName := table.Master.PrimaryKey[0].FieldName;

      SetLength(oids, pgStmtSrc.Fields.Count);
      for I := 0 to pgStmtSrc.Fields.Count-1 do
        begin
          oids[i] := pgStmtSrc.Fields[i].TypeOid;
          pgStmtSrc.Fields[i].TypeOid := SQL_ANY;
          if (UseGibridRowID = 0) and (RowIDIndexField = -1) then
            if pgStmtSrc.Fields[i].Name = CheckFieldName then
              RowIDIndexField := I;
        end;
      if RowIDIndexField = -1 then
        RowIDIndexField := 0;
      for I := 0 to pgStmtDst.Params.Count-1 do
        pgStmtDst.Params[i].TypeOid := SQL_ANY;
      {$ifdef PRINT_TIMER_TRANSACTION}
        t.Reset;
        t.Start;
        total := TStopwatch.StartNew;
      {$endif}
      if pgStmtSrc.Fetch then
      while not pgStmtSrc.Eof do
        begin
          if FTerminate then break;
          for I := 0 to DST_ROWSET_SIZE-1 do
            begin
              if FTerminate then break;
              for j := 0 to ParamCnt-1 do
                begin
                  buf := nil;
                  len := 0;
                  pgStmtSrc.Fields[J+UseGibridRowID].GetData(buf, len, true);
                  pgStmtDst.Params[i * ParamCnt + J].SetData(buf, len, false);
                end;
              idRaw := 0;
              LenID := 0;
              pgStmtSrc.Fields[RowIDIndexField].GetData(@idRaw, LenID);
              Inc(Counter);
              Inc(RowCommit);
              Dec(Size);
              if not pgStmtSrc.Fetch then break;
            end;
          id := 0;
          MoveRotate(@idRaw, @id, LenID);
          table.last_row_id := id;
          if FTerminate then break;
          pgStmtDst.Execute;
          Inc(Result, pgStmtDst.RowsAffected);
          Progress(Result, Count, InfoProgress, false, false);
          if RowCommit = DST_ROWSET_COMMIT then
            begin
              RowCommit := 0;
              SaveQuerySlaveInfo(table);
              pgConDst.ExecuteQuery('COMMIT');
              {$ifdef PRINT_TIMER_TRANSACTION}
                t.Stop;
                LogI('Commit: %d, %.3f ms, %f/rps, %f s',
                  [Counter, t.Elapsed.Ticks / t.Elapsed.TicksPerMillisecond, Counter / total.Elapsed.Ticks * total.Elapsed.TicksPerSecond, total.Elapsed.Ticks / total.Elapsed.TicksPerSecond]);
              {$endif}
              pgConDst.ExecuteQuery('BEGIN');
              {$ifdef PRINT_TIMER_TRANSACTION}
                t.Reset;
                t.Start;
              {$endif}
            end;
          if not FTerminate and (Size < DST_ROWSET_SIZE) and not pgStmtSrc.Eof then
            begin
              pgStmtDst.Close;
              pgStmtDst.Unprepare;
              pgStmtDst.Params.Count := ParamCnt * Size;
              for I := 0 to Size-1 do
                for j := 0 to ParamCnt-1 do
                    pgStmtDst.Params[i * ParamCnt + J].TypeOid   := oids[J+UseGibridRowID];
              sql_insert := SQLInsertBatch(GetSQLInsertByFieldsNative(table), Size);
              pgStmtDst.PrepareSQL(sql_insert);
              for I := 0 to pgStmtDst.Params.Count-1 do
                pgStmtDst.Params[i].TypeOid := SQL_ANY;
            end;
        end;
      table.Downloaded := not FTerminate;
    {$ifdef PRINT_TIMER_TRANSACTION}
      t.Stop;
      total.stop;
    {$endif}
      FDestCon.ExecSQL('ALTER TABLE '+EncodeSQLTableName(table)+' ENABLE TRIGGER ALL');
      SaveQuerySlaveInfo(table);
      CommitTransaction;//pgConDst.ExecuteQuery('COMMIT');

      Progress(Counter, Count, InfoProgress, false, false);
    except
      RollbackTransaction; //pgConDst.ExecuteQuery('ROLLBACK');
      raise;
    end;
  finally
    pgStmtDst.Free;
    pgStmtSrc.Free;
    pgConSrc.ExecuteQuery('COMMIT');
    Progress(0, 0, '', true);
    LogI('table: %s full: %s downloaded: %d', [table.Name, BoolToStr(table.Downloaded, true), Result]);
  end;

end;

function TDBReplicationEx.GetChangedData(var Params: TChangedDataParams;
  var Data: TListTDataChangedInfo): Boolean;
  function _splitData(const s: string): TArrayOfString;
  var
    i: Integer;
  begin
    SetLength(Result, 0);
    if Length(s) = 0 then exit;
    if s[1] = '{' then
      Result := Copy(s, 2, Length(s)-2).split([',']) else
      begin
        SetLength(Result, 1);
        Result[0] := s;
      end;
    for I := 0 to Length(Result)-1 do
      Result[i] := Trim(Result[i]);
  end;

  function _getOperation(const s: string): TDMLOperation;
  begin
    if SameText(s, 'INSERT') then
      Result := dmlInsert
    else if SameText(s, 'UPDATE') then
      Result := dmlUpdate
    else if SameText(s, 'DELETE') then
      Result := dmlDelete
    else
      Result := dmlUnknown
  end;
var
  i, id, cnt: integer;
  dcis: array of TDataChangedInfo absolute Data;
begin
  Result := false;
  if FTerminate then exit;

  if not FQueryData.Active then
    begin
      if (Params.count > 0) and (Params.index = Params.count) then exit; //<< чтобы не зацикливать. Забираем только по уведомлениям.
      if Length(Params.txids) = 0 then
        begin
        	FQueryData.SQL.Text  := 'select Count(*) as cnt, transaction_id, min(id) as min_id FROM _replica.table_update_data'+sLineBreak+
                                  '	where (id > :id) AND (last_modified > :last_modified)  GROUP BY transaction_id order by min_id ASC';
          FQueryData.Params[0].AsInteger  := Params.last_id;
          FQueryData.Params[1].AsDateTime := IncSecond(Params.last_modified, -1);
          FQueryData.Open();
          if FQueryData.IsEmpty then
            begin
              FQueryData.Close;
              exit;
            end;
          SetLength(Params.txids, FQueryData.RecordCount);
          SetLength(Params.rows, FQueryData.RecordCount);
          Params.count := FQueryData.RecordCount;
          Params.index := 0;
          i := 0;
          while not FQueryData.Eof do
            begin
              Params.txids[i] := FQueryData.FieldByName('transaction_id').AsLargeInt;
              Params.rows[i]  := FQueryData.FieldByName('cnt').AsInteger;
              Params.total_rows  := Params.total_rows + Params.rows[i];
              FQueryData.Next;
              Inc(i);
            end;
          FQueryData.Close;
          FQueryData.SQL.Text := 'SELECT * FROM _replica.table_update_data WHERE '+
                               '(id > :id) AND (transaction_id = :transaction_id) ORDER BY id ASC;';
        end;
      Params.cur_txid := Params.txids[Params.index];
      Params.cur_rows := Params.rows[Params.index];
      Inc(Params.index);
      FQueryData.Params[0].AsInteger  := Params.last_id;
      FQueryData.Params[1].AsLargeInt := Params.cur_txid;

      FQueryData.Open();
      if FQueryData.IsEmpty then
        begin
          FQueryData.Close;
          Result := GetChangedData(Params, Data);
          exit;
        end;

      SetLength(FChangedDataFields, 10);
      FChangedDataFields[0] := FQueryData.FieldByName('id');
      FChangedDataFields[1] := FQueryData.FieldByName('pk_keys');
      FChangedDataFields[2] := FQueryData.FieldByName('pk_values');
      FChangedDataFields[3] := FQueryData.FieldByName('upd_cols');
      FChangedDataFields[4] := FQueryData.FieldByName('operation');
      FChangedDataFields[5] := FQueryData.FieldByName('table_name');
      FChangedDataFields[6] := FQueryData.FieldByName('schema_name');
      FChangedDataFields[7] := FQueryData.FieldByName('last_modified');
      FChangedDataFields[8] := FQueryData.FieldByName('transaction_id');
      FChangedDataFields[9] := FQueryData.FieldByName('user_name');
    end;

  //i := FQueryData.GetNextPacket;
  cnt := FQueryData.RecordCount;
  if cnt = 0 then
    begin
      FQueryData.Close;
      Result := GetChangedData(Params, Data);
      exit;
    end;

  SetLength(dcis, cnt);
  //while not FQueryData.Eof do
  for I := 0 to cnt-1 do
    begin
      if FTerminate then break;
      id := FChangedDataFields[0].AsInteger;
      if id > FLastChangedID then
        begin
          dcis[i].id := id;
          dcis[i].key_names      := _splitData(FChangedDataFields[1].AsString);
          dcis[i].key_values     := _splitData(FChangedDataFields[2].AsString);
          dcis[i].changed_fields := _splitData(FChangedDataFields[3].AsString);
          dcis[i].operation      := _getOperation(FChangedDataFields[4].AsString);
          dcis[i].table_name     := FChangedDataFields[5].AsString;
          dcis[i].schema_name    := FChangedDataFields[6].AsString;
          dcis[i].last_modified  := FChangedDataFields[7].AsDateTime;
          dcis[i].transaction_id := FChangedDataFields[8].AsLargeInt;
          dcis[i].user_name      := FChangedDataFields[9].AsString;
          dcis[i].root := true;
//          Inc(i);
        end
      else
        asm
          // повторяющиеся записи. Принять меры.
          int 3;
        end;
      FQueryData.Next;
      if i = cnt then break;
    end;
  if FQueryData.Eof or FTerminate then
    FQueryData.Close;
  Result := not FTerminate;

end;

function TDBReplicationEx.GetChangedDDL(var Data: TListChangedDLL; last_modified: TDateTime): Boolean;
var
  i: integer;
  dcis: array of TDataChangedDDL absolute Data;
  query: TFDQuery;
begin
  query := TFDQuery.Create(nil);
  try
    query.Connection := FSourceCon;
    query.SQL.Text   := 'SELECT * FROM _replica.table_ddl WHERE last_modified > '+EncodeTimeSQLParam(last_modified);
    query.Open();
    Result :=  not query.IsEmpty;
    if not Result  then exit;
    SetLength(dcis, query.RecordCount);
    for i := 0 to Length(dcis)-1 do
      begin
        dcis[i].query      := query.FieldByName('query').AsString;
        dcis[i].last_modified  := query.FieldByName('last_modified').AsDateTime;
        query.Next;
      end;
    query.Close;
  finally
  query.Free
  end;
end;

function TDBReplicationEx.CreateMapQuery(RequestType: TTypeRuquest): TFDQuery;
var
  c: TFDCustomConnection ;
begin
  Result := nil;
  case RequestType of
    reqSI, reqSU:  c := FSourceCon;
    reqU,
    reqI,
    reqD:  c := FDestCon;
  else
    exit;
  end;
  Result := TFDQuery.Create(nil);
  Result.Connection := c;
end;

function TDBReplicationEx.GetSQLDelete(table: TSlaveTableNode): string;
var
  i: Integer;
begin
  Result := 'DELETE FROM '+EncodeSQLTableName(table)+ ' WHERE ';
  for I := 0 to table.PrimaryCount-1 do
    if i = 0 then
      Result := Result + table.PrimaryKey[i].FieldName +' = :' + table.PrimaryKey[i].FieldName else
      Result := Result + ' AND '+table.PrimaryKey[i].FieldName +' = :' + table.PrimaryKey[i].FieldName;
end;

function TDBReplicationEx.GetSQLInsertByFields(table: TSlaveTableNode): string;
var
  I: Integer;
  s, si: string;
begin
  s := '';
  si := '';
  with table do
    for I := 0 to FieldCount-1 do
      begin
      if i = 0  then
        s := Fields[i].FieldName else
        s := s + ', ' +Fields[i].FieldName ;
      if i = 0  then
        si := ':'+Fields[i].FieldName + GetPGClassFieldInto(Fields[i]) else
        si := si + ', :' +Fields[i].FieldName + GetPGClassFieldInto(Fields[i]) ;

      end;
  Result := Format('INSERT INTO %s (%s) VALUES (%s);', [EncodeSQLTableName(table), s, si]);
end;

function TDBReplicationEx.GetSQLInsertByFieldsNative(
  table: TSlaveTableNode): string;
var
  I: Integer;
  s, si: string;
begin
  s := '';
  si := '';
  with table do
    for I := 0 to FieldCount-1 do
      begin
      if i = 0  then
        s := Fields[i].FieldName else
        s := s + ', ' +Fields[i].FieldName ;
      if i = 0  then
        si := '$1' else
        si := si + ', $' +(i+1).ToString ;

      end;
  Result := Format('INSERT INTO %s (%s) VALUES (%s)', [EncodeSQLTableName(table), s, si]);

end;

function TDBReplicationEx.GetSQLSelectByFields(table: TSlaveTableNode;
  const explicit: TArrayOfString; BuildWhere: Boolean): string;
var
  s: string;
  i: Integer;
  a: TArrayOfString;

  function _GetField(const FieldName: string): string;
  var
    p: PFieldInfo;
  begin
    Result := '';
    p := table.Master.FieldByName(FieldName);
    if P <> nil then
      Result := p.FieldName + table.Master.GetPGClassFieldFrom(p);
  end;
begin
  Result := '';
  if Length(explicit) > 0 then
    a := explicit
  else
    a := table.Master.FieldList.Split([',']);
  s := '';
    for I := 0 to Length(a) -1 do
      if s = ''  then
        s := _GetField(trim(a[i])) else
        s := s + ', ' + _GetField(trim(a[i]));
  if s = '' then
    s := '*';
  Result := 'SELECT ' + S + ' FROM ' + EncodeSQLTableName(table);
  if BuildWhere then
    begin
      s := '';
      for I := 0 to table.Master.PrimaryCount -1 do
      if s = ''  then
        s := table.Master.PrimaryKey[i].FieldName + '=:'+ table.Master.PrimaryKey[i].FieldName else
        s := s + ' AND ' + table.Master.PrimaryKey[i].FieldName + '=:'+ table.Master.PrimaryKey[i].FieldName;
      Result := Result + ' WHERE '+ s;
    end;
end;


function TDBReplicationEx.GetSQLSelectByFieldsNative(table: TSlaveTableNode;
  const explicit: TArrayOfString; BuildWhere: Boolean): string;
var
  s: string;
  i: Integer;
  a: TArrayOfString;

  function _GetField(const FieldName: string): string;
  var
    p: PFieldInfo;
  begin
    Result := '';
    p := table.Master.FieldByName(FieldName);
    if P <> nil then
      Result := p.FieldName;// + table.Master.GetPGClassFieldFrom(p);
  end;
begin
  Result := '';
  if Length(explicit) > 0 then
    a := explicit
  else
    a := table.Master.FieldList.Split([',']);
  s := '';
    for I := 0 to Length(a) -1 do
      if s = ''  then
        s := _GetField(trim(a[i])) else
        s := s + ', ' + _GetField(trim(a[i]));
  if s = '' then
    s := '*';
  Result := 'SELECT ' + S + ' FROM ' + EncodeSQLTableName(table);
  if BuildWhere then
    begin
      s := '';
      for I := 0 to table.Master.PrimaryCount -1 do
      if s = ''  then
        s := table.Master.PrimaryKey[i].FieldName + '=$1' else
        s := s + ' AND ' + table.Master.PrimaryKey[i].FieldName + '=$'+ (i+1).ToString;
      Result := Result + ' WHERE '+ s;
    end;

end;

function TDBReplicationEx.GetSQLUpdateByFields(table: TSlaveTableNode;
  const explicit: TArrayOfString): string;

var
  I: Integer;
  s, keys: string;

  procedure _GetField(const FieldName: string);
  var
    k: Integer;
  begin
    with table do
      for k := 0 to FieldCount-1 do
        if (FieldName = '') or SameText(FieldName, fields[k].FieldName) then
        begin
          if s = ''  then
            s := Fields[k].FieldName + '=:'+Fields[k].FieldName + GetPGClassFieldInto(Fields[k]) else
            s := s + ', ' +Fields[k].FieldName  + '=:'+Fields[k].FieldName + GetPGClassFieldInto(Fields[k]);
          if FieldName <> '' then
            break;
        end;
  end;
begin
  keys := '';
  s := '';
  if Length(explicit) = 0 then
    _GetField('') else
  for I := 0 to Length(explicit)-1 do
    _GetField(explicit[i]);

  with table do
  for I := 0 to PrimaryCount-1 do
    if keys = ''  then
      keys := PrimaryKey[i].FieldName + '=:'+PrimaryKey[i].FieldName + GetPGClassFieldInto(PrimaryKey[i]) else
        keys := keys + ' AND ' +PrimaryKey[i].FieldName  + '=:'+PrimaryKey[i].FieldName + GetPGClassFieldInto(PrimaryKey[i]);

  Result := Format('UPDATE %s SET %s WHERE %s;', [EncodeSQLTableName(table), s, keys]);
end;

function TDBReplicationEx.NormalizeName(const Name: string): string;
var
  Cat, Sch, BObj, Obj: String;
begin
  FSourceCon.DecodeObjectName(Name, Cat, Sch, BObj, Obj);
  Result := FSourceCon.EncodeObjectName(Cat, Sch, BObj, Obj);
end;

procedure TDBReplicationEx.ResetTableList;
begin
  FClientID := '';
  FTables.Free;
  FTables := nil;
  FLastIDCommand := nil;
  FSaveTableInfo := nil;
end;

procedure TDBReplicationEx.RestoreSequenses;
resourcestring
  SQL_GET_SEQS =
' SELECT ''SELECT SETVAL('' ||'+
'     quote_literal(quote_ident(PGT.schemaname) || ''.'' || quote_ident(S.relname)) ||'+
'     '', COALESCE(MAX('' ||quote_ident(C.attname)|| ''), 1) ) FROM '' ||'+
'     quote_ident(PGT.schemaname)|| ''.''||quote_ident(T.relname)|| '';'''+
' FROM pg_class AS S,'+
'     pg_depend AS D,'+
'     pg_class AS T,'+
'     pg_attribute AS C,'+
'     pg_tables AS PGT'+
' WHERE S.relkind = ''S'''+
'     AND S.oid = D.objid'+
'     AND D.refobjid = T.oid'+
'     AND D.refobjid = C.attrelid'+
'     AND D.refobjsubid = C.attnum'+
'     AND T.relname = PGT.tablename'+
' ORDER BY S.relname;';

var
  pgStmtDst: TPgStatement;
  pgConDst: TPgConnection;
  list: TStringList;
  i: Integer;
begin
  pgConDst := TPgConnection(FDestCon.ConnectionIntf.CliObj);
  pgStmtDst := TPgStatement.Create(pgConDst, Self);
  try
    StartTransaction;// pgConDst.ExecuteQuery('BEGIN');
    pgStmtDst.ExecuteDirect(SQL_GET_SEQS);
    pgStmtDst.DescribeFields;
    list := TStringList.Create;
    try
      while pgStmtDst.Fetch do
        list.Add(pgStmtDst.Fields[0].GetAsString);
      for I := 0 to list.Count-1 do
        pgStmtDst.ExecuteDirect(list[i]);
    finally
      list.Free;
    end;
  finally
    CommitTransaction;// pgConDst.ExecuteQuery('COMMIT');
    pgStmtDst.Free;
  end;
end;

procedure TDBReplicationEx.SaveLastID(last_id: Integer);
begin
  FLastIDCommand.Params[0].AsString := IntToStr(last_id);
  FLastIDCommand.Execute();
end;

procedure TDBReplicationEx.SaveQuerySlaveInfo(table: TSlaveTableNode);
begin
  FSaveTableInfo.Params[0].AsDateTime  := table.last_modified;
  FSaveTableInfo.Params[1].AsBoolean   := table.Downloaded;
  FSaveTableInfo.Params[2].AsLargeInt  := table.last_row_id;
  FSaveTableInfo.Params[3].AsInteger   := table.Id;
  FSaveTableInfo.Execute();
  table.ResetStateChanges;
end;

procedure TDBReplicationEx.SetDestCon(const Value: TFDCustomConnection);
begin
  if FDestCon <> Value then
    begin
      FDestCon := Value;
      ResetTableList;
    end;
end;

procedure TDBReplicationEx.SetSourceCon(const Value: TFDCustomConnection);
begin
  if FSourceCon <> Value then
    begin
      FSourceCon := Value;
      FQueryData.Connection := Value;
    end;
end;

procedure TDBReplicationEx.Terminate;
begin
  FTerminate := true;
  MemoryBarrier;
end;

procedure TDBReplicationEx.UpdateRelationShip;
var
  i: Integer;
  query: TFDQuery;
  o, c: array of string;
  fo1, fc1, fo2, fc2: TField;
begin
  if Tables.RelationShipUpdated then exit;

  query := TFDQuery.Create(nil);
  try
    query.Connection := FDestCon;
    query.FetchOptions.Mode := fmAll;
    query.SQL.LoadFromFile('..\scripts\getRelationShip.sql');
    query.Open();

    SetLength(o, query.RecordCount);
    SetLength(c, query.RecordCount);
    fo1 := query.FieldByName('table_schema');
    fo2 := query.FieldByName('table_name');
    fc1 := query.FieldByName('foreign_table_schema');
    fc2 := query.FieldByName('foreign_table_name');
    for I := 0 to Length(o)-1 do
      begin
        c[i] := fo1.AsString + '.' + fo2.AsString;
        o[i] := fc1.AsString + '.' + fc2.AsString;
        query.Next;
      end;
    FTables.BuildRelationShip(o, c);

    query.Close;
  finally
    query.Free;
  end;
end;

procedure TDBReplicationEx.UpdateTableFieldDefs(table: TSlaveTableNode);
var
  list: TSTringList;
  s: string;
  query: TFDQuery;
begin
  if table.FieldDefsUpdated then exit;

  query := TFDQuery.Create(nil);
  try
    query.Connection := FDestCon;
    list := TStringList.Create;
    try
      StartTransaction ;
      // primary keys
      FDestCon.GetKeyFieldNames('', table.Schema, table.Table, '', list);
      list.Delimiter := ',';
      s := list.DelimitedText;
      query.SQL.Text := 'SELECT '+s+' FROM ' + EncodeSQLTableName(table);
      query.FieldDefs.Updated := false;
      query.FieldDefs.Update;
      table.UpdatePrimaryKeys(query.FieldDefs);
      table.Master.UpdatePrimaryKeys(query.FieldDefs);
      s :=  table.FieldList;
      query.SQL.Text := 'SELECT '+s+' FROM ' + EncodeSQLTableName(table);
      query.FieldDefs.Updated := false;
      query.FieldDefs.Update;
      table.UpdateFields(query.FieldDefs);
      table.Master.UpdateFields(query.FieldDefs);
      table.FieldDefsUpdated := true;
      if FixupPKTable(s, table) then
        table.FixUPField := s;
    finally
      CommitTransaction;
      list.Free;
    end;
  finally
    query.free;
  end;

end;

procedure TDBReplicationEx.UpdateTableList;
var
  query: TFDQuery;
  t: TSlaveTableNode;
  fields: array [0..10] of TField;
  fID: TField;
begin
  if FDestCon = nil then exit;

  if Assigned(FTables) then
    FTables.Clear else
    FTables := TRelationNodeList.Create(0);
  FLastModified := 0;
  FFullDownLoaded := true;
  query := TFDQuery.Create(nil);
  try
    query.Connection := FDestCon;
    query.SQL.Text := 'SELECT * FROM _replica.table_slave';
    query.Open();
    query.FetchAll;
    FTables.Capacity := query.RecordCount;
    fields[0]  := query.FieldByName('master_schema');
    fields[1]  := query.FieldByName('master_table');
    fields[2]  := query.FieldByName('slave_schema');
    fields[3]  := query.FieldByName('slave_table');
    fields[4]  := query.FieldByName('downloaded');
    fields[5]  := query.FieldByName('last_modified');
    fields[6]  := query.FieldByName('last_row_id');
    fields[7]  := query.FieldByName('master_fields');
    fields[8]  := query.FieldByName('slave_fields');


    fID     := query.FieldByName('id');
    while not query.Eof do
      begin
        if FTerminate then exit;
        t := FTables.CreateNode(fields[0].AsString, fields[1].AsString, fields[2].AsString, fields[3].AsString);
        t.id            := fID.AsInteger;
        t.last_modified := fields[5].AsDateTime;
        t.downloaded    := fields[4].AsBoolean;
        t.last_row_id   := fields[6].AsLargeInt;
        t.CreateMapQueryFunc := CreateMapQuery;
{ TODO 1 -cMappingFields :
На будующее заготовка для от
В будующем заготовка для многие ко многим. Сейчас
репликация работает таблица в таблицу. Опеределить маппинг полей ношения многие ко многим. Сейчас
репликация работает таблица в таблицу. При добавлении онтношений. Опеределить маппинг полей.
}
        t.FieldList     := fields[8].AsString;
        t.Master.FieldList := fields[7].AsString;
        if t.last_modified > FLastModified then
          FLastModified := t.last_modified;
        FFullDownLoaded := FFullDownLoaded and t.downloaded;
        query.Next;
      end;
    query.Close;
  finally
    query.Free;
  end;

  PrepareUpdateDateLastID;
  PrepareSaveTableInfo;

end;



procedure TDBReplicationEx.PrepareSaveTableInfo;
resourcestring
  rsSQL_SaveTableInfo =
    'UPDATE _replica.table_slave SET last_modified=:lm, downloaded=:d, last_row_id=:last_id WHERE id=:id;';
begin
  FDestCon.ConnectionIntf.CreateCommand(FSaveTableInfo);
  FSaveTableInfo.CommandText := rsSQL_SaveTableInfo;
  FSaveTableInfo.Params[0].DataType  := ftDateTime;
  FSaveTableInfo.Params[1].DataType  := ftBoolean;
  FSaveTableInfo.Params[2].DataType  := ftLargeint;
  FSaveTableInfo.Params[3].DataType  := ftInteger;
  FSaveTableInfo.Prepare;

end;

procedure TDBReplicationEx.PrepareUpdateDateLastID;
var
  query: TFDQuery;
begin
  if not Assigned(FDestCon) or Assigned(FLastIDCommand) then exit;

  FDestCon.ConnectionIntf.CreateCommand(FLastIDCommand);
  query := TFDQuery.Create(nil);
  try
    query.Connection := FDestCon;
    query.SQL.Text := 'SELECT value, id FROM _replica.settings WHERE name=:name;';
    query.Params[0].AsString := 'last_update_data_id';
    query.Open();
    if query.IsEmpty then
    begin
      FDestCon.ExecSQL('INSERT INTO _replica.settings (name, value) VALUES(''last_update_data_id'', 0);');
      query.Close;
      query.Open();
    end;
    FLastIDCommand.CommandText := 'UPDATE _replica.settings SET value=:value WHERE id=:id;';
    FLastIDCommand.Params[0].DataType  := ftString;
    FLastIDCommand.Params[1].AsInteger := query.Fields[1].AsInteger;
    FLastIDCommand.Prepare;
    FLastChangedID := query.Fields[0].AsInteger;
    query.Close;
  finally
    query.free;
  end;
end;

function TDBReplicationEx.VisitClient: Boolean;
begin
  Result := true;
  if FProcessing then
    begin
      LogI('client_visit() = Busy itself. Try later.');
      FNeedVisit := true;
      exit;
    end;
  FNeedVisit := false;
  if FClientID = '' then
    FClientID := FDestCon.ExecSQLScalar('SELECT value FROM _replica.settings WHERE name=''client_id'';');
  if FLastChangedID  = 0 then
    PrepareUpdateDateLastID;
  Result := FSourceCon.ExecSQLScalar('select _replica.client_visit(:id, :name, :last_id);',
              [FClientID, 'TEST RDB', FLastChangedID], [ftLargeint, ftString, ftInteger]);
  LogI('client_visit() = '+BoolToStr(Result, true));
end;


{ TErrorList }

procedure TErrorList.Add(row, col: Integer; const Value: Variant);
begin
  if Length(list) = count then
    SetLength(list, (COUNT + 1) * 2, DIM);
  LIST[row, col] := Value;

end;

function TErrorList.AddRow: Integer;
begin
  Result := Count;
  if Length(list) = count then
    SetLength(list, (COUNT + 1) * 2, DIM);
  Inc(Count);

end;

procedure TErrorList.Reset(dimCount: Integer);
begin
  SetLength(list, 0);
  count := 0;
  dim := dimCount;
end;

end.
