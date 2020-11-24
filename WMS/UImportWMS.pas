unit UImportWMS;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  Xml.XMLIntf,
  Xml.XMLDoc,
  UDefinitions,
  UQryThread;

type
  TImportWMS = class
  strict private
    FStream: TMemoryStream;
    FValues: TPacketValuesArray;
    FData: TDataObjects;
//    FErrQueue: TThreadedQueue<TErrData>;
//    FImpErrProcessor: TImportErrProcessor;
    FMsgProc: TNotifyMsgProc;
  strict private
    procedure IncArray; // Inc size of array FValues
    function Last: Integer; // Return High(FValues)
    procedure CheckError(const Attr: string; const AttrValue: Integer; AMsgProc: TNotifyMsgProc); overload;
    procedure CheckError(const Attr: string; const AttrValue: Extended; AMsgProc: TNotifyMsgProc); overload;
    procedure CheckError(const Attr, AttrValue: string; AMsgProc: TNotifyMsgProc); overload;
    procedure CheckErrorAsInt(const Attr, AttrValue: string; AMsgProc: TNotifyMsgProc); overload;
    procedure CheckDateTimeError(const Attr: string; const AttrValue: TDateTime; AMsgProc: TNotifyMsgProc); overload;
  strict private
    procedure FillArrOrderStatusChanged(const ARoot: IXMLNode; AMsgProc: TNotifyMsgProc);
    procedure FillArrReceivingResult(const ARoot: IXMLNode; AMsgProc: TNotifyMsgProc);
  strict private
    procedure ProcessOrderStatusChanged(AMsgProc: TNotifyMsgProc);
    procedure ProcessReceivingResult(AMsgProc: TNotifyMsgProc);
  strict private
    function FetchPacket(APacket: TPacketKind): TMemoryStream;
    procedure FillWmsToHostMessage(AMsgProc: TNotifyMsgProc);
    procedure ExecuteAlanProc(const AHeaderId: Integer; const APacketName, ASQL: string);
    procedure ProcessPacket(const AHeaderId: Integer; const APacketName, ASQL: string; AMsgProc: TNotifyMsgProc);
    procedure ProcessImportError(const AHeaderId: Integer; const APacketName, AErrMsg: string; AMsgProc: TNotifyMsgProc);
    procedure ProcessWrongTypeError(AMsgProc: TNotifyMsgProc);
    procedure UpdateWMSStatus(const AHeaderId, AErrCode: Integer; const AStatus, AErrMsg: string; AMsgProc: TNotifyMsgProc);
  public
    constructor Create(AData: TDataObjects; AMsgProc: TNotifyMsgProc);
    destructor Destroy; override;
    function ImportPacket(const APacket: TPacketKind): Boolean;
  end;

  EImportWMS = class(Exception);
    EOpenHeader = class(EImportWMS);
    EOpenDetail = class(EImportWMS);
    ENoDetailData = class(EImportWMS);

function GetImpTypeCaption(APacket: TPacketKind): string;

implementation

uses
  System.DateUtils,
  System.Variants,
  System.Math,
  Winapi.Windows,
  UConstants,
  UCommon;

const
  cWmsMessageType = '<message_type type="%s"/>';

function GetImpTypeCaption(APacket: TPacketKind): string;
begin
  case APacket of
    pknOrderStatusChanged: Result := cpnOrderStatusChanged;
    pknReceivingResult:    Result := cpnReceivingResult;
  end;
end;

function MyStrToDateTime(const AValue: string): TDateTime; // пример входных данных: "11-09-2019 15:43" -> нужно конвертировать в TDateTime
const
  cDateLen = 10;
  cTotLen  = 16;
var
  sDay, sMo, sYe, sH, sM: string;
begin
  if (Length(AValue) < cDateLen) or (Length(AValue) > cTotLen) or (Pos('-', AValue) = 0) then
    Exit(cZeroDateTime);

  sDay := Copy(AValue, 1, 2);
  sMo  := Copy(AValue, 4, 2);
  sYe  := Copy(AValue, 7, 4);

  if Length(AValue) = cDateLen then
  begin
    sH := '0';
    sM := '0';
  end;

  if Length(AValue) = cTotLen then
  begin
    sH := Copy(AValue, 12, 2);
    sM := Copy(AValue, 15, 2);
  end;

  Result := EncodeDateTime(StrToInt(sYe), StrToInt(sMo), StrToInt(sDay), StrToInt(sH), StrToInt(sM), 0, 0);
end;

{ TImportWMS }

procedure TImportWMS.CheckDateTimeError(const Attr: string; const AttrValue: TDateTime; AMsgProc: TNotifyMsgProc);
begin
  if AttrValue = cZeroDateTime then
  begin
    FValues[Last].Err_Code := cImpErrInvalidDateTime;
    FValues[Last].Err_Descr := Format(cImpErrDescr_InvalidDate, [Attr]);
    if Assigned(AMsgProc) then AMsgProc(Format(cImpErrDescr_InvalidDate, [Attr]));
  end;

  if AttrValue = cErrXmlAttributeNotExists then
  begin
    FValues[Last].Err_Code  := cImpErrAttrNotExists;
    FValues[Last].Err_Descr := Format(cImpErrDecr_AttrNotExists, [Attr]);
    if Assigned(AMsgProc) then AMsgProc(Format(cImpErrDecr_AttrNotExists, [Attr]));
  end;
end;

procedure TImportWMS.CheckError(const Attr, AttrValue: string; AMsgProc: TNotifyMsgProc);
begin
  if AttrValue = cErrStrXmlAttributeNotExists then
  begin
    FValues[Last].Err_Code  := cImpErrAttrNotExists;
    FValues[Last].Err_Descr := Format(cImpErrDecr_AttrNotExists, [Attr]);
    if Assigned(AMsgProc) then AMsgProc(Format(cImpErrDecr_AttrNotExists, [Attr]));
  end;
end;

procedure TImportWMS.CheckErrorAsInt(const Attr, AttrValue: string; AMsgProc: TNotifyMsgProc);
var
  iValue: Integer;
begin
  if AttrValue = cErrStrXmlAttributeNotExists then
    CheckError(Attr, AttrValue, AMsgProc)
  else
  begin
    iValue := getInt(AttrValue, -1);
    CheckError(Attr, iValue, AMsgProc);
  end;
end;

procedure TImportWMS.CheckError(const Attr: string; const AttrValue: Integer; AMsgProc: TNotifyMsgProc);
begin
  if AttrValue = -1 then
  begin
    FValues[Last].Err_Code  := cImpErrWrongType;
    FValues[Last].Err_Descr := Format(cImpErrDescr_NotInteger, [Attr]);
    if Assigned(AMsgProc) then AMsgProc(Format(cImpErrDescr_NotInteger, [Attr]));
  end;

  if AttrValue = cErrXmlAttributeNotExists then
  begin
    FValues[Last].Err_Code  := cImpErrAttrNotExists;
    FValues[Last].Err_Descr := Format(cImpErrDecr_AttrNotExists, [Attr]);
    if Assigned(AMsgProc) then AMsgProc(Format(cImpErrDecr_AttrNotExists, [Attr]));
  end;
end;

procedure TImportWMS.CheckError(const Attr: string; const AttrValue: Extended; AMsgProc: TNotifyMsgProc);
begin
  if AttrValue = -1 then
  begin
    FValues[Last].Err_Code  := cImpErrWrongType;
    FValues[Last].Err_Descr := Format(cImpErrDescr_NotNumeric, [Attr]);
    if Assigned(AMsgProc) then AMsgProc(Format(cImpErrDescr_NotNumeric, [Attr]));
  end;

  if AttrValue = cErrXmlAttributeNotExists then
  begin
    FValues[Last].Err_Code  := cImpErrAttrNotExists;
    FValues[Last].Err_Descr := Format(cImpErrDecr_AttrNotExists, [Attr]);
    if Assigned(AMsgProc) then AMsgProc(Format(cImpErrDecr_AttrNotExists, [Attr]));
  end;
end;

constructor TImportWMS.Create(AData: TDataObjects; AMsgProc: TNotifyMsgProc);
begin
  inherited Create;
  FData    := AData;
  FMsgProc := AMsgProc;

  FStream := TMemoryStream.Create;
//  FErrQueue := TThreadedQueue<TErrData>.Create(200, c1Sec * 5, 500);
//  FImpErrProcessor := TImportErrProcessor.Create(FErrQueue, FData, FMsgProc);
end;

destructor TImportWMS.Destroy;
begin
  FreeAndNil(FStream);
//  FImpErrProcessor.Terminate;
//  FImpErrProcessor.WaitFor;
//  FreeAndNil(FImpErrProcessor);
//  FreeAndNil(FErrQueue);  {TODO: экземпляр TImportWMS уничтожается раньше, чем отработают все потоки. См. TProcessPacketThread.Execute repeat..until}
  inherited;
end;

procedure TImportWMS.ExecuteAlanProc(const AHeaderId: Integer; const APacketName, ASQL: string);
//var
//  thrPacket: TProcessPacketThread;
begin
  // выполнение хр.процедуры в ALAN
  with FData.ExecQry do
  begin
    Close;
    SQL.Clear;
    SQL.Add(ASQL);
    Open;
  end;
//  thrPacket := TProcessPacketThread.Create(FData.ExecQry, saOpen, nil, AHeaderId, APacketName, FErrQueue);
//  thrPacket.Start;
end;

procedure TImportWMS.ProcessOrderStatusChanged(AMsgProc: TNotifyMsgProc);
const
  cProcName = 'gpInsert_wms_order_status_changed';
  cSelect   = 'SELECT * FROM gpSelect_wms_to_host_message (inPacketName:= %s)';
  cRunProc  = 'SELECT * FROM %s(inOrderId:= %d, inSession:= %s)';
var
  bFound: Boolean;
  sSelect, sSQL: string;
  I, inOrderId, iHeader_Id: Integer;
  arrOrderId: array of Integer;
begin
  SetLength(arrOrderId, 0);
  sSelect := Format(cSelect, [QuotedStr(cpnOrderStatusChanged)]);

  try
    with FData.SelectQry do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sSelect);
      Open;
      First;
    end;

    while not FData.SelectQry.Eof do
    begin
      inOrderId  := FData.SelectQry.FieldByName('MovementId').AsInteger;
      iHeader_Id := FData.SelectQry.FieldByName('Header_Id').AsInteger;

      sSQL := Format(cRunProc, [cProcName, inOrderId, QuotedStr('5')]);
      {$IFDEF DEBUG}
//      if Assigned(AMsgProc) then AMsgProc(sSQL);
      {$ENDIF}

      // если несколько записей с одинаковым MovementId, ProcessPacket должен вызваться 1 раз
      bFound := False;
      for I := Low(arrOrderId) to High(arrOrderId) do
      begin
        bFound := (inOrderId = arrOrderId[I]);
        if bFound then Break;
      end;

      // обработка пакета
      if not bFound then
      begin
        SetLength(arrOrderId, Length(arrOrderId) + 1);
        arrOrderId[High(arrOrderId)] := inOrderId;
        ProcessPacket(iHeader_Id, cpnOrderStatusChanged, sSQL, AMsgProc);
        Sleep(100);
      end;

      FData.SelectQry.Next;
    end;

    FData.SelectQry.Close;
  except
    on E: Exception do
      if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TImportWMS.ProcessPacket(const AHeaderId: Integer; const APacketName, ASQL: string; AMsgProc: TNotifyMsgProc);
begin
  try
    // выполнение хр.процедуры в ALAN
    ExecuteAlanProc(AHeaderId, APacketName, ASQL);

    // обновление поля to_host_header_message.Status = "Done" в WMS
    UpdateWMSStatus(AHeaderId, cImpErrZero, cStatusDone, '', AMsgProc);
  except
    on E: Exception do
    begin
      if Assigned(AMsgProc) then
        AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));

      ProcessImportError(AHeaderId, APacketName, E.Message, AMsgProc);
    end;
  end;
end;

procedure TImportWMS.ProcessReceivingResult(AMsgProc: TNotifyMsgProc);
const
  cProcName  = 'gpUpdate_wms_receiving_result';
  cSelect    = 'SELECT * FROM gpSelect_wms_to_host_message (inPacketName:= %s)';
  cRunProc   = 'SELECT * FROM %s(inId:= %d, inSession:= %s)';
var
  sSelect, sSQL: string;
  inId, iHeader_Id: Integer;
begin
  sSelect := Format(cSelect, [QuotedStr(cpnReceivingResult)]);

  try
    with FData.SelectQry do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sSelect);
      Open;
      First;
    end;

    while not FData.SelectQry.Eof do
    begin
      inId       := FData.SelectQry.FieldByName('Id').AsInteger;
      iHeader_Id := FData.SelectQry.FieldByName('Header_Id').AsInteger;

      // текст запроса для выполнения хр.процедуры
      sSQL := Format(cRunProc, [cProcName, inId, QuotedStr('5')]);
      {$IFDEF DEBUG}
      if Assigned(AMsgProc) then AMsgProc(sSQL);
      {$ENDIF}

      // обработка пакета
      ProcessPacket(iHeader_Id, cpnReceivingResult, sSQL, AMsgProc);
      Sleep(100);
      FData.SelectQry.Next;
    end;

    FData.SelectQry.Close;
  except
    on E: Exception do
      if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TImportWMS.ProcessWrongTypeError(AMsgProc: TNotifyMsgProc);
var
  I: Integer;
  thrQry: TQryThread;
begin
  // записываем статус 'error' и коды ошибок в WMS to_host_header_message
  if Length(FValues) > 0 then
  begin
    try
      for I := Low(FValues) to High(FValues) do
        if FValues[I].Err_Code <> 0 then
        begin 
          with FData.ErrorQry do
          begin
            ParamByName('Err_Code').AsInteger  := FValues[I].Err_Code;
            ParamByName('Err_Descr').AsString  := FValues[I].Err_Descr;
            ParamByName('Header_Id').AsInteger := FValues[I].Header_Id;
          end;
          thrQry := TQryThread.Create(FData.ErrorQry, saExec, AMsgProc);
          thrQry.Start;
          Sleep(50);
        end;
    except
      on E: Exception do
        if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
    end;
  end;
end;

function TImportWMS.FetchPacket(APacket: TPacketKind): TMemoryStream;
var
  sPacketType: string;
  sLine: string;
  sOperDate: string;
  sXmlHeader, sXmlFooter: string;
const
  cOperdate = ' operdate="%s"';
begin
  Result := nil;
  FData.HeaderQry.Close;
  FData.DetailQry.Close;
  FStream.Size := 0;

  case APacket of
    pknOrderStatusChanged: sPacketType := cpnOrderStatusChanged;
    pknReceivingResult:    sPacketType := cpnReceivingResult;
  end;

  with FData.HeaderQry do
  begin
    ParamByName('Type').AsString      := sPacketType;
    ParamByName('Status').AsString    := cStatusReady;
    ParamByName('Err_Code').AsInteger := cImpErrZero;
  end;

  try
    FData.HeaderQry.Open;
    if FData.HeaderQry.RecordCount = 0 then Exit;

    sXmlHeader := '<?xml version="1.0"?>' + #13 + '<root>' + #13;
    FStream.Write(sXmlHeader[1], ByteLength(sXmlHeader));

    if not FData.HeaderQry.FieldByName('type').IsNull then
    begin
      sLine := Format(cWmsMessageType, [FData.HeaderQry.FieldByName('type').AsString]) + #13;
      FStream.Write(sLine[1], ByteLength(sLine));
    end;

    FData.HeaderQry.First;
    while not FData.HeaderQry.Eof do
    begin
      if not FData.HeaderQry.FieldByName('message').IsNull then
        sLine := FData.HeaderQry.FieldByName('message').AsString;

      // запись атрибута 'operdate' в конце строки:   <...action="update">   =>  <...action="update" operdate="11-09-2019 15:43">
      if not FData.HeaderQry.FieldByName('start_date').IsNull then
      begin
        sOperDate := Format(cOperdate, [FormatDateTime('dd-mm-yyyy hh:mm', FData.HeaderQry.FieldByName('start_date').AsDateTime)]);
        if Pos('/>', sLine) > 0 then
          sLine := Copy(sLine, 1, Length(sLine) - 2) + sOperDate + '/>'
        else
          sLine := Copy(sLine, 1, Length(sLine) - 1) + sOperDate + '>';
      end;

      if Length(sLine) > 0 then
      begin
        sLine := sLine + #13;
        FStream.Write(sLine[1], ByteLength(sLine));

        FData.DetailQry.Close;
        FData.DetailQry.ParamByName('Header_Id').AsInteger := FData.HeaderQry.FieldByName('id').AsInteger;
        try
          FData.DetailQry.Open;
        except
          on E: Exception do
           raise EOpenDetail.CreateFmt(cExceptionMsg, [E.ClassName, E.Message + ' ' + FData.DetailQry.SQL.Text]);
        end;

        while not FData.DetailQry.Eof do
        begin
          if not FData.DetailQry.FieldByName('message').IsNull then
          begin
            sLine := FData.DetailQry.FieldByName('message').AsString;
            if Length(sLine) > 0 then
            begin
              sLine := sLine + #13;
              FStream.Write(sLine[1], ByteLength(sLine));
            end;
          end;
          FData.DetailQry.Next;
        end;
      end;
      FData.HeaderQry.Next;
    end;

    sXmlFooter := '</root>';
    FStream.Write(sXmlFooter[1], ByteLength(sXmlFooter));
    Result := FStream;
  except
    on E: Exception do
      raise EOpenHeader.CreateFmt(cExceptionMsg, [E.ClassName, E.Message + ' ' + FData.HeaderQry.SQL.Text]);
  end;
end;

procedure TImportWMS.FillArrOrderStatusChanged(const ARoot: IXMLNode; AMsgProc: TNotifyMsgProc);
var
  I, J: Integer;
  headerNode, detailNode: IXMLNode;
  sMessageType: string;
begin
  try
    for I := 0 to Pred(ARoot.ChildNodes.Count) do
    begin
      headerNode := ARoot.ChildNodes[I];

      if headerNode.NodeName = 'message_type' then
        sMessageType := getStr(headerNode.Attributes['type']);

      if headerNode.NodeName = 'order_status_changed' then
      begin
        IncArray;

        FValues[Last].Message_Type := sMessageType;
        CheckError('type', FValues[Last].Message_Type, AMsgProc);

        FValues[Last].Header_Id := getInt(headerNode.Attributes['syncid'], -1);
        CheckError('syncid', FValues[Last].Header_Id, AMsgProc);

        FValues[Last].MovementId := getStr(headerNode.Attributes['order_id']);
        CheckErrorAsInt('order_id', FValues[Last].MovementId, AMsgProc); // проверить, что string-значение может быть конвертировано в Integer

        FValues[Last].OperDate := MyStrToDateTime(headerNode.Attributes['operdate']);
        CheckDateTimeError('operdate', FValues[Last].OperDate, AMsgProc);

        if headerNode.HasChildNodes then
          for J := 0 to Pred(headerNode.ChildNodes.Count) do
          begin
            detailNode := headerNode.ChildNodes[J];
            if detailNode.NodeName = 'order_status_changed_detail' then
            begin
              if J > 0 then // нужно продублировать parent-значения для detailNode, если это не первая detailNode
              begin
                IncArray;
                FValues[Last].Message_Type := FValues[Last - 1].Message_Type;
                FValues[Last].Header_Id    := FValues[Last - 1].Header_Id;
                FValues[Last].MovementId   := FValues[Last - 1].MovementId;
                FValues[Last].Err_Code     := FValues[Last - 1].Err_Code;
                FValues[Last].Err_Descr    := FValues[Last - 1].Err_Descr;
                FValues[Last].OperDate     := FValues[Last - 1].OperDate;
              end;

              FValues[Last].Detail_Id := getInt(detailNode.Attributes['syncid'], -1);
              CheckError('syncid', FValues[Last].Detail_Id, AMsgProc);

              FValues[Last].SKU_Id := getStr(detailNode.Attributes['sku_id']);
              CheckError('sku_id', FValues[Last].SKU_Id, AMsgProc);

              FValues[Last].Qty := getStr(detailNode.Attributes['qty']);
              CheckError('qty', FValues[Last].Qty, AMsgProc);

              FValues[Last].Weight := getStr(detailNode.Attributes['real_weight']);
              CheckError('real_weight', FValues[Last].Weight, AMsgProc);

              FValues[Last].Weight_Biz := getStr(detailNode.Attributes['weight_biz']);
              CheckError('weight_biz', FValues[Last].Weight_Biz, AMsgProc);

              FValues[Last].Production_Date := getStr(detailNode.Attributes['production_date']);
              CheckError('production_date', FValues[Last].Production_Date, AMsgProc);
            end;
          end;
      end;
    end;
  except
    on E: Exception do
      if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TImportWMS.FillArrReceivingResult(const ARoot: IXMLNode; AMsgProc: TNotifyMsgProc);
var
  I, J: Integer;
  headerNode, detailNode: IXMLNode;
  sMessageType: string;
begin
  try
    for I := 0 to Pred(ARoot.ChildNodes.Count) do
    begin
      headerNode := ARoot.ChildNodes[I];

      if headerNode.NodeName = 'message_type' then
        sMessageType := getStr(headerNode.Attributes['type']);

      if headerNode.NodeName = 'receiving_result' then
      begin
        IncArray;

        FValues[Last].Message_Type := sMessageType;
        CheckError('type', FValues[Last].Message_Type, AMsgProc);

        FValues[Last].Header_Id := getInt(headerNode.Attributes['syncid'], -1);
        CheckError('syncid', FValues[Last].Header_Id, AMsgProc);

        FValues[Last].MovementId := getStr(headerNode.Attributes['inc_id']);
        CheckErrorAsInt('inc_id', FValues[Last].MovementId, AMsgProc); // проверить, что string-значение может быть конвертировано в Integer

        FValues[Last].OperDate := MyStrToDateTime(headerNode.Attributes['operdate']);
        CheckDateTimeError('operdate', FValues[Last].OperDate, AMsgProc);

        if headerNode.HasChildNodes then
          for J := 0 to Pred(headerNode.ChildNodes.Count) do
          begin
            detailNode := headerNode.ChildNodes[J];
            if detailNode.NodeName = 'receiving_result_detail' then
            begin
              if J > 0 then // нужно продублировать parent-значения для detailNode, если это не первая detailNode
              begin
                IncArray;
                FValues[Last].Message_Type := FValues[Last - 1].Message_Type;
                FValues[Last].Header_Id    := FValues[Last - 1].Header_Id;
                FValues[Last].MovementId   := FValues[Last - 1].MovementId;
                FValues[Last].Err_Code     := FValues[Last - 1].Err_Code;
                FValues[Last].Err_Descr    := FValues[Last - 1].Err_Descr;
                FValues[Last].OperDate     := FValues[Last - 1].OperDate;
              end;

              FValues[Last].Detail_Id := getInt(detailNode.Attributes['syncid'], -1);
              CheckError('syncid', FValues[Last].Detail_Id, AMsgProc);

              FValues[Last].SKU_Id := getStr(detailNode.Attributes['sku_id']);
              CheckError('sku_id', FValues[Last].SKU_Id, AMsgProc);

              FValues[Last].Qty := getStr(detailNode.Attributes['qty']);
              CheckError('qty', FValues[Last].Qty, AMsgProc);

              FValues[Last].Weight := getStr(detailNode.Attributes['weight']);
              CheckError('weight', FValues[Last].Weight, AMsgProc);

              FValues[Last].Name := getStr(detailNode.Attributes['name']);
              CheckError('name', FValues[Last].Name, AMsgProc);

              FValues[Last].Production_Date := getStr(detailNode.Attributes['production_date']);
              CheckError('production_date', FValues[Last].Production_Date, AMsgProc);
            end;
          end;
      end;
    end;
  except
    on E: Exception do
      if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TImportWMS.FillWmsToHostMessage(AMsgProc: TNotifyMsgProc);
var
  I: Integer;
  tmpQryData: TQryData;
  iIndex, iTotCount: Integer;
  arrThreads: array of TQryQueuedThread;
const
  cMaxThreadCount = 10;
begin
  SetLength(arrThreads, Min(Length(FValues), cMaxThreadCount));
  iIndex := Low(arrThreads);
  iTotCount := 0;

  for I := Low(arrThreads) to High(arrThreads) do
    arrThreads[I] := TQryQueuedThread.Create(FData.InsertQry.Connection, AMsgProc);

  try
    // записываем данные в таб. Alan wms_to_host_message
    for I := Low(FValues) to High(FValues) do
    begin
      if FValues[I].Err_Code <> 0 then Continue;

      with FData.InsertQry do
      begin
        Close;
        ParamByName('type').AsString            := FValues[I].Message_Type;
        ParamByName('Header_Id').AsInteger      := FValues[I].Header_Id;
        ParamByName('Detail_Id').AsInteger      := FValues[I].Detail_Id;
        ParamByName('MovementId').AsString      := FValues[I].MovementId;
        ParamByName('SKU_Id').AsString          := FValues[I].SKU_Id;
        ParamByName('Name').AsString            := FValues[I].Name;
        ParamByName('Qty').AsString             := FValues[I].Qty;
        ParamByName('Weight').AsString          := FValues[I].Weight;
        ParamByName('Weight_Biz').AsString      := FValues[I].Weight_Biz;
        ParamByName('OperDate').AsDateTime      := FValues[I].OperDate;
        ParamByName('Production_Date').AsString := FValues[I].Production_Date;
      end;

      tmpQryData.SQLText := FData.InsertQry.SQL.Text;
      tmpQryData.Params  := TFDParams.Create;
      tmpQryData.Params.Assign(FData.InsertQry.Params);

      arrThreads[iIndex].AddData(tmpQryData);

      Inc(iTotCount);
      Inc(iIndex);
      if iIndex > High(arrThreads) then
        iIndex := Low(arrThreads);
    end;

//    if Assigned(AMsgProc) then
//      AMsgProc('Befor terminate TQryQueuedThread threads');

    for I := Low(arrThreads) to High(arrThreads) do
      WaitFor(3000, not arrThreads[I].AllTasksDone);

    for I := Low(arrThreads) to High(arrThreads) do
      arrThreads[I].Terminate;

    for I := Low(arrThreads) to High(arrThreads) do
      arrThreads[I].WaitFor;

  finally
    if Assigned(AMsgProc) then
      AMsgProc('Total record count = ' + IntToStr(iTotCount));

    for I := Low(arrThreads) to High(arrThreads) do
      arrThreads[I].Free;
  end;
end;

function TImportWMS.ImportPacket(const APacket: TPacketKind): Boolean;
var
  I, iTotCount: Integer;
  dtmStart, dtmDiff: TDateTime;
  xmlDocument: IXMLDocument;
  rootNode: IXMLNode;
  tmpStream: TMemoryStream;
const
  cNoData = 'Нет данных <%s> для импорта';
  cRecCountSwitch = 500;
begin
  tmpStream := FetchPacket(APacket);
  iTotCount := 0;

  if tmpStream = nil then
  begin
    if Assigned(FMsgProc) then
      FMsgProc(Format(cNoData, [GetImpTypeCaption(APacket)]));
    Exit(False);
  end;

  SetLength(FValues, 0);
  xmlDocument := TXMLDocument.Create(nil);
  xmlDocument.LoadFromStream(tmpStream);
  xmlDocument.Active := True;
//  xmlDocument.SaveToFile(GetImpTypeCaption(APacket) + '.xml');
  rootNode := xmlDocument.DocumentElement;

  case APacket of
    pknOrderStatusChanged: FillArrOrderStatusChanged(rootNode, FMsgProc);
    pknReceivingResult:    FillArrReceivingResult(rootNode, FMsgProc);
  end;

  { записываем статус 'error' и коды ошибок в WMS to_host_header_message для записей,
    которые содержат значения, не соответствующие ожидаемым типам данных }
  if Length(FValues) > 0 then
    ProcessWrongTypeError(FMsgProc);

  if Length(FValues) > 0 then
  begin
    try
      // записываем данные в таб. Alan wms_to_host_message
      if Assigned(FMsgProc) then
        FMsgProc('Старт записи данных в ALAN.wms_to_host_message');

      dtmStart := Now;

      if Length(FValues) > cRecCountSwitch then
        FillWmsToHostMessage(FMsgProc) // при малом количестве записей проигрывает коду ниже, в котором выполняется последовательное выполнение запросов в цикле в гл.потоке
      else
      begin
        for I := Low(FValues) to High(FValues) do
        begin
          if FValues[I].Err_Code <> 0 then Continue;

          with FData.InsertQry do
          begin
            Close;
            ParamByName('type').AsString            := FValues[I].Message_Type;
            ParamByName('Header_Id').AsInteger      := FValues[I].Header_Id;
            ParamByName('Detail_Id').AsInteger      := FValues[I].Detail_Id;
            ParamByName('MovementId').AsString      := FValues[I].MovementId;
            ParamByName('SKU_Id').AsString          := FValues[I].SKU_Id;
            ParamByName('Name').AsString            := FValues[I].Name;
            ParamByName('Qty').AsString             := FValues[I].Qty;
            ParamByName('Weight').AsString          := FValues[I].Weight;
            ParamByName('Weight_Biz').AsString      := FValues[I].Weight_Biz;
            ParamByName('OperDate').AsDateTime      := FValues[I].OperDate;
            ParamByName('Production_Date').AsString := FValues[I].Production_Date;
//            ExecSQL;
            Open;
          end;
          Inc(iTotCount);
        end;

        if Assigned(FMsgProc) then
          FMsgProc('Общее число записей = ' + IntToStr(iTotCount));
      end;

      dtmDiff := Now - dtmStart;
//      if Assigned(FMsgProc) then
//        FMsgProc('Прошло времени: ' + FormatDateTime('hh:nn:ss_zzz', dtmDiff));

//      if Assigned(FMsgProc) then
//        FMsgProc('Закончил записывать данные в ALAN.wms_to_host_message');

      // обработка пакетов
      case APacket of
        pknOrderStatusChanged: ProcessOrderStatusChanged(FMsgProc);
        pknReceivingResult:    ProcessReceivingResult(FMsgProc);
      end;

      Result := True;
    except
      on E: Exception do
        if Assigned(FMsgProc) then FMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
    end;
  end;
end;

procedure TImportWMS.IncArray;
begin
  SetLength(FValues, Length(FValues) + 1);
end;

function TImportWMS.Last: Integer;
begin
  Result := High(FValues);
end;

procedure TImportWMS.ProcessImportError(const AHeaderId: Integer; // AHeaderId - wms_to_host_message.Header_Id
  const APacketName, AErrMsg: string; AMsgProc: TNotifyMsgProc);
var
  iPos: Integer;
  xmlDocument: IXMLDocument;
  rootNode, dataNode: IXMLNode;
  sXml, sSite, sDescr, sInsert, sUpdateErr: string;
  thrErr, thrMsg: TQryThread;
const
  cInsert    = 'SELECT gpInsert_wms_to_host_error(%d, %s, %s, %s)';
  cUpdateErr = 'SELECT gpUpdate_wms_to_host_message (%d)';
begin
  try
    sSite     := 'A'; // если явно не определено, что ошибка относится к WMS, тогда считаем ее своей ошибкой
    sDescr    := '';
    { если это ошибка, возбужденная в хр.процедуре при проверке входных данных, тогда
      текст ошибки должен иметь вид    Site="A" Descr="текст ошибки" и можно распарсить его как XML }
    iPos := Pos('site=', LowerCase(AErrMsg));

    if iPos > 0 then
    begin
      sXml := Copy(AErrMsg, iPos, Length(AErrMsg) - iPos + 1);
      sXml := StringReplace(sXml, '<', '(', [rfReplaceAll]);
      sXml := StringReplace(sXml, '>', ')', [rfReplaceAll]);
      sXml := '<?xml version="1.0"?><root><data ' + sXml + '/></root>';
    //  sXml := LowerCase(sXml);
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
      sDescr := SkipSystemErrWords(AErrMsg);// исключаем стандартные слова из текста сообщения об ошибке, например, "[FireDAC][Phys][PG][libpq]"

    // записываем данные в таб. wms_to_host_error
    sInsert := Format(cInsert, [AHeaderId, QuotedStr(sSite), QuotedStr(APacketName), QuotedStr(sDescr)]);
    with FData.ExecQry do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sInsert);
//      Open;
    end;
    thrErr := TQryThread.Create(FData.ExecQry, saOpen, AMsgProc);
    thrErr.Start;

    // обновляем поле Error = TRUE в wms_to_host_message
    sUpdateErr := Format(cUpdateErr, [AHeaderId]);
    with FData.ExecQry do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sUpdateErr);
//      Open;
    end;
    thrMsg := TQryThread.Create(FData.ExecQry, saOpen, AMsgProc);
    thrMsg.Start;

    // обновление полей to_host_header_message.Status и Err_Descr в WMS
    if sSite = 'W' then
      UpdateWMSStatus(AHeaderId, cImpErrWrongPacketData, cStatusError, sDescr, AMsgProc)
    else
      UpdateWMSStatus(AHeaderId, cImpErrZero, cStatusDone, '', AMsgProc); // если ошибка на нашей стороне, тогда пишем 'done' в WMS
  except
    on E: Exception do
      if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TImportWMS.UpdateWMSStatus(const AHeaderId, AErrCode: Integer; // AHeaderId - wms_to_host_message.Header_Id
  const AStatus, AErrMsg: string; AMsgProc: TNotifyMsgProc);
const
  cWMSUpdate = 'UPDATE to_host_header_message SET Status= %s, Err_Code= %d, Err_Descr= %s  WHERE Id = %d';
var
  sWMSUpdate: string;
  thrQry: TQryThread;
begin
  // обновление полей to_host_header_message.Status и Err_Descr в WMS
  sWMSUpdate := Format(cWMSUpdate, [QuotedStr(AStatus), AErrCode, QuotedStr(AErrMsg), AHeaderId]);
  with FData.DoneQry do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sWMSUpdate);
//    ExecSQL;
  end;
  thrQry := TQryThread.Create(FData.DoneQry, saExec, AMsgProc);
  thrQry.Start;
end;

end.
