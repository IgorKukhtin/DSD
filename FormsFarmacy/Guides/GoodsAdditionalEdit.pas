unit GoodsAdditionalEdit;

interface

uses
  DataModul, AncestorEditDialog, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  cxPropertiesStore, dsdAddOn, dsdGuides, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxMaskEdit, cxButtonEdit, cxCurrencyEdit, Vcl.StdCtrls,
  cxButtons, cxLabel, Vcl.Controls, cxTextEdit, cxCheckBox, dxSkinsCore,
  dxSkinsDefaultPainters, cxDBEdit;

type
  TGoodsAdditionalEditForm = class(TAncestorEditDialogForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    ceCode: TcxCurrencyEdit;
    ���: TcxLabel;
    GoodsMakerNameGuides: TdsdGuides;
    edMakerName: TcxButtonEdit;
    edNumberPlates: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel7: TcxLabel;
    ceQtyPackage: TcxCurrencyEdit;
    cbIsRecipe: TcxCheckBox;
    edNameUkr: TcxTextEdit;
    cxLabel12: TcxLabel;
    edFormDispensing: TcxButtonEdit;
    cxLabel14: TcxLabel;
    FormDispensingGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsAdditionalEditForm);

end.