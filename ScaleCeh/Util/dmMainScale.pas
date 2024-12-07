unit dmMainScale;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, Vcl.Dialogs,Forms,Vcl.StdCtrls;
type
  TDMMainScaleForm = class(TDataModule)
  public
    // !!!Scale + ScaleCeh!!!
    function gpGet_Scale_Partner(var execParams:TParams;inPartnerCode:Integer): Boolean;
    function gpGet_Scale_OrderExternal(var execParams:TParams;inBarCode:String; inFromId_calc, inToId_calc : Integer): Boolean;
    function gpUpdate_Scale_Partner_print(PartnerId : Integer; isMovement,isAccount,isTransport,isQuality,isPack,isSpec,isTax : Boolean; CountMovement,CountAccount,CountTransport,CountQuality,CountPack,CountSpec,CountTax : Integer): Boolean;
    function gpGet_Scale_PartnerParams(var execParams:TParams): Boolean;
    function gpGet_Scale_PSW_delete (inPSW: String): String;
    function gpGet_Scale_Movement_OperDatePartner(var execParamsMovement:TParams): Boolean;

    function gpUpdate_Scale_MovementString(MovementId : Integer; MovementStringDesc, InvNumberPartner : String): Boolean;
    function gpUpdate_Scale_Movement_ChangePercentAmount(var execParams:TParams): Boolean;
    function gpUpdate_Scale_MovementDate(var execParams:TParams): Boolean;
  end;

  // !!!Scale + ScaleCeh!!!
  function gpInitialize_MovementDesc: Boolean;

var
  DMMainScaleForm: TDMMainScaleForm;

implementation
uses DialogMovementDesc,UtilScale,MainCeh;
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
             else begin ParamsMovement.ParamByName('MovementDescName_master').asString  := CDS.FieldByName('MovementDescName_master').asString;
                        ParamsMovement.ParamByName('GoodsKindWeighingGroupId').asInteger:=CDS.FieldByName('GoodsKindWeighingGroupId').asInteger;
                        ParamsMovement.ParamByName('DocumentKindId').AsInteger    := CDS.FieldByName('DocumentKindId').AsInteger;
                        ParamsMovement.ParamByName('DocumentKindName').asString   := CDS.FieldByName('DocumentKindName').asString;
                        ParamsMovement.ParamByName('isSendOnPriceIn').asBoolean   := CDS.FieldByName('isSendOnPriceIn').asBoolean;
                        ParamsMovement.ParamByName('isPartionGoodsDate').asBoolean:= CDS.FieldByName('isPartionGoodsDate').asBoolean;
                        ParamsMovement.ParamByName('isStorageLine').asBoolean     := CDS.FieldByName('isStorageLine').asBoolean;
                        ParamsMovement.ParamByName('isArticleLoss').asBoolean     := CDS.FieldByName('isArticleLoss').asBoolean;
                        ParamsMovement.ParamByName('isSubjectDoc').asBoolean      := CDS.FieldByName('isSubjectDoc').asBoolean;
                        ParamsMovement.ParamByName('isCalc_Sh').asBoolean         := CDS.FieldByName('isCalc_Sh').asBoolean;
                  end;
        end
        else ParamsMovement.ParamByName('MovementDescName_master').AsString:='Для <Нового взвешивания> нажмите на клавиатуре клавишу <F2>.';
   end;
   with MainCehForm do
     if (ParamsMovement.ParamByName('DocumentKindId').AsInteger = zc_Enum_DocumentKind_CuterWeight)
     or (ParamsMovement.ParamByName('DocumentKindId').AsInteger = zc_Enum_DocumentKind_RealWeight)
     or (ParamsMovement.ParamByName('DocumentKindId').AsInteger = zc_Enum_DocumentKind_RealDelicShp)
     or (ParamsMovement.ParamByName('DocumentKindId').AsInteger = zc_Enum_DocumentKind_RealDelicMsg)
     or (ParamsMovement.ParamByName('DocumentKindId').AsInteger = zc_Enum_DocumentKind_LakTo)
     or (ParamsMovement.ParamByName('DocumentKindId').AsInteger = zc_Enum_DocumentKind_LakFrom)
     then cxDBGridDBTableView.Columns[cxDBGridDBTableView.GetColumnByFieldName('PartionGoods').Index].Visible := TRUE;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_PSW_delete (inPSW: String): String;
begin
      Result:='';
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_Partner(var execParams:TParams;inPartnerCode:Integer): Boolean;
begin
  Result:=false;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_OrderExternal(var execParams:TParams;inBarCode:String; inFromId_calc, inToId_calc : Integer): Boolean;
begin
  Result:=false;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_Partner_print(PartnerId : Integer; isMovement,isAccount,isTransport,isQuality,isPack,isSpec,isTax : Boolean; CountMovement,CountAccount,CountTransport,CountQuality,CountPack,CountSpec,CountTax : Integer): Boolean;
begin
  Result:=false;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_MovementString(MovementId : Integer; MovementStringDesc, InvNumberPartner : String): Boolean;
begin
  Result:=false;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_MovementDate(var execParams:TParams): Boolean;
begin
  Result:=false;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpUpdate_Scale_Movement_ChangePercentAmount(var execParams:TParams): Boolean;
begin
  Result:=false;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_PartnerParams(var execParams:TParams): Boolean;
begin
  Result:=false;
end;
{------------------------------------------------------------------------}
function TDMMainScaleForm.gpGet_Scale_Movement_OperDatePartner(var execParamsMovement:TParams): Boolean;
begin
  Result:=false;
end;
{------------------------------------------------------------------------}
end.
