unit Payment;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, ChoicePeriod, cxCheckBox, cxSplitter;

type
  TPaymentForm = class(TAncestorDocumentForm)
    lblJuridical: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    cxLabel4: TcxLabel;
    edTotalSumm: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    edTotalCount: TcxCurrencyEdit;
    colIncome_InvNumber: TcxGridDBColumn;
    colIncome_Operdate: TcxGridDBColumn;
    colIncome_JuridicalName: TcxGridDBColumn;
    colIncome_StatusName: TcxGridDBColumn;
    colIncome_UnitName: TcxGridDBColumn;
    colIncome_NDSKindName: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    deDateStart: TcxDateEdit;
    deDateEnd: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    colId: TcxGridDBColumn;
    colIncome_ContractName: TcxGridDBColumn;
    colIncome_TotalSumm: TcxGridDBColumn;
    colIncome_PaySumm: TcxGridDBColumn;
    colSummaPay: TcxGridDBColumn;
    colBankAccountName: TcxGridDBColumn;
    colBankName: TcxGridDBColumn;
    colNeedPay: TcxGridDBColumn;
    actOpenBankAccount: TOpenChoiceForm;
    PrintItemsVATCDS: TClientDataSet;
    colIncome_PaymentDate: TcxGridDBColumn;
    colIncome_PayOrder: TcxGridDBColumn;
    colSummaCorrBonus: TcxGridDBColumn;
    colSummaCorrOther: TcxGridDBColumn;
    colSummaCorrReturnOut: TcxGridDBColumn;
    mactSelectAll: TMultiAction;
    gpInsertUpdate_MovementItem_Payment_NeedPay: TdsdStoredProc;
    actInsertUpdate_MovementItem_Payment_NeedPay: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    actSelectAllAndRefresh: TMultiAction;
    spGet_Payment_Detail: TdsdStoredProc;
    spInsertUpdate_MovementFloat_TotalSummPayment: TdsdStoredProc;
    actGet_Payment_Detail: TdsdExecStoredProc;
    actInsertUpdate_MovementFloat_TotalSummPayment: TdsdExecStoredProc;
    spSelect_PaymentCorrSumm: TdsdStoredProc;
    PaymentCorrSummCDS: TClientDataSet;
    PaymentCorrSummDS: TDataSource;
    actSelect_PaymentCorrSumm: TdsdExecStoredProc;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    colContainerAmountBonus: TcxGridDBColumn;
    colContainerAmountReturnOut: TcxGridDBColumn;
    colContainerAmountOther: TcxGridDBColumn;
    colCorrBonus: TcxGridDBColumn;
    colLeftCorrBonus: TcxGridDBColumn;
    colCorrReturnOut: TcxGridDBColumn;
    colLeftCorrReturnOut: TcxGridDBColumn;
    colCorrOther: TcxGridDBColumn;
    colLeftCorrOther: TcxGridDBColumn;
    cxSplitter1: TcxSplitter;
    clContractNumber: TcxGridDBColumn;
    clContractStartDate: TcxGridDBColumn;
    clContractEndDate: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPaymentForm);

end.
