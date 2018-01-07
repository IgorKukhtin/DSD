unit AdditionalGoods;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorGuides, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxButtonEdit, cxSplitter,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, Vcl.Menus,
  dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel, cxGridCustomView,
  cxGrid, cxPC, cxPCdxBarPopupMenu, cxContainer, cxLabel, cxTextEdit, cxMaskEdit,
  dsdGuides, Vcl.DBActns, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TAdditionalGoodsForm = class(TAncestorGuidesForm)
    ObjectCode: TcxGridDBColumn;
    ValueData: TcxGridDBColumn;
    grSecondGoods: TcxGrid;
    tvSecondGoods: TcxGridDBTableView;
    GoodsSecondName: TcxGridDBColumn;
    glSecondGoods: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    grClientGoods: TcxGrid;
    tvClientGoods: TcxGridDBTableView;
    GoodsClientName: TcxGridDBColumn;
    glClientGoods: TcxGridLevel;
    cxSplitter2: TcxSplitter;
    ClientDS: TDataSource;
    spAdditionalGoods: TdsdStoredProc;
    ClientCDS: TClientDataSet;
    ClientMasterDS: TDataSource;
    spAdditioanlGoodsClient: TdsdStoredProc;
    ClientMasterCDS: TClientDataSet;
    RetailGuides: TdsdGuides;
    AdditionalGoodsDBViewAddOn: TdsdDBViewAddOn;
    AdditionalGoodsClientDBViewAddOn: TdsdDBViewAddOn;
    actGoodsChoice: TOpenChoiceForm;
    actInsertUpdateLink: TdsdUpdateDataSet;
    spInsertUpdate_Object_AdditionalGoods: TdsdStoredProc;
    mactInsert: TMultiAction;
    InsertRecord: TInsertRecord;
    DataSetPost: TDataSetPost;
    DataSetCancel: TDataSetCancel;
    actDeleteLink: TdsdExecStoredProc;
    mactDeleteLink: TMultiAction;
    DataSetDelete: TDataSetDelete;
    spDelete_Object_AdditionalGoods: TdsdStoredProc;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    GridAll: TcxGrid;
    GridAllDBTableView: TcxGridDBTableView;
    Id: TcxGridDBColumn;
    GridAllLevel1: TcxGridLevel;
    cxSplitter3: TcxSplitter;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    cdsAll: TClientDataSet;
    spAll: TdsdStoredProc;
    dsAll: TDataSource;
    GoodsMainId: TcxGridDBColumn;
    GoodsMainCode: TcxGridDBColumn;
    GoodsMainName: TcxGridDBColumn;
    GoodsId: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    NDS: TcxGridDBColumn;
    cxSplitter4: TcxSplitter;
    cxSplitter5: TcxSplitter;
    GoodsSecondCode: TcxGridDBColumn;
    GoodsCodeInt: TcxGridDBColumn;
    MakerName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}
initialization
  RegisterClass(TAdditionalGoodsForm);

end.
