unit JuridicalSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxCheckBox, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCurrencyEdit, dxSkinBlack,
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
  cxDropDownEdit, cxSplitter;

type
  TJuridicalSettingsForm = class(TAncestorEnumForm)
    JuridicalName: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    UpdateDataSet: TdsdUpdateDataSet;
    isPriceClose: TcxGridDBColumn;
    MainJuridicalName: TcxGridDBColumn;
    Bonus: TcxGridDBColumn;
    StartDate: TcxGridDBColumn;
    EndDate: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    PriceLimit: TcxGridDBColumn;
    ÑonditionalPercent: TcxGridDBColumn;
    isSite: TcxGridDBColumn;
    spErasedUnErased: TdsdStoredProc;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    bbShowAll: TdxBarButton;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    actShowErased: TBooleanStoredProcAction;
    isBonusVirtual: TcxGridDBColumn;
    actProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpen: TdxBarButton;
    AreaName: TcxGridDBColumn;
    spUpdate_isPriceClose_Yes: TdsdStoredProc;
    spUpdate_isPriceClose_No: TdsdStoredProc;
    spUpdateisisPriceCloseNo: TdsdExecStoredProc;
    spUpdateisisPriceCloseYes: TdsdExecStoredProc;
    macUpdateisisPriceCloseNo: TMultiAction;
    macUpdateisisPriceCloseYes: TMultiAction;
    bbUpdateisisPriceCloseYes: TdxBarButton;
    bbUpdateisisPriceCloseNo: TdxBarButton;
    spUpdate_isPriceCloseOrder_Yes: TdsdStoredProc;
    spUpdate_isPriceCloseOrder_No: TdsdStoredProc;
    spUpdateisPriceCloseOrderNo: TdsdExecStoredProc;
    spUpdateisPriceCloseOrderYes: TdsdExecStoredProc;
    macUpdateisPriceCloseOrderNo: TMultiAction;
    macUpdateisPriceCloseOrderYes: TMultiAction;
    bbUpdateisRePriceCloseYes: TdxBarButton;
    bbUpdateisRePriceCloseNo: TdxBarButton;
    macUpdateisPriceCloseOrder_Yes: TMultiAction;
    macUpdateisPriceCloseOrder_No: TMultiAction;
    cxSplitter1: TcxSplitter;
    dsdUpdateChild: TdsdUpdateDataSet;
    dsdSetErasedChild: TdsdUpdateErased;
    spErasedUnErasedChild: TdsdStoredProc;
    dsdUnErasedChild: TdsdUpdateErased;
    bbSetErasedChild: TdxBarButton;
    bbUnErasedChild: TdxBarButton;
    actLinkRefresh: TdsdDataSetRefresh;
    RefreshDispatcher: TRefreshDispatcher;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    clBonus: TcxGridDBColumn;
    clPriceLimit: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    ItemCDS: TClientDataSet;
    ItemDS: TDataSource;
    spSelect_JuridicalSettingsItem: TdsdStoredProc;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    clisErased: TcxGridDBColumn;
    spInsertUpdateItem: TdsdStoredProc;
    InsertRecord1: TInsertRecord;
    bbInsertRecord1: TdxBarButton;
    clPriceLimit_min: TcxGridDBColumn;
    spUpdate_isBonusClose_Yes: TdsdStoredProc;
    spUpdate_isBonusClose_No: TdsdStoredProc;
    actUpdateisBonusClose_No: TdsdExecStoredProc;
    actUpdateisBonusClose_Yes: TdsdExecStoredProc;
    macUpdateisBonusClose_No_list: TMultiAction;
    macUpdateisBonusClose_Yes_list: TMultiAction;
    bbUpdateisBonusClose_Yes: TdxBarButton;
    bbUpdateisBonusClose_No: TdxBarButton;
    macUpdateisBonusClose_Yes: TMultiAction;
    macUpdateisBonusClose_No: TMultiAction;
    actProtocolEraseOpenForm: TdsdOpenForm;
    dxBarButton1: TdxBarButton;
    Code: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TJuridicalSettingsForm);

end.
