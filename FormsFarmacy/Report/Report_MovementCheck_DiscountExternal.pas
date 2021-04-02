unit Report_MovementCheck_DiscountExternal;

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
  TReport_MovementCheck_DiscountExternalForm = class(TAncestorReportForm)
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    Amount: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    gpGetObjectGoods: TdsdStoredProc;
    Price: TcxGridDBColumn;
    getMovementForm: TdsdStoredProc;
    FormParams: TdsdFormParams;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    ceDiscountExternal: TcxButtonEdit;
    cxLabel4: TcxLabel;
    ceUnit: TcxButtonEdit;
    cxLabel3: TcxLabel;
    GuidesDiscountExternal: TdsdGuides;
    UnitGuides: TdsdGuides;
    ChangePercent: TcxGridDBColumn;
    SummChangePercent: TcxGridDBColumn;
    DiscountCardName: TcxGridDBColumn;
    DiscountExternalName: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    PriceWithVAT: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_MovementCheck_DiscountExternalForm);

end.
