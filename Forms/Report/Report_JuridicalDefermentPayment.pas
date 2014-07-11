unit Report_JuridicalDefermentPayment;

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
  cxCurrencyEdit, dsdGuides, cxButtonEdit, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, frxClass, frxDBSet, cxImageComboBox;

type
  TReport_JuridicalDefermentPayment = class(TAncestorReportForm)
    clJuridicalName: TcxGridDBColumn;
    colContractNumber: TcxGridDBColumn;
    colKreditRemains: TcxGridDBColumn;
    colDebetRemains: TcxGridDBColumn;
    colSaleSumm: TcxGridDBColumn;
    colDefermentPaymentRemains: TcxGridDBColumn;
    colSaleSumm1: TcxGridDBColumn;
    colSaleSumm2: TcxGridDBColumn;
    colSaleSumm3: TcxGridDBColumn;
    colSaleSumm4: TcxGridDBColumn;
    colSaleSumm5: TcxGridDBColumn;
    clAccountName: TcxGridDBColumn;
    colCondition: TcxGridDBColumn;
    edAccount: TcxButtonEdit;
    cxLabel3: TcxLabel;
    AccountGuides: TdsdGuides;
    actPrintOneWeek: TdsdPrintAction;
    actPrintTwoWeek: TdsdPrintAction;
    actPrintThreeWeek: TdsdPrintAction;
    actPrintFourWeek: TdsdPrintAction;
    spReport: TdsdStoredProc;
    cdsReport: TClientDataSet;
    bbReportOneWeek: TdxBarButton;
    FormParams: TdsdFormParams;
    bbTwoWeek: TdxBarButton;
    bbThreeWeek: TdxBarButton;
    bbFourWeek: TdxBarButton;
    bbOther: TdxBarButton;
    actPrint: TdsdPrintAction;
    bbPribt: TdxBarButton;
    clOKPO: TcxGridDBColumn;
    colContractCode: TcxGridDBColumn;
    clInfoMoneyCode: TcxGridDBColumn;
    clInfoMoneyGroupName: TcxGridDBColumn;
    clInfoMoneyDestinationName: TcxGridDBColumn;
    clInfoMoneyName: TcxGridDBColumn;
    clPaidKindName: TcxGridDBColumn;
    clAreaName: TcxGridDBColumn;
    clStartDate: TcxGridDBColumn;
    clEndDate: TcxGridDBColumn;
    actPrintSale: TdsdPrintAction;
    spReport_JuridicalSaleDocument: TdsdStoredProc;
    bbSale: TdxBarButton;
    cxLabel6: TcxLabel;
    edPaidKind: TcxButtonEdit;
    PaidKindGuides: TdsdGuides;
    clStartContractDate: TcxGridDBColumn;
    clRetailName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_JuridicalDefermentPayment);


end.
