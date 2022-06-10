unit LoadMerlinFormTest;

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
    procedure LoadBankFormTest;
    procedure LoadBankAccountFormTest;
    procedure LoadCashFormTest;
    procedure LoadCashMovementFormTest;
    procedure LoadCashSendMovementFormTest;
    procedure LoadCommentFormTest;
    procedure LoadCurrencyFormTest;
    procedure LoadCurrencyMovementFormTest;
    procedure LoadInfoMoneyFormTest;
    procedure LoadInfoMoneyDetailFormTest;
    procedure LoadImportSettingsFormTest;
    procedure LoadImportTypeFormTest;
    procedure LoadKindFormTest;
    procedure LoadMemberFormTest;
    procedure LoadObjectHistoryFormTest;
    procedure LoadPositionFormTest;
    procedure LoadReportFormTest;
    procedure LoadServiceFormTest;
    procedure LoadServiceMovementFormTest;
    procedure LoadServiceItemMovementFormTest;
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
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemContainerForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementItemContainerForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProtocolForm');
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementProtocolForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementItemProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementItemProtocolForm');

//
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

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementDescDataForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementDescDataForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovement_PeriodDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovement_PeriodDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovement_PeriodDialogCashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovement_PeriodDialogCashForm');
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
end;

procedure TLoadFormTest.LoadCashFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCash_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCash_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashTreeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashTreeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashTreeGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashTreeGroupForm');
end;

procedure TLoadFormTest.LoadCashMovementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashChildJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashChildJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashChildMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashChildMovementForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashMovementForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashInJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashInJournalForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashOutJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashOutJournalForm');
end;

   procedure TLoadFormTest.LoadCashSendMovementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashSendMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashSendMovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCashSendJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCashSendJournalForm');
end;

procedure TLoadFormTest.LoadCommentFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCommentInfoMoneyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCommentInfoMoneyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCommentInfoMoneyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCommentInfoMoneyEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCommentMoveMoneyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCommentMoveMoneyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCommentMoveMoneyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCommentMoveMoneyEditForm');
end;


procedure TLoadFormTest.LoadInfoMoneyDetailFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyDetailForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyDetailForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyDetailEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyDetailEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyDetail_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyDetail_ObjectForm');
end;

procedure TLoadFormTest.LoadObjectHistoryFormTest;
begin
  //
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TServiceItemLastForm'));
  TdsdFormStorageFactory.GetStorage.Load('TServiceItemLastForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TServiceItemForm'));
  TdsdFormStorageFactory.GetStorage.Load('TServiceItemForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TServiceItemEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TServiceItemEditForm');

end;

procedure TLoadFormTest.LoadCurrencyFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrency_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrency_ObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyEditForm');
end;

 procedure TLoadFormTest.LoadCurrencyMovementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyMovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TCurrencyJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TCurrencyJournalForm');
end;

procedure TLoadFormTest.LoadInfoMoneyFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoney_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoney_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyTreeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyTreeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyTreeGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyTreeGroupForm');
end;

procedure TLoadFormTest.LoadMemberFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMemberEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMemberEditForm');
end;

 procedure TLoadFormTest.LoadKindFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPaidKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPaidKindForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TInfoMoneyKindForm'));
  TdsdFormStorageFactory.GetStorage.Load('TInfoMoneyKindForm');
end;

procedure TLoadFormTest.LoadPositionFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TPositionEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TPositionEditForm');
end;


procedure TLoadFormTest.LoadReportFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CashBalanceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CashBalanceDialogtForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_CashBalanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_CashBalanceForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_UnitRentForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_UnitRentForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_UnitRentDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_UnitRentDialogForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_UnitBalanceDialogForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_UnitBalanceDialogtForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TReport_UnitBalanceForm'));
  TdsdFormStorageFactory.GetStorage.Load('TReport_UnitBalanceForm');

end;

procedure TLoadFormTest.LoadUnitFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitEditForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnit_ObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnit_ObjectForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitTreeForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitTreeForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUnitTreeGroupForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUnitTreeGroupForm');
end;

procedure TLoadFormTest.LoadServiceMovementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TServiceMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TServiceMovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TServiceJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TServiceJournalForm');
end;

procedure TLoadFormTest.LoadServiceItemMovementFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TServiceItemMovementForm'));
  TdsdFormStorageFactory.GetStorage.Load('TServiceItemMovementForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TServiceItemJournalForm'));
  TdsdFormStorageFactory.GetStorage.Load('TServiceItemJournalForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TServiceItemUpdateForm'));
  TdsdFormStorageFactory.GetStorage.Load('TServiceItemUpdateForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TServiceItemEditMIForm'));
  TdsdFormStorageFactory.GetStorage.Load('TServiceItemEditMIForm');
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
