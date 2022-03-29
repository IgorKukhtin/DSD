unit Report_Promo_Market;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, dsdGuides, cxButtonEdit, dsdAddOn,
  ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCheckBox, cxImageComboBox;

type
  TReport_Promo_MarketForm = class(TAncestorReportForm)
    cxLabel17: TcxLabel;
    edUnit: TcxButtonEdit;
    UnitGuides: TdsdGuides;
    DateStartSale: TcxGridDBColumn;
    DeteFinalSale: TcxGridDBColumn;
    DateStartPromo: TcxGridDBColumn;
    DateFinalPromo: TcxGridDBColumn;
    RetailName: TcxGridDBColumn;
    AreaName: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    TradeMarkName: TcxGridDBColumn;
    SummOut_diff: TcxGridDBColumn;
    SummIn_diff: TcxGridDBColumn;
    Summ_diff: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    dxBarButton1: TdxBarButton;
    MeasureName: TcxGridDBColumn;
    actReport_PromoDialog: TExecuteDialog;
    dxBarButton2: TdxBarButton;
    InvNumber: TcxGridDBColumn;
    StatusCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    PersonalTradeName: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    actOpenPromo: TdsdOpenForm;
    dxBarButton3: TdxBarButton;
    cbPromo: TcxCheckBox;
    cbTender: TcxCheckBox;
    actPrint1: TdsdPrintAction;
    actPrint2: TdsdPrintAction;
    bbPrint1: TdxBarButton;
    bbPrint2: TdxBarButton;
    PrintHead: TClientDataSet;
    spSelect_Movement_Promo_Print: TdsdStoredProc;
    actPrint_Mov: TdsdPrintAction;
    bbPrint_Mov: TdxBarButton;
    cxLabel6: TcxLabel;
    ceJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    cbIsDetail: TcxCheckBox;
    ContractCode: TcxGridDBColumn;
    ContractNumber: TcxGridDBColumn;
    ContractTagName: TcxGridDBColumn;
    ContractCode_21512: TcxGridDBColumn;
    ContractNumber_21512: TcxGridDBColumn;
    ContractTagName_21512: TcxGridDBColumn;
    spInsertUpdate_ByGrid: TdsdStoredProc;
    cxLabel7: TcxLabel;
    edOperDate: TcxDateEdit;
    bbInsertUpdate_ByGrid: TdxBarButton;
    actInsertUpdate_ByGrid: TdsdExecStoredProc;
    macInsertUpdate_ByGrid_list: TMultiAction;
    macInsertUpdate_ByGrid: TMultiAction;
    BranchName: TcxGridDBColumn;
    InfoMoneyCode_21512: TcxGridDBColumn;
    InfoMoneyName_21512: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_Promo_MarketForm);

end.
