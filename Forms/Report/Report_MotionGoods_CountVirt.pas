unit Report_MotionGoods_CountVirt;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon,
  cxCheckBox, cxImageComboBox;

type
  TReport_MotionGoods_CountVirtForm = class(TAncestorReportForm)
    GoodsGroupName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    CountItsOut_Weight: TcxGridDBColumn;
    CountStart_Weight: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GuidesGoodsGroup: TdsdGuides;
    FormParams: TdsdFormParams;
    CountStart: TcxGridDBColumn;
    CountSendIn_Weight: TcxGridDBColumn;
    CountSendIn: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    CountEnd: TcxGridDBColumn;
    CountEnd_Weight: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    GuidesUnit: TdsdGuides;
    edUnit: TcxButtonEdit;
    UnitName: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    cxLabel8: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    CountSendOut_Weight: TcxGridDBColumn;
    CountProductionIn_Weight: TcxGridDBColumn;
    CountSendOut: TcxGridDBColumn;
    CountProductionIn: TcxGridDBColumn;
    CountItsIn: TcxGridDBColumn;
    CountItsOut: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    CountItsIn_Weight: TcxGridDBColumn;
    bb: TdxBarButton;
    bbErased: TdxBarControlContainerItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_MotionGoods_CountVirtForm);

end.
