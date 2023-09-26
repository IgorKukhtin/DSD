unit ThreaFunctionUnit;

interface

uses System.Classes, System.SysUtils, System.DateUtils, DB,
     ZAbstractRODataset, ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection;

type

  TOnFinish = procedure(AError: String; AGroupId : Integer) of object;
  TOnProcess = procedure(AText: String; AGroupId, APosition, AMax : Integer) of object;

  // Поток для перерасчета цен
  TFunctionThread = class(TThread)
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
    property Session : String read FSession write FSession;

    property OnFinish: TOnFinish read FOnFinish write FOnFinish;
    property OnProcess: TOnProcess read FOnProcess write FOnProcess;
  end;


implementation

uses UnitConst, MainUnit;

procedure TFunctionThread.Execute;
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

      if Assigned(OnProcess) then OnProcess('Подсчитываем количество обновляемых функций', 1, 0, 0);

      if Terminated then Exit;
      FZQueryTable.SQL.Text := cSQLCalcFunctionMaster;
      FZQueryTable.Open;

      if Terminated then Exit;
      FZQueryExecute.SQL.Text := cSQLReplication_Function;

      nOffset := 0;
      while True do
      begin
        if Terminated then
          Exit;
        FZQueryExecute.Close;
        FZQueryExecute.ParamByName('inOffset').AsInteger := nOffset;
        FZQueryExecute.ParamByName('inRecordCount').AsInteger := 100;
        FZQueryExecute.Open;

        if FZQueryExecute.FieldByName('ErrorText').AsString <> '' then
        begin
          FError := FZQueryExecute.FieldByName('ErrorText').AsString;
          Exit;
        end;

        Inc(nOffset, FZQueryExecute.FieldByName('FunctionCount').AsInteger);

        if nPos <> (100 * nOffset div FZQueryTable.FieldByName('FunctionCount').AsInteger) then
        begin
          if Assigned(OnProcess) then OnProcess('Копирование функций', 1, nOffset, FZQueryTable.FieldByName('FunctionCount').AsInteger);
          nPos := (100 * nOffset div FZQueryTable.FieldByName('FunctionCount').AsInteger);
        end;

        if FZQueryExecute.FieldByName('FunctionCount').AsInteger = 0 then Break;
      end;

      if Assigned(OnProcess) then OnProcess('Копирование функций', 1, nOffset, FZQueryTable.FieldByName('FunctionCount').AsInteger);

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
    if Assigned(FOnFinish) then OnFinish(FError, 1);
  end;

end;


end.
