unit Report_RemainGoods;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxButtonEdit, dsdGuides, cxCurrencyEdit, dxBarBuiltInMenu, cxNavigator,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
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
  TReport_GoodsRemainsForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    actOpenPartionReport: TdsdOpenForm;
    bbGoodsPartyReport: TdxBarButton;
    NDS: TcxGridDBColumn;
    actRefreshPartionPrice: TdsdDataSetRefresh;
    actRefreshIsPartion: TdsdDataSetRefresh;
    cbPartion: TcxCheckBox;
    cbPartionPrice: TcxCheckBox;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    MP_JuridicalName: TcxGridDBColumn;
    MinPriceOnDate: TcxGridDBColumn;
    MP_Summa: TcxGridDBColumn;
    MinPriceOnDateVAT: TcxGridDBColumn;
    MP_SummaVAT: TcxGridDBColumn;
    ContainerId: TcxGridDBColumn;
    actRefreshJuridical: TdsdDataSetRefresh;
    cbJuridical: TcxCheckBox;
    isSP: TcxGridDBColumn;
    cbVendorminPrices: TcxCheckBox;
    actOverdueChange: TdsdOpenForm;
    dxBarButton1: TdxBarButton;
    MakerName: TcxGridDBColumn;
    BarCode: TcxGridDBColumn;
    MorionCode: TcxGridDBColumn;
    BadmCode: TcxGridDBColumn;
    OptimaCode: TcxGridDBColumn;
    AccommodationName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_GoodsRemainsForm);

end.
