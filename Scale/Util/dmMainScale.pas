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

    function gpSelect_Scale_OrderExternal(var execParams:TParams;inBarCode:String): Boolean;
    //function gpSelect_Scale_ParnerCode(var execParams:TParams;ParnerCode:String): Boolean;

    function gpInitialize_OperDate(var execParams:TParams):TDateTime;
    function gpInitialize_MovementDesc: Boolean;
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
function TDMMainScaleForm.gpSelect_Scale_OrderExternal(var execParams:TParams;inBarCode: String): Boolean;
begin
    with spSelect do
    begin
       StoredProcName:='gpSelect_Scale_OrderExternal';
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

         if  (DataSet.FieldByName('MovementDescId').asInteger = zc_Movement_Sale)
           or(DataSet.FieldByName('MovementDescId').asInteger = zc_Movement_ReturnOut)
         then begin
                   ParamByName('calcPartnerId').AsInteger:= ParamByName('ToId').AsInteger;
                   ParamByName('calcPartnerCode').AsInteger:= ParamByName('ToCode').AsInteger;
                   ParamByName('calcPartnerName').asString:= ParamByName('ToName').asString;
              end
         else if (DataSet.FieldByName('MovementDescId').asInteger = zc_Movement_ReturnIn)
               or(DataSet.FieldByName('MovementDescId').asInteger = zc_Movement_Income)
              then begin
                        ParamByName('calcPartnerId').AsInteger:= ParamByName('FromId').AsInteger;
                        ParamByName('calcPartnerCode').AsInteger:= ParamByName('FromCode').AsInteger;
                        ParamByName('calcPartnerName').asString:= ParamByName('FromName').asString;
                   end
              else begin
                        ParamByName('calcPartnerId').AsInteger:= 0;
                        ParamByName('calcPartnerCode').AsInteger:= 0;
                        ParamByName('calcPartnerName').asString:= '';
                   end;

         ParamByName('OrderExternalId').AsInteger:= DataSet.FieldByName('MovementId').asInteger;
         ParamByName('OrderExternal_BarCode').asString:= DataSet.FieldByName('BarCode').asString;
         ParamByName('OrderExternal_InvNumber').asString:= DataSet.FieldByName('InvNumber').asString;

         ParamByName('ContractId').AsInteger    := DataSet.FieldByName('ContractId').asInteger;
         ParamByName('ContractNumber').asString := DataSet.FieldByName('ContractNumber').asString;

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
function TDMMainScaleForm.gpInitialize_OperDate(var execParams:TParams):TDateTime;
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
function TDMMainScaleForm.gpInitialize_MovementDesc: Boolean;
begin
    Result:=false;

    with spSelect do
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
end.
