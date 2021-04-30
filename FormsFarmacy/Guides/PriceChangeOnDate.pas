unit PriceChangeOnDate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, Vcl.ExtCtrls, cxContainer, dsdGuides, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxCurrencyEdit, ExternalLoad, cxPCdxBarPopupMenu, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.ComCtrls,
  dxCore, cxDateUtils, cxLabel, cxDropDownEdit, cxCalendar, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TPriceChangeOnDateForm = class(TAncestorEnumForm)
    dxBarControlContainerItemUnit: TdxBarControlContainerItem;
    edRetail: TcxButtonEdit;
    GuidesRetail: TdsdGuides;
    FormParams: TdsdFormParams;
    dxBarButton1: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    actShowDel: TBooleanStoredProcAction;
    dxBarButton2: TdxBarButton;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    PriceChange: TcxGridDBColumn;
    DateChange: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    dsdUpdatePrice: TdsdUpdateDataSet;
    rdUnit: TRefreshDispatcher;
    FixValue: TcxGridDBColumn;
    MCSDateChange: TcxGridDBColumn;
    actStartLoadMCS: TMultiAction;
    actDoLoadMCS: TExecuteImportSettingsAction;
    dxBarButton3: TdxBarButton;
    spGetImportSetting_MCS: TdsdStoredProc;
    actGetImportSetting_MCS: TdsdExecStoredProc;
    spGetImportSetting_Price: TdsdStoredProc;
    actGetImportSetting_Price: TdsdExecStoredProc;
    actDoLoadPrice: TExecuteImportSettingsAction;
    actStartLoadPrice: TMultiAction;
    dxBarButton4: TdxBarButton;
    MCSIsClose: TcxGridDBColumn;
    MCSNotRecalc: TcxGridDBColumn;
    spRecalcMCS: TdsdStoredProc;
    actRecalcMCS: TdsdExecStoredProc;
    dxBarButton5: TdxBarButton;
    actStartRecalcMCS: TMultiAction;
    actRecalcMCSDialog: TExecuteDialog;
    Remains: TcxGridDBColumn;
    spDelete_Object_MCS: TdsdStoredProc;
    actDelete_Object_MCS: TdsdExecStoredProc;
    dxBarButton6: TdxBarButton;
    FixValueEnd: TcxGridDBColumn;
    MCSIsCloseDateChange: TcxGridDBColumn;
    MCSNotRecalcDateChange: TcxGridDBColumn;
    FixDateChange: TcxGridDBColumn;
    actPriceHistoryOpen: TdsdOpenForm;
    dxBarButton7: TdxBarButton;
    Panel: TPanel;
    deOperDate: TcxDateEdit;
    cxLabel3: TcxLabel;
    cxLabel1: TcxLabel;
    ExecuteDialog: TExecuteDialog;
    StartDate: TcxGridDBColumn;
    SummaRemains: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    RefreshDispatcher: TRefreshDispatcher;
    FixEndDate: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PriceChangeOnDateForm: TPriceChangeOnDateForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TPriceChangeOnDateForm)
end.
