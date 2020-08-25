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
* FrameSchema.pas - unit  print schema                                         *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit FrameSchema;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameList, Vcl.StdCtrls, Vcl.Grids,
  Vcl.ExtCtrls, RDBClass, RDBGridProvider, RDBGrid;

type
  TSchemaFrame = class(TListFrame)
  private
    { Private declarations }
    function GetSchemaList(Kind: TMapKind): TMetaSchemaList;
    procedure SetSchemaList(Kind: TMapKind; const Value: TMetaSchemaList);
  protected
    function GetProviderClass: TMetaListProviderClass; override;
  public
    { Public declarations }
    property SchemaList[Kind: TMapKind]: TMetaSchemaList read GetSchemaList write SetSchemaList;
  end;

var
  SchemaFrame: TSchemaFrame;

implementation

{$R *.dfm}

{ TSchemaFrame }

function TSchemaFrame.GetProviderClass: TMetaListProviderClass;
begin
  Result := TMetaSchemasProvider
end;

function TSchemaFrame.GetSchemaList(Kind: TMapKind): TMetaSchemaList;
begin
  Result := TMetaSchemaList(TMetaListProvider(GetProvider(Kind)).list);
end;

procedure TSchemaFrame.SetSchemaList(Kind: TMapKind;
  const Value: TMetaSchemaList);
begin
  ResetFilter(mkMaster);
  ResetFilter(mkSlave);
  TMetaListProvider(GetProvider(Kind)).list := Value;
end;

end.
