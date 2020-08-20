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
  Winapi.Windows,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  UConstants,
  UDefinitions,
  ULog,
  UGateway;

type
  TTimeMeter = class
  strict private
    FStartTime: TDateTime;
    FChkbox: TCheckBox;
    FStart, FEnd, FElapsed: TLabel;
  public
    constructor Create(AChkbox: TCheckBox; AStart, AEnd, AElapsed: TLabel);
    procedure Start;
    procedure Finish;
  end;

  TPacketThreadInfo = record
    PacketKind: TPacketKind;
    OnTerminate: TNotifyEvent;
    Stopped: Boolean;
  end;

  TTimerPool = array of TPacketThreadInfo;

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
    splHorz: TSplitter;
    pnlAlan: TPanel;
    pnlAlanTop: TPanel;
    grdAlan: TDBGrid;
    btnUpdateAlan: TButton;
    lbStartDateAlan: TLabel;
    lbEndDateAlan: TLabel;
    dtpStartDateAlan: TDateTimePicker;
    dtpEndDateAlan: TDateTimePicker;
    btnImpOrderStatusChanged: TButton;
    btnImpReceivingResult: TButton;
    tsWmsToHostMessage: TTabSheet;
    pnlWmsToHostMessage: TPanel;
    pnlWmstMessageTop: TPanel;
    lbWmsMsgStart: TLabel;
    lbWmsMsgEnd: TLabel;
    Label3: TLabel;
    btnUpdateWmsMessage: TButton;
    dtpWmsMsgStart: TDateTimePicker;
    dtpWmsMsgEnd: TDateTimePicker;
    cbbWmsMessageMode: TComboBox;
    grdWmsToHostMessage: TDBGrid;
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
    pgcLog: TPageControl;
    tsLogView: TTabSheet;
    tsCheckboxView: TTabSheet;
    grpExpPackets: TGroupBox;
    lbStartwms_Object_SKU: TLabel;
    lbEndwms_Object_SKU: TLabel;
    lbStartwms_Object_SKU_CODE: TLabel;
    lbEndwms_Object_SKU_CODE: TLabel;
    lbElpswms_Object_SKU: TLabel;
    lbElpswms_Object_SKU_CODE: TLabel;
    chkwms_Object_SKU: TCheckBox;
    chkwms_Object_SKU_CODE: TCheckBox;
    chkwms_Object_SKU_GROUP: TCheckBox;
    lbStartwms_Object_SKU_GROUP: TLabel;
    lbEndwms_Object_SKU_GROUP: TLabel;
    lbElpswms_Object_SKU_GROUP: TLabel;
    chkwms_Object_CLIENT: TCheckBox;
    lbStartwms_Object_CLIENT: TLabel;
    lbEndwms_Object_CLIENT: TLabel;
    lbElpswms_Object_CLIENT: TLabel;
    chkwms_Object_PACK: TCheckBox;
    lbStartwms_Object_PACK: TLabel;
    lbEndwms_Object_PACK: TLabel;
    lbElpswms_Object_PACK: TLabel;
    chkwms_Object_USER: TCheckBox;
    lbStartwms_Object_USER: TLabel;
    lbEndwms_Object_USER: TLabel;
    lbElpswms_Object_USER: TLabel;
    chkwms_Movement_INCOMING: TCheckBox;
    lbStartwms_Movement_INCOMING: TLabel;
    lbEndwms_Movement_INCOMING: TLabel;
    lbElpswms_Movement_INCOMING: TLabel;
    chkwms_Movement_ASN_LOAD: TCheckBox;
    lbStartwms_Movement_ASN_LOAD: TLabel;
    lbEndwms_Movement_ASN_LOAD: TLabel;
    lbElpswms_Movement_ASN_LOAD: TLabel;
    chkwms_Movement_ORDER: TCheckBox;
    lbStartwms_Movement_ORDER: TLabel;
    lbEndwms_Movement_ORDER: TLabel;
    lbElpswms_Movement_ORDER: TLabel;
    btnDataExportErrors: TButton;
    chkProcessExpErr: TCheckBox;
    lbStartProcessExpErr: TLabel;
    lbEndProcessExpErr: TLabel;
    lbElpsProcessExpErr: TLabel;
    tsWmsMessage: TTabSheet;
    pnlWmsMessage: TPanel;
    pnlWmsMsgTop: TPanel;
    lbMsgStart: TLabel;
    lbMsgEnd: TLabel;
    lbWmsMsgMode: TLabel;
    btnUpdateWmsMsg: TButton;
    dtpInsertStart: TDateTimePicker;
    dtpInsertEnd: TDateTimePicker;
    cbbWmsMsgMode: TComboBox;
    grdWmsMessage: TDBGrid;
    tsOraExport: TTabSheet;
    tsOraImport: TTabSheet;
    pnlWMS: TPanel;
    pnlWmsTop: TPanel;
    lbDateStart: TLabel;
    lbEndDate: TLabel;
    lbWMSShowMode: TLabel;
    btnUpdateWMS: TButton;
    dtpStartDateWMS: TDateTimePicker;
    dtpEndDateWMS: TDateTimePicker;
    cbbWMSShowMode: TComboBox;
    grdWMS: TDBGrid;
    pnlWmsFromHostError: TPanel;
    pnlpnlWmsFromHostErrorTop: TPanel;
    lbStartWmsFromHostError: TLabel;
    lbEndWmsFromHostError: TLabel;
    btnUpdateWmsFromHostError: TButton;
    dtpStartWmsFromHostError: TDateTimePicker;
    dtpEndWmsFromHostError: TDateTimePicker;
    grdWmsFromHostError: TDBGrid;
    splOraImport: TSplitter;
    pnlOraImpDetail: TPanel;
    grdWMSDetail: TDBGrid;
    pnlFromHostHeaderMessage: TPanel;
    pnlFromHostHeaderMessageTop: TPanel;
    lbStartFromHostHeaderMessage: TLabel;
    lbEndFromHostHeaderMessage: TLabel;
    lb3: TLabel;
    btnUpdateFromHostHeaderMessage: TButton;
    dtpStartFromHostHeaderMessage: TDateTimePicker;
    dtpEndFromHostHeaderMessage: TDateTimePicker;
    cbbFromHostHeaderMessage: TComboBox;
    grdFromHostHeaderMessage: TDBGrid;
    splFromHostHeader: TSplitter;
    pnlFromHostDetailMessage: TPanel;
    grdFromHostDetailMessage: TDBGrid;
    chkWriteLog: TCheckBox;
    btnStartGateway: TButton;
    btnStopGateway: TButton;
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
    procedure chkUseLogClick(Sender: TObject);
    procedure btnDataExportErrorsClick(Sender: TObject);
    procedure btnUpdateWmsMsgClick(Sender: TObject);
    procedure cbbWmsMsgModeChange(Sender: TObject);
    procedure dtpInsertStartChange(Sender: TObject);
    procedure dtpInsertEndChange(Sender: TObject);
    procedure grdWmsMessageDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure btnUpdateWmsFromHostErrorClick(Sender: TObject);
    procedure dtpStartWmsFromHostErrorChange(Sender: TObject);
    procedure dtpEndWmsFromHostErrorChange(Sender: TObject);
    procedure btnUpdateFromHostHeaderMessageClick(Sender: TObject);
    procedure cbbFromHostHeaderMessageChange(Sender: TObject);
    procedure dtpStartFromHostHeaderMessageChange(Sender: TObject);
    procedure dtpEndFromHostHeaderMessageChange(Sender: TObject);
    procedure chkWriteLogClick(Sender: TObject);
    procedure btnStartGatewayClick(Sender: TObject);
    procedure btnStopGatewayClick(Sender: TObject);

  private
    FLog: TLog;
    FTimerStopped: Boolean;
    FExpThread: TExporterThread;
    FImpThread: TImporterThread;
    FStartOrderStatusChanged: TDateTime;
    FStartReceivingResult: TDateTime;
    FTimerPool: TTimerPool;
    FObjectSKU_TM, FObjectSKUCode_TM, FObjectSKUGroup_TM, FObjectClient_TM, FObjectPack_TM, FObjectUser_TM,
    FMovementInc_TM, FMovementASNLoad_TM, FMovementOrder_TM, FProcessExpErr_TM: TTimeMeter;

  private
    procedure AddToLog_Timer(LogType, S: string);
    procedure myShowSql;
    procedure myLogSql;
    procedure myShowMsg(const AMsg: string);
    procedure MyDelay(mySec: Integer);
    procedure AdjustColumnWidth(AGrid: TDBGrid);
    procedure UpdateGrid(AQry: TFDQuery; ADataSrc: TDataSource; AGrid: TDBGrid; AStart, AEnd: TDateTimePicker;
      const ANeedRebuildColumns: Boolean); overload;
    procedure UpdateGrid(AQry: TFDQuery; ADataSrc: TDataSource; AGrid: TDBGrid; const ANeedRebuildColumns: Boolean); overload;
    procedure UpdateWMSGrid(const ANeedRebuildColumns: Boolean = False);
    procedure UpdateWMSGridDetail(const ANeedRebuildColumns: Boolean = False);
    procedure UpdateFromHostHeaderGrid(const ANeedRebuildColumns: Boolean = False);
    procedure UpdateFromHostDetailGrid(const ANeedRebuildColumns: Boolean = False);
    procedure UpdateAlanGrid(const ANeedRebuildColumns: Boolean = False);
    procedure UpdateWmsFromHostErrorGrid(const ANeedRebuildColumns: Boolean = False);
    procedure UpdateWmsToHostMsgGrid(const ANeedRebuildColumns: Boolean = False);
    procedure UpdateWmsMessageGrid(const ANeedRebuildColumns: Boolean = False);
    procedure WMNeedUpdateGrids(var AMessage: TMessage); message WM_NEED_UPDATE_GRIDS;
    procedure ExportPacket(APacketKind: TPacketKind; AOnTerminate: TNotifyEvent);
    procedure RunTimerPool(const APackets: array of TPacketKind);
    procedure NotifyPacketTerminated(APacketKind: TPacketKind);
    procedure StartTimeMeter(APacketKind: TPacketKind);
    procedure OnTerminateOrderStatusChanged(Sender: TObject);
    procedure OnTerminateReceivingResult(Sender: TObject);
    procedure OnTerminateWmsMovementASNLoad(Sender: TObject);
    procedure OnTerminateWmsObjectSKU(Sender: TObject);
    procedure OnTerminateWmsObjectSKUCode(Sender: TObject);
    procedure OnTerminateWmsObjectSKUGroup(Sender: TObject);
    procedure OnTerminateWmsObjectClient(Sender: TObject);
    procedure OnTerminateWmsObjectPack(Sender: TObject);
    procedure OnTerminateWmsObjectUser(Sender: TObject);
    procedure OnTerminateWmsMovementOrder(Sender: TObject);
    procedure OnTerminateWmsMovementIncoming(Sender: TObject);
    procedure OnTerminateProcessExportDataErr(Sender: TObject);

    function GetOnTerminate(APacketKInd: TPacketKind): TNotifyEvent;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  System.TypInfo,
  UData,
  UCommon,
  USettings,
  UQryThread,
  UFileVersion;

type
  THackedGrid = class(TCustomGrid);

const
  cLogFileName = 'Messages.log';
  cEndPacket = 'завершено  %s';
  cStartPacket = 'начало выполнени€  %s';
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
//  FLog.Write(LogFileName, DateTimeToStr(Now) + ' : ');  //<-- дата вставл€етс€ внутри FLog.Write
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

procedure TMainForm.NotifyPacketTerminated(APacketKind: TPacketKind);
var
  I: Integer;
begin
  for I := Low(FTimerPool) to High(FTimerPool) do
    if FTimerPool[I].PacketKind = APacketKind then
    begin
      FTimerPool[I].Stopped := True;
      Break;
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

  NotifyPacketTerminated(pknOrderStatusChanged);
end;

procedure TMainForm.OnTerminateProcessExportDataErr(Sender: TObject);
begin
  FProcessExpErr_TM.Finish;
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

  NotifyPacketTerminated(pknReceivingResult);
end;

procedure TMainForm.OnTerminateWmsMovementASNLoad(Sender: TObject);
var
  lwResult: LongWord;
  P: PExportData;
  lpack_id: Integer;
  tmpThread: TWorkerThread;
begin
  tmpThread := Sender as TWorkerThread;
  lwResult := tmpThread.MyReturnValue;
  lpack_id := 0;

  if lwResult > 0 then
  begin
    P := PExportData(lwResult);
    lpack_id := P^.Pack_id;
    Dispose(P);
  end;

  FMovementASNLoad_TM.Finish;

  if lpack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(lpack_id) + ' spName = pInsert_to_wms_ASN_LOAD')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(lpack_id) + ' spName = pInsert_to_wms_ASN_LOAD');

  NotifyPacketTerminated(pknWmsMovementIncoming);
end;

procedure TMainForm.OnTerminateWmsMovementIncoming(Sender: TObject);
var
  lwResult: LongWord;
  P: PExportData;
  lpack_id: Integer;
  tmpThread: TWorkerThread;

begin
  tmpThread := Sender as TWorkerThread;
  lwResult := tmpThread.MyReturnValue;
  lpack_id := 0;

  if lwResult > 0 then
  begin
    P := PExportData(lwResult);
    lpack_id := P^.Pack_id;
    Dispose(P);
  end;

  FMovementInc_TM.Finish;

  if lpack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(lpack_id) + ' spName = fInsert_to_wms_INCOMING')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(lpack_id) + ' spName = fInsert_to_wms_INCOMING');

  WaitFor(2000);

  if FTimerStopped then
  begin
    NotifyPacketTerminated(pknWmsMovementIncoming);
    Exit;
  end;

  // пакет ASNLoad должен быть запущен только по окончании пакета Incoming
  FMovementASNLoad_TM.Start;
  ExportPacket(pknWmsMovementASNLoad, OnTerminateWmsMovementASNLoad);

  // ¬ этом пакете не вызыываем NotifyPacketTerminated. Ёто будет сделано в OnTerminateWmsMovementASNLoad.
  //  роме случа€, когда таймер был остановлен и пакет pknWmsMovementASNLoad еще не был запущен.
end;

procedure TMainForm.OnTerminateWmsMovementOrder(Sender: TObject);
var
  lwResult: LongWord;
  P: PExportData;
  lpack_id: Integer;
  tmpThread: TWorkerThread;
begin
  tmpThread := Sender as TWorkerThread;
  lwResult := tmpThread.MyReturnValue;
  lpack_id := 0;

  if lwResult > 0 then
  begin
    P := PExportData(lwResult);
    lpack_id := P^.Pack_id;
    Dispose(P);
  end;

  FMovementOrder_TM.Finish;

  if lpack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(lpack_id) + ' spName = fInsert_to_wms_ORDER')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(lpack_id) + ' spName = fInsert_to_wms_ORDER');

  NotifyPacketTerminated(pknWmsMovementOrder);
end;

procedure TMainForm.OnTerminateWmsObjectClient(Sender: TObject);
var
  vb_pack_id: Integer;
  tmpThread: TWorkerThread;
begin
  tmpThread := Sender as TWorkerThread;
  vb_pack_id := tmpThread.MyReturnValue;
  FObjectClient_TM.Finish;

  if vb_pack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_CLIENT')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_CLIENT');

  NotifyPacketTerminated(pknWmsObjectClient);
end;

procedure TMainForm.OnTerminateWmsObjectPack(Sender: TObject);
var
  vb_pack_id: Integer;
  tmpThread: TWorkerThread;
begin
  tmpThread := Sender as TWorkerThread;
  vb_pack_id := tmpThread.MyReturnValue;
  FObjectPack_TM.Finish;

  if vb_pack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_PACK')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_PACK');

  NotifyPacketTerminated(pknWmsObjectPack);
end;

procedure TMainForm.OnTerminateWmsObjectSKU(Sender: TObject);
var
  vb_pack_id: Integer;
  tmpThread: TWorkerThread;
begin
  tmpThread := Sender as TWorkerThread;
  vb_pack_id := tmpThread.MyReturnValue;

  FObjectSKU_TM.Finish;

  if vb_pack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU');

  NotifyPacketTerminated(pknWmsObjectSKU);
end;

procedure TMainForm.OnTerminateWmsObjectSKUCode(Sender: TObject);
var
  vb_pack_id: Integer;
  tmpThread: TWorkerThread;
begin
  tmpThread := Sender as TWorkerThread;
  vb_pack_id := tmpThread.MyReturnValue;
  FObjectSKUCode_TM.Finish;

  if vb_pack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU_CODE')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU_CODE');

  NotifyPacketTerminated(pknWmsObjectSKUCode);
end;

procedure TMainForm.OnTerminateWmsObjectSKUGroup(Sender: TObject);
var
  vb_pack_id: Integer;
  tmpThread: TWorkerThread;
begin
  tmpThread := Sender as TWorkerThread;
  vb_pack_id := tmpThread.MyReturnValue;
  FObjectSKUGroup_TM.Finish;

  if vb_pack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU_GROUP + SKU_DEPENDS')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU_GROUP + SKU_DEPENDS');

  NotifyPacketTerminated(pknWmsObjectSKUGroup);
end;

procedure TMainForm.OnTerminateWmsObjectUser(Sender: TObject);
var
  vb_pack_id: Integer;
  tmpThread: TWorkerThread;
begin
  tmpThread := Sender as TWorkerThread;
  vb_pack_id := tmpThread.MyReturnValue;
  FObjectUser_TM.Finish;

  if vb_pack_id <> 0 then
    myShowMsg('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_USER')
  else
    myShowMsg('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_USER');

  NotifyPacketTerminated(pknWmsObjectUser);
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
    if not dmData.qryAlanGrid.Active then
      UpdateAlanGrid(True);

    if not dmData.qryAlanGridFromHost.Active then
      UpdateWmsFromHostErrorGrid(True);
  end;

  if pgcMain.ActivePage = tsWmsToHostMessage then
    if not dmData.qryWmsToHostMessage.Active then
      UpdateWmsToHostMsgGrid(True);

  if pgcMain.ActivePage = tsWmsMessage then
    if not dmData.qryWmsMessageAll.Active and not dmData.qryWmsMessageErr.Active then
      UpdateWmsMessageGrid(True);

  if pgcMain.ActivePage = tsOraImport then
  begin
    if not dmData.qryWMSGridErr.Active and not dmData.qryWMSGridAll.Active then
      UpdateWMSGrid(True); // UpdateWMSGridDetail(True) будет вызван внутри UpdateWMSGrid

    with dmData.qryWMSDetail do
    begin
      MasterSource    := dmData.dsWMS;
      MasterFields    := 'Id';
      IndexFieldNames := 'Header_Id';
    end;
  end;

  if pgcMain.ActivePage = tsOraExport then
  begin
    if not dmData.qryFromHostMessageAll.Active and not dmData.qryFRomHostMessageErr.Active then
      UpdateFromHostHeaderGrid(True); // UpdateFromHostDetailGrid(True) будет вызван внутри UpdateFromHostHeaderGrid

    with dmData.qryFromHostDetail do
    begin
      MasterSource    := dmData.dsFromHostMessage;
      MasterFields    := 'Id';
      IndexFieldNames := 'Header_Id';
    end;
  end;
end;

procedure TMainForm.RunTimerPool(const APackets: array of TPacketKind);
var
  I: Integer;
begin
  SetLength(FTimerPool, Length(APackets));

  for I := Low(FTimerPool) to High(FTimerPool) do
  begin
    FTimerPool[I].PacketKind  := APackets[I];
    FTimerPool[I].OnTerminate := GetOnTerminate(APackets[I]);
    StartTimeMeter(FTimerPool[I].PacketKind);
    ExportPacket(FTimerPool[I].PacketKind, FTimerPool[I].OnTerminate);
  end;
end;

procedure TMainForm.seFontSizeChange(Sender: TObject);
begin
  LogMemo.Font.Size := seFontSize.Value;
  mmoMessage.Font.Size := seFontSize.Value;
end;

procedure TMainForm.seTimerIntervalChange(Sender: TObject);
begin
  TSettings.TimerInterval := seTimerInterval.Value * c1Sec;
  Timer.Interval := seTimerInterval.Value * c1Sec;
end;

procedure TMainForm.StartTimeMeter(APacketKind: TPacketKind);
begin
  case APacketKInd of
    pknWmsMovementASNLoad:  FMovementASNLoad_TM.Start;
    pknWmsObjectClient:     FObjectClient_TM.Start;
    pknWmsObjectPack:       FObjectPack_TM.Start;
    pknWmsObjectSKU:        FObjectSKU_TM.Start;
    pknWmsObjectSKUCode:    FObjectSKUCode_TM.Start;
    pknWmsObjectSKUGroup:   FObjectSKUGroup_TM.Start;
    pknWmsObjectUser:       FObjectUser_TM.Start;
    pknWmsMovementIncoming: FMovementInc_TM.Start;
    pknWmsMovementOrder:    FMovementOrder_TM.Start;
  end;
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
begin
  FMovementInc_TM.Start;
  ExportPacket(pknWmsMovementIncoming, OnTerminateWmsMovementIncoming);
end;

procedure TMainForm.btnMovement_ORDER_to_wmsClick(Sender: TObject);
begin
  FMovementOrder_TM.Start;
  ExportPacket(pknWmsMovementOrder, OnTerminateWmsMovementOrder);
end;

procedure TMainForm.btnMovement_ASN_LOAD_to_wmsClick(Sender: TObject);
begin
  FMovementASNLoad_TM.Start;
  ExportPacket(pknWmsMovementASNLoad, OnTerminateWmsMovementASNLoad);
end;

procedure TMainForm.btnObject_SKU_to_wmsClick(Sender: TObject);
begin
  FObjectSKU_TM.Start;
  ExportPacket(pknWmsObjectSKU, OnTerminateWmsObjectSKU);
end;

procedure TMainForm.btnObject_SKU_CODE_to_wmsClick(Sender: TObject);
begin
  FObjectSKUCode_TM.Start;
  ExportPacket(pknWmsObjectSKUCode, OnTerminateWmsObjectSKUCode);
end;

procedure TMainForm.btnObject_SKU_GROUP_DEPENDS_to_wmsClickClick(Sender: TObject);
begin
  FObjectSKUGroup_TM.Start;
  ExportPacket(pknWmsObjectSKUGroup, OnTerminateWmsObjectSKUGroup);
end;

procedure TMainForm.btnObject_CLIENT_to_wmsClick(Sender: TObject);
begin
  FObjectClient_TM.Start;
  ExportPacket(pknWmsObjectClient, OnTerminateWmsObjectClient);
end;

procedure TMainForm.btnObject_PACK_to_wmsClick(Sender: TObject);
begin
  FObjectPack_TM.Start;
  ExportPacket(pknWmsObjectPack, OnTerminateWmsObjectPack);
end;

procedure TMainForm.btnObject_USER_to_wmsClick(Sender: TObject);
begin
  FObjectUser_TM.Start;
  ExportPacket(pknWmsObjectUser, OnTerminateWmsObjectUser);
end;

procedure TMainForm.btnUpdateAlanClick(Sender: TObject);
begin
  UpdateAlanGrid;
end;

procedure TMainForm.btnUpdateFromHostHeaderMessageClick(Sender: TObject);
begin
  UpdateFromHostHeaderGrid;
end;

procedure TMainForm.btnUpdateWMSClick(Sender: TObject);
begin
  UpdateWMSGrid;
end;

procedure TMainForm.btnUpdateWmsFromHostErrorClick(Sender: TObject);
begin
  UpdateWmsFromHostErrorGrid;
end;

procedure TMainForm.btnUpdateWmsMessageClick(Sender: TObject);
begin
  UpdateWmsToHostMsgGrid;
end;

procedure TMainForm.btnUpdateWmsMsgClick(Sender: TObject);
begin
  UpdateWmsMessageGrid;
end;

procedure TMainForm.cbbFromHostHeaderMessageChange(Sender: TObject);
begin
  UpdateFromHostHeaderGrid;
end;

procedure TMainForm.cbbWmsMessageModeChange(Sender: TObject);
begin
  UpdateWmsToHostMsgGrid;
end;

procedure TMainForm.cbbWmsMsgModeChange(Sender: TObject);
begin
  UpdateWmsMessageGrid;
end;

procedure TMainForm.cbbWMSShowModeChange(Sender: TObject);
begin
  UpdateWMSGrid;
end;

procedure TMainForm.chkUseLogClick(Sender: TObject);
begin
  if chkUseLog.Checked then
    pgcLog.ActivePage := tsLogView
  else
    pgcLog.ActivePage := tsCheckboxView;
end;

procedure TMainForm.chkWriteLogClick(Sender: TObject);
begin
  TSettings.UseLog := chkWriteLog.Checked;
end;

constructor TMainForm.Create(AOwner: TComponent);
var
  I: Integer;
const
  cAppCaption = 'SendData WMS - %s';
begin
  inherited;

  Caption := Format(cAppCaption, [GetFileVersion]);

  SetLength(FTimerPool, 0);
  FLog := TLog.Create;
  chkWriteLog.Checked := TSettings.UseLog;

  Timer.Interval := TSettings.TimerInterval;
  seTimerInterval.Value := TSettings.TimerInterval div c1Sec;
  FTimerStopped := True;

  edtWMSDatabase.Text := TSettings.WMSDatabase;
  edtAlanServer.Text := TSettings.AlanServer;
  pgcMain.ActivePage := tsLog;
  mmoMessage.Font.Size := seFontSize.Value;
  LogMemo.Font.Size := seFontSize.Value;

  dtpStartDateWMS.DateTime := Date;
  dtpEndDateWMS.DateTime   := TodayNearMidnight;

  dtpStartFromHostHeaderMessage.DateTime := Date;
  dtpEndFromHostHeaderMessage.DateTime   := TodayNearMidnight;

  dtpStartDateAlan.DateTime := Date;
  dtpEndDateAlan.DateTime   := TodayNearMidnight;

  dtpStartWmsFromHostError.DateTime := Date;
  dtpEndWmsFromHostError.DateTime   := TodayNearMidnight;

  dtpWmsMsgStart.DateTime := Date;
  dtpWmsMsgEnd.DateTime   := TodayNearMidnight;

  dtpInsertStart.DateTime := Date;
  dtpInsertEnd.DateTime   := TodayNearMidnight;

  pgcLog.ActivePage := tsCheckboxView;

  for I := 0 to Pred(ComponentCount) do
    if Components[I] is TDBGrid then
      with Components[I] as TDBGrid do
      begin
        Options := Options - [dgRowSelect] + [dgEditing, dgAlwaysShowSelection];
        ReadOnly := True;
      end;

  FObjectSKU_TM       := TTimeMeter.Create(chkwms_Object_SKU, lbStartwms_Object_SKU, lbEndwms_Object_SKU, lbElpswms_Object_SKU);
  FObjectSKUCode_TM   := TTimeMeter.Create(chkwms_Object_SKU_CODE, lbStartwms_Object_SKU_CODE, lbEndwms_Object_SKU_CODE, lbElpswms_Object_SKU_CODE);
  FObjectSKUGroup_TM  := TTimeMeter.Create(chkwms_Object_SKU_GROUP, lbStartwms_Object_SKU_GROUP, lbEndwms_Object_SKU_GROUP, lbElpswms_Object_SKU_GROUP);
  FObjectClient_TM    := TTimeMeter.Create(chkwms_Object_CLIENT, lbStartwms_Object_CLIENT, lbEndwms_Object_CLIENT, lbElpswms_Object_CLIENT);
  FObjectPack_TM      := TTimeMeter.Create(chkwms_Object_PACK, lbStartwms_Object_PACK, lbEndwms_Object_PACK, lbElpswms_Object_PACK);
  FObjectUser_TM      := TTimeMeter.Create(chkwms_Object_USER, lbStartwms_Object_USER, lbEndwms_Object_USER, lbElpswms_Object_USER);
  FMovementInc_TM     := TTimeMeter.Create(chkwms_Movement_INCOMING, lbStartwms_Movement_INCOMING, lbEndwms_Movement_INCOMING, lbElpswms_Movement_INCOMING);
  FMovementASNLoad_TM := TTimeMeter.Create(chkwms_Movement_ASN_LOAD, lbStartwms_Movement_ASN_LOAD, lbEndwms_Movement_ASN_LOAD, lbElpswms_Movement_ASN_LOAD);
  FMovementOrder_TM   := TTimeMeter.Create(chkwms_Movement_ORDER, lbStartwms_Movement_ORDER, lbEndwms_Movement_ORDER, lbElpswms_Movement_ORDER);
  FProcessExpErr_TM   := TTimeMeter.Create(chkProcessExpErr, lbStartProcessExpErr, lbEndProcessExpErr, lbElpsProcessExpErr);
end;

destructor TMainForm.Destroy;
var
  I: Integer;
  bAllStopped: Boolean;
begin
  FTimerStopped := True;
  Timer.Enabled := False;

  repeat
    bAllStopped := True;

    for I := Low(FTimerPool) to High(FTimerPool) do
      bAllStopped := bAllStopped and FTimerPool[I].Stopped;

    WaitFor(2000, not bAllStopped);
  until bAllStopped;

  FreeAndNil(FObjectSKU_TM);
  FreeAndNil(FObjectSKUCode_TM);
  FreeAndNil(FObjectSKUGroup_TM);
  FreeAndNil(FObjectClient_TM);
  FreeAndNil(FObjectPack_TM);
  FreeAndNil(FObjectUser_TM);
  FreeAndNil(FMovementInc_TM);
  FreeAndNil(FMovementASNLoad_TM);
  FreeAndNil(FMovementOrder_TM);
  FreeAndNil(FProcessExpErr_TM);
  FreeAndNil(FExpThread);
  FreeAndNil(FImpThread);
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

procedure TMainForm.dtpEndFromHostHeaderMessageChange(Sender: TObject);
begin
  UpdateFromHostHeaderGrid;
end;

procedure TMainForm.dtpEndWmsFromHostErrorChange(Sender: TObject);
begin
  UpdateWmsFromHostErrorGrid;
end;

procedure TMainForm.dtpInsertEndChange(Sender: TObject);
begin
  UpdateWmsMessageGrid;
end;

procedure TMainForm.dtpInsertStartChange(Sender: TObject);
begin
  UpdateWmsMessageGrid;
end;

procedure TMainForm.dtpStartDateAlanChange(Sender: TObject);
begin
  UpdateAlanGrid;
end;

procedure TMainForm.dtpStartDateWMSChange(Sender: TObject);
begin
  UpdateWMSGrid;
end;

procedure TMainForm.dtpStartFromHostHeaderMessageChange(Sender: TObject);
begin
  UpdateFromHostHeaderGrid;
end;

procedure TMainForm.dtpStartWmsFromHostErrorChange(Sender: TObject);
begin
  UpdateWmsFromHostErrorGrid;
end;

procedure TMainForm.dtpWmsMsgEndChange(Sender: TObject);
begin
  UpdateWmsToHostMsgGrid;
end;

procedure TMainForm.dtpWmsMsgStartChange(Sender: TObject);
begin
  UpdateWmsToHostMsgGrid;
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

procedure TMainForm.ExportPacket(APacketKind: TPacketKind; AOnTerminate: TNotifyEvent);
var
  tmpData: TExportData;
  expThread: TExportWorkerThread;
begin
  with tmpData do
  begin
    ThresholdRecCount := StrToInt(EditRecCount.Text);
    UseRecCount := cbRecCount.Checked;
    UseDebug    := cbDebug.Checked;
    LogSqlProc  := myLogSql;
    ShowSqlProc := myShowSql;
    ShowMsgProc := myShowMsg;
  end;

  expThread := TExportWorkerThread.Create(cCreateSuspended, tmpData, APacketKind, myShowMsg);
  expThread.OnTerminate := AOnTerminate;
  expThread.Start;
end;

procedure TMainForm.btnApplyDefSettingsClick(Sender: TObject);
begin
  dmData.CloseConnections;
  TSettings.ApplyDefault;

  edtWMSDatabase.Text   := TSettings.WMSDatabase;
  edtAlanServer.Text    := TSettings.AlanServer;
  seTimerInterval.Value := TSettings.TimerInterval div 1000;
  chkWriteLog.Checked   := TSettings.UseLog;
end;

procedure TMainForm.btnDataExportErrorsClick(Sender: TObject);
var
  tmpWorker: TProcessExportDataErrorThread;
begin
  // ƒанные были успешно вставлены в таб. WMS.from_host_header_message, но в результате обработки этих данных возникли ошибки.
  // —обираем эти ошибки и записываем в таб. ALAN.wms_to_host_error

  FProcessExpErr_TM.Start;
  tmpWorker := TProcessExportDataErrorThread.Create(True, myShowMsg);
  tmpWorker.OnTerminate := OnTerminateProcessExportDataErr;
  tmpWorker.Start;
end;

procedure TMainForm.btnStartGatewayClick(Sender: TObject);
begin
  FImpThread := TImporterThread.Create(cCreateRunning, myShowMsg, tknDriven);
  FExpThread   := TExporterThread.Create(cCreateRunning, myShowMsg, tknDriven);
end;

procedure TMainForm.btnStopGatewayClick(Sender: TObject);
begin
  FImpThread.Terminate;
  FExpThread.Terminate;

  FImpThread.WaitFor(c1Sec * 30);
  FExpThread.WaitFor(c1Sec * 30);

  FreeAndNil(FImpThread);
  FreeAndNil(FExpThread);
end;

procedure TMainForm.btnStartTimerClick(Sender: TObject);
begin
  FTimerStopped := False;

  btnStartTimer.Enabled := false;
  btnEndTimer.Enabled   := true;

  // добавь в массив любые пакеты, которые хочешь запускать по таймеру (кроме pknWmsMovementASNLoad)
  RunTimerPool([pknWmsMovementOrder, pknWmsMovementIncoming]);

  Timer.Enabled := True;
  myShowMsg('“аймер запущен');
end;

procedure TMainForm.btnEndTimerClick(Sender: TObject);
begin
  FTimerStopped := True;
  Timer.Enabled := False;

  btnStartTimer.Enabled := true;
  btnEndTimer.Enabled   := false;
  myShowMsg('“аймер остановлен');
end;

procedure TMainForm.TimerTimer(Sender: TObject);
var
  I: Integer;
begin
  // запускаем те пакеты, которые уже завершились
  for I := Low(FTimerPool) to High(FTimerPool) do
    if FTimerPool[I].Stopped and not FTimerStopped then
    begin
      FTimerPool[I].Stopped := False;
      StartTimeMeter(FTimerPool[I].PacketKind);
      ExportPacket(FTimerPool[I].PacketKind, FTimerPool[I].OnTerminate);
    end;
end;

procedure TMainForm.UpdateAlanGrid(const ANeedRebuildColumns: Boolean = False);
begin
  UpdateGrid(
    dmData.qryAlanGrid,
    dmData.dsAlan,
    grdAlan,
    dtpStartDateAlan,
    dtpEndDateAlan,
    ANeedRebuildColumns
  );
end;

procedure TMainForm.UpdateFromHostDetailGrid(const ANeedRebuildColumns: Boolean);
begin
  UpdateGrid(dmData.qryFromHostDetail, dmData.dsFromHostDetail, grdFromHostDetailMessage, ANeedRebuildColumns);
end;

procedure TMainForm.UpdateFromHostHeaderGrid(const ANeedRebuildColumns: Boolean);
var
  tmpQry: TFDQuery;
begin
  tmpQry := nil;

  case cbbFromHostHeaderMessage.ItemIndex of
    0: tmpQry := dmData.qryFromHostMessageAll;
    1: tmpQry := dmData.qryFRomHostMessageErr;
  end;

  UpdateGrid(
    tmpQry,
    dmData.dsFromHostMessage,
    grdFromHostHeaderMessage,
    dtpStartFromHostHeaderMessage,
    dtpEndFromHostHeaderMessage,
    ANeedRebuildColumns
  );

  // обновл€ем источник данных detail-грида
  UpdateFromHostDetailGrid(ANeedRebuildColumns);
end;

procedure TMainForm.UpdateGrid(AQry: TFDQuery; ADataSrc: TDataSource; AGrid: TDBGrid;
  const ANeedRebuildColumns: Boolean);
begin
  UpdateGrid(AQry, ADataSrc, AGrid, nil, nil, ANeedRebuildColumns);
end;

procedure TMainForm.UpdateGrid(AQry: TFDQuery; ADataSrc: TDataSource; AGrid: TDBGrid; AStart, AEnd: TDateTimePicker;
  const ANeedRebuildColumns: Boolean);
begin
  if AQry = nil then Exit;

  if ADataSrc = nil then Exit;
  

  if AEnd <> nil then
    AEnd.DateTime := NearMidnight(AEnd.DateTime);

  ADataSrc.DataSet := nil;
  try
    with AQry do
    begin
      Close;
      if AStart <> nil then
        ParamByName('StartDate').AsDateTime := AStart.DateTime;
      if AEnd <> nil then
        ParamByName('EndDate').AsDateTime   := AEnd.DateTime;
      Open;
    end;
  finally
    ADataSrc.DataSet := AQry;
    AGrid.DataSource := ADataSrc;
  end;

  if ANeedRebuildColumns then
    AGrid.Columns.RebuildColumns;

  AdjustColumnWidth(AGrid);
end;

procedure TMainForm.UpdateWmsFromHostErrorGrid(const ANeedRebuildColumns: Boolean);
begin
  UpdateGrid(
    dmData.qryAlanGridFromHost,
    dmData.dsWmsFromHostError,
    grdWmsFromHostError,
    dtpStartWmsFromHostError,
    dtpEndWmsFromHostError,
    ANeedRebuildColumns
  );
end;

procedure TMainForm.UpdateWMSGrid(const ANeedRebuildColumns: Boolean);
var
  qryWMS: TFDQuery;
begin
  qryWMS := nil;

  case cbbWMSShowMode.ItemIndex of
    0: qryWMS := dmData.qryWMSGridAll;
    1: qryWMS := dmData.qryWMSGridErr;
  end;

  UpdateGrid(
    qryWMS,
    dmData.dsWMS,
    grdWMS,
    dtpStartDateWMS,
    dtpEndDateWMS,
    ANeedRebuildColumns
  );

  // обновл€ем источник данных detail-грида
  UpdateWMSGridDetail(ANeedRebuildColumns);
end;

procedure TMainForm.UpdateWMSGridDetail(const ANeedRebuildColumns: Boolean);
begin
  UpdateGrid(dmData.qryWMSDetail, dmData.dsWMSDetail, grdWMSDetail, ANeedRebuildColumns);
end;

procedure TMainForm.UpdateWmsMessageGrid(const ANeedRebuildColumns: Boolean);
var
  qryWmsMsg: TFDQuery;
begin
  qryWmsMsg := nil;

  case cbbWmsMsgMode.ItemIndex of
    0: qryWmsMsg := dmData.qryWmsMessageAll;
    1: qryWmsMsg := dmData.qryWmsMessageErr;
  end;

  UpdateGrid(
    qryWmsMsg,
    dmData.dsWmsMessage,
    grdWmsMessage,
    dtpInsertStart,
    dtpInsertEnd,
    ANeedRebuildColumns
  );
end;

procedure TMainForm.UpdateWmsToHostMsgGrid(const ANeedRebuildColumns: Boolean);
begin
  case cbbWmsMessageMode.ItemIndex of
    0: dmData.qryWmsToHostMessage.ParamByName('ErrorOnly').AsBoolean := False;
    1: dmData.qryWmsToHostMessage.ParamByName('ErrorOnly').AsBoolean := True;
  end;

  UpdateGrid(
    dmData.qryWmsToHostMessage,
    dmData.dsWmsToHostMessage,
    grdWmsToHostMessage,
    dtpWmsMsgStart,
    dtpWmsMsgEnd,
    ANeedRebuildColumns
  );
end;

procedure TMainForm.WMNeedUpdateGrids(var AMessage: TMessage);
begin
  if not dmData.IsConnectedBoth(nil) then Exit;

  try
    UpdateWMSGrid(True);
    UpdateFromHostHeaderGrid(True);
    UpdateAlanGrid(True);
    UpdateWmsFromHostErrorGrid(True);
    UpdateWmsToHostMsgGrid(True);
    UpdateWmsMessageGrid(True);
  except
    on E: Exception do
      myShowMsg(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  // позиционирование Log memo
  LogMemo.Width := ((tsLogView.Width - LogMemo.Left) div 2) - 10;
  mmoMessage.Left := LogMemo.Left + LogMemo.Width + 10;
  mmoMessage.Width := tsLogView.Width - mmoMessage.Left - 10;

  // позиционирование гридов
  pnlWMS.Height := (tsOraImport.Height - splOraImport.Height) div 2;
  pnlWmsFromHostError.Height := (tsErrors.Height - splHorz.Height) div 2;
  pnlFromHostHeaderMessage.Height := (tsOraExport.Height - splFromHostHeader.Height) div 2;
end;

function TMainForm.GetOnTerminate(APacketKInd: TPacketKind): TNotifyEvent;
begin
  case APacketKInd of
    pknOrderStatusChanged:  Result := OnTerminateOrderStatusChanged;
    pknReceivingResult:     Result := OnTerminateReceivingResult;
    pknWmsMovementASNLoad:  Result := OnTerminateWmsMovementASNLoad;
    pknWmsObjectClient:     Result := OnTerminateWmsObjectClient;
    pknWmsObjectPack:       Result := OnTerminateWmsObjectPack;
    pknWmsObjectSKU:        Result := OnTerminateWmsObjectSKU;
    pknWmsObjectSKUCode:    Result := OnTerminateWmsObjectSKUCode;
    pknWmsObjectSKUGroup:   Result := OnTerminateWmsObjectSKUGroup;
    pknWmsObjectUser:       Result := OnTerminateWmsObjectUser;
    pknWmsMovementIncoming: Result := OnTerminateWmsMovementIncoming;
    pknWmsMovementOrder:    Result := OnTerminateWmsMovementOrder;
  end;
end;

procedure TMainForm.grdWmsMessageDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Grid: TStringGrid;
  Texto: String;
  R: TRect;
begin
  R := Rect;
  R.Top  := R.Top + 2;
  R.Left := R.Left + 2;

  Grid := TStringGrid(Sender);
  if Column.Field.IsBlob then
  begin
    Grid.Canvas.FillRect(Rect);
    Texto := Column.Field.AsString;
    DrawText(Grid.Canvas.Handle,
             PChar(Texto),
             StrLen(PChar(Texto)),
             R,
             DT_WORDBREAK);
  end
  else
    (Sender as TDBGrid).DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;



{ TTimeMeter }

constructor TTimeMeter.Create(AChkbox: TCheckBox; AStart, AEnd, AElapsed: TLabel);
begin
  inherited Create;
  FChkbox  := AChkbox;
  FStart   := AStart;
  FEnd     := AEnd;
  FElapsed := AElapsed;
end;

procedure TTimeMeter.Finish;
begin
  FChkbox.Checked := False;

  FEnd.Caption     := Format(cEndPacket, [FormatDateTime(cTimeStr, Now)]);
  FElapsed.Caption := Format(cElapsedPacket, [FormatDateTime(cTimeStr, Now - FStartTime)]);

  FElapsed.Repaint;
  FEnd.Repaint;
end;

procedure TTimeMeter.Start;
begin
  FStartTime := Now;
  FChkbox.Checked := True;

  FStart.Caption   := Format(cStartPacket, [FormatDateTime(cTimeStr, Now)]);
  FEnd.Caption     := Format(cEndPacket, ['']);
  FElapsed.Caption := Format(cElapsedPacket, ['']);

  FElapsed.Repaint;
  FEnd.Repaint;
end;

end.

