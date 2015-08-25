unit Report_Cash;

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
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxImageComboBox;

type
  TReport_CashForm = class(TAncestorReportForm)
    AccountName: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    StartAmount: TcxGridDBColumn;
    EndAmount: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    bbPrint: TdxBarButton;
    InfoMoneyCode: TcxGridDBColumn;
    DebetSumm: TcxGridDBColumn;
    KreditSumm: TcxGridDBColumn;
    SaleJournal: TdsdOpenForm;
    ReturnInJournal: TdsdOpenForm;
    IncomeJournal: TdsdOpenForm;
    ReturnOutJournal: TdsdOpenForm;
    MoneyJournal: TdsdOpenForm;
    ServiceJournal: TdsdOpenForm;
    SendDebtJournal: TdsdOpenForm;
    OtherJournal: TdsdOpenForm;
    spGetDescSets: TdsdStoredProc;
    FormParams: TdsdFormParams;
    SaleRealJournal: TdsdOpenForm;
    ReturnInRealJournal: TdsdOpenForm;
    TransferDebtJournal: TdsdOpenForm;
    bbPrintReal: TdxBarButton;
    MoneyPlaceName: TcxGridDBColumn;
    cxLabel6: TcxLabel;
    ceCash: TcxButtonEdit;
    GuidesCash: TdsdGuides;
    cxLabel3: TcxLabel;
    edAccount: TcxButtonEdit;
    GuidesAccount: TdsdGuides;
    spSelectPrint: TdsdStoredProc;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    actPrint: TdsdPrintAction;
    StartAmountD: TcxGridDBColumn;
    StartAmountK: TcxGridDBColumn;
    EndAmountD: TcxGridDBColumn;
    EndAmountK: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    GroupName: TcxGridDBColumn;
    GroupId: TcxGridDBColumn;
    actPrint_byElements: TdsdPrintAction;
    actPrint_byElements_byComments: TdsdPrintAction;
    bbPrint_byElements_byComments: TdxBarButton;
    MoneyPlaceCode: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    ProfitLossGroupCode: TcxGridDBColumn;
    ProfitLossGroupName: TcxGridDBColumn;
    ProfitLossDirectionCode: TcxGridDBColumn;
    ProfitLossDirectionName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_CashForm)

end.
