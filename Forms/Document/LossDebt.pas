unit LossDebt;

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
  TLossDebtForm = class(TParentForm)
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
    edJuridicalBasis: TcxButtonEdit;
    cxLabel3: TcxLabel;
    GuidesJuridicalBasis: TdsdGuides;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    cxPageControl: TcxPageControl;
    cxTabSheetMain: TcxTabSheet;
    cxTabSheetEntry: TcxTabSheet;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    clJuridicalCode: TcxGridDBColumn;
    clJuridicalName: TcxGridDBColumn;
    clAmountDebet: TcxGridDBColumn;
    clInfoMoneyName: TcxGridDBColumn;
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
    frxDBDataset: TfrxDBDataset;
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
    GridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    EntryToExcel: TdsdGridToExcel;
    bbEntryToGrid: TdxBarButton;
    GuidesFiller: TGuidesFiller;
    actInsertUpdateMovement: TdsdExecStoredProc;
    bbInsertUpdateMovement: TdxBarButton;
    InsertRecord: TInsertRecord;
    SetErased: TdsdUpdateErased;
    SetUnErased: TdsdUpdateErased;
    actShowErased: TBooleanStoredProcAction;
    bbInsert: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbShowErased: TdxBarButton;
    cxLabel4: TcxLabel;
    spErasedMIMaster: TdsdStoredProc;
    spUnErasedMIMaster: TdsdStoredProc;
    clIsErased: TcxGridDBColumn;
    colBusinessCode: TcxGridDBColumn;
    colBusinessName: TcxGridDBColumn;
    ceStatus: TcxButtonEdit;
    StatusGuides: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    UnCompleteMovement: TChangeGuidesStatus;
    CompleteMovement: TChangeGuidesStatus;
    DeleteMovement: TChangeGuidesStatus;
    clOperDate: TcxGridDBColumn;
    InfoMoneyChoiceForm: TOpenChoiceForm;
    clContractName: TcxGridDBColumn;
    ContractChoiceForm: TOpenChoiceForm;
    clInfoMoneyCode: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    edBusiness: TcxButtonEdit;
    GuidesBusiness: TdsdGuides;
    actShowAll: TBooleanStoredProcAction;
    clInfoMoneyGroupName: TcxGridDBColumn;
    clInfoMoneyDestinationName: TcxGridDBColumn;
    clUnitName: TcxGridDBColumn;
    clPaidKindName: TcxGridDBColumn;
    clAmountKredit: TcxGridDBColumn;
    clSummDebet: TcxGridDBColumn;
    clSummKredit: TcxGridDBColumn;
    clIsCalculated: TcxGridDBColumn;
    bbShowAll: TdxBarButton;
    clOKPO: TcxGridDBColumn;
    colJuridicalBasisCode: TcxGridDBColumn;
    colJuridicalBasisName: TcxGridDBColumn;
    colBranchCode: TcxGridDBColumn;
    colBranchName: TcxGridDBColumn;
    PaidKindChoiceForm: TOpenChoiceForm;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TLossDebtForm);

end.
