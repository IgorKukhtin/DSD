unit Report_SaleTare_Gofro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdGuides, dsdDB, cxButtonEdit,
  dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxCurrencyEdit, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCheckBox, dsdCommon;

type
  TReport_SaleTare_GofroForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    edUnit: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    FormParams: TdsdFormParams;
    GuidesUnit: TdsdGuides;
    GuidesGoodsGroup: TdsdGuides;
    OperDatePartner: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    ToCode: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    FromCode: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    BoxCount_calc: TcxGridDBColumn;
    bbOpenDocument: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    cbDetail: TcxCheckBox;
    InvNumber: TcxGridDBColumn;
    actOpenDocument: TdsdOpenForm;
    spGet_checkopen: TdsdStoredProc;
    actRefreshDet: TdsdDataSetRefresh;
    macOpenDocument: TMultiAction;
    actGet_checkopen: TdsdExecStoredProc;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    spSelectPrintBox_PartnerTotal: TdsdStoredProc;
    actPrintBoxTotalPartner: TdsdPrintAction;
    bbPrintBoxTotalPartner: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_SaleTare_GofroForm);

end.
