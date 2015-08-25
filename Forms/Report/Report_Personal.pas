unit Report_Personal;

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
  cxImageComboBox, cxCheckBox;

type
  TReport_PersonalForm = class(TAncestorReportForm)
    colAccountName: TcxGridDBColumn;
    colInfoMoneyGroupName: TcxGridDBColumn;
    colInfoMoneyDestinationName: TcxGridDBColumn;
    colStartAmount: TcxGridDBColumn;
    colEndAmount: TcxGridDBColumn;
    colInfoMoneyName: TcxGridDBColumn;
    dsdPrintAction: TdsdPrintAction;
    bbPrint: TdxBarButton;
    cxLabel3: TcxLabel;
    ceInfoMoneyGroup: TcxButtonEdit;
    GuidesInfoMoneyGroup: TdsdGuides;
    GuidesInfoMoneyDestination: TdsdGuides;
    ceInfoMoneyDestination: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesInfoMoney: TdsdGuides;
    ceInfoMoney: TcxButtonEdit;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    edAccount: TcxButtonEdit;
    GuidesAccount: TdsdGuides;
    colInfoMoneyCode: TcxGridDBColumn;
    colDebetSumm: TcxGridDBColumn;
    colKreditSumm: TcxGridDBColumn;
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
    dsdPrintRealAction: TdsdPrintAction;
    bbPrintReal: TdxBarButton;
    ceBranch: TcxButtonEdit;
    cxLabel7: TcxLabel;
    GuidesBranch: TdsdGuides;
    BranchName: TcxGridDBColumn;
    ServiceDate: TcxGridDBColumn;
    cbServiceDate: TcxCheckBox;
    deServiceDate: TcxDateEdit;
    colStartAmountD: TcxGridDBColumn;
    colStartAmountK: TcxGridDBColumn;
    colEndAmountD: TcxGridDBColumn;
    colEndAmountK: TcxGridDBColumn;
    colMoneySumm: TcxGridDBColumn;
    colServiceSumm: TcxGridDBColumn;
    clInfoMoneyName_all: TcxGridDBColumn;
    PersonalCode: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    PositionCode: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    PersonalServiceListCode: TcxGridDBColumn;
    PersonalServiceListName: TcxGridDBColumn;
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

  RegisterClass(TReport_PersonalForm)

end.
