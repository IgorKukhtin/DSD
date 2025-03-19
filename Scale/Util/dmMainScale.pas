unit dmMainScale;

interface

uses
  System.SysUtils, System.Classes, dsdDB, Data.DB, Datasnap.DBClient, Vcl.Dialogs,UtilScale,
  dsdCommon;

type
  TDMMainScaleForm = class(TDataModule)
    ClientDataSet: TClientDataSet;
    spSelect: TdsdStoredProc;
    procedure DataModuleCreate(Sender: TObject);
  private
  public
    time_exec_Insert_Scale_MI : TDateTime;
    GoodsId_exec_Insert_Scale_MI : Integer;
    // Scale + ScaleCeh
    function gpSelect_ToolsWeighing_onLevelChild(inBranchCode:Integer;inLevelChild: String): TArrayList;
    function gpGet_ToolsWeighing_Value(inLevel1,inLevel2,inLevel3,inItemName,inDefaultValue:String):String;
    function gpGet_Scale_User:String;
    function gpGet_Scale_OperDate(var execParams:TParams):TDateTime;
    // Scale - Sticker
    function gpSelect_Scale_StickerFile (inBranchCode : Integer) : TArrayStickerFileList;
    function gpSelect_Scale_StickerPack: TArrayList;
    // Scale + ScaleCeh
    function gpSelect_Scale_GoodsKindWeighing: TArrayList;
    function gpSelect_Object_Language: TArrayList;
    function gpGet_Scale_Goods(var execParams:TParams;inBarCode:String): Boolean;
    function gpGet_Scale_Goods_gk(var execParams:TParams): Boolean;
    // Scale + ScaleCeh
    function gpUpdate_Scale_MI_Erased(MovementItemId:Integer;NewValue: Boolean): Boolean;
    function gpUpdate_Scale_MIFloat(execParams:TParams): Boolean;
    function gpUpdate_Scale_MIString(execParams:TParams): Boolean;
    function gpUpdate_Scale_MIDate(execParams:TParams): Boolean;
    function gpUpdate_Scale_MILinkObject(execParams:TParams): Boolean;
    function gpUpdate_Scale_MLM(execParams:TParams): Boolean;
    function gpUpdate_Scale_MovementString(inMovementId:Integer; inDescCode, inValueData : String): Boolean;
    function gpUpdate_Scale_MovementDate(execParams:TParams): Boolean;
    // Scale + ScaleCeh
    function lpGet_BranchName(inBranchCode:Integer): String;
    function gpGet_Scale_Movement_checkId(var execParamsMovement:TParams): Boolean;
    function gpGet_Scale_Movement_checkInvNumberPartner(var execParamsMovement:TParams): Boolean;
    // Scale
    function gpGet_Scale_Movement_findOldPeriod(var execParamsMovement:TParams): Boolean;
    function gpGet_Scale_Movement_OperDatePartner(var execParamsMovement:TParams): Boolean;
    // !!!Scale + ScaleCeh!!!
    function gpGet_Scale_Partner(var execParams:TParams;inPartnerCode:Integer): Boolean;
    function gpGet_Scale_PartnerParams(var execParams:TParams): Boolean;
    function gpGet_Scale_OrderExternal(var execParams:TParams;inBarCode:String; inFromId_calc, inToId_calc:Integer): Boolean;
    function gpGet_Scale_Transport(var execParams:TParams;inBarCode:String): Boolean;
    // Scale
    function gpGet_Scale_GoodsRetail(var execParamsMovement:TParams;var execParams:TParams;inBarCode:String): Boolean;
    function gpGet_Scale_Personal(var execParams:TParams;inPersonalCode:Integer): Boolean;
    function gpGet_Scale_PSW_delete (inPSW: String): String;
    // !!!Scale + ScaleCeh!!!
    function gpUpdate_Scale_Partner_print(PartnerId : Integer; isMovement,isAccount,isTransport,isQuality,isPack,isSpec,isTax : Boolean; CountMovement,CountAccount,CountTransport,CountQuality,CountPack,CountSpec,CountTax : Integer): Boolean;
    //
    // +++Scale+++
    function gpGet_Scale_Movement(var execParamsMovement:TParams;isLast,isNext:Boolean): Boolean;
    // +++Scale+++
    function gpInsertUpdate_Scale_Movement(var execParamsMovement:TParams): Boolean;
    function gpInsert_Scale_MI(var execParamsMovement:TParams;var execParamsMI:TParams): Boolean;
    function gpInsert_Movement_all(var execParamsMovement:TParams): Boolean;
    function gpUpdate_Scale_Movement(var execParamsMovement:TParams): Boolean;
    //
    // Scale
    function gpUpdate_Scale_Movement_Transport(execParamsMovement:TParams): Boolean;
    function gpUpdate_Scale_Movement_PersonalComlete(execParamsPersonalComplete:TParams): Boolean;
    function gpUpdate_Scale_Movement_PersonalLoss(execParams:TParams): Boolean;
    //
    function gpUpdate_Scale_Movement_ChangePercentAmount (execParamsMovement : TParams): Boolean;
    function gpUpdate_Scale_Movement_Income_PricePartner (execParams : TParams; inIsUpdate : Boolean): Boolean;
    function gpUpdate_Scale_MI_Income_PricePartner(MovementDescId, BranchCode, MovementItemId  : Integer; PricePartner, AmountPartnerSecond : Double; isAmountPartnerSecond, isPriceWithVAT : Boolean; inOperDate_ReturnOut : TDateTime): Boolean;
    // Scale + ScaleCeh
    function gpUpdate_Scale_Movement_Status(MovementId_parent:Integer): Boolean;

    // Scale
    function gpInitialize_SettingMain_Tare_115: Boolean;

  end;

  function gpInitialize_Const: Boolean; // Scale + ScaleCeh
  function gpInitialize_Ini: Boolean;   // Scale
  function gpInitialize_SettingMain_Default: Boolean;//Scale + ScaleCeh
  function gpInitialize_MovementDesc: Boolean; // !!!Scale + ScaleCeh!!!
  function gpFind_MovementDesc (execParamsMovement : TParams): Boolean; // !!!Scale!!!

var
  DMMainScaleForm: TDMMainScaleForm;

implementation
uses Forms,FormStorage,Inifiles,TypInfo,DialogMovementDesc,UtilConst, DateUtils ;
{$R *.dfm}
{------------------------------------------------------------------------}
procedure TDMMainScaleForm.DataModuleCreate(Sender: TObject);
begin
    //gpInitialize_ParamsMovement;
    //
    Create_ParamsMovement(ParamsMovement);
    //
    Create_ParamsReason_global(ParamsReason);
    //
    gpGet_Scale_OperDate(ParamsMovement);
    //
    DMMainScaleForm.gpGet_Scale_Movement(ParamsMovement,TRUE,FALSE);//isLast=TRUE,isNext=FALSE
end;
{------------------------------------------------------------------------}
{function gpInitialize_ParamsMovement: Boolean;
begin
    Result:=false;
    //
    Create_ParamsMovement(ParamsMovement);
    //
    gpInitialize_OperDate(ParamsMovement);
    //
    Result:=DMMainScaleForm.gpGet_Scale_Movement(ParamsMovement,TRUE,FALSE);//isLast=TRUE,isNext=FALSE
end;}
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_Movement(var execParamsMovement:TParams;isLast,isNext:Boolean): Boolean;
begin
    Result:=false;

    with spSelect do
    begin
       StoredProcName:='gpGet_Scale_Movement';
       OutputType:=otDataSet;
       Params.Clear;

       if (isNext = TRUE)or(isLast = FALSE)//так сложно, т.к. при isLast = FALSE надо обработать MovementId
       then Params.AddParam('inMovementId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementId').AsInteger)
       else Params.AddParam('inMovementId', ftInteger, ptInput, 0);
       Params.AddParam('inOperDate', ftDateTime, ptInput, execParamsMovement.ParamByName('OperDate').AsDateTime);
       Params.AddParam('inIsNext', ftBoolean, ptInput, isNext);
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);

       //try
         Execute;

       //!!!выход, пока обрабатывается эта ошибка только в одном месте!!!
       if DataSet.RecordCount<>1 then begin Result:=false;exit;end;


       with execParamsMovement do
       begin
         ParamByName('MovementId_begin').AsInteger:= 0;
         ParamByName('isExportEmail').AsBoolean:= false;


         ParamByName('MovementId').AsInteger:= DataSet.FieldByName('MovementId').asInteger;
         ParamByName('InvNumber').asString:= DataSet.FieldByName('InvNumber').asString;
         ParamByName('OperDate_Movement').asDateTime:= DataSet.FieldByName('OperDate').asDateTime;

         ParamByName('MovementDescNumber').AsInteger:= DataSet.FieldByName('MovementDescNumber').asInteger;

         ParamByName('MovementDescId').AsInteger:= DataSet.FieldByName('MovementDescId').asInteger;
         ParamByName('FromId').AsInteger:= DataSet.FieldByName('FromId').asInteger;     // ToId
         ParamByName('FromCode').AsInteger:= DataSet.FieldByName('FromCode').asInteger; // ToCode
         ParamByName('FromName').asString:= DataSet.FieldByName('FromName').asString;   // ToName
         ParamByName('ToId').AsInteger:= DataSet.FieldByName('ToId').asInteger;         // FromId
         ParamByName('ToCode').AsInteger:= DataSet.FieldByName('ToCode').asInteger;     // FromCode
         ParamByName('ToName').asString:= DataSet.FieldByName('ToName').asString;       // FromName
         ParamByName('PaidKindId').AsInteger:= DataSet.FieldByName('PaidKindId').asInteger;
         ParamByName('PaidKindName').asString:= DataSet.FieldByName('PaidKindName').asString;

         ParamByName('calcPartnerId').AsInteger:= DataSet.FieldByName('PartnerId_calc').AsInteger;
         ParamByName('calcPartnerCode').AsInteger:= DataSet.FieldByName('PartnerCode_calc').AsInteger;
         ParamByName('calcPartnerName').asString:= DataSet.FieldByName('PartnerName_calc').asString;
         ParamByName('ChangePercent').asFloat:= DataSet.FieldByName('ChangePercent').asFloat;
         ParamByName('ChangePercentAmount').asFloat:= DataSet.FieldByName('ChangePercentAmount').asFloat;

         ParamByName('isEdiOrdspr').asBoolean:= DataSet.FieldByName('isEdiOrdspr').asBoolean;
         ParamByName('isEdiInvoice').asBoolean:= DataSet.FieldByName('isEdiInvoice').asBoolean;
         ParamByName('isEdiDesadv').asBoolean:= DataSet.FieldByName('isEdiDesadv').asBoolean;

         ParamByName('isMovement').asBoolean:= DataSet.FieldByName('isMovement').asBoolean;
         ParamByName('isAccount').asBoolean:= DataSet.FieldByName('isAccount').asBoolean;
         ParamByName('isTransport').asBoolean:= DataSet.FieldByName('isTransport').asBoolean;
         ParamByName('isQuality').asBoolean:= DataSet.FieldByName('isQuality').asBoolean;
         ParamByName('isPack').asBoolean:= DataSet.FieldByName('isPack').asBoolean;
         ParamByName('isSpec').asBoolean:= DataSet.FieldByName('isSpec').asBoolean;
         ParamByName('isTax').asBoolean:= DataSet.FieldByName('isTax').asBoolean;

         ParamByName('CountMovement').asInteger:= DataSet.FieldByName('CountMovement').asInteger;
         ParamByName('CountAccount').asInteger:= DataSet.FieldByName('CountAccount').asInteger;
         ParamByName('CountTransport').asInteger:= DataSet.FieldByName('CountTransport').asInteger;
         ParamByName('CountQuality').asInteger:= DataSet.FieldByName('CountQuality').asInteger;
         ParamByName('CountPack').asInteger:= DataSet.FieldByName('CountPack').asInteger;
         ParamByName('CountSpec').asInteger:= DataSet.FieldByName('CountSpec').asInteger;
         ParamByName('CountTax').asInteger:= DataSet.FieldByName('CountTax').asInteger;

         ParamByName('OrderExternalId').AsInteger        := DataSet.FieldByName('MovementId_Order').asInteger;
         ParamByName('OrderExternal_DescId').AsInteger   := DataSet.FieldByName('MovementDescId_Order').asInteger;
         ParamByName('OrderExternal_BarCode').asString   := DataSet.FieldByName('BarCode').asString;
         ParamByName('OrderExternal_InvNumber').asString := DataSet.FieldByName('InvNumber_Order').asString;
         ParamByName('OrderExternalName_master').asString:= DataSet.FieldByName('OrderExternalName_master').asString;

         ParamByName('TransportId').AsInteger        := DataSet.FieldByName('MovementId_Transport').asInteger;
         ParamByName('Transport_BarCode').asString   := DataSet.FieldByName('Transport_BarCode').asString+CalcBarCode(DataSet.FieldByName('Transport_BarCode').asString);
         ParamByName('Transport_InvNumber').asString := DataSet.FieldByName('Transport_InvNumber').asString;
         ParamByName('PersonalDriverId').AsInteger   := DataSet.FieldByName('PersonalDriverId').asInteger;
         ParamByName('PersonalDriverName').asString  := DataSet.FieldByName('PersonalDriverName').asString;
         ParamByName('CarName').asString             := DataSet.FieldByName('CarName').asString;
         ParamByName('RouteName').asString           := DataSet.FieldByName('RouteName').asString;

         ParamByName('SubjectDocId').AsInteger   := DataSet.FieldByName('SubjectDocId').asInteger;
         ParamByName('SubjectDocCode').AsInteger := DataSet.FieldByName('SubjectDocCode').asInteger;
         ParamByName('SubjectDocName').asString  := DataSet.FieldByName('SubjectDocName').asString;
         ParamByName('DocumentComment').asString := DataSet.FieldByName('Comment').asString;
         ParamByName('InvNumberPartner').asString := DataSet.FieldByName('InvNumberPartner').asString;

         ParamByName('ContractId').AsInteger    := DataSet.FieldByName('ContractId').asInteger;
         ParamByName('ContractCode').AsInteger  := DataSet.FieldByName('ContractCode').asInteger;
         ParamByName('ContractNumber').asString := DataSet.FieldByName('ContractNumber').asString;
         ParamByName('ContractTagName').asString:= DataSet.FieldByName('ContractTagName').asString;

         ParamByName('GoodsPropertyId').AsInteger:= DataSet.FieldByName('GoodsPropertyId').AsInteger;
         ParamByName('GoodsPropertyCode').AsInteger:= DataSet.FieldByName('GoodsPropertyCode').AsInteger;
         ParamByName('GoodsPropertyName').asString:= DataSet.FieldByName('GoodsPropertyName').asString;

         ParamByName('PriceListId').AsInteger   := DataSet.FieldByName('PriceListId').asInteger;
         ParamByName('PriceListCode').AsInteger := DataSet.FieldByName('PriceListCode').asInteger;
         ParamByName('PriceListName').asString  := DataSet.FieldByName('PriceListName').asString;

         ParamByName('isContractGoods').AsBoolean:= DataSet.FieldByName('isContractGoods').AsBoolean;
         ParamByName('isAsset').asBoolean:= DataSet.FieldByName('isAsset').asBoolean;

         ParamByName('TotalSumm').asFloat:= DataSet.FieldByName('TotalSumm').asFloat;
         ParamByName('TotalSummPartner').asFloat:= DataSet.FieldByName('TotalSummPartner').asFloat;

         ParamsReason.ParamByName('ReasonId').AsInteger:= DataSet.FieldByName('ReasonId').AsInteger;
         ParamsReason.ParamByName('ReasonCode').AsInteger:= DataSet.FieldByName('ReasonCode').AsInteger;
         ParamsReason.ParamByName('ReasonName').AsString:= DataSet.FieldByName('ReasonName').AsString;
         ParamsReason.ParamByName('ReturnKindName').AsString:= DataSet.FieldByName('ReturnKindName').AsString;

       end;

       {except
         result.Code := Code;
         result.Id   := 0;
         result.Name := '';
         ShowMessage('Ошибка получения - gpMovementDesc');
       end;}
    end;

    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_Movement_PersonalComlete(execParamsPersonalComplete:TParams): Boolean;
begin
    Result:=false;
    with spSelect do begin
       StoredProcName:='gpUpdate_Scale_Movement_PersonalComlete';
       OutputType:=otResult;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInput, execParamsPersonalComplete.ParamByName('MovementId').AsInteger);
       Params.AddParam('inPersonalId1', ftInteger, ptInput, execParamsPersonalComplete.ParamByName('PersonalId1').AsInteger);
       Params.AddParam('inPersonalId2', ftInteger, ptInput, execParamsPersonalComplete.ParamByName('PersonalId2').AsInteger);
       Params.AddParam('inPersonalId3', ftInteger, ptInput, execParamsPersonalComplete.ParamByName('PersonalId3').AsInteger);
       Params.AddParam('inPersonalId4', ftInteger, ptInput, execParamsPersonalComplete.ParamByName('PersonalId4').AsInteger);
       Params.AddParam('inPersonalId5', ftInteger, ptInput, execParamsPersonalComplete.ParamByName('PersonalId5').AsInteger);
       Params.AddParam('inPositionId1', ftInteger, ptInput, execParamsPersonalComplete.ParamByName('PositionId1').AsInteger);
       Params.AddParam('inPositionId2', ftInteger, ptInput, execParamsPersonalComplete.ParamByName('PositionId2').AsInteger);
       Params.AddParam('inPositionId3', ftInteger, ptInput, execParamsPersonalComplete.ParamByName('PositionId3').AsInteger);
       Params.AddParam('inPositionId4', ftInteger, ptInput, execParamsPersonalComplete.ParamByName('PositionId4').AsInteger);
       Params.AddParam('inPositionId5', ftInteger, ptInput, execParamsPersonalComplete.ParamByName('PositionId5').AsInteger);
       Params.AddParam('inPersonalId1_Stick', ftInteger, ptInput, execParamsPersonalComplete.ParamByName('PersonalId1_Stick').AsInteger);
       Params.AddParam('inPositionId1_Stick', ftInteger, ptInput, execParamsPersonalComplete.ParamByName('PositionId1_Stick').AsInteger);
       //try
         Execute;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpUpdate_Scale_Movement_PersonalComlete');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_Movement_PersonalLoss(execParams:TParams): Boolean;
begin
    Result:=false;
    with spSelect do begin
       StoredProcName:='gpUpdate_Scale_Movement_PersonalLoss';
       OutputType:=otResult;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInput, execParams.ParamByName('MovementId').AsInteger);
       Params.AddParam('inPersonalId', ftInteger, ptInput, execParams.ParamByName('PersonalId').AsInteger);
       //try
         Execute;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpUpdate_Scale_Movement_PersonalComlete');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_Movement_Status(MovementId_parent:Integer): Boolean;
begin
    Result:=false;
    with spSelect do begin
       StoredProcName:='gpUpdate_Scale_Movement_Status';
       OutputType:=otResult;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInput, MovementId_parent);
       //try
         Execute;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpUpdate_Scale_Movement_PersonalComlete');
       end;}
    end;
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_Movement_ChangePercentAmount (execParamsMovement : TParams): Boolean;
begin
    Result:=false;
    //
    with spSelect do begin
       StoredProcName:='gpUpdate_Scale_Movement_ChangePercentAmount';
       OutputType:=otResult;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementId').AsInteger);
       //% скидки для кол-ва поставщика
       Params.AddParam('inChangePercentAmount', ftFloat, ptInput, execParamsMovement.ParamByName('DiscountAmountPartner').AsFloat);
       // скидка за несоотвестветствие температуры
       Params.AddParam('inIsReason1', ftBoolean, ptInput, execParamsMovement.ParamByName('isDiscount_t').AsBoolean);
       // скидка за несоотвестветствие качеству
       Params.AddParam('inIsReason2', ftBoolean, ptInput, execParamsMovement.ParamByName('isDiscount_q').AsBoolean);
       //
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       //try
         Execute;
         Result:=true;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpGet_Scale_Movement_checkId');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_Movement_Income_PricePartner(execParams:TParams; inIsUpdate : Boolean): Boolean;
begin
    Result:=false;
    //
    if execParams.ParamByName('MovementId').AsInteger<>0 then
    with spSelect do begin
       StoredProcName:='gpUpdate_Scale_Movement_Income_PricePartner';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInput, execParams.ParamByName('MovementId').AsInteger);
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       Params.AddParam('inIsUpdate', ftBoolean, ptInput, inIsUpdate);
       //try
         Execute;
         Result:=DataSet.RecordCount > 0;
         //
         execParams.ParamByName('isPrice_diff_inf').AsBoolean:=DataSet.FieldByName('isPrice_diff').AsBoolean;
         execParams.ParamByName('GoodsCode_inf').AsInteger:=DataSet.FieldByName('GoodsCode').AsInteger;
         execParams.ParamByName('GoodsName_inf').AsString:=DataSet.FieldByName('GoodsName').AsString;
         execParams.ParamByName('PricePartner_inf').AsFloat:=DataSet.FieldByName('PricePartner').AsFloat;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpGet_Scale_Movement_checkId');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_MI_Income_PricePartner(MovementDescId, BranchCode, MovementItemId  : Integer;
                                                                PricePartner, AmountPartnerSecond : Double;
                                                                isAmountPartnerSecond, isPriceWithVAT : Boolean;
                                                                inOperDate_ReturnOut : TDateTime
                                                               ): Boolean;
begin
    Result:=false;
    //
    with spSelect do begin
       StoredProcName:='gpUpdate_Scale_MI_Income_PricePartner';
       OutputType:=otResult;
       Params.Clear;
       Params.AddParam('inMovementDescId', ftInteger, ptInput, MovementDescId);
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       Params.AddParam('inMovementItemId', ftInteger, ptInput, MovementItemId);
       Params.AddParam('inPricePartner', ftFloat, ptInput, PricePartner);
       Params.AddParam('inAmountPartnerSecond', ftFloat, ptInput, AmountPartnerSecond);
       Params.AddParam('inIsAmountPartnerSecond', ftBoolean, ptInput, isAmountPartnerSecond);
       Params.AddParam('inIsPriceWithVAT', ftBoolean, ptInput, isPriceWithVAT);
       Params.AddParam('inOperDate_ReturnOut', ftDateTime, ptInput, inOperDate_ReturnOut);
       //try
         Execute;
         Result:=true;
         //
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpGet_Scale_Movement_checkId');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_Movement_findOldPeriod(var execParamsMovement:TParams): Boolean;
begin
    Result:=false;
    //
    if execParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_Sale
    then exit;
    //
    if execParamsMovement.ParamByName('MovementId').AsInteger<>0 then
    with spSelect do begin
       StoredProcName:='gpGet_Scale_Movement_findOldPeriod';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementId').AsInteger);
       Params.AddParam('inMovementDescId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementDescId').AsInteger);
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       //try
         Execute;
         Result:=DataSet.FieldByName('isFind').asBoolean;
         execParamsMovement.ParamByName('OperDate_inf').AsDateTime:=DataSet.FieldByName('OperDate').AsDateTime;
         execParamsMovement.ParamByName('InvNumber_inf').AsString:=DataSet.FieldByName('InvNumber').AsString;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpGet_Scale_Movement_checkId');
       end;}
    end;
end;

{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_Movement_OperDatePartner(var execParamsMovement:TParams): Boolean;
begin
    Result:=false;
    //
    if execParamsMovement.ParamByName('MovementId').AsInteger<>0 then
    with spSelect do begin
       StoredProcName:='gpGet_Scale_OperDatePartner';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       Params.AddParam('inMovementId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementId').AsInteger);
       Params.AddParam('inMovementDescId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementDescId').AsInteger);
       Params.AddParam('inToId', ftInteger, ptInput, execParamsMovement.ParamByName('ToId').AsInteger);
       Params.AddParam('inOperDate', ftDateTime, ptInput, execParamsMovement.ParamByName('OperDate').AsDateTime);
       Params.AddParam('inIsDocInsert', ftBoolean, ptInput, execParamsMovement.ParamByName('isDocInsert').AsBoolean);
       Params.AddParam('inIsOldPeriod', ftBoolean, ptInput, execParamsMovement.ParamByName('isOldPeriod').AsBoolean);
       //try
         Execute;
         Result:=DataSet.FieldByName('isDialog').asBoolean;
         execParamsMovement.ParamByName('OperDatePartner').AsDateTime:=DataSet.FieldByName('OperDatePartner').AsDateTime;
         execParamsMovement.ParamByName('MovementId_find').AsInteger:=DataSet.FieldByName('MovementId_find').AsInteger;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpGet_Scale_Movement_checkId');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_Movement_checkId(var execParamsMovement:TParams): Boolean;
begin
    Result:=false;
    if execParamsMovement.ParamByName('MovementId').AsInteger<>0 then
    with spSelect do begin
       StoredProcName:='gpGet_Scale_Movement_checkId';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInputOutput, execParamsMovement.ParamByName('MovementId').AsInteger);
       //try
         Execute;
         Result:=DataSet.FieldByName('isOk').asBoolean;
         execParamsMovement.ParamByName('isMovementId_check').asBoolean:=DataSet.FieldByName('isOk').asBoolean
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpGet_Scale_Movement_checkId');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_Movement_checkInvNumberPartner(var execParamsMovement:TParams): Boolean;
begin
    Result:=false;
    //if execParamsMovement.ParamByName('MovementId').AsInteger<>0 then
    with spSelect do begin
       StoredProcName:='gpGet_Scale_Movement_checkInvNumberPartner';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInputOutput, execParamsMovement.ParamByName('MovementId').AsInteger);
       Params.AddParam('inPartnerId', ftInteger, ptInputOutput, execParamsMovement.ParamByName('calcPartnerId').AsInteger);
       Params.AddParam('inContractId', ftInteger, ptInputOutput, execParamsMovement.ParamByName('ContractId').AsInteger);
       Params.AddParam('inInvNumberPartner', ftString, ptInputOutput, execParamsMovement.ParamByName('InvNumberPartner').AsString);
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       //try
         Execute;
         Result:=DataSet.FieldByName('isOk').asBoolean;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpGet_Scale_Movement_checkId');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_MIFloat(execParams:TParams): Boolean;
begin
    Result:=false;

    with spSelect do begin
       StoredProcName:= 'gpUpdate_Scale_MIFloat';
       OutputType:=otResult;
       Params.Clear;
       Params.AddParam('inMovementItemId', ftInteger, ptInput, execParams.ParamByName('inMovementItemId').AsInteger);
       Params.AddParam('inDescCode', ftString, ptInput, execParams.ParamByName('inDescCode').AsString);
       Params.AddParam('inValueData', ftFloat, ptInput, execParams.ParamByName('inValueData').AsFloat);
       //try
         Execute;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpUpdate_Scale_MIFloat');
       end;}
    end;
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_MIString(execParams:TParams): Boolean;
begin
    Result:=false;

    with spSelect do begin
       StoredProcName:= 'gpUpdate_Scale_MIString';
       OutputType:=otResult;
       Params.Clear;
       Params.AddParam('inMovementItemId', ftInteger, ptInput, execParams.ParamByName('inMovementItemId').AsInteger);
       Params.AddParam('inDescCode', ftString, ptInput, execParams.ParamByName('inDescCode').AsString);
       Params.AddParam('inValueData', ftString, ptInput, execParams.ParamByName('inValueData').AsString);
       //try
         Execute;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpUpdate_Scale_MIString');
       end;}
    end;
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_MIDate(execParams:TParams): Boolean;
begin
    Result:=false;

    with spSelect do begin
       StoredProcName:= 'gpUpdate_Scale_MIDate';
       OutputType:=otResult;
       //
       if GetIndexParams(execParams, 'isPartionDate_save') > 0 then
         if execParams.ParamByName('isPartionDate_save').AsBoolean = FALSE
         then execParams.ParamByName('inMovementItemId').AsInteger:= -1 * abs (execParams.ParamByName('inMovementItemId').AsInteger);
       //
       Params.Clear;
       Params.AddParam('inMovementItemId', ftInteger, ptInput, execParams.ParamByName('inMovementItemId').AsInteger);
       Params.AddParam('inDescCode', ftString, ptInput, execParams.ParamByName('inDescCode').AsString);
       Params.AddParam('inValueData', ftDateTime, ptInput, execParams.ParamByName('inValueData').AsDateTime);
       execParams.ParamByName('inMovementItemId').AsInteger:= abs(execParams.ParamByName('inMovementItemId').AsInteger);
       //try
         Execute;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpUpdate_Scale_MIDate');
       end;}
    end;
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_MILinkObject(execParams:TParams): Boolean;
begin
    Result:=false;

    with spSelect do begin
       StoredProcName:= 'gpUpdate_Scale_MILinkObject';
       OutputType:=otResult;
       Params.Clear;
       Params.AddParam('inMovementItemId', ftInteger, ptInput, execParams.ParamByName('inMovementItemId').AsInteger);
       Params.AddParam('inDescCode', ftString, ptInput, execParams.ParamByName('inDescCode').AsString);
       Params.AddParam('inObjectId', ftInteger, ptInput, execParams.ParamByName('inObjectId').AsInteger);
       //try
         Execute;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpUpdate_Scale_MILinkObject');
       end;}
    end;
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_MovementDate(execParams:TParams): Boolean;
begin
    Result:=false;

    with spSelect do begin
       StoredProcName:= 'gpUpdate_Scale_MovementDate';
       OutputType:=otResult;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInput, execParams.ParamByName('inMovementId').AsInteger);
       Params.AddParam('inDescCode', ftString, ptInput, execParams.ParamByName('inDescCode').AsString);
       Params.AddParam('inValueData', ftDateTime, ptInput, execParams.ParamByName('inValueData').AsDateTime);
       //try
         Execute;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpUpdate_Scale_MovementDate');
       end;}
    end;
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_MovementString(inMovementId:Integer; inDescCode, inValueData : String): Boolean;
begin
    Result:=false;

    with spSelect do begin
       StoredProcName:= 'gpUpdate_Scale_MovementString';
       OutputType:=otResult;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInput, inMovementId);
       Params.AddParam('inDescCode', ftString, ptInput, inDescCode);
       Params.AddParam('inValueData', ftString, ptInput, inValueData);
       //try
         Execute;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpUpdate_Scale_MLM');
       end;}
    end;
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_MLM(execParams:TParams): Boolean;
begin
    Result:=false;

    with spSelect do begin
       StoredProcName:= 'gpUpdate_Scale_MLM';
       OutputType:=otResult;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInput, execParams.ParamByName('inMovementId').AsInteger);
       Params.AddParam('inDescCode', ftString, ptInput, execParams.ParamByName('inDescCode').AsString);
       Params.AddParam('inMovementChildId', ftInteger, ptInput, execParams.ParamByName('inMovementChildId').AsInteger);
       //try
         Execute;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpUpdate_Scale_MLM');
       end;}
    end;
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_Movement_Transport(execParamsMovement:TParams): Boolean;
var execParams:TParams;
begin
     if execParamsMovement.ParamByName('isTransport_link').AsBoolean = FALSE then
     begin
          Result:=false;
          exit;
     end;
     execParams:=nil;
     ParamAddValue(execParams,'inMovementId',ftInteger,execParamsMovement.ParamByName('MovementId').AsInteger);
     ParamAddValue(execParams,'inDescCode',ftString,'zc_MovementLinkMovement_Transport');
     ParamAddValue(execParams,'inMovementChildId',ftInteger,execParamsMovement.ParamByName('TransportId').AsInteger);
     Result:=DMMainScaleForm.gpUpdate_Scale_MLM(execParams);
     execParams.Free;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_Partner_print(PartnerId : Integer; isMovement,isAccount,isTransport,isQuality,isPack,isSpec,isTax : Boolean; CountMovement,CountAccount,CountTransport,CountQuality,CountPack,CountSpec,CountTax : Integer): Boolean;
begin
    Result:=false;

    with spSelect do begin
       StoredProcName:= 'gpUpdate_Scale_Partner_print';
       OutputType:=otResult;
       Params.Clear;
       Params.AddParam('inPartnerId', ftInteger, ptInput, PartnerId);
       Params.AddParam('inIsMovement', ftBoolean, ptInput, isMovement);
       Params.AddParam('inIsAccount', ftBoolean, ptInput, isAccount);
       Params.AddParam('inIsTransport', ftBoolean, ptInput, isTransport);
       Params.AddParam('inIsQuality', ftBoolean, ptInput, isQuality);
       Params.AddParam('inIsPack', ftBoolean, ptInput, isPack);
       Params.AddParam('inIsSpec', ftBoolean, ptInput, isSpec);
       Params.AddParam('inIsTax', ftBoolean, ptInput, isTax);
       Params.AddParam('inCountMovement', ftFloat, ptInput, CountMovement);
       Params.AddParam('inCountAccount', ftFloat, ptInput, CountAccount);
       Params.AddParam('inCountTransport', ftFloat, ptInput, CountTransport);
       Params.AddParam('inCountQuality', ftFloat, ptInput, CountQuality);
       Params.AddParam('inCountPack', ftFloat, ptInput, CountPack);
       Params.AddParam('inCountSpec', ftFloat, ptInput, CountSpec);
       Params.AddParam('inCountTax', ftFloat, ptInput, CountTax);
       //try
         Execute;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpUpdate_Scale_Partner_print');
       end;}
    end;
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpInsert_Movement_all(var execParamsMovement:TParams): Boolean;
begin
    Result:=false;
    with spSelect do begin
       StoredProcName:='gpInsert_Scale_Movement_all';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       Params.AddParam('inMovementId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementId').AsInteger);
       Params.AddParam('inMovementDescId_next', ftInteger, ptInput, execParamsMovement.ParamByName('MovementDescId_next').AsInteger);
       Params.AddParam('inOperDate', ftDateTime, ptInput, execParamsMovement.ParamByName('OperDate').AsDateTime);
       Params.AddParam('inOperDatePartner', ftDateTime, ptInput, execParamsMovement.ParamByName('OperDatePartner').AsDateTime);
       Params.AddParam('inIsDocInsert', ftBoolean, ptInput, execParamsMovement.ParamByName('isDocInsert').AsBoolean);
       Params.AddParam('inIsOldPeriod', ftBoolean, ptInput, execParamsMovement.ParamByName('isOldPeriod').AsBoolean);
       Params.AddParam('inIsDocPartner', ftBoolean, ptInput, execParamsMovement.ParamByName('isDocPartner').AsBoolean);
       Params.AddParam('inIP', ftString, ptInput, SettingMain.IP_str);
       //try
         Execute;
         execParamsMovement.ParamByName('MovementId_begin').AsInteger:=DataSet.FieldByName('MovementId_begin').asInteger;
         execParamsMovement.ParamByName('MovementId_begin_next').AsInteger:=DataSet.FieldByName('MovementId_begin_next').asInteger;
         execParamsMovement.ParamByName('isExportEmail').AsBoolean:= DataSet.FieldByName('isExportEmail').AsBoolean;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpInsert_Movement_all');
       end;}
    end;
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_Movement(var execParamsMovement:TParams): Boolean;
begin
    Result:=false;
    with spSelect do begin
       StoredProcName:='gpUpdate_Scale_Movement';
       OutputType:=otResult;
       Params.Clear;
       Params.AddParam('inId', ftInteger, ptInputOutput, execParamsMovement.ParamByName('MovementId').AsInteger);
       Params.AddParam('inMovementDescId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementDescId').AsInteger);
       Params.AddParam('inFromId', ftInteger, ptInput, execParamsMovement.ParamByName('FromId').AsInteger);
       Params.AddParam('inToId', ftInteger, ptInput, execParamsMovement.ParamByName('ToId').AsInteger);
       Params.AddParam('inContractId', ftInteger, ptInput, execParamsMovement.ParamByName('ContractId').AsInteger);
       Params.AddParam('inPaidKindId', ftInteger, ptInput, execParamsMovement.ParamByName('PaidKindId').AsInteger);
       Params.AddParam('inMovementDescNumber', ftInteger, ptInput, execParamsMovement.ParamByName('MovementDescNumber').AsInteger);
       //try
         Execute;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpInsertUpdate_Scale_Movement');
       end;}
    end;
    //
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpInsertUpdate_Scale_Movement(var execParamsMovement:TParams): Boolean;
begin
    Result:=false;
    with spSelect do begin
       StoredProcName:='gpInsertUpdate_Scale_Movement';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inId', ftInteger, ptInputOutput, execParamsMovement.ParamByName('MovementId').AsInteger);
       Params.AddParam('inOperDate', ftDateTime, ptInput, execParamsMovement.ParamByName('OperDate').AsDateTime);
       Params.AddParam('inOperDatePartner', ftDateTime, ptInput, execParamsMovement.ParamByName('OperDatePartner').AsDateTime);
       Params.AddParam('inInvNumberPartner', ftString, ptInput, execParamsMovement.ParamByName('InvNumberPartner').AsString);
       Params.AddParam('inMovementDescId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementDescId').AsInteger);
       Params.AddParam('inMovementDescNumber', ftInteger, ptInput, execParamsMovement.ParamByName('MovementDescNumber').AsInteger);
       Params.AddParam('inFromId', ftInteger, ptInput, execParamsMovement.ParamByName('FromId').AsInteger);
       Params.AddParam('inToId', ftInteger, ptInput, execParamsMovement.ParamByName('ToId').AsInteger);
       Params.AddParam('inContractId', ftInteger, ptInput, execParamsMovement.ParamByName('ContractId').AsInteger);
       Params.AddParam('inPaidKindId', ftInteger, ptInput, execParamsMovement.ParamByName('PaidKindId').AsInteger);
       Params.AddParam('inPriceListId', ftInteger, ptInput, execParamsMovement.ParamByName('PriceListId').AsInteger);
       Params.AddParam('inSubjectDocId', ftInteger, ptInput, execParamsMovement.ParamByName('SubjectDocId').AsInteger);
       Params.AddParam('inMovementId_Order', ftInteger, ptInput, execParamsMovement.ParamByName('OrderExternalId').AsInteger);
       //криво - через этот прараметр передаем - Через кого поступил возврат
       if (GetArrayList_Value_byName(Default_Array,'isDriverReturn') = AnsiUpperCase('TRUE'))
       and(execParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnIn)
       then Params.AddParam('inMovementId_Transport', ftInteger, ptInput, execParamsMovement.ParamByName('PersonalDriverId').AsInteger)
       else Params.AddParam('inMovementId_Transport', ftInteger, ptInput, execParamsMovement.ParamByName('TransportId').AsInteger);

       //(-)% Скидки (+)% Наценки
       Params.AddParam('inChangePercent', ftFloat, ptInput, execParamsMovement.ParamByName('ChangePercent').AsFloat);

       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       Params.AddParam('inComment', ftString, ptInput, execParamsMovement.ParamByName('DocumentComment').AsString);
       //
       Params.AddParam('inIsListInventory', ftBoolean, ptInput, execParamsMovement.ParamByName('isListInventory').AsBoolean);

       Params.AddParam('inMovementId_reReturnIn', ftInteger, ptInput, execParamsMovement.ParamByName('MovementId_reReturnIn').AsInteger);
       Params.AddParam('inIP', ftString, ptInput, SettingMain.IP_str);
       //try
         Execute;
         execParamsMovement.ParamByName('MovementId').AsInteger:=DataSet.FieldByName('Id').asInteger;
         execParamsMovement.ParamByName('InvNumber').AsString:=DataSet.FieldByName('InvNumber').AsString;
         execParamsMovement.ParamByName('OperDate_Movement').AsString:=DataSet.FieldByName('OperDate').AsString;
         execParamsMovement.ParamByName('TotalSumm').AsFloat:=DataSet.FieldByName('TotalSumm').AsFloat;
         execParamsMovement.ParamByName('TotalSummPartner').AsFloat:=DataSet.FieldByName('TotalSummPartner').AsFloat;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpInsertUpdate_Scale_Movement');
       end;}
    end;
    //
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpInsert_Scale_MI(var execParamsMovement:TParams;var execParamsMI:TParams): Boolean;
begin
    // надо отловить сохранение 2 раза
    if (now < IncSecond( time_exec_Insert_Scale_MI, SettingMain.Limit_Second_save_MI))
    and(SettingMain.Limit_Second_save_MI > 0)
    //and(SettingMain.BranchCode >= 201) and (SettingMain.BranchCode <= 210)
    and(execParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Sale)
    and(GoodsId_exec_Insert_Scale_MI = execParamsMI.ParamByName('GoodsId').AsInteger)
    then begin
        // наверно ошибочное сохранение 2 раза
        ShowMessage ('Ошибка.Дублирование взвешивания.'
                    +#10+#13
                    +'Вес на табло = <'+FloatToStr(execParamsMI.ParamByName('RealWeight').AsFloat)+'>'
                    +#10+#13
                    +DateTimeToStr(time_exec_Insert_Scale_MI)
                    +#10+#13
                    +DateTimeToStr(now)
                    );
        Result:= true;
        exit;
    end;
    //
    // надо отловить сохранение 2 раза
    time_exec_Insert_Scale_MI:= now;
    GoodsId_exec_Insert_Scale_MI:=execParamsMI.ParamByName('GoodsId').AsInteger;
    //
    //
    if execParamsMovement.ParamByName('MovementId').AsInteger = 0
    then Result:= gpInsertUpdate_Scale_Movement(execParamsMovement)
    else Result:= true;
    //
    if Result then
    with spSelect do begin
       StoredProcName:='gpInsert_Scale_MI';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inId', ftInteger, ptInput, 0);
       Params.AddParam('inMovementId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementId').AsInteger);
       Params.AddParam('inGoodsId', ftInteger, ptInput, execParamsMI.ParamByName('GoodsId').AsInteger);
       Params.AddParam('inGoodsKindId', ftInteger, ptInput, execParamsMI.ParamByName('GoodsKindId').AsInteger);

       Params.AddParam('inPartionGoodsDate', ftDateTime, ptInput, execParamsMI.ParamByName('PartionGoodsDate').AsDateTime);
       Params.AddParam('inIsPartionGoodsDate', ftBoolean, ptInput
                     , (execParamsMovement.ParamByName('isPartionGoodsDate').asBoolean = TRUE)
                    and(execParamsMI.ParamByName('isPartionDate_save').AsBoolean       = TRUE)
                      );
       Params.AddParam('inRealWeight', ftFloat, ptInput, execParamsMI.ParamByName('RealWeight').AsFloat);
       Params.AddParam('inChangePercentAmount', ftFloat, ptInput, execParamsMI.ParamByName('ChangePercentAmount').AsFloat);
       Params.AddParam('inCountTare', ftFloat, ptInput, execParamsMI.ParamByName('CountTare').AsFloat);
       Params.AddParam('inWeightTare', ftFloat, ptInput, execParamsMI.ParamByName('WeightTare').AsFloat);

       Params.AddParam('inCountTare1', ftFloat, ptInput, execParamsMI.ParamByName('CountTare1').AsFloat);
       Params.AddParam('inWeightTare1', ftFloat, ptInput, SettingMain.WeightTare1);
       Params.AddParam('inCountTare2', ftFloat, ptInput, execParamsMI.ParamByName('CountTare2').AsFloat);
       Params.AddParam('inWeightTare2', ftFloat, ptInput, SettingMain.WeightTare2);
       Params.AddParam('inCountTare3', ftFloat, ptInput, execParamsMI.ParamByName('CountTare3').AsFloat);
       Params.AddParam('inWeightTare3', ftFloat, ptInput, SettingMain.WeightTare3);
       Params.AddParam('inCountTare4', ftFloat, ptInput, execParamsMI.ParamByName('CountTare4').AsFloat);
       Params.AddParam('inWeightTare4', ftFloat, ptInput, SettingMain.WeightTare4);
       Params.AddParam('inCountTare5', ftFloat, ptInput, execParamsMI.ParamByName('CountTare5').AsFloat);
       Params.AddParam('inWeightTare5', ftFloat, ptInput, SettingMain.WeightTare5);
       Params.AddParam('inCountTare6', ftFloat, ptInput, execParamsMI.ParamByName('CountTare6').AsFloat);
       Params.AddParam('inWeightTare6', ftFloat, ptInput, SettingMain.WeightTare6);
       Params.AddParam('inCountTare7', ftFloat, ptInput, execParamsMI.ParamByName('CountTare7').AsFloat);
       Params.AddParam('inWeightTare7', ftFloat, ptInput, SettingMain.WeightTare7);
       Params.AddParam('inCountTare8', ftFloat, ptInput, execParamsMI.ParamByName('CountTare8').AsFloat);
       Params.AddParam('inWeightTare8', ftFloat, ptInput, SettingMain.WeightTare8);
       Params.AddParam('inCountTare9', ftFloat, ptInput, execParamsMI.ParamByName('CountTare9').AsFloat);
       Params.AddParam('inWeightTare9', ftFloat, ptInput, SettingMain.WeightTare9);
       Params.AddParam('inCountTare10', ftFloat, ptInput, execParamsMI.ParamByName('CountTare10').AsFloat);
       Params.AddParam('inWeightTare10', ftFloat, ptInput, SettingMain.WeightTare10);

       Params.AddParam('inTareId_1', ftInteger, ptInput, SettingMain.TareId_1);
       Params.AddParam('inTareId_2', ftInteger, ptInput, SettingMain.TareId_2);
       Params.AddParam('inTareId_3', ftInteger, ptInput, SettingMain.TareId_3);
       Params.AddParam('inTareId_4', ftInteger, ptInput, SettingMain.TareId_4);
       Params.AddParam('inTareId_5', ftInteger, ptInput, SettingMain.TareId_5);
       Params.AddParam('inTareId_6', ftInteger, ptInput, SettingMain.TareId_6);
       Params.AddParam('inTareId_7', ftInteger, ptInput, SettingMain.TareId_7);
       Params.AddParam('inTareId_8', ftInteger, ptInput, SettingMain.TareId_8);
       Params.AddParam('inTareId_9', ftInteger, ptInput, SettingMain.TareId_9);
       Params.AddParam('inTareId_10', ftInteger, ptInput, SettingMain.TareId_10);

       Params.AddParam('inPartionCellId', ftInteger, ptInput, execParamsMI.ParamByName('PartionCellId').AsInteger);

       Params.AddParam('inPrice', ftFloat, ptInput, execParamsMI.ParamByName('Price').AsFloat);
       Params.AddParam('inPrice_Return', ftFloat, ptInput, execParamsMI.ParamByName('Price_Return').AsFloat);
       Params.AddParam('inCountForPrice', ftFloat, ptInput, execParamsMI.ParamByName('CountForPrice').AsFloat);
       Params.AddParam('inCountForPrice_Return', ftFloat, ptInput, execParamsMI.ParamByName('CountForPrice_Return').AsFloat);
       if GetArrayList_Index_byName(Default_Array,'DayPrior_PriceReturn')>=0
       then Params.AddParam('inDayPrior_PriceReturn', ftInteger, ptInput, StrToInt(GetArrayList_Value_byName(Default_Array,'DayPrior_PriceReturn')))
       else Params.AddParam('inDayPrior_PriceReturn', ftInteger, ptInput, 0);
       Params.AddParam('inCount', ftFloat, ptInput, execParamsMI.ParamByName('Count').AsFloat);
       Params.AddParam('inHeadCount', ftFloat, ptInput, execParamsMI.ParamByName('HeadCount').AsFloat);
       Params.AddParam('inBoxCount', ftFloat, ptInput, execParamsMI.ParamByName('BoxCount').AsFloat);
       Params.AddParam('inBoxCode', ftInteger, ptInput, execParamsMI.ParamByName('BoxCode').AsInteger);
       Params.AddParam('inPartionGoods', ftString, ptInput, execParamsMI.ParamByName('PartionGoods').AsString);
       Params.AddParam('inPriceListId', ftInteger, ptInput, execParamsMovement.ParamByName('PriceListId').AsInteger);
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       Params.AddParam('inMovementId_Promo', ftInteger, ptInput, execParamsMI.ParamByName('MovementId_Promo').AsInteger);
       Params.AddParam('inReasonId', ftInteger, ptInput, ParamsReason.ParamByName('ReasonId').AsInteger);
       Params.AddParam('inAssetId', ftInteger, ptInput, execParamsMovement.ParamByName('AssetId').AsInteger);
       Params.AddParam('inIsReason', ftBoolean, ptInput, SettingMain.isReason);
       Params.AddParam('inIsAsset', ftBoolean, ptInput, execParamsMovement.ParamByName('isAsset').AsBoolean);
       Params.AddParam('inIsBarCode', ftBoolean, ptInput, execParamsMI.ParamByName('isBarCode').AsBoolean);

       Params.AddParam('inIsAmountPartnerSecond', ftBoolean, ptInput, execParamsMI.ParamByName('isAmountPartnerSecond').AsBoolean);
       Params.AddParam('inIsPriceWithVAT', ftBoolean, ptInput, execParamsMI.ParamByName('isPriceWithVAT').AsBoolean);
       Params.AddParam('inOperDate_ReturnOut', ftDateTime, ptInput, execParamsMI.ParamByName('OperDate_ReturnOut').AsDateTime);
       Params.AddParam('inPricePartner', ftFloat, ptInput, execParamsMI.ParamByName('PricePartner').AsFloat);
       Params.AddParam('inPriceIncome', ftFloat, ptInput, execParamsMI.ParamByName('PriceIncome').AsFloat);
       Params.AddParam('inAmountPartnerSecond', ftFloat, ptInput, execParamsMI.ParamByName('AmountPartnerSecond').AsFloat);
       Params.AddParam('inSummPartner', ftFloat, ptInput, execParamsMI.ParamByName('SummPartner').AsFloat);
       Params.AddParam('inIsDocPartner', ftBoolean, ptInput, ParamsMovement.ParamByName('isDocPartner').AsBoolean);

       Params.AddParam('inIP', ftString, ptInput, SettingMain.IP_str);

       //try
         Execute;

         execParamsMI.ParamByName('MovementItemId').AsInteger:=DataSet.FieldByName('Id').AsInteger;
         execParamsMovement.ParamByName('TotalSumm').AsFloat:=DataSet.FieldByName('TotalSumm').AsFloat;
         execParamsMovement.ParamByName('TotalSummPartner').AsFloat:=DataSet.FieldByName('TotalSummPartner').AsFloat;
         execParamsMovement.ParamByName('MessageText').AsString:=DataSet.FieldByName('MessageText').AsString;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpInsert_Scale_MI');
       end;}
    end;

end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_MI_Erased(MovementItemId:Integer;NewValue: Boolean): Boolean;
begin
    Result:= false;
    //
    with spSelect do begin
       StoredProcName:='gpUpdate_Scale_MI_Erased';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inMovementItemId', ftInteger, ptInput, MovementItemId);
       Params.AddParam('inIsModeSorting', ftBoolean, ptInput, FALSE);
       Params.AddParam('inIsErased', ftBoolean, ptInput, NewValue);
       //try
         Execute;
         ParamsMovement.ParamByName('TotalSumm').AsFloat:=DataSet.FieldByName('TotalSumm').AsFloat;
         ParamsMovement.ParamByName('TotalSummPartner').AsFloat:=DataSet.FieldByName('TotalSummPartner').AsFloat;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpUpdate_Scale_MI_Erased');
       end;}
    end;

end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(inBranchCode:Integer;inLevelChild: String): TArrayList;
var i: integer;
begin
    with spSelect do
    begin
       StoredProcName:='gpSelect_Object_ToolsWeighing_onLevelChild';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inIsCeh', ftBoolean, ptInput, SettingMain.isCeh);
       Params.AddParam('inBranchCode', ftInteger, ptInput, inBranchCode);
       Params.AddParam('inLevelChild', ftString, ptInput, inLevelChild);
       //try
         Execute;
         DataSet.First;
         SetLength(Result, DataSet.RecordCount);
         for i:= 0 to DataSet.RecordCount-1 do
         begin
          Result[i].Number := DataSet.FieldByName('Number').asInteger;
          Result[i].Id     := DataSet.FieldByName('Id').asInteger;
          Result[i].Code   := DataSet.FieldByName('Code').asInteger;
          Result[i].Name   := DataSet.FieldByName('Name').asString;
          Result[i].Value  := DataSet.FieldByName('Value').asString;
          DataSet.Next;
         end;
       {except
         SetLength(Result, 0);
         ShowMessage('Ошибка получения - gpSelect_ToolsWeighing_onLevelChild');
       end;}
    end;
    //
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_User:String;
begin
    with spSelect do begin
       StoredProcName:='gpGet_Scale_User';
       OutputType:=otDataSet;
       Params.Clear;
       //try
         Execute;
         Result := DataSet.FieldByName('UserName').asString;
         //
         UserId_begin := DataSet.FieldByName('UserId').asInteger;
         UserName_begin := DataSet.FieldByName('UserName').asString;

       {except
         Result := '';
         ShowMessage('Ошибка получения - gpGet_Scale_User');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_ToolsWeighing_Value(inLevel1,inLevel2,inLevel3,inItemName,inDefaultValue:String):String;
begin
    with spSelect do begin
       StoredProcName:='gpGet_ToolsWeighing_Value';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inLevel1', ftString, ptInput, inLevel1);
       Params.AddParam('inLevel2', ftString, ptInput, inLevel2);
       Params.AddParam('inLevel3', ftString, ptInput, inLevel3);
       Params.AddParam('inItemName', ftString, ptInput, inItemName);
       Params.AddParam('inDefaultValue', ftString, ptInput, inDefaultValue);
       //try
         Execute;
         Result := DataSet.FieldByName('Value').asString;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpGet_ToolsWeighing_Value');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpSelect_Scale_GoodsKindWeighing: TArrayList;
var i: integer;
begin
    with spSelect do
    begin
       StoredProcName:='gpSelect_Scale_GoodsKindWeighing';
       OutputType:=otDataSet;
       Params.Clear;
       //try
         Execute;
         DataSet.First;
         SetLength(Result, DataSet.RecordCount);
         for i:= 0 to DataSet.RecordCount-1 do
         begin
          Result[i].Number := DataSet.FieldByName('GroupId').asInteger;
          Result[i].Id     := DataSet.FieldByName('GoodsKindId').asInteger;
          Result[i].Code   := DataSet.FieldByName('GoodsKindCode').asInteger;
          Result[i].Name   := DataSet.FieldByName('GoodsKindName').asString;
          Result[i].Value  := '';
          DataSet.Next;
         end;
       {except
         SetLength(Result, 0);
         ShowMessage('Ошибка получения - gpSelect_Scale_GoodsKindWeighing');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpSelect_Object_Language: TArrayList;
var i: integer;
begin
    with spSelect do
    begin
       StoredProcName:='gpSelect_Object_Language';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inShowAll', ftBoolean, ptInput, FALSE);
       //try
         Execute;
         DataSet.First;
         SetLength(Result, DataSet.RecordCount);
         for i:= 0 to DataSet.RecordCount-1 do
         begin
          Result[i].Id     := DataSet.FieldByName('Id').asInteger;
          Result[i].Code   := DataSet.FieldByName('Code').asInteger;
          Result[i].Name   := DataSet.FieldByName('Name').asString;
          Result[i].Value  := '';
          DataSet.Next;
         end;
       {except
         SetLength(Result, 0);
         ShowMessage('Ошибка получения - gpSelect_Object_Language');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpSelect_Scale_StickerFile (inBranchCode : Integer): TArrayStickerFileList;
var i: integer;
    tmpStringStream : TStringStream;
    tmpStringStream_70_70 : TStringStream;
begin
    with spSelect do
    begin
       StoredProcName:='gpSelect_Scale_StickerFile';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inBranchCode', ftInteger, ptInput, inBranchCode);
       //try
         Execute;
         DataSet.First;
         SetLength(Result, DataSet.RecordCount);
         for i:= 0 to DataSet.RecordCount-1 do
         begin
          Result[i].Id       := DataSet.FieldByName('Id').asInteger;
          Result[i].Code     := DataSet.FieldByName('Code').asInteger;
          //
          Result[i].FileName := DataSet.FieldByName('FileName').asString;
          //
          tmpStringStream:= TStringStream.Create;
          tmpStringStream.WriteString (ReConvertConvert(DataSet.FieldByName('FileValue').asString));
          if tmpStringStream.Size = 0 then
             raise Exception.Create('Форма "' + DataSet.FieldByName('FileName').asString + '" не загружена из базы данных');

          tmpStringStream.Position := 0;
          Result[i].Report:= tmpStringStream;

          // для 70x70
          Result[i].FileName_70_70 := DataSet.FieldByName('FileName_70_70').asString;
          //
          if DataSet.FieldByName('FileName_70_70').asString <> '' then
          begin
              tmpStringStream_70_70:= TStringStream.Create;
              tmpStringStream_70_70.WriteString (ReConvertConvert(DataSet.FieldByName('FileValue_70_70').asString));
              if tmpStringStream_70_70.Size = 0 then
                 raise Exception.Create('Форма "' + DataSet.FieldByName('FileName').asString + '" не загружена из базы данных для 70x70');

              tmpStringStream_70_70.Position := 0;
              Result[i].Report_70_70:= tmpStringStream_70_70;
          end;


          DataSet.Next;
         end;
       {except
         SetLength(Result, 0);
         ShowMessage('Ошибка получения - gpSelect_Scale_GoodsKindWeighing');
       end;}
    end;
    //
 {   ShowMessage('start');
    //
    for i := 0 to Length(Result)-1 do
    begin
        tmpStream:= TStream.Create;
        tmpStringStream:= TStringStream.Create;

        Application.ProcessMessages;
        tmpStream:= TdsdFormStorageFactory.GetStorage.LoadReport(Result[i].FileName);
        Application.ProcessMessages;
        Sleep(100);
        Application.ProcessMessages;

        tmpStream.Position := 0;
        tmpStringStream.CopyFrom(tmpStream, tmpStream.Size);

        tmpStringStream.Position := 0;

        Result[i].Report:= tmpStringStream;
    end;
    ShowMessage('ok');}
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpSelect_Scale_StickerPack: TArrayList;
var i: integer;
begin
    with spSelect do
    begin
       StoredProcName:='gpSelect_Scale_StickerPack';
       OutputType:=otDataSet;
       Params.Clear;
       //try
         Execute;
         DataSet.First;
         SetLength(Result, DataSet.RecordCount);
         for i:= 0 to DataSet.RecordCount-1 do
         begin
          Result[i].Number := DataSet.FieldByName('GroupId').asInteger;
          Result[i].Id     := DataSet.FieldByName('StickerPackId').asInteger;
          Result[i].Code   := DataSet.FieldByName('StickerPackCode').asInteger;
          Result[i].Name   := DataSet.FieldByName('StickerPackName').asString;
          Result[i].Value  := '';
          DataSet.Next;
         end;
       {except
         SetLength(Result, 0);
         ShowMessage('Ошибка получения - gpSelect_Scale_GoodsKindWeighing');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_Goods(var execParams:TParams;inBarCode:String): Boolean;
begin
    if (trim (inBarCode) = '') or (trim (inBarCode) = '0') then
    begin
         Result:=false;
         exit
    end;
    //
    with spSelect do
    begin
       //в ШК - Id товара или Id товар+вид товара или для isCeh код GoodsCode
       StoredProcName:='gpGet_Scale_Goods';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inIsGoodsComplete', ftBoolean, ptInput, SettingMain.isGoodsComplete);
       Params.AddParam('inBarCode', ftString, ptInput, inBarCode);
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       //try
         Execute;
         //
         Result:=DataSet.RecordCount<>0;
       with execParams do
       begin
         ParamByName('GoodsId').AsInteger  := DataSet.FieldByName('GoodsId').AsInteger;
         ParamByName('GoodsCode').AsInteger:= DataSet.FieldByName('GoodsCode').AsInteger;
         ParamByName('GoodsName').asString := DataSet.FieldByName('GoodsName').asString;

         if SettingMain.isCeh = FALSE then
         begin
              // только для программы Scale
              ParamByName('GoodsKindId').AsInteger  := DataSet.FieldByName('GoodsKindId').asInteger;
              ParamByName('GoodsKindCode').AsInteger:= DataSet.FieldByName('GoodsKindCode').AsInteger;
              ParamByName('GoodsKindName').asString := DataSet.FieldByName('GoodsKindName').asString;
              //
              ParamByName('Amount_Goods').asFloat   := DataSet.FieldByName('Amount').asFloat;
              if ParamByName('Amount_Goods').asFloat > 0 then
              begin
                   ParamByName('Price').AsFloat        := DataSet.FieldByName('Price').AsFloat;
                   ParamByName('CountForPrice').AsFloat:= DataSet.FieldByName('CountForPrice').AsFloat;
              end;
         end
         else
         begin
              // только для программы ScaleCeh
              ParamByName('MeasureId').AsInteger  := DataSet.FieldByName('MeasureId').asInteger;
              ParamByName('MeasureCode').AsInteger:= DataSet.FieldByName('MeasureCode').AsInteger;
              ParamByName('MeasureName').asString := DataSet.FieldByName('MeasureName').asString;
         end;

       end;
       {except
         result.Code := Code;
         result.Id   := 0;
         result.Name := '';
         ShowMessage('Ошибка получения - gpGet_Scale_Goods');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_Goods_gk(var execParams:TParams): Boolean;
begin
    with spSelect do
    begin
       StoredProcName:='gpGet_Scale_Goods_gk';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inGoodsId', ftInteger, ptInput, execParams.ParamByName('GoodsId').AsInteger);
       Params.AddParam('inGoodsKindId', ftInteger, ptInput, execParams.ParamByName('GoodsKindId').AsInteger);
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       //try
         Execute;
         //
         Result:=DataSet.RecordCount<>0;
         if not Result then
         begin
              ShowMessage('Ошибка.'+#10+#13+'Данные для GoodsId = <'+execParams.ParamByName('GoodsId').AsString+'> + GoodsKindId = <'+execParams.ParamByName('GoodsKindId').AsString+'> не определены.');
              exit;
         end;
       with execParams do
       begin
         ParamByName('NamePack').AsString    := DataSet.FieldByName('GoodsKindName').AsString;
         // Вес шт. товара
         ParamByName('Weight_gd').AsFloat    := DataSet.FieldByName('Weight_gd').asFloat;
         // Вес 1-ой упаковки
         ParamByName('WeightPack_gd').AsFloat:= DataSet.FieldByName('WeightTare_gd').asFloat;
         // Вес 1-ой упаковки - Флоупак +  Нар.180 + Нар. 200
         if ParamByName('NamePack').AsString <> ''
         then ParamByName('WeightPack').AsFloat:= DataSet.FieldByName('WeightTare_gd').asFloat
         else ParamByName('WeightPack').AsFloat:= 0;
       end;

    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_GoodsRetail(var execParamsMovement:TParams;var execParams:TParams;inBarCode:String): Boolean;
begin
    with spSelect do
    begin
       //в ШК - закодированый товар + кол-во, т.е. для Retail
       StoredProcName:='gpGet_Scale_GoodsRetail';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inBarCode', ftString, ptInput, inBarCode);
       Params.AddParam('inGoodsPropertyId', ftInteger, ptInput, execParamsMovement.ParamByName('GoodsPropertyId').AsInteger);
       Params.AddParam('inOperDate', ftDateTime, ptInput, execParamsMovement.ParamByName('OperDate').AsDateTime);
       Params.AddParam('inOrderExternalId', ftInteger, ptInput, execParamsMovement.ParamByName('OrderExternalId').AsInteger);
       Params.AddParam('inPriceListId', ftInteger, ptInput, execParamsMovement.ParamByName('PriceListId').AsInteger);
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       //try
         Execute;
         //
         Result:=DataSet.RecordCount<>0;
         if not Result then
         begin
              ShowMessage('Ошибка.'+#10+#13+'Данные для <'+execParamsMovement.ParamByName('GoodsPropertyName').AsString+'> по штих коду <'+inBarCode+'> не определены.');
              exit;
         end;

       with execParams do
       begin
         ParamByName('GoodsId').AsInteger  := DataSet.FieldByName('GoodsId').AsInteger;
         //ParamByName('GoodsCode').AsInteger:= DataSet.FieldByName('GoodsCode').AsInteger;
         //ParamByName('GoodsName').asString := DataSet.FieldByName('GoodsName').asString;

         ParamByName('GoodsKindId').AsInteger  := DataSet.FieldByName('GoodsKindId').asInteger;
         //ParamByName('GoodsKindCode').AsInteger:= DataSet.FieldByName('GoodsKindCode').AsInteger;
         //ParamByName('GoodsKindName').asString := DataSet.FieldByName('GoodsKindName').asString;

         //Params.AddParam('inMovementId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementId').AsInteger);
         ParamByName('RealWeight').AsFloat          := DataSet.FieldByName('RealWeight').AsFloat;
         ParamByName('ChangePercentAmount').AsFloat := DataSet.FieldByName('ChangePercentAmount').AsFloat;
         ParamByName('CountTare').AsFloat           := DataSet.FieldByName('CountTare').AsFloat;
         ParamByName('WeightTare').AsFloat          := DataSet.FieldByName('WeightTare').AsFloat;
         ParamByName('Price').AsFloat               := DataSet.FieldByName('Price').AsFloat;
         ParamByName('Price_Return').AsFloat        := DataSet.FieldByName('Price_Return').AsFloat;
         ParamByName('CountForPrice').AsFloat       := DataSet.FieldByName('CountForPrice').AsFloat;
         ParamByName('CountForPrice_Return').AsFloat:= DataSet.FieldByName('CountForPrice_Return').AsFloat;
         ParamByName('isBarCode').AsBoolean         := TRUE;

         ParamByName('MovementId_Promo').AsInteger  := DataSet.FieldByName('MovementId_Promo').AsInteger;
         //Params.AddParam('inDayPrior_PriceReturn', ftInteger, ptInput, StrToInt(GetArrayList_Value_byName(Default_Array,'DayPrior_PriceReturn')));
         //Params.AddParam('inPriceListId', ftInteger, ptInput, execParamsMovement.ParamByName('PriceListId').AsInteger);

       end;

       {except
         result.Code := Code;
         result.Id   := 0;
         result.Name := '';
         ShowMessage('Ошибка получения - gpGet_Scale_GoodsRetail');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_Partner(var execParams:TParams;inPartnerCode:Integer): Boolean;
begin
    with spSelect do
    begin
       StoredProcName:='gpGet_Scale_Partner';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inOperDate', ftDateTime, ptInput, execParams.ParamByName('OperDate').AsDateTime);
       Params.AddParam('inMovementDescId', ftInteger, ptInput, execParams.ParamByName('MovementDescId').AsInteger);
       Params.AddParam('inPartnerCode', ftInteger, ptInput, inPartnerCode);
       Params.AddParam('inInfoMoneyId', ftInteger, ptInput, execParams.ParamByName('InfoMoneyId').AsInteger);
       Params.AddParam('inPaidKindId', ftInteger, ptInput, execParams.ParamByName('PaidKindId').AsInteger);
       //try
         Execute;
         //
         Result:=DataSet.RecordCount<>0;
       with execParams do
       begin
         ParamByName('isGetPartner').AsBoolean:= true;
         ParamByName('calcPartnerId').AsInteger:= DataSet.FieldByName('PartnerId').AsInteger;
         ParamByName('calcPartnerCode').AsInteger:= DataSet.FieldByName('PartnerCode').AsInteger;
         ParamByName('calcPartnerName').asString:= DataSet.FieldByName('PartnerName').asString;
         ParamByName('ChangePercent').asFloat:= DataSet.FieldByName('ChangePercent').asFloat;
         ParamByName('ChangePercentAmount').asFloat:= DataSet.FieldByName('ChangePercentAmount').asFloat;

         ParamByName('isEdiOrdspr').asBoolean:= DataSet.FieldByName('isEdiOrdspr').asBoolean;
         ParamByName('isEdiInvoice').asBoolean:= DataSet.FieldByName('isEdiInvoice').asBoolean;
         ParamByName('isEdiDesadv').asBoolean:= DataSet.FieldByName('isEdiDesadv').asBoolean;

         ParamByName('isMovement').asBoolean:= DataSet.FieldByName('isMovement').asBoolean;
         ParamByName('isAccount').asBoolean:= DataSet.FieldByName('isAccount').asBoolean;
         ParamByName('isTransport').asBoolean:= DataSet.FieldByName('isTransport').asBoolean;
         ParamByName('isQuality').asBoolean:= DataSet.FieldByName('isQuality').asBoolean;
         ParamByName('isPack').asBoolean:= DataSet.FieldByName('isPack').asBoolean;
         ParamByName('isSpec').asBoolean:= DataSet.FieldByName('isSpec').asBoolean;
         ParamByName('isTax').asBoolean:= DataSet.FieldByName('isTax').asBoolean;

         ParamByName('CountMovement').asInteger:= DataSet.FieldByName('CountMovement').asInteger;
         ParamByName('CountAccount').asInteger:= DataSet.FieldByName('CountAccount').asInteger;
         ParamByName('CountTransport').asInteger:= DataSet.FieldByName('CountTransport').asInteger;
         ParamByName('CountQuality').asInteger:= DataSet.FieldByName('CountQuality').asInteger;
         ParamByName('CountPack').asInteger:= DataSet.FieldByName('CountPack').asInteger;
         ParamByName('CountSpec').asInteger:= DataSet.FieldByName('CountSpec').asInteger;
         ParamByName('CountTax').asInteger:= DataSet.FieldByName('CountTax').asInteger;

         ParamByName('PaidKindId').AsInteger:= DataSet.FieldByName('PaidKindId').asInteger;
         ParamByName('PaidKindName').asString:= DataSet.FieldByName('PaidKindName').asString;

         if DataSet.RecordCount=1 then
         begin ParamByName('ContractId').AsInteger    := DataSet.FieldByName('ContractId').asInteger;
               ParamByName('ContractCode').AsInteger  := DataSet.FieldByName('ContractCode').asInteger;
               ParamByName('ContractNumber').asString := DataSet.FieldByName('ContractNumber').asString;
               ParamByName('ContractTagName').asString:= DataSet.FieldByName('ContractTagName').asString;
         end
         else begin ParamByName('ContractId').AsInteger    := 0;
                    ParamByName('ContractCode').AsInteger  := 0;
                    ParamByName('ContractNumber').asString := '';
                    ParamByName('ContractTagName').asString:= '';
         end;

         ParamByName('GoodsPropertyId').AsInteger:= DataSet.FieldByName('GoodsPropertyId').AsInteger;
         ParamByName('GoodsPropertyCode').AsInteger:= DataSet.FieldByName('GoodsPropertyCode').AsInteger;
         ParamByName('GoodsPropertyName').asString:= DataSet.FieldByName('GoodsPropertyName').asString;

         ParamByName('PriceListId').AsInteger   := DataSet.FieldByName('PriceListId').asInteger;
         ParamByName('PriceListCode').AsInteger := DataSet.FieldByName('PriceListCode').asInteger;
         ParamByName('PriceListName').asString  := DataSet.FieldByName('PriceListName').asString;
       end;

       {except
         result.Code := Code;
         result.Id   := 0;
         result.Name := '';
         ShowMessage('Ошибка получения - gpGet_Scale_Partner');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_PartnerParams(var execParams:TParams): Boolean;
begin
    //для этих MovementDescId не надо определять доп.параметры, поэтому возвращается true, что б закрыть справочник
    {if  (execParams.ParamByName('MovementDescId').AsInteger = zc_Movement_Loss)
      or(execParams.ParamByName('MovementDescId').AsInteger = zc_Movement_SendOnPrice)
    then begin
              Result:=true;
              exit
    end;}

    with spSelect do
    begin
       StoredProcName:='gpGet_Scale_PartnerParams';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inOperDate', ftDateTime, ptInput, execParams.ParamByName('OperDate').AsDateTime);
       Params.AddParam('inMovementDescId', ftInteger, ptInput, execParams.ParamByName('MovementDescId').AsInteger);
       Params.AddParam('inPartnerId', ftInteger, ptInput, execParams.ParamByName('calcPartnerId').AsInteger);
       Params.AddParam('inContractId', ftInteger, ptInput, execParams.ParamByName('ContractId').AsInteger);
       //try
         Execute;
         //
         Result:=DataSet.RecordCount=1;

       with execParams do
       begin
         if Result then
         begin ParamByName('GoodsPropertyId').AsInteger:= DataSet.FieldByName('GoodsPropertyId').AsInteger;
               ParamByName('GoodsPropertyCode').AsInteger:= DataSet.FieldByName('GoodsPropertyCode').AsInteger;
               ParamByName('GoodsPropertyName').asString:= DataSet.FieldByName('GoodsPropertyName').asString;

               ParamByName('PriceListId').AsInteger   := DataSet.FieldByName('PriceListId').asInteger;
               ParamByName('PriceListCode').AsInteger := DataSet.FieldByName('PriceListCode').asInteger;
               ParamByName('PriceListName').asString  := DataSet.FieldByName('PriceListName').asString;

               ParamByName('isContractGoods').AsBoolean:= DataSet.FieldByName('isContractGoods').AsBoolean;
         end
         else ShowMessage('Ошибка.Параметры не определены.<gpGet_Scale_PartnerParams>');

       end;

       {except
         result.Code := Code;
         result.Id   := 0;
         result.Name := '';
         ShowMessage('Ошибка получения - gpGet_Scale_PartnerParams');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_PSW_delete (inPSW: String): String;
begin
    with spSelect do
    begin
       StoredProcName:='gpGet_Scale_PSW_delete';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inPSW', ftString, ptInput, inPSW);
       //try
       Execute;
       //
       Result:=DataSet.FieldByName('PSW').asString;
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_Personal(var execParams:TParams;inPersonalCode:Integer): Boolean;
begin
    with spSelect do
    begin
       StoredProcName:='gpGet_Scale_Personal';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inPersonalCode', ftInteger, ptInput, inPersonalCode);
       Params.AddParam('inOperDate', ftDateTime, ptInput, ParamsMovement.ParamByName('OperDate').AsDateTime);
       //try
         Execute;
         //
         Result:=DataSet.RecordCount=1;

       with execParams
       do
         if Result then
         begin ParamByName('PersonalId').AsInteger:= DataSet.FieldByName('PersonalId').AsInteger;
               ParamByName('PersonalCode').AsInteger:= DataSet.FieldByName('PersonalCode').AsInteger;
               ParamByName('PersonalName').asString:= DataSet.FieldByName('PersonalName').asString;

               ParamByName('PositionId').AsInteger   := DataSet.FieldByName('PositionId').asInteger;
               ParamByName('PositionCode').AsInteger := DataSet.FieldByName('PositionCode').asInteger;
               ParamByName('PositionName').asString  := DataSet.FieldByName('PositionName').asString;
         end
         else // вот так "хитро" вернули кол-во записей для "нормального" сообщения
              ParamByName('PersonalId').AsInteger:= -1 * DataSet.RecordCount;

       {except
         result.Code := Code;
         result.Id   := 0;
         result.Name := '';
         ShowMessage('Ошибка получения - gpGet_Scale_Personal');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_OrderExternal(var execParams:TParams;inBarCode: String; inFromId_calc , inToId_calc: Integer): Boolean;
var MovementDescId_old:Integer;
begin
    with spSelect do
    begin
       StoredProcName:='gpGet_Scale_OrderExternal';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inIsCeh', ftBoolean, ptInput, SettingMain.isCeh);
       Params.AddParam('inOperDate', ftDateTime, ptInput, execParams.ParamByName('OperDate').AsDateTime);
       Params.AddParam('inFromId',ftInteger, ptInput, inFromId_calc);
       Params.AddParam('inToId',ftInteger, ptInput, inToId_calc);
       Params.AddParam('inBranchCode',ftInteger, ptInput, SettingMain.BranchCode);
       Params.AddParam('inBarCode', ftString, ptInput, inBarCode);
       //try
         Execute;
         //
         Result:=DataSet.RecordCount=1;
       with execParams do
       begin
         MovementDescId_old:=ParamByName('MovementDescId').AsInteger;
         //
         ParamByName('MovementId_get').AsInteger:= DataSet.FieldByName('MovementId_get').asInteger;//документ взвешивания !!!только для заявки!!!, потом переносится в MovementId
         ParamByName('MovementDescId').AsInteger:= DataSet.FieldByName('MovementDescId').asInteger;
         if (MovementDescId_old <> DataSet.FieldByName('MovementDescId').asInteger) or (ParamByName('FromId').AsInteger = 0) then
         begin
              ParamByName('FromId').AsInteger:= DataSet.FieldByName('ToId').asInteger;
              ParamByName('FromCode').AsInteger:= DataSet.FieldByName('ToCode').asInteger;
              ParamByName('FromName').asString:= DataSet.FieldByName('ToName').asString;
         end;
         ParamByName('ToId').AsInteger:= DataSet.FieldByName('FromId').asInteger;
         ParamByName('ToCode').AsInteger:= DataSet.FieldByName('FromCode').asInteger;
         ParamByName('ToName').asString:= DataSet.FieldByName('FromName').asString;
         ParamByName('PaidKindId').AsInteger:= DataSet.FieldByName('PaidKindId').asInteger;
         ParamByName('PaidKindName').asString:= DataSet.FieldByName('PaidKindName').asString;

         //определяется только для zc_Movement_SendOnPrice + zc_Movement_Loss + zc_Movement_Income
         if  (DataSet.FieldByName('MovementDescId').asInteger = zc_Movement_SendOnPrice)
           or(DataSet.FieldByName('MovementDescId').asInteger = zc_Movement_Loss)
           or(DataSet.FieldByName('MovementDescId').asInteger = zc_Movement_Income)
           or(DataSet.FieldByName('MovementDescId').asInteger = zc_Movement_Send)
           or(DataSet.FieldByName('MovementDescId').asInteger = zc_Movement_ReturnIn)
         then ParamByName('MovementDescNumber').AsInteger:= DataSet.FieldByName('MovementDescNumber').asInteger;

         ParamByName('calcPartnerId').AsInteger:= DataSet.FieldByName('PartnerId_calc').AsInteger;
         ParamByName('calcPartnerCode').AsInteger:= DataSet.FieldByName('PartnerCode_calc').AsInteger;
         ParamByName('calcPartnerName').asString:= DataSet.FieldByName('PartnerName_calc').asString;
         ParamByName('ChangePercent').asFloat:= DataSet.FieldByName('ChangePercent').asFloat;
         ParamByName('ChangePercentAmount').asFloat:= DataSet.FieldByName('ChangePercentAmount').asFloat;

         ParamByName('isEdiOrdspr').asBoolean:= DataSet.FieldByName('isEdiOrdspr').asBoolean;
         ParamByName('isEdiInvoice').asBoolean:= DataSet.FieldByName('isEdiInvoice').asBoolean;
         ParamByName('isEdiDesadv').asBoolean:= DataSet.FieldByName('isEdiDesadv').asBoolean;

         ParamByName('isMovement').asBoolean:= DataSet.FieldByName('isMovement').asBoolean;
         ParamByName('isAccount').asBoolean:= DataSet.FieldByName('isAccount').asBoolean;
         ParamByName('isTransport').asBoolean:= DataSet.FieldByName('isTransport').asBoolean;
         ParamByName('isQuality').asBoolean:= DataSet.FieldByName('isQuality').asBoolean;
         ParamByName('isPack').asBoolean:= DataSet.FieldByName('isPack').asBoolean;
         ParamByName('isSpec').asBoolean:= DataSet.FieldByName('isSpec').asBoolean;
         ParamByName('isTax').asBoolean:= DataSet.FieldByName('isTax').asBoolean;

         ParamByName('OrderExternalId').AsInteger:= DataSet.FieldByName('MovementId').asInteger;
         ParamByName('OrderExternal_DescId').AsInteger:= DataSet.FieldByName('MovementDescId_order').asInteger;
         ParamByName('OrderExternal_BarCode').asString:= DataSet.FieldByName('BarCode').asString;
         ParamByName('OrderExternal_InvNumber').asString:= DataSet.FieldByName('InvNumber').asString;
         ParamByName('OrderExternalName_master').asString:= DataSet.FieldByName('OrderExternalName_master').asString;

         ParamByName('ContractId').AsInteger    := DataSet.FieldByName('ContractId').asInteger;
         ParamByName('ContractCode').AsInteger  := DataSet.FieldByName('ContractCode').asInteger;
         ParamByName('ContractNumber').asString := DataSet.FieldByName('ContractNumber').asString;
         ParamByName('ContractTagName').asString:= DataSet.FieldByName('ContractTagName').asString;

         ParamByName('GoodsPropertyId').AsInteger:= DataSet.FieldByName('GoodsPropertyId').AsInteger;
         ParamByName('GoodsPropertyCode').AsInteger:= DataSet.FieldByName('GoodsPropertyCode').AsInteger;
         ParamByName('GoodsPropertyName').asString:= DataSet.FieldByName('GoodsPropertyName').asString;

         ParamByName('PriceListId').AsInteger   := DataSet.FieldByName('PriceListId').asInteger;
         ParamByName('PriceListCode').AsInteger := DataSet.FieldByName('PriceListCode').asInteger;
         ParamByName('PriceListName').asString  := DataSet.FieldByName('PriceListName').asString;

         ParamByName('isContractGoods').AsBoolean:= DataSet.FieldByName('isContractGoods').AsBoolean;

       end;


       {except
         result.Code := Code;
         result.Id   := 0;
         result.Name := '';
         ShowMessage('Ошибка получения - gpGet_Scale_OrderExternal');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_Transport(var execParams:TParams;inBarCode: String): Boolean;
begin
    if trim (inBarCode) = ''
    then with execParams do
         begin
               ParamByName('TransportId').AsInteger        := 0;
               ParamByName('Transport_BarCode').asString   := '';
               ParamByName('Transport_InvNumber').asString := '';
               ParamByName('PersonalDriverId').AsInteger   := 0;
               ParamByName('PersonalDriverName').asString  := '';
               ParamByName('CarName').asString             := '';
               ParamByName('RouteName').asString           := '';
         end
    else
    with spSelect do
    begin
       StoredProcName:='gpGet_Scale_Transport';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inOperDate', ftDateTime, ptInput, execParams.ParamByName('OperDate').AsDateTime);
       Params.AddParam('inBranchCode',ftInteger, ptInput, SettingMain.BranchCode);
       Params.AddParam('inBarCode', ftString, ptInput, inBarCode);
       Params.AddParam('inMovementId_order',ftInteger, ptInput, execParams.ParamByName('OrderExternalId').AsInteger);
       //try
         Execute;
         //
         Result:=DataSet.RecordCount=1;

       with execParams do
       begin
         ParamByName('TransportId').AsInteger        := DataSet.FieldByName('MovementId').asInteger;
         ParamByName('Transport_BarCode').asString   := DataSet.FieldByName('BarCode').asString;
         ParamByName('Transport_InvNumber').asString := DataSet.FieldByName('InvNumber').asString;
         ParamByName('PersonalDriverId').AsInteger   := DataSet.FieldByName('PersonalDriverId').asInteger;
         ParamByName('PersonalDriverName').asString  := DataSet.FieldByName('PersonalDriverName').asString;
         ParamByName('CarName').asString             := DataSet.FieldByName('CarName').asString;
         ParamByName('RouteName').asString           := DataSet.FieldByName('RouteName').asString;
       end;
       {except
         result.Code := Code;
         result.Id   := 0;
         result.Name := '';
         ShowMessage('Ошибка получения - gpGet_Scale_Transport');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_OperDate(var execParams:TParams):TDateTime;
begin
    with DMMainScaleForm.spSelect do
    begin
       StoredProcName:='gpGet_Scale_OperDate';
       OutputType:=otDataSet;
       Params.Clear;
       //try
         Params.AddParam('inIsCeh', ftBoolean, ptInput, SettingMain.isCeh);
         Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
         Execute;
         //
         Result:=DataSet.FieldByName('OperDate').asDateTime;
         execParams.ParamByName('OperDate').AsDateTime:=DataSet.FieldByName('OperDate').asDateTime;

       {except
         result.Code := Code;
         result.Id   := 0;
         result.Name := '';
         ShowMessage('Ошибка получения - gpGet_Scale_OperDate');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.lpGet_BranchName(inBranchCode:Integer): String;
begin
    with spSelect do
    begin
       StoredProcName:='gpExecSql_Value';
       OutputType:=otDataSet;
       Params.Clear;
       if inBranchCode > 1000
       then Params.AddParam('inSqlText', ftString, ptInput, 'SELECT Object.ValueData FROM Object WHERE Object.Id = COALESCE((SELECT Object_Branch.Id FROM Object AS Object_Branch WHERE Object_Branch.ObjectCode = '+ IntToStr(inBranchCode - 1000) + ' AND Object_Branch.DescId = zc_Object_Branch()), 0)' )
       else Params.AddParam('inSqlText', ftString, ptInput, 'SELECT Object.ValueData FROM Object WHERE Object.Id = COALESCE((SELECT Object_Branch.Id FROM Object AS Object_Branch WHERE Object_Branch.ObjectCode = '+ IntToStr(inBranchCode) + ' AND Object_Branch.DescId = zc_Object_Branch()), zc_Branch_Basis())' );
       Execute;
       if inBranchCode > 1000
       then Result:='('+IntToStr(inBranchCode-1000)+')'+DataSet.FieldByName('Value').asString
       else if inBranchCode > 100
            then Result:='('+IntToStr(inBranchCode)+')'+DataSet.FieldByName('Value').asString
            else Result:='('+IntToStr(inBranchCode)+')'+DataSet.FieldByName('Value').asString;
    end;
end;
{------------------------------------------------------------------------}
function gpInitialize_Const: Boolean;
begin
    Result:=false;

    with DMMainScaleForm.spSelect do
    begin
       StoredProcName:='gpExecSql_Value';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inSqlText', ftString, ptInput, '');

       //try

         //MovementDesc
         Params.ParamByName('inSqlText').Value:='SELECT zc_Movement_Income() :: TVarChar';
         Execute;
         zc_Movement_Income:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Movement_ReturnOut() :: TVarChar';
         Execute;
         zc_Movement_ReturnOut:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Movement_Sale() :: TVarChar';
         Execute;
         zc_Movement_Sale:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Movement_ReturnIn() :: TVarChar';
         Execute;
         zc_Movement_ReturnIn:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Movement_Send() :: TVarChar';
         Execute;
         zc_Movement_Send:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Movement_SendOnPrice() :: TVarChar';
         Execute;
         zc_Movement_SendOnPrice:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Movement_Loss() :: TVarChar';
         Execute;
         zc_Movement_Loss:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Movement_Inventory() :: TVarChar';
         Execute;
         zc_Movement_Inventory:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Movement_ProductionUnion() :: TVarChar';
         Execute;
         zc_Movement_ProductionUnion:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Movement_ProductionSeparate() :: TVarChar';
         Execute;
         zc_Movement_ProductionSeparate:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Movement_OrderExternal() :: TVarChar';
         Execute;
         zc_Movement_OrderExternal:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Movement_OrderInternal() :: TVarChar';
         Execute;
         zc_Movement_OrderInternal:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Movement_OrderIncome() :: TVarChar';
         Execute;
         zc_Movement_OrderIncome:=DataSet.FieldByName('Value').asInteger;

         //Measure
         Params.ParamByName('inSqlText').Value:='SELECT zc_Measure_Sh() :: TVarChar';
         Execute;
         zc_Measure_Sh:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Measure_Kg() :: TVarChar';
         Execute;
         zc_Measure_Kg:=DataSet.FieldByName('Value').asInteger;

         //BarCodePref
         Params.ParamByName('inSqlText').Value:='SELECT zc_BarCodePref_Object() :: TVarChar';
         Execute;
         zc_BarCodePref_Object:=DataSet.FieldByName('Value').asString;

         Params.ParamByName('inSqlText').Value:='SELECT zc_BarCodePref_Movement() :: TVarChar';
         Execute;
         zc_BarCodePref_Movement:=DataSet.FieldByName('Value').asString;

         Params.ParamByName('inSqlText').Value:='SELECT zc_BarCodePref_MI() :: TVarChar';
         Execute;
         zc_BarCodePref_MI:=DataSet.FieldByName('Value').asString;

         // DocumentKind - Взвешивание п/ф факт куттера
         Params.ParamByName('inSqlText').Value:='SELECT zc_Enum_DocumentKind_CuterWeight() :: TVarChar';
         Execute;
         zc_Enum_DocumentKind_CuterWeight:=DataSet.FieldByName('Value').asInteger;
         // DocumentKind - Взвешивание п/ф факт сырой
         Params.ParamByName('inSqlText').Value:='SELECT zc_Enum_DocumentKind_RealWeight() :: TVarChar';
         Execute;
         zc_Enum_DocumentKind_RealWeight:=DataSet.FieldByName('Value').asInteger;
         // DocumentKind - взвешивание п/ф факт после шприцевания
         Params.ParamByName('inSqlText').Value:='SELECT zc_Enum_DocumentKind_RealDelicShp() :: TVarChar';
         Execute;
         zc_Enum_DocumentKind_RealDelicShp:=DataSet.FieldByName('Value').asInteger;
         // DocumentKind - взвешивание п/ф факт после массажера
         Params.ParamByName('inSqlText').Value:='SELECT zc_Enum_DocumentKind_RealDelicMsg() :: TVarChar';
         Execute;
         zc_Enum_DocumentKind_RealDelicMsg:=DataSet.FieldByName('Value').asInteger;

         // DocumentKind - перемещение на лакирование
         Params.ParamByName('inSqlText').Value:='SELECT zc_Enum_DocumentKind_LakTo() :: TVarChar';
         Execute;
         zc_Enum_DocumentKind_LakTo:=DataSet.FieldByName('Value').asInteger;
         // DocumentKind - перемещение с лакирования
         Params.ParamByName('inSqlText').Value:='SELECT zc_Enum_DocumentKind_LakFrom() :: TVarChar';
         Execute;
         zc_Enum_DocumentKind_LakFrom:=DataSet.FieldByName('Value').asInteger;

         // InfoMoney
         // 30201 Доходы + Мясное сырье + Мясное сырье
         Params.ParamByName('inSqlText').Value:='SELECT zc_Enum_InfoMoney_30201() :: TVarChar';
         Execute;
         zc_Enum_InfoMoney_30201:=DataSet.FieldByName('Value').asInteger;

         //ObjectDesc
         Params.ParamByName('inSqlText').Value:='SELECT zc_Object_Partner() :: TVarChar';
         Execute;
         zc_Object_Partner:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Object_ArticleLoss() :: TVarChar';
         Execute;
         zc_Object_ArticleLoss:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Object_Member() :: TVarChar';
         Execute;
         zc_Object_Member:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Object_Unit() :: TVarChar';
         Execute;
         zc_Object_Unit:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Object_Car() :: TVarChar';
         Execute;
         zc_Object_Car:=DataSet.FieldByName('Value').asInteger;


       {except
         result.Code := Code;
         result.Id   := 0;
         result.Name := '';
         ShowMessage('Ошибка получения - gpMovementDesc');
       end;}
    end;

    Result:=true;
end;
{------------------------------------------------------------------------}
function gpInitialize_Ini: Boolean;
var
  Ini: TInifile;
  ScaleList:TStringList;
  i:Integer;
  tmpValue:String;
begin
  Result:=false;

  //!!!захардкодили т.к. это программа Scale а в программе ScaleCeh он захардкожен как TRUE!!!
  SettingMain.isCeh:=FALSE;//AnsiUpperCase(ExtractFileName(ParamStr(0))) <> AnsiUpperCase('Scale.exe');

  //а теперь ини-файл
  if System.Pos(AnsiUpperCase('ini'),AnsiUpperCase(ParamStr(1)))>0
  then Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + ParamStr(1))
  else if System.Pos(AnsiUpperCase('ini'),AnsiUpperCase(ParamStr(2)))>0
       then Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + ParamStr(2))
       else if System.Pos(AnsiUpperCase('ini'),AnsiUpperCase(ParamStr(3)))>0
            then Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + ParamStr(3))
            else Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'scale.ini');

  //!!!отладака при запуске!!!
  gc_isDebugMode:=AnsiUpperCase(Ini.ReadString('Main','isDebugMode','FALSE')) = AnsiUpperCase('TRUE');

  //!!!временно!!!
  SettingMain.BranchCode:=Ini.ReadInteger('Main','BrancCode',1);
  if SettingMain.BranchCode<>1 then Ini.WriteInteger('Main','BranchCode',SettingMain.BranchCode);
  //
  SettingMain.BranchCode:=Ini.ReadInteger('Main','BranchCode',1);
  if SettingMain.BranchCode=1 then Ini.WriteInteger('Main','BranchCode',1);
  //
  //!!!определили ПОСЛЕ BranchCode!!! - Печать этикеток ли
  if SettingMain.BranchCode > 1000
  then SettingMain.isSticker:= TRUE
  else SettingMain.isSticker:= FALSE;
  //
  //
  SettingMain.DefaultCOMPort:=Ini.ReadInteger('Main','DefaultCOMPort',1);
  if SettingMain.DefaultCOMPort=1 then Ini.WriteInteger('Main','DefaultCOMPort',1);

  SettingMain.ScaleCount:=Ini.ReadInteger('Main','ScaleCount',1);
  if SettingMain.ScaleCount=1 then Ini.WriteInteger('Main','ScaleCount',1);

  ScaleList:=TStringList.Create;
  Ini.ReadSectionValues('Type_CommPort_Name',ScaleList);
  if ScaleList.Count=0 then
  begin
       for i:=1 to SettingMain.ScaleCount do
          Ini.WriteString('Type_CommPort_Name','Item'+IntToStr(i-1),' stDB : '  + IntToStr(i) + ' : ' + 'DB');
       Ini.ReadSectionValues('Type_CommPort_Name',ScaleList);
  end;

  SetLength(Scale_Array,SettingMain.ScaleCount);
  for i:= 0 to SettingMain.ScaleCount-1 do
  begin
       tmpValue:=ScaleList[i];

       Scale_Array[i].Number := i;
       Delete(tmpValue,1,Pos('=',tmpValue));
       Scale_Array[i].ScaleType := TScaleType(GetEnumValue(TypeInfo(TScaleType), trim(Copy(tmpValue,1,Pos(':',tmpValue)-1))));
       Delete(tmpValue,1,Pos(':',tmpValue));
       try Scale_Array[i].ComPort := StrToInt(trim(Copy(tmpValue,1,Pos(':',tmpValue)-1))) except Scale_Array[i].ComPort:=-1;end;
       Delete(tmpValue,1,Pos(':',tmpValue));
       Scale_Array[i].ScaleName := trim(tmpValue);
   end;

  Ini.Free;
  ScaleList.Free;

  Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpInitialize_SettingMain_Tare_115: Boolean;
begin
    Result:=false;
    with spSelect do begin
       StoredProcName:='gpSelect_Scale_Tare_115';
       OutputType:=otDataSet;
       Params.Clear;
       //try
         Execute;
         //
         DataSet.First;
         //
         while not DataSet.EOF do
         begin
              if DataSet.FieldByName('NPP').asInteger = 1 then
              begin
                  SettingMain.WeightTare1:=DataSet.FieldByName('Weight').asFloat;
                  SettingMain.NameTare1:=DataSet.FieldByName('GuideName').asString;
                  SettingMain.TareId_1:=DataSet.FieldByName('GuideId').asInteger;
              end;
              if DataSet.FieldByName('NPP').asInteger = 2 then
              begin
                  SettingMain.WeightTare2:=DataSet.FieldByName('Weight').asFloat;
                  SettingMain.NameTare2:=DataSet.FieldByName('GuideName').asString;
                  SettingMain.TareId_2:=DataSet.FieldByName('GuideId').asInteger;
              end;
              if DataSet.FieldByName('NPP').asInteger = 3 then
              begin
                  SettingMain.WeightTare3:=DataSet.FieldByName('Weight').asFloat;
                  SettingMain.NameTare3:=DataSet.FieldByName('GuideName').asString;
                  SettingMain.TareId_3:=DataSet.FieldByName('GuideId').asInteger;
              end;
              if DataSet.FieldByName('NPP').asInteger = 4 then
              begin
                  SettingMain.WeightTare4:=DataSet.FieldByName('Weight').asFloat;
                  SettingMain.NameTare4:=DataSet.FieldByName('GuideName').asString;
                  SettingMain.TareId_4:=DataSet.FieldByName('GuideId').asInteger;
              end;
              if DataSet.FieldByName('NPP').asInteger = 5 then
              begin
                  SettingMain.WeightTare5:=DataSet.FieldByName('Weight').asFloat;
                  SettingMain.NameTare5:=DataSet.FieldByName('GuideName').asString;
                  SettingMain.TareId_5:=DataSet.FieldByName('GuideId').asInteger;
              end;
              if DataSet.FieldByName('NPP').asInteger = 6 then
              begin
                  SettingMain.WeightTare6:=DataSet.FieldByName('Weight').asFloat;
                  SettingMain.NameTare6:=DataSet.FieldByName('GuideName').asString;
                  SettingMain.TareId_6:=DataSet.FieldByName('GuideId').asInteger;
              end;
              if DataSet.FieldByName('NPP').asInteger = 7 then
              begin
                  SettingMain.WeightTare7:=DataSet.FieldByName('Weight').asFloat;
                  SettingMain.NameTare7:=DataSet.FieldByName('GuideName').asString;
                  SettingMain.TareId_7:=DataSet.FieldByName('GuideId').asInteger;
              end;
              if DataSet.FieldByName('NPP').asInteger = 8 then
              begin
                  SettingMain.WeightTare8:=DataSet.FieldByName('Weight').asFloat;
                  SettingMain.NameTare8:=DataSet.FieldByName('GuideName').asString;
                  SettingMain.TareId_8:=DataSet.FieldByName('GuideId').asInteger;
              end;
              if DataSet.FieldByName('NPP').asInteger = 9 then
              begin
                  SettingMain.WeightTare9:=DataSet.FieldByName('Weight').asFloat;
                  SettingMain.NameTare9:=DataSet.FieldByName('GuideName').asString;
                  SettingMain.TareId_9:=DataSet.FieldByName('GuideId').asInteger;
              end;
              if DataSet.FieldByName('NPP').asInteger = 10 then
              begin
                  SettingMain.WeightTare10:=DataSet.FieldByName('Weight').asFloat;
                  SettingMain.NameTare10:=DataSet.FieldByName('GuideName').asString;
                  SettingMain.TareId_10:=DataSet.FieldByName('GuideId').asInteger;
              end;
              //
              DataSet.Next;
         end;


       {except
         Result := '';
         ShowMessage('Ошибка получения - gpGet_Scale_Movement_checkId');
       end;}
    end;
    Result:=true;
end;
{------------------------------------------------------------------------}
function gpInitialize_SettingMain_Default: Boolean;
begin
  SettingMain.isGoodsComplete:=GetArrayList_Value_byName(Default_Array,'isGoodsComplete') = AnsiUpperCase('TRUE');
  //
  if SettingMain.isCeh = TRUE then
  begin
       SettingMain.WeightSkewer1:=myStrToFloat(GetArrayList_Value_byName(Default_Array,'WeightSkewer1'));
       SettingMain.WeightSkewer2:=myStrToFloat(GetArrayList_Value_byName(Default_Array,'WeightSkewer2'));
  end
  else begin
       SettingMain.Exception_WeightDiff:=myStrToFloat(GetArrayList_Value_byName(Default_Array,'Exception_WeightDiff'));
       //
       try SettingMain.Limit_Second_save_MI:=StrToInt(GetArrayList_Value_byName(Default_Array,'Limit_Second_save_MI'))
       except
           SettingMain.Limit_Second_save_MI:=0;
       end;
       //
       if SettingMain.BranchCode = 115 then
       begin
            DMMainScaleForm.gpInitialize_SettingMain_Tare_115;
       end
       else
       begin
           SettingMain.WeightTare1:=myStrToFloat(GetArrayList_Value_byName(Default_Array,'WeightTare1'));
           SettingMain.WeightTare2:=myStrToFloat(GetArrayList_Value_byName(Default_Array,'WeightTare2'));
           SettingMain.WeightTare3:=myStrToFloat(GetArrayList_Value_byName(Default_Array,'WeightTare3'));
           SettingMain.WeightTare4:=myStrToFloat(GetArrayList_Value_byName(Default_Array,'WeightTare4'));
           SettingMain.WeightTare5:=myStrToFloat(GetArrayList_Value_byName(Default_Array,'WeightTare5'));
           SettingMain.WeightTare6:=myStrToFloat(GetArrayList_Value_byName(Default_Array,'WeightTare6'));
           SettingMain.WeightTare7:=myStrToFloat(GetArrayList_Value_byName(Default_Array,'WeightTare7'));
           SettingMain.WeightTare8:=myStrToFloat(GetArrayList_Value_byName(Default_Array,'WeightTare8'));
           SettingMain.WeightTare9:=myStrToFloat(GetArrayList_Value_byName(Default_Array,'WeightTare9'));
           SettingMain.WeightTare10:=myStrToFloat(GetArrayList_Value_byName(Default_Array,'WeightTare10'));
       end;
       //
       SettingMain.isPartionDate:=GetArrayList_Value_byName(Default_Array,'isPartionDate') = AnsiUpperCase('TRUE');
       //
       SettingMain.isOperDatePartner:=GetArrayList_Value_byName(Default_Array,'isOperDatePartner') = AnsiUpperCase('TRUE');
       //
       SettingMain.isReason:=GetArrayList_Value_byName(Default_Array,'isReason') = AnsiUpperCase('TRUE');
       //
       SettingMain.isAsset:=GetArrayList_Value_byName(Default_Array,'isAsset') = AnsiUpperCase('TRUE');
       //
       SettingMain.isReReturnIn:=GetArrayList_Value_byName(Default_Array,'isReReturnIn') = AnsiUpperCase('TRUE');
       //
       SettingMain.isPartionGoods_20103:=GetArrayList_Value_byName(Default_Array,'isPartionGoods_20103') = AnsiUpperCase('TRUE');
       //
       if SettingMain.isSticker = TRUE
       then SettingMain.isSticker_Weight:=GetArrayList_Value_byName(Default_Array,'isSticker_Weight') = AnsiUpperCase('TRUE');
  end;
  //
  Result:=true;
end;
{------------------------------------------------------------------------}
function gpFind_MovementDesc (execParamsMovement : TParams): Boolean; //
begin
   Result:= false;
   with DialogMovementDescForm do
   begin
        if execParamsMovement.ParamByName('MovementDescNumber').asInteger<>0 then
        begin
             CDS.Filter:=' MovementDescId='+IntToStr(ParamsMovement.ParamByName('MovementDescId').AsInteger)
                       + ' and MovementDescId_next='+IntToStr(ParamsMovement.ParamByName('MovementDescId_next').AsInteger)
                       + ' and PaidKindId = ' + IntToStr(ParamsMovement.ParamByName('PaidKindId').AsInteger)
                       + ' and ToId = ' + IntToStr(ParamsMovement.ParamByName('ToId').AsInteger)
                          ;
             CDS.Filtered:=true;
             if CDS.RecordCount<>1
             then ShowMessage('Ошибка.Код операции не определен.')
             else begin execParamsMovement.ParamByName('MovementDescNumber').asInteger:= CDS.FieldByName('Number').asInteger;
                        execParamsMovement.ParamByName('MovementDescName_master').asString:= CDS.FieldByName('MovementDescName_master').asString;
                        execParamsMovement.ParamByName('GoodsKindWeighingGroupId').asInteger:=CDS.FieldByName('GoodsKindWeighingGroupId').asInteger;
                        execParamsMovement.ParamByName('InfoMoneyId').AsInteger  := CDS.FieldByName('InfoMoneyId').asInteger;
                        execParamsMovement.ParamByName('InfoMoneyCode').AsInteger:= CDS.FieldByName('InfoMoneyCode').asInteger;
                        execParamsMovement.ParamByName('InfoMoneyName').asString := CDS.FieldByName('InfoMoneyName').asString;
                        execParamsMovement.ParamByName('isSendOnPriceIn').asBoolean:= CDS.FieldByName('isSendOnPriceIn').asBoolean;
                        execParamsMovement.ParamByName('isPartionGoodsDate').asBoolean:= CDS.FieldByName('isPartionGoodsDate').asBoolean;
                        execParamsMovement.ParamByName('isPartionDate_save').asBoolean:= CDS.FieldByName('isPartionDate_save').asBoolean;
                        execParamsMovement.ParamByName('isTransport_link').asBoolean:= CDS.FieldByName('isTransport_link').asBoolean;
                        execParamsMovement.ParamByName('isSubjectDoc').asBoolean:= CDS.FieldByName('isSubjectDoc').asBoolean;
                        execParamsMovement.ParamByName('isComment').asBoolean:= CDS.FieldByName('isComment').asBoolean;
                        execParamsMovement.ParamByName('isInvNumberPartner').asBoolean:= CDS.FieldByName('isInvNumberPartner').asBoolean;
                        execParamsMovement.ParamByName('isInvNumberPartner_check').asBoolean:= CDS.FieldByName('isInvNumberPartner_check').asBoolean;
                        execParamsMovement.ParamByName('isDocPartner').asBoolean:= CDS.FieldByName('isDocPartner').asBoolean;
                        execParamsMovement.ParamByName('isListInventory').asBoolean:= CDS.FieldByName('isListInventory').asBoolean;
                        execParamsMovement.ParamByName('isAsset').asBoolean:= CDS.FieldByName('isAsset').asBoolean;
                        execParamsMovement.ParamByName('isReReturnIn').asBoolean:= CDS.FieldByName('isReReturnIn').asBoolean;

                        execParamsMovement.ParamByName('isOperCountPartner').asBoolean      := CDS.FieldByName('isOperCountPartner').asBoolean;
                        execParamsMovement.ParamByName('isOperPricePartner').asBoolean      := CDS.FieldByName('isOperPricePartner').asBoolean;
                        execParamsMovement.ParamByName('isReturnOut_Date').asBoolean        := CDS.FieldByName('isReturnOut_Date').asBoolean;
                        execParamsMovement.ParamByName('isCalc_PriceVat').asBoolean         := CDS.FieldByName('isCalc_PriceVat').asBoolean;

                        //
                        if CDS.FieldByName('isSendOnPriceIn').asBoolean = TRUE
                        then execParamsMovement.ParamByName('ChangePercentAmount').asFloat := 0;
                        //
                        Result:= true;
                  end;
        end
        else execParamsMovement.ParamByName('MovementDescName_master').AsString:='Для <Нового взвешивания> нажмите на клавиатуре клавишу <F2>.';
        //
        CDS.Filtered:=false;
        CDS.Filter:='';
   end;
end;
{------------------------------------------------------------------------}
function gpInitialize_MovementDesc: Boolean;
begin
   with DialogMovementDescForm do
   begin
        if ParamsMovement.ParamByName('MovementDescNumber').asInteger<>0 then
        begin
             CDS.Filter:='(Number='+IntToStr(ParamsMovement.ParamByName('MovementDescNumber').asInteger)
                        +')'
                          ;
             CDS.Filtered:=true;
             if CDS.RecordCount<>1
             then ShowMessage('Ошибка.Код операции не определен.')
             else begin ParamsMovement.ParamByName('MovementDescName_master').asString:= CDS.FieldByName('MovementDescName_master').asString;
                        ParamsMovement.ParamByName('MovementDescId_next').asInteger:= CDS.FieldByName('MovementDescId_next').asInteger;
                        ParamsMovement.ParamByName('GoodsKindWeighingGroupId').asInteger:=CDS.FieldByName('GoodsKindWeighingGroupId').asInteger;
                        ParamsMovement.ParamByName('InfoMoneyId').AsInteger  := CDS.FieldByName('InfoMoneyId').asInteger;
                        ParamsMovement.ParamByName('InfoMoneyCode').AsInteger:= CDS.FieldByName('InfoMoneyCode').asInteger;
                        ParamsMovement.ParamByName('InfoMoneyName').asString := CDS.FieldByName('InfoMoneyName').asString;
                        ParamsMovement.ParamByName('isSendOnPriceIn').asBoolean:= CDS.FieldByName('isSendOnPriceIn').asBoolean;
                        ParamsMovement.ParamByName('isPartionGoodsDate').asBoolean:= CDS.FieldByName('isPartionGoodsDate').asBoolean;
                        ParamsMovement.ParamByName('isPartionDate_save').asBoolean:= CDS.FieldByName('isPartionDate_save').asBoolean;
                        ParamsMovement.ParamByName('isTransport_link').asBoolean:= CDS.FieldByName('isTransport_link').asBoolean;
                        ParamsMovement.ParamByName('isSubjectDoc').asBoolean:= CDS.FieldByName('isSubjectDoc').asBoolean;
                        ParamsMovement.ParamByName('isComment').asBoolean:= CDS.FieldByName('isComment').asBoolean;
                        ParamsMovement.ParamByName('isInvNumberPartner').asBoolean:= CDS.FieldByName('isInvNumberPartner').asBoolean;
                        ParamsMovement.ParamByName('isInvNumberPartner_check').asBoolean:= CDS.FieldByName('isInvNumberPartner_check').asBoolean;
                        ParamsMovement.ParamByName('isDocPartner').asBoolean:= CDS.FieldByName('isDocPartner').asBoolean;
                        ParamsMovement.ParamByName('isListInventory').asBoolean:= CDS.FieldByName('isListInventory').asBoolean;
                        ParamsMovement.ParamByName('isAsset').asBoolean:= CDS.FieldByName('isAsset').asBoolean;
                        ParamsMovement.ParamByName('isReReturnIn').asBoolean:= CDS.FieldByName('isReReturnIn').asBoolean;

                        ParamsMovement.ParamByName('isOperCountPartner').asBoolean      := CDS.FieldByName('isOperCountPartner').asBoolean;
                        ParamsMovement.ParamByName('isOperPricePartner').asBoolean      := CDS.FieldByName('isOperPricePartner').asBoolean;
                        ParamsMovement.ParamByName('isReturnOut_Date').asBoolean        := CDS.FieldByName('isReturnOut_Date').asBoolean;
                        ParamsMovement.ParamByName('isCalc_PriceVat').asBoolean         := CDS.FieldByName('isCalc_PriceVat').asBoolean;
                        //
                        if CDS.FieldByName('isSendOnPriceIn').asBoolean = TRUE
                        then ParamsMovement.ParamByName('ChangePercentAmount').asFloat := 0;
                  end;
        end
        else ParamsMovement.ParamByName('MovementDescName_master').AsString:='Для <Нового взвешивания> нажмите на клавиатуре клавишу <F2>.';
        //
        CDS.Filtered:=false;
        CDS.Filter:='';
   end;
end;
{------------------------------------------------------------------------}
end.
