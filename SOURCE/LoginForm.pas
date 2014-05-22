unit LoginForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus, cxLabel, Vcl.StdCtrls,
  cxButtons, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxPropertiesStore,
  dxSkinsCore;

type
  TLoginForm = class(TForm)
    edUserName: TcxComboBox;
    edPassword: TcxTextEdit;
    btnOk: TcxButton;
    btnCancel: TcxButton;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxPropertiesStore: TcxPropertiesStore;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function GetUsers: string;
    procedure SetUsers(const Value: string);
  published
    property Users: string read GetUsers write SetUsers;
  end;

implementation

{$R *.dfm}

uses
  Storage, Authentication, CommonData;


procedure TLoginForm.btnOkClick(Sender: TObject);
begin
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, edUserName.Text, edPassword.Text, gc_User);
  if edUserName.Properties.Items.IndexOf(edUserName.Text) = -1 then
     edUserName.Properties.Items.Add(edUserName.Text);
  ModalResult := mrOk;
end;

procedure TLoginForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree
end;

procedure TLoginForm.FormCreate(Sender: TObject);
begin
  with cxPropertiesStore.Components.Add do begin
    Component := Self;
    Properties.Add('Users');
  end;
  cxPropertiesStore.RestoreFrom
end;

function TLoginForm.GetUsers: string;
begin
  result := edUserName.Properties.Items.Text
end;

procedure TLoginForm.SetUsers(const Value: string);
begin
  edUserName.Properties.Items.Text := Value
end;

end.
//А тут должна быть картинка программы
