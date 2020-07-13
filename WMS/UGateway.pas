unit UGateway;

interface

uses
  System.Classes,
  System.SysUtils,
  UData;

type
  TThreadHelper = class helper for TThread
  public
    function WaitFor(ATimeout: Cardinal): LongWord;
  end;

  TImporterThread = class(TWorkerThread)
  protected
    procedure Execute; override;
  end;

  TExporterThread = class(TWorkerThread)
  strict private
    FExpThreadCount: Integer;
  strict private
    function SendReferences: Boolean; // передача всех справочников
    procedure SendIncoming_ASNLoad;
    procedure SendOrder;
    procedure OnOrderTerminate(Sender: TObject); // окончание работы потоков ASNLoad и Order
    procedure OnSendReferencesTerminate(Sender: TObject); // окончание работы потоков отправки Справочников
  protected
    procedure Execute; override;
  end;

implementation

uses
  Winapi.Windows,
  System.StrUtils,
  UDefinitions,
  UConstants,
  USettings;

{ TExporterThread }

procedure TExporterThread.Execute;
var
  Interval: Integer;
begin
  inherited;

  {$REGION 'Начало выполнения ExporterThread'}
  InnerMsgProc('Начало выполнения ExporterThread');
  {$ENDREGION}

{
     получение данных из WMS идет постоянно, не зависит от экспорта, выполняется в потоке TImporterThread

     схема экспорта:
     1) отправка справочников в WMS - в первую очередь (остальные в очереди на отправку ждут этот процесс)
     2) потом две ветки (которые могут работать параллельно)
          2.1 - сначала Incoming - потом ASN_Load
          2.2 - Ордер
     3) по завершении экспорта прочитать ошибки
}

  while not Terminated do
  begin
    {$REGION 'Старт нового цикла экспорта данных'}
    InnerMsgProc('Старт нового цикла экспорта данных. Интервал ' + IntToStr(TSettings.GatewayIntervalMinute) + ' минут');
    {$ENDREGION}

    // 1) отправка справочников в WMS - в первую очередь
    {$REGION 'Старт экспорта справочников'}InnerMsgProc('Старт экспорта справочников');{$ENDREGION}
    if not SendReferences then
    begin
      Sleep(c1Sec * 10);
      {$REGION 'Cправочники не были отправлены'}InnerMsgProc('Cправочники не были отправлены');{$ENDREGION}
      Continue; // если отправка справочников завершилась неудачей, пробуем снова
    end;
    {$REGION 'Cправочники отправлены'}InnerMsgProc('Cправочники отправлены');{$ENDREGION}

    // 2.1 - сначала Incoming - потом ASN_Load
    if not Terminated then
      SendIncoming_ASNLoad;

    // 2.2 - Ордер
    {$REGION 'Старт экспорта Ордер'}InnerMsgProc('Старт экспорта Ордер');{$ENDREGION}
    if not Terminated then
      SendOrder;

    // 3) по завершении экспорта прочитать ошибки
    //   завершение экспорта определяется в методе 'OnOrderTerminate' - когда
    //   SendIncoming_ASNLoad и SendOrder завершили свою работу, тогда запускается TProcessExportDataErrorThread

    Interval := TSettings.GatewayIntervalMinute * c1Minute; // 3 минуты * 60000 => 180000 мсек
    MySleep(Interval);
  end;

  {$REGION 'Окончание выполнения ExporterThread'}
  InnerMsgProc('Окончание выполнения ExporterThread' + #13#10 + DupeString('-', 100) + #13#10);
  {$ENDREGION}
end;

procedure TExporterThread.OnOrderTerminate(Sender: TObject);
var
  lngResponse: LongWord;
  errThread: TProcessExportDataErrorThread;
begin
  InterlockedDecrement(FExpThreadCount);
  InnerMsgProc('Завершен экспорт ' + (Sender as TExportWorkerThread).PacketName);

  if FExpThreadCount <= 0 then
  begin
    // 3) по завершении экспорта прочитать ошибки
    {$REGION 'Старт чтения ошибок экспорта'}InnerMsgProc('Старт чтения ошибок экспорта');{$ENDREGION}
    InterlockedExchange(FExpThreadCount, 0);

    if not Terminated then
    begin
      errThread := TProcessExportDataErrorThread.Create(cCreateRunning, FMsgProc);
      lngResponse := errThread.WaitFor(c1Minute * 2);

      case lngResponse of
        WAIT_OBJECT_0: InnerMsgProc('Ошибки экспорта прочитаны');
        WAIT_TIMEOUT:  InnerMsgProc('Ошибки экспорта прочитаны не все. Поток чтения ошибок завершился по таймауту.');
      else
                       InnerMsgProc('Ошибки экспорта не прочитаны. Возникла ошибка в процессе чтения.');
      end;
    end;
  end;
end;

procedure TExporterThread.OnSendReferencesTerminate(Sender: TObject);
begin
//  InnerMsgProc('Завершен экспорт ' + (Sender as TExportWorkerThread).PacketName);
end;

procedure TExporterThread.SendIncoming_ASNLoad;
var
  tmpData: TExportData;
  expThread: TExportWorkerThread;
begin
  with tmpData do
  begin
    ThresholdRecCount := 0;
    UseRecCount := False;
    UseDebug    := False;
    LogSqlProc  := nil;
    ShowSqlProc := nil;
    ShowMsgProc := FMsgProc;
  end;

  {$REGION 'Старт экспорта Incoming'}InnerMsgProc('Старт экспорта Incoming');{$ENDREGION}
  // сначала Incoming
  expThread := TExportWorkerThread.Create(cCreateRunning, tmpData, pknWmsMovementIncoming, FMsgProc);

  // теперь ASN_Load после успешного выполнения Incoming
  if expThread.WaitFor(c1Minute) = WAIT_OBJECT_0 then
  begin
    {$REGION 'Incoming отправлен'}InnerMsgProc('Incoming отправлен');{$ENDREGION}
    Sleep(c1Sec * 2); // ждем 2 секунды после завершения Incoming
    {$REGION 'Старт экспорта ASN_Load'}InnerMsgProc('Старт экспорта ASN_Load');{$ENDREGION}
    Inc(FExpThreadCount);
    expThread := TExportWorkerThread.Create(cCreateSuspended, tmpData, pknWmsMovementASNLoad, FMsgProc);
    expThread.OnTerminate := OnOrderTerminate;
    expThread.Start;
  end
  else
    {$REGION 'Incoming не был отправлен'}InnerMsgProc('Incoming не был отправлен');{$ENDREGION}
end;

procedure TExporterThread.SendOrder;
var
  tmpData: TExportData;
  expThread: TExportWorkerThread;
begin
  with tmpData do
  begin
    ThresholdRecCount := 0;
    UseRecCount := False;
    UseDebug    := False;
    LogSqlProc  := nil;
    ShowSqlProc := nil;
    ShowMsgProc := FMsgProc;
  end;

  Inc(FExpThreadCount);
  expThread := TExportWorkerThread.Create(cCreateSuspended, tmpData, pknWmsMovementOrder, FMsgProc);
  expThread.OnTerminate := OnOrderTerminate;
  expThread.Start;
end;

function TExporterThread.SendReferences: Boolean;
var
  I: Integer;
  sMsg: string;
  tmpData: TExportData;
  expThread: TExportWorkerThread;
const
  cSent = 'Переданы данные справочника %s';
  cSendFail = 'Не удалось передать справочник %s';
  cSKU: array[0..5] of TPacketKind = (pknWmsObjectSKU, pknWmsObjectSKUCode, pknWmsObjectSKUGroup,
                                      pknWmsObjectClient, pknWmsObjectPack, pknWmsObjectUser);
begin
  Result := False;

  with tmpData do
  begin
    ThresholdRecCount := 0;
    UseRecCount := False;
    UseDebug    := False;
    LogSqlProc  := nil;
    ShowSqlProc := nil;
    ShowMsgProc := FMsgProc;
  end;

  {TODO: возможное изменение реализации. Вместо передачи справочников по очереди использовать
         WaitForMultipleObjects - запустить все потоки и ждать их завершения.
         Минус такого решения - невозможно прервать ожидание в случае Terminated }


  // передача всех справочников по очереди с проверкой результата операции
  for I := Low(cSKU) to High(cSKU) do
  begin
    if Terminated then Exit;

    Sleep(100);

    expThread := TExportWorkerThread.Create(cCreateSuspended, tmpData, cSKU[I], FMsgProc);
    expThread.OnTerminate := OnSendReferencesTerminate;
    expThread.Start;

    Result := expThread.WaitFor(c1Minute) = WAIT_OBJECT_0;

    if Result
    then sMsg := cSent
    else sMsg := cSendFail;

    sMsg := Format(sMsg, [expThread.PacketName]);
    InnerMsgProc(sMsg);

    if not Result then Exit;
  end;
end;



{ TImporterThread }

procedure TImporterThread.Execute;
var
  Interval: Integer;
begin
  inherited;

  {$REGION 'Начало выполнения ImporterThread'}
  InnerMsgProc('Начало выполнения ImporterThread');
  {$ENDREGION}

  while not Terminated do
  begin
    {$REGION 'Старт нового цикла импорта данных'}
    InnerMsgProc('Старт нового цикла импорта данных. Интервал ' + IntToStr(TSettings.GatewayIntervalMinute) + ' минут');
    {$ENDREGION}
    // при создании потока используй FMsgProc, а не InnerMsgProc.
    // FMsgProc указывает на callback-процедуру обработки сообщений, которая определена в классе, создающем этот поток.
    TImportWorkerThread.Create(cCreateRunning, pknOrderStatusChanged, FMsgProc);
    Sleep(100);
    TImportWorkerThread.Create(cCreateRunning, pknReceivingResult, FMsgProc);

    Interval := TSettings.GatewayIntervalMinute * c1Minute; // 3 минуты * 60000 => 180000 мсек
    MySleep(Interval);
  end;

  {$REGION 'Окончание выполнения ImporterThread'}
  InnerMsgProc('Окончание выполнения ImporterThread' + #13#10 + DupeString('-', 100) + #13#10);
  {$ENDREGION}
end;


{ TThreadHelper }

function TThreadHelper.WaitFor(ATimeout: Cardinal): LongWord;
begin
  Result := WaitForSingleObject(Handle, ATimeout);
end;

end.
