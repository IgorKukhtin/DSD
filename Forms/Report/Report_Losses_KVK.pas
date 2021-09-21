unit Report_Losses_KVK;

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
  cxColorComboBox, cxCheckBox;

type
  TReport_Losses_KVKForm = class(TAncestorReportForm)
    FormParams: TdsdFormParams;
    GoodsGroupNameFull: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    GoodsKindComplete_partion: TcxGridDBColumn;
    PersonalKVKName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    KVK: TcxGridDBColumn;
    actRefresh_Detail: TdsdDataSetRefresh;
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    cxLabel5: TcxLabel;
    edUser: TcxButtonEdit;
    GuidesUser: TdsdGuides;
    cxLabel3: TcxLabel;
    edPersonalKVK: TcxButtonEdit;
    cxLabel22: TcxLabel;
    ceKVK: TcxTextEdit;
    GuidesPersonalKVK: TdsdGuides;
    actReport_MotionGoods: TdsdOpenForm;
    bbReport_MotionGoods: TdxBarButton;
    DocumentKindName: TcxGridDBColumn;
    ContainerId: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_Losses_KVKForm);

end.
