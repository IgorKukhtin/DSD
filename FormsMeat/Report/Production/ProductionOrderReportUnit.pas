unit ProductionOrderReportUnit;

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
  dsdGuides, cxButtonEdit;

type
  TProductionOrderReportForm = class(TAncestorReportForm)
    GuidesUnit: TdsdGuides;
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    colCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colGoodsKindName: TcxGridDBColumn;
    colGoodsGroupName: TcxGridDBColumn;
    colMeasureName: TcxGridDBColumn;
    colMiddleOrderSumm: TcxGridDBColumn;
    colRemains: TcxGridDBColumn;
    colRemainsInDays: TcxGridDBColumn;
    colNotShippedOrder: TcxGridDBColumn;
    colTodayOrder: TcxGridDBColumn;
    cxGridDBTableViewColumn11: TcxGridDBColumn;
    cxGridDBTableViewColumn12: TcxGridDBColumn;
    cxGridDBTableViewColumn13: TcxGridDBColumn;
    cxGridDBTableViewColumn14: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass (TProductionOrderReportForm);

end.
