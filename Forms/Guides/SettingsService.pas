unit SettingsService;

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
  TSettingsServiceForm = class(TAncestorEnumForm)
    spInsertUpdate: TdsdStoredProc;
    UpdateDataSet: TdsdUpdateDataSet;
    Name: TcxGridDBColumn;
    spErasedUnErased: TdsdStoredProc;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    bbShowAll: TdxBarButton;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    actProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpen: TdxBarButton;
    spUpdateItem_isErased: TdsdStoredProc;
    bbUpdate: TdxBarButton;
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
    isSave: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    ItemCDS: TClientDataSet;
    ItemDS: TDataSource;
    spSelect_SettingsServiceItem: TdsdStoredProc;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    clisErased: TcxGridDBColumn;
    spInsertUpdateItem: TdsdStoredProc;
    InsertRecord1: TInsertRecord;
    bbInsertRecord1: TdxBarButton;
    InfoMoneyGroupCode: TcxGridDBColumn;
    Code: TcxGridDBColumn;
    InsertRecord: TInsertRecord;
    bbInsertRecord: TdxBarButton;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    actInsertUpdateItem: TdsdExecStoredProc;
    macInsertUpdateItem: TMultiAction;
    macInsertUpdateItem_list: TMultiAction;
    actErasedUnErasedChild: TdsdExecStoredProc;
    macErasedUnErasedChild: TMultiAction;
    macErasedUnErasedChild_list: TMultiAction;
    bbInsertUpdateItem_list: TdxBarButton;
    bbErasedUnErasedChild_list: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSettingsServiceForm);

end.
