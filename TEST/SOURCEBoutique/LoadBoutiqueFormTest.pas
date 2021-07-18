unit LoadBoutiqueFormTest;

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
//    procedure LoadBankFormTest;
//    procedure LoadBankAccountFormTest;
//    procedure LoadBankAccountDocumentFormTest;
//    procedure LoadBankStatementFormTest;
//    procedure LoadCalendarFormTest;
//    procedure LoadCashRegisterFormTest;
//    procedure LoadChangeIncomePaymentKindFormTest;
//    procedure LoadChangeIncomePaymentFormTest;
//    procedure LoadCheckFormTest;
//    procedure LoadCheckDeferredFormTest;
//    procedure LoadCheckVIPFormTest;
//    procedure LoadConditionsKeepFormTest;
//    procedure LoadContactPersonFormTest;
//    procedure LoadContractFormTest;
//    procedure LoadCurrencyFormTest;
//    procedure LoadCreateOrderFromMCSFormTest;
//    procedure LoadDefaultFormTest;
//    procedure LoadDiscountFormTest;
//    procedure LoadEnumFormTest;
//    procedure LoadEmailFormTest;
//    procedure LoadEmailSettingsFormTest;
//    procedure LoadImportSettingsFormTest;
//    procedure LoadImportTypeFormTest;
    procedure LoadBankFormTest;
    procedure LoadBankAccountFormTest;
    procedure LoadBrandFormTest;
    procedure LoadCityFormTest;
    procedure LoadClientFormTest;
    procedure LoadCompositionGroupFormTest;
    procedure LoadCompositionFormTest;
    procedure LoadControlFormTest;
    procedure LoadCountryBrandFormTest;
    procedure LoadCurrencyMovementFormTest;
    procedure LoadCashFormTest;
    procedure LoadCashMovementFormTest;
    procedure LoadCurrencyFormTest;
    procedure LoadDiscountFormTest;
    procedure LoadDiscountToolsFormTest;
    procedure LoadDiscountPeriodFormTest;
    procedure LoadDiscountPeriodItemFormTest;
    procedure LoadDiscountKindFormTest;
    procedure LoadIncomeFormTest;
    procedure LoadInfoMoneyFormTest;
    procedure LoadInventoryFormTest;
    procedure LoadImportSettingsFormTest;
    procedure LoadImportTypeFormTest;
    procedure LoadFabrikaFormTest;
    procedure LoadGoodsFormTest;
    procedure LoadGoodsAccountFormTest;
    procedure LoadGoodsItemFormTest;
    procedure LoadGoodsInfoFormTest;

    procedure LoadGoodsSizeFormTest;
    procedure LoadGoodsGroupFormTest;
    procedure LoadGoodsPrintFormTest;

    procedure LoadJuridicalGroupFormTest;
    procedure LoadJuridicalFormTest;
    procedure LoadJuridicalBasisFormTest;
    procedure LoadLabelFormTest;
    procedure LoadLossFormTest;
    procedure LoadLineFabricaFormTest;
    procedure LoadMemberFormTest;
    procedure LoadMeasureFormTest;
    procedure LoadPeriodFormTest;
    procedure LoadPartnerFormTest;
    procedure LoadPartionGoodsFormTest;
    procedure LoadPositionFormTest;
    procedure LoadPersonalFormTest;
    procedure LoadPriceListFormTest;
    procedure LoadProfitLossDemoFormTest;
    procedure LoadReportFormTest;
    procedure LoadReportBalanceFormTest;
    procedure LoadReportOLAPFormTest;
    procedure LoadReportProfitDemoFormTest;
    procedure LoadReportProfitLossFormTest;
    procedure LoadReturnOutFormTest;
    procedure LoadReturnInFormTest;
    procedure LoadSaleFormTest;
    procedure LoadServiceFormTest;
    procedure LoadSendFormTest;
    procedure LoadObjectUnionFormTest;
    procedure LoadUnitFormTest;
    procedure FormTest;

//    procedure LoadKindFormTest;
//    procedure LoadOrderSheduleFormTest;
//    procedure LoadOrderInternalFormTest;
//    procedure LoadOrderExternalFormTest;

//    procedure LoadOverFormTest;
//    procedure LoadOverSettingsFormTest;
//    procedure LoadPaidKindFormTest;
//    procedure LoadPaidTypeFormTest;
//    procedure LoadPartnerMedicalFormTest;
//    procedure LoadPaymentFormTest;
//    procedure LoadPersonalFormTest;
//    procedure LoadPersonalGroupFormTest;
//    procedure LoadPositionEducationFormTest;
//    procedure LoadPriceListFormTest;
//    procedure LoadPriceFormTest;
    procedure LoadProfitLossFormTest;
    procedure LoadProfitLossGroupFormTest;
    procedure LoadProfitLossDirectionFormTest;
//    procedure LoadPromoFormTest;
//    procedure LoadPromoUnitFormTest;
//    procedure LoadReportPromoParamsFormTest;
//    procedure LoadReportSoldParamsFormTest;
//
//    procedure LoadReportForSiteTest;
//    procedure LoadReportUploadFormTest;
//    procedure LoadRepriceFormTest;
//    procedure LoadRetailFormTest;
//    procedure LoadReturnTypeFormTest;

//    procedure LoadSendOnPriceFormTest;
//    procedure LoadSPObjectFormTest;
//    procedure LoadSheetWorkTimeFormTest;
//    procedure LoadUnitFormTest;

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

//
//procedure TLoadFormTest.LoadDefaultFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSetUserDefaultsForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TSetUserDefaultsForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDefaultsKeyForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TDefaultsKeyForm');
//end;
//
//
//procedure TLoadFormTest.LoadDiscountFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountExternalForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TDiscountExternalForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountExternalEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TDiscountExternalEditForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountExternal_ObjectForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TDiscountExternal_ObjectForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountExternalToolsForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TDiscountExternalToolsForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountExternalToolsEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TDiscountExternalToolsEditForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountExternalTools_ObjectForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TDiscountExternalTools_ObjectForm');
//
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBarCodeForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TBarCodeForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBarCodeEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TBarCodeEditForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountCardForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TDiscountCardForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountCardEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TDiscountCardEditForm');
//end;
//
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

procedure TLoadFormTest.LoadBankAccountFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountEditForm');
end;

procedure TLoadFormTest.LoadBankFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankEditForm');
end;

procedure TLoadFormTest.LoadBrandFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBrandForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBrandForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBrandEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBrandEditForm');
end;

procedure TLoadFormTest.LoadCityFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCityForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCityForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCityEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCityEditForm');
end;

procedure TLoadFormTest.LoadClientFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TClientSMSForm'));
  TdsdFormStorageFactory.GetStorage.Load('TClientSMSForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TClientSMSDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TClientSMSDialogForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TClientForm'));
  TdsdFormStorageFactory.GetStorage.Load('TClientForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TClientEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TClientEditForm');
end;

procedure TLoadFormTest.LoadCompositionFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCompositionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCompositionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCompositionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCompositionEditForm');
end;

procedure TLoadFormTest.LoadCompositionGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCompositionGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCompositionGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCompositionGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCompositionGroupEditForm');
end;

procedure TLoadFormTest.LoadCountryBrandFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCountryBrandForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCountryBrandForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCountryBrandEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCountryBrandEditForm');
end;

 procedure TLoadFormTest.LoadCurrencyMovementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyMovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyJournalForm');
end;

procedure TLoadFormTest.LoadDiscountFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountEditForm');
end;

procedure TLoadFormTest.LoadDiscountKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountKindForm');
end;

procedure TLoadFormTest.LoadDiscountToolsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountToolsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountToolsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountToolsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountToolsEditForm');
end;

procedure TLoadFormTest.LoadDiscountPeriodFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountPeriodForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountPeriodForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountPeriodEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountPeriodEditForm');
end;

procedure TLoadFormTest.LoadDiscountPeriodItemFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountPeriodItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountPeriodItemForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountPersentDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountPersentDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountPeriodItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountPeriodItemForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountPeriodItemDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountPeriodItemDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountPeriodGoodsItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountPeriodGoodsItemForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountPeriodGoodsItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountPeriodGoodsItemEditForm');

end;

procedure TLoadFormTest.LoadImportTypeFormTest;
begin
  // Типы импорта
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportTypeForm');
end;

procedure TLoadFormTest.LoadImportSettingsFormTest;
begin
  // Настройки импорта
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportSettingsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportSettingsForm');
end;

procedure TLoadFormTest.LoadFabrikaFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFabrikaForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFabrikaForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFabrikaEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFabrikaEditForm');
end;



procedure TLoadFormTest.LoadGoodsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsTreeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsTreeForm');
end;

procedure TLoadFormTest.LoadGoodsGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroup_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroup_ObjectForm');
end;

procedure TLoadFormTest.LoadGoodsInfoFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsInfoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsInfoForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsInfoEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsInfoEditForm');
end;

procedure TLoadFormTest.LoadGoodsItemFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsItemForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsItemEditForm');
end;

procedure TLoadFormTest.LoadGoodsSizeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsSizeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsSizeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsSizeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsSizeEditForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsSizeChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsSizeChoiceForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsSizeChoicebyCodeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsSizeChoicebyCodeForm');
end;

procedure TLoadFormTest.LoadGoodsPrintFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPrintForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsPrintForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPrintChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsPrintChoiceForm');
end;

procedure TLoadFormTest.LoadJuridicalBasisFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalBasisForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalBasisForm');
end;

procedure TLoadFormTest.LoadJuridicalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalEditForm');
end;

procedure TLoadFormTest.LoadJuridicalGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalGroupEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalGroup_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalGroup_ObjectForm');
end;

procedure TLoadFormTest.LoadCashFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashEditForm');
end;

procedure TLoadFormTest.LoadCashMovementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashOperationForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashOperationForm');
end;

procedure TLoadFormTest.LoadLabelFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLabelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLabelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLabelEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLabelEditForm');
end;

procedure TLoadFormTest.LoadLineFabricaFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLineFabricaForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLineFabricaForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLineFabricaEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLineFabricaEditForm');
end;

procedure TLoadFormTest.LoadObjectUnionFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMoneyPlaceCash_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMoneyPlaceCash_ObjectForm');

end;
//
//procedure TLoadFormTest.LoadBankFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TBankForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TBankEditForm');
//end;
//
//procedure TLoadFormTest.LoadBankStatementFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankStatementJournalForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TBankStatementJournalForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankStatementForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TBankStatementForm');
//end;
//
//procedure TLoadFormTest.LoadBankAccountDocumentFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountJournalFarmacyForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TBankAccountJournalFarmacyForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountMovementFarmacyForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TBankAccountMovementFarmacyForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountJournalFarmacyDialogForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TBankAccountJournalFarmacyDialogForm');
//end;
//
//procedure TLoadFormTest.LoadBankAccountFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TBankAccountForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccount_ObjectForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TBankAccount_ObjectForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TBankAccountEditForm');
//end;
//
////procedure TLoadFormTest.LoadCashFormTest;
////begin
////  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMainCashForm'));
////  TdsdFormStorageFactory.GetStorage.Load('TMainCashForm');
////end;
//
//procedure TLoadFormTest.LoadCashRegisterFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashRegisterForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TCashRegisterForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashRegisterEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TCashRegisterEditForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashRegisterKindForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TCashRegisterKindForm');
//end;
//
//procedure TLoadFormTest.LoadCalendarFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCalendarForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TCalendarForm');
//end;
//
//procedure TLoadFormTest.LoadCheckFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckJournalForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TCheckJournalForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckJournalUserForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TCheckJournalUserForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TCheckForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckPrintDialogForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TCheckPrintDialogForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDataTimeDialogForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TDataTimeDialogForm');
//end;
//
//procedure TLoadFormTest.LoadConditionsKeepFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TConditionsKeepForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TConditionsKeepForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TConditionsKeepEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TConditionsKeepEditForm');
//end;
//
//procedure TLoadFormTest.LoadContactPersonFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TContactPersonForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TContactPersonEditForm');
//  //  Вид контакта
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonKindForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TContactPersonKindForm');
//  //это ж !!!Enum!!!
//  //TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonKindEditForm'));
//  //TdsdFormStorageFactory.GetStorage.Load('TContactPersonKindEditForm');
//end;
//
//procedure TLoadFormTest.LoadContractFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TContractForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TContractEditForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContract_ObjectForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TContract_ObjectForm');
//end;
//
//procedure TLoadFormTest.LoadCreateOrderFromMCSFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCreateOrderFromMCSForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TCreateOrderFromMCSForm');
//end;
//
//procedure TLoadFormTest.LoadCurrencyFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TCurrencyForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TCurrencyEditForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrency_ObjectForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TCurrency_ObjectForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyValue_ObjectForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TCurrencyValue_ObjectForm');
//
//end;
//
//
procedure TLoadFormTest.LoadMeasureFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMeasureForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMeasureForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMeasureEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMeasureEditForm');
end;

procedure TLoadFormTest.LoadMemberFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberEditForm');
end;

procedure TLoadFormTest.LoadPartionGoodsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionGoodsChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionGoodsChoiceForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_DialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPUnit_DialogForm');
end;

procedure TLoadFormTest.LoadPartnerFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPeriodYear_ChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPeriodYear_ChoiceForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerEditForm');
end;

procedure TLoadFormTest.LoadPeriodFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPeriodForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPeriodForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPeriodEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPeriodEditForm');
end;

procedure TLoadFormTest.LoadPersonalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalEditForm');
end;

procedure TLoadFormTest.LoadPriceListFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListItemForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListItemDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListItemDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListGoodsItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListGoodsItemForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListGoodsItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListGoodsItemEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListTaxDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListTaxDialogForm');
end;

procedure TLoadFormTest.LoadPositionFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionEditForm');
end;

//procedure TLoadFormTest.LoadKindFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWorkTimeKind_ObjectForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TWorkTimeKind_ObjectForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWorkTimeKindForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TWorkTimeKindForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TConfirmedKindForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TConfirmedKindForm');
//
//end;
//
//
//
procedure TLoadFormTest.LoadReportFormTest;
begin
{
  //Отчет остаток товара на дату
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_RemainsCurrent_onDateForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_RemainsCurrent_onDateForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_RemainsCurrent_onDateDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_RemainsCurrent_onDateDialogForm');
  exit;
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Sale_AnalysisAllForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Sale_AnalysisAllForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Sale_AnalysisForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Sale_AnalysisForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Sale_AnalysisDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Sale_AnalysisDialogForm');
  //exit;
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsCodeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsCodeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsCodeDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsCodeDialogForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OH_DiscountPeriodForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OH_DiscountPeriodForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OH_DiscountPeriodDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OH_DiscountPeriodDialogForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ReturnInForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ReturnInForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleDialogForm');
  //Движ. по покупателю
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CollationByClientForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CollationByClientForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CollationByClientDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CollationByClientDialogForm');
  //Движ. по покупателю
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MotionByClientForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MotionByClientForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MotionByClientDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MotionByClientDialogForm');
  //текущие долги
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ClientDebtForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ClientDebtForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ClientDebtDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ClientDebtDialogForm');
  //Report_GoodsMI_SaleReturnInForm

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleReturnInForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleReturnInForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleReturnInDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleReturnInDialogForm');
  //     exit;
  // Report_GoodsMI_Account
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_AccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_AccountForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_AccountDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_AccountDialogForm');

  //Отчет Остаток товара
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsDialogForm');
  }
  //Отчет Текущий остаток товара
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_RemainsCurrentForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_RemainsCurrentForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_RemainsCurrentDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_RemainsCurrentDialogForm');
  {
  //Отчет пл списанию
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MovementLossForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementLossDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MovementLossDialogForm');
  //Отчет Перемещение
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementSendForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MovementSendForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementSendDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MovementSendDialogForm');
  //Отчет Возврат поставщику
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementReturnOutForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MovementReturnOutForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementReturnOutDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MovementReturnOutDialogForm');
  //Отчет Приход от поставщика
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementIncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MovementIncomeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementIncomeDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MovementIncomeDialogForm');
  }
end;

procedure TLoadFormTest.LoadReportBalanceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BalanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_BalanceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BalanceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_BalanceDialogForm');
end;

procedure TLoadFormTest.LoadReportOLAPFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleOLAPForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleOLAPForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleOLAPDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleOLAPDialogForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleOLAP_AnalysisForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleOLAP_AnalysisForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleOLAP_AnalysisDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleOLAP_AnalysisDialogForm');
end;
 procedure TLoadFormTest.LoadProfitLossDemoFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossDemoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossDemoForm');
end;

procedure TLoadFormTest.LoadReportProfitDemoFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitDemoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitDemoForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitDemoPeriodForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitDemoPeriodForm');
end;

procedure TLoadFormTest.LoadReportProfitLossFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitLossPeriodForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitLossPeriodForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitLossPeriodDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitLossPeriodDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitLossForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitLossDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitLossDialogForm');
end;
//
//procedure TLoadFormTest.LoadReportForSiteTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsOnUnit_ForSiteForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsOnUnit_ForSiteForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsOnUnit_ForSiteDialogForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsOnUnit_ForSiteDialogForm');
//end;
//
//procedure TLoadFormTest.LoadReportSoldParamsFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportSoldParamsForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TReportSoldParamsForm');
//end;
//
//procedure TLoadFormTest.LoadReportPromoParamsFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportPromoParamsForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TReportPromoParamsForm');
//end;
//
//procedure TLoadFormTest.LoadReportUploadFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_UploadBaDMForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TReport_UploadBaDMForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_UploadOptimaForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TReport_UploadOptimaForm');
//end;
//
//procedure TLoadFormTest.LoadRepriceFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRepriceJournalForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TRepriceJournalForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRepriceForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TRepriceForm');
//end;
//
//procedure TLoadFormTest.LoadRetailFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TRetailForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TRetailEditForm');
//end;
//
procedure TLoadFormTest.LoadReturnOutFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnOutForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnOutForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnOutJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnOutJournalForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnOutPartnerDataDialogForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TReturnOutPartnerDataDialogForm');
end;
procedure TLoadFormTest.LoadSendFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendJournalForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountPeriodItemBySendDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountPeriodItemBySendDialogForm');
end;
procedure TLoadFormTest.LoadSaleFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaleTwoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaleTwoForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaleJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaleJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaleItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaleItemEditForm');
end;
procedure TLoadFormTest.LoadReturnInFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnInForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnInForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnInJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnInJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnInItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnInItemEditForm');
end;
//
//procedure TLoadFormTest.LoadReturnTypeFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnTypeForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TReturnTypeForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnTypeEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TReturnTypeEditForm');
//end;
//
//
//procedure TLoadFormTest.LoadImportTypeFormTest;
//begin
//  //Типы импорта
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportTypeForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TImportTypeForm');
//end;
//
//procedure TLoadFormTest.LoadImportSettingsFormTest;
//begin
//  //Настройки импорта
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportSettingsForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TImportSettingsForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportGroupForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TImportGroupForm');
//end;
//
//procedure TLoadFormTest.LoadUnitFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitTreeForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TUnitTreeForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TUnitEditForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_ObjectForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TUnit_ObjectForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitForFarmacyCashForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TUnitForFarmacyCashForm');
//end;
//
//procedure TLoadFormTest.LoadEnumFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TNDSKindForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TNDSKindForm');
//  // Типы файлов
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFileTypeKindForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TFileTypeKindForm');
//  // Типы заказов
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderKindForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TOrderKindForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderKindEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TOrderKindEditForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmailToolsForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TEmailToolsForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmailKindForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TEmailKindForm');
//
//end;
//
//procedure TLoadFormTest.LoadEmailSettingsFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmailSettingsForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TEmailSettingsForm');
//end;
//
//procedure TLoadFormTest.LoadEmailFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmailForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TEmailForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmailEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TEmailEditForm');
//end;
//
procedure TLoadFormTest.LoadProfitLossGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossGroup_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossGroup_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossGroupEditForm');
end;
//
procedure TLoadFormTest.LoadProfitLossDirectionFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossDirectionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossDirectionForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossDirection_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossDirection_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossDirectionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossDirectionEditForm');
end;
//
procedure TLoadFormTest.LoadProfitLossFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLoss_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLoss_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossEditForm');
end;
//
//procedure TLoadFormTest.LoadPromoFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoJournalForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPromoJournalForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPromoForm');
//end;
//
//procedure TLoadFormTest.LoadPromoUnitFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoUnitJournalForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPromoUnitJournalForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoUnitForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPromoUnitForm');
//end;

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
//
//procedure TLoadFormTest.LoadOrderSheduleFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderSheduleForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TOrderSheduleForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderSheduleEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TOrderSheduleEditForm');
//end;
//
//procedure TLoadFormTest.LoadOrderInternalFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalLiteForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalLiteForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalJournalForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalJournalForm');
//end;
//
//procedure TLoadFormTest.LoadObjectUnionFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMoneyPlace_ObjectForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TMoneyPlace_ObjectForm');
//end;
//
//procedure TLoadFormTest.LoadOrderExternalFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalJournalForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalJournalForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalJournalChoiceForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalJournalChoiceForm');
//end;
//
procedure TLoadFormTest.LoadInventoryFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryItemEditForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryPartionForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TInventoryPartionForm');
end;
//
procedure TLoadFormTest.LoadLossFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossForm');
end;

//
procedure TLoadFormTest.LoadInfoMoneyFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyGroupEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyGroup_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyGroup_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyDestinationEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyDestinationEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyDestinationForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyDestinationForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyDestination_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyDestination_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoney_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoney_ObjectForm');
end;

procedure TLoadFormTest.LoadControlFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Sale_ContainerErrorForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Sale_ContainerErrorForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Client_LastErrorForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Client_LastErrorForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Client_TotalErrorForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Client_TotalErrorForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Sale_TotalErrorForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Sale_TotalErrorForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsAccount_TotalErrorForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsAccount_TotalErrorForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ReturnIn_TotalErrorForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ReturnIn_TotalErrorForm');
end;

procedure TLoadFormTest.LoadGoodsAccountFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsAccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsAccountForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsAccountJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsAccountJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsAccountItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsAccountItemEditForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsAccount_ReturnInForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsAccount_ReturnInForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsAccount_ReturnInJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsAccount_ReturnInJournalForm');
end;
procedure TLoadFormTest.LoadIncomeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeItemEditForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeItemPriceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeItemPriceDialogForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomePharmacyJournalForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TIncomePharmacyJournalForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeJournalChoiceForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TIncomeJournalChoiceForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncome_AmountTroubleForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TIncome_AmountTroubleForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomePartnerDataDialogForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TIncomePartnerDataDialogForm');
end;
//
//procedure TLoadFormTest.LoadPriceFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPriceForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMCSForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TMCSForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMCS_LiteForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TMCS_LiteForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRecalcMCS_DialogForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TRecalcMCS_DialogForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceHistoryForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPriceHistoryForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceOnDateForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPriceOnDateForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceDialogForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPriceDialogForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceGoodsDialogForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPriceGoodsDialogForm');
//end;
//
//procedure TLoadFormTest.LoadCheckVIPFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckVIPForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TCheckVIPForm');
//  //
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckVIP_ErrorForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TCheckVIP_ErrorForm');
//end;
//
//procedure TLoadFormTest.LoadOverFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOverJournalForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TOverJournalForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOverForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TOverForm');
//end;
//
//procedure TLoadFormTest.LoadOverSettingsFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOverSettingsForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TOverSettingsForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOverSettingsEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TOverSettingsEditForm');
//end;
//
//procedure TLoadFormTest.LoadPaidKindFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPaidKindForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPaidKindForm');
//end;
//
//procedure TLoadFormTest.LoadPaidTypeFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPaidTypeForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPaidTypeForm');
//end;
//
// procedure TLoadFormTest.LoadPartnerMedicalFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerMedicalForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPartnerMedicalForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerMedicalEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPartnerMedicalEditForm');
//end;
//
//procedure TLoadFormTest.LoadPaymentFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPaymentJournalForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPaymentJournalForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPaymentForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPaymentForm');
//end;
//
//procedure TLoadFormTest.LoadPersonalFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPersonalForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPersonalEditForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonal_ObjectForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPersonal_ObjectForm');
//end;
//
//procedure TLoadFormTest.LoadPersonalGroupFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalGroupForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPersonalGroupForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalGroupEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPersonalGroupEditForm');
//end;
//
//procedure TLoadFormTest.LoadPositionEducationFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPositionForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPositionEditForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEducationForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TEducationForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEducationEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TEducationEditForm');
//end;
//
//
//procedure TLoadFormTest.LoadChangeIncomePaymentFormTest;
//begin
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChangeIncomePaymentJournalForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TChangeIncomePaymentJournalForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChangeIncomePaymentForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TChangeIncomePaymentForm');
//end;
//


//

//
procedure TLoadFormTest.LoadServiceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeKoeffEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeKoeffEditForm');
//
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
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProcessForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProcessForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProtocolForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementProtocolForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementItemProtocolForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportExportLinkForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TImportExportLinkForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportExportLinkTypeForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TImportExportLinkTypeForm');
//
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemContainerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementItemContainerForm');
//
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementDescDataForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementDescDataForm');
//
//
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovement_PeriodDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovement_PeriodDialogForm');
//
//  {
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStatusForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TStatusForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPeriodCloseForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPeriodCloseForm');
//  }
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

procedure TLoadFormTest.LoadCurrencyFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyEditForm');
end;

initialization
  TestFramework.RegisterTest('Загрузка форм', TLoadFormTest.Suite);


end.
