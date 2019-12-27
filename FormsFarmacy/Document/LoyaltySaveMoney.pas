unit LoyaltySaveMoney;

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
  TLoyaltySaveMoneyForm = class(TAncestorDocumentForm)
    SignAmount: TcxGridDBColumn;
    SignChangePercent: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    cxSplitter1: TcxSplitter;
    edStartPromo: TcxDateEdit;
    cxLabel3: TcxLabel;
    edEndPromo: TcxDateEdit;
    cxLabel6: TcxLabel;
    actMISetErasedChild: TdsdUpdateErased;
    actMISetUnErasedChild: TdsdUpdateErased;
    bbMISetErasedChild: TdxBarButton;
    bbMISetUnErasedChild: TdxBarButton;
    actUpdateChildDS: TdsdUpdateDataSet;
    JuridicalChoiceForm: TOpenChoiceForm;
    actDoLoad: TExecuteImportSettingsAction;
    spGetImportSettingId: TdsdStoredProc;
    bbactStartLoad: TdxBarButton;
    bbInsertRecordChild: TdxBarButton;
    bbOpenReportForm: TdxBarButton;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    SignDCS: TClientDataSet;
    SignDS: TDataSource;
    dsdDBViewAddOn2: TdsdDBViewAddOn;
    spSelectPromoLoyaltySaveMoneySign: TdsdStoredProc;
    sgComment: TcxGridDBColumn;
    bbInsertRecordPartner: TdxBarButton;
    spInsertUpdateLoyaltySaveMoneySign: TdsdStoredProc;
    dsdUpdateSignDS: TdsdUpdateDataSet;
    spUpErasedMISign: TdsdStoredProc;
    actSetErasedLoyaltySaveMoneySign: TdsdUpdateErased;
    actSetUnErasedLoyaltySaveMoneySign: TdsdUpdateErased;
    bbSetErasedPromoPartner: TdxBarButton;
    bbSetUnErasedPromoPartner: TdxBarButton;
    actRefreshLoyaltySaveMoneySign: TdsdDataSetRefresh;
    bbInsertLoyaltySaveMoneySign: TdxBarButton;
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
    BuyerName: TcxGridDBColumn;
    bbGoodsIsCheckedYes: TdxBarButton;
    bbGoodsIsCheckedNo: TdxBarButton;
    actRefreshLoyaltySaveMoneyGoods: TdsdDataSetRefresh;
    spUpdateSignIsCheckedNo: TdsdExecStoredProc;
    spUpdateSignIsCheckedYes: TdsdExecStoredProc;
    actRefreshLoyaltySaveMoneyChild: TdsdDataSetRefresh;
    bbChildIsCheckedNo: TdxBarButton;
    bbChildIsCheckedYes: TdxBarButton;
    bbSignIsCheckedNo: TdxBarButton;
    bbSignIsCheckedYes: TdxBarButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    cxSplitter3: TcxSplitter;
    cxGrid3: TcxGrid;
    cxGridDBTableView3: TcxGridDBTableView;
    cxGridLevel3: TcxGridLevel;
    InfoDS: TDataSource;
    InfoDSD: TClientDataSet;
    spSelectLoyaltySaveMoneyInfo: TdsdStoredProc;
    MasterErased: TcxGridDBColumn;
    edEndSale: TcxDateEdit;
    cxLabel4: TcxLabel;
    edStartSale: TcxDateEdit;
    cxLabel5: TcxLabel;
    Amount: TcxGridDBColumn;
    sgUnitName: TcxGridDBColumn;
    spSelectPrintLoyaltySaveMoneyDay: TdsdStoredProc;
    spSetLoyaltySaveMoneyCheck: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    PrintTitleCDS: TClientDataSet;
    dxBarButton3: TdxBarButton;
    dsdDBViewAddOn3: TdsdDBViewAddOn;
    cxLabel19: TcxLabel;
    edRetail: TcxButtonEdit;
    GuidesRetail: TdsdGuides;
    dxBarButton4: TdxBarButton;
    BuyerPhone: TcxGridDBColumn;
    SummaUse: TcxGridDBColumn;
    SummaRemainder: TcxGridDBColumn;
    actChoiceBuyer: TOpenChoiceForm;
    actBuyerEdit: TdsdOpenForm;
    dxBarButton5: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TLoyaltySaveMoneyForm);

end.
