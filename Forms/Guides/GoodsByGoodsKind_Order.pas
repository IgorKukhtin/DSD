unit GoodsByGoodsKind_Order;

interface

uses
  Winapi.Windows, AncestorEnum, DataModul, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox, dsdAddOn, dsdDB,
  Datasnap.DBClient, dsdAction, System.Classes, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, Vcl.Controls, cxGrid,
  cxPCdxBarPopupMenu, Vcl.Menus, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxButtonEdit, cxCurrencyEdit,
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
  TGoodsByGoodsKind_OrderForm = class(TAncestorEnumForm)
    GoodsKindName: TcxGridDBColumn;
    WeightPackage: TcxGridDBColumn;
    WeightTotal: TcxGridDBColumn;
    isOrder: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    GoodsOpenChoice: TOpenChoiceForm;
    GoodsKindChoiceForm: TOpenChoiceForm;
    InsertRecord: TInsertRecord;
    bbInsertRecord: TdxBarButton;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    isNotMobile: TcxGridDBColumn;
    IsNewQuality: TcxGridDBColumn;
    actUpdateNewQuality: TdsdDataSetRefresh;
    spUpdateNewQuality: TdsdStoredProc;
    bbUpdateNewQuality: TdxBarButton;
    spUpdate_Top_Yes: TdsdStoredProc;
    bbUpdate_Top: TdxBarButton;
    spUpdate_Top_No: TdsdStoredProc;
    bbUpdate_Top_No: TdxBarButton;
    actUpdate_Top_No: TdsdExecStoredProc;
    actUpdate_Top_Yes: TdsdExecStoredProc;
    NormPack: TcxGridDBColumn;
    spUpdate_PackOrder: TdsdStoredProc;
    actUpdate_PackOrder: TdsdDataSetRefresh;
    bbUpdate_PackOrder: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
 initialization
  RegisterClass(TGoodsByGoodsKind_OrderForm);
end.
