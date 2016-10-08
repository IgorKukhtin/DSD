unit SendTicketFuelJournal;

interface

uses AncestorJournal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxImageComboBox, Vcl.Menus, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, dsdAddOn, ChoicePeriod, dxBarExtItems,
  dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  Vcl.Controls, cxGrid, cxPCdxBarPopupMenu, cxPC, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxButtonEdit,
  dsdGuides;

type
  TSendTicketFuelJournalForm = class(TAncestorJournalForm)
    colFromName: TcxGridDBColumn;
    colToName: TcxGridDBColumn;
    colTotalCount: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSendTicketFuelJournalForm);

end.
