unit Goods_SiteUpdate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, dsdDB, cxPropertiesStore, dxBar,
  Vcl.ActnList, dsdAction, ParentForm, DataModul, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter, dsdAddOn,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxCurrencyEdit, cxCustomPivotGrid,
  cxDBPivotGrid, cxLabel, ChoicePeriod, dxBarExtItems, cxCheckBox, dsdPivotGrid,
  cxDBEdit;

type
  TGoods_SiteUpdateForm = class(TParentForm)
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    dsdStoredProc: TdsdStoredProc;
    actExportToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel1: TPanel;
    RefreshDispatcher: TRefreshDispatcher;
    FormParams: TdsdFormParams;
    bbStaticText: TdxBarButton;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    bbPrint2: TdxBarButton;
    bbcbTotal: TdxBarControlContainerItem;
    bbOpenReport_AccountMotion: TdxBarButton;
    bbReport_Account: TdxBarButton;
    bbPrint3: TdxBarButton;
    bbGroup: TdxBarControlContainerItem;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    bbUpdate: TdxBarButton;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    cbShowAll: TcxCheckBox;
    cbDiffNameUkr: TcxCheckBox;
    cbDiffMakerName: TcxCheckBox;
    cbDiffMakerNameUkr: TcxCheckBox;
    cxLabel1: TcxLabel;
    isPublishedSite: TcxGridDBColumn;
    isNameUkrSite: TcxGridDBColumn;
    NameUkr: TcxGridDBColumn;
    NameUkrSite: TcxGridDBColumn;
    isMakerNameSite: TcxGridDBColumn;
    MakerName: TcxGridDBColumn;
    MakerNameSite: TcxGridDBColumn;
    isMakerNameUkrSite: TcxGridDBColumn;
    MakerNameUkr: TcxGridDBColumn;
    MakerNameUkrSite: TcxGridDBColumn;
    DateDownloadsSite: TcxGridDBColumn;
    Color_NameUkr: TcxGridDBColumn;
    Color_MakerName: TcxGridDBColumn;
    Color_MakerNameUkr: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    spUpdate_SiteUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    spUpdate_SiteUpdate_NameUkrSite: TdsdStoredProc;
    spUpdate_SiteUpdate_MakerNameSite: TdsdStoredProc;
    spUpdate_SiteUpdate_MakerNameUkrSite: TdsdStoredProc;
    actUpdate_SiteUpdate_NameUkrSite: TdsdExecStoredProc;
    mUpdate_SiteUpdate_NameUkrSite: TMultiAction;
    actUpdate_SiteUpdate_MakerNameSite: TdsdExecStoredProc;
    mactUpdate_SiteUpdate_MakerNameSite: TMultiAction;
    actUpdate_SiteUpdate_MakerNameUkrSite: TdsdExecStoredProc;
    mactUpdate_SiteUpdate_MakerNameUkrSite: TMultiAction;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoods_SiteUpdateForm);

end.
