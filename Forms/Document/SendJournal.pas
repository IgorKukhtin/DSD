unit SendJournal;

interface

uses AncestorJournal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxImageComboBox, Vcl.Menus, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, dsdAddOn, ChoicePeriod, dxBarExtItems,
  dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  Vcl.Controls, cxGrid, cxPCdxBarPopupMenu, cxPC;

type
  TSendJournalForm = class(TAncestorJournalForm)
    colStatus: TcxGridDBColumn;
    colInvNumber: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
    colFromName: TcxGridDBColumn;
    colToName: TcxGridDBColumn;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    colTotalCount: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSendJournalForm);

end.
