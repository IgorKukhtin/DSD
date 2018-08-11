unit Report_Liquidity;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  AncestorReport, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, Data.DB, cxDBData, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxPC, cxContainer, cxTextEdit,
  cxLabel, cxCurrencyEdit, cxButtonEdit, Vcl.DBActns, cxMaskEdit, Vcl.ExtCtrls,
  Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod, cxDropDownEdit, cxCalendar,
  dsdGuides, dxBarBuiltInMenu, cxNavigator, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxGridDBBandedTableView,
  cxGridBandedTableView;

type
  TReport_LiquidityForm = class(TAncestorReportForm)
    actRefreshSearch: TdsdExecStoredProc;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    Panel1: TPanel;
    gIncome: TcxGrid;
    gIncomeLevel: TcxGridLevel;
    dsIncome: TDataSource;
    cdsIncome: TClientDataSet;
    gIncomeDBBandedTableView: TcxGridDBBandedTableView;
    gIncomeJuridicalId: TcxGridDBBandedColumn;
    gIncomeJuridicalName: TcxGridDBBandedColumn;
    gIncomeSummNoPay: TcxGridDBBandedColumn;
    cxGridDBBandedTableView: TcxGridDBBandedTableView;
    cxGridJuridicalID: TcxGridDBBandedColumn;
    cxGridJuridicalName: TcxGridDBBandedColumn;
    cxGridSummaRemainder: TcxGridDBBandedColumn;
    gMarketCompany: TcxGrid;
    gMarketCompanyDBBandedTableView: TcxGridDBBandedTableView;
    gMarketCompanyMarketCompanyID: TcxGridDBBandedColumn;
    gMarketCompanyMarketCompanyName: TcxGridDBBandedColumn;
    gMarketCompanySumma: TcxGridDBBandedColumn;
    gMarketCompanyLevel: TcxGridLevel;
    dsMarketCompany: TDataSource;
    cdsMarketCompany: TClientDataSet;
    gOverdraft: TcxGrid;
    gOverdraftDBBandedTableView: TcxGridDBBandedTableView;
    gOverdraftBankID: TcxGridDBBandedColumn;
    gOverdraftBankName: TcxGridDBBandedColumn;
    gOverdraftSumma: TcxGridDBBandedColumn;
    gOverdraftLevel: TcxGridLevel;
    dsOverdraft: TDataSource;
    cdsOverdraft: TClientDataSet;
    spUpdateisMarketCompany: TdsdStoredProc;
    spUpdateisOverdraft: TdsdStoredProc;
    UpdateisMarketCompany: TdsdUpdateDataSet;
    UpdateisOverdraft: TdsdUpdateDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_LiquidityForm);

end.
