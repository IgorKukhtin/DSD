unit Price;

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
  dxCore, cxDateUtils, cxLabel, cxDropDownEdit, cxCalendar, cxCheckBox,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TPriceForm = class(TAncestorEnumForm)
    dxBarControlContainerItemUnit: TdxBarControlContainerItem;
    ceUnit: TcxButtonEdit;
    UnitGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    dxBarButton1: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    actShowDel: TBooleanStoredProcAction;
    dxBarButton2: TdxBarButton;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    DateChange: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    dsdUpdatePrice: TdsdUpdateDataSet;
    rdUnit: TRefreshDispatcher;
    MCSValue: TcxGridDBColumn;
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
    Fix: TcxGridDBColumn;
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
    Goods_isTop: TcxGridDBColumn;
    dsdOpenForm: TdsdOpenForm;
    bbOpenForm: TdxBarButton;
    cxLabel2: TcxLabel;
    ceGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    RefreshDispatcher: TRefreshDispatcher;
    Color_ExpirationDate: TcxGridDBColumn;
    cbisMCSAuto: TcxCheckBox;
    ceDays: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    cxLabel4: TcxLabel;
    DiffSP2: TcxGridDBColumn;
    isCorrectMCS: TcxGridDBColumn;
    isExcludeMCS: TcxGridDBColumn;
    CheckPriceDate: TcxGridDBColumn;
    spUpdate_CheckPrice: TdsdStoredProc;
    actUpdate_CheckPrice: TdsdExecStoredProc;
    bb: TdxBarButton;
    macUpdate_CheckPriceList: TMultiAction;
    macUpdate_CheckPrice: TMultiAction;
    InvNumber_Full: TcxGridDBColumn;
    isChecked: TcxGridDBColumn;
    OperDateStart: TcxGridDBColumn;
    OperDateEnd: TcxGridDBColumn;
    AmountDiff: TcxGridDBColumn;
    MarginPercentNew: TcxGridDBColumn;
    isError_MarginPercent: TcxGridDBColumn;
    isMCSValue_dif: TcxGridDBColumn;
    MCSValueSun: TcxGridDBColumn;
    PercentMarkupSP: TcxGridDBColumn;
    actReport_Object_Price_MCS_Year: TdsdOpenForm;
    dxBarButton8: TdxBarButton;
    UnitName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PriceForm: TPriceForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TPriceForm)
end.
