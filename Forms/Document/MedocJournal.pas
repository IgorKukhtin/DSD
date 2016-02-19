unit MedocJournal;

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
  cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxButtonEdit, cxCurrencyEdit;

type
  TMedocJournalForm = class(TAncestorJournalForm)
    InvNumberPartner: TcxGridDBColumn;
    InvNumberBranch: TcxGridDBColumn;
    InvNumberRegistered: TcxGridDBColumn;
    DateRegistered: TcxGridDBColumn;
    FromINN: TcxGridDBColumn;
    ToINN: TcxGridDBColumn;
    DescName: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    isIncome: TcxGridDBColumn;
    MovementInvNumber: TcxGridDBColumn;
    MovementOperDate: TcxGridDBColumn;
    UserName: TcxGridDBColumn;
    UpdateDate: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TMedocJournalForm)

end.
