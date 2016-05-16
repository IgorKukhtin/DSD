unit Report_Goods_ReturnInBySale;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxImageComboBox;

type
  TReport_Goods_ReturnInBySaleForm = class(TAncestorReportForm)
    clGoodsCode: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    clAmount: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    clAmountPartner: TcxGridDBColumn;
    clGoodsKindName: TcxGridDBColumn;
    clMeasureName: TcxGridDBColumn;
    cxLabel7: TcxLabel;
    cePartner: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    PaidKindGuides: TdsdGuides;
    clUnitName: TcxGridDBColumn;
    clPartnerCode: TcxGridDBColumn;
    clJuridicalCode: TcxGridDBColumn;
    cxLabel8: TcxLabel;
    edGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    cxLabel10: TcxLabel;
    edContract: TcxButtonEdit;
    ContractGuides: TdsdGuides;
    cxLabel11: TcxLabel;
    edGoodsKind: TcxButtonEdit;
    GoodsKindGuides: TdsdGuides;
    cxLabel25: TcxLabel;
    edSale: TcxButtonEdit;
    SaleChoiceGuides: TdsdGuides;
    cxLabel9: TcxLabel;
    cePrice: TcxCurrencyEdit;
    clStatusCode: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_Goods_ReturnInBySaleForm);

end.
