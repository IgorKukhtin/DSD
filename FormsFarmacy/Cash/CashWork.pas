unit CashWork;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, CashInterface, DB, Buttons, Datasnap.DBClient,
  Gauges, cxGraphics, cxControls, cxLookAndFeels, DateUtils,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, cxCurrencyEdit,
  cxClasses, cxPropertiesStore, dsdAddOn, dxSkinsCore, dxSkinsDefaultPainters,
  dsdDB, Vcl.Menus;

type
  TCashWorkForm = class(TForm)
    ceInputOutput: TcxCurrencyEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    BitBtn1: TBitBtn;
    laRest: TLabel;
    Button5: TButton;
    btDeleteAllArticul: TButton;
    Gauge: TGauge;
    Button6: TButton;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    Button7: TButton;
    btInfo: TButton;
    spGet_Money_CashRegister: TdsdStoredProc;
    PopupMenuInfo: TPopupMenu;
    pmZReportInfo: TMenuItem;
    pmCheckSum: TMenuItem;
    pmGetDate: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button5Click(Sender: TObject);
    procedure btDeleteAllArticulClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure btInfoClick(Sender: TObject);
    procedure pmZReportInfoClick(Sender: TObject);
    procedure pmCheckSumClick(Sender: TObject);
    procedure pmGetDateClick(Sender: TObject);
  private
    m_Cash: ICash;
    m_DataSet: TDataSet;
    m_ZReportName: string;
  public
    constructor Create(Cash: ICash; DataSet: TDataSet; ZReportName: string);

    procedure SaveZReport(AFileName, AText, AFiscalNumber : string;
                          AZReport : Integer; ASummaCash, ASummaCard : Currency);
  end;

implementation

{$R *.dfm}

  uses CommonData, EmployeeWorkLog, PUSHMessage, LocalWorkUnit, MainCash2;

function CheckZReportLogCDS : boolean;
  var ZReportLogCDS : TClientDataSet;
begin
  Result := FileExists(ZReportLog_lcl);
  if Result then Exit;
  ZReportLogCDS :=  TClientDataSet.Create(Nil);
  try
    try
      ZReportLogCDS.FieldDefs.Add('ZReport', ftInteger);
      ZReportLogCDS.FieldDefs.Add('FiscalNumber', ftString, 20);
      ZReportLogCDS.FieldDefs.Add('Date', ftDateTime);
      ZReportLogCDS.FieldDefs.Add('SummaCash', ftCurrency);
      ZReportLogCDS.FieldDefs.Add('SummaCard', ftCurrency);
      ZReportLogCDS.FieldDefs.Add('UserId', ftInteger);
      ZReportLogCDS.FieldDefs.Add('isSend', ftBoolean);
      ZReportLogCDS.CreateDataSet;
      SaveLocalData(ZReportLogCDS, ZReportLog_lcl);
      Result := True;
    Except ON E:Exception do
      ShowMessage('Ошибка создания файла данных по Z отчетам:'#13#10 + E.Message);
    end;
  finally
    if ZReportLogCDS.Active then ZReportLogCDS.Close;
    ZReportLogCDS.Free;
  end;
end;

{ TCashWorkForm }

constructor TCashWorkForm.Create(Cash: ICash; DataSet: TDataSet; ZReportName: string);
begin
  inherited Create(nil);
  m_Cash:= Cash;
  m_DataSet:= DataSet;
  m_ZReportName:= ZReportName;
  if (m_ZReportName <> '') and (Copy(m_ZReportName, Length(m_ZReportName), 1) <> ' ') then m_ZReportName := m_ZReportName + ' ';
end;

procedure TCashWorkForm.Button1Click(Sender: TObject);
begin
  if ceInputOutput.Value <= 0 then
  begin
    ShowMessage('Сумма должна быть больше нуля...');
    Exit;
  end;

  if TButton(Sender).Tag = 0 then
    m_Cash.CashInputOutput(ceInputOutput.Value)
  else m_Cash.CashInputOutput(- ceInputOutput.Value);
end;

procedure TCashWorkForm.Button2Click(Sender: TObject);
var cFiscalNumber, cSerialNumber, cJuridicalName : String;
    cZReport : Integer; nSummaCash, nSummaCard : Currency;

begin

  if not gc_User.Local then
  try
    spGet_Money_CashRegister.ParamByName('inCashRegisterName').Value := m_Cash.FiscalNumber;
    spGet_Money_CashRegister.ParamByName('inZReport').Value := m_Cash.ZReport;
    spGet_Money_CashRegister.ParamByName('inCheckOut').Value := m_Cash.ReceiptsSales;
    spGet_Money_CashRegister.ParamByName('inCheckIn').Value := m_Cash.ReceiptsReturn;
    spGet_Money_CashRegister.ParamByName('outSummsCash').Value := 0;
    spGet_Money_CashRegister.ParamByName('outSummsCard').Value := 0;
    spGet_Money_CashRegister.Execute;

    if (spGet_Money_CashRegister.ParamByName('outSummsCash').AsFloat <> m_Cash.SummaCash)
      or (spGet_Money_CashRegister.ParamByName('outSummsCard').AsFloat <> m_Cash.SummaCard) then
      if not ShowPUSHMessage('Проверьте суммы за день по X отчётe с суммами в программе.'#13#13 +
                             'Сумма по РРО нал   : ' + FormatCurr(',0.00', m_Cash.SummaCash) + #13 +
                             'Сумма по РРО карта : ' + FormatCurr(',0.00', m_Cash.SummaCard) + #13 +
                             'Сумма по РРО итого : ' + FormatCurr(',0.00', m_Cash.SummaCash + m_Cash.SummaCard) + #13#13 +
                             'Сумма по программе нал  : ' + FormatCurr(',0.00', spGet_Money_CashRegister.ParamByName('outSummsCash').AsFloat) + #13 +
                             'Сумма по программе карта: ' + FormatCurr(',0.00', spGet_Money_CashRegister.ParamByName('outSummsCard').AsFloat) + #13 +
                             'Сумма по программе итого: ' + FormatCurr(',0.00', spGet_Money_CashRegister.ParamByName('outSummsCash').AsFloat + spGet_Money_CashRegister.ParamByName('outSummsCard').AsFloat)) then Exit;
  except
  end;

  if MessageDlg('Вы уверены в снятии Z-отчета?', mtInformation, mbOKCancel, 0) = mrOk then
  begin
     cFiscalNumber := m_Cash.FiscalNumber;
     cSerialNumber := m_Cash.SerialNumber;
     cJuridicalName := m_Cash.JuridicalName;
     cZReport := m_Cash.ZReport;
     nSummaCash := m_Cash.SummaCash;
     nSummaCard := m_Cash.SummaCard;

     if m_Cash.SensZReportBefore then
       SaveZReport(StringReplace(cJuridicalName, '"', '', [rfReplaceAll]) + ' ' +
                   m_ZReportName + FormatDateTime('DD.MM.YY', Date) + ' ФН' +
                   cFiscalNumber  + ' №' + IntToStr(cZReport), m_Cash.InfoZReport,
                   cFiscalNumber, cZReport, nSummaCash, nSummaCard);
     m_Cash.ClosureFiscal;
     if not m_Cash.SensZReportBefore then
       SaveZReport(StringReplace(cJuridicalName, '"', '', [rfReplaceAll]) + ' ' +
                   m_ZReportName + FormatDateTime('DD.MM.YY', Date) + ' ФН' +
                   cFiscalNumber  + ' №' + IntToStr(cZReport), m_Cash.InfoZReport,
                   cFiscalNumber, cZReport, nSummaCash, nSummaCard);
     EmployeeWorkLog_ZReport;
     if not gc_User.Local and (cSerialNumber <> '') then
     try
       MainCashForm.spUpdate_CashSerialNumber.ParamByName('inFiscalNumber').Value := cFiscalNumber;
       MainCashForm.spUpdate_CashSerialNumber.ParamByName('inSerialNumber').Value := cSerialNumber;
       MainCashForm.spUpdate_CashSerialNumber.Execute;
     except on E: Exception do Add_Log('Exception: ' + E.Message);
     end;
  end;
end;

procedure TCashWorkForm.Button3Click(Sender: TObject);
begin
  if MainCashForm.UnitConfigCDS.FieldByName('isSetDateRRO').AsBoolean then
  begin
//    m_Cash.SetTime;
    if Abs(MinutesBetween(m_Cash.GetTime, Now)) > 2 then
    begin
      ShowMessage('Переведите время на РРО через FPWINX.');
      Exit;
    end;
  end;

  m_Cash.PrintZeroReceipt;
end;

procedure TCashWorkForm.Button4Click(Sender: TObject);
var i: integer;
    RecordCountStr: string;
    CategoriesId: string;
begin
  with m_DataSet do
  begin
    First;
    i:=1;
    RecordCountStr:= IntToStr(RecordCount);
    while not EOF do
    begin
      try
        m_Cash.DeleteArticules(FieldByName('Code').AsInteger);
      except
      end;
      m_Cash.ProgrammingGoods(FieldByName('Code').AsInteger, FieldByName('FullName').asString,
                              FieldByName('LastPrice').asFloat, FieldByName('NDS').asFloat);
      Application.ProcessMessages;
      laRest.Caption:=IntToStr(i)+' из '+RecordCountStr;
      inc(i);
      Next;
    end;
  end;
end;

procedure TCashWorkForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree
end;

procedure TCashWorkForm.pmCheckSumClick(Sender: TObject);
begin
    spGet_Money_CashRegister.ParamByName('inCashRegisterName').Value := m_Cash.FiscalNumber;
    spGet_Money_CashRegister.ParamByName('inZReport').Value := m_Cash.ZReport;
    spGet_Money_CashRegister.ParamByName('inCheckOut').Value := m_Cash.ReceiptsSales;
    spGet_Money_CashRegister.ParamByName('inCheckIn').Value := m_Cash.ReceiptsReturn;
    spGet_Money_CashRegister.ParamByName('outSummsCash').Value := 0;
    spGet_Money_CashRegister.ParamByName('outSummsCard').Value := 0;
    spGet_Money_CashRegister.Execute;

    ShowPUSHMessage('Сравнение суммы за день по X отчётe с суммами в программе.'#13#13 +
      'Сумма по РРО нал   : ' + FormatCurr(',0.00', m_Cash.SummaCash) + #13 +
      'Сумма по РРО карта : ' + FormatCurr(',0.00', m_Cash.SummaCard) + #13 +
      'Сумма по РРО итого : ' + FormatCurr(',0.00', m_Cash.SummaCash + m_Cash.SummaCard) + #13#13 +
      'Сумма по программе нал  : ' + FormatCurr(',0.00', spGet_Money_CashRegister.ParamByName('outSummsCash').AsFloat) + #13 +
      'Сумма по программе карта: ' + FormatCurr(',0.00', spGet_Money_CashRegister.ParamByName('outSummsCard').AsFloat) + #13 +
      'Сумма по программе итого: ' + FormatCurr(',0.00', spGet_Money_CashRegister.ParamByName('outSummsCash').AsFloat + spGet_Money_CashRegister.ParamByName('outSummsCard').AsFloat));

end;

procedure TCashWorkForm.pmGetDateClick(Sender: TObject);
begin
  ShowMessage(FormatDateTime('dd.mm.yyyy hh:nn', m_Cash.GetTime));
end;

procedure TCashWorkForm.pmZReportInfoClick(Sender: TObject);
begin
  ShowMessage(m_Cash.InfoZReport);
end;

procedure TCashWorkForm.Button5Click(Sender: TObject);
begin
  if MessageDlg('Вы уверены в снятии X-отчета?', mtInformation, mbOKCancel, 0) = mrOk then
     m_Cash.XReport;
end;

procedure TCashWorkForm.Button6Click(Sender: TObject);
begin
  m_Cash.SetTime
end;

procedure TCashWorkForm.btInfoClick(Sender: TObject);
var
  APoint: TPoint;
begin
  APoint := btInfo.ClientToScreen(Point(0, btInfo.ClientHeight));
  PopupMenuInfo.Popup(APoint.X, APoint.Y);
end;

procedure TCashWorkForm.btDeleteAllArticulClick(Sender: TObject);
var i: integer;
begin
   m_Cash.DeleteArticules(0);
{   Gauge.MinValue:=1;
   Gauge.MaxValue:=14000;
   for i:=1 to 14000 do begin
     Gauge.Progress:=i;
   end;}
   m_Cash.ClearArticulAttachment;
   ShowMessage('Артикулы удалены')
  {}
end;

procedure TCashWorkForm.SaveZReport(AFileName, AText, AFiscalNumber : string;
                                    AZReport : Integer; ASummaCash, ASummaCard : Currency);
  var F: TextFile; cName : string; nUserId : Integer; ZReportLogCDS: TClientDataSet;
begin
  try
    if not ForceDirectories(ExtractFilePath(Application.ExeName) + 'ZRepot') then
    begin
      ShowMessage('Ошибка создания директории для сохранения Электронной формы z отчёта. Покажите это окно системному администратору...');
      Exit;
    end;

    cName := ExtractFilePath(Application.ExeName) + 'ZRepot\' + AFileName + '.txt';

    try
      if FileExists(cName) then DeleteFile(cName);
      AssignFile(F,cName);
      Rewrite(F);

      Writeln(F, AText);
    finally
      Flush(F);
      CloseFile(F);
    end;
    PostMessage(HWND_BROADCAST, FM_SERVISE, 2, 5);
  except on E: Exception do
    ShowMessage('Ошибка сохранения Электронной формы z отчёта. Покажите это окно системному администратору: ' + #13#10 + E.Message);
  end;

  if CheckZReportLogCDS then
  begin
    if not TryStrToInt(gc_User.Session, nUserId) then nUserId := 0;

    ZReportLogCDS :=  TClientDataSet.Create(Nil);
    WaitForSingleObject(MutexZReportLog, INFINITE);
    try
      try
        LoadLocalData(ZReportLogCDS, ZReportLog_lcl, False);
        if not ZReportLogCDS.Active then
        begin
          DeleteLocalData(ZReportLog_lcl);
          CheckZReportLogCDS;
          LoadLocalData(ZReportLogCDS, ZReportLog_lcl);
        end;

        ZReportLogCDS.Append;
        ZReportLogCDS.FieldByName('ZReport').AsInteger := AZReport;
        ZReportLogCDS.FieldByName('FiscalNumber').AsString := AFiscalNumber;
        ZReportLogCDS.FieldByName('Date').AsDateTime := Now;
        ZReportLogCDS.FieldByName('SummaCash').AsCurrency := ASummaCash;
        ZReportLogCDS.FieldByName('SummaCard').AsCurrency := ASummaCard;
        ZReportLogCDS.FieldByName('UserId').AsInteger := nUserId;
        ZReportLogCDS.FieldByName('isSend').AsBoolean := False;
        ZReportLogCDS.Post;

        SaveLocalData(ZReportLogCDS, ZReportLog_lcl);
      Except ON E:Exception do
        ShowMessage('Ошибка сохранения данных по Z отчетам:'#13#10 + E.Message);
      end;
    finally
      ReleaseMutex(MutexZReportLog);
      ZReportLogCDS.Free;
        // отправка сообщения о необходимости отправки
      PostMessage(HWND_BROADCAST, FM_SERVISE, 2, 6);
    end;
  end;
end;

end.
