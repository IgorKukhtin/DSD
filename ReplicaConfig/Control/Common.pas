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
* Common.pas - common unit                                                     *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit Common;

interface
uses
  Winapi.Windows,
  System.Classes;
implementation

var
  fonts: array [1..4] of THandle;
function LoadResourceFontByName(const ResourceName: string; ResType: PChar; font: PHandle) : Boolean;
var
  ResStream : TResourceStream;
  FontsCount : DWORD;
  f: THandle;
begin
  ResStream := TResourceStream.Create(hInstance, ResourceName, ResType);
  try
    f := AddFontMemResourceEx(ResStream.Memory, ResStream.Size, nil, @FontsCount);
    if font <> nil then
      font^ := f;
    Result := f <> 0;
  finally
    ResStream.Free;
  end;
end;

function LoadResourceFontByID(ResourceID: Integer; ResType: PChar; font: PHandle): Boolean;
var
  ResStream : TResourceStream;
  FontsCount : DWORD;
  f: THandle;
begin
  ResStream := TResourceStream.CreateFromID(hInstance, ResourceID, ResType);
  try
    f := AddFontMemResourceEx(ResStream.Memory, ResStream.Size, nil, @FontsCount);
    if font <> nil then
      font^ := f;
    Result := f <> 0;
  finally
    ResStream.Free;
  end;
end;

procedure Init;
var
  I: Integer;
begin
  for I := 1 to Length(fonts) do
    LoadResourceFontByID(i, RT_FONT, @fonts[i]);
end;

procedure Finish;
var
  I: Integer;
begin
  for I := 1 to Length(fonts) do
    if fonts[i] <> 0 then
      RemoveFontMemResourceEx(fonts[i]);
end;

initialization
  Init;
finalization
  Finish;

end.
