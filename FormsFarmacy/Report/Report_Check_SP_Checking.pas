unit Report_Check_SP_Checking;

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
  TReport_Check_SP_CheckingForm = class(TAncestorReportForm)
    dxBarButton1: TdxBarButton;
    actRefreshStart: TdsdDataSetRefresh;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    NumLine: TcxGridDBColumn;
    bbPrint1: TdxBarButton;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    bbPrintInvoice: TdxBarButton;
    FormParams: TdsdFormParams;
    bbPrint_Pact: TdxBarButton;
    bbPrintDepartment: TdxBarButton;
    bbPrintDepartment_152: TdxBarButton;
    bbPrintInvoiceDepartment: TdxBarButton;
    bbPrint_PactDepartment: TdxBarButton;
    dxBarButton2: TdxBarButton;
    InvNumber_Full: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    SummaSP_pack: TcxGridDBColumn;
    InvNumberSP: TcxGridDBColumn;
    SummaSP: TcxGridDBColumn;
    SummaSP_pack_File: TcxGridDBColumn;
    SummaSP_File: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_Check_SP_CheckingForm: TReport_Check_SP_CheckingForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_Check_SP_CheckingForm)
end.
