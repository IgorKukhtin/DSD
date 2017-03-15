unit UtilScale;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, Vcl.Dialogs,Forms,Vcl.StdCtrls;

const
    fmtWeight:String = ',0.#### ��.';
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

  TScaleType = (stBI, stDB, stZeus);

  TListItemScale = record
    Number   : Integer;
    ScaleType: TScaleType;
    ScaleName: string;
    COMPort  : Integer;
  end;

  TArrayList = array of TListItem;
  TArrayListScale = array of TListItemScale;

  TSettingMain = record
    isCeh:Boolean;          // ScaleCeh or Scale
    isGoodsComplete:Boolean;// ScaleCeh or Scale - ����� ��/������������/�������� or �������
    WeightSkewer1:Double;   // only ScaleCeh
    WeightSkewer2:Double;   // only ScaleCeh
    Exception_WeightDiff:Double; // only Scale
    BranchCode:Integer;
    BranchName:String;
    ScaleCount:Integer;
    DefaultCOMPort:Integer;
    IndexScale_old:Integer;
  end;

  function gpCheck_BranchCode: Boolean;

  function Recalc_PartionGoods(Edit:TEdit):Boolean;

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
  procedure Create_ParamsPersonal(var Params:TParams; idx:String);
  procedure Create_ParamsPersonalComplete(var Params:TParams);
  procedure Create_ParamsWorkProgress(var Params:TParams);

  // ������� TParam � ��������� ���� _Name � ����� _DataType � ��������� � TParams
  procedure ParamAdd(var execParams:TParams;_Name:String;_DataType:TFieldType);
  // ������� TParam � ��������� ���� _Name � ����� _DataType � ��������� � TParams �� ��������� _Value
  procedure ParamAddValue(var execParams: TParams;_Name:String;_DataType:TFieldType;_Value: variant);
  // ���������� ������ �������� ���������� FindName � TParams
  function GetIndexParams(execParams:TParams;FindName:String):Integer;
  //
  procedure CopyValuesParamsFrom(var fromParams,toParams:TParams);
  procedure EmptyValuesParams(var execParams:TParams);

  function CheckBarCode(BarCode:String):Boolean;
  function CalcBarCode(BarCode:String):String;
  function myStrToFloat(Value:String):Double;
  function myReplaceStr(const S, Srch, Replace: string): string;

var
  UserId_begin : Integer;
  UserName_begin : String;

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

  zc_Movement_OrderExternal: Integer;

  zc_Enum_InfoMoney_30201: Integer; // ������ + ������ ����� + ������ �����

  zc_Enum_DocumentKind_CuterWeight: Integer; // ����������� �/� ���� �������

  zc_Object_Partner    : Integer;
  zc_Object_ArticleLoss: Integer;
  zc_Object_Unit       : Integer;

//  zc_Measure_Sh: Integer;
  zc_Measure_Kg: Integer;

  zc_BarCodePref_Object  :String;
  zc_BarCodePref_Movement:String;
  zc_BarCodePref_MI      :String;

implementation
//uses DMMainScale;
{------------------------------------------------------------------------}
procedure Create_ParamsMovement(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'ColorGridValue',ftInteger);
     ParamAdd(Params,'OperDate',ftDateTime);

     ParamAdd(Params,'MovementId_begin',ftInteger);//�������� ������� ��������� ����� �������� "��������� �����������", �.�. ����� Save_Movement_all

     ParamAdd(Params,'MovementId_get',ftInteger);//�������� ����������� ������������ ��� gpGet_Scale_OrderExternal !!!������ ��� ������!!!, ����� ����������� � MovementId

     ParamAdd(Params,'MovementId',ftInteger); //�������� �����������
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

     ParamAdd(Params,'InfoMoneyId',ftInteger);
     ParamAdd(Params,'InfoMoneyCode',ftInteger);
     ParamAdd(Params,'InfoMoneyName',ftString);

     ParamAdd(Params,'isGetPartner',ftBoolean); //��������� ��������
     ParamAdd(Params,'calcPartnerId',ftInteger);
     ParamAdd(Params,'calcPartnerCode',ftInteger);
     ParamAdd(Params,'calcPartnerName',ftString);
     ParamAdd(Params,'ChangePercentAmount',ftFloat);
     ParamAdd(Params,'ChangePercent',ftFloat);

     ParamAdd(Params,'isTransport_link',ftBoolean);
     ParamAdd(Params,'TransportId',ftInteger);
     ParamAdd(Params,'Transport_BarCode',ftString);
     ParamAdd(Params,'Transport_InvNumber',ftString);
     ParamAdd(Params,'PersonalDriverId',ftInteger);
     ParamAdd(Params,'PersonalDriverName',ftString);
     ParamAdd(Params,'CarName',ftString);
     ParamAdd(Params,'RouteName',ftString);

     ParamAdd(Params,'isEdiOrdspr',ftBoolean); //�������������
     ParamAdd(Params,'isEdiInvoice',ftBoolean);//����
     ParamAdd(Params,'isEdiDesadv',ftBoolean); //�����������

     ParamAdd(Params,'isMovement',ftBoolean);  //���������
     ParamAdd(Params,'isAccount',ftBoolean);   //����
     ParamAdd(Params,'isTransport',ftBoolean); //���
     ParamAdd(Params,'isQuality',ftBoolean);   //������������
     ParamAdd(Params,'isPack',ftBoolean);      //�����������
     ParamAdd(Params,'isSpec',ftBoolean);      //������������
     ParamAdd(Params,'isTax',ftBoolean);       //���������

     ParamAdd(Params,'CountMovement',ftInteger);  //���������
     ParamAdd(Params,'CountAccount',ftInteger);   //����
     ParamAdd(Params,'CountTransport',ftInteger); //���
     ParamAdd(Params,'CountQuality',ftInteger);   //������������
     ParamAdd(Params,'CountPack',ftInteger);      //�����������
     ParamAdd(Params,'CountSpec',ftInteger);      //������������
     ParamAdd(Params,'CountTax',ftInteger);       //���������

     ParamAdd(Params,'isSendOnPriceIn',ftBoolean);
     ParamAdd(Params,'isPartionGoodsDate',ftBoolean);

     ParamAdd(Params,'OrderExternalId',ftInteger);
     ParamAdd(Params,'OrderExternal_DescId',ftInteger);
     ParamAdd(Params,'OrderExternal_BarCode',ftString);
     ParamAdd(Params,'OrderExternal_InvNumber',ftString);
     ParamAdd(Params,'OrderExternalName_master',ftString);

     ParamAdd(Params,'ContractId',ftInteger);
     ParamAdd(Params,'ContractCode',ftInteger);
     ParamAdd(Params,'ContractNumber',ftString);
     ParamAdd(Params,'ContractTagName',ftString);

     ParamAdd(Params,'GoodsPropertyId',ftInteger);
     ParamAdd(Params,'GoodsPropertyCode',ftInteger);
     ParamAdd(Params,'GoodsPropertyName',ftString);

     ParamAdd(Params,'PriceListId',ftInteger);
     ParamAdd(Params,'PriceListCode',ftInteger);
     ParamAdd(Params,'PriceListName',ftString);

     ParamAdd(Params,'DocumentKindId',ftInteger);
     ParamAdd(Params,'DocumentKindName',ftString);

     ParamAdd(Params,'GoodsKindWeighingGroupId',ftInteger);

     ParamAdd(Params,'MovementDescName_master',ftString);

     ParamAdd(Params,'isComlete',ftBoolean);//��������� ��������, ����� ��������� ���������
     ParamAdd(Params,'isMovementId_check',ftBoolean);//��������� ��������, Insert ��� Update � TDialogMovementDescForm

     ParamAdd(Params,'TotalSumm',ftFloat);

end;
{------------------------------------------------------------------------}
procedure Create_ParamsMI(var Params:TParams);
begin
     Params:=nil;
     if SettingMain.isCeh = FALSE then
     begin
     ParamAdd(Params,'GoodsId',ftInteger);           // ������
     ParamAdd(Params,'GoodsCode',ftInteger);         // ������
     ParamAdd(Params,'GoodsName',ftString);          // ������
     ParamAdd(Params,'GoodsKindId',ftInteger);       // ���� �������
     ParamAdd(Params,'GoodsKindCode',ftInteger);     // ���� �������
     ParamAdd(Params,'GoodsKindName',ftString);      // ���� �������
     ParamAdd(Params,'RealWeight_Get',ftFloat);      //
     ParamAdd(Params,'RealWeight',ftFloat);          // �������� ��� (��� �����: ����� ���� � % ������ ��� ���-��)
     ParamAdd(Params,'CountTare',ftFloat);           // ���������� ����
     ParamAdd(Params,'WeightTare',ftFloat);          // ��� 1-�� ����
     ParamAdd(Params,'ChangePercentAmount',ftFloat); // % ������ ��� ���-��
     ParamAdd(Params,'Price',ftFloat);               //
     ParamAdd(Params,'Price_Return',ftFloat);        //
     ParamAdd(Params,'CountForPrice',ftFloat);       //
     ParamAdd(Params,'CountForPrice_Return',ftFloat);//
     ParamAdd(Params,'Count',ftFloat);               // ���������� ������� ��� ���������� �������
     ParamAdd(Params,'HeadCount',ftFloat);           // ���������� �����
     ParamAdd(Params,'BoxCount',ftFloat);            //
     ParamAdd(Params,'BoxCode',ftInteger);           //
     ParamAdd(Params,'PartionGoods',ftString);       //
     ParamAdd(Params,'isBarCode',ftBoolean);         //
     ParamAdd(Params,'MovementId_Promo',ftInteger);  //
     end
     else
     begin
     ParamAdd(Params,'GoodsId',ftInteger);           // ������
     ParamAdd(Params,'GoodsCode',ftInteger);         // ������
     ParamAdd(Params,'GoodsName',ftString);          // ������
     ParamAdd(Params,'GoodsKindId',ftInteger);       // ���� �������
     ParamAdd(Params,'GoodsKindCode',ftInteger);     // ���� �������
     ParamAdd(Params,'GoodsKindName',ftString);      // ���� �������

     ParamAdd(Params,'GoodsKindId_list',ftString);   // ���� �������
     ParamAdd(Params,'GoodsKindName_List',ftString); // ���� �������

     ParamAdd(Params,'GoodsKindId_max',ftInteger);   // ���� �������
     ParamAdd(Params,'GoodsKindCode_max',ftInteger); // ���� �������
     ParamAdd(Params,'GoodsKindName_max',ftString);  // ���� �������

     ParamAdd(Params,'MeasureId',ftInteger);         // ������� ���������
     ParamAdd(Params,'MeasureCode',ftInteger);       // ������� ���������
     ParamAdd(Params,'MeasureName',ftString);        // ������� ���������
     ParamAdd(Params,'OperCount',ftFloat);           // ���������� (� ������: ����� ���� � ������)
     ParamAdd(Params,'RealWeight',ftFloat);          // �������� ��� (��� �����: ����� ���� � ������)
     ParamAdd(Params,'WeightTare',ftFloat);          // ��� ����
     ParamAdd(Params,'WeightOther',ftFloat);         // ���, ������
     ParamAdd(Params,'CountSkewer1',ftFloat);        // ���������� ������/������� ����1
     ParamAdd(Params,'CountSkewer2',ftFloat);        // ���������� ������/������� ����2
     ParamAdd(Params,'Count',ftFloat);               // ���������� �������
     ParamAdd(Params,'CountPack',ftFloat);           // ���������� �������
     ParamAdd(Params,'HeadCount',ftFloat);           // ���������� �����
     ParamAdd(Params,'LiveWeight',ftFloat);          // ����� ���
     ParamAdd(Params,'PartionGoods',ftString);       //
     ParamAdd(Params,'PartionGoodsDate',ftDateTime); //
     ParamAdd(Params,'isStartWeighing',ftBoolean);   //��������� ��������
     end;

end;
{------------------------------------------------------------------------}
procedure Create_ParamsPersonal(var Params:TParams;idx:String);
begin
     if (idx = '') or (idx = '1') then Params:=nil;

     ParamAdd(Params,'PersonalId'+idx, ftInteger);   //
     ParamAdd(Params,'PersonalCode'+idx, ftInteger); //
     ParamAdd(Params,'PersonalName'+idx, ftString);  //
     ParamAdd(Params,'PositionId'+idx, ftInteger);   //
     ParamAdd(Params,'PositionCode'+idx, ftInteger); //
     ParamAdd(Params,'PositionName'+idx, ftString);  //
end;
{------------------------------------------------------------------------}
procedure Create_ParamsPersonalComplete(var Params:TParams);
begin
     Create_ParamsPersonal(Params, '1');
     Create_ParamsPersonal(Params, '2');
     Create_ParamsPersonal(Params, '3');
     Create_ParamsPersonal(Params, '4');
     ParamAdd(Params,'MovementId', ftInteger);
     ParamAdd(Params,'InvNumber',ftString);
     ParamAdd(Params,'OperDate',ftDateTime);
     ParamAdd(Params,'MovementDescId',ftInteger);
     ParamAdd(Params,'FromName',ftString);
     ParamAdd(Params,'ToName',ftString);
end;
{------------------------------------------------------------------------}
procedure Create_ParamsWorkProgress(var Params:TParams);
begin
     Params:=nil;
     ParamAdd(Params,'OperDate',ftDateTime);         //
     ParamAdd(Params,'UnitId',ftInteger);            //
     ParamAdd(Params,'GoodsId',ftInteger);           // ������
     ParamAdd(Params,'GoodsCode',ftInteger);         // ������
     ParamAdd(Params,'GoodsName',ftString);          // ������
     ParamAdd(Params,'MeasureId',ftInteger);         //
     ParamAdd(Params,'MeasureCode',ftInteger);       //
     ParamAdd(Params,'MeasureName',ftString);        //
     ParamAdd(Params,'MovementItemId',ftInteger);    //
     ParamAdd(Params,'MovementInfo',ftString);       //
end;
{------------------------------------------------------------------------}
{------------------------------------------------------------------------}
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
    if (ArrayList[i].Value = Value)
       or ((myStrToFloat(ArrayList[i].Value) = myStrToFloat(Value))
           and (myStrToFloat(Value) <> 0))
    then begin Result:=i;break;end;
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
// ������� TParam � ��������� ���� _Name � ����� _DataType � ��������� � TParams
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
// ������� TParam � ��������� ���� _Name � ����� _DataType � ��������� � TParams �� ��������� _Value
procedure ParamAddValue(var execParams: TParams;_Name:String;_DataType:TFieldType;_Value: variant);
begin
  if not Assigned(execParams) then execParams:=TParams.Create;
  ParamAdd(execParams,_Name,_DataType);
  execParams.Items[GetIndexParams(execParams,_Name)].Value:=_Value;
end;
{------------------------------------------------------------------------------}
function GetIndexParams(execParams:TParams;FindName:String):Integer;//���������� ������ �������� ���������� FindName � TParams
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
         if execParams[i].DataType=ftBoolean
         then execParams.ParamByName(Items[i].Name).AsBoolean:=false
         else
             if execParams[i].DataType=ftInteger
             then execParams.ParamByName(Items[i].Name).AsInteger:=0
             else
                 if execParams[i].DataType=ftFloat
                 then execParams.ParamByName(Items[i].Name).AsFloat:=0
                 else
                    if (execParams[i].DataType<>ftDate) and (execParams[i].DataType<>ftDateTime)
                    then execParams.ParamByName(Items[i].Name).AsString:='';
    end;
end;
{------------------------------------------------------------------------------}
function CheckBarCode(BarCode:String):Boolean;
var Summ:String;
    Summ_show:String;
begin
     Summ:=CalcBarCode(BarCode);
     Result:=(Summ<>'')and(LengTh(BarCode)=13);
     if not Result then exit;
     //
     Result:=BarCode[13]=Summ;

     if UserId_begin = 5
     then Summ_show:='('+Summ+')'
     else Summ_show:='';

     if not Result then ShowMessage('������ � �������� <����� ���> = <'+BarCode+'>.'+Summ_show);
end;
{------------------------------------------------------------------------------}
function CalcBarCode(BarCode:String):String;
var Summ:Integer;
begin
     if LengTh(BarCode)>=12
     then
     try Summ:=   StrToInt(BarCode[1])+StrToInt(BarCode[3])+StrToInt(BarCode[5])+StrToInt(BarCode[7])+StrToInt(BarCode[9])+StrToInt(BarCode[11])
              +3*(StrToInt(BarCode[2])+StrToInt(BarCode[4])+StrToInt(BarCode[6])+StrToInt(BarCode[8])+StrToInt(BarCode[10])+StrToInt(BarCode[12]));
     except Summ:=-1;end
     else Summ:=-1;
     //
     if Summ>0 then
     begin
          Summ:=Summ mod 10;
          if Summ<>0 then Summ:=10-Summ;
     end
     else Summ:=-1;
     //
     if Summ <> -1
     then Result:=IntToStr(Summ)
     else Result:='';
end;
{------------------------------------------------------------------------------}
function myStrToFloat(Value:String):Double;
begin
     Value:=trim(Value);
     //
     try
         if (System.Pos('.',Value)>0)and(DecimalSeparator<>'.')
         then Result:=StrToFloat(myReplaceStr(Value,'.',DecimalSeparator))
         else if (System.Pos(',',Value)>0)and(DecimalSeparator<>',')
              then Result:=StrToFloat(myReplaceStr(Value,'.',DecimalSeparator))
              else Result:=StrToFloat(Value);
     except
            Result:=0;
     end;
end;
{------------------------------------------------------------------------------}
function myReplaceStr(const S, Srch, Replace: string): string;
var
  I: Integer;
  Source: string;
begin
  Source := S;
  Result := '';
  repeat
    I := Pos(Srch, Source);
    if I > 0 then begin
      Result := Result + Copy(Source, 1, I - 1) + Replace;
      Source := Copy(Source, I + Length(Srch), MaxInt);
    end
    else Result := Result + Source;
  until I <= 0;
end;
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
function zf_Calc_Word_bySeparate(myStr,Sep1,Sep2:String;myWordNumber:smallint):String;
var i,finSeparate:Integer;
    findIndex,findIndex_next:Integer;
begin
     if myWordNumber<=0 then begin Result:='';exit;end;
     //
     finSeparate:=0;
     findIndex:=0;
     findIndex_next:=0;
     for i:=1 to LengTh(myStr) do begin
        if (myStr[i]=Sep1)or(myStr[i]=Sep2) then finSeparate:=finSeparate+1;
        if (finSeparate=myWordNumber-1)and(findIndex=0) then findIndex:=i;
        if (finSeparate=myWordNumber)and(findIndex_next=0) then findIndex_next:=i;
     end;
     try
        if myWordNumber=1 then if findIndex_next=0 then Result:=myStr else Result:=System.Copy(myStr,findIndex,findIndex_next-1)
        else if (myWordNumber>finSeparate+1) then Result:=''
             else if findIndex_next=0 then Result:=System.Copy(myStr,findIndex+1,LengTh(myStr)-findIndex)
                  else Result:=System.Copy(myStr,findIndex+1,findIndex_next-findIndex-1);
        except ShowMessage('zf_Calc_Word_bySeparate<'+myStr+'><'+IntToStr(myWordNumber)+'>');
               Result:='';
     end;
end;
{------------------------------------------------------------------------------}
function zf_Calc_WordCount_bySeparate(myStr,Sep1,Sep2:String):smallint;
var i:Integer;
begin
     Result:=0;
     for i:=1 to LengTh(myStr) do
        if (myStr[i]=Sep1)or(myStr[i]=Sep2) then Result:=Result+1;
     //
     if trim(myStr)<>'' then Result:=Result+1;
end;
{------------------------------------------------------------------------------}
function myCalcPartionGoods(PartionStr:String):String;
var myPartionDate,myClientStr,myGoodsMainStr,myOperInfoStr:String;
    myDay_str,myMonth_str,myYear_str:String;
    myDay,myMonth,myYear:Word;
    myBillDate:TDateTime;
    Year, Month, Day: Word;
    myWordCount,myWordCountD:smallint;
begin
     PartionStr:=trim(PartionStr);
     //
     myWordCountD:=zf_Calc_WordCount_bySeparate(PartionStr,'.','xxxxxxxxx');
     if myWordCountD=1 then
     try
         myWordCountD:=zf_Calc_WordCount_bySeparate(PartionStr,'-','xxxxxxxxx');
         myMonth:=StrToInt(zf_Calc_Word_bySeparate(PartionStr,'-','.',myWordCountD));
         myBillDate:=ParamsMovement.ParamByName('OperDate').AsDateTime;
         DecodeDate(myBillDate, Year, Month, Day);
         if Month>=myMonth then myYear:=Year else myYear:=Year-1;
         PartionStr:=PartionStr+'-'+IntToStr(myYear)
     except
     end;
     //
     myWordCount:=zf_Calc_WordCount_bySeparate(PartionStr,'-','.');
     //
     myClientStr:=zf_Calc_Word_bySeparate(PartionStr,'-','.',myWordCount-3);//System.Copy(PartionStr,1,3);

     myOperInfoStr:='';
     if myWordCount=4
     then myGoodsMainStr:=''
     else if myWordCount=5
          then myGoodsMainStr:=zf_Calc_Word_bySeparate(PartionStr,'-','.',1)
          else if myWordCount=6
               then begin myGoodsMainStr:=zf_Calc_Word_bySeparate(PartionStr,'-','.',2);
                          myOperInfoStr:=zf_Calc_Word_bySeparate(PartionStr,'-','.',1);
                    end
          else begin Result:='';exit;end;
     //
     try
         myDay:=StrToInt(zf_Calc_Word_bySeparate(PartionStr,'-','.',myWordCount-2));//StrToInt(System.Copy(PartionStr,5,2));
         myMonth:=StrToInt(zf_Calc_Word_bySeparate(PartionStr,'-','.',myWordCount-1));//StrToInt(System.Copy(PartionStr,8,2));
         myBillDate:=ParamsMovement.ParamByName('OperDate').AsDateTime;
         DecodeDate(myBillDate, Year, Month, Day);
         if Month>=myMonth then myYear:=Year else myYear:=Year-1;
     except
           myBillDate:=StrToDate('01.01.2000');
           myMonth:=0;
           myYear:=0;
     end;
     //
     if myDay  <10  then myDay_str:=  '0'  +IntToStr(myDay)   else myDay_str:=   IntToStr(myDay);
     if myMonth<10  then myMonth_str:='0'  +IntToStr(myMonth) else myMonth_str:= IntToStr(myMonth);
     if myYear <100 then myYear_str:= '20' +IntToStr(myYear)  else myYear_str:=  IntToStr(myYear);
     if myYear <10  then myYear_str:= '200'+IntToStr(myYear)  else myYear_str:=  IntToStr(myYear);

     myPartionDate:=myDay_str+'.'+myMonth_str+'.'+myYear_str;
     //
     try if (StrToDate(myPartionDate)>myBillDate)//or(abs(StrToDate(myPartionDate)-myBillDate)>31)
         then Result:=''
         else if myOperInfoStr<>'' then Result:=myOperInfoStr+'-'+myGoodsMainStr+'-'+myClientStr+'-'+myPartionDate
              else if myGoodsMainStr<>'' then Result:=myGoodsMainStr+'-'+myClientStr+'-'+myPartionDate
                   else Result:=myClientStr+'-'+myPartionDate;//ReplaceStr(myPartionDate,'.','.')
     except Result:=''
     end;
end;
//------------------------------------------------------------------------------------------------
function Recalc_PartionGoods(Edit:TEdit):Boolean;
var PartionGoods:String;
begin
        if  (trim(Edit.Text)<>'')
        and((ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_Sale)
          or(ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_ReturnIn)
          or(ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_Loss)
          or(ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_Inventory)
          or(ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_Send)
          or(ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_ProductionUnion)
          or(ParamsMovement.ParamByName('MovementDescId').AsInteger= zc_Movement_ProductionSeparate)
           )
        then begin
                  PartionGoods:=myCalcPartionGoods(Edit.Text);
                  Result:=PartionGoods<>'';
                  if Result then Edit.Text:=PartionGoods;
        end
        else begin
                  Result:=true;
                  Edit.Text:='';
             end;
end;
{------------------------------------------------------------------------------}
function gpCheck_BranchCode: Boolean;
begin
    Result:=((SettingMain.isCeh = FALSE) and ((SettingMain.BranchCode = 201) or (SettingMain.BranchCode < 100)))
          or((SettingMain.isCeh = TRUE) and ((SettingMain.BranchCode = 1) or (SettingMain.BranchCode > 100)));
    //
    if not Result
    then ShowMessage('������.������ ��������� ��� ������� <'+IntToStr(SettingMain.BranchCode)+'> �� ������������.');
end;
{------------------------------------------------------------------------}
end.
