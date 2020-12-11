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
    procedure LoadServiceFormTest;
    procedure LoadTranslateWordFormTest;
    procedure LoadLanguageFormTest;
    procedure LoadBankFormTest;
    procedure LoadBrandFormTest;
    procedure LoadClientFormTest;
    procedure LoadCountryFormTest;
    procedure LoadColorPatternFormTest;
    procedure LoadDiscountParnerFormTest;
    procedure LoadGoodsGroupFormTest;
    procedure LoadGoodsFormTest;
    procedure LoadGoodsTagFormTest;
    procedure LoadGoodsTypeFormTest;
    procedure LoadGoodsSizeFormTest;
    procedure LoadImportSettingsFormTest;
    procedure LoadImportTypeFormTest;
    procedure LoadInfoMoneyFormTest;
    procedure LoadKindFormTest;
    procedure LoadMemberFormTest;
    procedure LoadMeasureFormTest;
    procedure LoadModelEtiketenFormTest;
    procedure LoadPartnerFormTest;
    procedure LoadPersonalFormTest;
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
    procedure LoadPriceListFormTest;
    procedure LoadReceiptProdModelFormTest;
    procedure LoadReceiptLevelFormTest;
    procedure LoadReceiptGoodsFormTest;
    procedure LoadReceiptServiceFormTest;
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

procedure TLoadFormTest.LoadBankFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankEditForm');
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

       procedure TLoadFormTest.LoadDiscountParnerFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountParnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountParnerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TDiscountParnerEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TDiscountParnerEditForm');
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

procedure TLoadFormTest.LoadGoodsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsTreeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsTreeForm');
end;

  procedure TLoadFormTest.LoadKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTaxKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTaxKindForm');
end;

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
  // ��������� �������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportSettingsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportSettingsForm');
end;

procedure TLoadFormTest.LoadImportTypeFormTest;
begin
  // ���� �������
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TImportTypeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TImportTypeForm');
end;

initialization
  TestFramework.RegisterTest('�������� ����', TLoadFormTest.Suite);


end.
