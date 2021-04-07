unit CashWork;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, CashInterface, DB, Buttons,
  Gauges, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, cxCurrencyEdit,
  cxClasses, cxPropertiesStore, dsdAddOn, dxSkinsCore, dxSkinsDefaultPainters,
  dsdDB;

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
    Button8: TButton;
    spGet_Money_CashRegister: TdsdStoredProc;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button5Click(Sender: TObject);
    procedure btDeleteAllArticulClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    m_Cash: ICash;
    m_DataSet: TDataSet;
    m_ZReportName: string;
  public
    constructor Create(Cash: ICash; DataSet: TDataSet; ZReportName: string);

    procedure SaveZReport(AFileName, AText : string);
  end;

implementation

{$R *.dfm}

  uses CommonData, EmployeeWorkLog, PUSHMessage, MainCash2;

{ TCashWorkForm }

constructor TCashWorkForm.Create(Cash: ICash; DataSet: TDataSet; ZReportName: string);
begin
  inherited Create(nil);
  m_Cash:= Cash;
  m_DataSet:= DataSet;
  m_ZReportName:= ZReportName;
  if (m_ZReportName <> '') and (Copy(m_ZReportName, Length(m_ZReportName) - 1, 1) <> ' ') then m_ZReportName := m_ZReportName + ' ';
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
begin

//  if not gc_User.Local then
//  try
//    spGet_Money_CashRegister.ParamByName('inCashRegisterName').Value := m_Cash.FiscalNumber;
//    spGet_Money_CashRegister.ParamByName('inCheckOut').Value := m_Cash.ReceiptsSales;
//    spGet_Money_CashRegister.ParamByName('inCheckIn').Value := m_Cash.ReceiptsReturn;
//    spGet_Money_CashRegister.ParamByName('outSummsCash').Value := 0;
//    spGet_Money_CashRegister.Execute;
//
//    if spGet_Money_CashRegister.ParamByName('outSummsCash').AsFloat <> m_Cash.SummaCash then
//      ShowPUSHMessage('Проверьте суммы за день по X отчётe с суммами в программе.'#13#13 +
//        'Сумма по РРО : ' + FormatCurr(',0.00', m_Cash.SummaCash) + #13#13 +
//        'Сумма по программе: ' + FormatCurr(',0.00', spGet_Money_CashRegister.ParamByName('outSummsCash').AsFloat));
//  except
//  end;

  if MessageDlg('Вы уверены в снятии Z-отчета?', mtInformation, mbOKCancel, 0) = mrOk then
  begin
     if m_Cash.SensZReportBefore then
       SaveZReport(StringReplace(m_Cash.JuridicalName, '"', '', [rfReplaceAll]) + ' ' +
                   m_ZReportName + FormatDateTime('DD.MM.YY', Date) + ' ФН' +
                   m_Cash.FiscalNumber  + ' №' + IntToStr(m_Cash.ZReport), m_Cash.InfoZReport);
     m_Cash.ClosureFiscal;
     if not m_Cash.SensZReportBefore then
       SaveZReport(StringReplace(m_Cash.JuridicalName, '"', '', [rfReplaceAll]) + ' ' +
                   m_ZReportName + FormatDateTime('DD.MM.YY', Date) + ' ФН' +
                   m_Cash.FiscalNumber  + ' №' + IntToStr(m_Cash.ZReport), m_Cash.InfoZReport);
     EmployeeWorkLog_ZReport;
     if not gc_User.Local then
     try
       MainCashForm.spUpdate_CashSerialNumber.ParamByName('inFiscalNumber').Value := m_Cash.FiscalNumber;
       MainCashForm.spUpdate_CashSerialNumber.ParamByName('inSerialNumber').Value := m_Cash.SerialNumber;
       MainCashForm.spUpdate_CashSerialNumber.Execute;
     except on E: Exception do Add_Log('Exception: ' + E.Message);
     end;
  end;
end;

procedure TCashWorkForm.Button3Click(Sender: TObject);
begin
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

procedure TCashWorkForm.Button5Click(Sender: TObject);
begin
  if MessageDlg('Вы уверены в снятии X-отчета?', mtInformation, mbOKCancel, 0) = mrOk then
     m_Cash.XReport;
end;

procedure TCashWorkForm.Button6Click(Sender: TObject);
begin
  m_Cash.SetTime
end;

procedure TCashWorkForm.Button8Click(Sender: TObject);
begin
  ShowMessage(m_Cash.InfoZReport);
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

procedure TCashWorkForm.SaveZReport(AFileName, AText : string);
  var F: TextFile; cName : string;
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
end;

end.
