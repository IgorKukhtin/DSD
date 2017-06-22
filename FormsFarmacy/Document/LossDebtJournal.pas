unit LossDebtJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, AncestorJournal, DataModul, ParentForm,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, Data.DB, cxDBData, cxImageComboBox, cxCurrencyEdit,
  dsdAddOn, ChoicePeriod, Vcl.Menus, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, dxBarExtItems, dxBar, cxClasses, cxPropertiesStore,
  Datasnap.DBClient, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.Controls, Vcl.ExtCtrls, cxPCdxBarPopupMenu,
  cxPC, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter;

type
  TLossDebtJournalForm = class(TAncestorJournalForm)
    JuridicalBasisName: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TLossDebtJournalForm);

end.
