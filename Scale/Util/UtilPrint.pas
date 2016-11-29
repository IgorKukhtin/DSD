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
    spSelectPrint_ReturnOut: TdsdStoredProc;
    actPrint_ReturnOut: TdsdPrintAction;
    spSelectPrint_Income: TdsdStoredProc;
    actPrint_Income: TdsdPrintAction;
    spSelectPrint_Send: TdsdStoredProc;
    actPrint_Send: TdsdPrintAction;
    spSelectPrint_Loss: TdsdStoredProc;
    actPrint_Loss: TdsdPrintAction;
    spSelectPrint_ProductionSeparate: TdsdStoredProc;
    actPrint_ProductionSeparate: TdsdPrintAction;
    spEDIEvents: TdsdStoredProc;
    actEDIEvents: TdsdExecStoredProc;
    spSelectPrint_Inventory: TdsdStoredProc;
    actPrint_Inventory: TdsdPrintAction;
    spSelectSale_EDI: TdsdStoredProc;
    spSelectPrint_SaleOrder: TdsdStoredProc;
    actPrintSaleOrder: TdsdPrintAction;
    actPrint_SendOnPrice_diff: TdsdPrintAction;
    spSelectPrintCeh: TdsdStoredProc;
    actPrintCeh: TdsdPrintAction;
    spGetMovement: TdsdStoredProc;
    spSelectPrint_ReestrKind: TdsdStoredProc;
    actPrint_ReestrKind: TdsdPrintAction;
  private
  end;

  function Print_Movement (MovementDescId,MovementId,MovementId_by:Integer; myPrintCount:Integer; isPreview:Boolean; isSendOnPriceIn:Boolean):Boolean;
  function Print_MovementDiff (MovementDescId,MovementId:Integer):Boolean;
  function Print_MovementReestrKind (MovementId_Reestr:Integer):Boolean;
  function Print_Tax      (MovementDescId,MovementId:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Account  (MovementDescId,MovementId:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Spec     (MovementDescId,MovementId,MovementId_by:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Pack     (MovementDescId,MovementId,MovementId_by:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Transport(MovementDescId,MovementId,MovementId_sale:Integer; OperDate:TDateTime; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Quality  (MovementDescId,MovementId:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Sale_Order(MovementId_order,MovementId_by:Integer; isDiff:Boolean):Boolean;

  procedure SendEDI_Invoice (MovementId: Integer);
  procedure SendEDI_OrdSpr (MovementId: Integer);
  procedure SendEDI_Desadv (MovementId: Integer);

var
  UtilPrintForm: TUtilPrintForm;

implementation
uses UtilScale;
{$R *.dfm}
//------------------------------------------------------------------------------------------------
procedure Print_Inventory (MovementId,MovementId_by: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.FormParams.ParamByName('MovementId_by').Value := MovementId_by;
  UtilPrintForm.actPrint_Inventory.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_Send (MovementId,MovementId_by: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.FormParams.ParamByName('MovementId_by').Value := MovementId_by;

  with UtilPrintForm.spGetMovement do Execute;

  if UtilPrintForm.spGetMovement.ParamByName('outDocumentKindId').Value = zc_Enum_DocumentKind_CuterWeight
  then UtilPrintForm.actPrintCeh.Execute
  else UtilPrintForm.actPrint_Send.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_Loss (MovementId: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.actPrint_Loss.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_Income (MovementId: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.actPrint_Income.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_ReturnOut (MovementId: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.actPrint_ReturnOut.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_Sale (MovementId: Integer; myPrintCount:Integer; isPreview:Boolean);
begin
  if myPrintCount <= 0 then myPrintCount:=1;
  //
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.actPrint_Sale.CopiesCount:=myPrintCount;
  UtilPrintForm.actPrint_Sale.WithOutPreview:= not isPreview;
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
  else UtilPrintForm.actPrint_SendOnPrice_out.Execute; // !!!�� ������ ������!!!
  // else UtilPrintForm.actPrint_SendOnPrice_out.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_ProductionSeparate (MovementId,MovementId_by: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.FormParams.ParamByName('MovementId_by').Value := MovementId_by;
  UtilPrintForm.actPrint_ProductionSeparate.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_TaxDocument (MovementId: Integer; myPrintCount:Integer; isPreview:Boolean);
begin
  if myPrintCount <= 0 then myPrintCount:=1;
  //
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.actPrintTax_Client.CopiesCount:=myPrintCount;
  UtilPrintForm.actPrintTax_Client.WithOutPreview:= not isPreview;
  UtilPrintForm.mactPrint_Tax_Client.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_AccountDocument (MovementId: Integer; myPrintCount:Integer; isPreview:Boolean);
begin
  if myPrintCount <= 0 then myPrintCount:=1;
  //
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.actPrint_Account.CopiesCount:=myPrintCount;
  UtilPrintForm.actPrint_Account.WithOutPreview:= not isPreview;
  UtilPrintForm.mactPrint_Account.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_PackDocument (MovementId,MovementId_by:Integer; myPrintCount:Integer; isPreview:Boolean);
begin
  if myPrintCount <= 0 then myPrintCount:=1;
  //
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.FormParams.ParamByName('MovementId_by').Value := MovementId_by;
  UtilPrintForm.actPrint_Pack.CopiesCount:=myPrintCount;
  UtilPrintForm.actPrint_Pack.WithOutPreview:= not isPreview;
  UtilPrintForm.actPrint_Pack.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_SpecDocument (MovementId,MovementId_by:Integer; myPrintCount:Integer; isPreview:Boolean);
begin
  if myPrintCount <= 0 then myPrintCount:=1;
  //
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.FormParams.ParamByName('MovementId_by').Value := MovementId_by;
  UtilPrintForm.actPrint_Spec.CopiesCount:=myPrintCount;
  UtilPrintForm.actPrint_Spec.WithOutPreview:= not isPreview;
  UtilPrintForm.actPrint_Spec.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_TransportDocument (MovementId,MovementId_sale: Integer;OperDate:TDateTime; myPrintCount:Integer; isPreview:Boolean);
begin
  if myPrintCount <= 0 then myPrintCount:=1;
  //
  UtilPrintForm.FormParams.ParamByName('MovementId_by').Value := MovementId;
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId_sale;
  UtilPrintForm.FormParams.ParamByName('OperDate').Value := OperDate;
  UtilPrintForm.actPrint_TTN.CopiesCount:=myPrintCount;
  UtilPrintForm.actPrint_TTN.WithOutPreview:= not isPreview;
  UtilPrintForm.mactPrint_TTN.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_QualityDocument (MovementId: Integer; myPrintCount:Integer; isPreview:Boolean);
begin
  if myPrintCount <= 0 then myPrintCount:=1;
  //
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.actPrint_QualityDoc.CopiesCount:=myPrintCount;
  UtilPrintForm.actPrint_QualityDoc.WithOutPreview:= not isPreview;
  UtilPrintForm.mactPrint_QualityDoc.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_Sale_OrderDocument(MovementId_order,MovementId_by:Integer; isDiff:Boolean);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId_order;
  UtilPrintForm.FormParams.ParamByName('MovementId_by').Value := MovementId_by;
  UtilPrintForm.FormParams.ParamByName('inIsDiff').Value := isDiff;
  UtilPrintForm.actPrintSaleOrder.Execute;
end;
//------------------------------------------------------------------------------------------------
function Print_MovementDiff (MovementDescId,MovementId:Integer):Boolean;
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.actPrint_SendOnPrice_diff.Execute;
end;
//------------------------------------------------------------------------------------------------
function Print_MovementReestrKind (MovementId_Reestr:Integer):Boolean;
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId_Reestr;
  UtilPrintForm.actPrint_ReestrKind.Execute;
end;
//------------------------------------------------------------------------------------------------
function Print_Movement (MovementDescId, MovementId, MovementId_by: Integer; myPrintCount:Integer; isPreview:Boolean; isSendOnPriceIn:Boolean):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     Result:=false;
          //
          try
             //Print
             if (MovementDescId = zc_Movement_Sale)
             or (MovementDescId = zc_Movement_Loss)and(SettingMain.isCeh=false)and(SettingMain.isGoodsComplete=true)
             then Print_Sale(MovementId,myPrintCount,isPreview)
             else if MovementDescId = zc_Movement_ReturnIn
                  then Print_ReturnIn(MovementId)
                  else if MovementDescId = zc_Movement_SendOnPrice
                       then Print_SendOnPrice(MovementId,isSendOnPriceIn)

                       else if MovementDescId = zc_Movement_Income
                            then Print_Income(MovementId)
                            else if MovementDescId = zc_Movement_ReturnOut
                                  then Print_ReturnOut(MovementId)


                            else if (MovementDescId = zc_Movement_Inventory)
                                  then Print_Inventory(MovementId, MovementId_by)

                            else if (MovementDescId = zc_Movement_Send)
                                 or (MovementDescId = zc_Movement_ProductionUnion)
                                  then Print_Send(MovementId,MovementId_by)
                            else if MovementDescId = zc_Movement_Loss
                                  then Print_Loss(MovementId)

                                  else if MovementDescId = zc_Movement_ProductionSeparate
                                        then Print_ProductionSeparate(MovementId,MovementId_by)

                                        else begin ShowMessage ('������.����� ������ <���������> �� �������.');exit;end;
          except
                ShowMessage('������.������ <���������> �� ������������.');
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
             then Print_TaxDocument(MovementId,myPrintCount,isPreview)
             else begin ShowMessage ('������.����� ������ <���������> �� �������.');exit;end;
          except
                ShowMessage('������.������ <���������> �� ������������.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_Account (MovementDescId,MovementId: Integer;myPrintCount:Integer;isPreview:Boolean):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     Result:=false;
          //
          try
             //Print
             if MovementDescId = zc_Movement_Sale
             then Print_AccountDocument(MovementId,myPrintCount,isPreview)
             else begin ShowMessage ('������.����� ������ <����> �� �������.');exit;end;
          except
                ShowMessage('������.������ <����> �� ������������.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_Spec (MovementDescId,MovementId,MovementId_by:Integer;myPrintCount:Integer;isPreview:Boolean):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     Result:=false;
          //
          try
             //Print
             if (MovementDescId = zc_Movement_Sale)or(MovementDescId = zc_Movement_SendOnPrice)
             then Print_SpecDocument(MovementId,MovementId_by,myPrintCount,isPreview)
             else begin ShowMessage ('������.����� ������ <������������> �� �������.');exit;end;
          except
                ShowMessage('������.������ <������������> �� ������������.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_Pack (MovementDescId,MovementId,MovementId_by:Integer;myPrintCount:Integer;isPreview:Boolean):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     Result:=false;
          //
          try
             //Print
             if (MovementDescId = zc_Movement_Sale)or(MovementDescId = zc_Movement_SendOnPrice)
             then Print_PackDocument(MovementId,MovementId_by,myPrintCount,isPreview)
             else begin ShowMessage ('������.����� ������ <����������� ����> �� �������.');exit;end;
          except
                ShowMessage('������.������ �� <����������� ����> ������������.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_Transport (MovementDescId,MovementId,MovementId_sale: Integer;OperDate:TDateTime;myPrintCount:Integer;isPreview:Boolean):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     Result:=false;
          //
          try
             //Print
             if MovementDescId = zc_Movement_Sale
             then Print_TransportDocument(MovementId,MovementId_sale,OperDate,myPrintCount,isPreview)
             else begin ShowMessage ('������.����� ������ <���> �� �������.');exit;end;
          except
                ShowMessage('������.������ <���> �� ������������.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_Quality(MovementDescId,MovementId:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     Result:=false;
          //
          try
             //Print
             if (MovementDescId = zc_Movement_Sale) or (MovementDescId = zc_Movement_Loss) or (MovementDescId = zc_Movement_SendOnPrice)
             then Print_QualityDocument(MovementId,myPrintCount,isPreview)
             else begin ShowMessage ('������.����� ������ <������������> �� �������.');exit;end;
          except
                ShowMessage('������.������ <������������> �� ������������.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_Sale_Order(MovementId_order,MovementId_by:Integer; isDiff:Boolean):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     Result:=false;
          //
          try
             //Print
             if (MovementId_order <> 0)
             then Print_Sale_OrderDocument(MovementId_order,MovementId_by,isDiff)
             else begin ShowMessage ('������.'+#10+#13+'� ������ �� ����������.'+#10+#13+'������ <��������� ������/��������> �� ������������.');exit;end;
          except
                ShowMessage('������.������ <��������� ������/��������> �� ������������.');
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
        ShowMessage('������ ��� �������� � EXITE ��������� <����>.');
        exit;
  end;
  ShowMessage('�������� <����> ��������� ������� � EXITE.');
end;
//------------------------------------------------------------------------------------------------
procedure SendEDI_OrdSpr (MovementId: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  try UtilPrintForm.mactOrdSpr.Execute;
  except
        ShowMessage('������ ��� �������� � EXITE ��������� <������������� ��������>.');
        exit;
  end;
  ShowMessage('�������� <������������� ��������> ��������� ������� � EXITE.');
end;
//------------------------------------------------------------------------------------------------
procedure SendEDI_Desadv (MovementId: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  try UtilPrintForm.mactDesadv.Execute;
  except
        ShowMessage('������ ��� �������� � EXITE ��������� <����������� �� ��������>.');
        exit;
  end;
  ShowMessage('�������� <����������� �� ��������> ��������� ������� � EXITE.');
end;
//------------------------------------------------------------------------------------------------
end.
