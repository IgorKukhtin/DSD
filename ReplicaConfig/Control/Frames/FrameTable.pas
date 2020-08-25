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
* FrameTable.pas - unit   print tables                                         *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit FrameTable;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameList, Vcl.StdCtrls, Vcl.Grids,
  Vcl.ExtCtrls, RDBClass, RDBGridProvider, RDBGrid;

type
  TTableFrame = class(TListFrame)
  private
    { Private declarations }
    function GetTableList(Kind: TMapKind): TMetaTableList;
    procedure SetTableList(Kind: TMapKind; const Value: TMetaTableList);
  protected
    function GetProviderClass: TMetaListProviderClass; override;
  public
    { Public declarations }
    property TableList[Kind: TMapKind]: TMetaTableList read GetTableList write SetTableList;
  end;

var
  TableFrame: TTableFrame;

implementation

{$R *.dfm}

{ TTableFrame }

function TTableFrame.GetProviderClass: TMetaListProviderClass;
begin
  Result := TMetaTablesProvider
end;

function TTableFrame.GetTableList(Kind: TMapKind): TMetaTableList;
begin
  Result := TMetaTableList(TMetaListProvider(GetProvider(Kind)).list);
end;

procedure TTableFrame.SetTableList(Kind: TMapKind; const Value: TMetaTableList);
begin
  TMetaListProvider(GetProvider(Kind)).list := Value;
end;

end.
