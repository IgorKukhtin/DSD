unit CashOperation;

interface

uses
  AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters;

type
  TCashOperationForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    edCash: TcxButtonEdit;
    edUnit: TcxButtonEdit;
    edInfoMoney: TcxButtonEdit;
    edOperDate: TcxDateEdit;
    edAmountIn: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    GuidesCash: TdsdGuides;
    GuidesUnit: TdsdGuides;
    GuidesInfoMoney: TdsdGuides;
    edObject: TcxButtonEdit;
    GuidesObjectl: TdsdGuides;
    cxLabel6: TcxLabel;
    GuidesFiller: TGuidesFiller;
    cxLabel10: TcxLabel;
    edComment: TcxTextEdit;
    cxLabel3: TcxLabel;
    edAmountOut: TcxCurrencyEdit;
    edInvNumber: TcxTextEdit;
    cxLabel13: TcxLabel;
    edCurrencyPartnerValue: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edParPartnerValue: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    edCurrency: TcxButtonEdit;
    GuidesCurrency: TdsdGuides;
    cxLabel8: TcxLabel;
    edCurrencyValue: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    edParValue: TcxCurrencyEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TCashOperationForm);

end.
