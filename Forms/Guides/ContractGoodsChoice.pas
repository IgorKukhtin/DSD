unit ContractGoodsChoice;

interface

uses
  Winapi.Windows, AncestorGuides, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dsdAddOn, dxBarExtItems,
  dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  Vcl.Controls, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, Vcl.Menus, cxButtonEdit, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxContainer, dsdGuides, cxLabel, cxTextEdit, cxMaskEdit, Vcl.ExtCtrls,
  cxCurrencyEdit, cxSplitter;

type
  TContractGoodsChoiceForm = class(TAncestorGuidesForm)
    GoodsKindName: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    ContractCode: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    Panel: TPanel;
    edRetail: TcxButtonEdit;
    cxLabel10: TcxLabel;
    GuidesRetail: TdsdGuides;
    cxLabel6: TcxLabel;
    edJuridical: TcxButtonEdit;
    cxLabel9: TcxLabel;
    edContract: TcxButtonEdit;
    GuidesContract: TdsdGuides;
    GuidesJuridical: TdsdGuides;
    cxLabel1: TcxLabel;
    edPriceListGoods: TcxButtonEdit;
    GuidesPriceListGoods: TdsdGuides;
    FormParams: TdsdFormParams;
    spInsertUpdate: TdsdStoredProc;
    actInsertUpdate: TdsdExecStoredProc;
    macInsertUpdate: TMultiAction;
    bbInsertUpdate: TdxBarButton;
    RefreshDispatcher: TRefreshDispatcher;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    tmCode: TcxGridDBColumn;
    tmTradeMarkName: TcxGridDBColumn;
    tmContractCode: TcxGridDBColumn;
    tmContractName: TcxGridDBColumn;
    tmisErased: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    MasterCDS_TM: TClientDataSet;
    MasterDS_TM: TDataSource;
    spSelect_TM: TdsdStoredProc;
    DBViewAddOn_TM: TdsdDBViewAddOn;
    spInsertUpdate_ContractTradeMark: TdsdStoredProc;
    actChoiceFormTradeMark: TOpenChoiceForm;
    actUpdateDataSet_TM: TdsdUpdateDataSet;
    InsertRecord_TM: TInsertRecord;
    dsdSetErased_TM: TdsdUpdateErased;
    spErasedUnErased_TM: TdsdStoredProc;
    dsdSetUnErased_TM: TdsdUpdateErased;
    bbInsertRecord_TM: TdxBarButton;
    bbSetErased_TM: TdxBarButton;
    bbSetUnErased_TM: TdxBarButton;
    GuidesContractTag: TdsdGuides;
    edContractTag: TcxButtonEdit;
    cxLabel2: TcxLabel;
    actChoiceFormContract: TOpenChoiceForm;
    cxTopSplitter: TcxSplitter;
    macSetErased_list: TMultiAction;
    macSetErased: TMultiAction;
    bbmacSetErased: TdxBarButton;
    edGoodsProperty: TcxButtonEdit;
    cxLabel3: TcxLabel;
    GuidesGoodsProperty: TdsdGuides;
    spUpdate_Price0: TdsdStoredProc;
    actUpdate_Price0: TdsdExecStoredProc;
    macUpdate_Price0_list: TMultiAction;
    macUpdate_Price0: TMultiAction;
    actRefreshGoods: TdsdDataSetRefresh;
    bb: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TContractGoodsChoiceForm);

end.
