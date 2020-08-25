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
* FrameList.pas - base unit  print replication map
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit FrameList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls,
  Vcl.ExtCtrls, RDBClass, RDBGridProvider, RDBGrid;

type
  TListFrame = class(TFrame)
    GridPanel: TGridPanel;
    lblMaster: TLabel;
    lblSlave: TLabel;
    dgMaster: TDrawGrid;
    dgSlave: TDrawGrid;
    edMasterSearch: TEdit;
    edSlaveSearch: TEdit;
    procedure edMasterSearchChange(Sender: TObject);
  private
    { Private declarations }
     FProviders: array [TMapKind] of TMetaListProvider;
     FFilters:array [TMapKind] of TMetaClassList;
     FOrigins:array [TMapKind] of TMetaClassList;
  protected
    function GetProvider(kind: TMapKind): TMetaListProvider;
    function GetProviderClass: TMetaListProviderClass; virtual; abstract;
    function Locate(const Value: string; kind: TMapKind): Integer; virtual;
    function Filter(const Value: string; kind: TMapKind): Integer; virtual;

  public
    { Public declarations }
    procedure ResetFilter(kind: TMapKind);
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

constructor TListFrame.Create(Owner: TComponent);
begin
  inherited;
  FProviders[mkMaster] := GetProviderClass.Create(nil, nil);
  FProviders[mkSlave] := GetProviderClass.Create(nil, nil);
  FProviders[mkMaster].Grid := dgMaster;
  FProviders[mkSlave].Grid := dgSlave;
end;

destructor TListFrame.Destroy;
begin
  FProviders[mkMaster].Free;
  FProviders[mkSlave].Free;
  FFilters[mkMaster].Free;
  FFilters[mkSlave].Free;
  inherited;
end;

procedure TListFrame.edMasterSearchChange(Sender: TObject);
var
  i: Integer;
  grid: TDrawGrid;
begin
  if Sender = edMasterSearch then
    begin
      Filter(edMasterSearch.Text, mkMaster);
    end
  else
    begin
      Filter(edSlaveSearch.Text, mkSlave);
    end;
  exit;
  if Sender = edMasterSearch then
    begin
      i := Locate(edMasterSearch.Text, mkMaster);
      grid := dgMaster;
    end
  else
    begin
      i := Locate(edSlaveSearch.Text, mkSlave);
      grid := dgSlave;
    end;
  if i <> -1 then
    grid.Row := i + 1;
end;


function TListFrame.Filter(const Value: string; kind: TMapKind): Integer;
var
  fltr, orgn: TMetaClassList;
  I: Integer;
begin
  if not Assigned(FFilters[kind]) then
    begin
      FOrigins[kind] := FProviders[kind].list;
      FFilters[kind] := TMetaClassListClass(FOrigins[kind].ClassType).Create(false);
    end;

  ResetFilter(kind);
  fltr := FFilters[kind];
  orgn := FOrigins[kind];
  fltr.Clear;
  if Value <> '' then
    for I := 0 to orgn.Count-1 do
      if orgn[i].Name.Contains(Value) then
        fltr.Add(orgn[i]);
  if fltr.Count > 0 then
    FProviders[kind].list := FFilters[kind];
end;

function TListFrame.GetProvider(kind: TMapKind): TMetaListProvider;
begin
  Result := FProviders[kind]
end;

function TListFrame.Locate(const Value: string; kind: TMapKind): Integer;
var
  i: Integer;
  list: TMetaClassList;
begin
  list := FProviders[kind].list;
  Result := -1;
  for I := 0 to list.Count-1 do
    if list[i].Name.StartsWith(Value, true) then
      begin
        Result := i;
        break;
      end;
end;

procedure TListFrame.ResetFilter(kind: TMapKind);
begin
  if Assigned(FOrigins[kind]) then
    FProviders[kind].list := FOrigins[kind];

end;

end.
