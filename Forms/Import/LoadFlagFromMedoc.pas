unit LoadFlagFromMedoc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dsdDB, Vcl.ActnList,
  dsdAction, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, MeDocCOM;

type
  TLoadFlagFromMedocForm = class(TAncestorDialogForm)
    cxLabel1: TcxLabel;
    dePeriodDate: TcxDateEdit;
    TaxFiz: TMedocComAction;
    TaxCorrectiveFiz: TMedocComAction;
    MultiAction: TMultiAction;
    dsdFormClose1: TdsdFormClose;
    TaxJur: TMedocComAction;
    TaxCorrectiveJur: TMedocComAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
   RegisterClass(TLoadFlagFromMedocForm)

end.
