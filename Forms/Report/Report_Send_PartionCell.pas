unit Report_Send_PartionCell;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxCheckBox, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TReport_Send_PartionCellForm = class(TAncestorReportForm)
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    Amount: TcxGridDBColumn;
    cxLabel8: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    bbSumm_branch: TdxBarControlContainerItem;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    getMovementForm: TdsdStoredProc;
    actGetForm: TdsdExecStoredProc;
    actOpenForm: TdsdOpenForm;
    actOpenDocument: TMultiAction;
    bbOpenDocument: TdxBarButton;
    FormParams: TdsdFormParams;
    cbMovement: TcxCheckBox;
    actUpdateMainDS: TdsdUpdateDataSet;
    spUpdate_MI_Send_byReport: TdsdStoredProc;
    actRefreshPartion: TdsdDataSetRefresh;
    spUpdateMI_PartionGoodsDate: TdsdStoredProc;
    ExecuteDialogUpdatePartionGoodsDate: TExecuteDialog;
    actUpdateMI_PartionGoodsDate: TdsdExecStoredProc;
    macUpdatePartionGoodsDate: TMultiAction;
    bbUpdatePartionGoodsDate: TdxBarButton;
    Color_PartionGoodsDate: TcxGridDBColumn;
    isClose_value_min: TcxGridDBColumn;
    Color_1: TcxGridDBColumn;
    Color_2: TcxGridDBColumn;
    Color_3: TcxGridDBColumn;
    Color_4: TcxGridDBColumn;
    Color_5: TcxGridDBColumn;
    Color_6: TcxGridDBColumn;
    Color_7: TcxGridDBColumn;
    Color_8: TcxGridDBColumn;
    Color_9: TcxGridDBColumn;
    Color_10: TcxGridDBColumn;
    isPartionCell: TcxGridDBColumn;
    OperDate_min: TcxGridDBColumn;
    OperDate_max: TcxGridDBColumn;
    NormInDays: TcxGridDBColumn;
    NormInDays_real: TcxGridDBColumn;
    NormInDays_tax: TcxGridDBColumn;
    NormInDays_date: TcxGridDBColumn;
    actOpenFormPartionCell: TdsdOpenForm;
    bbOpenFormPartionCell: TdxBarButton;
    PanelSearch: TPanel;
    lbSearchCode: TcxLabel;
    edSearchCode: TcxTextEdit;
    lbSearchName: TcxLabel;
    edSearchName: TcxTextEdit;
    FieldFilter_Search: TdsdFieldFilter;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_Send_PartionCellForm);

end.
