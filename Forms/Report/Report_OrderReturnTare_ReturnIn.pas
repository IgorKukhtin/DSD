unit Report_OrderReturnTare_ReturnIn;

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
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCheckBox;

type
  TReport_OrderReturnTare_ReturnInForm = class(TAncestorReportForm)
    FromCode: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    getMovementForm: TdsdStoredProc;
    FormParams: TdsdFormParams;
    bbExecuteDialog: TdxBarButton;
    FromName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDatePartner: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    GuidesTransport: TdsdGuides;
    edTransport: TcxButtonEdit;
    cxLabel3: TcxLabel;
    edPartner: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    cxLabel5: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    cbAll: TcxCheckBox;
    actRefresh1: TdsdDataSetRefresh;
    Amount: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_OrderReturnTare_ReturnInForm);

end.
