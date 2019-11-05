unit GoodsRetailTab_Error;

interface

uses
  DataModul, Winapi.Windows, ParentForm, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxCurrencyEdit, cxCheckBox,
  dsdAddOn, dsdDB, dsdAction, System.Classes, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, Datasnap.DBClient, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  Vcl.Controls, cxGrid, AncestorGuides, cxPCdxBarPopupMenu, Vcl.Menus, cxPC,
  dxSkinsCore, dxSkinsDefaultPainters, cxContainer, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxLabel, dsdGuides, cxSplitter, Vcl.DBActns, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, Vcl.ExtCtrls, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TGoodsRetailTab_ErrorForm = class(TAncestorGuidesForm)
    cxGridGChild1: TcxGrid;
    cxGridDBTableViewChild1: TcxGridDBTableView;
    cxGridLevelChild1: TcxGridLevel;
    ChildCDS_1: TClientDataSet;
    ChildDS_1: TDataSource;
    DBViewAddOnChild1: TdsdDBViewAddOn;
    actGoodsLinkRefresh: TdsdDataSetRefresh;
    RefreshDispatcher: TRefreshDispatcher;
    mactDelete: TMultiAction;
    DataSetDelete: TDataSetDelete;
    dsdStoredProc1: TdsdStoredProc;
    dsdExecStoredProc1: TdsdExecStoredProc;
    mactListDelete: TMultiAction;
    N8: TMenuItem;
    N9: TMenuItem;
    Protocol2OpenForm: TdsdOpenForm;
    Protocol3OpenForm: TdsdOpenForm;
    bbProtocol2OpenForm: TdxBarButton;
    bbProtocol3OpenForm: TdxBarButton;
    cxGridLevel1: TcxGridLevel;
    cxSplitter: TcxSplitter;
    Color_UserInsertId: TcxGridDBColumn;
    Color_UserUpdateId: TcxGridDBColumn;
    isErr_DateUpdate: TcxGridDBColumn;
    isErr_UserInsertId: TcxGridDBColumn;
    isErr_DateInsert: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsRetailTab_ErrorForm);

end.
