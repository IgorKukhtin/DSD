unit Report_JuridicalCollation;

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
  cxCurrencyEdit, DataModul, frxClass, frxDBSet, dsdGuides, cxButtonEdit;

type
  TReport_JuridicalColletionForm = class(TAncestorReportForm)
    colJuridicalName: TcxGridDBColumn;
    colContractNumber: TcxGridDBColumn;
    colPaidKindName: TcxGridDBColumn;
    colAccountName: TcxGridDBColumn;
    colInfoMoneyGroupName: TcxGridDBColumn;
    colInfoMoneyDestinationName: TcxGridDBColumn;
    colStartAmount: TcxGridDBColumn;
    colSaleSumm: TcxGridDBColumn;
    colMoneySumm: TcxGridDBColumn;
    colServiceSumm: TcxGridDBColumn;
    colOtherSumm: TcxGridDBColumn;
    colEndAmount: TcxGridDBColumn;
    colInfoMoneyName: TcxGridDBColumn;
    dsdPrintAction: TdsdPrintAction;
    frxDBDataset: TfrxDBDataset;
    bbPrint: TdxBarButton;
    cxLabel6: TcxLabel;
    edJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_JuridicalColletionForm)

end.
