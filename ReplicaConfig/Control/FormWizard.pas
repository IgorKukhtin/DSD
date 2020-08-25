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
* FormWizard.pas - unit form wizard replication. Under dev                     *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit FormWizard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameList, FrameSchema, FrameTable,
  RDBClass, GenData;

type
  TWizardForm = class(TForm)
    SchemaFrame: TSchemaFrame;
    TableFrame: TTableFrame;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FTables: array [TMapKind] of TMetaTableList;
  public
    { Public declarations }
    procedure Reinit(kinds: TMetaTableKinds);
  end;

var
  WizardForm: TWizardForm;

implementation

{$R *.dfm}

{ TWizardForm }

procedure TWizardForm.FormCreate(Sender: TObject);
begin
  FTables[mkMaster] := TMetaTableList.Create(false);
  FTables[mkSlave] := TMetaTableList.Create(false);
end;

procedure TWizardForm.FormDestroy(Sender: TObject);
begin
  FTables[mkMaster].Free;
  FTables[mkSlave].Free;

end;

procedure TWizardForm.Reinit(kinds: TMetaTableKinds);
var
  i, j: Integer;
  list: TMetaTableList;
begin
  SchemaFrame.SchemaList[mkMaster] := nil;
  SchemaFrame.SchemaList[mkSlave] := nil;
  SchemaFrame.SchemaList[mkMaster] := Schemas[mkMaster];
  SchemaFrame.SchemaList[mkSlave] := Schemas[mkSlave];
  SchemaFrame.ResetFilter(mkMaster);
  SchemaFrame.ResetFilter(mkSlave);
  for I := 0 to Schemas[mkMaster].Count-1 do
    begin
      list := Schemas[mkMaster][i].Tables;
      for j := 0 to list.Count-1 do
        if list[j].Kind in kinds then
          FTables[mkMaster].Add(list[j])
    end;
  TableFrame.TableList[mkMaster] := FTables[mkMaster];
  for I := 0 to Schemas[mkSlave].Count-1 do
    begin
      list := Schemas[mkSlave][i].Tables;
      for j := 0 to list.Count-1 do
        if list[j].Kind in kinds then
          FTables[mkSlave].Add(list[j])
    end;
  TableFrame.TableList[mkSlave] := FTables[mkSlave];
  SchemaFrame.lblMaster.Caption := 'Schema master';
  SchemaFrame.lblSlave.Caption := 'Schema slave';
  TableFrame.lblMaster.Caption := 'Table master';
  TableFrame.lblSlave.Caption := 'Table slave';
end;

end.
