unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.UITypes,
  System.Variants, System.Classes, Vcl.Graphics, System.StrUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxBarBuiltInMenu, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, Vcl.StdCtrls, cxPC,
  Data.DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, ZAbstractConnection,
  ZConnection, Vcl.ExtCtrls, cxContainer, cxEdit, cxTextEdit, cxMemo, cxLabel,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxProgressBar, DataModul, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxNavigator, dxDateRanges, cxDBData, cxCheckBox, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxGridCustomView, cxGrid, Datasnap.DBClient, cxCurrencyEdit,
  DateUtils;

type
  TMainForm = class(TForm)
    cxPageControl: TcxPageControl;
    cxTabSheetUpdate: TcxTabSheet;
    cxTabSheetSnapshot: TcxTabSheet;
    grpSlave: TGroupBox;
    lbSlaveServer: TLabel;
    lbSlaveDatabase: TLabel;
    lbSlaveUser: TLabel;
    lbSlavePassword: TLabel;
    lbSlavePort: TLabel;
    edtSlaveServer: TEdit;
    edtSlaveDatabase: TEdit;
    edtSlaveUser: TEdit;
    edtSlavePassword: TEdit;
    edtSlavePort: TEdit;
    grpMaster: TGroupBox;
    lbMasterServer: TLabel;
    lbDatabase: TLabel;
    lbMasterUser: TLabel;
    lbMasterPort: TLabel;
    lbMasterPassword: TLabel;
    edtMasterServer: TEdit;
    edtMasterDatabase: TEdit;
    edtMasterUser: TEdit;
    edtMasterPort: TEdit;
    edtMasterPassword: TEdit;
    ZConnection: TZConnection;
    ZQuery: TZQuery;
    grpScripts: TGroupBox;
    pnlScriptBottom: TPanel;
    btnCheck�ase: TButton;
    pnlScriptTop: TPanel;
    lbScriptPath: TLabel;
    pnlScriptList: TPanel;
    edtScriptPath: TEdit;
    btnScriptPath: TButton;
    mmoScriptLog: TcxMemo;
    opndlgMain: TFileOpenDialog;
    ZQueryExecute: TZQuery;
    btnSnapshot: TButton;
    btnFunction: TButton;
    btnView: TButton;
    GroupBox1: TGroupBox;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    deDateSnapshot: TcxDateEdit;
    deDateSend: TcxDateEdit;
    deDateEqualization: TcxDateEdit;
    btnIndex: TButton;
    Panel1: TPanel;
    cxLabel4: TcxLabel;
    ReplServerId: TcxTextEdit;
    ReplServerCode: TcxTextEdit;
    ReplServerName: TcxTextEdit;
    grpEqualization: TGroupBox;
    Panel2: TPanel;
    btnEqualizationAll: TButton;
    Panel3: TPanel;
    mmoScriptLogEqualization: TcxMemo;
    btnEqualizationLoad: TButton;
    btnEqualizationSend: TButton;
    pbEqualization: TcxProgressBar;
    lblActionTake: TcxLabel;
    btnEqualizationBreak: TButton;
    btnSequence: TButton;
    cxTabSheetDocSettings: TcxTabSheet;
    Panel5: TPanel;
    cxLabel5: TcxLabel;
    cxGridDescIdMovement: TcxGrid;
    cxGridDescIdMovementDBTableView: TcxGridDBTableView;
    ItemName: TcxGridDBColumn;
    cxGridDescIdMovementLevel: TcxGridLevel;
    cxGridDescIdMovementDBTableViewColumn1: TcxGridDBColumn;
    cxGridDescIdMovementDBTableViewColumn2: TcxGridDBColumn;
    cxGridDescIdMovementDBTableViewColumn3: TcxGridDBColumn;
    cxGridDescIdMovementDBTableViewColumn4: TcxGridDBColumn;
    cxGridDescIdMovementDBTableViewColumn5: TcxGridDBColumn;
    cxGridDescIdMovementDBTableViewColumn6: TcxGridDBColumn;
    cxGridDescIdMovementDBTableViewColumn7: TcxGridDBColumn;
    ZQueryDescIdMovement: TZQuery;
    DataSourceDescIdMovement: TDataSource;
    Panel6: TPanel;
    btnReserveId: TButton;
    pnlInfoEqualization: TPanel;
    btnUpdateDataLog: TButton;
    edtMasterPasswordUpd: TEdit;
    edtMasterUserUpd: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtSlavePasswordUpd: TEdit;
    edtSlaveUserUpd: TEdit;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    EqualizationCDS: TClientDataSet;
    EqualizationDS: TDataSource;
    TableName: TcxGridDBColumn;
    CounutEqualization: TcxGridDBColumn;
    CounutEqualizationLast: TcxGridDBColumn;
    CounutSend: TcxGridDBColumn;
    CounutSendLast: TcxGridDBColumn;
    EqualizationCDSTableName: TStringField;
    EqualizationCDSCounutEqualization: TIntegerField;
    EqualizationCDSCounutEqualizationLast: TIntegerField;
    EqualizationCDSCounutSend: TIntegerField;
    EqualizationCDSCounutSendLast: TIntegerField;
    btnlInfoEqualizationView: TButton;
    TimerEqualization: TTimer;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    edRecordStep: TcxCurrencyEdit;
    edTimerInterval: TcxCurrencyEdit;
    edOffsetTimeEnd: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnScriptPathClick(Sender: TObject);
    procedure btnCheck�aseClick(Sender: TObject);
    procedure btnSnapshotClick(Sender: TObject);
    procedure btnFunctionClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnIndexClick(Sender: TObject);
    procedure btnEqualizationLoadClick(Sender: TObject);
    procedure btnEqualizationBreakClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSequenceClick(Sender: TObject);
    procedure cxPageControlPageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
    procedure btnReserveIdClick(Sender: TObject);
    procedure deDateEqualizationExit(Sender: TObject);
    procedure deDateSendExit(Sender: TObject);
    procedure deDateSnapshotExit(Sender: TObject);
    procedure btnUpdateDataLogClick(Sender: TObject);
    procedure btnlInfoEqualizationViewClick(Sender: TObject);
    procedure TimerEqualizationTimer(Sender: TObject);
    procedure btnEqualizationAllClick(Sender: TObject);
    procedure edRecordStepExit(Sender: TObject);
    procedure edTimerIntervalExit(Sender: TObject);
    procedure edOffsetTimeEndExit(Sender: TObject);
    procedure btnEqualizationSendClick(Sender: TObject);
  private
    { Private declarations }

    FDateSnapshot : Variant;
    FDateSend : Variant;
    FDateEqualization : Variant;
    FRecordStep : Integer;
    FOffsetTimeEnd : Integer;

    FTimerEqualization : Boolean;
    FCloseFoeFinish : Boolean;

    procedure ReadSettings;
    procedure ReadInfo;
    procedure WriteSettings;
    function GetInfoMaster : Boolean;
    function GetInfoSlave(AShowError : boolean) : Boolean;
    function GetInfoSlavePostgres : Boolean;

    procedure EqualizationThreadFinish(AError : String);
    procedure EqualizationThreadMessage(AText: string);
    procedure EqualizationThreadAddLog;
    procedure EqualizationThreadProgress;
  public
    { Public declarations }
    procedure SaveBranchServiceLog(ALogMessage: string; AShowMessage: Boolean = False);
    procedure SaveBranchEqualizationeLog(ALogMessage: string; AShowMessage: Boolean = False);
    function LiadScripts(AFileName : String) : String;
    function CheckDB : boolean;
    procedure EqualizationAll(AMode: Integer);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses System.Math, System.IOUtils, UnitSettings, UnitConst,
     ThreadSnapshotUnit, ThreadFunctionUnit, ThreadIndexUnit, ThreadbtnEqualizationUnit;

var EqualizationThread : TEqualizationThread;

procedure TMainForm.SaveBranchServiceLog(ALogMessage: string; AShowMessage: Boolean = False);
var F: TextFile;
    cFile: string;
begin
  mmoScriptLog.Lines.Add(ALogMessage);
  cFile := ExtractFilePath(ParamStr(0))+'\BranchService.log';
  AssignFile(F, cFile);
  if FileExists(cFile) then
    Append(F)
  else
    Rewrite(F);
  WriteLn(F, DateTimeToStr(Now) + ' : ' + StringReplace(ALogMessage, #13#10, ' ', [rfReplaceAll]));
  CloseFile(F);
  if AShowMessage then ShowMessage(ALogMessage);
end;

procedure TMainForm.TimerEqualizationTimer(Sender: TObject);
begin
  TimerEqualization.Enabled := False;
  EqualizationAll(3);
end;

procedure TMainForm.SaveBranchEqualizationeLog(ALogMessage: string; AShowMessage: Boolean = False);
var F: TextFile;
    cFile: string;
begin
  mmoScriptLogEqualization.Lines.Add(ALogMessage);
  cFile := ExtractFilePath(ParamStr(0))+'\BranchService_Equalization.log';
  AssignFile(F, cFile);
  if FileExists(cFile) then
    Append(F)
  else
    Rewrite(F);
  WriteLn(F, DateTimeToStr(Now) + ' : ' + StringReplace(ALogMessage, #13#10, ' ', [rfReplaceAll]));
  CloseFile(F);
  if AShowMessage then ShowMessage(ALogMessage);
end;

function TMainForm.LiadScripts(AFileName : String) : String;
var cFile: string;
begin
  cFile := edtScriptPath.Text + AFileName;
  if FileExists(cFile) then Result := TFile.ReadAllText(cFile)
  else raise Exception.Create('������ ���� ' + cFile + ' �� ������.');
end;

function TMainForm.GetInfoMaster : Boolean;
begin
  Result := False;
  SaveBranchServiceLog('����������� � Master � ���� ' + edtMasterDatabase.Text);
  try
    ZConnection.Disconnect;
    ZConnection.HostName :=  edtMasterServer.Text;
    ZConnection.Database :=  edtMasterDatabase.Text;
    ZConnection.User     :=  edtMasterUser.Text;
    ZConnection.Password :=  edtMasterPassword.Text;
    ZConnection.Port     :=  StrToInt(edtMasterPort.Text);

    ZConnection.Connect;
    Result := ZConnection.Connected;
  except
    on E: Exception do
      SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TMainForm.GetInfoSlave(AShowError : boolean) : Boolean;
begin
  Result := False;
  SaveBranchServiceLog('����������� � Slave � ���� ' + edtSlaveDatabase.Text);
  try
    ZConnection.Disconnect;
    ZConnection.HostName :=  edtSlaveServer.Text;
    ZConnection.Database :=  edtSlaveDatabase.Text;
    ZConnection.User     :=  edtSlaveUser.Text;
    ZConnection.Password :=  edtSlavePassword.Text;
    ZConnection.Port     :=  StrToInt(edtSlavePort.Text);

    ZConnection.Connect;
    Result := ZConnection.Connected;
  except
    on E: Exception do
      if AShowError then SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TMainForm.GetInfoSlavePostgres : Boolean;
begin
  Result := False;
  SaveBranchServiceLog('����������� � Slave � ���� postgres');
  try
    ZConnection.Disconnect;
    ZConnection.HostName :=  edtSlaveServer.Text;
    ZConnection.Database :=  'postgres';
    ZConnection.User     :=  edtSlaveUser.Text;
    ZConnection.Password :=  edtSlavePassword.Text;
    ZConnection.Port     :=  StrToInt(edtSlavePort.Text);

    ZConnection.Connect;
    Result := ZConnection.Connected;
  except
    on E: Exception do
      SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TMainForm.btnCheck�aseClick(Sender: TObject);
  var cEncodings, S, MovementDesc : String; List : TStringList; I, nReplServerId : Integer;
begin
  if not GetInfoMaster then Exit;
  try
    nReplServerId := 0;
    ZQuery.Close;
    ZQuery.SQL.Text := Format(cSQLInfoDB, [edtMasterDatabase.Text]);
    ZQuery.Open;
    SaveBranchServiceLog('������ �������: ' + ZQuery.FieldByName('Version').AsString);
    SaveBranchServiceLog('���������: ' + ZQuery.FieldByName('Encodings').AsString);
    cEncodings := ZQuery.FieldByName('Encodings').AsString;

    if not ZQuery.FieldByName('isCatalogReplica').AsBoolean then
    begin
      ShowMessage('�� ������� �� ������� ����� <_replica> ������ ����������.');
      Exit;
    end;

    // ������� �� ������� ������� ��������� ��������� �������
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLpg_get_tabledef);
    ZQueryExecute.ExecSQL;

    // ������� (���������) Table_Equalization_ObjectId
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLTable_Equalization_ObjectId);
    ZQueryExecute.ExecSQL;

    // ������� (���������) gpBranchService_EqualizationPrepareId
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLEqualizationPrepareId);
    ZQueryExecute.ExecSQL;

    // ������� (���������) BranchService_DescId_ForMovement
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLEqualizationForMovement);
    ZQueryExecute.ExecSQL;

    // �������� BranchService_DescId_ForMovement
    ZQueryExecute.SQL.Text := cSQLDelete_DescId_ForMovement;
    ZQueryExecute.ExecSQL;

    List := TStringList.Create;
    try
      List.Text := MainForm.LiadScripts(cMovementEqualizationDesc);
      for I := 0 to List.Count - 1 do if (Trim(List.Strings[I]) <> '') and (Trim(List.Strings[I])[1] <> '#') then
      begin
        MovementDesc := Trim(List.Strings[I]);
        if Copy(MovementDesc, Length(MovementDesc) - 1, 2) <> '()' then MovementDesc := MovementDesc + '()';

        ZQueryExecute.Close;
        ZQueryExecute.SQL.Text := Format(cSQLInsert_DescId_Movement_ForMovement, [MovementDesc, MovementDesc]);
        ZQueryExecute.ExecSQL;
      end;

      List.Text := MainForm.LiadScripts(cMovementInsertDesc);
      for I := 0 to List.Count - 1 do if (Trim(List.Strings[I]) <> '') and (Trim(List.Strings[I])[1] <> '#') then
      begin
        MovementDesc := Trim(List.Strings[I]);
        if Copy(MovementDesc, Length(MovementDesc) - 1, 2) <> '()' then MovementDesc := MovementDesc + '()';

        ZQueryExecute.Close;
        ZQueryExecute.SQL.Text := Format(cSQLInsert_DescId_Movement_ForMovement, [MovementDesc, MovementDesc]);
        ZQueryExecute.ExecSQL;
      end;
    finally
      FreeAndNil(List);
    end;

    // ���� ��� ������� ID zc_Object_ReplServer
//    if ReplServerId.Text = '' then
//    begin
//      if (edtSlaveServer.Text = '') or
//         (edtSlaveDatabase.Text = '') or
//         (edtSlaveUser.Text = '') or
//         (edtSlavePassword.Text = '') or
//         (StrToInt(edtSlavePort.Text) = 0) then
//      begin
//        ShowMessage('�� ��� ��������� ��������� ��� ����������� � ���� Slave');
//        Exit;
//      end;
//
//      ZQuery.Close;
//      ZQuery.SQL.Text := cSQLGetReplServer;
//      ZQuery.ParamByName('HOST').AsString := edtSlaveServer.Text;
//      ZQuery.ParamByName('UserName').AsString := edtSlaveUser.Text;
//      ZQuery.ParamByName('Password').AsString := edtSlavePassword.Text;
//      ZQuery.ParamByName('Port').AsString := edtSlavePort.Text;
//      ZQuery.ParamByName('DataBaseName').AsString := edtSlaveDatabase.Text;
//      ZQuery.Open;
//
//      if not ZQuery.Active or ZQuery.IsEmpty then
//      begin
//        if MessageDlg('������� ������ � ����������� "������� ��� ������� ��"?', mtInformation, mbOKCancel, 0) <> mrOk then Exit;
//        S := '';
//        if not InputQuery('���� ������� ��� ������� ��', '��� ������� ��� ������� ��', S) then Exit;
//        if S = '' then Exit;
//
//        ZQuery.Close;
//        ZQuery.SQL.Text := cSQLInsertReplServer;
//        ZQuery.ParamByName('inName').AsString := S;
//        ZQuery.ParamByName('inHost').AsString := edtSlaveServer.Text;
//        ZQuery.ParamByName('inUser').AsString := edtSlaveUser.Text;
//        ZQuery.ParamByName('inPassword').AsString := edtSlavePassword.Text;
//        ZQuery.ParamByName('inPort').AsString := edtSlavePort.Text;
//        ZQuery.ParamByName('inDataBase').AsString := edtSlaveDatabase.Text;
//        ZQuery.Open;
//        nReplServerId := ZQuery.FieldByName('Id').AsInteger;
//
//      end else if ZQuery.Active and not ZQuery.IsEmpty then
//        nReplServerId := ZQuery.FieldByName('Id').AsInteger;
//
//
//    end;

//    if (edtMasterUserUpd.Text = '') and (ReplServerId.Text <> '') then
//    begin
//      if MessageDlg('������� ���� �� ������� ' + edtMasterServer.Text +
//         ' ��� �������� ���������?', mtInformation, mbOKCancel, 0) <> mrOk then Exit;
//
//      S := 'BS_' + ReplServerId.Text;
//      if not InputQuery('������� ���� �� ������� ' + edtMasterServer.Text, '��� ���� ��� �������� ���������', S) then Exit;
//      if S = '' then Exit;
//
//      SaveBranchServiceLog('�������� ���� ��� �������� ��������� �� �������: ' + edtMasterDatabase.Text);
//      ZQuery.Close;
//      ZQuery.SQL.Text := Format(cSQLCreateUser, [S, edtMasterPassword.Text, s, s]);
//      ZQuery.ExecSQL;
//      SaveBranchServiceLog('����: ' + S + ' �� ������� ' + edtMasterServer.Text + ' �������.');
//
//      edtMasterUserUpd.Text := S;
//      edtMasterPasswordUpd.Text := edtMasterPassword.Text;
//    end;

    if not GetInfoSlave(False) then
    begin
      if not GetInfoSlavePostgres then Exit;
      ZQuery.Close;
      ZQuery.SQL.Text := Format(cSQLInfoDB, [edtMasterDatabase.Text]);
      ZQuery.Open;
      if ZQuery.RecordCount = 0 then
      begin
        if MessageDlg('���� ' + edtSlaveDatabase.Text + ' �� ������� ' + edtSlaveServer.Text + #13#13 +
           '�� ������� �������?', mtInformation, mbOKCancel, 0) <> mrOk then Exit;

        SaveBranchServiceLog('�������� ����: ' + edtSlaveDatabase.Text + ' �� ������� ' + edtSlaveServer.Text);
        ZQuery.Close;
        ZQuery.SQL.Text := Format(cSQLCreateDB, [edtSlaveDatabase.Text, edtSlaveUser.Text, cEncodings]);
        ZQuery.ExecSQL;
        SaveBranchServiceLog('����: ' + edtSlaveDatabase.Text + ' �� ������� ' + edtSlaveServer.Text + ' �������.');

      end;
      if not GetInfoSlave(True) then Exit;
    end;

    ZQuery.Close;
    ZQuery.SQL.Text := Format(cSQLInfoDB, [edtSlaveDatabase.Text]);
    ZQuery.Open;
    if not ZQuery.FieldByName('isCatalogReplica').AsBoolean then
    begin
      ZQuery.Close;
      ZQuery.SQL.Text := cSQLSchema;
      ZQuery.ExecSQL;
    end;

    ZQuery.Close;
    ZQuery.SQL.Text := Format(cSQLInfoDB, [edtSlaveDatabase.Text]);
    ZQuery.Open;
    SaveBranchServiceLog('������ �������: ' + ZQuery.FieldByName('Version').AsString);
    SaveBranchServiceLog('���������: ' + ZQuery.FieldByName('Encodings').AsString);

    if cEncodings <> ZQuery.FieldByName('Encodings').AsString then
    begin
      ShowMessage('��������� ��� �� ��������� ���������� �������� ����������.');
      Exit;
    end;

    if not ZQuery.FieldByName('isCatalogReplica').AsBoolean then
    begin
      ShowMessage('�� ������ �� ������� ����� <_replica> ������ ����������.');
      Exit;
    end;

    // ������� EXTENSION dblink
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := cSQLCreatedblink;
    ZQueryExecute.ExecSQL;

    // ������� Domains
    ZQuery.Close;
    ZQuery.SQL.Text := cSQLInfoDomains;
    ZQuery.Open;

    if ZQuery.RecordCount < 4 then
    begin
      ZQueryExecute.Close;
      ZQueryExecute.SQL.Text := LiadScripts(cSQLCreateDomains);
      ZQueryExecute.ExecSQL;
    end;

    if (edtSlaveUserUpd.Text = '') and (ReplServerId.Text <> '') then
    begin
      if MessageDlg('������� ���� �� ������� ' + edtSlaveServer.Text +
         ' ��� �������� ���������?', mtInformation, mbOKCancel, 0) <> mrOk then Exit;

      S := 'BS_' + ReplServerId.Text;
      if not InputQuery('������� ���� �� ������� ' + edtSlaveServer.Text, '��� ���� ��� �������� ���������', S) then Exit;
      if S = '' then Exit;

      SaveBranchServiceLog('�������� ���� ��� �������� ��������� �� �������: ' + edtSlaveDatabase.Text);
      ZQuery.Close;
      ZQuery.SQL.Text := Format(cSQLCreateUser, [S, edtSlavePassword.Text, s, s]);
      ZQuery.ExecSQL;
      SaveBranchServiceLog('����: ' + S + ' �� ������� ' + edtSlaveServer.Text + ' �������.');

      edtSlaveUserUpd.Text := S;
      edtSlavePasswordUpd.Text := edtSlavePassword.Text;
    end;

    // ������� (���������) BranchService_Settings
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLBranchService_Settings);
    ZQueryExecute.ExecSQL;

    // ������� (���������) BranchService_Reserve_Movement
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLBranchService_Reserve_Movement);
    ZQueryExecute.ExecSQL;

    // ������� (���������) BranchService_DescId_Movement
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLBranchService_DescId_Movement);
    ZQueryExecute.ExecSQL;

    // ������� (���������) lpBranchService_Get_MovementId
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPGet_MovementId);
    ZQueryExecute.ExecSQL;

    // ������� ������� � ����������� ����������� � ����
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := Format(LiadScripts(cSQLSPMasterConnect),
        [edtMasterServer.Text, edtMasterDatabase.Text, edtMasterPort.Text, edtMasterUser.Text,
         edtMasterPassword.Text, edtMasterUserUpd.Text, edtMasterPasswordUpd.Text, edtSlaveUserUpd.Text]);
    ZQueryExecute.ExecSQL;

    // ������� (���������) lpBranchService_Get_MovementItemId
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPGet_MovementItemId);
    ZQueryExecute.ExecSQL;

    // ������� (���������) gpBranchService_ReserveAllId
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSReserveAllId);
    ZQueryExecute.ExecSQL;

    // ������� ������� ��� ��������� ���������
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPEqualization_MasterStep);
    ZQueryExecute.ExecSQL;
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPEqualization_UpdateTableData);
    ZQueryExecute.ExecSQL;

    if (nReplServerId <> 0) and (IntToStr(nReplServerId) <> ReplServerId.Text) then
    begin
      ZQuery.Close;
      ZQuery.SQL.Text := cSQLUpdateReplServer;
      ZQuery.ParamByName('ReplServerId').AsInteger := nReplServerId;
      ZQuery.ExecSQL;
    end;

    // �������� ������ ������������ ������
    ZQuery.Close;
    ZQuery.SQL.Text := cSQLProcCount;
    ZQuery.Open;

    // ������� DescId ��� Movement
    if ZQuery.FieldByName('ProcCount').AsInteger > 10 then
    begin
      List := TStringList.Create;
      try
        // ������� ��������
        ZQueryExecute.Close;
        ZQueryExecute.SQL.Text := cSQLClear_DescId_Movement;
        ZQueryExecute.ExecSQL;

        List.Text := MainForm.LiadScripts(cMovementEqualizationDesc);
        for I := 0 to List.Count - 1 do if (Trim(List.Strings[I]) <> '') and (Trim(List.Strings[I])[1] <> '#') then
        begin
          MovementDesc := Trim(List.Strings[I]);
          if Copy(MovementDesc, Length(MovementDesc) - 1, 2) <> '()' then MovementDesc := MovementDesc + '()';

          ZQueryExecute.Close;
          ZQueryExecute.SQL.Text := Format(cSQLInsert_DescId_Movement_Equalization, [MovementDesc]);
          ZQueryExecute.ExecSQL;
        end;

        List.Text := MainForm.LiadScripts(cMovementInsertDesc);
        for I := 0 to List.Count - 1 do if (Trim(List.Strings[I]) <> '') and (Trim(List.Strings[I])[1] <> '#') then
        begin
          MovementDesc := Trim(List.Strings[I]);
          if Copy(MovementDesc, Length(MovementDesc) - 1, 2) <> '()' then MovementDesc := MovementDesc + '()';

          ZQueryExecute.Close;
          ZQueryExecute.SQL.Text := Format(cSQLInsert_DescId_Movement_Insert, [MovementDesc]);
          ZQueryExecute.ExecSQL;
        end;

        // ������� ��������
        ZQueryExecute.Close;
        ZQueryExecute.SQL.Text := cSQLDelete_Table_Equalization;
        ZQueryExecute.ExecSQL;

        List.Text := MainForm.LiadScripts(cTableEqualizationList);
        for I := 0 to List.Count - 1 do if (Trim(List.Strings[I]) <> '') and (Trim(List.Strings[I])[1] <> '#') then
        begin
          ZQueryExecute.Close;
          ZQueryExecute.SQL.Text := Format(cSQLInsert_Table_Equalization, [IntToStr(I), Trim(List.Strings[I])]);
          ZQueryExecute.ExecSQL;
        end;

      finally
        List.Free;
      end;
    end;

    if MessageDlg('��������� ������� ������ � ������� �����������?', mtInformation, mbOKCancel, 0) <> mrOk then Exit;

    // ������� ������� �������� �������
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPNewTable);
    ZQueryExecute.ExecSQL;

    // ������� ��������� ������� �������� ��������� ������ �������
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPBan_Changes_Trigger);
    ZQueryExecute.ExecSQL;

    // �������� ������ ������������ ������
    ZQuery.Close;
    ZQuery.SQL.Text := cSQLTableList;
    ZQuery.Open;

    // ������� ����������� �������
    List := TStringList.Create;
    try
      List.Text := LiadScripts(cTableListAll);
      for I := 0 to List.Count - 1 do
      if (List.Strings[I] <> '') AND (List.Strings[I][1] <> '#') then
      begin
        SaveBranchServiceLog('�������� �������: ' + List.Strings[I]);

        if not ZQuery.Locate('Table_Name', List.Strings[I], [loCaseInsensitive]) then
        begin
          // �������� ��������� �������
          ZQueryExecute.Close;
          ZQueryExecute.SQL.Text := Format(cSQLNewTable, [List.Strings[I]]);
          ZQueryExecute.Open;

          SaveBranchServiceLog('  ' + ZQueryExecute.FieldByName('outText').AsString);

          if ZQueryExecute.FieldByName('outIsError').AsBoolean then
            if MessageDlg(ZQueryExecute.FieldByName('outText').AsString + #13#10#13#10 + '�������� ����������?', mtInformation, mbOKCancel, 0) = mrOk then Exit;
        end else SaveBranchServiceLog('  ��� �������.');

        // ������� ��� �������� ������ �������� ��������� ������
        ZQueryExecute.Close;
        ZQueryExecute.SQL.Text := Format(cSQLCreateTriggerBanChanges, [List.Strings[I], List.Strings[I], List.Strings[I], List.Strings[I]]);
        ZQueryExecute.ExecSQL;

      end;
    finally
      List.Free;
    end;

    // �������� MasterId ��� �����
//    SaveBranchServiceLog('�������� MasterId ��� �����.');
//    ZQueryExecute.Close;
//    ZQueryExecute.SQL.Text := LiadScripts(cSQLAddMasterId);
//    ZQueryExecute.ExecSQL;

  except
    on E: Exception do
      SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TMainForm.CheckDB : boolean;
  var cEncodings : String;
      List : TStringList;
      I : Integer;
      bTfbleErr : Boolean;
begin
  Result := False;
  if not GetInfoMaster then Exit;
  try
    ZQuery.Close;
    ZQuery.SQL.Text := Format(cSQLInfoDB, [edtMasterDatabase.Text]);
    ZQuery.Open;
    SaveBranchServiceLog('������ �������: ' + ZQuery.FieldByName('Version').AsString);
    SaveBranchServiceLog('���������: ' + ZQuery.FieldByName('Encodings').AsString);
    cEncodings := ZQuery.FieldByName('Encodings').AsString;

    if not ZQuery.FieldByName('isCatalogReplica').AsBoolean then
    begin
      ShowMessage('�� ������� �� ������� ����� <_replica> ������ ����������.');
      Exit;
    end;

    if not GetInfoSlave(False) then Exit;

    ZQuery.Close;
    ZQuery.SQL.Text := Format(cSQLInfoDB, [edtSlaveDatabase.Text]);
    ZQuery.Open;
    SaveBranchServiceLog('������ �������: ' + ZQuery.FieldByName('Version').AsString);
    SaveBranchServiceLog('���������: ' + ZQuery.FieldByName('Encodings').AsString);

    if cEncodings <> ZQuery.FieldByName('Encodings').AsString then
    begin
      ShowMessage('��������� ��� �� ��������� ���������� �������� ����������.');
      Exit;
    end;

    // ������� EXTENSION dblink
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := cSQLCreatedblink;
    ZQueryExecute.ExecSQL;

    // �������� Domains
    ZQuery.Close;
    ZQuery.SQL.Text := cSQLInfoDomains;
    ZQuery.Open;

    if ZQuery.RecordCount < 4 then
    begin
      ShowMessage('���������� Domains ������ ������������ ���������� �������� ����������.');
      Exit;
    end;

    // ������� ������� � ����������� ����������� � ����
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := Format(LiadScripts(cSQLSPMasterConnect),
        [edtMasterServer.Text, edtMasterDatabase.Text, edtMasterPort.Text, edtMasterUser.Text,
         edtMasterPassword.Text, edtMasterUserUpd.Text, edtMasterPasswordUpd.Text, edtSlaveUserUpd.Text]);
    ZQueryExecute.ExecSQL;

    // �������� ������ ������������ ������
    ZQuery.Close;
    ZQuery.SQL.Text := cSQLTableList;
    ZQuery.Open;

    // ��������� ������� ������
    SaveBranchServiceLog('�������� ������� ������.');
    bTfbleErr := False;
    List := TStringList.Create;
    try
      List.Text := LiadScripts(cReplicationList);
      for I := 0 to List.Count - 1 do
      if (List.Strings[I] <> '') and (List.Strings[I][1] <> '#') then
      begin
        if not ZQuery.Locate('Table_Name', SplitString(List.Strings[I], ';')[0], [loCaseInsensitive]) then
        begin
          SaveBranchServiceLog('������� ' + SplitString(List.Strings[I], ';')[0] + ' �� �������.');
          bTfbleErr := bTfbleErr or True;
        end;
      end;
    finally
      List.Free;
    end;

    if bTfbleErr then
    begin
      ShowMessage('�� ��� ������� �� Slave �������.');
      Exit;
    end;

    // �������� MasterId ��� �����
//    SaveBranchServiceLog('�������� MasterId ��� �����.');
//    ZQueryExecute.Close;
//    ZQueryExecute.SQL.Text := LiadScripts(cSQLAddMasterId);
//    ZQueryExecute.ExecSQL;

    Result := True;
  except
    on E: Exception do
      SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;

end;

procedure TMainForm.cxPageControlPageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  if NewPage = cxTabSheetDocSettings then
  begin
    ZQueryDescIdMovement.Close;
    if GetInfoSlave(False) then ZQueryDescIdMovement.Open;
  end;
end;

procedure TMainForm.deDateSendExit(Sender: TObject);
begin
  if deDateSend.EditValue <> FDateSend then
  begin
    if not CheckDB then Exit;
    try

       // ������� (���������) BranchService_Settings
       ZQueryExecute.Close;
       ZQueryExecute.SQL.Text := LiadScripts(cSQLBranchService_Settings);
       ZQueryExecute.ExecSQL;

       ZQuery.Close;
       ZQuery.SQL.Text := cSQLUpdateDateSend;
       ZQuery.ParamByName('Date').Value := deDateSend.EditValue;
       ZQuery.ExecSQL;

       ReadInfo;

     except
      on E: Exception do
        SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
    end;
  end;
end;

procedure TMainForm.deDateSnapshotExit(Sender: TObject);
begin
  if deDateSnapshot.EditValue <> FDateSnapshot then
  begin
    if not CheckDB then Exit;
    try

       // ������� (���������) BranchService_Settings
       ZQueryExecute.Close;
       ZQueryExecute.SQL.Text := LiadScripts(cSQLBranchService_Settings);
       ZQueryExecute.ExecSQL;

       ZQuery.Close;
       ZQuery.SQL.Text := cSQLUpdateDateSnapshot;
       ZQuery.ParamByName('Date').Value := deDateSnapshot.EditValue;
       ZQuery.ExecSQL;

       ReadInfo;

     except
      on E: Exception do
        SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
    end;
  end;
end;

procedure TMainForm.edOffsetTimeEndExit(Sender: TObject);
begin
  if edOffsetTimeEnd.Value <> FOffsetTimeEnd then
  begin
    if not CheckDB then Exit;
    try
       try
         if Round(edOffsetTimeEnd.Value) <= 0 then
         begin
           ShowMessage('������ ����� �� ����, ��� ������ ���� ������ ��� ����� 0.');
           Exit;
         end;

         // ������� (���������) BranchService_Settings
         ZQueryExecute.Close;
         ZQueryExecute.SQL.Text := LiadScripts(cSQLBranchService_Settings);
         ZQueryExecute.ExecSQL;

         ZQuery.Close;
         ZQuery.SQL.Text := cSQLUpdateOffsetTimeEnd;
         ZQuery.ParamByName('OffsetTimeEnd').Value := Round(edOffsetTimeEnd.Value);
         ZQuery.ExecSQL;
       finally
         ReadInfo;
       end;
     except
      on E: Exception do
        SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
    end;
  end;
end;

procedure TMainForm.edRecordStepExit(Sender: TObject);
begin
  if edRecordStep.Value <> FRecordStep then
  begin
    if not CheckDB then Exit;
    try
       try
         if Round(edRecordStep.Value) < 1000 then
         begin
           ShowMessage('������������ ������� �� 1 ������ ����� 1000 ������.');
           Exit;
         end;

         // ������� (���������) BranchService_Settings
         ZQueryExecute.Close;
         ZQueryExecute.SQL.Text := LiadScripts(cSQLBranchService_Settings);
         ZQueryExecute.ExecSQL;

         ZQuery.Close;
         ZQuery.SQL.Text := cSQLUpdateRecordStep;
         ZQuery.ParamByName('RecordStep').Value := Round(edRecordStep.Value);
         ZQuery.ExecSQL;
       finally
         ReadInfo;
       end;
     except
      on E: Exception do
        SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
    end;
  end;
end;

procedure TMainForm.edTimerIntervalExit(Sender: TObject);
begin
  if TSettings.TimerInterval <> Round(edTimerInterval.Value) then
  begin
    if Round(edTimerInterval.Value) > 0 then
      TSettings.TimerInterval := Round(edTimerInterval.Value)
    else edTimerInterval.Value := TSettings.TimerInterval;
  end;
end;

procedure TMainForm.deDateEqualizationExit(Sender: TObject);
begin
  if deDateEqualization.EditValue <> FDateEqualization then
  begin
    if not CheckDB then Exit;
    try

       // ������� (���������) BranchService_Settings
       ZQueryExecute.Close;
       ZQueryExecute.SQL.Text := LiadScripts(cSQLBranchService_Settings);
       ZQueryExecute.ExecSQL;

       ZQuery.Close;
       ZQuery.SQL.Text := cSQLUpdateDateEqualization;
       ZQuery.ParamByName('Date').Value := deDateEqualization.EditValue;
       ZQuery.ExecSQL;

       ReadInfo;
     except
      on E: Exception do
        SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
    end;
  end;
end;

procedure TMainForm.btnEqualizationAllClick(Sender: TObject);
begin
  EqualizationAll(3);
end;

procedure TMainForm.btnEqualizationBreakClick(Sender: TObject);
begin
  if Assigned(EqualizationThread) then
  begin
    if EqualizationThread.Terminated then Exit;
    if MessageDlg('������������ �����������.'#13#10#13#10'��������?', mtInformation, mbOKCancel, 0) = mrOk then
    begin
      EqualizationThread.Error := '�������� �������������.';
      EqualizationThread.Terminate;
      FTimerEqualization := False;
    end;
  end else
  begin
    if not FCloseFoeFinish then
    begin
      ShowMessage('����� ����������� �� �������.');
      Exit;
    end else Close;
  end;
end;

procedure TMainForm.EqualizationAll(AMode: Integer);
begin

  if Assigned(EqualizationThread) then
  begin
    ShowMessage('����� ����������� ��� �������.');
    Exit;
  end;

  try

    EqualizationCDS.DisableControls;
    try
      EqualizationCDS.First;
      while not EqualizationCDS.Eof do
      begin
        EqualizationCDS.Edit;
        EqualizationCDS.FieldByName('CounutEqualizationLast').AsInteger := 0;
        EqualizationCDS.Post;
        EqualizationCDS.Next;
      end;
    finally
      EqualizationCDS.First;
      EqualizationCDS.EnableControls
    end;

    mmoScriptLogEqualization.Text := '';
    lblActionTake.Caption := '';
    pnlInfoEqualization.Visible := True;
    Application.ProcessMessages;
    SaveBranchServiceLog('������ ����� ��� ��������� ���������.');
    try

      EqualizationThread := TEqualizationThread.Create(True);
      EqualizationThread.Mode := AMode;
      EqualizationThread.FreeOnTerminate:=True;
      EqualizationThread.HostName := MainForm.edtSlaveServer.Text;
      EqualizationThread.Database := MainForm.edtSlaveDatabase.Text;
      EqualizationThread.User := MainForm.edtSlaveUserUpd.Text;
      EqualizationThread.Password := MainForm.edtSlavePasswordUpd.Text;
      EqualizationThread.Port := StrToInt(MainForm.edtSlavePort.Text);
      EqualizationThread.LibraryLocation := MainForm.ZConnection.LibraryLocation;
      if deDateEqualization.EditValue <> Null then
        EqualizationThread.StartDate := deDateEqualization.Date
      else if deDateSnapshot.EditValue <> Null then
        EqualizationThread.StartDate := deDateSnapshot.Date;

      EqualizationThread.OnFinish := EqualizationThreadFinish;
      EqualizationThread.OnMessage := EqualizationThreadMessage;
      EqualizationThread.OnAddLog := EqualizationThreadAddLog;
      EqualizationThread.OnProgress := EqualizationThreadProgress;

      EqualizationThread.Resume;

    except
      on E: Exception do
        SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
    end;
  finally
  end;
end;

procedure TMainForm.btnEqualizationLoadClick(Sender: TObject);
begin
  EqualizationAll(2);
end;

procedure TMainForm.btnEqualizationSendClick(Sender: TObject);
begin
 EqualizationAll(1);
end;

procedure TMainForm.btnFunctionClick(Sender: TObject);
begin

  if not CheckDB then Exit;
  try

    // ������� ������� ��� ������� ���������� �������
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPCalcFunctionMaster);
    ZQueryExecute.ExecSQL;

    // ������� ������� ��� �������� �������
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPReplication_Function);
    ZQueryExecute.ExecSQL;

    SaveBranchServiceLog('������ ������ �������� �������.');
    with TThreadFunctionForm.Create(Nil) do
    begin
       try
         ShowModal;
         if Error <> '' then
         begin
           SaveBranchServiceLog('������ ���������� �������� �������:'#13#10 + Error, True);
         end else
         begin
           SaveBranchServiceLog('������� ������� ��������.', True);
         end;
       finally
         Free;
       end;
    end;
  except
    on E: Exception do
      SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TMainForm.btnIndexClick(Sender: TObject);
begin
  if not CheckDB then Exit;
  try
    // ������� ������� ��� �������� ��������
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPReplication_Index);
    ZQueryExecute.ExecSQL;

    SaveBranchServiceLog('������ ������ �������� ��������.');
    with TThreadIndexForm.Create(Nil) do
    begin
       try
         ShowModal;
         if Error <> '' then
         begin
           SaveBranchServiceLog('������ ���������� �������� ��������:'#13#10 + Error, True);
         end else
         begin
           SaveBranchServiceLog('������� �������� ��������.', True);
         end;
       finally
         Free;
       end;
    end;
  except
    on E: Exception do
      SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TMainForm.btnlInfoEqualizationViewClick(Sender: TObject);
begin
  pnlInfoEqualization.Visible := not pnlInfoEqualization.Visible;
end;

procedure TMainForm.btnReserveIdClick(Sender: TObject);
begin
  ZQueryDescIdMovement.Close;
  if GetInfoSlave(False) then
  try

    // ������� (���������) gpBranchService_ReserveAllId
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSReserveAllId);
    ZQueryExecute.ExecSQL;

    SaveBranchServiceLog('��������� �������������� Id � ������� ����������.');

      // ��������� �������������� Id � ������� ����������
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := cSQLReserveAllId;
    ZQueryExecute.Open;

    if ZQueryExecute.FieldByName('ErrorText').AsString = '' then
    begin
      SaveBranchServiceLog('�������������� Id � ������� ����������. ���������� - ' +
         ZQueryExecute.FieldByName('MovementCount').AsString + '. ����� ���������� ' +
         ZQueryExecute.FieldByName('MovementItemCount').AsString, True);
    end else
    begin
      SaveBranchServiceLog('������� ����� �������� � ��������. ���������� - ' +
         ZQueryExecute.FieldByName('MovementCount').AsString + '. ����� ���������� ' +
         ZQueryExecute.FieldByName('MovementItemCount').AsString + '.' + #13#10 +
         ZQueryExecute.FieldByName('ErrorText').AsString, True);
    end;

  finally
    ZQueryDescIdMovement.Open;
  end;
end;

procedure TMainForm.btnScriptPathClick(Sender: TObject);
var
  sScriptFolder, sInitPath: string;
begin
  sInitPath := TSettings.ScriptPath;
  if not TDirectory.Exists(sInitPath) then
    sInitPath := ExtractFilePath(ParamStr(0));

  {$WARNINGS OFF}
  with opndlgMain do
  begin
    Title := '�������� ����� �� ���������';
    Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
    OkButtonLabel := '�������';
    DefaultFolder := sInitPath;
    if Execute then
    begin
      sScriptFolder        := FileName;
      edtScriptPath.Text   := sScriptFolder;
      TSettings.ScriptPath := sScriptFolder;
    end;
  end;
  {$WARNINGS ON}

//  if Length(sScriptFolder) > 0 then
//  begin
//    FreeAndNil(FScriptFiles);
//    FScriptFiles := TScriptFiles.Create(sScriptFolder, LogApplyScript);
//  end;
end;

procedure TMainForm.btnSequenceClick(Sender: TObject);
begin

  if not CheckDB then Exit;
  try

    // ������� ������� ��� �������� �������������������
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPReplication_Sequence);
    ZQueryExecute.ExecSQL;

    SaveBranchServiceLog('������ �������� �������������������.');

    // ������� ������� ��� �������� �����
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := cSQLReplication_Sequence;
    ZQueryExecute.Open;

    if ZQueryExecute.FieldByName('ErrorText').AsString = '' then
    begin
      SaveBranchServiceLog('������� ������������������� ��������. ������� - ' + ZQueryExecute.FieldByName('SequenceCountOk').AsString + ' �������������������.', True);
    end else
    begin
      SaveBranchServiceLog('������� ������������������� �������� � ��������. ������� - ' +
        ZQueryExecute.FieldByName('SequenceCountOk').AsString + ' �������������������.'#13#10 +
        ZQueryExecute.FieldByName('ErrorText').AsString, True);
    end;

  except
    on E: Exception do
      SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;

end;

procedure TMainForm.btnSnapshotClick(Sender: TObject);
begin

  if not CheckDB then Exit;
  try

    // ������� ������� ��� ������� ������������ ������
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPCalculateTableMaster);
    ZQueryExecute.ExecSQL;

    // ������� ������� ��� ���������� �������
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPReplication_Table);
    ZQueryExecute.ExecSQL;
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPReplication_Table_IdList);
    ZQueryExecute.ExecSQL;
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPReplication_Table_Movement);
    ZQueryExecute.ExecSQL;
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPReplication_Table_Simple);
    ZQueryExecute.ExecSQL;

    ZQuery.Close;
    ZQuery.SQL.Text := cSQLOpenBranchService_Settings;
    ZQuery.Open;

    // ��������� ���� ��������
    if ZQuery.FieldByName('DateSnapshot').IsNull then
    begin
      ZQuery.Close;
      ZQuery.SQL.Text := cSQLUpdateDateSnapshot;
      ZQuery.ParamByName('Date').AsDateTime := Date;
      ZQuery.ExecSQL;
    end;
    ZQuery.Close;

    SaveBranchServiceLog('������ ������� �������� ������ (�������).');
    with TThreadSnapshotForm.Create(Nil) do
    begin
       try
         ShowModal;
         if Error <> '' then
         begin
           SaveBranchServiceLog('������ ���������� ������� ������ (�������): '#13#10 + Error, True);
         end else
         begin
           SaveBranchServiceLog('������� ������ (�������) ��������.', True);
         end;
       finally
         Free;
       end;
    end;
  except
    on E: Exception do
      SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TMainForm.btnUpdateDataLogClick(Sender: TObject);
begin
  if not CheckDB then Exit;
  try
    // ������� ������� ��� ����������� ���������
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPReplication_UpdateDataLog);
    ZQueryExecute.ExecSQL;

    SaveBranchServiceLog('���������� ������� ��� ����������� ���������.');

    // ��������� ������� �����
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := cSQLEqualization_UpdateDataLog;
    ZQueryExecute.Open;

    if ZQueryExecute.FieldByName('ErrorText').AsString = '' then
    begin
      SaveBranchServiceLog(ZQueryExecute.FieldByName('OutText').AsString, False);
      ShowMessage('��������� ���������� ������� ��� ����������� ���������.');
    end else
    begin
      SaveBranchServiceLog('���������� ������� ��� ����������� ��������� �������� � ��������:'#13#10 +
        ZQueryExecute.FieldByName('ErrorText').AsString, True);
    end;
  except
    on E: Exception do
      SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TMainForm.btnViewClick(Sender: TObject);
begin

  if not CheckDB then Exit;
  try

    // ������� ������� ��� ������� ���������� �����
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPCalcViewMaster);
    ZQueryExecute.ExecSQL;

    // ������� ������� ��� �������� �����
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := LiadScripts(cSQLSPReplication_View);
    ZQueryExecute.ExecSQL;

    SaveBranchServiceLog('������ �������� �����.');

    // ��������� ������� �����
    ZQueryExecute.Close;
    ZQueryExecute.SQL.Text := cSQLReplication_View;
    ZQueryExecute.Open;

    if ZQueryExecute.FieldByName('ErrorText').AsString = '' then
    begin
      SaveBranchServiceLog('������� ����� ��������. ������� - ' + ZQueryExecute.FieldByName('ViewCountOk').AsString + ' �����.', True);
    end else
    begin
      SaveBranchServiceLog('������� ����� �������� � ��������. ������� - ' +
        ZQueryExecute.FieldByName('ViewCountOk').AsString +
        ' �� ' + ZQueryExecute.FieldByName('ViewCount').AsString + ' �����.'#13#10 +
        ZQueryExecute.FieldByName('ErrorText').AsString, True);
    end;

  except
    on E: Exception do
      SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(EqualizationThread) then
  begin
    ShowMessage('��������� ���������� �����������.');
    Action := caNone;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  mmoScriptLog.Lines.Clear;
  mmoScriptLogEqualization.Lines.Clear;
  EqualizationThread := Nil;
  FTimerEqualization := False;
  FCloseFoeFinish := False;
  SaveBranchServiceLog('������ ��������� - BranchService');

  ReadSettings;

  edtScriptPath.Text := TSettings.ScriptPath;
  pnlInfoEqualization.Visible := False;

  ZConnection.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  if (edtSlaveServer.Text = '') or (edtSlaveServer.Text = '') then
  begin
    cxPageControl.Properties.ActivePage := cxTabSheetSnapshot;
    Exit;
  end;

  if FileExists(ExtractFilePath(ParamStr(0)) + '\BranchService.db') then
    EqualizationCDS.LoadFromFile(ExtractFilePath(ParamStr(0)) + '\BranchService.db');

  ReadInfo;

  if (ParamCount >= 1) and (CompareText(ParamStr(1), 'equalization') = 0) then
  begin
    FTimerEqualization := True;
    FCloseFoeFinish := True;
    cxTabSheetDocSettings.TabVisible := False;
    cxTabSheetSnapshot.TabVisible := False;

    btnEqualizationAll.Enabled := False;
    btnEqualizationLoad.Enabled := False;
    btnEqualizationSend.Enabled := False;
    btnlInfoEqualizationView.Enabled := False;

    deDateSnapshot.Enabled := False;
    deDateSend.Enabled := False;
    deDateEqualization.Enabled := False;

    TimerEqualization.Enabled := True;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  WriteSettings;
  SaveBranchServiceLog('�������� ��������� - BranchService');
end;

procedure TMainForm.ReadSettings;
begin
  edtMasterServer.Text      := TSettings.MasterServer;
  edtMasterDatabase.Text    := TSettings.MasterDatabase;
  edtMasterUser.Text        := TSettings.MasterUser;
  edtMasterPassword.Text    := TSettings.MasterPassword;
  edtMasterPort.Text        := IntToStr(TSettings.MasterPort);
  edtMasterUserUpd.Text     := TSettings.MasterUserUpd;
  edtMasterPasswordUpd.Text := TSettings.MasterPasswordUpd;

  edtSlaveServer.Text       := TSettings.SlaveServer;
  edtSlaveDatabase.Text     := TSettings.SlaveDatabase;
  edtSlaveUser.Text         := TSettings.SlaveUser;
  edtSlavePassword.Text     := TSettings.SlavePassword;
  edtSlavePort.Text         := IntToStr(TSettings.SlavePort);
  edtSlaveUserUpd.Text      := TSettings.SlaveUserUpd;
  edtSlavePasswordUpd.Text  := TSettings.SlavePasswordUpd;

  edTimerInterval.Value     := TSettings.TimerInterval;
end;

procedure TMainForm.ReadInfo;
begin
  try
    try
      if GetInfoSlave(False) then
      begin

        // ������� (���������) BranchService_Settings
        if FileExists(cSQLBranchService_Settings) then
        begin
          ZQueryExecute.Close;
          ZQueryExecute.SQL.Text := LiadScripts(cSQLBranchService_Settings);
          ZQueryExecute.ExecSQL;
        end;

        try
          ZQuery.Close;
          ZQuery.SQL.Text := cSQLOpenBranchService_Settings;
          ZQuery.Open;
        except
         ZQuery.Close;
        end;

        if not ZQuery.Active then
        begin
          ZQuery.Close;
          ZQuery.SQL.Text := cSQLOpenBranchService_SettingsSmoll;
          ZQuery.Open;
        end;

        if not ZQuery.FieldByName('ReplServerId').IsNull then
          ReplServerId.Text :=  ZQuery.FieldByName('ReplServerId').AsString;

        if Assigned(ZQuery.FindField('ReplServerCode')) and
           not ZQuery.FieldByName('ReplServerCode').IsNull then
          ReplServerCode.Text :=  ZQuery.FieldByName('ReplServerCode').AsString;

        if Assigned(ZQuery.FindField('ReplServerName')) and
           not ZQuery.FieldByName('ReplServerName').IsNull then
          ReplServerName.Text :=  ZQuery.FieldByName('ReplServerName').AsString;

        FDateSnapshot := ZQuery.FieldByName('DateSnapshot').AsVariant;
        deDateSnapshot.EditValue :=  ZQuery.FieldByName('DateSnapshot').AsVariant;

        FDateSend := ZQuery.FieldByName('DateSend').AsVariant;
        deDateSend.EditValue :=  ZQuery.FieldByName('DateSend').AsVariant;

        FDateEqualization := ZQuery.FieldByName('DateEqualization').AsVariant;
        deDateEqualization.EditValue :=  ZQuery.FieldByName('DateEqualization').AsVariant;

        FRecordStep := ZQuery.FieldByName('RecordStep').AsInteger;
        edRecordStep.Value := ZQuery.FieldByName('RecordStep').AsInteger;

        FOffsetTimeEnd := ZQuery.FieldByName('OffsetTimeEnd').AsInteger;
        edOffsetTimeEnd.Value := ZQuery.FieldByName('OffsetTimeEnd').AsInteger;

        cxPageControl.Properties.ActivePage := cxTabSheetUpdate;
      end else cxPageControl.Properties.ActivePage := cxTabSheetSnapshot;


    except
      on E: Exception do
        begin
          SaveBranchServiceLog(Format(cExceptionMsg, [E.ClassName, E.Message]));
          cxPageControl.Properties.ActivePage := cxTabSheetSnapshot;
        end;
    end;
  finally

  end;
end;

procedure TMainForm.WriteSettings;
begin
  TSettings.MasterServer      := edtMasterServer.Text;
  TSettings.MasterDatabase    := edtMasterDatabase.Text;
  TSettings.MasterUser        := edtMasterUser.Text;
  TSettings.MasterPassword    := edtMasterPassword.Text;
  TSettings.MasterPort        := StrToIntDef(edtMasterPort.Text, TSettings.DefaultPort);
  TSettings.MasterUserUpd     := edtMasterUserUpd.Text;
  TSettings.MasterPasswordUpd := edtMasterPasswordUpd.Text;

  TSettings.SlaveServer       := edtSlaveServer.Text;
  TSettings.SlaveDatabase     := edtSlaveDatabase.Text;
  TSettings.SlaveUser         := edtSlaveUser.Text;
  TSettings.SlavePassword     := edtSlavePassword.Text;
  TSettings.SlavePort         := StrToIntDef(edtSlavePort.Text, TSettings.DefaultPort);
  TSettings.SlaveUserUpd      := edtSlaveUserUpd.Text;
  TSettings.SlavePasswordUpd  := edtSlavePasswordUpd.Text;

end;

procedure TMainForm.EqualizationThreadFinish(AError : String);
begin
  TThread.CreateAnonymousThread(procedure
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          EqualizationThread := Nil;
          lblActionTake.Caption := '�������� �������';
          pbEqualization.Position := 0;
          if AError <> '' then
          begin
            SaveBranchEqualizationeLog('������ ���������� ����������� ������:'#13#10 + AError);
          end else
          begin
            SaveBranchEqualizationeLog('����������� ������ ���������.');
          end;

          ReadInfo;

          if FTimerEqualization then
          begin
            if edTimerInterval.Value > 0 then
              TimerEqualization.Interval := Round(edTimerInterval.Value * 1000)
            else TimerEqualization.Interval := 3 * 60 * 1000;
            TimerEqualization.Enabled := True;
            lblActionTake.Caption := '��������� ������:' +
              FormatDateTime('HH:NN:SS', IncSecond(Now, TimerEqualization.Interval div 1000));
          end else if FCloseFoeFinish then Close;
        end)
    end).Start;
end;

procedure TMainForm.EqualizationThreadMessage(AText: string);
begin
  lblActionTake.Caption := AText;
  MainForm.SaveBranchEqualizationeLog(AText);
end;

procedure TMainForm.EqualizationThreadAddLog;
begin
  MainForm.SaveBranchEqualizationeLog('��������� ���������� �������������:');

  EqualizationCDS.DisableControls;
  try
    EqualizationCDS.First;
    while not EqualizationCDS.Eof do
    begin
      if EqualizationCDS.FieldByName('CounutEqualizationLast').AsInteger > 0 then
        MainForm.SaveBranchEqualizationeLog(EqualizationCDS.FieldByName('TableName').AsString + ' - ' +
                                            EqualizationCDS.FieldByName('CounutEqualizationLast').AsString);

      EqualizationCDS.Next;
    end;
  finally
    EqualizationCDS.First;
    EqualizationCDS.EnableControls
  end;
  MainForm.SaveBranchEqualizationeLog('����� ����������: ' +
    IntToStr(EqualizationThread.TimeSec div 60) + ' ���. ' + IntToStr(EqualizationThread.TimeSec mod 60) + ' ���. ');

end;

procedure TMainForm.EqualizationThreadProgress;
begin

  if not Assigned(EqualizationThread) then Exit;
  //lblActionTake.Caption := AText;

  pbEqualization.Properties.Max := EqualizationThread.Max;
  pbEqualization.Position := EqualizationThread.Progress;

  if Assigned(EqualizationThread.DataSet) and EqualizationThread.DataSet.Active then
  begin
    EqualizationCDS.DisableControls;
    try
      EqualizationThread.DataSet.First;
      while not EqualizationThread.DataSet.Eof do
      begin
        if (EqualizationThread.DataSet.FieldByName('TableName').AsString <> '') and (EqualizationThread.DataSet.FieldByName('RowUpdate').AsInteger > 0) then
        begin
          if EqualizationCDS.Locate('TableName', EqualizationThread.DataSet.FieldByName('TableName').AsString, [loCaseInsensitive]) then
          begin
            EqualizationCDS.Edit;
            EqualizationCDS.FieldByName('CounutEqualizationLast').AsInteger := EqualizationCDS.FieldByName('CounutEqualizationLast').AsInteger + EqualizationThread.DataSet.FieldByName('RowUpdate').AsInteger;
            EqualizationCDS.FieldByName('CounutEqualization').AsInteger := EqualizationCDS.FieldByName('CounutEqualization').AsInteger + EqualizationThread.DataSet.FieldByName('RowUpdate').AsInteger;
            EqualizationCDS.Post;
          end else
          begin
            EqualizationCDS.Append;
            EqualizationCDS.FieldByName('TableName').AsString := EqualizationThread.DataSet.FieldByName('TableName').AsString;
            EqualizationCDS.FieldByName('CounutEqualizationLast').AsInteger := EqualizationThread.DataSet.FieldByName('RowUpdate').AsInteger;
            EqualizationCDS.FieldByName('CounutEqualization').AsInteger := EqualizationThread.DataSet.FieldByName('RowUpdate').AsInteger;
            EqualizationCDS.Post;
          end;
        end;
        EqualizationThread.DataSet.Next;
      end;
    finally
      EqualizationCDS.SaveToFile(ExtractFilePath(ParamStr(0)) + '\BranchService.db', dfXML);
      EqualizationCDS.First;
      EqualizationCDS.EnableControls;
    end;
  end;
end;

end.
