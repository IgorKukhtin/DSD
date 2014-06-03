unit ProductionUnion;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocumentMC, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC;

type
  TProductionUnionForm = class(TAncestorDocumentMCForm)
    actUpdateChildDS: TdsdUpdateDataSet;
    colCount: TcxGridDBColumn;
    colChildLineNum: TcxGridDBColumn;
    colLineNum: TcxGridDBColumn;
    colPartionClose: TcxGridDBColumn;
    colPartionGoods: TcxGridDBColumn;
    colComment: TcxGridDBColumn;
    colRealWeight: TcxGridDBColumn;
    colCuterCount: TcxGridDBColumn;
    colGoodsKindName: TcxGridDBColumn;
    colReceiptName: TcxGridDBColumn;
    colPartionGoodsDate: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProductionUnionForm);

end.
