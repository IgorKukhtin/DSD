unit Report_GoodsPartionHistory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, dsdGuides,
  cxButtonEdit, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView, cxGrid, cxPC,
  cxPCdxBarPopupMenu, cxCurrencyEdit, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCheckBox, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TReport_GoodsPartionHistoryForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    cxLabel3: TcxLabel;
    edGoods: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edParty: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GuidesGoods: TdsdGuides;
    GuidesParty: TdsdGuides;
    MovementId: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    MovementDescId: TcxGridDBColumn;
    MovementDescName: TcxGridDBColumn;
    FromId: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    ToId: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    AmountOut: TcxGridDBColumn;
    AmountInvent: TcxGridDBColumn;
    MCSValue: TcxGridDBColumn;
    Saldo: TcxGridDBColumn;
    spGet_UserUnit: TdsdStoredProc;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    CheckMember: TcxGridDBColumn;
    Bayer: TcxGridDBColumn;
    actOpenDocument: TdsdOpenForm;
    N2: TMenuItem;
    N3: TMenuItem;
    FormParams: TdsdFormParams;
    spGet_MovementFormClass: TdsdStoredProc;
    actGet_MovementFormClass: TdsdExecStoredProc;
    mactOpenDocument: TMultiAction;
    rgUnit: TRefreshDispatcher;
    rdGoods: TRefreshDispatcher;
    rdParty: TRefreshDispatcher;
    Summa: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actRefreshIsPartion: TdsdDataSetRefresh;
    cbPartion: TcxCheckBox;
    ceCode: TcxCurrencyEdit;
    PartionGoods: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_GoodsPartionHistoryForm: TReport_GoodsPartionHistoryForm;

implementation

{$R *.dfm}
initialization

  RegisterClass(TReport_GoodsPartionHistoryForm);
end.
