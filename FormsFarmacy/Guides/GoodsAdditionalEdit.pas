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
    Код: TcxLabel;
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
    edMakerNameUkr: TcxTextEdit;
    cxLabel4: TcxLabel;
    edDosage: TcxTextEdit;
    cxLabel5: TcxLabel;
    edVolume: TcxTextEdit;
    cxLabel6: TcxLabel;
    ceGoodsWhoCan: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edGoodsMethodAppl: TcxButtonEdit;
    cxLabel9: TcxLabel;
    edGoodsSignOrigin: TcxButtonEdit;
    cxLabel10: TcxLabel;
    GoodsSignOriginGuides: TdsdGuides;
    GoodsMethodApplGuides: TdsdGuides;
    GoodsWhoCanGuides: TdsdGuides;
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
