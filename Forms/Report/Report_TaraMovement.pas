unit Report_TaraMovement;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdGuides, dsdDB, cxButtonEdit,
  dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxCurrencyEdit;

type
  TReport_TaraMovementForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    edObject: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edGoods: TcxButtonEdit;
    FormParams: TdsdFormParams;
    ObjectGuides: TdsdGuides;
    GoodsGuides: TdsdGuides;
    colInvNumber: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
    colMovementDescName: TcxGridDBColumn;
    colLocationDescName: TcxGridDBColumn;
    colLocationCode: TcxGridDBColumn;
    colLocationName: TcxGridDBColumn;
    colObjectByDescName: TcxGridDBColumn;
    colObjectByCode: TcxGridDBColumn;
    colObjectByName: TcxGridDBColumn;
    colPaidKindName: TcxGridDBColumn;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colAmountIn: TcxGridDBColumn;
    colAmountOut: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    mactOpenDocument: TMultiAction;
    actOpenForm: TdsdOpenForm;
    actMovementForm: TdsdExecStoredProc;
    spGet_Movement_Form: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_TaraMovementForm);

end.
