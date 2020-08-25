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
* RDBData.pas - project file replication                                       *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
program RDB;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Winapi.Windows,
  System.SysUtils,
  RDBDataModule in 'RDBDataModule.pas' {RDBM: TDataModule},
  CrtUtils in 'CrtUtils.pas',
  RDBData in 'RDBData.pas',
  RDBManager in 'RDBManager.pas',
  MapTables in 'MapTables.pas',
  RDBTimer in 'RDBTimer.pas',
  Logger in 'Logger.pas',
  FixNativePG in 'FixNativePG.pas';

procedure OnTerminate;
begin
  LogI('Close()');
  CRTTimer.Free;
  RDBM.Free;
  RDBM := nil;
end;

//------------------------------------------------------------------------------
{ возвращает версию файла }
function FileVersion(const FileName:string): string;
var
  P: Pointer;
  GetTranslationString:string;
  Size: DWORD;
  Handle: DWORD;
  Buffer: PChar;
begin
   Buffer := nil;
   Result := '';
   Size := GetFileVersionInfoSize(PChar(FileName), Handle);
   if Size > 0 then
    try
       GetMem(Buffer, Size);
       if GetFileVersionInfo(PChar(FileName), Handle, Size, Buffer) then
         VerQueryValue(Buffer, '\VarFileInfo\Translation', P, Size);
       if P <> nil then
        begin
          GetTranslationString := IntToHex(MakeLong(HiWord(Longint(P^)), LoWord(Longint(P^))), 8);
          GetTranslationString  :=  '\StringFileInfo\' + GetTranslationString + '\FileVersion';
          if VerQueryValue(Buffer, PChar(GetTranslationString), P, Size) then
            SetString(Result, PChar(P), Size-1 );
        end;
    finally
      Freemem(Buffer);
    end;
end;

begin
  //ReportMemoryLeaksOnShutdown := true;
  ApplicationName := Format(ApplicationNameDef, [FileVersion(ParamStr(0))]);
  InitConsole('REPLICATION V.'+FileVersion(ParamStr(0)));
  OnConsolteTerminate := @OnTerminate;
  try
//    for I := 0 to 12 do
//      PanelUpdateValue(I, I.ToString);
    CRTTimer := TCRTTimer.Create;


    RDBM := TRDBM.Create(nil);
    try
      RDBM.ReConnect;
      CRTTimer.Srart;
    except
      RDBM.Free;
      raise;
    end;
//    CRTTimer.Add(0, idxValueMasterUtime, -1, nil, false, nil);
//    CRTTimer.Add(0, idxValueSlaveUTime, -1, nil, false, nil);

    while not ConsoleTerminate do
      begin
        readln;
      end;
    FinalizeConsole;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  CRTTimer.Free;
  readln;
end.
