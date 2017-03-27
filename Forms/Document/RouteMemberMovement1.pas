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
    GuidesFiller: TGuidesFiller;
    MemberGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    ceGUID: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edInsertDate: TcxDateEdit;
    cxLabel15: TcxLabel;
    edInsertMobileDate: TcxDateEdit;
    cxLabel34: TcxLabel;
    edGPSN: TcxTextEdit;
    cxLabel35: TcxLabel;
    edGPSE: TcxTextEdit;
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
