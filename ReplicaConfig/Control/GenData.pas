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
* GenData.pas - unit for generation sql script                                 *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit GenData;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, RDBClass,
  RDBDataModule, ShaCrc64Unit;
const
  TABLE_SLAVE = '_replica.table_slave';
var
    Schemas: array [TMapKind] of  TMetaSchemaList;
    Maps: TMapMetaTableList;
  procedure RefreshStruct(Force: Boolean);
  procedure RemapStruct(AutoAlter: Boolean = true; tableKinds: TMetaTableKinds = [tkTable]);
  procedure GenerateSQLs(map: TMapMeta);
  function GetScriptStruct(Kind: TMapKind; AOnlyTableSlave: boolean = false): string;
  function GetTableSlaveScript: string;

  procedure InitData;
  procedure ReleaseData;
implementation

var
  Refreshed: boolean;
procedure RefreshStruct;
var
  i: Integer;
begin
  if not Force and Refreshed then exit;

  Maps.Clear;
  Schemas[mkMaster].Clear;
  Schemas[mkSlave].Clear;
  RDB.SwitchConnectionMaster(mkMaster);
  RDB.LoadShcema(Schemas[mkMaster]);
  RDB.SwitchConnectionMaster(mkSlave);
  RDB.LoadShcema(Schemas[mkSlave]);
  Refreshed := true;
end;

procedure RemapStruct(AutoAlter: Boolean; tableKinds: TMetaTableKinds);
label
  next;
var
  tMaster: TMetaTable;
  fMaster, fSlave: TMetaField;
  p: Pointer;
  ms, ss: TMetaSchema;
  mt,st: TMetaTableList;
  mf, sf: TMetaFieldList;
  I, K, J: Integer;
  map: TMapMeta;

  function _checkPK(m, s: TMetaTable): Integer;
  var
    n: Integer;
  begin
    Result := 0;
    for n := 0 to m.Indexes.Count-1 do
      if m.Indexes[n].Kind = ikPrimaryKey then
        begin
          Result := 1;
          break;
        end;
    for n := 0 to s.Indexes.Count-1 do
      if s.Indexes[n].Kind = ikPrimaryKey then
        begin
          Result := Result or 2;
          break;
        end;
  end;
begin
  Maps.clear;
  for K := 0 to Schemas[mkSlave].Count-1 do
    begin
      // поиск совпадения схемы
      ss := Schemas[mkSlave][K];
      if not ss.Checked then Continue;

      ms := TMetaSchema(Schemas[mkMaster].ItemsByName[ss.Name]);
      if (ms = nil) or not ms.Checked then Continue;
      mt := ms.Tables;
      st := ss.Tables;
      for I := 0 to st.Count-1 do
        begin
          if not (st[i].Kind in tableKinds) or not st[i].Checked then Continue;
         // совпадение таблиц
          tMaster := TMetaTable(mt.ItemsByName[st[i].Name]);
          if (tMaster = nil) or not (tMaster.Kind in tableKinds) or not tMaster.Checked then Continue;
          map := Maps.Add;
          map.AddTables(tMaster, st[i]);
          mf := tMaster.Fields;
          sf := st[i].Fields;
          //  совпадение полей
          for j := 0 to sf.Count-1 do
            begin
              if not sf[j].Checked then Continue;
              fMaster := TMetaField(mf.ItemsByName[sf[j].Name]);
              if (fMaster = nil) or not fMaster.Checked then Continue;
              map.AddFields(fMaster, sf[j]);
            end;
          j := _checkPK(tMaster, st[i]);
          map.Flags := [mfApply];
          if map.FieldCount = 0 then
            map.Flags := [mfError]
          else if j <> 3 then
            map.Flags := [mfError]
          else if j = 0 then
            if AutoAlter then
              begin
                fMaster          := TMetaField.Create;
                fMaster.Name     := 'id';
                fMaster.Alter    := true;
                fMaster.DataType := 23;
                fMaster.PK       := true;
                fSlave           := TMetaField.Create;
                fSlave.Name      := 'id';
                fSlave.Alter     := true;
                fSlave.DataType  := 23;
                fSlave.PK        := true;
                map.AddFields(fMaster, fSlave);
                map.Flags := map.Flags + [mfAlterIndex];
              end
            else
              map.Flags := [mfError];

          if mfApply in map.Flags then
            GenerateSQLs(map);
        end;
    end;
end;


procedure GenerateSQLs(map: TMapMeta);
var
  i: Integer;
  list: TStringList;
  s, select1, select2, update1, update2, insert1, insert2, trigger: string;
  function NormalizeName(const Name: string): string;
  begin
    Result := Name;
  end;
begin
  if not Assigned(map)then exit;
  s := '';
  select1 := '';
  select2 := '';
  update1 := '';
  update2:= '';
  insert1:= '';
  insert2:= '';
  map.ResetSQLs;
  for I := 0 to map.FieldCount-1 do
    begin
      if map.Fields[mkMaster, i].Alter and map.Fields[mkMaster, i].Checked then
        begin
          s := 'ALTER TABLE '+ NormalizeName(map.Tables[mkMaster].Name)+ sLineBreak +
               '   ADD COLUMN '+NormalizeName(map.Fields[mkMaster, i].Name)+ ' SERIAL;'+sLineBreak;
          map.SQLAlter[mkMaster] := map.SQLAlter[mkMaster] + s;
          s := 'CREATE UNIQUE INDEX _idx_' + NormalizeName(map.Tables[mkMaster].Name+ '_'+map.Fields[mkMaster, i].Name)+
               ' ON '+NormalizeName(map.Tables[mkMaster].Name)+' ('+sLineBreak+
               '   ' + NormalizeName(map.Fields[mkMaster, i].Name) + ' ASC'+sLineBreak+
               ');' +sLineBreak;
          map.SQLAlter[mkMaster] := map.SQLAlter[mkMaster] + s;
        end;
      if map.Fields[mkSlave, i].Alter then
        begin
          s := 'ALTER TABLE '+ NormalizeName(map.Tables[mkSlave].Name)+ sLineBreak +
               '   ADD COLUMN '+NormalizeName(map.Fields[mkSlave, i].Name)+ ' SERIAL;'+sLineBreak;
          map.SQLAlter[mkSlave] := map.SQLAlter[mkSlave] + s;
          s := 'CREATE UNIQUE INDEX _idx_' + NormalizeName(map.Tables[mkSlave].Name+ '_'+map.Fields[mkSlave, i].Name)+
               ' ON '+NormalizeName(map.Tables[mkSlave].Name)+' ('+sLineBreak+
               '   ' + NormalizeName(map.Fields[mkSlave, i].Name) + ' ASC'+sLineBreak+
               ');' +sLineBreak;
          map.SQLAlter[mkSlave] := map.SQLAlter[mkSlave] + s;
        end;


      if map.Fields[mkMaster, i].Checked then
        begin
      (*
      Временно не используется. может быть удалено
          select1 := select1 + ', '+ NormalizeName(map.Fields[mkMaster, i].Name);
          insert1 := insert1 + ', '+ NormalizeName(map.Fields[mkSlave, i].Name);
          insert2 := insert2 + ', :'+map.Fields[mkMaster, i].Name;
          update1 := update1 + ', '+ NormalizeName(map.Fields[mkSlave, i].Name) +
                     ' = :'+map.Fields[mkMaster, i].Name;
          if map.Fields[mkSlave, i].PK then
            update2 := update2 + ' AND '+ NormalizeName(map.Fields[mkSlave, i].Name) +
                     ' = :'+map.Fields[mkSlave, i].Name;
    *)
          if map.Fields[mkMaster, i].PK then
            begin
//              select2 := select2 + ' AND '+ NormalizeName(map.Fields[mkMaster, i].Name) +
//                       ' = :'+map.Fields[mkMaster, i].Name;
              trigger  := trigger + ', ' + QuotedStr(map.Fields[mkMaster, i].Name);
            end;

        end;

    end;

Delete(trigger, 1, 2);
  (*
  Временно не используется, может быть удалено
  Delete(select1, 1, 2);
  Delete(select2, 1, 5);
  Delete(insert1, 1, 2);
  Delete(insert2, 1, 2);
  Delete(update1, 1, 2);
  Delete(update2, 1, 5);

  select1 := Format('SELECT %s FROM %s WHERE %s;', [select1, NormalizeName(map.Tables[mkMaster].Name), select2]);
  insert1 := Format('INSERT INTO %s (%s) VALUES (%s);', [NormalizeName(map.Tables[mkSlave].Name), insert1, insert2]);
  update1 := Format('UPDATE %s SET %s WHERE %s;', [NormalizeName(map.Tables[mkSlave].Name), update1, update2]);
  map.SQLSelect[mkSlave] := select1;
  map.SQLUpdate[mkSlave] := update1;
  map.SQLInsert[mkSlave] := insert1;
  *)
   // первых два условия - это частный случай. Перенести в скрипт дополнительный.
  if map.Tables[mkMaster].Name = 'container' then
    begin
      map.SQLAlter[mkMaster] := map.SQLAlter[mkMaster] +
'DROP TRIGGER IF EXISTS trigger_notify_changes_container ON public.container;'+sLineBreak+
'CREATE TRIGGER trigger_notify_changes_container'+sLineBreak+
'    BEFORE INSERT OR DELETE OR UPDATE'+sLineBreak+
'    ON public.container'+sLineBreak+
'    FOR EACH ROW'+sLineBreak+
'    EXECUTE PROCEDURE _replica.notice_changed_data_container();';
    end
  else
  if map.Tables[mkMaster].Name = 'movementitemcontainer' then
    begin
      map.SQLAlter[mkMaster] := map.SQLAlter[mkMaster] +
'DROP TRIGGER IF EXISTS trigger_notify_changes_movementitemcontainer ON public.movementitemcontainer;'+sLineBreak+
'CREATE TRIGGER trigger_notify_changes_movementitemcontainer'+sLineBreak+
'    BEFORE INSERT OR DELETE OR UPDATE'+sLineBreak+
'    ON public.movementitemcontainer'+sLineBreak+
'    FOR EACH ROW'+sLineBreak+
'    EXECUTE PROCEDURE _replica.notice_changed_data_movementitemcontainer();';
    end
  else
    begin
  s := NormalizeName('trigger_notify_changes_'+map.Tables[mkMaster].Name);
  map.SQLAlter[mkMaster] := map.SQLAlter[mkMaster] + 'DROP TRIGGER IF EXISTS '+ s +sLineBreak + ' ON '+
                            NormalizeName(map.Tables[mkMaster].Schema.Name)+'.'+NormalizeName(map.Tables[mkMaster].Name) + ';';
  map.SQLAlter[mkMaster] := map.SQLAlter[mkMaster] + sLineBreak +
    'CREATE TRIGGER ' + s + sLineBreak+
    '    BEFORE INSERT OR UPDATE OR DELETE'+sLineBreak+
    '    ON ' +  NormalizeName(map.Tables[mkMaster].Schema.Name)+'.'+NormalizeName(map.Tables[mkMaster].Name) + sLineBreak+
    '    FOR EACH ROW'+sLineBreak+
    '    EXECUTE PROCEDURE _replica.notice_changed_data (' + trigger + ');';

    end;
end;

function GetScriptStruct(Kind: TMapKind; AOnlyTableSlave: boolean = false): string;
var
  i: Integer;
  list, listSlave: TStringList;
  s: string;
  function GetTableKey: int64;
  var
    ss: string;
  begin
    with Maps[i].Tables[mkMaster] do
      ss := Schema.Name + '.' + Name + ' => ' ;
    with Maps[i].Tables[mkSlave] do
      ss := ss + Schema.Name + '.' + Name;
    Result := NormalCRC64(Pointer(ss), Length(ss) * SizeOf(char));
  end;

  function GetStartIdValue(AValue: int64): string;
  begin
    if AValue < 0 then
      Result := 'NULL'
    else
      Result := IntToStr(AValue);
  end;
begin
  list := TStringList.Create;
  listSlave := TStringList.Create;
  try
    for I := 0 to Maps.Count-1 do
      if (mfApply in Maps[i].Flags) and Maps[i].Checked then
      begin
        if not AOnlyTableSlave then
        begin
          s := Maps[i].SQLAlter[Kind];
          if s <> '' then
            begin
              list.Add(' -- table '+Maps[i].Tables[Kind].Name);
              list.Add(s);
              list.Add('');
            end;
        end;
        if Kind = mkSlave then
          begin
            with Maps[i] do
            listSlave.Add(
              Format(
                'INSERT INTO  _replica.table_slave (table_key, master_schema, slave_schema, '+
                'master_table, slave_table, master_fields, slave_fields, '+
                'sql_select, sql_update, sql_insert, downloaded, start_id) VALUES (%d, %s, %s, %s, '+
                '%s, %s, %s, %s, %s, %s, FALSE, %s) ON CONFLICT (table_key) DO UPDATE SET'+sLineBreak+
                'master_schema = %1:s, slave_schema = %s, '+
                'master_table= %s, slave_table= %s, master_fields= %s, slave_fields= %s, '+
                'sql_select= %s, sql_update= %s, sql_insert= %s, start_id= %s;',
                [
                  GetTableKey,
                  QuotedStr(Tables[mkMaster].Schema.Name),
                  QuotedStr(Tables[mkSlave].Schema.Name),
                  QuotedStr(Tables[mkMaster].Name),
                  QuotedStr(Tables[mkSlave].Name),
                  QuotedStr(GetListField(mkMaster)),
                  QuotedStr(GetListField(mkSlave)),
                  QuotedStr(SQLSelect[mkSlave]),
                  QuotedStr(SQLUpdate[mkSlave]),
                  QuotedStr(SQLInsert[mkSlave]),
                  GetStartIdValue(Tables[mkMaster].StartId)
                ]
              )
            );

          end
        else if Kind = mkMaster then
          begin
            with Maps[i] do
            listSlave.Add(
              Format(
                'INSERT INTO  _replica.table_slave (table_key, master_schema, slave_schema, '+
                'master_table, slave_table, master_fields, slave_fields, '+
                'sql_select, sql_update, sql_insert, downloaded) VALUES (%d, %s, %s, %s, '+
                '%s, %s, %s, %s, %s, %s, FALSE) ON CONFLICT (table_key) DO UPDATE SET'+sLineBreak+
                'master_schema = %1:s, slave_schema = %s, '+
                'master_table= %s, slave_table= %s, master_fields= %s, slave_fields= %s, '+
                'sql_select= %s, sql_update= %s, sql_insert= %s;',
                [
                  GetTableKey,
                  QuotedStr(Tables[mkMaster].Schema.Name),
                  QuotedStr(Tables[mkSlave].Schema.Name),
                  QuotedStr(Tables[mkMaster].Name),
                  QuotedStr(Tables[mkSlave].Name),
                  QuotedStr(GetListField(mkMaster)),
                  QuotedStr(GetListField(mkSlave)),
                  QuotedStr(SQLSelect[mkSlave]),
                  QuotedStr(SQLUpdate[mkSlave]),
                  QuotedStr(SQLInsert[mkSlave])
                ]
              )
            );

          end;
      end;


    Result := list.Text + sLineBreak + listSlave.Text;

  finally
    list.Free;
    listSlave.Free;
  end;

end;

function GetTableSlaveScript: string;
begin
  RefreshStruct(true);
  Result := GetScriptStruct(mkSlave, true);
end;

procedure InitData;
begin
  Schemas[mkMaster] := TMetaSchemaList.Create(true);
  Schemas[mkSlave] := TMetaSchemaList.Create(true);
  Maps := TMapMetaTableList.Create(true);
end;

procedure ReleaseData;
begin
  Maps.Free;
  Schemas[mkMaster].Free;
  Schemas[mkSlave].Free;
end;

end.
