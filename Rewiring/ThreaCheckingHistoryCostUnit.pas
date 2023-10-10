unit ThreaCheckingHistoryCostUnit;

interface

uses System.Classes, System.SysUtils, System.DateUtils, DB,
     ZAbstractRODataset, ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection;

type

  TOnFinish = procedure(AError: String; AisMaster : Boolean; AUUId : String) of object;

  // Поток для перерасчета цен
  TCheckingHistoryCostThread = class(TThread)
  private
  { Private declarations }
    FHostName: String;
    FDatabase: String;
    FUser: String;
    FPassword: String;
    FPort: Integer;
    FLibraryLocation: String;

    FZConnection: TZConnection;
    FZQueryTable: TZQuery;
    FZQueryExecute: TZQuery;

    FError: String;
    FisMaster: Boolean;
    FBranchId : Integer;
    FStartDate : TDateTime;
    FEndDate : TDateTime;
    FSession : String;

    FRewiringUUId : String;

    FOnFinish: TOnFinish;
  protected
    procedure Execute; override;

  public

    property Error: String read FError write FError;

    property HostName: String read FHostName write FHostName;
    property Database: String read FDatabase write FDatabase;
    property User: String read FUser write FUser;
    property Password: String read FPassword write FPassword;
    property Port: Integer read FPort write FPort;
    property LibraryLocation: String read FLibraryLocation write FLibraryLocation;
    property Terminated;
    property isMaster : Boolean read FisMaster write FisMaster;
    property BranchId : Integer read FBranchId write FBranchId;
    property StartDate : TDateTime read FStartDate write FStartDate;
    property EndDate : TDateTime read FEndDate write FEndDate;
    property Session : String read FSession write FSession;

    property RewiringUUId : String read FRewiringUUId write FRewiringUUId;

    property OnFinish: TOnFinish read FOnFinish write FOnFinish;
  end;


implementation

uses UnitConst, MainUnit;

procedure TCheckingHistoryCostThread.Execute;
  var nPos : Integer;
      I, nOffset: Integer;
begin
  FError := '';
  nPos := -1;

  //if Assigned(OnMessage) then OnMessage('Подключаемся к базе данных Slave.');

  FZConnection := TZConnection.Create(Nil);
  FZConnection.Protocol := 'postgresql-9';
  FZConnection.HostName :=  FHostName;
  FZConnection.Database :=  FDatabase;
  FZConnection.User     :=  FUser;
  FZConnection.Password :=  FPassword;
  FZConnection.Port     :=  FPort;
  FZConnection.LibraryLocation := FLibraryLocation;

  FZQueryTable := TZQuery.Create(Nil);
  FZQueryTable.Connection := FZConnection;
  FZQueryExecute := TZQuery.Create(Nil);
  FZQueryExecute.Connection := FZConnection;

  try
    try
      if Terminated then Exit;

      FZConnection.Connect;

      // Перерасчета цен на слейве или мастеру
      if FisMaster then
        FZQueryTable.SQL.Text := cSQL_CheckingHistoryCost_Master
      else FZQueryTable.SQL.Text := cSQL_CheckingHistoryCost_Slave;
      FZQueryTable.ParamByName('inStartDate').Value := FStartDate;
      FZQueryTable.ParamByName('inEndDate').Value := FEndDate;
      FZQueryTable.ParamByName('inBranchId').Value := FBranchId;
      FZQueryTable.ParamByName('inItearationCount').Value := 50;
      FZQueryTable.ParamByName('inDiffSumm').Value := 1;
      FZQueryTable.ParamByName('inSession').Value := FSession;
      FZQueryTable.Open;
      FRewiringUUId := FZQueryTable.FieldByName('RewiringUUId').AsString;
      FZQueryTable.Close;

      //FRewiringUUId := '0807adf9-d20a-4d7a-8927-3bcb029aa1f8';

      FZQueryTable.Close;

    except
      on E: Exception do
      begin
        FError := Format(cExceptionMsg, [E.ClassName, E.Message]);
      end;
    end;

  finally
    if Terminated and (FError = '') then FError := 'Прервано';
    FZQueryExecute.Close;
    FZQueryTable.Close;
    FZConnection.Disconnect;
    FreeAndNil(FZQueryExecute);
    FreeAndNil(FZQueryTable);
    FreeAndNil(FZConnection);
    if Assigned(FOnFinish) then OnFinish(FError, FisMaster, FRewiringUUId);
  end;

end;


end.
