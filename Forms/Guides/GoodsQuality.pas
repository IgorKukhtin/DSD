unit GoodsQuality;

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
  DataModul, cxButtonEdit, cxContainer, cxLabel, dsdGuides, cxTextEdit,
  cxMaskEdit;

type
  TGoodsQualityForm = class(TParentForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Value1: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    bbRefresh: TdxBarButton;
    bbGridToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbChoiceGuides: TdxBarButton;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    dsdGridToExcel: TdsdGridToExcel;
    dsdStoredProc: TdsdStoredProc;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    Value2: TcxGridDBColumn;
    dsdChoiceGuides: TdsdChoiceGuides;
    isErased: TcxGridDBColumn;
    Value3: TcxGridDBColumn;
    Value4: TcxGridDBColumn;
    Value5: TcxGridDBColumn;
    Value6: TcxGridDBColumn;
    spInsertUpdateObject: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    Name: TcxGridDBColumn;
    Value7: TcxGridDBColumn;
    Value8: TcxGridDBColumn;
    Value9: TcxGridDBColumn;
    Value10: TcxGridDBColumn;
    GoodsChoiceForm: TOpenChoiceForm;
    actShowAll: TBooleanStoredProcAction;
    bbactShowAll: TdxBarButton;
    bb: TdxBarControlContainerItem;
    bb1: TdxBarControlContainerItem;
    ceQuality: TcxButtonEdit;
    dsdQualityGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    RefreshDispatcher: TRefreshDispatcher;
    GoodsGroupName: TcxGridDBColumn;
    QualityName: TcxGridDBColumn;
    QualityChoiceForm: TOpenChoiceForm;
    GoodsCode: TcxGridDBColumn;
    QualityCode: TcxGridDBColumn;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
 initialization
  RegisterClass(TGoodsQualityForm);
end.
