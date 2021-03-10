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
  dxSkinsdxBarPainter, cxCheckBox, dsdExportToXLSAction;

type
  TReport_Check_SP_ForDPSSForm = class(TAncestorReportForm)
    dxBarButton1: TdxBarButton;
    IntenalSPName: TcxGridDBColumn;
    actRefreshStart: TdsdDataSetRefresh;
    BrandSPName: TcxGridDBColumn;
    PriceSP: TcxGridDBColumn;
    CountSP: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    KindOutSPName: TcxGridDBColumn;
    bbPrint: TdxBarButton;
    NumLine: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    bbPrint1: TdxBarButton;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    bbPrintInvoice: TdxBarButton;
    FormParams: TdsdFormParams;
    bbPrint_Pact: TdxBarButton;
    bbPrintDepartment: TdxBarButton;
    bbPrintDepartment_152: TdxBarButton;
    bbPrintInvoiceDepartment: TdxBarButton;
    bbPrint_PactDepartment: TdxBarButton;
    Markup: TcxGridDBColumn;
    PriceWithVAT: TcxGridDBColumn;
    actExecForDPSS: TdsdExecStoredProc;
    actPrintForDPSS: TdsdExportToXLS;
    dxBarButton2: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrintItem: TdsdStoredProc;
    spSelectPrintHeader: TdsdStoredProc;
    PrintSignCDS: TClientDataSet;
    spSelectPrintSign: TdsdStoredProc;
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
