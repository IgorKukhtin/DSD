unit PriceListLoad_Add;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxContainer, dsdGuides, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxLabel, cxCurrencyEdit;

type
  TPriceListLoad_AddForm = class(TAncestorDBGridForm)
    OperDate: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    actOpenPriceList: TdsdInsertUpdateAction;
    NDSinPrice: TcxGridDBColumn;
    bbOpen: TdxBarButton;
    spLoadPriceList: TdsdStoredProc;
    actLoadPriceList: TdsdExecStoredProc;
    bbLoadPriceList: TdxBarButton;
    spUpdateGoods: TdsdStoredProc;
    ContractName: TcxGridDBColumn;
    mactLoadPriceList: TMultiAction;
    N3: TMenuItem;
    IsMoved: TcxGridDBColumn;
    actOneLoadPriceList: TdsdExecStoredProc;
    mactLoadPrice1: TMultiAction;
    actDeletePriceListLoad: TdsdExecStoredProc;
    bbDelete: TdxBarButton;
    spDelete: TdsdStoredProc;
    actOpenMovementPriceList: TdsdInsertUpdateAction;
    FormParams: TdsdFormParams;
    MacGetMovement: TMultiAction;
    spGetMovement: TdsdStoredProc;
    actGetMovement: TdsdExecStoredProc;
    bbGetMovement: TdxBarButton;
    AreaName: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    edArea: TcxButtonEdit;
    GuidesArea: TdsdGuides;
    bbText: TdxBarControlContainerItem;
    bbedArea: TdxBarControlContainerItem;
    Amount_all: TcxGridDBColumn;
    Amount_tied: TcxGridDBColumn;
    Amount_untied: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPriceListLoad_AddForm);

end.
