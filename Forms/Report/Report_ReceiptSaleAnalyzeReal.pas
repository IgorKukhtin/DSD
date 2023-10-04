unit Report_ReceiptSaleAnalyzeReal;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit, Vcl.Grids, Vcl.DBGrids, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCheckBox,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TReport_ReceiptSaleAnalyzeRealForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    edFromUnit: TcxButtonEdit;
    FromUnitGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    edToUnit: TcxButtonEdit;
    ToUnitGuides: TdsdGuides;
    colGoodsGroupNameFull: TcxGridDBColumn;
    cxLabel11: TcxLabel;
    edPriceList_1: TcxButtonEdit;
    PriceList_1_Guides: TdsdGuides;
    cxLabel6: TcxLabel;
    edPriceList_2: TcxButtonEdit;
    cxLabel7: TcxLabel;
    edPriceList_3: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edPriceList_sale: TcxButtonEdit;
    PriceList_2_Guides: TdsdGuides;
    PriceList_3_Guides: TdsdGuides;
    PriceList_sale_Guides: TdsdGuides;
    cxGridLevel1: TcxGridLevel;
    ChildView: TcxGridDBTableView;
    clReceiptid: TcxGridDBColumn;
    AmountChild: TcxGridDBColumn;
    clGoodsCode: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    clPrice1: TcxGridDBColumn;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    ChildViewAddOn: TdsdDBViewAddOn;
    clPrice2: TcxGridDBColumn;
    clPrice3: TcxGridDBColumn;
    Summ1: TcxGridDBColumn;
    Summ2: TcxGridDBColumn;
    Summ3: TcxGridDBColumn;
    SummIn_sale: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Amount_Weight: TcxGridDBColumn;
    OperCount_Weight_sale: TcxGridDBColumn;
    Price_in_sale: TcxGridDBColumn;
    GroupNumber: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    MeasureNameChild: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    Color_calc: TcxGridDBColumn;
    Receiptid: TcxGridDBColumn;
    isStart: TcxGridDBColumn;
    Amount_start: TcxGridDBColumn;
    Summ1_Start: TcxGridDBColumn;
    Summ2_Start: TcxGridDBColumn;
    Summ3_Start: TcxGridDBColumn;
    ReceiptCode: TcxGridDBColumn;
    ReceiptCode_user: TcxGridDBColumn;
    Price1_cost: TcxGridDBColumn;
    Price2_cost: TcxGridDBColumn;
    Price3_cost: TcxGridDBColumn;
    SummOut_PriceList_sale: TcxGridDBColumn;
    Price_out_pl_sale: TcxGridDBColumn;
    SummOut_sale: TcxGridDBColumn;
    Price_out_sale: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    actPrint_Real: TdsdPrintAction;
    bbPrint_Real: TdxBarButton;
    Summ_sale: TcxGridDBColumn;
    SummPrice1_sale: TcxGridDBColumn;
    SummPrice2_sale: TcxGridDBColumn;
    SummPrice3_sale: TcxGridDBColumn;
    Tax_Summ_sale: TcxGridDBColumn;
    Tax_SummOut_sale: TcxGridDBColumn;
    Tax_return: TcxGridDBColumn;
    OperCount_sh_return: TcxGridDBColumn;
    OperCount_sh_sale: TcxGridDBColumn;
    cbGoodsKind: TcxCheckBox;
    bbGoodsKind: TdxBarControlContainerItem;
    actPrint_Calc: TdsdPrintAction;
    actPrint_CalcPrice: TdsdPrintAction;
    bbPrint_Calc: TdxBarButton;
    bbPrint_CalcPrice: TdxBarButton;
    actPrint_DiffPrice: TdsdPrintAction;
    bbPrint_DiffPrice: TdxBarButton;
    SummCost1_sale: TcxGridDBColumn;
    SummCost2_sale: TcxGridDBColumn;
    SummCost3_sale: TcxGridDBColumn;
    actPrint_Calc_PriceList: TdsdPrintAction;
    bbPrint_Calc_PriceList: TdxBarButton;
    actPrint_DiffPriceIn: TdsdPrintAction;
    bbPrint_DiffPriceIn: TdxBarButton;
    SummCost4_sale: TcxGridDBColumn;
    Price4_cost: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actPrint_Calc_PriceListExcel: TdsdPrintAction;
    bbPrint_Calc_PriceListExcel: TdxBarButton;
    actRefreshStart: TdsdDataSetRefresh;
    spGetParams: TdsdStoredProc;
    GoodsCode_isCost: TcxGridDBColumn;
    GoodsName_isCost: TcxGridDBColumn;
    actPrint_Profit: TdsdPrintAction;
    bbPrint_Profit: TdxBarButton;
    Profit: TcxGridDBColumn;
    Color_Profit: TcxGridDBColumn;
    cxLabel9: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    cbExclude: TcxCheckBox;
    spGet_Juridical: TdsdStoredProc;
    cxLabel10: TcxLabel;
    edPriceList_5: TcxButtonEdit;
    cxLabel12: TcxLabel;
    edPriceList_6: TcxButtonEdit;
    GuidesPriceList_6: TdsdGuides;
    GuidesPriceList_5: TdsdGuides;
    actPrint_CalcPrice5: TdsdPrintAction;
    actPrint_CalcPrice6: TdsdPrintAction;
    bbPrint_CalcPrice5: TdxBarButton;
    bbPrint_CalcPrice6: TdxBarButton;
    Koef1_bon: TcxGridDBColumn;
    Koef2_bon: TcxGridDBColumn;
    Koef3_bon: TcxGridDBColumn;
    Price1_bon: TcxGridDBColumn;
    Price2_bon: TcxGridDBColumn;
    Price3_bon: TcxGridDBColumn;
    Summ1_bon: TcxGridDBColumn;
    Summ2_bon: TcxGridDBColumn;
    Summ3_bon: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_ReceiptSaleAnalyzeRealForm)


end.
