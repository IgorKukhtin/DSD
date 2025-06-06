unit PersonalService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, cxSplitter,
  ExternalLoad, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dsdInternetAction, Vcl.StdCtrls, dsdCommon;

type
  TPersonalServiceForm = class(TAncestorDocumentForm)
    INN: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    bbPrint_Bill: TdxBarButton;
    SummCard: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    edServiceDate: TcxDateEdit;
    cxLabel6: TcxLabel;
    edComment: TcxTextEdit;
    cxLabel12: TcxLabel;
    SummService: TcxGridDBColumn;
    SummMinus: TcxGridDBColumn;
    SummAdd: TcxGridDBColumn;
    edPersonalServiceList: TcxButtonEdit;
    GuidesPersonalServiceList: TdsdGuides;
    cxLabel3: TcxLabel;
    UnitCode: TcxGridDBColumn;
    PersonalCode: TcxGridDBColumn;
    IsMain: TcxGridDBColumn;
    IsOfficial: TcxGridDBColumn;
    AmountCash: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    SummCardRecalc: TcxGridDBColumn;
    SummSocialIn: TcxGridDBColumn;
    SummSocialAdd: TcxGridDBColumn;
    SummChild: TcxGridDBColumn;
    MemberName: TcxGridDBColumn;
    actMemberChoice: TOpenChoiceForm;
    AmountToPay: TcxGridDBColumn;
    spUpdateIsMain: TdsdStoredProc;
    actUpdateIsMain: TdsdExecStoredProc;
    bbUpdateIsMain: TdxBarButton;
    bbPersonalServiceList: TdxBarButton;
    mactUpdateMask: TMultiAction;
    actUpdateMask: TdsdExecStoredProc;
    spUpdateMask: TdsdStoredProc;
    actPersonalServiceJournalChoice: TOpenChoiceForm;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyName_all: TcxGridDBColumn;
    PersonalServiceListName: TcxGridDBColumn;
    actPersonalServiceListChoice: TOpenChoiceForm;
    SummTransport: TcxGridDBColumn;
    SummTransportAdd: TcxGridDBColumn;
    SummPhone: TcxGridDBColumn;
    SummTransportAddLong: TcxGridDBColumn;
    SummTransportTaxi: TcxGridDBColumn;
    ChildCDS: TClientDataSet;
    ChildDs: TDataSource;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxMemberName: TcxGridDBColumn;
    cxAmount: TcxGridDBColumn;
    cxMemberCount: TcxGridDBColumn;
    cxDayCount: TcxGridDBColumn;
    cxWorkTimeHoursOne: TcxGridDBColumn;
    cxWorkTimeHours: TcxGridDBColumn;
    cxPrice: TcxGridDBColumn;
    cxHoursPlan: TcxGridDBColumn;
    cxHoursDay: TcxGridDBColumn;
    cxPersonalCount: TcxGridDBColumn;
    cxGrossOne: TcxGridDBColumn;
    cxModelServiceName: TcxGridDBColumn;
    cxStaffListSummKindName: TcxGridDBColumn;
    cxisErased: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitterChild: TcxSplitter;
    DBViewAddOnChild: TdsdDBViewAddOn;
    spSelectChild: TdsdStoredProc;
    edIsAuto: TcxCheckBox;
    spGetImportSetting: TdsdStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actGetImportSetting: TdsdExecStoredProc;
    actLoadExcel: TMultiAction;
    bbLoadExcel: TdxBarButton;
    SummNalog: TcxGridDBColumn;
    SummNalogRecalc: TcxGridDBColumn;
    spUpdate_SetNULL: TdsdStoredProc;
    PersonalName_to: TcxGridDBColumn;
    PersonalCode_to: TcxGridDBColumn;
    clStorageLineName: TcxGridDBColumn;
    spUpdate_CardSecondCash: TdsdStoredProc;
    actUpdateCardSecondCash: TdsdExecStoredProc;
    bbUpdateCardSecondCash: TdxBarButton;
    macUpdateCardSecondCash: TMultiAction;
    CardSecond: TcxGridDBColumn;
    macUpdateCardSecond: TMultiAction;
    actUpdateCardSecond: TdsdExecStoredProc;
    spUpdate_CardSecond: TdsdStoredProc;
    bbUpdateCardSecond: TdxBarButton;
    spSelectMISign: TdsdStoredProc;
    SignCDS: TClientDataSet;
    SignDS: TDataSource;
    cxLabel21: TcxLabel;
    edstrSign: TcxTextEdit;
    cxLabel22: TcxLabel;
    edstrSignNo: TcxTextEdit;
    actInsertUpdateMISignYes: TdsdExecStoredProc;
    spInsertUpdateMISign_Yes: TdsdStoredProc;
    spInsertUpdateMISign_No: TdsdStoredProc;
    mactInsertUpdateMISignYes: TMultiAction;
    actInsertUpdateMISignNo: TdsdExecStoredProc;
    mactInsertUpdateMISignNo: TMultiAction;
    bbInsertUpdateMISignNo: TdxBarButton;
    bbInsertUpdateMISignYes: TdxBarButton;
    actRefresh_Sign: TdsdDataSetRefresh;
    spSelectPrint_All: TdsdStoredProc;
    actPrint_All: TdsdPrintAction;
    bbPrint_All: TdxBarButton;
    spUpdate_MI_PersonalService_SummNalogRet: TdsdStoredProc;
    actUpdateSummNalogRet: TdsdExecStoredProc;
    macUpdateNalogRetSimpl: TMultiAction;
    macUpdateSummNalogRet: TMultiAction;
    bbUpdateSummNalogRet: TdxBarButton;
    actRefreshMaster: TdsdDataSetRefresh;
    cxLabel5: TcxLabel;
    edMember: TcxButtonEdit;
    GuidesMember: TdsdGuides;
    MessageDCS: TClientDataSet;
    MessageDS: TDataSource;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    msUserName: TcxGridDBColumn;
    cxGridLevel3: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    spSelectMIMessage: TdsdStoredProc;
    spInsertUpdateMIMessage: TdsdStoredProc;
    actUpdateDataSetMessage: TdsdUpdateDataSet;
    actRefresh_Message: TdsdDataSetRefresh;
    msOrd: TcxGridDBColumn;
    msisQuestion: TcxGridDBColumn;
    msisAnswer: TcxGridDBColumn;
    msisQuestionRead: TcxGridDBColumn;
    msisAnswerRead: TcxGridDBColumn;
    actUserChoice: TOpenChoiceForm;
    spSelectPrintDetail: TdsdStoredProc;
    actPrint_Detail: TdsdPrintAction;
    bbPrint_Child: TdxBarButton;
    SummCardSecondDiff: TcxGridDBColumn;
    SummFineOth: TcxGridDBColumn;
    SummHospOth: TcxGridDBColumn;
    spUpdate_Compensation: TdsdStoredProc;
    actUpdate_Compensation: TdsdExecStoredProc;
    macUpdate_Compensation: TMultiAction;
    bbUpdate_Compensation: TdxBarButton;
    DayCompensation: TcxGridDBColumn;
    PriceCompensation: TcxGridDBColumn;
    ExportXmlGrid: TcxGrid;
    ExportXmlGridDBTableView: TcxGridDBTableView;
    RowData: TcxGridDBColumn;
    ExportXmlGridLevel: TcxGridLevel;
    ExportDS: TDataSource;
    ExportCDS: TClientDataSet;
    spGet_Export_FileName1: TdsdStoredProc;
    spSelect_Export: TdsdStoredProc;
    actSelect_Export: TdsdExecStoredProc;
    actExport_Grid: TExportGrid;
    actSMTPFile: TdsdSMTPFileAction;
    actExport: TMultiAction;
    actGet_Export_FileNameOld: TdsdExecStoredProc;
    bbExport: TdxBarButton;
    spSelectExport: TdsdStoredProc;
    actExportToFileZp: TdsdStoredProcExportToFile;
    spGet_Export_FileNameZP: TdsdStoredProc;
    actGet_Export_FileNameZp: TdsdExecStoredProc;
    actExportZP: TMultiAction;
    bbExportZP: TdxBarButton;
    actExport_file: TdsdStoredProcExportToFile;
    spGet_Export_FileName: TdsdStoredProc;
    actGet_Export_FileName: TdsdExecStoredProc;
    spInsertUpdate_byMemberMinus: TdsdStoredProc;
    actInsertUpdate_byMemberMinus: TdsdExecStoredProc;
    macInsertUpdate_byMemberMinus: TMultiAction;
    bbmacInsertUpdate_byMemberMinus: TdxBarButton;
    edBankOutDate: TcxDateEdit;
    cxLabel7: TcxLabel;
    actExportZPDate: TMultiAction;
    spSelectExportDate: TdsdStoredProc;
    actExportToFileZpDate: TdsdStoredProcExportToFile;
    bbExportZPDate: TdxBarButton;
    cbDetail: TcxCheckBox;
    FineSubjectName: TcxGridDBColumn;
    actFineSubjectOpenChoiceForm: TOpenChoiceForm;
    actUnitFineSubjectChoiceForm: TOpenChoiceForm;
    cxTabSheet1: TcxTabSheet;
    cxGridChild_all: TcxGrid;
    cxGridDBTableViewChild_all: TcxGridDBTableView;
    cxGridLevelChild_all: TcxGridLevel;
    DBViewAddOnChild_all: TdsdDBViewAddOn;
    spSelectChild_all: TdsdStoredProc;
    ChildCDS_all: TClientDataSet;
    ChildDS_all: TDataSource;
    actGridToExcel_Child_all: TdsdGridToExcel;
    bbGridToExcel_Child_all: TdxBarButton;
    cxRate: TcxGridDBColumn;
    cxKoeff: TcxGridDBColumn;
    ExportEmailCDS: TClientDataSet;
    ExportEmailDS: TDataSource;
    bbExportCSV: TdxBarButton;
    spGet_Export_EmailCSV: TdsdStoredProc;
    actGet_Export_EmailCSV: TdsdExecStoredProc;
    spGet_Export_FileNameCSV: TdsdStoredProc;
    actGet_Export_FileNameCSV: TdsdExecStoredProc;
    spSelect_ExportCSV: TdsdStoredProc;
    actSelect_ExportCSV: TdsdExecStoredProc;
    actExport_GridCSV: TExportGrid;
    actSMTPFileCSV: TdsdSMTPFileAction;
    mactExportCSV: TMultiAction;
    cbMail: TcxCheckBox;
    actRefreshGet: TdsdDataSetRefresh;
    spGetImportSetting_mm: TdsdStoredProc;
    actDoLoad_mm: TExecuteImportSettingsAction;
    actGetImportSetting_mm: TdsdExecStoredProc;
    macStartLoad_mm: TMultiAction;
    bbStartLoad_mm: TdxBarButton;
    spInsertUpdate_MemberMinus: TdsdStoredProc;
    actInsertUpdate_MemberMinus: TdsdExecStoredProc;
    macInsertUpdate_MemberMinus: TMultiAction;
    bbInsertUpdate_MemberMinus: TdxBarButton;
    StaffListSummKindName: TcxGridDBColumn;
    spGetImportSetting_SMER: TdsdStoredProc;
    actDoLoad_SMER: TExecuteImportSettingsAction;
    actGetImportSetting_SMER: TdsdExecStoredProc;
    macStartLoad_SMER: TMultiAction;
    bbStartLoad_SMER: TdxBarButton;
    Code1C: TcxGridDBColumn;
    cxLabel8: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
    actOpenProtocolMember: TdsdOpenForm;
    actOpenProtocolPersonal: TdsdOpenForm;
    bbOpenProtocolMember: TdxBarButton;
    bbOpenProtocolPersonal: TdxBarButton;
    spGetImportSettingSummService: TdsdStoredProc;
    actGetImportSettingSS: TdsdExecStoredProc;
    macStartLoad_SS: TMultiAction;
    bbStartLoad_SS: TdxBarButton;
    actDoLoad_SS: TExecuteImportSettingsAction;
    bbLoad: TdxBarSubItem;
    spGetImportSettingAvance: TdsdStoredProc;
    actGetImportSettingAvance: TdsdExecStoredProc;
    actDoLoad_Avance: TExecuteImportSettingsAction;
    macLoad_Avance: TMultiAction;
    bbLoad_Avance: TdxBarButton;
    Amount_avance_ps: TcxGridDBColumn;
    spSelectExport_dbf: TdsdStoredProc;
    actGet_Export_FileNameZp_dbf: TdsdExecStoredProc;
    actExport_dbf: TdsdStoredProcExportToFile;
    macExport_dbf: TMultiAction;
    spGet_Export_FileNameZP_dbf: TdsdStoredProc;
    bbExport_dbf: TdxBarButton;
    bbSubPrint: TdxBarSubItem;
    bbInsertData: TdxBarSubItem;
    bbExportSub: TdxBarSubItem;
    actOpenReportRecalcForm: TdsdOpenForm;
    bbOpenReportRecalcForm: TdxBarButton;
    spInsertUpdate_Avance: TdsdStoredProc;
    ExecuteDialogPeriod: TExecuteDialog;
    actInsertUpdate_Avance: TdsdExecStoredProc;
    macInsertUpdate_AvanceAuto: TMultiAction;
    bbnsertUpdate_AvanceAuto: TdxBarButton;
    spGetImportSettingComp: TdsdStoredProc;
    actGetImportSettingCompens: TdsdExecStoredProc;
    actDoLoad_Compens: TExecuteImportSettingsAction;
    macLoad_Compens: TMultiAction;
    bbLoad_Compens: TdxBarButton;
    AmountCash_rem: TcxGridDBColumn;
    AmountCash_pay: TcxGridDBColumn;
    spGetImportSetting_fine: TdsdStoredProc;
    actDoLoad_fine: TExecuteImportSettingsAction;
    actGetImportSetting_fine: TdsdExecStoredProc;
    macStartLoad: TMultiAction;
    macStartLoad_fine: TMultiAction;
    bbStartLoad_fine: TdxBarButton;
    spUpdate_PriceNalog: TdsdStoredProc;
    actPriceNalogDialog: TExecuteDialog;
    edPriceNalog: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    macUpdate_PriceNalog: TMultiAction;
    actUpdate_PriceNalog: TdsdExecStoredProc;
    bbUpdate_PriceNalog: TdxBarButton;
    actGridToExcel_Child: TdsdGridToExcel;
    bbGridToExcel_Child: TdxBarButton;
    spSelect_ExportCSVF2: TdsdStoredProc;
    spGet_Export_FileNameCSVF2: TdsdStoredProc;
    spGet_Export_EmailCSVF2: TdsdStoredProc;
    mactExportCSVF2: TMultiAction;
    actGet_Export_EmailCSVF2: TdsdExecStoredProc;
    actGet_Export_FileNameCSVF2: TdsdExecStoredProc;
    actSelect_ExportCSVF2: TdsdExecStoredProc;
    bbExportCSVF2: TdxBarButton;
    bbSeparator: TdxBarSeparator;
    spGet_Export_EmailF2_xls: TdsdStoredProc;
    spSelect_ExportF2_xls: TdsdStoredProc;
    spGet_Export_FileNameF2_xls: TdsdStoredProc;
    mactExportF2_xls: TMultiAction;
    actGet_Export_EmailF2_xls: TdsdExecStoredProc;
    actGet_Export_FileNameF2_xls: TdsdExecStoredProc;
    actSelect_ExportF2_xls: TdsdExecStoredProc;
    bbExportCSVF2_xls: TdxBarButton;
    actExport_GridF2_xls: TExportGrid;
    spUpdate_CardSecond4000: TdsdStoredProc;
    macUpdateCardSecond4000: TMultiAction;
    actUpdateCardSecond4000: TdsdExecStoredProc;
    bbUpdateCardSecond4000: TdxBarButton;
    SummCardSecondRecalc_00807: TcxGridDBColumn;
    SummCardSecondRecalc_005: TcxGridDBColumn;
    macUpdateCardSecond_num: TMultiAction;
    actUpdateCardSecond_num: TdsdExecStoredProc;
    spUpdate_CardSecond_num_yes4000: TdsdStoredProc;
    bbUpdateCardSecond_num: TdxBarButton;
    actOpenBankSecondNumForm: TdsdOpenForm;
    cxLabel30: TcxLabel;
    edBankSecondNum: TcxButtonEdit;
    GuidesBankSecondNum: TdsdGuides;
    bbOpenBankSecondNumForm: TdxBarButton;
    mactExportF2_Prior_xls: TMultiAction;
    spGet_Export_EmailF2_prior_xls: TdsdStoredProc;
    spGet_Export_FileNameF2_prior_xls: TdsdStoredProc;
    spSelect_ExportF2_prior_xls: TdsdStoredProc;
    actGet_Export_EmailF2_prior_xls: TdsdExecStoredProc;
    actGet_Export_FileNameF2_prior_xls: TdsdExecStoredProc;
    actSelect_ExportF2_prior_xls: TdsdExecStoredProc;
    bbExportF2_Prior_xls: TdxBarButton;
    ExportXmlGrid_num: TcxGrid;
    cxGridDBTableView_num: TcxGridDBTableView;
    cxGridLevel4: TcxGridLevel;
    ExportCDS_num: TClientDataSet;
    ExportDS_num: TDataSource;
    expBankSecond_num: TcxGridDBColumn;
    actExport_GridF2_prior_xls: TExportGrid;
    expINN: TcxGridDBColumn;
    expCardBankSecond: TcxGridDBColumn;
    expBankSecondName: TcxGridDBColumn;
    expPersonalName: TcxGridDBColumn;
    Panel1: TPanel;
    actReport_Open: TdsdOpenForm;
    bbReport_Open: TdxBarButton;
    spSelectPrint_Num: TdsdStoredProc;
    actPrint_Num: TdsdPrintAction;
    bbPrint_Num: TdxBarButton;
    expFIO: TcxGridDBColumn;
    expName: TcxGridDBColumn;
    expName_two: TcxGridDBColumn;
    expPhone: TcxGridDBColumn;
    expCardIBANSecond: TcxGridDBColumn;
    expCardSecond: TcxGridDBColumn;
    spUpdate_isMail: TdsdStoredProc;
    actUpdate_isMail: TdsdExecStoredProc;
    actPrint_Grid: TdsdPrintAction;
    bbPrint_Grid: TdxBarButton;
    Amount_avance_ret: TcxGridDBColumn;
    AmountCash_print: TcxGridDBColumn;
    SummNalog_print: TcxGridDBColumn;
    spDelete_Object_Print: TdsdStoredProc;
    spInsertPrint_byGrid: TdsdStoredProc;
    actDelete_Object_Print: TdsdExecStoredProc;
    actPrint_byGrid: TdsdExecStoredProc;
    actPrint_byGrid_list: TMultiAction;
    macPrint_grid_new: TMultiAction;
    spSelectPrint_grid: TdsdStoredProc;
    bbPrintGridNew: TdxBarButton;
    actPrint_Grid_new: TdsdPrintAction;
    MI_ChildProtocolOpenForm: TdsdOpenForm;
    bbMI_ChildProtocolOpenForm: TdxBarButton;
    actUpdate_CardSecond_num_not4000: TdsdExecStoredProc;
    mactUpdateCardSecond_num_not4000: TMultiAction;
    spUpdate_CardSecond_num_not4000: TdsdStoredProc;
    bbUpdateCardSecond_num_not4000: TdxBarButton;
    AmountService_diff_start: TcxGridDBColumn;
    AmountService_diff_end: TcxGridDBColumn;
    Amount_LossPersonal: TcxGridDBColumn;
    InsertRecordPersonal: TInsertRecord;
    actOpenChoiceFormPersonal: TOpenChoiceForm;
    bbInsertRecordPersonal: TdxBarButton;
    spInsertMaskMIMaster_Personal: TdsdStoredProc;
    actAddMask_Personal: TdsdExecStoredProc;
    bb: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPersonalServiceForm);

end.
