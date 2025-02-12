unit ReestrIncomeUpdateMovement;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit,
  cxButtonEdit, dsdGuides, frxClass, frxDBSet, EDI, dsdInternetAction,
  cxSplitter, dsdCommon;

type
  TReestrIncomeUpdateMovementForm = class(TAncestorJournalForm)
    OperDatePartner: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    InvNumberPartner: TcxGridDBColumn;
    Date_Insert: TcxGridDBColumn;
    N13: TMenuItem;
    miInvoice: TMenuItem;
    miOrdSpr: TMenuItem;
    miDesadv: TMenuItem;
    ExecuteDialog: TExecuteDialog;
    cxLabel27: TcxLabel;
    edReestrKind: TcxButtonEdit;
    ReestrKindGuides: TdsdGuides;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    ClientDataSet: TClientDataSet;
    DataSource: TDataSource;
    actUpdateDataSource: TdsdUpdateDataSet;
    MovementItemProtocolOpenForm: TdsdOpenForm;
    cxSplitter1: TcxSplitter;
    spSelectBarCode: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    bbErased: TdxBarButton;
    spGet_Period: TdsdStoredProc;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    macMISetErased: TMultiAction;
    actExternalDialog: TExecuteDialog;
    bbExternalDialog: TdxBarButton;
    actPrintPeriod: TdsdPrintAction;
    spSelectPrintPeriod: TdsdStoredProc;
    bbPrintPeriod: TdxBarButton;
    actDialog_Print: TExecuteDialog;
    macPrintPeriod: TMultiAction;
    edIsShowAll: TcxCheckBox;
    spSelectPrintGroup: TdsdStoredProc;
    cxLabel18: TcxLabel;
    cePersonal: TcxButtonEdit;
    GuidesPersonal: TdsdGuides;
    cxLabel19: TcxLabel;
    cePersonalTrade: TcxButtonEdit;
    GuidesPersonalTrade: TdsdGuides;
    actPrintGroup: TdsdPrintAction;
    actPrintPeriodGroup: TdsdPrintAction;
    spSelectPrintPeriodGroup: TdsdStoredProc;
    macPrintPeriodGroup: TMultiAction;
    bbPrintGroup: TdxBarButton;
    bbPrintPeriodGroup: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReestrIncomeUpdateMovementForm: TReestrIncomeUpdateMovementForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReestrIncomeUpdateMovementForm);
end.
