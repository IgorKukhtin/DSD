unit GoodsMainEdit;

interface

uses
  DataModul, AncestorEditDialog, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  cxPropertiesStore, dsdAddOn, dsdGuides, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxMaskEdit, cxButtonEdit, cxCurrencyEdit, Vcl.StdCtrls,
  cxButtons, cxLabel, Vcl.Controls, cxTextEdit;

type
  TGoodsMainEditForm = class(TAncestorEditDialogForm)
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsMainEditForm);

end.
