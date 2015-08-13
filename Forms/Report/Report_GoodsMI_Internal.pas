unit Report_GoodsMI_Internal;

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
  TReport_GoodsMI_InternalForm = class(TAncestorReportForm)
    clTradeMarkName: TcxGridDBColumn;
    clGoodsGroupName: TcxGridDBColumn;
    clGoodsCode: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    SummOut_branch: TcxGridDBColumn;
    AmountOut_Weight: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    AmountOut_Sh: TcxGridDBColumn;
    edInDescName: TcxTextEdit;
    clGoodsKindName: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edTo: TcxButtonEdit;
    ToGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    edFrom: TcxButtonEdit;
    FromGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    edPaidKind: TcxButtonEdit;
    PaidKindGuides: TdsdGuides;
    ExecuteDialog: TExecuteDialog;
    bb: TdxBarButton;
    PriceOut_zavod: TcxGridDBColumn;
    PriceIn_zavod: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    PriceOut_branch: TcxGridDBColumn;
    PriceIn_branch: TcxGridDBColumn;
    LocationCode: TcxGridDBColumn;
    LocationName: TcxGridDBColumn;
    LocationCode_by: TcxGridDBColumn;
    LocationName_by: TcxGridDBColumn;
    ArticleLossCode: TcxGridDBColumn;
    ArticleLossName: TcxGridDBColumn;
    ProfitLossName_All: TcxGridDBColumn;
    ProfitLossGroupName: TcxGridDBColumn;
    ProfitLossDirectionName: TcxGridDBColumn;
    ProfitLossName: TcxGridDBColumn;
    ProfitLossCode: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    cbMO_all: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_GoodsMI_InternalForm);

end.
