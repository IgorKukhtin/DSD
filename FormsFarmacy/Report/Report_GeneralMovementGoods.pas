unit Report_GeneralMovementGoods;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  AncestorEnum, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, Data.DB, cxDBData, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxPC, cxContainer, cxTextEdit,
  cxLabel, cxCurrencyEdit, cxButtonEdit, Vcl.DBActns, cxMaskEdit, Vcl.ExtCtrls,
  dxBarBuiltInMenu, cxNavigator, Vcl.StdCtrls, cxButtons, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.ComCtrls,
  dxCore, cxDateUtils, cxDropDownEdit, cxCalendar, cxGridBandedTableView,
  cxGridDBBandedTableView, ChoicePeriod, dsdGuides, cxCheckBox;

type
  TReport_GeneralMovementGoodsForm = class(TAncestorEnumForm)
    edCodeSearch: TcxTextEdit;
    cxLabel1: TcxLabel;
    ChoiceGoodsForm: TOpenChoiceForm;
    UpdateDataSet: TdsdUpdateDataSet;
    actSetGoodsLink: TdsdExecStoredProc;
    bbGoodsPriceListLink: TdxBarButton;
    mactChoiceGoodsForm: TMultiAction;
    actRefreshSearch: TdsdExecStoredProc;
    Panel1: TPanel;
    actDeleteLink: TdsdExecStoredProc;
    actRefreshSearch2: TdsdExecStoredProc;
    cxLabel3: TcxLabel;
    cxLabel2: TcxLabel;
    edGoodsSearch: TcxTextEdit;
    cxLabel4: TcxLabel;
    dxBarButton1: TdxBarButton;
    FormParams: TdsdFormParams;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    GoodsCode: TcxGridDBBandedColumn;
    UnitName: TcxGridDBBandedColumn;
    SummaSale: TcxGridDBBandedColumn;
    SummaIncome: TcxGridDBBandedColumn;
    AmountIncome: TcxGridDBBandedColumn;
    SummaProfit: TcxGridDBBandedColumn;
    Remains: TcxGridDBBandedColumn;
    RemainsSum: TcxGridDBBandedColumn;
    ceUnit: TcxButtonEdit;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    deStart: TcxDateEdit;
    cxLabel7: TcxLabel;
    deEnd: TcxDateEdit;
    GuidesUnit: TdsdGuides;
    PeriodChoice: TPeriodChoice;
    AmountSale: TcxGridDBBandedColumn;
    actGridToExcelReport: TdsdGridToExcel;
    bbGridToExcelReport: TdxBarButton;
    GoodsName: TcxGridDBBandedColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    RefreshDispatcher: TRefreshDispatcher;
    edGoods: TcxButtonEdit;
    cxLabel8: TcxLabel;
    GuidesGoods: TdsdGuides;
    cbTabletki: TcxCheckBox;
    cbMobile: TcxCheckBox;
    cbNeBoley: TcxCheckBox;
    SummChangePercent: TcxGridDBBandedColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_GeneralMovementGoodsForm);

end.
