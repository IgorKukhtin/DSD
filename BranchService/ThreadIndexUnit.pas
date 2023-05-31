unit ThreadIndexUnit;

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
  TIndexThread = class(TThread)
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

  TThreadIndexForm = class(TForm)
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
    FFunctionThread : TIndexThread;
    FError: String;
  public
    { Public declarations }
    property Error: String read FError;
  end;

implementation

{$R *.dfm}

Uses MainUnit, UnitConst;

procedure TThreadIndexForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not FFunctionThread.Finished then
  begin
    if FFunctionThread.Terminated then Action := caNone
    else if MessageDlg('Выполняеться создание индексов.'#13#10#13#10'Прервать?', mtInformation, mbOKCancel, 0) = mrOk then
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

procedure TThreadIndexForm.FormCreate(Sender: TObject);
begin
  FError := '';
  FFunctionThread := TIndexThread.Create(True);
  FFunctionThread.FreeOnTerminate:=False;
  FFunctionThread.FHostName := MainForm.edtSlaveServer.Text;
  FFunctionThread.FDatabase := MainForm.edtSlaveDatabase.Text;
  FFunctionThread.FUser := MainForm.edtSlaveUser.Text;
  FFunctionThread.FPassword := MainForm.edtSlavePassword.Text;
  FFunctionThread.FPort := StrToInt(MainForm.edtSlavePort.Text);
  FFunctionThread.FLibraryLocation := MainForm.ZConnection.LibraryLocation;

  FFunctionThread.OnError := SnapshotThreadError;
  FFunctionThread.OnFinish := SnapshotThreadFinish;
  FFunctionThread.OnMessage := SnapshotThreadMessage;
  FFunctionThread.OnAddLog := SnapshotThreadAddLog;
  FFunctionThread.OnProgress := SnapshotThreadProgress
end;

procedure TThreadIndexForm.FormDestroy(Sender: TObject);
begin
  FFunctionThread.Free;
end;


procedure TThreadIndexForm.FormShow(Sender: TObject);
begin
  FFunctionThread.Resume;
end;

procedure TThreadIndexForm.SnapshotThreadError(AError: string);
begin
//  inc(FErrors);
//  FSnapshotTableHasErrors := true;
//  UpdateSnapshotErrors;
//  SnapshotLog.Lines.Add(AError);
//  SaveSnapshotLog(AError);
end;

procedure TThreadIndexForm.SnapshotThreadFinish;
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

procedure TThreadIndexForm.SnapshotThreadMessage(AText: string);
begin
  lblActionTake.Caption := AText;
end;

procedure TThreadIndexForm.SnapshotThreadAddLog(AText: string);
begin
  MainForm.SaveBranchServiceLog(AText);
end;

procedure TThreadIndexForm.SnapshotThreadProgress(AText: string; AFunctionRecordPos, AFunctionRecordMax : Integer);
begin
  lblActionTake.Caption := AText;

  pbAll.Properties.Max := AFunctionRecordMax;
  pbAll.Position := AFunctionRecordPos;
end;

{ TCheckConnectThread }

procedure TIndexThread.Execute;
  var S: String;
      I, nIndex: Integer;
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

  if Terminated then Exit;
  FZQueryExecute.SQL.Text := cSQLReplication_Index;

  try
    try
      FZConnection.Connect;

      if Terminated then Exit;
      if Assigned(OnAddLog) then OnAddLog('Получаем перечень таблмц.');
      if Assigned(OnMessage) then OnMessage('Получаем перечень таблмц.');
      S := ''; nIndex := 0;
      List := TStringList.Create;
      try
        List.Text := MainForm.LiadScripts(cTableListAll);

        for I := 0 to List.Count - 1 do
        begin
          if Terminated then Exit;

          if Assigned(OnProgress) then OnProgress(Format(cIndexProcessing, [
                                                         IntToStr(I)
                                                       , IntToStr(List.Count)
                                                       , List.Strings[I]])
                                                       , I, List.Count);

          FZQueryExecute.Close;
          FZQueryExecute.ParamByName('inTableName').AsString  := List.Strings[I];
          FZQueryExecute.Open;

          if FZQueryExecute.FieldByName('ErrorText').AsString <> '' then
          begin
            FError := FZQueryExecute.FieldByName('ErrorText').AsString;
            Exit;
          end;

        end;
      finally
        if Assigned(OnAddLog) then OnAddLog(Format(cIndexResult, [IntToStr(List.Count), IntToStr(nIndex)]));
        List.Free;
      end;

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
