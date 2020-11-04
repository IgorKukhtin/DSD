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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, ChoicePeriod, cxCheckBox, cxSplitter,
  dsdExportToXLSAction;

type
  TPaymentForm = class(TAncestorDocumentForm)
    lblJuridical: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    cxLabel4: TcxLabel;
    edTotalSumm: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    edTotalCount: TcxCurrencyEdit;
    Income_InvNumber: TcxGridDBColumn;
    Income_Operdate: TcxGridDBColumn;
    Income_JuridicalName: TcxGridDBColumn;
    Income_StatusName: TcxGridDBColumn;
    Income_UnitName: TcxGridDBColumn;
    Income_NDS: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    deDateStart: TcxDateEdit;
    deDateEnd: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    Id: TcxGridDBColumn;
    Income_ContractName: TcxGridDBColumn;
    Income_TotalSumm: TcxGridDBColumn;
    Income_PaySumm: TcxGridDBColumn;
    SummaPay: TcxGridDBColumn;
    BankAccountName: TcxGridDBColumn;
    BankName: TcxGridDBColumn;
    NeedPay: TcxGridDBColumn;
    actOpenBankAccount: TOpenChoiceForm;
    PrintItemsVATCDS: TClientDataSet;
    Income_PaymentDate: TcxGridDBColumn;
    Income_PayOrder: TcxGridDBColumn;
    SummaCorrBonus: TcxGridDBColumn;
    SummaCorrOther: TcxGridDBColumn;
    SummaCorrReturnOut: TcxGridDBColumn;
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
    ContainerAmountBonus: TcxGridDBColumn;
    ContainerAmountReturnOut: TcxGridDBColumn;
    ContainerAmountOther: TcxGridDBColumn;
    CorrBonus: TcxGridDBColumn;
    LeftCorrBonus: TcxGridDBColumn;
    CorrReturnOut: TcxGridDBColumn;
    LeftCorrReturnOut: TcxGridDBColumn;
    CorrOther: TcxGridDBColumn;
    LeftCorrOther: TcxGridDBColumn;
    cxSplitter1: TcxSplitter;
    ContractNumber: TcxGridDBColumn;
    ContractStartDate: TcxGridDBColumn;
    ContractEndDate: TcxGridDBColumn;
    actRefreshLite: TdsdDataSetRefresh;
    spUpdateMI_NeedPay: TdsdStoredProc;
    actUpdateMI_NeedPay: TdsdExecStoredProc;
    macUpdateMI_NeedPay: TMultiAction;
    bbUpdateMI_NeedPay: TdxBarButton;
    actExportToXLSPrivat: TdsdExportToXLS;
    actExecStoredProcPrivat: TdsdExecStoredProc;
    ExportBankCDS: TClientDataSet;
    spExportBankPrivat: TdsdStoredProc;
    dxBarButton2: TdxBarButton;
    spExportBankPrivatFileName: TdsdStoredProc;
    spExportBankUkrximFileName: TdsdStoredProc;
    spExportBankUkrxim: TdsdStoredProc;
    actExportToXLSUkrxim: TdsdExportToXLS;
    actExecStoredProcUkrxim: TdsdExecStoredProc;
    dxBarButton3: TdxBarButton;
    cbPaymentFormed: TcxCheckBox;
    actExportToXLSConcord: TdsdExportToXLS;
    actExecStoredProcConcord: TdsdExecStoredProc;
    dxBarButton4: TdxBarButton;
    spExportBankConcordFileName: TdsdStoredProc;
    spExportBankConcord: TdsdStoredProc;
    isPartialPay: TcxGridDBColumn;
    ContainerAmountPartialSale: TcxGridDBColumn;
    CorrPartialSale: TcxGridDBColumn;
    LeftCorrPartialSale: TcxGridDBColumn;
    SummaCorrPartialPay: TcxGridDBColumn;
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
