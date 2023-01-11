unit Report_OrderInternal;

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
  TReport_OrderInternalForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbSumm_branch: TdxBarControlContainerItem;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    getMovementForm: TdsdStoredProc;
    actGetForm: TdsdExecStoredProc;
    bbOpenFormClient: TdxBarButton;
    FormParams: TdsdFormParams;
    actOpenFormOrderInternal: TdsdOpenForm;
    actOpenFormOrderClient: TdsdOpenForm;
    bbOpenFormPartner: TdxBarButton;
    actRefreshEmpty: TdsdDataSetRefresh;
    Amount: TcxGridDBColumn;
    EngineNum: TcxGridDBColumn;
    EngineName_boat: TcxGridDBColumn;
    actChoiceGuides: TdsdChoiceGuides;
    lbSearchArticle: TcxLabel;
    edSearchArticle: TcxTextEdit;
    FieldFilter_Article: TdsdFieldFilter;
    bbedSearchArticle: TdxBarControlContainerItem;
    bblbSearchArticle: TdxBarControlContainerItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_OrderInternalForm);

end.
