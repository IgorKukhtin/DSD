unit UMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Samples.Spin,
  UDefinitions,
  ULog,
  UData;


type
  TfrmMain = class(TForm)
    pgcMain: TPageControl;
    tsLog: TTabSheet;
    tsSettings: TTabSheet;
    pnlLogTop: TPanel;
    pnlLogLeft: TPanel;
    pnlLog: TPanel;
    mmoLog: TMemo;
    lbRange: TLabel;
    seRange: TSpinEdit;
    grpMaster: TGroupBox;
    grpSlave: TGroupBox;
    lbMasterServer: TLabel;
    edtMasterServer: TEdit;
    lbDatabase: TLabel;
    edtMasterDatabase: TEdit;
    lbSlaveServer: TLabel;
    edtSlaveServer: TEdit;
    lbSlaveDatabase: TLabel;
    edtSlaveDatabase: TEdit;
    chkShowLog: TCheckBox;
    btnSendSinglePacket: TButton;
    pgcLog: TPageControl;
    tsMemo: TTabSheet;
    tsChk: TTabSheet;
    lbMasterUser: TLabel;
    lbMasterPort: TLabel;
    edtMasterUser: TEdit;
    edtMasterPort: TEdit;
    lbMasterPassword: TLabel;
    edtMasterPassword: TEdit;
    lbSlaveUser: TLabel;
    edtSlaveUser: TEdit;
    lbSlavePassword: TLabel;
    edtSlavePassword: TEdit;
    lbSlavePort: TLabel;
    edtSlavePort: TEdit;
    lbLibLocation: TLabel;
    edtLibLocation: TEdit;
    btnLibLocation: TButton;
    {$WARNINGS OFF}
    opndlgMain: TFileOpenDialog;
    btnTestMaster: TButton;
    btnTestSlave: TButton;
    btnReplicaCommandsSQL: TButton;
    lbStartReplica: TLabel;
    edtStartReplica: TEdit;
    btnMinId: TButton;
    btnMaxId: TButton;
    btnUseMinId: TButton;
    lbLastId: TLabel;
    btnSendPackets: TButton;
    chkWriteLog: TCheckBox;
    {$WARNINGS ON}
    procedure chkShowLogClick(Sender: TObject);
    procedure btnLibLocationClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnTestMasterClick(Sender: TObject);
    procedure btnTestSlaveClick(Sender: TObject);
    procedure btnSendSinglePacketClick(Sender: TObject);
    procedure btnReplicaCommandsSQLClick(Sender: TObject);
    procedure seRangeChange(Sender: TObject);
    procedure edtStartReplicaExit(Sender: TObject);
    procedure mmoLogChange(Sender: TObject);
    procedure btnMinIdClick(Sender: TObject);
    procedure btnMaxIdClick(Sender: TObject);
    procedure btnUseMinIdClick(Sender: TObject);
    procedure btnSendPacketsClick(Sender: TObject);
    procedure chkWriteLogClick(Sender: TObject);
  private
    FLog: TLog;
    FData: TdmData;
  private
    procedure ReadSettings;
    procedure WriteSettings;
    procedure AssignOnExitSettings;
    procedure SwitchShowLog;
    procedure LogMessage(const AMsg: string);
    procedure OnChangeStartId(const ANewStartId: Integer);
    procedure OnTerminateSinglePacket(Sender: TObject);
    procedure OnTerminateReplica(Sender: TObject);
  private
    procedure OnExitSettings(Sender: TObject);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  UConstants,
  USettings;

const
  cLastId = 'Последний обработанный Id = %d';

function BelongsTo(AControl, ASerachParent: TWinControl): Boolean;
var
  tmpParent: TWinControl;
begin
  tmpParent := AControl.Parent;

  while (tmpParent <> nil) and (tmpParent <> ASerachParent) do
    tmpParent := tmpParent.Parent;

  Result := (tmpParent = ASerachParent);
end;

procedure TfrmMain.ReadSettings;
begin
  edtMasterServer.Text   := TSettings.MasterServer;
  edtMasterDatabase.Text := TSettings.MasterDatabase;
  edtMasterUser.Text     := TSettings.MasterUser;
  edtMasterPassword.Text := TSettings.MasterPassword;
  edtMasterPort.Text     := IntToStr(TSettings.MasterPort);

  edtSlaveServer.Text   := TSettings.SlaveServer;
  edtSlaveDatabase.Text := TSettings.SlaveDatabase;
  edtSlaveUser.Text     := TSettings.SlaveUser;
  edtSlavePassword.Text := TSettings.SlavePassword;
  edtSlavePort.Text     := IntToStr(TSettings.SlavePort);

  edtLibLocation.Text  := TSettings.LibLocation;
  edtStartReplica.Text := IntToStr(TSettings.ReplicaStart);
  seRange.Value        := TSettings.ReplicaRange;
  chkWriteLog.Checked  := TSettings.UseLog;
  chkShowLog.Checked   := TSettings.UseLogGUI;
  SwitchShowLog;
end;

procedure TfrmMain.seRangeChange(Sender: TObject);
begin
  TSettings.ReplicaRange := seRange.Value;
end;

procedure TfrmMain.SwitchShowLog;
begin
  if chkShowLog.Checked then
    pgcLog.ActivePage := tsMemo
  else
    pgcLog.ActivePage := tsChk;
end;

procedure TfrmMain.WriteSettings;
begin
  TSettings.MasterServer   := edtMasterServer.Text;
  TSettings.MasterDatabase := edtMasterDatabase.Text;
  TSettings.MasterUser     := edtMasterUser.Text;
  TSettings.MasterPassword := edtMasterPassword.Text;
  TSettings.MasterPort     := StrToIntDef(edtMasterPort.Text, TSettings.DefaultPort);

  TSettings.SlaveServer   := edtSlaveServer.Text;
  TSettings.SlaveDatabase := edtSlaveDatabase.Text;
  TSettings.SlaveUser     := edtSlaveUser.Text;
  TSettings.SlavePassword := edtSlavePassword.Text;
  TSettings.SlavePort     := StrToIntDef(edtSlavePort.Text, TSettings.DefaultPort);

  TSettings.LibLocation  := edtLibLocation.Text;
  TSettings.ReplicaRange := seRange.Value;
  TSettings.UseLogGUI    := chkShowLog.Checked;
end;

procedure TfrmMain.AssignOnExitSettings;
var
  I: Integer;
begin
  for I := 0 to Pred(ComponentCount) do
    if Components[I] is TEdit then
      if BelongsTo(TEdit(Components[I]), tsSettings) then
      begin
        OutputDebugString(PWideChar('Edit.name = ' + Components[I].Name));
        TEdit(Components[I]).OnExit := OnExitSettings;
      end;
end;

procedure TfrmMain.btnLibLocationClick(Sender: TObject);
begin
  {$WARNINGS OFF}
  with opndlgMain.FileTypes.Add do
  begin
    DisplayName := 'Клиентская библиотека PostgreSQL';
    FileMask := 'libpq.dll';
  end;

  if opndlgMain.Execute then
    edtLibLocation.Text := opndlgMain.FileName;
  {$WARNINGS ON}
end;

procedure TfrmMain.btnMaxIdClick(Sender: TObject);
const
  cMsg = 'Max Id = %d';
begin
  LogMessage(Format(cMsg, [FData.MaxId]));
end;

procedure TfrmMain.btnMinIdClick(Sender: TObject);
const
  cMsg = 'Min Id = %d';
begin
  LogMessage(Format(cMsg, [FData.MinId]));
end;

procedure TfrmMain.btnReplicaCommandsSQLClick(Sender: TObject);
const
  cStartPerlica = 'Старт репликации: %d, диапазон: %d, SQL:' + #13#10 + '%s';
  cCmdCountMsg = 'В пакете всего команд: %d';
begin
  // формирование SelectSQL для ZQuery, который вернет набор команд репликации
  FData.BuildReplicaCommandsSQL( TSettings.ReplicaStart, TSettings.ReplicaRange);
  LogMessage(
    Format(
      cStartPerlica, [
        StrToIntDef(edtStartReplica.Text, 0),
        seRange.Value,
        FData.qrySelectReplicaCmd.SQL.Text
      ])
  );

  // количество команд репликации
  LogMessage(Format(cCmdCountMsg, [FData.GetReplicaCmdCount]));
end;

procedure TfrmMain.btnSendPacketsClick(Sender: TObject);
const
  cStartPerlica = 'Старт репликации: %d, диапазон: %d';
var
  iStart, iRange: Integer;
  tmpReplica: TReplicaThread;
begin
  iStart := StrToIntDef(edtStartReplica.Text, 0);
  iRange := seRange.Value;

  LogMessage(Format(cStartPerlica, [iStart, iRange]));

  tmpReplica := TReplicaThread.Create(cCreateSuspended, iStart, iRange, LogMessage);
  tmpReplica.OnTerminate := OnTerminateReplica;
  tmpReplica.OnChangeStartId := OnChangeStartId;
  tmpReplica.Start;
  btnSendPackets.Enabled := False;
end;

procedure TfrmMain.btnSendSinglePacketClick(Sender: TObject);
var
  tmpWorker: TSinglePacket;
begin
  LogMessage('Старт выгрузки одного пакета ');
  tmpWorker := TSinglePacket.Create(
    cCreateSuspended,
    StrToIntDef(edtStartReplica.Text, 0),
    seRange.Value,
    LogMessage
  );
  tmpWorker.OnTerminate := OnTerminateSinglePacket;
  tmpWorker.OnChangeStartId := OnChangeStartId;
  tmpWorker.Start;
  btnSendSinglePacket.Enabled := False;
end;

procedure TfrmMain.btnTestMasterClick(Sender: TObject);
begin
  FData.conMaster.Disconnect;

  if FData.IsMasterConnected then
    LogMessage('Master подключен');
end;

procedure TfrmMain.btnTestSlaveClick(Sender: TObject);
begin
  FData.conSlave.Disconnect;

  if FData.IsSlaveConnected then
    LogMessage('Slave подключен');
end;

procedure TfrmMain.btnUseMinIdClick(Sender: TObject);
begin
  edtStartReplica.Text := IntToStr(FData.MinId);
end;

procedure TfrmMain.chkShowLogClick(Sender: TObject);
begin
  SwitchShowLog;
  TSettings.UseLogGUI := chkShowLog.Checked;
end;

procedure TfrmMain.chkWriteLogClick(Sender: TObject);
begin
  TSettings.UseLog := chkWriteLog.Checked;
end;

procedure TfrmMain.edtStartReplicaExit(Sender: TObject);
begin
  TSettings.ReplicaStart := StrToIntDef(edtStartReplica.Text, 1);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteSettings;
  FreeAndNil(FData);
  FreeAndNil(FLog);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FLog := TLog.Create;
  pgcMain.ActivePage := tsLog;
  ReadSettings;
  AssignOnExitSettings;

  FData := TdmData.Create(
    nil,
    StrToIntDef(edtStartReplica.Text, 0),
    seRange.Value,
    LogMessage
  );
  FData.OnChangeStartId := OnChangeStartId;
end;

procedure TfrmMain.LogMessage(const AMsg: string);
const
  cMsg = '%s %s';
begin
  if TSettings.UseLog then
    FLog.Write('application.log', AMsg);

  mmoLog.Lines.Add(
    Format(cMsg, [
      FormatDateTime(cTimeStr, Now),
      AMsg
    ])
  );
end;

procedure TfrmMain.mmoLogChange(Sender: TObject);
begin
  SendMessage((Sender as TMemo).Handle, EM_LINESCROLL, 0, (Sender as TMemo).Lines.Count);
end;

procedure TfrmMain.OnChangeStartId(const ANewStartId: Integer);
begin
  lbLastId.Caption := Format(cLastId, [ANewStartId]);
end;

procedure TfrmMain.OnExitSettings(Sender: TObject);
begin
  WriteSettings;
end;

procedure TfrmMain.OnTerminateReplica(Sender: TObject);
const
  cEnd = 'Репликация завершена';
begin
  LogMessage(cEnd);
  btnSendPackets.Enabled := True;
end;

procedure TfrmMain.OnTerminateSinglePacket(Sender: TObject);
var
  tmpWorker: TWorkerThread;
  iCount: Integer;
const
  cEnd = 'Окончание выгрузки одного пакета. Выполнено %d команд';
begin
  tmpWorker := (Sender as TWorkerThread);
  iCount := tmpWorker.MyReturnValue;

  LogMessage(Format(cEnd, [iCount]));

  btnSendSinglePacket.Enabled := True;
end;

end.
