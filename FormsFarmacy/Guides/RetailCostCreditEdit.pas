unit RetailCostCreditEdit;

interface

uses
  DataModul, AncestorEditDialog, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  cxPropertiesStore, dsdAddOn, dsdGuides, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxMaskEdit, cxButtonEdit, cxCurrencyEdit, Vcl.StdCtrls,
  cxButtons, cxLabel, Vcl.Controls, cxTextEdit, dxSkinsCore,
  dxSkinsDefaultPainters;

type
  TRetailCostCreditEditForm = class(TAncestorEditDialogForm)
    cxLabel18: TcxLabel;
    cePercent: TcxCurrencyEdit;
    cxLabel1: TcxLabel;
    edRetail: TcxButtonEdit;
    GuidesRetail: TdsdGuides;
    edMinPrice: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TRetailCostCreditEditForm);

end.
