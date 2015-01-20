unit Report_GoodsMI_SaleReturnIn;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxCheckBox, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TReport_GoodsMI_SaleReturnInForm = class(TAncestorReportForm)
    clTradeMarkName: TcxGridDBColumn;
    clGoodsGroupName: TcxGridDBColumn;
    clGoodsCode: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    clSale_Summ: TcxGridDBColumn;
    clSale_Amount_Weight: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    clSale_Amount_Sh: TcxGridDBColumn;
    clJuridicalName: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    clReturn_Amount_Sh: TcxGridDBColumn;
    clReturn_Amount_Weight: TcxGridDBColumn;
    clReturn_Summ: TcxGridDBColumn;
    clGoodsKindName: TcxGridDBColumn;
    clSale_AmountPartner_Weight: TcxGridDBColumn;
    clSale_AmountPartner_Sh: TcxGridDBColumn;
    clReturn_AmountPartner_Weight: TcxGridDBColumn;
    clReturn_AmountPartner_Sh: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    clReturnPercent: TcxGridDBColumn;
    clGoodsGroupNameFull: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    edPaidKind: TcxButtonEdit;
    cxLabel7: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    InfoMoneyGuides: TdsdGuides;
    PaidKindGuides: TdsdGuides;
    clMeasureName: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    RetailName: TcxGridDBColumn;
    clOKPO: TcxGridDBColumn;
    actPrint_byJuridical: TdsdPrintAction;
    bbPrint_byJuridical: TdxBarButton;
    clJuridicalGroupName: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    actPrint_byStatGroup: TdsdPrintAction;
    bbPrint_byStatGroup: TdxBarButton;
    cbPartner: TcxCheckBox;
    cbGoods: TcxCheckBox;
    bbPartner: TdxBarControlContainerItem;
    bbGoods: TdxBarControlContainerItem;
    AreaName: TcxGridDBColumn;
    RetailReportName: TcxGridDBColumn;
    PartnerTagName: TcxGridDBColumn;
    CityName: TcxGridDBColumn;
    CityKindName: TcxGridDBColumn;
    RegionName: TcxGridDBColumn;
    ProvinceName: TcxGridDBColumn;
    ProvinceCityName: TcxGridDBColumn;
    StreetName: TcxGridDBColumn;
    StreetKindName: TcxGridDBColumn;
    PartnerId: TcxGridDBColumn;
    InfoMoneyName_all: TcxGridDBColumn;
    Sale_SummCost: TcxGridDBColumn;
    Return_SummCost: TcxGridDBColumn;
    actPrint_byPartner: TdsdPrintAction;
    bbPrint_byPartner: TdxBarButton;
    edBranch: TcxButtonEdit;
    cxLabel8: TcxLabel;
    BranchGuides: TdsdGuides;
    ceArea: TcxButtonEdit;
    cxLabel20: TcxLabel;
    ceRetail: TcxButtonEdit;
    cxLabel6: TcxLabel;
    AreaGuides: TdsdGuides;
    RetailGuides: TdsdGuides;
    cxLabel9: TcxLabel;
    ñåTradeMark: TcxButtonEdit;
    TradeMarkGuides: TdsdGuides;
    cbTradeMark: TcxCheckBox;
    bbTradeMark: TdxBarControlContainerItem;
    Sale_Summ_10200: TcxGridDBColumn;
    Sale_Summ_10300: TcxGridDBColumn;
    Sale_Amount_10500_Weight: TcxGridDBColumn;
    Sale_Amount_40200_Weight: TcxGridDBColumn;
    Return_Amount_40200_Weight: TcxGridDBColumn;
    Sale_SummCost_10500: TcxGridDBColumn;
    Sale_SummCost_40200: TcxGridDBColumn;
    Return_SummCost_40200: TcxGridDBColumn;
    Return_Summ_10300: TcxGridDBColumn;
    GoodsGroupAnalystName: TcxGridDBColumn;
    clContractTagGroupName: TcxGridDBColumn;
    Address: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_GoodsMI_SaleReturnInForm);

end.
