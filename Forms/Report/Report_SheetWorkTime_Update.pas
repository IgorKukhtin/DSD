unit Report_SheetWorkTime_Update;

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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxGridChartView, cxGridDBChartView, cxSplitter, cxImageComboBox, dsdCommon;

type
  TReport_SheetWorkTime_UpdateForm = class(TAncestorReportForm)
    FormParams: TdsdFormParams;
    edUnit: TcxButtonEdit;
    cxLabel8: TcxLabel;
    GuidesUnit: TdsdGuides;
    HeaderCDS: TClientDataSet;
    ItemsCDS: TClientDataSet;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    mactOpenDocument: TMultiAction;
    actMovementCheck: TdsdExecStoredProc;
    actOpenForm: TdsdOpenForm;
    bbOpenDocument: TdxBarButton;
    actUpdateDataSet: TdsdUpdateDataSet;
    actPrint: TdsdPrintAction;
    UnitName: TcxGridDBColumn;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    isErased: TcxGridDBColumn;
    spErasedMIMaster_: TdsdStoredProc;
    actMISetErased_: TdsdUpdateErased;
    actMISetUnErased_: TdsdUpdateErased;
    actMovementItemProtocolOpenForm: TdsdOpenForm;
    bbMISetErased: TdxBarButton;
    bbMISetUnErased: TdxBarButton;
    bbMovementItemProtocol: TdxBarButton;
    StatusCode: TcxGridDBColumn;
    ShortName: TcxGridDBColumn;
    OperDate_mi: TcxGridDBColumn;
    UserName_mi: TcxGridDBColumn;
    OperDate_mov: TcxGridDBColumn;
    UserName_mov: TcxGridDBColumn;
    MovementItemId: TcxGridDBColumn;
    MovementId: TcxGridDBColumn;
    spUnErasedMIMaster: TdsdStoredProc;
    spErasedMIMaster: TdsdStoredProc;
    actMISetErased: TdsdUpdateErased;
    actMISetUnErased: TdsdUpdateErased;
    MovementProtocolOpenForm: TdsdOpenForm;
    bbMovementProtocolOpenForm: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_SheetWorkTime_UpdateForm);

end.
