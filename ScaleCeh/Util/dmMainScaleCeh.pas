unit dmMainScaleCeh;

interface

uses
  System.SysUtils, System.Classes, dsdDB, Data.DB, Datasnap.DBClient, Vcl.Dialogs,UtilScale,
  dsdCommon;

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
    function gpUpdate_Scale_MovementDate(execParams:TParams): Boolean;

    // Scale + ScaleCeh
    function gpGet_Scale_Movement_checkId(var execParamsMovement:TParams): Boolean;
    function lpGet_BranchName(inBranchCode:Integer): String;
    // ScaleCeh
    function lpGet_UnitName(inUnitId:Integer): String;
    //
    // +++ScaleCeh+++
    function gpGet_ScaleCeh_Movement(var execParamsMovement:TParams;isLast,isNext:Boolean): Boolean;
    function gpGet_Scale_OrderExternal(var execParams:TParams;inBarCode:String; inFromId_calc, inToId_calc:Integer): Boolean;
    function gpGet_ScaleCeh_GoodsSeparate(inOperDate: TDateTime; inMovementId, inGoodsId : Integer; inPartionGoods : String;
                                          inIsClose : Boolean;
                                      var TotalCount_in, TotalCount_isOpen, TotalCount_null, TotalCount_MO, TotalCount_OB, TotalCount_PR, TotalCount_P : Double;
                                      var HeadCount_in, HeadCount_isOpen, HeadCount_null, HeadCount_MO, HeadCount_OB, HeadCount_PR, HeadCount_P : Double;
                                      var PartionGoods_null, PartionGoods_MO, PartionGoods_OB, PartionGoods_PR, PartionGoods_P : String
                                         ):Boolean;
    function gpInsert_ScaleCeh_GoodsSeparate(var retMovementId_begin, retMovementId : Integer;
                                             execParamsMovement:TParams;
                                             inOperDate: TDateTime;
                                             inFromId, inToId, inGoodsId, inStorageLineId : Integer; inPartionGoods : String;
                                             inAmount, inHeadCount : Double;
                                             inIsClose : Boolean
                                            ):Boolean;
    // +++ScaleCeh+++
    function gpInsertUpdate_ScaleCeh_Movement(var execParamsMovement:TParams): Boolean;
    function gpInsert_ScaleCeh_MI(var execParamsMovement:TParams;var execParamsMI:TParams): Boolean;
    function gpInsert_MovementCeh_all(var execParamsMovement:TParams): Boolean;
    function gpUpdate_ScaleCeh_Movement_ArticleLoss(execParams:TParams): Boolean;
    function gpUpdate_ScaleCeh_Movement_Status(execParams:TParams): Boolean;
    // Scale + ScaleCeh
    function gpUpdate_Scale_Movement_Status_2(MovementId_parent:Integer): Boolean;
    //
    function gpGet_Scale_Goods_gk(var execParams:TParams): Boolean;
    //
    //ScaleCeh
    function gpGet_ScaleCeh_Movement_checkPartion(var ValueStep_obv : Integer; MovementId,GoodsId:Integer;PartionGoods:String;OperCount:Double): Boolean;
    function gpGet_ScaleCeh_Movement_checkKVK (var ValueStep_kvk : Integer; MovementDescId, DocumentKindId, GoodsId : Integer; PartionGoodsDate : TDateTime) : Boolean;
    //ScaleCeh
    function gpGet_ScaleCeh_Movement_checkStorageLine(MovementId : Integer): String;
    //ScaleCeh - Light
    function gpGet_ScaleLight_Goods(var execParamsLight : TParams; inGoodsId, inGoodsKindId : Integer): Boolean;
    function gpGet_ScaleLight_BarCodeBox (num : Integer; execParamsLight : TParams):Boolean;

  end;

  function gpInitialize_Const: Boolean;//Scale + ScaleCeh
  function gpInitialize_Ini: Boolean;  //ScaleCeh
  function gpInitialize_SettingMain_Default: Boolean;//Scale + ScaleCeh

var
  DMMainScaleCehForm: TDMMainScaleCehForm;

implementation
uses Inifiles,TypInfo,UtilConst;
{$R *.dfm}
{------------------------------------------------------------------------}
procedure TDMMainScaleCehForm.DataModuleCreate(Sender: TObject);
begin
    //  gpInitialize_ParamsMovement;
    //
//!    Create_ParamsMovement(ParamsMovement);
    //
//!    gpGet_Scale_OperDate(ParamsMovement);
    //
    ///////Result:=
//!    DMMainScaleCehForm.gpGet_ScaleCeh_Movement(ParamsMovement,TRUE,FALSE);//isLast=TRUE,isNext=FALSE
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
function TDMMainScaleCehForm.gpGet_Scale_Goods_gk(var execParams:TParams): Boolean;
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
         ParamByName('NamePack').AsString := DataSet.FieldByName('GoodsKindName').AsString;
         ParamByName('WeightPack').AsFloat:= DataSet.FieldByName('WeightTare_gd').asFloat;
         ParamByName('Weight_gd').AsFloat := DataSet.FieldByName('Weight_gd').asFloat;
       end;

    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleCehForm.gpGet_ScaleCeh_Movement(var execParamsMovement:TParams;isLast,isNext:Boolean): Boolean;
begin
    Result:=false;

    if (SettingMain.isModeSorting = TRUE) // and (1=0)
    then
      with spSelect do begin
         StoredProcName:='gpGet_ScaleLight_Movement';
         OutputType:=otDataSet;
         Params.Clear;

         if (isNext = TRUE)or(isLast = FALSE)//так сложно, т.к. при isLast = FALSE надо обработать MovementId
         then Params.AddParam('inMovementId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementId').AsInteger)
         else Params.AddParam('inMovementId', ftInteger, ptInput, 0);
         Params.AddParam('inPlaceNumber', ftInteger, ptInput, SettingMain.PlaceNumber);
         Params.AddParam('inOperDate', ftDateTime, ptInput, execParamsMovement.ParamByName('OperDate').AsDateTime);
         Params.AddParam('inIsNext', ftBoolean, ptInput, isNext);
         Params.AddParam('inIs_test', ftBoolean, ptInput, true);

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
           ParamByName('FromId').AsInteger:= DataSet.FieldByName('FromId').asInteger;
           ParamByName('FromCode').AsInteger:= DataSet.FieldByName('FromCode').asInteger;
           ParamByName('FromName').asString:= DataSet.FieldByName('FromName').asString;
           ParamByName('ToId').AsInteger:= DataSet.FieldByName('ToId').asInteger;
           ParamByName('ToCode').AsInteger:= DataSet.FieldByName('ToCode').asInteger;
           ParamByName('ToName').asString:= DataSet.FieldByName('ToName').asString;

           // !!!ParamsLight!!!
           ParamsLight.ParamByName('GoodsId').AsInteger  := DataSet.FieldByName('GoodsId').asInteger;
           ParamsLight.ParamByName('GoodsCode').AsInteger:= DataSet.FieldByName('GoodsCode').asInteger;
           ParamsLight.ParamByName('GoodsName').asString := DataSet.FieldByName('GoodsName').asString;
           ParamsLight.ParamByName('GoodsKindId').AsInteger  := DataSet.FieldByName('GoodsKindId').AsInteger;
           ParamsLight.ParamByName('GoodsKindCode').AsInteger:= DataSet.FieldByName('GoodsKindCode').asInteger;
           ParamsLight.ParamByName('GoodsKindName').asString := DataSet.FieldByName('GoodsKindName').asString;

           ParamsLight.ParamByName('GoodsId_sh').AsInteger  := DataSet.FieldByName('GoodsId_sh').AsInteger;
           ParamsLight.ParamByName('GoodsCode_sh').AsInteger:= DataSet.FieldByName('GoodsCode_sh').asInteger;
           ParamsLight.ParamByName('GoodsName_sh').asString := DataSet.FieldByName('GoodsName_sh').asString;
           ParamsLight.ParamByName('GoodsKindId_sh').AsInteger  := DataSet.FieldByName('GoodsKindId_sh').AsInteger;
           ParamsLight.ParamByName('GoodsKindCode_sh').AsInteger:= DataSet.FieldByName('GoodsKindCode_sh').asInteger;
           ParamsLight.ParamByName('GoodsKindName_sh').asString := DataSet.FieldByName('GoodsKindName_sh').asString;

           ParamsLight.ParamByName('MeasureId').AsInteger  := DataSet.FieldByName('MeasureId').AsInteger;
           ParamsLight.ParamByName('MeasureCode').AsInteger:= DataSet.FieldByName('MeasureCode').asInteger;
           ParamsLight.ParamByName('MeasureName').asString := DataSet.FieldByName('MeasureName').asString;
           // Главное сообщение - сколько ящиков
           ParamsLight.ParamByName('Count_box').AsInteger:= DataSet.FieldByName('Count_box').AsInteger;
           // Id - есть ли ШТ.
           ParamsLight.ParamByName('GoodsTypeKindId_Sh').AsInteger := DataSet.FieldByName('GoodsTypeKindId_Sh').AsInteger;
           // Id - есть ли НОМ.
           ParamsLight.ParamByName('GoodsTypeKindId_Nom').AsInteger:= DataSet.FieldByName('GoodsTypeKindId_Nom').AsInteger;
           // Id - есть ли ВЕС
           ParamsLight.ParamByName('GoodsTypeKindId_Ves').AsInteger:= DataSet.FieldByName('GoodsTypeKindId_Ves').AsInteger;
           // Код ВМС
           ParamsLight.ParamByName('WmsCode_Sh').asString := DataSet.FieldByName('WmsCode_Sh').asString;
           ParamsLight.ParamByName('WmsCode_Nom').asString:= DataSet.FieldByName('WmsCode_Nom').asString;
           ParamsLight.ParamByName('WmsCode_Ves').asString:= DataSet.FieldByName('WmsCode_Ves').asString;
           // минимальный вес 1шт.
           ParamsLight.ParamByName('WeightMin').AsFloat:= DataSet.FieldByName('WeightMin').AsFloat;
           // максимальный вес 1шт.
           ParamsLight.ParamByName('WeightMax').AsFloat:= DataSet.FieldByName('WeightMax').AsFloat;

           // минимальный вес 1ед.
           ParamsLight.ParamByName('WeightMin_Sh').AsFloat := DataSet.FieldByName('WeightMin_Sh').AsFloat;
           ParamsLight.ParamByName('WeightMin_Nom').AsFloat:= DataSet.FieldByName('WeightMin_Nom').AsFloat;
           ParamsLight.ParamByName('WeightMin_Ves').AsFloat:= DataSet.FieldByName('WeightMin_Ves').AsFloat;
           // максимальный вес 1ед.
           ParamsLight.ParamByName('WeightMax_Sh').AsFloat := DataSet.FieldByName('WeightMax_Sh').AsFloat;
           ParamsLight.ParamByName('WeightMax_Nom').AsFloat:= DataSet.FieldByName('WeightMax_Nom').AsFloat;
           ParamsLight.ParamByName('WeightMax_Ves').AsFloat:= DataSet.FieldByName('WeightMax_Ves').AsFloat;

           //1-ая линия - Всегда этот цвет
           ParamsLight.ParamByName('GoodsTypeKindId_1').AsInteger := DataSet.FieldByName('GoodsTypeKindId_1').AsInteger;
           ParamsLight.ParamByName('BarCodeBoxId_1').AsInteger    := DataSet.FieldByName('BarCodeBoxId_1').AsInteger;
           ParamsLight.ParamByName('BoxCode_1').AsInteger         := DataSet.FieldByName('BoxCode_1').AsInteger;
           ParamsLight.ParamByName('BoxBarCode_1').AsString       := DataSet.FieldByName('BoxBarCode_1').AsString;
        // ParamsLight.ParamByName('WeightOnBoxTotal_1').asFloat  := 0; // Вес итого накопительный (в незакрытом ящике) - при достижении будет сброс
        // ParamsLight.ParamByName('CountOnBoxTotal_1').asFloat   := 0; // шт итого накопительно (в незакрытом ящике) - информативно?
        // ParamsLight.ParamByName('WeightTotal_1').asFloat       := 0; // Вес итого накопительный (в закрытых ящиках) - информативно
        // ParamsLight.ParamByName('CountTotal_1').asFloat        := 0; // шт итого накопительный (в закрытых ящиках) - информативно
        // ParamsLight.ParamByName('BoxTotal_1').asFloat          := 0; // ящиков итого (закрытых) - информативно

           ParamsLight.ParamByName('BoxId_1').AsInteger           := DataSet.FieldByName('BoxId_1').AsInteger;
           ParamsLight.ParamByName('BoxName_1').asString          := DataSet.FieldByName('BoxName_1').asString;
           ParamsLight.ParamByName('BoxWeight_1').asFloat         := DataSet.FieldByName('BoxWeight_1').asFloat;   // Вес самого ящика
           ParamsLight.ParamByName('WeightOnBox_1').asFloat       := DataSet.FieldByName('WeightOnBox_1').asFloat; // вложенность - Вес
           ParamsLight.ParamByName('CountOnBox_1').asFloat        := DataSet.FieldByName('CountOnBox_1').asFloat;  // Вложенность - шт (информативно?)
           ParamsLight.ParamByName('isFull_1').AsBoolean          := FALSE;

           //2-ая линия - Всегда этот цвет
           ParamsLight.ParamByName('GoodsTypeKindId_2').AsInteger := DataSet.FieldByName('GoodsTypeKindId_2').AsInteger;
           ParamsLight.ParamByName('BarCodeBoxId_2').AsInteger    := DataSet.FieldByName('BarCodeBoxId_2').AsInteger;
           ParamsLight.ParamByName('BoxCode_2').AsInteger         := DataSet.FieldByName('BoxCode_2').AsInteger;
           ParamsLight.ParamByName('BoxBarCode_2').AsString       := DataSet.FieldByName('BoxBarCode_2').AsString;
        // ParamsLight.ParamByName('WeightOnBoxTotal_2').asFloat  := 0; // Вес итого накопительный (в незакрытом ящике) - при достижении будет сброс
        // ParamsLight.ParamByName('CountOnBoxTotal_2').asFloat   := 0; // шт итого накопительно (в незакрытом ящике) - информативно?
        // ParamsLight.ParamByName('WeightTotal_2').asFloat       := 0; // Вес итого накопительный (в закрытых ящиках) - информативно
        // ParamsLight.ParamByName('CountTotal_2').asFloat        := 0; // шт итого накопительный (в закрытых ящиках) - информативно
        // ParamsLight.ParamByName('BoxTotal_2').asFloat          := 0; // ящиков итого (закрытых) - информативно
           ParamsLight.ParamByName('isFull_2').AsBoolean          := FALSE;

           ParamsLight.ParamByName('BoxId_2').AsInteger           := DataSet.FieldByName('BoxId_2').AsInteger;
           ParamsLight.ParamByName('BoxName_2').asString          := DataSet.FieldByName('BoxName_2').asString;
           ParamsLight.ParamByName('BoxWeight_2').asFloat         := DataSet.FieldByName('BoxWeight_2').asFloat;   // Вес самого ящика
           ParamsLight.ParamByName('WeightOnBox_2').asFloat       := DataSet.FieldByName('WeightOnBox_2').asFloat; // вложенность - Вес
           ParamsLight.ParamByName('CountOnBox_2').asFloat        := DataSet.FieldByName('CountOnBox_2').asFloat;  // Вложенность - шт (информативно?)

            //3-ья линия - Всегда этот цвет
           ParamsLight.ParamByName('GoodsTypeKindId_3').AsInteger := DataSet.FieldByName('GoodsTypeKindId_3').AsInteger;
           ParamsLight.ParamByName('BarCodeBoxId_3').AsInteger    := DataSet.FieldByName('BarCodeBoxId_3').AsInteger;
           ParamsLight.ParamByName('BoxCode_3').AsInteger         := DataSet.FieldByName('BoxCode_3').AsInteger;
           ParamsLight.ParamByName('BoxBarCode_3').AsString       := DataSet.FieldByName('BoxBarCode_3').AsString;
        // ParamsLight.ParamByName('WeightOnBoxTotal_3').asFloat  := 0; // Вес итого накопительный (в незакрытом ящике) - при достижении будет сброс
        // ParamsLight.ParamByName('CountOnBoxTotal_3').asFloat   := 0; // шт итого накопительно (в незакрытом ящике) - информативно?
        // ParamsLight.ParamByName('WeightTotal_3').asFloat       := 0; // Вес итого накопительный (в закрытых ящиках) - информативно
        // ParamsLight.ParamByName('CountTotal_3').asFloat        := 0; // шт итого накопительный (в закрытых ящиках) - информативно
        // ParamsLight.ParamByName('BoxTotal_3').asFloat          := 0; // ящиков итого (закрытых) - информативно
           ParamsLight.ParamByName('isFull_3').AsBoolean          := FALSE;

           ParamsLight.ParamByName('BoxId_3').AsInteger           := DataSet.FieldByName('BoxId_3').AsInteger;
           ParamsLight.ParamByName('BoxName_3').asString          := DataSet.FieldByName('BoxName_3').asString;
           ParamsLight.ParamByName('BoxWeight_3').asFloat         := DataSet.FieldByName('BoxWeight_3').asFloat;   // Вес самого ящика
           ParamsLight.ParamByName('WeightOnBox_3').asFloat       := DataSet.FieldByName('WeightOnBox_3').asFloat; // вложенность - Вес
           ParamsLight.ParamByName('CountOnBox_3').asFloat        := DataSet.FieldByName('CountOnBox_3').asFloat;  // Вложенность - шт (информативно?)

         end;
      end
    else
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
         Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);

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
           ParamByName('isSticker_Ceh').asBoolean:= DataSet.FieldByName('isSticker_Ceh').asBoolean;
           ParamByName('isSticker_KVK').asBoolean:= DataSet.FieldByName('isSticker_KVK').asBoolean;

           ParamByName('MovementDescId').AsInteger:= DataSet.FieldByName('MovementDescId').asInteger;
           ParamByName('FromId').AsInteger:= DataSet.FieldByName('FromId').asInteger;
           ParamByName('FromCode').AsInteger:= DataSet.FieldByName('FromCode').asInteger;
           ParamByName('FromName').asString:= DataSet.FieldByName('FromName').asString;
           ParamByName('ToId').AsInteger:= DataSet.FieldByName('ToId').asInteger;
           ParamByName('ToCode').AsInteger:= DataSet.FieldByName('ToCode').asInteger;
           ParamByName('ToName').asString:= DataSet.FieldByName('ToName').asString;

           ParamByName('SubjectDocId').AsInteger   := DataSet.FieldByName('SubjectDocId').asInteger;
           ParamByName('SubjectDocCode').AsInteger := DataSet.FieldByName('SubjectDocCode').asInteger;
           ParamByName('SubjectDocName').asString  := DataSet.FieldByName('SubjectDocName').asString;
           ParamByName('DocumentComment').asString := DataSet.FieldByName('Comment').asString;

           ParamByName('PersonalGroupId').AsInteger   := DataSet.FieldByName('PersonalGroupId').asInteger;
           ParamByName('PersonalGroupCode').AsInteger := DataSet.FieldByName('PersonalGroupCode').asInteger;
           ParamByName('PersonalGroupName').asString  := DataSet.FieldByName('PersonalGroupName').asString;

           ParamByName('OrderExternalId').AsInteger        := DataSet.FieldByName('MovementId_Order').asInteger;
           ParamByName('OrderExternal_DescId').AsInteger   := DataSet.FieldByName('MovementDescId_Order').asInteger;
           ParamByName('OrderExternal_InvNumber').asString := DataSet.FieldByName('InvNumber_Order').asString;
           ParamByName('OrderExternalName_master').asString:= DataSet.FieldByName('OrderExternalName_master').asString;

           ParamByName('isKVK').asBoolean:= DataSet.FieldByName('isKVK').asBoolean;
           ParamByName('isAsset').asBoolean:= DataSet.FieldByName('isAsset').asBoolean;
           ParamByName('isPartionCell').asBoolean:= DataSet.FieldByName('isPartionCell').asBoolean;
           ParamByName('isPartionPassport').asBoolean:= DataSet.FieldByName('isPartionPassport').asBoolean;

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
function TDMMainScaleCehForm.gpGet_Scale_OrderExternal(var execParams:TParams;inBarCode: String; inFromId_calc, inToId_calc : Integer): Boolean;
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
       //ParamByName('PaidKindId').AsInteger:= DataSet.FieldByName('PaidKindId').asInteger;
       //ParamByName('PaidKindName').asString:= DataSet.FieldByName('PaidKindName').asString;

         //определяется только для zc_Movement_SendOnPrice + zc_Movement_Loss + zc_Movement_Income
         if  (DataSet.FieldByName('MovementDescId').asInteger = zc_Movement_SendOnPrice)
           or(DataSet.FieldByName('MovementDescId').asInteger = zc_Movement_Loss)
           or(DataSet.FieldByName('MovementDescId').asInteger = zc_Movement_Income)
           or(DataSet.FieldByName('MovementDescId').asInteger = zc_Movement_Send)
           or(DataSet.FieldByName('MovementDescId').asInteger = zc_Movement_ReturnIn)
         then ParamByName('MovementDescNumber').AsInteger:= DataSet.FieldByName('MovementDescNumber').asInteger;

       //ParamByName('calcPartnerId').AsInteger:= DataSet.FieldByName('PartnerId_calc').AsInteger;
       //ParamByName('calcPartnerCode').AsInteger:= DataSet.FieldByName('PartnerCode_calc').AsInteger;
       //ParamByName('calcPartnerName').asString:= DataSet.FieldByName('PartnerName_calc').asString;
       //ParamByName('ChangePercent').asFloat:= DataSet.FieldByName('ChangePercent').asFloat;
       //ParamByName('ChangePercentAmount').asFloat:= DataSet.FieldByName('ChangePercentAmount').asFloat;

       //ParamByName('isEdiOrdspr').asBoolean:= DataSet.FieldByName('isEdiOrdspr').asBoolean;
       //ParamByName('isEdiInvoice').asBoolean:= DataSet.FieldByName('isEdiInvoice').asBoolean;
       //ParamByName('isEdiDesadv').asBoolean:= DataSet.FieldByName('isEdiDesadv').asBoolean;

       //ParamByName('isMovement').asBoolean:= DataSet.FieldByName('isMovement').asBoolean;
       //ParamByName('isAccount').asBoolean:= DataSet.FieldByName('isAccount').asBoolean;
       //ParamByName('isTransport').asBoolean:= DataSet.FieldByName('isTransport').asBoolean;
       //ParamByName('isQuality').asBoolean:= DataSet.FieldByName('isQuality').asBoolean;
       //ParamByName('isPack').asBoolean:= DataSet.FieldByName('isPack').asBoolean;
       //ParamByName('isSpec').asBoolean:= DataSet.FieldByName('isSpec').asBoolean;
       //ParamByName('isTax').asBoolean:= DataSet.FieldByName('isTax').asBoolean;

         ParamByName('OrderExternalId').AsInteger:= DataSet.FieldByName('MovementId').asInteger;
         ParamByName('OrderExternal_DescId').AsInteger:= DataSet.FieldByName('MovementDescId_order').asInteger;
         ParamByName('OrderExternal_BarCode').asString:= DataSet.FieldByName('BarCode').asString;
         ParamByName('OrderExternal_InvNumber').asString:= DataSet.FieldByName('InvNumber').asString;
         ParamByName('OrderExternalName_master').asString:= DataSet.FieldByName('OrderExternalName_master').asString;

       //ParamByName('ContractId').AsInteger    := DataSet.FieldByName('ContractId').asInteger;
       //ParamByName('ContractCode').AsInteger  := DataSet.FieldByName('ContractCode').asInteger;
       //ParamByName('ContractNumber').asString := DataSet.FieldByName('ContractNumber').asString;
       //ParamByName('ContractTagName').asString:= DataSet.FieldByName('ContractTagName').asString;

       //ParamByName('GoodsPropertyId').AsInteger:= DataSet.FieldByName('GoodsPropertyId').AsInteger;
       //ParamByName('GoodsPropertyCode').AsInteger:= DataSet.FieldByName('GoodsPropertyCode').AsInteger;
       //ParamByName('GoodsPropertyName').asString:= DataSet.FieldByName('GoodsPropertyName').asString;

       //ParamByName('PriceListId').AsInteger   := DataSet.FieldByName('PriceListId').asInteger;
       //ParamByName('PriceListCode').AsInteger := DataSet.FieldByName('PriceListCode').asInteger;
       //ParamByName('PriceListName').asString  := DataSet.FieldByName('PriceListName').asString;
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
function TDMMainScaleCehForm.gpGet_ScaleCeh_Movement_checkPartion(var ValueStep_obv : Integer; MovementId,GoodsId:Integer;PartionGoods:String;OperCount:Double): Boolean;
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
       Params.AddParam('inValueStep', ftInteger, ptInput, ValueStep_obv);
       //try
         Execute;
         Result:=(DataSet.FieldByName('Code').asInteger = 0) or (DataSet.FieldByName('ValueStep').asInteger > 2);
         if DataSet.FieldByName('ValueStep').asInteger > 0 then ValueStep_obv:= DataSet.FieldByName('ValueStep').asInteger;
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
        then if ValueStep_obv > 0
             then ShowMessage('('+IntToStr(ValueStep_obv)+') ' + spSelect.DataSet.FieldByName('MessageStr').AsString)
             else ShowMessage(spSelect.DataSet.FieldByName('MessageStr').AsString)
        else Result:=MessageDlg(spSelect.DataSet.FieldByName('MessageStr').AsString,mtConfirmation,mbYesNoCancel,0) = 6;
end;
{------------------------------------------------------------------------}
function TDMMainScaleCehForm.gpGet_ScaleCeh_Movement_checkKVK (var ValueStep_kvk : Integer; MovementDescId, DocumentKindId, GoodsId : Integer; PartionGoodsDate : TDateTime) : Boolean;
begin
    Result:= (MovementDescId = zc_Movement_ProductionUnion);
    if not Result then exit;
    //
    //Result:= DocumentKindId > 0;
    //if Result then exit;
    //
    with spSelect do begin
       StoredProcName:='gpGet_ScaleCeh_Movement_checkKVK';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inMovementDescId', ftInteger, ptInput, MovementDescId);
       Params.AddParam('inDocumentKindId', ftInteger, ptInput, DocumentKindId);
       Params.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
       Params.AddParam('inPartionGoodsDate', ftDateTime, ptInput, PartionGoodsDate);
       Params.AddParam('inBranchCode',ftInteger, ptInput, SettingMain.BranchCode);
       Params.AddParam('inValueStep', ftInteger, ptInput, ValueStep_kvk);
       //try
         Execute;
         Result:=(DataSet.FieldByName('isCheck').asBoolean = TRUE);
         ValueStep_kvk:= ValueStep_kvk + 1;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpGet_ScaleCeh_Movement_checkKVK');
       end;}
    end;
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
function TDMMainScaleCehForm.gpUpdate_Scale_MovementDate(execParams:TParams): Boolean;
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
function TDMMainScaleCehForm.gpUpdate_ScaleCeh_Movement_ArticleLoss(execParams:TParams): Boolean;
begin
    Result:=false;
    with spSelect do begin
       StoredProcName:='gpUpdate_ScaleCeh_Movement_ArticleLoss';
       OutputType:=otResult;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInput, execParams.ParamByName('MovementId').AsInteger);
       Params.AddParam('inArticleLossId', ftInteger, ptInput, execParams.ParamByName('ArticleLossId').AsInteger);
       //try
         Execute;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpUpdate_ScaleCeh_Movement_ArticleLoss');
       end;}
    end;
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleCehForm.gpUpdate_ScaleCeh_Movement_Status(execParams:TParams): Boolean;
begin
    Result:=false;
    with spSelect do begin
       StoredProcName:='gpUpdate_ScaleCeh_Movement_Status';
       OutputType:=otResult;
       Params.Clear;
       Params.AddParam('inMovementId', ftInteger, ptInput, execParams.ParamByName('MovementId').AsInteger);
       Params.AddParam('inStatusId', ftInteger, ptInput, execParams.ParamByName('StatusId').AsInteger);
       Params.AddParam('inBranchCode',ftInteger, ptInput, SettingMain.BranchCode);
       //try
         Execute;
       {except
         Result := '';
         ShowMessage('Ошибка получения - gpUpdate_ScaleCeh_Movement_ArticleLoss');
       end;}
    end;
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleCehForm.gpUpdate_Scale_Movement_Status_2(MovementId_parent:Integer): Boolean;
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
function TDMMainScaleCehForm.gpInsert_MovementCeh_all(var execParamsMovement:TParams): Boolean;
begin
    Result:=false;
    if SettingMain.isModeSorting = TRUE
    then
       with spSelect do begin
           StoredProcName:='gpInsert_ScaleLight_Movement_all';
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
        end
      else
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
    if SettingMain.isModeSorting = TRUE
    then
      with spSelect do begin
         StoredProcName:='gpInsertUpdate_ScaleLight_Movement';
         OutputType:=otDataSet;
         Params.Clear;
         Params.AddParam('inId', ftInteger, ptInputOutput, execParamsMovement.ParamByName('MovementId').AsInteger);
         Params.AddParam('inOperDate', ftDateTime, ptInput, execParamsMovement.ParamByName('OperDate').AsDateTime);
         Params.AddParam('inMovementDescId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementDescId').AsInteger);
         Params.AddParam('inMovementDescNumber', ftInteger, ptInput, execParamsMovement.ParamByName('MovementDescNumber').AsInteger);
         Params.AddParam('inFromId', ftInteger, ptInput, execParamsMovement.ParamByName('FromId').AsInteger);
         Params.AddParam('inToId', ftInteger, ptInput, execParamsMovement.ParamByName('ToId').AsInteger);
         Params.AddParam('inGoodsTypeKindId_1', ftInteger, ptInput, ParamsLight.ParamByName('GoodsTypeKindId_1').AsInteger);
         Params.AddParam('inGoodsTypeKindId_2', ftInteger, ptInput, ParamsLight.ParamByName('GoodsTypeKindId_2').AsInteger);
         Params.AddParam('inGoodsTypeKindId_3', ftInteger, ptInput, ParamsLight.ParamByName('GoodsTypeKindId_3').AsInteger);
         Params.AddParam('inBarCodeBoxId_1', ftInteger, ptInput, ParamsLight.ParamByName('BarCodeBoxId_1').AsInteger);
         Params.AddParam('inBarCodeBoxId_2', ftInteger, ptInput, ParamsLight.ParamByName('BarCodeBoxId_2').AsInteger);
         Params.AddParam('inBarCodeBoxId_3', ftInteger, ptInput, ParamsLight.ParamByName('BarCodeBoxId_3').AsInteger);
         Params.AddParam('inGoodsId', ftInteger, ptInput, ParamsLight.ParamByName('GoodsId').AsInteger);
         Params.AddParam('inGoodsKindId', ftInteger, ptInput, ParamsLight.ParamByName('GoodsKindId').AsInteger);
         Params.AddParam('inGoodsId_sh', ftInteger, ptInput, ParamsLight.ParamByName('GoodsId_sh').AsInteger);
         Params.AddParam('inGoodsKindId_sh', ftInteger, ptInput, ParamsLight.ParamByName('GoodsKindId_sh').AsInteger);
         Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
         Params.AddParam('inPlaceNumber', ftInteger, ptInput, SettingMain.PlaceNumber);
         //try
           Execute;
           execParamsMovement.ParamByName('MovementId').AsInteger:=DataSet.FieldByName('Id').asInteger;
           execParamsMovement.ParamByName('InvNumber').AsString:=DataSet.FieldByName('InvNumber').AsString;
           execParamsMovement.ParamByName('OperDate_Movement').AsString:=DataSet.FieldByName('OperDate').AsString;
         {except
           Result := '';
           ShowMessage('Ошибка получения - gpInsertUpdate_ScaleCeh_Movement');
         end;}
      end
    else
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
         Params.AddParam('inSubjectDocId', ftInteger, ptInput, execParamsMovement.ParamByName('SubjectDocId').AsInteger);
         if execParamsMovement.ParamByName('isPersonalGroup').AsBoolean = true
         then Params.AddParam('inPersonalGroupId', ftInteger, ptInput, execParamsMovement.ParamByName('PersonalGroupId').AsInteger)
         else Params.AddParam('inPersonalGroupId', ftInteger, ptInput, 0);
         Params.AddParam('inMovementId_Order', ftInteger, ptInput, execParamsMovement.ParamByName('OrderExternalId').AsInteger);
         Params.AddParam('inIsProductionIn', ftBoolean, ptInput, execParamsMovement.ParamByName('isSendOnPriceIn').AsBoolean);
         Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
         Params.AddParam('inComment', ftString, ptInput, execParamsMovement.ParamByName('DocumentComment').AsString);
         Params.AddParam('inIsListInventory', ftBoolean, ptInput, execParamsMovement.ParamByName('isListInventory').AsBoolean);
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
    if Result
    then
      if SettingMain.isModeSorting = TRUE
      then
        with spSelect do begin
           StoredProcName:='gpInsert_ScaleLight_MI';
           OutputType:=otDataSet;
           Params.Clear;
           Params.AddParam('inId', ftInteger, ptInput, 0);
           Params.AddParam('inMovementId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementId').AsInteger);
           Params.AddParam('inGoodsId', ftInteger, ptInput, ParamsLight.ParamByName('GoodsId').AsInteger);
           Params.AddParam('inGoodsKindId', ftInteger, ptInput, ParamsLight.ParamByName('GoodsKindId').AsInteger);
           Params.AddParam('inGoodsId_sh', ftInteger, ptInput, ParamsLight.ParamByName('GoodsId_sh').AsInteger);
           Params.AddParam('inGoodsKindId_sh', ftInteger, ptInput, ParamsLight.ParamByName('GoodsKindId_sh').AsInteger);
           Params.AddParam('inMeasureId', ftInteger, ptInput, ParamsLight.ParamByName('MeasureId').AsInteger);

           Params.AddParam('inWmsCode_Sh',  ftString, ptInput, ParamsLight.ParamByName('WmsCode_Sh').AsString);
           Params.AddParam('inWmsCode_Nom', ftString, ptInput, ParamsLight.ParamByName('WmsCode_Nom').AsString);
           Params.AddParam('inWmsCode_Ves', ftString, ptInput, ParamsLight.ParamByName('WmsCode_Ves').AsString);
           // Id - есть ли ШТ.
           Params.AddParam('inGoodsTypeKindId_Sh', ftInteger, ptInput, ParamsLight.ParamByName('GoodsTypeKindId_Sh').AsInteger);
           // Id - есть ли НОМ.
           Params.AddParam('inGoodsTypeKindId_Nom', ftInteger, ptInput, ParamsLight.ParamByName('GoodsTypeKindId_Nom').AsInteger);
           // Id - есть ли ВЕС
           Params.AddParam('inGoodsTypeKindId_Ves', ftInteger, ptInput, ParamsLight.ParamByName('GoodsTypeKindId_Ves').AsInteger);

           //1-ая линия - Всегда этот цвет
           Params.AddParam('inGoodsTypeKindId_1', ftInteger, ptInput, ParamsLight.ParamByName('GoodsTypeKindId_1').AsInteger);
           Params.AddParam('inBarCodeBoxId_1', ftInteger, ptInput, ParamsLight.ParamByName('BarCodeBoxId_1').AsInteger);
           if SettingMain.isLightLEFT_123 = TRUE
           then Params.AddParam('inLineCode_1', ftInteger, ptInput, 1)
           else Params.AddParam('inLineCode_1', ftInteger, ptInput, 3);
           // вложенность - Вес
           Params.AddParam('inWeightOnBox_1', ftFloat, ptInput, ParamsLight.ParamByName('WeightOnBox_1').asFloat);
           // Вложенность - шт (информативно?)
           Params.AddParam('inCountOnBox_1', ftFloat, ptInput, ParamsLight.ParamByName('CountOnBox_1').asFloat);

           //2-ая линия - Всегда этот цвет
           Params.AddParam('inGoodsTypeKindId_2', ftInteger, ptInput, ParamsLight.ParamByName('GoodsTypeKindId_2').AsInteger);
           Params.AddParam('inBarCodeBoxId_2', ftInteger, ptInput, ParamsLight.ParamByName('BarCodeBoxId_2').AsInteger);
           Params.AddParam('inLineCode_2', ftInteger, ptInput, 2);
           // вложенность - Вес
           Params.AddParam('inWeightOnBox_2', ftFloat, ptInput, ParamsLight.ParamByName('WeightOnBox_2').asFloat);
           // Вложенность - шт (информативно?)
           Params.AddParam('inCountOnBox_2', ftFloat, ptInput, ParamsLight.ParamByName('CountOnBox_2').asFloat);

            //3-ья линия - Всегда этот цвет
           Params.AddParam('inGoodsTypeKindId_3', ftInteger, ptInput, ParamsLight.ParamByName('GoodsTypeKindId_3').AsInteger);
           Params.AddParam('inBarCodeBoxId_3', ftInteger, ptInput, ParamsLight.ParamByName('BarCodeBoxId_3').AsInteger);
           if SettingMain.isLightLEFT_123 = TRUE
           then Params.AddParam('inLineCode_3', ftInteger, ptInput, 3)
           else Params.AddParam('inLineCode_3', ftInteger, ptInput, 1);
           // вложенность - Вес
           Params.AddParam('inWeightOnBox_3', ftFloat, ptInput, ParamsLight.ParamByName('WeightOnBox_3').asFloat);
           // Вложенность - шт (информативно?)
           Params.AddParam('inCountOnBox_3', ftFloat, ptInput, ParamsLight.ParamByName('CountOnBox_3').asFloat);

           // минимальный вес 1ед.
           Params.AddParam('inWeightMin', ftFloat, ptInput, ParamsLight.ParamByName('WeightMin').AsFloat);
           // максимальный вес 1ед.
           Params.AddParam('inWeightMax', ftFloat, ptInput, ParamsLight.ParamByName('WeightMax').AsFloat);

           // минимальный вес 1ед.
           Params.AddParam('inWeightMin_Sh', ftFloat, ptInput, ParamsLight.ParamByName('WeightMin_Sh').AsFloat);
           Params.AddParam('inWeightMin_Nom', ftFloat, ptInput, ParamsLight.ParamByName('WeightMin_Nom').AsFloat);
           Params.AddParam('inWeightMin_Ves', ftFloat, ptInput, ParamsLight.ParamByName('WeightMin_Ves').AsFloat);
           // максимальный вес 1ед.
           Params.AddParam('inWeightMax_Sh', ftFloat, ptInput, ParamsLight.ParamByName('WeightMax_Sh').AsFloat);
           Params.AddParam('inWeightMax_Nom', ftFloat, ptInput, ParamsLight.ParamByName('WeightMax_Nom').AsFloat);
           Params.AddParam('inWeightMax_Ves', ftFloat, ptInput, ParamsLight.ParamByName('WeightMax_Ves').AsFloat);

           Params.AddParam('inAmount', ftFloat, ptInput, 1);
           Params.AddParam('inRealWeight', ftFloat, ptInput, execParamsMI.ParamByName('RealWeight').AsFloat);
           Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
           //
           Params.AddParam('inIsErrSave', ftBoolean, ptInput, ParamsLight.ParamByName('isErrSave').AsBoolean);


           //try
             Result:= false;
             Execute;
             Result:= true;
           {except
             Result := '';
             ShowMessage('Ошибка получения - gpInsert_ScaleCeh_MI');
           end;}
           //
           // вернули Id строки
           ParamsLight.ParamByName('MovementItemId').asInteger:= DataSet.FieldByName('Id').asInteger;
           // вернули если была ошибка
           ParamsLight.ParamByName('ResultText').asString:= DataSet.FieldByName('ResultText').asString;
           // вернули какой наполнен
           ParamsLight.ParamByName('isFull_1').asBoolean:= DataSet.FieldByName('isFull_1').asBoolean;
           ParamsLight.ParamByName('isFull_2').asBoolean:= DataSet.FieldByName('isFull_2').asBoolean;
           ParamsLight.ParamByName('isFull_3').asBoolean:= DataSet.FieldByName('isFull_3').asBoolean;
           // вернули № линии, что б подсветить
           if (SettingMain.isLightLEFT_123 = false) and (DataSet.FieldByName('LineCode').asInteger = 3)
           then ParamsLight.ParamByName('LineCode_begin').asInteger:= 1
           else if (SettingMain.isLightLEFT_123 = false) and (DataSet.FieldByName('LineCode').asInteger = 1)
           then ParamsLight.ParamByName('LineCode_begin').asInteger:= 3
           else ParamsLight.ParamByName('LineCode_begin').asInteger:=DataSet.FieldByName('LineCode').asInteger;
           //
           // если заполнился ящик_1, надо будет спросить для него НОВЫЙ
           if ParamsLight.ParamByName('isFull_1').asBoolean = TRUE then
           begin
             ParamsLight.ParamByName('BarCodeBoxId_1').AsInteger    := 0;
             ParamsLight.ParamByName('BoxCode_1').AsInteger         := 0;
             ParamsLight.ParamByName('BoxBarCode_1').AsString       := '';
             // Вес итого накопительный (в незакрытом ящике) - при достижении будет сброс
             ParamsLight.ParamByName('WeightOnBoxTotal_1').AsFloat:= DataSet.FieldByName('WeightOnBox').AsFloat;
             // шт итого накопительно (в незакрытом ящике) - информативно?
             ParamsLight.ParamByName('CountOnBoxTotal_1').AsFloat := DataSet.FieldByName('CountOnBox').AsFloat;
           end;
           // если заполнился ящик_2, надо будет спросить для него НОВЫЙ
           if ParamsLight.ParamByName('isFull_2').asBoolean = TRUE then
           begin
             ParamsLight.ParamByName('BarCodeBoxId_2').AsInteger    := 0;
             ParamsLight.ParamByName('BoxCode_2').AsInteger         := 0;
             ParamsLight.ParamByName('BoxBarCode_2').AsString       := '';
             // Вес итого накопительный (в незакрытом ящике) - при достижении будет сброс
             ParamsLight.ParamByName('WeightOnBoxTotal_2').AsFloat:= DataSet.FieldByName('WeightOnBox').AsFloat;
             // шт итого накопительно (в незакрытом ящике) - информативно?
             ParamsLight.ParamByName('CountOnBoxTotal_2').AsFloat := DataSet.FieldByName('CountOnBox').AsFloat;
           end;
           // если заполнился ящик_3, надо будет спросить для него НОВЫЙ
           if ParamsLight.ParamByName('isFull_3').asBoolean = TRUE then
           begin
             ParamsLight.ParamByName('BarCodeBoxId_3').AsInteger    := 0;
             ParamsLight.ParamByName('BoxCode_3').AsInteger         := 0;
             ParamsLight.ParamByName('BoxBarCode_3').AsString       := '';
             // Вес итого накопительный (в незакрытом ящике) - при достижении будет сброс
             ParamsLight.ParamByName('WeightOnBoxTotal_3').AsFloat:= DataSet.FieldByName('WeightOnBox').AsFloat;
             // шт итого накопительно (в незакрытом ящике) - информативно?
             ParamsLight.ParamByName('CountOnBoxTotal_3').AsFloat := DataSet.FieldByName('CountOnBox').AsFloat;
           end;

        end
      else
        with spSelect do begin
           StoredProcName:='gpInsert_ScaleCeh_MI';
           OutputType:=otDataSet;
           Params.Clear;
           Params.AddParam('inId', ftInteger, ptInput, 0);
           Params.AddParam('inMovementId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementId').AsInteger);
           Params.AddParam('inGoodsId', ftInteger, ptInput, execParamsMI.ParamByName('GoodsId').AsInteger);
           Params.AddParam('inGoodsKindId', ftInteger, ptInput, execParamsMI.ParamByName('GoodsKindId').AsInteger);
           Params.AddParam('inStorageLineId', ftInteger, ptInput, execParamsMI.ParamByName('StorageLineId').AsInteger);
           Params.AddParam('inPersonalId_KVK', ftInteger, ptInput, execParamsMovement.ParamByName('PersonalId_KVK').AsInteger);
           Params.AddParam('inAssetId', ftInteger, ptInput, execParamsMovement.ParamByName('AssetId').AsInteger);
           Params.AddParam('inAssetId_two', ftInteger, ptInput, execParamsMovement.ParamByName('AssetId_two').AsInteger);
           Params.AddParam('inIsStartWeighing', ftBoolean, ptInput, execParamsMI.ParamByName('isStartWeighing').AsBoolean);
           Params.AddParam('inIsPartionGoodsDate', ftBoolean, ptInput, execParamsMovement.ParamByName('isPartionGoodsDate').AsBoolean);
           Params.AddParam('inIsAsset', ftBoolean, ptInput, execParamsMovement.ParamByName('isAsset').AsBoolean);
           Params.AddParam('inOperCount', ftFloat, ptInput, execParamsMI.ParamByName('OperCount').AsFloat);

           if (execParamsMI.ParamByName('MeasureId').AsInteger = zc_Measure_Sh)
           and(execParamsMovement.ParamByName('isCalc_Sh').AsBoolean = TRUE)
           and(execParamsMI.ParamByName('RealWeight_Get').AsFloat > 0)
           then Params.AddParam('inRealWeight', ftFloat, ptInput, execParamsMI.ParamByName('RealWeight_Get').AsFloat)
           else Params.AddParam('inRealWeight', ftFloat, ptInput, execParamsMI.ParamByName('RealWeight').AsFloat);

           Params.AddParam('inWeightTare', ftFloat, ptInput, execParamsMI.ParamByName('WeightTare').AsFloat);
           Params.AddParam('inLiveWeight', ftFloat, ptInput, execParamsMI.ParamByName('LiveWeight').AsFloat);
           Params.AddParam('inHeadCount', ftFloat, ptInput, execParamsMI.ParamByName('HeadCount').AsFloat);
           Params.AddParam('inCount', ftFloat, ptInput, execParamsMI.ParamByName('Count').AsFloat);
           //Количество упаковок
           Params.AddParam('inCountPack', ftFloat, ptInput, execParamsMI.ParamByName('CountPack').AsFloat);
           //Вес 1-ой упаковки
           Params.AddParam('inWeightPack', ftFloat, ptInput, execParamsMI.ParamByName('WeightPack').AsFloat);
           //
           Params.AddParam('inCountSkewer1', ftFloat, ptInput, execParamsMI.ParamByName('CountSkewer1').AsFloat);
           Params.AddParam('inWeightSkewer1', ftFloat, ptInput, SettingMain.WeightSkewer1);
           Params.AddParam('inCountSkewer2', ftFloat, ptInput, execParamsMI.ParamByName('CountSkewer2').AsFloat);
           Params.AddParam('inWeightSkewer2', ftFloat, ptInput, SettingMain.WeightSkewer2);
           Params.AddParam('inWeightOther', ftFloat, ptInput, execParamsMI.ParamByName('WeightOther').AsFloat);

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

           Params.AddParam('inPartionGoodsDate', ftDateTime, ptInput, execParamsMI.ParamByName('PartionGoodsDate').AsDateTime);
           Params.AddParam('inPartionGoods', ftString, ptInput, execParamsMI.ParamByName('PartionGoods').AsString);
           Params.AddParam('inNumberKVK', ftString, ptInput, execParamsMovement.ParamByName('NumberKVK').AsString);
           Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
           //try
             Execute;
           {except
             Result := '';
             ShowMessage('Ошибка получения - gpInsert_ScaleCeh_MI');
           end;}

           // вернули Id строки
           execParamsMI.ParamByName('MovementItemId').asInteger:= DataSet.FieldByName('Id').asInteger;

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
       Params.AddParam('inIsModeSorting', ftBoolean, ptInput, SettingMain.isModeSorting);
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
         exit;
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
       //Params.AddParam('inMovementDescId', ftInteger, ptInput, ParamsMovement.ParamByName('MovementDescId').AsInteger);
       //Params.AddParam('inWeight_gd', ftFloat, ptInput, execParams.ParamByName('Weight_gd').AsFloat);
       //Params.AddParam('inMeasureId', ftInteger, ptInput, execParams.ParamByName('MeasureId').AsInteger);
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
         end
         else
         begin
              // только для программы ScaleCeh
              ParamByName('MeasureId').AsInteger  := DataSet.FieldByName('MeasureId').asInteger;
              ParamByName('MeasureCode').AsInteger:= DataSet.FieldByName('MeasureCode').AsInteger;
              ParamByName('MeasureName').asString := DataSet.FieldByName('MeasureName').asString;

              // только для программы ScaleCeh
              ParamByName('Weight_gd').AsFloat        := DataSet.FieldByName('Weight_gd').AsFloat;
              ParamByName('WeightTare_gd').AsFloat    := DataSet.FieldByName('WeightTare_gd').AsFloat;
              ParamByName('CountForWeight_gd').AsFloat:= DataSet.FieldByName('CountForWeight_gd').AsFloat;
              ParamByName('WeightPackageSticker_gd').AsFloat:= DataSet.FieldByName('WeightPackageSticker_gd').AsFloat;

              // Схема - втулки - перевод из веса - только для программы ScaleCeh
              if (ParamByName('MeasureId').AsInteger <> zc_Measure_Kg)
              and(ParamByName('MeasureId').AsInteger <> zc_Measure_Sh)
//              and(ParamByName('MeasureId').AsInteger <> zc_Measure_Kgg)
              and(ParamByName('Weight_gd').AsFloat   > 0)
              {and((SettingMain.BranchCode = 1)
                or(SettingMain.BranchCode = 102)
                or(SettingMain.BranchCode = 103)}
              and((ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_Inventory)
                or(ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_Send)
                 )
              then ParamByName('isWeight_gd').AsBoolean := true
             //else ParamByName('isWeight_gd').AsBoolean := false;
              else ParamByName('isWeight_gd').AsBoolean := false;

              // только для программы ScaleCeh - всегда ввод кол-ва - надо для тары
              ParamByName('isEnterCount').asBoolean     := DataSet.FieldByName('isEnterCount').asBoolean;

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
function TDMMainScaleCehForm.gpGet_ScaleLight_BarCodeBox (num : Integer; execParamsLight : TParams):Boolean;
begin
    with spSelect do begin
       StoredProcName:='gpGet_ScaleLight_BarCodeBox';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inGoodsId', ftInteger, ptInput, execParamsLight.ParamByName('GoodsId').AsInteger);
       Params.AddParam('inGoodsKindId', ftInteger, ptInput, execParamsLight.ParamByName('GoodsKindId').AsInteger);
       if num = 1 then
       begin
           Params.AddParam('inBoxId',      ftInteger, ptInput, execParamsLight.ParamByName('BoxId_1').AsInteger);
           Params.AddParam('inBoxBarCode', ftString,  ptInput, execParamsLight.ParamByName('BoxBarCode_1').AsString);
       end
       else
         if num = 2 then
         begin
             Params.AddParam('inBoxId',      ftInteger, ptInput, execParamsLight.ParamByName('BoxId_2').AsInteger);
             Params.AddParam('inBoxBarCode', ftString,  ptInput, execParamsLight.ParamByName('BoxBarCode_2').AsString);
         end
         else
           if num = 3 then
           begin
               Params.AddParam('inBoxId',      ftInteger, ptInput, execParamsLight.ParamByName('BoxId_3').AsInteger);
               Params.AddParam('inBoxBarCode', ftString,  ptInput, execParamsLight.ParamByName('BoxBarCode_3').AsString);
           end;
       //
       try
         Result:= false;
         Execute;
         Result:= true;
       except
           on E: Exception do
             if pos('context', AnsilowerCase(E.Message)) = 0 then
               ShowMessage(E.Message)
             else
               // Выбрасываем все что после Context
               ShowMessage(Copy(E.Message, 1, pos('context', AnsilowerCase(E.Message)) - 1));
       end;
       //
       if Result then
         if num = 1 then
         begin
             execParamsLight.ParamByName('BarCodeBoxId_1').AsInteger:= DataSet.FieldByName('BarCodeBoxId').AsInteger;
             execParamsLight.ParamByName('BoxCode_1').AsInteger     := DataSet.FieldByName('BoxCode').AsInteger;
             execParamsLight.ParamByName('BoxBarCode_1').AsString   := DataSet.FieldByName('BoxBarCode').AsString;
             execParamsLight.ParamByName('isFull_1').asBoolean      := FALSE;
         end
         else
           if num = 2 then
           begin
               execParamsLight.ParamByName('BarCodeBoxId_2').AsInteger:= DataSet.FieldByName('BarCodeBoxId').AsInteger;
               execParamsLight.ParamByName('BoxCode_2').AsInteger     := DataSet.FieldByName('BoxCode').AsInteger;
               execParamsLight.ParamByName('BoxBarCode_2').AsString   := DataSet.FieldByName('BoxBarCode').AsString;
               execParamsLight.ParamByName('isFull_2').asBoolean      := FALSE;
           end
           else
             if num = 3 then
             begin
                 execParamsLight.ParamByName('BarCodeBoxId_3').AsInteger:= DataSet.FieldByName('BarCodeBoxId').AsInteger;
                 execParamsLight.ParamByName('BoxCode_3').AsInteger     := DataSet.FieldByName('BoxCode').AsInteger;
                 execParamsLight.ParamByName('BoxBarCode_3').AsString   := DataSet.FieldByName('BoxBarCode').AsString;
                 execParamsLight.ParamByName('isFull_3').asBoolean      := FALSE;
             end;

    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleCehForm.gpInsert_ScaleCeh_GoodsSeparate(var retMovementId_begin, retMovementId : Integer;
                                                             execParamsMovement:TParams;
                                                             inOperDate: TDateTime;
                                                             inFromId, inToId, inGoodsId, inStorageLineId : Integer; inPartionGoods : String;
                                                             inAmount, inHeadCount : Double;
                                                             inIsClose : Boolean
                                                            ):Boolean;
begin
    Result:=false;
    //
    with spSelect do
    begin
       //
       StoredProcName:='gpInsert_ScaleCeh_GoodsSeparate';
       OutputType:=otDataSet;
       Params.Clear;
       //
       Params.AddParam('inMovementId', ftInteger, ptInputOutput, execParamsMovement.ParamByName('MovementId').AsInteger);
       Params.AddParam('inOperDate', ftDateTime, ptInput, inOperDate);
       Params.AddParam('inMovementDescId', ftInteger, ptInput, execParamsMovement.ParamByName('MovementDescId').AsInteger);
       Params.AddParam('inMovementDescNumber', ftInteger, ptInput, execParamsMovement.ParamByName('MovementDescNumber').AsInteger);
       Params.AddParam('inFromId', ftInteger, ptInput, inFromId);
       Params.AddParam('inToId', ftInteger, ptInput, inToId);
       Params.AddParam('inIsProductionIn', ftBoolean, ptInput, execParamsMovement.ParamByName('isSendOnPriceIn').AsBoolean);
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       Params.AddParam('inGoodsId', ftInteger,  ptInput, inGoodsId);
       Params.AddParam('inPartionGoods',ftString,   ptInput, inPartionGoods);
       Params.AddParam('inAmount', ftFloat, ptInput, inAmount);
       Params.AddParam('inHeadCount', ftFloat, ptInput, inHeadCount);
       Params.AddParam('inStorageLineId', ftInteger,  ptInput, inStorageLineId);
       Params.AddParam('inIsClose', ftBoolean, ptInput, inIsClose);
       //try
         Execute;
         //
         retMovementId_begin:= DataSet.FieldByName('MovementId_begin').asInteger;
         retMovementId      := DataSet.FieldByName('MovementId').asInteger;
    end;
    //
    Result:=true;
end;
{------------------------------------------------------------------------}
function TDMMainScaleCehForm.gpGet_ScaleCeh_GoodsSeparate(inOperDate: TDateTime; inMovementId, inGoodsId : Integer; inPartionGoods : String;
                                                          inIsClose : Boolean;
                                                      var TotalCount_in, TotalCount_isOpen, TotalCount_null, TotalCount_MO, TotalCount_OB, TotalCount_PR, TotalCount_P : Double;
                                                      var HeadCount_in, HeadCount_isOpen, HeadCount_null, HeadCount_MO, HeadCount_OB, HeadCount_PR, HeadCount_P : Double;
                                                      var PartionGoods_null, PartionGoods_MO, PartionGoods_OB, PartionGoods_PR, PartionGoods_P : String
                                                         ):Boolean;
begin
    with spSelect do
    begin
       //
       StoredProcName:='gpGet_ScaleCeh_GoodsSeparate';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inOperDate',    ftDateTime, ptInput, inOperDate);
       Params.AddParam('inMovementId',  ftInteger,  ptInput, inMovementId);
       Params.AddParam('inGoodsId',     ftInteger,  ptInput, inGoodsId);
       Params.AddParam('inPartionGoods',ftString,   ptInput, inPartionGoods);
       Params.AddParam('inIsClose',     ftBoolean,  ptInput, inIsClose);
       //try
         Execute;
         //
         Result:=DataSet.RecordCount<>0;
       //
       if Result then
         with DataSet do
         begin
           First;
           TotalCount_in    := 0;
           TotalCount_isOpen:= 0;
           TotalCount_null  := 0;
           TotalCount_MO    := 0;
           TotalCount_OB    := 0;
           TotalCount_PR    := 0;
           TotalCount_P     := 0;
           //
           HeadCount_in    := 0;
           HeadCount_isOpen:= 0;
           HeadCount_null  := 0;
           HeadCount_MO    := 0;
           HeadCount_OB    := 0;
           HeadCount_PR    := 0;
           HeadCount_P     := 0;
           //
           PartionGoods_null:= DataSet.FieldByName('PartionGoods_null').asString;
           PartionGoods_MO  := DataSet.FieldByName('PartionGoods_MO').asString;
           PartionGoods_OB  := DataSet.FieldByName('PartionGoods_OB').asString;
           PartionGoods_PR  := DataSet.FieldByName('PartionGoods_PR').asString;
           PartionGoods_P   := DataSet.FieldByName('PartionGoods_P').asString;
           while not EOF do
           begin
             TotalCount_in    := TotalCount_in     + DataSet.FieldByName('TotalCount_in').asFloat;
             TotalCount_isOpen:= TotalCount_isOpen + DataSet.FieldByName('TotalCount_isOpen').asFloat;
             TotalCount_null  := TotalCount_null   + DataSet.FieldByName('TotalCount_null').asFloat;
             TotalCount_MO    := TotalCount_MO     + DataSet.FieldByName('TotalCount_MO').asFloat;
             TotalCount_OB    := TotalCount_OB     + DataSet.FieldByName('TotalCount_OB').asFloat;
             TotalCount_PR    := TotalCount_PR     + DataSet.FieldByName('TotalCount_PR').asFloat;
             TotalCount_P     := TotalCount_P      + DataSet.FieldByName('TotalCount_P').asFloat;
             //
             HeadCount_in    := HeadCount_in     + DataSet.FieldByName('HeadCount_in').asFloat;
             HeadCount_isOpen:= HeadCount_isOpen + DataSet.FieldByName('HeadCount_isOpen').asFloat;
             HeadCount_null  := HeadCount_null   + DataSet.FieldByName('HeadCount_null').asFloat;
             HeadCount_MO    := HeadCount_MO     + DataSet.FieldByName('HeadCount_MO').asFloat;
             HeadCount_OB    := HeadCount_OB     + DataSet.FieldByName('HeadCount_OB').asFloat;
             HeadCount_PR    := HeadCount_PR     + DataSet.FieldByName('HeadCount_PR').asFloat;
             HeadCount_P     := HeadCount_P      + DataSet.FieldByName('HeadCount_P').asFloat;
             Next;
           end;
         end;
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleCehForm.gpGet_ScaleLight_Goods(var execParamsLight:TParams; inGoodsId, inGoodsKindId : Integer): Boolean;
begin
    //
    //!!!ModeSorting!!!
    //
    if (SettingMain.isModeSorting = TRUE) then
    with spSelect do
    begin
       //
       StoredProcName:='gpGet_ScaleLight_Goods';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inGoodsId', ftInteger, ptInput, inGoodsId);
       Params.AddParam('inGoodsKindId', ftInteger, ptInput, inGoodsKindId);
       Params.AddParam('inIs_test', ftBoolean, ptInput, true);
       //try
         Execute;
         //
         Result:=DataSet.RecordCount<>0;

       with execParamsLight do
       begin
         ParamByName('GoodsId').AsInteger  := DataSet.FieldByName('GoodsId').AsInteger;
         ParamByName('GoodsCode').AsInteger:= DataSet.FieldByName('GoodsCode').asInteger;
         ParamByName('GoodsName').asString := DataSet.FieldByName('GoodsName').asString;
         ParamByName('GoodsKindId').AsInteger  := DataSet.FieldByName('GoodsKindId').AsInteger;
         ParamByName('GoodsKindCode').AsInteger:= DataSet.FieldByName('GoodsKindCode').asInteger;
         ParamByName('GoodsKindName').asString := DataSet.FieldByName('GoodsKindName').asString;

         ParamByName('GoodsId_sh').AsInteger  := DataSet.FieldByName('GoodsId_sh').AsInteger;
         ParamByName('GoodsCode_sh').AsInteger:= DataSet.FieldByName('GoodsCode_sh').asInteger;
         ParamByName('GoodsName_sh').asString := DataSet.FieldByName('GoodsName_sh').asString;
         ParamByName('GoodsKindId_sh').AsInteger  := DataSet.FieldByName('GoodsKindId_sh').AsInteger;
         ParamByName('GoodsKindCode_sh').AsInteger:= DataSet.FieldByName('GoodsKindCode_sh').asInteger;
         ParamByName('GoodsKindName_sh').asString := DataSet.FieldByName('GoodsKindName_sh').asString;

         ParamByName('MeasureId').AsInteger  := DataSet.FieldByName('MeasureId').AsInteger;
         ParamByName('MeasureCode').AsInteger:= DataSet.FieldByName('MeasureCode').asInteger;
         ParamByName('MeasureName').asString := DataSet.FieldByName('MeasureName').asString;
         // Главное сообщение - сколько ящиков
         ParamByName('Count_box').AsInteger          := DataSet.FieldByName('Count_box').AsInteger;
         // Id - есть ли ШТ.
         ParamByName('GoodsTypeKindId_Sh').AsInteger := DataSet.FieldByName('GoodsTypeKindId_Sh').AsInteger;
         // Id - есть ли НОМ.
         ParamByName('GoodsTypeKindId_Nom').AsInteger:= DataSet.FieldByName('GoodsTypeKindId_Nom').AsInteger;
         // Id - есть ли ВЕС
         ParamByName('GoodsTypeKindId_Ves').AsInteger:= DataSet.FieldByName('GoodsTypeKindId_Ves').AsInteger;
         // Код ВМС
         ParamByName('WmsCode_Sh').asString := DataSet.FieldByName('WmsCode_Sh').asString;
         ParamByName('WmsCode_Nom').asString:= DataSet.FieldByName('WmsCode_Nom').asString;
         ParamByName('WmsCode_Ves').asString:= DataSet.FieldByName('WmsCode_Ves').asString;
         // минимальный вес 1шт.
         ParamByName('WeightMin').AsFloat:= DataSet.FieldByName('WeightMin').AsFloat;
         // максимальный вес 1шт.
         ParamByName('WeightMax').AsFloat:= DataSet.FieldByName('WeightMax').AsFloat;

         // минимальный вес 1ед.
         ParamByName('WeightMin_Sh').AsFloat := DataSet.FieldByName('WeightMin_Sh').AsFloat;
         ParamByName('WeightMin_Nom').AsFloat:= DataSet.FieldByName('WeightMin_Nom').AsFloat;
         ParamByName('WeightMin_Ves').AsFloat:= DataSet.FieldByName('WeightMin_Ves').AsFloat;
         // максимальный вес 1ед.
         ParamByName('WeightMax_Sh').AsFloat := DataSet.FieldByName('WeightMax_Sh').AsFloat;
         ParamByName('WeightMax_Nom').AsFloat:= DataSet.FieldByName('WeightMax_Nom').AsFloat;
         ParamByName('WeightMax_Ves').AsFloat:= DataSet.FieldByName('WeightMax_Ves').AsFloat;

         //1-ая линия - Всегда этот цвет
         ParamByName('GoodsTypeKindId_1').AsInteger := DataSet.FieldByName('GoodsTypeKindId_1').AsInteger;
         ParamByName('BarCodeBoxId_1').AsInteger    := 0;
         ParamByName('BoxCode_1').AsInteger         := 0;
         ParamByName('BoxBarCode_1').AsString       := '';
      // ParamByName('WeightOnBoxTotal_1').asFloat  := 0; // Вес итого накопительный (в незакрытом ящике) - при достижении будет сброс
      // ParamByName('CountOnBoxTotal_1').asFloat   := 0; // шт итого накопительно (в незакрытом ящике) - информативно?
      // ParamByName('WeightTotal_1').asFloat       := 0; // Вес итого накопительный (в закрытых ящиках) - информативно
      // ParamByName('CountTotal_1').asFloat        := 0; // шт итого накопительный (в закрытых ящиках) - информативно
      // ParamByName('BoxTotal_1').asFloat          := 0; // ящиков итого (закрытых) - информативно
         ParamByName('isFull_1').AsBoolean          := FALSE;

         ParamByName('BoxId_1').AsInteger           := DataSet.FieldByName('BoxId_1').AsInteger;
         ParamByName('BoxName_1').asString          := DataSet.FieldByName('BoxName_1').asString;
         ParamByName('BoxWeight_1').asFloat         := DataSet.FieldByName('BoxWeight_1').asFloat;   // Вес самого ящика
         ParamByName('WeightOnBox_1').asFloat       := DataSet.FieldByName('WeightOnBox_1').asFloat; // вложенность - Вес
         ParamByName('CountOnBox_1').asFloat        := DataSet.FieldByName('CountOnBox_1').asFloat;  // Вложенность - шт (информативно?)

         //2-ая линия - Всегда этот цвет
         ParamByName('GoodsTypeKindId_2').AsInteger := DataSet.FieldByName('GoodsTypeKindId_2').AsInteger;
         ParamByName('BarCodeBoxId_2').AsInteger    := 0;
         ParamByName('BoxCode_2').AsInteger         := 0;
         ParamByName('BoxBarCode_2').AsString       := '';
      // ParamByName('WeightOnBoxTotal_2').asFloat  := 0; // Вес итого накопительный (в незакрытом ящике) - при достижении будет сброс
      // ParamByName('CountOnBoxTotal_2').asFloat   := 0; // шт итого накопительно (в незакрытом ящике) - информативно?
      // ParamByName('WeightTotal_2').asFloat       := 0; // Вес итого накопительный (в закрытых ящиках) - информативно
      // ParamByName('CountTotal_2').asFloat        := 0; // шт итого накопительный (в закрытых ящиках) - информативно
      // ParamByName('BoxTotal_2').asFloat          := 0; // ящиков итого (закрытых) - информативно
         ParamByName('isFull_2').AsBoolean          := FALSE;

         ParamByName('BoxId_2').AsInteger           := DataSet.FieldByName('BoxId_2').AsInteger;
         ParamByName('BoxName_2').asString          := DataSet.FieldByName('BoxName_2').asString;
         ParamByName('BoxWeight_2').asFloat         := DataSet.FieldByName('BoxWeight_2').asFloat;   // Вес самого ящика
         ParamByName('WeightOnBox_2').asFloat       := DataSet.FieldByName('WeightOnBox_2').asFloat; // вложенность - Вес
         ParamByName('CountOnBox_2').asFloat        := DataSet.FieldByName('CountOnBox_2').asFloat;  // Вложенность - шт (информативно?)

          //3-ья линия - Всегда этот цвет
         ParamByName('GoodsTypeKindId_3').AsInteger := DataSet.FieldByName('GoodsTypeKindId_3').AsInteger;
         ParamByName('BarCodeBoxId_3').AsInteger    := 0;
         ParamByName('BoxCode_3').AsInteger         := 0;
         ParamByName('BoxBarCode_3').AsString       := '';
      // ParamByName('WeightOnBoxTotal_3').asFloat  := 0; // Вес итого накопительный (в незакрытом ящике) - при достижении будет сброс
      // ParamByName('CountOnBoxTotal_3').asFloat   := 0; // шт итого накопительно (в незакрытом ящике) - информативно?
      // ParamByName('WeightTotal_3').asFloat       := 0; // Вес итого накопительный (в закрытых ящиках) - информативно
      // ParamByName('CountTotal_3').asFloat        := 0; // шт итого накопительный (в закрытых ящиках) - информативно
      // ParamByName('BoxTotal_3').asFloat          := 0; // ящиков итого (закрытых) - информативно
         ParamByName('isFull_3').AsBoolean          := FALSE;

         ParamByName('BoxId_3').AsInteger           := DataSet.FieldByName('BoxId_3').AsInteger;
         ParamByName('BoxName_3').asString          := DataSet.FieldByName('BoxName_3').asString;
         ParamByName('BoxWeight_3').asFloat         := DataSet.FieldByName('BoxWeight_3').asFloat;   // Вес самого ящика
         ParamByName('WeightOnBox_3').asFloat       := DataSet.FieldByName('WeightOnBox_3').asFloat; // вложенность - Вес
         ParamByName('CountOnBox_3').asFloat        := DataSet.FieldByName('CountOnBox_3').asFloat;  // Вложенность - шт (информативно?)

       end;

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
function TDMMainScaleCehForm.lpGet_UnitName(inUnitId:Integer): String;
begin
    with spSelect do
    if inUnitId > 0 then
    begin
       StoredProcName:='gpExecSql_Value';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inSqlText', ftString, ptInput, 'SELECT Object.ValueData FROM Object WHERE Object.Id = '+ IntToStr(inUnitId) + ' AND Object.DescId = zc_Object_Unit()');
       Execute;
       Result:=DataSet.FieldByName('Value').asString;
    end
    else Result:='';
end;
{------------------------------------------------------------------------}
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
         Params.ParamByName('inSqlText').Value:='SELECT zc_Measure_Sh() :: TVarChar';
         Execute;
         zc_Measure_Sh:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Measure_Kg() :: TVarChar';
         Execute;
         zc_Measure_Kg:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Measure_Kgg() :: TVarChar';
         Execute;
         zc_Measure_Kgg:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Enum_Status_Complete() :: TVarChar';
         Execute;
         zc_Enum_Status_Complete:=DataSet.FieldByName('Value').asInteger;

         Params.ParamByName('inSqlText').Value:='SELECT zc_Enum_Status_UnComplete() :: TVarChar';
         Execute;
         zc_Enum_Status_UnComplete:=DataSet.FieldByName('Value').asInteger;

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

         Params.ParamByName('inSqlText').Value:='SELECT zc_Object_Unit() :: TVarChar';
         Execute;
         zc_Object_Unit:=DataSet.FieldByName('Value').asInteger;

         //ModeSorting
         // назв - Штучный
         Params.ParamByName('inSqlText').Value:='SELECT ValueData FROM Object WHERE Id = zc_Enum_GoodsTypeKind_Sh()';
         Execute;
         SettingMain.Name_Sh:=DataSet.FieldByName('Value').asString;
         // назв - Номинальный
         Params.ParamByName('inSqlText').Value:='SELECT ValueData FROM Object WHERE Id = zc_Enum_GoodsTypeKind_Nom()';
         Execute;
         SettingMain.Name_Nom:=DataSet.FieldByName('Value').asString;
         // назв - Неноминальный
         Params.ParamByName('inSqlText').Value:='SELECT ValueData FROM Object WHERE Id = zc_Enum_GoodsTypeKind_Ves()';
         Execute;
         SettingMain.Name_Ves:=DataSet.FieldByName('Value').asString;
         // назв - Штучный
         Params.ParamByName('inSqlText').Value:='SELECT COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = zc_Enum_GoodsTypeKind_Sh() AND DescId = zc_ObjectString_GoodsTypeKind_ShortName() AND ValueData <> '+chr(39)+''+chr(39)+'), '+chr(39)+'ШТ.'+chr(39)+' :: TVarChar)';
         Execute;
         SettingMain.ShName_Sh:=DataSet.FieldByName('Value').asString;
         // назв - Номинальный
         Params.ParamByName('inSqlText').Value:='SELECT COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = zc_Enum_GoodsTypeKind_Nom() AND DescId = zc_ObjectString_GoodsTypeKind_ShortName() AND ValueData <> '+chr(39)+''+chr(39)+'), '+chr(39)+'НОМ.'+chr(39)+' :: TVarChar)';
         Execute;
         SettingMain.ShName_Nom:=DataSet.FieldByName('Value').asString;
         // назв - Неноминальный
         Params.ParamByName('inSqlText').Value:='SELECT COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = zc_Enum_GoodsTypeKind_Ves() AND DescId = zc_ObjectString_GoodsTypeKind_ShortName() AND ValueData <> '+chr(39)+''+chr(39)+'), '+chr(39)+'ВЕС.'+chr(39)+' :: TVarChar)';
         Execute;
         SettingMain.ShName_Ves:=DataSet.FieldByName('Value').asString;



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
  ScaleList : TStringList;
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
  //PlaceNumber
  SettingMain.PlaceNumber:=Ini.ReadInteger('Main','PlaceNumber',0);
  if SettingMain.PlaceNumber=0 then begin SettingMain.PlaceNumber:= 1; Ini.WriteInteger('Main','PlaceNumber',1);end;

  SettingMain.DefaultCOMPort:=Ini.ReadInteger('Main','DefaultCehCOMPort',1);
  if SettingMain.DefaultCOMPort=1 then Ini.WriteInteger('Main','DefaultCehCOMPort',1);

  SettingMain.LightCOMPort:=Ini.ReadInteger('Main','DefaultLightCOMPort',0);
  if SettingMain.LightCOMPort=0 then Ini.WriteInteger('Main','DefaultLightCOMPort',4);

  //isLightLEFT_123
  tmpValue:=Ini.ReadString('Main','isLightLEFT_123','');
  if tmpValue='' then Ini.WriteString('Main','isLightLEFT_123', 'TRUE');
  SettingMain.isLightLEFT_123:= AnsiUpperCase(tmpValue) = AnsiUpperCase('TRUE');
  //isLightLEFT_123
  tmpValue:=Ini.ReadString('Main','isLightCOMPort','');
  if tmpValue='' then Ini.WriteString('Main','isLightCOMPort', 'FALSE');
  SettingMain.isLightCOMPort:= AnsiUpperCase(tmpValue) = AnsiUpperCase('TRUE');

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
  SettingMain.isAsset:=GetArrayList_Value_byName(Default_Array,'isAsset') = AnsiUpperCase('TRUE');
  //
  if SettingMain.isCeh = TRUE then
  begin
       SettingMain.isModeSorting:=GetArrayList_Value_byName(Default_Array,'isModeSorting') = AnsiUpperCase('TRUE');

       SettingMain.isCalc_sht:=GetArrayList_Value_byName(Default_Array,'isCalc_sht') = AnsiUpperCase('TRUE');

       SettingMain.WeightSkewer1:=myStrToFloat(GetArrayList_Value_byName(Default_Array,'WeightSkewer1'));
       SettingMain.WeightSkewer2:=myStrToFloat(GetArrayList_Value_byName(Default_Array,'WeightSkewer2'));

       try SettingMain.UnitId1:= StrToInt(GetArrayList_Value_byName(Default_Array,'UnitId1')); except SettingMain.UnitId1:= 0; end;
       try SettingMain.UnitId2:= StrToInt(GetArrayList_Value_byName(Default_Array,'UnitId2')); except SettingMain.UnitId2:= 0; end;
       try SettingMain.UnitId3:= StrToInt(GetArrayList_Value_byName(Default_Array,'UnitId3')); except SettingMain.UnitId3:= 0; end;
       try SettingMain.UnitId4:= StrToInt(GetArrayList_Value_byName(Default_Array,'UnitId4')); except SettingMain.UnitId4:= 0; end;
       try SettingMain.UnitId5:= StrToInt(GetArrayList_Value_byName(Default_Array,'UnitId5')); except SettingMain.UnitId5:= 0; end;

       SettingMain.UnitName1:= DMMainScaleCehForm.lpGet_UnitName(SettingMain.UnitId1);
       SettingMain.UnitName2:= DMMainScaleCehForm.lpGet_UnitName(SettingMain.UnitId2);
       SettingMain.UnitName3:= DMMainScaleCehForm.lpGet_UnitName(SettingMain.UnitId3);
       SettingMain.UnitName4:= DMMainScaleCehForm.lpGet_UnitName(SettingMain.UnitId4);
       SettingMain.UnitName5:= DMMainScaleCehForm.lpGet_UnitName(SettingMain.UnitId5);

       try SettingMain.UnitId1_sep:= StrToInt(GetArrayList_Value_byName(Default_Array,'UnitId1_sep')); except SettingMain.UnitId1_sep:= 0; end;
       try SettingMain.UnitId2_sep:= StrToInt(GetArrayList_Value_byName(Default_Array,'UnitId2_sep')); except SettingMain.UnitId2_sep:= 0; end;
       SettingMain.UnitName1_sep:= DMMainScaleCehForm.lpGet_UnitName(SettingMain.UnitId1_sep);
       SettingMain.UnitName2_sep:= DMMainScaleCehForm.lpGet_UnitName(SettingMain.UnitId2_sep);

       //ModeSorting - Color
       try SettingMain.LightColor_1:= StrToInt(GetArrayList_Value_byName(Default_Array,'LightColor_1')); except SettingMain.LightColor_1:= 0; end;
       try SettingMain.LightColor_2:= StrToInt(GetArrayList_Value_byName(Default_Array,'LightColor_2')); except SettingMain.LightColor_1:= 0; end;
       try SettingMain.LightColor_3:= StrToInt(GetArrayList_Value_byName(Default_Array,'LightColor_3')); except SettingMain.LightColor_1:= 0; end;

  end;
  //
  Result:=true;
end;
{------------------------------------------------------------------------}
end.
