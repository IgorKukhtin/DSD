unit PersonalServiceJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit,
  cxButtonEdit, dsdGuides, frxClass, frxDBSet, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  dsdInternetAction, Vcl.StdCtrls, dsdCommon;

type
  TPersonalServiceJournalForm = class(TAncestorJournalForm)
    ServiceDate: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    bbTax: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrintTax_Us: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    TotalSummService: TcxGridDBColumn;
    TotalSummCard: TcxGridDBColumn;
    TotalSummMinus: TcxGridDBColumn;
    TotalSummAdd: TcxGridDBColumn;
    PersonalServiceListName: TcxGridDBColumn;
    TotalSummCash: TcxGridDBColumn;
    TotalSummCardRecalc: TcxGridDBColumn;
    TotalSummSocialIn: TcxGridDBColumn;
    TotalSummSocialAdd: TcxGridDBColumn;
    TotalSummChild: TcxGridDBColumn;
    TotalSummToPay: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    cbIsServiceDate: TcxCheckBox;
    actIsServiceDate: TdsdDataSetRefresh;
    TotalSummTransportAdd: TcxGridDBColumn;
    TotalSummTransport: TcxGridDBColumn;
    TotalSummPhone: TcxGridDBColumn;
    TotalSummTransportAddLong: TcxGridDBColumn;
    TotalSummTransportTaxi: TcxGridDBColumn;
    spSelectExport: TdsdStoredProc;
    ExportCDS: TClientDataSet;
    actExportTXTVostok: TMultiAction;
    actExportTXTVostokSelect: TdsdExecStoredProc;
    FileDialogAction1: TFileDialogAction;
    ExportGrid1: TExportGrid;
    bbExportZp: TdxBarButton;
    actExportToFileZp: TdsdStoredProcExportToFile;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    macExportZP: TMultiAction;
    actGet_Export_FileNameZp: TdsdExecStoredProc;
    spGet_Export_FileNameZP: TdsdStoredProc;
    TotalSummNalog: TcxGridDBColumn;
    TotalSummNalogRecalc: TcxGridDBColumn;
    spSelectPrint_All: TdsdStoredProc;
    actPrint_All: TdsdPrintAction;
    bbPrint_All: TdxBarButton;
    spInsertUpdateMISign_Yes: TdsdStoredProc;
    spInsertUpdateMISign_No: TdsdStoredProc;
    actInsertUpdateMISignYes: TdsdExecStoredProc;
    mactInsertUpdateMISignYes: TMultiAction;
    mactInsertUpdateMISignYesList: TMultiAction;
    actInsertUpdateMISignNo: TdsdExecStoredProc;
    mactInsertUpdateMISignNo: TMultiAction;
    mactInsertUpdateMISignNoList: TMultiAction;
    bbInsertUpdateMISignYesList: TdxBarButton;
    bbInsertUpdateMISignNoList: TdxBarButton;
    MemberName: TcxGridDBColumn;
    spSelectPrint_Detail: TdsdStoredProc;
    actPrint_Detail: TdsdPrintAction;
    bbPrint_Detail: TdxBarButton;
    TotalSummFineOth: TcxGridDBColumn;
    TotalSummHospOth: TcxGridDBColumn;
    spGet_Export_FileName: TdsdStoredProc;
    spSelect_Export: TdsdStoredProc;
    actGet_Export_FileName: TdsdExecStoredProc;
    actSMTPFile: TdsdSMTPFileAction;
    actExport_Grid: TExportGrid;
    actExport: TMultiAction;
    bbExport: TdxBarButton;
    actExport_file: TdsdStoredProcExportToFile;
    isMail: TcxGridDBColumn;
    actExport_GridCSV: TExportGrid;
    ExportXmlGrid: TcxGrid;
    ExportXmlGridDBTableView: TcxGridDBTableView;
    RowData: TcxGridDBColumn;
    ExportXmlGridLevel: TcxGridLevel;
    ExportDS: TDataSource;
    ExportEmailDS: TDataSource;
    ExportEmailCDS: TClientDataSet;
    spGet_Export_EmailCSV: TdsdStoredProc;
    spGet_Export_FileNameCSV: TdsdStoredProc;
    actSMTPFileCSV: TdsdSMTPFileAction;
    actGet_Export_FileNameCSV: TdsdExecStoredProc;
    actGet_Export_EmailCSV: TdsdExecStoredProc;
    actSelect_ExportCSV: TdsdExecStoredProc;
    spSelect_ExportCSV: TdsdStoredProc;
    mactExportCSV: TMultiAction;
    bbExportCSV: TdxBarButton;
    actOpenFormPersonalServiceDetail: TdsdOpenForm;
    bbOpenFormPersonalServiceDetail: TdxBarButton;
    macExport_dbf: TMultiAction;
    actExport_dbf: TdsdStoredProcExportToFile;
    bbExport_dbf: TdxBarButton;
    actGet_Export_FileNameZp_dbf: TdsdExecStoredProc;
    spSelectExport_dbf: TdsdStoredProc;
    spGet_Export_FileNameZP_dbf: TdsdStoredProc;
    mactExportCSV_F2: TMultiAction;
    spGet_Export_EmailCSVF2: TdsdStoredProc;
    actGet_Export_EmailCSVF2: TdsdExecStoredProc;
    actGet_Export_FileNameCSVF2: TdsdExecStoredProc;
    spGet_Export_FileNameCSVF2: TdsdStoredProc;
    spSelect_ExportCSVF2: TdsdStoredProc;
    actSelect_ExportCSVF2: TdsdExecStoredProc;
    bbExportCSV_F2: TdxBarButton;
    bbsPrint: TdxBarSubItem;
    bbsSend: TdxBarSubItem;
    bbSeparator1: TdxBarSeparator;
    spGet_Export_EmailF2_xls: TdsdStoredProc;
    spSelect_ExportF2_xls: TdsdStoredProc;
    spGet_Export_FileNameF2_xls: TdsdStoredProc;
    actSelect_ExportF2_xls: TdsdExecStoredProc;
    actExport_GridF2_xls: TExportGrid;
    actGet_Export_FileNameF2_xls: TdsdExecStoredProc;
    actGet_Export_EmailF2_xls: TdsdExecStoredProc;
    mactExportF2_xls: TMultiAction;
    bbtExportF2_xls: TdxBarButton;
    is4000: TcxGridDBColumn;
    InvNumber_BankSecondNum: TcxGridDBColumn;
    spGet_Export_EmailF2_prior_xls: TdsdStoredProc;
    spSelect_ExportF2_prior_xls: TdsdStoredProc;
    spGet_Export_FileNameF2_prior_xls: TdsdStoredProc;
    mactExportF2_prior_xls: TMultiAction;
    actGet_Export_EmailF2_prior_xls: TdsdExecStoredProc;
    actGet_Export_FileNameF2_prior_xls: TdsdExecStoredProc;
    actSelect_ExportF2_prior_xls: TdsdExecStoredProc;
    bbExportF2_prior_xls: TdxBarButton;
    Panel1: TPanel;
    ExportXmlGrid_num: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    ExportCDS_num: TClientDataSet;
    ExportDS_num: TDataSource;
    actExport_GridF2_proir_xls: TExportGrid;
    spSelectPrint_Num: TdsdStoredProc;
    actPrint_Num: TdsdPrintAction;
    bbPrint_Num: TdxBarButton;

    expFIO: TcxGridDBColumn;
    expName: TcxGridDBColumn;
    expName_two: TcxGridDBColumn;
    expINN: TcxGridDBColumn;
    expPhone: TcxGridDBColumn;
    expCardIBANSecond: TcxGridDBColumn;
    expCardSecond: TcxGridDBColumn;
    expBankSecond_num: TcxGridDBColumn;
    expPersonalName: TcxGridDBColumn;
    expBankSecondName: TcxGridDBColumn;
    expCardBankSecond: TcxGridDBColumn;
    spUpdate_isMail: TdsdStoredProc;
    actUpdate_isMail: TdsdExecStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TPersonalServiceJournalForm);
end.
