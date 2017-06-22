unit AlternativeGroup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, dsdAction, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses,
  dsdDB, Datasnap.DBClient, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxButtonEdit, Vcl.DBActns, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxPCdxBarPopupMenu,
  dxSkinsdxBarPainter;

type
  TAlternativeGroupForm = class(TAncestorEnumForm)
    actShowDel: TBooleanStoredProcAction;
    actShowDelGoods: TBooleanStoredProcAction;
    Id: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    dxBarButton1: TdxBarButton;
    GridGoods: TcxGrid;
    GridGoodsTableView: TcxGridDBTableView;
    GridGoodsLevel: TcxGridLevel;
    GoodsCDS: TClientDataSet;
    GoodsDS: TDataSource;
    spSelect_AlternativeGroup_Goods: TdsdStoredProc;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    AlternativeGroupId: TcxGridDBColumn;
    GoodsId: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    clisErased: TcxGridDBColumn;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    spInsertUpdate_AlternativeGroup: TdsdStoredProc;
    spInsertUpdate_AlternativeGroup_Goods: TdsdStoredProc;
    dsdUpdateDataSet_Object_AlternativeGroup: TdsdUpdateDataSet;
    dsdUpdateDataSet_AlternativeGroup_Goods: TdsdUpdateDataSet;
    OpenChoiceFormGoods: TOpenChoiceForm;
    spDelete_AlternativeGroup_Goods: TdsdStoredProc;
    actDeleteDataSet: TDataSetDelete;
    actExecuteDeleteLinkGoods: TdsdExecStoredProc;
    actDeleteLink: TMultiAction;
    dxBarButton4: TdxBarButton;
    spErasedUnErased: TdsdStoredProc;
    actSetErased: TdsdUpdateErased;
    actSetUnErased: TdsdUpdateErased;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AlternativeGroupForm: TAlternativeGroupForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TAlternativeGroupForm)

end.
