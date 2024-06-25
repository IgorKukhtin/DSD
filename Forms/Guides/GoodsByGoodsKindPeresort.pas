unit GoodsByGoodsKindPeresort;

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
  dxSkinXmas2008Blue, ExternalLoad, dsdCommon;

type
  TGoodsByGoodsKindPeresortForm = class(TAncestorEnumForm)
    GoodsKindName_in: TcxGridDBColumn;
    Weight_out: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    actChoiceFormGoods_in: TOpenChoiceForm;
    actChoiceFormGoodsKind_in: TOpenChoiceForm;
    InsertRecord: TInsertRecord;
    bbInsertRecord: TdxBarButton;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocol: TdxBarButton;
    actChoiceFormGoods_out: TOpenChoiceForm;
    actChoiceFormGoodsKind_out: TOpenChoiceForm;
    FormParams: TdsdFormParams;
    spGetImportSettingId: TdsdStoredProc;
    bbStartLoad: TdxBarButton;
    spErasedUnErased: TdsdStoredProc;
    actSetErased: TdsdUpdateErased;
    actSetUnErased: TdsdUpdateErased;
    actShowAll: TBooleanStoredProcAction;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    bbShowAll: TdxBarButton;
    actDoLoad: TExecuteImportSettingsAction;
    actGetImportSetting: TdsdExecStoredProc;
    macStartLoad: TMultiAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
 initialization
  RegisterClass(TGoodsByGoodsKindPeresortForm);
end.
