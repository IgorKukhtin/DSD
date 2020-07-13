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
    function SendReferences: Boolean; // �������� ���� ������������
    procedure SendIncoming_ASNLoad;
    procedure SendOrder;
    procedure OnOrderTerminate(Sender: TObject); // ��������� ������ ������� ASNLoad � Order
    procedure OnSendReferencesTerminate(Sender: TObject); // ��������� ������ ������� �������� ������������
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

  {$REGION '������ ���������� ExporterThread'}
  InnerMsgProc('������ ���������� ExporterThread');
  {$ENDREGION}

{
     ��������� ������ �� WMS ���� ���������, �� ������� �� ��������, ����������� � ������ TImporterThread

     ����� ��������:
     1) �������� ������������ � WMS - � ������ ������� (��������� � ������� �� �������� ���� ���� �������)
     2) ����� ��� ����� (������� ����� �������� �����������)
          2.1 - ������� Incoming - ����� ASN_Load
          2.2 - �����
     3) �� ���������� �������� ��������� ������
}

  while not Terminated do
  begin
    {$REGION '����� ������ ����� �������� ������'}
    InnerMsgProc('����� ������ ����� �������� ������. �������� ' + IntToStr(TSettings.GatewayIntervalMinute) + ' �����');
    {$ENDREGION}

    // 1) �������� ������������ � WMS - � ������ �������
    {$REGION '����� �������� ������������'}InnerMsgProc('����� �������� ������������');{$ENDREGION}
    if not SendReferences then
    begin
      Sleep(c1Sec * 10);
      {$REGION 'C���������� �� ���� ����������'}InnerMsgProc('C���������� �� ���� ����������');{$ENDREGION}
      Continue; // ���� �������� ������������ ����������� ��������, ������� �����
    end;
    {$REGION 'C���������� ����������'}InnerMsgProc('C���������� ����������');{$ENDREGION}

    // 2.1 - ������� Incoming - ����� ASN_Load
    if not Terminated then
      SendIncoming_ASNLoad;

    // 2.2 - �����
    {$REGION '����� �������� �����'}InnerMsgProc('����� �������� �����');{$ENDREGION}
    if not Terminated then
      SendOrder;

    // 3) �� ���������� �������� ��������� ������
    //   ���������� �������� ������������ � ������ 'OnOrderTerminate' - �����
    //   SendIncoming_ASNLoad � SendOrder ��������� ���� ������, ����� ����������� TProcessExportDataErrorThread

    Interval := TSettings.GatewayIntervalMinute * c1Minute; // 3 ������ * 60000 => 180000 ����
    MySleep(Interval);
  end;

  {$REGION '��������� ���������� ExporterThread'}
  InnerMsgProc('��������� ���������� ExporterThread' + #13#10 + DupeString('-', 100) + #13#10);
  {$ENDREGION}
end;

procedure TExporterThread.OnOrderTerminate(Sender: TObject);
var
  lngResponse: LongWord;
  errThread: TProcessExportDataErrorThread;
begin
  InterlockedDecrement(FExpThreadCount);
  InnerMsgProc('�������� ������� ' + (Sender as TExportWorkerThread).PacketName);

  if FExpThreadCount <= 0 then
  begin
    // 3) �� ���������� �������� ��������� ������
    {$REGION '����� ������ ������ ��������'}InnerMsgProc('����� ������ ������ ��������');{$ENDREGION}
    InterlockedExchange(FExpThreadCount, 0);

    if not Terminated then
    begin
      errThread := TProcessExportDataErrorThread.Create(cCreateRunning, FMsgProc);
      lngResponse := errThread.WaitFor(c1Minute * 2);

      case lngResponse of
        WAIT_OBJECT_0: InnerMsgProc('������ �������� ���������');
        WAIT_TIMEOUT:  InnerMsgProc('������ �������� ��������� �� ���. ����� ������ ������ ���������� �� ��������.');
      else
                       InnerMsgProc('������ �������� �� ���������. �������� ������ � �������� ������.');
      end;
    end;
  end;
end;

procedure TExporterThread.OnSendReferencesTerminate(Sender: TObject);
begin
//  InnerMsgProc('�������� ������� ' + (Sender as TExportWorkerThread).PacketName);
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

  {$REGION '����� �������� Incoming'}InnerMsgProc('����� �������� Incoming');{$ENDREGION}
  // ������� Incoming
  expThread := TExportWorkerThread.Create(cCreateRunning, tmpData, pknWmsMovementIncoming, FMsgProc);

  // ������ ASN_Load ����� ��������� ���������� Incoming
  if expThread.WaitFor(c1Minute) = WAIT_OBJECT_0 then
  begin
    {$REGION 'Incoming ���������'}InnerMsgProc('Incoming ���������');{$ENDREGION}
    Sleep(c1Sec * 2); // ���� 2 ������� ����� ���������� Incoming
    {$REGION '����� �������� ASN_Load'}InnerMsgProc('����� �������� ASN_Load');{$ENDREGION}
    Inc(FExpThreadCount);
    expThread := TExportWorkerThread.Create(cCreateSuspended, tmpData, pknWmsMovementASNLoad, FMsgProc);
    expThread.OnTerminate := OnOrderTerminate;
    expThread.Start;
  end
  else
    {$REGION 'Incoming �� ��� ���������'}InnerMsgProc('Incoming �� ��� ���������');{$ENDREGION}
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
  cSent = '�������� ������ ����������� %s';
  cSendFail = '�� ������� �������� ���������� %s';
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

  {TODO: ��������� ��������� ����������. ������ �������� ������������ �� ������� ������������
         WaitForMultipleObjects - ��������� ��� ������ � ����� �� ����������.
         ����� ������ ������� - ���������� �������� �������� � ������ Terminated }


  // �������� ���� ������������ �� ������� � ��������� ���������� ��������
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

  {$REGION '������ ���������� ImporterThread'}
  InnerMsgProc('������ ���������� ImporterThread');
  {$ENDREGION}

  while not Terminated do
  begin
    {$REGION '����� ������ ����� ������� ������'}
    InnerMsgProc('����� ������ ����� ������� ������. �������� ' + IntToStr(TSettings.GatewayIntervalMinute) + ' �����');
    {$ENDREGION}
    // ��� �������� ������ ��������� FMsgProc, � �� InnerMsgProc.
    // FMsgProc ��������� �� callback-��������� ��������� ���������, ������� ���������� � ������, ��������� ���� �����.
    TImportWorkerThread.Create(cCreateRunning, pknOrderStatusChanged, FMsgProc);
    Sleep(100);
    TImportWorkerThread.Create(cCreateRunning, pknReceivingResult, FMsgProc);

    Interval := TSettings.GatewayIntervalMinute * c1Minute; // 3 ������ * 60000 => 180000 ����
    MySleep(Interval);
  end;

  {$REGION '��������� ���������� ImporterThread'}
  InnerMsgProc('��������� ���������� ImporterThread' + #13#10 + DupeString('-', 100) + #13#10);
  {$ENDREGION}
end;


{ TThreadHelper }

function TThreadHelper.WaitFor(ATimeout: Cardinal): LongWord;
begin
  Result := WaitForSingleObject(Handle, ATimeout);
end;

end.
