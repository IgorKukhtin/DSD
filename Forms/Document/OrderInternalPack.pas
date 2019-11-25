unit OrderInternalPack;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, cxSplitter,
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
  TOrderInternalPackForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    bbPrintTax: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    bbTax: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrintScan: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    AmountSecond: TcxGridDBColumn;
    spUpdateAmountRemains: TdsdStoredProc;
    spUpdateAmountPartner: TdsdStoredProc;
    spUpdateAmountForecast: TdsdStoredProc;
    actUpdateAmountRemains: TdsdExecStoredProc;
    MultiAmountRemain: TMultiAction;
    edOperDatePartner: TcxDateEdit;
    cxLabel10: TcxLabel;
    cxLabel18: TcxLabel;
    edDayCount: TcxCurrencyEdit;
    edOperDateStart: TcxDateEdit;
    cxLabel19: TcxLabel;
    cxLabel20: TcxLabel;
    edOperDateEnd: TcxDateEdit;
    AmountRemains: TcxGridDBColumn;
    AmountPartner: TcxGridDBColumn;
    AmountForecast: TcxGridDBColumn;
    AmountForecastOrder: TcxGridDBColumn;
    bbMultiAmountRemain: TdxBarButton;
    actUpdateAmountPartner: TdsdExecStoredProc;
    MultiAmountPartner: TMultiAction;
    actUpdateAmountForecast: TdsdExecStoredProc;
    MultiAmountForecast: TMultiAction;
    actUpdateAmountAll: TMultiAction;
    bbMultiAmountPartner: TdxBarButton;
    bbMultiAmountForecast: TdxBarButton;
    bbUpdateAmountAll: TdxBarButton;
    MeasureName: TcxGridDBColumn;
    ReceiptCode_code: TcxGridDBColumn;
    ReceiptName: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    Koeff: TcxGridDBColumn;
    CountForecast: TcxGridDBColumn;
    CountForecastOrder: TcxGridDBColumn;
    CountForecastK: TcxGridDBColumn;
    CountForecastOrderK: TcxGridDBColumn;
    AmountPartnerPrior: TcxGridDBColumn;
    TermProduction: TcxGridDBColumn;
    NormInDays: TcxGridDBColumn;
    StartProductionInDays: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    DayCountForecast: TcxGridDBColumn;
    DayCountForecastOrder: TcxGridDBColumn;
    Color_remains: TcxGridDBColumn;
    GoodsCode_detail: TcxGridDBColumn;
    GoodsName_detail: TcxGridDBColumn;
    GoodsKindName_detail: TcxGridDBColumn;
    MeasureName_detail: TcxGridDBColumn;
    AmountRemains_calc: TcxGridDBColumn;
    AmountPrognoz_calc: TcxGridDBColumn;
    AmountPrognozOrder_calc: TcxGridDBColumn;
    AmountRemains_child: TcxGridDBColumn;
    cxBottomSplitter: TcxSplitter;
    ColorB_AmountPartner: TcxGridDBColumn;
    ColorB_DayCountForecast: TcxGridDBColumn;
    ColorB_AmountPrognoz: TcxGridDBColumn;
    ColorB_const: TcxGridDBColumn;
    Color_remains_calc: TcxGridDBColumn;
    AmountRemainsChild_calc: TcxGridDBColumn;
    Color_remainsChild_calc: TcxGridDBColumn;
    ReceiptCode: TcxGridDBColumn;
    ReceiptCode_code_basis: TcxGridDBColumn;
    AmountSend_sh: TcxGridDBColumn;
    AmountSend_Weight: TcxGridDBColumn;
    Color_send: TcxGridDBColumn;
    Percent_diff: TcxGridDBColumn;
    Color_Percent_diff: TcxGridDBColumn;
    ColorB_Percent_diff: TcxGridDBColumn;
    isPercent_diff: TcxGridDBColumn;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    AmountBaza_sh: TcxGridDBColumn;
    AmountBaza_Weight: TcxGridDBColumn;
    actPrintScan: TdsdPrintAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderInternalPackForm);

end.
