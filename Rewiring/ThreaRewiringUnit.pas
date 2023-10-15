unit ThreaRewiringUnit;

interface

uses System.Classes, System.SysUtils, System.DateUtils, DB,
     ZAbstractRODataset, ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection;

type

  TOnFinish = procedure(AError: String; AGroupId : Integer) of object;
  TOnProcess = procedure(AText: String; AGroupId, APosition, AMax : Integer) of object;

  // Поток для перерасчета цен
  TRewiringThread = class(TThread)
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
    FGroupId : Integer;
    FGroupName : String;
    FStartDate : TDateTime;
    FEndDate : TDateTime;
    FIsSale : Boolean;
    FIsBefoHistoryCost : Boolean;
    FStepRewiring : Integer;
    FSession : String;

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
    property GroupId : Integer read FGroupId write FGroupId;
    property GroupName : String read FGroupName write FGroupName;
    property StartDate : TDateTime read FStartDate write FStartDate;
    property EndDate : TDateTime read FEndDate write FEndDate;
    property IsSale : Boolean read FIsSale write FIsSale;
    property IsBefoHistoryCost : Boolean read FIsBefoHistoryCost write FIsBefoHistoryCost;
    property StepRewiring : Integer read FStepRewiring write FStepRewiring;
    property Session : String read FSession write FSession;

    property OnFinish: TOnFinish read FOnFinish write FOnFinish;
    property OnProcess: TOnProcess read FOnProcess write FOnProcess;
  end;


implementation

uses UnitConst, MainUnit;

procedure TRewiringThread.Execute;
  var nPos : Integer;
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

      if Assigned(OnProcess) then OnProcess('Пол. документов', FGroupId, 0, 0);

      // Процедура перепроведения
      FZQueryExecute.SQL.Text := cSQL_Rewiring_MovementId;

      // Перерасчета цен на слейве
      FZQueryTable.SQL.Text := Format(cSQL_Rewiring_Calc, [IntToStr(FStepRewiring)]);
      FZQueryTable.ParamByName('inStartDate').Value := FStartDate;
      FZQueryTable.ParamByName('inEndDate').Value := FEndDate;
      FZQueryTable.ParamByName('inIsSale').Value := FIsSale;
      FZQueryTable.ParamByName('inIsBefoHistoryCost').Value := FIsBefoHistoryCost;
      FZQueryTable.ParamByName('inGroupId').Value := FGroupId;
      FZQueryTable.Open;
      FZQueryTable.First;

      while not FZQueryTable.Eof do
      begin
        if Terminated then Exit;

        if nPos <> (100 * FZQueryTable.RecNo div FZQueryTable.RecordCount) then
        begin
          if Assigned(OnProcess) then OnProcess('Обработка', FGroupId, FZQueryTable.RecNo, FZQueryTable.RecordCount);
          nPos := (100 * FZQueryTable.RecNo div FZQueryTable.RecordCount);
        end;

        try
          FZQueryExecute.Close;
          FZQueryExecute.ParamByName('inMovementId').Value := FZQueryTable.FieldByName('MovementId').AsInteger;
          FZQueryExecute.ParamByName('inIsNoHistoryCost').Value := True;
          FZQueryExecute.ParamByName('inStepRewiring').Value := FStepRewiring;
          FZQueryExecute.ParamByName('inSession').Value := FSession;
          FZQueryExecute.Open;
        except
        end;

        FZQueryTable.Next;
      end;


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
    if Assigned(FOnFinish) then OnFinish(FError, FGroupId);
  end;

end;


end.
