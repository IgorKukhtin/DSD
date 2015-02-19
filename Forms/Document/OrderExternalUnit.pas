unit OrderExternalUnit;

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
  TOrderExternalUnitForm = class(TAncestorDocumentForm)
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
    PrintItemsCDS: TClientDataSet;
    PrintItemsSverkaCDS: TClientDataSet;
    AmountSecond: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    edInvNumberOrder: TcxTextEdit;
    cxLabel3: TcxLabel;
    edOperDateMark: TcxDateEdit;
    cxLabel10: TcxLabel;
    edOperDatePartner: TcxDateEdit;
    cxLabel4: TcxLabel;
    edFrom: TcxButtonEdit;
    cxLabel6: TcxLabel;
    edPaidKind: TcxButtonEdit;
    cxLabel9: TcxLabel;
    edContract: TcxButtonEdit;
    cxLabel13: TcxLabel;
    edRouteSorting: TcxButtonEdit;
    PaidKindGuides: TdsdGuides;
    ContractGuides: TdsdGuides;
    GuidesRouteSorting: TdsdGuides;
    GuidesFrom: TdsdGuides;
    cxLabel7: TcxLabel;
    edRoute: TcxButtonEdit;
    GuidesRoute: TdsdGuides;
    cxLabel16: TcxLabel;
    edPersonal: TcxButtonEdit;
    GuidesPersonal: TdsdGuides;
    cxLabel11: TcxLabel;
    edPriceList: TcxButtonEdit;
    PriceListGuides: TdsdGuides;
    Price: TcxGridDBColumn;
    CountForPrice: TcxGridDBColumn;
    AmountSumm: TcxGridDBColumn;
    cxLabel8: TcxLabel;
    edTo: TcxButtonEdit;
    GuidesTo: TdsdGuides;
    AmountSumm_Partner: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    edPriceWithVAT: TcxCheckBox;
    cxLabel12: TcxLabel;
    edVATPercent: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    edContractTag: TcxButtonEdit;
    cxLabel17: TcxLabel;
    ContractTagGuides: TdsdGuides;
    AmountRemains: TcxGridDBColumn;
    spSavePrintState: TdsdStoredProc;
    actSPSavePrintState: TdsdExecStoredProc;
    mactPrint_Order: TMultiAction;
    cbPrinted: TcxCheckBox;
    edDayCount: TcxCurrencyEdit;
    cxLabel18: TcxLabel;
    AmountPartner: TcxGridDBColumn;
    AmountForecast: TcxGridDBColumn;
    spUpdateAmountRemains: TdsdStoredProc;
    actUpdateAmountRemains: TdsdExecStoredProc;
    actUpdateAmountPartner: TdsdExecStoredProc;
    actUpdateAmountForecast: TdsdExecStoredProc;
    bbUpdateAmountRemains: TdxBarButton;
    bbUpdateAmountPartner: TdxBarButton;
    bbUpdateAmountForecast: TdxBarButton;
    bbUpdateAmountAll: TdxBarButton;
    MultiAmountRemain: TMultiAction;
    spUpdateAmountPartner: TdsdStoredProc;
    MultiAmountPartner: TMultiAction;
    dsdRefreshMI: TdsdDataSetRefresh;
    actUpdateAmountAll: TMultiAction;
    spUpdateAmountForecast: TdsdStoredProc;
    MultiAmountForecast: TMultiAction;
    AmountCalc: TcxGridDBColumn;
    cxLabel19: TcxLabel;
    cxLabel20: TcxLabel;
    ceOperDateStart: TcxDateEdit;
    ceOperDateEnd: TcxDateEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderExternalUnitForm);

end.
