unit PriceListLoad;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC;

type
  TPriceListLoadForm = class(TAncestorDBGridForm)
    colOperDate: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    actOpenPriceList: TdsdInsertUpdateAction;
    colNDSinPrice: TcxGridDBColumn;
    bbOpen: TdxBarButton;
    spLoadPriceList: TdsdStoredProc;
    actLoadPriceList: TdsdExecStoredProc;
    bbLoadPriceList: TdxBarButton;
    spUpdateGoods: TdsdStoredProc;
    colContractName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPriceListLoadForm);

end.
