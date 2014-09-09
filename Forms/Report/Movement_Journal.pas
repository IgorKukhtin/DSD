unit Movement_Journal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn,
  ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, cxCurrencyEdit, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, dsdGuides, cxButtonEdit;

type
  TMovementJournalForm = class(TAncestorJournalForm)
    colDescName: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    actOpenDocument: TMultiAction;
    actOpenForm: TdsdOpenForm;
    actMovementForm: TdsdExecStoredProc;
    bbOpenDocument: TdxBarButton;
    getMovementForm: TdsdStoredProc;
    cxLabel3: TcxLabel;
    edPartner: TcxButtonEdit;
    cxLabel6: TcxLabel;
    edJuridical: TcxButtonEdit;
    cxLabel7: TcxLabel;
    cxLabel4: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    edAccount: TcxButtonEdit;
    cxLabel5: TcxLabel;
    cxLabel8: TcxLabel;
    edPaidKind: TcxButtonEdit;
    ceContract: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    PartnerGuides: TdsdGuides;
    InfoMoneyGuides: TdsdGuides;
    AccountGuides: TdsdGuides;
    PaidKindGuides: TdsdGuides;
    ContractGuides: TdsdGuides;
    cxLabel9: TcxLabel;
    edBranch: TcxButtonEdit;
    BranchGuides: TdsdGuides;
    colBranchCode: TcxGridDBColumn;
    colBranchName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TMovementJournalForm)

end.
