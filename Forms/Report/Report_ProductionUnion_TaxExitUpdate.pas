unit Report_ProductionUnion_TaxExitUpdate;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TReport_ProductionUnion_TaxExitUpdateForm = class(TAncestorReportForm)
    GoodsGroupNameFull: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    TaxLossVPR: TcxGridDBColumn;
    CuterCount_inf: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    PartionGoodsDate: TcxGridDBColumn;
    Amount_Humidity: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    cxLabel3: TcxLabel;
    edFromGroup: TcxButtonEdit;
    cxLabel5: TcxLabel;
    FromGroupGuides: TdsdGuides;
    edToGroup: TcxButtonEdit;
    ToGroupGuides: TdsdGuides;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    GoodsKindName_Complete: TcxGridDBColumn;
    RealWeightShp_calc: TcxGridDBColumn;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    AmountShp_diff: TcxGridDBColumn;
    actPrintTRM: TdsdPrintAction;
    actPrintCEH: TdsdPrintAction;
    actPrintOUT: TdsdPrintAction;
    bbPrintTRM: TdxBarButton;
    bbPrintCEH: TdxBarButton;
    bbPrintOUT: TdxBarButton;
    ValueGP: TcxGridDBColumn;
    ValueGP_diff: TcxGridDBColumn;
    ValuePF: TcxGridDBColumn;
    ValuePF_diff: TcxGridDBColumn;
    Part_main_det: TcxGridDBColumn;
    cbisPartion: TcxCheckBox;
    actRefresh_Partion: TdsdDataSetRefresh;
    isPrint: TcxGridDBColumn;
    actPrintCEH_Group: TdsdPrintAction;
    actPrintTRM_Group: TdsdPrintAction;
    bbsPrint: TdxBarSubItem;
    bbxBarSeparator: TdxBarSeparator;
    bbPrintCEH_Group: TdxBarButton;
    bbPrintTRM_Group: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    spPrint_TaxExitUpdate_groupCeh: TdsdStoredProc;
    spPrint_TaxExitUpdate_groupTRM: TdsdStoredProc;
    spDelete_Object_Print: TdsdStoredProc;
    spInsertPrint_byGrid: TdsdStoredProc;
    spPrint_TaxExitUpdate_groupCeh_gr: TdsdStoredProc;
    spPrint_TaxExitUpdate_groupTRM_gr: TdsdStoredProc;
    actDelete_Object_Print: TdsdExecStoredProc;
    actPrint_byGrid: TdsdExecStoredProc;
    actPrint_byGrid_list: TMultiAction;
    actPrintCEH_Group_gr: TdsdPrintAction;
    actPrintTRM_Group_gr: TdsdPrintAction;
    macPrintCEH_Group_gr: TMultiAction;
    macPrintTRM_Group_gr: TMultiAction;
    bbmacPrintCEH_Group_gr: TdxBarButton;
    bbmacPrintTRM_Group_gr: TdxBarButton;
    cbIsTerm: TcxCheckBox;
    actRefresh_Term: TdsdDataSetRefresh;
    Amount_inf_calc: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_ProductionUnion_TaxExitUpdateForm);

end.
