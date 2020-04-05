unit dmMainScaleCeh;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, Vcl.Dialogs,Forms,Vcl.StdCtrls;
type
  TDMMainScaleCehForm = class(TDataModule)
  public
    // !!!Scale + ScaleCeh!!!
    function gpGet_Scale_OrderExternal(var execParams:TParams;inBarCode:String;FromId_calc, ToId_calc:Integer): Boolean;
  end;

  // !!!Scale + ScaleCeh!!!
//  function gpInitialize_MovementDesc: Boolean;

var
  DMMainScaleCehForm: TDMMainScaleCehForm;

implementation
//uses DialogMovementDesc,UtilScale;
{------------------------------------------------------------------------}
function TDMMainScaleCehForm.gpGet_Scale_OrderExternal(var execParams:TParams;inBarCode:String;FromId_calc, ToId_calc:Integer): Boolean;
begin
  Result:=false;
end;
{------------------------------------------------------------------------}
end.
