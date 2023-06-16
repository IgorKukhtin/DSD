unit Report_OrderClient_byBoat;

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
  TReport_OrderClient_byBoatForm = class(TAncestorReportForm)
    ObjectCode: TcxGridDBColumn;
    ObjectName: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbSumm_branch: TdxBarControlContainerItem;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    getMovementForm: TdsdStoredProc;
    actGetForm: TdsdExecStoredProc;
    bbOpenFormClient: TdxBarButton;
    FormParams: TdsdFormParams;
    cbisDetail: TcxCheckBox;
    actOpenFormClient: TdsdOpenForm;
    actOpenFormPartner: TdsdOpenForm;
    bbOpenFormPartner: TdxBarButton;
    actRefreshEmpty: TdsdDataSetRefresh;
    Amount: TcxGridDBColumn;
    actChoiceGuides: TdsdChoiceGuides;
    lbSearchArticle: TcxLabel;
    edSearchArticle: TcxTextEdit;
    FieldFilter_Article: TdsdFieldFilter;
    bbedSearchArticle: TdxBarControlContainerItem;
    bblbSearchArticle: TdxBarControlContainerItem;
    spSelectPrint3: TdsdStoredProc;
    actPrint3: TdsdPrintAction;
    actPrint2: TdsdPrintAction;
    bbPrint2: TdxBarButton;
    bbPrint3: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    OperDate: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    MonthName1: TcxGridDBColumn;
    ProdColorName: TcxGridDBColumn;
    MonthRemains: TcxGridDBColumn;
    actReport_OC_ByBoatChoice: TdsdOpenForm;
    bbReport_OC_ByBoatChoice: TdxBarButton;
    ColorText: TcxGridDBColumn;
    GuidesOrderClient: TdsdGuides;
    cxLabel15: TcxLabel;
    edOrderClient: TcxButtonEdit;
    AmountIn: TcxGridDBColumn;
    actPrint4: TdsdPrintAction;
    bbPrint4: TdxBarButton;
    spSelectPrint4: TdsdStoredProc;
    cbisOnlyChild: TcxCheckBox;
    actRefreshGoods: TdsdDataSetRefresh;
    Comment_mov: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_OrderClient_byBoatForm);

end.
