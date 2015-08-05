unit Report_GoodsMI;

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
  TReport_GoodsMIForm = class(TAncestorReportForm)
    clTradeMarkName: TcxGridDBColumn;
    clGoodsGroupName: TcxGridDBColumn;
    clGoodsCode: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    OperCount_Partner: TcxGridDBColumn;
    OperCount_real: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    OperCount_Change_110000_A: TcxGridDBColumn;
    edInDescName: TcxTextEdit;
    OperCount_110000_P: TcxGridDBColumn;
    OperCount_Change_real: TcxGridDBColumn;
    clGoodsKindName: TcxGridDBColumn;
    OperCount_Partner_110000_A: TcxGridDBColumn;
    OperCount_Change_110000_P: TcxGridDBColumn;
    OperCount_110000_A: TcxGridDBColumn;
    clMeasureName: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    UnitGuides: TdsdGuides;
    edUnit: TcxButtonEdit;
    cxLabel6: TcxLabel;
    edJuridical: TcxButtonEdit;
    cxLabel7: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edPaidKind: TcxButtonEdit;
    InfoMoneyGuides: TdsdGuides;
    PaidKindGuides: TdsdGuides;
    JuridicalGuides: TdsdGuides;
    OperCount: TcxGridDBColumn;
    OperCount_40200: TcxGridDBColumn;
    OperCount_Change: TcxGridDBColumn;
    OperCount_40200_110000_A: TcxGridDBColumn;
    OperCount_40200_110000_P: TcxGridDBColumn;
    OperCount_40200_real: TcxGridDBColumn;
    OperCount_Loss: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrintByGoods: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    cxLabel8: TcxLabel;
    edUnitGroup: TcxButtonEdit;
    GuidesUnitGroup: TdsdGuides;
    OperCount_Partner_real: TcxGridDBColumn;
    OperCount_Partner_110000_P: TcxGridDBColumn;
    SummIn_Loss: TcxGridDBColumn;
    SummIn_Loss_zavod: TcxGridDBColumn;
    SummIn_branch_real: TcxGridDBColumn;
    SummIn_zavod_real: TcxGridDBColumn;
    SummIn_110000_A: TcxGridDBColumn;
    SummIn_110000_P: TcxGridDBColumn;
    SummIn_branch: TcxGridDBColumn;
    SummIn_zavod: TcxGridDBColumn;
    SummIn_Change_branch: TcxGridDBColumn;
    SummIn_Change_zavod: TcxGridDBColumn;
    SummIn_Change_110000_A: TcxGridDBColumn;
    SummIn_Change_110000_P: TcxGridDBColumn;
    SummIn_Change_branch_real: TcxGridDBColumn;
    SummIn_Change_zavod_real: TcxGridDBColumn;
    SummIn_40200_branch: TcxGridDBColumn;
    SummIn_40200_zavod: TcxGridDBColumn;
    SummIn_40200_110000_A: TcxGridDBColumn;
    SummIn_40200_110000_P: TcxGridDBColumn;
    SummIn_40200_branch_real: TcxGridDBColumn;
    SummIn_40200_zavod_real: TcxGridDBColumn;
    SummOut_PriceList: TcxGridDBColumn;
    SummOut_PriceList_110000_A: TcxGridDBColumn;
    SummOut_PriceList_110000_P: TcxGridDBColumn;
    SummOut_PriceList_real: TcxGridDBColumn;
    SummOut_Diff: TcxGridDBColumn;
    SummOut_Diff_110000_A: TcxGridDBColumn;
    SummOut_Diff_110000_P: TcxGridDBColumn;
    SummOut_Diff_real: TcxGridDBColumn;
    SummOut_Change: TcxGridDBColumn;
    SummOut_Change_110000_A: TcxGridDBColumn;
    SummOut_Change_110000_P: TcxGridDBColumn;
    SummOut_Change_real: TcxGridDBColumn;
    SummOut_Partner: TcxGridDBColumn;
    SummOut_Partner_110000_A: TcxGridDBColumn;
    SummOut_Partner_110000_P: TcxGridDBColumn;
    SummOut_Partner_real: TcxGridDBColumn;
    SummIn_Partner_branch: TcxGridDBColumn;
    SummIn_Partner_zavod: TcxGridDBColumn;
    SummIn_Partner_A: TcxGridDBColumn;
    SummIn_Partner_P: TcxGridDBColumn;
    SummIn_Partner_branch_real: TcxGridDBColumn;
    SummIn_Partner_zavod_real: TcxGridDBColumn;
    SummProfit_branch: TcxGridDBColumn;
    SummProfit_zavod: TcxGridDBColumn;
    PriceIn_branch: TcxGridDBColumn;
    PriceIn_zavod: TcxGridDBColumn;
    PriceOut_Partner: TcxGridDBColumn;
    Tax_branch: TcxGridDBColumn;
    Tax_zavod: TcxGridDBColumn;
    PriceList_Partner: TcxGridDBColumn;
    BusinessName: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    cbPartner: TcxCheckBox;
    cbTradeMark: TcxCheckBox;
    cbGoods: TcxCheckBox;
    cbGoodsKind: TcxCheckBox;
    bbGoods: TdxBarControlContainerItem;
    bbPartner: TdxBarControlContainerItem;
    bb: TdxBarControlContainerItem;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    cbPartionGoods: TcxCheckBox;
    bbPartionGoods: TdxBarControlContainerItem;
    PartionGoods: TcxGridDBColumn;
    actPrint2: TdsdPrintAction;
    OperCount_total: TcxGridDBColumn;
    SummIn_branch_total: TcxGridDBColumn;
    SummIn_zavod_total: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_GoodsMIForm);

end.
