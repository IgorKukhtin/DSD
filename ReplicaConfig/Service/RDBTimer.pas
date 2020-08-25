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
* RDBTimer.pas - module timer for application rdb                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}

unit RDBTimer;

interface
uses
  Windows, SysUtils, Classes;
type
  TOnCRTTimer  = procedure (Id: Integer; Context: TObject) of object;
  PTimerInfo = ^TTimerInfo;
  TTimerInfo = record
    id: Integer;
    context: TObject;
    onTimer: TOnCRTTimer;
    index_crt: Integer;
    interval: Integer;
    ellapsed: Integer;
    paused: Boolean;

    s, m, h, d: Integer;
    next: PTimerInfo;
  end;
  TCRTTimer = class
  private
    FTimers: PTimerInfo;
    FTerminate: Boolean;
    FInterval: Cardinal;
    FHandle: THandle;
    FIdGen: Integer;
    FLock: Integer;
    FThreadInit: Integer;
    FRunning: Boolean;
    procedure HandleException;
    procedure Tick;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Id, IndexCrt, Interval: Integer; Context: TObject; Paused: Boolean;
      OnTimer: TOnCRTTimer): Integer;
    function Change(Id, IndexCrt, Interval: Integer; Context: TObject; Paused: Boolean;
      OnTimer: TOnCRTTimer): Integer;
    procedure Delete(Id: Integer);
    procedure Stop;
    procedure Srart;
    procedure Clear;
  end;
var
  CRTTimer: TCRTTimer;

implementation

{ TCRTTimer }

uses CrtUtils;

procedure APC(p: TCRTTimer); stdcall;
begin
  //
end;

function _Timer(t: TCRTTimer): Integer;
label
  RETRY;
begin
  InterlockedExchange(t.FThreadInit, 1);
  SleepEx(INFINITE, true);
  RETRY:
  try
    while not t.FTerminate do
      begin
        t.Tick;
        SleepEx(t.FInterval, true);
      end;
  except
    t.HandleException;
  end;
  if not t.FTerminate then
    goto RETRY;
  InterlockedExchange(t.FThreadInit, 0);
  Result := 0;
end;


function TCRTTimer.Add(Id, IndexCrt, Interval: Integer; Context: TObject;
  Paused: Boolean; OnTimer: TOnCRTTimer): Integer;
var
  c: PTimerInfo;
begin

  New(c);
  FillChar(c^, SizeOf(c^), 0);

  if id = -1 then
      id := InterlockedIncrement(FIdGen)
  else if id < FIdGen then
    raise Exception.CreateFmt('ID "%d"must be greater "%d"', [id, FIdGen])
  else
    InterlockedExchange(FIdGen, id);

  Result := Id;
  c.id := id;
  c.index_crt := IndexCrt;
  c.context   := Context;
  c.onTimer   := OnTimer;
  c.paused    := Paused;
  C.interval  := Interval;
  while InterlockedExchange(FLock, 1) <> 0 do SwitchToThread;
  c.next := FTimers;
  FTimers := c;
  InterlockedExchange(FLock, 0);
end;

function TCRTTimer.Change(Id, IndexCrt, Interval: Integer; Context: TObject;
  Paused: Boolean; OnTimer: TOnCRTTimer): Integer;
var
  c: PTimerInfo;
begin
  Result := id;
  c := FTimers;
  while c <> nil do
    begin
      if c.id = id then
        begin
          c.index_crt := IndexCrt;
          c.context   := Context;
          c.onTimer   := OnTimer;
          c.paused    := Paused;
          c.interval  := Interval;
          c.ellapsed  := 0;
          exit;
        end;
      c := c.next;
    end;
  Result := Add(id, IndexCrt, Interval, Context, Paused, OnTimer);
end;

procedure TCRTTimer.Clear;
var
  c, d: PTimerInfo;
begin
  Stop;
  WaitForSingleObject(FHandle, 5000);
  c := FTimers;
  FTimers := nil;
  while c <> nil do
    begin
      d := c;
      c := c.next;
      Dispose(d);
    end;

end;

constructor TCRTTimer.Create;
begin
  inherited;
  FHandle := BeginThread(nil, 0, @_Timer, Self, 0, PDWORD(nil)^);
  Win32Check(FHandle <> 0);
  while FThreadInit = 0 do SwitchToThread;

end;

procedure TCRTTimer.Delete(Id: Integer);
var
  c: PTimerInfo;
  p: ^PTimerInfo;
begin
  c := FTimers;
  p := @FTimers;
  while c <> nil do
    begin
      if c.id = id then
        begin
          while InterlockedExchange(FLock, 1) <> 0 do SwitchToThread;
          p^ := c.next;
          InterlockedExchange(FLock, 0);
          Dispose(c);
          break;
        end;
      p := @c.next;
      c := c.next;
    end;
end;

destructor TCRTTimer.Destroy;
begin
  FTerminate := true;
  Clear;
  CloseHandle(FHandle);
  inherited;
end;

procedure TCRTTimer.HandleException;
begin

end;

procedure TCRTTimer.Srart;
begin
  if FRunning then exit;
  FInterval := 1000;
  QueueUserAPC(@APC, FHandle, NativeInt(Self));
  FRunning := true;
end;

procedure TCRTTimer.Stop;
begin
  if not FRunning then exit;
  FInterval := INFINITE;
  QueueUserAPC(@APC, FHandle, NativeInt(Self));
  FRunning := false;
end;

procedure TCRTTimer.Tick;
var
  c, n: PTimerInfo;
begin
  c := FTimers;
  while c <> nil do
    begin
      if FTerminate  then break;
      if c.paused then
        begin
          c := c.next;
          Continue;
        end;

      n := c.next;
      inc(c.ellapsed);
      inc(c.s);
      if c.s = 60 then
        begin
          c.s := 0;
          Inc(c.m);
          if c.m = 60 then
            begin
              Inc(c.h);
              c.m := 0;
            end;
        end;
      if c.index_crt <> -1 then
        PanelUpdateValue(c.index_crt, Format('%2.2d:%2.2d:%2.2d', [c.h, c.m, c.s]));
      if Assigned(c.onTimer) and (c.ellapsed = c.interval) then
        begin
          c.ellapsed := 0;
          c.onTimer(c.id, c.context);
        end;
       c := n;
    end;

end;

end.
