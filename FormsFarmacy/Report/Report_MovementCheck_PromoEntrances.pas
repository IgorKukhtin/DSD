unit Report_MovementCheck_PromoEntrances;

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
  TReport_MovementCheck_PromoEntrancesForm = class(TAncestorReportForm)
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    Amount: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    gpGetObjectGoods: TdsdStoredProc;
    Price: TcxGridDBColumn;
    getMovementForm: TdsdStoredProc;
    FormParams: TdsdFormParams;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    GuidesDiscountExternal: TdsdGuides;
    UnitGuides: TdsdGuides;
    ChangePercent: TcxGridDBColumn;
    SummChangePercent: TcxGridDBColumn;
    Entrances: TcxGridDBColumn;
    cxGridDetals: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    Itog_Doctors: TcxGridDBColumn;
    Itog_CheckCount: TcxGridDBColumn;
    Itog_GoodsCount: TcxGridDBColumn;
    Itog_SummSale: TcxGridDBColumn;
    Itog_SummChangePercent: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    spItog: TdsdStoredProc;
    ItogDS: TDataSource;
    ItogCDS: TClientDataSet;
    actGridToExcelItog: TdsdGridToExcel;
    dxBarButton1: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_MovementCheck_PromoEntrancesForm);

end.
