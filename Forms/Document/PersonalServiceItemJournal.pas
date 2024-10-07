unit PersonalServiceItemJournal;

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
  dsdInternetAction, dsdCommon;

type
  TPersonalServiceItemJournalForm = class(TAncestorJournalForm)
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
    PersonalServiceListName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    cbIsServiceDate: TcxCheckBox;
    actIsServiceDate: TdsdDataSetRefresh;
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
    actExportZP: TMultiAction;
    actGet_Export_FileNameZp: TdsdExecStoredProc;
    spGet_Export_FileNameZP: TdsdStoredProc;
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
    ContainerId_max: TcxGridDBColumn;
    ContainerId_min: TcxGridDBColumn;
    bbsExport: TdxBarSubItem;
    bbSeparate: TdxBarSeparator;
    spUpdate_isMail: TdsdStoredProc;
    actUpdate_isMail: TdsdExecStoredProc;
    cxLabel30: TcxLabel;
    edInvNumberPersonalServiceList: TcxButtonEdit;
    GuidesPersonalServiceList: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TPersonalServiceItemJournalForm);
end.
