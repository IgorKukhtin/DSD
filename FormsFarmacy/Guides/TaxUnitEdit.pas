unit TaxUnitEdit;

interface

uses
  DataModul, AncestorEditDialog, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  cxPropertiesStore, dsdAddOn, dsdGuides, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxMaskEdit, cxButtonEdit, cxCurrencyEdit, Vcl.StdCtrls,
  cxButtons, cxLabel, Vcl.Controls, cxTextEdit, dxSkinsCore,
  dxSkinsDefaultPainters;

type
  TTaxUnitEditForm = class(TAncestorEditDialogForm)
    cxLabel18: TcxLabel;
    ceValue: TcxCurrencyEdit;
    cxLabel1: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    edPrice: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TTaxUnitEditForm);

end.
