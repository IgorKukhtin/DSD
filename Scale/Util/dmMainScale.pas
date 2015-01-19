unit dmMainScale;

interface

uses
  System.SysUtils, System.Classes, dsdDB, Data.DB, Datasnap.DBClient, Vcl.Dialogs,UtilScale
 ,dmMainTest;

type
  TDMMainScaleForm = class(TDataModule)
    ClientDataSet: TClientDataSet;
    spSelect: TdsdStoredProc;
  private
  public
    function gpSelect_ToolsWeighing_onLevelChild(inScaleNum:Integer;inLevelChild: String): TArrayList;
    function gpGet_ToolsWeighing_Value(inLevel1,inLevel2,inLevel3,inItemName,inDefaultValue:String):String;
    function gpGetObject_byCode (Code, DescId: integer): TDBObject;
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
function TDMMainScaleForm.gpGetObject_byCode(Code, DescId: integer): TDBObject;
begin
    with spSelect do
    begin
       StoredProcName:='gpGetObject_byCode';
       OutputType:=otDataSet;
       Params.Clear;
       Params.AddParam('inCode', ftInteger, ptInput, Code);
       Params.AddParam('inDescId', ftInteger, ptInput, DescId);
       Params.AddParam('outId', ftInteger, ptOutput, 0);
       Params.AddParam('outName', ftString, ptOutput, '');

       //try
         Execute;
         Result.Code := Code;
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
end.
