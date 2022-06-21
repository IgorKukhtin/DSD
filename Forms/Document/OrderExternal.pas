unit OrderExternal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter;

type
  TOrderExternalForm = class(TAncestorDocumentForm)
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintItemsSverkaCDS: TClientDataSet;
    AmountSecond: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    edInvNumberOrder: TcxTextEdit;
    cxLabel3: TcxLabel;
    edOperDateMark: TcxDateEdit;
    cxLabel10: TcxLabel;
    edOperDatePartner: TcxDateEdit;
    cxLabel4: TcxLabel;
    edFrom: TcxButtonEdit;
    cxLabel6: TcxLabel;
    edPaidKind: TcxButtonEdit;
    cxLabel9: TcxLabel;
    edContract: TcxButtonEdit;
    cxLabel13: TcxLabel;
    edRouteSorting: TcxButtonEdit;
    PaidKindGuides: TdsdGuides;
    ContractGuides: TdsdGuides;
    GuidesRouteSorting: TdsdGuides;
    GuidesFrom: TdsdGuides;
    cxLabel7: TcxLabel;
    edRoute: TcxButtonEdit;
    GuidesRoute: TdsdGuides;
    cxLabel16: TcxLabel;
    edMember: TcxButtonEdit;
    GuidesMember: TdsdGuides;
    cxLabel11: TcxLabel;
    edPriceList: TcxButtonEdit;
    PriceListGuides: TdsdGuides;
    Price: TcxGridDBColumn;
    CountForPrice: TcxGridDBColumn;
    AmountSumm: TcxGridDBColumn;
    cxLabel8: TcxLabel;
    edTo: TcxButtonEdit;
    GuidesTo: TdsdGuides;
    AmountSumm_Partner: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    edPriceWithVAT: TcxCheckBox;
    cxLabel12: TcxLabel;
    edVATPercent: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    edContractTag: TcxButtonEdit;
    cxLabel17: TcxLabel;
    ContractTagGuides: TdsdGuides;
    AmountEDI: TcxGridDBColumn;
    AmountRemains: TcxGridDBColumn;
    spSavePrintState: TdsdStoredProc;
    actSPSavePrintState: TdsdExecStoredProc;
    mactPrint_Order: TMultiAction;
    cbPrinted: TcxCheckBox;
    GoodsGroupNameFull: TcxGridDBColumn;
    cxLabel21: TcxLabel;
    edPartner: TcxButtonEdit;
    PartnerGuides: TdsdGuides;
    ArticleGLN: TcxGridDBColumn;
    cxLabel18: TcxLabel;
    ceComment: TcxTextEdit;
    cxLabel19: TcxLabel;
    edOperDatePartner_sale: TcxDateEdit;
    cbPromo: TcxCheckBox;
    MovementPromo: TcxGridDBColumn;
    PricePromo: TcxGridDBColumn;
    LineNum: TcxGridDBColumn;
    isPriceEDIDiff: TcxGridDBColumn;
    ChangePercent: TcxGridDBColumn;
    actShowMessage: TShowMessageAction;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    actPrintTotal: TdsdPrintAction;
    spSelectPrintTotal: TdsdStoredProc;
    bbPrintTotal: TdxBarButton;
    actUpdateOperDatePartner: TdsdDataSetRefresh;
    ExecuteDialogUpdateOperDatePartner: TExecuteDialog;
    macUpdateOperDatePartner: TMultiAction;
    cbAuto: TcxCheckBox;
    spUpdateMovement_OperDatePartner: TdsdStoredProc;
    actRefreshGet: TdsdDataSetRefresh;
    bbUpdateOperDatePartner: TdxBarButton;
    actPrint_2: TdsdPrintAction;
    bbPrintOrder: TdxBarButton;
    mactPrint_Order2: TMultiAction;
    cxLabel20: TcxLabel;
    ceStatus_wms: TcxButtonEdit;
    GuidesStatus_wms: TdsdGuides;
    spUpdate_Status_wms: TdsdStoredProc;
    ChangeGuidesStatuswms1: TChangeGuidesStatus;
    ChangeGuidesStatuswms2: TChangeGuidesStatus;
    ChangeGuidesStatuswms3: TChangeGuidesStatus;
    cbPrintComment: TcxCheckBox;
    spGetReporNameBill: TdsdStoredProc;
    actPrint_Account_ReportName: TdsdExecStoredProc;
    actPrint_Account: TdsdPrintAction;
    mactPrint_Account: TMultiAction;
    bbPrint_Account: TdxBarButton;
    spSelectPrintBill: TdsdStoredProc;
    cxLabel22: TcxLabel;
    cxLabel23: TcxLabel;
    edCarInfo: TcxButtonEdit;
    GuidesCarInfo: TdsdGuides;
    edCarInfo_Date: TcxDateEdit;
    cxTabSheet1: TcxTabSheet;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    GoodsGroupNameFull_ch: TcxGridDBColumn;
    GoodsCode_ch: TcxGridDBColumn;
    GoodsName_ch: TcxGridDBColumn;
    GoodsKindName_ch: TcxGridDBColumn;
    MeasureName_ch: TcxGridDBColumn;
    Amount_ch: TcxGridDBColumn;
    AmountSecond_ch: TcxGridDBColumn;
    InvNumber_income_ch: TcxGridDBColumn;
    isErased_ch: TcxGridDBColumn;
    OperDate_income_ch: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    ChildDS: TDataSource;
    ChildCDS: TClientDataSet;
    dsdDBViewAddOnChild: TdsdDBViewAddOn;
    spSelectChild: TdsdStoredProc;
    spUpdateMIChild_Amount: TdsdStoredProc;
    spUpdateMIChild_AmountSecond: TdsdStoredProc;
    actUpdateMIChild_Amount: TdsdExecStoredProc;
    macUpdateMIChild_Amount: TMultiAction;
    actUpdateMIChild_AmountSecond: TdsdExecStoredProc;
    macUpdateMIChild_AmountSecond: TMultiAction;
    bbUpdateMIChild_Amount: TdxBarButton;
    bbUpdateMIChild_AmountSecond: TdxBarButton;
    actRefreshChild: TdsdDataSetRefresh;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderExternalForm);

end.
