unit TransportGoods;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TTransportGoodsForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    Код: TcxLabel;
    edOperDate: TcxDateEdit;
    edInvNumber_Sale: TcxButtonEdit;
    GuideSaleJournalChoice: TdsdGuides;
    cxLabel6: TcxLabel;
    GuidesFiller: TGuidesFiller;
    edInvNumber: TcxTextEdit;
    edOperDate_Sale: TcxDateEdit;
    edRoute: TcxButtonEdit;
    GuideRoute: TdsdGuides;
    cxLabel67: TcxLabel;
    cxLabel2: TcxLabel;
    edFrom: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel9: TcxLabel;
    edCar: TcxButtonEdit;
    GuideCar: TdsdGuides;
    cxLabel5: TcxLabel;
    edPersonalDriver: TcxButtonEdit;
    GuidePersonalDriver: TdsdGuides;
    cxLabel7: TcxLabel;
    edCarTrailer: TcxButtonEdit;
    GuideCarTrailer: TdsdGuides;
    cxLabel4: TcxLabel;
    edCarModel: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edCarTrailerModel: TcxButtonEdit;
    cxLabel10: TcxLabel;
    edTo: TcxButtonEdit;
    cxLabel14: TcxLabel;
    edMember1: TcxButtonEdit;
    GuideMember1: TdsdGuides;
    cxLabel11: TcxLabel;
    edMember2: TcxButtonEdit;
    GuideMember2: TdsdGuides;
    GuideCarModel: TdsdGuides;
    GuideCarTrailerModel: TdsdGuides;
    edInvNumberMark: TcxTextEdit;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    edMember3: TcxButtonEdit;
    GuideMember3: TdsdGuides;
    edMember4: TcxButtonEdit;
    cxLabel15: TcxLabel;
    GuideMember4: TdsdGuides;
    GuidesTo: TdsdGuides;
    cxLabel16: TcxLabel;
    edCarJuridical: TcxButtonEdit;
    GuidesCarJuridical: TdsdGuides;
    edBarCode: TcxTextEdit;
    cxLabel17: TcxLabel;
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
