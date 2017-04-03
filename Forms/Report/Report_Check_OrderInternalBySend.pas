unit Report_Check_OrderInternalBySend;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxCheckBox,
  cxImageComboBox;

type
  TReport_Check_OrderInternalBySendForm = class(TAncestorReportForm)
    GoodsGroupName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    GoodsKindName: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    bbPrint: TdxBarButton;
    bbPrint_byPack: TdxBarButton;
    bbPrint_byProduction: TdxBarButton;
    bbPrint_byType: TdxBarButton;
    bbPrint_byRoute: TdxBarButton;
    bbPrint_byRouteItog: TdxBarButton;
    bbPrint_byCross: TdxBarButton;
    HeaderCDS: TClientDataSet;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbPrint_Dozakaz: TdxBarButton;
    OrderAmount: TcxGridDBColumn;
    actisDataAll: TdsdDataSetRefresh;
    cxLabel13: TcxLabel;
    edFrom: TcxButtonEdit;
    cxLabel3: TcxLabel;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    GuidesGoodsGroup: TdsdGuides;
    isUnder: TcxGridDBColumn;
    isOver: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_Check_OrderInternalBySendForm);

end.
