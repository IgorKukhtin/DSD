unit Member_TrasportDateDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dsdDB, Vcl.ActnList,
  dsdAction, cxClasses, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxCurrencyEdit, cxLabel,
  dxSkinsCore, dxSkinsDefaultPainters, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxMaskEdit, cxDropDownEdit, cxCalendar;

type
  TMember_TrasportDateDialogForm = class(TAncestorDialogForm)
    cxLabel5: TcxLabel;
    edStartSummer: TcxDateEdit;
    cxLabel3: TcxLabel;
    edEndSummer: TcxDateEdit;
    cxPropertiesStore1: TcxPropertiesStore;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Member_TrasportDateDialogForm: TMember_TrasportDateDialogForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMember_TrasportDateDialogForm);

end.
