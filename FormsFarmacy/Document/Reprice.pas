unit Reprice;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit;

type
  TRepriceForm = class(TAncestorDocumentForm)
    edUnit: TcxButtonEdit;
    lblUnit: TcxLabel;
    GuidesUnit: TdsdGuides;
    cxLabel3: TcxLabel;
    edTotalSumm: TcxTextEdit;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colPriceOld: TcxGridDBColumn;
    colPriceNew: TcxGridDBColumn;
    colSummReprice: TcxGridDBColumn;
    colMinExpirationDate: TcxGridDBColumn;
    colNDS: TcxGridDBColumn;
    colPriceDiff: TcxGridDBColumn;
    colJuridicalName: TcxGridDBColumn;
    colJuridical_GoodsName: TcxGridDBColumn;
    colMakerName: TcxGridDBColumn;
    colMarginPercent: TcxGridDBColumn;
    colJuridical_Price: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
   
{$R *.dfm}

initialization
  RegisterClass(TRepriceForm);
end.
