unit Check;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, dsdGuides,
  dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, cxCurrencyEdit, dxBarBuiltInMenu, cxNavigator;

type
  TCheckForm = class(TAncestorDocumentForm)
    cxTextEdit1: TcxTextEdit;
    cxTextEdit2: TcxTextEdit;
    cxTextEdit3: TcxTextEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxTextEdit4: TcxTextEdit;
    ChoiceCashRegister: TOpenChoiceForm;
    ChoicePaidType: TOpenChoiceForm;
    spUpdate_Movement_Check: TdsdStoredProc;
    actEditDocument: TMultiAction;
    dxBarButton1: TdxBarButton;
    actUpdate_Movement_Check: TdsdExecStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TCheckForm)

end.
