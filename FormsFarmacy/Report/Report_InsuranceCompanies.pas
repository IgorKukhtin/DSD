unit Report_InsuranceCompanies;

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
  TReport_InsuranceCompaniesForm = class(TAncestorReportForm)
    dxBarButton1: TdxBarButton;
    Amount: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    NumLine: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    ceUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    cxLabel4: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    cxLabel5: TcxLabel;
    ceInsuranceCompanies: TcxButtonEdit;
    GuidesInsuranceCompanies: TdsdGuides;
    bbPrint1: TdxBarButton;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    bbPrintInvoice: TdxBarButton;
    FormParams: TdsdFormParams;
    bbPrint_Pact: TdxBarButton;
    bbPrintDepartment: TdxBarButton;
    bbPrintDepartment_152: TdxBarButton;
    bbPrintInvoiceDepartment: TdxBarButton;
    bbPrint_PactDepartment: TdxBarButton;
    InvNumber_Full: TcxGridDBColumn;
    NDS: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_InsuranceCompaniesForm: TReport_InsuranceCompaniesForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_InsuranceCompaniesForm)
end.
