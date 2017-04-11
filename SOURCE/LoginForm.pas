unit LoginForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus, cxLabel, Vcl.StdCtrls,
  cxButtons, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxPropertiesStore,
  dxSkinsCore, dxSkinsDefaultPainters;

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
    FAllowLocalConnect: Boolean;
    FOnlyLocal: Boolean;
    function GetUsers: string;
    procedure SetUsers(const Value: string);
    procedure SetAllowLocalConnect(Value: Boolean);
  public
    property AllowLocalConnect: Boolean read FAllowLocalConnect write SetAllowLocalConnect;
  published
    property Users: string read GetUsers write SetUsers;
  end;

implementation

{$R *.dfm}

uses
  Storage, Authentication, CommonData, MessagesUnit, StrUtils, LocalWorkUnit;

procedure TLoginForm.btnOkClick(Sender: TObject);
var TextMessage,EMessage: String;
begin
  try
    if not FOnlyLocal then
    Begin
      TAuthentication.CheckLogin(TStorageFactory.GetStorage, edUserName.Text,
        edPassword.Text, gc_User, not FAllowLocalConnect);
      if assigned(gc_User) then
      Begin
        if edUserName.Properties.Items.IndexOf(edUserName.Text) = -1 then
           edUserName.Properties.Items.Add(edUserName.Text);
        if FAllowLocalConnect then
          SaveLocalConnect(edUserName.Text, edPassword.Text, gc_User.Session);
        ModalResult := mrOk;
      End
      else
        FOnlyLocal := FAllowLocalConnect;
    End;
    if FOnlyLocal then
    Begin
      if CheckLocalConnect(edUserName.Text, edPassword.Text, gc_User) then
      Begin
        ModalResult := mrOk;
        exit;
      End;
    End;
  except
    on E: Exception do
    begin
      if (pos('connect timed out', AnsilowerCase(E.Message)) > 0) and
         FAllowLocalConnect then
      Begin
        if CheckLocalConnect(edUserName.Text, edPassword.Text, gc_User) then
        Begin
          ModalResult := mrOk;
          exit;
        End
        else
          FOnlyLocal := True;
      End
      else
      Begin
        if pos('context', AnsilowerCase(E.Message)) = 0 then
           TextMessage := E.Message
        else
           // ����������� ��� ��� ����� Context
           TextMessage := Copy(E.Message, 1, pos('context', AnsilowerCase(E.Message)) - 1);
        TextMessage := ReplaceStr(TextMessage, 'ERROR:', '������:');
        EMessage := E.Message;
        TMessagesForm.Create(nil).Execute(TextMessage, EMessage);
      End;
    end;
  end;
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
  cxPropertiesStore.RestoreFrom;

  AllowLocalConnect := False;
  FOnlyLocal := False;

end;

function TLoginForm.GetUsers: string;
begin
  result := edUserName.Properties.Items.Text
end;

procedure TLoginForm.SetAllowLocalConnect(Value: Boolean);
begin
  FAllowLocalConnect := Value;
  gc_allowLocalConnection := Value;
end;

procedure TLoginForm.SetUsers(const Value: string);
begin
  edUserName.Properties.Items.Text := Value
end;

end.
//� ��� ������ ���� �������� ���������
