unit BankStatement;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxCurrencyEdit, Vcl.ExtCtrls, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxButtonEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, cxTextEdit, cxLabel,
  cxMemo;

type
  TBankStatementForm = class(TAncestorDBGridForm)
    FormParams: TdsdFormParams;
    colDocNumber: TcxGridDBColumn;
    colOKPO: TcxGridDBColumn;
    colDebet: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    colLinkJuridicalName: TcxGridDBColumn;
    Panel: TPanel;
    cxLabel1: TcxLabel;
    edInvNumber: TcxTextEdit;
    cxLabel2: TcxLabel;
    edOperDate: TcxDateEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    spGet: TdsdStoredProc;
    edBankName: TcxTextEdit;
    edBankAccount: TcxTextEdit;
    colInfoMoney: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
    colContract: TcxGridDBColumn;
    colCredit: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TBankStatementForm);


end.
