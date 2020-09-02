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
* MainUnit.pas - main unit applcation "configurator"                           *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  System.Actions, Vcl.ActnList, FormScripts, GenData, RDBClass, RDBDataModule,
  FormDumpRestore, FormWizard, FormMapResult;

type
  TMainForm = class(TForm)
    pnlTop: TPanel;
    btnExecuteScripts: TButton;
    btnCreateReplicaStruct: TButton;
    chbAutoAlter: TCheckBox;
    chbReadOnly: TCheckBox;
    chbDelay: TCheckBox;
    chbTimer: TCheckBox;
    btnGenerateExecute: TButton;
    ActionList: TActionList;
    actAlterPK: TAction;
    actAlter: TAction;
    actAlterIndex: TAction;
    edDelay: TEdit;
    edTimer: TEdit;
    chbIncludeTable: TCheckBox;
    chbIncludeView: TCheckBox;
    lblObject: TLabel;
    lblDelayTime: TLabel;
    lblTimerTime: TLabel;
    btnWizard: TButton;
    btnGenerate: TButton;
    chbCheckSchema: TCheckBox;
    btnInitMasterSequences: TButton;
    btnInitSlaveSequences: TButton;
    btnSaveClientIDs: TButton;
    procedure actAlterPKExecute(Sender: TObject);
    procedure actAlterIndexExecute(Sender: TObject);
    procedure btnExecuteScriptsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGenerateExecuteClick(Sender: TObject);
    procedure btnCreateReplicaStructClick(Sender: TObject);
    procedure btnWizardClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnInitMasterSequencesClick(Sender: TObject);
    procedure btnSaveClientIDsClick(Sender: TObject);
    procedure btnInitSlaveSequencesClick(Sender: TObject);
  private
    { Private declarations }
    function CreateID(Kind: TMapKind): string;
    function GetReplicaScript(): string;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
 ShaCrc64Unit;

{$R *.dfm}

procedure TMainForm.actAlterIndexExecute(Sender: TObject);
begin
//
end;

procedure TMainForm.actAlterPKExecute(Sender: TObject);
begin
//
end;

procedure TMainForm.btnCreateReplicaStructClick(Sender: TObject);
var
  srv, db, user, pwd: string;
  prt: integer;
begin
  with TDumpRestoreForm.Create(nil) do
    try
      RDB.GetConnectionInfo(srv, db, user, pwd, prt, mkMaster);
      edHostDump.Text := srv;
      edPortDump.Text := IntToStr(prt);
      edDBDump.Text   := db;
      edUserDump.Text := user;
      edPswDump.Text  := pwd;
      RDB.GetConnectionInfo(srv, db, user, pwd, prt, mkSlave);
      edHostRestore.Text := srv;
      edPortRestore.Text := IntToStr(prt);
      edDBRestore.Text   := db;
      edUserRestore.Text := user;
      edPswRestore.Text  := pwd;
      ShowModal;
    finally
      Free;
    end;
end;

procedure TMainForm.btnExecuteScriptsClick(Sender: TObject);
begin
  ScriptsForm.ShowModal
end;

procedure TMainForm.btnGenerateClick(Sender: TObject);
var
  kinds: TMetaTableKinds;
  s: string;
  list: TStringList;
begin
  RDB.CheckReplicaSchema;
  list := TStringList.Create;

  RefreshStruct(false);
  kinds := [];
  if chbIncludeTable.Checked then
    Include(kinds, tkTable);
  if chbIncludeView.Checked then
    Include(kinds, tkView);
  RemapStruct(chbAutoAlter.Checked, kinds);
  if not chbCheckSchema.Checked or not RDB.ReplicaSchemaUsed[mkMaster] then
    begin
      list.Add(GetReplicaScript());
      list.Add('');
    end;
  list.Add(GetScriptStruct(mkMaster));
  list.Add('');
  list.Add(DefSettingsVersion);
  list.Add(Format(DefSettingsClientId, [CreateID(mkMaster)]));
  ScriptsForm.AddScript(list.Text, 'replica_master');
  list.Clear;
  if not chbCheckSchema.Checked or not RDB.ReplicaSchemaUsed[mkSlave] then
    begin
      list.Add(GetReplicaScript());
      list.Add('');
    end;
  list.Add(GetScriptStruct(mkSlave));
  list.Add('');
  list.Add(DefSettingsVersion);
  list.Add(Format(DefSettingsClientId, [CreateID(mkSlave)]));
  ScriptsForm.AddScript(list.Text, 'replica_slave');
  ScriptsForm.ShowModal;
end;

procedure TMainForm.btnGenerateExecuteClick(Sender: TObject);
var
  kinds: TMetaTableKinds;
  s: string;
  list: TStringList;
begin
  RDB.CheckReplicaSchema;
  list := TStringList.Create;
  try

//    if not chbCheckSchema.Checked or not RDB.ReplicaSchemaUsed[mkSlave] then
//      RDB.ExecuteScript(GetReplicaScript(false), mkSlave);
//    if not chbCheckSchema.Checked or not RDB.ReplicaSchemaUsed[mkMaster] then
//      RDB.ExecuteScript(GetReplicaScript(false), mkMaster);
//    lblSchemaReplica.Caption := 'shcema _replica created';

    if not chbCheckSchema.Checked or not RDB.ReplicaSchemaUsed[mkMaster] then
      list.Add(GetReplicaScript());


    RefreshStruct(false);
    kinds := [];
    if chbIncludeTable.Checked then
      Include(kinds, tkTable);
    if chbIncludeView.Checked then
      Include(kinds, tkView);
    RemapStruct(chbAutoAlter.Checked, kinds);
    list.Clear;
    list.Add(GetScriptStruct(mkMaster));
    list.Add('');
    list.Add(DefSettingsVersion);
    list.Add(Format(DefSettingsClientId, [CreateID(mkMaster)]));
    s := list.Text;
    ScriptsForm.AddScript(s);
    RDB.ExecuteScript(s, mkMaster);

    list.Clear;
    if not chbCheckSchema.Checked or not RDB.ReplicaSchemaUsed[mkSlave] then
      list.Add(GetReplicaScript());
    list.Add(GetScriptStruct(mkSlave));
    list.Add('');
    list.Add(DefSettingsVersion);
    list.Add(Format(DefSettingsClientId, [CreateID(mkSlave)]));
    s := list.Text;
    ScriptsForm.AddScript(s);
    RDB.ExecuteScript(s, mkSlave);
    RDB.SaveClientIDs;
    MessageBox(Handle, 'OK', '', MB_ICONINFORMATION or MB_OK);
  finally
    list.Free;
  end;
end;

procedure TMainForm.btnInitMasterSequencesClick(Sender: TObject);
begin
  if RDB.InitMasterSequences then
  begin
    RDB.ExecuteScript(GetTableSlaveScript, mkSlave);
    MessageBox(Handle, 'Master sequences are initialized successfully', '', MB_ICONINFORMATION or MB_OK);
  end;
end;

procedure TMainForm.btnInitSlaveSequencesClick(Sender: TObject);
begin
  if RDB.InitSlaveSequences then
    MessageBox(Handle, 'Slave sequences are initialized successfully', '', MB_ICONINFORMATION or MB_OK);
end;

procedure TMainForm.btnSaveClientIDsClick(Sender: TObject);
begin
  RDB.SaveClientIDs;
end;

procedure TMainForm.btnWizardClick(Sender: TObject);
var
  kinds: TMetaTableKinds;
begin
  RefreshStruct(false);
  kinds := [];
  if chbIncludeTable.Checked then
    Include(kinds, tkTable);
  if chbIncludeView.Checked then
    Include(kinds, tkView);
  WizardForm.Reinit(kinds);
  WizardForm.ShowModal;
  RemapStruct(chbAutoAlter.Checked, kinds);
  MapResultForm.Reinit;
  MapResultForm.ShowModal;
end;

function TMainForm.CreateID(Kind: TMapKind): string;
var
  s1, s2, s3, s4: string;
  s: string;
  i, prt: Integer;
  crc64: Int64;
begin
  RDB.GetConnectionInfo(s1, s2, s3, s4, prt, Kind);
  s := s1 + s2 + s3 + s4;
  crc64:= NormalCRC64(Pointer(s), Length(s) * SizeOf(char));
  Result := crc64.ToString;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  {$ifdef release}
    btnWizard.Visible := FALSE;
  {$endif}
  InitData;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  ReleaseData;
end;

function TMainForm.GetReplicaScript(): string;
var
  list: TStringList;
begin
  list := TStringList.Create;
  try
    list.LoadFromFile('..\scripts\_replica.sql');
    Result := list.Text;
    list.LoadFromFile('..\scripts\_replica_container.sql');
    Result  := Result + sLineBreak + list.Text;
  finally
    list.Free;
  end;
end;

end.
