unit dmMainScale;

interface

uses
  System.SysUtils, System.Classes, dsdDB, Data.DB, Datasnap.DBClient, Vcl.Dialogs,UtilScale;

type
  TDMMainScaleForm = class(TDataModule)
    ClientDataSet: TClientDataSet;
    spSelect: TdsdStoredProc;
  private
  public
    function gpSelect_ToolsWeighing_onLevelChild(inScaleNum:Integer;inLevelChild: String): TArrayList;
    function gpGet_ToolsWeighing_Value(inLevel1,inLevel2,inLevel3,inItemName,inDefaultValue:String):String;
    function gpGetObject_byCode (inCode, inDescId: integer): TDBObject;

    function gpSelect_Scale_OrderExternal(var SettingMovement_local:TSettingMovement;inOperDate:TDateTime;inBarCode:String): Boolean;
    function gpSelect_Scale_OperDate(var SettingMovement_global:TSettingMovement):TDateTime;
  end;

var
  DMMainScaleForm: TDMMainScaleForm;

implementation
{$R *.dfm}
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(inScaleNum:Integer;inLevelChild: String): TArrayList;
var
    i: integer;
begin
    with spSelect do
    begin
       StoredProcName:='gpSelect_Object_ToolsWeighing_onLevelChild';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inScaleNum', ftInteger, ptInput, inScaleNum);
       Params.AddParam('inLevelChild', ftString, ptInput, inLevelChild);
       //try
         Execute;
         SetLength(Result, DataSet.RecordCount);
         for I := 0 to DataSet.RecordCount-1 do
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
function TDMMainScaleForm.gpGetObject_byCode(inCode, inDescId: integer): TDBObject;
begin
    with spSelect do
    begin
       StoredProcName:='gpGetObject_byCode';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inCode', ftInteger, ptInput, inCode);
       Params.AddParam('inDescId', ftInteger, ptInput, inDescId);
       Params.AddParam('outId', ftInteger, ptOutput, 0);
       Params.AddParam('outName', ftString, ptOutput, '');

       //try
         Execute;
         Result.Code := inCode;
         Result.Id   := ParamByName('outId').Value;
         Result.Name := ParamByName('outName').Value;
       {except
         result.Code := Code;
         result.Id   := 0;
         result.Name := '';
         ShowMessage('Ошибка получения - gpGetObject_byCode');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpSelect_Scale_OrderExternal(var SettingMovement_local:TSettingMovement;inOperDate:TDateTime;inBarCode: String): Boolean;
begin
    with spSelect do
    begin
       StoredProcName:='gpSelect_Scale_OrderExternal';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inOperDate', ftDateTime, ptInput, inOperDate);
       Params.AddParam('inBarCode', ftString, ptInput, inBarCode);
       //try
         Execute;
         //
         Result:=DataSet.RecordCount=1;
         //
         SettingMovement_local.OrderExternalId         := DataSet.FieldByName('MovementId').asInteger;
         SettingMovement_local.OrderExternal_BarCode   := DataSet.FieldByName('BarCode').asString;
         SettingMovement_local.OrderExternal_InvNumber := DataSet.FieldByName('InvNumber').asString;

         SettingMovement_local.MovementDescId:= DataSet.FieldByName('MovementDescId').asInteger;
         SettingMovement_local.FromId        := DataSet.FieldByName('ToId').asInteger;
         SettingMovement_local.FromName      := DataSet.FieldByName('ToName').asString;
         SettingMovement_local.ToId          := DataSet.FieldByName('FromId').asInteger;
         SettingMovement_local.ToName        := DataSet.FieldByName('FromName').asString;
         SettingMovement_local.PaidKindId    := DataSet.FieldByName('PaidKindId').asInteger;
         SettingMovement_local.PaidKindName  := DataSet.FieldByName('PaidKindName').asString;

         SettingMovement_local.PriceListId   := DataSet.FieldByName('PriceListId').asInteger;
         SettingMovement_local.PriceListCode := DataSet.FieldByName('PriceListCode').asInteger;
         SettingMovement_local.PriceListName := DataSet.FieldByName('PriceListName').asString;

         SettingMovement_local.ContractId    := DataSet.FieldByName('ContractId').asInteger;
         SettingMovement_local.ContractNumber:= DataSet.FieldByName('ContractNumber').asString;


       {except
         result.Code := Code;
         result.Id   := 0;
         result.Name := '';
         ShowMessage('Ошибка получения - gpGetObject_byCode');
       end;}
    end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpSelect_Scale_OperDate(var SettingMovement_global:TSettingMovement):TDateTime;
begin
    with spSelect do
    begin
       StoredProcName:='gpSelect_Scale_OperDate';
       OutputType:=otDataSet;
       Params.Clear;
       //try
         Execute;
         //
         Result:=DataSet.FieldByName('OperDate').asDateTime;
         SettingMovement_global.OperDate:=DataSet.FieldByName('OperDate').asDateTime;

       {except
         result.Code := Code;
         result.Id   := 0;
         result.Name := '';
         ShowMessage('Ошибка получения - gpGetObject_byCode');
       end;}
    end;
end;
{------------------------------------------------------------------------}
end.
