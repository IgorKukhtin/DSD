unit UnitPeresort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, dxSkinsdxBarPainter, dsdAddOn,
  dsdDB, dsdAction, Vcl.ActnList, dxBarExtItems, dxBar, cxClasses,
  cxPropertiesStore, Datasnap.DBClient, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxCheckBox,
  cxButtonEdit, cxImageComboBox, cxSplitter, cxCurrencyEdit, dsdCommon;

type
  TUnitPeresortForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbInsert: TdxBarButton;
    bbEdit: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    dsdGridToExcel: TdsdGridToExcel;
    dsdStoredProc: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdChoiceGuides: TdsdChoiceGuides;
    spErasedUnErased: TdsdStoredProc;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    UnitsDS: TDataSource;
    UnitsCDS: TClientDataSet;
    cxGridUnit: TcxGrid;
    cxGridDBTableViewUnit: TcxGridDBTableView;
    GoodsName: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    clisErased: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    cxTopSplitter: TcxSplitter;
    spSelectUnitPeresort_Unit: TdsdStoredProc;
    spInsertUpdateUnitPeresort: TdsdStoredProc;
    ChildViewAddOn: TdsdDBViewAddOn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    actInsertChild: TdsdInsertUpdateAction;
    actUpdateChild: TdsdInsertUpdateAction;
    spErasedUnErasedChild: TdsdStoredProc;
    dsdSetErasedChild: TdsdUpdateErased;
    dsdSetUnErasedChild: TdsdUpdateErased;
    ProtocolOpenFormChild: TdsdOpenForm;
    bbProtocolOpenFormChild: TdxBarButton;
    bbInsertChild: TdxBarButton;
    bbUpdateChild: TdxBarButton;
    bbSetErasedChild: TdxBarButton;
    bbSetUnErasedChild: TdxBarButton;
    InsertRecordChild: TInsertRecord;
    actUnitChoicetForm: TOpenChoiceForm;
    actUpdateDataSetChild: TdsdUpdateDataSet;
    spInsertUpdate: TdsdStoredProc;
    GoodsIncomeOpenChoice: TOpenChoiceForm;
    GoodsKindIncomeChoiceForm: TOpenChoiceForm;
    actUpdateDataSet: TdsdUpdateDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
 initialization
  RegisterClass(TUnitPeresortForm);
end.
