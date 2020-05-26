unit Main;

interface

uses
  System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls, Vcl.ExtCtrls, ULog, Vcl.ComCtrls, Vcl.Samples.Spin;

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
    btnAll_from_wms: TButton;
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
    procedure btnAll_from_wmsClick(Sender: TObject);
  private
    FLog: TLog;
    FStopTimer: Boolean;
  private
    procedure AddToLog_Timer(LogType, S: string);
    procedure myShowSql;
    procedure myLogSql;
    procedure myShowMsg(const AMsg: string);
    procedure MyDelay(mySec: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  UData, USettings;

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

  LogStr := FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) + ' ' + S;
  LogMemo.Lines.Add(LogStr);

  LogFileName := LogType + '\' + FormatDateTime('yyyy-mm-dd', Date) + '.log';
  FLog.Write(LogFileName, DateTimeToStr(Now) + ' : ');
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
  sMsg := Format(cMsg, [FormatDateTime('yyyy-mm-dd hh:mm:ss', Now), AMsg]);
  mmoMessage.Lines.Add(sMsg);
end;

procedure TMainForm.myLogSql;
var
  LogFileName: string;
  i: Integer;
begin
  LogFileName := FormatDateTime('yyyy-mm-dd hh-mm-ss', Now) + '.log';

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

constructor TMainForm.Create(AOwner: TComponent);
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
end;

destructor TMainForm.Destroy;
begin
  FreeAndNil(FLog);
  inherited;
end;

procedure TMainForm.edtAlanServerExit(Sender: TObject);
begin
  TSettings.AlanServer := edtAlanServer.Text;
end;

procedure TMainForm.edtWMSDatabaseExit(Sender: TObject);
begin
  TSettings.WMSDatabase := edtWMSDatabase.Text;
end;

procedure TMainForm.btnAll_from_wmsClick(Sender: TObject);
begin
  if dmData.IsConnectedBoth(myShowMsg) then
  begin
    if dmData.ImportWMS(myShowMsg) then
      myShowMsg('Success import data from WMS');
  end;
end;

procedure TMainForm.btnApplyDefSettingsClick(Sender: TObject);
begin
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

procedure TMainForm.FormResize(Sender: TObject);
begin
  LogMemo.Width := ((ClientWidth - LogMemo.Left) div 2) - 10;
  mmoMessage.Left := LogMemo.Left + LogMemo.Width + 10;
  mmoMessage.Width := ClientWidth - mmoMessage.Left - 20;
end;

end.

