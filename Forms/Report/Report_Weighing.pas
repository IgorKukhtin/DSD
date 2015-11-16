unit Report_Weighing;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, dxColorEdit,
  cxColorComboBox;

type
  TReport_WeighingForm = class(TAncestorReportForm)
    FormParams: TdsdFormParams;
    GoodsGroupNameFull: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edMovementDesc: TcxButtonEdit;
    MovementDescGuides: TdsdGuides;
    AmountPartner_mi: TcxGridDBColumn;
    RealWeight: TcxGridDBColumn;
    Amount_sh: TcxGridDBColumn;
    Amount_mi_sh: TcxGridDBColumn;
    ChangePercentAmount: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    CountForPrice: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    AmountPartner: TcxGridDBColumn;
    AmountChangePercent: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    InvNumber_parent: TcxGridDBColumn;
    OperDate_parent: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    MovementDescName: TcxGridDBColumn;
    AmountDiff_sh: TcxGridDBColumn;
    Amount_Weight: TcxGridDBColumn;
    Amount_mi_Weight: TcxGridDBColumn;
    AmountDiff_Weight: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_WeighingForm);

end.
