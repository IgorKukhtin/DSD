unit DistributionPromo;

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
  dsdExportToXLSAction, cxMemo;

type
  TDistributionPromoForm = class(TAncestorDocumentForm)
    MasterGoodsGroupCode: TcxGridDBColumn;
    MasterGoodsGroupName: TcxGridDBColumn;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chJuridicalName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    DetailDCS: TClientDataSet;
    DetailDS: TDataSource;
    spSelect_MovementItem_DistributionPromoChild: TdsdStoredProc;
    cxSplitter1: TcxSplitter;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    IsErased: TcxGridDBColumn;
    spInsertUpdateMIChild: TdsdStoredProc;
    cxLabel3: TcxLabel;
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
    bbInsertRecordChild: TdxBarButton;
    bbOpenReportForm: TdxBarButton;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    SignDCS: TClientDataSet;
    SignDS: TDataSource;
    dsdDBViewAddOn2: TdsdDBViewAddOn;
    spSelectPromoDistributionPromoSign: TdsdStoredProc;
    bbInsertRecordPartner: TdxBarButton;
    dsdUpdateSignDS: TdsdUpdateDataSet;
    spUpErasedMISign: TdsdStoredProc;
    bbSetErasedPromoPartner: TdxBarButton;
    bbSetUnErasedPromoPartner: TdxBarButton;
    actRefreshDistributionPromoSign: TdsdDataSetRefresh;
    bbInsertDistributionPromoSign: TdxBarButton;
    bbReportMinPriceForm: TdxBarButton;
    bbOpenReportMinPrice_All: TdxBarButton;
    spErasedMISign: TdsdStoredProc;
    cxSplitter2: TcxSplitter;
    sgNumberIssued: TcxGridDBColumn;
    bbGoodsIsCheckedYes: TdxBarButton;
    bbGoodsIsCheckedNo: TdxBarButton;
    actRefreshDistributionPromoGoods: TdsdDataSetRefresh;
    spUpdateSignIsCheckedNo: TdsdExecStoredProc;
    spUpdateSignIsCheckedYes: TdsdExecStoredProc;
    actRefreshDistributionPromoChild: TdsdDataSetRefresh;
    bbChildIsCheckedNo: TdxBarButton;
    bbChildIsCheckedYes: TdxBarButton;
    bbSignIsCheckedNo: TdxBarButton;
    bbSignIsCheckedYes: TdxBarButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    cxSplitter3: TcxSplitter;
    MasterErased: TcxGridDBColumn;
    edEndPromo: TcxDateEdit;
    edStartPromo: TcxDateEdit;
    sqJuridicalName: TcxGridDBColumn;
    sqRetailName: TcxGridDBColumn;
    sqUnitName: TcxGridDBColumn;
    chIsChecked: TcxGridDBColumn;
    spSelectPrintDistributionPromoDay: TdsdStoredProc;
    actLinkWithChecks: TMultiAction;
    actChoiceDistributionPromoCheck: TOpenChoiceForm;
    actExecDistributionPromoCheck: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    PrintTitleCDS: TClientDataSet;
    dxBarButton3: TdxBarButton;
    dsdDBViewAddOn3: TdsdDBViewAddOn;
    cxLabel19: TcxLabel;
    edRetail: TcxButtonEdit;
    GuidesRetail: TdsdGuides;
    dxBarButton4: TdxBarButton;
    spUnhook_Movement: TdsdStoredProc;
    dxBarButton5: TdxBarButton;
    cbisElectron: TcxCheckBox;
    actInsertPromoCode: TMultiAction;
    actExecSPInsertPromoCode: TdsdExecStoredProc;
    actExecuteDialogPromoCode: TExecuteDialog;
    bbInsertPromoCode: TdxBarButton;
    actPrintSticker: TdsdExportToXLS;
    ExecSPPrintSticker: TdsdExecStoredProc;
    ExecutePromoCodeSignUnitName: TExecuteDialog;
    dxBarButton6: TdxBarButton;
    actInsertPromoCodeScales: TMultiAction;
    actExecSPInsertPromoCodeScales: TdsdExecStoredProc;
    actExecuteDialogPromoCodeScales: TExecuteDialog;
    dxBarButton7: TdxBarButton;
    edSummRepay: TcxCurrencyEdit;
    cxLabel20: TcxLabel;
    sqNumberRequests: TcxGridDBColumn;
    actOpenCheckSale: TdsdInsertUpdateAction;
    bbOpenCheckCreate: TdxBarButton;
    bbOpenCheckSale: TdxBarButton;
    MasterIsChecked: TcxGridDBColumn;
    edAmount: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edMessage: TcxMemo;
    cxLabel4: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TDistributionPromoForm);

end.
