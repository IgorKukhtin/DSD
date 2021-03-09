unit Report_Check_SP_ForDPSS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn,
  ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dsdGuides, cxButtonEdit, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu,
  dxSkinsdxBarPainter, cxCheckBox;

type
  TReport_Check_SP_ForDPSSForm = class(TAncestorReportForm)
    dxBarButton1: TdxBarButton;
    IntenalSPName: TcxGridDBColumn;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    BrandSPName: TcxGridDBColumn;
    PriceSP: TcxGridDBColumn;
    actRefreshIsPartion: TdsdDataSetRefresh;
    CountSP: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actRefreshPartionPrice: TdsdDataSetRefresh;
    KindOutSPName: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    NumLine: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    actPrint_152: TdsdPrintAction;
    bbPrint1: TdxBarButton;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    actPrintInvoice: TdsdPrintAction;
    actSaveMovement: TdsdExecStoredProc;
    macPrintInvoice: TMultiAction;
    bbPrintInvoice: TdxBarButton;
    actGetReportNameSP: TdsdExecStoredProc;
    mactPrint_Pact: TMultiAction;
    actPrintPact: TdsdPrintAction;
    FormParams: TdsdFormParams;
    bbPrint_Pact: TdxBarButton;
    actPrintDepartment: TdsdPrintAction;
    actPrintDepartment_152: TdsdPrintAction;
    macPrintInvoiceDepartment: TMultiAction;
    actPrintInvoiceDepartment: TdsdPrintAction;
    bbPrintDepartment: TdxBarButton;
    bbPrintDepartment_152: TdxBarButton;
    bbPrintInvoiceDepartment: TdxBarButton;
    actPrintPactDepartment: TdsdPrintAction;
    mactPrint_PactDepartment: TMultiAction;
    bbPrint_PactDepartment: TdxBarButton;
    actGetReportNameSPDepartmen: TdsdExecStoredProc;
    Markup: TcxGridDBColumn;
    PriceWithVAT: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_Check_SP_ForDPSSForm: TReport_Check_SP_ForDPSSForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_Check_SP_ForDPSSForm)
end.
