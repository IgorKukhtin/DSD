unit Report_MovementCheck_Promo;

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
  TReport_MovementCheck_PromoForm = class(TAncestorReportForm)
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    cxLabel3: TcxLabel;
    colAmount: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
    colMovementDesc: TcxGridDBColumn;
    edMaker: TcxButtonEdit;
    GuidesMaker: TdsdGuides;
    colInvNumber: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    gpGetObjectGoods: TdsdStoredProc;
    colStatusName: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
    colPriceSale: TcxGridDBColumn;
    getMovementForm: TdsdStoredProc;
    FormParams: TdsdFormParams;
    colPartionGoods: TcxGridDBColumn;
    colExpirationDate: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_MovementCheck_PromoForm);

end.
