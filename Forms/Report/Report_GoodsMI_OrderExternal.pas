unit Report_GoodsMI_OrderExternal;

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
  TReport_GoodsMI_OrderExternalForm = class(TAncestorReportForm)
    GoodsGroupName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    AmountSumm1: TcxGridDBColumn;
    Amount_Weight1: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    Amount_Sh1: TcxGridDBColumn;
    RouteSortingName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    AmountSummTotal: TcxGridDBColumn;
    AmountSumm2: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    Amount_Weight2: TcxGridDBColumn;
    Amount_Sh2: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    actPrint_byByer: TdsdPrintAction;
    bbPrint: TdxBarButton;
    RouteName: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    bbPrint_byPack: TdxBarButton;
    cxLabel13: TcxLabel;
    edRouteSorting: TcxButtonEdit;
    cxLabel7: TcxLabel;
    edRoute: TcxButtonEdit;
    GuidesRouteSorting: TdsdGuides;
    GuidesRoute: TdsdGuides;
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    GuidesFrom: TdsdGuides;
    edTo: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edByDoc: TcxCheckBox;
    GuidesTo: TdsdGuides;
    Amount_Weight_Itog: TcxGridDBColumn;
    Amount_Sh_Itog: TcxGridDBColumn;
    Amount_Weight_Dozakaz: TcxGridDBColumn;
    Amount_Sh_Dozakaz: TcxGridDBColumn;
    AmountSumm_Dozakaz: TcxGridDBColumn;
    InvNumberContract: TcxGridDBColumn;
    Amount12: TcxGridDBColumn;
    actPrint_byPack: TdsdPrintAction;
    actPrint_byProduction: TdsdPrintAction;
    bbPrint_byProduction: TdxBarButton;
    actPrint_byType: TdsdPrintAction;
    bbPrint_byType: TdxBarButton;
    actPrint_byRoute: TdsdPrintAction;
    bbPrint_byRoute: TdxBarButton;
    Amount_WeightSK: TcxGridDBColumn;
    FromCode: TcxGridDBColumn;
    RouteSortingCode: TcxGridDBColumn;
    actPrint_byRouteItog: TdsdPrintAction;
    bbPrint_byRouteItog: TdxBarButton;
    InfoMoneyName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_GoodsMI_OrderExternalForm);

end.
