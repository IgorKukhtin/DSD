unit Loyalty;

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
  TLoyaltyForm = class(TAncestorDocumentForm)
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
    spSelect_MovementItem_LoyaltyChild: TdsdStoredProc;
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
    spSelectPromoLoyaltySign: TdsdStoredProc;
    sgComment: TcxGridDBColumn;
    bbInsertRecordPartner: TdxBarButton;
    spInsertUpdateLoyaltySign: TdsdStoredProc;
    dsdUpdateSignDS: TdsdUpdateDataSet;
    spUpErasedMISign: TdsdStoredProc;
    actSetErasedLoyaltySign: TdsdUpdateErased;
    actSetUnErasedLoyaltySign: TdsdUpdateErased;
    bbSetErasedPromoPartner: TdxBarButton;
    bbSetUnErasedPromoPartner: TdxBarButton;
    actRefreshLoyaltySign: TdsdDataSetRefresh;
    bbInsertLoyaltySign: TdxBarButton;
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
    actRefreshLoyaltyGoods: TdsdDataSetRefresh;
    spUpdateSignIsCheckedNo: TdsdExecStoredProc;
    spUpdateSignIsCheckedYes: TdsdExecStoredProc;
    actRefreshLoyaltyChild: TdsdDataSetRefresh;
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
    spSelectLoyaltyInfo: TdsdStoredProc;
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
    actExportToXLSLoyaltyDay: TdsdExportToXLS;
    actExecLoyaltyDay: TdsdExecStoredProc;
    spSelectPrintLoyaltyDay: TdsdStoredProc;
    actLinkWithChecks: TMultiAction;
    actChoiceLoyaltyCheck: TOpenChoiceForm;
    actExecLoyaltyCheck: TdsdExecStoredProc;
    spSetLoyaltyCheck: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TLoyaltyForm);

end.
