unit TransportGoods;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters;

type
  TTransportGoodsForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    ceOperDate: TcxDateEdit;
    ceFounder: TcxButtonEdit;
    FounderGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    GuidesFiller: TGuidesFiller;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    edInvNumber: TcxTextEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TTransportGoodsForm);

end.
