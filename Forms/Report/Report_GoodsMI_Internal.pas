unit Report_GoodsMI_Internal;

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
  TReport_GoodsMI_InternalForm = class(TAncestorReportForm)
    TradeMarkName: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    SummOut_branch: TcxGridDBColumn;
    AmountOut_Weight: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    AmountOut_Sh: TcxGridDBColumn;
    edInDescName: TcxTextEdit;
    GoodsKindName: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edTo: TcxButtonEdit;
    ToGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    edFrom: TcxButtonEdit;
    FromGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    edPaidKind: TcxButtonEdit;
    PaidKindGuides: TdsdGuides;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    PriceOut_zavod: TcxGridDBColumn;
    PriceIn_zavod: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    PriceOut_branch: TcxGridDBColumn;
    PriceIn_branch: TcxGridDBColumn;
    LocationCode: TcxGridDBColumn;
    LocationName: TcxGridDBColumn;
    LocationCode_by: TcxGridDBColumn;
    LocationName_by: TcxGridDBColumn;
    ArticleLossCode: TcxGridDBColumn;
    ArticleLossName: TcxGridDBColumn;
    ProfitLossName_All: TcxGridDBColumn;
    ProfitLossGroupName: TcxGridDBColumn;
    ProfitLossDirectionName: TcxGridDBColumn;
    ProfitLossName: TcxGridDBColumn;
    ProfitLossCode: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    cbMO_all: TcxCheckBox;
    PartionGoods: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    cbLocation: TcxCheckBox;
    cbGoodsKind: TcxCheckBox;
    cbPartionGoods: TcxCheckBox;
    bbLocation: TdxBarControlContainerItem;
    bbGoodsKind: TdxBarControlContainerItem;
    bbPartionGoods: TdxBarControlContainerItem;
    AmountOut: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    cxLabel7: TcxLabel;
    edPriceList: TcxButtonEdit;
    PriceListGuides: TdsdGuides;
    Price_PriceList: TcxGridDBColumn;
    SummOut_PriceList: TcxGridDBColumn;
    LocationItemName: TcxGridDBColumn;
    LocationItemName_by: TcxGridDBColumn;
    Summ_ProfitLoss: TcxGridDBColumn;
    actPrintArticleLoss: TdsdPrintAction;
    bbPrintArticleLoss: TdxBarButton;
    Amount_Send_pl: TcxGridDBColumn;
    cbComment: TcxCheckBox;
    BranchCode_from: TcxGridDBColumn;
    BranchName_from: TcxGridDBColumn;
    UnitCode_from: TcxGridDBColumn;
    UnitName_from: TcxGridDBColumn;
    PositionName_from: TcxGridDBColumn;
    BranchCode_to: TcxGridDBColumn;
    BranchName_to: TcxGridDBColumn;
    UnitCode_to: TcxGridDBColumn;
    UnitName_to: TcxGridDBColumn;
    PositionName_to: TcxGridDBColumn;
    actPrintComment: TdsdPrintAction;
    bbPrintComment: TdxBarButton;
    actPrintArticleLossGroup: TdsdPrintAction;
    bbPrintArticleLossGroup: TdxBarButton;
    Summ_ProfitLoss_loss: TcxGridDBColumn;
    Summ_ProfitLoss_send: TcxGridDBColumn;
    cbSubjectDoc: TcxCheckBox;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    actPrintArticleLossPrice: TdsdPrintAction;
    bbPrintArticleLossPrice: TdxBarButton;
    cbDateDoc: TcxCheckBox;
    cbInvnumber: TcxCheckBox;
    DayOfWeekName: TcxGridDBColumn;
    myCount: TcxGridDBColumn;
    Date_Insert: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_GoodsMI_InternalForm);

end.
