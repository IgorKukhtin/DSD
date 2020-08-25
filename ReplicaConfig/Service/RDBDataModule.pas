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
* RDBDataModule.pas - module init connection                                   *
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
  System.SysUtils, System.Classes, RDBManager, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Phys, FireDAC.Comp.Client, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.ConsoleUI.Wait, FireDAC.Phys.PG, FireDAC.Phys.PGDef,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.DApt,
  Data.DB, FireDAC.Moni.Base, FireDAC.Moni.RemoteClient, CrtUtils, RDBTimer;

type
  TRDBM = class(TDataModule)
    FDManager: TFDManager;
    FDMoniRemoteClientLink: TFDMoniRemoteClientLink;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure FDConnectionRecover(ASender, AInitiator: TObject;
      AException: Exception; var AAction: TFDPhysConnectionRecoverAction);
    procedure FDConnectionRestored(Sender: TObject);
    procedure FDConnectionLost(Sender: TObject);
    procedure FDConnectionError(ASender, AInitiator: TObject;
      var AException: Exception);
  private
    { Private declarations }
    FRDBManager: TRDBManager;
    FConnected: Boolean;
    FVisitBusy,FVisitError: Boolean;
    FLastDBError: Exception;
    procedure OnTimerRecovery(Id: Integer; Context: TObject);
    procedure OnVisit(Id: Integer; Context: TObject);
    function GetClientID: string;
  public
    { Public declarations }
    procedure ReConnect;
    procedure Terminate;
    function GetNewConnection(const ConnectionDefName: string): TFDCustomConnection;
    procedure ReleaseConnection(Conn: TFDCustomConnection);
    procedure OnException(E: Exception);

  end;

var
  RDBM: TRDBM;
  ConnectionMaster: string  = 'master-connection';
  ConnectionSlave: string   = 'slave-connection';
  ConnectionFile: string    = 'ConnDef.ini';
  TimerVisit: Integer = 15;
  ApplicationName: string = 'RDB v1.0(Replication database application)';
const
  ApplicationNameDef = 'RDB v%s(Replication database application)';
  idMasterUTimer = 0;
  idMasterDTimer = 1;
  idSlaveUTimer = 2;
  idSlaveDTimer = 3;
  idVisitTimer  = 4;


implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

uses Logger, Windows, TypInfo;

{$R *.dfm}



procedure TRDBM.DataModuleCreate(Sender: TObject);
begin
  FDManager.ConnectionDefFileName := ConnectionFile;
  FRDBManager := TRDBManager.Create(TRDBAlertPG);
  FRDBManager.OnException := OnException;
end;

procedure TRDBM.DataModuleDestroy(Sender: TObject);
begin
  Terminate;
  FRDBManager.Free;
end;

procedure TRDBM.FDConnectionError(ASender, AInitiator: TObject;
  var AException: Exception);
var
  E: EFDDBEngineException absolute AException;
  conn: TFDCustomConnection;
  s: string;
begin
  FLastDBError := AException;
       { TODO : Добавить синхронизацию ислючений, чтобы не дублировались }
  if not (AException is EFDDBEngineException) then
    begin
      LogE('[CONNECTION ERROR] ClassName: %s, Message: %s',
            [AException.ClassName, AException.Message]);
    end
  else if (E.Kind <> ekUKViolated) then
    begin
      LogE('[CONNECTION ERROR] ClassName: %s, Message: %s => SQL: %s Params: %s',
            [E.ClassName, E.Message, E.SQL, E.Params.CommaText]);
    end;
  if (AException is EFDDBEngineException) then
    begin
      s := Format('ClassName: %s, Message: %s => SQL: %s Params: %s',
            [E.ClassName, E.Message, E.SQL, E.Params.CommaText]);
      conn := GetNewConnection(ConnectionMaster);
      try
        conn.ExecSQL('INSERT INTO _replica.logger (client_id, msg, msg_type) VALUES (:id, :msg, :type)',
            [GetClientID, s, GetEnumName(TypeInfo(TFDCommandExceptionKind), Integer(E.Kind))], [ftLargeint, ftString, ftString]);
      except
        //  ну шлепнули нам здесь, чего в цикл пускать?
        //  тихо уходим
      end;
      ReleaseConnection(conn);
    end;
end;

procedure TRDBM.FDConnectionLost(Sender: TObject);
var
  conn: TFDCustomConnection absolute Sender;
begin
  LogW('[CONNECTION LOST] Name: %s', [conn.ConnectionDefName]);
  try
  FRDBManager.Alerter.Active := false;
  except
    on E: Exception do
      LogE('ClassName: %s Message: %s',  [E.ClassName, E.Message]);
  end;

  if conn.Tag = idMasterUTimer then
    begin
      CRTTimer.Change(idMasterUTimer, -1, -1, nil, true, nil);
      CRTTimer.Change(idMasterDTimer, idxValueMasterDTime, 15, conn, false, OnTimerRecovery);
    end
  else
    begin
      CRTTimer.Change(idSlaveUTimer, -1, -1, nil, true, nil);
      CRTTimer.Change(idSlaveDTimer, idxValueSlaveDTime, 15, conn, false, OnTimerRecovery);
    end;
end;

procedure TRDBM.FDConnectionRecover(ASender, AInitiator: TObject;
  AException: Exception; var AAction: TFDPhysConnectionRecoverAction);
var
  conn: TFDCustomConnection absolute ASender;
begin
  LogW('[CONNECTION RECOVER] Action: %d ClassName: %s Message: %s',
        [Integer(AAction), AException.ClassName, AException.Message]);
  FRDBManager.Paused := true;
end;

procedure TRDBM.FDConnectionRestored(Sender: TObject);
begin
  LogW('[CONNECTION RESTORED] ClassName: ' + Sender.ClassName);
  FRDBManager.Alerter.Active := true;
  FRDBManager.Paused := false;
  FRDBManager.UpdateTable('',  '');
end;

var
  id: Integer;
function TRDBM.GetClientID: string;
begin
  Result := FRDBManager.GetClientID
end;

function TRDBM.GetNewConnection(const ConnectionDefName: string): TFDCustomConnection;
begin
  Result := TFDConnection.Create(Self);
  Result.ConnectionDefName := ConnectionDefName;
  Result.LoginPrompt := false;
  Result.TxOptions.Isolation := xiSnapshot;
  Result.OnError := FDConnectionError;
  Result.OnLost  := FDConnectionLost;
  Result.OnRestored := FDConnectionRestored;
  Result.OnRecover  := FDConnectionRecover;
  Result.Name := 'Con_'+id.ToString;
  Result.Params.Values['ApplicationName'] := ApplicationName;
  Inc(id);
  Result.Connected := true;

end;

procedure TRDBM.OnException(E: Exception);
var
  Inner: Exception;
begin
  if E = FLastDBError then
    begin
      LogE('Aborted!');
      exit;
    end;
  FLastDBError := nil;
  Inner := E;
  while Inner <> nil do
  begin
    LogE('ClassName: %s Message: %s',  [Inner.ClassName, Inner.Message]);
    Inner := Inner.InnerException;
  end;
end;


procedure TRDBM.OnTimerRecovery(Id: Integer; Context: TObject);
var
  c: TFDConnection absolute Context;
begin
  LogI('[OnTimerRecovery] TRY RECOVERY ID = %d',[ID]);
  try
  c.Ping;
  if c.Connected and c.Ping then
    begin
      if c.InTransaction then
        c.Rollback;
      CRTTimer.Change(id, -1, -1, nil, true, nil);
      if c.Tag = idMasterUTimer then
        CRTTimer.Change(idMasterUTimer, idxValueMasterUTime, -1, c, false, nil) else
        CRTTimer.Change(idSlaveUTimer, idxValueSlaveUTime, -1, c, false, nil);
      LogI('[OnTimerRecovery] RECOVERY SUCCESS ID = %d', [ID]);
      if FRDBManager.CanExecute then
        begin
          FRDBManager.Alerter.Active := true;
          FRDBManager.Paused := false;
          FRDBManager.UpdateTable('', '');
        end;
    end;
  except
    on E: Exception do
      LogE('[OnTimerRecovery] ClassName: %s Message: %s', [E.ClassName, E.Message]);
  end;
end;

procedure TRDBM.OnVisit(Id: Integer; Context: TObject);
begin
  try
    FVisitBusy := not FRDBManager.ClientVisit;
  except
    on E: Exception do
      begin
        FVisitError := true;
        LogE('client_visit() ClassName: %s Message: %s', [E.ClassName, E.Message]);
      end;
  end;
end;

procedure TRDBM.ReConnect;
var
  s: string;
  c: IFDStanConnectionDef;
  conn: TFDCustomConnection;
begin

  if FindCmdLineSwitch('file', s)  then
    ConnectionFile := s;
  if FindCmdLineSwitch('master', s)  then
    ConnectionMaster := s;
  if FindCmdLineSwitch('slave', s)  then
    ConnectionSlave := s;

  FRDBManager.Paused := true;

  FDManager.Close;
  FDManager.ConnectionDefFileName := ConnectionFile;
  FDManager.Open;
  c := FDManager.ConnectionDefs.ConnectionDefByName(ConnectionMaster);
  PanelUpdateValue(idxValueMasterName, c.Name);
  PanelUpdateValue(idxValueMasterSrv, TFDPhysPGConnectionDefParams(c.Params).Server);
  PanelUpdateValue(idxValueMasterDB, c.Params.Database);
  c := FDManager.ConnectionDefs.ConnectionDefByName(ConnectionSlave);
  PanelUpdateValue(idxValueSlaveName, c.name);
  PanelUpdateValue(idxValueSlaveSrv, TFDPhysPGConnectionDefParams(c.Params).Server);
  PanelUpdateValue(idxValueSlaveDB, c.Params.Database);

  c := nil;

  FRDBManager.Paused := true;
  FDManager.Close;
  FDManager.ConnectionDefFileName := ConnectionFile;
  FDManager.Open;
  conn := GetNewConnection(ConnectionMaster);
  CRTTimer.Clear;

  conn.Tag := idMasterUTimer;
  CRTTimer.Add(idMasterUTimer, idxValueMasterUTime, -1, conn, false, nil);
  CRTTimer.Add(idMasterDTimer, -1, -1, nil, true, nil);
  ReleaseConnection(FRDBManager.SrcConnection(conn));
  conn := GetNewConnection(ConnectionSlave);
  conn.Tag := idSlaveUTimer;
  CRTTimer.Add(idSlaveUTimer, idxValueSlaveUTime, -1, conn, false, nil);
  CRTTimer.Add(idSlaveDTimer, -1, -1, nil, true, nil);
  ReleaseConnection(FRDBManager.DestConnection(conn));
  CRTTimer.Add(idVisitTimer, -1, 60 * TimerVisit, nil, false, OnVisit);

  WriteInfo('Started ' + DateTimeToStr(Now) + '.');
  WriteInfo('Code page = '+ GetACP.ToString);
  WriteInfo('log enable = '+ BoolToStr(FindCmdLineSwitch('log'), true));
  WriteInfo('timer visit = %d min', [TimerVisit]);
  OnVisit(-1, nil);
  if not FVisitBusy and not FVisitError then
    begin
      FRDBManager.Paused := false;
      FRDBManager.UpdateTable('', '');
    end
  else if not FVisitError then
    begin
      WriteInfo('Application in IDLE mode. Other client has connection to replication.');
    end
  else
    begin
      WriteInfo('Erorr occured.');
    end;

end;

procedure TRDBM.ReleaseConnection(Conn: TFDCustomConnection);
begin
  if Conn <> nil then
    begin
      Conn.Connected := false;
      Conn.Free;
    end;
end;

procedure TRDBM.Terminate;
begin
  FRDBManager.Terminate;
  FRDBManager.WaitFor;
  FDManager.Close;
  ReleaseConnection(FRDBManager.SrcConnection(nil));
  ReleaseConnection(FRDBManager.DestConnection(nil));

end;

end.

