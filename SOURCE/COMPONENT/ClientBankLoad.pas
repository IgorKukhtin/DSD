unit ClientBankLoad;

interface

uses dsdAction, DB, dsdDb;

type

  TClientBankType = (cbPrivatBank, cbForum, cbVostok, cbFidoBank);

  TClientBankLoad = class
  private
    FDataSet: TDataSet;
    FInitializeDirectory: string;
    FActive: boolean;
    FOEM: boolean;
    function GetOperSumm: real; virtual; abstract;
    function GetDocNumber: string; virtual; abstract;
    function GetOperDate: TDateTime; virtual; abstract;
    function GetBankAccountFrom: string; virtual; abstract;
    function GetOKPOFrom: string; virtual; abstract;
    function GetBankAccountTo: string; virtual; abstract;
    function GetBankMFOFrom: string; virtual; abstract;
    function GetBankMFOTo: string; virtual; abstract;
    function GetJuridicalNameFrom: string; virtual; abstract;
    function GetJuridicalNameTo: string; virtual; abstract;
    function GetOKPOTo: string; virtual; abstract;
    function GetComment: string; virtual; abstract;
  public
    constructor Create; virtual;
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

    property BankAccountFrom: string read GetBankAccountFrom;
    property BankMFOFrom: string read GetBankMFOFrom;
    property OKPOFrom: string read GetOKPOFrom;
    property JuridicalNameFrom: string read GetJuridicalNameFrom;
    property BankAccountTo: string read GetBankAccountTo;
    property BankMFOTo: string read GetBankMFOTo;
    property OKPOTo: string read GetOKPOTo;
    property JuridicalNameTo: string read GetJuridicalNameTo;
    property Comment: string read GetComment;
  end;

  TClientBankLoadAction = class(TdsdCustomAction)
  private
    FClientBankType: TClientBankType;
    FInitializeDirectory: string;
    function GetClientBankLoad(AClientBankType: TClientBankType): TClientBankLoad;
    function GetStoredProc: TdsdStoredProc;
    procedure ProcessingOneRow(AClientBankLoad: TClientBankLoad; AStoredProc: TdsdStoredProc);
  public
    function Execute: boolean; override;
  published
    // Для какого банка осуществляется загрузка
    property ClientBankType: TClientBankType read FClientBankType write FClientBankType;
    // Директория загрузки. Сделана published что бы сохранять данные по стандартной схеме
    property InitializeDirectory: string read FInitializeDirectory write FInitializeDirectory;
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
    constructor Create; override;
    function GetOperSumm: real; override;
    function GetDocNumber: string; override;
    function GetOperDate: TDateTime; override;

    function GetBankAccountFrom: string; override;
    function GetOKPOFrom: string; override;
    function GetBankAccountTo: string; override;
    function GetBankMFOFrom: string; override;
    function GetBankMFOTo: string; override;
    function GetJuridicalNameFrom: string; override;
    function GetJuridicalNameTo: string; override;
    function GetOKPOTo: string; override;
    function GetComment: string; override;
  end;

  TForumBankLoad = class(TClientBankLoad)
    function GetOperSumm: real; override;
    function GetDocNumber: string; override;
    function GetOperDate: TDateTime; override;

    function GetBankAccountFrom: string; override;
    function GetOKPOFrom: string; override;
    function GetBankAccountTo: string; override;
    function GetBankMFOFrom: string; override;
    function GetBankMFOTo: string; override;
    function GetJuridicalNameFrom: string; override;
    function GetJuridicalNameTo: string; override;
    function GetOKPOTo: string; override;
    function GetComment: string; override;
  end;

  TVostokBankLoad = class(TClientBankLoad)
    function GetOperSumm: real; override;
    function GetDocNumber: string; override;
    function GetOperDate: TDateTime; override;

    function GetBankAccountFrom: string; override;
    function GetOKPOFrom: string; override;
    function GetBankAccountTo: string; override;
    function GetBankMFOFrom: string; override;
    function GetBankMFOTo: string; override;
    function GetJuridicalNameFrom: string; override;
    function GetJuridicalNameTo: string; override;
    function GetOKPOTo: string; override;
    function GetComment: string; override;
  end;

  TFidoBankLoad = class(TClientBankLoad)
    function GetOperSumm: real; override;
    function GetDocNumber: string; override;
    function GetOperDate: TDateTime; override;

    function GetBankAccountFrom: string; override;
    function GetOKPOFrom: string; override;
    function GetBankAccountTo: string; override;
    function GetBankMFOFrom: string; override;
    function GetBankMFOTo: string; override;
    function GetJuridicalNameFrom: string; override;
    function GetJuridicalNameTo: string; override;
    function GetOKPOTo: string; override;
    function GetComment: string; override;
  end;

function TClientBankLoadAction.Execute: boolean;
var
   FClientBankLoad: TClientBankLoad;
   FStoredProc: TdsdStoredProc;
begin
  FClientBankLoad := GetClientBankLoad(ClientBankType);
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
  AClientBankType: TClientBankType): TClientBankLoad;
begin
  case AClientBankType of
    cbPrivatBank: result := TPrivatBankLoad.Create;
    cbForum: result := TForumBankLoad.Create;
    cbVostok: result := TVostokBankLoad.Create;
    cbFidoBank: result := TFidoBankLoad.Create;
  end;
end;

function TClientBankLoadAction.GetStoredProc: TdsdStoredProc;
begin
  result := TdsdStoredProc.Create(nil);
  with result do begin
    Params.AddParam('inDocNumber', ftString, ptInput, null);
    Params.AddParam('inOperDate', ftDateTime, ptInput, null);
    Params.AddParam('inBankAccountFrom', ftString, ptInput, null);
    Params.AddParam('inBankMFOFrom', ftString, ptInput, null);
    Params.AddParam('inOKPOFrom', ftString, ptInput, null);
    Params.AddParam('inJuridicalNameFrom', ftString, ptInput, null);
    Params.AddParam('inBankAccountTo', ftString, ptInput, null);
    Params.AddParam('inBankMFOTo', ftString, ptInput, null);
    Params.AddParam('inOKPOTo', ftString, ptInput, null);
    Params.AddParam('inJuridicalNameTo', ftString, ptInput, null);
    Params.AddParam('inAmount', ftFloat, ptInput, null);
  end;
end;

procedure TClientBankLoadAction.ProcessingOneRow(
  AClientBankLoad: TClientBankLoad; AStoredProc: TdsdStoredProc);
begin
  with AStoredProc, AClientBankLoad do begin
    ParamByName('inDocNumber').Value := DocNumber;
    ParamByName('inOperDate').Value := OperDate;
    ParamByName('inBankAccountFrom').Value := BankAccountFrom;
    ParamByName('inBankMFOFrom').Value := BankMFOFrom;
    ParamByName('inOKPOFrom').Value := OKPOFrom;
    ParamByName('inJuridicalNameFrom').Value := JuridicalNameFrom;
    ParamByName('inBankAccountTo').Value := BankAccountTo;
    ParamByName('inBankMFOTo').Value := BankMFOTo;
    ParamByName('inOKPOTo').Value := OKPOTo;
    ParamByName('inJuridicalNameTo').Value := JuridicalNameTo;
    ParamByName('inAmount').Value := OperSumm;
    Execute;
  end;
end;

{ TClientBankLoad }

procedure TClientBankLoad.Activate;
begin
  with TFileOpenDialog.Create(nil) do
  try
    DefaultFolder := InitializeDirectory;
    with FileTypes.Add do
    begin
      DisplayName := 'Файлы загрузки';
      FileMask := '*.dbf';
    end;
    if Execute then begin
       InitializeDirectory := ExtractFilePath(FileName);
       FDataSet := TMemDBFTable.Create(nil);
       TMemDBFTable(FDataSet).FileName := FileName;
       TMemDBFTable(FDataSet).OEM := FOEM;
       TMemDBFTable(FDataSet).Open;
       FActive := TMemDBFTable(FDataSet).Active;
    end;
  finally
    Free;
  end;
end;

constructor TClientBankLoad.Create;
begin
  FActive := false;
  FOEM := false;
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
  FDataSet.Next;
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

function TPrivatBankLoad.GetBankAccountFrom: string;
begin
  if FDataSet.FieldByName('DOC_DT_KT').AsInteger = 0 then
     result := FDataSet.FieldByName('ACCOUNT_A').AsString
  else
     result := FDataSet.FieldByName('ACCOUNT_B').AsString
end;

function TPrivatBankLoad.GetBankAccountTo: string;
begin
  if FDataSet.FieldByName('DOC_DT_KT').AsInteger = 1 then
     result := FDataSet.FieldByName('ACCOUNT_A').AsString
  else
     result := FDataSet.FieldByName('ACCOUNT_B').AsString
end;

function TPrivatBankLoad.GetBankMFOFrom: string;
begin
  if FDataSet.FieldByName('DOC_DT_KT').AsInteger = 0 then
     result := FDataSet.FieldByName('MFO_A').AsString
  else
     result := FDataSet.FieldByName('MFO_B').AsString
end;

function TPrivatBankLoad.GetBankMFOTo: string;
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

function TPrivatBankLoad.GetDocNumber: string;
begin
  result := FDataSet.FieldByName('N_DOC').AsString
end;

function TPrivatBankLoad.GetJuridicalNameFrom: string;
begin
  if FDataSet.FieldByName('DOC_DT_KT').AsInteger = 0 then
     result := FDataSet.FieldByName('NAME_A').AsString
  else
     result := FDataSet.FieldByName('NAME_B').AsString
end;

function TPrivatBankLoad.GetJuridicalNameTo: string;
begin
  if FDataSet.FieldByName('DOC_DT_KT').AsInteger = 1 then
     result := FDataSet.FieldByName('NAME_A').AsString
  else
     result := FDataSet.FieldByName('NAME_B').AsString
end;

function TPrivatBankLoad.GetOKPOFrom: string;
begin
  if FDataSet.FieldByName('DOC_DT_KT').AsInteger = 0 then
     result := FDataSet.FieldByName('OKPO1_A').AsString
  else
     result := FDataSet.FieldByName('OKPO2_B').AsString
end;

function TPrivatBankLoad.GetOKPOTo: string;
begin
  if FDataSet.FieldByName('DOC_DT_KT').AsInteger = 1 then
     result := FDataSet.FieldByName('OKPO1_A').AsString
  else
     result := FDataSet.FieldByName('OKPO2_B').AsString
end;

function TPrivatBankLoad.GetOperDate: TDateTime;
begin
  result := FDataSet.FieldByName('DATE_DOC').AsDateTime
end;

function TPrivatBankLoad.GetOperSumm: real;
begin
  result := FDataSet.FieldByName('SUM_DOC').AsFloat
end;

{ TForumBankLoad }

function TForumBankLoad.GetBankAccountFrom: string;
begin
  result := FDataSet.FieldByName('RR_DB').AsString
end;

function TForumBankLoad.GetBankAccountTo: string;
begin
  result := FDataSet.FieldByName('RR_K').AsString
end;

function TForumBankLoad.GetBankMFOFrom: string;
begin
  result := FDataSet.FieldByName('MFO_DB').AsString
end;

function TForumBankLoad.GetBankMFOTo: string;
begin
  result := FDataSet.FieldByName('MFO_CR').AsString
end;

function TForumBankLoad.GetComment: string;
begin
  result := FDataSet.FieldByName('PRIZN').AsString
end;

function TForumBankLoad.GetDocNumber: string;
begin
  result := FDataSet.FieldByName('N_DOC').AsString
end;

function TForumBankLoad.GetJuridicalNameFrom: string;
begin
  result := FDataSet.FieldByName('NAIM_D').AsString
end;

function TForumBankLoad.GetJuridicalNameTo: string;
begin
  result := FDataSet.FieldByName('NAIM_K').AsString
end;

function TForumBankLoad.GetOKPOFrom: string;
begin
  result := FDataSet.FieldByName('OKPO_DB').AsString
end;

function TForumBankLoad.GetOKPOTo: string;
begin
  result := FDataSet.FieldByName('OKPO_CR').AsString
end;

function TForumBankLoad.GetOperDate: TDateTime;
begin
  result := FDataSet.FieldByName('DAT').AsDateTime
end;

function TForumBankLoad.GetOperSumm: real;
begin
  result := FDataSet.FieldByName('SUM').AsFloat
end;

{ TVostokBankLoad }

function TVostokBankLoad.GetBankAccountFrom: string;
begin
  result := FDataSet.FieldByName('ACC_A').AsString
end;

function TVostokBankLoad.GetBankAccountTo: string;
begin
  result := FDataSet.FieldByName('ACC_B').AsString
end;

function TVostokBankLoad.GetBankMFOFrom: string;
begin
  result := FDataSet.FieldByName('R_MFO').AsString
end;

function TVostokBankLoad.GetBankMFOTo: string;
begin
  result := FDataSet.FieldByName('MFO').AsString
end;

function TVostokBankLoad.GetComment: string;
begin
  result := FDataSet.FieldByName('COMMENT').AsString
end;

function TVostokBankLoad.GetDocNumber: string;
begin
  result := FDataSet.FieldByName('DOC_NO').AsString
end;

function TVostokBankLoad.GetJuridicalNameFrom: string;
begin
  result := FDataSet.FieldByName('R_NAME').AsString
end;

function TVostokBankLoad.GetJuridicalNameTo: string;
begin
  result := FDataSet.FieldByName('NAME').AsString
end;

function TVostokBankLoad.GetOKPOFrom: string;
begin
  result := FDataSet.FieldByName('R_ZIP').AsString
end;

function TVostokBankLoad.GetOKPOTo: string;
begin
  result := ''
end;

function TVostokBankLoad.GetOperDate: TDateTime;
begin
  result := FDataSet.FieldByName('DATE').AsDateTime
end;

function TVostokBankLoad.GetOperSumm: real;
begin
  result := FDataSet.FieldByName('SUM').AsFloat
end;

{ TFidoBankLoad }

function TFidoBankLoad.GetBankAccountFrom: string;
begin
  result := FDataSet.FieldByName('KL_CHK').AsString
end;

function TFidoBankLoad.GetBankAccountTo: string;
begin
  result := FDataSet.FieldByName('KL_CHK_K').AsString
end;

function TFidoBankLoad.GetBankMFOFrom: string;
begin
  result := FDataSet.FieldByName('MFO').AsString
end;

function TFidoBankLoad.GetBankMFOTo: string;
begin
  result := FDataSet.FieldByName('MFO_K').AsString
end;

function TFidoBankLoad.GetComment: string;
begin
  result := FDataSet.FieldByName('N_P').AsString
end;

function TFidoBankLoad.GetDocNumber: string;
begin
  result := FDataSet.FieldByName('ND').AsString
end;

function TFidoBankLoad.GetJuridicalNameFrom: string;
begin
  result := FDataSet.FieldByName('KL_NM').AsString
end;

function TFidoBankLoad.GetJuridicalNameTo: string;
begin
  result := FDataSet.FieldByName('KL_NM_K').AsString
end;

function TFidoBankLoad.GetOKPOFrom: string;
begin
  result := FDataSet.FieldByName('KL_OKP').AsString
end;

function TFidoBankLoad.GetOKPOTo: string;
begin
  result := FDataSet.FieldByName('KL_OKP_K').AsString
end;

function TFidoBankLoad.GetOperDate: TDateTime;
begin
  result := FDataSet.FieldByName('DATA').AsDateTime
end;

function TFidoBankLoad.GetOperSumm: real;
begin
  result := FDataSet.FieldByName('S').AsFloat
end;

end.
