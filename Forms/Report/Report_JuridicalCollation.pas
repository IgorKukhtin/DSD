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
  cxCurrencyEdit, DataModul, frxClass, frxDBSet, dsdGuides, cxButtonEdit,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TReport_JuridicalCollationForm = class(TAncestorReportForm)
    colItemName: TcxGridDBColumn;
    coInvNumber: TcxGridDBColumn;
    colDebet: TcxGridDBColumn;
    colKredit: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
    dsdPrintAction: TdsdPrintAction;
    frxDBDataset: TfrxDBDataset;
    bbPrint: TdxBarButton;
    cxLabel6: TcxLabel;
    edJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    getMovementForm: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actOpenForm: TdsdOpenForm;
    actGetForm: TdsdExecStoredProc;
    actOpenDocument: TMultiAction;
    bbOpenDocument: TdxBarButton;
    colAccountCode: TcxGridDBColumn;
    colAccountName: TcxGridDBColumn;
    colContractName: TcxGridDBColumn;
    colInfoMoneyCode: TcxGridDBColumn;
    colInfoMoneyName: TcxGridDBColumn;
    colInfoMoneyGroupCode: TcxGridDBColumn;
    colInfoMoneyGroupName: TcxGridDBColumn;
    colInfoMoneyDestinationCode: TcxGridDBColumn;
    colInfoMoneyDestinationName: TcxGridDBColumn;
    spJuridicalBalance: TdsdStoredProc;
    cxLabel3: TcxLabel;
    edMainJuridical: TcxButtonEdit;
    MainJuridicalGuides: TdsdGuides;
    gpGetDefault: TdsdStoredProc;
    gpGetJuridical: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrintReport: TdxBarButton;
    cxLabel4: TcxLabel;
    edAccount: TcxButtonEdit;
    AccountGuides: TdsdGuides;
    cxLabel8: TcxLabel;
    ceContract: TcxButtonEdit;
    ContractGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_JuridicalCollationForm)

end.
