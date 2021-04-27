unit OrderFinanceMovement;

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
  cxImageComboBox, dsdInternetAction;

type
  TOrderFinanceMovementForm = class(TParentForm)
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
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    cxPageControl: TcxPageControl;
    cxTabSheetMain: TcxTabSheet;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    ContractCode: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    AmountRemains: TcxGridDBColumn;
    AmountPlan: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    actUpdateMasterDS: TdsdUpdateDataSet;
    spInsertUpdateMIMaster: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    AmountPartner: TcxGridDBColumn;
    bbShowAll: TdxBarButton;
    bbStatic: TdxBarStatic;
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
    spGetTotalSumm: TdsdStoredProc;
    actMIContainer: TdsdOpenForm;
    bbMIContainer: TdxBarButton;
    MovementItemProtocolOpenForm: TdsdOpenForm;
    bbMovementItemProtocol: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    bbCalcAmountPartner: TdxBarControlContainerItem;
    spIDEL: TdsdStoredProc;
    actAddMask: TdsdExecStoredProc;
    bbAddMask: TdxBarButton;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    actInsertRecord: TInsertRecord;
    bbInsertRecord: TdxBarButton;
    bbCompleteCost: TdxBarButton;
    bbactUnCompleteCost: TdxBarButton;
    bbactSetErasedCost: TdxBarButton;
    bbShowErasedCost: TdxBarButton;
    Comment: TcxGridDBColumn;
    actJuridicalChoiceForm: TOpenChoiceForm;
    actContractChoiceForm: TOpenChoiceForm;
    cxLabel4: TcxLabel;
    edOrderFinance: TcxButtonEdit;
    GuidesOrderFinance: TdsdGuides;
    cxTabSheet1: TcxTabSheet;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chJuridicalCode: TcxGridDBColumn;
    chJuridicalName: TcxGridDBColumn;
    chisErased: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    JuridicalCDS: TClientDataSet;
    JuridicalDS: TDataSource;
    dsdDBViewAddOnJuridical: TdsdDBViewAddOn;
    spSelectJuridicalOrderFinance: TdsdStoredProc;
    chSummOrderFinance: TcxGridDBColumn;
    spUpdate_Juridical_OrderFinance: TdsdStoredProc;
    actUpdateJuridicalDS: TdsdUpdateDataSet;
    actShowAll: TBooleanStoredProcAction;
    spInsertUpdateMI_byReport: TdsdStoredProc;
    actUpdate_AmountByReport: TdsdExecStoredProc;
    bbUpdate_AmountByReport: TdxBarButton;
    cxLabel3: TcxLabel;
    edBankAccount: TcxButtonEdit;
    GuidesBankAccount: TdsdGuides;
    BankAccountName: TcxGridDBColumn;
    actBankAccountChoiceForm: TOpenChoiceForm;
    actShowAllJur: TBooleanStoredProcAction;
    bbShowAllJur: TdxBarButton;
    actShowErasedJur: TBooleanStoredProcAction;
    bbShowErasedJur: TdxBarButton;
    chBankAccountName: TcxGridDBColumn;
    chBankName: TcxGridDBColumn;
    actBankAccountChoiceFormJur: TOpenChoiceForm;
    spSelect_Export: TdsdStoredProc;
    spGet_Export_FileName: TdsdStoredProc;
    ExportDS: TDataSource;
    ExportCDS: TClientDataSet;
    actGet_Export_FileName: TdsdExecStoredProc;
    ExportXmlGrid: TcxGrid;
    ExportXmlGridDBTableView: TcxGridDBTableView;
    RowData: TcxGridDBColumn;
    ExportXmlGridLevel: TcxGridLevel;
    actSelect_Export: TdsdExecStoredProc;
    actExport_Grid: TExportGrid;
    actSMTPFile: TdsdSMTPFileAction;
    actExport: TMultiAction;
    bbExport: TdxBarButton;
    actBankAccountChoiceFormJurMain: TOpenChoiceForm;
    actExport_file: TdsdStoredProcExportToFile;
    actExport_New: TMultiAction;
    spErasedUnErased_JurOrdFin: TdsdStoredProc;
    actSetErasedJurOrdFin: TdsdUpdateErased;
    actSetUnErasedJurOrdFin: TdsdUpdateErased;
    bbSetErasedJurOrdFin: TdxBarButton;
    bbSetUnErasedJurOrdFin: TdxBarButton;
    InsertRecord_JurOrdFin: TInsertRecord;
    actContractChoiceForm_JurOrdFin: TOpenChoiceForm;
    bbInsertRecord_JurOrdFin: TdxBarButton;
    chComment: TcxGridDBColumn;
    ProtocolOpenFormJOF: TdsdOpenForm;
    bbProtocolOpenFormJOF: TdxBarButton;
    ExecuteDialogPeriod: TExecuteDialog;
    actInsert_byMovBankAccount: TdsdExecStoredProc;
    macInsert_byMovBankAccount: TMultiAction;
    spInsert_byMovBankAccount: TdsdStoredProc;
    bbInsert_byMovBankAccount: TdxBarButton;
    actRefreshOFJ: TdsdDataSetRefresh;
    spInsertMaskMIMaster2: TdsdStoredProc;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderFinanceMovementForm);

end.
