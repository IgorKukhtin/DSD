unit Report_GoodsTax;

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
  TReport_GoodsTaxForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    edGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    clUnit_infName: TcxGridDBColumn;
    clDirectionName: TcxGridDBColumn;
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
    clPartnerName: TcxGridDBColumn;
    clOperDatePartner: TcxGridDBColumn;
    clPartnerCode: TcxGridDBColumn;
    clAmountPartner: TcxGridDBColumn;
    clOperPrice: TcxGridDBColumn;
    cxGridDBTableViewColumn1: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_GoodsTaxForm);

end.
