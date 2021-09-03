unit Report_ZeroingInOrders;

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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter;

type
  TReport_ZeroingInOrdersForm = class(TAncestorReportForm)
    InvNumber: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    InvNumberOrder: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    BayerPhone: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    ceUnit: TcxButtonEdit;
    cxLabel3: TcxLabel;
    UnitGuides: TdsdGuides;
    Bayer: TcxGridDBColumn;
    bbUpdateDateCompensation: TdxBarButton;
    dxBarButton1: TdxBarButton;
    cxSplitter1: TcxSplitter;
    actUpdate: TdsdInsertUpdateAction;
    dxBarButton2: TdxBarButton;
    GoodsCode: TcxGridDBColumn;
    dxBarButton3: TdxBarButton;
    GoodsName: TcxGridDBColumn;
    ZeroingDate: TcxGridDBColumn;
    dxBarButton4: TdxBarButton;
    AmountOrder: TcxGridDBColumn;
    StatusName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_ZeroingInOrdersForm);

end.
