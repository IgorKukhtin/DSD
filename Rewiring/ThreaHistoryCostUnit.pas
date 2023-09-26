unit ThreaHistoryCostUnit;

interface

uses System.Classes, System.SysUtils, System.DateUtils, DB,
     ZAbstractRODataset, ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection;

type

  TOnFinish = procedure(AError: String; ABranchId : Integer) of object;
  TOnProcess = procedure(AText: String; ABranchId : Integer) of object;

  // Поток для перерасчета цен
  THistoryCostThread = class(TThread)
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
    FBranchId : Integer;
    FBranchName : String;
    FStartDate : TDateTime;
    FEndDate : TDateTime;
    FSession : String;

    FRewiringUUId : String;

    FOnFinish: TOnFinish;
    FOnProcess: TOnProcess;
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
    property BranchId : Integer read FBranchId write FBranchId;
    property BranchName : String read FBranchName write FBranchName;
    property StartDate : TDateTime read FStartDate write FStartDate;
    property EndDate : TDateTime read FEndDate write FEndDate;
    property Session : String read FSession write FSession;

    property OnFinish: TOnFinish read FOnFinish write FOnFinish;
    property OnProcess: TOnProcess read FOnProcess write FOnProcess;
  end;


implementation

uses UnitConst, MainUnit;

procedure THistoryCostThread.Execute;
begin
  FError := '';

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

      if Assigned(OnProcess) then OnProcess('Выполнение расчета', FBranchId);

      // Перерасчета цен на слейве
      FZQueryTable.SQL.Text := cSQL_HistoryCost_Calc;
      FZQueryTable.ParamByName('inStartDate').Value := FStartDate;
      FZQueryTable.ParamByName('inEndDate').Value := FEndDate;
      FZQueryTable.ParamByName('inBranchId').Value := FBranchId;
      FZQueryTable.ParamByName('inItearationCount').Value := 50;
      FZQueryTable.ParamByName('inDiffSumm').Value := 1;
      FZQueryTable.ParamByName('inSession').Value := FSession;
      FZQueryTable.Open;
      FRewiringUUId := FZQueryTable.FieldByName('RewiringUUId').AsString;
      FZQueryTable.Close;

      // Отправка HistoryCost на мастер и возврат на слейв
      if FRewiringUUId <> '' then
      begin
        if Assigned(OnProcess) then OnProcess('Копирование результатов', FBranchId);

        FZQueryTable.SQL.Text := cSQL_HistoryCost_Send;
        FZQueryTable.ParamByName('inRewiringUUId').Value := FRewiringUUId;
        FZQueryTable.ParamByName('inStartDate').Value := FStartDate;
        FZQueryTable.ParamByName('inEndDate').Value := FEndDate;
        FZQueryTable.ParamByName('inBranchId').Value := FBranchId;
        FZQueryTable.ParamByName('inSession').Value := FSession;
        FZQueryTable.Open;
        FZQueryTable.Close;
      end else FError := 'Не получен RewiringUUId';

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
    if Assigned(FOnFinish) then OnFinish(FError, FBranchId);
  end;

end;


end.
