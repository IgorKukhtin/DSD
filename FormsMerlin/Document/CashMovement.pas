unit CashMovement;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEditDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dsdDB, dsdAction,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, dsdGuides, cxButtonEdit, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxCurrencyEdit, cxLabel, dxSkinsCore, dxSkinsDefaultPainters, cxCheckBox;

type
  TCashMovementForm = class(TAncestorEditDialogForm)
    Код: TcxLabel;
    cxLabel1: TcxLabel;
    ceOperDate: TcxDateEdit;
    ceAmount: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cxLabel5: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
    edInvNumber: TcxTextEdit;
    ceUnit: TcxButtonEdit;
    cxLabel14: TcxLabel;
    GuidesUnit: TdsdGuides;
    cxLabel17: TcxLabel;
    ceServiceDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    edCommentInfoMoney: TcxButtonEdit;
    GuidesCommentInfoMoney: TdsdGuides;
    cxLabel3: TcxLabel;
    ceParent_infomoney: TcxButtonEdit;
    GuidesParent_infomoney: TdsdGuides;
    cbSign: TcxCheckBox;
    cbChild: TcxCheckBox;
    cxLabel4: TcxLabel;
    edInfoMoneyDetail: TcxButtonEdit;
    GuidesInfoMoneyDetail: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCashMovementForm);

end.
