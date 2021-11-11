unit Report_MovementProtocolGroupDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore,
  cxDateUtils, dsdGuides, cxButtonEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, cxLabel, dsdDB, Vcl.ActnList, dsdAction, cxPropertiesStore,
  dsdAddOn, Vcl.StdCtrls, cxButtons, ChoicePeriod, cxCheckBox, cxCurrencyEdit;

type
  TReport_MovementProtocolGroupDialogForm = class(TAncestorDialogForm)
    cxLabel1: TcxLabel;
    deStart: TcxDateEdit;
    cxLabel2: TcxLabel;
    deEnd: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    cbisMovement: TcxCheckBox;
    UnitGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    edUser: TcxButtonEdit;
    UserGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_MovementProtocolGroupDialogForm);
end.
