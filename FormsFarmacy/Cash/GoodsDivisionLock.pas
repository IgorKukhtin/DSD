unit GoodsDivisionLock;

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
  DataModul, cxContainer, dsdGuides, cxLabel, cxTextEdit, cxMaskEdit,
  cxButtonEdit;

type
  TGoodsDivisionLockForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
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
    dsdGridToExcel: TdsdGridToExcel;
    dsdStoredProc: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    isErased: TcxGridDBColumn;
    spErasedUnErased: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    bbProtocolOpenForm: TdxBarButton;
    dxBarButton1: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    ceUnit: TcxButtonEdit;
    cxLabel3: TcxLabel;
    UnitGuides: TdsdGuides;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    dxBarButton2: TdxBarButton;
    UnitName: TcxGridDBColumn;
    isLock: TcxGridDBColumn;
    actProtocolOpenForm: TdsdOpenForm;
    dxBarButton3: TdxBarButton;
    dsdChoiceGuides: TdsdUpdateDataSet;
    spUpdate: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

{$R *.dfm}
initialization
  RegisterClass(TGoodsDivisionLockForm);
end.
