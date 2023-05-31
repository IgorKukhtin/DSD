unit ThreadSnapshotUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  cxLabel, cxProgressBar, System.Math, System.RegularExpressions;

type
  TOnError = procedure(AError: string) of object;
  TOnFinish = procedure of object;
  TOnMessage = procedure(AText: string) of object;
  TOnAddLog = procedure(AText: string) of object;
  TOnProgress = procedure(AText: string; ATablePos, ATableMax : Integer;
                                         ATableRecordPos, ATableRecordMax : Integer;
                                         ARecordFullPos, ARecordFullMax : Int64) of object;

  // Поток для Перенос данных (снапшот)
  TSnapshotThread = class(TThread)
  private
  { Private declarations }
    FHostName: String;
    FDatabase: String;
    FUser: String;
    FPassword: String;
    FPort: Integer;
    FLibraryLocation: String;

    FRecordCountSelect : Integer;
    FRecordFull        : Int64;
    FRecordFullMax     : Int64;

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

  TThreadSnapshotForm = class(TForm)
    PanelMain: TPanel;
    Panel1: TPanel;
    btnEqualizationBreak: TButton;
    lblActionTake: TcxLabel;
    pbTable: TcxProgressBar;
    pbCurrTable: TcxProgressBar;
    cxLabel1: TcxLabel;
    pbAll: TcxProgressBar;
    cxLabel2: TcxLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure SnapshotThreadError(AError: string);
    procedure SnapshotThreadFinish;
    procedure SnapshotThreadMessage(AText: string);
    procedure SnapshotThreadAddLog(AText: string);
    procedure SnapshotThreadProgress(AText: string; ATablePos, ATableMax : Integer;
                                     ATableRecordPos, ATableRecordMax : Integer;
                                     ARecordFullPos, ARecordFullMax : Int64);
  private
    { Private declarations }
    FSnapshotThread : TSnapshotThread;
    FError: String;
  public
    { Public declarations }
    property Error: String read FError;
  end;

implementation

{$R *.dfm}

Uses MainUnit, UnitConst;

procedure TThreadSnapshotForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not FSnapshotThread.Finished then
  begin
    if FSnapshotThread.Terminated then Action := caNone
    else if MessageDlg('Выполняеться перенос данных (снапшот).'#13#10#13#10'Прервать?', mtInformation, mbOKCancel, 0) = mrOk then
    begin
      FSnapshotThread.FError := 'Прервано пользователем.';
      FSnapshotThread.Terminate;
      Action := caNone;
    end else Action := caNone;
  end else
  begin
    FError := FSnapshotThread.FError;
  end;
end;

procedure TThreadSnapshotForm.FormCreate(Sender: TObject);
begin
  FError := '';
  FSnapshotThread := TSnapshotThread.Create(True);
  FSnapshotThread.FreeOnTerminate:=False;
  FSnapshotThread.FHostName := MainForm.edtSlaveServer.Text;
  FSnapshotThread.FDatabase := MainForm.edtSlaveDatabase.Text;
  FSnapshotThread.FUser := MainForm.edtSlaveUser.Text;
  FSnapshotThread.FPassword := MainForm.edtSlavePassword.Text;
  FSnapshotThread.FPort := StrToInt(MainForm.edtSlavePort.Text);
  FSnapshotThread.FLibraryLocation := MainForm.ZConnection.LibraryLocation;

  FSnapshotThread.FRecordCountSelect := 10000;

  FSnapshotThread.OnError := SnapshotThreadError;
  FSnapshotThread.OnFinish := SnapshotThreadFinish;
  FSnapshotThread.OnMessage := SnapshotThreadMessage;
  FSnapshotThread.OnAddLog := SnapshotThreadAddLog;
  FSnapshotThread.OnProgress := SnapshotThreadProgress
end;

procedure TThreadSnapshotForm.FormDestroy(Sender: TObject);
begin
  FSnapshotThread.Free;
end;


procedure TThreadSnapshotForm.FormShow(Sender: TObject);
begin
  FSnapshotThread.Resume;
end;

procedure TThreadSnapshotForm.SnapshotThreadError(AError: string);
begin
//  inc(FErrors);
//  FSnapshotTableHasErrors := true;
//  UpdateSnapshotErrors;
//  SnapshotLog.Lines.Add(AError);
//  SaveSnapshotLog(AError);
end;

procedure TThreadSnapshotForm.SnapshotThreadFinish;
begin
  TThread.CreateAnonymousThread(procedure
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          while not FSnapshotThread.Finished do Sleep(1000);
          Close;
        end)
    end).Start;
end;

procedure TThreadSnapshotForm.SnapshotThreadMessage(AText: string);
begin
  lblActionTake.Caption := AText;
end;

procedure TThreadSnapshotForm.SnapshotThreadAddLog(AText: string);
begin
  MainForm.SaveBranchServiceLog(AText);
end;

procedure TThreadSnapshotForm.SnapshotThreadProgress(AText: string; ATablePos, ATableMax : Integer;
                                                     ATableRecordPos, ATableRecordMax : Integer;
                                                     ARecordFullPos, ARecordFullMax : Int64);
begin
  lblActionTake.Caption := AText;

  pbTable.Properties.Max := ATableMax;
  pbTable.Position := ATablePos;

  pbCurrTable.Properties.Max := ATableRecordMax;
  pbCurrTable.Position := ATableRecordPos;

  pbAll.Properties.Max := ARecordFullMax;
  pbAll.Position := ARecordFullPos;
end;

{ TCheckConnectThread }

procedure TSnapshotThread.Execute;
  var S: String;
      I, nOffset: Integer;
      List: TStringList;
      Res: TArray<string>;
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
      if Assigned(OnAddLog) then OnAddLog('Подсчитываем количество строк на мастере.');
      if Assigned(OnMessage) then OnMessage('Подсчитываем количество строк на мастере.');
      S := '';
      List := TStringList.Create;
      try
        List.Text := MainForm.LiadScripts(cReplicationList);
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
      FZQueryTable.SQL.Text := Format(cSQLCalculateTableMaster, [S]);
      FZQueryTable.Open;

      // Посчитаем общее количество строк
      FZQueryTable.First;
      FRecordFullMax := 0;
      while not FZQueryTable.Eof do
      begin
        FRecordFullMax := FRecordFullMax +  FZQueryTable.FieldByName('RecordCount').AsInteger;
        FZQueryTable.Next;
      end;

      if Terminated then Exit;
      FZQueryExecute.SQL.Text := cSQLReplication_Table;

      FZQueryTable.First;
      while not FZQueryTable.Eof do
      begin
        nOffset := 0;
        Res := TRegEx.Split(FZQueryTable.FieldByName('TableNane').AsString, ';');
        S := Res[0];
        if High(Res) > 1 then S := S + ' ' + Res[1];
        if Assigned(OnAddLog) then OnAddLog(Format(cTableLogStart, [
                                            FZQueryTable.FieldByName('TableNane').AsString]));
        if Assigned(OnProgress) then OnProgress(Format(cTableProcessing, [
                                                S
                                              , IntToStr(nOffset)
                                              , FZQueryTable.FieldByName('RecordCount').AsString])
                                              , FZQueryTable.RecNo, FZQueryTable.RecordCount
                                              , nOffset, FZQueryTable.FieldByName('RecordCount').AsInteger
                                              , FRecordFull, FRecordFullMax);
        while True do
        begin
          if Terminated then
            Exit;
          FZQueryExecute.Close;
          FZQueryExecute.ParamByName('inTableName').AsString  := FZQueryTable.FieldByName('TableNane').AsString;
          FZQueryExecute.ParamByName('inOffset').AsInteger := nOffset;
          if (Pos('blob', LowerCase(FZQueryExecute.ParamByName('inTableName').AsString)) > 0) and
             (Pos('desc', LowerCase(FZQueryExecute.ParamByName('inTableName').AsString)) = 0) then
            FZQueryExecute.ParamByName('inRecordCount').AsInteger := MAX(1000, FRecordCountSelect div 10)
          else if (Pos('movement', LowerCase(FZQueryExecute.ParamByName('inTableName').AsString)) > 0) and
             (Pos('desc', LowerCase(FZQueryExecute.ParamByName('inTableName').AsString)) = 0) then
            FZQueryExecute.ParamByName('inRecordCount').AsInteger := MAX(1000, FRecordCountSelect div 10)
          else FZQueryExecute.ParamByName('inRecordCount').AsInteger := FRecordCountSelect;
          FZQueryExecute.Open;

          if FZQueryExecute.FieldByName('ErrorText').AsString <> '' then
          begin
            FError := FZQueryExecute.FieldByName('ErrorText').AsString;
            Exit;
          end;

          Inc(nOffset, FZQueryExecute.FieldByName('RowCount').AsInteger);
          Inc(FRecordFull, FZQueryExecute.FieldByName('RowCount').AsInteger);

          if Assigned(OnProgress) then OnProgress(Format(cTableProcessing, [
                                                  FZQueryTable.FieldByName('TableNane').AsString
                                                , IntToStr(nOffset)
                                                , FZQueryTable.FieldByName('RecordCount').AsString])
                                                , FZQueryTable.RecNo, FZQueryTable.RecordCount
                                                , nOffset, FZQueryTable.FieldByName('RecordCount').AsInteger
                                                , FRecordFull, FRecordFullMax);

          if FZQueryExecute.FieldByName('RowCount').AsInteger <
            FZQueryExecute.ParamByName('inRecordCount').AsInteger then Break;
        end;

        if Assigned(OnAddLog) then OnAddLog(Format(cTableLogResult, [
                                            FZQueryTable.FieldByName('TableNane').AsString,
                                            IntToStr(nOffset)]));

        FZQueryTable.Next;
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
    if Assigned(FOnFinish) then Synchronize(OnFinish);
  end;

end;

end.
