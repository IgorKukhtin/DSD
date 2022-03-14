unit PriceListItemsLoad;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, Vcl.ExtCtrls, cxButtonEdit, cxContainer, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel,
  dsdGuides, cxCurrencyEdit, Vcl.DBActns, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TPriceListItemsLoadForm = class(TAncestorDBGridForm)
    FormParams: TdsdFormParams;
    Panel1: TPanel;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsNDS: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    ExpirationDate: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    Code: TcxGridDBColumn;
    actChoiceGoods: TOpenChoiceForm;
    cxLabel2: TcxLabel;
    edOperDate: TcxDateEdit;
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    spGet: TdsdStoredProc;
    GuidesFrom: TdsdGuides;
    actUpdate: TdsdUpdateDataSet;
    spUpdatePriceListItem: TdsdStoredProc;
    CommonCode: TcxGridDBColumn;
    ProducerName: TcxGridDBColumn;
    bbDeleteGoodsLink: TdxBarButton;
    mactGoodsLinkDelete: TMultiAction;
    DataSetPost: TDataSetPost;
    BarCode: TcxGridDBColumn;
    Remains: TcxGridDBColumn;
    spGetMovement: TdsdStoredProc;
    actGetMovement: TdsdExecStoredProc;
    actOpenMovementPriceList: TdsdInsertUpdateAction;
    MacGetMovement: TMultiAction;
    bbGetMovement: TdxBarButton;
    cxLabel5: TcxLabel;
    edArea: TcxButtonEdit;
    GuidesArea: TdsdGuides;
    IsPromo: TcxGridDBColumn;
    actUpdate_Goods_Promo: TMultiAction;
    spUpdate_Goods_Promo: TdsdStoredProc;
    actExecUpdate_Goods_Promo: TdsdExecStoredProc;
    dxBarSubItem1: TdxBarSubItem;
    bbUpdate_Goods_Promo: TdxBarButton;
    isResolution_224: TcxGridDBColumn;
    spUpdate_inResolution_224_No: TdsdStoredProc;
    spUpdate_inResolution_224_Yes: TdsdStoredProc;
    actisResolution_224_Yes: TMultiAction;
    mainResolution_224_Yes: TMultiAction;
    actUpdate_inResolution_224_Yes: TdsdExecStoredProc;
    actinResolution_224_No: TMultiAction;
    mainResolution_224_No: TMultiAction;
    actUpdate_inResolution_224_No: TdsdExecStoredProc;
    bbisResolution_224_Yes: TdxBarButton;
    bbtinResolution_224_No: TdxBarButton;
    IsClose: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPriceListItemsLoadForm);

end.
