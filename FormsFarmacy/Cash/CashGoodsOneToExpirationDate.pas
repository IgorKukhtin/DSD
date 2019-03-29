unit CashGoodsOneToExpirationDate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, cxLabel, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxCurrencyEdit;

type
  TCashGoodsOneToExpirationDateForm = class(TAncestorDBGridForm)
    bbOpen: TdxBarButton;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    SummCard: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    ExpirationDate: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCashGoodsOneToExpirationDateForm);

end.
