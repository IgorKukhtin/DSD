unit OrderInternal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter;

type
  TOrderInternalForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    bbPrintTax: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    bbTax: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    AmountSecond: TcxGridDBColumn;
    spUpdateAmountRemains: TdsdStoredProc;
    spUpdateAmountPartner: TdsdStoredProc;
    spUpdateAmountForecast: TdsdStoredProc;
    actUpdateAmountRemains: TdsdExecStoredProc;
    MultiAmountRemain: TMultiAction;
    edOperDatePartner: TcxDateEdit;
    cxLabel10: TcxLabel;
    cxLabel18: TcxLabel;
    edDayCount: TcxCurrencyEdit;
    edOperDateStart: TcxDateEdit;
    cxLabel19: TcxLabel;
    cxLabel20: TcxLabel;
    edOperDateEnd: TcxDateEdit;
    AmountRemains: TcxGridDBColumn;
    AmountPartner: TcxGridDBColumn;
    AmountForecast: TcxGridDBColumn;
    AmountForecastOrder: TcxGridDBColumn;
    CuterCount: TcxGridDBColumn;
    bbMultiAmountRemain: TdxBarButton;
    actUpdateAmountPartner: TdsdExecStoredProc;
    MultiAmountPartner: TMultiAction;
    actUpdateAmountForecast: TdsdExecStoredProc;
    MultiAmountForecast: TMultiAction;
    actUpdateAmountAll: TMultiAction;
    bbMultiAmountPartner: TdxBarButton;
    bbMultiAmountForecast: TdxBarButton;
    bbUpdateAmountAll: TdxBarButton;
    MeasureName: TcxGridDBColumn;
    ReceiptCode: TcxGridDBColumn;
    ReceiptName: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    Koeff: TcxGridDBColumn;
    CountForecast: TcxGridDBColumn;
    CountForecastOrder: TcxGridDBColumn;
    CountForecastK: TcxGridDBColumn;
    CountForecastOrderK: TcxGridDBColumn;
    AmountPartnerPrior: TcxGridDBColumn;
    TermProduction: TcxGridDBColumn;
    NormInDays: TcxGridDBColumn;
    StartProductionInDays: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    ContainerId: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderInternalForm);

end.
