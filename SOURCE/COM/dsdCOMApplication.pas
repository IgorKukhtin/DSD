unit dsdCOMApplication;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, Project_TLB, StdVcl, dsdDB;

type
  TdsdCOMApplication = class(TAutoObject, IdsdCOMApplication)
  private
    spInsertUpdate_Movement_OrderExternal_1C: TdsdStoredProc;
  protected
    procedure InsertUpdate_Movement_OrderExternal_1C(var ioId, ioMovementItemId
      : Integer; const inInvNumber, inInvNumberPartner: WideString;
      inOperDate: TDateTime; inFromCode_1C, inGoodsCode_1C: Integer;
      inAmount, inPrice: Double); safecall;
  public
    procedure Initialize; override;
  end;

implementation

uses ComServ, DB, SysUtils;

procedure TdsdCOMApplication.Initialize;
begin
  inherited;
  spInsertUpdate_Movement_OrderExternal_1C := TdsdStoredProc.Create(nil);
  with spInsertUpdate_Movement_OrderExternal_1C, Params do
  begin
    StoredProcName := 'gpInsertUpdate_Movement_OrderExternal_1C';
    OutputType := otResult;
    AddParam('ioId', ftInteger, ptInputOutput, 0);
    AddParam('ioMovementItemId', ftInteger, ptInputOutput, 0);
    AddParam('inInvNumber', ftString, ptInput, '');
    AddParam('inInvNumberPartner', ftString, ptInput, '');
    AddParam('inOperDate', ftDateTime, ptInput, Date);
    AddParam('inFromCode_1C', ftInteger, ptInput, 0);
    AddParam('inGoodsCode_1C', ftInteger, ptInput, 0);
    AddParam('inAmount', ftFloat, ptInput, 0);
    AddParam('inPrice', ftFloat, ptInput, 0);
  end;
end;

procedure TdsdCOMApplication.InsertUpdate_Movement_OrderExternal_1C(var ioId, ioMovementItemId: Integer;
          const inInvNumber, inInvNumberPartner: WideString; inOperDate: TDateTime;
          inFromCode_1C, inGoodsCode_1C: Integer; inAmount, inPrice: Double);

begin
  with spInsertUpdate_Movement_OrderExternal_1C do begin
       ParamByName('ioId').Value := ioId;
       ParamByName('ioMovementItemId').Value := ioMovementItemId;
       ParamByName('inInvNumber').Value := inInvNumber;
       ParamByName('inInvNumberPartner').Value := inInvNumberPartner;
       ParamByName('inOperDate').Value := inOperDate;
       ParamByName('inFromCode_1C').Value := inFromCode_1C;
       ParamByName('inGoodsCode_1C').Value := inGoodsCode_1C;
       ParamByName('inAmount').Value := inAmount;
       ParamByName('inPrice').Value := inPrice;
       Execute;
       ioId := ParamByName('ioId').Value;
       ioMovementItemId := ParamByName('ioMovementItemId').Value;
  end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TdsdCOMApplication, Class_dsdCOMApplication,
    ciMultiInstance, tmApartment);
end.
