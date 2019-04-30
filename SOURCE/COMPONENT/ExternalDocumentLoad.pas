unit ExternalDocumentLoad;

{$I ..\dsdVer.inc}

interface

uses ExternalLoad, dsdDB, Classes {$IFDEF DELPHI103RIO}, Actions {$ENDIF};

type

  TSale1CLoadAction = class(TExternalLoadAction)
  private
    FBranch: TdsdParam;
    FEndDate: TdsdParam;
    FStartDate: TdsdParam;
    function ToDate(S: string): Variant;
  protected
    function GetStoredProc: TdsdStoredProc; override;
    function GetExternalLoad: TExternalLoad; override;
    procedure ProcessingOneRow(AExternalLoad: TExternalLoad; AStoredProc: TdsdStoredProc); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Branch: TdsdParam read FBranch write FBranch;
    // Период дат
    property StartDateParam: TdsdParam read FStartDate write FStartDate;
    property EndDateParam: TdsdParam read FEndDate write FEndDate;
  end;

  TSale1CLoad = class(TFileExternalLoad)
  private
    function GetOperDate: TDateTime;
  protected
    procedure First; override;
  public
    constructor Create(StartDate, EndDate: TDateTime);
    procedure Next;     override;
    property OperDate: TDateTime read GetOperDate;
    function GetData(FieldName: String): Variant;
  end;

  TMoney1CLoadAction = class(TExternalLoadAction)
  private
    FBranch: TdsdParam;
    FEndDate: TdsdParam;
    FStartDate: TdsdParam;
    function ToDate(S: string): Variant;
  protected
    function GetStoredProc: TdsdStoredProc; override;
    function GetExternalLoad: TExternalLoad; override;
    procedure ProcessingOneRow(AExternalLoad: TExternalLoad; AStoredProc: TdsdStoredProc); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Branch: TdsdParam read FBranch write FBranch;
    // Период дат
    property StartDateParam: TdsdParam read FStartDate write FStartDate;
    property EndDateParam: TdsdParam read FEndDate write FEndDate;
  end;

  TMoney1CLoad = class(TFileExternalLoad)
  private
    function GetOperDate: TDateTime;
  protected
    procedure First; override;
  public
    constructor Create(StartDate, EndDate: TDateTime);
    procedure Next;     override;
    property OperDate: TDateTime read GetOperDate;
    function GetData(FieldName: String): Variant;
  end;

  procedure Register;

implementation

uses VCL.ActnList, DB, Variants, SysUtils, UtilConvert;

procedure Register;
begin
  RegisterActions('DSDLib', [TSale1CLoadAction], TSale1CLoadAction);
  RegisterActions('DSDLib', [TMoney1CLoadAction], TMoney1CLoadAction);
end;

{ TSale1CLoadAction }

constructor TSale1CLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  Branch := TdsdParam.Create(nil);
  FStartDate := TdsdParam.Create(nil);
  FEndDate := TdsdParam.Create(nil);
end;

destructor TSale1CLoadAction.Destroy;
begin
  FreeAndNil(FStartDate);
  FreeAndNil(FEndDate);
  FreeAndNil(FBranch);
  inherited;
end;

function TSale1CLoadAction.GetExternalLoad: TExternalLoad;
begin
  result := TSale1CLoad.Create(StartDateParam.Value, EndDateParam.Value)
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
    Params.AddParam('inSuma', ftFloat, ptInput, null);
    Params.AddParam('inPDV', ftFloat, ptInput, null);
    Params.AddParam('inSumaPDV', ftFloat, ptInput, null);
    Params.AddParam('inClientINN', ftString, ptInput, null);
    Params.AddParam('inClientOKPO', ftString, ptInput, null);
    Params.AddParam('inInvNalog', ftString, ptInput, null);
    Params.AddParam('inBranchId', ftInteger, ptInput, null);
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
    ParamByName('inOperCount').Value :=  gfStrToFloat(GetData('OperCount'));
    ParamByName('inOperPrice').Value := gfStrToFloat(GetData('OperPrice'));
    ParamByName('inTax').Value := gfStrToFloat(GetData('Tax'));
    ParamByName('inSuma').Value := gfStrToFloat(GetData('Suma'));
    ParamByName('inPDV').Value := gfStrToFloat(GetData('PDV'));
    ParamByName('inSumaPDV').Value := gfStrToFloat(GetData('SumaPDV'));
    ParamByName('inClientINN').Value := GetData('ClientINN');
    ParamByName('inClientOKPO').Value := GetData('ClientOKPO');
    ParamByName('inInvNalog').Value := GetData('InvNalog');
    ParamByName('inBranchId').Value := Branch.Value;
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

constructor TSale1CLoad.Create(StartDate, EndDate: TDateTime);
begin
  inherited Create;
  FStartDate := StartDate;
  FEndDate := EndDate;
end;

procedure TSale1CLoad.First;
begin
  inherited;
  // Установить на первую запись подходящей даты
  while not FDataSet.EOF do begin
    if (FStartDate <= OperDate) and (OperDate <= FEndDate) then
             break;
    FDataSet.Next;
  end;
end;

function TSale1CLoad.GetData(FieldName: String): Variant;
begin
  result := trim(FDataSet.FieldByName(FieldName).AsString);
end;

function TSale1CLoad.GetOperDate: TDateTime;
var S: string;
begin
  S := GetData('OperDate');
  if S = '' then
     result := StrToDate('01.01.1901')
  else
     result := gfStrFormatToDate(S, 'YYYYMMDD')
end;

procedure TSale1CLoad.Next;
begin
  repeat
    FDataSet.Next;
  until ((FStartDate <= OperDate) and (OperDate <= FEndDate)) or FDataSet.EOF;
end;

{ TMoney1CLoadAction }

constructor TMoney1CLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  Branch := TdsdParam.Create(nil);
  FStartDate := TdsdParam.Create(nil);
  FEndDate := TdsdParam.Create(nil);
end;

destructor TMoney1CLoadAction.Destroy;
begin
  FreeAndNil(FStartDate);
  FreeAndNil(FEndDate);
  FreeAndNil(FBranch);
  inherited;
end;

function TMoney1CLoadAction.GetExternalLoad: TExternalLoad;
begin
  result := TSale1CLoad.Create(StartDateParam.Value, EndDateParam.Value)
end;

function TMoney1CLoadAction.GetStoredProc: TdsdStoredProc;
begin
  result := TdsdStoredProc.Create(nil);
  result.OutputType := otResult;
  result.StoredProcName := 'gpInsertUpdate_1CMoneyLoad';
  with result do begin
    Params.AddParam('inUnitId', ftInteger, ptInput, null);
    Params.AddParam('inInvNumber', ftString, ptInput, null);
    Params.AddParam('inOperDate', ftDateTime, ptInput, null);
    Params.AddParam('inClientCode', ftInteger, ptInput, null);
    Params.AddParam('inClientName', ftString, ptInput, null);
    Params.AddParam('inSummaIn', ftFloat, ptInput, null);
    Params.AddParam('inSummaOut', ftFloat, ptInput, null);
    Params.AddParam('inBranchId', ftInteger, ptInput, null);
  end;
end;

procedure TMoney1CLoadAction.ProcessingOneRow(AExternalLoad: TExternalLoad;
  AStoredProc: TdsdStoredProc);
begin
  with AStoredProc, TSale1CLoad(AExternalLoad) do begin
    ParamByName('inUnitId').Value := GetData('UnitId');
    ParamByName('inInvNumber').Value := GetData('InvNumber');
    ParamByName('inOperDate').Value := ToDate(GetData('OperDate'));
    ParamByName('inClientCode').Value := GetData('ClientCode');
    ParamByName('inClientName').Value := GetData('ClientName');
    ParamByName('inSummaIn').Value := gfStrToFloat(GetData('SummaIn'));
    ParamByName('inSummaOut').Value :=  gfStrToFloat(GetData('SummaOut'));
    ParamByName('inBranchId').Value := Branch.Value;
    Execute;
  end;
end;

function TMoney1CLoadAction.ToDate(S: string): Variant;
begin
  if S = '' then
     result := StrToDate('01.01.1901')
  else
     result := S
end;

{ TMoney1CLoad }

constructor TMoney1CLoad.Create(StartDate, EndDate: TDateTime);
begin
  inherited Create;
  FStartDate := StartDate;
  FEndDate := EndDate;
end;

procedure TMoney1CLoad.First;
begin
  inherited;
  // Установить на первую запись подходящей даты
  while not FDataSet.EOF do begin
    if (FStartDate <= OperDate) and (OperDate <= FEndDate) then
             break;
    FDataSet.Next;
  end;
end;

function TMoney1CLoad.GetData(FieldName: String): Variant;
begin
  result := trim(FDataSet.FieldByName(FieldName).AsString);
end;

function TMoney1CLoad.GetOperDate: TDateTime;
var S: string;
begin
  S := GetData('OperDate');
  if S = '' then
     result := StrToDate('01.01.1901')
  else
     result := gfStrFormatToDate(S, 'YYYYMMDD')
end;

procedure TMoney1CLoad.Next;
begin
  repeat
    FDataSet.Next;
  until ((FStartDate <= OperDate) and (OperDate <= FEndDate)) or FDataSet.EOF;
end;

initialization
  RegisterClass(TSale1CLoadAction);
  RegisterClass (TMoney1CLoadAction);

end.
