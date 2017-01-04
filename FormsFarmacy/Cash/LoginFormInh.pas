unit LoginFormInh;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, LoginForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  cxPropertiesStore, Vcl.StdCtrls, cxButtons, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxLabel, dsdDB;

type
  TLoginForm1 = class(TLoginForm)
    cxLabel4: TcxLabel;
    edFarmacyName: TcxComboBox;
    spChekFarmacyName: TdsdStoredProc;
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginForm1: TLoginForm1;

implementation

uses  Storage, Authentication, CommonData, MessagesUnit, StrUtils, LocalWorkUnit, IniUtils;

{$R *.dfm}

procedure TLoginForm1.btnOkClick(Sender: TObject);
begin
 inherited;
 if ModalResult <> mrOk then exit;
 spChekFarmacyName.ParamByName('AFarmacyName').Value:= iniLocalFarmacyName(edFarmacyName.Text);
 spChekFarmacyName.Execute;
 if  spChekFarmacyName.ParamByName('AFarmacyName').Value = 'no' then
    ModalResult:=mrCancel;
end;

procedure TLoginForm1.FormShow(Sender: TObject);
begin
  inherited;
 edFarmacyName.Text:= iniLocalFarmacyName('');
if edFarmacyName.Text<>'' then
edFarmacyName.Enabled:=False;
end;

end.
