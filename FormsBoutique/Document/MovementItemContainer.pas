unit MovementItemContainer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxCurrencyEdit, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxContainer, cxCheckBox, cxButtonEdit;

type
  TMovementItemContainerForm = class(TAncestorDBGridForm)
    FormParams: TdsdFormParams;
    colJuridicalBasisCode: TcxGridDBColumn;
    colJuridicalBasisName: TcxGridDBColumn;
    cbInfoMoneyDetail: TcxCheckBox;
    bbIsInfoMoneyDetail: TdxBarControlContainerItem;
    RefreshDispatcher: TRefreshDispatcher;
    bbIsDestination: TdxBarControlContainerItem;
    cbDestination: TcxCheckBox;
    bbIsParentDetail: TdxBarControlContainerItem;
    cbParentDetail: TcxCheckBox;
    Amount_Currency: TcxGridDBColumn;
    CurrencyName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMovementItemContainerForm);

end.
