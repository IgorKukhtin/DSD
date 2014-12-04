unit LoadFarmacyFormTest;

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
    procedure LoadContactPersonFormTest;
    procedure LoadContractFormTest;
    procedure LoadDefaultFormTest;
    procedure LoadEnumFormTest;
    procedure LoadGoodsGroupFormTest;
    procedure LoadGoodsFormTest;
    procedure LoadImportSettingsFormTest;
    procedure LoadImportTypeFormTest;
    procedure LoadIncomeFormTest;
    procedure LoadJuridicalFormTest;
    procedure LoadLoadFormTest;
    procedure LoadMeasureFormTest;
    procedure LoadMemberFormTest;
    procedure LoadOrderInternalFormTest;
    procedure LoadOrderExternalFormTest;
    procedure LoadPriceListFormTest;
    procedure LoadReportFormTest;
    procedure LoadRetailFormTest;
    procedure LoadServiceFormTest;
    procedure LoadUnitFormTest;
    procedure LoadAdditionalGoodsFormTest;
    procedure FormTest;
  end;

implementation

uses CommonData, Storage, FormStorage, Classes, Authentication, SysUtils,
     cxPropertiesStore, cxStorage, DBClient, dsdDB, ActionTest, MainForm;

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

procedure TLoadFormTest.LoadDefaultFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSetUserDefaultsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSetUserDefaultsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDefaultsKeyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDefaultsKeyForm');
end;

procedure TLoadFormTest.LoadContactPersonFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContactPersonForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContactPersonEditForm');
  //  Вид контакта
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContactPersonKindForm');
end;

procedure TLoadFormTest.LoadContractFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractEditForm');
end;

procedure TLoadFormTest.LoadGoodsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsMainForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsMainForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsMainEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsMainEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsLiteForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsLiteForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsMainLiteForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsMainLiteForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPartnerCodeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsPartnerCodeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPartnerCodeMasterForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsPartnerCodeMasterForm');
end;

procedure TLoadFormTest.LoadMemberFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMember_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMember_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberEditForm');
end;

procedure TLoadFormTest.LoadMeasureFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMeasureForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMeasureForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMeasureEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMeasureEditForm');
end;

procedure TLoadFormTest.LoadGoodsGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupEditForm');
end;

procedure TLoadFormTest.LoadLoadFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListLoadForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListLoadForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListItemsLoadForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListItemsLoadForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementLoadForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovenentLoadForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemsLoadForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementItemsLoadForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChoiceGoodsFromPriceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChoiceGoodsFromPriceListForm');
end;

procedure TLoadFormTest.LoadReportFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportOrderGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReportOrderGoodsForm');
end;

procedure TLoadFormTest.LoadRetailFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRetailForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRetailEditForm');
end;

procedure TLoadFormTest.LoadJuridicalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerCodeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerCodeForm');
end;

procedure TLoadFormTest.LoadImportTypeFormTest;
begin
  //Типы импорта
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportTypeForm');
end;

procedure TLoadFormTest.LoadImportSettingsFormTest;
begin
  //Настройки импорта
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportSettingsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportSettingsForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportGroupForm');
end;

procedure TLoadFormTest.LoadUnitFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitTreeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitTreeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnit_ObjectForm');
end;

procedure TLoadFormTest.LoadEnumFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TNDSKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TNDSKindForm');
  // Типы файлов
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFileTypeKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFileTypeKindForm');
  // Типы заказов
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderKindEditForm');
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
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;

procedure TLoadFormTest.LoadOrderInternalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalJournalForm');
end;

procedure TLoadFormTest.LoadOrderExternalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalJournalForm');
end;

procedure TLoadFormTest.LoadIncomeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeJournalForm');
end;

procedure TLoadFormTest.LoadAdditionalGoodsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAdditionalGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAdditionalGoodsForm');
end;

procedure TLoadFormTest.LoadPriceListFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListJournalForm');
end;

procedure TLoadFormTest.LoadServiceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFormsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFormsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TObjectDescForm'));
  TdsdFormStorageFactory.GetStorage.Load('TObjectDescForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoleEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnionDescForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnionDescForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserKeyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserKeyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLoadObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLoadObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceGroupSettingsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceGroupSettingsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalSettingsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalSettingsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalSettingsPriceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalSettingsPriceListForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TActionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TActionForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserProtocolForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProcessForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProcessForm');
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStatusForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStatusForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProtocolForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemContainerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementItemContainerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementDescDataForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementDescDataForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementProtocolForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementItemProtocolForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPeriodCloseForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPeriodCloseForm');
  }
end;


initialization
  TestFramework.RegisterTest('Загрузка форм', TLoadFormTest.Suite);


end.
