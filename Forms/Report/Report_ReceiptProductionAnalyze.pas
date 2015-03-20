unit Report_ReceiptProductionAnalyze;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit;

type
  TReport_ReceiptProductionAnalyzeForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    edFromGroup: TcxButtonEdit;
    FromGroupGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    edToGroup: TcxButtonEdit;
    ToGroupGuides: TdsdGuides;
    cxGridDBTableViewColumn1: TcxGridDBColumn;
    cxGridDBTableViewColumn2: TcxGridDBColumn;
    cxGridDBTableViewColumn3: TcxGridDBColumn;
    cxGridDBTableViewColumn4: TcxGridDBColumn;
    cxGridDBTableViewColumn5: TcxGridDBColumn;
    cxGridDBTableViewColumn6: TcxGridDBColumn;
    cxGridDBTableViewColumn7: TcxGridDBColumn;
    cxGridDBTableViewColumn8: TcxGridDBColumn;
    cxGridDBTableViewColumn9: TcxGridDBColumn;
    cxGridDBTableViewColumn10: TcxGridDBColumn;
    cxLabel11: TcxLabel;
    edPriceList: TcxButtonEdit;
    PriceListGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    cxButtonEdit1: TcxButtonEdit;
    cxLabel7: TcxLabel;
    cxButtonEdit2: TcxButtonEdit;
    cxLabel8: TcxLabel;
    cxButtonEdit3: TcxButtonEdit;
    dsdGuides1: TdsdGuides;
    dsdGuides2: TdsdGuides;
    dsdGuides3: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_ReceiptProductionAnalyzeForm: TReport_ReceiptProductionAnalyzeForm;

implementation

{$R *.dfm}

end.
