unit CashEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, cxCurrencyEdit, cxCheckBox,
  Data.DB, Datasnap.DBClient, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, ParentForm, dsdGuides,
  dsdDB, dsdAction;

type
  TCashEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdExecStoredProc: TdsdExecStoredProc;
    dsdFormClose1: TdsdFormClose;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    ceBranch: TcxLookupComboBox;
    BranchDataSet: TClientDataSet;
    spGetBranch: TdsdStoredProc;
    dsdBranchGuides: TdsdGuides;
    cxLabel2: TcxLabel;
    cePaidKind: TcxLookupComboBox;
    cxLabel4: TcxLabel;
    ceCurrency: TcxLookupComboBox;
    PaidKindDataSet: TClientDataSet;
    spGetPaidKind: TdsdStoredProc;
    PaidKindDS: TDataSource;
    dsdPaidKindGuides: TdsdGuides;
    CurrencyDataSet: TClientDataSet;
    spGetCurrency: TdsdStoredProc;
    CurrencyDS: TDataSource;
    dsdCurrencyGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TCashEditForm);

end.
