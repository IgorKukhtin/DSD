unit Report_MovementIncome_Promo;

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
  TReport_MovementIncome_PromoForm = class(TAncestorReportForm)
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    ProducerName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    cxLabel3: TcxLabel;
    Amount: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    MovementDesc: TcxGridDBColumn;
    edMaker: TcxButtonEdit;
    GuidesMaker: TdsdGuides;
    InvNumber: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    gpGetObjectGoods: TdsdStoredProc;
    StatusName: TcxGridDBColumn;
    PriceSale: TcxGridDBColumn;
    getMovementForm: TdsdStoredProc;
    FormParams: TdsdFormParams;
    PartionGoods: TcxGridDBColumn;
    ExpirationDate: TcxGridDBColumn;
    PaymentDate: TcxGridDBColumn;
    InvNumberBranch: TcxGridDBColumn;
    BranchDate: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    PriceSIP: TcxGridDBColumn;
    SummSIP: TcxGridDBColumn;
    GoodsGroupPromoName: TcxGridDBColumn;
    MorionCode: TcxGridDBColumn;
    Summa: TcxGridDBColumn;
    SummaWithVAT: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_MovementIncome_PromoForm);

end.
