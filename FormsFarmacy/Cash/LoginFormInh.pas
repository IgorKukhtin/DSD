unit LoginFormInh;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, LoginForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  cxPropertiesStore, Vcl.StdCtrls, cxButtons, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxLabel, dsdDB, dxSkinsCore, dxSkinsDefaultPainters, cxClasses,
  System.Actions, Vcl.ActnList, dsdAction, UtilConst;

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
    spGetUnitName: TdsdStoredProc;
    ActionList1: TActionList;
    actLoginAdmin: TAction;
    FormParams: TdsdFormParams;
    spGet_User_IsAdmin: TdsdStoredProc;
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actLoginAdminExecute(Sender: TObject);
  private
    { Private declarations }
    FUnitCode : Integer;
    FReRegistration : Boolean;
  public
    { Public declarations }
  end;

var
  LoginForm1: TLoginForm1;

implementation

uses Storage, Authentication, CommonData, MessagesUnit, StrUtils, LocalWorkUnit,
  IniUtils, UnitTreeCash;

{$R *.dfm}

{ TcxComboBoxUser }

function TcxComboBoxUser.GetUsers: string;
begin
  result := Properties.Items.Text
end;

procedure TcxComboBoxUser.SetUsers(const Value: string);
  var ItemList : String;
begin
  if dsdProject = prFarmacy then
  begin
    try
      ItemList := TAuthentication.GetLoginList(TStorageFactory.GetStorage);
      if ItemList <> '' then
      begin
        Properties.Items.Text := ItemList;
        Exit;
      end;
    except
    end;
  end;

  if Value <> '' then Properties.Items.Text := Value
end;

{ TLoginForm1 }
procedure TLoginForm1.actLoginAdminExecute(Sender: TObject);
begin
  if not FReRegistration then
  begin
    FReRegistration := True;
    edFarmacyName.Enabled := False;
    edFarmacyName.Text := 'Перерегистрация аптеки';
    Caption := 'Вход в систему с перерегистрацией';
  end else
  begin
    FReRegistration := False;
    edFarmacyName.Text := iniLocalUnitNameGet;
    FUnitCode := iniLocalUnitCodeGet;
    if (edFarmacyName.Text = '') and (FUnitCode = 0) then
    begin
      edFarmacyName.Enabled := True;
      ActiveControl:=edFarmacyName;
    end;
    Caption := 'Вход в систему';
  end;
end;

procedure TLoginForm1.btnOkClick(Sender: TObject);
begin
  inherited;
  // сохраняем авторизационные данные для запуска сервиса + для вывода в MainForm

  if ModalResult <> mrOk then exit;

  if FReRegistration then
  begin
    if not gc_User.Local  then
    begin
      try
        spGet_User_IsAdmin.Execute;
        if spGet_User_IsAdmin.ParamByName('gpGet_User_IsAdmin').Value = True then
        begin
           with TUnitTreeCashForm.Create(Application) do
           begin
             try
               actRefresh.Execute;
               if (ShowModal = mrOk) and (ClientDataSet.RecordCount > 0) then
               begin
                 iniLocalUnitCodeSave(ClientDataSet.FieldByName('Code').AsInteger);
                 iniLocalUnitNameSave(ClientDataSet.FieldByName('Name').AsString);
                 edFarmacyName.Text := iniLocalUnitNameGet;
                 FUnitCode := iniLocalUnitCodeGet;
               end else
               begin
                 Self.ModalResult := mrNone;
                 Exit;
               end;
             finally
               Free;
             end;
           end;
        end else
        begin
          edFarmacyName.Text := iniLocalUnitNameGet;
          ShowMessage('Перерегистрация доступна только администратору.');
        end;
      except ON E: Exception do
          Begin
             Application.OnException(Application.MainForm,E);
             ModalResult := mrNone;
          End;
      end;
    end else edFarmacyName.Text := iniLocalUnitNameGet;;
  end;

  IniUtils.gUnitId    := 0;
  IniUtils.gUnitName  := edFarmacyName.Text;
  IniUtils.gUserName  := edUserName.Text;
  IniUtils.gUserCode  := 0;
  IniUtils.gUnitCode  := FUnitCode;
  IniUtils.gPassValue := edPassword.Text;

  if ModalResult <> mrOk then exit;

  //только для On-line режима 10.04.2017
  if not gc_User.Local then
  begin
      spChekFarmacyName.ParamByName('inUnitCode').Value := FUnitCode;
      spChekFarmacyName.ParamByName('inUnitName').Value := edFarmacyName.Text;
      try spChekFarmacyName.Execute;
          IniUtils.gUnitId    := spChekFarmacyName.ParamByName('outUnitId').Value;
          IniUtils.gUnitName  := spChekFarmacyName.ParamByName('outUnitName').Value;
          IniUtils.gUnitCode  := spChekFarmacyName.ParamByName('outUnitCode').Value;
          IniUtils.gUserCode  := spChekFarmacyName.ParamByName('outUserCode').Value;
          //
          if spChekFarmacyName.ParamByName('outIsEnter').Value = FALSE
          then ModalResult := mrCancel
          else
          begin
            if FUnitCode = 0 then iniLocalUnitCodeSave(spChekFarmacyName.ParamByName('outUnitCode').Value);
            if edFarmacyName.Enabled then iniLocalUnitNameSave(edFarmacyName.Text)
            else if edFarmacyName.Text <> spChekFarmacyName.ParamByName('outUnitName').Value then
              iniLocalUnitNameSave(spChekFarmacyName.ParamByName('outUnitName').Value);
          end;
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
  FUnitCode := iniLocalUnitCodeGet;
  FReRegistration := False;
end;

procedure TLoginForm1.FormShow(Sender: TObject);
begin
  inherited;
  ActiveControl:=edUserName;
  //
  edFarmacyName.Text := iniLocalUnitNameGet;
  FUnitCode := iniLocalUnitCodeGet;
  if (edFarmacyName.Text <> '') or (FUnitCode <> 0) then
    edFarmacyName.Enabled := False // Поле заполняется один раз
  else
    ActiveControl:=edFarmacyName;
end;

end.
