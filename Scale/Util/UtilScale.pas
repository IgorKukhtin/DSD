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

  TArrayList =  array of TListItem;

  TSettingMain = record
    ScaleNum:         integer;
    ComPort:          string;
    UserId:           integer;
  end;

  TSettingMovement = record
    OperDate:   TDateTime;

    MovementNumber:   integer;
    MovementDescId:   integer;
    FromId:           integer;
    FromCode:         integer;
    FromName:         string;
    ToId:             integer;
    ToCode:           integer;
    ToName:           string;
    PaidKindId:       integer;
    PaidKindName:     string;
    ColorGridValue:   integer;

    calcPartnerCode:    integer;
    calcPartnerName:    string;

    OrderExternalId:         integer;
    OrderExternal_BarCode:   string;
    OrderExternal_InvNumber: string;

    ContractId:       integer;
    ContractNumber:   string;

    PriceListId:      integer;
    PriceListCode:    integer;
    PriceListName:    string;
  end;

  function GetArrayList_Value_byName   (ArrayList:TArrayList;Name:String):String;
  function GetArrayList_Index_byName   (ArrayList:TArrayList;Name:String):Integer;
  function GetArrayList_Index_byNumber (ArrayList:TArrayList;Number:Integer):Integer;

  function isEqualFloatValues (Value1,Value2:Double):boolean;
  procedure MyDelay(mySec:Integer);

var
  SettingMain    : TSettingMain;
  SettingMovement: TSettingMovement;

  Default_Array       :TArrayList;
  Service_Array       :TArrayList;

implementation
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
end.
