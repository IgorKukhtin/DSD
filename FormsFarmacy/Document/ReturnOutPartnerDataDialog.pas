unit ReturnOutPartnerDataDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxMaskEdit, cxDropDownEdit, cxCalendar, cxTextEdit, cxLabel,
  dsdDB, Vcl.ActnList, dsdAction, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls,
  cxButtons;

type
  TReturnOutPartnerDataDialogForm = class(TAncestorDialogForm)
    cxLabel9: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    cxLabel11: TcxLabel;
    edOperDatePartner: TcxDateEdit;
    edAdjustingOurDate: TcxDateEdit;
    cxLabel1: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReturnOutPartnerDataDialogForm);
end.
