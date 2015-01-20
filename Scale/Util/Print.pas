unit Print;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dsdAction, Vcl.ActnList, dsdDB, Data.DB,
  Datasnap.DBClient;

type
  TfPrint = class(TForm)
    PrintItemsSverkaCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    spGetReporNameTax: TdsdStoredProc;
    spGetReportName: TdsdStoredProc;
    spGetReporNameBill: TdsdStoredProc;
    spSelectTax_Us: TdsdStoredProc;
    spSelectTax_Client: TdsdStoredProc;
    spSelectPrint: TdsdStoredProc;
    spSelectPrintInvoice: TdsdStoredProc;
    spSelectPrintTTN: TdsdStoredProc;
    spSelectPrintPack22: TdsdStoredProc;
    spSelectPrintPack21: TdsdStoredProc;
    spSelectPrintPack: TdsdStoredProc;
    FormParams: TdsdFormParams;
    ActionList: TActionList;
    mactPrint_Sale: TMultiAction;
    mactPrint_Bill: TMultiAction;
    mactPrint_Tax_Us: TMultiAction;
    mactPrint_Tax_Client: TMultiAction;
    actPrintTax_Us: TdsdPrintAction;
    actPrintTax_Client: TdsdPrintAction;
    actPrint: TdsdPrintAction;
    actPrint_Bill: TdsdPrintAction;
    actSPPrintSaleProcName: TdsdExecStoredProc;
    actSPPrintSaleTaxProcName: TdsdExecStoredProc;
    actSPPrintSaleBillProcName: TdsdExecStoredProc;
    actPrint_Spec: TdsdPrintAction;
    actPrint_Invoice: TdsdPrintAction;
    actPrint_Pack: TdsdPrintAction;
    actPrint_Pack22: TdsdPrintAction;
    actPrint_Pack21: TdsdPrintAction;
    actPrint_TTN: TdsdPrintAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure PrintSale(Id: Integer);

var
  fPrint: TfPrint;

implementation

{$R *.dfm}

procedure PrintSale(Id: Integer);
var
  l_Id :Integer;
begin
  fPrint.FormParams.ParamByName('Id').Value := Id;
  fPrint.mactPrint_Sale.Execute;
end;


end.
