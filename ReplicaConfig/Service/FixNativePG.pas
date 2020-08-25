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
* FixNativePG.pas - fix low-level access to postgress                          *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit FixNativePG;

interface
uses
  Winapi.Windows, System.Classes, System.SysUtils,
  FireDAC.Phys.PGWrapper, FireDAC.Phys.PGCli;

  type
    TPgParamEx = class(TPgParam)
    private
      FSilent: Boolean;
      class var BufferOffset: Integer;
      class var ValueRefOffset: Integer;
      function GetBuffer: Pointer;
      function GetValueRef: Pointer;
      procedure SetBuffer(const Value: Pointer);
      procedure SetValueRef(const Value: Pointer);
    protected

      procedure SetTypeOid(AValue: Oid); override;
    public

      class constructor Create;  // Executed automatically at program start
      property ValueRef : Pointer read GetValueRef write SetValueRef;
      property Buffer : Pointer read GetBuffer write SetBuffer;
      procedure SetTypeOidSilent(AValue: Oid);
    end;


    TPgParamsEx = class(TPgParams)
    protected
      function GetVariableClass: TPgVariableClass; override;
    end;


    procedure PatchPgParams(Params: TPgParams);
implementation
uses
  rtti;
procedure PatchPgParams(Params: TPgParams);
type
  PClass = ^TClass;
begin
  if Params.ClassType = TPgParams then
    PClass(Params)^ := TPgParamsEx;
end;

{ TPgParamEx }

class constructor TPgParamEx.Create;
var
  ctx: TRTTIContext;
begin
  ValueRefOffset := ctx.GetType(TPgParamEx).GetField('FValueRef').Offset;
  BufferOffset   := ctx.GetType(TPgParamEx).GetField('FBuffer').Offset;
end;

function TPgParamEx.GetBuffer: Pointer;
begin
  Result := PPointer(Pointer(NativeInt(Self) + BufferOffset))^;
end;

function TPgParamEx.GetValueRef: Pointer;
begin
  Result := PPointer(Pointer(NativeInt(Self) + ValueRefOffset))^;
end;

procedure TPgParamEx.SetBuffer(const Value: Pointer);
begin
  PPointer(Pointer(NativeInt(Self) + BufferOffset))^ := Value;
end;

procedure TPgParamEx.SetValueRef(const Value: Pointer);
begin
  PPointer(Pointer(NativeInt(Self) + ValueRefOffset))^ := Value;
end;

procedure TPgParamEx.SetTypeOid(AValue: Oid);
var
  p1, p2: Pointer;
begin
  if not FSilent then
    begin
      inherited;
      exit;
    end;

  p1 := Buffer;
  p2 := ValueRef;
  try
    Buffer := nil;
    ValueRef := nil;
    inherited;
  finally
    Buffer := p1;
    ValueRef := p2;
  end;

end;

procedure TPgParamEx.SetTypeOidSilent(AValue: Oid);
begin
  FSilent := true;
  try
    SetTypeOid(AValue);
  finally
    FSilent := false;
  end;
end;



{ TPgParamsEx }

function TPgParamsEx.GetVariableClass: TPgVariableClass;
begin
  Result := TPgParamEx;
end;


end.
