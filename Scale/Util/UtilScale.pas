unit UtilScale;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, Vcl.Dialogs,Forms;
type

  TDBObject = record
    Id:   Integer;
    Code: Integer;
    Name: string;
  end;

  TListItem = record
    Number: Integer;
    Id:     Integer;
    Code:   Integer;
    Name:   string;
    Value:  string;
  end;

  TScaleType = (stBI, stDB);

  TListItemScale = record
    Number   : Integer;
    ScaleType: TScaleType;
    ScaleName: string;
    COMPort  : Integer;
  end;

  TArrayList = array of TListItem;
  TArrayListScale = array of TListItemScale;

  TSettingMain = record
    BrancCode :Integer;
    ScaleCount:Integer;
    DefaultCOMPort:Integer;
    IndexScale_old:Integer;
  end;


  function GetArrayList_Value_byName   (ArrayList:TArrayList;Name:String):String;
  function GetArrayList_Index_byNumber (ArrayList:TArrayList;Number:Integer):Integer;
  function GetArrayList_Index_byCode   (ArrayList:TArrayList;Code:Integer):Integer;
  function GetArrayList_Index_byName   (ArrayList:TArrayList;Name:String):Integer;
  function GetArrayList_Index_byValue  (ArrayList:TArrayList;Value:String):Integer;

  function GetArrayList_lpIndex_GoodsKind(ArrayList:TArrayList;GoodsKindWeighingGroupId,Code:Integer):Integer;
  function GetArrayList_gpIndex_GoodsKind(ArrayList:TArrayList;GoodsKindWeighingGroupId,lpIndex:Integer):Integer;

  function isEqualFloatValues (Value1,Value2:Double):boolean;

  procedure MyDelay(mySec:Integer);
  procedure MyDelay_two(mySec:Integer);

  procedure Create_ParamsMovement(var Params:TParams);
  procedure Create_ParamsMI(var Params:TParams);

  // создает TParam с названием поля _Name и типом _DataType и добавляет к TParams
  procedure ParamAdd(var execParams:TParams;_Name:String;_DataType:TFieldType);
  // создает TParam с названием поля _Name и типом _DataType и добавляет к TParams со значением _Value
  procedure ParamAddValue(var execParams: TParams;_Name:String;_DataType:TFieldType;_Value: variant);
  // возвращаят индекс парамтра сназванием FindName в TParams
  function GetIndexParams(execParams:TParams;FindName:String):Integer;
  //
  procedure CopyValuesParamsFrom(var fromParams,toParams:TParams);
  procedure EmptyValuesParams(var execParams:TParams);

var
  SettingMain   : TSettingMain;
  ParamsMovement: TParams;
  ParamsMI: TParams;

  Scale_Array         :TArrayListScale;

  Default_Array       :TArrayList;
  Service_Array       :TArrayList;

  GoodsKind_Array     :TArrayList;
  TareCount_Array     :TArrayList;
  TareWeight_Array    :TArrayList;
  ChangePercentAmount_Array :TArrayList;
  PriceList_Array     :TArrayList;

  zc_Movement_Income: Integer;
  zc_Movement_ReturnOut: Integer;
  zc_Movement_Sale: Integer;
  zc_Movement_ReturnIn: Integer;
  zc_Movement_Send: Integer;
  zc_Movement_SendOnPrice: Integer;

  zc_Movement_Loss: Integer;
  zc_Movement_Inventory: Integer;
  zc_Movement_ProductionUnion: Integer;
  zc_Movement_ProductionSeparate: Integer;

  zc_Measure_Sh: Integer;
  zc_Measure_Kg: Integer;

  zc_BarCodePref_Object  :String;
  zc_BarCodePref_Movement:String;
  zc_BarCodePref_MI      :String;

  implementation

{------------------------------------------------------------------------}
procedure Create_ParamsMovement(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'ColorGridValue',ftInteger);
     ParamAdd(Params,'OperDate',ftDateTime);

     ParamAdd(Params,'MovementId_begin',ftInteger);

     ParamAdd(Params,'MovementId',ftInteger);
     ParamAdd(Params,'InvNumber',ftString);
     ParamAdd(Params,'OperDate_Movement',ftDateTime);

     ParamAdd(Params,'MovementDescNumber',ftInteger);

     ParamAdd(Params,'MovementDescId',ftInteger);
     ParamAdd(Params,'FromId',ftInteger);
     ParamAdd(Params,'FromCode',ftInteger);
     ParamAdd(Params,'FromName',ftString);
     ParamAdd(Params,'ToId',ftInteger);
     ParamAdd(Params,'ToCode',ftInteger);
     ParamAdd(Params,'ToName',ftString);
     ParamAdd(Params,'PaidKindId',ftInteger);
     ParamAdd(Params,'PaidKindName',ftString);

     ParamAdd(Params,'calcPartnerId',ftInteger);
     ParamAdd(Params,'calcPartnerCode',ftInteger);
     ParamAdd(Params,'calcPartnerName',ftString);
     ParamAdd(Params,'ChangePercentAmount',ftFloat);
     ParamAdd(Params,'ChangePercent',ftFloat);

     ParamAdd(Params,'OrderExternalId',ftInteger);
     ParamAdd(Params,'OrderExternal_BarCode',ftString);
     ParamAdd(Params,'OrderExternal_InvNumber',ftString);
     ParamAdd(Params,'OrderExternalName_master',ftString);

     ParamAdd(Params,'ContractId',ftInteger);
     ParamAdd(Params,'ContractCode',ftInteger);
     ParamAdd(Params,'ContractNumber',ftString);
     ParamAdd(Params,'ContractTagName',ftString);

     ParamAdd(Params,'PriceListId',ftInteger);
     ParamAdd(Params,'PriceListCode',ftInteger);
     ParamAdd(Params,'PriceListName',ftString);

     ParamAdd(Params,'GoodsKindWeighingGroupId',ftInteger);

     ParamAdd(Params,'MovementDescName_master',ftString);

     ParamAdd(Params,'TotalSumm',ftFloat);

end;
{------------------------------------------------------------------------}
procedure Create_ParamsMI(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'GoodsId',ftInteger);     // Товары
     ParamAdd(Params,'GoodsCode',ftInteger);     // Товары
     ParamAdd(Params,'GoodsName',ftString);     // Товары
     ParamAdd(Params,'GoodsKindId',ftInteger); // Виды товаров
     ParamAdd(Params,'GoodsKindCode',ftInteger); // Виды товаров
     ParamAdd(Params,'GoodsKindName',ftString);     // Виды товаров
     ParamAdd(Params,'RealWeight_Get',ftFloat);      //
     ParamAdd(Params,'RealWeight',ftFloat);          // Реальный вес (без учета тары и % скидки для кол-ва)
     ParamAdd(Params,'CountTare',ftFloat);           // Количество тары
     ParamAdd(Params,'WeightTare',ftFloat);          // Вес 1-ой тары
     ParamAdd(Params,'ChangePercentAmount',ftFloat); // % скидки для кол-ва
     ParamAdd(Params,'Price',ftFloat);          //
     ParamAdd(Params,'CountForPrice',ftFloat);  //
end;
{------------------------------------------------------------------------}
function GetArrayList_Value_byName(ArrayList:TArrayList;Name:String):String;
var i: Integer;
begin
  Result:='';
  for i := 0 to Length(ArrayList)-1 do
    if ArrayList[i].Name = Name then begin Result:=AnsiUpperCase(ArrayList[i].Value);break;end;
end;
{------------------------------------------------------------------------}
function GetArrayList_Index_byNumber(ArrayList:TArrayList;Number:Integer):Integer;
var i: Integer;
begin
  Result:=-1;
  for i := 0 to Length(ArrayList)-1 do
    if ArrayList[i].Number = Number then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------}
function GetArrayList_Index_byCode(ArrayList:TArrayList;Code:Integer):Integer;
var i: Integer;
begin
  Result:=-1;
  for i := 0 to Length(ArrayList)-1 do
    if ArrayList[i].Code = Code then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------}
function GetArrayList_Index_byName(ArrayList:TArrayList;Name:String):Integer;
var i: Integer;
begin
  Result:=-1;
  for i := 0 to Length(ArrayList)-1 do
    if ArrayList[i].Name = Name then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------}
function GetArrayList_Index_byValue(ArrayList:TArrayList;Value:String):Integer;
var i: Integer;
begin
  Result:=-1;
  for i := 0 to Length(ArrayList)-1 do
    if ArrayList[i].Value = Value then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------}
function GetArrayList_lpIndex_GoodsKind(ArrayList:TArrayList;GoodsKindWeighingGroupId,Code:Integer):Integer;
var i,ii: Integer;
begin
  Result:=-1;
  ii:=-1;
  for i := 0 to Length(ArrayList)-1 do
    if ArrayList[i].Number = GoodsKindWeighingGroupId
    then begin
              ii:=ii+1;
              if (ArrayList[i].Code = Code)or(Code<=0) then begin Result:=ii;break;end;
         end;
end;
{------------------------------------------------------------------------}
function GetArrayList_gpIndex_GoodsKind(ArrayList:TArrayList;GoodsKindWeighingGroupId,lpIndex:Integer):Integer;
var i,ii: Integer;
begin
  Result:=-1;
  ii:=-1;
  for i := 0 to Length(ArrayList)-1 do
    if ArrayList[i].Number = GoodsKindWeighingGroupId
    then begin
              ii:=ii+1;
              if (ii = lpIndex)or(lpIndex<0) then begin Result:=i;break;end;
         end;
end;
{------------------------------------------------------------------------}
function isEqualFloatValues(Value1,Value2:Double):boolean;
begin
     Result:=abs(Value1-Value2)<0.0001;
end;
{------------------------------------------------------------------------}
procedure MyDelay(mySec:Integer);
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  calcSec,calcSec2:LongInt;
begin
     Present:=Now;
     DecodeDate(Present, Year, Month, Day);
     DecodeTime(Present, Hour, Min, Sec, MSec);
     //calcSec:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
     //calcSec2:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
     calcSec:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     calcSec2:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     while abs(calcSec-calcSec2)<mySec do
     begin
          Application.ProcessMessages;
          Application.ProcessMessages;
          Application.ProcessMessages;
          Application.ProcessMessages;
          Present:=Now;
          DecodeDate(Present, Year, Month, Day);
          DecodeTime(Present, Hour, Min, Sec, MSec);
          //calcSec2:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
          calcSec2:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
          Application.ProcessMessages;
          Application.ProcessMessages;
          Application.ProcessMessages;
     end;
end;
{------------------------------------------------------------------------------}
procedure MyDelay_two(mySec:Integer);
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  calcSec,calcSec2:LongInt;
begin
     Present:=Now;
     DecodeDate(Present, Year, Month, Day);
     DecodeTime(Present, Hour, Min, Sec, MSec);
     //calcSec:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
     //calcSec2:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
     calcSec:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     calcSec2:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     while abs(calcSec-calcSec2)<mySec do
     begin
          Present:=Now;
          DecodeDate(Present, Year, Month, Day);
          DecodeTime(Present, Hour, Min, Sec, MSec);
          //calcSec2:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
          calcSec2:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     end;
end;
{------------------------------------------------------------------------------}
// создает TParam с названием поля _Name и типом _DataType и добавляет к TParams
procedure ParamAdd(var execParams:TParams;_Name:String;_DataType:TFieldType);
begin
     if not Assigned(execParams) then execParams:=TParams.Create
     else
         if GetIndexParams(execParams,_Name)>=0 then exit;

     TParam.Create(execParams,ptUnknown);
     execParams[execParams.Count-1].Name:=_Name;
     execParams[execParams.Count-1].DataType:=_DataType;
end;
{------------------------------------------------------------------------------}
// создает TParam с названием поля _Name и типом _DataType и добавляет к TParams со значением _Value
procedure ParamAddValue(var execParams: TParams;_Name:String;_DataType:TFieldType;_Value: variant);
begin
  if not Assigned(execParams) then execParams:=TParams.Create;
  ParamAdd(execParams,_Name,_DataType);
  execParams.Items[GetIndexParams(execParams,_Name)].Value:=_Value;
end;
{------------------------------------------------------------------------------}
function GetIndexParams(execParams:TParams;FindName:String):Integer;//возвращаят индекс парамтра сназванием FindName в TParams
var i:Integer;
begin
  Result:=-1;
  if not Assigned(execParams) then exit;
  for i:=0 to execParams.Count-1 do
          if UpperCase(execParams[i].Name)=UpperCase(FindName)then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------------}
procedure CopyValuesParamsFrom(var fromParams,toParams:TParams);
var i:Integer;
begin
   if not Assigned(fromParams)then exit;
   with fromParams do
    for i:=0 to Count-1 do toParams.ParamValues[Items[i].Name]:=ParamValues[Items[i].Name];
end;
{------------------------------------------------------------------------------}
procedure EmptyValuesParams(var execParams:TParams);
var i:Integer;
begin
   if not Assigned(execParams)then exit;
   with execParams do
    for i:=0 to Count-1 do
    begin
         if execParams[i].DataType=ftString then execParams.ParamByName(Items[i].Name).AsString:='';
         if execParams[i].DataType=ftInteger then execParams.ParamByName(Items[i].Name).AsInteger:=0;
    end;
end;
{------------------------------------------------------------------------------}
end.
