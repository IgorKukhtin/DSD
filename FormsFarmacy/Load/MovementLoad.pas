unit MovementLoad;

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
  TMovementLoadForm = class(TAncestorDBGridForm)
    clOperDate: TcxGridDBColumn;
    actOpenPriceList: TdsdInsertUpdateAction;
    bbOpen: TdxBarButton;
    clInvNumber: TcxGridDBColumn;
    clTotalCount: TcxGridDBColumn;
    clTotalSumm: TcxGridDBColumn;
    clJuridicalId: TcxGridDBColumn;
    clUnitId: TcxGridDBColumn;
    clNDSKindId: TcxGridDBColumn;
    clIsAllGoodsConcat: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMovementLoadForm);

end.
