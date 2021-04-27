unit ReturnInPodium;

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
  cxImageComboBox, cxSplitter, ChoicePeriod, cxDBLabel;

type
  TReturnInPodiumForm = class(TParentForm)
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
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    GuidesTo: TdsdGuides;
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
    GuidesFrom: TdsdGuides;
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
    cxLabel5: TcxLabel;
    edTotalSumm: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    edTotalSummPay: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    edTotalDebt: TcxCurrencyEdit;
    actRefreshMI: TdsdDataSetRefresh;
    edHappyDate: TcxDateEdit;
    cxLabel8: TcxLabel;
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
    cbIsPay: TcxCheckBox;
    actInsertUpdateMIChild: TdsdInsertUpdateAction;
    mactInsertUpdateMIChild: TMultiAction;
    bbInsertUpdateMIChild: TdxBarButton;
    actInsertUpdateMIChildTotal: TdsdInsertUpdateAction;
    mactInsertUpdateMIChildTotal: TMultiAction;
    bbInsertUpdateMIChildTotal: TdxBarButton;
    cxLabel15: TcxLabel;
    edStartDate: TcxDateEdit;
    edEndDate: TcxDateEdit;
    PartionId: TcxGridDBColumn;
    SaleMI_Id: TcxGridDBColumn;
    RefreshDispatcher: TRefreshDispatcher;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    cxLabel18: TcxLabel;
    edInsertDate: TcxDateEdit;
    edInsertName: TcxButtonEdit;
    cxLabel19: TcxLabel;
    Amount_Return: TcxGridDBColumn;
    actUpdateDataSource: TdsdUpdateDataSet;
    spGet_Partion_byBarcode: TdsdStoredProc;
    spInsertUpdateMIMaster_BarCode: TdsdStoredProc;
    ChangePercent: TcxGridDBColumn;
    OperDate_Sale: TcxGridDBColumn;
    InvNumber_Sale: TcxGridDBColumn;
    TotalPay_Sale: TcxGridDBColumn;
    TotalPayOth_Sale: TcxGridDBColumn;
    TotalPay_Return: TcxGridDBColumn;
    SummDebt: TcxGridDBColumn;
    SummChangePercent_sale: TcxGridDBColumn;
    TotalChangePercent_sale: TcxGridDBColumn;
    TotalChangePercent: TcxGridDBColumn;
    TotalPayOth: TcxGridDBColumn;
    spSelectPrint_Check: TdsdStoredProc;
    actPrintCheck: TdsdPrintAction;
    bbPrintCheck: TdxBarButton;
    cxLabel9: TcxLabel;
    ceComment_Client: TcxTextEdit;
    cxLabel10: TcxLabel;
    edDiscountTaxTwo: TcxCurrencyEdit;
    spComplete_User: TdsdStoredProc;
    spGet_New: TdsdStoredProc;
    actGet_New: TdsdExecStoredProc;
    actComplete_User: TdsdExecStoredProc;
    mact_User: TMultiAction;
    bb_User: TdxBarButton;
    spGet_Printer: TdsdStoredProc;
    actGet_Printer: TdsdExecStoredProc;
    mactPrintCheck: TMultiAction;
    HeaderChanger: THeaderChanger;
    spGet_TotalSumm_byClient: TdsdStoredProc;
    actGet_TotalSumm_byClient: TdsdDataSetRefresh;
    PeriodChoice: TPeriodChoice;
    isLine: TcxGridDBColumn;
    PanelNameFull: TPanel;
    DBLabelNameFull: TcxDBLabel;
    spInsertUpdate_Movement_Sale: TdsdStoredProc;
    actInsert_Movement_Sale: TdsdExecStoredProc;
    actOpenSalePodiumForm: TdsdOpenForm;
    mact_User_Sale: TMultiAction;
    spGet_Check_ReturnIn_No: TdsdStoredProc;
    spGet_Check_ReturnIn_Yes: TdsdStoredProc;
    actGet_Check_ReturnIn_No: TdsdExecStoredProc;
    actGet_Check_ReturnIn_Yes: TdsdExecStoredProc;
    bbact_User_Sale: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReturnInPodiumForm);

end.
