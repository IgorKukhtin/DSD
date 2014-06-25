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
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure UserFormSettingsTest;
(*    procedure LoadBankFormTest;
    procedure LoadBankAccountFormTest;
    procedure LoadBusinessFormTest;
    procedure LoadCashFormTest;
    procedure LoadContractFormTest;
    procedure LoadContractKindFormTest;
    procedure LoadCurrencyFormTest;
    procedure LoadExtraChargeCategoriesFormTest;
    procedure LoadGoodsGroupFormTest; *)
    procedure LoadGoodsFormTest;
   (*procedure LoadGoodsPropertyFormTest;
    procedure LoadGoodsPropertyValueFormTest;
    procedure LoadGoodsKindFormTest;
    procedure LoadJuridicalGroupFormTest;
    procedure LoadJuridicalFormTest;
    procedure LoadMeasureFormTest;
    procedure LoadPartnerFormTest;
    procedure LoadPaidKindFormTest;
    procedure LoadPriceListFormTest;
    procedure LoadIncomeFormTest;
    procedure LoadUnitGroupFormTest;
    procedure LoadUnitFormTest;
    procedure LoadReportFormTest;*)
  end;

implementation

uses CommonData, Storage, FormStorage, Classes,
     Authentication, SysUtils, cxPropertiesStore, cxStorage;

{ TLoadFormTest }

function TLoadFormTest.GetForm(FormClass: string): TForm;
begin
  if GetClass(FormClass) = nil then
     raise Exception.Create('Не зарегистрирован класс: ' + FormClass);
  Application.CreateForm(TComponentClass(GetClass(FormClass)), Result);
end;

(*
procedure TLoadFormTest.LoadBankAccountFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankAccountEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankAccountEditForm');
//  TdsdFormStorageFactory.GetStorage.SaveUserFormSettings('TBankAccountForm', TStringStream.Create('Test'));
//  Check(FormStorage.StreamToString(TdsdFormStorageFactory.GetStorage.LoadUserFormSettings('TBankAccountForm')) = 'Test', ' Не правильно работает сохранение установок ' + FormStorage.StreamToString(TdsdFormStorageFactory.GetStorage.LoadUserFormSettings('TBankAccountForm')));
end;

procedure TLoadFormTest.LoadBankFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBankEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBankEditForm');
end;

procedure TLoadFormTest.LoadExtraChargeCategoriesFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TExtraChargeCategoriesForm'));
  TdsdFormStorageFactory.GetStorage.Load('TExtraChargeCategoriesForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TExtraChargeCategoriesEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TExtraChargeCategoriesEditForm');
end;

procedure TLoadFormTest.LoadBusinessFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBusinessForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBusinessForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBusinessEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBusinessEditForm');
end;

procedure TLoadFormTest.LoadCashFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashEditForm');
end;

procedure TLoadFormTest.LoadContractFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractEditForm');
end;

procedure TLoadFormTest.LoadContractKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractKindForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TContractKindEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TContractKindEditForm');
end;

procedure TLoadFormTest.LoadCurrencyFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyEditForm');
end;
*)
procedure TLoadFormTest.LoadGoodsFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsEditForm');
end;
 (*
procedure TLoadFormTest.LoadGoodsGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsGroupEditForm');
end;

procedure TLoadFormTest.LoadGoodsKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TGoodsKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TGoodsKindForm');
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

procedure TLoadFormTest.LoadIncomeFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TIncomeJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TIncomeJournalForm');
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
end;

procedure TLoadFormTest.LoadMeasureFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMeasureForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMeasureForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMeasureEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMeasureEditForm');
end;

procedure TLoadFormTest.LoadPaidKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPaidKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPaidKindForm');
end;

procedure TLoadFormTest.LoadPartnerFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPartnerEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPartnerEditForm');
end;

procedure TLoadFormTest.LoadPriceListFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPriceListEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPriceListEditForm');
end;

procedure TLoadFormTest.LoadReportFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TBalanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TBalanceForm');
end;

procedure TLoadFormTest.LoadUnitFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitEditForm');
end;

procedure TLoadFormTest.LoadUnitGroupFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitGroupForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitGroupEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitGroupEditForm');
end;
*)
procedure TLoadFormTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;

procedure TLoadFormTest.TearDown;
begin
  inherited;

end;


procedure TLoadFormTest.UserFormSettingsTest;
var
  TempStream : TMemoryStream;
  AStoreComponent: TcxPropertiesStoreComponent;
  cxPropertiesStore: TcxPropertiesStore;
begin
 // TdsdFormStorageFactory.GetStorage.SaveUserFormSettings('TBankAccountForm', TStringStream.Create(#6));

  (*cxPropertiesStore:= TcxPropertiesStore.Create(nil);
  cxPropertiesStore.StorageType := stStream;
  AStoreComponent  := TcxPropertiesStoreComponent(cxPropertiesStore.Components.Add);
  AStoreComponent.Component := TForm.Create(nil);
  AStoreComponent.Properties.Add('Top');
  TempStream := TMemoryStream.Create;
  try
    cxPropertiesStore.StorageStream := TempStream;
    cxPropertiesStore.StoreTo(True);
    TdsdFormStorageFactory.GetStorage.SaveUserFormSettings('TBankAccountForm', TempStream);
    TempStream.Clear;
    TempStream.LoadFromStream(TdsdFormStorageFactory.GetStorage.LoadUserFormSettings('TBankAccountForm'));
    TempStream.Position := 0; // Inserted line
    cxPropertiesStore.RestoreFrom;
  finally
    TempStream.Free;
  end;*)
end;

initialization
  TestFramework.RegisterTest('Загрузка форм', TLoadFormTest.Suite);


end.
