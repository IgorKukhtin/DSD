unit AncestorEditDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dsdDB, Vcl.ActnList,
  dsdAction, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons;

type
  TAncestorEditDialogForm = class(TAncestorDialogForm)
    spInsertUpdate: TdsdStoredProc;
    spGet: TdsdStoredProc;
    FormClose: TdsdFormClose;
    InsertUpdateGuides: TdsdInsertUpdateGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
