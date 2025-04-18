unit Report_ProductionSeparate_CheckPrice;

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
  TReport_ProductionSeparate_CheckPriceForm = class(TAncestorReportForm)
    GoodsGroupName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Summa: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    Amount: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    SummaIn: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    Price: TcxGridDBColumn;
    PriceIn: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edFromGroup: TcxButtonEdit;
    cxLabel5: TcxLabel;
    GuidesFrom: TdsdGuides;
    edToGroup: TcxButtonEdit;
    GuidesTo: TdsdGuides;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actPrintTotal: TdsdPrintAction;
    bbPrintTotal: TdxBarButton;
    ���: TcxLabel;
    cePersent: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    edPriceList: TcxButtonEdit;
    GuidesPriceList: TdsdGuides;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    getMovementForm: TdsdStoredProc;
    actMovementForm: TdsdExecStoredProc;
    actOpenForm: TdsdOpenForm;
    actOpenDocument: TMultiAction;
    bbOpenDocument: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_ProductionSeparate_CheckPriceForm);

end.
