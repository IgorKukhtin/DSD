unit dmMainScaleCeh;

interface

uses
  System.SysUtils, System.Classes, dsdDB, Data.DB, Datasnap.DBClient, Vcl.Dialogs,UtilScale;

type
  TDMMainScaleCehForm = class(TDataModule)
    ClientDataSet: TClientDataSet;
    spSelect: TdsdStoredProc;
    procedure DataModuleCreate(Sender: TObject);
  private
  public
    // Scale + ScaleCeh
    function gpSelect_ToolsWeighing_onLevelChild(inBranchCode:Integer;inLevelChild: String): TArrayList;
    function gpGet_ToolsWeighing_Value(inLevel1,inLevel2,inLevel3,inItemName,inDefaultValue:String):String;
    function gpGet_Scale_User:String;
    function gpGet_Scale_OperDate(var execParams:TParams):TDateTime;
    // Scale + ScaleCeh
    function gpSelect_Scale_GoodsKindWeighing: TArrayList;
    function gpGet_Scale_Goods(var execParams:TParams;inBarCode:String): Boolean;
    // Scale + ScaleCeh
    function gpUpdate_Scale_MI_Erased(MovementItemId:Integer;NewValue: Boolean): Boolean;
    function gpUpdate_Scale_MIFloat(execParams:TParams): Boolean;
    function gpUpdate_Scale_MIString(execParams:TParams): Boolean;
    function gpUpdate_Scale_MIDate(execParams:TParams): Boolean;
    function gpUpdate_Scale_MILinkObject(execParams:TParams): Boolean;

    // Scale + ScaleCeh
    function gpGet_Scale_Movement_checkId(var execParamsMovement:TParams): Boolean;
    function lpGet_BranchName(inBranchCode:Integer): String;
    //
    // +++ScaleCeh+++
    function gpGet_ScaleCeh_Movement(var execParamsMovement:TParams;isLast,isNext:Boolean): Boolean;
    // +++ScaleCeh+++
    function gpInsertUpdate_ScaleCeh_Movement(var execParamsMovement:TParams): Boolean;
    function gpInsert_ScaleCeh_MI(var execParamsMovement:TParams;var execParamsMI:TParams): Boolean;
    function gpInsert_MovementCeh_all(var execParamsMovement:TParams): Boolean;
    //
    //ScaleCeh
    function gpGet_ScaleCeh_Movement_checkPartion(MovementId,GoodsId:Integer;PartionGoods:String;OperCount:Double): Boolean;
    //ScaleCeh
    function gpGet_ScaleCeh_Movement_checkStorageLine(MovementId : Integer): String;

  end;

  function gpInitialize_Const: Boolean;//Scale + ScaleCeh
  function gpInitialize_Ini: Boolean;  //ScaleCeh
  function gpInitialize_SettingMain_Default: Boolean;//Scale + ScaleCeh

var
  DMMainScaleCehForm: TDMMainScaleCehForm;

implementation
uses Inifiles,TypInfo,DialogMovementDesc,UtilConst;
{$R *.dfm}
{------------------------------------------------------------------------}
procedure TDMMainScaleCehForm.DataModuleCreate(Sender: TObject);
begin
    //  gpInitialize_ParamsMovement;
    //
    Create_ParamsMovement(ParamsMovement);
    //
    gpGet_Scale_OperDate(ParamsMovement);
    //
    ///////Result:=
    DMMainScaleCehForm.gpGet_ScaleCeh_Movement(ParamsMovement,TRUE,FALSE);//isLast=TRUE,isNext=FALSE
end;
{------------------------------------------------------------------------}
{function gpInitialize_ParamsMovement: Boolean;
begin
    Result:=false;
    //
    Create_ParamsMovement(ParamsMovement);
    //
    gpGet_Scale_OperDate(ParamsMovement);
    //
    Result:=DMMainScaleCehForm.gpGet_ScaleCeh_Movement(ParamsMovement,TRUE,FALSE);//isLast=TRUE,isNext=FALSE
end;}
{------------------------------------------------------------------------}
function TDMMainScaleCehForm.gpGet_ScaleCeh_Movement(var execParamsMovement:TParams;isLast,isNext:Boolean): Boolean;
begin
    Result:=false;

    with spSelect do
    begin
       StoredProcName:='gpGet_ScaleCeh_Movement';
       OutputType:=otDataSet;
       Params.Clear;

       if (isNext = TRUE)or(isLast = FALSE)//так сложно, т.к. при isLast = FALSE надо обработать MovementId
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
function TDMMainScaleCehForm.gpGet_Scale_Movement_checkId(var execParamsMovement:TParams): Boolean;
begin
    Result:=false;
    if execParamsMovement.ParamByName('MovementId').AsInteger<>0 then
    with spSelect do begin
       StoredProcName:='gpGet_Scale_Movement_checkId';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementId').AsInteger);
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
function TDMMainScaleCehForm.gpGet_ScaleCeh_Movement_checkStorageLine(MovementId : Integer): String;
begin
    with spSelect do begin
       StoredProcName:='gpGet_ScaleCeh_Movement_checkStorageLine';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInput, MovementId);
       //try
       Execute;
       if DataSet.FieldByName('isStorageLine_empty').asBoolean = TRUE
       then Result:= ''
       else Result:= DataSet.FieldByName('MessageStr').asString
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleCehForm.gpGet_ScaleCeh_Movement_checkPartion(MovementId,GoodsId:Integer;PartionGoods:String;OperCount:Double): Boolean;
begin
    Result:=false;
    with spSelect do begin
       StoredProcName:='gpGet_ScaleCeh_Movement_checkPartion';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInput, MovementId);
       Params.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
       Params.AddParam('inPartionGoods', ftString, ptInput, PartionGoods);
       Params.AddParam('inOperCount', ftFloat, ptInput, OperCount);
       //try
         Execute;
         Result:=DataSet.FieldByName('Code').asInteger = 0;
         //execParamsMovement.ParamByName('MessageCode').AsInteger:= DataSet.FieldByName('Code').AsInteger;
         //execParamsMovement.ParamByName('MessageStr').AsString:= DataSet.FieldByName('MessageStr').AsString;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpGet_ScaleCeh_Movement_checkPartion');
       end;}
    end;

    if not Result
    then
        if spSelect.DataSet.FieldByName('Code').asInteger = 1
        then ShowMessage(spSelect.DataSet.FieldByName('MessageStr').AsString)
        else Result:=MessageDlg(spSelect.DataSet.FieldByName('MessageStr').AsString,mtConfirmation,mbYesNoCancel,0) = 6;
end;
{------------------------------------------------------------------------}
function TDMMainScaleCehForm.gpUpdate_Scale_MIFloat(execParams:TParams): Boolean;
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
function TDMMainScaleCehForm.gpUpdate_Scale_MIString(execParams:TParams): Boolean;
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
function TDMMainScaleCehForm.gpUpdate_Scale_MIDate(execParams:TParams): Boolean;
begin
    Result:=false;

    with spSelect do begin
       StoredProcName:= 'gpUpdate_Scale_MIDate';
       OutputType:=otResult;
       Params.Clear;
       Params.AddParam('inMovementItemId', ftInteger, ptInput, execParams.ParamByName('inMovementItemId').AsInteger);
       Params.AddParam('inDescCode', ftString, ptInput, execParams.ParamByName('inDescCode').AsString);
       Params.AddParam('inValueData', ftDateTime, ptInput, execParams.ParamByName('inValueData').AsDateTime);
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
function TDMMainScaleCehForm.gpUpdate_Scale_MILinkObject(execParams:TParams): Boolean;
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
function TDMMainScaleCehForm.gpInsert_MovementCeh_all(var execParamsMovement:TParams): Boolean;
begin
    Result:=false;
    with spSelect do begin
       StoredProcName:='gpInsert_ScaleCeh_Movement_all';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       Params.AddParam('inMovementId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementId').AsInteger);
       Params.AddParam('inOperDate', ftDateTime, ptInput, execParamsMovement.ParamByName('OperDate').AsDateTime);
       //try
         Execute;
         execParamsMovement.ParamByName('MovementId_begin').AsInteger:=DataSet.FieldByName('MovementId_begin').asInteger;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpInsert_ScaleCeh_Movement_all');
       end;}
    end;
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleCehForm.gpInsertUpdate_ScaleCeh_Movement(var execParamsMovement:TParams): Boolean;
begin
    Result:=false;
    with spSelect do begin
       StoredProcName:='gpInsertUpdate_ScaleCeh_Movement';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inId', ftInteger, ptInputOutput, execParamsMovement.ParamByName('MovementId').AsInteger);
       Params.AddParam('inOperDate', ftDateTime, ptInput, execParamsMovement.ParamByName('OperDate').AsDateTime);
       Params.AddParam('inMovementDescId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementDescId').AsInteger);
       Params.AddParam('inMovementDescNumber', ftInteger, ptInput, execParamsMovement.ParamByName('MovementDescNumber').AsInteger);
       Params.AddParam('inFromId', ftInteger, ptInput, execParamsMovement.ParamByName('FromId').AsInteger);
       Params.AddParam('inToId', ftInteger, ptInput, execParamsMovement.ParamByName('ToId').AsInteger);
       Params.AddParam('inIsProductionIn', ftBoolean, ptInput, execParamsMovement.ParamByName('isSendOnPriceIn').AsBoolean);
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       //try
         Execute;
         execParamsMovement.ParamByName('MovementId').AsInteger:=DataSet.FieldByName('Id').asInteger;
         execParamsMovement.ParamByName('InvNumber').AsString:=DataSet.FieldByName('InvNumber').AsString;
         execParamsMovement.ParamByName('OperDate_Movement').AsString:=DataSet.FieldByName('OperDate').AsString;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpInsertUpdate_ScaleCeh_Movement');
       end;}
    end;
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleCehForm.gpInsert_ScaleCeh_MI(var execParamsMovement:TParams;var execParamsMI:TParams): Boolean;
begin
    if execParamsMovement.ParamByName('MovementId').AsInteger = 0
    then Result:= gpInsertUpdate_ScaleCeh_Movement(execParamsMovement)
    else Result:= true;
    //
    if Result then
    with spSelect do begin
       StoredProcName:='gpInsert_ScaleCeh_MI';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inId', ftInteger, ptInput, 0);
       Params.AddParam('inMovementId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementId').AsInteger);
       Params.AddParam('inGoodsId', ftInteger, ptInput, execParamsMI.ParamByName('GoodsId').AsInteger);
       Params.AddParam('inGoodsKindId', ftInteger, ptInput, execParamsMI.ParamByName('GoodsKindId').AsInteger);
       Params.AddParam('inStorageLineId', ftInteger, ptInput, execParamsMI.ParamByName('StorageLineId').AsInteger);
       Params.AddParam('inIsStartWeighing', ftBoolean, ptInput, execParamsMI.ParamByName('isStartWeighing').AsBoolean);
       Params.AddParam('inIsPartionGoodsDate', ftBoolean, ptInput, execParamsMovement.ParamByName('isPartionGoodsDate').AsBoolean);
       Params.AddParam('inOperCount', ftFloat, ptInput, execParamsMI.ParamByName('OperCount').AsFloat);
       Params.AddParam('inRealWeight', ftFloat, ptInput, execParamsMI.ParamByName('RealWeight').AsFloat);
       Params.AddParam('inWeightTare', ftFloat, ptInput, execParamsMI.ParamByName('WeightTare').AsFloat);
       Params.AddParam('inLiveWeight', ftFloat, ptInput, execParamsMI.ParamByName('LiveWeight').AsFloat);
       Params.AddParam('inHeadCount', ftFloat, ptInput, execParamsMI.ParamByName('HeadCount').AsFloat);
       Params.AddParam('inCount', ftFloat, ptInput, execParamsMI.ParamByName('Count').AsFloat);
       Params.AddParam('inCountPack', ftFloat, ptInput, execParamsMI.ParamByName('CountPack').AsFloat);
       Params.AddParam('inCountSkewer1', ftFloat, ptInput, execParamsMI.ParamByName('CountSkewer1').AsFloat);
       Params.AddParam('inWeightSkewer1', ftFloat, ptInput, SettingMain.WeightSkewer1);
       Params.AddParam('inCountSkewer2', ftFloat, ptInput, execParamsMI.ParamByName('CountSkewer2').AsFloat);
       Params.AddParam('inWeightSkewer2', ftFloat, ptInput, SettingMain.WeightSkewer2);
       Params.AddParam('inWeightOther', ftFloat, ptInput, execParamsMI.ParamByName('WeightOther').AsFloat);
       Params.AddParam('inPartionGoodsDate', ftDateTime, ptInput, execParamsMI.ParamByName('PartionGoodsDate').AsDateTime);
       Params.AddParam('inPartionGoods', ftString, ptInput, execParamsMI.ParamByName('PartionGoods').AsString);
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       //try
         Execute;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpInsert_ScaleCeh_MI');
       end;}
    end;

end;
{------------------------------------------------------------------------}
function TDMMainScaleCehForm.gpUpdate_Scale_MI_Erased(MovementItemId:Integer;NewValue: Boolean): Boolean;
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
         ShowMessage('Ошибка получения - gpUpdate_ScaleCeh_MI_Erased');
       end;}
    end;

end;
{------------------------------------------------------------------------}
function TDMMainScaleCehForm.gpSelect_ToolsWeighing_onLevelChild(inBranchCode:Integer;inLevelChild: String): TArrayList;
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
function TDMMainScaleCehForm.gpGet_Scale_User:String;
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
function TDMMainScaleCehForm.gpGet_ToolsWeighing_Value(inLevel1,inLevel2,inLevel3,inItemName,inDefaultValue:String):String;
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
function TDMMainScaleCehForm.gpSelect_Scale_GoodsKindWeighing: TArrayList;
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
function TDMMainScaleCehForm.gpGet_Scale_Goods(var execParams:TParams;inBarCode:String): Boolean;
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
         end
         else
         begin
              // только для программы ScaleCeh
              ParamByName('MeasureId').AsInteger  := DataSet.FieldByName('MeasureId').asInteger;
              ParamByName('MeasureCode').AsInteger:= DataSet.FieldByName('MeasureCode').AsInteger;
              ParamByName('MeasureName').asString := DataSet.FieldByName('MeasureName').asString;

              // только для программы ScaleCeh
              ParamByName('GoodsKindId_list').asString   := DataSet.FieldByName('GoodsKindId_list').asString;
              ParamByName('GoodsKindName_List').asString := DataSet.FieldByName('GoodsKindName_List').asString;

              ParamByName('GoodsKindId_max').AsInteger  := DataSet.FieldByName('GoodsKindId_max').asInteger;
              ParamByName('GoodsKindCode_max').AsInteger:= DataSet.FieldByName('GoodsKindCode_max').AsInteger;
              ParamByName('GoodsKindName_max').asString := DataSet.FieldByName('GoodsKindName_max').asString;
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
function TDMMainScaleCehForm.gpGet_Scale_OperDate(var execParams:TParams):TDateTime;
begin
    with  DMMainScaleCehForm.spSelect do
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
function TDMMainScaleCehForm.lpGet_BranchName(inBranchCode:Integer): String;
begin
    with spSelect do
    begin
       StoredProcName:='gpExecSql_Value';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inSqlText', ftString, ptInput, 'SELECT Object.ValueData FROM Object WHERE Object.Id = COALESCE((SELECT Object_Branch.Id FROM Object AS Object_Branch WHERE Object_Branch.ObjectCode = '+ IntToStr(inBranchCode) + ' AND Object_Branch.DescId = zc_Object_Branch()), zc_Branch_Basis())' );
       Execute;
       if inBranchCode > 100
       then Result:='('+IntToStr(inBranchCode)+')'+DataSet.FieldByName('Value').asString
       else Result:='('+IntToStr(inBranchCode)+')'+DataSet.FieldByName('Value').asString;
    end;
end;
{------------------------------------------------------------------------}
function gpInitialize_Const: Boolean;
begin
    Result:=false;

    with  DMMainScaleCehForm.spSelect do
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

         //Measure
         //Params.ParamByName('inSqlText').Value:='SELECT zc_Measure_Sh() :: TVarChar';
         //Execute;
         //zc_Measure_Sh:=DataSet.FieldByName('Value').asInteger;

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

         // DocumentKind
         // Взвешивание п/ф факт куттера
         Params.ParamByName('inSqlText').Value:='SELECT zc_Enum_DocumentKind_CuterWeight() :: TVarChar';
         Execute;
         zc_Enum_DocumentKind_CuterWeight:=DataSet.FieldByName('Value').asInteger;

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

         Params.ParamByName('inSqlText').Value:='SELECT zc_Object_Unit() :: TVarChar';
         Execute;
         zc_Object_Unit:=DataSet.FieldByName('Value').asInteger;

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

  //!!!захардкодили т.к. это программа ScaleCeh!!!
  SettingMain.isCeh:=TRUE;//AnsiUpperCase(ExtractFileName(ParamStr(0))) <> AnsiUpperCase('Scale.exe');

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

  SettingMain.DefaultCOMPort:=Ini.ReadInteger('Main','DefaultCehCOMPort',1);
  if SettingMain.DefaultCOMPort=1 then Ini.WriteInteger('Main','DefaultCehCOMPort',1);

  SettingMain.ScaleCount:=Ini.ReadInteger('Main','ScaleCehCount',1);
  if SettingMain.ScaleCount=1 then Ini.WriteInteger('Main','ScaleCehCount',1);

  ScaleList:=TStringList.Create;
  Ini.ReadSectionValues('TypeCeh_CommPort_Name',ScaleList);
  if ScaleList.Count=0 then
  begin
       for i:=1 to SettingMain.ScaleCount do
          Ini.WriteString('TypeCeh_CommPort_Name','Item'+IntToStr(i-1),' stDB : '  + IntToStr(i) + ' : ' + 'DB');
       Ini.ReadSectionValues('TypeCeh_CommPort_Name',ScaleList);
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
function gpInitialize_SettingMain_Default: Boolean;
begin
  SettingMain.isGoodsComplete:=GetArrayList_Value_byName(Default_Array,'isGoodsComplete') = AnsiUpperCase('TRUE');
  //
  if SettingMain.isCeh = TRUE then
  begin
       SettingMain.WeightSkewer1:=myStrToFloat(GetArrayList_Value_byName(Default_Array,'WeightSkewer1'));
       SettingMain.WeightSkewer2:=myStrToFloat(GetArrayList_Value_byName(Default_Array,'WeightSkewer2'));
  end;
  //
  Result:=true;
end;
{------------------------------------------------------------------------}
end.
