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
    //procedure LoadCashFormTest;
    procedure LoadAccountFormTest;
    procedure LoadBankFormTest;
    procedure LoadBankAccountFormTest;
    procedure LoadBankAccountDocumentFormTest;
    procedure LoadBankStatementFormTest;
    procedure LoadCashRegisterFormTest;
    procedure LoadCheckFormTest;
    procedure LoadContactPersonFormTest;
    procedure LoadContractFormTest;
    procedure LoadCurrencyFormTest;
    procedure LoadDefaultFormTest;
    procedure LoadEnumFormTest;
    procedure LoadGoodsGroupFormTest;
    procedure LoadGoodsFormTest;
    procedure LoadImportSettingsFormTest;
    procedure LoadImportTypeFormTest;
    procedure LoadIncomeFormTest;
    procedure LoadInfoMoneyGroupFormTest;
    procedure LoadInfoMoneyDestinationFormTest;
    procedure LoadInfoMoneyFormTest;
    procedure LoadJuridicalFormTest;
    procedure LoadLoadFormTest;
    procedure LoadLossDebtFormTest;
    procedure LoadMargineCategory;
    procedure LoadMeasureFormTest;
    procedure LoadMemberFormTest;
    procedure LoadOrderInternalFormTest;
    procedure LoadOrderExternalFormTest;
    procedure LoadObjectUnionFormTest;
    procedure LoadPriceListFormTest;
    procedure LoadProfitLossFormTest;
    procedure LoadProfitLossGroupFormTest;
    procedure LoadProfitLossDirectionFormTest;
    procedure LoadReportFormTest;
    procedure LoadRetailFormTest;
    procedure LoadReturnTypeFormTest;
    procedure LoadReturnOutFormTest;
    procedure LoadServiceFormTest;
    procedure LoadSendOnPriceFormTest;
    procedure LoadUnitFormTest;
    procedure LoadAdditionalGoodsFormTest;
    procedure LoadPriceFormTest;
    procedure LoadAlternativeGroupFormTest;
    procedure LoadCheckVIPFormTest;
    procedure LoadCheckDeferredFormTest;
    procedure LoadPaidTypeFormTest;
    procedure LoadInventoryJournalFormTest;
    procedure LoadInventoryFormTest;
    procedure LoadLossJournalFormTest;
    procedure LoadLossFormTest;
    procedure LoadArticleLossEditFormTest;
    procedure LoadArticleLossFormTest;
    procedure LoadSendJournalFormTest;
    procedure LoadSendFormTest;
    procedure LoadCreateOrderFromMCSFormTest;
    procedure LoadReportSoldParamsFormTest;
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

procedure TLoadFormTest.LoadDefaultFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSetUserDefaultsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSetUserDefaultsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDefaultsKeyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDefaultsKeyForm');
end;

procedure TLoadFormTest.LoadAccountFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountGroup_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountGroup_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountGroupEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountDirectionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountDirectionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountDirection_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountDirection_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountDirectionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountDirectionEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccount_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccount_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountEditForm');
end;

procedure TLoadFormTest.LoadBankFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankEditForm');
end;

procedure TLoadFormTest.LoadBankStatementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankStatementJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankStatementJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankStatementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankStatementForm');
end;

procedure TLoadFormTest.LoadBankAccountDocumentFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountJournalFarmacyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountJournalFarmacyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountMovementFarmacyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountMovementFarmacyForm');
end;

procedure TLoadFormTest.LoadBankAccountFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccount_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccount_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountEditForm');
end;

//procedure TLoadFormTest.LoadCashFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMainCashForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TMainCashForm');
//end;

procedure TLoadFormTest.LoadCashRegisterFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashRegisterForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashRegisterForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashRegisterEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashRegisterEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashRegisterKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashRegisterKindForm');
end;

procedure TLoadFormTest.LoadCheckFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckJournalUserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckJournalUserForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckForm');
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

procedure TLoadFormTest.LoadCreateOrderFromMCSFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCreateOrderFromMCSForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCreateOrderFromMCSForm');
end;

procedure TLoadFormTest.LoadCurrencyFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrency_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrency_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyValue_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyValue_ObjectForm');

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

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionGoodsChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionGoodsChoiceForm');

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

procedure TLoadFormTest.LoadMargineCategory;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginCategoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginCategoryForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginCategoryItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginCategoryItemForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginCategoryLinkForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginCategoryLinkForm');
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

procedure TLoadFormTest.LoadLossDebtFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossDebtForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossDebtForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossDebtJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossDebtJournalForm');
end;

procedure TLoadFormTest.LoadReportFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportOrderGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReportOrderGoodsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BalanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_BalanceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalSoldForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalSoldForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalCollationForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalCollationForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsRemainsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsRemainsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsPartionMoveForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsPartionMoveForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportMovementCheckForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReportMovementCheckForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsPartionHistoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsPartionHistoryForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SoldForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SoldForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Sold_DayForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Sold_DayForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Sold_DayUserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Sold_DayUserForm');
end;

procedure TLoadFormTest.LoadReportSoldParamsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportSoldParamsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReportSoldParamsForm');
end;

procedure TLoadFormTest.LoadRetailFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRetailForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRetailEditForm');
end;

procedure TLoadFormTest.LoadReturnOutFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnOutForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnOutForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnOutJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnOutJournalForm');
end;

procedure TLoadFormTest.LoadReturnTypeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnTypeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnTypeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnTypeEditForm');
end;

procedure TLoadFormTest.LoadJuridicalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridical_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridical_ObjectForm');
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
procedure TLoadFormTest.LoadProfitLossGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossGroup_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossGroup_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossGroupEditForm');
end;

procedure TLoadFormTest.LoadProfitLossDirectionFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossDirectionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossDirectionForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossDirection_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossDirection_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossDirectionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossDirectionEditForm');
end;

procedure TLoadFormTest.LoadProfitLossFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLoss_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLoss_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossEditForm');
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

procedure TLoadFormTest.LoadOrderInternalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalLiteForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalLiteForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalJournalForm');
end;

procedure TLoadFormTest.LoadObjectUnionFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMoneyPlace_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMoneyPlace_ObjectForm');
end;

procedure TLoadFormTest.LoadOrderExternalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalJournalForm');
end;

procedure TLoadFormTest.LoadInfoMoneyGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyGroup_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyGroup_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyGroupEditForm');
end;


procedure TLoadFormTest.LoadInventoryFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryForm');
end;

procedure TLoadFormTest.LoadInventoryJournalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryJournalForm');
end;

procedure TLoadFormTest.LoadLossFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossForm');
end;

procedure TLoadFormTest.LoadLossJournalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossJournalForm');
end;

procedure TLoadFormTest.LoadArticleLossFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TArticleLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TArticleLossForm');
end;

procedure TLoadFormTest.LoadArticleLossEditFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TArticleLossEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TArticleLossEditForm');
end;

procedure TLoadFormTest.LoadInfoMoneyDestinationFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyDestinationForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyDestinationForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyDestination_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyDestination_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyDestinationEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyDestinationEditForm');
end;

procedure TLoadFormTest.LoadInfoMoneyFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoney_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoney_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyEditForm');
end;

procedure TLoadFormTest.LoadIncomeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomePharmacyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomePharmacyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomePharmacyJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomePharmacyJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeJournalChoiceForm');
end;

procedure TLoadFormTest.LoadAdditionalGoodsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAdditionalGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAdditionalGoodsForm');
end;

procedure TLoadFormTest.LoadPriceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMCSForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMCSForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRecalcMCS_DialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRecalcMCS_DialogForm');
end;

procedure TLoadFormTest.LoadAlternativeGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAlternativeGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAlternativeGroupForm');
end;

procedure TLoadFormTest.LoadCheckVIPFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckVIPForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckVIPForm');
end;

procedure TLoadFormTest.LoadPaidTypeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPaidTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPaidTypeForm');
end;

procedure TLoadFormTest.LoadCheckDeferredFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckDeferredForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckDeferredForm');
end;

procedure TLoadFormTest.LoadPriceListFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListJournalForm');
end;

procedure TLoadFormTest.LoadSendFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendForm');
end;

procedure TLoadFormTest.LoadSendJournalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendJournalForm');
end;

procedure TLoadFormTest.LoadSendOnPriceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendOnPriceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendOnPriceJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendOnPriceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendOnPriceForm');
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

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TActionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TActionForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserProtocolForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProcessForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProcessForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProtocolForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementProtocolForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportExportLinkForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportExportLinkForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportExportLinkTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportExportLinkTypeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemContainerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementItemContainerForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementDescDataForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementDescDataForm');

  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStatusForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStatusForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementItemProtocolForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPeriodCloseForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPeriodCloseForm');
  }
end;


initialization
  TestFramework.RegisterTest('Загрузка форм', TLoadFormTest.Suite);


end.
