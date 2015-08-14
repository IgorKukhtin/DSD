unit Report_GoodsMI_IncomeByPartner;

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
  TReport_GoodsMI_IncomeByPartnerForm = class(TAncestorReportForm)
    clTradeMarkName: TcxGridDBColumn;
    clGoodsGroupName: TcxGridDBColumn;
    clGoodsCode: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    clAmountPartner_Sh: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    clAmountPartner_Weight: TcxGridDBColumn;
    clJuridicalName: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    clPaidKindName: TcxGridDBColumn;
    edInDescName: TcxTextEdit;
    clAmount_Weight: TcxGridDBColumn;
    clAmount_Sh: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    clFuelKindName: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    PartnerId: TcxGridDBColumn;
    bbPrint: TdxBarButton;
    actPrintByGoods: TdsdPrintAction;
    bbPrintByGoods: TdxBarButton;
    cxLabel5: TcxLabel;
    edUnitGroup: TcxButtonEdit;
    GuidesUnitGroup: TdsdGuides;
    cxLabel6: TcxLabel;
    edUnit: TcxButtonEdit;
    UnitGuides: TdsdGuides;
    cxLabel7: TcxLabel;
    edPaidKind: TcxButtonEdit;
    PaidKindGuides: TdsdGuides;
    ExecuteDialog: TExecuteDialog;
    bbDialog: TdxBarButton;
    cxLabel8: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    InfoMoneyGuides: TdsdGuides;
    GoodsGroupNameFull: TcxGridDBColumn;
    PartnerCode: TcxGridDBColumn;
    PartionGoods: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    PricePartner: TcxGridDBColumn;
    AmountDiff_Weight: TcxGridDBColumn;
    AmountDiff_Sh: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    LocationCode: TcxGridDBColumn;
    LocationName: TcxGridDBColumn;
    Summ_ProfitLoss: TcxGridDBColumn;
    cbGoodsKind: TcxCheckBox;
    cbPartionGoods: TcxCheckBox;
    bbGoodsKind: TdxBarControlContainerItem;
    bbPartionGoods: TdxBarControlContainerItem;
    AmountPartner: TcxGridDBColumn;
    cbPartner: TcxCheckBox;
    bbPartner: TdxBarControlContainerItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_GoodsMI_IncomeByPartnerForm);

end.
