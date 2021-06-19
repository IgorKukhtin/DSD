unit SaleJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdDB,
  dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, cxCalc, cxCurrencyEdit, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TSaleJournalForm = class(TAncestorJournalForm)
    spGet_Movement_Sale: TdsdStoredProc;
    UnitName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    TotalSummPrimeCost: TcxGridDBColumn;
    Id: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    isSP: TcxGridDBColumn;
    GroupMemberSPName: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    PrintDialog: TExecuteDialog;
    actPrint: TdsdPrintAction;
    macPrint: TMultiAction;
    bbmacPrint: TdxBarButton;
    InvNumber_Invoice_Full: TcxGridDBColumn;
    SPKindName: TcxGridDBColumn;
    isDeferred: TcxGridDBColumn;
    isNP: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSaleJournalForm);

end.
