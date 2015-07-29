unit Report_GoodsMI_Defroster;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxCheckBox;

type
  TReport_GoodsMI_DefrosterForm = class(TAncestorReportForm)
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount_Separate_in: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    Amount_diff: TcxGridDBColumn;
    Amount_Send_in: TcxGridDBColumn;
    Amount_Loss: TcxGridDBColumn;
    Amount_Loss_diff: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    UnitGuides: TdsdGuides;
    edUnit: TcxButtonEdit;
    Amount_Separate_out: TcxGridDBColumn;
    Tax_diff: TcxGridDBColumn;
    Amount_Send_out: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    actPrintByGoods: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrintByGoods: TdxBarButton;
    PartionGoodsName: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    PartnerCode: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    actPrint1: TdsdPrintAction;
    bbPrint1: TdxBarButton;
    actUpdateDefroster: TdsdExecStoredProc;
    spUpdateDefroster: TdsdStoredProc;
    bbUpdateDefroster: TdxBarButton;
    Tax_Separate_diff: TcxGridDBColumn;
    Price_in: TcxGridDBColumn;
    Price_Separate_in: TcxGridDBColumn;
    Price_Send_in: TcxGridDBColumn;
    Price_out: TcxGridDBColumn;
    Price_Separate_out: TcxGridDBColumn;
    Price_Send_out: TcxGridDBColumn;
    Summ_Loss_diff: TcxGridDBColumn;
    Price_Loss_diff: TcxGridDBColumn;
    cbPartionGoods: TcxCheckBox;
    bbPartionGoods: TdxBarControlContainerItem;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    Summ_Production_out: TcxGridDBColumn;
    Amount_Production_out: TcxGridDBColumn;
    Separate_CountIn: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_GoodsMI_DefrosterForm);

end.
