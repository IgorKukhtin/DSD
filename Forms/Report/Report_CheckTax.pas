unit Report_CheckTax;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus;

type
  TReport_CheckTaxForm = class(TAncestorReportForm)
    clInvNumber_Sale: TcxGridDBColumn;
    clInvNumber_Tax: TcxGridDBColumn;
    clGoodsCode: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    clAmount_Sale: TcxGridDBColumn;
    clAmount_Tax: TcxGridDBColumn;
    clFromCode: TcxGridDBColumn;
    clGoodsKindName: TcxGridDBColumn;
    clOperDate_Sale: TcxGridDBColumn;
    clOperDate_Tax: TcxGridDBColumn;
    clFromName: TcxGridDBColumn;
    clToCode: TcxGridDBColumn;
    clToName: TcxGridDBColumn;
    clPrice_Sale: TcxGridDBColumn;
    clPrice_Tax: TcxGridDBColumn;
    clDifference: TcxGridDBColumn;
    clDocumentTaxKindName: TcxGridDBColumn;
    clContract_InvNumber: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_CheckTaxForm);

end.
