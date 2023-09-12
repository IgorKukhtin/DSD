unit Report_Send_PersonalGroup;

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
  TReport_Send_PersonalGroupForm = class(TAncestorReportForm)
    GoodsGroupName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    CountPack: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GuidesGoodsGroup: TdsdGuides;
    FormParams: TdsdFormParams;
    AmountOut: TcxGridDBColumn;
    CountPack_out: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    isError: TcxGridDBColumn;
    CountPack_in: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    GuidesUnitTo: TdsdGuides;
    edUnitTo: TcxButtonEdit;
    Amount: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    actPrint_Real: TdsdPrintAction;
    bbPrint_Real: TdxBarButton;
    bbPrint: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    cxLabel8: TcxLabel;
    edUnitFrom: TcxButtonEdit;
    GuidesUnitFrom: TdsdGuides;
    bbGoods: TdxBarControlContainerItem;
    bbcbTradeMark: TdxBarControlContainerItem;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    bbPartionGoods: TdxBarControlContainerItem;
    actPrint: TdsdPrintAction;
    AmountHour: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    bbcbSubjectDoc: TdxBarControlContainerItem;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    cbIsDays: TcxCheckBox;
    cxLabel5: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    cbisGoods: TcxCheckBox;
    InvNumber: TcxGridDBColumn;
    cbisMovement: TcxCheckBox;
    actOpenForm: TdsdOpenForm;
    actMovementForm: TdsdExecStoredProc;
    macOpenDocument: TMultiAction;
    getMovementForm: TdsdStoredProc;
    bbOpenDocument: TdxBarButton;
    actRefreshMovement: TdsdDataSetRefresh;
    actRefreshGoods: TdsdDataSetRefresh;
    actRefreshDay: TdsdDataSetRefresh;
    GuidesModelService: TdsdGuides;
    cxLabel6: TcxLabel;
    edModelService: TcxButtonEdit;
    cxLabel7: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_Send_PersonalGroupForm);

end.
