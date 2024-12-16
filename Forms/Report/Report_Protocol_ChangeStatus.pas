unit Report_Protocol_ChangeStatus;

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
  cxImageComboBox, dsdCommon;

type
  TReport_Protocol_ChangeStatusForm = class(TAncestorReportForm)
    UserName_1: TcxGridDBColumn;
    MemberName_1: TcxGridDBColumn;
    OperDate_Protocol_1: TcxGridDBColumn;
    actRefreshIsMovement: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    bbDialog: TdxBarButton;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReport: TdxBarButton;
    FormParams: TdsdFormParams;
    Invnumber_Movement: TcxGridDBColumn;
    DescName_Movement: TcxGridDBColumn;
    getMovementForm: TdsdStoredProc;
    actMovementForm: TdsdExecStoredProc;
    actOpenForm: TdsdOpenForm;
    macOpenDocument: TMultiAction;
    bbOpenDocument: TdxBarButton;
    StatusCode_Movement: TcxGridDBColumn;
    MovementId: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edStartDate_mov: TcxDateEdit;
    cxLabel3: TcxLabel;
    edEndDate_mov: TcxDateEdit;
    cbIsComplete_yes: TcxCheckBox;
    cbIsComplete_from: TcxCheckBox;
    MovementProtocolOpenForm: TdsdOpenForm;
    bbMovementProtocolOpenForm: TdxBarButton;
    Diff_minute: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_Protocol_ChangeStatusForm);

end.
