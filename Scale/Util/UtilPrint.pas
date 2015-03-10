unit UtilPrint;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dsdAction, Vcl.ActnList, dsdDB, Data.DB,
  Datasnap.DBClient,EDI;

type
  TUtilPrintForm = class(TForm)
    PrintItemsSverkaCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    spGetReporNameTax: TdsdStoredProc;
    spGetReportName_Sale: TdsdStoredProc;
    spGetReporNameBill: TdsdStoredProc;
    spSelectTax_Us: TdsdStoredProc;
    spSelectTax_Client: TdsdStoredProc;
    spSelectPrint_Sale: TdsdStoredProc;
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
    actPrint_Sale: TdsdPrintAction;
    actPrint_Bill: TdsdPrintAction;
    actPrintReportName_Sale: TdsdExecStoredProc;
    actSPPrintSaleTaxProcName: TdsdExecStoredProc;
    actSPPrintSaleBillProcName: TdsdExecStoredProc;
    actPrint_Spec: TdsdPrintAction;
    actPrint_Invoice: TdsdPrintAction;
    actPrint_Pack: TdsdPrintAction;
    actPrint_Pack22: TdsdPrintAction;
    actPrint_Pack21: TdsdPrintAction;
    actPrint_TTN: TdsdPrintAction;
    actPrint_ReturnIn: TdsdPrintAction;
    spSelectPrint_ReturnIn: TdsdStoredProc;
    spSelectPrint_SendOnPrice: TdsdStoredProc;
    actPrint_SendOnPrice: TdsdPrintAction;
    spGetReportName_ReturnIn: TdsdStoredProc;
    mactPrint_ReturnIn: TMultiAction;
    actPrintReportName_ReturnIn: TdsdExecStoredProc;
    EDI: TEDI;
    actInvoice: TEDIAction;
    actOrdSpr: TEDIAction;
    actDesadv: TEDIAction;
    mactInvoice: TMultiAction;
    mactOrdSpr: TMultiAction;
    mactDesadv: TMultiAction;
    spUpdateEdiDesadv: TdsdStoredProc;
    spUpdateEdiInvoice: TdsdStoredProc;
    spUpdateEdiOrdspr: TdsdStoredProc;
    actUpdateEdiDesadvTrue: TdsdExecStoredProc;
    actUpdateEdiInvoiceTrue: TdsdExecStoredProc;
    actUpdateEdiOrdsprTrue: TdsdExecStoredProc;
    actExecPrintStoredProc: TdsdExecStoredProc;
    spGetDefaultEDI: TdsdStoredProc;
    actSetDefaults: TdsdExecStoredProc;
  private
  end;

  procedure Print_Sale (MovementId: Integer);
  procedure Print_ReturnIn (MovementId: Integer);
  procedure Print_SendOnPrice (MovementId: Integer);

  procedure EDI_Invoice (MovementId: Integer);
  procedure EDI_OrdSpr (MovementId: Integer);
  procedure EDI_Desadv (MovementId: Integer);

var
  UtilPrintForm: TUtilPrintForm;

implementation
{$R *.dfm}
//------------------------------------------------------------------------------------------------
procedure Print_Sale (MovementId: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.mactPrint_Sale.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_ReturnIn (MovementId: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.mactPrint_ReturnIn.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_SendOnPrice (MovementId: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.actPrint_SendOnPrice.Execute;
end;
//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------
procedure EDI_Invoice (MovementId: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  try UtilPrintForm.mactInvoice.Execute;
  except
        ShowMessage('Ошибка при отправке в EXITE документа <Счет>.');
        exit;
  end;
  ShowMessage('Документ <Счет> отправлен успешно в EXITE.');
end;
//------------------------------------------------------------------------------------------------
procedure EDI_OrdSpr (MovementId: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  try UtilPrintForm.mactOrdSpr.Execute;
  except
        ShowMessage('Ошибка при отправке в EXITE документа <Подтверждение отгрузки>.');
        exit;
  end;
  ShowMessage('Документ <Подтверждение отгрузки> отправлен успешно в EXITE.');
end;
//------------------------------------------------------------------------------------------------
procedure EDI_Desadv (MovementId: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  try UtilPrintForm.mactDesadv.Execute;
  except
        ShowMessage('Ошибка при отправке в EXITE документа <Уведомление об отгрузке>.');
        exit;
  end;
  ShowMessage('Документ <Уведомление об отгрузке> отправлен успешно в EXITE.');
end;
//------------------------------------------------------------------------------------------------
end.
