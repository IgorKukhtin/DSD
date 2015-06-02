unit UtilPrint;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dsdAction, Vcl.ActnList, dsdDB, Data.DB,
  Datasnap.DBClient,EDI,frxBarcode;

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
    spSelectPrint_ExpInvoice: TdsdStoredProc;
    spSelectPrint_TTN: TdsdStoredProc;
    spSelectPrint_ExpPack: TdsdStoredProc;
    spSelectPrint_Pack: TdsdStoredProc;
    spSelectPrint_Spec: TdsdStoredProc;
    FormParams: TdsdFormParams;
    ActionList: TActionList;
    mactPrint_Sale: TMultiAction;
    mactPrint_Account: TMultiAction;
    mactPrint_Tax_Us: TMultiAction;
    mactPrint_Tax_Client: TMultiAction;
    actPrintTax_Us: TdsdPrintAction;
    actPrintTax_Client: TdsdPrintAction;
    actPrint_Sale: TdsdPrintAction;
    actPrint_Account: TdsdPrintAction;
    actPrint_Sale_ReportName: TdsdExecStoredProc;
    actPrint_Tax_ReportName: TdsdExecStoredProc;
    actPrint_Account_ReportName: TdsdExecStoredProc;
    actPrint_ExpSpec: TdsdPrintAction;
    actPrint_ExpInvoice: TdsdPrintAction;
    actPrint_ExpPack: TdsdPrintAction;
    actPrint_Spec: TdsdPrintAction;
    actPrint_Pack: TdsdPrintAction;
    actPrint_TTN: TdsdPrintAction;
    actPrint_ReturnIn: TdsdPrintAction;
    spSelectPrint_ReturnIn: TdsdStoredProc;
    spGetReportName_ReturnIn: TdsdStoredProc;
    mactPrint_ReturnIn: TMultiAction;
    actPrint_ReturnIn_ReportName: TdsdExecStoredProc;
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
    actDialog_TTN: TdsdOpenForm;
    mactPrint_TTN: TMultiAction;
    spSelectPrint_Quality: TdsdStoredProc;
    actPrint_QualityDoc: TdsdPrintAction;
    actDialog_QualityDoc: TdsdOpenForm;
    mactPrint_QualityDoc: TMultiAction;
    actPrint_SendOnPrice_out: TdsdPrintAction;
    actPrint_SendOnPrice_in: TdsdPrintAction;
    spSelectPrint_SendOnPrice: TdsdStoredProc;
  private
  end;

  function Print_Movement (MovementDescId,MovementId:Integer; myPrintCount:Integer; isPreview:Boolean; isSendOnPriceIn:Boolean):Boolean;
  function Print_Tax      (MovementDescId,MovementId:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Account  (MovementDescId,MovementId:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Spec     (MovementDescId,MovementId,MovementId_by:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Pack     (MovementDescId,MovementId,MovementId_by:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Transport(MovementDescId,MovementId,MovementId_sale:Integer; OperDate:TDateTime; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Quality  (MovementDescId,MovementId:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;

  procedure SendEDI_Invoice (MovementId: Integer);
  procedure SendEDI_OrdSpr (MovementId: Integer);
  procedure SendEDI_Desadv (MovementId: Integer);

var
  UtilPrintForm: TUtilPrintForm;

implementation
uses UtilScale;
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
procedure Print_SendOnPrice (MovementId: Integer; isSendOnPriceIn:Boolean);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  if isSendOnPriceIn = True
  then UtilPrintForm.actPrint_SendOnPrice_in.Execute
  else UtilPrintForm.actPrint_SendOnPrice_out.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_TaxDocument (MovementId: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.mactPrint_Tax_Client.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_AccountDocument (MovementId: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.mactPrint_Account.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_PackDocument (MovementId,MovementId_by:Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.FormParams.ParamByName('MovementId_by').Value := MovementId_by;
  UtilPrintForm.actPrint_Pack.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_SpecDocument (MovementId,MovementId_by:Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.FormParams.ParamByName('MovementId_by').Value := MovementId_by;
  UtilPrintForm.actPrint_Spec.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_TransportDocument (MovementId,MovementId_sale: Integer;OperDate:TDateTime);
begin
  UtilPrintForm.FormParams.ParamByName('MovementId_by').Value := MovementId;
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId_sale;
  UtilPrintForm.FormParams.ParamByName('OperDate').Value := OperDate;
  UtilPrintForm.mactPrint_TTN.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_QualityDocument (MovementId: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.mactPrint_QualityDoc.Execute;
end;
//------------------------------------------------------------------------------------------------
function Print_Movement (MovementDescId,MovementId: Integer;myPrintCount:Integer;isPreview:Boolean; isSendOnPriceIn:Boolean):Boolean;
begin
     Result:=false;
          //
          try
             //Print
             if (MovementDescId = zc_Movement_Sale)
             or (MovementDescId = zc_Movement_Loss)
             or (MovementDescId = zc_Movement_ReturnOut)
             then Print_Sale(MovementId)
             else if MovementDescId = zc_Movement_ReturnIn
                  then Print_ReturnIn(MovementId)
                  else if MovementDescId = zc_Movement_SendOnPrice
                       then Print_SendOnPrice(MovementId,isSendOnPriceIn)
                       else begin ShowMessage ('Ошибка.Форма печати <Накладная> не найдена.');exit;end;
          except
                ShowMessage('Ошибка.Печать <Накладная> не сформирована.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_Tax (MovementDescId,MovementId: Integer;myPrintCount:Integer;isPreview:Boolean):Boolean;
begin
     Result:=false;
          //
          try
             //Print
             if MovementDescId = zc_Movement_Sale
             then Print_TaxDocument(MovementId)
             else begin ShowMessage ('Ошибка.Форма печати <Налоговая> не найдена.');exit;end;
          except
                ShowMessage('Ошибка.Печать <Налоговая> не сформирована.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_Account (MovementDescId,MovementId: Integer;myPrintCount:Integer;isPreview:Boolean):Boolean;
begin
     Result:=false;
          //
          try
             //Print
             if MovementDescId = zc_Movement_Sale
             then Print_AccountDocument(MovementId)
             else begin ShowMessage ('Ошибка.Форма печати <Счет> не найдена.');exit;end;
          except
                ShowMessage('Ошибка.Печать <Счет> не сформирована.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_Spec (MovementDescId,MovementId,MovementId_by:Integer;myPrintCount:Integer;isPreview:Boolean):Boolean;
begin
     Result:=false;
          //
          try
             //Print
             if MovementDescId = zc_Movement_Sale
             then Print_SpecDocument(MovementId,MovementId_by)
             else begin ShowMessage ('Ошибка.Форма печати <Спецификация> не найдена.');exit;end;
          except
                ShowMessage('Ошибка.Печать <Спецификация> не сформирована.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_Pack (MovementDescId,MovementId,MovementId_by:Integer;myPrintCount:Integer;isPreview:Boolean):Boolean;
begin
     Result:=false;
          //
          try
             //Print
             if MovementDescId = zc_Movement_Sale
             then Print_PackDocument(MovementId,MovementId_by)
             else begin ShowMessage ('Ошибка.Форма печати <Упаковочный лист> не найдена.');exit;end;
          except
                ShowMessage('Ошибка.Печать не <Упаковочный лист> сформирована.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_Transport (MovementDescId,MovementId,MovementId_sale: Integer;OperDate:TDateTime;myPrintCount:Integer;isPreview:Boolean):Boolean;
begin
     Result:=false;
          //
          try
             //Print
             if MovementDescId = zc_Movement_Sale
             then Print_TransportDocument(MovementId,MovementId_sale,OperDate)
             else begin ShowMessage ('Ошибка.Форма печати <ТТН> не найдена.');exit;end;
          except
                ShowMessage('Ошибка.Печать <ТТН> не сформирована.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_Quality(MovementDescId,MovementId:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
begin
     Result:=false;
          //
          try
             //Print
             if (MovementDescId = zc_Movement_Sale) or (MovementDescId = zc_Movement_Loss)
             then Print_QualityDocument(MovementId)
             else begin ShowMessage ('Ошибка.Форма печати <Качественное> не найдена.');exit;end;
          except
                ShowMessage('Ошибка.Печать <Качественное> не сформирована.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------
procedure SendEDI_Invoice (MovementId: Integer);
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
procedure SendEDI_OrdSpr (MovementId: Integer);
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
procedure SendEDI_Desadv (MovementId: Integer);
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
