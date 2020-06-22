unit Main;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Samples.Spin,
  Vcl.Grids,
  Vcl.DBGrids,
  Winapi.Messages,
  UConstants,
  ULog;

type
  TMainForm = class(TForm)
    pgcMain: TPageControl;
    tsLog: TTabSheet;
    cbRecCount: TCheckBox;
    EditRecCount: TEdit;
    cbDebug: TCheckBox;
    LogMemo: TMemo;
    btnObject_SKU_to_wms: TButton;
    btnObject_SKU_CODE_to_wms: TButton;
    btnObject_SKU_GROUP_DEPENDS_to_wmsClick: TButton;
    btnObject_CLIENT_to_wms: TButton;
    btnObject_PACK_to_wms: TButton;
    btnObject_USER_to_wms: TButton;
    btnMovement_INCOMING_to_wms: TButton;
    btnMovement_ASN_LOAD_to_wms: TButton;
    btnMovement_ORDER_to_wms: TButton;
    btnStartTimer: TButton;
    btnEndTimer: TButton;
    btnFDC_alan: TButton;
    btnFDC_wms: TButton;
    Timer: TTimer;
    tsSettings: TTabSheet;
    mmoMessage: TMemo;
    lbWMSDatabase: TLabel;
    edtWMSDatabase: TEdit;
    lbAlanServer: TLabel;
    edtAlanServer: TEdit;
    seTimerInterval: TSpinEdit;
    lbTimerInterval: TLabel;
    lbIntervalSec: TLabel;
    btnApplyDefSettings: TButton;
    lbFontSize: TLabel;
    seFontSize: TSpinEdit;
    tsErrors: TTabSheet;
    pnlWMS: TPanel;
    splHorz: TSplitter;
    pnlAlan: TPanel;
    pnlWmsTop: TPanel;
    pnlAlanTop: TPanel;
    grdWMS: TDBGrid;
    grdAlan: TDBGrid;
    btnUpdateWMS: TButton;
    btnUpdateAlan: TButton;
    lbDateStart: TLabel;
    lbEndDate: TLabel;
    dtpStartDateWMS: TDateTimePicker;
    dtpEndDateWMS: TDateTimePicker;
    lbStartDateAlan: TLabel;
    lbEndDateAlan: TLabel;
    dtpStartDateAlan: TDateTimePicker;
    dtpEndDateAlan: TDateTimePicker;
    btnImpOrderStatusChanged: TButton;
    btnImpReceivingResult: TButton;
    lbWMSShowMode: TLabel;
    cbbWMSShowMode: TComboBox;
    tsWmsMessage: TTabSheet;
    pnlWmsMessage: TPanel;
    pnlWmstMessageTop: TPanel;
    lbWmsMsgStart: TLabel;
    lbWmsMsgEnd: TLabel;
    Label3: TLabel;
    btnUpdateWmsMessage: TButton;
    dtpWmsMsgStart: TDateTimePicker;
    dtpWmsMsgEnd: TDateTimePicker;
    cbbWmsMessageMode: TComboBox;
    grdWmsMessage: TDBGrid;
    grpPackets: TGroupBox;
    chkOrderStatusChanged: TCheckBox;
    chkReceivingResult: TCheckBox;
    chkUseLog: TCheckBox;
    lbStart_OrderStatusChanged: TLabel;
    lbEnd_OrderStatusChanged: TLabel;
    lbStart_ReceivingResult: TLabel;
    lbEnd_ReceivingResult: TLabel;
    lbElapsed_OrderStatusChanged: TLabel;
    lbElapsed_ReceivingResult: TLabel;
    procedure btnFDC_wmsClick(Sender: TObject);
    procedure btnFDC_alanClick(Sender: TObject);
    procedure btnObject_SKU_to_wmsClick(Sender: TObject);
    procedure btnObject_SKU_GROUP_DEPENDS_to_wmsClickClick(Sender: TObject);
    procedure btnObject_CLIENT_to_wmsClick(Sender: TObject);
    procedure btnObject_USER_to_wmsClick(Sender: TObject);
    procedure btnObject_PACK_to_wmsClick(Sender: TObject);
    procedure btnObject_SKU_CODE_to_wmsClick(Sender: TObject);
    procedure btnMovement_INCOMING_to_wmsClick(Sender: TObject);
    procedure btnMovement_ASN_LOAD_to_wmsClick(Sender: TObject);
    procedure btnMovement_ORDER_to_wmsClick(Sender: TObject);
    procedure btnStartTimerClick(Sender: TObject);
    procedure btnEndTimerClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure seTimerIntervalChange(Sender: TObject);
    procedure edtWMSDatabaseExit(Sender: TObject);
    procedure edtAlanServerExit(Sender: TObject);
    procedure btnApplyDefSettingsClick(Sender: TObject);
    procedure seFontSizeChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure pgcMainChange(Sender: TObject);
    procedure btnUpdateWMSClick(Sender: TObject);
    procedure btnUpdateAlanClick(Sender: TObject);
    procedure dtpStartDateWMSChange(Sender: TObject);
    procedure dtpEndDateWMSChange(Sender: TObject);
    procedure dtpStartDateAlanChange(Sender: TObject);
    procedure dtpEndDateAlanChange(Sender: TObject);
    procedure btnImpOrderStatusChangedClick(Sender: TObject);
    procedure btnImpReceivingResultClick(Sender: TObject);
    procedure cbbWMSShowModeChange(Sender: TObject);
    procedure btnUpdateWmsMessageClick(Sender: TObject);
    procedure cbbWmsMessageModeChange(Sender: TObject);
    procedure dtpWmsMsgStartChange(Sender: TObject);
    procedure dtpWmsMsgEndChange(Sender: TObject);
  private
    FLog: TLog;
    FStopTimer: Boolean;
    FStartOrderStatusChanged: TDateTime;
    FStartReceivingResult: TDateTime;
  private
    procedure AddToLog_Timer(LogType, S: string);
    procedure myShowSql;
    procedure myLogSql;
    procedure myShowMsg(const AMsg: string);
    procedure MyDelay(mySec: Integer);
    procedure AdjustColumnWidth(AGrid: TDBGrid);
    procedure UpdateWMSGrid(const ANeedRebuildColumns: Boolean = False);
    procedure UpdateAlanGrid(const ANeedRebuildColumns: Boolean = False);
    procedure UpdateWmsMsgGrid(const ANeedRebuildColumns: Boolean = False);
    procedure WMNeedUpdateGrids(var AMessage: TMessage); message WM_NEED_UPDATE_GRIDS;
    procedure OnTerminateOrderStatusChanged(Sender: TObject);
    procedure OnTerminateReceivingResult(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Winapi.Windows,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  UDefinitions,
  UData,
  UCommon,
  USettings,
  UQryThread;

type
  THackedGrid = class(TCustomGrid);

const
  cLogFileName = 'Messages.log';
  cEndPacket = 'завершено  %s';
  cStartPacket = 'начало выполнения  %s';
  cElapsedPacket = 'выполнено за  %s';

procedure TMainForm.MyDelay(mySec: Integer);
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  calcSec, calcSec2: LongInt;
begin
  Present := Now;
  DecodeDate(Present, Year, Month, Day);
  DecodeTime(Present, Hour, Min, Sec, MSec);
     //calcSec:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
     //calcSec2:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
  calcSec := Day * 24 * 60 * 60 * 1000 + Hour * 60 * 60 * 1000 + Min * 60 * 1000 + Sec * 1000 + MSec;
  calcSec2 := Day * 24 * 60 * 60 * 1000 + Hour * 60 * 60 * 1000 + Min * 60 * 1000 + Sec * 1000 + MSec;
  while abs(calcSec - calcSec2) < mySec do
  begin
    Application.ProcessMessages;
    Application.ProcessMessages;
    Application.ProcessMessages;
    Application.ProcessMessages;
    Present := Now;
    DecodeDate(Present, Year, Month, Day);
    DecodeTime(Present, Hour, Min, Sec, MSec);
          //calcSec2:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
    calcSec2 := Day * 24 * 60 * 60 * 1000 + Hour * 60 * 60 * 1000 + Min * 60 * 1000 + Sec * 1000 + MSec;
    Application.ProcessMessages;
    Application.ProcessMessages;
    Application.ProcessMessages;
  end;
end;

procedure TMainForm.AddToLog_Timer(LogType, S: string);
var
  LogFileName, LogStr: string;
begin
  Application.ProcessMessages;

  LogStr := FormatDateTime(cDateTimeStr, Now) + ' ' + S;
  LogMemo.Lines.Add(LogStr);

  LogFileName := LogType + '\' + FormatDateTime('yyyy-mm-dd', Date) + '.log';
//  FLog.Write(LogFileName, DateTimeToStr(Now) + ' : ');  //<-- дата вставляется внутри FLog.Write
  FLog.Write(LogFileName, S);
  FLog.Write(LogFileName, EmptyStr);

  Application.ProcessMessages;
end;

procedure TMainForm.myShowSql;
var
  str_test: string;
  i: Integer;
begin
  str_test := '';
  with dmData.to_wms_Packets_query do
  begin
    for i := 0 to SQL.Count - 1 do
      str_test := str_test + SQL[i] + #13;
        //
    myShowMsg('Sql.Length = ' + IntToStr(Length(str_test)) + #13 + 'Sql.Count = ' + IntToStr(SQL.Count) + #13 + 'Sql=' + #13 + str_test);
  end;
end;

procedure TMainForm.OnTerminateOrderStatusChanged(Sender: TObject);
begin
  chkOrderStatusChanged.Checked := False;

  lbEnd_OrderStatusChanged.Caption     := Format(cEndPacket, [FormatDateTime(cDateTimeStr, Now)]);
  lbElapsed_OrderStatusChanged.Caption := Format(cElapsedPacket, [FormatDateTime(cTimeStr, Now - FStartOrderStatusChanged)]);

  lbElapsed_OrderStatusChanged.Repaint;
  lbEnd_OrderStatusChanged.Repaint;

  PostMessage(Handle, WM_NEED_UPDATE_GRIDS, 0, 0);
end;

procedure TMainForm.OnTerminateReceivingResult(Sender: TObject);
begin
  chkReceivingResult.Checked := False;

  lbEnd_ReceivingResult.Caption     := Format(cEndPacket, [FormatDateTime(cDateTimeStr, Now)]);
  lbElapsed_ReceivingResult.Caption := Format(cElapsedPacket, [FormatDateTime(cTimeStr, Now - FStartReceivingResult)]);

  lbElapsed_ReceivingResult.Repaint;
  lbEnd_ReceivingResult.Repaint;

  PostMessage(Handle, WM_NEED_UPDATE_GRIDS, 0, 0);
end;

procedure TMainForm.AdjustColumnWidth(AGrid: TDBGrid);
var
  iVisibleRowCount: Integer;
  tmpWorker: TAdjustColmnWidthThread;
begin
  Assert(AGrid.DataSource.DataSet <> nil, 'Expected DataSet <> nil');

  iVisibleRowCount := THackedGrid(AGrid).VisibleRowCount;
  tmpWorker := TAdjustColmnWidthThread.Create(AGrid, iVisibleRowCount, AGrid.DataSource.DataSet as TFDQuery, myShowMsg);
  tmpWorker.Start;
end;

procedure TMainForm.pgcMainChange(Sender: TObject);
begin
  if not dmData.IsConnectedBoth(nil) then Exit;

  if pgcMain.ActivePage = tsErrors then
  begin
    if not dmData.qryWMSGridErr.Active then
      UpdateWMSGrid(True);

    if not dmData.qryAlanGrid.Active then
      UpdateAlanGrid(True);
  end;

  if pgcMain.ActivePage = tsWmsMessage then
    if not dmData.qryWmsToHostMessage.Active then
      UpdateWmsMsgGrid(True);
end;

procedure TMainForm.seFontSizeChange(Sender: TObject);
begin
  LogMemo.Font.Size := seFontSize.Value;
  mmoMessage.Font.Size := seFontSize.Value;
end;

procedure TMainForm.seTimerIntervalChange(Sender: TObject);
begin
  TSettings.TimerInterval := seTimerInterval.Value * 1000;
  Timer.Interval := seTimerInterval.Value * 1000;
end;

procedure TMainForm.myShowMsg(const AMsg: string);
const
  cMsg = '%s %s';
var
  sMsg: string;
begin
  if chkUseLog.Checked then
  begin
    sMsg := Format(cMsg, [FormatDateTime(cDateTimeStr, Now), AMsg]);
    mmoMessage.Lines.Add(sMsg);
  end;

  FLog.Write(cLogFileName, AMsg);
end;

procedure TMainForm.myLogSql;
var
  LogFileName: string;
  i: Integer;
begin
  LogFileName := 'LogSql_' + FormatDateTime('yyyy-mm-dd hh-nn-ss', Now) + '.log';

  with dmData.to_wms_Packets_query do
  begin
    for i := 0 to SQL.Count - 1 do
      FLog.Write(LogFileName, SQL[i]);
  end;
end;

procedure TMainForm.btnFDC_wmsClick(Sender: TObject);
begin
  if dmData.ConnectWMS(TSettings.WMSDatabase, myShowMsg) then
    myShowMsg('WMS Connected = OK');
end;

procedure TMainForm.btnImpOrderStatusChangedClick(Sender: TObject);
var
  tmpWorker: TImportWorkerThread;
begin
  chkOrderStatusChanged.Checked := True;
  FStartOrderStatusChanged := Now;

  lbStart_OrderStatusChanged.Caption   := Format(cStartPacket, [FormatDateTime(cDateTimeStr, Now)]);
  lbEnd_OrderStatusChanged.Caption     := Format(cEndPacket, ['']);
  lbElapsed_OrderStatusChanged.Caption := Format(cElapsedPacket, ['']);

  tmpWorker := TImportWorkerThread.Create(cCreateSuspended, pknOrderStatusChanged, myShowMsg);
  tmpWorker.OnTerminate := OnTerminateOrderStatusChanged;
  tmpWorker.Start;
end;

procedure TMainForm.btnImpReceivingResultClick(Sender: TObject);
var
  tmpWorker: TImportWorkerThread;
begin
  chkReceivingResult.Checked := True;
  FStartReceivingResult := Now;

  lbStart_ReceivingResult.Caption   := Format(cStartPacket, [FormatDateTime(cDateTimeStr, Now)]);
  lbEnd_ReceivingResult.Caption     := Format(cEndPacket, ['']);
  lbElapsed_ReceivingResult.Caption := Format(cElapsedPacket, ['']);

  tmpWorker := TImportWorkerThread.Create(cCreateSuspended, pknReceivingResult, myShowMsg);
  tmpWorker.OnTerminate := OnTerminateReceivingResult;
  tmpWorker.Start;
end;

procedure TMainForm.btnFDC_alanClick(Sender: TObject);
begin
  if dmData.ConnectAlan(TSettings.AlanServer, myShowMsg) then
    myShowMsg('Alan Connected = OK');
end;

procedure TMainForm.btnMovement_INCOMING_to_wmsClick(Sender: TObject);
var
  lRecCount, lpack_id: Integer;
begin
   // INCOMING
  dmData.pInsert_to_wms_Movement_INCOMING_all(
    lRecCount, lpack_id, cbRecCount.Checked, cbDebug.Checked, StrToInt(EditRecCount.Text),
    myLogSql, myShowSql, myShowMsg);
  if lpack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(lpack_id) + ' spName = fInsert_to_wms_INCOMING')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(lpack_id) + ' spName = fInsert_to_wms_INCOMING');
end;

procedure TMainForm.btnMovement_ORDER_to_wmsClick(Sender: TObject);
var
  lRecCount, lpack_id: Integer;
begin
   // ORDER_all
  dmData.pInsert_to_wms_Movement_ORDER_all(
    lRecCount, lpack_id, cbRecCount.Checked, cbDebug.Checked, StrToInt(EditRecCount.Text),
    myLogSql, myShowSql, myShowMsg);
  if lpack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(lpack_id) + ' spName = fInsert_to_wms_ORDER')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(lpack_id) + ' spName = fInsert_to_wms_ORDER');
end;

procedure TMainForm.btnMovement_ASN_LOAD_to_wmsClick(Sender: TObject);
var
  lRecCount, lpack_id: Integer;
begin
   // ASN_LOAD
  dmData.pInsert_to_wms_Movement_ASN_LOAD_all(
    lRecCount, lpack_id, cbRecCount.Checked, cbDebug.Checked, StrToInt(EditRecCount.Text),
    myLogSql, myShowSql, myShowMsg);
  if lpack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(lpack_id) + ' spName = pInsert_to_wms_ASN_LOAD')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(lpack_id) + ' spName = pInsert_to_wms_ASN_LOAD');
end;

procedure TMainForm.btnObject_SKU_to_wmsClick(Sender: TObject);
var
  vb_pack_id: Integer;
begin
   // SKU
  vb_pack_id := dmData.fInsert_to_wms_SKU_all(cbRecCount.Checked, cbDebug.Checked,
    StrToInt(EditRecCount.Text), myLogSql, myShowSql, myShowMsg);
  if vb_pack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU');
end;

procedure TMainForm.btnObject_SKU_CODE_to_wmsClick(Sender: TObject);
var
  vb_pack_id: Integer;
begin
   // SKU_CODE
  vb_pack_id := dmData.fInsert_to_wms_SKU_CODE_all(cbRecCount.Checked, cbDebug.Checked,
    StrToInt(EditRecCount.Text), myLogSql, myShowSql, myShowMsg);
  if vb_pack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU_CODE')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU_CODE');
end;

procedure TMainForm.btnObject_SKU_GROUP_DEPENDS_to_wmsClickClick(Sender: TObject);
var
  vb_pack_id: Integer;
begin
   // sku_group + sku_depends
  vb_pack_id := dmData.fInsert_to_wms_SKU_GROUP_all(cbRecCount.Checked, cbDebug.Checked,
    StrToInt(EditRecCount.Text), myLogSql, myShowSql, myShowMsg);
  if vb_pack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU_GROUP + SKU_DEPENDS')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU_GROUP + SKU_DEPENDS');
end;

procedure TMainForm.btnObject_CLIENT_to_wmsClick(Sender: TObject);
var
  vb_pack_id: Integer;
begin
   // sku_group + sku_depends
  vb_pack_id := dmData.fInsert_to_wms_CLIENT_all(cbRecCount.Checked, cbDebug.Checked,
    StrToInt(EditRecCount.Text), myLogSql, myShowSql, myShowMsg);
   //vb_pack_id:= fInsert_to_wms_CLIENT;
  if vb_pack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_CLIENT')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_CLIENT');
end;

procedure TMainForm.btnObject_PACK_to_wmsClick(Sender: TObject);
var
  vb_pack_id: Integer;
begin
   // sku_group + sku_depends
  vb_pack_id := dmData.fInsert_to_wms_PACK_all(cbRecCount.Checked, cbDebug.Checked,
    StrToInt(EditRecCount.Text), myLogSql, myShowSql, myShowMsg);
  if vb_pack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_PACK')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_PACK');
end;

procedure TMainForm.btnObject_USER_to_wmsClick(Sender: TObject);
var
  vb_pack_id: Integer;
begin
   // sku_group + sku_depends
  vb_pack_id := dmData.fInsert_to_wms_USER_all(cbRecCount.Checked, cbDebug.Checked,
    StrToInt(EditRecCount.Text), myLogSql, myShowSql, myShowMsg);
  if vb_pack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_USER')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_USER');
end;

procedure TMainForm.btnStartTimerClick(Sender: TObject);
begin
  FStopTimer := False;
  btnStartTimer.Enabled := false;
  btnEndTimer.Enabled := true;
  myShowMsg('Start timer');
  Timer.Enabled := true;
end;

procedure TMainForm.btnUpdateAlanClick(Sender: TObject);
begin
  UpdateAlanGrid;
end;

procedure TMainForm.btnUpdateWMSClick(Sender: TObject);
begin
  UpdateWMSGrid;
end;

procedure TMainForm.btnUpdateWmsMessageClick(Sender: TObject);
begin
  UpdateWmsMsgGrid;
end;

procedure TMainForm.cbbWmsMessageModeChange(Sender: TObject);
begin
  UpdateWmsMsgGrid;
end;

procedure TMainForm.cbbWMSShowModeChange(Sender: TObject);
begin
  UpdateWMSGrid;
end;

constructor TMainForm.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited;
  FLog := TLog.Create;
  Timer.Interval := TSettings.TimerInterval;
  seTimerInterval.Value := TSettings.TimerInterval div 1000;
  edtWMSDatabase.Text := TSettings.WMSDatabase;
  edtAlanServer.Text := TSettings.AlanServer;
  pgcMain.ActivePage := tsLog;
  mmoMessage.Font.Size := seFontSize.Value;
  LogMemo.Font.Size := seFontSize.Value;

  dtpStartDateWMS.DateTime := Date;
  dtpEndDateWMS.DateTime   := TodayNearMidnight;

  dtpStartDateAlan.DateTime := Date;
  dtpEndDateAlan.DateTime   := TodayNearMidnight;

  dtpWmsMsgStart.DateTime := Date;
  dtpWmsMsgEnd.DateTime   := TodayNearMidnight;

  for I := 0 to Pred(ComponentCount) do
    if Components[I] is TDBGrid then
      with Components[I] as TDBGrid do
      begin
        Options := Options - [dgRowSelect] + [dgEditing, dgAlwaysShowSelection];
        ReadOnly := True;
      end;
end;

destructor TMainForm.Destroy;
begin
  FreeAndNil(FLog);
  inherited;
end;

procedure TMainForm.dtpEndDateAlanChange(Sender: TObject);
begin
  UpdateAlanGrid;
end;

procedure TMainForm.dtpEndDateWMSChange(Sender: TObject);
begin
  UpdateWMSGrid;
end;

procedure TMainForm.dtpStartDateAlanChange(Sender: TObject);
begin
  UpdateAlanGrid;
end;

procedure TMainForm.dtpStartDateWMSChange(Sender: TObject);
begin
  UpdateWMSGrid;
end;

procedure TMainForm.dtpWmsMsgEndChange(Sender: TObject);
begin
  UpdateWmsMsgGrid;
end;

procedure TMainForm.dtpWmsMsgStartChange(Sender: TObject);
begin
  UpdateWmsMsgGrid;
end;

procedure TMainForm.edtAlanServerExit(Sender: TObject);
begin
  dmData.CloseConnections;
  TSettings.AlanServer := edtAlanServer.Text;
end;

procedure TMainForm.edtWMSDatabaseExit(Sender: TObject);
begin
  dmData.CloseConnections;
  TSettings.WMSDatabase := edtWMSDatabase.Text;
end;

procedure TMainForm.btnApplyDefSettingsClick(Sender: TObject);
begin
  dmData.CloseConnections;
  TSettings.ApplyDefault;

  edtWMSDatabase.Text   := TSettings.WMSDatabase;
  edtAlanServer.Text    := TSettings.AlanServer;
  seTimerInterval.Value := TSettings.TimerInterval div 1000;
end;

procedure TMainForm.btnEndTimerClick(Sender: TObject);
begin
  FStopTimer := True;
  btnStartTimer.Enabled := true;
  btnEndTimer.Enabled := false;
  myShowMsg('Stop timer');
end;

procedure TMainForm.TimerTimer(Sender: TObject);
var
  lRecCount, lpack_id: Integer;
  Folder_Name: string;
begin
  Folder_Name := 'Exec_Timer';
     //
  try
    Timer.Enabled := false;
       //
       // INCOMING
    try
      dmData.pInsert_to_wms_Movement_INCOMING_all(
        lRecCount, lpack_id, cbRecCount.Checked, cbDebug.Checked, StrToInt(EditRecCount.Text),
        myLogSql, myShowSql, myShowMsg);
           //
      if lpack_id <> 0 then
        if lRecCount > 0 then
          AddToLog_Timer(Folder_Name, 'Send To WMS INCOMING : count = ' + IntToStr(lRecCount))
        else
          AddToLog_Timer(Folder_Name, 'not Send To WMS INCOMING')
      else
        AddToLog_Timer(Folder_Name, 'ERROR - pack_id = ' + IntToStr(lpack_id) + ' spName = pInsert_to_wms_Movement_INCOMING_all');
    except
      on E: Exception do
      begin
        AddToLog_Timer(Folder_Name, E.Message);
        AddToLog_Timer(Folder_Name, 'ERROR - exec pInsert_to_wms_Movement_INCOMING_all');
      end;
    end;
       //
       //обязательно таймаут
    MyDelay(2 * 1000);
       //
       // ASN_LOAD
    try
      dmData.pInsert_to_wms_Movement_ASN_LOAD_all(
        lRecCount, lpack_id, cbRecCount.Checked, cbDebug.Checked, StrToInt(EditRecCount.Text),
        myLogSql, myShowSql, myShowMsg);
      if lpack_id <> 0 then
        if lRecCount > 0 then
          AddToLog_Timer(Folder_Name, 'Send To WMS ASN : count = ' + IntToStr(lRecCount))
        else
          AddToLog_Timer(Folder_Name, 'not Send To WMS ASN')
      else
        AddToLog_Timer(Folder_Name, 'ERROR - pack_id = ' + IntToStr(lpack_id) + ' spName = pInsert_to_wms_ASN_LOAD');
    except
      on E: Exception do
      begin
        AddToLog_Timer(Folder_Name, E.Message);
        AddToLog_Timer(Folder_Name, 'ERROR - exec pInsert_to_wms_Movement_ASN_LOAD_all');
      end;
    end;
       //
    AddToLog_Timer(Folder_Name, '');
  finally
    Timer.Enabled := not FStopTimer;
  end;
end;

procedure TMainForm.UpdateAlanGrid(const ANeedRebuildColumns: Boolean = False);
begin
  dtpEndDateAlan.DateTime := NearMidnight(dtpEndDateAlan.DateTime);

  dmData.dsAlan.DataSet := nil;
  try
    with dmData.qryAlanGrid do
    begin
      Close;
      ParamByName('StartDate').AsDateTime := dtpStartDateAlan.DateTime;
      ParamByName('EndDate').AsDateTime   := dtpEndDateAlan.DateTime;
      Open;
    end;
  finally
    dmData.dsAlan.DataSet := dmData.qryAlanGrid;
  end;

  if ANeedRebuildColumns then
    grdAlan.Columns.RebuildColumns;

  AdjustColumnWidth(grdAlan);
end;

procedure TMainForm.UpdateWMSGrid(const ANeedRebuildColumns: Boolean);
var
  qryWMS: TFDQuery;
begin
  qryWMS := nil;

  dmData.dsWMS.DataSet := nil;
  try
    case cbbWMSShowMode.ItemIndex of
      0: qryWMS := dmData.qryWMSGridAll;
      1: qryWMS := dmData.qryWMSGridErr;
    end;

    dtpEndDateWMS.DateTime := NearMidnight(dtpEndDateWMS.DateTime);

    qryWMS.Close;
    qryWMS.ParamByName('StartDate').AsDateTime := dtpStartDateWMS.DateTime;
    qryWMS.ParamByName('EndDate').AsDateTime   := dtpEndDateWMS.DateTime;
    qryWMS.Open;
  finally
    dmData.dsWMS.DataSet := qryWMS;;
  end;

  if ANeedRebuildColumns then
    grdWMS.Columns.RebuildColumns;

  AdjustColumnWidth(grdWMS);
end;

procedure TMainForm.UpdateWmsMsgGrid(const ANeedRebuildColumns: Boolean);
begin
  dtpWmsMsgEnd.DateTime := NearMidnight(dtpWmsMsgEnd.DateTime);

  dmData.dsWmsToHostMessage.DataSet := nil;
  try
    with dmData.qryWmsToHostMessage do
    begin
      Close;
      ParamByName('StartDate').AsDateTime := dtpWmsMsgStart.DateTime;
      ParamByName('EndDate').AsDateTime   := dtpWmsMsgEnd.DateTime;
      ParamByName('ErrorOnly').AsBoolean  := (cbbWmsMessageMode.ItemIndex = 1);
      Open;
    end;
  finally
    dmData.dsWmsToHostMessage.DataSet := dmData.qryWmsToHostMessage;
  end;

  if ANeedRebuildColumns then
    grdWmsMessage.Columns.RebuildColumns;

  AdjustColumnWidth(grdWmsMessage);
end;

procedure TMainForm.WMNeedUpdateGrids(var AMessage: TMessage);
begin
  if not dmData.IsConnectedBoth(nil) then Exit;

  UpdateWMSGrid(True);
  UpdateAlanGrid(True);
  UpdateWmsMsgGrid(True);
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  // позиционирование Log memo
  LogMemo.Width := ((ClientWidth - LogMemo.Left) div 2) - 10;
  mmoMessage.Left := LogMemo.Left + LogMemo.Width + 10;
  mmoMessage.Width := ClientWidth - mmoMessage.Left - 20;

  // позиционирование гридов
  pnlWMS.Height := (tsErrors.Height - splHorz.Height) div 2;
end;

end.

