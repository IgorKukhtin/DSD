unit RouteMemberMovement;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters;

type
  TRouteMemberMovementForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    ceInvNumber: TcxCurrencyEdit;
    ceOperDate: TcxDateEdit;
    ceInsertName: TcxButtonEdit;
    cxLabel6: TcxLabel;
    MemberGuides: TdsdGuides;
    edInsertDate: TcxDateEdit;
    cxLabel14: TcxLabel;
    cxLabel15: TcxLabel;
    edInsertMobileDate: TcxDateEdit;
    cxLabel4: TcxLabel;
    ceGUID: TcxCurrencyEdit;
    cxLabel34: TcxLabel;
    cxLabel35: TcxLabel;
    edGPSN: TcxCurrencyEdit;
    edGPSE: TcxCurrencyEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TRouteMemberMovementForm);

end.
