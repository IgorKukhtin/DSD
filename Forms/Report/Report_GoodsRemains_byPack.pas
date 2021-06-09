unit Report_GoodsRemains_byPack;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxCheckBox;

type
  TReport_GoodsRemains_byPackForm = class(TAncestorReportForm)
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    MeasureName: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    GuidesUnit: TdsdGuides;
    edUnit: TcxButtonEdit;
    actPrint: TdsdPrintAction;
    actPrintByGoods: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrintByGoods: TdxBarButton;
    RemainsStart: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    GoodsCode_basis: TcxGridDBColumn;
    GoodsName_basis: TcxGridDBColumn;
    RemainsEnd: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    Weight: TcxGridDBColumn;
    actRefreshData: TdsdDataSetRefresh;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    actRefreshDataPersonalGroup: TdsdDataSetRefresh;
    actRefreshMov: TdsdDataSetRefresh;
    cxLabel5: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    cxLabel7: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoodsGroup: TdsdGuides;
    GuidesGoods: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_GoodsRemains_byPackForm);

end.
