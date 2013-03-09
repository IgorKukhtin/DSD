unit FormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dsdDataSetWrapperUnit;

type
  TParentForm = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Execute(Params: TdsdParams);
  end;

implementation

uses cxPropertiesStore, cxControls, cxContainer, cxEdit, cxGroupBox,
  dxBevel, cxButtons, cxGridDBTableView, cxGrid, DB, DBClient,
  dxBar, Vcl.ActnList, dsdActionUnit, cxTextEdit, cxLabel,
  StdActns;

{$R *.dfm}

procedure TParentForm.Execute(Params: TdsdParams);
var
  i: integer;
begin
  for I := 0 to ComponentCount - 1 do
    if Components[i] is TdsdFormParams then
       (Components[i] as TdsdFormParams).Params.Assign(Params);

  for I := 0 to ComponentCount - 1 do begin
    if Components[i] is TdsdDataSetRefresh then
       (Components[i] as TdsdDataSetRefresh).Execute;
    if Components[i] is TcxPropertiesStore then
       (Components[i] as TcxPropertiesStore).RestoreFrom;
  end;
end;

initialization
  RegisterClass (TdxBevel);
  RegisterClass (TcxButton);
  RegisterClass (TcxGroupBox);
  RegisterClass (TcxGridDBTableView);
  RegisterClass (TcxGrid);
  RegisterClass (TcxPropertiesStore);
  RegisterClass (TDataSource);
  RegisterClass (TClientDataSet);
  RegisterClass (TdsdStoredProc);
  RegisterClass (TdxBarManager);
  RegisterClass (TActionList);
  RegisterClass (TdsdDataSetRefresh);
  RegisterClass (TdsdExecStoredProc);
  RegisterClass (TdsdOpenForm);
  RegisterClass (TcxTextEdit);
  RegisterClass (TcxLabel);
  RegisterClass (TFileExit);
  RegisterClass (TdsdFormParams);
  RegisterClass (TdsdFormClose);

end.
