unit Report_SaleReturnIn_RealEx;

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
  TReport_SaleReturnIn_RealExForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    LocationDescName: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Summa: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    OperDatePartner: TcxGridDBColumn;
    ContractCode: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    isDiff: TcxGridDBColumn;
    OperDate_ReturnIn: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    edPartner: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    GuidesPartner: TdsdGuides;
    cbisMovement: TcxCheckBox;
    bbSumm_branch: TdxBarControlContainerItem;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    PriceReturn: TcxGridDBColumn;
    SummaReturn: TcxGridDBColumn;
    getMovementForm: TdsdStoredProc;
    actGetForm: TdsdExecStoredProc;
    actOpenForm: TdsdOpenForm;
    actOpenDocument: TMultiAction;
    bbOpenDocument: TdxBarButton;
    FormParams: TdsdFormParams;
    actOpenDocumentRet: TMultiAction;
    actGetFormRet: TdsdExecStoredProc;
    actOpenFormRet: TdsdOpenForm;
    getMovementFormRet: TdsdStoredProc;
    bbOpenDocumentRet: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_SaleReturnIn_RealExForm);

end.
