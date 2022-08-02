unit ReturnOut;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxCurrencyEdit, dsdAddOn,
  dsdAction, cxCheckBox, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, Datasnap.DBClient, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxBarBuiltInMenu, cxNavigator, cxImageComboBox,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TReturnOutForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    bbPrintTax: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    bbTax: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrintTTN: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    Summ: TcxGridDBColumn;
    edPriceWithVAT: TcxCheckBox;
    cxLabel10: TcxLabel;
    edNDSKind: TcxButtonEdit;
    NDSKindGuides: TdsdGuides;
    Price: TcxGridDBColumn;
    ContractGuides: TdsdGuides;
    ceTotalSummMVAT: TcxCurrencyEdit;
    ceTotalSummPVAT: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    actRefreshGoodsCode: TdsdExecStoredProc;
    bbRefreshGoodsCode: TdxBarButton;
    spIncome_GoodsId: TdsdStoredProc;
    cxLabel5: TcxLabel;
    edIncome: TcxButtonEdit;
    GuidesIncome: TdsdGuides;
    cxLabel6: TcxLabel;
    edReturnType: TcxButtonEdit;
    ReturnTypeGuides: TdsdGuides;
    cxLabel9: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    cxLabel11: TcxLabel;
    edOperDatePartner: TcxDateEdit;
    AmountInIncome: TcxGridDBColumn;
    Remains: TcxGridDBColumn;
    WarningColor: TcxGridDBColumn;
    cxLabel12: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    cxLabel13: TcxLabel;
    deIncomeOperDate: TcxDateEdit;
    mactEditPartnerData: TMultiAction;
    dxBarButton1: TdxBarButton;
    actPartnerDataDialog: TExecuteDialog;
    spUpdateReturnOut_PartnerData: TdsdStoredProc;
    actUpdateReturnOut_PartnerData: TdsdExecStoredProc;
    edJuridicalLegalAddress: TcxButtonEdit;
    cxLabel14: TcxLabel;
    edJuridicalActualAddress: TcxButtonEdit;
    cxLabel16: TcxLabel;
    GuidesJuridicalLegalAddress: TdsdGuides;
    GuidesJuridicalActualAddress: TdsdGuides;
    edAdjustingOurDate: TcxDateEdit;
    cxLabel17: TcxLabel;
    actPrintTTN: TdsdPrintAction;
    AmountOther: TcxGridDBColumn;
    actComplete: TdsdExecStoredProc;
    dxBarButton2: TdxBarButton;
    spMovementComplete: TdsdStoredProc;
    edComment: TcxTextEdit;
    cxLabel18: TcxLabel;
    cbisDeferred: TcxCheckBox;
    spUpdate_isDeferred_No: TdsdStoredProc;
    spUpdate_isDeferred_Yes: TdsdStoredProc;
    spUpdateisDeferredYes: TdsdExecStoredProc;
    spUpdateisDeferredNo: TdsdExecStoredProc;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    DeferredSend: TcxGridDBColumn;
    DeferredOut: TcxGridDBColumn;
    actPrintOptima: TdsdPrintAction;
    bbPrintOptima: TdxBarButton;
    MorionCode: TcxGridDBColumn;
    actSetVisibleAction: TdsdSetVisibleAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DataModul;

initialization
  RegisterClass(TReturnOutForm);

end.
