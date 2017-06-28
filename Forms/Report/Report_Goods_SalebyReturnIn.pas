unit Report_Goods_SalebyReturnIn;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
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
  TReport_Goods_SalebyReturnInForm = class(TAncestorReportForm)
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edRetail: TcxButtonEdit;
    GuidesRetail: TdsdGuides;
    FormParams: TdsdFormParams;
    AmountReturn: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    AmountRem: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edBranch: TcxButtonEdit;
    cxLabel6: TcxLabel;
    edJuridical: TcxButtonEdit;
    cxLabel7: TcxLabel;
    cePartner: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    PaidKindGuides: TdsdGuides;
    JuridicalGuides: TdsdGuides;
    UnitName: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    PartnerCode: TcxGridDBColumn;
    JuridicalCode: TcxGridDBColumn;
    cxLabel8: TcxLabel;
    edGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    GuidesBranch: TdsdGuides;
    cxLabel9: TcxLabel;
    cePrice: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    edContract: TcxButtonEdit;
    ContractGuides: TdsdGuides;
    cxLabel11: TcxLabel;
    edGoodsKind: TcxButtonEdit;
    GoodsKindGuides: TdsdGuides;
    bbChoiceGuides: TdxBarButton;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    MovementDescName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_Goods_SalebyReturnInForm);

end.
