unit Report_Sale_WeighingPartner_Compare;

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
  cxColorComboBox, cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon,
  cxImageComboBox;

type
  TReport_Sale_WeighingPartner_CompareForm = class(TAncestorReportForm)
    FormParams: TdsdFormParams;
    GoodsGroupNameFull: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    StatusCode: TcxGridDBColumn;
    actRefresh_Detail: TdsdDataSetRefresh;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    Weight: TcxGridDBColumn;
    PrintItemsCDS: TClientDataSet;
    lbSearchName: TcxLabel;
    edSearchToName: TcxTextEdit;
    FieldFilter_Name: TdsdFieldFilter;
    dsdChoiceGuides1: TdsdChoiceGuides;
    ToName: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edSearchGoodsCode: TcxTextEdit;
    cxLabel4: TcxLabel;
    edSearchGoodsName: TcxTextEdit;
    FromName: TcxGridDBColumn;
    MovementDescName: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    actPrintPassport_prod: TdxBarButton;
    actProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    cxLabel5: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    cxLabel8: TcxLabel;
    edUnitFrom: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    InvNumber_wp: TcxGridDBColumn;
    isBarCode_str: TcxGridDBColumn;
    WeightPackage: TcxGridDBColumn;
    WeightTotal: TcxGridDBColumn;
    CountPack: TcxGridDBColumn;
    WeightPack_wp: TcxGridDBColumn;
    getMovementForm: TdsdStoredProc;
    actGetForm: TdsdExecStoredProc;
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
  RegisterClass(TReport_Sale_WeighingPartner_CompareForm);

end.
