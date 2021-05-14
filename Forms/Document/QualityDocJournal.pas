unit QualityDocJournal;

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
  TQualityDocJournalForm = class(TAncestorJournalForm)
    TotalCountSh: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    CarModelName: TcxGridDBColumn;
    CarName: TcxGridDBColumn;
    InvNumber_Sale: TcxGridDBColumn;
    OperDate_Sale: TcxGridDBColumn;
    InvNumberPartner_Sale: TcxGridDBColumn;
    OperDatePartner_Sale: TcxGridDBColumn;
    TotalCountKg: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    OperDateIn: TcxGridDBColumn;
    OperDateOut: TcxGridDBColumn;
    InvNumber_Quality: TcxGridDBColumn;
    OperDate_Quality: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    spGetReportNameQuality: TdsdStoredProc;
    actPrint_Quality_ReportName: TdsdExecStoredProc;
    mactPrint_QualityDoc: TMultiAction;
    byPrinterCDS: TClientDataSet;
    byPrintDS: TDataSource;
    spSelect_byPrint: TdsdStoredProc;
    mactPrint_QualityDoc_list: TMultiAction;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    bbPrint_QualityDoc_list: TdxBarButton;
    spSelectPrint_list: TdsdStoredProc;
    actPrint_list: TdsdPrintAction;
    actPrint_Quality_ReportName_list: TdsdExecStoredProc;
    spGetReportNameQuality_list: TdsdStoredProc;
    MovementId_Sale_ch2: TcxGridDBColumn;
    mactPrint_QualityDoc_All: TMultiAction;
    actSelect_byPrint: TdsdExecStoredProc;
    actPrint_two: TdsdPrintAction;
    mactPrint_QualityDoc_two: TMultiAction;
    spSelectPrint_two: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TQualityDocJournalForm);
end.
