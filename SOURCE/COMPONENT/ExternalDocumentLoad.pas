unit ExternalDocumentLoad;

interface

uses ExternalLoad, dsdDB;

type

  TSale1CLoadAction = class(TExternalLoadAction)
  private
    function ToDate(S: string): Variant;
  protected
    function GetStoredProc: TdsdStoredProc; override;
    function GetExternalLoad: TExternalLoad; override;
    procedure ProcessingOneRow(AExternalLoad: TExternalLoad; AStoredProc: TdsdStoredProc); override;
  end;

  TSale1CLoad = class(TFileExternalLoad)
  private
  public
    function GetData(FieldName: String): Variant;
  end;

  procedure Register;

implementation

uses VCL.ActnList, DB, Variants, SysUtils, Classes;

procedure Register;
begin
  RegisterActions('DSDLib', [TSale1CLoadAction], TSale1CLoadAction);
end;

{ TSale1CLoadAction }

function TSale1CLoadAction.GetExternalLoad: TExternalLoad;
begin
  result := TSale1CLoad.Create
end;

function TSale1CLoadAction.GetStoredProc: TdsdStoredProc;
begin
  result := TdsdStoredProc.Create(nil);
  result.OutputType := otResult;
  result.StoredProcName := 'gpInsertUpdate_1CSaleLoad';
  with result do begin
    Params.AddParam('inUnitId', ftInteger, ptInput, null);
    Params.AddParam('inVidDoc', ftString, ptInput, null);
    Params.AddParam('inInvNumber', ftString, ptInput, null);
    Params.AddParam('inOperDate', ftDateTime, ptInput, null);
    Params.AddParam('inClientCode', ftInteger, ptInput, null);
    Params.AddParam('inClientName', ftString, ptInput, null);
    Params.AddParam('inGoodsCode', ftInteger, ptInput, null);
    Params.AddParam('inGoodsName', ftString, ptInput, null);
    Params.AddParam('inOperCount', ftFloat, ptInput, null);
    Params.AddParam('inOperPrice', ftFloat, ptInput, null);
    Params.AddParam('inTax', ftFloat, ptInput, null);
    Params.AddParam('inDoc1Date', ftDateTime, ptInput, null);
    Params.AddParam('inDoc1Number', ftString, ptInput, null);
    Params.AddParam('inDoc2Date', ftDateTime, ptInput, null);
    Params.AddParam('inDoc2Number', ftString, ptInput, null);
    Params.AddParam('inSuma', ftFloat, ptInput, null);
    Params.AddParam('inPDV', ftFloat, ptInput, null);
    Params.AddParam('inSumaPDV', ftFloat, ptInput, null);
    Params.AddParam('inClientINN', ftString, ptInput, null);
    Params.AddParam('inClientOKPO', ftString, ptInput, null);
    Params.AddParam('inInvNalog', ftString, ptInput, null);
    Params.AddParam('inBillId', ftInteger, ptInput, null);
    Params.AddParam('inEkspCode', ftInteger, ptInput, null);
    Params.AddParam('inExpName', ftString, ptInput, null);
  end;
end;

procedure TSale1CLoadAction.ProcessingOneRow(AExternalLoad: TExternalLoad;
  AStoredProc: TdsdStoredProc);
begin
  with AStoredProc, TSale1CLoad(AExternalLoad) do begin
    ParamByName('inUnitId').Value := GetData('UnitId');
    ParamByName('inVidDoc').Value := GetData('VidDoc');
    ParamByName('inInvNumber').Value := GetData('InvNumber');
    ParamByName('inOperDate').Value := ToDate(GetData('OperDate'));
    ParamByName('inClientCode').Value := GetData('ClientCode');
    ParamByName('inClientName').Value := GetData('ClientName');
    ParamByName('inGoodsCode').Value := GetData('GoodsCode');
    ParamByName('inGoodsName').Value := GetData('GoodsName');
    ParamByName('inOperCount').Value := GetData('OperCount');
    ParamByName('inOperPrice').Value := GetData('OperPrice');
    ParamByName('inTax').Value := GetData('Tax');
    ParamByName('inDoc1Date').Value := ToDate(GetData('Doc1Date'));
    ParamByName('inDoc1Number').Value := GetData('Doc1Number');
    ParamByName('inDoc2Date').Value := ToDate(GetData('Doc2Date'));
    ParamByName('inDoc2Number').Value := GetData('Doc2Number');
    ParamByName('inSuma').Value := GetData('Suma');
    ParamByName('inPDV').Value := GetData('PDV');
    ParamByName('inSumaPDV').Value := GetData('SumaPDV');
    ParamByName('inTax').Value := GetData('Tax');
    ParamByName('inClientINN').Value := GetData('ClientINN');
    ParamByName('inClientOKPO').Value := GetData('ClientOKPO');
    ParamByName('inInvNalog').Value := GetData('InvNalog');
    ParamByName('inBillId').Value := GetData('BillId');
    ParamByName('inEkspCode').Value := GetData('EkspCode');
    ParamByName('inExpName').Value := GetData('ExpName');

    Execute;
  end;
end;

function TSale1CLoadAction.ToDate(S: string): Variant;
begin
  if S = '' then
     result := StrToDate('01.01.1901')
  else
     result := S
end;

{ TSale1CLoad }

function TSale1CLoad.GetData(FieldName: String): Variant;
begin
  result := FDataSet.FieldByName(FieldName).AsString;
end;

initialization

  RegisterClass(TSale1CLoadAction);

end.
