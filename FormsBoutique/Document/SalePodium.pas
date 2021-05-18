 unit SalePodium;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dsdDB, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Datasnap.DBClient, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dxBar, Vcl.ExtCtrls, cxContainer, cxLabel, cxTextEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxButtonEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, dsdGuides, Vcl.Menus, cxPCdxBarPopupMenu, cxPC, frxClass, frxDBSet,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  DataModul, dxBarExtItems, dsdAddOn, cxCheckBox, cxCurrencyEdit,
  cxImageComboBox, cxSplitter, cxDBLabel;

type
  TSalePodiumForm = class(TParentForm)
    FormParams: TdsdFormParams;
    spSelectMI: TdsdStoredProc;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    bbRefresh: TdxBarButton;
    cxPropertiesStore: TcxPropertiesStore;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    DataPanel: TPanel;
    edInvNumber: TcxTextEdit;
    cxLabel1: TcxLabel;
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    edTo: TcxButtonEdit;
    edFrom: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    GuidesFrom: TdsdGuides;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    cxPageControl: TcxPageControl;
    cxTabSheetMain: TcxTabSheet;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    OperPrice: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    actUpdateMasterDS: TdsdUpdateDataSet;
    spInsertUpdateMIMaster: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    CountForPrice: TcxGridDBColumn;
    bbShowAll: TdxBarButton;
    bbStatic: TdxBarStatic;
    actShowAll: TBooleanStoredProcAction;
    MasterViewAddOn: TdsdDBViewAddOn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spInsertUpdateMovement: TdsdStoredProc;
    HeaderSaver: THeaderSaver;
    spGet: TdsdStoredProc;
    RefreshAddOn: TRefreshAddOn;
    actGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    GuidesFiller: TGuidesFiller;
    actInsertUpdateMovement: TdsdExecStoredProc;
    bbInsertUpdateMovement: TdxBarButton;
    actSetErased: TdsdUpdateErased;
    actSetUnErased: TdsdUpdateErased;
    actShowErased: TBooleanStoredProcAction;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbShowErased: TdxBarButton;
    cxLabel11: TcxLabel;
    spErasedMIMaster: TdsdStoredProc;
    spUnErasedMIMaster: TdsdStoredProc;
    IsErased: TcxGridDBColumn;
    StatusGuides: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    actUnCompleteMovement: TChangeGuidesStatus;
    actCompleteMovement: TChangeGuidesStatus;
    actDeleteMovement: TChangeGuidesStatus;
    ceStatus: TcxButtonEdit;
    MeasureName: TcxGridDBColumn;
    GuidesTo: TdsdGuides;
    spGetTotalSumm: TdsdStoredProc;
    cxLabel12: TcxLabel;
    edDiscountTax: TcxCurrencyEdit;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    actMIProtocol: TdsdOpenForm;
    bbMIProtocol: TdxBarButton;
    GoodsGroupNameFull: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    bbInsertRecord: TdxBarButton;
    cxLabel5: TcxLabel;
    edTotalSumm: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    edTotalSummPay: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    edTotalDebt: TcxCurrencyEdit;
    actRefreshMI: TdsdDataSetRefresh;
    PartionId: TcxGridDBColumn;
    edHappyDate: TcxDateEdit;
    cxLabel8: TcxLabel;
    cxLabel10: TcxLabel;
    ceComment_Client: TcxTextEdit;
    cxLabel13: TcxLabel;
    cePhoneMobile: TcxTextEdit;
    cxLabel17: TcxLabel;
    cePhone: TcxTextEdit;
    cxLabel14: TcxLabel;
    edLastDate: TcxDateEdit;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    ClientDataSet: TClientDataSet;
    DataSource: TDataSource;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    BarCode: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    spSelectBarCode: TdsdStoredProc;
    actPartionGoodsChoice: TOpenChoiceForm;
    actInsertRecord: TInsertRecord;
    cbIsPay: TcxCheckBox;
    DiscountSaleKindName: TcxGridDBColumn;
    actInsertUpdateMIChild: TdsdInsertUpdateAction;
    mactInsertUpdateMIChild: TMultiAction;
    bbInsertUpdateMIChild: TdxBarButton;
    actInsertUpdateMIChildTotal: TdsdInsertUpdateAction;
    mactInsertUpdateMIChildTotal: TMultiAction;
    bbInsertUpdateMIChildTotal: TdxBarButton;
    Remains: TcxGridDBColumn;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    cxLabel15: TcxLabel;
    edInsertDate: TcxDateEdit;
    cxLabel18: TcxLabel;
    edInsertName: TcxButtonEdit;
    Comment: TcxGridDBColumn;
    TotalSummDebt: TcxGridDBColumn;
    isClose: TcxGridDBColumn;
    Amount_USD_Exc: TcxGridDBColumn;
    Amount_EUR_Exc: TcxGridDBColumn;
    Amount_GRN_Exc: TcxGridDBColumn;
    actUpdateDataSource: TdsdUpdateDataSet;
    spInsertUpdateMIMaster_BarCode: TdsdStoredProc;
    spGet_Partion_byBarCode: TdsdStoredProc;
    actPrintCheck: TdsdPrintAction;
    bbPrintCheck: TdxBarButton;
    spSelectPrint_Check: TdsdStoredProc;
    edDiscountTaxTwo: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    spComplete_User: TdsdStoredProc;
    spGet_New: TdsdStoredProc;
    actComplete_User: TdsdExecStoredProc;
    actGet_New: TdsdExecStoredProc;
    mact_User: TMultiAction;
    bb_User: TdxBarButton;
    spGet_Printer: TdsdStoredProc;
    mactPrintCheck: TMultiAction;
    actGet_Printer: TdsdExecStoredProc;
    spUpdate_isChecked: TdsdStoredProc;
    actUpdate_isChecked: TdsdExecStoredProc;
    bbUpdate_isChecked: TdxBarButton;
    isChecked: TcxGridDBColumn;
    HeaderChanger: THeaderChanger;
    spGet_TotalSumm_byClient: TdsdStoredProc;
    actGet_TotalSumm_byClient: TdsdDataSetRefresh;
    PanelNameFull: TPanel;
    DBLabelNameFull: TcxDBLabel;
    OperPriceListReal: TcxGridDBColumn;
    OperPriceList_curr: TcxGridDBColumn;
    CurrencyName_pl: TcxGridDBColumn;
    OperPriceList_original: TcxGridDBColumn;
    TotalSummPriceList_curr: TcxGridDBColumn;
    TotalSummToPay_curr: TcxGridDBColumn;
    TotalSummDebt_curr: TcxGridDBColumn;
    CurrencyValue_usd: TcxGridDBColumn;
    ParValue_usd: TcxGridDBColumn;
    CurrencyValue_eur: TcxGridDBColumn;
    ParValue_eur: TcxGridDBColumn;
    edCurrencyClient: TcxButtonEdit;
    cxLabel19: TcxLabel;
    GuidesCurrencyClient: TdsdGuides;
    cbOffer: TcxCheckBox;
    mact_User_PriceReal: TMultiAction;
    mactPrintCheckPriceReal: TMultiAction;
    actPrintCheckPriceReal: TdsdPrintAction;
    bbact_User_PriceReal: TdxBarButton;
    OperPriceListReal_curr: TcxGridDBColumn;
    spInsertMI_byReturn: TdsdStoredProc;
    actInsertMI_byReturn: TdsdExecStoredProc;
    ExecuteDialog_offer: TExecuteDialog;
    macInsertMI_byReturn_offer: TMultiAction;
    bbInsertMI_byReturn_offer: TdxBarButton;
    bbPrintCheckPriceReal: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSalePodiumForm);

end.
