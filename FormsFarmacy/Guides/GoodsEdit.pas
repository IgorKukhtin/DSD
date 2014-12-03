unit GoodsEdit;

interface

uses
  DataModul, AncestorEditDialog, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  cxPropertiesStore, dsdAddOn, dsdGuides, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxMaskEdit, cxButtonEdit, cxCurrencyEdit, Vcl.StdCtrls,
  cxButtons, cxLabel, Vcl.Controls, cxTextEdit;

type
  TGoodsEditForm = class(TAncestorEditDialogForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    ceCode: TcxCurrencyEdit;
    Код: TcxLabel;
    GoodsGroupGuides: TdsdGuides;
    ceParentGroup: TcxButtonEdit;
    cxLabel4: TcxLabel;
    ceMeasure: TcxButtonEdit;
    dsdMeasureGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    ceNDSKind: TcxButtonEdit;
    NDSKindGuides: TdsdGuides;
    edMinimumLot: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel5: TcxLabel;
    ceReferPrice: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceReferCode: TcxCurrencyEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsEditForm);

end.
