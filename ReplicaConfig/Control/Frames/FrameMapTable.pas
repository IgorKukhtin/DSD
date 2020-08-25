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
* FrameMapTable.pas - unit  print map table                                    *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit FrameMapTable;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls,
  Vcl.ExtCtrls, RDBClass, RDBGridProvider, RDBGrid;

type
  TMapFrame = class(TFrame)
    GridPanel: TGridPanel;
    lblMaster: TLabel;
    lblSlave: TLabel;
    dgMaster: TDrawGrid;
    edSlaveSearch: TEdit;
    edMasterSeatch: TEdit;
    dgFields: TDrawGrid;
    procedure edMasterSeatchChange(Sender: TObject);
  private
    { Private declarations }
    FProviderMap: TMapMetaListProvider;
    FProviderFlds: TMapFieldsProvider;
    function GetMapList: TMapMetaTableList;
    procedure SetMapList(const Value: TMapMetaTableList);
    function GetMap: TMapMeta;
  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    property MapList: TMapMetaTableList read GetMapList write SetMapList;
    property Map: TMapMeta read GetMap;
  end;

implementation

{$R *.dfm}

constructor TMapFrame.Create(Owner: TComponent);
begin
  inherited;
  FProviderFlds := TMapFieldsProvider.Create(nil);
  FProviderFlds.Grid := dgFields;
  FProviderMap := TMapMetaListProvider.Create(nil, nil);
  FProviderMap.Details := FProviderFlds;
  FProviderMap.Grid := dgMaster;
end;

destructor TMapFrame.Destroy;
begin
  FProviderFlds.Free;
  FProviderMap.Free;
  inherited;
end;

procedure TMapFrame.edMasterSeatchChange(Sender: TObject);
var
  i: Integer;
  s: string;
  list: TMapMetaTableList;
  grid: TDrawGrid;
  kind: TMapKind;
begin
  if Sender = edMasterSeatch then
    begin
      s := edMasterSeatch.Text;
      kind := mkMaster;
    end
  else
    begin
      s := edSlaveSearch.Text;
      kind := mkSlave;
    end;
  list:= GetMapList;
  grid := dgMaster;
  for I := 0 to list.Count-1 do
    if list[i].Tables[kind].Name.StartsWith(s, true) then
      begin
        grid.Row := i + 1;
        break;
      end;
end;

function TMapFrame.GetMap: TMapMeta;
begin
  Result :=  FProviderFlds.Map;
end;

function TMapFrame.GetMapList(): TMapMetaTableList;
begin
  Result := TMapMetaTableList(FProviderMap.List)
end;

procedure TMapFrame.SetMapList(const Value: TMapMetaTableList);
begin
  FProviderMap.List := Value;
end;

end.
