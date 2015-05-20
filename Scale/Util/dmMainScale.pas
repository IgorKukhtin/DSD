unit dmMainScale;

interface

uses
  System.SysUtils, System.Classes, dsdDB, Data.DB, Datasnap.DBClient, Vcl.Dialogs,UtilScale;

type
  TDMMainScaleForm = class(TDataModule)
    ClientDataSet: TClientDataSet;
    spSelect: TdsdStoredProc;
    procedure DataModuleCreate(Sender: TObject);
  private
  public
    function gpSelect_ToolsWeighing_onLevelChild(inBrancCode:Integer;inLevelChild: String): TArrayList;
    function gpGet_ToolsWeighing_Value(inLevel1,inLevel2,inLevel3,inItemName,inDefaultValue:String):String;
    function gpGet_Scale_User:String;

    function gpSelect_Scale_GoodsKindWeighing: TArrayList;
    function gpGet_Scale_Partner(var execParams:TParams;inPartnerCode:Integer): Boolean;
    function gpGet_Scale_PartnerParams(var execParams:TParams): Boolean;
    function gpGet_Scale_OrderExternal(var execParams:TParams;inBarCode:String): Boolean;
    function gpGet_Scale_Goods(var execParams:TParams;inBarCode:String): Boolean;
    function gpGet_Scale_GoodsRetail(var execParamsMovement:TParams;var execParams:TParams;inBarCode:String): Boolean;
    function gpGet_Scale_Personal(var execParams:TParams;inPersonalCode:Integer): Boolean;

    function gpGet_Scale_Movement(var execParamsMovement:TParams;isLast,isNext:Boolean): Boolean;

    function gpInsert_Movement_all(var execParamsMovement:TParams): Boolean;
    function gpInsertUpdate_Scale_Movement(var execParamsMovement:TParams): Boolean;
    function gpInsert_Scale_MI(var execParamsMovement:TParams;var execParamsMI:TParams): Boolean;

    function gpUpdate_Scale_Movement_PersonalComlete(execParamsPersonalComplete:TParams): Boolean;

    function gpUpdate_Scale_MI_Erased(MovementItemId:Integer;NewValue: Boolean): Boolean;

    function gpUpdate_Scale_Movement_check(execParamsMovement:TParams): Boolean;

    function gpUpdate_Scale_MIFloat(execParams:TParams): Boolean;
  end;

  function gpInitialize_OperDate(var execParams:TParams):TDateTime;
  function gpInitialize_Const: Boolean;
  function gpInitialize_Ini: Boolean;
  function gpInitialize_ParamsMovement: Boolean;
  function gpInitialize_MovementDesc: Boolean;

var
  DMMainScaleForm: TDMMainScaleForm;

implementation
uses Inifiles,TypInfo,DialogMovementDesc;
{$R *.dfm}
{------------------------------------------------------------------------}
procedure TDMMainScaleForm.DataModuleCreate(Sender: TObject);
begin
  gpInitialize_ParamsMovement;
end;
{------------------------------------------------------------------------}
function gpInitialize_ParamsMovement: Boolean;
begin
    Result:=false;
    //
    Create_ParamsMovement(ParamsMovement);
    //
    gpInitialize_OperDate(ParamsMovement);
    //
    Result:=DMMainScaleForm.gpGet_Scale_Movement(ParamsMovement,TRUE,FALSE);//isLast=TRUE,isNext=FALSE
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_Movement(var execParamsMovement:TParams;isLast,isNext:Boolean): Boolean;
begin
    Result:=false;

    with spSelect do
    begin
       StoredProcName:='gpGet_Scale_Movement';
       OutputType:=otDataSet;
       Params.Clear;

       if (isLast = FALSE) or (isNext = TRUE)
       then Params.AddParam('inMovementId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementId').AsInteger)
       else Params.AddParam('inMovementId', ftInteger, ptInput, 0);
       Params.AddParam('inOperDate', ftDateTime, ptInput, execParamsMovement.ParamByName('OperDate').AsDateTime);
       Params.AddParam('inIsNext', ftBoolean, ptInput, isNext);

       //try
         Execute;

       //!!!выход, пока обрабатывается эта ошибка только в одном месте!!!
       if DataSet.RecordCount<>1 then begin Result:=false;exit;end;


       with execParamsMovement do
       begin
         ParamByName('MovementId_begin').AsInteger:= 0;

         ParamByName('MovementId').AsInteger:= DataSet.FieldByName('MovementId').asInteger;
         ParamByName('InvNumber').asString:= DataSet.FieldByName('InvNumber').asString;
         ParamByName('OperDate_Movement').asDateTime:= DataSet.FieldByName('OperDate').asDateTime;

         ParamByName('MovementDescNumber').AsInteger:= DataSet.FieldByName('MovementDescNumber').asInteger;

         ParamByName('MovementDescId').AsInteger:= DataSet.FieldByName('MovementDescId').asInteger;
         ParamByName('FromId').AsInteger:= DataSet.FieldByName('ToId').asInteger;
         ParamByName('FromCode').AsInteger:= DataSet.FieldByName('ToCode').asInteger;
         ParamByName('FromName').asString:= DataSet.FieldByName('ToName').asString;
         ParamByName('ToId').AsInteger:= DataSet.FieldByName('FromId').asInteger;
         ParamByName('ToCode').AsInteger:= DataSet.FieldByName('FromCode').asInteger;
         ParamByName('ToName').asString:= DataSet.FieldByName('FromName').asString;
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

         ParamByName('OrderExternalId').AsInteger:= DataSet.FieldByName('MovementId_Order').asInteger;
         ParamByName('OrderExternal_BarCode').asString:= DataSet.FieldByName('BarCode').asString;
         ParamByName('OrderExternal_InvNumber').asString:= DataSet.FieldByName('InvNumber_Order').asString;
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

         ParamByName('TotalSumm').asFloat:= DataSet.FieldByName('TotalSumm').asFloat;
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
                        ParamsMovement.ParamByName('GoodsKindWeighingGroupId').asInteger:=CDS.FieldByName('GoodsKindWeighingGroupId').asInteger;
                        ParamsMovement.ParamByName('InfoMoneyId').AsInteger  := CDS.FieldByName('InfoMoneyId').asInteger;
                        ParamsMovement.ParamByName('InfoMoneyCode').AsInteger:= CDS.FieldByName('InfoMoneyCode').asInteger;
                        ParamsMovement.ParamByName('InfoMoneyName').asString := CDS.FieldByName('InfoMoneyName').asString;
                  end;
          end
          else ParamsMovement.ParamByName('MovementDescName_master').AsString:='Нажмите на клавиатуре клавишу <F2>.';
   end;
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
       Params.AddParam('inPositionId1', ftInteger, ptInput, execParamsPersonalComplete.ParamByName('PositionId1').AsInteger);
       Params.AddParam('inPositionId2', ftInteger, ptInput, execParamsPersonalComplete.ParamByName('PositionId2').AsInteger);
       Params.AddParam('inPositionId3', ftInteger, ptInput, execParamsPersonalComplete.ParamByName('PositionId3').AsInteger);
       Params.AddParam('inPositionId4', ftInteger, ptInput, execParamsPersonalComplete.ParamByName('PositionId4').AsInteger);
       //try
         Execute;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpUpdate_Scale_Movement_PersonalComlete');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_Movement_check(execParamsMovement:TParams): Boolean;
begin
    Result:=false;
    if execParamsMovement.ParamByName('MovementId').AsInteger<>0 then
    with spSelect do begin
       StoredProcName:='gpUpdate_Scale_Movement_check';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInputOutput, execParamsMovement.ParamByName('MovementId').AsInteger);
       //try
         Execute;
         Result:=DataSet.FieldByName('isOk').asBoolean;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpGet_ToolsWeighing_Value');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_MIFloat(execParams:TParams): Boolean;
begin
    Result:=false;

    with spSelect do begin
       StoredProcName:= 'gpUpdate_Scale_MIFloat';
       OutputType:=otDataSet;
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
function TDMMainScaleForm.gpInsert_Movement_all(var execParamsMovement:TParams): Boolean;
begin
    Result:=false;
    with spSelect do begin
       StoredProcName:='gpInsert_Scale_Movement_all';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInputOutput, execParamsMovement.ParamByName('MovementId').AsInteger);
       Params.AddParam('inOperDate', ftDateTime, ptInput, execParamsMovement.ParamByName('OperDate').AsDateTime);
       //try
         Execute;
         execParamsMovement.ParamByName('MovementId_begin').AsInteger:=DataSet.FieldByName('MovementId_begin').asInteger;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpGet_ToolsWeighing_Value');
       end;}
    end;
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
       Params.AddParam('inMovementDescId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementDescId').AsInteger);
       Params.AddParam('inMovementDescNumber', ftInteger, ptInput, execParamsMovement.ParamByName('MovementDescNumber').AsInteger);
       Params.AddParam('inFromId', ftInteger, ptInput, execParamsMovement.ParamByName('FromId').AsInteger);
       Params.AddParam('inToId', ftInteger, ptInput, execParamsMovement.ParamByName('ToId').AsInteger);
       Params.AddParam('inContractId', ftInteger, ptInput, execParamsMovement.ParamByName('ContractId').AsInteger);
       Params.AddParam('inPaidKindId', ftInteger, ptInput, execParamsMovement.ParamByName('PaidKindId').AsInteger);
       Params.AddParam('inPriceListId', ftInteger, ptInput, execParamsMovement.ParamByName('PriceListId').AsInteger);
       Params.AddParam('inMovementId_Order', ftInteger, ptInput, execParamsMovement.ParamByName('OrderExternalId').AsInteger);
       Params.AddParam('inChangePercent', ftFloat, ptInput, execParamsMovement.ParamByName('ChangePercent').AsFloat);
       //try
         Execute;
         execParamsMovement.ParamByName('MovementId').AsInteger:=DataSet.FieldByName('Id').asInteger;
         execParamsMovement.ParamByName('InvNumber').AsString:=DataSet.FieldByName('InvNumber').AsString;
         execParamsMovement.ParamByName('OperDate_Movement').AsString:=DataSet.FieldByName('OperDate').AsString;
         execParamsMovement.ParamByName('TotalSumm').AsFloat:=DataSet.FieldByName('TotalSumm').AsFloat;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpGet_ToolsWeighing_Value');
       end;}
    end;
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpInsert_Scale_MI(var execParamsMovement:TParams;var execParamsMI:TParams): Boolean;
begin
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
       Params.AddParam('inRealWeight', ftFloat, ptInput, execParamsMI.ParamByName('RealWeight').AsFloat);
       Params.AddParam('inChangePercentAmount', ftFloat, ptInput, execParamsMI.ParamByName('ChangePercentAmount').AsFloat);
       Params.AddParam('inCountTare', ftFloat, ptInput, execParamsMI.ParamByName('CountTare').AsFloat);
       Params.AddParam('inWeightTare', ftFloat, ptInput, execParamsMI.ParamByName('WeightTare').AsFloat);
       Params.AddParam('inPrice', ftFloat, ptInput, execParamsMI.ParamByName('Price').AsFloat);
       Params.AddParam('inPrice_Return', ftFloat, ptInput, execParamsMI.ParamByName('Price_Return').AsFloat);
       Params.AddParam('inCountForPrice', ftFloat, ptInput, execParamsMI.ParamByName('CountForPrice').AsFloat);
       Params.AddParam('inCountForPrice_Return', ftFloat, ptInput, execParamsMI.ParamByName('CountForPrice_Return').AsFloat);
       Params.AddParam('inDayPrior_PriceReturn', ftInteger, ptInput, StrToInt(GetArrayList_Value_byName(Default_Array,'DayPrior_PriceReturn')));
       Params.AddParam('inCount', ftFloat, ptInput, execParamsMI.ParamByName('Count').AsFloat);
       Params.AddParam('inHeadCount', ftFloat, ptInput, execParamsMI.ParamByName('HeadCount').AsFloat);
       Params.AddParam('inPartionGoods', ftString, ptInput, execParamsMI.ParamByName('PartionGoods').AsString);
       Params.AddParam('inPriceListId', ftInteger, ptInput, execParamsMovement.ParamByName('PriceListId').AsInteger);
       //try
         Execute;
         execParamsMovement.ParamByName('TotalSumm').AsFloat:=DataSet.FieldByName('TotalSumm').AsFloat;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpGet_ToolsWeighing_Value');
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
       Params.AddParam('inIsErased', ftBoolean, ptInput, NewValue);
       //try
         Execute;
         ParamsMovement.ParamByName('TotalSumm').AsFloat:=DataSet.FieldByName('TotalSumm').AsFloat;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpGet_ToolsWeighing_Value');
       end;}
    end;

end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(inBrancCode:Integer;inLevelChild: String): TArrayList;
var i: integer;
begin
    with spSelect do
    begin
       StoredProcName:='gpSelect_Object_ToolsWeighing_onLevelChild';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inBrancCode', ftInteger, ptInput, inBrancCode);
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
         ShowMessage('Ошибка получения - gpGet_ToolsWeighing_Value');
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
         ShowMessage('Ошибка получения - gpSelect_ToolsWeighing_onLevelChild');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_Goods(var execParams:TParams;inBarCode:String): Boolean;
begin
    with spSelect do
    begin
       //в ШК - Id товара или товар+вид товара
       StoredProcName:='gpGet_Scale_Goods';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inBarCode', ftString, ptInput, inBarCode);
       //try
         Execute;
         //
         Result:=DataSet.RecordCount<>0;
       with execParams do
       begin
         ParamByName('GoodsId').AsInteger  := DataSet.FieldByName('GoodsId').AsInteger;
         ParamByName('GoodsCode').AsInteger:= DataSet.FieldByName('GoodsCode').AsInteger;
         ParamByName('GoodsName').asString := DataSet.FieldByName('GoodsName').asString;

         ParamByName('GoodsKindId').AsInteger  := DataSet.FieldByName('GoodsKindId').asInteger;
         ParamByName('GoodsKindCode').AsInteger:= DataSet.FieldByName('GoodsKindCode').AsInteger;
         ParamByName('GoodsKindName').asString := DataSet.FieldByName('GoodsKindName').asString;
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
       Params.AddParam('inPartnerCode', ftInteger, ptInput, inPartnerCode);
       Params.AddParam('inInfoMoneyId', ftInteger, ptInput, execParams.ParamByName('InfoMoneyId').AsInteger);
       Params.AddParam('inPaidKindId', ftInteger, ptInput, execParams.ParamByName('PaidKindId').AsInteger);
       //try
         Execute;
         //
         Result:=DataSet.RecordCount<>0;
       with execParams do
       begin
         ParamByName('calcPartnerId').AsInteger:= DataSet.FieldByName('PartnerId').AsInteger;
         ParamByName('calcPartnerCode').AsInteger:= DataSet.FieldByName('PartnerCode').AsInteger;
         ParamByName('calcPartnerName').asString:= DataSet.FieldByName('PartnerName').asString;
         ParamByName('ChangePercent').asFloat:= DataSet.FieldByName('ChangePercent').asFloat;
         ParamByName('ChangePercentAmount').asFloat:= DataSet.FieldByName('ChangePercentAmount').asFloat;
         ParamByName('isEdiOrdspr').asBoolean:= DataSet.FieldByName('isEdiOrdspr').asBoolean;
         ParamByName('isEdiInvoice').asBoolean:= DataSet.FieldByName('isEdiInvoice').asBoolean;
         ParamByName('isEdiDesadv').asBoolean:= DataSet.FieldByName('isEdiDesadv').asBoolean;

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
    with spSelect do
    begin
       StoredProcName:='gpGet_Scale_PartnerParams';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inOperDate', ftDateTime, ptInput, execParams.ParamByName('OperDate').AsDateTime);
       Params.AddParam('inPartnerId', ftInteger, ptInput, execParams.ParamByName('calcPartnerId').AsInteger);
       Params.AddParam('inContractIdId', ftInteger, ptInput, execParams.ParamByName('ContractId').AsInteger);
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
function TDMMainScaleForm.gpGet_Scale_OrderExternal(var execParams:TParams;inBarCode: String): Boolean;
begin
    with spSelect do
    begin
       StoredProcName:='gpGet_Scale_OrderExternal';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inOperDate', ftDateTime, ptInput, execParams.ParamByName('OperDate').AsDateTime);
       Params.AddParam('inBarCode', ftString, ptInput, inBarCode);
       //try
         Execute;
         //
         Result:=DataSet.RecordCount=1;
       with execParams do
       begin
         ParamByName('MovementDescId').AsInteger:= DataSet.FieldByName('MovementDescId').asInteger;
         ParamByName('FromId').AsInteger:= DataSet.FieldByName('ToId').asInteger;
         ParamByName('FromCode').AsInteger:= DataSet.FieldByName('ToCode').asInteger;
         ParamByName('FromName').asString:= DataSet.FieldByName('ToName').asString;
         ParamByName('ToId').AsInteger:= DataSet.FieldByName('FromId').asInteger;
         ParamByName('ToCode').AsInteger:= DataSet.FieldByName('FromCode').asInteger;
         ParamByName('ToName').asString:= DataSet.FieldByName('FromName').asString;
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

         ParamByName('OrderExternalId').AsInteger:= DataSet.FieldByName('MovementId').asInteger;
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
       end;


       {except
         result.Code := Code;
         result.Id   := 0;
         result.Name := '';
         ShowMessage('Ошибка получения - gpGetObject_byCode');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function gpInitialize_OperDate(var execParams:TParams):TDateTime;
begin
    with DMMainScaleForm.spSelect do
    begin
       StoredProcName:='gpSelect_Scale_OperDate';
       OutputType:=otDataSet;
       Params.Clear;
       //try
         Execute;
         //
         Result:=DataSet.FieldByName('OperDate').asDateTime;
         execParams.ParamByName('OperDate').AsDateTime:=DataSet.FieldByName('OperDate').asDateTime;

       {except
         result.Code := Code;
         result.Id   := 0;
         result.Name := '';
         ShowMessage('Ошибка получения - gpGetObject_byCode');
       end;}
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

         Params.ParamByName('inSqlText').Value:='SELECT zc_Measure_Sh() :: TVarChar';
         Execute;
         zc_Measure_Sh:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Measure_Kg() :: TVarChar';
         Execute;
         zc_Measure_Kg:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_BarCodePref_Object() :: TVarChar';
         Execute;
         zc_BarCodePref_Object:=DataSet.FieldByName('Value').asString;

         Params.ParamByName('inSqlText').Value:='SELECT zc_BarCodePref_Movement() :: TVarChar';
         Execute;
         zc_BarCodePref_Movement:=DataSet.FieldByName('Value').asString;

         Params.ParamByName('inSqlText').Value:='SELECT zc_BarCodePref_MI() :: TVarChar';
         Execute;
         zc_BarCodePref_MI:=DataSet.FieldByName('Value').asString;

         // Доходы + Мясное сырье + Мясное сырье
         Params.ParamByName('inSqlText').Value:='SELECT zc_Enum_InfoMoney_30201() :: TVarChar';
         Execute;
         zc_Enum_InfoMoney_30201:=DataSet.FieldByName('Value').asInteger;


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

  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'scale.ini');

  SettingMain.BrancCode:=Ini.ReadInteger('Main','BrancCode',1);
  if SettingMain.BrancCode=1 then Ini.WriteInteger('Main','BrancCode',1);

  SettingMain.DefaultCOMPort:=Ini.ReadInteger('Main','DefaultCOMPort',1);
  if SettingMain.DefaultCOMPort=1 then Ini.WriteInteger('Main','DefaultCOMPort',1);

  SettingMain.ScaleCount:=Ini.ReadInteger('Main','ScaleCount',2);
  if SettingMain.ScaleCount=2 then Ini.WriteInteger('Main','ScaleCount',2);

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
end.
