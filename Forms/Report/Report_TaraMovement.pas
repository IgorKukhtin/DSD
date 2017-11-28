unit Report_TaraMovement;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TReport_TaraMovementForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    edObject: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edGoods: TcxButtonEdit;
    FormParams: TdsdFormParams;
    ObjectGuides: TdsdGuides;
    GoodsGuides: TdsdGuides;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    MovementDescName: TcxGridDBColumn;
    LocationDescName: TcxGridDBColumn;
    LocationCode: TcxGridDBColumn;
    LocationName: TcxGridDBColumn;
    ObjectByDescName: TcxGridDBColumn;
    ObjectByCode: TcxGridDBColumn;
    ObjectByName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    AmountIn: TcxGridDBColumn;
    AmountOut: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    mactOpenDocument: TMultiAction;
    actOpenForm: TdsdOpenForm;
    actMovementForm: TdsdExecStoredProc;
    spGet_Movement_Form: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    cxLabel5: TcxLabel;
    ceAccountGroup: TcxButtonEdit;
    AccountGroupGuides: TdsdGuides;
    AccountGroupCode: TcxGridDBColumn;
    AccountGroupName: TcxGridDBColumn;
    AmountPartner_out: TcxGridDBColumn;
    AmountPartner_in: TcxGridDBColumn;
    AmountInf_out: TcxGridDBColumn;
    AmountInf_in: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_TaraMovementForm);

end.
