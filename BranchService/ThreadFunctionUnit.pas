unit ThreadFunctionUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  cxLabel, cxProgressBar, System.Math;

type
  TOnError = procedure(AError: string) of object;
  TOnFinish = procedure of object;
  TOnMessage = procedure(AText: string) of object;
  TOnAddLog = procedure(AText: string) of object;
  TOnProgress = procedure(AText: string; AFunctionRecordPos, AFunctionRecordMax : Integer) of object;

  // Поток для Переноса функций
  TFunctionThread = class(TThread)
  private
  { Private declarations }
    FHostName: String;
    FDatabase: String;
    FUser: String;
    FPassword: String;
    FPort: Integer;
    FLibraryLocation: String;

    FFunctionCount : Integer;

    FZConnection: TZConnection;
    FZQueryTable: TZQuery;
    FZQueryExecute: TZQuery;

    FError: String;

    FOnError: TOnError;
    FOnFinish: TOnFinish;
    FOnMessage: TOnMessage;
    FOnAddLog: TOnAddLog;
    FOnProgress: TOnProgress;
  protected
    procedure Execute; override;

    property OnError: TOnError read FOnError write FOnError;
    property OnFinish: TOnFinish read FOnFinish write FOnFinish;
    property OnMessage: TOnMessage read FOnMessage write FOnMessage;
    property OnAddLog: TOnAddLog read FOnAddLog write FOnAddLog;
    property OnProgress: TOnProgress read FOnProgress write FOnProgress;
  end;

  TThreadFunctionForm = class(TForm)
    PanelMain: TPanel;
    Panel1: TPanel;
    Button1: TButton;
    pbAll: TcxProgressBar;
    lblActionTake: TcxLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure SnapshotThreadError(AError: string);
    procedure SnapshotThreadFinish;
    procedure SnapshotThreadMessage(AText: string);
    procedure SnapshotThreadAddLog(AText: string);
    procedure SnapshotThreadProgress(AText: string; AFunctionRecordPos, AFunctionRecordMax : Integer);
  private
    { Private declarations }
    FFunctionThread : TFunctionThread;
    FError: String;
  public
    { Public declarations }
    property Error: String read FError;
  end;

implementation

{$R *.dfm}

Uses MainUnit, UnitConst;

procedure TThreadFunctionForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not FFunctionThread.Finished then
  begin
    if FFunctionThread.Terminated then Action := caNone
    else if MessageDlg('Выполняеться перенос функций.'#13#10#13#10'Прервать?', mtInformation, mbOKCancel, 0) = mrOk then
    begin
      FFunctionThread.FError := 'Прервано пользователем.';
      FFunctionThread.Terminate;
      Action := caNone;
    end else Action := caNone;
  end else
  begin
    FError := FFunctionThread.FError;
  end;
end;

procedure TThreadFunctionForm.FormCreate(Sender: TObject);
begin
  FError := '';
  FFunctionThread := TFunctionThread.Create(True);
  FFunctionThread.FreeOnTerminate:=False;
  FFunctionThread.FHostName := MainForm.edtSlaveServer.Text;
  FFunctionThread.FDatabase := MainForm.edtSlaveDatabase.Text;
  FFunctionThread.FUser := MainForm.edtSlaveUser.Text;
  FFunctionThread.FPassword := MainForm.edtSlavePassword.Text;
  FFunctionThread.FPort := StrToInt(MainForm.edtSlavePort.Text);
  FFunctionThread.FLibraryLocation := MainForm.ZConnection.LibraryLocation;

  FFunctionThread.FFunctionCount := 100;

  FFunctionThread.OnError := SnapshotThreadError;
  FFunctionThread.OnFinish := SnapshotThreadFinish;
  FFunctionThread.OnMessage := SnapshotThreadMessage;
  FFunctionThread.OnAddLog := SnapshotThreadAddLog;
  FFunctionThread.OnProgress := SnapshotThreadProgress
end;

procedure TThreadFunctionForm.FormDestroy(Sender: TObject);
begin
  FFunctionThread.Free;
end;


procedure TThreadFunctionForm.FormShow(Sender: TObject);
begin
  FFunctionThread.Resume;
end;

procedure TThreadFunctionForm.SnapshotThreadError(AError: string);
begin
//  inc(FErrors);
//  FSnapshotTableHasErrors := true;
//  UpdateSnapshotErrors;
//  SnapshotLog.Lines.Add(AError);
//  SaveSnapshotLog(AError);
end;

procedure TThreadFunctionForm.SnapshotThreadFinish;
begin
  TThread.CreateAnonymousThread(procedure
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          while not FFunctionThread.Finished do Sleep(1000);
          Close;
        end)
    end).Start;
end;

procedure TThreadFunctionForm.SnapshotThreadMessage(AText: string);
begin
  lblActionTake.Caption := AText;
end;

procedure TThreadFunctionForm.SnapshotThreadAddLog(AText: string);
begin
  MainForm.SaveBranchServiceLog(AText);
end;

procedure TThreadFunctionForm.SnapshotThreadProgress(AText: string; AFunctionRecordPos, AFunctionRecordMax : Integer);
begin
  lblActionTake.Caption := AText;

  pbAll.Properties.Max := AFunctionRecordMax;
  pbAll.Position := AFunctionRecordPos;
end;

{ TCheckConnectThread }

procedure TFunctionThread.Execute;
  var S: String;
      I, nOffset: Integer;
      List: TStringList;
begin
  FError := '';

  if Assigned(OnAddLog) then OnAddLog('Подключаемся к базе данных Slave.');
  if Assigned(OnMessage) then OnMessage('Подключаемся к базе данных Slave.');
  Sleep(2000);

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
      FZConnection.Connect;

      if Terminated then Exit;
      if Assigned(OnAddLog) then OnAddLog('Подсчитываем количество обновляемых функций.');
      if Assigned(OnMessage) then OnMessage('Подсчитываем количество обновляемых функций.');
      S := '';
      List := TStringList.Create;
      try
        List.Text := MainForm.LiadScripts(cFunctionFilter);
        for I := 0 to List.Count - 1 do
        if (List.Strings[I] <> '') and (List.Strings[I][1] <> '#') then
        begin
          if S <> '' then S := S + ',';
          S := S + List.Strings[I]
        end;
      finally
        List.Free;
      end;

      if Terminated then Exit;
      FZQueryTable.SQL.Text := Format(cSQLCalcFunctionMaster, [S]);
      FZQueryTable.Open;

      if Terminated then Exit;
      FZQueryExecute.SQL.Text := cSQLReplication_Function;

      nOffset := 0;
      if Assigned(OnProgress) then OnProgress(Format(cFunctionProcessing, [
                                              IntToStr(nOffset)
                                            , FZQueryTable.FieldByName('FunctionCount').AsString])
                                            , nOffset, FZQueryTable.FieldByName('FunctionCount').AsInteger);
      while True do
      begin
        if Terminated then
          Exit;
        FZQueryExecute.Close;
        FZQueryExecute.ParamByName('inFunctionFilter').AsString  := S;
        FZQueryExecute.ParamByName('inOffset').AsInteger := nOffset;
        FZQueryExecute.ParamByName('inRecordCount').AsInteger := FFunctionCount;
        FZQueryExecute.Open;

        if FZQueryExecute.FieldByName('ErrorText').AsString <> '' then
        begin
          FError := FZQueryExecute.FieldByName('ErrorText').AsString;
          Exit;
        end;

        Inc(nOffset, FZQueryExecute.FieldByName('FunctionCount').AsInteger);

        if Assigned(OnProgress) then OnProgress(Format(cFunctionProcessing, [
                                                       IntToStr(nOffset)
                                                     , FZQueryTable.FieldByName('FunctionCount').AsString])
                                                     , nOffset, FZQueryTable.FieldByName('FunctionCount').AsInteger);

        if FZQueryExecute.FieldByName('FunctionCount').AsInteger = 0 then Break;
      end;

      if Assigned(OnAddLog) then OnAddLog(Format(cFunctionResult, [IntToStr(nOffset)]));

      FZQueryTable.Next;

    except
      on E: Exception do
        FError := Format(cExceptionMsg, [E.ClassName, E.Message]);
    end;

  finally
    FZQueryExecute.Close;
    FZQueryTable.Close;
    FZConnection.Disconnect;
    FreeAndNil(FZQueryExecute);
    FreeAndNil(FZQueryTable);
    FreeAndNil(FZConnection);
    if Assigned(FOnFinish) then OnFinish;
  end;

end;

end.
