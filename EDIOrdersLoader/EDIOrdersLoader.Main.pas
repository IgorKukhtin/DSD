unit EDIOrdersLoader.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, dsdDB, EDI, Vcl.ActnList,
  dsdAction, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsCore, dxSkinsDefaultPainters, Vcl.Menus, cxButtons,
  cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, System.IniFiles,
  Data.DB, Datasnap.DBClient, cxStyles, dxSkinscxPCPainter, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxDBData, dsdInternetAction, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxGridCustomView, cxGrid, dsdExportToXLSAction, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue
  ,frxBarcode, FastReportAddOn, dsdCommon;

type
  TMainForm = class(TForm)
    TrayIcon: TTrayIcon;
    Timer: TTimer;
    OptionsMemo: TMemo;
    LogMemo: TMemo;
    FormParams: TdsdFormParams;
    spGetDefaultEDI: TdsdStoredProc;
    EDI: TEDI;
    ActionList: TActionList;
    actSetDefaults: TdsdExecStoredProc;
    spHeaderOrder: TdsdStoredProc;
    spListOrder: TdsdStoredProc;
    Panel: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    StartButton: TcxButton;
    StopButton: TcxButton;
    actStartEDI: TAction;
    actStopEDI: TAction;
    EDIActionOrdersLoad: TEDIAction;
    cbPrevDay: TCheckBox;
    spGetStatMovementEDI: TdsdStoredProc;
    actGet_Movement_Edi_stat: TdsdExecStoredProc;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectSale_EDI: TdsdStoredProc;
    spUpdateEdiOrdspr: TdsdStoredProc;
    spUpdateEdiInvoice: TdsdStoredProc;
    spUpdateEdiDesadv: TdsdStoredProc;
    actExecPrintStoredProc: TdsdExecStoredProc;
    actUpdateEdiDesadvTrue: TdsdExecStoredProc;
    actUpdateEdiInvoiceTrue: TdsdExecStoredProc;
    actUpdateEdiOrdsprTrue: TdsdExecStoredProc;
    actInvoice: TEDIAction;
    actOrdSpr: TEDIAction;
    actDesadv: TEDIAction;
    mactInvoice: TMultiAction;
    mactOrdSpr: TMultiAction;
    mactDesadv: TMultiAction;
    Send_toEDICDS: TClientDataSet;
    spSelectSend_toEDI: TdsdStoredProc;
    spUpdate_EDI_Send: TdsdStoredProc;
    actUpdate_EDI_Send: TdsdExecStoredProc;
    cbLoad: TCheckBox;
    cbSend: TCheckBox;
    actAfterInvoice: TAction;
    ExportEmailCDS: TClientDataSet;
    ExportEmailDS: TDataSource;
    ExportCDS: TClientDataSet;
    ExportDS: TDataSource;
    ExportXmlGrid: TcxGrid;
    ExportXmlGridDBTableView: TcxGridDBTableView;
    RowData: TcxGridDBColumn;
    ExportXmlGridLevel: TcxGridLevel;
    spGet_Export_Email: TdsdStoredProc;
    spGet_Export_FileName: TdsdStoredProc;
    spSelect_Export: TdsdStoredProc;
    spUpdate_isMail: TdsdStoredProc;
    actGet_Export_Email: TdsdExecStoredProc;
    actGet_Export_FileName: TdsdExecStoredProc;
    actSelect_Export: TdsdExecStoredProc;
    actExport_Grid: TExportGrid;
    actSMTPFile: TdsdSMTPFileAction;
    actUpdate_isMail: TdsdExecStoredProc;
    mactExport: TMultiAction;
    cbEmail: TCheckBox;
    Send_EmailCDS: TClientDataSet;
    spSelectSend_Email: TdsdStoredProc;
    mactExport_xls: TMultiAction;
    spSelectPrintItem: TdsdStoredProc;
    cbEmailExcel: TCheckBox;
    PrintSignCDS: TClientDataSet;
    spSelectPrintHeader: TdsdStoredProc;
    spSelectPrintSign: TdsdStoredProc;
    actSelect_Export_xls: TdsdExecStoredProc;
    actExportToXLS_project: TdsdExportToXLS;
    actGet_Export_FileName_xls: TdsdExecStoredProc;
    spGet_Export_FileName_xls: TdsdStoredProc;
    spGetReportName: TdsdStoredProc;
    actSPPrintSaleProcName: TdsdExecStoredProc;
    PrintItemsSverkaCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actExport_fr3: TdsdPrintAction;
    mactExport_xls_2244900110: TMultiAction;
    actVchasnoEDIOrdeLoad: TdsdVchasnoEDIAction;
    actVchasnoEDIOrdrsp: TdsdVchasnoEDIAction;
    actVchasnoEDIDesadv: TdsdVchasnoEDIAction;
    actVchasnoEDIComDoc: TdsdVchasnoEDIAction;
    Panel1: TPanel;
    LogVchasno_InMsgMemo: TMemo;
    LogVchasno_OutMsgMemo: TMemo;
    actVchasnoEDIDelnot: TdsdVchasnoEDIAction;
    actUpdateVchasnoEdiComdocTrue: TdsdExecStoredProc;
    actUpdateVchasnoEdiDelnotTrue: TdsdExecStoredProc;
    spUpdateVchasnoEdiComdoc: TdsdStoredProc;
    spUpdateVchasnoEdiDelnot: TdsdStoredProc;
    spGetReportNameQuality_export: TdsdStoredProc;
    spSelectPrint_Quality: TdsdStoredProc;
    DataCondraCDS: TClientDataSet;
    spSelectData_Condra: TdsdStoredProc;
    acGet_Quality_ReportName: TdsdExecStoredProc;
    actPrintQuality_saveFile: TdsdPrintAction;
    actSelectData_Condra: TdsdExecStoredProc;
    actVchasno_SendCondra: TdsdVchasnoEDIAction;
    mactVchasnoEDICONDRA: TMultiAction;
    actUpdateEdiCONDRATrue: TdsdExecStoredProc;
    spUpdateEdiCondra: TdsdStoredProc;
    actGet_Email_report: TdsdExecStoredProc;
    spGet_Email_report: TdsdStoredProc;
    actSMTPFile_Email_report: TdsdSMTPFileAction;
    spUpdateEdiSent_Email_report: TdsdStoredProc;
    procedure TrayIconClick(Sender: TObject);
    procedure AppMinimize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actStartEDIExecute(Sender: TObject);
    procedure actStartEDIUpdate(Sender: TObject);
    procedure actStopEDIExecute(Sender: TObject);
    procedure actStopEDIUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actAfterInvoiceExecute(Sender: TObject);
  private
    { Private declarations }
    FIntervalVal: Integer;
    FProccessing: Boolean;
    FProccessingEmail: Boolean;
    isPrevDay_begin: Boolean;
    gErr: Boolean;
    Hour_onDel: Integer;
    Hour_onSendEmail: Integer;
    fStartTime: TDateTime;
    procedure AddToLog(S: string);
    procedure AddToLog_Vchasno(isOutMsg : Boolean; S: string; isError : Boolean);
    procedure StartEDI;
    procedure StopEDI;
    procedure ProccessEDI;
    procedure ProccessEmail;
    function fGet_Movement_Edi_stat : Integer;
    function fEdi_LoadData_from : Boolean;
    function fEdi_LoadDataVchasno_from : Boolean;
    function fEdi_SendData_to : Boolean;
    function fSale_SendEmail : Boolean;

    procedure pSendReport_VchasnoEDI_err (MovementId_send_Edi: Integer;
                                          InvNumberPartner_order: String;
                                          OperDate_order : TDateTime;
                                          InvNumber_Parent: String;
                                          OperDatePartner_Parent : TDateTime;
                                          FromName,ToName,RetailName: String;
                                          lProcessName : String;
                                          lFileName_save : String;
                                          Error_txt : String
                                         );
  public
    { Public declarations }
    procedure MyDelay_two(mySec:Integer);
    property IntervalVal: Integer read FIntervalVal;
    property Proccessing: Boolean read FProccessing write FProccessing;
    property ProccessingEmail: Boolean read FProccessingEmail write FProccessingEmail;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.MyDelay_two(mySec:Integer);
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  calcSec,calcSec2:LongInt;
begin
     Present:=Now;
     DecodeDate(Present, Year, Month, Day);
     DecodeTime(Present, Hour, Min, Sec, MSec);
     //calcSec:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
     //calcSec2:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
     calcSec:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     calcSec2:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     while abs(calcSec-calcSec2)<mySec do
     begin
          Present:=Now;
          DecodeDate(Present, Year, Month, Day);
          DecodeTime(Present, Hour, Min, Sec, MSec);
          //calcSec2:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
          calcSec2:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     end;
end;

procedure TMainForm.actAfterInvoiceExecute(Sender: TObject);
begin
     if (PrintHeaderCDS.FieldByName('InvNumber').asString = '') or (PrintHeaderCDS.RecordCount <> 1)
     then
          LogMemo.Lines.Add('!!! FIND ERROR !!!'
                          + ' InvNumber = <'+PrintHeaderCDS.FieldByName('InvNumber').asString + '>'
                          //Документ продажа - отправка в EDI
                          + ' MovementId = <'+IntToStr (FormParams.ParamByName('MovementId_toEDI').Value) + '>'
                          //Документ для отправки в EDI
                          + ' MovementId_EDI_send = <'+IntToStr (FormParams.ParamByName('MovementId_EDI_send').Value) + '>'
                          //
                          + ' RecordCount = <'+IntToStr (PrintHeaderCDS.RecordCount) + '>'
                           )
     else
          LogMemo.Lines.Add('ok Send = <'+PrintHeaderCDS.FieldByName('InvNumber').asString);
end;

procedure TMainForm.actStartEDIExecute(Sender: TObject);
begin
      try StartEDI;
          //
          Hour_onSendEmail:=-1;
          ProccessEmail;
      finally
          Timer.Enabled:=True;
      end;
end;

procedure TMainForm.actStartEDIUpdate(Sender: TObject);
begin
//  actStartEDI.Enabled := not Timer.Enabled;
end;

procedure TMainForm.actStopEDIExecute(Sender: TObject);
begin
  StopEDI;
end;

procedure TMainForm.actStopEDIUpdate(Sender: TObject);
begin
//  actStopEDI.Enabled := Timer.Enabled;
end;

procedure TMainForm.AddToLog_Vchasno(isOutMsg : Boolean; S: string; isError : Boolean);
var
  LogStr: string;
  LogFileName: string;
  LogFile: TextFile;
begin
  Application.ProcessMessages;
  LogStr := FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) + ' ' + S;
  // в этом окне
  if isError = true
  then if isOutMsg = true
       // ошибка - исходящий пакет
       then LogVchasno_OutMsgMemo.Lines.Add(LogStr)
       // ошибка - входящий пакет
       else LogVchasno_InMsgMemo.Lines.Add(LogStr)
  // нет ошибки - в общем окне
  else LogMemo.Lines.Add(LogStr);

  // в этот файл
  if isError = true
  then if isOutMsg = true
       // ошибка - исходящий пакет
       then LogFileName := ChangeFileExt(Application.ExeName, '') + '_Vch_err_out_' + FormatDateTime('yyyymmdd', Date) + '.log'
       // ошибка - входящий пакет
       else LogFileName := ChangeFileExt(Application.ExeName, '') + '_Vch_err_out_' + FormatDateTime('yyyymmdd', Date) + '.log'
  // нет ошибки - стандарт файл Vchasno
  else LogFileName := ChangeFileExt(Application.ExeName, '') + '_Vchasno_' + FormatDateTime('yyyymmdd', Date) + '.log';

  AssignFile(LogFile, LogFileName);

  if FileExists(LogFileName) then
    Append(LogFile)
  else
    Rewrite(LogFile);

  Writeln(LogFile, LogStr);
  CloseFile(LogFile);
  Application.ProcessMessages;
end;

procedure TMainForm.AddToLog(S: string);
var
  LogStr: string;
  LogFileName: string;
  LogFile: TextFile;
begin
  Application.ProcessMessages;
  LogStr := FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) + ' ' + S;
  LogMemo.Lines.Add(LogStr);
  LogFileName := ChangeFileExt(Application.ExeName, '') + '_' + FormatDateTime('yyyymmdd', Date) + '.log';

  AssignFile(LogFile, LogFileName);

  if FileExists(LogFileName) then
    Append(LogFile)
  else
    Rewrite(LogFile);

  Writeln(LogFile, LogStr);
  CloseFile(LogFile);
  Application.ProcessMessages;
end;

procedure TMainForm.AppMinimize(Sender: TObject);
begin
  ShowWindow(Handle, SW_HIDE);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StopEDI;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  IntervalStr: string;
  ExcelStr: string;
begin
  Application.OnMinimize := AppMinimize;
  Timer.Enabled := False;
  Proccessing := False;
  ProccessingEmail := False;
  Hour_onDel := -1;
  Hour_onSendEmail:= -1;
  //
  // параметры для отправки по почте ошибки EDI_Send_Email_report
  actGet_Email_report.Execute;
  FormParams.ParamByName('Subject_Email_report').Value:=ExportEmailCDS.FieldByName('Subject').AsString;
  FormParams.ParamByName('Body_Email_report').Value:=ExportEmailCDS.FieldByName('Body').AsString;
  FormParams.ParamByName('AddressFrom_Email_report').Value:=ExportEmailCDS.FieldByName('AddressFrom').AsString;
  FormParams.ParamByName('Host_Email_report').Value:=ExportEmailCDS.FieldByName('Host').AsString;
  FormParams.ParamByName('Port_Email_report').Value:=ExportEmailCDS.FieldByName('Port').AsString;
  FormParams.ParamByName('UserName_Email_report').Value:=ExportEmailCDS.FieldByName('UserName').AsString;
  FormParams.ParamByName('Password_Email_report').Value:=ExportEmailCDS.FieldByName('Password').AsString;
  FormParams.ParamByName('AddressTo_Email_report').Value:=ExportEmailCDS.FieldByName('AddressTo').AsString;
  //
  actVchasnoEDIOrdeLoad.ShowErrorMessages.Value:= FALSE;
  actVchasnoEDIOrdrsp.ShowErrorMessages.Value:= FALSE;
  actVchasnoEDIDesadv.ShowErrorMessages.Value:= FALSE;
  actVchasnoEDIDelnot.ShowErrorMessages.Value:= FALSE;
  actVchasnoEDIComDoc.ShowErrorMessages.Value:= FALSE;
  //
  cbEmailExcel.Checked:= TRUE; // ParamStr(3) = 'Excel';
  cbLoad.Checked:=  TRUE; // ParamStr(3) = '';
  cbSend.Checked:=  TRUE; // ParamStr(3) = '';
  cbEmail.Checked:= TRUE; // ParamStr(3) = '';

  // При запуске считаем что пред день НЕ надо, т.е. он уже обработан
  isPrevDay_begin:= false;

  if FindCmdLineSwitch('interval', IntervalStr) then
    FIntervalVal := StrToIntDef(IntervalStr, 1)
  else
    FIntervalVal := 1;

  if IntervalVal > 0 then
    Timer.Interval := IntervalVal * 60 * 1000
  else
    Timer.Interval := 1 * 1 * 1000;

  if cbPrevDay.Checked = TRUE
  then deStart.EditValue := Date - 1
  else deStart.EditValue := Date;

  deEnd.EditValue := Date ;
  deStart.Enabled := False;
  deEnd.Enabled := False;
  fStartTime:= Now;
  OptionsMemo.Lines.Text := 'Текущий интервал: ' + IntToStr(IntervalVal) + ' мин.';
  //
  LogMemo.Clear;
  LogVchasno_InMsgMemo.Clear;
  LogVchasno_OutMsgMemo.Clear;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
      ActiveControl:= cbPrevDay;
      if not Timer.Enabled then
      try MainForm.StartEDI;
      finally
          Timer.Enabled:=True;
      end;
end;

function TMainForm.fGet_Movement_Edi_stat : Integer;
begin
     actGet_Movement_Edi_stat.Execute;
     Result:= spGetStatMovementEDI.ParamByName('gpGet_Movement_Edi_stat').Value;
end;

function TMainForm.fEdi_LoadData_from : Boolean;
var Old_stat : Integer;
    Present: TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
    lHoursInterval_del : Integer;
begin
  Present:=Now;
  DecodeTime(Present, Hour, Min, Sec, MSec);

  if isPrevDay_begin = false then cbPrevDay.Checked:= true;

  try
    Result:= false;
    //
    AddToLog('.....');
    actSetDefaults.Execute;
    AddToLog('Обновили Default для EDI : ' + DateTimeToStr(now));

    // напрямую - работает криво
    lHoursInterval_del:= FormParams.ParamByName('HoursInterval_del').Value;

    // если пришло время и за "текущий" Hour еще не было удаления
    if ((Hour mod lHoursInterval_del) = 0)
    and (Hour_onDel <> Hour)
    and (spGetDefaultEDI.ParamByName('gIsDelete').Value = TRUE)
    then begin
              //переопределили Признак - "удаление на ФТП" - будем делать каждые Х часов :)
              FormParams.ParamByName('gIsDelete').Value := TRUE;
              //запомнили текущий Hour кода сделали удаление
              Hour_onDel:= Hour;
         end
    // поставили что НЕ надо удалить
    // else FormParams.ParamByName('gIsDelete').Value := FALSE;
    else FormParams.ParamByName('gIsDelete').Value := TRUE;

    //
    OptionsMemo.Lines.Clear;
    OptionsMemo.Lines.Add('Старт: '+FormatDateTime('dd.mm.yy hh:mm', fStartTime));
    if FormParams.ParamByName('gIsDelete').Value = TRUE
    then OptionsMemo.Lines.Add('Текущий интервал: ' + IntToStr(IntervalVal) + ' : del = TRUE')
    else OptionsMemo.Lines.Add('Текущий интервал: ' + IntToStr(IntervalVal) + ' : del = FALSE');
    OptionsMemo.Lines.Add('Host: ' +  FormParams.ParamByName('Host').AsString);
    OptionsMemo.Lines.Add('UserName: ' +  FormParams.ParamByName('UserName').AsString);
    OptionsMemo.Lines.Add('Password: ' +  FormParams.ParamByName('Password').AsString);

     if cbLoad.Checked = FALSE then
     begin
          AddToLog('.....');
          AddToLog('ОТКЛЮЧИЛИ Загрузку из EDI');
          Result:= true;
          exit
     end;

    if cbPrevDay.Checked = TRUE
    then deStart.EditValue := Date - 1
    else deStart.EditValue := Date;
    deEnd.EditValue := Date;

    Old_stat:=fGet_Movement_Edi_stat;
    AddToLog('Загрузка EDI началась ... <'+IntToStr(Old_stat)+'>');

    if FormParams.ParamByName('gIsDelete').Value = TRUE
    then AddToLog(' - Период с ' + deStart.EditText + ' по ' + deEnd.EditText + ' : del = TRUE')
    else AddToLog(' - Период с ' + deStart.EditText + ' по ' + deEnd.EditText + ' : del = FALSE');

    EDIActionOrdersLoad.Execute;
    AddToLog('Загружено <'+IntToStr(fGet_Movement_Edi_stat - Old_stat)+'> Документов');

    AddToLog('Finish');

    // теперь после Vchasno
    //if cbPrevDay.Checked = true then begin cbPrevDay.Checked:= false; isPrevDay_begin:= true; end;

    //
    Result:= TRUE;

  except
     on E: Exception do begin
        gErr:= Pos('--- ignore file',E.Message) = 0;
        AddToLog(E.Message);
     end;
  end;
end;

// Загрузка из EDI-VCHASNO
function TMainForm.fEdi_LoadDataVchasno_from : Boolean;
var Old_stat : Integer;
    Present: TDateTime;
    Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
  Present:=Now;
  DecodeTime(Present, Hour, Min, Sec, MSec);

  if isPrevDay_begin = false then cbPrevDay.Checked:= true;

  try
    Result:= false;
    //
    AddToLog_Vchasno(false, '.....', false);
    actSetDefaults.Execute;
    AddToLog_Vchasno(false, 'Обновили Default для EDI-VCHASNO : ' + DateTimeToStr(now), false);


    OptionsMemo.Lines.Clear;
    OptionsMemo.Lines.Add('Старт: '+FormatDateTime('dd.mm.yy hh:mm', fStartTime));
    OptionsMemo.Lines.Add('Текущий интервал: ' + IntToStr(IntervalVal) + ' : del = NO');
    OptionsMemo.Lines.Add('Host: ' +  actVchasnoEDIOrdeLoad.Host.Value);
    OptionsMemo.Lines.Add('UserName: Token' );
    OptionsMemo.Lines.Add('Password: actVchasnoEDIOrdeLoad.Token.Value' {+  actVchasnoEDIOrdeLoad.Token.Value});

     if cbLoad.Checked = FALSE then
     begin
          AddToLog_Vchasno(false, '.....', false);
          AddToLog_Vchasno(false, 'ОТКЛЮЧИЛИ Загрузку из EDI-VCHASNO', false);
          Result:= true;
          exit
     end;

    if cbPrevDay.Checked = TRUE
    then deStart.EditValue := Date - 1
    else deStart.EditValue := Date;
    deEnd.EditValue := Date;

    Old_stat:=fGet_Movement_Edi_stat;
    AddToLog_Vchasno(false, 'Загрузка VCHASNO началась ... <'+IntToStr(Old_stat)+'>', false);

    AddToLog_Vchasno(false, ' - Период с ' + deStart.EditText + ' по ' + deEnd.EditText + ' : del = NO', false);

    if not actVchasnoEDIOrdeLoad.Execute
    then begin
              AddToLog_Vchasno(false, actVchasnoEDIOrdeLoad.ErrorText.Value, true);
    end;

    AddToLog_Vchasno(false, 'Загружено <'+IntToStr(fGet_Movement_Edi_stat - Old_stat)+'> Документов', false);

    AddToLog_Vchasno(false, 'Finish', false);

    if cbPrevDay.Checked = true then begin cbPrevDay.Checked:= false; isPrevDay_begin:= true; end;

    //
    Result:= TRUE;

  except
     on E: Exception do begin
        AddToLog_Vchasno(false, E.Message, true);
     end;
  end;
end;

//-------------------------------------------------------------------------------------------
// Ошибку отправить по почте + файл - вложение
procedure TMainForm.pSendReport_VchasnoEDI_err (MovementId_send_Edi: Integer;
                                                InvNumberPartner_order: String;
                                                OperDate_order : TDateTime;
                                                InvNumber_Parent: String;
                                                OperDatePartner_Parent : TDateTime;
                                                FromName,ToName,RetailName: String;
                                                lProcessName : String;
                                                lFileName_save : String;
                                                Error_txt : String
                                               );
begin
  FormParams.ParamByName('Subject_Email_report').Value:='Ошибка Вчасно <'+lProcessName+'> <'+RetailName+'>'
                                                      + ' Заявка № <'+InvNumberPartner_order+'> от <'+DateToStr(OperDate_order)+'>'
                                                      + ' Продажа № <'+InvNumber_Parent+'> от <'+DateToStr(OperDatePartner_Parent)+'> '
                                                      + ' ('+FromName+' -> '+ToName
                                                       ;
  FormParams.ParamByName('Body_Email_report').Value:=Error_txt;
  //
  actSMTPFile_Email_report.FileName:=lFileName_save;
  try actSMTPFile_Email_report.Execute;
      //
      FormParams.ParamByName('MovementId_Email_report').Value:=MovementId_send_Edi;
      spUpdateEdiSent_Email_report.Execute;
  except ON E: Exception DO
  Begin
     AddToLog_Vchasno(true, 'Ошибка при ошибка по почте :  ' + FormParams.ParamByName('Subject_Email_report').Value, true);
     AddToLog_Vchasno(true, '', true);
     AddToLog_Vchasno(true, lFileName_save, true);
     AddToLog_Vchasno(true, 'Error:', true);
     AddToLog_Vchasno(true, E.Message, true);
     AddToLog_Vchasno(true, '', true);
  End;
  end;
end;
//-------------------------------------------------------------------------------------------
function TMainForm.fEdi_SendData_to : Boolean;
var Err_str, lFileName_save: String;
    i : Integer;
begin
     if cbSend.Checked = FALSE then
     begin
          AddToLog('.....');
          AddToLog('ОТКЛЮЧИЛИ отправку в EDI');
          Result:= true;
          exit
     end;

     Result:= false;

     spSelectSend_toEDI.Execute;
     Send_toEDICDS.First;
     if Send_toEDICDS.RecordCount = 0 then
     begin
          AddToLog('.....');
          AddToLog('Нет отправки в EDI <' + IntToStr(Send_toEDICDS.RecordCount) + '>');

          Result:= true;
          exit
     end;

     AddToLog('.....');
     AddToLog('Началась отправка в EDI итого : <' + IntToStr(Send_toEDICDS.RecordCount) + '>');
     i:= 1;

     with Send_toEDICDS do
     while (not EOF) and ((gErr=FALSE) or (i<5)) do
     begin
          Application.ProcessMessages;
          //Документ продажа - отправка в EDI
          FormParams.ParamByName('MovementId_toEDI').Value   := FieldByName('Id').AsInteger;
          //Документ для отправки в EDI
          FormParams.ParamByName('MovementId_sendEDI').Value := FieldByName('MovementId').AsInteger;
          //
          Application.ProcessMessages;
          // Попробовали отправить
          try
              // EDIN
              if (FieldByName('isEdiOrdspr').AsBoolean  = true) and (FieldByName('isVchasnoEDI').AsBoolean  = false) then mactOrdspr.Execute;
              // EDIN
              if (FieldByName('isEdiDesadv').AsBoolean  = true) and (FieldByName('isVchasnoEDI').AsBoolean  = false) then mactDesadv.Execute;
              // EDIN
              if (FieldByName('isEdiInvoice').AsBoolean = true) and (FieldByName('isVchasnoEDI').AsBoolean  = false) then mactInvoice.Execute;
              // Ошибки по EDIN нет
              FormParams.ParamByName('Err_str_toEDI').Value := '';

              // Vchasno-Ordspr
              if (FieldByName('isEdiOrdspr').AsBoolean  = true) and (FieldByName('isVchasnoEDI').AsBoolean  = true)
               //and (1=0)
              then begin
                       lFileName_save:= 'VchasnoEDI_ORDRSP_'
                                        +FieldByName('InvNumber_Parent').AsString
                                        +' '
                                        +FormatDateTime('yyyy-mm-dd',FieldByName('OperDate_Parent').AsDateTime)
                                        +'.xml'
                                        ;
                       //
                       actExecPrintStoredProc.Execute;
                       if actVchasnoEDIOrdrsp.Execute
                       then actUpdateEdiOrdsprTrue.Execute
                       else begin
                            // Ошибку записать в базе
                            FormParams.ParamByName('Err_str_toEDI').Value := 'Ошибка при отправке';
                            // Ошибку показать в логе
                            AddToLog_Vchasno(true, 'Ошибка при отправке Ordspr Вчасно № :  <' + FieldByName('InvNumber_Parent').AsString + '> от' + DateToStr(FieldByName('OperDate_Parent').AsDateTime) + '>', true);
                            AddToLog_Vchasno(true, actVchasnoEDIOrdrsp.ErrorText.Value, true);
                            AddToLog_Vchasno(true, '', true);
                            //
                            // Ошибку отправить по почте + файл - вложение
                            if FieldByName('isOperDate_Sent').AsBoolean = TRUE
                            then
                                pSendReport_VchasnoEDI_err (FieldByName('MovementId').AsInteger
                                                           ,FieldByName('InvNumberPartner_order').AsString
                                                           ,FieldByName('OperDate_order').AsDateTime
                                                           ,FieldByName('InvNumber_Parent').AsString
                                                           ,FieldByName('OperDatePartner_Parent').AsDateTime
                                                           ,FieldByName('FromName').AsString
                                                           ,FieldByName('ToName').AsString
                                                           ,FieldByName('RetailName').AsString
                                                           ,'Ordspr'
                                                           ,lFileName_save
                                                           ,actVchasnoEDIOrdrsp.ErrorText.Value
                                                            );
                       end;
                       MyDelay_two(3000);
              end;

              // Vchasno-Desadv
              if (FieldByName('isEdiDesadv').AsBoolean  = true) and (FieldByName('isVchasnoEDI').AsBoolean  = true)
               //and (1=0)
              then begin
                       lFileName_save:= 'VchasnoEDI_DESADV_'
                                        +FieldByName('InvNumber_Parent').AsString
                                        +' '
                                        +FormatDateTime('yyyy-mm-dd',FieldByName('OperDate_Parent').AsDateTime)
                                        +'.xml'
                                        ;
                       //
                       actExecPrintStoredProc.Execute;
                       if actVchasnoEDIDesadv.Execute
                       then actUpdateEdiDesadvTrue.Execute
                       else begin
                            // Ошибку записать в базе
                            FormParams.ParamByName('Err_str_toEDI').Value := 'Ошибка при отправке';
                            // Ошибку показать в логе
                            AddToLog_Vchasno(true, 'Ошибка при отправке Desadv Вчасно № :  <' + FieldByName('InvNumber_Parent').AsString + '> от' + DateToStr(FieldByName('OperDate_Parent').AsDateTime) + '>', true);
                            AddToLog_Vchasno(true, actVchasnoEDIDesadv.ErrorText.Value, true);
                            AddToLog_Vchasno(true, '', true);
                            //
                            // Ошибку отправить по почте + файл - вложение
                            if FieldByName('isOperDate_Sent').AsBoolean = TRUE
                            then
                                pSendReport_VchasnoEDI_err (FieldByName('MovementId').AsInteger
                                                           ,FieldByName('InvNumberPartner_order').AsString
                                                           ,FieldByName('OperDate_order').AsDateTime
                                                           ,FieldByName('InvNumber_Parent').AsString
                                                           ,FieldByName('OperDatePartner_Parent').AsDateTime
                                                           ,FieldByName('FromName').AsString
                                                           ,FieldByName('ToName').AsString
                                                           ,FieldByName('RetailName').AsString
                                                           ,'Desadv'
                                                           ,lFileName_save
                                                           ,actVchasnoEDIOrdrsp.ErrorText.Value
                                                            );
                       end;
                       MyDelay_two(3000);
                       //
                       //еще отправка Декларация
                       if (FieldByName('isEdiQuality').AsBoolean  = true) and (FormParams.ParamByName('Err_str_toEDI').Value = '')
                        //and (1=0)
                       then begin
                            //Документ продажа
                            FormParams.ParamByName('MovementId_sale').Value := FieldByName('Id').AsInteger;
                            //
                            if mactVchasnoEDICONDRA.Execute
                            then actUpdateEdiCONDRATrue.Execute
                            else begin
                                  // Ошибку записать в базе
                                  FormParams.ParamByName('Err_str_toEDI').Value := 'Ошибка при отправке Декларация';
                                  // Ошибку показать в логе
                                  AddToLog_Vchasno(true, 'Ошибка при отправке CONDRA Вчасно № :  <' + FieldByName('InvNumber_Parent').AsString + '> от' + DateToStr(FieldByName('OperDate_Parent').AsDateTime) + '>', true);
                                  AddToLog_Vchasno(true, actVchasno_SendCondra.ErrorText.Value, true);
                                  AddToLog_Vchasno(true, '', true);
                             end;
                            //
                            MyDelay_two(3000);
                       end;
              end;

              // Vchasno - Delnot
              if (FieldByName('isEdiDelnot').AsBoolean  = true) and (FieldByName('isVchasnoEDI').AsBoolean  = true)
               //and (1=0)
              then begin
                       actExecPrintStoredProc.Execute;
                       if actVchasnoEDIDelnot.Execute
                       then actUpdateVchasnoEdiDelnotTrue.Execute
                       else begin
                            // Ошибку записать в базе
                            FormParams.ParamByName('Err_str_toEDI').Value := 'Ошибка при отправке';
                            // Ошибку показать в логе
                            AddToLog_Vchasno(true, 'Ошибка при отправке Delnot Вчасно № :  <' + FieldByName('InvNumber_Parent').AsString + '> от' + DateToStr(FieldByName('OperDate_Parent').AsDateTime) + '>', true);
                            AddToLog_Vchasno(true, actVchasnoEDIDelnot.ErrorText.Value, true);
                            AddToLog_Vchasno(true, '', true);
                       end;
              end;

              // Vchasno - Comdoc
              if (FieldByName('isEdiComdoc').AsBoolean  = true) and (FieldByName('isVchasnoEDI').AsBoolean  = true)
               //and (1=0)
              then begin
                       actExecPrintStoredProc.Execute;
                       if actVchasnoEDIComdoc.Execute
                       then actUpdateVchasnoEdiComdocTrue.Execute
                       else begin
                            // Ошибку записать в базе
                            FormParams.ParamByName('Err_str_toEDI').Value := 'Ошибка при отправке';
                            // Ошибку показать в логе
                            AddToLog_Vchasno(true, 'Ошибка при отправке Comdoc Вчасно № :  <' + FieldByName('InvNumber_Parent').AsString + '> от' + DateToStr(FieldByName('OperDate_Parent').AsDateTime) + '>', true);
                            AddToLog_Vchasno(true, actVchasnoEDIComdoc.ErrorText.Value, true);
                            AddToLog_Vchasno(true, '', true);
                       end;
              end;
              //
              Application.ProcessMessages;

              // Сохранили Log
              if FormParams.ParamByName('Err_str_toEDI').Value = ''
              then AddToLog('отправилось без ошибки № : <' + IntToStr(i) + '>');
              // Сохранили что отправка прошла
              actUpdate_EDI_Send.Execute;

          except
              FormParams.ParamByName('Err_str_toEDI').Value := 'Ошибка при отправке';
              //
              if (FieldByName('isEdiOrdspr').AsBoolean  = true) and (FieldByName('isVchasnoEDI').AsBoolean  = false) then AddToLog('isEdiOrdspr  =  <true>');
              if (FieldByName('isEdiDesadv').AsBoolean  = true) and (FieldByName('isVchasnoEDI').AsBoolean  = false) then AddToLog('isEdiDesadv  =  <true>');
              if (FieldByName('isEdiInvoice').AsBoolean = true) and (FieldByName('isVchasnoEDI').AsBoolean  = false) then AddToLog('isEdiInvoice =  <true>');
              //
              if (FieldByName('isEdiOrdspr').AsBoolean  = true) and (FieldByName('isVchasnoEDI').AsBoolean  = true) then AddToLog('isEdiVchasnoOrdspr  =  <true>');
              if (FieldByName('isEdiDesadv').AsBoolean  = true) and (FieldByName('isVchasnoEDI').AsBoolean  = true) then AddToLog('isEdiVchasnoDesadv  =  <true>');
              if (FieldByName('isEdiDesadv').AsBoolean  = true) and (FieldByName('isVchasnoEDI').AsBoolean  = true) then AddToLog('isEdiVchasnoComDoc  =  <true>');
              //
              AddToLog('Ошибка при отправке Id : <' + IntToStr(i) + '> <' + FieldByName('Id').AsString + '> № :');
              //
              Application.ProcessMessages;
              // Сохранили что ошибка
              actUpdate_EDI_Send.Execute;
          end;
          //
          if  (FieldByName('isVchasnoEDI').AsBoolean  = false)
           or (1=1)
          then AddToLog('завершен № : <' + IntToStr(i) + '> из <' + IntToStr(Send_toEDICDS.RecordCount) + '>');
          //
          Next;
          i:= i+1;
     end;

     AddToLog('Завершилась отправка в EDI : <' + IntToStr(i-1) + '> из <' + IntToStr(Send_toEDICDS.RecordCount) + '>');
     AddToLog('.....');

end;

function TMainForm.fSale_SendEmail : Boolean;
var Err_str: String;
    i : Integer;
begin
     if (cbEmail.Checked = FALSE)and (cbEmailExcel.Checked = FALSE) then
     begin
          AddToLog('.....');
          AddToLog('ОТКЛЮЧИЛИ отправку Email');
          Result:= true;
          exit
     end;

     Result:= false;

     spSelectSend_Email.ParamByName('inIsExcel').Value:= cbEmailExcel.Checked = TRUE;
     spSelectSend_Email.Execute;
     Send_EmailCDS.First;
     if Send_EmailCDS.RecordCount = 0 then
     begin
          AddToLog('.....');
          AddToLog('Нет отправки Email <' + IntToStr(Send_EmailCDS.RecordCount) + '>');

          Result:= true;
          exit
     end;

     AddToLog('.....');
     AddToLog('Началась отправка Email итого : <' + IntToStr(Send_EmailCDS.RecordCount) + '>');
     i:= 1;

     with Send_EmailCDS do
     while (not EOF) and ((gErr=FALSE) or (i<5)) do
     begin
          Application.ProcessMessages;
          FormParams.ParamByName('MovementId_sendEmail').Value := FieldByName('MovementId').AsInteger;
          Application.ProcessMessages;
          // Попробовали отправить
          try
              if FieldByName('ExportKindId').AsInteger = FieldByName('zc_Logistik41750857').AsInteger
              then mactExport_xls.Execute
              else
              if FieldByName('ExportKindId').AsInteger = FieldByName('zc_Nedavn2244900110').AsInteger
              then mactExport_xls_2244900110.Execute
              else mactExport.Execute;
              //
              Application.ProcessMessages;
              // Сохранили что отправка прошла
              AddToLog('отправилось без ошибки № : <' + IntToStr(i) + '> <' + FieldByName('MovementId').AsString + '> <' + FieldByName('InvNumber').AsString + '> <' + FieldByName('ToName').AsString + '> <' + FieldByName('OperDatePartner').AsString + '>' + '> <' + FieldByName('OperDate_protocol').AsString + '>');
          except
              // FormParams.ParamByName('Err_str_Email').Value := 'Ошибка при отправке';
              AddToLog('Ошибка при отправке № : <' + IntToStr(i) + '> <' + FieldByName('MovementId').AsString + '> <' + FieldByName('InvNumber').AsString + '> <' + FieldByName('ToName').AsString + '> <' + FieldByName('OperDatePartner').AsString + '>' + '> <' + FieldByName('OperDate_protocol').AsString + '>');
              //
              Application.ProcessMessages;
              // Сохранили что ошибка
              //actUpdate_Email_Send_err.Execute;
          end;
          //
          //AddToLog('завершен № : <' + IntToStr(i) + '> из <' + IntToStr(RecordCount) + '>');
          //
          Next;
          i:= i+1;
     end;

     AddToLog('Завершилась отправка Email : <' + IntToStr(i-1) + '> из <' + IntToStr(Send_EmailCDS.RecordCount) + '>');
     AddToLog('.....');

end;

procedure TMainForm.ProccessEDI;
var Present: TDateTime;
    Hour, Min, Sec, MSec: Word;
    IntervalStr: string;
begin
if ParamStr(1) <> 'alan_dp_ua' then exit;

  ActiveControl:= cbPrevDay;

  Present:=Now;
  DecodeTime(Present, Hour, Min, Sec, MSec);

  //если уже работает, повторно НЕ запускаем
  if Proccessing then
    Exit;

try
//  Timer.Enabled:=False;
  Proccessing := True;

  if (((Hour>=0) and (Hour<7)) or (Hour>=23))
  //and (1=0)
  then
  begin
       // !!! Только Отправка !!!
       fEdi_SendData_to;
       //
       //
       AddToLog('..... Нет Загрузки .....');
       Proccessing := False;
       //Timer.Enabled:=True;
       isPrevDay_begin := false;
       exit;
  end;

  //
  // !!! Только Загрузка EDI !!!
  gErr:= FALSE;
  try fEdi_LoadData_from;
  except
        on E: Exception do begin
           gErr:= Pos('--- ignore file',E.Message) = 0;
           AddToLog('**** Ошибка *** LoadData - from *** : ' + E.Message);
        end;
  end;
  // !!! Только Загрузка - VCHASNO !!!
  try fEdi_LoadDataVchasno_from;
  except
        on E: Exception do begin
           AddToLog_Vchasno(false, '**** Ошибка *** VCHASNO - LoadData - from *** : ' + E.Message, true);
        end;
  end;
  //
  // !!! Только Отправка !!!
  try fEdi_SendData_to;
  except
        on E: Exception do begin
           AddToLog('**** Ошибка *** SendData - to *** : ' + E.Message);
        end;
  end;
  //
  if gErr = TRUE then
  begin
      FIntervalVal := 0;
      AddToLog('Текущий интервал изменен до : ' + IntToStr(3) + ' сек.');
  end
  else
  if FindCmdLineSwitch('interval', IntervalStr) then
    FIntervalVal := StrToIntDef(IntervalStr, 1)
  else
    FIntervalVal := 1;

  if (Hour > 18) and (IntervalVal >= 1) then
  begin
    //Timer.Interval := (IntervalVal * 15)  * 60 * 1000;
    //AddToLog('Текущий интервал изменен до : ' + IntToStr(IntervalVal * 15) + ' мин.');
    Timer.Interval := 30  * 60 * 1000;
    AddToLog('Текущий интервал изменен до : ' + IntToStr(30) + ' мин.');
  end
  else
    if IntervalVal >= 1
    then
       Timer.Interval := (IntervalVal * 1)  * 60 * 1000
    else
       Timer.Interval := (3 * 1)  * 1 * 1000;

finally
  Proccessing := False;
//  Timer.Enabled:=True;
end;

end;

procedure TMainForm.ProccessEmail;
var Present: TDateTime;
    Hour, Min, Sec, MSec: Word;
    IntervalStr: string;
begin
if ParamStr(1) <> 'alan_dp_ua' then exit;

  ActiveControl:= cbPrevDay;
//exit;
  Present:=Now;
  DecodeTime(Present, Hour, Min, Sec, MSec);

  //если уже работает, повторно НЕ запускаем
  if ProccessingEmail then
    Exit;

  //если надо перезапустить
  if (Hour_onSendEmail >= 21) and (Hour >=4) then Hour_onSendEmail:= 0;


  //если уже сделали отправку Email, тогда не надо (отправляем каждые 2 часа)
  if (Hour_onSendEmail + 2 >= Hour) and (Hour_onSendEmail >= 0) then
    Exit;

try
  ProccessingEmail := True;
  //
  // !!! Только Отправка !!!
  try fSale_SendEmail;
      //запомнили текущий Hour кода сделали отправку Email
      Hour_onSendEmail:= Hour;
  except
        on E: Exception do begin
           AddToLog('**** Ошибка *** SendEmail *** : ' + E.Message);
        end;
  end;

finally
  ProccessingEmail := False;
end;

end;

procedure TMainForm.StartEDI;
begin
  AddToLog('Запуск ...');

  if IntervalVal > 0 then
  begin
    StartButton.Enabled:= FALSE;
    StopButton.Enabled := TRUE;
    //
    ProccessEDI;
    // Timer.Enabled := True;
  end
  else
    AddToLog('Запуск не выполнен, т.к. не определен интервал');
end;

procedure TMainForm.StopEDI;
begin
  if Timer.Enabled then
  begin
    while Proccessing do
      Application.ProcessMessages;

    Timer.Enabled := False;
    AddToLog('Остановка');
    //
    StartButton.Enabled:= TRUE;
    StopButton.Enabled := FALSE;
  end;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  try
    Timer.Enabled:= false;
    //
    ProccessEDI;
    //
    ProccessEmail;

  finally
    Timer.Enabled:= true;
  end;
end;

procedure TMainForm.TrayIconClick(Sender: TObject);
begin
  ShowWindow(Handle, SW_RESTORE);
  SetForegroundWindow(Handle);
end;

end.
