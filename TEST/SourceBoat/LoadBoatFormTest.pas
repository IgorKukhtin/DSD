unit LoadBoatFormTest;

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
  published
    procedure MainFormTest;
    procedure LoadAccountFormTest;
    procedure LoadBankFormTest;
    procedure LoadBankAccountFormTest;
    procedure LoadBankAccountMovementFormTest;
    procedure LoadBrandFormTest;
    procedure LoadClientFormTest;
    procedure LoadCountryFormTest;
    procedure LoadColorPatternFormTest;
    procedure LoadCurrencyFormTest;
    procedure LoadDiscountPartnerFormTest;
    procedure LoadDocTagFormTest;
    procedure LoadEmailFormTest;
    procedure LoadGoodsGroupFormTest;
    procedure LoadGoodsFormTest;
    procedure LoadGoodsTagFormTest;
    procedure LoadGoodsTypeFormTest;
    procedure LoadGoodsSizeFormTest;
    procedure LoadIncomeFormTest;
    procedure LoadIncomeCostFormTest;
    procedure LoadInvoiceFormTest;
    procedure LoadInventoryFormTest;
    procedure LoadImportSettingsFormTest;
    procedure LoadImportTypeFormTest;
    procedure LoadInfoMoneyFormTest;
    procedure LoadKindFormTest;
    procedure LoadLanguageFormTest;
    procedure LoadLossFormTest;
    procedure LoadMailSendFormTest;
    procedure LoadMaterialOptionsFormTest;
    procedure LoadMemberFormTest;
    procedure LoadMeasureFormTest;
    procedure LoadMeasureCodeFormTest;
    procedure LoadModelEtiketenFormTest;
    procedure LoadOrderClientFormTest;
    procedure LoadOrderInternalFormTest;
    procedure LoadOrderPartnerFormTest;
    procedure LoadPartionGoodsFormTest;
    procedure LoadPartionCellFormTest;
    procedure LoadPersonalFormTest;
    procedure LoadPartnerFormTest;
    procedure LoadPLZFormTest;
    procedure LoadPositionFormTest;
    procedure LoadProdColorFormTest;
    procedure LoadProdColorItemsFormTest;
    procedure LoadProdColorKindFormTest;
    procedure LoadProdColorPatternFormTest;
    procedure LoadProdColorGroupFormTest;
    procedure LoadProdEngineFormTest;
    procedure LoadProdModelFormTest;
    procedure LoadProdOptionsFormTest;
    procedure LoadProdOptItemsFormTest;
    procedure LoadProdOptPatternFormTest;
    procedure LoadProductFormTest;
    procedure LoadProductionPersonalFormTest;
    procedure LoadProductionUnionFormTest;
    procedure LoadPriceListFormTest;
    procedure LoadPriceListMovementFormTest;
    procedure LoadProfitLossFormTest;
    procedure LoadReceiptProdModelFormTest;
    procedure LoadReceiptLevelFormTest;
    procedure LoadReceiptGoodsFormTest;
    procedure LoadReceiptServiceFormTest;
    procedure LoadReceiptServiceGroupFormTest;
    procedure LoadReceiptServiceModelFormTest;
    procedure LoadReceiptServiceMaterialFormTest;
    procedure LoadReportFormTest;
    procedure LoadReportProfitLossFormTest;
    procedure LoadReportPersonalFormTest;
    procedure LoadSaleFormTest;
    procedure LoadServiceFormTest;
    procedure LoadSendFormTest;
    procedure LoadTranslateMessageFormTest;
    procedure LoadTranslateObjectFormTest;
    procedure LoadTranslateWordFormTest;
    procedure LoadUnionFormTest;
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
     raise Exception.Create('�� ��������������� �����: ' + FormClass);
  Application.CreateForm(TComponentClass(GetClass(FormClass)), Result);
end;

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

procedure TLoadFormTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', gc_AdminPassword, gc_User);
end;

procedure TLoadFormTest.LoadAccountFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountGroupEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountGroupForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountDirectionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountDirectionEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountDirectionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountDirectionForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TAccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TAccountForm');
end;

procedure TLoadFormTest.LoadServiceFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCheckBooleanDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCheckBooleanDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFormsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFormsForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementProtocol_InfoForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementProtocol_InfoForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementProtocolForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementItemProtocolForm');

//
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TObjectDescForm'));
  TdsdFormStorageFactory.GetStorage.Load('TObjectDescForm');
  exit;
  {
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

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemContainerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementItemContainerForm');
   }
end;

procedure TLoadFormTest.LoadLossFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLossForm');

//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendJournalChoiceForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TSendJournalChoiceForm');
end;

procedure TLoadFormTest.LoadMailSendFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMailSendEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMailSendEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMailSendForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMailSendForm');
end;


procedure TLoadFormTest.LoadSendFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendJournalChoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendItemEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendItemEditNotPartNumberForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSendItemEditNotPartNumberForm');

//  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSendJournalChoiceForm'));
//  TdsdFormStorageFactory.GetStorage.Load('TSendJournalChoiceForm');
end;

procedure TLoadFormTest.LoadTranslateMessageFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTranslateMessageForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTranslateMessageForm');
end;

procedure TLoadFormTest.LoadTranslateObjectFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTranslateObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTranslateObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTranslateObjectEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTranslateObjectEditForm');


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

procedure TLoadFormTest.LoadBankFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankEditForm');
end;

procedure TLoadFormTest.LoadBankAccountFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountPdfEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountPdfEditForm');
end;

procedure TLoadFormTest.LoadBankAccountMovementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountChildJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountChildJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountChildForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountChildForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountMovementChildForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountMovementChildForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountJournalByInvoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountJournalByInvoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountMovementForm');
end;

procedure TLoadFormTest.LoadClientFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TClientForm'));
  TdsdFormStorageFactory.GetStorage.Load('TClientForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TClientEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TClientEditForm');
end;

 procedure TLoadFormTest.LoadCountryFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCountryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCountryForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCountryEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCountryEditForm');
end;

procedure TLoadFormTest.LoadDiscountPartnerFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountPartnerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountPartnerEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountPartnerEditForm');
end;

procedure TLoadFormTest.LoadDocTagFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDocTagForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDocTagForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDocTagEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDocTagEditForm');
end;

procedure TLoadFormTest.LoadEmailFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmailKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmailKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmailSettingsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmailSettingsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TEmailToolsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TEmailToolsForm');
end;

procedure TLoadFormTest.LoadInvoiceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInvoiceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInvoiceJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInvoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInvoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInvoiceJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInvoiceJournalChoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInvoiceItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInvoiceItemEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInvoicePdfEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInvoicePdfEditForm');

end;

procedure TLoadFormTest.LoadInventoryFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryItemEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryItemEditNotPartNumberForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryItemEditNotPartNumberForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInventoryItemEdit_limitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInventoryItemEdit_limitForm');
end;

procedure TLoadFormTest.LoadIncomeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeJournalByInvoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeJournalByInvoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeItemForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeItemEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeItemEdit_limitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeItemEdit_limitForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeJournalChoiceForm');
end;

procedure TLoadFormTest.LoadIncomeCostFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeCostJournalByInvoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeCostJournalByInvoiceForm');
 // exit;
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeCostJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeCostJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeCostForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeCostForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCostJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCostJournalChoiceForm');
end;

 procedure TLoadFormTest.LoadOrderClientFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderClientDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderClientDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderClientSummDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderClientSummDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderClientJournalChoiceItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderClientJournalChoiceItemForm');

  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderClientJournalReserveForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderClientJournalReserveForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderClientJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderClientJournalChoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderClientJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderClientJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderClientForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderClientForm');

end;

 procedure TLoadFormTest.LoadOrderInternalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalJournalChoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderInternalMasterChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderInternalMasterChoiceForm');
end;

 procedure TLoadFormTest.LoadOrderPartnerFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderPartnerJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderPartnerJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TOrderPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TOrderPartnerForm');
end;

procedure TLoadFormTest.LoadProductionUnionFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionUnionMasterJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionUnionMasterJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionUnionJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionUnionJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionUnionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionUnionForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionUnionMasterChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionUnionMasterChoiceForm');
end;

procedure TLoadFormTest.LoadProductionPersonalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionPersonalJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionPersonalJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductionPersonalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductionPersonalForm');
end;

procedure TLoadFormTest.LoadGoodsGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroup_ListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroup_ListForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupChoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroup_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroup_ObjectForm');
end;

procedure TLoadFormTest.LoadSaleFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaleJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaleJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TSaleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TSaleForm');
end;

procedure TLoadFormTest.LoadGoodsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoods_limitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoods_limitForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsMainForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsMainForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsEditForm'));

  TdsdFormStorageFactory.GetStorage.Load('TGoodsEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsTreeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsTreeForm');
end;

  procedure TLoadFormTest.LoadKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMailKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMailKindForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaxKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaxKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaxKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaxKindEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPaidKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPaidKindForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInvoiceKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInvoiceKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInvoiceKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInvoiceKindEditForm');
end;

procedure TLoadFormTest.LoadMeasureFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMeasureForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMeasureForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMeasureEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMeasureEditForm');
end;

procedure TLoadFormTest.LoadMeasureCodeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMeasureCodeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMeasureCodeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMeasureCodeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMeasureCodeEditForm');
end;

procedure TLoadFormTest.LoadMaterialOptionsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMaterialOptionsChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMaterialOptionsChoiceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMaterialOptionsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMaterialOptionsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMaterialOptionsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMaterialOptionsEditForm');
end;

procedure TLoadFormTest.LoadMemberFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberEditForm');
end;

procedure TLoadFormTest.LoadGoodsTagFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsTagForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsTagForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsTagEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsTagEditForm');
end;

procedure TLoadFormTest.LoadGoodsTypeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsTypeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsTypeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsTypeEditForm');
end;

procedure TLoadFormTest.LoadGoodsSizeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsSizeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsSizeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsSizeEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsSizeEditForm');
end;

procedure TLoadFormTest.LoadModelEtiketenFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TModelEtiketenForm'));
  TdsdFormStorageFactory.GetStorage.Load('TModelEtiketenForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TModelEtiketenEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TModelEtiketenEditForm');
end;

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

procedure TLoadFormTest.LoadPartnerFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerEditForm');
end;

procedure TLoadFormTest.LoadPartionGoodsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionGoodsChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionGoodsChoiceForm');
end;

procedure TLoadFormTest.LoadPartionCellFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionCellForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionCellForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartionCellEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartionCellEditForm');
end;

 procedure TLoadFormTest.LoadPersonalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPersonalEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPersonalEditForm');
end;
procedure TLoadFormTest.LoadPLZFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPLZForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPLZForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPLZEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPLZEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPLZ_CityForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPLZ_CityForm');
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

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdColor_goodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdColor_goodsForm');

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

procedure TLoadFormTest.LoadProdColorKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdColorKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdColorKindForm');
end;

 procedure TLoadFormTest.LoadColorPatternFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TColorPatternForm'));
  TdsdFormStorageFactory.GetStorage.Load('TColorPatternForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TColorPatternEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TolorPatternEditForm');
end;

procedure TLoadFormTest.LoadCurrencyFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrency_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrency_ObjectForm');
end;

procedure TLoadFormTest.LoadProdColorPatternFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdColorPatternForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdColorPatternForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdColorPatternEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdColorPatternEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdColorPatternGoodsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdColorPatternGoodsEditForm');
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

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProdOptions_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProdOptions_ObjectForm');
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

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProductDocumentPhotoEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProductDocumentPhotoEditForm');
end;
 procedure TLoadFormTest.LoadProfitLossFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossGroupEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossGroup_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossGroup_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossDirectionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossDirectionEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossDirectionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossDirectionForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossDirection_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossDirection_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLossForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProfitLoss_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProfitLoss_ObjectForm');

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

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListGoodsItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListGoodsItemEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceList_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceList_ObjectForm');
end;

procedure TLoadFormTest.LoadPriceListMovementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListMovementForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListItemEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListItemEdit_limitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListItemEdit_limitForm');
end;

procedure TLoadFormTest.LoadReceiptProdModelFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptProdModelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptProdModelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptProdModelEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptProdModelEditForm');
end;

procedure TLoadFormTest.LoadReceiptLevelFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptLevelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptLevelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptLevelEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptLevelEditForm');
end;

procedure TLoadFormTest.LoadReceiptGoodsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptGoodsLineForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptGoodsLineForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptGoodsEditEnterForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptGoodsEditEnterForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptGoodsChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptGoodsChoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptGoodsForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptGoodsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptGoodsEditForm');

end;

procedure TLoadFormTest.LoadReceiptServiceFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptServiceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptServiceEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptServiceEditForm');
end;

procedure TLoadFormTest.LoadReceiptServiceGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptServiceGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptServiceGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptServiceGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptServiceGroupEditForm');
end;
procedure TLoadFormTest.LoadReceiptServiceModelFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptServiceModelForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptServiceModelForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptServiceModelEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptServiceModelEditForm');
end;
procedure TLoadFormTest.LoadReceiptServiceMaterialFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptServiceMaterialForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptServiceMaterialForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReceiptServiceMaterialEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReceiptServiceMaterialEditForm');
end;

procedure TLoadFormTest.LoadReportFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Boat_AssemblyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Boat_AssemblyForm');
   {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ClientForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ClientForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ClientDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ClientDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CollationByPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CollationByPartnerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CollationByPartnerDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CollationByPartnerDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PartnerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PartnerDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PartnerDialogForm');


  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderClient_byBoatChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderClient_byBoatChoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderClient_byBoatForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderClient_byBoatForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderClient_byBoatDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderClient_byBoatDialogForm');
  exit;

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PriceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PriceListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PriceListDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PriceListDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SendForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SendForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_SendDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_SendDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderInternalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderInternalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderInternalDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderInternalDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_PriceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_PriceListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Movement_PriceListDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Movement_PriceListDialogForm');
  exit;
   }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMotionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMotionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsMotionDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsMotionDialogForm');
  //exit;
  {
   //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProductionPersonalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProductionPersonalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProductionPersonalDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProductionPersonalDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BalanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_BalanceForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_BalanceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_BalanceDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderClientForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderClientForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_OrderClientDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_OrderClientDialogForm');
   exit;
   }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_GoodsDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_GoodsDialogForm');
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementIncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MovementIncomeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_MovementIncomeDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_MovementIncomeDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_RemainsCurrentForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_RemainsCurrentForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_Goods_RemainsCurrentDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_Goods_RemainsCurrentDialogForm');
  }
end;

procedure TLoadFormTest.LoadReportProfitLossFormTest;
begin
  {
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitLossPeriodForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitLossPeriodForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitLossPeriodDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitLossPeriodDialogForm');
  }
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitLossForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitLossForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_ProfitLossDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_ProfitLossDialogForm');
end;

procedure TLoadFormTest.LoadReportPersonalFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PersonalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PersonalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_PersonalDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_PersonalDialogForm');
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

procedure TLoadFormTest.LoadUnionFormTest;
begin

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnion_TranslateObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnion_TranslateObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnion_OrderJournalChoiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnion_OrderJournalChoiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnion_Goods_ReceiptServiceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnion_Goods_ReceiptServiceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnion_Goods_ReceiptService_limitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnion_Goods_ReceiptService_limitForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnion_ClientPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnion_ClientPartnerForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMoneyPlace_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMoneyPlace_ObjectForm');

end;

procedure TLoadFormTest.LoadImportSettingsFormTest;
begin
  // ��������� �������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportSettingsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportSettingsForm');
end;

procedure TLoadFormTest.LoadImportTypeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TFileTypeKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TFileTypeKindForm');
  // ���� �������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportTypeForm');
end;

initialization
  TestFramework.RegisterTest('�������� ����', TLoadFormTest.Suite);
end.
