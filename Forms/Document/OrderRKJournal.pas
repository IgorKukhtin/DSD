unit OrderRKJournal;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TOrderRKJournalForm = class(TAncestorJournalForm)
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    FromName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    OperDate_Print: TcxGridDBColumn;
    RouteName: TcxGridDBColumn;
    RouteGroupName: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    TotalCountSh: TcxGridDBColumn;
    TotalCountKg: TcxGridDBColumn;
    isPrint: TcxGridDBColumn;
    spSavePrintState: TdsdStoredProc;
    actSPSavePrintState: TdsdExecStoredProc;
    mactPrint: TMultiAction;
    N13: TMenuItem;
    Comment: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    actShowMessage: TShowMessageAction;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    spSelectPrintTotal: TdsdStoredProc;
    spGetReporNameBill: TdsdStoredProc;
    spSelectPrintBill: TdsdStoredProc;
    OperDate_CarInfo: TcxGridDBColumn;
    spUpdateMIChild_AmountSecond: TdsdStoredProc;
    spUpdateMIChild_Amount: TdsdStoredProc;
    spUpdateMIChild_AmountNull: TdsdStoredProc;
    spUpdateMIChild_AmountSecondNull: TdsdStoredProc;
    bbsPrint: TdxBarSubItem;
    bbSeparator: TdxBarSeparator;
    InvNumber_OrderExternal: TcxGridDBColumn;
    OperDate_OrderExternal: TcxGridDBColumn;
    OperDatePartner_OrderExternal: TcxGridDBColumn;
    OperDatePartner_sale_OE: TcxGridDBColumn;
    actReport_open: TdsdOpenForm;
    dxBarButton1: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TOrderRKJournalForm);
end.
