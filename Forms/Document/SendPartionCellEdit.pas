unit SendPartionCellEdit;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCheckBox;

type
  TSendPartionCellEditForm = class(TAncestorEditDialogForm)
    cePartionCell_Amount_1: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceGooods: TcxButtonEdit;
    cxLabel12: TcxLabel;
    GuidesGoods: TdsdGuides;
    cxLabel3: TcxLabel;
    cePartionCell_Amount_2: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    cePartionCell_Amount_3: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    cePartionCell_Amount_5: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    GuidesGooodsKind: TdsdGuides;
    ceGooodsKind: TcxButtonEdit;
    cxLabel9: TcxLabel;
    cePartionCell_Last: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    cePartionCell_Amount_4: TcxCurrencyEdit;
    cbisPartionCell_Close_1: TcxCheckBox;
    cbisPartionCell_Close_3: TcxCheckBox;
    cbisPartionCell_Close_4: TcxCheckBox;
    cbisPartionCell_Close_2: TcxCheckBox;
    cbisPartionCell_Close_5: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TSendPartionCellEditForm);

end.
