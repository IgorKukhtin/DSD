unit Report_GoodsMI_ProductionUnion;

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
  TReport_GoodsMI_ProductionUnionForm = class(TAncestorReportForm)
    GoodsGroupName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    HeadCount: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    Amount: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    PartionGoods: TcxGridDBColumn;
    ChildGoodsGroupName: TcxGridDBColumn;
    ChildGoodsCode: TcxGridDBColumn;
    ChildGoodsName: TcxGridDBColumn;
    ChildAmount: TcxGridDBColumn;
    ChildSumm: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    ChildPrice: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edFromGroup: TcxButtonEdit;
    cxLabel5: TcxLabel;
    FromGroupGuides: TdsdGuides;
    cxLabel7: TcxLabel;
    edGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    edToGroup: TcxButtonEdit;
    ToGroupGuides: TdsdGuides;
    cbIsMovement: TcxCheckBox;
    cbIsPartion: TcxCheckBox;
    cxLabel6: TcxLabel;
    cxLabel8: TcxLabel;
    edChildGoods: TcxButtonEdit;
    edChildGoodsGroup: TcxButtonEdit;
    ChildGoodsGroupGuides: TdsdGuides;
    ChildGoodsGuides: TdsdGuides;
    ChildPartionGoods: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    GoodsKindName: TcxGridDBColumn;
    ChildGoodsKindName: TcxGridDBColumn;
    MainPrice: TcxGridDBColumn;
    isPeresort: TcxGridDBColumn;
    DocumentKindName: TcxGridDBColumn;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    DescName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    ChildComment: TcxGridDBColumn;
    cbPeresort: TcxCheckBox;
    UnitName_from: TcxGridDBColumn;
    UnitName_to: TcxGridDBColumn;
    cbisUnit: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_GoodsMI_ProductionUnionForm);

end.
