unit FormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TForm2 = class(TForm)
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses cxPropertiesStore, cxControls, cxContainer, cxEdit, cxGroupBox,
  dxBevel, cxButtons, cxGridDBTableView, cxGrid, DB, DBClient,
  dsdDataSetWrapperUnit, dxBar, Vcl.ActnList, dsdActionUnit;

{$R *.dfm}
procedure TForm2.FormShow(Sender: TObject);
var
  i: integer;
begin
  for I := 0 to ComponentCount - 1 do
    if Components[i] is TdsdDataSetWrapper then
       (Components[i] as TdsdDataSetWrapper).Execute;
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
  RegisterClass (TdsdDataSetWrapper);
  RegisterClass (TdxBarManager);
  RegisterClass (TActionList);
  RegisterClass (TdsdDataSetRefresh);


end.
