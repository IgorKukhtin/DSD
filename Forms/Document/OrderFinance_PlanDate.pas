unit OrderFinance_PlanDate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon,
  cxImageComboBox, cxCheckBox, dsdInternetAction;

type
  TOrderFinance_PlanDateForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    GuidesWeek_Date1: TdsdGuides;
    edWeekNumber1: TcxButtonEdit;
    edWeekNumber2: TcxButtonEdit;
    actBankChoiceForm: TOpenChoiceForm;
    BankName_jof: TcxGridDBColumn;
    actBankAccountChoicetForm: TOpenChoiceForm;
    spUpdate_PlanDate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    spGet_WeekNumber_byPeriod: TdsdStoredProc;
    actGet_Period_byWeekNumber: TdsdDataSetRefresh;
    actGet_WeekNumber_byPeriod: TdsdDataSetRefresh;
    spGet_CurrentWeekDay: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    spSelect_Export: TdsdStoredProc;
    mactExport_New_OTP: TMultiAction;
    ExportXmlGrid: TcxGrid;
    ExportXmlGridDBTableView: TcxGridDBTableView;
    RowData: TcxGridDBColumn;
    ExportXmlGridLevel: TcxGridLevel;
    actExport_Grid: TExportGrid;
    FormParams: TdsdFormParams;
    ExportCDS: TClientDataSet;
    ExportDS: TDataSource;
    actSMTPFile: TdsdSMTPFileAction;
    spGet_Export_FileName: TdsdStoredProc;
    actGet_Export_FileName: TdsdExecStoredProc;
    actExport_file: TdsdStoredProcExportToFile;
    bbExport_New_OTP: TdxBarButton;
    spGet_Period: TdsdStoredProc;
    cxLabel12: TcxLabel;
    GuidesBankMain: TdsdGuides;
    edBankMain: TcxButtonEdit;
    bbBank: TdxBarControlContainerItem;
    bbText: TdxBarControlContainerItem;
    actBankChoiceFormMain: TOpenChoiceForm;
    actBankAccountChoicetFormMain: TOpenChoiceForm;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrintPlan: TdsdPrintAction;
    bbPrintPlan: TdxBarButton;
    Number_day: TcxGridDBColumn;
    dxBarSubItem1: TdxBarSubItem;
    edNPP: TcxCurrencyEdit;
    mactExport_New_OTP_NPP: TMultiAction;
    spGet_Export_FileNameNPP: TdsdStoredProc;
    actGet_Export_FileNameNPP: TdsdExecStoredProc;
    spSelect_ExportNPP: TdsdStoredProc;
    actExport_fileNPP: TdsdStoredProcExportToFile;
    dxBarButton1: TdxBarButton;
    DateDay: TcxGridDBColumn;
    WeekDay: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TOrderFinance_PlanDateForm);

end.
