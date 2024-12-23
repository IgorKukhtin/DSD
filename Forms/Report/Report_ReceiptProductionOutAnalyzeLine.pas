unit Report_ReceiptProductionOutAnalyzeLine;

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
  dxSkinXmas2008Blue, dsdCommon;

type
  TReport_ReceiptProductionOutAnalyzeLineForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    edFromUnit: TcxButtonEdit;
    FromUnitGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    edToUnit: TcxButtonEdit;
    ToUnitGuides: TdsdGuides;
    GoodsGroupNameFull_ch: TcxGridDBColumn;
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
    GoodsId_ch: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    PricePlan1: TcxGridDBColumn;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    ChildViewAddOn: TdsdDBViewAddOn;
    PricePlan2: TcxGridDBColumn;
    PricePlan3: TcxGridDBColumn;
    OperCountIn_ch: TcxGridDBColumn;
    OperCountIn_Weight_ch: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    GoodsKindId: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    PriceIn_ch: TcxGridDBColumn;
    GoodsKindId_ch: TcxGridDBColumn;
    GoodsId: TcxGridDBColumn;
    MasterKey: TcxGridDBColumn;
    PartionGoodsDate_ch: TcxGridDBColumn;
    GoodsKindName_complete_ch: TcxGridDBColumn;
    TaxSumm_ch: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    actPrint_Reserve: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrint_Reserve: TdxBarButton;
    OperSummPlan_real_ch: TcxGridDBColumn;
    GoodsKindName_complete: TcxGridDBColumn;
    PartionGoodsDate: TcxGridDBColumn;
    cbPartionGoods: TcxCheckBox;
    bbPartionGoods: TdxBarControlContainerItem;
    CuterCount: TcxGridDBColumn;
    TaxGP_real: TcxGridDBColumn;
    TaxGP_plan: TcxGridDBColumn;
    OperCount_gp_plan: TcxGridDBColumn;
    actPrint_TaxReal: TdsdPrintAction;
    dxBarButton1: TdxBarButton;
    Price_sale: TcxGridDBColumn;
    OperCount_ReWork: TcxGridDBColumn;
    LossGP_real: TcxGridDBColumn;
    LossGP_plan: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actPrint_fact: TdsdPrintAction;
    bbPrint_fact: TdxBarButton;
    DetailCDS: TClientDataSet;
    DetailDS: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_ReceiptProductionOutAnalyzeLineForm)


end.
