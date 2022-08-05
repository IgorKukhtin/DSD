unit WeighingPartner_bySale;

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
  TWeighingPartner_bySaleForm = class(TAncestorReportForm)
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    getMovementForm: TdsdStoredProc;
    FormParams: TdsdFormParams;
    bbExecuteDialog: TdxBarButton;
    cxLabel25: TcxLabel;
    edSale: TcxButtonEdit;
    cxLabel4: TcxLabel;
    deOperdate: TcxDateEdit;
    GuidesSale: TdsdGuides;
    cxLabel8: TcxLabel;
    edGoods: TcxButtonEdit;
    cxLabel11: TcxLabel;
    edGoodsKind: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    GuidesGoodsKind: TdsdGuides;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWeighingPartner_bySaleForm);

end.
