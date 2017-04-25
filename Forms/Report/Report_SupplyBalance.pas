unit Report_SupplyBalance;

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
  TReport_SupplyBalanceForm = class(TAncestorReportForm)
    clGoodsCode: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    Color_RemainsDays: TcxGridDBColumn;
    RemainsStart: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    CountOut_oth: TcxGridDBColumn;
    CountIncome: TcxGridDBColumn;
    RemainsDays: TcxGridDBColumn;
    clGoodsKindName: TcxGridDBColumn;
    CountOnDay: TcxGridDBColumn;
    RemainsEnd: TcxGridDBColumn;
    clMeasureName: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    UnitGuides: TdsdGuides;
    edUnit: TcxButtonEdit;
    CountProductionOut: TcxGridDBColumn;
    ReserveDays: TcxGridDBColumn;
    CountIn_oth: TcxGridDBColumn;
    PlanOrder: TcxGridDBColumn;
    CountOrder: TcxGridDBColumn;
    RemainsDaysWithOrder: TcxGridDBColumn;
    actPrint_Real: TdsdPrintAction;
    bbPrint_Real: TdxBarButton;
    bbPrint: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbGoods: TdxBarControlContainerItem;
    bbPartner: TdxBarControlContainerItem;
    bb: TdxBarControlContainerItem;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    bbPartionGoods: TdxBarControlContainerItem;
    actPrint: TdsdPrintAction;
    CountDays: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    actPrint1: TdsdPrintAction;
    cxLabel5: TcxLabel;
    edJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_SupplyBalanceForm);

end.
