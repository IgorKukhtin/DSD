unit GoodsByGoodsKind_VMC;

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
  dxSkinXmas2008Blue, cxContainer, dsdGuides, cxTextEdit, cxMaskEdit, cxLabel,
  Vcl.ExtCtrls;

type
  TGoodsByGoodsKind_VMCForm = class(TAncestorEnumForm)
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
    spInsertUpdateList: TdsdStoredProc;
    ExecuteDialogUpdate: TExecuteDialog;
    actUpdateList: TdsdDataSetRefresh;
    macUpdateList: TMultiAction;
    macUpdate: TMultiAction;
    FormParams: TdsdFormParams;
    bbUpdate: TdxBarButton;
    cxLabel27: TcxLabel;
    edGoodsBrand: TcxButtonEdit;
    GuidesGoodsBrand: TdsdGuides;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    spUpdateGoodsBrand: TdsdStoredProc;
    actUpdateGoodsBrand: TdsdDataSetRefresh;
    macUpdateGoodsBrandList: TMultiAction;
    macUpdateGoodsBrand: TMultiAction;
    bbUpdateGoodsBrand: TdxBarButton;
    GoodsBrandName: TcxGridDBColumn;
    isGoodsTypeKind_Sh: TcxGridDBColumn;
    isGoodsTypeKind_Nom: TcxGridDBColumn;
    spUpdateSh_Yes: TdsdStoredProc;
    spUpdateNom_Yes: TdsdStoredProc;
    spUpdateSh_No: TdsdStoredProc;
    spUpdateVes_Yes: TdsdStoredProc;
    spUpdateNom_No: TdsdStoredProc;
    spUpdateVes_No: TdsdStoredProc;
    actUpdateSh_Yes: TdsdDataSetRefresh;
    actUpdateSh_No: TdsdDataSetRefresh;
    actUpdateNom_Yes: TdsdDataSetRefresh;
    actUpdateNom_No: TdsdDataSetRefresh;
    actUpdateVes_Yes: TdsdDataSetRefresh;
    actUpdateVes_No: TdsdDataSetRefresh;
    macListUpdateSh_Yes: TMultiAction;
    macUpdateSh_Yes: TMultiAction;
    macListUpdateSh_No: TMultiAction;
    macListUpdateNom_Yes: TMultiAction;
    macUpdateSh_No: TMultiAction;
    macUpdateNom_No: TMultiAction;
    macUpdateNom_Yes: TMultiAction;
    macListUpdateNom_No: TMultiAction;
    macListUpdateVes_No: TMultiAction;
    macUpdateVes_No: TMultiAction;
    macListUpdateVes_Yes: TMultiAction;
    macUpdateVes_Yes: TMultiAction;
    bbUpdateSh_Yes: TdxBarButton;
    bbUpdateSh_No: TdxBarButton;
    bbUpdateNom_Yes: TdxBarButton;
    bbUpdateNom_No: TdxBarButton;
    bbUpdateVes_Yes: TdxBarButton;
    bbUpdateVes_No: TdxBarButton;
    BoxChoiceForm: TOpenChoiceForm;
    Box2ChoiceForm: TOpenChoiceForm;
    Panel: TPanel;
    edRetail2: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel6: TcxLabel;
    edRetail1: TcxButtonEdit;
    GuidesRetail1: TdsdGuides;
    GuidesRetail2: TdsdGuides;
    cxLabel1: TcxLabel;
    edRetail3: TcxButtonEdit;
    GuidesRetail3: TdsdGuides;
    cxLabel2: TcxLabel;
    edRetail4: TcxButtonEdit;
    GuidesRetail4: TdsdGuides;
    cxLabel4: TcxLabel;
    edRetail5: TcxButtonEdit;
    GuidesRetail5: TdsdGuides;
    cxLabel5: TcxLabel;
    edRetail6: TcxButtonEdit;
    GuidesRetail6: TdsdGuides;
    BoxRetailForm1: TOpenChoiceForm;
    BoxRetailForm2: TOpenChoiceForm;
    BoxRetailForm3: TOpenChoiceForm;
    BoxRetailForm4: TOpenChoiceForm;
    BoxRetailForm5: TOpenChoiceForm;
    BoxRetailForm6: TOpenChoiceForm;
    RefreshDispatcher: TRefreshDispatcher;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    WmsCellNum: TcxGridDBColumn;
    actGoods_shOpenChoice: TOpenChoiceForm;
    actGoodsKind_shOpenForm: TOpenChoiceForm;
    ProtocolGoodsPropertyBoxId_2: TdsdOpenForm;
    ProtocolGoodsPropertyBoxId: TdsdOpenForm;
    bbProtocolGoodsPropertyBoxId: TdxBarButton;
    bbProtocolGoodsPropertyBoxId_2: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
 initialization
  RegisterClass(TGoodsByGoodsKind_VMCForm);
end.
