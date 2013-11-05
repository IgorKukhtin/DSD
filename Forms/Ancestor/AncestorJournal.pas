unit AncestorJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dsdAddOn, dxBarExtItems,
  dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxContainer, Vcl.ComCtrls, dxCore,
  cxDateUtils, ChoicePeriod, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls;

type
  TJournalForm = class(TAncestorDBGridForm)
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
