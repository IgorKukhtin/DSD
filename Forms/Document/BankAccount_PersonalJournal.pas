unit BankAccount_PersonalJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxCheckBox, cxImageComboBox, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.Menus, cxCurrencyEdit, dsdGuides,
  cxButtonEdit;

type
  TBankAccount_PersonalJournalForm = class(TAncestorJournalForm)
    Comment: TcxGridDBColumn;
    edBankAccount: TcxButtonEdit;
    cxLabel3: TcxLabel;
    GuidesBankAccount: TdsdGuides;
    MemberName: TcxGridDBColumn;
    PersonalServiceListName: TcxGridDBColumn;
    Comment_Service: TcxGridDBColumn;
    InvNumber_Service: TcxGridDBColumn;
    OperDate_Service: TcxGridDBColumn;
    ServiceDate_Service: TcxGridDBColumn;
    TotalSummToPay_Service: TcxGridDBColumn;
    cbIsServiceDate: TcxCheckBox;
    actIsServiceDate: TdsdDataSetRefresh;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TBankAccount_PersonalJournalForm);

end.
