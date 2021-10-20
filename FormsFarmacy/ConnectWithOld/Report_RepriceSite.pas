unit Report_RepriceSite;

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
  TReport_RepriceSiteForm = class(TAncestorDBGridForm)
    colMidPriceUnit: TcxGridDBColumn;
    colUnitPriceDiff: TcxGridDBColumn;
    colMidPriceUnitDiff: TcxGridDBColumn;
    colNewPriceCalc: TcxGridDBColumn;
    colMidPriceIncome: TcxGridDBColumn;
    colMinPriceIncome: TcxGridDBColumn;
    cplMaxPriceIncome: TcxGridDBColumn;
    colNewPriceMidUnit: TcxGridDBColumn;
    colPriceUnitBase: TcxGridDBColumn;
    colisNewPrice: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_RepriceSiteForm);

end.
