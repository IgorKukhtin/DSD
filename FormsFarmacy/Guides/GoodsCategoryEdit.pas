unit GoodsCategoryEdit;

interface

uses
  DataModul, AncestorEditDialog, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  cxPropertiesStore, dsdAddOn, dsdGuides, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxMaskEdit, cxButtonEdit, cxCurrencyEdit, Vcl.StdCtrls,
  cxButtons, cxLabel, Vcl.Controls, cxTextEdit, dxSkinsCore,
  dxSkinsDefaultPainters;

type
  TGoodsCategoryEditForm = class(TAncestorEditDialogForm)
    cxLabel2: TcxLabel;
    GuidesGoods: TdsdGuides;
    edGoods: TcxButtonEdit;
    cxLabel6: TcxLabel;
    edUnitCategory: TcxButtonEdit;
    GuidesUnitCategory: TdsdGuides;
    cxLabel18: TcxLabel;
    ceValue: TcxCurrencyEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsCategoryEditForm);

end.
