unit LoadBoatFormTest;

interface

uses
  TestFramework, Forms;

type

  TLoadFormTest = class (TTestCase)
  private
    function GetForm(FormClass: string): TForm;
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
  published
    procedure MainFormTest;
    procedure LoadServiceFormTest;
    procedure FormTest;
  end;

implementation

uses CommonData, Storage, FormStorage, Classes, Authentication, SysUtils,
     cxPropertiesStore, cxStorage, DBClient, dsdDB, ActionTest, MainForm,
     UtilConst;

{ TLoadFormTest }

procedure TLoadFormTest.FormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTestForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTestForm');
end;

function TLoadFormTest.GetForm(FormClass: string): TForm;
begin
  if GetClass(FormClass) = nil then
     raise Exception.Create('Не зарегистрирован класс: ' + FormClass);
  Application.CreateForm(TComponentClass(GetClass(FormClass)), Result);
end;

procedure TLoadFormTest.MainFormTest;
var ActionDataSet: TClientDataSet;
    StoredProc: TdsdStoredProc;
    i: integer;
    Action: ActionTest.TAction;
begin
  // Здесь мы заполняем справочник Action
  // Получаем все Action из базы
  ActionDataSet := TClientDataSet.Create(nil);
  StoredProc := TdsdStoredProc.Create(nil);
  MainFormInstance := TMainForm.Create(nil);
  Action := ActionTest.TAction.Create;
  try
    StoredProc.DataSet := ActionDataSet;
    StoredProc.StoredProcName := 'gpSelect_Object_Action';
    StoredProc.Execute;
    // добавим тех, что нет
    with MainFormInstance.ActionList do
      for I := 0 to ActionCount - 1 do
          if not ActionDataSet.Locate('Name', Actions[i].Name, []) then
             Action.InsertUpdateAction(0, 0, Actions[i].Name);
  finally
    Action.Free;
    StoredProc.Free;
    ActionDataSet.Free;
    MainFormInstance.Free;
  end;
end;

procedure TLoadFormTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', gc_AdminPassword, gc_User);
end;

procedure TLoadFormTest.LoadServiceFormTest;
begin
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFormsForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TFormsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TObjectDescForm'));
  TdsdFormStorageFactory.GetStorage.Load('TObjectDescForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoleEditForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleUnionForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TRoleUnionForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnionDescForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TUnionDescForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserKeyForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TUserKeyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserEditForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLoadObjectForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TLoadObjectForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceGroupSettingsForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPriceGroupSettingsForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceGroupSettingsTopForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPriceGroupSettingsTopForm');

//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalSettingsForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TJuridicalSettingsForm');
//  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TActionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TActionForm');
//
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserProtocolForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProcessForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TProcessForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProtocolForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementProtocolForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TMovementProtocolForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemProtocolForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TMovementItemProtocolForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportExportLinkForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TImportExportLinkForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportExportLinkTypeForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TImportExportLinkTypeForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemContainerForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TMovementItemContainerForm');
//
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementDescDataForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementDescDataForm');
//
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovement_PeriodDialogForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TMovement_PeriodDialogForm');
//
//  {
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStatusForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TStatusForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPeriodCloseForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPeriodCloseForm');
//  }
end;

initialization
  TestFramework.RegisterTest('Загрузка форм', TLoadFormTest.Suite);


end.
