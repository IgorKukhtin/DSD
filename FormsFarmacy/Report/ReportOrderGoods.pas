unit ReportOrderGoods;

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
  dsdGuides;

type
  TReportOrderGoodsForm = class(TAncestorReportForm)
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colProducerName: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    colExpirationDate: TcxGridDBColumn;
    colNDS: TcxGridDBColumn;
    colGoodsNDS: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    cxLabel3: TcxLabel;
    colAmount: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
    colMovementDesc: TcxGridDBColumn;
    edGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    colInvNumber: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    colOrderKindName: TcxGridDBColumn;
    ceCode: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    gpGetObjectGoods: TdsdStoredProc;
    colStatusName: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReportOrderGoodsForm);

end.
