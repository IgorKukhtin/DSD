unit Member_TrasportDialog;

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
  TMember_TrasportDialogForm = class(TAncestorDialogForm)
    cxPropertiesStore1: TcxPropertiesStore;
    cxLabel6: TcxLabel;
    cxLabel8: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel9: TcxLabel;
    edLimit: TcxCurrencyEdit;
    edReparation: TcxCurrencyEdit;
    edSummerFuel: TcxCurrencyEdit;
    edWinterFuel: TcxCurrencyEdit;
    edLimitDistance: TcxCurrencyEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Member_TrasportDialogForm: TMember_TrasportDialogForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMember_TrasportDialogForm);

end.
