unit Report_GoodsMI_Package;

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
  TReport_GoodsMI_PackageForm = class(TAncestorReportForm)
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    Amount_Send_in: TcxGridDBColumn;
    Amount_Production: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    GuidesUnit: TdsdGuides;
    edUnit: TcxButtonEdit;
    Weight_diff: TcxGridDBColumn;
    Amount_Send_out: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    actPrintByGoods: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrintByGoods: TdxBarButton;
    CountPackage: TcxGridDBColumn;
    WeightPackage: TcxGridDBColumn;
    Weight_Send_out: TcxGridDBColumn;
    Weight_Send_in: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    Weight_Production: TcxGridDBColumn;
    GoodsCode_basis: TcxGridDBColumn;
    GoodsName_basis: TcxGridDBColumn;
    ReceiptCode_code: TcxGridDBColumn;
    ReceiptCode: TcxGridDBColumn;
    ReceiptName: TcxGridDBColumn;
    WeightPackage_one: TcxGridDBColumn;
    CountPackage_calc: TcxGridDBColumn;
    WeightPackage_calc: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    WeightTotal: TcxGridDBColumn;
    cbisDate: TcxCheckBox;
    actRefreshData: TdsdDataSetRefresh;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    cbisPersonalGroup: TcxCheckBox;
    actRefreshDataPersonalGroup: TdsdDataSetRefresh;
    PersonalGroupName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    MovementDescName: TcxGridDBColumn;
    cbMovement: TcxCheckBox;
    actRefreshMov: TdsdDataSetRefresh;
    cbUnComplete: TcxCheckBox;
    actRefreshUnComplete: TdsdDataSetRefresh;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_GoodsMI_PackageForm);

end.
