unit LoyaltyPresent;

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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, ExternalLoad, cxCheckBox,
  dsdExportToXLSAction;

type
  TLoyaltyPresentForm = class(TAncestorDocumentForm)
    MasterAmount: TcxGridDBColumn;
    MasterCount: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chJuridicalName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    DetailDCS: TClientDataSet;
    DetailDS: TDataSource;
    spSelect_MovementItem_LoyaltyPresentChild: TdsdStoredProc;
    cxSplitter1: TcxSplitter;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    IsErased: TcxGridDBColumn;
    spInsertUpdateMIChild: TdsdStoredProc;
    edStartPromo: TcxDateEdit;
    cxLabel3: TcxLabel;
    edEndPromo: TcxDateEdit;
    cxLabel6: TcxLabel;
    spErasedMIChild: TdsdStoredProc;
    spUnErasedMIChild: TdsdStoredProc;
    actMISetErasedChild: TdsdUpdateErased;
    actMISetUnErasedChild: TdsdUpdateErased;
    bbMISetErasedChild: TdxBarButton;
    bbMISetUnErasedChild: TdxBarButton;
    actUpdateChildDS: TdsdUpdateDataSet;
    JuridicalChoiceForm: TOpenChoiceForm;
    actDoLoad: TExecuteImportSettingsAction;
    spGetImportSettingId: TdsdStoredProc;
    bbactStartLoad: TdxBarButton;
    cxLabel9: TcxLabel;
    edDayCount: TcxCurrencyEdit;
    bbInsertRecordChild: TdxBarButton;
    bbOpenReportForm: TdxBarButton;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    SignDCS: TClientDataSet;
    SignDS: TDataSource;
    dsdDBViewAddOn2: TdsdDBViewAddOn;
    spSelectPromoLoyaltyPresentSign: TdsdStoredProc;
    sgComment: TcxGridDBColumn;
    bbInsertRecordPartner: TdxBarButton;
    spInsertUpdateLoyaltyPresentSign: TdsdStoredProc;
    dsdUpdateSignDS: TdsdUpdateDataSet;
    spUpErasedMISign: TdsdStoredProc;
    actSetErasedLoyaltyPresentSign: TdsdUpdateErased;
    actSetUnErasedLoyaltyPresentSign: TdsdUpdateErased;
    bbSetErasedPromoPartner: TdxBarButton;
    bbSetUnErasedPromoPartner: TdxBarButton;
    actRefreshLoyaltyPresentSign: TdsdDataSetRefresh;
    bbInsertLoyaltyPresentSign: TdxBarButton;
    bbReportMinPriceForm: TdxBarButton;
    bbOpenReportMinPrice_All: TdxBarButton;
    cxLabel10: TcxLabel;
    edInsertName: TcxButtonEdit;
    GuidesInsert: TdsdGuides;
    cxLabel11: TcxLabel;
    edUpdateName: TcxButtonEdit;
    GuidesUpdate: TdsdGuides;
    cxLabel12: TcxLabel;
    edInsertdate: TcxDateEdit;
    cxLabel13: TcxLabel;
    edUpdateDate: TcxDateEdit;
    spErasedMISign: TdsdStoredProc;
    sgInsertName: TcxGridDBColumn;
    sgUpdateName: TcxGridDBColumn;
    cxSplitter2: TcxSplitter;
    sgGUID: TcxGridDBColumn;
    bbGoodsIsCheckedYes: TdxBarButton;
    bbGoodsIsCheckedNo: TdxBarButton;
    actRefreshLoyaltyPresentGoods: TdsdDataSetRefresh;
    spUpdateSignIsCheckedNo: TdsdExecStoredProc;
    spUpdateSignIsCheckedYes: TdsdExecStoredProc;
    actRefreshLoyaltyPresentChild: TdsdDataSetRefresh;
    bbChildIsCheckedNo: TdxBarButton;
    bbChildIsCheckedYes: TdxBarButton;
    bbSignIsCheckedNo: TdxBarButton;
    bbSignIsCheckedYes: TdxBarButton;
    sgInvnumber_Check: TcxGridDBColumn;
    sgOperDate_Check: TcxGridDBColumn;
    sgUnitName_Check: TcxGridDBColumn;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    cxSplitter3: TcxSplitter;
    cxGrid3: TcxGrid;
    cxGridDBTableView3: TcxGridDBTableView;
    InfoOperDate: TcxGridDBColumn;
    InfoAmount: TcxGridDBColumn;
    cxGridLevel3: TcxGridLevel;
    InfoDS: TDataSource;
    InfoDSD: TClientDataSet;
    spSelectLoyaltyPresentInfo: TdsdStoredProc;
    MasterErased: TcxGridDBColumn;
    edEndSale: TcxDateEdit;
    cxLabel4: TcxLabel;
    edStartSale: TcxDateEdit;
    cxLabel5: TcxLabel;
    edStartSummCash: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    sgOperDate: TcxGridDBColumn;
    sgAmount: TcxGridDBColumn;
    sqInvnumber_CheckSale: TcxGridDBColumn;
    sqOperDate_CheckSale: TcxGridDBColumn;
    sqUnitName_CheckSale: TcxGridDBColumn;
    chIsChecked: TcxGridDBColumn;
    sgUnitName: TcxGridDBColumn;
    edMonthCount: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edSummLimit: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    chDayCount: TcxGridDBColumn;
    chSummLimit: TcxGridDBColumn;
    edChangePercent: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    edServiceDate: TcxDateEdit;
    cxLabel18: TcxLabel;
    InfoAccrued: TcxGridDBColumn;
    InfoSummChange: TcxGridDBColumn;
    dsdStoredProc1: TdsdStoredProc;
    InfoAccruedCount: TcxGridDBColumn;
    InfoChangeCount: TcxGridDBColumn;
    InfoPercentUsed: TcxGridDBColumn;
    actExportToXLSLoyaltyPresentDay: TdsdExportToXLS;
    actExecLoyaltyPresentDay: TdsdExecStoredProc;
    spSelectPrintLoyaltyPresentDay: TdsdStoredProc;
    actLinkWithChecks: TMultiAction;
    actChoiceLoyaltyPresentCheck: TOpenChoiceForm;
    actExecLoyaltyPresentCheck: TdsdExecStoredProc;
    spSetLoyaltyPresentCheck: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    PrintTitleCDS: TClientDataSet;
    actExportCreaturesPromocode: TdsdOpenForm;
    actExportUsedPromocode: TdsdOpenForm;
    dxBarButton3: TdxBarButton;
    dsdDBViewAddOn3: TdsdDBViewAddOn;
    cxLabel19: TcxLabel;
    edRetail: TcxButtonEdit;
    GuidesRetail: TdsdGuides;
    spUnhook_MovementItem: TdsdStoredProc;
    actUnhook_MovementItem: TdsdExecStoredProc;
    dxBarButton4: TdxBarButton;
    cbBeginning: TcxCheckBox;
    spUnhook_Movement: TdsdStoredProc;
    actUnhook_Movement: TdsdExecStoredProc;
    dxBarButton5: TdxBarButton;
    cbisElectron: TcxCheckBox;
    actInsertPromoCode: TMultiAction;
    actExecSPInsertPromoCode: TdsdExecStoredProc;
    actExecuteDialogPromoCode: TExecuteDialog;
    bbInsertPromoCode: TdxBarButton;
    spInsertPromoCode: TdsdStoredProc;
    actPrintSticker: TdsdExportToXLS;
    ExecSPPrintSticker: TdsdExecStoredProc;
    ExecutePromoCodeSignUnitName: TExecuteDialog;
    spSelectPrintSticker: TdsdStoredProc;
    dxBarButton6: TdxBarButton;
    actInsertPromoCodeScales: TMultiAction;
    actExecSPInsertPromoCodeScales: TdsdExecStoredProc;
    actExecuteDialogPromoCodeScales: TExecuteDialog;
    spInsertPromoCodeScales: TdsdStoredProc;
    dxBarButton7: TdxBarButton;
    edSummRepay: TcxCurrencyEdit;
    cxLabel20: TcxLabel;
    sqTotalSumm_CheckSale: TcxGridDBColumn;
    actOpenCheckCreate: TdsdInsertUpdateAction;
    actOpenCheckSale: TdsdInsertUpdateAction;
    bbOpenCheckCreate: TdxBarButton;
    bbOpenCheckSale: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TLoyaltyPresentForm);

end.
