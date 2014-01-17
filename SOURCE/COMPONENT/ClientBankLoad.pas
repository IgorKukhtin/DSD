unit ClientBankLoad;

interface

uses dsdAction, DB, dsdDb, Classes;

type

  TClientBankType = (cbPrivatBank, cbForum, cbVostok, cbFidoBank, cbOTPBank);

  TClientBankLoad = class
  private
    FDataSet: TDataSet;
    FInitializeDirectory: string;
    FActive: boolean;
    FOEM: boolean;
    FStartDate: TDateTime;
    FEndDate: TDateTime;
    function GetOperSumm: real; virtual; abstract;
    function GetDocNumber: string; virtual; abstract;
    function GetOperDate: TDateTime; virtual; abstract;
    function GetBankAccountMain: string; virtual; abstract;
    function GetOKPO: string; virtual; abstract;
    function GetBankAccount: string; virtual; abstract;
    function GetBankMFOMain: string; virtual; abstract;
    function GetBankMFO: string; virtual; abstract;
    function GetJuridicalName: string; virtual; abstract;
    function GetBankName: string; virtual; abstract;
    function GetComment: string; virtual; abstract;
    function GetCurrencyCode: string; virtual; abstract;
    function GetCurrencyName: string; virtual; abstract;
  public
    constructor Create(StartDate, EndDate: TDateTime); virtual;
    destructor Destroy;
    function EOF: boolean;
    function RecordCount: integer;
    procedure Next;
    procedure Activate;
    property InitializeDirectory: string read FInitializeDirectory write FInitializeDirectory;
    property Active: boolean read FActive;
    property DocNumber: string read GetDocNumber;
    property OperDate: TDateTime read GetOperDate;
    property OperSumm: real read GetOperSumm;
    property BankAccountMain: string read GetBankAccountMain;
    property BankMFOMain: string read GetBankMFOMain;
    property OKPO: string read GetOKPO;
    property JuridicalName: string read GetJuridicalName;
    property BankAccount: string read GetBankAccount;
    property BankMFO: string read GetBankMFO;
    property BankName: string read GetBankName;
    property CurrencyCode: string read GetCurrencyCode;
    property CurrencyName: string read GetCurrencyName;
    property Comment: string read GetComment;
  end;

  TClientBankLoadAction = class(TdsdCustomAction)
  private
    FClientBankType: TClientBankType;
    FInitializeDirectory: string;
    FEndDate: TdsdParam;
    FStartDate: TdsdParam;
    function StartDate: TDateTime;
    function EndDate: TDateTime;
    function GetClientBankLoad(AClientBankType: TClientBankType; StartDate, EndDate: TDateTime): TClientBankLoad;
    function GetStoredProc: TdsdStoredProc;
    procedure ProcessingOneRow(AClientBankLoad: TClientBankLoad; AStoredProc: TdsdStoredProc);
  public
    function Execute: boolean; override;
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
  published
    // Для какого банка осуществляется загрузка
    property ClientBankType: TClientBankType read FClientBankType write FClientBankType;
    // Директория загрузки. Сделана published что бы сохранять данные по стандартной схеме
    property InitializeDirectory: string read FInitializeDirectory write FInitializeDirectory;
    property StartDateParam: TdsdParam read FStartDate write FStartDate;
    property EndDateParam: TdsdParam read FEndDate write FEndDate;
  end;

  procedure Register;

implementation

{ TClientBankLoadAction }

uses VCL.ActnList, Dialogs, SysUtils, MemDBFTable, Variants, SimpleGauge;

procedure Register;
begin
  RegisterActions('DSDLib', [TClientBankLoadAction], TClientBankLoadAction);
end;

type

  TPrivatBankLoad = class(TClientBankLoad)
    constructor Create(StartDate, EndDate: TDateTime); override;
    function GetOperSumm: real; override;
    function GetDocNumber: string; override;
    function GetOperDate: TDateTime; override;

    function GetBankAccountMain: string; override;
    function GetOKPO: string; override;
    function GetBankAccount: string; override;
    function GetBankMFOMain: string; override;
    function GetBankMFO: string; override;
    function GetJuridicalName: string; override;
    function GetBankName: string; override;
    function GetComment: string; override;
    function GetCurrencyCode: string; override;
    function GetCurrencyName: string; override;
  end;

  TForumBankLoad = class(TClientBankLoad)
    function GetOperSumm: real; override;
    function GetDocNumber: string; override;
    function GetOperDate: TDateTime; override;

    function GetBankAccountMain: string; override;
    function GetOKPO: string; override;
    function GetBankAccount: string; override;
    function GetBankMFOMain: string; override;
    function GetBankMFO: string; override;
    function GetJuridicalName: string; override;
    function GetBankName: string; override;
    function GetComment: string; override;
    function GetCurrencyCode: string; override;
    function GetCurrencyName: string; override;
  end;

  TVostokBankLoad = class(TClientBankLoad)
    function GetOperSumm: real; override;
    function GetDocNumber: string; override;
    function GetOperDate: TDateTime; override;

    function GetBankAccountMain: string; override;
    function GetOKPO: string; override;
    function GetBankAccount: string; override;
    function GetBankMFOMain: string; override;
    function GetBankMFO: string; override;
    function GetJuridicalName: string; override;
    function GetBankName: string; override;
    function GetComment: string; override;
    function GetCurrencyCode: string; override;
    function GetCurrencyName: string; override;
  end;

  TFidoBankLoad = class(TClientBankLoad)
    function GetOperSumm: real; override;
    function GetDocNumber: string; override;
    function GetOperDate: TDateTime; override;

    function GetBankAccountMain: string; override;
    function GetOKPO: string; override;
    function GetBankAccount: string; override;
    function GetBankMFOMain: string; override;
    function GetBankMFO: string; override;
    function GetJuridicalName: string; override;
    function GetBankName: string; override;
    function GetComment: string; override;
    function GetCurrencyCode: string; override;
    function GetCurrencyName: string; override;
  end;

  TOTPBankLoad = class(TClientBankLoad)
    function GetOperSumm: real; override;
    function GetDocNumber: string; override;
    function GetOperDate: TDateTime; override;

    function GetBankAccountMain: string; override;
    function GetOKPO: string; override;
    function GetBankAccount: string; override;
    function GetBankMFOMain: string; override;
    function GetBankMFO: string; override;
    function GetJuridicalName: string; override;
    function GetBankName: string; override;
    function GetComment: string; override;
    function GetCurrencyCode: string; override;
    function GetCurrencyName: string; override;
  end;

constructor TClientBankLoadAction.Create(Owner: TComponent);
begin
  inherited;
  FStartDate := TdsdParam.Create(nil);
  FEndDate := TdsdParam.Create(nil);
end;

destructor TClientBankLoadAction.Destroy;
begin
  FStartDate.Free;
  FEndDate.Free;
  inherited;
end;

function TClientBankLoadAction.EndDate: TDateTime;
begin
  result := EndDateParam.Value;
end;

function TClientBankLoadAction.Execute: boolean;
var
   FClientBankLoad: TClientBankLoad;
   FStoredProc: TdsdStoredProc;
begin
  FClientBankLoad := GetClientBankLoad(ClientBankType, StartDate, EndDate);
  try
    FClientBankLoad.InitializeDirectory := InitializeDirectory;
    FClientBankLoad.Activate;
    if FClientBankLoad.Active then begin
       InitializeDirectory := FClientBankLoad.InitializeDirectory;
       FStoredProc := GetStoredProc;
       FStoredProc.OutputType := otResult;
       FStoredProc.StoredProcName := 'gpInsertUpdate_Movement_BankStatementItemLoad';
       try
         with TGaugeFactory.GetGauge('Загрузка данных', 1, FClientBankLoad.RecordCount) do begin
           Start;
           try
             while not FClientBankLoad.EOF do begin
               ProcessingOneRow(FClientBankLoad, FStoredProc);
               IncProgress;
               FClientBankLoad.Next;
             end;
           finally
             Finish
           end;
         end;
       finally
         FStoredProc.Free
       end;
    end;
  finally
    FClientBankLoad.Free;
  end;
end;

function TClientBankLoadAction.GetClientBankLoad(
  AClientBankType: TClientBankType; StartDate, EndDate: TDateTime): TClientBankLoad;
begin
  case AClientBankType of
    cbPrivatBank: result := TPrivatBankLoad.Create(StartDate, EndDate);
    cbForum: result := TForumBankLoad.Create(StartDate, EndDate);
    cbVostok: result := TVostokBankLoad.Create(StartDate, EndDate);
    cbFidoBank: result := TFidoBankLoad.Create(StartDate, EndDate);
    cbOTPBank: result := TOTPBankLoad.Create(StartDate, EndDate);
  end;
end;

function TClientBankLoadAction.GetStoredProc: TdsdStoredProc;
begin
  result := TdsdStoredProc.Create(nil);
  with result do begin
    Params.AddParam('inDocNumber', ftString, ptInput, null);
    Params.AddParam('inOperDate', ftDateTime, ptInput, null);
    Params.AddParam('inBankAccountMain', ftString, ptInput, null);
    Params.AddParam('inBankMFOMain', ftString, ptInput, null);
    Params.AddParam('inOKPO', ftString, ptInput, null);
    Params.AddParam('inJuridicalName', ftString, ptInput, null);
    Params.AddParam('inBankAccount', ftString, ptInput, null);
    Params.AddParam('inBankMFO', ftString, ptInput, null);
    Params.AddParam('inBankName', ftString, ptInput, null);
    Params.AddParam('inCurrencyCode', ftString, ptInput, null);
    Params.AddParam('inCurrencyName', ftString, ptInput, null);
    Params.AddParam('inAmount', ftFloat, ptInput, null);
    Params.AddParam('inComment', ftString, ptInput, null);
  end;
end;

procedure TClientBankLoadAction.ProcessingOneRow(
  AClientBankLoad: TClientBankLoad; AStoredProc: TdsdStoredProc);
begin
  with AStoredProc, AClientBankLoad do begin
    ParamByName('inDocNumber').Value := DocNumber;
    ParamByName('inOperDate').Value := OperDate;
    ParamByName('inBankAccountMain').Value := BankAccountMain;
    ParamByName('inBankMFOMain').Value := BankMFOMain;
    ParamByName('inOKPO').Value := OKPO;
    ParamByName('inJuridicalName').Value := JuridicalName;
    ParamByName('inBankAccount').Value := BankAccount;
    ParamByName('inBankMFO').Value := BankMFO;
    ParamByName('inBankName').Value := BankName;
    ParamByName('inCurrencyCode').Value := CurrencyCode;
    ParamByName('inCurrencyName').Value := CurrencyName;
    ParamByName('inAmount').Value := OperSumm;
    ParamByName('inComment').Value := Comment;
    Execute;
  end;
end;

function TClientBankLoadAction.StartDate: TDateTime;
begin
  result := StartDateParam.Value;
end;

{ TClientBankLoad }

procedure TClientBankLoad.Activate;
begin
  with {File}TOpenDialog.Create(nil) do
  try
    InitialDir := InitializeDirectory;
//    DefaultFolder := InitializeDirectory;
    DefaultExt := '*.dbf';
    Filter := '*.dbf';
    {with FileTypes.Add do
    begin
      DisplayName := 'Файлы загрузки';
      FileMask := '*.dbf';
    end;}
    if Execute then begin
       InitializeDirectory := ExtractFilePath(FileName);
       FDataSet := TMemDBFTable.Create(nil);
       TMemDBFTable(FDataSet).FileName := FileName;
       TMemDBFTable(FDataSet).OEM := FOEM;
       TMemDBFTable(FDataSet).Open;
       FActive := TMemDBFTable(FDataSet).Active;
       // Установить на первую запись подходящей даты
       while not TMemDBFTable(FDataSet).EOF do begin
         if (FStartDate <= OperDate) and (OperDate <= FEndDate) then
             break;
         TMemDBFTable(FDataSet).Next;
       end;
    end;
  finally
    Free;
  end;
end;

constructor TClientBankLoad.Create;
begin
  FActive := false;
  FOEM := false;
  FStartDate := StartDate;
  FEndDate := EndDate;
end;

destructor TClientBankLoad.Destroy;
begin
  if Assigned(FDataSet) then
     FreeAndNil(FDataSet);
end;

function TClientBankLoad.EOF: boolean;
begin
  result := (not Assigned(FDataSet)) or (not FDataSet.Active) or FDataSet.Eof;
end;

procedure TClientBankLoad.Next;
begin
  repeat
    FDataSet.Next;
  until ((FStartDate <= OperDate) and (OperDate <= FEndDate)) or FDataSet.EOF;
end;

function TClientBankLoad.RecordCount: integer;
begin
  result  := FDataSet.RecordCount
end;

{ TPrivatBankLoad }

constructor TPrivatBankLoad.Create;
begin
  inherited;
  FOEM := true;
end;

function TPrivatBankLoad.GetBankAccountMain: string;
begin
  if FDataSet.FieldByName('DOC_DT_KT').AsInteger = 0 then
     result := FDataSet.FieldByName('ACCOUNT_A').AsString
  else
     result := FDataSet.FieldByName('ACCOUNT_B').AsString;
  result := trim(result);
end;

function TPrivatBankLoad.GetBankAccount: string;
begin
  if FDataSet.FieldByName('DOC_DT_KT').AsInteger = 1 then
     result := FDataSet.FieldByName('ACCOUNT_A').AsString
  else
     result := FDataSet.FieldByName('ACCOUNT_B').AsString;
  result := trim(result);
end;

function TPrivatBankLoad.GetBankMFOMain: string;
begin
  if FDataSet.FieldByName('DOC_DT_KT').AsInteger = 0 then
     result := FDataSet.FieldByName('MFO_A').AsString
  else
     result := FDataSet.FieldByName('MFO_B').AsString
end;

function TPrivatBankLoad.GetBankName: string;
begin

end;

function TPrivatBankLoad.GetBankMFO: string;
begin
  if FDataSet.FieldByName('DOC_DT_KT').AsInteger = 1 then
     result := FDataSet.FieldByName('MFO_A').AsString
  else
     result := FDataSet.FieldByName('MFO_B').AsString
end;

function TPrivatBankLoad.GetComment: string;
begin
  result := FDataSet.FieldByName('N_P').AsString
end;

function TPrivatBankLoad.GetCurrencyCode: string;
begin
  result := ''
end;

function TPrivatBankLoad.GetCurrencyName: string;
begin
  result := FDataSet.FieldByName('VAL').AsString
end;

function TPrivatBankLoad.GetDocNumber: string;
begin
  result := FDataSet.FieldByName('N_DOC').AsString
end;

function TPrivatBankLoad.GetJuridicalName: string;
begin
  if FDataSet.FieldByName('DOC_DT_KT').AsInteger = 1 then
     result := FDataSet.FieldByName('NAME_A').AsString
  else
     result := FDataSet.FieldByName('NAME_B').AsString
end;

function TPrivatBankLoad.GetOKPO: string;
begin
  if FDataSet.FieldByName('DOC_DT_KT').AsInteger = 1 then
     result := trim(FDataSet.FieldByName('OKPO1_A').AsString)
  else
     result := trim(FDataSet.FieldByName('OKPO2_B').AsString)
end;

function TPrivatBankLoad.GetOperDate: TDateTime;
begin
  result := FDataSet.FieldByName('DATE_DOC').AsDateTime
end;

function TPrivatBankLoad.GetOperSumm: real;
begin
  if FDataSet.FieldByName('DOC_DT_KT').AsInteger = 1 then
     result := FDataSet.FieldByName('SUM_DOC').AsFloat
  else
     result := - FDataSet.FieldByName('SUM_DOC').AsFloat;
end;

{ TForumBankLoad }

function TForumBankLoad.GetBankAccountMain: string;
begin
  if FDataSet.FieldByName('OPERAT').AsInteger = 1 then
     result := FDataSet.FieldByName('RR_DB').AsString
  else
     result := FDataSet.FieldByName('RR_K').AsString;
end;

function TForumBankLoad.GetBankAccount: string;
begin
  if FDataSet.FieldByName('OPERAT').AsInteger = 2 then
     result := FDataSet.FieldByName('RR_DB').AsString
  else
     result := FDataSet.FieldByName('RR_K').AsString;
end;

function TForumBankLoad.GetBankMFOMain: string;
begin
  if FDataSet.FieldByName('OPERAT').AsInteger = 1 then
     result := FDataSet.FieldByName('MFO_DB').AsString
  else
     result := FDataSet.FieldByName('MFO_CR').AsString;
end;

function TForumBankLoad.GetBankMFO: string;
begin
  if FDataSet.FieldByName('OPERAT').AsInteger = 2 then
     result := FDataSet.FieldByName('MFO_DB').AsString
  else
     result := FDataSet.FieldByName('MFO_CR').AsString;
end;

function TForumBankLoad.GetComment: string;
begin
  result := FDataSet.FieldByName('PRIZN').AsString
end;

function TForumBankLoad.GetCurrencyCode: string;
begin
  result := FDataSet.FieldByName('KOD_VAL').AsString
end;

function TForumBankLoad.GetCurrencyName: string;
begin
  result := ''
end;

function TForumBankLoad.GetDocNumber: string;
begin
  result := FDataSet.FieldByName('N_DOC').AsString
end;

function TForumBankLoad.GetJuridicalName: string;
begin
  if FDataSet.FieldByName('OPERAT').AsInteger = 1 then
     result := FDataSet.FieldByName('NAIM_K').AsString
  else
     result := FDataSet.FieldByName('NAIM_D').AsString
end;

function TForumBankLoad.GetBankName: string;
begin
  result := ''
end;

function TForumBankLoad.GetOKPO: string;
begin
  if FDataSet.FieldByName('OPERAT').AsInteger = 2 then
     result := trim(FDataSet.FieldByName('OKPO_DB').AsString)
  else
     result := trim(FDataSet.FieldByName('OKPO_CR').AsString);
end;

function TForumBankLoad.GetOperDate: TDateTime;
begin
  result := FDataSet.FieldByName('DAT').AsDateTime
end;

function TForumBankLoad.GetOperSumm: real;
begin
  if FDataSet.FieldByName('OPERAT').AsInteger = 2 then
     result := FDataSet.FieldByName('SUM').AsFloat
  else
     result := - FDataSet.FieldByName('SUM').AsFloat
end;

{ TVostokBankLoad }

function TVostokBankLoad.GetBankAccountMain: string;
begin
  result := FDataSet.FieldByName('ACC_A').AsString
end;

function TVostokBankLoad.GetBankAccount: string;
begin
  result := FDataSet.FieldByName('ACC_B').AsString
end;

function TVostokBankLoad.GetBankMFOMain: string;
begin
  result := FDataSet.FieldByName('MFO').AsString
end;

function TVostokBankLoad.GetBankMFO: string;
begin
  result := FDataSet.FieldByName('R_MFO').AsString
end;

function TVostokBankLoad.GetComment: string;
begin
  result := FDataSet.FieldByName('COMMENT').AsString
end;

function TVostokBankLoad.GetCurrencyCode: string;
begin
  result := FDataSet.FieldByName('CURRENCY').AsString
end;

function TVostokBankLoad.GetCurrencyName: string;
begin
  result := ''
end;

function TVostokBankLoad.GetDocNumber: string;
begin
  result := FDataSet.FieldByName('DOC_NO').AsString
end;

function TVostokBankLoad.GetJuridicalName: string;
begin
  result := FDataSet.FieldByName('R_NAME').AsString
end;

function TVostokBankLoad.GetBankName: string;
begin
  result := ''
end;

function TVostokBankLoad.GetOKPO: string;
begin
  result := trim(FDataSet.FieldByName('CHAR_R_ZIP').AsString)
end;

function TVostokBankLoad.GetOperDate: TDateTime;
begin
  result := FDataSet.FieldByName('DATE').AsDateTime
end;

function TVostokBankLoad.GetOperSumm: real;
begin
  if FDataSet.FieldByName('FL_DK').AsInteger = 0 then
     result := FDataSet.FieldByName('SUM').AsFloat
  else
     result := - FDataSet.FieldByName('SUM').AsFloat
end;

{ TFidoBankLoad }

function TFidoBankLoad.GetBankAccountMain: string;
begin
  result := FDataSet.FieldByName('KL_CHK').AsString
end;

function TFidoBankLoad.GetBankAccount: string;
begin
  result := FDataSet.FieldByName('KL_CHK_K').AsString
end;

function TFidoBankLoad.GetBankMFOMain: string;
begin
  result := FDataSet.FieldByName('MFO').AsString
end;

function TFidoBankLoad.GetBankMFO: string;
begin
  result := FDataSet.FieldByName('MFO_K').AsString
end;

function TFidoBankLoad.GetComment: string;
begin
  result := FDataSet.FieldByName('N_P').AsString
end;

function TFidoBankLoad.GetCurrencyCode: string;
begin
  result := FDataSet.FieldByName('CUR_ID').AsString
end;

function TFidoBankLoad.GetCurrencyName: string;
begin
  result := ''
end;

function TFidoBankLoad.GetDocNumber: string;
begin
  result := FDataSet.FieldByName('ND').AsString
end;

function TFidoBankLoad.GetJuridicalName: string;
begin
  result := FDataSet.FieldByName('KL_NM_K').AsString
end;

function TFidoBankLoad.GetBankName: string;
begin
  result := FDataSet.FieldByName('MFO_NM_K').AsString
end;

function TFidoBankLoad.GetOKPO: string;
begin
  result := trim(FDataSet.FieldByName('KL_OKP_K').AsString)
end;

function TFidoBankLoad.GetOperDate: TDateTime;
begin
  result := FDataSet.FieldByName('DATA').AsDateTime
end;

function TFidoBankLoad.GetOperSumm: real;
begin
  if FDataSet.FieldByName('DK').asInteger = 2 then
     result := FDataSet.FieldByName('S').AsFloat
  else
     result := - FDataSet.FieldByName('S').AsFloat
end;

{ TOTPBankLoad }

function TOTPBankLoad.GetBankAccountMain: string;
begin
  if FDataSet.FieldByName('OPERAT').AsInteger = 1 then
     result := FDataSet.FieldByName('RR_DB').AsString
  else
     result := FDataSet.FieldByName('RR_K').AsString;
end;

function TOTPBankLoad.GetBankAccount: string;
begin
  if FDataSet.FieldByName('OPERAT').AsInteger = 2 then
     result := FDataSet.FieldByName('RR_DB').AsString
  else
     result := FDataSet.FieldByName('RR_K').AsString;
end;

function TOTPBankLoad.GetBankMFOMain: string;
begin
  if FDataSet.FieldByName('OPERAT').AsInteger = 1 then
     result := FDataSet.FieldByName('MFO_DB').AsString
  else
     result := FDataSet.FieldByName('MFO_CR').AsString;
end;

function TOTPBankLoad.GetBankMFO: string;
begin
  if FDataSet.FieldByName('OPERAT').AsInteger = 2 then
     result := FDataSet.FieldByName('MFO_DB').AsString
  else
     result := FDataSet.FieldByName('MFO_CR').AsString;
end;

function TOTPBankLoad.GetComment: string;
begin
  result := FDataSet.FieldByName('PRIZN').AsString
end;

function TOTPBankLoad.GetCurrencyCode: string;
begin
  result := FDataSet.FieldByName('KOD_VAL').AsString
end;

function TOTPBankLoad.GetCurrencyName: string;
begin
  result := ''
end;

function TOTPBankLoad.GetDocNumber: string;
begin
  result := FDataSet.FieldByName('N_DOC').AsString
end;

function TOTPBankLoad.GetJuridicalName: string;
begin
  if FDataSet.FieldByName('OPERAT').AsInteger = 1 then
     result := FDataSet.FieldByName('NAIM_K').AsString
  else
     result := FDataSet.FieldByName('NAIM_D').AsString
end;

function TOTPBankLoad.GetBankName: string;
begin
  result := ''
end;

function TOTPBankLoad.GetOKPO: string;
begin
  if FDataSet.FieldByName('OPERAT').AsInteger = 2 then
     result := trim(FDataSet.FieldByName('OKPO_DB').AsString)
  else
     result := trim(FDataSet.FieldByName('OKPO_CR').AsString);
end;

function TOTPBankLoad.GetOperDate: TDateTime;
begin
  result := FDataSet.FieldByName('DAT').AsDateTime
end;

function TOTPBankLoad.GetOperSumm: real;
begin
  if FDataSet.FieldByName('OPERAT').AsInteger = 2 then
     result := FDataSet.FieldByName('SUM').AsFloat
  else
     result := - FDataSet.FieldByName('SUM').AsFloat
end;

end.
