unit UQryThread;

interface

uses
  System.Classes,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  UDefinitions;

type
  TSQLAction = (saOpen, saExec);
  TThreadKind = (tknDriven, tknNondriven);

  TErrData = record
    HeaderId: Integer;
    PacketName: string;
    EMessage: string;
  end;

  TBaseQryThread = class(TThread)
  strict private
    FQry: TFDQuery;
    FConn: TFDConnection;
    FAction: TSQLAction;
  protected
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

implementation

uses
  System.SysUtils,
  System.SyncObjs,
  ActiveX,
  Xml.XMLIntf,
  Xml.XMLDoc,
  UConstants,
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

  if AQry.Connection <> nil then
    FConn.Assign(AQry.Connection);

  FQry.SQL.Assign(AQry.SQL);

  for I := 0 to Pred(FQry.ParamCount) do
    FQry.Params[I].Assign(AQry.Params[I]);

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

  if AData.ExecQry.Connection <> nil then
    FAlanConn.Assign(AData.ExecQry.Connection);

  FExecQry.SQL.Assign(AData.ExecQry.SQL);

  for I := 0 to Pred(FExecQry.ParamCount) do
    FExecQry.Params[I].Assign(AData.ExecQry.Params[I]);

  FExecQry.Connection := FAlanConn;

  if AData.DoneQry.Connection <> nil then
    FWMSConn.Assign(AData.DoneQry.Connection);

  FDoneQry.SQL.Assign(AData.DoneQry.SQL);

  for I := 0 to Pred(FDoneQry.ParamCount) do
    FDoneQry.Params[I].Assign(AData.DoneQry.Params[I]);

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

end.
