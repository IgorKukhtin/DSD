unit GoodsCategory;

interface

uses
  DataModul, Winapi.Windows, ParentForm, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxCurrencyEdit, cxCheckBox,
  dsdAddOn, dsdDB, dsdAction, System.Classes, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, Datasnap.DBClient, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  Vcl.Controls, cxGrid, AncestorGuides, cxPCdxBarPopupMenu, Vcl.Menus, cxPC,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
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
  dxSkinXmas2008Blue, cxContainer, dsdGuides, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxLabel, Vcl.ExtCtrls;

type
  TGoodsCategoryForm = class(TAncestorGuidesForm)
    GoodsCode: TcxGridDBColumn;
    UnitCategoryName: TcxGridDBColumn;
    Value: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GuidesUnitCategory: TdsdGuides;
    actShowAll: TBooleanStoredProcAction;
    actShowDel: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    bbShowDel: TdxBarButton;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    bbUnitCategory: TdxBarControlContainerItem;
    RefreshDispatcher: TRefreshDispatcher;
    FormParams: TdsdFormParams;
    Panel: TPanel;
    cxLabel2: TcxLabel;
    edUnit: TcxButtonEdit;
    edUnitCategory: TcxButtonEdit;
    cxLabel1: TcxLabel;
    GuidesUnit: TdsdGuides;
    UnitName: TcxGridDBColumn;
    actRefreshList: TdsdDataSetRefresh;
    cbList: TcxCheckBox;
    spSelect_GoodsCategoryCopy: TdsdStoredProc;
    actSelect_GoodsCategoryCopy: TdsdExecStoredProc;
    actChoiceUnit: TOpenChoiceForm;
    bbSelect_GoodsCategoryCopy: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsCategoryForm);

end.
