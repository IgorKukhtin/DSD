unit Invoice;

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
  cxImageComboBox, cxSplitter, dsdCommon;

type
  TInvoiceForm = class(TParentForm)
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
    cxLabel3: TcxLabel;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    cxPageControl: TcxPageControl;
    cxTabSheetMain: TcxTabSheet;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    AmountSumm: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    actUpdateMasterDS: TdsdUpdateDataSet;
    spInsertUpdateMIMaster: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    CountForPrice: TcxGridDBColumn;
    bbShowAll: TdxBarButton;
    bbStatic: TdxBarStatic;
    MasterViewAddOn: TdsdDBViewAddOn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spInsertUpdateMovement: TdsdStoredProc;
    edPriceWithVAT: TcxCheckBox;
    edVATPercent: TcxCurrencyEdit;
    edChangePercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    HeaderSaver: THeaderSaver;
    spGet: TdsdStoredProc;
    RefreshAddOn: TRefreshAddOn;
    GridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    GuidesFiller: TGuidesFiller;
    actInsertUpdateMovement: TdsdExecStoredProc;
    bbInsertUpdateMovement: TdxBarButton;
    cxLabel9: TcxLabel;
    edContract: TcxButtonEdit;
    cxLabel10: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesContract: TdsdGuides;
    GuidesPaidKind: TdsdGuides;
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
    GuidesFrom: TdsdGuides;
    spGetTotalSumm: TdsdStoredProc;
    cxLabel12: TcxLabel;
    edCurrencyValue: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edCurrencyDocument: TcxButtonEdit;
    GuidesCurrencyDocument: TdsdGuides;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    MovementItemProtocolOpenForm: TdsdOpenForm;
    bbMovementItemProtocol: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    bbCalcAmountPartner: TdxBarControlContainerItem;
    spInsertMaskMIMaster: TdsdStoredProc;
    actAddMask: TdsdExecStoredProc;
    bbAddMask: TdxBarButton;
    actGoodsChoiceForm: TOpenChoiceForm;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    actInsertRecord: TInsertRecord;
    actMeasureChoiceForm: TOpenChoiceForm;
    bbInsertRecord: TdxBarButton;
    bbCompleteCost: TdxBarButton;
    bbactUnCompleteCost: TdxBarButton;
    bbactSetErasedCost: TdxBarButton;
    bbShowErasedCost: TdxBarButton;
    Comment: TcxGridDBColumn;
    actUnitChoiceForm: TOpenChoiceForm;
    actAssetChoiceForm: TOpenChoiceForm;
    actNameBeforeChoiceForm: TOpenChoiceForm;
    cxLabel19: TcxLabel;
    edInvNumberOrderIncome: TcxButtonEdit;
    GuidesOrderIncome: TdsdGuides;
    actShowAll: TBooleanStoredProcAction;
    MIId_OrderIncome: TcxGridDBColumn;
    cxSplitter1: TcxSplitter;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chUnitName: TcxGridDBColumn;
    chAmount: TcxGridDBColumn;
    chOperDate: TcxGridDBColumn;
    chComment: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    ChildDS: TDataSource;
    DBViewChildAddOn: TdsdDBViewAddOn;
    ChildCDS: TClientDataSet;
    spInsertUpdateMIChild: TdsdStoredProc;
    spSelectMIChild: TdsdStoredProc;
    actUpdateChildDS: TdsdUpdateDataSet;
    actInsertRecordChild: TInsertRecord;
    bbInsertRecordChild: TdxBarButton;
    spErasedMIChild: TdsdStoredProc;
    spUnErasedMIChild: TdsdStoredProc;
    SetErasedChild: TdsdUpdateErased;
    SetUnErasedChild: TdsdUpdateErased;
    bbSetErasedChild: TdxBarButton;
    bbSetUnErasedChild: TdxBarButton;
    InvNumber_OrderIncome: TcxGridDBColumn;
    actOrderIncomeJournalDetailChoiceForm: TOpenChoiceForm;
    cxLabel24: TcxLabel;
    edParValue: TcxCurrencyEdit;
    PriceOrderIncome: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    actUpdateAsset_toGoods: TOpenChoiceForm;
    bbUpdateAsset_toGoods: TdxBarButton;
    AssetCode: TcxGridDBColumn;
    spisClosed: TdsdStoredProc;
    edisClosed: TcxCheckBox;
    actClosed: TdsdExecStoredProc;
    bbClosed: TdxBarButton;
    cxLabel4: TcxLabel;
    edTotalSumm_f1: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    edTotalSumm_f2: TcxCurrencyEdit;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TInvoiceForm);

end.
