unit Report_Goods_byMovement;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus;

type
  TReport_Goods_byMovementForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    cxLabel3: TcxLabel;
    UnitGuides: TdsdGuides;
    edUnit: TcxButtonEdit;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    cxLabel5: TcxLabel;
    edUnitGroup: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edGoodsGroupGP: TcxButtonEdit;
    GoodsGroupGPGuides: TdsdGuides;
    UnitGroupGuides: TdsdGuides;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    ReturnAmount: TcxGridDBColumn;
    ReturnAmountPartner: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    AmountPartner: TcxGridDBColumn;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    ChildDBViewAddOn: TdsdDBViewAddOn;
    actPrintGp: TdsdPrintAction;
    bbPrintGp: TdxBarButton;
    isTop: TcxGridDBColumn;
    chisTop: TcxGridDBColumn;
    bb: TdxBarButton;
    spGetParams: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    ColorReport: TcxGridDBColumn;
    chColorReport: TcxGridDBColumn;
    NumLine: TcxGridDBColumn;
    chNumLine: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_Goods_byMovementForm);

end.
