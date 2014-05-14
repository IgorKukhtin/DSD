unit EDIJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, EDI;

type
  TEDIJournalForm = class(TAncestorDBGridForm)
    colOperDate: TcxGridDBColumn;
    colInvNumber: TcxGridDBColumn;
    cxGridDBTableViewColumn3: TcxGridDBColumn;
    cxGridDBTableViewColumn4: TcxGridDBColumn;
    Panel: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    EDIActionComdocLoad: TEDIActionComdocLoad;
    spHeader: TdsdStoredProc;
    spList: TdsdStoredProc;
    bbLoadComDoc: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TEDIJournalForm);

end.
