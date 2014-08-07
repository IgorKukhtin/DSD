unit AncestorJournal;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dsdAddOn, dxBarExtItems,
  dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxContainer, Vcl.ComCtrls, dxCore,
  cxDateUtils, ChoicePeriod, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxPCdxBarPopupMenu, cxPC, cxImageComboBox,
  dxSkinsCore, dxSkinsDefaultPainters, Vcl.Menus, dxSkinscxPCPainter,
  dxSkinsdxBarPainter;

type
  TAncestorJournalForm = class(TAncestorDBGridForm)
    Panel: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    PeriodChoice: TPeriodChoice;
    RefreshDispatcher: TRefreshDispatcher;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    actComplete: TdsdChangeMovementStatus;
    actUnComplete: TdsdChangeMovementStatus;
    actSetErased: TdsdChangeMovementStatus;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbComplete: TdxBarButton;
    bbUnComplete: TdxBarButton;
    bbDelete: TdxBarButton;
    spMovementComplete: TdsdStoredProc;
    spMovementUnComplete: TdsdStoredProc;
    spMovementSetErased: TdsdStoredProc;
    N3: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    N2: TMenuItem;
    N5: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    actCompleteList: TMultiAction;
    actUnCompleteList: TMultiAction;
    actSetErasedList: TMultiAction;
    actMovementItemContainer: TdsdOpenForm;
    bbMovementItemContainer: TdxBarButton;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    FormParams: TdsdFormParams;
    spCompete: TdsdExecStoredProc;
    spUncomplete: TdsdExecStoredProc;
    spErased: TdsdExecStoredProc;
    actSimpleCompleteList: TMultiAction;
    actSimpleUncompleteList: TMultiAction;
    actSimpleErased: TMultiAction;
    bbInsertMask: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
