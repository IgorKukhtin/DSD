unit dmMainScale;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, Vcl.Dialogs,Forms,Vcl.StdCtrls;
type
  TDMMainScaleForm = class(TDataModule)
  public
    // !!!Scale + ScaleCeh!!!
    function gpGet_Scale_Partner(var execParams:TParams;inPartnerCode:Integer): Boolean;
    function gpGet_Scale_OrderExternal(var execParams:TParams;inBarCode:String): Boolean;
    function gpUpdate_Scale_Partner_print(PartnerId : Integer; isMovement,isAccount,isTransport,isQuality,isPack,isSpec,isTax : Boolean): Boolean;
    function gpGet_Scale_PartnerParams(var execParams:TParams): Boolean;
  end;

  // !!!Scale + ScaleCeh!!!
  function gpInitialize_MovementDesc: Boolean;

var
  DMMainScaleForm: TDMMainScaleForm;

implementation
uses DialogMovementDesc,UtilScale;
{------------------------------------------------------------------------}
function gpInitialize_MovementDesc: Boolean;
begin
   with DialogMovementDescForm do
   begin
        if ParamsMovement.ParamByName('MovementDescNumber').asInteger<>0 then
        begin
             CDS.Filter:='(Number='+IntToStr(ParamsMovement.ParamByName('MovementDescNumber').asInteger)
                        +')'
                          ;
             CDS.Filtered:=true;
             if CDS.RecordCount<>1
             then ShowMessage('Ошибка.Код операции не определен.')
             else begin ParamsMovement.ParamByName('MovementDescName_master').asString:= CDS.FieldByName('MovementDescName_master').asString;
                        ParamsMovement.ParamByName('GoodsKindWeighingGroupId').asInteger:=CDS.FieldByName('GoodsKindWeighingGroupId').asInteger;
                        ParamsMovement.ParamByName('isSendOnPriceIn').asBoolean:= CDS.FieldByName('isSendOnPriceIn').asBoolean;
                        ParamsMovement.ParamByName('isPartionGoodsDate').asBoolean:= CDS.FieldByName('isPartionGoodsDate').asBoolean;
                  end;
        end
        else ParamsMovement.ParamByName('MovementDescName_master').AsString:='Для <Нового взвешивания> нажмите на клавиатуре клавишу <F2>.';
   end;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_Partner(var execParams:TParams;inPartnerCode:Integer): Boolean;
begin
  Result:=false;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_OrderExternal(var execParams:TParams;inBarCode:String): Boolean;
begin
  Result:=false;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_Partner_print(PartnerId : Integer; isMovement,isAccount,isTransport,isQuality,isPack,isSpec,isTax : Boolean): Boolean;
begin
  Result:=false;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_PartnerParams(var execParams:TParams): Boolean;
begin
  Result:=false;
end;
{------------------------------------------------------------------------}
end.
