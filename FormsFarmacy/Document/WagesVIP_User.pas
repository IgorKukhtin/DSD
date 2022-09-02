unit WagesVIP_User;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  Vcl.Menus, dsdGuides, Data.DB,
  Datasnap.DBClient, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, cxPropertiesStore, dsdAddOn, dsdDB, dsdAction,
  Vcl.ActnList, cxCurrencyEdit, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit,
  cxButtonEdit, Vcl.ComCtrls, dxCore, cxDateUtils, cxCalendar,
  dxSkinsDefaultPainters, cxCheckBox;

type
  TWagesVIP_UserForm = class(TParentForm)
    edMemberName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    spGet: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    edOperDate: TcxDateEdit;
    cxLabel11: TcxLabel;
    edAmountAccrued: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    edHoursWork: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    ActionList1: TActionList;
    ExecuteDialog: TExecuteDialog;
    actRefresh: TdsdDataSetRefresh;
    RefreshDispatcher: TRefreshDispatcher;
    FormClose: TdsdFormClose;
    edApplicationAward: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    edTotalSum: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TWagesVIP_UserForm);

end.
