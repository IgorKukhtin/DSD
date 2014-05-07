unit PersonalSendCash;

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
  DataModul, dxBarExtItems, dsdAddOn, cxCheckBox, cxCurrencyEdit;

type
  TPersonalSendCashForm = class(TParentForm)
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
    edPersonal: TcxButtonEdit;
    cxLabel3: TcxLabel;
    GuidesPersonal: TdsdGuides;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    cxPageControl: TcxPageControl;
    cxTabSheetMain: TcxTabSheet;
    cxTabSheetEntry: TcxTabSheet;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    colPersonalCode: TcxGridDBColumn;
    colPersonalName: TcxGridDBColumn;
    colAmount_20401: TcxGridDBColumn;
    colAmount_21201: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    spSelectMIContainer: TdsdStoredProc;
    cxGridEntryDBTableView: TcxGridDBTableView;
    cxGridEntryLevel: TcxGridLevel;
    cxGridEntry: TcxGrid;
    colDebetAccountName: TcxGridDBColumn;
    colDebetAmount: TcxGridDBColumn;
    EntryCDS: TClientDataSet;
    EntryDS: TDataSource;
    colKreditAccountName: TcxGridDBColumn;
    colKreditAmount: TcxGridDBColumn;
    actUpdateMasterDS: TdsdUpdateDataSet;
    spInsertUpdateMIMaster: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    colDebetAccountGroupName: TcxGridDBColumn;
    colDebetAccountDirectionName: TcxGridDBColumn;
    colAccountCode: TcxGridDBColumn;
    colKreditAccountGroupName: TcxGridDBColumn;
    colKreditAccountDirectionName: TcxGridDBColumn;
    colDirectionObjectCode: TcxGridDBColumn;
    colDirectionObjectName: TcxGridDBColumn;
    colDestinationObjectName: TcxGridDBColumn;
    colAccountOnComplete: TcxGridDBColumn;
    bbStatic: TdxBarStatic;
    MasterViewAddOn: TdsdDBViewAddOn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    EntryViewAddOn: TdsdDBViewAddOn;
    spInsertUpdateMovement: TdsdStoredProc;
    HeaderSaver: THeaderSaver;
    spGet: TdsdStoredProc;
    RefreshAddOn: TRefreshAddOn;
    colDestinationObjectCode: TcxGridDBColumn;
    colInfoMoneyName: TcxGridDBColumn;
    colInfoMoneyName_Detail: TcxGridDBColumn;
    GridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    EntryToExcel: TdsdGridToExcel;
    bbEntryToGrid: TdxBarButton;
    GuidesFiller: TGuidesFiller;
    actInsertUpdateMovement: TdsdExecStoredProc;
    bbInsertUpdateMovement: TdxBarButton;
    colRouteName: TcxGridDBColumn;
    colCarName: TcxGridDBColumn;
    PersonalChoiceForm: TOpenChoiceForm;
    InsertRecord: TInsertRecord;
    SetErased: TdsdUpdateErased;
    SetUnErased: TdsdUpdateErased;
    actShowErased: TBooleanStoredProcAction;
    bbInsert: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbShowErased: TdxBarButton;
    RouteChoiceForm: TOpenChoiceForm;
    CarChoiceForm: TOpenChoiceForm;
    cxLabel4: TcxLabel;
    spErasedMIMaster: TdsdStoredProc;
    spUnErasedMIMaster: TdsdStoredProc;
    colIsErased: TcxGridDBColumn;
    colCarModelName: TcxGridDBColumn;
    colBusinessCode: TcxGridDBColumn;
    colBusinessName: TcxGridDBColumn;
    ceStatus: TcxButtonEdit;
    StatusGuides: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    UnCompleteMovement: TChangeGuidesStatus;
    CompleteMovement: TChangeGuidesStatus;
    DeleteMovement: TChangeGuidesStatus;
    colOperDate: TcxGridDBColumn;
    clOperDate: TcxGridDBColumn;
    colBranchCode: TcxGridDBColumn;
    colBranchName: TcxGridDBColumn;
    colInvNumber: TcxGridDBColumn;
    colJuridicalBasisCode: TcxGridDBColumn;
    colJuridicalBasisName: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPersonalSendCashForm);

end.
