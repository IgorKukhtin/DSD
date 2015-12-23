unit Report_TaraDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore,
  dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore,
  cxDateUtils, dsdGuides, cxButtonEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, cxLabel, dsdDB, Vcl.ActnList, dsdAction, cxPropertiesStore,
  dsdAddOn, Vcl.StdCtrls, cxButtons, ChoicePeriod, cxCheckBox;

type
  TReport_TaraDialogForm = class(TAncestorDialogForm)
    cxLabel1: TcxLabel;
    deStart: TcxDateEdit;
    cxLabel2: TcxLabel;
    deEnd: TcxDateEdit;
    PeriodChoice: TPeriodChoice;
    chkWithSupplier: TcxCheckBox;
    chbWithBayer: TcxCheckBox;
    chbWithPlace: TcxCheckBox;
    chbWithBranch: TcxCheckBox;
    cxLabel3: TcxLabel;
    edObject: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edGoods: TcxButtonEdit;
    ObjectGuides: TdsdGuides;
    GoodsGuides: TdsdGuides;
    chkWithMember: TcxCheckBox;
    cxLabel5: TcxLabel;
    ceAccountGroup: TcxButtonEdit;
    AccountGroupGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_TaraDialogForm);
end.
