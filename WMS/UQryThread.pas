unit UQryThread;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.SyncObjs,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  Vcl.DBGrids,
  {$IFDEF LOG}
  ULog,
  {$ENDIF}
  UDefinitions;

type
  TSQLAction = (saOpen, saExec);

  TErrData = record
    HeaderId: Integer;
    PacketName: string;
    EMessage: string;
  end;

  TQryData = record
    SQLText: string;
    Params: TFDParams;
  end;

  TBaseQryThread = class(TThread)
  strict private
    FConn: TFDConnection;
    FAction: TSQLAction;
  protected
    FQry: TFDQuery;
    FMsgProc: TNotifyMsgProc;
    FDone: Boolean;
    FFailed: Boolean;
  private
    function IsConnected: Boolean;
  protected
    procedure ProcessData;
    property Connection: TFDConnection read FConn;
  public
    constructor Create(AQry: TFDQuery; Action: TSQLAction; AMsgProc: TNotifyMsgProc; AKind: TThreadKind = tknNondriven); reintroduce;
    destructor Destroy; override;
    property Done: Boolean read FDone;
    property Failed: Boolean read FFailed;
  end;

  TQryThread = class(TBaseQryThread)
  protected
    procedure Execute; override;
  end;

  TAdjustColmnWidthThread = class(TQryThread)
  strict private
    FGrid: TDBGrid;
    FVisibleRowCount: Integer;
  protected
    procedure Execute; override;
  public
    constructor Create(AGrid: TDBGrid; const AVisibleRowCount: Integer; AQry: TFDQuery;
      AMsgProc: TNotifyMsgProc; AKind: TThreadKind = tknNondriven); reintroduce;
  end;

  TProcessPacketThread = class(TBaseQryThread)
  strict private
    FHeaderId: Integer;
    FPacketName: string;
    FErrQueue: TThreadedQueue<TErrData>;
  protected
    procedure Execute; override;
  public
    constructor Create(AQry: TFDQuery; Action: TSQLAction; AMsgProc: TNotifyMsgProc;
      const AHeaderId: Integer; const APacketName: string; AErrQueue: TThreadedQueue<TErrData>;
      AKind: TThreadKind = tknNondriven); reintroduce;
  end;

  TImportErrProcessor = class(TThread)
  strict private
    FErrQueue: TThreadedQueue<TErrData>;
    FStream: TMemoryStream;
    FMsgProc: TNotifyMsgProc;
    FExecQry: TFDQuery;
    FDoneQry: TFDQuery;
    FAlanConn: TFDConnection;
    FWMSConn: TFDConnection;
  strict private
    procedure ProcessError(AData: TErrData);
    procedure UpdateWMSStatus(const AHeaderId, AErrCode: Integer; const AStatus, AErrMsg: string; AMsgProc: TNotifyMsgProc);
  protected
    procedure Execute; override;
  public
    constructor Create(AErrQueue: TThreadedQueue<TErrData>; AData: TDataObjects; AMsgProc: TNotifyMsgProc); reintroduce;
    destructor Destroy; override;
  end;

  // Управляемый поток. Выполняет запросы, которые добавляются во внутреннюю очередь во время жизни потока.
  TQryQueuedThread = class(TThread)
  strict private
    FQry: TFDQuery;
    FConn: TFDConnection;
    FSqlQueue: TThreadedQueue<TQryData>;
    FMsgProc: TNotifyMsgProc;
    FTaskCount: Cardinal;
    FName: string;
    {$IFDEF LOG}
    FLog: TLog;
    {$ENDIF}
  strict private
    function GetAction(const ASQL: string): TSQLAction;
    function GetAllTasksDone: Boolean;
    procedure ProcessQry(AData: TQryData);
    procedure WriteLog(const AMsg: string);
  protected
    procedure Execute; override;
  public
    constructor Create(AConnection: TFDCustomConnection; AMsgProc: TNotifyMsgProc);
    destructor Destroy; override;
    property AllTasksDone: Boolean read GetAllTasksDone;
    procedure AddData(AData: TQryData);
  end;


implementation

uses
  System.SysUtils,
  System.Variants,
  System.Math,
  Winapi.ActiveX,
  Xml.XMLIntf,
  Xml.XMLDoc,
  Data.DB,
  UConstants,
  {$IFDEF LOG}
  System.StrUtils,
  {$ENDIF}
  UCommon;

{ TBaseQryThread }

constructor TBaseQryThread.Create(AQry: TFDQuery; Action: TSQLAction; AMsgProc: TNotifyMsgProc; AKind: TThreadKind);
var
  I: Integer;
begin
  inherited Create(True);

  FQry  := TFDQuery.Create(nil);
  FConn := TFDConnection.Create(nil);
  FAction := Action;
  FMsgProc := AMsgProc;

  TMonitor.Enter(AQry);
  try
    if AQry.Connection <> nil then
    begin
      TMonitor.Enter(AQry.Connection);
      try
        FConn.Assign(AQry.Connection);
      finally
        TMonitor.Exit(AQry.Connection);
      end;
    end;

    FQry.SQL.Assign(AQry.SQL);

    for I := 0 to Pred(FQry.ParamCount) do
      FQry.Params[I].Assign(AQry.Params[I]);
  finally
    TMonitor.Exit(AQry);
  end;

  FQry.Connection := FConn;

  FreeOnTerminate := (AKind = tknNondriven);
end;

destructor TBaseQryThread.Destroy;
begin
  FreeAndNil(FQry);
  FreeAndNil(FConn);
  inherited;
end;

function TBaseQryThread.IsConnected: Boolean;
begin
  Result := FConn.Connected;

  if not Result then
  try
    FConn.Connected := True;
    Result := FConn.Connected;
  except
    on E: Exception do
    begin
      Result := False;
      if Assigned(FMsgProc) then
        Synchronize(procedure
                    begin
                      FMsgProc(Format(cThreadExceptionMsg, [E.ClassName, ClassName, E.Message]))
                    end);
    end;
  end;
end;

procedure TBaseQryThread.ProcessData;
begin
  if IsConnected then
  case FAction of
    saOpen: FQry.Open;
    saExec: FQry.ExecSQL;
  end;
end;


{ TQryThread }

procedure TQryThread.Execute;
begin
  inherited;
  FDone   := False;
  FFailed := False;

  try
    ProcessData;
    FDone := True;
  except
    on E: Exception do
    begin
      FFailed := True;
      if Assigned(FMsgProc) then
        Synchronize(procedure
                    begin
                      FMsgProc(Format(cThreadExceptionMsg, [E.ClassName, ClassName, E.Message]))
                    end);
    end;
  end;
end;


{ TProcessPacketThread }

constructor TProcessPacketThread.Create(AQry: TFDQuery; Action: TSQLAction; AMsgProc: TNotifyMsgProc;
  const AHeaderId: Integer; const APacketName: string; AErrQueue: TThreadedQueue<TErrData>;
  AKind: TThreadKind);
begin
  inherited Create(AQry, Action, AMsgProc, AKind);

  FHeaderId   := AHeaderId;
  FPacketName := APacketName;
  FErrQueue   := AErrQueue;
end;

procedure TProcessPacketThread.Execute;
var
  tmpErrData: TErrData;
  waitResult: TWaitResult;
begin
  inherited;
  FDone   := False;
  FFailed := False;

  try
    ProcessData;
    FDone := True;
  except
    on E: Exception do
    begin
      FFailed := True;
      tmpErrData.HeaderId   := FHeaderId;
      tmpErrData.PacketName := FPacketName;
      tmpErrData.EMessage   := E.Message;
      repeat
        Assert(FErrQueue <> nil, 'Expected FErrQueue <> nil');
        waitResult := FErrQueue.PushItem(tmpErrData);
        TThread.Sleep(100);
      until (waitResult <> wrTimeout);
    end;
  end;
end;

{ TImportErrProcessor }

constructor TImportErrProcessor.Create(AErrQueue: TThreadedQueue<TErrData>; AData: TDataObjects; AMsgProc: TNotifyMsgProc);
var
  I: Integer;
begin
  FErrQueue := AErrQueue;
  FMsgProc  := AMsgProc;
  FStream   := TMemoryStream.Create;
  FExecQry  := TFDQuery.Create(nil);
  FDoneQry  := TFDQuery.Create(nil);
  FAlanConn := TFDConnection.Create(nil);
  FWMSConn  := TFDConnection.Create(nil);

  TMonitor.Enter(AData.ExecQry);
  try
    if AData.ExecQry.Connection <> nil then
    begin
      TMonitor.Enter(AData.ExecQry.Connection);
      try
        FAlanConn.Assign(AData.ExecQry.Connection);
      finally
        TMonitor.Exit(AData.ExecQry.Connection);
      end;
    end;

    FExecQry.SQL.Assign(AData.ExecQry.SQL);

    for I := 0 to Pred(FExecQry.ParamCount) do
      FExecQry.Params[I].Assign(AData.ExecQry.Params[I]);
  finally
    TMonitor.Exit(AData.ExecQry);
  end;

  FExecQry.Connection := FAlanConn;

  TMonitor.Enter(AData.DoneQry);
  try
    if AData.DoneQry.Connection <> nil then
    begin
      TMonitor.Enter(AData.DoneQry.Connection);
      try
        FWMSConn.Assign(AData.DoneQry.Connection);
      finally
        TMonitor.Exit(AData.DoneQry.Connection);
      end;
    end;

    FDoneQry.SQL.Assign(AData.DoneQry.SQL);

    for I := 0 to Pred(FDoneQry.ParamCount) do
      FDoneQry.Params[I].Assign(AData.DoneQry.Params[I]);
  finally
    TMonitor.Exit(AData.DoneQry);
  end;

  FDoneQry.Connection := FWMSConn;

  inherited Create(False);
end;

destructor TImportErrProcessor.Destroy;
begin
  FreeAndNil(FStream);
  FreeAndNil(FDoneQry);
  FreeAndNil(FExecQry);
  FreeAndNil(FAlanConn);
  FreeAndNil(FWMSConn);
  inherited;
end;

procedure TImportErrProcessor.Execute;
var
  tmpData: TErrData;
begin
  inherited;

  CoInitialize(nil);
  try
    while not Terminated do
    begin
      if FErrQueue.PopItem(tmpData) = wrSignaled then
        ProcessError(tmpData);
      Sleep(100);
    end;
  finally
    CoUninitialize;
  end;
end;

procedure TImportErrProcessor.ProcessError(AData: TErrData);
var
  iPos: Integer;
  xmlDocument: IXMLDocument;
  rootNode, dataNode: IXMLNode;
  sXml, sSite, sDescr, sInsert, sUpdateErr: string;
  thrErr, thrMsg: TQryThread;
const
  cInsert    = 'INSERT INTO wms_to_host_error(Header_Id, Site, Type, Description) VALUES(%d, %s, %s, %s)';
  cUpdateErr = 'UPDATE wms_to_host_message SET Error = TRUE WHERE Header_Id = %d';
begin
  if Length(AData.EMessage) = 0 then Exit;

  if Terminated then Exit;
  
  try
    sSite     := 'A'; // если явно не определено, что ошибка относится к WMS, тогда считаем ее своей ошибкой
    sDescr    := '';
    { если это ошибка, возбужденная в хр.процедуре при проверке входных данных, тогда
      текст ошибки должен иметь вид    Site="A" Descr="текст ошибки" и можно распарсить его как XML }
    iPos := Pos('site=', LowerCase(AData.EMessage));

    if iPos > 0 then
    begin
      sXml := Copy(AData.EMessage, iPos, Length(AData.EMessage) - iPos + 1);
      sXml := StringReplace(sXml, '<', '(', [rfReplaceAll]);
      sXml := StringReplace(sXml, '>', ')', [rfReplaceAll]);
      sXml := '<?xml version="1.0"?><root><data ' + sXml + '/></root>';

      if Terminated then Exit;

      FStream.Size := 0;
      FStream.Write(sXml[1], ByteLength(sXml));
      FStream.Position := 0;

      xmlDocument := TXMLDocument.Create(nil);
      xmlDocument.LoadFromStream(FStream);
      xmlDocument.Active := True;
      rootNode := xmlDocument.DocumentElement;
      dataNode := rootNode.ChildNodes[0];

      sSite     := getStr(dataNode.Attributes['Site'], '');
      sDescr    := getStr(dataNode.Attributes['Descr'], '');
    end
    else
      sDescr := AData.EMessage;

    if Terminated then Exit;

    // записываем данные в таб. wms_to_host_error
    sInsert := Format(cInsert, [AData.HeaderId, QuotedStr(sSite), QuotedStr(AData.PacketName), QuotedStr(sDescr)]);
    with FExecQry do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sInsert);
    end;
    thrErr := TQryThread.Create(FExecQry, saExec, FMsgProc);
    thrErr.Start;

    if Terminated then Exit;

    // обновляем поле Error = TRUE в wms_to_host_message
    sUpdateErr := Format(cUpdateErr, [AData.HeaderId]);
    with FExecQry do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sUpdateErr);
    end;
    thrMsg := TQryThread.Create(FExecQry, saExec, FMsgProc);
    thrMsg.Start;

    if Terminated then Exit;

    // обновление полей to_host_header_message.Status и Err_Descr в WMS
    if sSite = 'W' then
      UpdateWMSStatus(AData.HeaderId, cImpErrWrongPacketData, cStatusError, sDescr, FMsgProc)
    else
      UpdateWMSStatus(AData.HeaderId, cImpErrZero, cStatusDone, '', FMsgProc); // если ошибка на нашей стороне, тогда пишем 'done' в WMS
  except
    on E: Exception do
      if Assigned(FMsgProc) then FMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TImportErrProcessor.UpdateWMSStatus(const AHeaderId, AErrCode: Integer;
  const AStatus, AErrMsg: string; AMsgProc: TNotifyMsgProc);
const
  cWMSUpdate = 'UPDATE to_host_header_message SET Status= %s, Err_Code= %d, Err_Descr= %s  WHERE Id = %d';
var
  sWMSUpdate: string;
  thrQry: TQryThread;
begin
  // обновление полей to_host_header_message.Status и Err_Descr в WMS
  sWMSUpdate := Format(cWMSUpdate, [QuotedStr(AStatus), AErrCode, QuotedStr(AErrMsg), AHeaderId]);
  with FDoneQry do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sWMSUpdate);
  end;
  thrQry := TQryThread.Create(FDoneQry, saExec, AMsgProc);
  thrQry.Start;
end;

{ TQryQueuedThread }

procedure TQryQueuedThread.AddData(AData: TQryData);
var
  waitResult: TWaitResult;
begin
  repeat
    Assert(FSqlQueue <> nil, 'Expected FSqlQueue <> nil');
    waitResult := FSqlQueue.PushItem(AData);
    WriteLog('AddData ParamCount= ' + IntToStr(AData.Params.Count));
    TThread.Sleep(10);
  until (waitResult <> wrTimeout);

  Inc(FTaskCount);
end;

constructor TQryQueuedThread.Create(AConnection: TFDCustomConnection; AMsgProc: TNotifyMsgProc);
const
  cQueueSize   = 100;
  cPushTimeOut = c1Sec * 2;
  cPopTimeOut  = 50;
begin
  FName := 'QryQueuedThread_' + IntToStr(TThread.GetTickCount);
  FSqlQueue := TThreadedQueue<TQryData>.Create(cQueueSize, cPushTimeOut, cPopTimeOut);
  FMsgProc  := AMsgProc;

  FQry  := TFDQuery.Create(nil);
  FConn := TFDConnection.Create(nil);

  TMonitor.Enter(AConnection);
  try
    if AConnection <> nil then
      FConn.Assign(AConnection);
  finally
    TMonitor.Exit(AConnection);
  end;

  FQry.Connection := FConn;

  {$IFDEF LOG}
  FLog := TLog.Create;
  {$ENDIF}

  WriteLog('Create thread');
  inherited Create(False);
end;

destructor TQryQueuedThread.Destroy;
var
  tmpData: TQryData;
begin
  {$IFDEF LOG}
  WriteLog('Destroy thread' + #13#10 + DupeString('-', 80));
  {$ENDIF}
  FreeAndNil(FQry);
  FreeAndNil(FConn);

  while FSqlQueue.PopItem(tmpData) = wrSignaled do
    FreeAndNil(tmpData.Params);

  FreeAndNil(FSqlQueue);
  {$IFDEF LOG}
  FreeAndNil(FLog);
  {$ENDIF}
  inherited;
end;

procedure TQryQueuedThread.Execute;
var
  tmpData: TQryData;
begin
  inherited;

  while not Terminated do
  begin
    if FSqlQueue.PopItem(tmpData) = wrSignaled then
      ProcessQry(tmpData);

    TThread.Sleep(10);
  end;
end;

function TQryQueuedThread.GetAction(const ASQL: string): TSQLAction;
begin
  Result := saExec;
  if Pos('select', LowerCase(Trim(ASQL))) = 1 then
    Result := saOpen;
end;

function TQryQueuedThread.GetAllTasksDone: Boolean;
begin
  WriteLog('GetAllTasksDone: TotalItemsPopped= ' + IntToStr(FSqlQueue.TotalItemsPopped) +
           ' TaskCount= ' + IntToStr(FTaskCount));
  Result := FSqlQueue.TotalItemsPopped >= FTaskCount;
end;

procedure TQryQueuedThread.ProcessQry(AData: TQryData);
begin
  WriteLog('ProcessQry start');
  if Length(Trim(AData.SQLText)) = 0 then
  begin
    WriteLog('ProcessQry empty AData.SQLText');
    Exit;
  end;

  FQry.Close;
  FQry.SQL.Clear;
  FQry.SQL.Add(AData.SQLText);
  FQry.Params.Clear;
  FQry.Params.Assign(AData.Params);

  try
    case GetAction(AData.SQLText) of
     saOpen:
       begin
         try
           FQry.Open;
         except
           on E: Exception do
             if Assigned(FMsgProc) then
               TThread.Queue(nil,
                 procedure
                 begin
                   FMsgProc(E.Message);
                 end
               );
         end;
       end;

     saExec:
       begin
         try
           FQry.ExecSQL;
         except
           on E: Exception do
             if Assigned(FMsgProc) then
               TThread.Queue(nil,
                 procedure
                 begin
                   FMsgProc(E.Message);
                 end
               );
         end;
       end;
    end;
  finally
    WriteLog('ProcessQry end');
    FreeAndNil(AData.Params);
  end;
end;

procedure TQryQueuedThread.WriteLog(const AMsg: string);
begin
  {$IFDEF LOG}
  FLog.Write(FName + '.txt', AMsg);
  {$ENDIF}
end;


{ TAdjustColmnWidthThread }

constructor TAdjustColmnWidthThread.Create(AGrid: TDBGrid; const AVisibleRowCount: Integer;
  AQry: TFDQuery; AMsgProc: TNotifyMsgProc; AKind: TThreadKind);
begin
  inherited Create(AQry, saOpen, AMsgProc, AKind);

  FGrid := AGrid;
  FVisibleRowCount := AVisibleRowCount;
end;

procedure TAdjustColmnWidthThread.Execute;
type
  TIntArray = array of Integer;
var
  I, J, iCount: Integer;
  colWidths: TIntArray;
  sValue: string;
begin
  inherited;

  SetLength(colWidths, FQry.Fields.Count);

  for I := 0 to Pred(FQry.Fields.Count) do
    colWidths[I] := Length(FQry.Fields[I].FieldName) + 2;

  if FQry.RecordCount > 0 then FQry.First;

  iCount  := 0;
  while not FQry.Eof and (iCount < FVisibleRowCount)  do
  begin
    for J := 0 to Pred(FQry.FieldCount) do
    begin
      sValue := VarToStr(Coalesce(FQry.Fields[J].Value, 0));
      colWidths[J] := Max(colWidths[J], Length(sValue));
    end;
    Inc(iCount);
    FQry.Next;
  end;

  Synchronize(procedure
              var
                I, iLetterW: Integer;
              begin
                iLetterW := 8;
                if (FGrid <> nil) and (FGrid.Parent <> nil) then
                  iLetterW := FGrid.Canvas.TextWidth('M');

                FGrid.Columns.BeginUpdate;
                try
                  for I := 0 to Pred(FGrid.Columns.Count) do
                    FGrid.Columns[I].Width := colWidths[I] * iLetterW;
                finally
                  FGrid.Columns.EndUpdate;
                end;
              end);
end;

end.
