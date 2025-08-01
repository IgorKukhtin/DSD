unit LoadFormTest;

interface

uses
  TestFramework, Forms;

type

  TLoadFormTest = class (TTestCase)
  private
    function GetForm(FormClass: string): TForm;
  protected
    // �������������� ������ ��� ������������
    procedure SetUp; override;
    // ���������� ������ ��� ������������
    procedure TearDown; override;
  published
    procedure MainFormTest;
    procedure UserFormSettingsTest;
    procedure Load1CLinkFormTest;
    procedure LoadAccountFormTest;
    procedure LoadAddressFormTest;
    procedure LoadAdvertisingFormTest;
    procedure LoadAssetFormTest;
    procedure LoadAreaUnitFormTest;
    procedure LoadArticleLossFormTest;
    procedure LoadBankFormTest;
    procedure LoadBankAccountFormTest;
    procedure LoadBankAccountContractFormTest;
    procedure LoadBankAccountDocumentFormTest;
    procedure LoadBankSecondNumFormTest;
    procedure LoadBankStatementFormTest;
    procedure LoadBarCodeBoxFormTest;
    procedure LoadBonusKindFormTest;
    procedure LoadBranchFormTest;
    procedure LoadBranchJuridicalFormTest;
    procedure LoadBusinessFormTest;
    procedure LoadBoxFormTest;
    procedure LoadCashFormTest;
    procedure LoadCashFlowFormTest;
    procedure LoadCarFormTest;
    procedure LoadCarExternalFormTest;
    procedure LoadCarInfoFormTest;
    procedure LoadCarModelFormTest;
    procedure LoadChoiceCellFormTest;
    procedure LoadChoiceCellMovementFormTest;
    procedure LoadClientKindFormTest;
    procedure LoadConditionPromoFormTest;
    procedure LoadContractKindFormTest;
    procedure LoadContractFormTest;
    procedure LoadContractPartnerFormTest;
    procedure LoadContractGoodsFormTest;
    procedure LoadContractGoodsMovementFormTest;
    procedure LoadContactPersonFormTest;
    procedure LoadContractTermKindFormTest;
    procedure LoadContractTradeMarkFormTest;
    procedure LoadCorrespondentAccountFormTest;
    procedure LoadCostFormTest;
    procedure LoadChangePercentMovementFormTest;
    procedure LoadCurrencyFormTest;
    procedure LoadCurrencyMovementFormTest;
    procedure LoadDefaultFormTest;
    procedure LoadDocumentKindFormTest;
    procedure LoadDocumentTaxKindFormTest;
    procedure LoadEDIForm;
    procedure LoadEntryAssetFormTest;
    procedure LoadEmailForm;
    procedure LoadExternalForm;
    procedure LoadFreightFormTest;
    procedure LoadFineSubjectFormTest;
    procedure LoadFounderFormTest;
    procedure LoadFounderServiceFormTest;
    procedure LoadFuelFormTest;
    procedure LoadGoodsPropertyFormTest;
    procedure LoadGoodsPropertyValueFormTest;
    procedure LoadGoodsGroupFormTest;
    procedure LoadGoodsFormTest;
    procedure LoadGoodsBrandFormTest;
    procedure LoadGoodsKindWeighingFormTest;
    procedure LoadGoodsKindFormTest;
    procedure LoadGoodsListIncomeFormTest;
    procedure LoadGoodsListSaleFormTest;
    procedure LoadGoodsReportSaleFormTest;
    procedure LoadGoodsTagFormTest;
    procedure LoadGoodsTypeKindFormTest;
    procedure LoadGoodsPlatformFormTest;
    procedure LoadGoodsSeparateFormTest;
    procedure LoadGoodsScaleCehFormTest;
    procedure LoadGoodsNormDiffFormTest;
    procedure LoadImportSettingsFormTest;
    procedure LoadImportTypeFormTest;
    procedure LoadInfoMoneyFormTest;
    procedure LoadIncomeFormTest;
    procedure LoadIncomeAssetFormTest;
    procedure LoadInventoryFormTest;
    procedure LoadInvoiceFormTest;
    procedure LoadJuridicalGroupFormTest;
    procedure LoadJuridicalFormTest;
    procedure LoadJuridicalOrderFinanceFormTest;
    procedure LoadLabFormTest;
    procedure LoadLossFormTest;
    procedure LoadLossAssetFormTest;
    procedure LoadLossDebtFormTest;
    procedure LoadLossPersonalFormTest;
    procedure LoadMeasureFormTest;
    procedure LoadMemberFormTest;
    procedure LoadMemberMinusFormTest;
    procedure LoadMemberBankAccountFormTest;
    procedure LoadMemberBranchFormTest;
    procedure LoadMemberExternalFormTest;
    procedure LoadMemberPriceListFormTest;
    procedure LoadMemberSheetWorkTimeFormTest;
    procedure LoadMemberHolidayFormTest;
    procedure LoadHospitalDoc_1CFormTest;
    procedure LoadMemberPersonalServiceListFormTest;
    procedure LoadMessagePersonalServiceLastFormTest;
    procedure LoadMobileTariffFormTest;
    procedure LoadMobileBillsFormTest;
    procedure LoadMobileProjectFormTest;
    procedure LoadMobileReportFormTest;
    procedure LoadModelServiceFormTest;
    procedure LoadMovementFormTest;
    procedure LoadOrderCarInfoFormTest;
    procedure LoadOrderGoodsFormTest;
    procedure LoadOrderFinanceFormTest;
    procedure LoadOrderFinanceMovementFormTest;
    procedure LoadOrderSaleFormTest;
    procedure LoadOrderIncomeFormTest;
    procedure LoadOrderInternalFormTest;
    procedure LoadOrderReturnTareFormTest;
    procedure LoadOrderExternalFormTest;
    procedure LoadOrderTypeFormTest;
    procedure LoadPartnerFormTest;
    procedure LoadPartnerTagFormTest;
    procedure LoadPartnerExternalFormTest;
    procedure LoadPartionGoodsChoiceFormTest;
    procedure LoadPartionModelFormTest;
    procedure LoadPartionRemainsFormTest;
    procedure LoadPaidKindFormTest;
    procedure LoadPairDayFormTest;
    procedure LoadPartionCellFormTest;
    procedure LoadPersonalReportFormTest;
    procedure LoadPersonalAccountFormTest;
    procedure LoadPersonalFormTest;
    procedure LoadPersonalGroupMovementFormTest;
    procedure LoadPersonalSendCashFormTest;
    procedure LoadPersonalGroupSummAddFormTest;
    procedure LoadPersonalRateFormTest;
    procedure LoadPersonalServiceFormTest;
    procedure LoadPersonalServiceListFormTest;
    procedure LoadPersonalTRansportFormTest;
    procedure LoadPartnerMapFormTest;
    procedure LoadPriceListFormTest;
    procedure LoadPriceCorrectiveFormTest;
    procedure LoadProductionUnionFormTest;
    procedure LoadProductionSeparateFormTest;
    procedure LoadProfitLossFormTest;
    procedure LoadProfitLossServiceFormTest;
    procedure LoadProfitLossResultFormTest;
    procedure LoadProfitIncomeServiceFormTest;
    procedure LoadPositionFormTest;
    procedure LoadPromoKindFormTest;
    procedure LoadPromoStateKindFormTest;
    procedure LoadPromoFormTest;
    procedure LoadPromoTradeFormTest;
    procedure LoadQualityFormTest;
    procedure LoadQualityParamsFormTest;
    procedure LoadQualityDocFormTest;
    procedure LoadQualityNumberFormTest;
    procedure LoadReasonFormTest;
    procedure LoadReplFormTest;
    procedure LoadReestrFormTest;
    procedure LoadReestrKindFormTest;
    procedure LoadReportFormTest;
    procedure LoadReportBonusFormTest;
    procedure LoadReestrIncomeFormTest;
    procedure LoadReestrReturnOutFormTest;
    procedure LoadReestrReturnFormTest;
    procedure LoadReestrTransportGoodsFormTest;
    procedure LoadReportAssetFormTest;
    procedure LoadReportBranchFormTest;
    procedure LoadReportSystemFormTest;
    procedure LoadReportBankAccountCashFormTest;
    procedure LoadReportInvoiceFormTest;
    procedure LoadReportProductionAnalyzeFormTest;
    procedure LoadReportSaleAnalyzeFormTest;
    procedure LoadReportSheetWorkTimeFormTest;
    procedure LoadReportProductionOutAnalyzeFormTest;
    procedure LoadReportProductionOrderFormTest;
    procedure LoadReportPromoFormTest;
    procedure LoadReportTaraFormTest;
    procedure LoadReportTransportFormTest;
    procedure LoadReportWageFormTest;
    procedure LoadReturnKindFormTest;
    procedure LoadReturnInFormTest;
    procedure LoadReturnOutFormTest;
    procedure LoadRetailFormTest;
    procedure LoadReceiptFormTest;
    procedure LoadRoleFormTest;
    procedure LoadRouteFormTest;
    procedure LoadRouteGroupFormTest;
    procedure LoadRouteNumFormTest;
    procedure LoadRouteSortingFormTest;
    procedure LoadRateFuelKindFormTest;
    procedure LoadNameBeforeFormTest;
    procedure LoadSectionFormTest;
    procedure LoadSaleFormTest;
    procedure LoadSaleAssetFormTest;
    procedure LoadSaleExternalFormTest;
    procedure LoadSendFormTest;
    procedure LoadSendAssetFormTest;
    procedure LoadSendDebtFormTest;
    procedure LoadSendMemberFormTest;
    procedure LoadSendOnPriceFormTest;
    procedure LoadServiceDocumentFormTest;
    procedure LoadServiceFormTest;
    procedure LoadSettingsServiceFormTest;
    procedure LoadSignInternalFormTest;
    procedure LoadSiteTagFormTest;
    procedure LoadSheetWorkTimeFormTest;
    procedure LoadSheetWorkTimeCloseFormTest;
    procedure LoadSmsSettingsFormTest;
    procedure LoadStaffListFormTest;
    procedure LoadStickerFormTest;
    procedure LoadStorageLineFormTest;
    procedure LoadStorage_ObjectFormTest;
    procedure LoadStoreRealFormTest;
    procedure LoadSubjectDocFormTest;
    procedure LoadTaskTest;
    procedure LoadTaxFormTest;
    procedure LoadTaxCorrectiveTest;
    procedure LoadTransportFormTest;
    procedure LoadTransportServiceFormTest;
    procedure LoadTransportGoodsFormTest;
    procedure LoadTransferDebtOutFormTest;
    procedure LoadTransferDebtInFormTest;
    procedure LoadTradeMarkFormTest;
    procedure LoadTelegramGroupFormTest;
    procedure LoadToolsWeighingFormTest;
    procedure LoadViewPriceListFormTest;
    procedure LoadVisitFormTest;
    procedure LoadUnionFormTest;
    procedure LoadUnitFormTest;
    procedure LoadUnitPeresortFormTest;
    procedure LoadUserByGroupFormTest;
    procedure LoadWorkTimeKindFormTest;
    procedure LoadWeighingPartnerFormTest;
    procedure LoadWeighingProductionFormTest;
    procedure LoadWeighingProduction_wmsFormTest;
    //procedure LoadZakazExternalFormTest;
    //procedure LoadZakazInternalFormTest;
  end;

implementation

uses CommonData, Storage, FormStorage, Classes,
     dsdDB, Authentication, SysUtils, cxPropertiesStore,
     cxStorage, DBClient, MainForm, ActionTest, UtilConst;

{ TLoadFormTest }

function TLoadFormTest.GetForm(FormClass: string): TForm;
begin
  if GetClass(FormClass) = nil then
     raise Exception.Create('�� ��������������� �����: ' + FormClass);
  Application.CreateForm(TComponentClass(GetClass(FormClass)), Result);
end;

procedure TLoadFormTest.LoadBankAccountDocumentFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountJournal_srv_rForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountJournal_srv_rForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountJournalForm');
  //exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountMovementForm');
  exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountMovement_SplitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountMovement_SplitForm');
  exit;

//
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccount_PersonalJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccount_PersonalJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccount_PersonalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccount_PersonalForm');
end;

procedure TLoadFormTest.LoadBankAccountFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountForm');
  //exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccount_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccount_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountEditForm');
end;

procedure TLoadFormTest.LoadCorrespondentAccountFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCorrespondentAccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCorrespondentAccountForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCorrespondentAccountEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCorrespondentAccountEditForm');
end;


procedure TLoadFormTest.LoadBankAccountContractFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountContractForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountContractForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountContractEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountContractEditForm');
end;

procedure TLoadFormTest.LoadBankFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankEditForm');
end;


procedure TLoadFormTest.LoadBankSecondNumFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankSecondNumJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankSecondNumJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankSecondNumForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankSecondNumForm');
end;


procedure TLoadFormTest.LoadBankStatementFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankStatementJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankStatementJournalForm');
  //exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankStatementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankStatementForm');
end;

procedure TLoadFormTest.LoadBarCodeBoxFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBarCodeBoxPrintDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBarCodeBoxPrintDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBarCodeBoxForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBarCodeBoxForm');
 {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBarCodeBoxDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBarCodeBoxDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBarCodeBoxEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBarCodeBoxEditForm');
  }
end;

procedure TLoadFormTest.LoadBonusKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBonusKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBonusKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBonusKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBonusKindEditForm');
end;

procedure TLoadFormTest.LoadBranchFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBranchForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBranchForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBranch_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBranch_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBranchEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBranchEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBranch_TTNDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBranch_TTNDialogForm');
  }
end;

procedure TLoadFormTest.LoadBranchJuridicalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBranchJuridicalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBranchJuridicalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBranchJuridicalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBranchJuridicalEditForm');
end;

procedure TLoadFormTest.LoadBusinessFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBusinessForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBusinessForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBusiness_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBusiness_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBusinessEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBusinessEditForm');
end;

procedure TLoadFormTest.LoadCashFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashJournal_srv_rForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashJournal_srv_rForm');
  exit;
  {TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashOperationBonusForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashOperationBonusForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashJournalBonusForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashJournalBonusForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovement_PeriodDialog_BonusForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovement_PeriodDialog_BonusForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCash_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCash_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashEditForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashJournalUserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashJournalUserForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashOperationForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashOperationForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCash_PersonalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCash_PersonalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCash_PersonalJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCash_PersonalJournalForm');
   }
end;

procedure TLoadFormTest.LoadCashFlowFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashFlowForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashFlowForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashFlowEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashFlowEditForm');
end;

procedure TLoadFormTest.LoadContractFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractConditionPartnerValueEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractConditionPartnerValueEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractConditionPartnerValueForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractConditionPartnerValueForm');
   exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractEditForm');
  exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractConditionValueForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractConditionValueForm');
   exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractChoiceForm');
  exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractChoicePartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractChoicePartnerForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractChoicePartnerOrderForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractChoicePartnerOrderForm');
  exit;

 {
   // ��������� ��������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractStateKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractStateKindForm');
  // ������� ��������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractArticleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractArticleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractArticleEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractArticleEditForm');
  }
  // �������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAreaForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAreaForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAreaEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAreaEditForm');
   exit;
   // ������� (��������)
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAreaContractForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAreaContractForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAreaContractEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAreaContractEditForm');
  exit;
  // ���� ������� ���������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractConditionKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractConditionKindForm');
  }
  // ������� ���������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractConditionByContractForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractConditionByContractForm');
  {// ������� ��������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractTagForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractTagForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractTagEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractTagEditForm');
  // ������ ��������� ���������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractTagGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractTagGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractTagGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractTagGroupEditForm');
   }
end;

procedure TLoadFormTest.LoadContractKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractKindEditForm');
end;

procedure TLoadFormTest.LoadContractPartnerFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractPartner_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractPartner_ObjectForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractPartnerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractPartnerEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractPartnerEditForm');
end;

procedure TLoadFormTest.LoadContractTermKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractTermKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCContractTermKindForm');
end;

procedure TLoadFormTest.LoadContractGoodsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractGoodsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractGoodsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractGoodsEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractGoodsChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractGoodsChoiceForm');
end;

procedure TLoadFormTest.LoadContractGoodsMovementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractGoodsMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractGoodsMovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractGoodsJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractGoodsJournalForm');
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
  // ��� ��������� �����
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyValue_ForCashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyValue_ForCashForm');
end;

procedure TLoadFormTest.LoadCostFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeCostJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeCostJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeCostForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeCostForm');
  //
  {exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCostJournalChoicebyIncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCostJournalChoicebyIncomeForm');
  exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCostJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCostJournalChoiceForm');
end;

procedure TLoadFormTest.LoadChangePercentMovementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChangePercentMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChangePercentMovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChangePercentJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChangePercentJournalForm');
end;

procedure TLoadFormTest.LoadCurrencyMovementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyListMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyListMovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyListJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyListJournalForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyMovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyJournalForm');
end;

procedure TLoadFormTest.LoadDefaultFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSetUserDefaultsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSetUserDefaultsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDefaultsKeyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDefaultsKeyForm');
end;

procedure TLoadFormTest.LoadGoodsFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsByGoodsKindPeresortForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsByGoodsKindPeresortForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoods_ScaleDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoods_ScaleDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupPropertyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupPropertyForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupProperty_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupProperty_ObjectForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupPropertyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupPropertyEditForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupPropertyParentEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupPropertyParentEditForm');
   exit;


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoods_Name_BUHDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoods_Name_BUHDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoods_AssetProdForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoods_AssetProdForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsEditForm');
  exit;

  TsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsTreeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsTreeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoods_WeightTareDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoods_WeightTareDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoods_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoods_ObjectForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsTree_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsTree_ObjectForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsByGoodsKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsByGoodsKindForm');
  exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsByGoodsKind_NormForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsByGoodsKind_NormForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsByGoodsKind_OrderForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsByGoodsKind_OrderForm');
   exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsByGoodsKind_ScaleCehForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsByGoodsKind_ScaleCehForm');
  exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsByGoodsKind_StickerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsByGoodsKind_StickerForm');
  exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsByGoodsKind_lineVMCForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsByGoodsKind_lineVMCForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsByGoodsKind_VMCForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsByGoodsKind_VMCForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsByGoodsKind_VMCDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsByGoodsKind_VMCDialogForm');
  // ����. ����
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsByGK_VMCDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsByGK_VMCDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsExternalForm');
   }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoods_UKTZEDForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoods_UKTZEDForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoods_ParamForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoods_ParamForm');

end;

procedure TLoadFormTest.LoadGoodsBrandFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsBrandForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsBrandForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsBrandEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsBrandEditForm');
end;

      procedure TLoadFormTest.LoadGoodsSeparateFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsSeparateForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsSeparateForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsSeparateEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsSeparateEditForm');
end;

procedure TLoadFormTest.LoadGoodsScaleCehFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsScaleCehForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsScaleCehForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsScaleCehEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsScaleCehEditForm');
end;

 procedure TLoadFormTest.LoadGoodsNormDiffFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsNormDiffForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsNormDiffForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsNormDiffEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsNormDiffEditForm');
end;

procedure TLoadFormTest.LoadGoodsKindWeighingFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsKindWeighingTreeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsKindWeighingTreeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsKindWeighingEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsKindWeighingEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsKindWeighingGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsKindWeighingGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsKindWeighingGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsKindWeighingGroupEditForm');
end;

procedure TLoadFormTest.LoadGoodsGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupDirectionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupDirectionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupDirectionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupDirectionEditForm');
  exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroup_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroup_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupEditForm');
   }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroup_UKTZEDForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroup_UKTZEDForm');
  //
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupStatForm'));
  TdsdFormStorageFactory.GetStorage.Load('GoodsGroupStatForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupStatEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupStatEditForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupAnalystForm'));
  TdsdFormStorageFactory.GetStorage.Load('GoodsGroupAnalystForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupAnalystEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupAnalystEditForm');
  }
end;

procedure TLoadFormTest.LoadGoodsKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsKindNewForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsKindNewForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsKindNewEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsKindNewEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsKindNew_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsKindNew_ObjectForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsKind_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsKind_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsKindEditForm');
end;

procedure TLoadFormTest.LoadGoodsListIncomeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsListIncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsListIncomeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsListIncomeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsListIncomeEditForm');
//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsListIncomeDialogForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TGoodsListIncomeDialogForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsListIncome_byReportEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsListIncome_byReportEditForm');
end;

procedure TLoadFormTest.LoadGoodsListSaleFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsListSaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsListSaleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsListSaleEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsListSaleEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsListSaleDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsListSaleDialogForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsListSale_byReportEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsListSale_byReportEditForm');
end;

procedure TLoadFormTest.LoadGoodsPropertyFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPropertyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsPropertyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPropertyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsPropertyEditForm');
end;

procedure TLoadFormTest.LoadGoodsPropertyValueFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPropertyValueForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsPropertyValueForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPropertyValueEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsPropertyValueEditForm');
//
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPropertyValueDocForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsPropertyValueDocForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPropertyValueVMSForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsPropertyValueVMSForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPropertyValueExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsPropertyValueExternalForm');
  }
end;

procedure TLoadFormTest.LoadQualityParamsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TQualityParamsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TQualityParamsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TQualityParamsJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TQualityParamsJournalForm');
end;

procedure TLoadFormTest.LoadQualityDocFormTest;
begin
  {TdsdFormStorageFactory.GetStorage.Save(GetForm('TQualityDocForm'));
  TdsdFormStorageFactory.GetStorage.Load('TQualityDocForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TQualityDocJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TQualityDocJournalForm');
end;

procedure TLoadFormTest.LoadQualityNumberFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TQualityNumberForm'));
  TdsdFormStorageFactory.GetStorage.Load('TQualityNumberForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TQualityNumberJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TQualityNumberJournalForm');
end;

procedure TLoadFormTest.LoadGoodsReportSaleFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsReportSaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsReportSaleForm');
end;
procedure TLoadFormTest.LoadGoodsTagFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsTagForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsTagForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsTagEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsTagEditForm');
end;

 procedure TLoadFormTest.LoadGoodsTypeKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsTypeKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsTypeKindForm');
end;

procedure TLoadFormTest.LoadGoodsPlatformFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPlatformForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsPlatformForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPlatformEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsPlatformEditForm');
end;
procedure TLoadFormTest.LoadPersonalAccountFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalAccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalAccountForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalAccountJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalAccountJournalForm');
end;

procedure TLoadFormTest.LoadPersonalSendCashFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalSendCashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalSendCashForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalSendCashJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalSendCashJournalForm');
end;


procedure TLoadFormTest.LoadPersonalGroupSummAddFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalGroupSummAddForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalGroupSummAddForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalGroupSummAddJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalGroupSummAddJournalForm');
end;

procedure TLoadFormTest.LoadPersonalRateFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalRateForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalRateForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalRateJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalRateJournalForm');
end;

procedure TLoadFormTest.LoadPersonalServiceFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovement_DateDialog_PersonalServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovement_DateDialog_PersonalServiceForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceNalogDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceNalogDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PersonalService_RecalcForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PersonalService_RecalcForm');
  exit;


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalService_DetailDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalService_DetailDialogForm');

  //TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalServiceItemJournal_unitForm'));
  //TdsdFormStorageFactory.GetStorage.Load('TPersonalServiceItemJournal_unitForm');
  //exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalServiceForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalServiceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalServiceJournalForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalServiceItemJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalServiceItemJournalForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalServiceJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalServiceJournalChoiceForm');

end;

procedure TLoadFormTest.LoadPersonalTransportFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalTransportForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalTransportForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalTransportJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalTransportJournalForm');
end;

 procedure TLoadFormTest.LoadOrderCarInfoFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderCarInfoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderCarInfoForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderCarInfoEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderCarInfoEditForm');
end;

procedure TLoadFormTest.LoadPersonalServiceListFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalServiceList_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalServiceList_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalServiceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalServiceListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalServiceListEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalServiceListEditForm');
end;

procedure TLoadFormTest.LoadOrderFinanceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderFinanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderFinanceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderFinanceEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderFinanceEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyPlace_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyPlace_ObjectForm');
end;
procedure TLoadFormTest.LoadOrderGoodsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderGoodsJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderGoodsJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderGoodsForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderPeriodKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderPeriodKindForm');
end;

procedure TLoadFormTest.LoadOrderSaleFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderSaleJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderSaleJournalForm');
end;

procedure TLoadFormTest.LoadOrderFinanceMovementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderFinanceMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderFinanceMovementForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderFinanceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderFinanceJournalForm');
end;

procedure TLoadFormTest.LoadPartnerMapFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerMapForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerMapForm');
end;

procedure TLoadFormTest.LoadImportSettingsFormTest;
begin
{
  //��������� �������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportSettingsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportSettingsForm');
 }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportGroupForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLoadFlagFromMedocForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLoadFlagFromMedocForm');

end;

procedure TLoadFormTest.LoadImportTypeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFileTypeKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFileTypeKindForm');
  //���� �������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportTypeForm');
end;

procedure TLoadFormTest.LoadIncomeFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeEdit_PartnerParamForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeEdit_PartnerParamForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChange�urrencyUserDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChange�urrencyUserDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncome20202Form'));
  TdsdFormStorageFactory.GetStorage.Load('TIncome20202Form');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncome20202JournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncome20202JournalForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeForm');
  //exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeJournalForm');
  exit;
  {//
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChangePriceUserDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChangePriceUserDialogForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeFuelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeFuelForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeFuelJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeFuelJournalForm');
  //

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomePartionGoodsJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomePartionGoodsJournalForm');
  exit;
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomePartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomePartnerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomePartnerJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomePartnerJournalForm');
  exit;
  //

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeJournalChoiceForm');

end;
procedure TLoadFormTest.LoadIncomeAssetFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeAssetForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeAssetForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeAssetJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeAssetJournalForm');
  {//
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAssetPlace_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAssetPlace_ObjectForm');
  }
end;

procedure TLoadFormTest.LoadOrderIncomeFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderIncomeSnabForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderIncomeSnabForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderIncomeSnabJournalForm'));
  TdsdFormS
  torageFactory.GetStorage.Load('TOrderIncomeSnabJournalForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderIncomeSnabJournal_byReportForm'));
  TdsdFormStorageFactory.GetStorage.Load('OrderIncomeSnabJournal_byReportFormForm');
  //
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderIncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderIncomeForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderIncomeJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderIncomeJournalForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderIncomeJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderIncomeJournalChoiceForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderIncomeJournalDetailChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderIncomeJournalDetailChoiceForm');
  }
end;

procedure TLoadFormTest.LoadSendFormTest;
begin
 {

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSend_DatePartionDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSend_DatePartionDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendPartionCellEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendPartionCellEditForm');
   }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendJournalForm');
  exit;
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendJournalChoiceForm');
  exit;
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendTicketFuelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendTicketFuelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendTicketFuelJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendTicketFuelJournalForm');
end;

procedure TLoadFormTest.LoadSendAssetFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendAssetForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendAssetForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendAssetJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendAssetJournalForm');
end;

procedure TLoadFormTest.LoadSendMemberFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendMemberForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendMemberForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendMemberJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendMemberJournalForm');
end;

procedure TLoadFormTest.LoadOrderInternalFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternal_deflectionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternal_deflectionForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalPackRemains_deflectionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalPackRemains_deflectionForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalJournalChoiceForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalStewForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalStewForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalStewJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalStewJournalForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalBasisPackForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalBasisPackForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalBasisPackJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalBasisPackJournalForm');
  exit;
   }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalPackRemainsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalPackRemainsForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalPackRemainsJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalPackRemainsJournalForm');
  exit;
  {

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderInternalPackRemainsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderInternalPackRemainsForm');
  exit;
  //


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalForm');
   exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalChildForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalChildForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalPackForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalPackForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalPackJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalPackJournalForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalBasisForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalBasisForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalBasisJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalBasisJournalForm');

end;


 procedure TLoadFormTest.LoadOrderReturnTareFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderReturnTareJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderReturnTareJournalChoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderReturnTareForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderReturnTareForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderReturnTareJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderReturnTareJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderReturnTare_SaleByTransportForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderReturnTare_SaleByTransportForm');

end;

procedure TLoadFormTest.LoadOrderExternalFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalChild_BySendForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalChild_BySendForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalChildForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalChildForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalJournal_byReportForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalJournal_byReportForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalForm');
 // exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalJournalForm');
  exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalJournalChoiceForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalItemJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalItemJournalForm');
  // ������ �� ������� �����
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalUnitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalUnitForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalUnitJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalUnitJournalForm');
  //
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternal_DatePartnerDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternal_DatePartnerDialogForm');
  }
end;

procedure TLoadFormTest.LoadOrderTypeFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderType_isPrEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderType_isPrEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderTypeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderType_EditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderType_EditForm');
end;

procedure TLoadFormTest.LoadSendDebtFormTest;
begin
 {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendDebtMemberForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendDebtMemberForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendDebtMemberJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendDebtMemberJournalForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendDebtForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendDebtForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendDebtJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendDebtJournalForm');
end;
procedure TLoadFormTest.LoadSendOnPriceFormTest;
begin
{  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendOnPriceJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendOnPriceJournalChoiceForm');
  // exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendOnPrice_ReestrJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendOnPrice_ReestrJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendOnPriceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendOnPriceForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendOnPriceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendOnPriceJournalForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendOnPrice_BranchForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendOnPrice_BranchForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendOnPrice_BranchJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendOnPrice_BranchJournalForm');
end;

procedure TLoadFormTest.LoadServiceDocumentFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TServiceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TServiceJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TServiceForm');
end;

procedure TLoadFormTest.LoadSettingsServiceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSettingsServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSettingsServiceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSettingsServiceItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSettingsServiceItemEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSettingsService_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSettingsService_ObjectForm');
end;

procedure TLoadFormTest.LoadServiceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PrintForms_byMovementDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PrintForms_byMovementDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PrintForms_byMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PrintForms_byMovementForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TServiceDateDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TServiceDateDialogForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMIFloatEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMIFloatEditForm');

  exit;
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAmountDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAmountDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnDescKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnDescKindForm');
  exit;


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPSLExportKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPSLExportKindForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChangeInvnumberDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChangeInvnumberDialogForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementPromo_DateDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementPromo_DateDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovement_Period_PaidKind_BranchDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovement_Period_PaidKind_BranchDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDatePeriodDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDatePeriodDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDataTimeDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDataTimeDialogForm');
  // exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDataDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDataDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TColorForm'));
  TdsdFormStorageFactory.GetStorage.Load('TColorForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TActionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TActionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProcessForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProcessForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserSettingsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserSettingsForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserForm');
  exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserEditForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserKeyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserKeyForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUser_byMessageForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUser_byMessageForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUser_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUser_ObjectForm');
  exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStatusForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStatusForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProtocolForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TObjectDescForm'));
  TdsdFormStorageFactory.GetStorage.Load('TObjectDescForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFormsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFormsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnionDescForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnionDescForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemContainerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementItemContainerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementDescDataForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementDescDataForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserProtocolForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementProtocolForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementItemProtocolForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPeriodCloseForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPeriodCloseForm');
  exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPeriodClose_UserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPeriodClose_UserForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportExportLinkForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportExportLinkForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportExportLinkTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportExportLinkTypeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGlobalConstForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGlobalConstForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovement_DateDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovement_DateDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovement_PeriodDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovement_PeriodDialogForm');
  }
end;

procedure TLoadFormTest.LoadSignInternalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSignInternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSignInternalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSignInternalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSignInternalEditForm');
end;

procedure TLoadFormTest.LoadSiteTagFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSiteTagForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSiteTagForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSiteTagEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSiteTagEditForm');
end;

procedure TLoadFormTest.LoadPersonalReportFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalReportForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalReportForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalReportJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalReportJournalForm');
end;


procedure TLoadFormTest.LoadSheetWorkTimeFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemProtocolSWTForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementItemProtocolSWTForm');
 }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSheetWorkTime_lineForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSheetWorkTime_lineForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSheetWorkTimeJournal_lineForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSheetWorkTimeJournal_lineForm');

  exit;
  {
  //�����������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDayKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDayKindForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSheetWorkTime_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSheetWorkTime_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSheetWorkTimeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSheetWorkTimeEditForm');
  //
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSheetWorkTimeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSheetWorkTimeForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSheetWorkTimeJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSheetWorkTimeJournalForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSheetWorkTimeAddRecordForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSheetWorkTimeAddRecordForm');
end;

procedure TLoadFormTest.LoadSheetWorkTimeCloseFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSheetWorkTimeCloseEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSheetWorkTimeCloseEditForm');
  {//exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSheetWorkTimeCloseForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSheetWorkTimeCloseForm');
   }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSheetWorkTimeCloseJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSheetWorkTimeCloseJournalForm');
  //exit;
  //TdsdFormStorageFactory.GetStorage.Save(GetForm('TSheetWorkTimeAddRecordForm'));
  //TdsdFormStorageFactory.GetStorage.Load('TSheetWorkTimeAddRecordForm');
end;

procedure TLoadFormTest.LoadNameBeforeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TNameBeforeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TNameBeforeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TNameBeforeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TNameBeforeEditForm');
end;


procedure TLoadFormTest.LoadSaleFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSale_PayForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSale_PayForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSale_PayJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSale_PayJournalForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSale_TransportJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSale_TransportJournalForm');
  //
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaleForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaleJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaleJournalForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSale_PartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSale_PartnerForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSale_PartnerJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSale_PartnerJournalForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSale_OrderForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSale_OrderForm');
    //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSale_OrderJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSale_OrderJournalForm');
   exit;
   {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementCheckForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementCheckForm');
   }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaleJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaleJournalChoiceForm');

end;

procedure TLoadFormTest.LoadSaleAssetFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaleAssetForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaleAssetForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaleAssetJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaleAssetJournalForm');

end;

procedure TLoadFormTest.LoadSaleExternalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaleExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaleExternalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaleExternalJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaleExternalJournalForm');
end;

procedure TLoadFormTest.LoadTaxFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaxForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaxForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaxJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaxJournalForm');
  exit;
   //08.04.14 Dima
   {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaxJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaxJournalChoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMedocJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMedocJournalForm');
  //09.06.15
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaxJournalDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaxJournalDialogForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementString_INNEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementString_INNEditForm');
  }
end;

procedure TLoadFormTest.LoadTaxCorrectiveTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaxCorrectiveJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaxCorrectiveJournalChoiceForm');
  Exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaxCorrectiveForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaxCorrectiveForm');
  //Exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaxCorrectiveJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaxCorrectiveJournalForm');

end;

procedure TLoadFormTest.LoadTaskTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaskForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaskForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaskJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaskJournalForm');
end;

procedure TLoadFormTest.LoadReturnKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnKindForm');
end;

procedure TLoadFormTest.LoadReturnOutFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnOutJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnOutJournalChoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnOutForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnOutForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnOutJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnOutJournalForm');
  exit;
  // ������� ���������� �� ����������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnOutPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnOutPartnerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnOutPartnerJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnOutPartnerJournalForm');

end;

procedure TLoadFormTest.LoadReturnInFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnInChildDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnInChildDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnInForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnInForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnInJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnInJournalForm');
  //exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnIn_PartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnIn_PartnerForm');

  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnIn_PartnerJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnIn_PartnerJournalForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnInJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnInJournalChoiceForm');
  {
  //�����
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_ReturnInBySaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_ReturnInBySaleForm');

  //����� �� �������� ������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_SalebyReturnInForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_SalebyReturnInForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_SalebyReturnInDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_SalebyReturnInDialogForm');
  //�����
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_SalebyReturnIn_ChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_SalebyReturnIn_ChoiceForm');

  //����� �������� �������� �������� � ��������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_ReturnInToSaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Check_ReturnInToSaleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_ReturnInToSaleDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Check_ReturnInToSaleDialogForm');

  //����� �������� ���������� � �������� �������� � ��������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckAmount_ReturnInToSaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckAmount_ReturnInToSaleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckAmount_ReturnInToSaleDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckAmount_ReturnInToSaleDialogForm');
   }
end;
{ ZakazExternalForm  -> OrderExternalForm
procedure TLoadFormTest.LoadZakazExternalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TZakazExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TZakazExternalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TZakazExternalJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TZakazExternalJournalForm');
end;
procedure TLoadFormTest.LoadZakazInternalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TZakazInternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TZakazInternalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TZakazInternalJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TZakazInternalJournalForm');
end;
}
procedure TLoadFormTest.MainFormTest;
var ActionDataSet: TClientDataSet;
    StoredProc: TdsdStoredProc;
    i: integer;
    Action: ActionTest.TAction;
begin
  // ����� �� ��������� ���������� Action
  // �������� ��� Action �� ����
  ActionDataSet := TClientDataSet.Create(nil);
  StoredProc := TdsdStoredProc.Create(nil);
  MainFormInstance := TMainForm.Create(nil);
  Action := ActionTest.TAction.Create;
  try
    StoredProc.DataSet := ActionDataSet;
    StoredProc.StoredProcName := 'gpSelect_Object_Action';
    StoredProc.Execute;
    // ������� ���, ��� ���
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

procedure TLoadFormTest.LoadLabFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLabSampleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLabSampleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLabSampleEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLabSampleEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLabProductForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLabProductForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLabProductEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLabProductEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLabMarkForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLabMarkForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLabMarkEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLabMarkEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLabMark_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLabMark_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLabReceiptChildEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLabReceiptChildEditForm');
end;

procedure TLoadFormTest.LoadLossFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossJournalForm');
end;
procedure TLoadFormTest.LoadLossAssetFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossAssetForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossAssetForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossAssetJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossAssetJournalForm');
end;

procedure TLoadFormTest.LoadLossDebtFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossDebtForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossDebtForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossDebtJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossDebtJournalForm');
end;

procedure TLoadFormTest.LoadLossPersonalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossPersonalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossPersonalForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossPersonalJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossPersonalJournalForm');
end;
procedure TLoadFormTest.LoadInventoryFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryJournalForm');
end;

procedure TLoadFormTest.LoadInvoiceFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInvoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInvoiceForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInvoiceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInvoiceJournalForm');
  //

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInvoiceJournalDetailChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInvoiceJournalDetailChoiceForm');
  exit;
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInvoiceJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInvoiceJournalChoiceForm');
end;

procedure TLoadFormTest.LoadJuridicalFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridical_DialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridical_DialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalVatPriceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalVatPriceDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridical_BasisForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridical_BasisForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalForm');
   {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridical_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridical_ObjectForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalEditForm');
  exit;
   {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalTreeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalTreeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalGLNForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalGLNForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridical_PriceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridical_PriceListForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridical_PrintKindItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridical_PrintKindItemForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridical_ContainerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridical_ContainerForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalUKTZEDForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalUKTZEDForm');
  }
end;

 procedure TLoadFormTest.LoadJuridicalOrderFinanceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalOrderFinanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalOrderFinanceForm');
end;

procedure TLoadFormTest.LoadProductionSeparateFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionSeparateJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionSeparateJournalChoiceForm');
  //exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionSeparateItemJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionSeparateItemJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionSeparateStorageLineForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionSeparateStorageLineForm');
   }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionSeparateForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionSeparateForm');
  //exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionSeparateJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionSeparateJournalForm');

end;
procedure TLoadFormTest.LoadProductionUnionFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAmountFormDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAmountFormDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAmountForm_twoDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAmountForm_twoDialogForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionUnionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionUnionForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionUnionJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionUnionJournalForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionUnionTechJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionUnionTechJournalForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionUnionTechEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionUnionTechEditForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionPeresortJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionPeresortJournalForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionPeresortForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionPeresortForm');
  //

  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionUnionTechReceiptJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionUnionTechReceiptJournalForm');

end;

procedure TLoadFormTest.LoadTransportFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransportKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransportKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransportKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransportKindEditForm');
  exit;
 {  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransportRouteJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransportRouteJournalForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransportForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransportForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransportJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransportJournalForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransportJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransportJournalChoiceForm');

end;

procedure TLoadFormTest.LoadTransportServiceFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransportServiceSummReestrDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransportServiceSummReestrDialogForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransportServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransportServiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransportServiceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransportServiceJournalForm');
end;

procedure TLoadFormTest.LoadTransportGoodsFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransportGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransportGoodsForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransportGoodsJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransportGoodsJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransportGoods_EDINJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransportGoods_EDINJournalForm');
end;

procedure TLoadFormTest.LoadTransferDebtOutFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransferDebtOutForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransferDebtOutForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransferDebtOutJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransferDebtOutJournalForm');
  //�� ������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransferDebtOut_OrderForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransferDebtOut_OrderForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransferDebtOut_OrderJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransferDebtOut_OrderJournalForm');
end;

procedure TLoadFormTest.LoadTransferDebtInFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransferDebtInForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransferDebtInForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransferDebtInJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransferDebtInJournalForm');
end;

procedure TLoadFormTest.LoadEntryAssetFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEntryAssetForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEntryAssetForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEntryAssetJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEntryAssetJournalForm');
end;

procedure TLoadFormTest.LoadPriceCorrectiveFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceCorrectiveForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceCorrectiveForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceCorrectiveJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceCorrectiveJournalForm');
end;

procedure TLoadFormTest.LoadJuridicalGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalGroup_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalGroup_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalGroupEditForm');
end;

procedure TLoadFormTest.LoadMeasureFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMeasureForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMeasureForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMeasureEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMeasureEditForm');
end;

  procedure TLoadFormTest.LoadContractTradeMarkFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractTradeMarkForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractTradeMarkForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractTradeMarkEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractTradeMarkEditForm');
end;

procedure TLoadFormTest.LoadBoxFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBoxForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBoxForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBoxEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBoxEditForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPropertyBoxForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsPropertyBoxForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPropertyBoxEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsPropertyBoxEditForm');
end;

procedure TLoadFormTest.LoadConditionPromoFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TConditionPromoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TConditionPromoForm');
end;

procedure TLoadFormTest.LoadContactPersonFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContactPersonForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContactPersonEditForm');
  //  ��� ��������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContactPersonKindForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContactPersonChoiceForm');
  //��� � !!!Enum!!!
  //TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonKindEditForm'));
  //TdsdFormStorageFactory.GetStorage.Load('TContactPersonKindEditForm');
end;

procedure TLoadFormTest.LoadPartionRemainsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionRemainsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionRemainsForm');
end;

procedure TLoadFormTest.LoadPaidKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPaidKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPaidKindForm');
end;


procedure TLoadFormTest.LoadPairDayFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPairDayForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPairDayForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPairDayEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPairDayEditForm');
end;

procedure TLoadFormTest.LoadPartionCellFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionCellCheckisManyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionCellCheckisManyEditForm');
  exit;
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionCellCheckEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionCellCheckEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionCellChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionCellChoiceForm');
  exit;
}
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionCellForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionCellForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionCell_listForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionCell_listForm');
 // TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionCellEditForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPartionCellEditForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionCellChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionCellChoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionCellChoiceAllForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionCellChoiceAllForm');

//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionCellMovementForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TPartionCellMovementForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionCellCheckEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionCellCheckEditForm');
   }
end;

procedure TLoadFormTest.LoadReestrKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrKindForm');
end;

procedure TLoadFormTest.LoadReasonFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReasonForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReasonForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReasonEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReasonEditForm');
end;


procedure TLoadFormTest.LoadReplFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReplServerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReplServerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReplServerEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReplServerEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReplObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReplObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReplObjectEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReplObjectEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReplMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReplMovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReplMovementEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReplMovementEditForm');
end;

procedure TLoadFormTest.LoadReestrFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrJournal_byReportForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrJournal_byReportForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrJournalForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrStartMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrStartMovementForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrUpdateMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrUpdateMovementForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSale_ReestrJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSale_ReestrJournalForm');
   {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrStartDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrStartDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrUpdateDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrUpdateDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrPrintDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrPrintDialogForm');
    }
end;

procedure TLoadFormTest.LoadReestrTransportGoodsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrTransportGoodsJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrTransportGoodsJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrTransportGoodsStartMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrTransportGoodsStartMovementForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrTransportGoodsUpdateMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrTransportGoodsUpdateMovementForm');
end;

procedure TLoadFormTest.LoadReestrIncomeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrIncomeJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrIncomeJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrIncomeStartMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrIncomeStartMovementForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrIncomeUpdateMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrIncomeUpdateMovementForm');
end;

    procedure TLoadFormTest.LoadReestrReturnOutFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrReturnOutJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrReturnOutJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrReturnOutStartMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrReturnOutStartMovementForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrReturnOutUpdateMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrReturnOutUpdateMovementForm');
end;

procedure TLoadFormTest.LoadReestrReturnFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrReturnJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrReturnJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrReturnStartMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrReturnStartMovementForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrReturnUpdateMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrReturnUpdateMovementForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSale_ReestrJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSale_ReestrJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrStartDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrStartDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrUpdateDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrUpdateDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReestrPrintDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReestrPrintDialogForm');

end;

procedure TLoadFormTest.LoadDocumentKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDocumentKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDocumentKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDocumentKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDocumentKindEditForm');
end;

procedure TLoadFormTest.LoadDocumentTaxKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDocumentTaxKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDocumentTaxKindForm');
end;

procedure TLoadFormTest.LoadEDIForm;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEDIJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEDIJournalForm');
  // exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEDIJournalLoadForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEDIJournalLoadForm');

  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEDI_SendJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEDI_SendJournalForm');
//  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEDIJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEDIJournalForm');
  // exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEDIJournalLoadForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEDIJournalLoadForm');
end;

procedure TLoadFormTest.LoadEmailForm;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TExportKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TExportKindForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmailToolsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmailToolsForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmailSettingsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmailSettingsForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmailKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmailKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmailKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmailKindEditForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TExportJuridicalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TExportJuridicalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TExportJuridicalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TExportJuridicalEditForm');

end;

procedure TLoadFormTest.LoadExternalForm;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaveTaxDocumentForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaveTaxDocumentForm');
  exit;
 }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaveDocumentTo1CForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaveDocumentTo1CForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaveMarketingDocumentTo1CForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaveMarketingDocumentTo1CForm');
end;

procedure TLoadFormTest.LoadPartnerFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartner_CategoryEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartner_CategoryEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerPersonalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerPersonalForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerContactForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerContactForm');
  //exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerForm');
  //exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartner_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartner_ObjectForm');
  //exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerEditForm');

  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerJuridicalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerJuridicalEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerGLNForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerGLNForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartner_PriceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartner_PriceListForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartner_PriceList_viewForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartner_PriceList_viewForm');
  }
end;

procedure TLoadFormTest.LoadPartnerTagFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerTagForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerTagForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerTagEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerTagEditForm');
end;

procedure TLoadFormTest.LoadPartnerExternalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerExternalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerExternalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerExternalEditForm');
end;

procedure TLoadFormTest.LoadPartionGoodsChoiceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionGoodsAssetChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionGoodsAssetChoiceForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionGoods20202ChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionGoods20202ChoiceForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionGoodsChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionGoodsChoiceForm');
end;

procedure TLoadFormTest.LoadPartionModelFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionModelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionModelForm');
end;

procedure TLoadFormTest.LoadPriceListFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListItem_SeparateForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListItem_SeparateForm');
  exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListEditForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListItemForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListGoodsItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListGoodsItemForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListGoodsItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListGoodsItemEditForm');
    exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceList_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceList_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListTaxDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListTaxDialogForm');
   }
end;

procedure TLoadFormTest.LoadQualityFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsByGoodsKindQualityForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsByGoodsKindQualityForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsQualityForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsQualityForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsQuality_RawForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsQuality_RawForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TQualityForm'));
  TdsdFormStorageFactory.GetStorage.Load('TQualityForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TQualityEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TQualityEditForm');
end;

procedure TLoadFormTest.LoadReportBonusFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitLossService_bySaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitLossService_bySaleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitLossService_bySaleDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitLossService_bySaleDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossService_ContractChildForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossService_ContractChildForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitLossServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitLossServiceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitLossServiceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitLossServiceDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckBonus_IncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckBonus_IncomeForm');
  exit;

    TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckBonusTest2Form'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckBonusTest2Form');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckBonusDetailForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckBonusDetailForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckBonus_SaleReturnForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckBonus_SaleReturnForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckBonusTestForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckBonusTestForm');
  //   exit;
   }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckBonusForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckBonusForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckBonusDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckBonusDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckBonus_JournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckBonus_JournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckBonus_JournalDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckBonus_JournalDialogForm');
  exit;
end;

procedure TLoadFormTest.LoadReportFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Inventory_WeighingFactForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Inventory_WeighingFactForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Inventory_WeighingFactDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Inventory_WeighingFactDialogForm');
  ///exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovement_Inventory_scaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovement_Inventory_scaleForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovement_Inventory_scaleDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovement_Inventory_scaleDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_WeighingPartner_PassportForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_WeighingPartner_PassportForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_WeighingPartner_PassportDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_WeighingPartner_PassportDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_WP_PassportPSWDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_WP_PassportPSWDialogForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Container_dataForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Container_dataForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Container_dataDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Container_dataDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ContractGoodsMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ContractGoodsMovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ContractGoodsMovementDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ContractGoodsMovementDialogForm');
  exit;

 TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_Sale_TotalSumForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Check_Sale_TotalSumForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_Sale_TotalSumDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Check_Sale_TotalSumDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProductionUnion_TaxExitUpdateDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProductionUnion_TaxExitUpdateDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProductionUnion_TaxExitUpdateForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProductionUnion_TaxExitUpdateForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PartionCell_GoodsHistoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PartionCell_GoodsHistoryForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PartionCell_historyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PartionCell_historyForm');
  }
   {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSend_PartionCell_isManyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSend_PartionCell_isManyEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Send_PartionCell_manyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Send_PartionCell_manyForm');
  //exit;
  //

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Send_PartionCellDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Send_PartionCellDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Send_PartionCellForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Send_PartionCellForm');
 // exit;


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Send_PartionCellRemainsDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Send_PartionCellRemainsDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Send_PartionCellRemainsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Send_PartionCellRemainsForm');
  exit;


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PersonalGroupSummAddForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PersonalGroupSummAddForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PersonalGroupSummAddDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PersonalGroupSummAddDialogForm');
   exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_WageWarehouseBranchForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_WageWarehouseBranchForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_WageWarehouseBranchDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_WageWarehouseBranchDialogForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_PartionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_PartionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_PartionDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_PartionDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Sale_BankAccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Sale_BankAccountForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Sale_BankAccountDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Sale_BankAccountDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Send_PersonalGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Send_PersonalGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Send_PersonalGroupDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Send_PersonalGroupDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalDefermentPaymentMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalDefermentPaymentMovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalDefermentPaymentMovementDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalDefermentPaymentMovementDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CashPersonal_toPayForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CashPersonal_toPayForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Remains_PartionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Remains_PartionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Remains_PartionDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Remains_PartionDialogForm');
 // exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleReturnIn_RealExForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleReturnIn_RealExForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleReturnIn_RealExDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleReturnIn_RealExDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_inventoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_inventoryForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_inventoryDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_inventoryDialogForm');
  exit;


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_DefermentPaymentOLAPTableForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_DefermentPaymentOLAPTableForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_DefermentPaymentOLAPTableDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_DefermentPaymentOLAPTableDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_InventoryDetailForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_InventoryDetailForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_InventoryDetailDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_InventoryDetailDialogForm');
  exit;


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Trade_OlapForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Trade_OlapForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Trade_OlapDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Trade_OlapDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_SaleReturnIn_PaidKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_SaleReturnIn_PaidKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_SaleReturnIn_PaidKindDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_SaleReturnIn_PaidKindDialogForm');
  exit;


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Losses_KVKForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Losses_KVKForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Losses_KVKDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Losses_KVKDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_WeighingProduction_KVKForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_WeighingProduction_KVKForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_WeighingProduction_KVKDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_WeighingProduction_KVKDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderGoods_OlapForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderGoods_OlapForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderGoods_OlapDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderGoods_OlapDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsRemains_byPackForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsRemains_byPackForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsRemains_byPackDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsRemains_byPackDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Supply_RemainsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Supply_RemainsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Supply_RemainsDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Supply_RemainsDialogForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Supply_OlapForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Supply_OlapForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Supply_OlapDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Supply_OlapDialogForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SupplyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SupplyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SupplyDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SupplyDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleExternal_GoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleExternal_GoodsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleExternal_GoodsDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleExternal_GoodsDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleExternal_OrderSaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleExternal_OrderSaleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleExternal_OrderSaleDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleExternal_OrderSaleDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleExternalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleExternalDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleExternalDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BalanceNoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_BalanceNoForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderInternalBasis_OlapForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderInternalBasis_OlapForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderInternalBasis_OlapDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderInternalBasis_OlapDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_ProfitLossServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_ProfitLossServiceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_ProfitLossServiceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_ProfitLossServiceDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ReceiptAnalyzeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ReceiptAnalyzeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ReceiptAnalyzeDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ReceiptAnalyzeDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProductionUnionTech_OrderForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProductionUnionTech_OrderForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProductionUnionTech_OrderDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProductionUnionTech_OrderDialogForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_RemainsOLAPTableForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_RemainsOLAPTableForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_RemainsOLAPTableDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_RemainsOLAPTableDialogForm');
   exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Insert_RemainsOLAPTableForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Insert_RemainsOLAPTableForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BalanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_BalanceForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_IncomeKill_OlapForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_IncomeKill_OlapForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_IncomeKill_OlapDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_IncomeKill_OlapDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_HolidayCompensationForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_HolidayCompensationForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_HolidayCompensationDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_HolidayCompensationDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSelect_HolidayCompensation_zpForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSelect_HolidayCompensation_zpForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSelect_HolidayCompensation_dayForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSelect_HolidayCompensation_dayForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_HolidayPersonalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_HolidayPersonalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_HolidayPersonalDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_HolidayPersonalDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProductionSeparate_CheckPriceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProductionSeparate_CheckPriceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProductionSeparate_CheckPriceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProductionSeparate_CheckPriceDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Income_OlapForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Income_OlapForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Income_OlapDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Income_OlapDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Sale_OlapForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Sale_OlapForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Sale_OlapDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Sale_OlapDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProductionUnion_OlapForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProductionUnion_OlapForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProductionUnion_OlapDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProductionUnion_OlapDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckTaxCorrective_NPPForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckTaxCorrective_NPPForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckTC_NPPDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckTC_NPPDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Remains_byOrderExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Remains_byOrderExternalForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Remains_byOrderExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Remains_byOrderExternalForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_OrderInternalBySendForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Check_OrderInternalBySendForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_OrderInternalBySendDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Check_OrderInternalBySendDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MotionGoodsWeekForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MotionGoodsWeekForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MotionGoodsWeekDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MotionGoodsWeekDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SupplyBalanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SupplyBalanceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SupplyBalanceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SupplyBalanceDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MotionGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MotionGoodsForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MotionGoodsDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MotionGoodsDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MotionGoodsUpakForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MotionGoodsUpakForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MotionGoodsCehForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MotionGoodsCehForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsBalance_ServerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsBalance_ServerForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsBalanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsBalanceForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsBalanceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsBalanceDialogForm');
 exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BalanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_BalanceForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BalanceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_BalanceDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Balance_gridForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Balance_gridForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitLoss_gridForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitLoss_gridForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitLoss_gridDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitLoss_gridDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitLossForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitLossDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitLossDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_HistoryCost_CompareDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_HistoryCost_CompareDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_HistoryCost_CompareForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_HistoryCost_CompareForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_HistoryCostForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_HistoryCostForm');
  //

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_HistoryCost_DifferenceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_HistoryCost_DifferenceDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_HistoryCost_DifferenceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_HistoryCost_DifferenceForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_byMovementSaleReturnForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_byMovementSaleReturnForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_byMovementSaleReturnDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_byMovementSaleReturnDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_byMovementRealForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_byMovementRealForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_byMovementRealDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_byMovementRealDialogForm');
  //exit;

  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_byMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_byMovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_byMovementDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_byMovementDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MotionGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MotionGoodsForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MotionGoodsDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MotionGoodsDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MotionGoodsUpakForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MotionGoodsUpakForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MotionGoodsCehForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MotionGoodsCehForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsBalanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsBalanceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsBalanceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsBalanceDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_AccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_AccountForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_AccountDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_AccountDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_AccountMotionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_AccountMotionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_AccountMotionDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_AccountMotionDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Account_noBalanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Account_noBalanceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_AccountMotion_noBalanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_AccountMotion_noBalanceForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TransportHoursWorkForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TransportHoursWorkForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TransportHoursWorkDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TransportHoursWorkDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsTaxForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsTaxForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsTaxDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsTaxDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsDialogForm');
    exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_TransferDebtForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_TransferDebtForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_TransferDebtDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_TransferDebtDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMIForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMIForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_DialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_DialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_SendOnPriceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_SendOnPriceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_SendOnPriceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_SendOnPriceDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_byMovementAllForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_byMovementAllForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_byMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_byMovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_byMovementDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_byMovementDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_byMovementDifForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_byMovementDifForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_byMovementDifDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_byMovementDifDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_byPriceDifForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_byPriceDifForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_byPriceDifDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_byPriceDifDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_SaleReturnInNotOlapForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_SaleReturnInNotOlapForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_SaleReturnInForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_SaleReturnInForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_SaleReturnInDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_SaleReturnInDialogForm');
     exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_SaleReturnIn_BUHForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_SaleReturnIn_BUHForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_SaleReturnInUnitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_SaleReturnInUnitForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_SaleReturnInUnitNewForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_SaleReturnInUnitNewForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_SaleReturnIn_ExpensesForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_SaleReturnIn_ExpensesForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalSoldForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalSoldForm');
  exit;


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalSoldDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalSoldDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalDefermentPayment_BranchForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalDefermentPayment_BranchForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalDefermentPayment_BranchDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalDefermentPayment_BranchDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalSold_BranchForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalSold_BranchForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalSold_BranchDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalSold_BranchDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalCollationForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalCollationForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalCollationDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalCollationDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportCollation_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReportCollation_ObjectForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportCollation_ObjectDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReportCollation_ObjectDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportCollation_UpdateObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReportCollation_UpdateObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReportCollation_UpdateObjectDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReportCollation_UpdateObjectDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_IncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_IncomeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_IncomeDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_IncomeDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_IncomeByPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_IncomeByPartnerForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalDefermentDebetForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalDefermentDebetForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalDefermentPayment365Form'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalDefermentPayment365Form');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalDefermentPaymentForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalDefermentPaymentForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalDefermentPaymentDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalDefermentPaymentDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalDefermentIncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalDefermentIncomeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalDefermentIncomeDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalDefermentIncomeDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckTaxDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckTaxDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckTaxForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckTaxForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckTaxCorrectiveForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckTaxCorrectiveForm');
  exit;


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckContractInMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckContractInMovementForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderExternal_MIChild_DetailForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderExternal_MIChild_DetailForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderExternal_UpdateForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderExternal_UpdateForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderExternal_UpdateDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderExternal_UpdateDialogForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_OrderExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_OrderExternalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_OrderExternalDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_OrderExternalDialogForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_OrderExternal_SaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_OrderExternal_SaleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_OrderExternal_SaleDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_OrderExternal_SaleDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleOrderExternalListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleOrderExternalListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleOrderExternalListDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleOrderExternalListDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_ProductionUnion_diffForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_ProductionUnion_diffForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_ProductionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_ProductionForm');
  ///exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_ProductionDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_ProductionDialogForm');
  //exit;
  }

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_ProductionSeparate_TotalDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_ProductionSeparate_TotalDialogForm');;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_ProductionSeparate_TotalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_ProductionSeparate_TotalForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_ProductionSeparateForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_ProductionSeparateForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_ProductionSeparateUnionDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_ProductionSeparateUnionDialogForm');
  exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_ProductionUnionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_ProductionUnionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_ProductionUnionDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_ProductionUnionDialogForm');
  exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_ProductionUnionMDForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_ProductionUnionMDForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_WeighingForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_WeighingForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_WeighingDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_WeighingDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PersonalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PersonalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PersonalDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PersonalDialogForm');
   exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Personal_ServiceSummForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Personal_ServiceSummForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Personal_MoneySummForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Personal_MoneySummForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MemberForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MemberForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MemberDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MemberDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CashForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CashDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CashDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BankAccount_Cash_OlapForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_BankAccount_Cash_OlapForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BankAccount_Cash_OlapDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_BankAccount_Cash_OlapDialogForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Cash_OlapForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Cash_OlapForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Cash_OlapDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Cash_OlapDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CashUserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CashUserForm');
      TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CashUserDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CashUserDialogForm');
exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BankAccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_BankAccountForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BankAccountDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_BankAccountDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_FoundersForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_FoundersForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_FoundersDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_FoundersDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_DefrosterForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_DefrosterForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_DefrosterDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_DefrosterDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_PackageForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_PackageForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_PackageDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_PackageDialogForm');
  exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PersonalCompleteDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PersonalCompleteDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PersonalCompleteForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PersonalCompleteForm');
   exit;
   {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_InternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_InternalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_InternalDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_InternalDialogForm');
  exit;
  //����� �������� ���-�� � �������� ��������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_ReturnInToLinkForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Check_ReturnInToLinkForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Check_ReturnInToLinkDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Check_ReturnInToLinkDialogForm');
  }
end;

procedure TLoadFormTest.LoadReportAssetFormTest;
begin
{
TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_AssetRepairForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_AssetRepairForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_AssetRepairDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_AssetRepairDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalSold_AssetNoBalanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalSold_AssetNoBalanceForm');
  exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MotionGoodsAssetNoBalanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MotionGoodsAssetNoBalanceForm');
  exit;
  //exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MotionGoodsAssetForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MotionGoodsAssetForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MotionGoodsAssetDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MotionGoodsAssetDialogForm');
end;

procedure TLoadFormTest.LoadReportTaraFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleTare_GofroDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleTare_GofroDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleTare_GofroForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleTare_GofroForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderReturnTareDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderReturnTareDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderReturnTareForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderReturnTareForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderReturnTare_ReturnInForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderReturnTare_ReturnInForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderReturnTare_SaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderReturnTare_SaleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderReturnTare_OrderForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderReturnTare_OrderForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TaraForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TaraForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TaraMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TaraMovementForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TaraDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TaraDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerAndUnitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerAndUnitForm');
end;

procedure TLoadFormTest.LoadReportTransportFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TransportTireForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TransportTireForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TransportTireDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TransportTireDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TransportRepairForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TransportRepairForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TransportRepairDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TransportRepairDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Transport_CostForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Transport_CostForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Transport_CostDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Transport_CostDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TransportFuelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TransportFuelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TransportFuelDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TransportFuelDialogForm');
  exit;

//exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_FuelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_FuelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_FuelDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_FuelDialogForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TransportForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TransportForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TransportDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TransportDialogForm');
  exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TransportListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TransportListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TransportListDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TransportListDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Transport_ProfitLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Transport_ProfitLossForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Transport_ProfitLossDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Transport_ProfitLossDialogForm');
  }
end;

procedure TLoadFormTest.LoadReportWageFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_StaffListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_StaffListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_StaffListDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_StaffListDialogForm');
  exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_WageForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_WageForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_WageDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_WageDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Wage_ServerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Wage_ServerForm');
end;

procedure TLoadFormTest.LoadReportBankAccountCashFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BankAccount_CashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_BankAccount_CashForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BankAccount_CashDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_BankAccount_CashDialogForm');
end;

procedure TLoadFormTest.LoadReportInvoiceFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_InvoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_InvoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_InvoiceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_InvoiceDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_InvoiceDetailForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_InvoiceDetailForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PromoInvoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PromoInvoiceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PromoInvoiceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PromoInvoiceDialogForm');
  }
end;

procedure TLoadFormTest.LoadReportBranchFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Branch_App1_FullForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Branch_App1_FullForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Branch_App7_FullForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Branch_App7_FullForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Branch_App7Form'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Branch_App7Form');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Branch_App7DialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Branch_App7DialogForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Branch_App7_NewForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Branch_App7_NewForm');
  {
  //TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Branch_App1_NewForm'));
  //TdsdFormStorageFactory.GetStorage.Load('TReport_Branch_App1_NewForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Branch_App1Form'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Branch_App1Form');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Branch_App1DialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Branch_App1DialogForm');

  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Branch_CashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Branch_CashForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Branch_CashDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Branch_CashDialogForm');

end;

procedure TLoadFormTest.LoadReportSystemFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Protocol_ChangeStatusForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Protocol_ChangeStatusForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Protocol_ChangeStatusDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Protocol_ChangeStatusDialogForm');
  exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MIProtocolUpdateForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MIProtocolUpdateForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementProtocolGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MovementProtocolGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementProtocolGroupDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MovementProtocolGroupDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MovementProtocolForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementProtocolDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MovementProtocolDialogForm');
  exit;
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MIProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MIProtocolForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MIProtocolDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MIProtocolDialogForm');
  exit;
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_LoginProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_LoginProtocolForm');
   }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_UserProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_UserProtocolForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_UserProtocolDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_UserProtocolDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_UserProtocolViewForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_UserProtocolViewForm');
end;

procedure TLoadFormTest.LoadReportProductionOrderFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionOrderReportForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionOrderReportForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProductionOrderDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProductionOrderDialogForm');
end;

procedure TLoadFormTest.LoadReportProductionAnalyzeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProductionUnionTech_AnalysForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProductionUnionTech_AnalysForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProductionUnionTech_AnalysDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProductionUnionTech_AnalysDialogDialogForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ReceiptProductionAnalyzeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ReceiptProductionAnalyzeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ReceiptProductionAnalyzeDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ReceiptProductionAnalyzeDialogForm');
  }
  end;

procedure TLoadFormTest.LoadReportSaleAnalyzeFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ReceiptSaleAnalyzeDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ReceiptSaleAnalyzeDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ReceiptSaleAnalyzeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ReceiptSaleAnalyzeForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ReceiptSaleAnalyzeRealDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ReceiptSaleAnalyzeRealDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ReceiptSaleAnalyzeRealForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ReceiptSaleAnalyzeRealForm');
end;

procedure TLoadFormTest.LoadReportSheetWorkTimeFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SheetWorkTime_UpdateForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SheetWorkTime_UpdateForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SheetWorkTime_UpdateDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SheetWorkTime_UpdateDialogForm');
   exit;
  {

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SheetWorkTimeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SheetWorkTimeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SheetWorkTimeDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SheetWorkTimeDialogForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SheetWorkTime_GraphForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SheetWorkTime_GraphForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SheetWorkTime_GraphDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SheetWorkTime_GraphDialogForm');
  exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SheetWorkTime_OutForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SheetWorkTime_OutForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SheetWorkTime_OutDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SheetWorkTime_OutDialogForm');
  exit;
  }
end;

procedure TLoadFormTest.LoadReportProductionOutAnalyzeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ReceiptProductionOutAnalyzeLineForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ReceiptProductionOutAnalyzeLineForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ReceiptProductionOutAnalyzeTestForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ReceiptProductionOutAnalyzeTestForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ReceiptProductionOutAnalyzeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ReceiptProductionOutAnalyzeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ReceiptProductionOutAnalyzeDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ReceiptProductionOutAnalyzeDialogForm');
end;

procedure TLoadFormTest.LoadReportPromoFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Promo_DetailErrorForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Promo_DetailErrorForm');
   exit;

   {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Promo_MarketForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Promo_MarketForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Promo_MarketDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Promo_MarketDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Promo_PlanFactForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Promo_PlanFactForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Promo_PlanFactDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Promo_PlanFactDialogForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleReturn_byPromoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleReturn_byPromoForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Promo_TradeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Promo_TradeForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Promo_Result_MonthForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Promo_Result_MonthForm');
  exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Promo_ResultForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Promo_ResultForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Promo_Result_TradeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Promo_Result_TradeForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Promo_ResultDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Promo_ResultDialogForm');
  //

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PromoPlanForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PromoPlanForm');
  //
   }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PromoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PromoForm');
   {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PromoDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PromoDialogForm');
  }
end;

procedure TLoadFormTest.LoadVisitFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TVisitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TVisitForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TVisitJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TVisitJournalForm');
end;

procedure TLoadFormTest.LoadUnionFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromo_ServiceGoodsJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromo_ServiceGoodsJournalChoiceForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAssetGroup_GoodsGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAssetGroup_GoodsGroupForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalServiceList_Unit_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalServiceList_Unit_ObjectForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalRetailPartner_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalRetailPartner_ObjectForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalUnitFounder_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalUnitFounder_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSourceFuel_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSourceFuel_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStoragePlace_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStoragePlace_ObjectForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMoneyPlace_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMoneyPlace_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMoneyPlaceCash_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMoneyPlaceCash_ObjectForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsFuel_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsFuel_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberPlace_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberPlace_ObjectForm');
  }
end;

procedure TLoadFormTest.LoadUnitFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_PersonalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnit_PersonalForm');
   // exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitForm');
   /// exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitEditForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitTreeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitTreeForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnit_ObjectForm');
   exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_SheetWorkTimeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnit_SheetWorkTimeForm');
end;

  procedure TLoadFormTest.LoadUnitPeresortFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitPeresortForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitPeresortForm');

end;

procedure TLoadFormTest.LoadUserByGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserByGroupListTreeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserByGroupListTreeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserByGroupListEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserByGroupListEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserByGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserByGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserByGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserByGroupEditForm');
end;

procedure TLoadFormTest.LoadToolsWeighingFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TToolsWeighingEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TToolsWeighingEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TToolsWeighingTreeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TToolsWeighingTreeForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TToolsWeighingPlace_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TToolsWeighingPlace_ObjectForm');
end;

procedure TLoadFormTest.LoadTelegramGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTelegramGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTelegramGroupEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTelegramGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTelegramGroupForm');
end;

{procedure TLoadFormTest.LoadUnitGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitGroupEditForm');
end; }

procedure TLoadFormTest.LoadInfoMoneyFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyGroupEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyGroupForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyGroup_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyGroup_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyGroup_ObjectDescForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyGroup_ObjectDescForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyDestinationEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyDestinationEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyDestinationForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyDestinationForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyDestination_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyDestination_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyDestination_ObjectDescForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyDestination_ObjectDescForm');
   }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoney_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoney_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoney_ObjectDescForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoney_ObjectDescForm');
  }
end;

procedure TLoadFormTest.Load1CLinkFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartner1CLink_ExcelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartner1CLink_ExcelForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartner1CLinkForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartner1CLinkForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartner1CLinkPlaceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartner1CLinkPlaceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsByGoodsKind1CLinkForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsByGoodsKind1CLinkForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLoadSaleFrom1CForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLoadSaleFrom1CForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLoadMoneyFrom1CForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLoadMoneyFrom1CForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBranchLinkForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBranchLinkForm');
end;

procedure TLoadFormTest.LoadAccountFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountGroupEditForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountGroupForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountGroup_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountGroup_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountGroup_ObjectDescForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountGroup_ObjectDescForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountDirectionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountDirectionEditForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountDirectionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountDirectionForm');
  {TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountDirection_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountDirection_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountDirection_ObjectDescForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountDirection_ObjectDescForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountEditForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountForm');

  {TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccount_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccount_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccount_ObjectDescForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccount_ObjectDescForm');
  }
end;

procedure TLoadFormTest.LoadProfitLossFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossGroupEditForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossGroupForm');
  {TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossGroup_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossGroup_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossDirectionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossDirectionEditForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossDirectionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossDirectionForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossDirection_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossDirection_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossEditForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLoss_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLoss_ObjectForm');
  }
end;

procedure TLoadFormTest.LoadProfitLossServiceFormTest;
begin


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossServiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossServiceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossServiceJournalForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossService_51201JournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossService_51201JournalForm')
end;

procedure TLoadFormTest.LoadProfitLossResultFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossResultForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossResultForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossResultJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossResultJournalForm');

end;
procedure TLoadFormTest.LoadProfitIncomeServiceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitIncomeServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitIncomeServiceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitIncomeServiceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitIncomeServiceJournalForm');
end;


procedure TLoadFormTest.LoadPromoFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromo_MI_DetailForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromo_MI_DetailForm');
  {
   TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractChoice_byPromoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractChoice_byPromoForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChangePercentDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChangePercentDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoManagerDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoManagerDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoManagerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoManagerForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoManagerJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoManagerJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoJournalForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoForm');
   {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoInvoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoInvoiceForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoPartnerForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoContractBonus_DetailForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoContractBonus_DetailForm');
  }
end;

procedure TLoadFormTest.LoadPromoTradeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoTradeDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoTradeDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoItemForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoItemEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoTradeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoTradeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoTradeJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoTradeJournalForm');

end;
procedure TLoadFormTest.LoadPromoKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoKindForm');
end;
procedure TLoadFormTest.LoadPromoStateKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPromoStateKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPromoStateKindForm');
end;

procedure TLoadFormTest.LoadTradeMarkFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTradeMarkForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTradeMarkForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTradeMarkEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTradeMarkEditForm');
end;

procedure TLoadFormTest.LoadAreaUnitFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAreaUnitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAreaUnitForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAreaUnitEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAreaUnitkEditForm');
end;

procedure TLoadFormTest.LoadAssetFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAsset_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAsset_ObjectForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAsset_DocGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAsset_DocGoodsForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAssetForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAssetForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAssetEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAssetEditForm');
   {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAssetTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAssetTypeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAssetTypeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAssetTypeEditForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAssetGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAssetGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAssetGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAssetGroupEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCountryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCountryForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCountryEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCountryEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMakerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMakerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMakerEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMakerEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAssetGoodsPlaceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAssetGoodsPlaceForm');

  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAssetToPlaceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAssetToPlaceForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAssetGoods_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAssetGoods_ObjectForm');
  }
end;

procedure TLoadFormTest.LoadArticleLossFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TArticleLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TArticleLossForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TArticleLossEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TArticleLossEditForm');
end;

procedure TLoadFormTest.LoadAdvertisingFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAdvertisingForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAdvertisingForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAdvertisingEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAdvertisingEditForm');
end;

procedure TLoadFormTest.LoadAddressFormTest;
begin
{
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerAddressForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerAddressForm');
  exit;
  // �������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRegionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRegionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRegionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRegionEditForm');
  // �����
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProvinceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProvinceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProvinceEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProvinceEditForm');
  // ��� ����������� ������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCityKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCityKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCityKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCityKindEditForm');
    }
  // ���������� �����
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCityForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCityForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCityEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCityEditForm');

  // ��� ����������� ������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCityKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCityKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCityKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCityKindEditForm');
  //�����
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStreetForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStreetForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStreetEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStreetEditForm');
  // ��� �����/��������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStreetKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStreetKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStreetKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStreetKindEditForm');
  // ����� � ���������� ������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProvinceCityForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProvinceCityForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProvinceCityEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProvinceCityEditForm');
end;

procedure TLoadFormTest.LoadStorage_ObjectFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStorage_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStorage_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStorage_ObjectEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStorage_ObjectEditForm');
end;

procedure TLoadFormTest.LoadStorageLineFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStorageLineForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStorageLineForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStorageLineEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStorageLineEditForm');
end;

procedure TLoadFormTest.LoadStickerFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerHeaderForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerHeaderForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerHeaderEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerHeaderEditForm');
   exit;
   }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSticker_ListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSticker_ListForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerEditForm');
  //exit;
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSticker_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSticker_ObjectForm');
  //exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerProperty_ValueForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerProperty_ValueForm');
  exit;
  //Property

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerPropertyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerPropertyEditForm');

  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerGroupEditForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerTypeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerTypeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerTypeEditForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerTagForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerTagForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerTagEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerTagEditForm');
  //

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerSortForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerSortForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerSortEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerSortEditForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerNormForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerNormForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerNormEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerSortNormForm');
  //

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerFileForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerFileForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerFileEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerFileEditForm');
  exit;

  //StickerPack
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerPackForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerPackForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerPackEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerPackEditForm');
  // StickerSkin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerSkinForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerSkinForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStickerSkinEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStickerSkinEditForm');

  //Language
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLanguageForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLanguageForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLanguageEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLanguageEditForm');
  }
end;

procedure TLoadFormTest.LoadStoreRealFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStoreRealForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStoreRealForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStoreRealJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStoreRealJournalForm');
end;

  procedure TLoadFormTest.LoadSubjectDocFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSubjectDocForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSubjectDocForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSubjectDocEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSubjectDocEditForm');
end;

procedure TLoadFormTest.LoadRoleFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleMaskEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoleMaskEditForm');
  //�� �����
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoleEditForm');
 }
  //��������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleUnionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoleUnionForm');
end;

procedure TLoadFormTest.LoadRouteFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoute_SelfForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoute_SelfForm');
  exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoute_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoute_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteEditForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteMemberForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteMemberForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteMemberEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteMemberEditForm');
end;

procedure TLoadFormTest.LoadRouteGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteGroupEditForm');
end;

procedure TLoadFormTest.LoadRouteNumFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteNumForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteNumForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteNumEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteNumEditForm');
end;

procedure TLoadFormTest.LoadRouteSortingFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteSortingForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteSortingForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteSorting_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteSorting_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteSortingEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteSortingEditForm');
  // ���� ���������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteKindForm');
end;

procedure TLoadFormTest.LoadMemberFormTest;
begin

  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberGLNDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberGLNDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberGLNEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberGLNEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberReportEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberReportEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberReportForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberReportForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMember_ContainerByDebtForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMember_ContainerByDebtForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGenderEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGenderEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGenderForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGenderForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJobSourceEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJobSourceEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJobSourceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJobSourceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberSkillEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberSkillEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberSkillForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberSkillForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberHoliday_ChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberHoliday_ChoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMember_ChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMember_ChoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalPosition_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalPosition_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberPosition_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberPosition_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberForm');
  exit;
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMember_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMember_ObjectForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMember_ObjectDescForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMember_ObjectDescForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMember_ContainerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMember_ContainerForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMember_TrasportForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMember_TrasportForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMember_TrasportDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMember_TrasportDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMember_TrasportDateDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMember_TrasportDateDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMember_TrasportChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMember_TrasportChoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMember_ObjectToEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMember_ObjectToEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMember_ObjectToForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMember_ObjectToForm');
  }
end;

procedure TLoadFormTest.LoadMemberMinusFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberMinusForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberMinusForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberMinusEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberMinusEditForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberExternal_Juridical_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberExternal_Juridical_ObjectForm');
end;

procedure TLoadFormTest.LoadMemberBankAccountFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberBankAccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberBankAccountForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberBankAccountEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberBankAccountEditForm');
end;

procedure TLoadFormTest.LoadMemberBranchFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberBranchForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberBranchForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberBranchEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberBranchEditForm');
end;

procedure TLoadFormTest.LoadMemberExternalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberExternalForm');
  //TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberExternal_ObjectForm'));
  //TdsdFormStorageFactory.GetStorage.Load('TMemberExternal_ObjectForm');
  {TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberExternalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberExternalEditForm');
  }
end;

procedure TLoadFormTest.LoadMemberSheetWorkTimeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberSheetWorkTimeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberSheetWorkTimeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberSheetWorkTimeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberSheetWorkTimeEditForm');
end;

   procedure TLoadFormTest.LoadMemberPriceListFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberPriceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberPriceListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberPriceListEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberPriceListEditForm');
end;

procedure TLoadFormTest.LoadViewPriceListFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TViewPriceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TViewPriceListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TViewPriceListEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TViewPriceListEditForm');
end;

procedure TLoadFormTest.LoadMemberPersonalServiceListFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberPersonalServiceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberPersonalServiceListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberPersonalServiceListEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberPersonalServiceListEditForm');
end;

procedure TLoadFormTest.LoadWorkTimeKindFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWorkTimeKind_HolidayForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWorkTimeKind_HolidayForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWorkTimeKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWorkTimeKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWorkTimeKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWorkTimeKindEditForm');
  }
    //����� ������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWorkTimeKind_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWorkTimeKind_ObjectForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWorkTimeKindSummDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWorkTimeKindSummDialogForm');
  //
end;

procedure TLoadFormTest.LoadSmsSettingsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSmsSettingsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSmsSettingsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSmsSettingsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSmsSettingsEditForm');
end;

procedure TLoadFormTest.LoadSectionFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSectionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSectionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSectionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSectionEditForm');
end;

procedure TLoadFormTest.LoadStaffListFormTest;
begin

  //������� ���������� ������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStaffListDataForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStaffListDataForm');
  {//������� ���������� �����
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStaffListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStaffListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStaffListEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStaffListEditForm');
  //���� ���� ��� �������� ����������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStaffListSummKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStaffListSummKindForm');

  //��������� ������� ����
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCalendarForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCalendarForm');
  }
  end;

 procedure TLoadFormTest.LoadMessagePersonalServiceLastFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMessagePersonalServiceLastForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMessagePersonalServiceLastForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMessagePersonalService_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMessagePersonalService_ObjectForm');
end;

procedure TLoadFormTest.LoadMobileTariffFormTest;
begin
  {// ����� ����������� ������ ��������� ����������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileTariffForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileTariffForm');
  // ����� ������ ������ ����������� ������ ��������� ����������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileTariffEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileTariffEditForm');
  }
  // ����� ����������� ��������� �������� �����������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileEmployeeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileEmployeeForm');

  // ����� ������ ������ ����������� ������ ��������� ����������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileEmployeeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileEmployeeEditForm');
    exit;
  // ����� - OLD
  // ����� ������ ����� ������� ��������� ����� �� �����������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MobileKSForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MobileKSForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileTariff2Form'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileTariff2Form');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileTariffEdit2Form'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileTariffEdit2Form');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileNumbersEmployee2Form'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileNumbersEmployee2Form');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileNumbersEmployeeEdit2Form'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileNumbersEmployeeEdit2Form');
end;

procedure TLoadFormTest.LoadMobileBillsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileBillsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileBillsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileBillsJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileBillsJournalForm');
end;

 procedure TLoadFormTest.LoadMemberHolidayFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberHolidayForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberHolidayForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberHolidayJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberHolidayJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberHolidayEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberHolidayEditForm');
end;
 procedure TLoadFormTest.LoadHospitalDoc_1CFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('THospitalDoc_1CJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('THospitalDoc_1CJournalForm');
end;

procedure TLoadFormTest.LoadMobileProjectFormTest;
begin
   {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileMemberDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileMemberDialogForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileMovement_DateDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileMovement_DateDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobilePackForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobilePackForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobilePackEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobilePackEditForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileReturnInJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileReturnInJournalForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobilePromoJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobilePromoJournalForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobilePromoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobilePromoForm');
  exit;
  //

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileOrderExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileOrderExternalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileOrderExternalJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileOrderExternalJournalForm');
  //exit;
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileContract_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileContract_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileConst_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileConst_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobilePriceListItems_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobilePriceListItems_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobilePartner_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobilePartner_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileGoodsByGoodsKind_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileGoodsByGoodsKind_ObjectForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMobileGoodsListSale_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMobileGoodsListSale_ObjectForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteMemberJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteMemberJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteMemberMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteMemberMovementForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPhotoMobileForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPhotoMobileForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPhotoMobileEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPhotoMobileEditForm');
end;

procedure TLoadFormTest.LoadMobileReportFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleOrderExtList_MobileForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleOrderExtList_MobileForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SaleOrderExtList_MobileDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SaleOrderExtList_MobileDialogForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Mobile_OrderExternal_SaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Mobile_OrderExternal_SaleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Mobile_OrderExternal_SaleDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Mobile_OrderExternal_SaleDialogForm');
  }
end;
procedure TLoadFormTest.LoadModelServiceFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TModelService_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TModelService_ObjectForm');
 exit;

 //���� ������ ����������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TModelServiceKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TModelServiceKindForm');
  }
  //���� ������ ������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TModelServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TModelServiceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TModelServiceEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TModelServiceEditForm');
  exit;
   {
  //���� ������ ������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSelectKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSelectKindForm');
  //���� ����������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementDescForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementDescForm');
  }
end;

procedure TLoadFormTest.LoadMovementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementGoodsBarCodeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementGoodsBarCodeForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementGoodsJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementGoodsJournalForm');
end;

procedure TLoadFormTest.LoadPositionFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionMember_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionMember_ObjectForm');
  }
  // ���������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionEditForm');
  {
  // ������ ���������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionLevelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionLevelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionLevelEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionLevelEditForm');
  }
  // ������������� ���������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionPropertyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionPropertyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionPropertyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionPropertyEditForm');
end;

procedure TLoadFormTest.LoadPersonalFormTest;
begin
{
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalUnit_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalUnit_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReasonOutForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReasonOutForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReasonOutEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReasonOutEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalEditForm');
 }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonal_ChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonal_ChoiceForm');
  //exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonal_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonal_ObjectForm');
  //exit;
  //  ���������� ������ ��� ������������� � Scale

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberPswDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberPswDialogForm');

  // ����������� �����������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalGroupEditForm');
  }
end;

 procedure TLoadFormTest.LoadPersonalGroupMovementFormTest;
 begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalGroupMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalGroupMovementForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalGroupJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalGroupJournalForm');
end;

procedure TLoadFormTest.LoadCarFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TObjectColorForm'));
  TdsdFormStorageFactory.GetStorage.Load('TObjectColorForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TObjectColorEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TObjectColorEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCarPropertyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCarPropertyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCarPropertyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCarPropertyEditForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBodyTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBodyTypeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBodyTypeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBodyTypeEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCarTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCarTypeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCarTypeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCarTypeEditForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCarForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCarForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCarEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCarEditForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCar_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCar_ObjectForm');
end;

procedure TLoadFormTest.LoadCarExternalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCarExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCarExternalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCarExternalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCarExternalEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCarUnionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCarUnionForm');
end;

procedure TLoadFormTest.LoadCarInfoFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCarInfoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCarInfoForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCarInfoEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCarInfoEditForm');
end;

procedure TLoadFormTest.LoadFuelFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFuelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFuelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFuelEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFuelEditForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRateFuelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRateFuelForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTicketFuelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTicketFuelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTicketFuelEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTicketFuelEditForm');
  //
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCardFuelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCardFuelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCardFuelEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCardFuelEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCardFuelKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCardFuelKindForm');
end;

procedure TLoadFormTest.LoadCarModelFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCarModelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCarModelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCarModelEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCarModelEditForm');
end;

procedure TLoadFormTest.LoadChoiceCellFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChoiceCellForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChoiceCellorm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChoiceCellEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChoiceCellEditForm');
end;

procedure TLoadFormTest.LoadChoiceCellMovementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TChoiceCellJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TChoiceCellJournalForm');

end;

procedure TLoadFormTest.LoadClientKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TClientKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TClientKindForm');
end;

procedure TLoadFormTest.LoadRateFuelKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRateFuelKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRateFuelKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRateFuelKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRateFuelKindEditForm');
end;

procedure TLoadFormTest.LoadFreightFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFreightForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFreightForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFreightEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFreightEditForm');
end;

procedure TLoadFormTest.LoadFounderFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFounderForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFounderForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFounderEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFounderEditForm');
end;

procedure TLoadFormTest.LoadFineSubjectFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFineSubjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFineSubjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFineSubjectEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFineSubjectEditForm');
end;

procedure TLoadFormTest.LoadFounderServiceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFounderServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFounderServiceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFounderServiceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFounderServiceJournalForm');
end;


 procedure TLoadFormTest.LoadWeighingPartnerFormTest;
 begin
    {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingPartner_ActDiffForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingPartner_ActDiffForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingPartner_ActDiffEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingPartner_ActDiffEditForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingPartner_bySaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingPartner_bySaleForm');
   }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingPartnerForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingPartnerJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingPartnerJournalForm');
   exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingPartnerItemJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingPartnerItemJournalForm');
  exit;
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingPartnerDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingPartnerDialogForm');
  exit;
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingPartnerEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingPartnerEditForm');
  //
  }

  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternal_SendOnPriceJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternal_SendOnPriceJournalChoiceForm');
end;

 procedure TLoadFormTest.LoadWeighingProductionFormTest;
 begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingProductionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingProductionForm');
  //exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingProductionJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingProductionJournalForm');
  exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingProductionItemJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingProductionItemJournalForm');
  exit;
  {//
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingProductionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingProductionEditForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingProductionParamEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingProductionParamEditForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingProductionBoxEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingProductionBoxEditForm');


end;

  procedure TLoadFormTest.LoadWeighingProduction_wmsFormTest;
 begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingProduction_wmsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingProduction_wmsForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingProduction_wmsJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingProduction_wmsJournalForm');
  exit;
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsByGoodsKind_wmsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsByGoodsKind_wmsForm');
end;

procedure TLoadFormTest.LoadRetailFormTest;
begin
  // �������� ����
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRetailForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRetailEditForm');
  exit;
    // �������� ���� (�����)
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailReportForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRetailReportForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailReportEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRetailReportEditForm');
  // �������� ����  (�������� ������)
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetail_PrintKindItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRetail_PrintKindItemForm');
end;

procedure TLoadFormTest.LoadReceiptFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptLevelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptLevelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptLevelEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptLevelEditForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptMainGoods_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptMainGoods_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptDialogForm');
  // ���������
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptEditForm');
   exit;
  {
  // ������� � ����������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptCostForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptCostForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptCostEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptCostEditForm');
  //���� ��������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptKindForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceipt_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceipt_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptGoods_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptGoods_ObjectForm');
   }
  // ������������ ��������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptComponentsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptComponentsForm');


end;

procedure TLoadFormTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', gc_AdminPassword, gc_User);
end;

procedure TLoadFormTest.TearDown;
begin
  inherited;

end;


procedure TLoadFormTest.UserFormSettingsTest;
var Form: TForm;
begin


end;

initialization
  TestFramework.RegisterTest('�������� ����', TLoadFormTest.Suite);


end.
