unit Report_MIProtocol;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxCheckBox, cxSplitter,
  cxGridChartView, cxGridDBChartView, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
  cxImageComboBox;

type
  TReport_MIProtocolForm = class(TAncestorReportForm)
    UserCode: TcxGridDBColumn;
    UserName: TcxGridDBColumn;
    MemberName: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    OperDate_Protocol: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    cxLabel5: TcxLabel;
    edUser: TcxButtonEdit;
    cbisMovement: TcxCheckBox;
    GuidesUser: TdsdGuides;
    actRefreshIsMovement: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    bbDialog: TdxBarButton;
    isErased: TcxGridDBColumn;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReport: TdxBarButton;
    FormParams: TdsdFormParams;
    cxLabel3: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GuidesGoodsGroup: TdsdGuides;
    cxLabel6: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    Invnumber_Movement: TcxGridDBColumn;
    DescName_Movement: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    AmountPartner: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    getMovementForm: TdsdStoredProc;
    actMovementForm: TdsdExecStoredProc;
    actOpenForm: TdsdOpenForm;
    macOpenDocument: TMultiAction;
    bbOpenDocument: TdxBarButton;
    StatusCode: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    MovementItemId: TcxGridDBColumn;
    Text_inf: TcxGridDBColumn;
    IsInsert: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_MIProtocolForm);

end.
