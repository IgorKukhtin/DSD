unit LoadFormTest;

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
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure MainFormTest;
    procedure UserFormSettingsTest;
    procedure Load1CLinkFormTest;
    procedure LoadAccountFormTest;
    procedure LoadAddressFormTest;
    procedure LoadAssetFormTest;
    procedure LoadArticleLossFormTest;
    procedure LoadBankFormTest;
    procedure LoadBankAccountFormTest;
    procedure LoadBankAccountContractFormTest;
    procedure LoadBankAccountDocumentFormTest;
    procedure LoadBankStatementFormTest;
    procedure LoadBonusKindFormTest;
    procedure LoadBranchFormTest;
    procedure LoadBusinessFormTest;
    procedure LoadBoxFormTest;
    procedure LoadCashFormTest;
    procedure LoadCarFormTest;
    procedure LoadCarModelFormTest;
    procedure LoadContractKindFormTest;
    procedure LoadContractFormTest;
    procedure LoadContractPartnerFormTest;
    procedure LoadContractGoodsFormTest;
    procedure LoadContactPersonFormTest;
    procedure LoadCorrespondentAccountFormTest;
    procedure LoadCurrencyFormTest;
    procedure LoadCurrencyMovementFormTest;
    procedure LoadDefaultFormTest;
    procedure LoadDocumentTaxKindFormTest;
    procedure LoadEDIForm;
    procedure LoadExternalForm;
    procedure LoadFreightFormTest;
    procedure LoadFounderFormTest;
    procedure LoadFounderServiceFormTest;
    procedure LoadFuelFormTest;
    procedure LoadGoodsPropertyFormTest;
    procedure LoadGoodsPropertyValueFormTest;
    procedure LoadGoodsQualityFormTest;
    procedure LoadGoodsGroupFormTest;
    procedure LoadGoodsFormTest;
    procedure LoadGoodsKindWeighingFormTest;
    procedure LoadGoodsKindFormTest;
    procedure LoadGoodsTagFormTest;
    procedure LoadImportSettingsFormTest;
    procedure LoadImportTypeFormTest;
    procedure LoadInfoMoneyGroupFormTest;
    procedure LoadInfoMoneyDestinationFormTest;
    procedure LoadInfoMoneyFormTest;
    procedure LoadIncomeFormTest;
    procedure LoadInventoryFormTest;
    procedure LoadJuridicalGroupFormTest;
    procedure LoadJuridicalFormTest;
    procedure LoadLossFormTest;
    procedure LoadLossDebtFormTest;
    procedure LoadMeasureFormTest;
    procedure LoadMemberFormTest;
    procedure LoadModelServiceFormTest;
    procedure LoadMovementFormTest;
    procedure LoadOrderInternalFormTest;
    procedure LoadOrderExternalFormTest;
    procedure LoadOrderTypeFormTest;
    procedure LoadPartnerFormTest;
    procedure LoadPartnerTagFormTest;
    procedure LoadPartionGoodsChoiceFormTest;
    procedure LoadPaidKindFormTest;
    procedure LoadPersonalReportFormTest;
    procedure LoadPersonalAccountFormTest;
    procedure LoadPersonalSendCashFormTest;
    procedure LoadPriceListFormTest;
    procedure LoadPriceCorrectiveFormTest;
    procedure LoadProductionUnionFormTest;
    procedure LoadProductionSeparateFormTest;
    procedure LoadProfitLossFormTest;
    procedure LoadProfitLossServiceFormTest;
    procedure LoadProfitLossGroupFormTest;
    procedure LoadProfitLossDirectionFormTest;
    procedure LoadPositionFormTest;
    procedure LoadPersonalFormTest;
    procedure LoadPersonalServiceFormTest;
    procedure LoadPersonalServiceListFormTest;
    procedure LoadQualityFormTest;
    procedure LoadReportFormTest;
    procedure LoadReportProductionFormTest;
    procedure LoadReturnInFormTest;
    procedure LoadReturnOutFormTest;
    procedure LoadRetailFormTest;
    procedure LoadReceiptFormTest;
    procedure LoadRoleFormTest;
    procedure LoadRouteFormTest;
    procedure LoadRouteSortingFormTest;
    procedure LoadRateFuelKindFormTest;
    procedure LoadSaleFormTest;
    procedure LoadSendFormTest;
    procedure LoadSendDebtFormTest;
    procedure LoadSendOnPriceFormTest;
    procedure LoadServiceDocumentFormTest;
    procedure LoadServiceFormTest;
    procedure LoadSheetWorkTimeFormTest;
    procedure LoadStaffListFormTest;
    procedure LoadStorage_ObjectFormTest;
    procedure LoadTaxFormTest;
    procedure LoadTaxCorrectiveTest;
    procedure LoadTransportFormTest;
    procedure LoadTransportServiceFormTest;
    procedure LoadTransferDebtOutFormTest;
    procedure LoadTransferDebtInFormTest;
    procedure LoadTradeMarkFormTest;
    procedure LoadUnionFormTest;
    procedure LoadUnitFormTest;
    procedure LoadToolsWeighingFormTest;
    procedure LoadWorkTimeKindFormTest;
    procedure LoadWeighingPartnerFormTest;
    procedure LoadWeighingProductionFormTest;
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
     raise Exception.Create('Не зарегистрирован класс: ' + FormClass);
  Application.CreateForm(TComponentClass(GetClass(FormClass)), Result);
end;

procedure TLoadFormTest.LoadBankAccountDocumentFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountMovementForm');
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

procedure TLoadFormTest.LoadBankStatementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankStatementJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankStatementJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankStatementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankStatementForm');
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
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBranch_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBranch_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBranchEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBranchEditForm');
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
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCash_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCash_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashEditForm');

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
end;

procedure TLoadFormTest.LoadContractFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractConditionValueForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractConditionValueForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractChoiceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractChoicePartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractChoicePartnerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractChoicePartnerOrderForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractChoicePartnerOrderForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractEditForm');
  // Состояние договора
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractStateKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractStateKindForm');
  // Предмет договора
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractArticleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractArticleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractArticleEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractArticleEditForm');
  // Регионы
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAreaForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAreaForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAreaEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAreaEditForm');
  // Регионы (договора)
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAreaContractForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAreaContractForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAreaContractEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAreaContractEditForm');
  // Типы условий договоров
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractConditionKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractConditionKindForm');
  // Условия договоров
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractConditionByContractForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractConditionByContractForm');
  // Признак договора
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractTagForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractTagForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractTagEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractTagEditForm');
  // Группы признаков договоров
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractTagGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractTagGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractTagGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractTagGroupEditForm');
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
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractPartnerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractPartnerEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractPartnerEditForm');
end;

procedure TLoadFormTest.LoadContractGoodsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractGoodsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractGoodsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractGoodsEditForm');
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

procedure TLoadFormTest.LoadCurrencyMovementFormTest;
begin
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
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsTreeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsTreeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoods_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoods_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsTree_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsTree_ObjectForm');

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
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroup_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroup_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupEditForm');

  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupStatForm'));
  TdsdFormStorageFactory.GetStorage.Load('GoodsGroupStatForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupStatEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupStatEditForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupAnalystForm'));
  TdsdFormStorageFactory.GetStorage.Load('GoodsGroupAnalystForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupAnalystEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupAnalystEditForm');
end;

procedure TLoadFormTest.LoadGoodsKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsKind_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsKind_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsKindEditForm');
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
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsPropertyValueEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsPropertyValueEditForm');
end;

procedure TLoadFormTest.LoadGoodsQualityFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsQualityForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsQualityForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsQualityMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsQualityMovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsQualityMovementJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsQualityMovementJournalForm');
end;


procedure TLoadFormTest.LoadGoodsTagFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsTagForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsTagForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsTagEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsTagEditForm');
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

procedure TLoadFormTest.LoadPersonalServiceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalServiceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalServiceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalServiceJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalServiceJournalSelectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalServiceJournalSelectForm');
end;

procedure TLoadFormTest.LoadPersonalServiceListFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalServiceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalServiceListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalServiceListEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalServiceListEditForm');
end;

procedure TLoadFormTest.LoadImportSettingsFormTest;
begin
  //Настройки импорта
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportSettingsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportSettingsForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportGroupForm');
end;

procedure TLoadFormTest.LoadImportTypeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFileTypeKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFileTypeKindForm');
  //Типы импорта
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportTypeForm');
end;

procedure TLoadFormTest.LoadIncomeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeJournalForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeFuelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeFuelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeFuelJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeFuelJournalForm');
end;

procedure TLoadFormTest.LoadSendFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendJournalForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendTicketFuelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendTicketFuelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendTicketFuelJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendTicketFuelJournalForm');
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
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalJournalChoiceForm');
  // заявки на главный склад
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalUnitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalUnitForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderExternalUnitJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderExternalUnitJournalForm');
end;

procedure TLoadFormTest.LoadOrderTypeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderTypeForm');
end;

procedure TLoadFormTest.LoadSendDebtFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendDebtForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendDebtForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendDebtJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendDebtJournalForm');
end;
procedure TLoadFormTest.LoadSendOnPriceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendOnPriceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendOnPriceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendOnPriceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendOnPriceJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendOnPrice_BranchForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendOnPrice_BranchForm');
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

procedure TLoadFormTest.LoadServiceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TActionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TActionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProcessForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProcessForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserKeyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserKeyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserEditForm');
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
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPeriodCloseForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPeriodCloseForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPeriodClose_UserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPeriodClose_UserForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportExportLinkForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportExportLinkForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportExportLinkTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportExportLinkTypeForm');

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
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSheetWorkTimeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSheetWorkTimeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSheetWorkTimeJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSheetWorkTimeJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSheetWorkTimeAddRecordForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSheetWorkTimeAddRecordForm');
end;

procedure TLoadFormTest.LoadSaleFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaleJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaleJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSale_PartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSale_PartnerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSale_PartnerJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSale_PartnerJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSale_OrderForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSale_OrderForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSale_OrderJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSale_OrderJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementCheckForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementCheckForm');
end;

procedure TLoadFormTest.LoadTaxFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaxForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaxForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaxJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaxJournalForm');
   //08.04.14 Dima
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaxJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaxJournalChoiceForm');
end;

procedure TLoadFormTest.LoadTaxCorrectiveTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaxCorrectiveForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaxCorrectiveForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaxCorrectiveJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaxCorrectiveJournalForm');
end;

procedure TLoadFormTest.LoadReturnOutFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnOutForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnOutForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnOutJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnOutJournalForm');
end;
procedure TLoadFormTest.LoadReturnInFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnInForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnInForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnInJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnInJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnIn_PartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnIn_PartnerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReturnIn_PartnerJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReturnIn_PartnerJournalForm');
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

procedure TLoadFormTest.LoadLossFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossJournalForm');
end;
procedure TLoadFormTest.LoadLossDebtFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossDebtForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossDebtForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossDebtJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossDebtJournalForm');
end;

procedure TLoadFormTest.LoadInventoryFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryJournalForm');
end;
procedure TLoadFormTest.LoadJuridicalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridical_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridical_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalTreeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalTreeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TJuridicalGLNForm'));
  TdsdFormStorageFactory.GetStorage.Load('TJuridicalGLNForm');
end;
procedure TLoadFormTest.LoadProductionSeparateFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionSeparateForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionSeparateForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionSeparateJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionSeparateJournalForm');
end;
procedure TLoadFormTest.LoadProductionUnionFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionUnionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionUnionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionUnionJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionUnionJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionUnionTechJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionUnionTechJournalForm');


//ProductionUnionTechEditForm
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionUnionTechEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionUnionTechEditForm');

  // 11,12,14 Инна
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionPeresortJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionPeresortJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionPeresortForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionPeresortForm');
end;

procedure TLoadFormTest.LoadTransportFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransportForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransportForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransportJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransportJournalForm');
end;

procedure TLoadFormTest.LoadTransportServiceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransportServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransportServiceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransportServiceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransportServiceJournalForm');
end;

procedure TLoadFormTest.LoadTransferDebtOutFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransferDebtOutForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransferDebtOutForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTransferDebtOutJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTransferDebtOutJournalForm');
  //по заявке
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

procedure TLoadFormTest.LoadBoxFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBoxForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBoxForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBoxEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBoxEditForm');
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
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContactPersonChoiceForm');
  //TdsdFormStorageFactory.GetStorage.Save(GetForm('TContactPersonKindEditForm'));
  //TdsdFormStorageFactory.GetStorage.Load('TContactPersonKindEditForm');
end;

procedure TLoadFormTest.LoadPaidKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPaidKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPaidKindForm');
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
end;

procedure TLoadFormTest.LoadExternalForm;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaveTaxDocumentForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaveTaxDocumentForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaveDocumentTo1CForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaveDocumentTo1CForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaveMarketingDocumentTo1CForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaveMarketingDocumentTo1CForm');
end;

procedure TLoadFormTest.LoadPartnerFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartner_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartner_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerJuridicalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerJuridicalEditForm');
end;

procedure TLoadFormTest.LoadPartnerTagFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerTagForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerTagForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerTagEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerTagEditForm');
end;

procedure TLoadFormTest.LoadPartionGoodsChoiceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionGoodsChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionGoodsChoiceForm');
end;

procedure TLoadFormTest.LoadPriceListFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListItemForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListGoodsItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListGoodsItemForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceList_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceList_ObjectForm');
end;

procedure TLoadFormTest.LoadQualityFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TQualityForm'));
  TdsdFormStorageFactory.GetStorage.Load('TQualityForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TQualityEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TQualityEditForm');



end;

procedure TLoadFormTest.LoadReportFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BalanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_BalanceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitLossForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_HistoryCostForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_HistoryCostForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MotionGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MotionGoodsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MotionGoodsDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MotionGoodsDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_FuelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_FuelForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TransportForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TransportForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_AccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_AccountForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_TransportHoursWorkForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_TransportHoursWorkForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsTaxForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsTaxForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_TransferDebtForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_TransferDebtForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMIForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMIForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_byMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_byMovementForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_byMovementDifForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_byMovementDifForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_byPriceDifForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_byPriceDifForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_SaleReturnInForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_SaleReturnInForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalSoldForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalSoldForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalCollationForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalCollationForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_IncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_IncomeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_IncomeByPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_IncomeByPartnerForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalDefermentPaymentForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalDefermentPaymentForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_JuridicalDefermentIncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_JuridicalDefermentIncomeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckTaxForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckTaxForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckTaxCorrectiveForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckTaxCorrectiveForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckBonusForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckBonusForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CheckContractInMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CheckContractInMovementForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_OrderExternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_OrderExternalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_OrderExternal_SaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_OrderExternal_SaleForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_ProductionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_ProductionForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_ProductionSeparateForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_ProductionSeparateForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_ProductionUnionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_ProductionUnionForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMI_ProductionUnionMDForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMI_ProductionUnionMDForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PersonalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PersonalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MemberForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MemberForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CashForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CashUserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CashUserForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BankAccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_BankAccountForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_FoundersForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_FoundersForm');
end;

procedure TLoadFormTest.LoadReportProductionFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionOrderReportForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionOrderReportForm');
end;

procedure TLoadFormTest.LoadUnionFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSourceFuel_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSourceFuel_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStoragePlace_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStoragePlace_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMoneyPlace_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMoneyPlace_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMoneyPlaceCash_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMoneyPlaceCash_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsFuel_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsFuel_ObjectForm');
end;

procedure TLoadFormTest.LoadUnitFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitTreeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitTreeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnit_ObjectForm');
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



{procedure TLoadFormTest.LoadUnitGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitGroupEditForm');
end; }


procedure TLoadFormTest.LoadInfoMoneyGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyGroup_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyGroup_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyGroupEditForm');
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

procedure TLoadFormTest.LoadProfitLossServiceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossServiceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossServiceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossServiceJournalForm');
end;


procedure TLoadFormTest.LoadTradeMarkFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTradeMarkForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTradeMarkForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTradeMarkEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTradeMarkEditForm');
end;
procedure TLoadFormTest.LoadAssetFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAssetForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAssetForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAssetEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAssetEditForm');

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
end;

procedure TLoadFormTest.LoadArticleLossFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TArticleLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TArticleLossForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TArticleLossEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TArticleLossEditForm');
end;

procedure TLoadFormTest.LoadAddressFormTest;
begin
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerAddressForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerAddressForm');
  // область
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRegionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRegionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRegionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRegionEditForm');
  // Район
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProvinceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProvinceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProvinceEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProvinceEditForm');
  // Вид населенного пункта
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCityKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCityKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCityKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCityKindEditForm');

  // населенный пункт
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCityForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCityForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCityEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCityEditForm');

  // Вид населенного пункта
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCityKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCityKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCityKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCityKindEditForm');
  //улица
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStreetForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStreetForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStreetEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStreetEditForm');
  // вид улица/проспект
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStreetKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStreetKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStreetKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStreetKindEditForm');
  // Район в населенном пункте
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

procedure TLoadFormTest.LoadRoleFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleMaskEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoleMaskEditForm');
  //по маске
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoleEditForm');
  //подробно
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleUnionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoleUnionForm');
end;

procedure TLoadFormTest.LoadRouteFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoute_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoute_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteEditForm');
end;

procedure TLoadFormTest.LoadRouteSortingFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteSortingForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteSortingForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteSorting_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteSorting_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteSortingEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteSortingEditForm');
  // типы маршрутов
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRouteKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRouteKindForm');
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

procedure TLoadFormTest.LoadWorkTimeKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWorkTimeKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWorkTimeKindForm');
  //форма выбора
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWorkTimeKind_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWorkTimeKind_ObjectForm');
end;

procedure TLoadFormTest.LoadStaffListFormTest;
begin
  //штатное расписание данные
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStaffListDataForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStaffListDataForm');
  //штатное расписание выбор
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStaffListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStaffListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStaffListEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStaffListEditForm');
  //Типы сумм для штатного расписания
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TStaffListSummKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TStaffListSummKindForm');
  //Календарь рабочих дней
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCalendarForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCalendarForm');
end;

procedure TLoadFormTest.LoadModelServiceFormTest;
begin
 //Типы модели начисления
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TModelServiceKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TModelServiceKindForm');
  //Типы выбора данных
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TModelServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TModelServiceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TModelServiceEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TModelServiceEditForm');
  //Типы выбора данных
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSelectKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSelectKindForm');
  //Типы документов
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementDescForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementDescForm');
end;

procedure TLoadFormTest.LoadMovementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementGoodsJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementGoodsJournalForm');


end;

procedure TLoadFormTest.LoadPositionFormTest;
begin
  // должности
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionEditForm');
  // Разряд должности
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionLevelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionLevelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionLevelEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionLevelEditForm');
end;

procedure TLoadFormTest.LoadPersonalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonal_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonal_ObjectForm');
  // группировки сотрудников
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalGroupEditForm');
end;

procedure TLoadFormTest.LoadCarFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCarForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCarForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCarEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCarEditForm');
end;

procedure TLoadFormTest.LoadFuelFormTest;
begin
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
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCardFuelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCardFuelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCardFuelEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCardFuelEditForm');
end;

procedure TLoadFormTest.LoadCarModelFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCarModelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCarModelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCarModelEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCarModelEditForm');
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

procedure TLoadFormTest.LoadFounderServiceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFounderServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFounderServiceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFounderServiceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFounderServiceJournalForm');
end;


 procedure TLoadFormTest.LoadWeighingPartnerFormTest;
 begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingPartnerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingPartnerJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingPartnerJournalForm');
end;

 procedure TLoadFormTest.LoadWeighingProductionFormTest;
 begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingProductionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingProductionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TWeighingProductionJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TWeighingProductionJournalForm');
end;

procedure TLoadFormTest.LoadRetailFormTest;
begin
  // Торговая сеть
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRetailForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRetailEditForm');
    // Торговая сеть (отчет)
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailReportForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRetailReportForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRetailReportEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRetailReportEditForm');
end;

procedure TLoadFormTest.LoadReceiptFormTest;
begin
  // Рецептуры
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptEditForm');
  // Затраты в рецептурах
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptCostForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptCostForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptCostEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptCostEditForm');
  //Типы рецептур
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptKindForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceipt_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceipt_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptGoods_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptGoods_ObjectForm');
end;

procedure TLoadFormTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', gc_AdminPassword, gc_User);
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
  TestFramework.RegisterTest('Загрузка форм', TLoadFormTest.Suite);


end.
