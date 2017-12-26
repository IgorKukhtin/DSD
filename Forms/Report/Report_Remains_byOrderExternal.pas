unit Report_Remains_byOrderExternal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  AncestorReport, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, Data.DB, cxDBData, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxPC, cxContainer, cxTextEdit,
  cxLabel, cxCurrencyEdit, cxButtonEdit, Vcl.DBActns, cxMaskEdit, Vcl.ExtCtrls,
  Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod, cxDropDownEdit, cxCalendar,
  dsdGuides, dxBarBuiltInMenu, cxNavigator, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TReport_Remains_byOrderExternalForm = class(TAncestorReportForm)
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    getMovementForm: TdsdStoredProc;
    FormParams: TdsdFormParams;
    bbExecuteDialog: TdxBarButton;
    cxLabel25: TcxLabel;
    edPromo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    deOperdate: TcxDateEdit;
    GuidesOrderExternal: TdsdGuides;
    FromName: TcxGridDBColumn;
    PartionGoods: TcxGridDBColumn;
    GoodsCode_pack: TcxGridDBColumn;
    GoodsName_pack: TcxGridDBColumn;
    GoodsKindName_pack: TcxGridDBColumn;
    ReceiptName: TcxGridDBColumn;
    ReceiptCode: TcxGridDBColumn;
    ReceiptName_basis: TcxGridDBColumn;
    ReceiptCode_basis: TcxGridDBColumn;
    ReceiptName_pack: TcxGridDBColumn;
    ReceiptCode_pack: TcxGridDBColumn;
    Amount_result: TcxGridDBColumn;
    Remains_CEH_next: TcxGridDBColumn;
    PartionGoods_start: TcxGridDBColumn;
    TermProduction: TcxGridDBColumn;
    Amount_result_two: TcxGridDBColumn;
    Income_CEH: TcxGridDBColumn;
    Amount_result_two_two: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_Remains_byOrderExternalForm);

end.
