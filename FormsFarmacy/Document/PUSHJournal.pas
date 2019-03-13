unit PUSHJournal;

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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxBlobEdit;

type
  TPUSHJournalForm = class(TAncestorJournalForm)
    spGet_Movement_PUSH: TdsdStoredProc;
    colId: TcxGridDBColumn;
    colMessageText: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbmacPrint: TdxBarButton;
    colDateEndPUSH: TcxGridDBColumn;
    colReplays: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPUSHJournalForm);

end.
