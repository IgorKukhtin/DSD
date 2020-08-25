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
* FormMapResult.pas - unit form wizard-result replication. Under dev           *
*                                                                              *
* Last modified: 29.07.2020 17:49:30                                           *
* Author       : Pukhkiy Igor                                                  *
* Email        : nspytnik-programming@yahoo.com                                *
* www          :                                                               *
*                                                                              *
* File version: 0.0.0.1d                                                       *
*==============================================================================}
unit FormMapResult;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrameMapTable, Vcl.ExtCtrls,
  Vcl.StdCtrls, RDBClass, RDBGridProvider, RDBGrid, GenData;

type
  TMapResultForm = class(TForm)
    pnl: TPanel;
    MapFrame: TMapFrame;
    btnGenerateCustomIndex: TButton;
    mmAlter: TMemo;
    mmSelect: TMemo;
    mmUpdate: TMemo;
    mmInsert: TMemo;
    procedure MapFramedgMasterSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Reinit();
  end;

var
  MapResultForm: TMapResultForm;

implementation

{$R *.dfm}

procedure TMapResultForm.MapFramedgMasterSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  map: TMapMeta;
begin
  map := MapFrame.Map;
  if Assigned(Map) then
    begin
      mmAlter.Text :=  MapFrame.Map.SQLAlter[mkMaster];
      mmSelect.Text := MapFrame.Map.SQLSelect[mkMaster];
      mmUpdate.Text := MapFrame.Map.SQLUpdate[mkSlave];
      mmInsert.Text := MapFrame.Map.SQLInsert[mkSlave];
    end
  else
    begin
      mmAlter.Text :=  '';
      mmSelect.Text := '';
      mmUpdate.Text := '';
      mmInsert.Text := '';
    end;
end;

procedure TMapResultForm.Reinit();
begin
  MapFrame.MapList := nil;
  MapFrame.MapList := maps;
end;

end.
