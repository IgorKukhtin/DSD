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
  dsdGuides, cxCurrencyEdit;

type
  TPriceListItemsLoadForm = class(TAncestorDBGridForm)
    FormParams: TdsdFormParams;
    Panel1: TPanel;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colGoodsNDS: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colExpirationDate: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colCode: TcxGridDBColumn;
    actChoiceGoods: TOpenChoiceForm;
    cxLabel2: TcxLabel;
    edOperDate: TcxDateEdit;
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    spGet: TdsdStoredProc;
    GuidesFrom: TdsdGuides;
    actUpdate: TdsdUpdateDataSet;
    spUpdatePriceListItem: TdsdStoredProc;
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
