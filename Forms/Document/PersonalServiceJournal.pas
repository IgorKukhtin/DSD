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
    colServiceDate: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
    colTotalSumm: TcxGridDBColumn;
    bbTax: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrintTax_Us: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    colTotalSummService: TcxGridDBColumn;
    colTotalSummCard: TcxGridDBColumn;
    colTotalSummMinus: TcxGridDBColumn;
    colTotalSummAdd: TcxGridDBColumn;
    colPersonalServiceListName: TcxGridDBColumn;
    colTotalSummCash: TcxGridDBColumn;
    colTotalSummCardRecalc: TcxGridDBColumn;
    colTotalSummSocialIn: TcxGridDBColumn;
    colTotalSummSocialAdd: TcxGridDBColumn;
    colTotalSummChild: TcxGridDBColumn;
    colTotalSummToPay: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
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
