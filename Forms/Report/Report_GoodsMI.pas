unit Report_GoodsMI;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TReport_GoodsMIForm = class(TAncestorReportForm)
    TradeMarkName: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    OperCount_Partner: TcxGridDBColumn;
    OperCount_real: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    OperCount_Change_110000_A: TcxGridDBColumn;
    edInDescName: TcxTextEdit;
    OperCount_110000_P: TcxGridDBColumn;
    OperCount_Change_real: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    OperCount_Partner_110000_A: TcxGridDBColumn;
    OperCount_Change_110000_P: TcxGridDBColumn;
    OperCount_110000_A: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    UnitGuides: TdsdGuides;
    edUnit: TcxButtonEdit;
    cxLabel6: TcxLabel;
    edJuridical: TcxButtonEdit;
    cxLabel7: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edPaidKind: TcxButtonEdit;
    InfoMoneyGuides: TdsdGuides;
    PaidKindGuides: TdsdGuides;
    JuridicalGuides: TdsdGuides;
    OperCount: TcxGridDBColumn;
    OperCount_40200: TcxGridDBColumn;
    OperCount_Change: TcxGridDBColumn;
    OperCount_40200_110000_A: TcxGridDBColumn;
    OperCount_40200_110000_P: TcxGridDBColumn;
    OperCount_40200_real: TcxGridDBColumn;
    OperCount_Loss: TcxGridDBColumn;
    actPrint_Real: TdsdPrintAction;
    bbPrint_Real: TdxBarButton;
    bbPrint: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    cxLabel8: TcxLabel;
    edUnitGroup: TcxButtonEdit;
    GuidesUnitGroup: TdsdGuides;
    OperCount_Partner_real: TcxGridDBColumn;
    OperCount_Partner_110000_P: TcxGridDBColumn;
    SummIn_Loss: TcxGridDBColumn;
    SummIn_Loss_zavod: TcxGridDBColumn;
    SummIn_branch_real: TcxGridDBColumn;
    SummIn_zavod_real: TcxGridDBColumn;
    SummIn_110000_A: TcxGridDBColumn;
    SummIn_110000_P: TcxGridDBColumn;
    SummIn_branch: TcxGridDBColumn;
    SummIn_zavod: TcxGridDBColumn;
    SummIn_Change_branch: TcxGridDBColumn;
    SummIn_Change_zavod: TcxGridDBColumn;
    SummIn_Change_110000_A: TcxGridDBColumn;
    SummIn_Change_110000_P: TcxGridDBColumn;
    SummIn_Change_branch_real: TcxGridDBColumn;
    SummIn_Change_zavod_real: TcxGridDBColumn;
    SummIn_40200_branch: TcxGridDBColumn;
    SummIn_40200_zavod: TcxGridDBColumn;
    SummIn_40200_110000_A: TcxGridDBColumn;
    SummIn_40200_110000_P: TcxGridDBColumn;
    SummIn_40200_branch_real: TcxGridDBColumn;
    SummIn_40200_zavod_real: TcxGridDBColumn;
    SummOut_PriceList: TcxGridDBColumn;
    SummOut_PriceList_110000_A: TcxGridDBColumn;
    SummOut_PriceList_110000_P: TcxGridDBColumn;
    SummOut_PriceList_real: TcxGridDBColumn;
    SummOut_Diff: TcxGridDBColumn;
    SummOut_Diff_110000_A: TcxGridDBColumn;
    SummOut_Diff_110000_P: TcxGridDBColumn;
    SummOut_Diff_real: TcxGridDBColumn;
    SummOut_Change: TcxGridDBColumn;
    SummOut_Change_110000_A: TcxGridDBColumn;
    SummOut_Change_110000_P: TcxGridDBColumn;
    SummOut_Change_real: TcxGridDBColumn;
    SummOut_Partner: TcxGridDBColumn;
    SummOut_Partner_110000_A: TcxGridDBColumn;
    SummOut_Partner_110000_P: TcxGridDBColumn;
    SummOut_Partner_real: TcxGridDBColumn;
    SummIn_Partner_branch: TcxGridDBColumn;
    SummIn_Partner_zavod: TcxGridDBColumn;
    SummIn_Partner_A: TcxGridDBColumn;
    SummIn_Partner_P: TcxGridDBColumn;
    SummIn_Partner_branch_real: TcxGridDBColumn;
    SummIn_Partner_zavod_real: TcxGridDBColumn;
    SummProfit_branch_real: TcxGridDBColumn;
    SummProfit_zavod_real: TcxGridDBColumn;
    PriceIn_branch: TcxGridDBColumn;
    PriceIn_zavod: TcxGridDBColumn;
    PriceOut_Partner: TcxGridDBColumn;
    Tax_branch: TcxGridDBColumn;
    Tax_zavod: TcxGridDBColumn;
    PriceList_Partner: TcxGridDBColumn;
    BusinessName: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    cbPartner: TcxCheckBox;
    cbTradeMark: TcxCheckBox;
    cbGoods: TcxCheckBox;
    cbGoodsKind: TcxCheckBox;
    bbGoods: TdxBarControlContainerItem;
    bbPartner: TdxBarControlContainerItem;
    bbTradeMark: TdxBarControlContainerItem;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    cbPartionGoods: TcxCheckBox;
    bbPartionGoods: TdxBarControlContainerItem;
    PartionGoods: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    OperCount_total: TcxGridDBColumn;
    SummIn_branch_total: TcxGridDBColumn;
    SummIn_zavod_total: TcxGridDBColumn;
    OperCount_sh_Partner_real: TcxGridDBColumn;
    AreaName: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    PartnerTagName: TcxGridDBColumn;
    SummProfit_branch: TcxGridDBColumn;
    SummProfit_zavod: TcxGridDBColumn;
    SummOut_Promo: TcxGridDBColumn;
    SummOut_Promo_110000_A: TcxGridDBColumn;
    SummOut_Promo_110000_P: TcxGridDBColumn;
    SummOut_Promo_real: TcxGridDBColumn;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    cbDate: TcxCheckBox;
    OperDate: TcxGridDBColumn;
    OperDatePartner: TcxGridDBColumn;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    cbReason: TcxCheckBox;
    bbisReason: TdxBarControlContainerItem;
    cbErased: TcxCheckBox;
    bbErased: TdxBarControlContainerItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_GoodsMIForm);

end.
