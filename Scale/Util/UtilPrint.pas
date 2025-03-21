unit UtilPrint;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dsdAction, Vcl.ActnList, dsdDB, Data.DB,
  Datasnap.DBClient,EDI,frxBarcode, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxDBData, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, dsdInternetAction,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dsdCommon;

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
    PrintItemsTwoCDS: TClientDataSet;
    spInsert_Movement_EDI_Send: TdsdStoredProc;
    actInsert_Movement_EDI_Send: TdsdExecStoredProc;
    actPrint_PackGross2: TdsdPrintAction;
    actPrint_PackGross: TdsdPrintAction;
    spSelectPrintSticker: TdsdStoredProc;
    spGetReportNameQuality: TdsdStoredProc;
    actPrint_Quality_ReportName: TdsdExecStoredProc;
    actPrint_PackWeight: TdsdPrintAction;
    actPrint_Report_GoodsBalance1: TdsdPrintAction;
    actPrint_Report_GoodsBalance: TdsdPrintAction;
    spReport_GoodsBalance: TdsdStoredProc;
    actPrintSticker: TdsdPrintAction;
    ExportEmailCDS: TClientDataSet;
    ExportEmailDS: TDataSource;
    ExportCDS: TClientDataSet;
    ExportDS: TDataSource;
    spSelect_Export: TdsdStoredProc;
    spGet_Export_FileName: TdsdStoredProc;
    spGet_Export_Email: TdsdStoredProc;
    ExportXmlGrid: TcxGrid;
    ExportXmlGridDBTableView: TcxGridDBTableView;
    RowData: TcxGridDBColumn;
    ExportXmlGridLevel: TcxGridLevel;
    actGet_Export_Email: TdsdExecStoredProc;
    actGet_Export_FileName: TdsdExecStoredProc;
    actSelect_Export: TdsdExecStoredProc;
    actExport_Grid: TExportGrid;
    actSMTPFile: TdsdSMTPFileAction;
    actExport: TMultiAction;
    spUpdate_isMail: TdsdStoredProc;
    actUpdate_isMail: TdsdExecStoredProc;
    actPrintSticker_Wms: TdsdPrintAction;
    spSelectPrintWmsSticker: TdsdStoredProc;
    actPrint_ReturnInAkt: TdsdPrintAction;
    spSelectPrintAkt: TdsdStoredProc;
    spSelectPrintSticker_Ceh: TdsdStoredProc;
    actPrintSticker_Ceh: TdsdPrintAction;
    actPrint_ProductionUnion: TdsdPrintAction;
    spSelectPrint_ProductionUnion: TdsdStoredProc;
    spGet_Movement: TdsdStoredProc;
    actGet_Movement: TdsdExecStoredProc;
    spSelectPrint_Quality_list: TdsdStoredProc;
    actPrint_QualityDoc_list: TdsdPrintAction;
    mactPrint_QualityDoc_list: TMultiAction;
    actPrintStikerKVK: TdsdPrintAction;
    spGetReporNameTTN: TdsdStoredProc;
    actSPPrintTTNProcName: TdsdExecStoredProc;
    actPrint_Income_diff: TdsdPrintAction;
    spSelectPrint_Income_diff: TdsdStoredProc;
    spSelectPrint_Income_Price_diff: TdsdStoredProc;
    actPrint_Income_Price_diff: TdsdPrintAction;
    spSelectPrint_TTN_final: TdsdStoredProc;
    actPrint_TTN_final: TdsdPrintAction;
    macPrint_TTN_final: TMultiAction;
    spSelectPrint_Income_byPartner: TdsdStoredProc;
    actPrint_Income_byPartner: TdsdPrintAction;
    spSelectPrint_Income_bySklad: TdsdStoredProc;
    actPrint_Income_bySklad: TdsdPrintAction;
    spSelectPrint_reestr: TdsdStoredProc;
    actPrint_reestr_income: TdsdPrintAction;
    spSelectMIPrintPassport: TdsdStoredProc;
    actSelectMIPrintPassport: TdsdPrintAction;
    spSelectPrintBox_PartnerTotal: TdsdStoredProc;
    actPrintBoxTotalPartner: TdsdPrintAction;
    spSelectPrint_Pack_send: TdsdStoredProc;
    actPrint_PackGross_send: TdsdPrintAction;
  private
  end;

  function Print_Movement (MovementDescId,MovementId,MovementId_by:Integer; myPrintCount:Integer; isPreview:Boolean; isSendOnPriceIn:Boolean):Boolean;
  function Print_MovementDiff (MovementDescId,MovementId:Integer):Boolean;
  function Print_MovementReestrKind (MovementId_Reestr:Integer):Boolean;
  function Print_Tax      (MovementDescId,MovementId:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Account  (MovementDescId,MovementId:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Spec     (MovementDescId,MovementId,MovementId_by:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Pack     (MovementDescId,MovementId,MovementId_by:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_PackGross(MovementDescId,MovementId,MovementId_by:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_PackGross_Send(MovementDescId,MovementId,MovementId_by:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Transport(MovementDescId,MovementId,MovementId_sale:Integer; OperDate:TDateTime; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Transport_Total(MovementDescId,MovementId_sale:Integer; OperDate:TDateTime; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Quality  (MovementDescId,MovementId:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Sale_Order(MovementId_order,MovementId_by:Integer; isDiff:Boolean; isDiffTax:Boolean):Boolean;
  function Print_PackWeight (MovementDescId,MovementId:Integer; isPreview:Boolean):Boolean;
  function Print_Sticker (MovementDescId,MovementId:Integer; isPreview:Boolean):Boolean;
  function Print_Sticker_Wms (MovementDescId,MovementId,MovementItemId:Integer; isPreview:Boolean):Boolean;
  function Print_Sticker_Ceh (MovementDescId,MovementId,MovementItemId:Integer; isKVK, isPreview:Boolean):Boolean;
  function Print_QualityDoc_list(MovementDescId,MovementId:Integer; isPreview:Boolean):Boolean;
  function Print_ReportGoodsBalance (StartDate,EndDate:TDateTime; UnitId : Integer; UnitName : String; isGoodsKind, isPartionGoods:Boolean):Boolean;
  function Print_Income_diff (MovementId: Integer):Boolean;
  function Print_Income_Price_diff (MovementId: Integer):Boolean;
  function Print_Movement_Income_Sklad(MovementDescId,MovementId,MovementId_by:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
  function Print_Box_Total (MovementId: Integer):Boolean;

  function Print_Movement_Income_Reestr(StartDate, EndDate : TDateTime; MovementDescId,UnitId:Integer):Boolean;

  function Print_MIPassport (MovementId, MovementItemId:Integer):Boolean;

  procedure SendEDI_Invoice (MovementId: Integer);
  procedure SendEDI_OrdSpr (MovementId: Integer);
  procedure SendEDI_Desadv (MovementId: Integer);

  procedure Export_Email (MovementId: Integer);

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

  if  (UtilPrintForm.spGetMovement.ParamByName('outDocumentKindId').Value = zc_Enum_DocumentKind_CuterWeight)
   or (UtilPrintForm.spGetMovement.ParamByName('outDocumentKindId').Value = zc_Enum_DocumentKind_RealWeight)
   or (UtilPrintForm.spGetMovement.ParamByName('outDocumentKindId').Value = zc_Enum_DocumentKind_RealDelicShp)
   or (UtilPrintForm.spGetMovement.ParamByName('outDocumentKindId').Value = zc_Enum_DocumentKind_RealDelicMsg)
   or (UtilPrintForm.spGetMovement.ParamByName('outDocumentKindId').Value = zc_Enum_DocumentKind_LakTo)
   or (UtilPrintForm.spGetMovement.ParamByName('outDocumentKindId').Value = zc_Enum_DocumentKind_LakFrom)
  then UtilPrintForm.actPrintCeh.Execute
  else UtilPrintForm.actPrint_Send.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_PackWeightDocument (MovementId: Integer; isPreview:Boolean);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.actPrint_PackWeight.WithOutPreview:= not isPreview;
  UtilPrintForm.actPrint_PackWeight.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_StickerDocument (MovementId: Integer; isPreview:Boolean);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.actPrintSticker.WithOutPreview:= not isPreview;
  UtilPrintForm.actPrintSticker.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_Sticker_WmsDocument (MovementId,MovementItemId: Integer; isPreview:Boolean);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.FormParams.ParamByName('MovementItemId').Value := MovementItemId;
  UtilPrintForm.actPrintSticker_Wms.WithOutPreview:= not isPreview;
  UtilPrintForm.actPrintSticker_Wms.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_Sticker_CehDocument (MovementId,MovementItemId: Integer; isKVK, isPreview:Boolean);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.FormParams.ParamByName('MovementItemId').Value := MovementItemId;
  //
  if isKVK = True then
  begin
        UtilPrintForm.actPrintStikerKVK.WithOutPreview:= not isPreview;
        UtilPrintForm.actPrintStikerKVK.Printer:= PrinterSticker_Array[0].Name;
        UtilPrintForm.actPrintStikerKVK.Execute;
  end
  else begin
        UtilPrintForm.actPrintSticker_Ceh.WithOutPreview:= not isPreview;
        UtilPrintForm.actPrintSticker_Ceh.Printer:= PrinterSticker_Array[0].Name;
        UtilPrintForm.actPrintSticker_Ceh.Execute;
  end;
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
procedure Print_Income_byPartner (MovementId_wp: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId_wp;
  UtilPrintForm.actPrint_Income_byPartner.Execute;
end;
//------------------------------------------------------------------------------------------------
function Print_Income_diff (MovementId: Integer):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
     UtilPrintForm.actPrint_Income_diff.Execute;
end;
//------------------------------------------------------------------------------------------------
function Print_Box_Total (MovementId: Integer):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='GoodsName_two';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
     UtilPrintForm.actPrintBoxTotalPartner.Execute;
end;
//------------------------------------------------------------------------------------------------
function Print_Income_Price_diff (MovementId: Integer):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
     UtilPrintForm.actPrint_Income_Price_diff.Execute;
end;
//------------------------------------------------------------------------------------------------
function Print_Movement_Income_Sklad(MovementDescId,MovementId,MovementId_by:Integer; myPrintCount:Integer; isPreview:Boolean):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
     UtilPrintForm.actPrint_Income_bySklad.Execute;
end;
//------------------------------------------------------------------------------------------------
function Print_MIPassport (MovementId, MovementItemId:Integer):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
     UtilPrintForm.FormParams.ParamByName('MovementItemId').Value := MovementItemId;
     //
     //
     UtilPrintForm.actSelectMIPrintPassport.Execute;
end;
//------------------------------------------------------------------------------------------------
function Print_Movement_Income_Reestr(StartDate, EndDate : TDateTime; MovementDescId,UnitId:Integer):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     UtilPrintForm.FormParams.ParamByName('inStartDate').Value := StartDate;
     UtilPrintForm.FormParams.ParamByName('inEndDate').Value := EndDate;
     UtilPrintForm.FormParams.ParamByName('inUnitId').Value := UnitId;
     UtilPrintForm.FormParams.ParamByName('inIsReturnOut').Value := MovementDescId <> zc_Movement_Income;
     //
     //
     UtilPrintForm.actPrint_reestr_income.Execute;
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
  //UtilPrintForm.mactPrint_ReturnIn.Execute;
  UtilPrintForm.actPrint_ReturnInAkt.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_SendOnPrice (MovementId: Integer; isSendOnPriceIn:Boolean);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  if isSendOnPriceIn = True
  then UtilPrintForm.actPrint_SendOnPrice_in.Execute
  else UtilPrintForm.actPrint_SendOnPrice_out.Execute; // !!!не ВСЕГДА приход!!!
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
procedure Print_ProductionUnion (MovementId,MovementId_by: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
//  UtilPrintForm.FormParams.ParamByName('MovementId_by').Value := MovementId_by;
  UtilPrintForm.actPrint_ProductionUnion.Execute;
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
procedure Print_PackDocumentGross (MovementId,MovementId_by:Integer; myPrintCount:Integer; isPreview:Boolean);
begin
  if myPrintCount <= 0 then myPrintCount:=1;
  //
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.FormParams.ParamByName('MovementId_by').Value := MovementId_by;
  UtilPrintForm.actPrint_PackGross.CopiesCount:=myPrintCount;
  UtilPrintForm.actPrint_PackGross.WithOutPreview:= not isPreview;
  UtilPrintForm.actPrint_PackGross.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_PackDocumentGross_Send (MovementId,MovementId_by:Integer; myPrintCount:Integer; isPreview:Boolean);
begin
  if myPrintCount <= 0 then myPrintCount:=1;
  //
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.FormParams.ParamByName('MovementId_by').Value := MovementId_by;
  UtilPrintForm.actPrint_PackGross_Send.CopiesCount:=myPrintCount;
  UtilPrintForm.actPrint_PackGross_Send.WithOutPreview:= not isPreview;
  UtilPrintForm.actPrint_PackGross_Send.Execute;
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
procedure Print_QualityDocument_list (MovementId: Integer; isPreview:Boolean);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.actPrint_QualityDoc.CopiesCount:=1;
  UtilPrintForm.actPrint_QualityDoc.WithOutPreview:= not isPreview;
  UtilPrintForm.mactPrint_QualityDoc_list.Execute;
end;
//------------------------------------------------------------------------------------------------
procedure Print_Sale_OrderDocument(MovementId_order,MovementId_by:Integer; isDiff:Boolean; isDiffTax:Boolean);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId_order;
  UtilPrintForm.FormParams.ParamByName('MovementId_by').Value := MovementId_by;
  UtilPrintForm.FormParams.ParamByName('inIsDiff').Value := isDiff;
  UtilPrintForm.FormParams.ParamByName('inIsDiffTax').Value := isDiffTax;
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
     // замена
     if MovementDescId = zc_Movement_Send then
     begin
        UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
        UtilPrintForm.actGet_Movement.Execute;
        MovementDescId:= UtilPrintForm.FormParams.ParamByName('MovementDescId').Value;
     end;
     //
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
                            then if MovementId_by < 0
                                 then if MovementId > 0
                                      // реальный док поставщика
                                      then Print_Income_byPartner(MovementId)
                                      // док взвешивания - здесь только данные поставщика
                                      else Print_Income_byPartner(-1 * MovementId_by)

                                 else Print_Income(MovementId)

                            else if MovementDescId = zc_Movement_ReturnOut
                                  then Print_ReturnOut(MovementId)


                            else if (MovementDescId = zc_Movement_Inventory)
                                  then Print_Inventory(MovementId, MovementId_by)

                            else if (MovementDescId = zc_Movement_ProductionUnion)
                                and (SettingMain.isGoodsComplete = FALSE)
                                and (SettingMain.isModeSorting   = FALSE)
                                 then Print_ProductionUnion(MovementId,MovementId_by)

                            else if (MovementDescId = zc_Movement_Send)
                                 or (MovementDescId = zc_Movement_ProductionUnion)
                                  then Print_Send(MovementId,MovementId_by)
                            else if MovementDescId = zc_Movement_Loss
                                  then Print_Loss(MovementId)

                                  else if MovementDescId = zc_Movement_ProductionSeparate
                                        then Print_ProductionSeparate(MovementId,MovementId_by)

                                  else if MovementDescId = zc_Movement_ProductionUnion
                                        then Print_ProductionUnion(MovementId,MovementId_by)

                                        else begin ShowMessage ('Ошибка.Форма печати <Накладная> не найдена.');exit;end;
          except on E:Exception do begin
                  //ShowMessage('Ошибка.Печать <Накладная> не сформирована.');
                  ShowMessage(E.Message);
                  exit;
                end;
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
             else begin ShowMessage ('Ошибка.Форма печати <Спецификация> не найдена.');exit;end;
          except
                ShowMessage('Ошибка.Печать <Спецификация> не сформирована.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_PackWeight (MovementDescId,MovementId:Integer; isPreview:Boolean):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     Result:=false;
          //
          try
             //Print
             if (MovementDescId = zc_Movement_Sale) or (MovementDescId = zc_Movement_SendOnPrice)
             then Print_PackWeightDocument (MovementId,isPreview)
             else begin ShowMessage('Ошибка.Печать тара (фоззи) возможна только для документа <Продажа покупателю>.');exit;end;
          except
                ShowMessage('Ошибка.Печать <Печать тара (фоззи)> НЕ сформирована.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_Sticker (MovementDescId,MovementId:Integer; isPreview:Boolean):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     Result:=false;
          //
          try
             //Print
             if (MovementDescId = zc_Movement_Income)
             then Print_StickerDocument (MovementId,isPreview)
             else begin ShowMessage('Ошибка.Печать на термопринтер стикера-самоклейки возможна только для документа <Приход от поставщика>.');exit;end;
          except
                ShowMessage('Ошибка.Печать <Печать на термопринтер> НЕ сформирована.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_Sticker_Wms (MovementDescId,MovementId,MovementItemId:Integer; isPreview:Boolean):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     Result:=false;
          //
          try
             //Print
             Print_Sticker_WmsDocument (MovementId,MovementItemId,isPreview);
          except
                ShowMessage('Ошибка.Печать <Печать на термопринтер> НЕ сформирована.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_Sticker_Ceh (MovementDescId,MovementId,MovementItemId:Integer; isKVK, isPreview:Boolean):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     Result:=false;
     //
     if Length(PrinterSticker_Array) = 0 then
     begin
          ShowMessage('Ошибка.Не определен термопринтер для печати этикетки.');
          exit;
     end;

          //
          try
             //Print
             Print_Sticker_CehDocument (MovementId,MovementItemId,isKVK,isPreview);
          except
                ShowMessage('Ошибка.Печать <Печать на термопринтер> НЕ сформирована.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_ReportGoodsBalance (StartDate,EndDate:TDateTime; UnitId : Integer; UnitName : String; isGoodsKind, isPartionGoods:Boolean):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     Result:=false;
          //
          try
            UtilPrintForm.actPrint_Report_GoodsBalance.StoredProc.Params.ParamByName('inStartDate').Value:=StartDate;
            UtilPrintForm.actPrint_Report_GoodsBalance.StoredProc.Params.ParamByName('inEndDate').Value:=EndDate;
            UtilPrintForm.actPrint_Report_GoodsBalance.StoredProc.Params.ParamByName('inLocationId').Value:=UnitId;

            UtilPrintForm.actPrint_Report_GoodsBalance.Params.ParamByName('StartDate').Value:=StartDate;
            UtilPrintForm.actPrint_Report_GoodsBalance.Params.ParamByName('EndDate').Value:=EndDate;
            UtilPrintForm.actPrint_Report_GoodsBalance.Params.ParamByName('LocationName').Value:=UnitName;
            UtilPrintForm.actPrint_Report_GoodsBalance.Params.ParamByName('isGoodsKind').Value:=isGoodsKind;
            UtilPrintForm.actPrint_Report_GoodsBalance.Params.ParamByName('isPartionGoods').Value:=isPartionGoods;
            UtilPrintForm.actPrint_Report_GoodsBalance.Params.ParamByName('isAmount').Value:=true;

            UtilPrintForm.actPrint_Report_GoodsBalance.Execute;
          except
                ShowMessage('Ошибка.Печать <Отчет> НЕ сформирована.');
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
             then Print_PackDocument (MovementId,MovementId_by,myPrintCount,isPreview)
             else begin ShowMessage ('Ошибка.Форма печати <Упаковочный лист> не найдена.');exit;end;
          except
                ShowMessage('Ошибка.Печать <Упаковочный лист> НЕ сформирована.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_PackGross (MovementDescId,MovementId,MovementId_by:Integer;myPrintCount:Integer;isPreview:Boolean):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     Result:=false;
          //
          try
             //Print
             if 1=1 // (MovementDescId = zc_Movement_Sale)or(MovementDescId = zc_Movement_SendOnPrice)
             then Print_PackDocumentGross (MovementId,MovementId_by,myPrintCount,isPreview)
             else begin ShowMessage ('Ошибка.Форма печати <Упак. Лист вес БРУТТО> не найдена.');exit;end;
          except
                ShowMessage('Ошибка.Печать <Упак. Лист вес БРУТТО> НЕ сформирована.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_PackGross_Send (MovementDescId,MovementId,MovementId_by:Integer;myPrintCount:Integer;isPreview:Boolean):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     Result:=false;
          //
          try
             //Print
             if 1=1 // (MovementDescId = zc_Movement_Sale)or(MovementDescId = zc_Movement_SendOnPrice)
             then Print_PackDocumentGross_Send (MovementId,MovementId_by,myPrintCount,isPreview)
             else begin ShowMessage ('Ошибка.Форма печати <Упак. Лист Перемещение вес БРУТТО> не найдена.');exit;end;
          except
                ShowMessage('Ошибка.Печать <Упак. Лист Перемещение вес БРУТТО> НЕ сформирована.');
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
             if (MovementDescId = zc_Movement_Sale) or (MovementDescId = zc_Movement_SendOnPrice)
             then Print_TransportDocument(MovementId,MovementId_sale,OperDate,myPrintCount,isPreview)
             else begin ShowMessage ('Ошибка.Форма печати <ТТН> не найдена.');exit;end;
          except
                ShowMessage('Ошибка.Печать <ТТН> не сформирована.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_Transport_Total(MovementDescId,MovementId_sale: Integer;OperDate:TDateTime;myPrintCount:Integer;isPreview:Boolean):Boolean;
begin
     UtilPrintForm.PrintHeaderCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsCDS.IndexFieldNames:='';
     UtilPrintForm.PrintItemsSverkaCDS.IndexFieldNames:='';
     //
     Result:=false;
          //
          try
             //Print
             if (MovementDescId = zc_Movement_Sale) or (MovementDescId = zc_Movement_SendOnPrice)
             then begin
                      if myPrintCount <= 0 then myPrintCount:=1;
                      //
                      UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId_sale;
                      UtilPrintForm.FormParams.ParamByName('OperDate').Value := OperDate;
                      UtilPrintForm.actPrint_TTN_final.CopiesCount:=myPrintCount;
                      UtilPrintForm.actPrint_TTN_final.WithOutPreview:= not isPreview;
                      //
                      UtilPrintForm.macPrint_TTN_final.Execute;
             end
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
             else begin ShowMessage ('Ошибка.Форма печати <Качественное> не найдена.');exit;end;
          except
                ShowMessage('Ошибка.Печать <Качественное> не сформирована.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_Sale_Order(MovementId_order,MovementId_by:Integer; isDiff:Boolean; isDiffTax:Boolean):Boolean;
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
             then Print_Sale_OrderDocument(MovementId_order, MovementId_by, isDiff, isDiffTax)
             else begin ShowMessage ('Ошибка.'+#10+#13+'№ заявки не установлен.'+#10+#13+'Печать <Сравнение Заявка/Отгрузка> не сформирована.');exit;end;
          except
                ShowMessage('Ошибка.Печать <Сравнение Заявка/Отгрузка> не сформирована.');
                exit;
          end;
     Result:=true;
end;
//------------------------------------------------------------------------------------------------
function Print_QualityDoc_list(MovementDescId,MovementId:Integer; isPreview:Boolean):Boolean;
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
             then Print_QualityDocument_list(MovementId,isPreview)
             else begin ShowMessage ('Ошибка.Форма печати <Качественное> возможно только для продажи.');exit;end;
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
  UtilPrintForm.spInsert_Movement_EDI_Send.ParamByName('ioId').Value := 0;
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.FormParams.ParamByName('DescCode_EDI_Send').Value := 'zc_MovementBoolean_EdiInvoice';
  try UtilPrintForm.actInsert_Movement_EDI_Send.Execute;
  except
        ShowMessage('Ошибка при отправке в EXITE документа <Счет>.');
        exit;
  end;
  {try UtilPrintForm.mactInvoice.Execute;
  except
        ShowMessage('Ошибка при отправке в EXITE документа <Счет>.');
        exit;
  end;}
  ShowMessage('Документ <Счет> отправлен успешно в EXITE.');
end;
//------------------------------------------------------------------------------------------------
procedure SendEDI_OrdSpr (MovementId: Integer);
begin
  UtilPrintForm.spInsert_Movement_EDI_Send.ParamByName('ioId').Value := 0;
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.FormParams.ParamByName('DescCode_EDI_Send').Value := 'zc_MovementBoolean_EdiOrdspr';
  try UtilPrintForm.actInsert_Movement_EDI_Send.Execute;
  except
        ShowMessage('Ошибка при отправке в EXITE документа <Подтверждение отгрузки>.');
        exit;
  end;
  {try UtilPrintForm.mactOrdSpr.Execute;
  except
        ShowMessage('Ошибка при отправке в EXITE документа <Подтверждение отгрузки>.');
        exit;
  end;}
  ShowMessage('Документ <Подтверждение отгрузки> отправлен успешно в EXITE.');
end;
//------------------------------------------------------------------------------------------------
procedure SendEDI_Desadv (MovementId: Integer);
begin
  UtilPrintForm.spInsert_Movement_EDI_Send.ParamByName('ioId').Value := 0;
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  UtilPrintForm.FormParams.ParamByName('DescCode_EDI_Send').Value := 'zc_MovementBoolean_EdiDesadv';
  try UtilPrintForm.actInsert_Movement_EDI_Send.Execute;
  except
        ShowMessage('Ошибка при отправке в EXITE документа <Уведомление об отгрузке>.');
        exit;
  end;
  {try UtilPrintForm.mactDesadv.Execute;
  except
        ShowMessage('Ошибка при отправке в EXITE документа <Уведомление об отгрузке>.');
        exit;
  end;}
  ShowMessage('Документ <Уведомление об отгрузке> отправлен успешно в EXITE.');
end;
//------------------------------------------------------------------------------------------------
procedure Export_Email (MovementId: Integer);
begin
  UtilPrintForm.FormParams.ParamByName('Id').Value := MovementId;
  try UtilPrintForm.actExport.Execute;
  except
        ShowMessage('Ошибка при отправке электронного документа по почте Покупателю.');
        exit;
  end;
  ShowMessage('Электронный документ успешно отправлен по почте Покупателю.');
end;
//------------------------------------------------------------------------------------------------
end.
