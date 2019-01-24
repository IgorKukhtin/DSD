unit Report_JuridicalCollationSaldo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxCurrencyEdit, DataModul, frxClass, frxDBSet, dsdGuides, cxButtonEdit,
  dxSkinsCore, cxImageComboBox, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, dsdExportToXLSAction;

type
  TReport_JuridicalCollationSaldoForm = class(TAncestorReportForm)
    Name: TcxGridDBColumn;
    Debet: TcxGridDBColumn;
    Kredit: TcxGridDBColumn;
    actPrintOfficial: TdsdPrintAction;
    bbPrintOfficial: TdxBarButton;
    getMovementForm: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actOpenForm: TdsdOpenForm;
    actGetForm: TdsdExecStoredProc;
    actOpenDocument: TMultiAction;
    bbOpenDocument: TdxBarButton;
    spJuridicalBalance: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    actPrintTurnover: TdsdPrintAction;
    bbPrintTurnover: TdxBarButton;
    actPrintCurrency: TdsdPrintAction;
    bbPrintCurrency: TdxBarButton;
    edJuridicalBasis: TcxButtonEdit;
    cxLabel3: TcxLabel;
    JuridicalBasisGuide: TdsdGuides;
    SaldoDS: TDataSource;
    SalsoCDS: TClientDataSet;
    cxGridSaldo: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    SaldoNDSKindName: TcxGridDBColumn;
    SaldoSummaWith: TcxGridDBColumn;
    SaldoSummaNDS: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    SaldoSumma: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    actExportToXLS_PrintAll: TdsdExportToXLS;
    actExportToXLS_PrintGoods: TdsdExportToXLS;
    actPrintAll: TMultiAction;
    actPrintGoods: TMultiAction;
    actExecStoredProc_PrintAll: TdsdExecStoredProc;
    actExecStoredProc_PrintGoods: TdsdExecStoredProc;
    spSelectPrintGoods: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_JuridicalCollationSaldoForm)

end.
