unit IncomeFuel;

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
  DataModul, dxBarExtItems, dsdAddOn, cxCheckBox, cxCurrencyEdit, cxSplitter,
  cxBlobEdit;

type
  TIncomeFuelForm = class(TParentForm)
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
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    PageControl: TcxPageControl;
    cxTabSheetMain: TcxTabSheet;
    actUpdateMasterDS: TdsdUpdateDataSet;
    spInsertUpdateMIMaster: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbShowAll: TdxBarButton;
    bbStatic: TdxBarStatic;
    actShowAll: TBooleanStoredProcAction;
    MasterViewAddOn: TdsdDBViewAddOn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spInsertUpdateMovement: TdsdStoredProc;
    edPriceWithVAT: TcxCheckBox;
    edVATPercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
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
    cxLabel12: TcxLabel;
    edDriver: TcxButtonEdit;
    GuidesPersonalDriver: TdsdGuides;
    edRoute: TcxButtonEdit;
    cxLabel5: TcxLabel;
    GuidesRoute: TdsdGuides;
    SetErased: TdsdUpdateErased;
    SetUnErased: TdsdUpdateErased;
    actShowErased: TBooleanStoredProcAction;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbShowErased: TdxBarButton;
    cxLabel6: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    cxLabel8: TcxLabel;
    spErasedMIMaster: TdsdStoredProc;
    spUnErasedMIMaster: TdsdStoredProc;
    cxLabel11: TcxLabel;
    edChangePrice: TcxCurrencyEdit;
    edOperDatePartner: TcxDateEdit;
    cxLabel13: TcxLabel;
    StatusGuides: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    UnCompleteMovement: TChangeGuidesStatus;
    CompleteMovement: TChangeGuidesStatus;
    DeleteMovement: TChangeGuidesStatus;
    ceStatus: TcxButtonEdit;
    spGetTotalSumm: TdsdStoredProc;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    cxGridChild: TcxGrid;
    cxGridDBTableViewChild: TcxGridDBTableView;
    clRouteMemberCode: TcxGridDBColumn;
    clAmount: TcxGridDBColumn;
    clStartOdometre: TcxGridDBColumn;
    clEndOdometre: TcxGridDBColumn;
    clOperDate: TcxGridDBColumn;
    cxGridLevelChild: TcxGridLevel;
    ChildViewAddOn: TdsdDBViewAddOn;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    spInsertUpdateMIChild: TdsdStoredProc;
    cxSplitterChild: TcxSplitter;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colFuelName: TcxGridDBColumn;
    colMeasureName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colCountForPrice: TcxGridDBColumn;
    colAmountSumm: TcxGridDBColumn;
    colIsErased: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    RouteMemberChoiceForm: TOpenChoiceForm;
    spSelectMIChild: TdsdStoredProc;
    clDistance_calc: TcxGridDBColumn;
    InsertRecordChild: TInsertRecord;
    SetErasedChild: TdsdUpdateErased;
    spErasedMIChild: TdsdStoredProc;
    spUnErasedMIChild: TdsdStoredProc;
    SetUnErasedChild: TdsdUpdateErased;
    bbInsertRecordChild: TdxBarButton;
    bbSetErasedChild: TdxBarButton;
    bbSetUnErasedChild: TdxBarButton;
    actUpdateChildDS: TdsdUpdateDataSet;
    clRouteMemberName: TcxGridDBColumn;
    clDayOfWeekName: TcxGridDBColumn;
    clisErased: TcxGridDBColumn;
    cxGrid1: TcxGrid;
    cxGridDBTableViewInfo: TcxGridDBTableView;
    colStartOdometre: TcxGridDBColumn;
    colEndOdometre: TcxGridDBColumn;
    cxGridLevelInfo: TcxGridLevel;
    spGetInfo: TdsdStoredProc;
    InfoCDS: TClientDataSet;
    InfoDS: TDataSource;
    dsdDBViewAddOnInfo: TdsdDBViewAddOn;
    colAmountFuel: TcxGridDBColumn;
    colReparation: TcxGridDBColumn;
    colLimitMoney: TcxGridDBColumn;
    colLimitChange: TcxGridDBColumn;
    colLimitDistance: TcxGridDBColumn;
    colLimitDistanceChange: TcxGridDBColumn;
    colDistanceReal: TcxGridDBColumn;
    colFuelCalc: TcxGridDBColumn;
    colFuelRealCalc: TcxGridDBColumn;
    colFuelDiff: TcxGridDBColumn;
    colFuelSummDiff: TcxGridDBColumn;
    colSummDiff: TcxGridDBColumn;
    colSummDiffTotal: TcxGridDBColumn;
    colSummReparation: TcxGridDBColumn;
    colSummPersonal: TcxGridDBColumn;
    actUpdateInfoDs: TdsdUpdateDataSet;
    MIProtocolOpenForm: TdsdOpenForm;
    MIChildProtocolOpenForm: TdsdOpenForm;
    bbMIProtocol: TdxBarButton;
    bbMIChildProtocol: TdxBarButton;
    bbRouteMember: TdxBarButton;
    SignDS: TDataSource;
    SignCDS: TClientDataSet;
    cxSplitter2: TcxSplitter;
    dsdDBViewAddOnSign: TdsdDBViewAddOn;
    spSelectMISign: TdsdStoredProc;
    SignInternalChoiceForm: TOpenChoiceForm;
    SignProtocolOpenForm: TdsdOpenForm;
    bbSignProtocolOpenForm: TdxBarButton;
    spInsertUpdateMISign: TdsdStoredProc;
    actInsertUpdateMISign: TdsdExecStoredProc;
    bbInsertUpdateMISign: TdxBarButton;
    spInsertUpdateMISign_No: TdsdStoredProc;
    actInsertUpdateMISignNO: TdsdExecStoredProc;
    bbInsertUpdateMISignNO: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    cxGridSign: TcxGrid;
    cxGridDBTableViewSign: TcxGridDBTableView;
    sgIsSign: TcxGridDBColumn;
    sclSignInternalName: TcxGridDBColumn;
    sgOrd: TcxGridDBColumn;
    sgUserName: TcxGridDBColumn;
    sgOperDate: TcxGridDBColumn;
    sclisErased: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TIncomeFuelForm);

end.
