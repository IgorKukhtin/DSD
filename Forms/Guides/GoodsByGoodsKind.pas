unit GoodsByGoodsKind;

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
  TGoodsByGoodsKindForm = class(TAncestorEnumForm)
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
    GoodsSubOpenChoice: TOpenChoiceForm;
    GoodsKindSubChoiceForm: TOpenChoiceForm;
    ReceiptName: TcxGridDBColumn;
    ReceiptChoiceForm: TOpenChoiceForm;
    ReceiptCode: TcxGridDBColumn;
    Id: TcxGridDBColumn;
    ChangePercentAmount: TcxGridDBColumn;
    spUpdate_isParam: TdsdStoredProc;
    GoodsKindPackChoiceForm: TOpenChoiceForm;
    GoodsPackOpenChoice: TOpenChoiceForm;
    GoodsSubSendOpenChoice: TOpenChoiceForm;
    GoodsKindSubSendChoiceForm: TOpenChoiceForm;
    ReceiptGPChoiceForm: TOpenChoiceForm;
    spUpdateNewQuality: TdsdStoredProc;
    actUpdateNewQuality: TdsdDataSetRefresh;
    bbUpdateNewQuality: TdxBarButton;
    GoodsSubOpenChoice_Br: TOpenChoiceForm;
    GoodsKindSubSendChoiceForm_Br: TOpenChoiceForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
 initialization
  RegisterClass(TGoodsByGoodsKindForm);
end.
