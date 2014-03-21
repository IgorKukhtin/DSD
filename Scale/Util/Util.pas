unit Util;

interface

uses
  System.SysUtils, System.Classes, dsdDB, Data.DB, Datasnap.DBClient, Vcl.Dialogs;

type

  TDBObject = record
    Id:   integer;
    Code: integer;
    Name: string;
  end;

  TSetting = record
    ScaleNum:         integer;
    ToolsCode:        integer;
    DefaultToolsCode: integer;
    RouteSortingId:   integer;
    RouteSortingCode: integer;
    RouteSortingName: string;
    DescId:           integer;
    DescName:         string;
    FromId:           integer;
    FromCode:         integer;
    FromName:         string;
    ToId:             integer;
    ToCode:           integer;
    ToName:           string;
    PartnerId:        integer;
    PartnerCode:      integer;
    PartnerName:      string;
    PriceListId:      integer;
    PriceListCode:    integer;
    PriceListName:    string;
    PaidKindId:       integer;
    PaidKindName:     string;
    ColorGridName:    string;
  end;

function GetObject_byCode(Code, DescId: integer): TDBObject;
function GetDefaultValue(inLevel1,inLevel2,inLevel3,inLevel4,inValueData:String):String;

function isEqualFloatValues(Value1,Value2:Double):boolean;
{==================================}
//      создает TParam с названием поля _Name и типом _DataType и значение _Value
function CreateParamValue(_Name:String;_DataType:TFieldType;_Value: variant):TParams;
{==================================}
//      создает TParam с названием поля _Name и типом _DataType
//      и добавляет к TParams
procedure ParamAdd(var Result:TParams;_Name:String;_DataType:TFieldType);
{==================================}
//      возвращаят индекс парамтра сназванием FindName в TParams
function GetIndexParams(execParams:TParams;FindName:String):integer;
//      создает TParam с названием поля _Name и типом _DataType и значение _Value
//      и добавляет к TParams
procedure ParamAddValue(var Params: TParams;_Name:String;_DataType:TFieldType;_Value: variant);
function FindParamName(execParams:TParams;FindValue:String):String;
{==================================}
// равно ли значение полей pParams значениям в DataSet
function EqualParams_DataSet(pParams: TParams;DataSet: TDataSet): boolean;
{==================================}
function FindTStringList(execList:TStringList;FindItem:String):boolean;
{==================================}



var
  CurSetting: TSetting;
  NewSetting: TSetting;
  ParamsPriceList :TParams;
//  ,ParamsKindPackage,ParamsDiscount,ParamsCountTare,ParamsCodeTareWeightEnter,ParamsBill_ScaleHistory:TParams;
//  ParamsBillKind,ParamsBillKind_UnitFrom,ParamsBillKind_UnitTo,ParamsBillKind_MoneyKind,ParamsBillKind_isProduction:TParams;

implementation
function GetDefaultValue(inLevel1,inLevel2,inLevel3,inLevel4,inValueData:String):String;
var
 spExec : TdsdStoredProc;
 ClientDataSet: TClientDataSet;
begin
  spExec:= TdsdStoredProc.Create(spExec);
  ClientDataSet:= TClientDataSet.Create(ClientDataSet);
  try
    with spExec do begin
       OutputType:=otDataSet;
       DataSet:=ClientDataSet;
       StoredProcName:='gpGetToolsPropertyValue';
       Params.AddParam('inLevel1', ftString, ptInput, inLevel1);
       Params.AddParam('inLevel2', ftString, ptInput, inLevel2);
       Params.AddParam('inLevel3', ftString, ptInput, inLevel3);
       Params.AddParam('inLevel4', ftString, ptInput, inLevel4);
       Params.AddParam('inValueData', ftString, ptInput, inValueData);

       try
         Execute;
         result := ClientDataSet.FieldByName('Value').asString;
       except
//         ShowMessage('Ошибка получения значения');
         result := '';
       end;
    end;
  finally spExec.Free; ClientDataSet.Free; end;


end;


function GetObject_byCode(Code, DescId: integer): TDBObject;
var
 spExec : TdsdStoredProc;
begin
  spExec:=TdsdStoredProc.Create(spExec);
  try
    with spExec do begin
       OutputType:=otResult;
       StoredProcName:='gpGetObject_byCode';
       Params.AddParam('inCode', ftInteger, ptInput, Code);
       Params.AddParam('inDescId', ftInteger, ptInput, DescId);
       Params.AddParam('outId', ftInteger, ptOutput, 0);
       Params.AddParam('outName', ftString, ptOutput, 'test');
       try
         Execute;
         result.Code := Code;
         result.Id   := ParamByName('outId').Value;
         result.Name := ParamByName('outName').Value;
       except
//         ShowMessage('Ошибка получения объекта');
         result.Code := Code;
         result.Id   := 0;
         result.Name := '';

       end;
    end;
  finally spExec.Free end;
end;

{------------------------------------------------------------------------}
function isEqualFloatValues(Value1,Value2:Double):boolean;
begin
     Result:=abs(Value1-Value2)<0.0001;
end;
{------------------------------------------------------------------------}
//  Находит в DataSet значение из Params поля NameFieldID и если нашли то меняет на значения из Params
function UpdateDataSet(DataSet:TDataSet;NameFieldID:String;Params: TParams): boolean;
var i:integer;
begin
     result:=false;
     with DataSet do begin
          DisableControls;
          if Locate(NameFieldID,Params.ParamByName(NameFieldID).AsString,[]) then
          try
             Edit;
             for i:=0 to Params.Count-1 do if UpperCase(Params[i].Name)<>UpperCase(NameFieldID)
                 then FieldByName(Params[i].Name).Value:=Params[i].Value;
             Post;
             result:=true;
          except end;
          EnableControls;
     end;
end;
{------------------------------------------------------------------------------}
//      создает TParam с названием поля _Name и типом _DataType и значение _Value
//      и добавляет к TParams
procedure ParamAddValue(var Params :TParams;_Name:String;_DataType:TFieldType;_Value: variant);
begin
  if not Assigned(Params) then Params:=TParams.Create;
  ParamAdd(Params,_Name,_DataType);
  Params.Items[Params.Count-1].Value:=_Value;
end;
{------------------------------------------------------------------------------}
//      создает TParam с названием поля _Name и типом _DataType и значение _Value
function CreateParamValue(_Name:String;_DataType:TFieldType;_Value: variant):TParams;
begin Result:=nil;ParamAddValue(Result,_Name,_DataType,_Value);end;
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
function FindParamName(execParams:TParams;FindValue:String):String;
var i:integer;
begin
  Result:='';
  if not Assigned(execParams) then exit;
  for i:=0 to execParams.Count-1 do
          if UpperCase(execParams.Items[i].AsString)=UpperCase(FindValue) then begin Result:=execParams.Items[i].Name;break;end;
end;
{------------------------------------------------------------------------------}
function FindTStringList(execList:TStringList;FindItem:String):boolean;
var i:integer;
begin
  Result:=false;
  if(not Assigned(execList))or(execList.Count=0) then exit;
  for i:=0 to execList.Count-1 do
          if UpperCase(execList[i])=UpperCase(FindItem)then begin Result:=true;break;end;
end;
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------}
//      создает TParam с названием поля _Name и типом _DataType
//      и добавляет к TParams
procedure ParamAdd(var Result:TParams;_Name:String;_DataType:TFieldType);
begin
     if not Assigned(Result) then Result:=TParams.Create;
     TParam.Create(Result,ptUnknown);
     Result[Result.Count-1].Name:=_Name;
     Result[Result.Count-1].DataType:=_DataType;
end;
{------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
// равно ли значение полей pParams значениям в DataSet
function EqualParams_DataSet(pParams: TParams;DataSet: TDataSet): boolean;
var i: integer;
begin
   result:=true;
   with DataSet do begin
     for i:=0 to pParams.Count-1 do begin
        result:=result and (pParams[i].asString=FieldByName(pParams[i].Name).AsString);
     end;
   end;
end;
{------------------------------------------------------------------------}


end.
