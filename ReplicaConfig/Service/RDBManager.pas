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
* RDBManager.pas - manager thread and task                                     *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.3d                                                       *
*==============================================================================}

unit RDBManager;

interface
uses
  Windows, SysUtils, Classes,  RDBData,
  FireDAC.Comp.Client, Data.DB;
type
  TOnException = procedure (E: Exception) of object;
  TRDBManager = class;
  TRDBCustomAlerter = class;

  TRDBCustomAlerter = class
  private
    FConnection: TFDCustomConnection;
    FActive: Boolean;
    FManager: TRDBManager;
    procedure SetConnection(const Value: TFDCustomConnection);
    procedure SetActive(const Value: Boolean);
  protected
    procedure InternalSetConnection(const Value: TFDCustomConnection); virtual; abstract;
    procedure InternalSetActive(const Value: Boolean); virtual; abstract;
    procedure AlertTable(const Name, Op: string);
  public
    constructor Create(Manager: TRDBManager); virtual;
    destructor Destroy; override;
    property Active: Boolean read FActive write SetActive;
    property Connection : TFDCustomConnection read FConnection  write SetConnection ;
  end;

  TRDBAlerterClass = class of TRDBCustomAlerter;

  TRDBManager = class(TThread)
  private
    FReplica: TDBReplicationEx;
    FUpdates: array of array [0..1] of string;
    FEvent: THandle;
    FBreak: Boolean;
    FPaused: Boolean;
    FProccessing: Boolean;
    FRDBAlerter: TRDBCustomAlerter;
    FOnException: TOnException;
    procedure SetPaused(const Value: Boolean);
  protected
    procedure Execute; override;
    procedure TerminatedSet; override;
  public
    constructor Create(RDBAlerterClass: TRDBAlerterClass);
    destructor Destroy; override;
    function CanExecute: Boolean;
    function GetClientID: string;
    procedure Release;
    procedure UpdateTable(const TableName, Op: string);
    function SrcConnection(con: TFDCustomConnection): TFDCustomConnection;
    function DestConnection(con: TFDCustomConnection): TFDCustomConnection;
    function ClientVisit(): Boolean;
    property Paused: Boolean read FPaused write SetPaused;
    property OnException: TOnException read FOnException write FOnException;
    property Alerter: TRDBCustomAlerter read  FRDBAlerter;

  end;

  TRDBAlertPG = class (TRDBCustomAlerter)
  private
    FAlerter: TFDEventAlerter;
    procedure OnAlert (ASender: TFDCustomEventAlerter;
      const AEventName: String; const AArgument: Variant);
  protected
    procedure InternalSetConnection(const Value: TFDCustomConnection); override;
    procedure InternalSetActive(const Value: Boolean); override;
  public
    constructor Create(Manager: TRDBManager); override;
    destructor Destroy; override;


  end;

implementation

uses Logger;

const
  CHANEL_NOTIFY_DATA = '_replica_table_notify_';
  CHANEL_NOTIFY_DDL  = '_replica_ddl_notify_';

{ **************************************************************************** }
{                               TRDBManager                                    }
{ **************************************************************************** }

function TRDBManager.CanExecute: Boolean;
begin
  Result := Assigned(FReplica.Source) and Assigned(FReplica.Destination) and
            FReplica.Source.Connected and FReplica.Destination.Connected;
end;

function TRDBManager.ClientVisit: Boolean;
begin
  Result := FReplica.VisitClient;
end;

constructor TRDBManager.Create(RDBAlerterClass: TRDBAlerterClass);
begin
  FReplica := TDBReplicationEx.Create(nil, nil);
  FEvent := CreateEvent(nil, false, false, '_EVENT_RDB_');
  FRDBAlerter := RDBAlerterClass.Create(Self);
  FPaused := true;
  inherited Create;
end;

function TRDBManager.DestConnection(con: TFDCustomConnection): TFDCustomConnection;
begin
  // todo: raise excpetpion when Proccessing
  Result := FReplica.Destination;
  FReplica.Destination := con;
end;

destructor TRDBManager.Destroy;
begin
  FRDBAlerter.Active := false;
  CloseHandle(FEvent);
  FReplica.Free;
  FRDBAlerter.Free;
  inherited;
end;

procedure TRDBManager.Execute;
var
  tables: array of array [0..1] of string;
  i: Integer;
begin
  while (WaitForSingleObject(FEvent, INFINITE)= WAIT_OBJECT_0) and not Terminated do
    begin
      if FPaused then Continue;
      FProccessing := true;
      try
        tables := nil;
        Pointer(tables) := InterlockedExchangePointer(Pointer(FUpdates), Pointer(tables));
        for I := 0 to Length(tables)-1 do
          begin
            //Continue;
            if tables[i, 0] <> CHANEL_NOTIFY_DDL then
              FReplica.ExecuteEx(tables[i, 0], tables[i, 1])  else
              FReplica.ExecuteDDL();
            if FBreak then break;
          end;
      except
        on E: Exception do
          FOnException(E);
        // Handle exception;
      end;
      FProccessing := false;
    end;
end;

function TRDBManager.GetClientID: string;
begin
  Result := FReplica.ClientID;
end;

procedure TRDBManager.Release;
begin

end;

procedure TRDBManager.SetPaused(const Value: Boolean);
begin
  if FPaused <> Value then
    begin
      FPaused := Value;
      FBreak := Value;
      SetEvent(FEvent);
    end;
end;

function TRDBManager.SrcConnection(con: TFDCustomConnection): TFDCustomConnection;
begin
  // todo: raise excpetpion when Proccessing
  Result := FReplica.Source;
  FReplica.Source := con;
  FRDBAlerter.Connection := con;
  FRDBAlerter.Active := con <> nil
end;

procedure TRDBManager.TerminatedSet;
begin
  inherited;
  FReplica.Terminate;
  FBreak := true;
  SetEvent(FEvent);
end;

procedure TRDBManager.UpdateTable(const TableName, Op: string);
label
  SET_EVENT;
var
  a: array of array [0..1] of string;
  I: Integer;
begin
  a := nil;
  Pointer(a) := InterlockedExchangePointer(Pointer(FUpdates), Pointer(a));
  for I := 0 to Length(a)-1 do
    if (a[i, 0] = TableName) and (a[i, 1] = Op) then
      goto SET_EVENT;
  I := Length(a);
  SetLength(a, i+1);
  a[i, 0] := TableName;
  a[i, 1] := Op;

SET_EVENT:
  Pointer(a) := InterlockedExchangePointer(Pointer(FUpdates), Pointer(a));
  SetEvent(FEvent);
end;



{ **************************************************************************** }
{                               TRDBCustomAlerter                              }
{ **************************************************************************** }


procedure TRDBCustomAlerter.AlertTable(const Name, Op: string);
begin
  FManager.UpdateTable(Name, Op);
end;

constructor TRDBCustomAlerter.Create(Manager: TRDBManager);
begin
  inherited Create;
  FManager := Manager;
end;

destructor TRDBCustomAlerter.Destroy;
begin
  Active := false;
  inherited;
end;

procedure TRDBCustomAlerter.SetActive(const Value: Boolean);
begin
  if FActive <> Value then
    begin
      InternalSetActive(Value);
      FActive := Value;
    end;
end;

procedure TRDBCustomAlerter.SetConnection(const Value: TFDCustomConnection);
begin
  if FConnection <> Value then
    begin
      Active := false;
      InternalSetConnection(Value);
      FConnection := Value;
    end;
end;

{ **************************************************************************** }
{                               TRDBAlertPG                                    }
{ **************************************************************************** }

constructor TRDBAlertPG.Create(Manager: TRDBManager);
begin
  inherited;
  FAlerter := TFDEventAlerter.Create(nil);
  FAlerter.Names.Add(CHANEL_NOTIFY_DATA);
  FAlerter.Names.Add(CHANEL_NOTIFY_DDL);
  FAlerter.OnAlert := OnAlert;
  FAlerter.Options.AutoRegister := false;
  FAlerter.Options.Synchronize  := false;
end;

destructor TRDBAlertPG.Destroy;
begin
  FAlerter.Free;
  inherited;
end;

procedure TRDBAlertPG.InternalSetActive(const Value: Boolean);
begin
  FAlerter.Active := Value;
end;

procedure TRDBAlertPG.InternalSetConnection(const Value: TFDCustomConnection);
begin
  FAlerter.Connection := Value;
end;

procedure TRDBAlertPG.OnAlert(ASender: TFDCustomEventAlerter;
  const AEventName: String; const AArgument: Variant);
var
  args: array of string;
  a: TArray<string>;
begin



  if AEventName = CHANEL_NOTIFY_DDL then
    begin
      LogI('STRUCTURE CHANGED');
      EXIT;
    end;
  args := AArgument;
  if Length(args) < 2 then exit;
  args[1] := Copy(args[1], 2, Length(args[1])-2);
  a := args[1].Split([',']);
  if Length(a) > 2 then
    begin
      a[0] := trim(a[0]);
      a[1] := trim(a[1]);
      LogI('EVENT: %s, OBJECT: %s.%s, PID: %s', [AEventName, a[0], a[1], args[0]]);
      AlertTable(a[0], a[1]);
    end
  else
    begin
      LogI('EVENT: %s, PID: %s', [AEventName, args[0]]);
      AlertTable('', '');
    end;
  exit;
  if AEventName = CHANEL_NOTIFY_DATA then
    AlertTable(CHANEL_NOTIFY_DATA, '') else
    AlertTable(CHANEL_NOTIFY_DDL, '');


end;

end.
