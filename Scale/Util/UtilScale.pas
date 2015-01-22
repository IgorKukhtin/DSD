unit UtilScale;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, Vcl.Dialogs,Forms;
type

  TDBObject = record
    Id:   integer;
    Code: integer;
    Name: string;
  end;

  TListItem = record
    Number:  integer;
    Id:   integer;
    Code: integer;
    Name: string;
    Value: string;
  end;

  TArrayList = array of TListItem;

  TSettingMain = record
    ScaleNum:         integer;
    ComPort:          string;
    BI:               Boolean;
    DB:               Boolean;
    UserId:           integer;
  end;


  function GetArrayList_Value_byName   (ArrayList:TArrayList;Name:String):String;
  function GetArrayList_Index_byName   (ArrayList:TArrayList;Name:String):Integer;
  function GetArrayList_Index_byNumber (ArrayList:TArrayList;Number:Integer):Integer;

  function isEqualFloatValues (Value1,Value2:Double):boolean;
  procedure MyDelay(mySec:Integer);

  procedure Create_ParamsMovement(var Params:TParams);

  // создает TParam с названием поля _Name и типом _DataType и добавляет к TParams
  procedure ParamAdd(var execParams:TParams;_Name:String;_DataType:TFieldType);
  // создает TParam с названием поля _Name и типом _DataType и добавляет к TParams со значением _Value
  procedure ParamAddValue(var execParams: TParams;_Name:String;_DataType:TFieldType;_Value: variant);
  // возвращаят индекс парамтра сназванием FindName в TParams
  function GetIndexParams(execParams:TParams;FindName:String):integer;
  //
  procedure CopyValuesParamsFrom(fromParams,toParams:TParams);

var
  SettingMain   : TSettingMain;
  ParamsMovement: TParams;

  Default_Array       :TArrayList;
  Service_Array       :TArrayList;

  zc_Movement_Income: integer;
  zc_Movement_ReturnOut: integer;
  zc_Movement_Sale: integer;
  zc_Movement_ReturnIn: integer;
  zc_Movement_Send: integer;
  zc_Movement_SendOnPrice: integer;

  zc_Movement_Loss: integer;
  zc_Movement_Inventory: integer;
  zc_Movement_ProductionUnion: integer;
  zc_Movement_ProductionSeparate: integer;

implementation

{------------------------------------------------------------------------}
procedure Create_ParamsMovement(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'ColorGridValue',ftInteger);
     ParamAdd(Params,'OperDate',ftDateTime);

     ParamAdd(Params,'MovementNumber',ftInteger);

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

     ParamAdd(Params,'MovementDescName_master',ftString);

end;
{------------------------------------------------------------------------}
function GetArrayList_Value_byName(ArrayList:TArrayList;Name:String):String;
var i: Integer;
begin
  Result:='';
  for i := 0 to Length(ArrayList)-1 do
    if ArrayList[i].Name = Name then begin Result:=ArrayList[i].Value;break;end;
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
function GetArrayList_Index_byNumber(ArrayList:TArrayList;Number:Integer):Integer;
var i: Integer;
begin
  Result:=-1;
  for i := 0 to Length(ArrayList)-1 do
    if ArrayList[i].Number = Number then begin Result:=i;break;end;
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
function GetIndexParams(execParams:TParams;FindName:String):integer;//возвращаят индекс парамтра сназванием FindName в TParams
var i:integer;
begin
  Result:=-1;
  if not Assigned(execParams) then exit;
  for i:=0 to execParams.Count-1 do
          if UpperCase(execParams[i].Name)=UpperCase(FindName)then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------------}
procedure CopyValuesParamsFrom(fromParams,toParams:TParams);
var i:integer;
begin
   if not Assigned(fromParams)then exit;
   with fromParams do
    for i:=0 to Count-1 do toParams.ParamValues[Items[i].Name]:=ParamValues[Items[i].Name];
end;
{------------------------------------------------------------------------------}
end.
