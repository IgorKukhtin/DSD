unit Report_GoodsMI_ProductionUnionMD;

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
  TReport_GoodsMI_ProductionUnionMDForm = class(TAncestorReportForm)
    clGoodsGroupName: TcxGridDBColumn;
    clGoodsCode: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    clSumm: TcxGridDBColumn;
    clHeadCount: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    clAmount: TcxGridDBColumn;
    clInvNumber: TcxGridDBColumn;
    clOperDate: TcxGridDBColumn;
    clPartionGoods: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    cxLabel3: TcxLabel;
    edFromGroup: TcxButtonEdit;
    cxLabel5: TcxLabel;
    FromGroupGuides: TdsdGuides;
    cxLabel7: TcxLabel;
    edGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    edToGroup: TcxButtonEdit;
    ToGroupGuides: TdsdGuides;
    cbGroupMovement: TcxCheckBox;
    cbGroupPartion: TcxCheckBox;
    cxLabel6: TcxLabel;
    cxLabel8: TcxLabel;
    edChildGoods: TcxButtonEdit;
    edChildGoodsGroup: TcxButtonEdit;
    ChildGoodsGroupGuides: TdsdGuides;
    ChildGoodsGuides: TdsdGuides;
    cxGridDetail: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    ChildPartionGoods: TcxGridDBColumn;
    ChildGoodsGroupName: TcxGridDBColumn;
    ChildGoodsCode: TcxGridDBColumn;
    ChildGoodsName: TcxGridDBColumn;
    ChildAmount: TcxGridDBColumn;
    ChildSumm: TcxGridDBColumn;
    ChildPrice: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    UnitName: TcxGridDBColumn;
    GoodsKindChildName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    InfoMoneyDetailName: TcxGridDBColumn;
    ReceiptName: TcxGridDBColumn;
    InfoMoneyDetailChildName: TcxGridDBColumn;
    cbGroupInfoMoney: TcxCheckBox;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_GoodsMI_ProductionUnionMDForm);

end.
