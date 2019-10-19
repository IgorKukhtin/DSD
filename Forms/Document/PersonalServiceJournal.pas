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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

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
    bbExport: TdxBarButton;
    actExportToFile: TdsdStoredProcExportToFile;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    actExport: TMultiAction;
    actGet_Export_FileName: TdsdExecStoredProc;
    spGet_Export_FileName: TdsdStoredProc;
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
