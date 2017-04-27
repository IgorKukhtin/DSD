unit CurrencyMovement;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters;

type
  TCurrencyMovementForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    ���: TcxLabel;
    ceOperDate: TcxDateEdit;
    ceAmount: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceCurrencyTo: TcxButtonEdit;
    CurrencyToGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    GuidesFiller: TGuidesFiller;
    ceCurrencyFrom: TcxButtonEdit;
    cxLabel8: TcxLabel;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    CurrencyFromGuides: TdsdGuides;
    edInvNumber: TcxTextEdit;
    ceParValue: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TCurrencyMovementForm);

end.
