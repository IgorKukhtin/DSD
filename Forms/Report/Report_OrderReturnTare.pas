unit Report_OrderReturnTare;

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
  cxCheckBox;

type
  TReport_OrderReturnTareForm = class(TAncestorReportForm)
    FormParams: TdsdFormParams;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    MovementDescName: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    PartnerCode: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount_return: TcxGridDBColumn;
    mactOpenDocument: TMultiAction;
    actOpenForm: TdsdOpenForm;
    actMovementForm: TdsdExecStoredProc;
    spGet_Movement_Form: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    GoodsGroupNameFull: TcxGridDBColumn;
    Amount_order: TcxGridDBColumn;
    cbMovement: TcxCheckBox;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actReport_OrderReturnTare_ReturnIn: TdsdOpenForm;
    bbReport_OrderReturnTare_ReturnIn: TdxBarButton;
    actRefresh1: TdsdDataSetRefresh;
    Amount_sale: TcxGridDBColumn;
    actReport_OrderReturnTare_Order: TdsdOpenForm;
    actReport_OrderReturnTare_Sale: TdsdOpenForm;
    bbReport_OrderReturnTare_Order: TdxBarButton;
    bbReport_OrderReturnTare_Sale: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_OrderReturnTareForm);

end.
