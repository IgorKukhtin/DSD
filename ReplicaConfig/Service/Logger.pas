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
* Logger.pas - logger module                                                   *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit Logger;

interface
uses
  Windows, SysUtils, Classes, CrtUtils;
type
  TLogSeverity = (lsInformation, lsWarning, lsError, lsFatal, lsDebug);

procedure Log(Severity: TLogSeverity; const Fmt: string; const Args: array of const); overload;
procedure Log(Severity: TLogSeverity; const Text: string); overload;
procedure LogI(const Fmt: string; const Args: array of const); overload;
procedure LogI(const Text: string); overload;
procedure LogE(const Fmt: string; const Args: array of const); overload;
procedure LogE(const Text: string); overload;
procedure LogW(const Fmt: string; const Args: array of const); overload;
procedure LogW(const Text: string); overload;

implementation
var
  f: TFileStream;
  logEnable: Boolean;

procedure WriteLog(Severity: TLogSeverity; const text: string);
var
  u: UTF8String;
begin
  case Severity of
    lsInformation: u := ' [I]  ';
    lsWarning: u := ' [W]  ';
    lsError: u := ' [E]  ';
    lsFatal: u := ' [F]  ';
    lsDebug: u := ' [D]  ';
  else
    u := ' [?]  ';
  end;
  u := FormatDateTime('HH:NN:SS.ZZZ', Now) + u + text + sLineBreak;
  f.Write(Pointer(u)^, Length(u));
end;

procedure Log(Severity: TLogSeverity; const Fmt: string; const Args: array of const); overload;
begin
  Log(Severity, Format(Fmt, Args));
end;

procedure Log(Severity: TLogSeverity; const Text: string); overload;
begin
  case Severity of
    lsInformation: WriteInfo(Text);
    lsWarning: ;
    lsError: WriteError(Text);
    lsFatal: ;
    lsDebug: ;
  end;
  if logEnable then
    WriteLog(Severity, Text);
end;

procedure LogI(const Fmt: string; const Args: array of const); overload;
begin
  LogI(Format(Fmt, Args));
end;

procedure LogI(const Text: string); overload;
begin
  WriteInfo(Text);
  if logEnable then
    WriteLog(lsInformation, Text);
end;

procedure LogE(const Fmt: string; const Args: array of const); overload;
begin
  LogE(Format(Fmt, Args));
end;

procedure LogE(const Text: string); overload;
begin
  WriteError(Text);
  if logEnable then
    WriteLog(lsError, Text);
end;

procedure LogW(const Fmt: string; const Args: array of const); overload;
begin
  LogW(Format(Fmt, Args));
end;

procedure LogW(const Text: string); overload;
begin
  WriteInfo(Text);
  if logEnable then
    WriteLog(lsWarning, Text);
end;


procedure LogInit;
var
  s: string;
  a: AnsiString;
begin
  if not FindCmdLineSwitch('log', s) then exit;
  if s = '' then
    s := ChangeFileExt(ParamStr(0), '.log');
  if FileExists(s) then
    begin
      f := TFileStream.Create(s, fmOpenReadWrite or fmShareDenyNone);
      f.Seek(0, soFromEnd);
    end
  else
    begin
      f := TFileStream.Create(s, fmCreate or fmShareDenyNone);
      f.WriteData(TBytes.Create($EF, $BB, $BF), 3);
    end;
  a := '----------- BEGIN ---------------------------------------' +
       FormatDateTime('DD.MM.YYYY HH:NN:SS.ZZZ', Now) + sLineBreak;
  F.Write(Pointer(a)^, Length(a));
  logEnable := true;
end;

procedure LogFinalize;
begin
  logEnable := false;
  FreeAndNil(f);
end;

initialization
  LogInit
finalization
  LogFinalize

end.
