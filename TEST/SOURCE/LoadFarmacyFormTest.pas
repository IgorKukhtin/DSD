unit LoadFarmacyFormTest;

interface

uses
  TestFramework, Forms;

type

  TLoadFormTest = class(TTestCase)
  private
    function GetForm(FormClass: string): TForm;
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
  published
    procedure MainFormTest;
    // procedure LoadCashFormTest;
    procedure LoadAccountFormTest;
    procedure LoadAdditionalGoodsFormTest;
    procedure LoadAlternativeGroupFormTest;
    procedure LoadArticleLossEditFormTest;
    procedure LoadArticleLossFormTest;
    procedure LoadAreaFormTest;
    procedure LoadBankFormTest;
    procedure LoadBankAccountFormTest;
    procedure LoadBankAccountDocumentFormTest;
    procedure LoadBankPOSTerminalFormTest;
    procedure LoadBankStatementFormTest;
    procedure LoadBuyerFormTest;
    procedure LoadCalendarFormTest;
    procedure LoadCancelReasonFormTest;
    procedure LoadCashRegisterFormTest;
    procedure LoadChangeIncomePaymentKindFormTest;
    procedure LoadChangeIncomePaymentFormTest;
    procedure LoadCheckFormTest;
    procedure LoadCheckDeferredFormTest;
    procedure LoadCheckVIPFormTest;
    procedure LoadCheckLiki24FormTest;
    procedure LoadCheckSiteFormTest;
    procedure LoadConditionsKeepFormTest;
    procedure LoadContactPersonFormTest;
    procedure LoadClientsByBankFormTest;
    procedure LoadComputerAccessoriesFormTest;
    procedure LoadContractFormTest;
    procedure LoadCreditLimitDistributorFormTest;
    procedure LoadCurrencyFormTest;
    procedure LoadCreateOrderFromMCSFormTest;
    procedure LoadDefaultFormTest;
    procedure LoadDiscountFormTest;
    procedure LoadDistributionPromoFormTest;
    procedure LoadDiffKindFormTest;
    procedure LoadDivisionPartiesFormTest;
    procedure LoadDriverTest;
    procedure LoadDriverSunTest;
    procedure LoadEnumFormTest;
    procedure LoadEmailFormTest;
    procedure LoadEmailSettingsFormTest;
    procedure LoadEmployeeScheduleFormTest;
    procedure LoadFinalSUAFormTest;
    procedure LoadFiscalFormTest;
    procedure LoadGoodsGroupFormTest;
    procedure LoadGoodsGroupPromoFormTest;
    procedure LoadGoodsFormTest;
    procedure LoadGoodsInventoryFormTest;
    procedure LoadGoodsCategoryFormTest;
    procedure LoadGoodsSPMovementFormTest;
    procedure LoadGoodsRepriceFormTest;
    procedure LoadHardwareFormTest;
    procedure LoadHouseholdInventoryFormTest;
    procedure LoadInventoryHouseholdInventoryFormTest;
    procedure LoadImportSettingsFormTest;
    procedure LoadImportTypeFormTest;
    procedure LoadIncomeFormTest;
    procedure LoadIncomeHouseholdInventoryFormTest;
    procedure LoadInfoMoneyGroupFormTest;
    procedure LoadInfoMoneyDestinationFormTest;
    procedure LoadInfoMoneyFormTest;
    procedure LoadInstructionsFormTest;
    procedure LoadInventoryFormTest;
    procedure LoadInvoiceFormTest;
    procedure LoadIlliquidUnitFormTest;
    procedure LoadJuridicalFormTest;
    procedure LoadJuridicalAreaFormTest;
    procedure LoadLayoutFormTest;
    procedure LoadLoadFormTest;
    procedure LoadLoyaltyFormTest;
    procedure LoadLoyaltyPresentFormTest;
    procedure LoadLoyaltySaveMoneyFormTest;
    procedure LoadLossDebtFormTest;
    procedure LoadLossFormTest;
    procedure LoadListDiffFormTest;
    procedure LoadMakerFormTest;
    procedure LoadMargineCategory;
    procedure LoadMarginCategoryMovement;
    procedure LoadMarginReport;
    procedure LoadMeasureFormTest;
    procedure LoadMemberFormTest;
    procedure LoadMemberIncomeCheckFormTest;
    procedure LoadMovementReportUnLiquidFormtest;
    procedure LoadKindFormTest;
    procedure LoadOrderSheduleFormTest;
    procedure LoadOrderInternalFormTest;
    procedure LoadOrderInternalPromoFormTest;
    procedure LoadOrderExternalFormTest;
    procedure LoadObjectUnionFormTest;
    procedure LoadOverFormTest;
    procedure LoadOverSettingsFormTest;
    procedure LoadPaidKindFormTest;
    procedure LoadPaidTypeFormTest;
    procedure LoadPartnerMedicalFormTest;
    procedure LoadPartionDateKindFormTest;
    procedure LoadPaymentFormTest;
    procedure LoadPermanentDiscountFormTest;
    procedure LoadPersonalFormTest;
    procedure LoadPersonalGroupFormTest;
    procedure LoadPlanIventoryFormTest;
    procedure LoadPositionEducationFormTest;
    procedure LoadPriceListFormTest;
    procedure LoadPriceFormTest;
    procedure LoadPriceChangeFormTest;
    procedure LoadProjectsImprovementsFormTest;
    procedure LoadProfitLossFormTest;
    procedure LoadProfitLossGroupFormTest;
    procedure LoadProfitLossDirectionFormTest;
    procedure LoadPromoFormTest;
    procedure LoadPromoCodeFormTest;
    procedure LoadPromoBonusFormTest;
    procedure LoadPromoUnitFormTest;
    procedure LoadProvinceCityFormTest;
    procedure LoadReasonDifferencesFormTest;
    procedure LoadRelatedProductFormTest;
    procedure LoadReportPromoParamsFormTest;
    procedure LoadReportSoldParamsFormTest;
    procedure LoadReportFormTest;
    procedure LoadRogerseFormTest;
    procedure LoadReportForSiteTest;
    procedure LoadReportUploadFormTest;
    procedure LoadRepriceFormTest;
    procedure LoadRepriceChangeFormTest;
    procedure LoadRetailFormTest;
    procedure LoadRetailCostCreditFormTest;
    procedure LoadReturnInFormTest;
    procedure LoadReturnTypeFormTest;
    procedure LoadReturnOutFormTest;
    procedure LoadSaleFormTest;
    procedure LoadServiceFormTest;
    procedure LoadSeasonalityCoefficientFormTest;
    procedure LoadSendFormTest;
    procedure LoadSendPartionDateFormTest;
    procedure LoadSendPartionDateChangeFormTest;
    procedure LoadSendOnPriceFormTest;
    procedure LoadSystemFormTest;
    procedure LoadSPObjectFormTest;
    procedure LoadSPKindFormTest;
    procedure LoadSheetWorkTimeFormTest;
    procedure LoadSunExclusionFormTest;
    procedure LoadTaxUnitFormTest;
    procedure LoadTechnicalRediscountFormTest;
    procedure LoadUnitFormTest;
    procedure LoadUnionFormTest;
    procedure LoadUnnamedEnterprisesFormTest;
    procedure LoadWagesFormTest;
    procedure LoadWriteOffHouseholdInventoryFormTest;
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

procedure TLoadFormTest.LoadDiscountFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountExternalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountExternalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountExternalEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountExternal_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountExternal_ObjectForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountExternalToolsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountExternalToolsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountExternalToolsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountExternalToolsEditForm');
  Exit;

  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TDiscountExternalTools_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountExternalTools_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TDiscountExternalJuridicalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountExternalJuridicalForm');
  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TDiscountExternalJuridicalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountExternalJuridicalEditForm');
}

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBarCodeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBarCodeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBarCodeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBarCodeEditForm');
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountCardForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountCardForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountCardEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountCardEditForm');}
end;

procedure TLoadFormTest.LoadDistributionPromoFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDistributionPromoJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDistributionPromoJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDistributionPromoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDistributionPromoForm');
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
  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TAccountDirection_ObjectForm'));
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

procedure TLoadFormTest.LoadAreaFormTest;
begin
  // Регионы
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAreaForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAreaForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAreaEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAreaEditForm');
end;

procedure TLoadFormTest.LoadDiffKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiffKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiffKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiffKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiffKindEditForm');
end;

procedure TLoadFormTest.LoadDivisionPartiesFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDivisionPartiesForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDivisionPartiesForm');
end;

procedure TLoadFormTest.LoadDriverTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDriverForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDriverForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDriverEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDriverEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitLincDriverForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitLincDriverForm');
end;

procedure TLoadFormTest.LoadDriverSunTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDriverSunForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDriverSunForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDriverSunEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDriverSunEditForm');
end;

procedure TLoadFormTest.LoadBankStatementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankStatementJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankStatementJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankStatementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankStatementForm');
end;

procedure TLoadFormTest.LoadBuyerFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBuyerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBuyerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBuyerEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBuyerEditForm');
end;

procedure TLoadFormTest.LoadBankAccountDocumentFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TBankAccountJournalFarmacyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountJournalFarmacyForm');
  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TBankAccountMovementFarmacyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountMovementFarmacyForm');

  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TBankAccountJournalFarmacyDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load
    ('TBankAccountJournalFarmacyDialogForm');
end;

procedure TLoadFormTest.LoadBankPOSTerminalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankPOSTerminalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankPOSTerminalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankPOSTerminalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankPOSTerminalEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitBankPOSTerminalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitBankPOSTerminalForm');
end;

procedure TLoadFormTest.LoadBankAccountFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountEditForm');
{  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccount_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccount_ObjectForm');}
end;

// procedure TLoadFormTest.LoadCashFormTest;
// begin
// TdsdFormStorageFactory.GetStorage.Save(GetForm('TMainCashForm'));
// TdsdFormStorageFactory.GetStorage.Load('TMainCashForm');
// end;

procedure TLoadFormTest.LoadCashRegisterFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsSP_CashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsSP_CashForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsUnitRetail_CashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsUnitRetail_CashForm');

{  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOverdueChangeCashPUSHSendForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOverdueChangeCashPUSHSendForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOverdueChangeCashJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOverdueChangeCashJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashRegisterForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashRegisterForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashRegisterEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashRegisterEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashRegisterKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashRegisterKindForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccommodationForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccommodationForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccommodationEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccommodationEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashGoodsOneToExpirationDateForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashGoodsOneToExpirationDateForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOverdueDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOverdueDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOverdueJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOverdueJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOverdue_UpdateRangeCat5DialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOverdue_UpdateRangeCat5DialogForm');
  }
end;

procedure TLoadFormTest.LoadCalendarFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCalendarForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCalendarForm');
end;

procedure TLoadFormTest.LoadCancelReasonFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCancelReasonEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCancelReasonEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCancelReasonForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCancelReasonForm');
end;

procedure TLoadFormTest.LoadCheckFormTest;
begin
{  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckSummCardForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckSummCardForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckJournalDiscountExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckJournalDiscountExternalForm');
  Exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberSPChoiceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberSPChoiceDialogForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckJournalUserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckJournalUserForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChoiceDeferredCheckForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChoiceDeferredCheckForm');
  exit;

  }

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckForm');
            {

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionGoodsListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionGoodsListForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJackdawsChecksForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJackdawsChecksForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJackdawsChecksEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJackdawsChecksEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckNoCashRegisterForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckNoCashRegisterForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckPrintDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckPrintDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDataTimeDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDataTimeDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheck_SPEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheck_SPEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckUnCompleteForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckUnCompleteForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashSummaForDeyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashSummaForDeyForm');
  }
end;

procedure TLoadFormTest.LoadConditionsKeepFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TConditionsKeepForm'));
  TdsdFormStorageFactory.GetStorage.Load('TConditionsKeepForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TConditionsKeepEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TConditionsKeepEditForm');
end;

procedure TLoadFormTest.LoadContactPersonFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContactPersonForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContactPersonEditForm');
  // Вид контакта
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContactPersonKindForm');
  // это ж !!!Enum!!!
  // TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonKindEditForm'));
  // TdsdFormStorageFactory.GetStorage.Load('TContactPersonKindEditForm');
end;

procedure TLoadFormTest.LoadClientsByBankFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TClientsByBankForm'));
  TdsdFormStorageFactory.GetStorage.Load('TClientsByBankForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TClientsByBankEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TClientsByBankEditForm');
end;

procedure TLoadFormTest.LoadComputerAccessoriesFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TComputerAccessoriesForm'));
  TdsdFormStorageFactory.GetStorage.Load('TComputerAccessoriesForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TComputerAccessoriesEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TComputerAccessoriesEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TComputerAccessoriesRegisterForm'));
  TdsdFormStorageFactory.GetStorage.Load('TComputerAccessoriesRegisterForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TComputerAccessoriesRegisterJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TComputerAccessoriesRegisterJournalForm');
end;

procedure TLoadFormTest.LoadContractFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractEditForm');
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContract_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContract_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractChoiceForm');
  }
end;

procedure TLoadFormTest.LoadCreateOrderFromMCSFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRecalcMCSShedulerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRecalcMCSShedulerForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRecalcMCSShedulerEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRecalcMCSShedulerEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRecalcMCSShedulerSunDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRecalcMCSShedulerSunDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeekForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeekForm');
  Exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCreateOrderFromMCSForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCreateOrderFromMCSForm');
end;

procedure TLoadFormTest.LoadCreditLimitDistributorFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCreditLimitDistributorForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCreditLimitDistributorForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCreditLimitDistributorEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCreditLimitDistributorEditForm');
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

procedure TLoadFormTest.LoadFinalSUAFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFinalSUAForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFinalSUAForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFinalSUAJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFinalSUAJournalForm');
end;

procedure TLoadFormTest.LoadFiscalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFiscalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFiscalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFiscalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFiscalEditForm');
end;

procedure TLoadFormTest.LoadGoodsInventoryFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsInventoryDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsInventoryDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsInventoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsInventoryForm');
end;

procedure TLoadFormTest.LoadGoodsCategoryFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsCategoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsCategoryForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsCategoryEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsCategoryEditForm');
end;

procedure TLoadFormTest.LoadGoodsFormTest;
begin
{    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoods_GoodsPairSun_EditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoods_GoodsPairSun_EditForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoods_LimitSUN_T_EditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoods_LimitSUN_T_EditForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoods_KoeffSUN_EditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoods_KoeffSUN_EditForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsRetailTab_ErrorForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsRetailTab_ErrorForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsMainTab_ErrorForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsMainTab_ErrorForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsAll_TabForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsAll_TabForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsAllRetail_TabForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsAllRetail_TabForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsRetailForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsRetailForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsRetailDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsRetailDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoods_BarCodeForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoods_BarCodeForm');
    //exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsAllForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsAllForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsAllRetailForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsAllRetailForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsAllJuridicalForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsAllJuridicalForm');
    //exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPartnerCodeForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsPartnerCodeForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPartnerCodeMasterForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsPartnerCodeMasterForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoods_NDS_diffForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoods_NDS_diffForm');
  }

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsEditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsEditForm');
     exit;
    {

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsTopDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsTopDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsAnalogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsAnalogForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsAnalogEditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsAnalogEditForm');


    TdsdFormStorageFactory.GetStorage.Save(GetForm('TExchangeForm'));
    TdsdFormStorageFactory.GetStorage.Load('TExchangeForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TExchangeEditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TExchangeEditForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsMainForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsMainForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsMainEditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsMainEditForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsLiteForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsLiteForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsMainLiteForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsMainLiteForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionGoodsChoiceForm'));
    TdsdFormStorageFactory.GetStorage.Load('TPartionGoodsChoiceForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsAllForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsAllForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsAllRetailForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsAllRetailForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsAllJuridicalForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsAllJuridicalForm');
  }
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

procedure TLoadFormTest.LoadMemberIncomeCheckFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberIncomeCheckForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberIncomeCheckForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberIncomeCheckEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberIncomeCheckEditForm');
end;

procedure TLoadFormTest.LoadMakerFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMakerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMakerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMakerEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMakerEditForm');

  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMakerReportEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMakerReportEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMaker_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMaker_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCountryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCountryForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCountryEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCountryEditForm');
  }
end;

procedure TLoadFormTest.LoadMargineCategory;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginCategory_AllForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginCategory_AllForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersentSalaryDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersentSalaryDialogForm');
  exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginCategoryAllDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginCategoryAllDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginCategoryItemHistoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginCategoryItemHistoryForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginCategoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginCategoryForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginCategoryEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginCategoryEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginCategoryItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginCategoryItemForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginCategoryLinkForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginCategoryLinkForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginCategory_CrossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginCategory_CrossForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginCategory_CrossDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginCategory_CrossDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginCategory_TotalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginCategory_TotalForm');
  }
end;

procedure TLoadFormTest.LoadMarginCategoryMovement;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginCategory_Movement2Form'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginCategory_Movement2Form');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginCategoryJournal2Form'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginCategoryJournal2Form');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginCategory_MovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginCategory_MovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginCategoryJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginCategoryJournalForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SAMP_AnalysisDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SAMP_AnalysisDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SAMP_AnalysisForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SAMP_AnalysisForm');
end;

procedure TLoadFormTest.LoadMarginReport;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginReportForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginReportForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMarginReportItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMarginReportItemForm');
end;

procedure TLoadFormTest.LoadMeasureFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMeasureForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMeasureForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMeasureEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMeasureEditForm');
end;

procedure TLoadFormTest.LoadKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWorkTimeKind_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWorkTimeKind_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWorkTimeKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWorkTimeKindForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TConfirmedKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TConfirmedKindForm');

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

procedure TLoadFormTest.LoadGoodsGroupPromoFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupPromoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupPromoForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupPromoEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupPromoEditForm');
end;

procedure TLoadFormTest.LoadLoadFormTest;
begin
    {
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListLoad_AddForm'));
    TdsdFormStorageFactory.GetStorage.Load('TPriceListLoad_AddForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListLoadForm'));
    TdsdFormStorageFactory.GetStorage.Load('TPriceListLoadForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListItemsLoadForm'));
    TdsdFormStorageFactory.GetStorage.Load('TPriceListItemsLoadForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementLoadForm'));
    TdsdFormStorageFactory.GetStorage.Load('TMovenentLoadForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemsLoadForm'));
    TdsdFormStorageFactory.GetStorage.Load('TMovementItemsLoadForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TChoiceGoodsFromPriceListForm'));
    TdsdFormStorageFactory.GetStorage.Load('TChoiceGoodsFromPriceListForm');
    exit;

  // отчет поиск товара по всей сети
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsFromRemainsSetPriceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsFromRemainsSetPriceDialogForm');
}
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChoiceGoodsFromRemainsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChoiceGoodsFromRemainsForm');
  exit;
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TColorForm'));
  TdsdFormStorageFactory.GetStorage.Load('TColorForm');
  exit;
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsBarCodeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsBarCodeForm');

end;

procedure TLoadFormTest.LoadLoyaltyFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLoyaltyJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLoyaltyJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLoyaltyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLoyaltyForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChoiceLoyaltyCheckForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChoiceLoyaltyCheckForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_LoyaltyDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_LoyaltyDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Loyalty_CreaturesPromocodeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Loyalty_CreaturesPromocodeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Loyalty_UsedPromocodeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Loyalty_UsedPromocodeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLoyaltyInsertPromoCodeDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLoyaltyInsertPromoCodeDialogForm');
end;

procedure TLoadFormTest.LoadLoyaltySaveMoneyFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLoyaltySaveMoneyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLoyaltySaveMoneyForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLoyaltySaveMoneyJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLoyaltySaveMoneyJournalForm');
end;

procedure TLoadFormTest.LoadLoyaltyPresentFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLoyaltyPresentJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLoyaltyPresentJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLoyaltyPresentForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLoyaltyPresentForm');
end;

procedure TLoadFormTest.LoadLossDebtFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossDebtForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossDebtForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossDebtJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossDebtJournalForm');
end;

procedure TLoadFormTest.LoadReasonDifferencesFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReasonDifferencesForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReasonDifferencesForm');
end;

procedure TLoadFormTest.LoadRelatedProductFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRelatedProductForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRelatedProductForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRelatedProductJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRelatedProductJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChoiceRelatedProductForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChoiceRelatedProductForm');
end;

procedure TLoadFormTest.LoadReportFormTest;
begin

{  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsPrice_PromoBonusForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsPrice_PromoBonusForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_UnitDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_UnitDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Reprice_PromoBonusForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Reprice_PromoBonusForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PriceCheckForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PriceCheckForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_Send_RemainsSun_SUAForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_Send_RemainsSun_SUAForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SalesOfTermDrugsDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SalesOfTermDrugsDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SalesOfTermDrugsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SalesOfTermDrugsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SalesOfTermDrugsUnitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SalesOfTermDrugsUnitForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SalesOfTermDrugsUserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SalesOfTermDrugsUserForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsRemainsUKTZEDDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsRemainsUKTZEDDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsRemainsUKTZEDForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsRemainsUKTZEDForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_Send_RemainsSun_UKTZEDForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_Send_RemainsSun_UKTZEDForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_QuantityComparisonForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Check_QuantityComparisonForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_QuantityComparisonDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Check_QuantityComparisonDialogForm');



  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementCheckSiteDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MovementCheckSiteDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementCheckSiteForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MovementCheckSiteForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ClippedReprice_SaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ClippedReprice_SaleForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SAUAForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SAUAForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TwoVendorBindingsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TwoVendorBindingsForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ResortsByLotForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ResortsByLotForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ResortsByLotDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ResortsByLotDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ArrivalWithoutSalesForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ArrivalWithoutSalesForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ArrivalWithoutSalesDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ArrivalWithoutSalesDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_FoundPositionsSUNForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_FoundPositionsSUNForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ChangeCommentsSUNForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ChangeCommentsSUNForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CommentSendSUNForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CommentSendSUNForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PositionsUKTVEDonSUNForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PositionsUKTVEDonSUNForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_LeftSendForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_LeftSendForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_CountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Check_CountForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_CountDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Check_CountDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderInternalPromo_DistributionCalculationForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderInternalPromo_DistributionCalculationForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PercentageOccupancySUNForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PercentageOccupancySUNForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_NumberChecksDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Check_NumberChecksDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_NumberChecksForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Check_NumberChecksForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_Send_RemainsSun_SupplementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_Send_RemainsSun_SupplementForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_RemainsOverGoods_NForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_RemainsOverGoods_NForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ImplementationPeriodForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ImplementationPeriodForm');
   exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_WillNotOrderForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_WillNotOrderForm');
   exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ImplementationPeriodForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ImplementationPeriodForm');


    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_IncomeVATBalanceForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_IncomeVATBalanceForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_IncomeSale_UseNDSKindForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_IncomeSale_UseNDSKindForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_IncomeSale_UseNDSKindDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_IncomeSale_UseNDSKindDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_NomenclaturePeriodForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_NomenclaturePeriodForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_NomenclaturePeriodDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_NomenclaturePeriodDialogForm');
    exit;


    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PharmacyPerformanceForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_PharmacyPerformanceForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PharmacyPerformanceDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_PharmacyPerformanceDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GeneralMovementGoodsForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GeneralMovementGoodsForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GeneralMovementGoodsDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GeneralMovementGoodsDialogForm');
    exit;


    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_EntryGoodsMovementDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_EntryGoodsMovementDialogForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_EntryGoodsMovementForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_EntryGoodsMovementForm');
    exit;
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalSalesForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalSalesForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalSalesDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalSalesDialogForm');
    exit;
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_InventoryErrorRemainsForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_InventoryErrorRemainsForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_InventoryErrorRemainsDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_InventoryErrorRemainsDialogForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_InventoryErrorRemainsDocForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_InventoryErrorRemainsDocForm');
    exit;


    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalRemainsForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalRemainsForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalRemainsDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalRemainsDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SendSUN_SUNv2Form'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_SendSUN_SUNv2Form');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SUNSaleDatesForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_SUNSaleDatesForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SUNSaleDatesDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_SUNSaleDatesDialogForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MoneyBoxSunForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MoneyBoxSunForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SendSUNLossDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_SendSUNLossDialogForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SendSUNLossForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_SendSUNLossForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SendSUNDelayForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_SendSUNDelayForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SendSUNDelayDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_SendSUNDelayDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_InventoryErrorRemainsForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_InventoryErrorRemainsForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_InventoryErrorRemainsDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_InventoryErrorRemainsDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_StockTiming_RemainderForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_StockTiming_RemainderForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_StockTiming_RemainderDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_StockTiming_RemainderDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementCheck_PromoDoctorsForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementCheck_PromoDoctorsForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementCheck_PromoEntrancesForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementCheck_PromoEntrancesForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PercentageOverdueSUNForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_PercentageOverdueSUNForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_IlliquidReductionPlanAllForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_IlliquidReductionPlanAllForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_IlliquidReductionPlanListForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_IlliquidReductionPlanListForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_IlliquidReductionPlanAllDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_IlliquidReductionPlanAllDialogForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_IlliquidReductionPlanUserForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_IlliquidReductionPlanUserForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_ReturnOutForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_ReturnOutForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_ReturnOutDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_ReturnOutDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitabilityForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitabilityForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitabilityDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitabilityDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementCheck_DiscountExternalForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementCheck_DiscountExternalForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_DiscountExternalDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_DiscountExternalDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckSUNForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_CheckSUNForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckSUNDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_CheckSUNDialogForm');
    exit;
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckSendSUN_InOutForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_CheckSendSUN_InOutForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckSendSUN_InOutDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_CheckSendSUN_InOutDialogForm');
   // exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BalanceGoodsSUNForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_BalanceGoodsSUNForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BalanceGoodsSUNDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_BalanceGoodsSUNDialogForm');
    exit;


    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PriceProtocolForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_PriceProtocolForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PriceProtocolDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_PriceProtocolDialogForm');
    //exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_Send_RemainsSun_piForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_Send_RemainsSun_piForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_Send_RemainsSun_expressForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_Send_RemainsSun_expressForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_Send_RemainsSunOut_expressForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_Send_RemainsSunOut_expressForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_Send_RemainsSun_expressDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_Send_RemainsSun_expressDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_Send_RemainsSunOutForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_Send_RemainsSunOutForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_Send_RemainsSunOut_express_v2Form'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_Send_RemainsSunOut_express_v2Form');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_Send_RemainsSun_expressv2DialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_Send_RemainsSun_expressv2DialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_Send_RemainsSunForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_Send_RemainsSunForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_Send_RemainsSunDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_Send_RemainsSunDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_Send_RemainsSunOutForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_Send_RemainsSunOutForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsPartionDate0Form'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsPartionDate0Form');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsPartionDate5Form'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsPartionDate5Form');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsPartionDate5DialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsPartionDate5DialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Send_RemainsSun_overForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Send_RemainsSun_overForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsSendSUNForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsSendSUNForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsSendSUNDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsSendSUNDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsRemainsCashForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsRemainsCashForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsRemainsCashDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsRemainsCashDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsPartionMoveCashForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsPartionMoveCashForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsPartionMoveCashDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsPartionMoveCashDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckPartionDateForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_CheckPartionDateForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckPartionDateDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_CheckPartionDateDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsPartionDate_PromoDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsPartionDate_PromoDialogForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsPartionDate_PromoForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsPartionDate_PromoForm');
    exit;
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsNotSalePastDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsNotSalePastDialogForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsNotSalePastForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsNotSalePastForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsPartionDateForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsPartionDateForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsPartionDateDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsPartionDateDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_ListDiffForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_ListDiffForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_ListDiffDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_ListDiffDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_GoodsPriceChangeForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Check_GoodsPriceChangeForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_GoodsPriceChangeDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Check_GoodsPriceChangeDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_IncomeSampleForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_IncomeSampleForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_IncomeSampleDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_IncomeSampleDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_PriceChangeForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Check_PriceChangeForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_PriceChangeDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Check_PriceChangeDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsRemainsCurrentForm'));
    TdsdFormStorageFactory.GetStorage.Load('TRReport_GoodsRemainsCurrentForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsRemainsCurrentDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TRReport_GoodsRemainsCurrentDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_UKTZEDDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Check_UKTZEDDialogForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_UKTZEDForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Check_UKTZEDForm');
    //exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MinPrice_byPromoDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MinPrice_byPromoDialogForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MinPrice_byPromoForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MinPrice_byPromoForm');
    // exit;

    // Остатки товара (ID товара другой сети)
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsRemains_AnotherRetailForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsRemains_AnotherRetailForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_AnotherRetailForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_AnotherRetailForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementIncome_byPromoDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementIncome_byPromoDialogForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementIncome_byPromoForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementIncome_byPromoForm');
    //exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportMovementCheckGrowthAndFallingForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReportMovementCheckGrowthAndFallingForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportMovementCheckGrowthAndFallingDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReportMovementCheckGrowthAndFallingDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_RatingForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Check_RatingForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_RatingDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Check_RatingDialogForm');
    //exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OverOrderForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_OverOrderForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OverOrderDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_OverOrderDialogForm');
    //exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_AssortmentForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Check_AssortmentdForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_AssortmentDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Check_AssortmentDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementPriceListForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementPriceListForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementPriceList_DialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementPriceList_DialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BadmForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_BadmForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_byReportBadmForm'));
    TdsdFormStorageFactory.GetStorage.Load('TUnit_byReportBadmForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MinPrice_onGoodsForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MinPrice_onGoodsForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MinPrice_onGoodsDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MinPrice_onGoodsDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckPromoForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_CheckPromoForm');


    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PeriodDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_PeriodDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PromoDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_PromoDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementCheck_PromoForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementCheck_PromoForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementIncome_PromoForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementIncome_PromoForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsRemainsForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsRemainsForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsRemainsDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsRemainsDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TOverdueChangeJournalForm'));
    TdsdFormStorageFactory.GetStorage.Load('TOverdueChangeJournalForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TOverdueChangeDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TOverdueChangeDialogForm');
    exit;


    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementCheckErrorForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementCheckErrorForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementCheckErrorDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementCheckErrorDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Payment_PlanForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Payment_PlanForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Payment_PlanDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Payment_PlanDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementCheck_UnLiquidForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementCheck_UnLiquidForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementCheck_UnLiquidDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementCheck_UnLiquidDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportOrderGoodsForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReportOrderGoodsForm');

    // отчет распределение остатков
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_RemainsOverGoodsForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_RemainsOverGoodsForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_RemainsOverGoodsDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_RemainsOverGoodsDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_RemainsOverGoods_ToForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_RemainsOverGoods_ToForm');
    exit;

    //Отчет Приход на точку
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementIncomeForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementIncomeForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementIncomeDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementIncomeDialogForm');

    //Отчет Приход на точку для фармацевта
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementIncomeFarmForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementIncomeFarmForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementIncomeFarmDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementIncomeFarmDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BalanceForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_BalanceForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalSoldForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalSoldForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalCollationForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalCollationForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalCollationSaldoForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalCollationSaldoForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsPartionMoveForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsPartionMoveForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsPartionMoveDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsPartionMoveDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementCheck_CrossForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementCheck_CrossForm');
    exit;

   TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsRemainsLightForm'));
    TdsdFormStorageFactory.GetStorage.Load('TRReport_GoodsRemainsLightForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsRemainsLightDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TRReport_GoodsRemainsLightDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportMovementCheckLightForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReportMovementCheckLightForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementChecLightDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementChecLightDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportMovementCheckForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReportMovementCheckForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementCheckDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementCheckDialogForm');

    // для фармацевта
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportMovementCheckFarmForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReportMovementCheckFarmForm');

    // Отчет по продажам на кассах физическим лицам
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportMovementCheckFLForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReportMovementCheckFLForm');

    // Отчет по выполнению плана продаж по сотруднику
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ImplementationPlanEmployeeAllForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_ImplementationPlanEmployeeAllForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TDataDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TDataDialogForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ImplementationPlanEmployeeDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_ImplementationPlanEmployeeDialogForm');


    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementCheckFarmDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementCheckFarmDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsPartionHistoryForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsPartionHistoryForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsPartionHistoryDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsPartionHistoryDialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SoldForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_SoldForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Sold_DayForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Sold_DayForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Sold_DayUserForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Sold_DayUserForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_ByPartionGoodsForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_ByPartionGoodsForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_WageForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_WageForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_WageDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_WageDialogForm');

    //отчет доходности
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitDialogForm');
    exit;

    // средний чек за период
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckMiddle_DetailForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_CheckMiddle_DetailForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckMiddle_DetailDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_CheckMiddle_DetailDialogForm');

    // средний чек
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportMovementCheckMiddleForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReportMovementCheckMiddleForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementCheckMiddleDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_MovementCheckMiddleDialogForm');

    //Отчет Ценовая интервенция
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PriceInterventionForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_PriceInterventionForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PriceInterventionDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_PriceInterventionDialogForm');
    //Отчет Ценовая интервенция2
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PriceIntervention2Form'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_PriceIntervention2Form');

    // отчет распределение остатков
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_RemainsOverGoodsForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_RemainsOverGoodsForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_RemainsOverGoodsDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_RemainsOverGoodsDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_LiquidityForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_LiquidityForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TOverdraftForm'));
    TdsdFormStorageFactory.GetStorage.Load('TOverdraftForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TOverdraftEditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TOverdraftEditForm');
  }
end;

procedure TLoadFormTest.LoadReportForSiteTest;
begin
  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TReport_GoodsOnUnit_ForSiteForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsOnUnit_ForSiteForm');

  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TReport_GoodsOnUnit_ForSiteDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load
    ('TReport_GoodsOnUnit_ForSiteDialogForm');
end;

procedure TLoadFormTest.LoadRogerseFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportRogersMovementCheckForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReportRogersMovementCheckForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRepriceRogersJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRepriceRogersJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRepriceRogersForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRepriceRogersForm');
end;

procedure TLoadFormTest.LoadReportSoldParamsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportSoldParamsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReportSoldParamsForm');
end;

procedure TLoadFormTest.LoadReportPromoParamsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportPromoParamsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReportPromoParamsForm');
end;

procedure TLoadFormTest.LoadReportUploadFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_UploadBaDMForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_UploadBaDMForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_UploadOptimaForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_UploadOptimaForm');
end;

procedure TLoadFormTest.LoadRepriceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRepriceUnitShedulerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRepriceUnitShedulerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRepriceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRepriceJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRepriceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRepriceForm');
end;

procedure TLoadFormTest.LoadMovementReportUnLiquidFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportUnLiquidJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReportUnLiquidJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportUnLiquid_MovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReportUnLiquid_MovementForm');
end;

procedure TLoadFormTest.LoadRepriceChangeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRepriceChangeJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRepriceChangeJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRepriceChangeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRepriceChangeForm');
end;

procedure TLoadFormTest.LoadRetailFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRetailForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRetailEditForm');
end;

procedure TLoadFormTest.LoadRetailCostCreditFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailCostCreditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRetailCostCreditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailCostCreditEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRetailCostCreditEditForm');
end;

procedure TLoadFormTest.LoadReturnOutFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnOutPharmacyJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnOutPharmacyJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnOutForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnOutForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnOutJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnOutJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnOutPartnerDataDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnOutPartnerDataDialogForm');
end;

procedure TLoadFormTest.LoadReturnTypeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnTypeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnTypeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnTypeEditForm');
end;

procedure TLoadFormTest.LoadIlliquidUnitFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIlliquidUnitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIlliquidUnitForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIlliquidUnitJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIlliquidUnitJournalForm');
end;

procedure TLoadFormTest.LoadLayoutFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLayoutForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLayoutForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLayoutEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLayoutEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLayout_MovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLayout_MovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLayoutJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLayoutJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLayoutJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLayoutJournalChoiceForm');
end;

procedure TLoadFormTest.LoadJuridicalFormTest;
begin
   TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalForm'));
   TdsdFormStorageFactory.GetStorage.Load('TJuridicalForm');
   TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalEditForm'));
   TdsdFormStorageFactory.GetStorage.Load('TJuridicalEditForm');

    {
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalCorporateForm'));
    TdsdFormStorageFactory.GetStorage.Load('TJuridicalCorporateForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridical_ObjectForm'));
    TdsdFormStorageFactory.GetStorage.Load('TJuridical_ObjectForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerCodeForm'));
    TdsdFormStorageFactory.GetStorage.Load('TPartnerCodeForm');

  // Адрес
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAddressForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAddressForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAddressEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAddressEditForm');

  // Юридический адрес поставщика
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalLegalAddressForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalLegalAddressForm');
  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TJuridicalLegalAddressEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalLegalAddressEditForm');

  // Фактический адрес поставщика
  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TJuridicalActualAddressForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalActualAddressForm');
  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TJuridicalActualAddressEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalActualAddressEditForm');
  }
end;

procedure TLoadFormTest.LoadJuridicalAreaFormTest;
begin
  // Регионы поставщиков
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalAreaForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalAreaForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalAreaEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalAreaEditForm');
end;

procedure TLoadFormTest.LoadImportTypeFormTest;
begin
  // Типы импорта
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportTypeForm');
end;

procedure TLoadFormTest.LoadImportSettingsFormTest;
begin
{
  // Настройки импорта
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportSettingsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportSettingsForm');
 }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportGroupEditForm');
end;

procedure TLoadFormTest.LoadGoodsRepriceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsRepriceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsRepriceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsRepriceEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsRepriceEditForm');
end;

procedure TLoadFormTest.LoadHardwareFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('THardwareForm'));
  TdsdFormStorageFactory.GetStorage.Load('THardwareForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('THardwareEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('THardwareEditForm');
end;

procedure TLoadFormTest.LoadHouseholdInventoryFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('THouseholdInventoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('THouseholdInventoryForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('THouseholdInventoryEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('THouseholdInventoryEditForm');
end;

procedure TLoadFormTest.LoadInventoryHouseholdInventoryFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryHouseholdInventoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryHouseholdInventoryForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryHouseholdInventoryJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryHouseholdInventoryJournalForm');
end;

procedure TLoadFormTest.LoadTaxUnitFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaxUnitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaxUnitForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaxUnitEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaxUnitEditForm');
end;

procedure TLoadFormTest.LoadTechnicalRediscountFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTechnicalRediscountJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTechnicalRediscountJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTechnicalRediscountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTechnicalRediscountForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTechnicalRediscountCashierJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTechnicalRediscountCashierJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTechnicalRediscountCashierForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTechnicalRediscountCashierForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCommentTRForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCommentTRForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCommentTREditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCommentTREditForm');
end;

procedure TLoadFormTest.LoadUnitFormTest;
begin
{  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_SUN_LockDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnit_SUN_LockDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_LimitSUN_EditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnit_LimitSUN_EditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitForOrderInternalPromoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitForOrderInternalPromoForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_HT_SUN_EditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnit_HT_SUN_EditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_SunIncome_EditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnit_SunIncome_EditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_T_SUN_EditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnit_T_SUN_EditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_KoeffSUN_EditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnit_KoeffSUN_EditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_MCSForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnit_MCSForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitTreeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitTreeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnit_ObjectForm');
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TListDaySUNDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TListDaySUNDialogForm');

    //
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_JuridicalAreaForm'));
    TdsdFormStorageFactory.GetStorage.Load('TUnit_JuridicalAreaForm');
    //
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitForFarmacyCashForm'));
    TdsdFormStorageFactory.GetStorage.Load('TUnitForFarmacyCashForm');

    //
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitCategoryForm'));
    TdsdFormStorageFactory.GetStorage.Load('TUnitCategoryForm');
    //
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitCategoryEditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TUnitCategoryEditForm');
    }
end;

procedure TLoadFormTest.LoadUnionFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_Area_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnit_Area_ObjectForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridical_Unit_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridical_Unit_ObjectForm');
end;

procedure TLoadFormTest.LoadUnnamedEnterprisesFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnnamedEnterprisesForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnnamedEnterprisesForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnnamedEnterprisesJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnnamedEnterprisesJournalForm');
end;

procedure TLoadFormTest.LoadWagesFormTest;
begin
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPayrollGroupForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPayrollGroupForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPayrollGroupEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPayrollGroupEditForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPayrollTypeEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPayrollTypeEditForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPayrollTypeForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPayrollTypeForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPayrollTypeDialogForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPayrollTypeDialogForm');

//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWagesJournalForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TWagesJournalForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWagesForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TWagesForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWagesAdditionalExpensesForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWagesAdditionalExpensesForm');
//
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWagesSUN1Form'));
//  TdsdFormStorageFactory.GetStorage.Load('TWagesSUN1Form');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWagesTechnicalRediscountForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TWagesTechnicalRediscountForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWagesTechnicalRediscountUnitForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TWagesTechnicalRediscountUnitForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWagesMoneyBoxSunForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TWagesMoneyBoxSunForm');
//
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWagesUserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWagesUserForm');
end;

procedure TLoadFormTest.LoadWriteOffHouseholdInventoryFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWriteOffHouseholdInventoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWriteOffHouseholdInventoryForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWriteOffHouseholdInventoryJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWriteOffHouseholdInventoryJournalForm');
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

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmailToolsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmailToolsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmailKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmailKindForm');

end;

procedure TLoadFormTest.LoadEmailSettingsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmailSettingsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmailSettingsForm');
end;

procedure TLoadFormTest.LoadEmailFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmailForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmailForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmailEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmailEditForm');
end;

procedure TLoadFormTest.LoadProfitLossGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossGroupForm');
  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TProfitLossGroup_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossGroup_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossGroupEditForm');
end;

procedure TLoadFormTest.LoadProfitLossDirectionFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossDirectionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossDirectionForm');

  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TProfitLossDirection_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossDirection_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TProfitLossDirectionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossDirectionEditForm');
end;

procedure TLoadFormTest.LoadProjectsImprovementsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProjectsImprovementsJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProjectsImprovementsJournalForm');
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

procedure TLoadFormTest.LoadPromoFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoCodeDoctorForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoCodeDoctorForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoForm');
end;

procedure TLoadFormTest.LoadPromoCodeFormTest;
begin
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_byPromoCodeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Check_byPromoCodeForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoCodeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoCodeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoCodeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoCodeEditForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoCodeMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoCodeMovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoCodeJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoCodeJournalForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoCodeSignDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoCodeSignDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoCodeSignPercentDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoCodeSignPercentDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoCodeSignUnitNameDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoCodeSignUnitNameDialogForm');
end;

procedure TLoadFormTest.LoadPromoBonusFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoBonusJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoBonusJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoBonusForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoBonusForm');
end;

procedure TLoadFormTest.LoadPromoUnitFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoUnitJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoUnitJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoUnitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoUnitForm');
end;

procedure TLoadFormTest.LoadProvinceCityFormTest;
begin
  // Микрорайон в населенном пункте
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProvinceCityForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProvinceCityForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProvinceCityEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProvinceCityEditForm');
end;

procedure TLoadFormTest.MainFormTest;
var
  ActionDataSet: TClientDataSet;
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
      for i := 0 to ActionCount - 1 do
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
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ',
    gc_AdminPassword, gc_User);
end;

procedure TLoadFormTest.LoadOrderSheduleFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderSheduleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderSheduleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderSheduleEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderSheduleEditForm');
end;

procedure TLoadFormTest.LoadOrderInternalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalLiteForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalLiteForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalJournalForm');
end;

procedure TLoadFormTest.LoadOrderInternalPromoFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalPromoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalPromoForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalPromoJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalPromoJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderInternalPromoOLAPForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderInternalPromoOLAPForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPromoChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsPromoChoiceForm');
   }
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
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalJournalChoiceForm');
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

procedure TLoadFormTest.LoadInstructionsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInstructionsKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInstructionsKindForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInstructionsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInstructionsForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInstructionsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInstructionsEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInstructionsCashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInstructionsCashForm');
end;

procedure TLoadFormTest.LoadInventoryFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryPartionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryPartionForm');
end;

procedure TLoadFormTest.LoadInvoiceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInvoiceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInvoiceJournalForm');
end;

procedure TLoadFormTest.LoadGoodsSPMovementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsSPJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsSPJournalChoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsSPJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsSPJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsSP_MovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsSP_MovementForm');
end;

procedure TLoadFormTest.LoadLossFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossFundJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossFundJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossFundForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossFundForm');
end;

procedure TLoadFormTest.LoadListDiffFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TListDiffJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TListDiffJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TListDiffForm'));
  TdsdFormStorageFactory.GetStorage.Load('TListDiffForm');
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
  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TInfoMoneyDestination_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyDestination_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TInfoMoneyDestinationEditForm'));
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
{  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChoiceIncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChoiceIncomeForm');

}
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeForm');
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeOperDataDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeOperDataDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomePharmacyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomePharmacyForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomePharmacyJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomePharmacyJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeJournalChoiceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncome_AmountTroubleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncome_AmountTroubleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomePartnerDataDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomePartnerDataDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeCheckDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeCheckDialogForm');
  }
end;

procedure TLoadFormTest.LoadIncomeHouseholdInventoryFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeHouseholdInventoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeHouseholdInventoryForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeHouseholdInventoryJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeHouseholdInventoryJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeHouseholdInventoryCashJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeHouseholdInventoryCashJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeHouseholdInventoryCashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeHouseholdInventoryCashForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_HouseholdInventoryRemainsDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_HouseholdInventoryRemainsDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_HouseholdInventoryRemainsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_HouseholdInventoryRemainsForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_HouseholdInventoryRemainsCashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_HouseholdInventoryRemainsCashForm');
end;

procedure TLoadFormTest.LoadAdditionalGoodsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAdditionalGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAdditionalGoodsForm');
end;

procedure TLoadFormTest.LoadPriceFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceOnDateForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceOnDateForm');
 }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMCS_LiteForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMCS_LiteForm');
  exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMCSForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMCSForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRecalcMCS_DialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRecalcMCS_DialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceHistoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceHistoryForm');



  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceGoodsDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceGoodsDialogForm');
   }
end;

procedure TLoadFormTest.LoadPriceChangeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceChangeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceChangeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceChangeHistoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceChangeHistoryForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceChangeOnDateForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceChangeOnDateForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceChangeDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceChangeDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceChangeGoodsDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceChangeGoodsDialogForm');
end;

procedure TLoadFormTest.LoadAlternativeGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAlternativeGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAlternativeGroupForm');
end;

procedure TLoadFormTest.LoadCheckDeferredFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckDeferredForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckDeferredForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckDeferred_SearchForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckDeferred_SearchForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckDelayDeferredForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckDelayDeferredForm');
end;

procedure TLoadFormTest.LoadCheckLiki24FormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckLiki24Form'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckLiki24Form');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckLiki24_SearchForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckLiki24_SearchForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckDelayLiki24Form'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckDelayLiki24Form');
end;

procedure TLoadFormTest.LoadCheckVIPFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CashListDiffPeriodForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CashListDiffPeriodForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckVIPForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckVIPForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckDelayVIPForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckDelayVIPForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckVIP_ErrorForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckVIP_ErrorForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckVIP_SearchForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckVIP_SearchForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckCashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckCashForm');
end;

procedure TLoadFormTest.LoadCheckSiteFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckSiteForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckSiteForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckSite_SearchForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckSite_SearchForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckDelaySiteForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckDelaySiteForm');
end;

procedure TLoadFormTest.LoadOverFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOverJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOverJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOverForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOverForm');
end;

procedure TLoadFormTest.LoadOverSettingsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOverSettingsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOverSettingsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOverSettingsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOverSettingsEditForm');
end;

procedure TLoadFormTest.LoadPaidKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPaidKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPaidKindForm');
end;

procedure TLoadFormTest.LoadPaidTypeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPaidTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPaidTypeForm');
end;

procedure TLoadFormTest.LoadPartnerMedicalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerMedical_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerMedical_ObjectForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerMedicalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerMedicalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerMedicalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerMedicalEditForm');
end;

procedure TLoadFormTest.LoadPaymentFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPaymentJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPaymentJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPaymentForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPaymentForm');
end;

procedure TLoadFormTest.LoadPermanentDiscountFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPermanentDiscountJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPermanentDiscountJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPermanentDiscountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPermanentDiscountForm');
end;

procedure TLoadFormTest.LoadPersonalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonal_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonal_ObjectForm');
end;

procedure TLoadFormTest.LoadPersonalGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalGroupEditForm');
end;

  procedure TLoadFormTest.LoadPlanIventoryFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPlanIventoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPlanIventoryForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPlanIventoryEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPlanIventoryEditForm');
end;

procedure TLoadFormTest.LoadPositionEducationFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEducationForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEducationForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEducationEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEducationEditForm');
end;

procedure TLoadFormTest.LoadChangeIncomePaymentFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChangeIncomePaymentJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChangeIncomePaymentJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChangeIncomePaymentForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChangeIncomePaymentForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCalculationPartialSaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCalculationPartialSaleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Sale_PartialSaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Sale_PartialSaleForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Sale_PartialSaleAllForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Sale_PartialSaleAllForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Sale_PartialSaleAllDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Sale_PartialSaleAllDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Income_PartialSaleDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Income_PartialSaleDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Income_PartialSaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Income_PartialSaleForm');
end;

procedure TLoadFormTest.LoadChangeIncomePaymentKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TChangeIncomePaymentKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChangeIncomePaymentKindForm');
end;

procedure TLoadFormTest.LoadPriceListFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListJournalForm');
end;

procedure TLoadFormTest.LoadSaleFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaleJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaleJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaleForm');
end;

procedure TLoadFormTest.LoadReturnInFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnInJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnInJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnInForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnInForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnInCashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnInCashForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnInJournalCashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnInJournalCashForm');

  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckItemJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckItemJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckToReturnForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckToReturnForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckToReturnDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckToReturnDialogForm');
end;

procedure TLoadFormTest.LoadSeasonalityCoefficientFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSeasonalityCoefficientEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSeasonalityCoefficientEditForm');
end;

procedure TLoadFormTest.LoadSendFormTest;
begin
 {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChoiceSendForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChoiceSendForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendJournalForm');
}


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendMenegerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendMenegerForm');

{  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionDateGoodsListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionDateGoodsListForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCommentSendEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCommentSendEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCommentSendForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCommentSendForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendCashJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendCashJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendCashJournalSunForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendCashJournalSunForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendCashJournalSunForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendCashJournalSunForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendCashJournalVIPForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendCashJournalVIPForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendMenegerJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendMenegerJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendMenegerVIPJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendMenegerVIPJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TConfirmedDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TConfirmedDialogForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendVIP_ToGenerateCheckForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendVIP_ToGenerateCheckForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendVIP_ToGenerateCheckDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendVIP_ToGenerateCheckDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendVIP_VIPDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendVIP_VIPDialogForm');

    // диалог изменения цены получателя
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceBySendDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceBySendDialogForm');
  }
end;

procedure TLoadFormTest.LoadSendPartionDateFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendPartionDateJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendPartionDateJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendPartionDateForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendPartionDateForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendPartionDate_UpdatePercentDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendPartionDate_UpdatePercentDialogForm');
end;

procedure TLoadFormTest.LoadSendPartionDateChangeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendPartionDateChangeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendPartionDateChangeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendPartionDateChangeJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendPartionDateChangeJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendPartionDateChangeCashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendPartionDateChangeCashForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendPartionDateChangeCashJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendPartionDateChangeCashJournalForm');
end;

procedure TLoadFormTest.LoadSendOnPriceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendOnPriceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendOnPriceJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendOnPriceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendOnPriceForm');
end;

procedure TLoadFormTest.LoadSheetWorkTimeFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_KPUForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_KPUForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TestingUserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TestingUserForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TestingUserAttemptsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TestingUserAttemptsForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPUSHJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPUSHJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPUSHForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPUSHForm');

  Exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSheetWorkTimeJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSheetWorkTimeJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSheetWorkTimeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSheetWorkTimeForm');

  TdsdFormStorageFactory.GetStorage.Save
    (GetForm('TSheetWorkTimeAddRecordForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSheetWorkTimeAddRecordForm');

end;


procedure TLoadFormTest.LoadSunExclusionFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSunExclusionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSunExclusionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSunExclusionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSunExclusionEditForm');
end;


procedure TLoadFormTest.LoadEmployeeScheduleFormTest;
begin


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmployeeScheduleJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmployeeScheduleJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmployeeScheduleNewForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmployeeScheduleNewForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmployeeScheduleEditUserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmployeeScheduleEditUserForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmployeeScheduleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmployeeScheduleForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmployeeScheduleUserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmployeeScheduleUserForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmployeeScheduleUnitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmployeeScheduleUnitForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmployeeScheduleFillingForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmployeeScheduleFillingForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmployeeScheduleAddUserDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmployeeScheduleAddUserDialogForm');
end;

procedure TLoadFormTest.LoadSPKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSPKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSPKindForm');
end;

procedure TLoadFormTest.LoadPartionDateKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionDateKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionDateKindForm');
end;

procedure TLoadFormTest.LoadSystemFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TClearDefaultUnitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TClearDefaultUnitForm');
  Exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSummaDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSummaDialogForm');
  Exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIntegerDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIntegerDialogForm');
  Exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAmountDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAmountDialogForm');
  Exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGlobalConstForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGlobalConstForm');
end;

procedure TLoadFormTest.LoadSPObjectFormTest;
begin

{
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SummSPForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_SummSPForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SummSP_DialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_SummSP_DialogForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TMedicSP_ObjectForm'));
    TdsdFormStorageFactory.GetStorage.Load('TMedicSP_ObjectForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TMedicSPForm'));
    TdsdFormStorageFactory.GetStorage.Load('TMedicSPForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TMedicSPEditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TMedicSPEditForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TAmbulantClinicSPForm'));
    TdsdFormStorageFactory.GetStorage.Load('TAmbulantClinicSPForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TAmbulantClinicSPEditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TAmbulantClinicSPEditForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberSPForm'));
    TdsdFormStorageFactory.GetStorage.Load('TMemberSPForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberSPEditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TMemberSPEditForm');

    // отчет реестр по постановлению 1303
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleSPForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_SaleSPForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleSPDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TReport_SaleSPDialogForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGroupMemberSPForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGroupMemberSPForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGroupMemberSPEditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGroupMemberSPEditForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TKindOutSPForm'));
    TdsdFormStorageFactory.GetStorage.Load('TKindOutSPForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TKindOutSPEditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TKindOutSPEditForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TBrandSPForm'));
    TdsdFormStorageFactory.GetStorage.Load('TBrandSPForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TBrandSPEditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TBrandSPEditForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TIntenalSPForm'));
    TdsdFormStorageFactory.GetStorage.Load('TIntenalSPForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TIntenalSPEditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TIntenalSPEditForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsSP_ObjectForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsSP_ObjectForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsSPForm'));
    TdsdFormStorageFactory.GetStorage.Load('TGoodsSPForm');
    exit;
}
  // отчет по продажам товара соц. проекта
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckSPForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckSPForm');
{  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckSPDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckSPDialogForm');
  }

end;

procedure TLoadFormTest.LoadServiceFormTest;
begin
       {
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemContainerCountForm'));
    TdsdFormStorageFactory.GetStorage.Load('TMovementItemContainerCountForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalPrioritiesForm'));
    TdsdFormStorageFactory.GetStorage.Load('TJuridicalPrioritiesForm');
     }
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashSettingsEditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TCashSettingsEditForm');
      {
    TdsdFormStorageFactory.GetStorage.Save(GetForm('THelsiUserForm'));
    TdsdFormStorageFactory.GetStorage.Load('THelsiUserForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TLog_CashRemainsForm'));
    TdsdFormStorageFactory.GetStorage.Load('TLog_CashRemainsForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheck_CashRegisterForm'));
    TdsdFormStorageFactory.GetStorage.Load('TCheck_CashRegisterForm');

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

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleUnionForm'));
    TdsdFormStorageFactory.GetStorage.Load('TRoleUnionForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnionDescForm'));
    TdsdFormStorageFactory.GetStorage.Load('TUnionDescForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserNickForm'));
    TdsdFormStorageFactory.GetStorage.Load('TUserNickForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserForm'));
    TdsdFormStorageFactory.GetStorage.Load('TUserForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserHelsiEditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TUserHelsiEditForm');
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserEditForm'));
    TdsdFormStorageFactory.GetStorage.Load('TUserEditForm');
    exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserKeyForm'));
    TdsdFormStorageFactory.GetStorage.Load('TUserKeyForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TLoadObjectForm'));
    TdsdFormStorageFactory.GetStorage.Load('TLoadObjectForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceGroupSettingsForm'));
    TdsdFormStorageFactory.GetStorage.Load('TPriceGroupSettingsForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceGroupSettingsTopForm'));
    TdsdFormStorageFactory.GetStorage.Load('TPriceGroupSettingsTopForm');

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
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemProtocolForm'));
    TdsdFormStorageFactory.GetStorage.Load('TMovementItemProtocolForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportExportLinkForm'));
    TdsdFormStorageFactory.GetStorage.Load('TImportExportLinkForm');
    exit;
    TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportExportLinkTypeForm'));
    TdsdFormStorageFactory.GetStorage.Load('TImportExportLinkTypeForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemContainerForm'));
    TdsdFormStorageFactory.GetStorage.Load('TMovementItemContainerForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementDescDataForm'));
    TdsdFormStorageFactory.GetStorage.Load('TMovementDescDataForm');


    TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovement_PeriodDialogForm'));
    TdsdFormStorageFactory.GetStorage.Load('TMovement_PeriodDialogForm');


    TdsdFormStorageFactory.GetStorage.Save(GetForm('TStatusForm'));
    TdsdFormStorageFactory.GetStorage.Load('TStatusForm');

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TPeriodCloseForm'));
    TdsdFormStorageFactory.GetStorage.Load('TPeriodCloseForm');
  }
end;

initialization

TestFramework.RegisterTest('Загрузка форм', TLoadFormTest.Suite);

end.
