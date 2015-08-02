unit Report_ReceiptSaleAnalyze;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit, Vcl.Grids, Vcl.DBGrids, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TReport_ReceiptSaleAnalyzeForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    edFromUnit: TcxButtonEdit;
    FromUnitGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    edToUnit: TcxButtonEdit;
    ToUnitGuides: TdsdGuides;
    colGoodsGroupNameFull: TcxGridDBColumn;
    cxLabel11: TcxLabel;
    edPriceList_1: TcxButtonEdit;
    PriceList_1_Guides: TdsdGuides;
    cxLabel6: TcxLabel;
    edPriceList_2: TcxButtonEdit;
    cxLabel7: TcxLabel;
    edPriceList_3: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edPriceList_sale: TcxButtonEdit;
    PriceList_2_Guides: TdsdGuides;
    PriceList_3_Guides: TdsdGuides;
    PriceList_sale_Guides: TdsdGuides;
    cxGridLevel1: TcxGridLevel;
    ChildView: TcxGridDBTableView;
    clReceiptid: TcxGridDBColumn;
    AmountChild: TcxGridDBColumn;
    clGoodsCode: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    clPrice1: TcxGridDBColumn;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    ChildViewAddOn: TdsdDBViewAddOn;
    clPrice2: TcxGridDBColumn;
    clPrice3: TcxGridDBColumn;
    Summ1: TcxGridDBColumn;
    Summ2: TcxGridDBColumn;
    Summ3: TcxGridDBColumn;
    OperSumm: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Amount_Weight: TcxGridDBColumn;
    OperCount_Weight: TcxGridDBColumn;
    Price_in: TcxGridDBColumn;
    GroupNumber: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    MeasureNameChild: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    Color_calc: TcxGridDBColumn;
    Receiptid: TcxGridDBColumn;
    isStart: TcxGridDBColumn;
    Amount_start: TcxGridDBColumn;
    Summ1_Start: TcxGridDBColumn;
    Summ2_Start: TcxGridDBColumn;
    Summ3_Start: TcxGridDBColumn;
    ReceiptCode: TcxGridDBColumn;
    ReceiptCode_user: TcxGridDBColumn;
    Price1_cost: TcxGridDBColumn;
    Price2_cost: TcxGridDBColumn;
    Price3_cost: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_ReceiptSaleAnalyzeForm)


end.
