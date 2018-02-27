unit Sale;

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
  cxImageComboBox, cxSplitter;

type
  TSaleForm = class(TParentForm)
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
    edFrrom: TcxButtonEdit;
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
    GridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    GuidesFiller: TGuidesFiller;
    actInsertUpdateMovement: TdsdExecStoredProc;
    bbInsertUpdateMovement: TdxBarButton;
    SetErased: TdsdUpdateErased;
    SetUnErased: TdsdUpdateErased;
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
    UnCompleteMovement: TChangeGuidesStatus;
    CompleteMovement: TChangeGuidesStatus;
    DeleteMovement: TChangeGuidesStatus;
    ceStatus: TcxButtonEdit;
    MeasureName: TcxGridDBColumn;
    GuidesTo: TdsdGuides;
    spGetTotalSumm: TdsdStoredProc;
    cxLabel12: TcxLabel;
    edDiscountTax: TcxCurrencyEdit;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    MovementItemProtocolOpenForm: TdsdOpenForm;
    bbMovementItemProtocol: TdxBarButton;
    GoodsGroupNameFull: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    bbCalcAmountPartner: TdxBarControlContainerItem;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    bbInsertRecord: TdxBarButton;
    bbCompleteCost: TdxBarButton;
    bbactUnCompleteCost: TdxBarButton;
    bbactSetErasedCost: TdxBarButton;
    bbShowErasedCost: TdxBarButton;
    cxLabel5: TcxLabel;
    edTotalSumm: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    edTotalSummPay: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    edTotalDebt: TcxCurrencyEdit;
    bbUpdateRecord1: TdxBarButton;
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
    actGoodsChoiceForm: TOpenChoiceForm;
    InsertRecord: TInsertRecord;
    cbisPay: TcxCheckBox;
    DiscountSaleKindName: TcxGridDBColumn;
    actInsertUpdateMIChild: TdsdInsertUpdateAction;
    MacInsertUpdateMIChild: TMultiAction;
    bbInsertUpdateMIChild: TdxBarButton;
    actInsertUpdateMIChildTotal: TdsdInsertUpdateAction;
    MacInsertUpdateMIChildTotal: TMultiAction;
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
    clBarCode: TcxGridDBColumn;
    spGet_Partion_byBarcode: TdsdStoredProc;
    BarCode_str: TcxGridDBColumn;
    actPrintCheck: TdsdPrintAction;
    bbPrintCheck: TdxBarButton;
    spSelectPrint_Check: TdsdStoredProc;
    edDiscountTaxTwo: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    spComplete_User: TdsdStoredProc;
    spGet_New: TdsdStoredProc;
    actComplete_User: TdsdExecStoredProc;
    actGet_New: TdsdExecStoredProc;
    mac_User: TMultiAction;
    bbmac_User: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSaleForm);

end.
