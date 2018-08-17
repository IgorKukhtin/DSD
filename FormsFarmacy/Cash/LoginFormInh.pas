unit LoginFormInh;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, LoginForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  cxPropertiesStore, Vcl.StdCtrls, cxButtons, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxLabel, dsdDB, dxSkinsCore, dxSkinsDefaultPainters;

type
  TcxComboBoxUser = Class(TcxComboBox)
  private
    function GetUsers: string;
    procedure SetUsers(const Value: string);
  published
    property Users: string read GetUsers write SetUsers;
  end;

  TcxComboBox = Class(TcxComboBoxUser)
  end;

  TLoginForm1 = class(TLoginForm)
    cxLabel4: TcxLabel;
    edFarmacyName: TcxComboBox;
    spChekFarmacyName: TdsdStoredProc;
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginForm1: TLoginForm1;

implementation

uses Storage, Authentication, CommonData, MessagesUnit, StrUtils, LocalWorkUnit,
  IniUtils;

{$R *.dfm}

{ TcxComboBoxUser }

function TcxComboBoxUser.GetUsers: string;
begin
  result := Properties.Items.Text
end;

procedure TcxComboBoxUser.SetUsers(const Value: string);
begin
  if Value <> '' then Properties.Items.Text := Value
end;

{ TLoginForm1 }
procedure TLoginForm1.btnOkClick(Sender: TObject);
begin
  inherited;
  // сохраняем авторизационные данные для запуска сервиса + для вывода в MainForm
  IniUtils.gUnitId    := 0;
  IniUtils.gUnitName  := edFarmacyName.Text;
  IniUtils.gUserName  := edUserName.Text;
  IniUtils.gPassValue := edPassword.Text;

  if ModalResult <> mrOk then exit;

  //только для On-line режима 10.04.2017
  if not gc_User.Local then
  begin
      spChekFarmacyName.ParamByName('inUnitName').Value := edFarmacyName.Text;
      try spChekFarmacyName.Execute;
          IniUtils.gUnitId    := spChekFarmacyName.ParamByName('outUnitId').Value;
          //
          if spChekFarmacyName.ParamByName('outIsEnter').Value = FALSE
          then ModalResult := mrCancel
          else if edFarmacyName.Enabled then iniLocalUnitNameSave(edFarmacyName.Text);
      except ON E: Exception do
          Begin
             Application.OnException(Application.MainForm,E);
             ModalResult := mrNone;
          End;
      end;
  end;

end;

procedure TLoginForm1.FormCreate(Sender: TObject);
begin
  inherited;
  edFarmacyName.Text := iniLocalUnitNameGet;
end;

procedure TLoginForm1.FormShow(Sender: TObject);
begin
  inherited;
  ActiveControl:=edUserName;
  //
  edFarmacyName.Text := iniLocalUnitNameGet;
  if edFarmacyName.Text <> '' then
    edFarmacyName.Enabled := False // Поле заполняется один раз
  else
    ActiveControl:=edFarmacyName;
end;

end.
