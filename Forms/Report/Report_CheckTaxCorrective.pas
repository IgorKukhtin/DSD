unit Report_CheckTaxCorrective;

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
  TReport_CheckTaxCorrectiveForm = class(TAncestorReportForm)
    clInvNumber_ReturnIn: TcxGridDBColumn;
    clGoodsCode: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    clAmount_ReturnIn: TcxGridDBColumn;
    clAmount_TaxCorrective: TcxGridDBColumn;
    clFromCode: TcxGridDBColumn;
    clGoodsKindName: TcxGridDBColumn;
    clOperDate_ReturnIn: TcxGridDBColumn;
    clFromName: TcxGridDBColumn;
    clToCode: TcxGridDBColumn;
    clToName: TcxGridDBColumn;
    clPrice_ReturnIn: TcxGridDBColumn;
    clPrice_TaxCorrective: TcxGridDBColumn;
    clDifference: TcxGridDBColumn;
    clInvNumber_TaxCorrective: TcxGridDBColumn;
    clOperDate_TaxCorrective: TcxGridDBColumn;
    clDocumentTaxKindName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_CheckTaxCorrectiveForm);

end.
