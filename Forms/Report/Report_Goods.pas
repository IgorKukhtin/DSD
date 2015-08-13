unit Report_Goods;

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
  TReport_GoodsForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    edGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    clLocationDescName: TcxGridDBColumn;
    clLocationName: TcxGridDBColumn;
    clGoodsCode: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    clMovementDescName: TcxGridDBColumn;
    clSummStart: TcxGridDBColumn;
    clSummIn: TcxGridDBColumn;
    clSummOut: TcxGridDBColumn;
    clSummEnd: TcxGridDBColumn;
    clInvNumber: TcxGridDBColumn;
    clGoodsKindName: TcxGridDBColumn;
    clOperDate: TcxGridDBColumn;
    clObjectByName: TcxGridDBColumn;
    clOperDatePartner: TcxGridDBColumn;
    clObjectByCode: TcxGridDBColumn;
    clAmountStart: TcxGridDBColumn;
    clPrice: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edLocation: TcxButtonEdit;
    LocationGuides: TdsdGuides;
    clPartionGoods: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    isActive: TcxGridDBColumn;
    ObjectByDescName: TcxGridDBColumn;
    MovementDescName_order: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    MovementId: TcxGridDBColumn;
    isRemains: TcxGridDBColumn;
    GoodsCode_parent: TcxGridDBColumn;
    GoodsName_parent: TcxGridDBColumn;
    GoodsKindName_complete: TcxGridDBColumn;
    GoodsKindName_parent: TcxGridDBColumn;
    Price_end: TcxGridDBColumn;
    Price_partner: TcxGridDBColumn;
    SummPartnerOut: TcxGridDBColumn;
    SummPartnerIn: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edUnitGroup: TcxButtonEdit;
    GuidesUnitGroup: TdsdGuides;
    GoodsGroupGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_GoodsForm);

end.
