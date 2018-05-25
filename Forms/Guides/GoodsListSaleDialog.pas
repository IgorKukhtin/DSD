unit GoodsListSaleDialog;

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
  TGoodsListSaleDialogForm = class(TAncestorDialogForm)
    cxLabel3: TcxLabel;
    edRetail: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edJuridical: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edContract: TcxButtonEdit;
    RetailGuides: TdsdGuides;
    JuridicalGuides: TdsdGuides;
    ContractGuides: TdsdGuides;
    cxLabel8: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsListSaleDialogForm);
end.
