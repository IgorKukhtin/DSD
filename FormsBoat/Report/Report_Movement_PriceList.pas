unit Report_Movement_PriceList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport_boat, cxGraphics, cxControls,
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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TReport_Movement_PriceListForm = class(TAncestorReport_boatForm)
    cxLabel3: TcxLabel;
    edGoods: TcxButtonEdit;
    GuidesGoods: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    cxLabel8: TcxLabel;
    edPartner: TcxButtonEdit;
    GuidesPartner: TdsdGuides;
    bbSumm_branch: TdxBarControlContainerItem;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    getMovementForm: TdsdStoredProc;
    actGetForm: TdsdExecStoredProc;
    bbOpenFormClient: TdxBarButton;
    FormParams: TdsdFormParams;
    actOpenFormPriceList: TdsdOpenForm;
    bbOpenFormPartner: TdxBarButton;
    actRefreshEmpty: TdsdDataSetRefresh;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_Movement_PriceListForm);

end.
