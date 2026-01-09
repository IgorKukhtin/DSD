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
  cxImageComboBox, dsdInternetAction, dsdCommon, ChoicePeriod, cxBlobEdit;

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
    AmountSumm: TcxGridDBColumn;
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
    actExport_Grid_file: TExportGrid;
    actSMTPFile_file: TdsdSMTPFileAction;
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
    chComment_pay: TcxGridDBColumn;
    ProtocolOpenFormJOF: TdsdOpenForm;
    bbProtocolOpenFormJOF: TdxBarButton;
    ExecuteDialogPeriod: TExecuteDialog;
    actInsert_byMovBankAccount: TdsdExecStoredProc;
    macInsert_byMovBankAccount: TMultiAction;
    spInsert_byMovBankAccount: TdsdStoredProc;
    bbInsert_byMovBankAccount: TdxBarButton;
    actRefreshOFJ: TdsdDataSetRefresh;
    spInsertMaskMIMaster2: TdsdStoredProc;
    Condition: TcxGridDBColumn;
    GuidesInsert: TdsdGuides;
    edInsertUser: TcxButtonEdit;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    edUpdateUser: TcxButtonEdit;
    GuidesUpdate: TdsdGuides;
    GuidesUnit: TdsdGuides;
    cxLabel7: TcxLabel;
    ceUnit: TcxButtonEdit;
    cxLabel8: TcxLabel;
    cePosition: TcxButtonEdit;
    GuidesPosition: TdsdGuides;
    cxLabel9: TcxLabel;
    edWeekNumber: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    ceMember_1: TcxButtonEdit;
    GuidesMember1: TdsdGuides;
    GuidesMember2: TdsdGuides;
    ceMember_2: TcxButtonEdit;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    edInsertDate: TcxDateEdit;
    cxLabel14: TcxLabel;
    edUpdatetDate: TcxDateEdit;
    edUpdatetDate_report: TcxDateEdit;
    cxLabel15: TcxLabel;
    edUserUpdate_report: TcxButtonEdit;
    cxLabel17: TcxLabel;
    Guides_Update_report: TdsdGuides;
    spGet_Export_Email_xls: TdsdStoredProc;
    actGet_Export_Email_xls: TdsdExecStoredProc;
    actGet_Export_FileNamexls: TdsdExecStoredProc;
    spSelectOrderFinance_XLS: TdsdStoredProc;
    actSelect_Export_xls: TdsdExecStoredProc;
    mactExport_xls: TMultiAction;
    actExport_Grid_xls1: TExportGrid;
    dxBarButton1: TdxBarButton;
    bbOut: TdxBarSubItem;
    ExportEmailCDS: TClientDataSet;
    ExportEmailDS: TDataSource;
    actSMTPFile_xls: TdsdSMTPFileAction;
    spGetFileName_xls: TdsdStoredProc;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxLabel18: TcxLabel;
    cxLabel19: TcxLabel;
    PeriodChoice: TPeriodChoice;
    edTotalSumm_1: TcxCurrencyEdit;
    AmountPlan_total: TcxGridDBColumn;
    mactExportMail_xls_1: TMultiAction;
    mactExportMail_xls_2: TMultiAction;
    mactExportMail_xls_3: TMultiAction;
    mactExportMail_xls_4: TMultiAction;
    mactExportMail_xls_5: TMultiAction;
    dxBarSeparator: TdxBarSeparator;
    bbExportMail_xls_1: TdxBarButton;
    bbExportMail_xls_2: TdxBarButton;
    bbExportMail_xls_3: TdxBarButton;
    bbExportMail_xls_4: TdxBarButton;
    bbExportMail_xls_5: TdxBarButton;
    edTotalSumm_2: TcxCurrencyEdit;
    edTotalSumm_3: TcxCurrencyEdit;
    cxLabel23: TcxLabel;
    edOKPO_search: TcxTextEdit;
    cxLabel24: TcxLabel;
    edJuridicalName_search: TcxTextEdit;
    FieldFilter: TdsdFieldFilter;
    actChoiceGuides: TdsdChoiceGuides;
    spUpdate_SignWait_1_Yes: TdsdStoredProc;
    actUpdate_SignWait_1_Yes: TdsdExecStoredProc;
    actRefreshGet: TdsdDataSetRefresh;
    ceDateSignWait_1: TcxDateEdit;
    ceDateSign_1: TcxDateEdit;
    cbSignWait_1: TcxCheckBox;
    cbSign_1: TcxCheckBox;
    spUpdate_Sign_1_Yes: TdsdStoredProc;
    actUpdate_Sign_1_Yes: TdsdExecStoredProc;
    bbUpdate_Sign_1_Yes: TdxBarButton;
    edTotalText_1: TcxTextEdit;
    edTotalText_2: TcxTextEdit;
    edTotalText_3: TcxTextEdit;
    spUpdate_SignWait_1_No: TdsdStoredProc;
    spUpdate_Sign_1_No: TdsdStoredProc;
    actUpdate_Sign_1_No: TdsdExecStoredProc;
    actUpdate_SignWait_1_No: TdsdExecStoredProc;
    bbUpdate_Sign_1_No: TdxBarButton;
    bbSign: TdxBarSubItem;
    bbUpdate_SignWait_1_Yes: TdxBarButton;
    bbUpdate_SignWait_1_No: TdxBarButton;
    dxBarSeparator1: TdxBarSeparator;
    NumGroup: TcxGridDBColumn;
    chNumGroup: TcxGridDBColumn;
    Color_Group: TcxGridDBColumn;
    actBankChoiceForm_JurMain: TOpenChoiceForm;
    actBankChoiceForm_Jur: TOpenChoiceForm;
    mactExport_group: TMultiAction;
    actGet_Export_FileName_gr: TdsdExecStoredProc;
    actGet_Export_Email_gr: TdsdExecStoredProc;
    actSelect_Export_gr: TdsdExecStoredProc;
    spGet_Export_Email_gr: TdsdStoredProc;
    spGetFileName_gr: TdsdStoredProc;
    dsdDBViewAddOn_Export: TdsdDBViewAddOn;
    bbmactExport_group: TdxBarButton;
    actExport_Grid_groupCSV: TExportGrid;
    actSMTPFile: TdsdSMTPFileAction;
    spGet_Export_Email: TdsdStoredProc;
    actGet_Export_Email: TdsdExecStoredProc;
    actExport_Grid: TExportGrid;
    spGet_Export_FileName_xls: TdsdStoredProc;
    actGet_Export_FileName_xls: TdsdExecStoredProc;
    spGetReportName: TdsdStoredProc;
    actExport_fr3: TdsdPrintAction;
    mactExport_fr3: TMultiAction;
    bbtExport_fr3: TdxBarButton;
    mactExportGroup_fr3: TMultiAction;
    spGet_Export_EmailGroup: TdsdStoredProc;
    actGet_Export_EmailGroup: TdsdExecStoredProc;
    actPrint_xls: TdsdPrintAction;
    bbPrint_xls: TdxBarButton;
    bbsPrint: TdxBarSubItem;
    InfoMoneyCode: TcxGridDBColumn;
    PersonalName_contract: TcxGridDBColumn;
    cxLabel20: TcxLabel;
    edOperDate_Amount: TcxDateEdit;
    OperDate_Amount: TcxGridDBColumn;
    OperDate_Amount_old: TcxGridDBColumn;
    Amount_old: TcxGridDBColumn;
    AmountPlan_1_old: TcxGridDBColumn;
    AmountPlan_2_old: TcxGridDBColumn;
    AmountPlan_3_old: TcxGridDBColumn;
    AmountPlan_4_old: TcxGridDBColumn;
    AmountPlan_5_old: TcxGridDBColumn;
    AmountReal_1_old: TcxGridDBColumn;
    AmountReal_2_old: TcxGridDBColumn;
    AmountReal_3_old: TcxGridDBColumn;
    AmountReal_4_old: TcxGridDBColumn;
    AmountReal_5_old: TcxGridDBColumn;
    AmountPlan_total_old: TcxGridDBColumn;
    AmountReal_total_old: TcxGridDBColumn;
    isPlan_1_old: TcxGridDBColumn;
    isPlan_2_old: TcxGridDBColumn;
    isPlan_3_old: TcxGridDBColumn;
    isPlan_4_old: TcxGridDBColumn;
    isPlan_5_old: TcxGridDBColumn;
  private
  public
  end;

implementation
{$R *.dfm}

initialization
  RegisterClass(TOrderFinanceMovementForm);
end.
