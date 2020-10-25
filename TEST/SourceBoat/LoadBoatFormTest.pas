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
    procedure LoadTranslateWordFormTest;
    procedure LoadLanguageFormTest;
    procedure LoadBrandFormTest;
    procedure LoadClientFormTest;
    procedure LoadImportSettingsFormTest;
    procedure LoadImportTypeFormTest;
    procedure LoadMemberFormTest;
    procedure LoadPartnerFormTest;
    procedure LoadPersonalFormTest;
    procedure LoadPositionFormTest;
    procedure LoadProdColorFormTest;
    procedure LoadProdColorItemsFormTest;
    procedure LoadProdColorPatternFormTest;
    procedure LoadProdColorGroupFormTest;
    procedure LoadProdEngineFormTest;
    procedure LoadProdModelFormTest;
    procedure LoadProdOptionsFormTest;
    procedure LoadProdOptItemsFormTest;
    procedure LoadProdOptPatternFormTest;
    procedure LoadProductFormTest;
    procedure LoadUnitFormTest;
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
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TObjectDescForm'));
  TdsdFormStorageFactory.GetStorage.Load('TObjectDescForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoleEditForm');
//
//
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TActionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TActionForm');
//
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserProtocolForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProtocolForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementDescDataForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementDescDataForm');

end;

procedure TLoadFormTest.LoadTranslateWordFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTranslateWordForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTranslateWordForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTranslateWordEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTranslateWordEditForm');

end;

procedure TLoadFormTest.LoadLanguageFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLanguageForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLanguageForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLanguageEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLanguageEditForm');
end;

procedure TLoadFormTest.LoadBrandFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBrandForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBrandForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBrandEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBrandEditForm');
end;

procedure TLoadFormTest.LoadClientFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TClientForm'));
  TdsdFormStorageFactory.GetStorage.Load('TClientForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TClientEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TClientEditForm');
end;

procedure TLoadFormTest.LoadMemberFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberEditForm');
end;

procedure TLoadFormTest.LoadPartnerFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerEditForm');
end;

procedure TLoadFormTest.LoadPersonalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalEditForm');
end;

procedure TLoadFormTest.LoadPositionFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionEditForm');
end;

procedure TLoadFormTest.LoadProdColorFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdColorForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdColorForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdColorEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdColorEditForm');
end;

procedure TLoadFormTest.LoadProdColorItemsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdColorItemsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdColorItemsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdColorItemsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdColorItemsEditForm');
end;

procedure TLoadFormTest.LoadProdColorPatternFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdColorPatternForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdColorPatternForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdColorPatternEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdColorPatternEditForm');
end;
procedure TLoadFormTest.LoadProdColorGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdColorGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdColorGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdColorGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdColorGroupEditForm');
end;

procedure TLoadFormTest.LoadProdEngineFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdEngineForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdEngineForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdEngineEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdEngineEditForm');
end;

procedure TLoadFormTest.LoadProdModelFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdModelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdModelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdModelEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdModelEditForm');
end;

procedure TLoadFormTest.LoadProdOptionsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdOptionsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdOptionsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdOptionsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdOptionsEditForm');
end;

procedure TLoadFormTest.LoadProdOptItemsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdOptItemsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdOptItemsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdOptItemsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdOptItemsEditForm');
end;

procedure TLoadFormTest.LoadProdOptPatternFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdOptPatternForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdOptPatternForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdOptPatternEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdOptPatternEditForm');
end;

procedure TLoadFormTest.LoadProductFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductEditForm');
end;

procedure TLoadFormTest.LoadUnitFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitEditForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnit_ObjectForm');
end;

procedure TLoadFormTest.LoadImportSettingsFormTest;
begin
  // Настройки импорта
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportSettingsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportSettingsForm');
end;

procedure TLoadFormTest.LoadImportTypeFormTest;
begin
  // Типы импорта
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportTypeForm');
end;

initialization
  TestFramework.RegisterTest('Загрузка форм', TLoadFormTest.Suite);


end.
