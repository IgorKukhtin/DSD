unit Report_GoodsMI_ProductionSeparate;

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
  TReport_GoodsMI_ProductionSeparateForm = class(TAncestorReportForm)
    GoodsGroupName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    HeadCount: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    Amount: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    PartionGoods: TcxGridDBColumn;
    ChildGoodsGroupName: TcxGridDBColumn;
    ChildGoodsCode: TcxGridDBColumn;
    ChildGoodsName: TcxGridDBColumn;
    ChildAmount: TcxGridDBColumn;
    ChildSumm: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    Price: TcxGridDBColumn;
    ChildPrice: TcxGridDBColumn;
    Percent: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edFromGroup: TcxButtonEdit;
    cxLabel5: TcxLabel;
    FromGroupGuides: TdsdGuides;
    cxLabel7: TcxLabel;
    edGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    edToGroup: TcxButtonEdit;
    ToGroupGuides: TdsdGuides;
    cbGroupMovement: TcxCheckBox;
    cbGroupPartion: TcxCheckBox;
    cxLabel6: TcxLabel;
    cxLabel8: TcxLabel;
    edChildGoods: TcxButtonEdit;
    edChildGoodsGroup: TcxButtonEdit;
    ChildGoodsGroupGuides: TdsdGuides;
    ChildGoodsGuides: TdsdGuides;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actPrintTotal: TdsdPrintAction;
    bbPrintTotal: TdxBarButton;
    Num: TcxGridDBColumn;
    cbStorageLine: TcxCheckBox;
    cbCalculated: TcxCheckBox;
    actReport_Goods: TdsdOpenForm;
    bbReport_Goods: TdxBarButton;
    StorageLineName_in: TcxGridDBColumn;
    GuidesPriceListNorm: TdsdGuides;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint_its: TdsdStoredProc;
    actPrint_its: TdsdPrintAction;
    bbsPrint: TdxBarSubItem;
    bbPrint_its: TdxBarButton;
    cxLabel9: TcxLabel;
    edPriceListNorm: TcxButtonEdit;
    bbPriceListNorm: TdxBarControlContainerItem;
    bbLabel9: TdxBarControlContainerItem;
    bbGroupPrint: TdxBarControlContainerItem;
    spSelectPrint_its_mov: TdsdStoredProc;
    actPrint_its_mov: TdsdPrintAction;
    bbPrint_its_mov: TdxBarButton;
    spSelectPrint_4001: TdsdStoredProc;
    spSelectPrint_4218: TdsdStoredProc;
    spSelectPrint_4134: TdsdStoredProc;
    actPrint_4001_gov: TdsdPrintAction;
    actPrint_4218: TdsdPrintAction;
    actPrint_4134: TdsdPrintAction;
    bbPrint_4001_gov: TdxBarButton;
    bbPrint_4134: TdxBarButton;
    bbPrint_4218: TdxBarButton;
    bbSeparator: TdxBarSeparator;
    Print_test_4001: TdsdStoredProc;
    actPrint_4001_test: TdsdPrintAction;
    bbPrint_test: TdxBarButton;
    Print_test_4218: TdsdStoredProc;
    Print_test_4134: TdsdStoredProc;
    actPrint_test_4218: TdsdPrintAction;
    bbtPrint_test_4218: TdxBarButton;
    Print_test_its: TdsdStoredProc;
    Print_test_its_mov: TdsdStoredProc;
    Print_test_4001_mov: TdsdStoredProc;
    Print_test_4218_mov: TdsdStoredProc;
    Print_test_4134_mov: TdsdStoredProc;
    bbsPrintMovement: TdxBarSubItem;
    actPrint_4001_gov_mov: TdsdPrintAction;
    actPrint_4218_mov: TdsdPrintAction;
    actPrint_4134_mov: TdsdPrintAction;
    bbPrint_4001_gov_mov: TdxBarButton;
    bbPrint_4134_mov: TdxBarButton;
    bbPrint_4218_mov: TdxBarButton;
    bbs: TdxBarSubItem;
    Print_test_its_gr: TdsdStoredProc;
    Print_test_4001_gr: TdsdStoredProc;
    Print_test_4218_gr: TdsdStoredProc;
    Print_test_4134_gr: TdsdStoredProc;
    actPrint_4001_gov_gr: TdsdPrintAction;
    actPrint_4218_gr: TdsdPrintAction;
    actPrint_4134_gr: TdsdPrintAction;
    actPrint_its_gr: TdsdPrintAction;
    bbPrint_4001_gov_gr: TdxBarButton;
    bbPrint_4134_gr: TdxBarButton;
    bbPrint_4218_gr: TdxBarButton;
    bbPrint_its_gr: TdxBarButton;
    cbMonth: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_GoodsMI_ProductionSeparateForm);

end.
