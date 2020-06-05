unit UImportWMS;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  Xml.XMLIntf,
  Xml.XMLDoc,
  UDefinitions;

type
  TPacketKind = (pknOrderStatusChanged, pknReceivingResult);

  TPacketValues = record
    message_type: string;
    header_id: Integer;
    detail_id: Integer;
    movementid: Integer;
    sku_id: Integer;
    name: string;
    qty: Double;
    weight: Double;
    weight_biz: Double;
    operdate: TDateTime;
    production_date: TDateTime;
    err_code: Integer;
  private
    Ferr_descr: string;
    procedure SetErrDescr(AValue: string);
    function GetErrDescr: string;
  public
    property err_descr: string read GetErrDescr write SetErrDescr;
  end;

  TPacketValuesArray = array of TPacketValues;

  TImportWMS = class
  strict private
    FHeader: TFDQuery;
    FDetail: TFDQuery;
    FInsertQry: TFDQuery;
    FErrorQry: TFDQuery;
    FDoneQry: TFDQuery;
    FSelectQry: TFDQuery;
    FExecQry: TFDQuery;
    FWMSTrans: TFDTransaction;
    FStream: TMemoryStream;
    FValues: TPacketValuesArray;
  strict private
    procedure IncArray; // Inc size of array FValues
    function Last: Integer; // Return High(FValues)
    function getStr(const AttrValue: OleVariant): string;
    function getInt(const AttrValue: OleVariant; const ADefValue: Integer): Integer;
    function getFloat(const AttrValue: OleVariant; const ADefValue: Extended): Extended;
    procedure CheckError(const Attr: string; const AttrValue: Integer; AMsgProc: TNotifyMsgProc); overload;
    procedure CheckError(const Attr: string; const AttrValue: Extended; AMsgProc: TNotifyMsgProc); overload;
    procedure CheckError(const Attr, AttrValue: string; AMsgProc: TNotifyMsgProc); overload;
    procedure CheckDateTimeError(const Attr: string; const AttrValue: TDateTime; AMsgProc: TNotifyMsgProc); overload;
  strict private
    procedure FillArrOrderStatusChanged(const ARoot: IXMLNode; AMsgProc: TNotifyMsgProc);
    procedure FillArrReceivingResult(const ARoot: IXMLNode; AMsgProc: TNotifyMsgProc);
  strict private
    function FetchPacket(APacket: TPacketKind): TMemoryStream;
    procedure ExecuteOrderStatusChanged(AMsgProc: TNotifyMsgProc);
    procedure ExecuteReceivingResult(AMsgProc: TNotifyMsgProc);
  public
    constructor Create(AHeaderQry, ADetailQry, AInsertQry, AErrorQry, ADoneQry, ASelectQry, AExecQry: TFDQuery; AWMSTrans: TFDTransaction);
    destructor Destroy; override;
    function ImportPacket(const APacket: TPacketKind; AMsgProc: TNotifyMsgProc): Boolean;
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
  UConstants;

const
  cWmsMessageType = '<message_type type="%s"/>';
  // Packet name
  cmtOrderStatusChanged = 'order_status_changed';
  cmtReceivingResult = 'receiving_result';

function GetImpTypeCaption(APacket: TPacketKind): string;
begin
  case APacket of
    pknOrderStatusChanged: Result := cmtOrderStatusChanged;
    pknReceivingResult:    Result := cmtReceivingResult;
  end;
end;

function MyStrToDateTime(const AValue: string): TDateTime; // пример входных данных: "11-09-2019 15:43" -> нужно конвертировать в TDateTime
const
  cDateLen = 10;
  cTotLen = 16;
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
    FValues[Last].err_code := cImpErrInvalidDateTime;
    FValues[Last].err_descr := Format(cImpErrDescr_InvalidDate, [Attr]);
    if Assigned(AMsgProc) then AMsgProc(Format(cImpErrDescr_InvalidDate, [Attr]));
  end;

  if AttrValue = cErrXmlAttributeNotExists then
  begin
    FValues[Last].err_code := cImpErrAttrNotExists;
    FValues[Last].err_descr := Format(cImpErrDecr_AttrNotExists, [Attr]);
    if Assigned(AMsgProc) then AMsgProc(Format(cImpErrDecr_AttrNotExists, [Attr]));
  end;
end;

procedure TImportWMS.CheckError(const Attr, AttrValue: string; AMsgProc: TNotifyMsgProc);
begin
  if AttrValue = cErrStrXmlAttributeNotExists then
  begin
    FValues[Last].err_code := cImpErrAttrNotExists;
    FValues[Last].err_descr := Format(cImpErrDecr_AttrNotExists, [Attr]);
    if Assigned(AMsgProc) then AMsgProc(Format(cImpErrDecr_AttrNotExists, [Attr]));
  end;
end;

procedure TImportWMS.CheckError(const Attr: string; const AttrValue: Integer; AMsgProc: TNotifyMsgProc);
begin
  if AttrValue = -1 then
  begin
    FValues[Last].err_code := cImpErrWrongType;
    FValues[Last].err_descr := Format(cImpErrDescr_NotInteger, [Attr]);
    if Assigned(AMsgProc) then AMsgProc(Format(cImpErrDescr_NotInteger, [Attr]));
  end;

  if AttrValue = cErrXmlAttributeNotExists then
  begin
    FValues[Last].err_code := cImpErrAttrNotExists;
    FValues[Last].err_descr := Format(cImpErrDecr_AttrNotExists, [Attr]);
    if Assigned(AMsgProc) then AMsgProc(Format(cImpErrDecr_AttrNotExists, [Attr]));
  end;
end;

procedure TImportWMS.CheckError(const Attr: string; const AttrValue: Extended; AMsgProc: TNotifyMsgProc);
begin
  if AttrValue = -1 then
  begin
    FValues[Last].err_code := cImpErrWrongType;
    FValues[Last].err_descr := Format(cImpErrDescr_NotNumeric, [Attr]);
    if Assigned(AMsgProc) then AMsgProc(Format(cImpErrDescr_NotNumeric, [Attr]));
  end;

  if AttrValue = cErrXmlAttributeNotExists then
  begin
    FValues[Last].err_code := cImpErrAttrNotExists;
    FValues[Last].err_descr := Format(cImpErrDecr_AttrNotExists, [Attr]);
    if Assigned(AMsgProc) then AMsgProc(Format(cImpErrDecr_AttrNotExists, [Attr]));
  end;
end;

constructor TImportWMS.Create(AHeaderQry, ADetailQry, AInsertQry, AErrorQry, ADoneQry, ASelectQry, AExecQry: TFDQuery;
  AWMSTrans: TFDTransaction);
begin
  inherited Create;
  FHeader    := AHeaderQry;
  FDetail    := ADetailQry;
  FInsertQry := AInsertQry;
  FErrorQry  := AErrorQry;
  FDoneQry   := ADoneQry;
  FSelectQry := ASelectQry;
  FExecQry   := AExecQry;
  FWMSTrans  := AWMSTrans;

  FStream := TMemoryStream.Create;
end;

destructor TImportWMS.Destroy;
begin
  FreeAndNil(FStream);
  inherited;
end;

procedure TImportWMS.ExecuteOrderStatusChanged(AMsgProc: TNotifyMsgProc);
const
  cProcName = 'gpInsert_wms_order_status_changed';

  cSelect   = 'SELECT DISTINCT Id, MovementId FROM wms_to_host_message WHERE (Done = FALSE) AND (Type = %s) ORDER BY Id';

  cRunProc  = 'SELECT * FROM %s(inSession:= %s, inOrderId:= %d);';
var
  sSelect, sExec: string;
begin
  sSelect := Format(cSelect, [QuotedStr(cmtOrderStatusChanged)]);

  try
    with FSelectQry do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sSelect);
      Open;
      First;
    end;

    while not FSelectQry.Eof do
    begin
      try
        sExec := Format(cRunProc, [cProcName, QuotedStr('5'), FSelectQry.FieldByName('MovementId').AsInteger]);
        {$IFDEF DEBUG}
        if Assigned(AMsgProc) then AMsgProc(sExec);
        {$ENDIF}
        FExecQry.Close;
        FExecQry.SQL.Clear;
        FExecQry.SQL.Add(sExec);
        FExecQry.Open;
      except
        on E: Exception do
          if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
      end;

      FSelectQry.Next;
    end;

    FSelectQry.Close;
  except
    on E: Exception do
      if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TImportWMS.ExecuteReceivingResult(AMsgProc: TNotifyMsgProc);
const
  cProcName = 'gpUpdate_wms_receiving_result';

  cSelect   = 'SELECT DISTINCT Id, MovementId, Name, Qty FROM wms_to_host_message WHERE (Done = FALSE) AND (Type = %s) ORDER BY Id';

  cRunProc  = 'SELECT * FROM %s(inId:= %d, inIncomingId:= %d, inName:= %s, inQty:= %f);';
var
  sSelect, sExec: string;
  tmpSettings: TFormatSettings;
begin
  sSelect := Format(cSelect, [QuotedStr(cmtReceivingResult)]);
  tmpSettings.DecimalSeparator := '.';

  try
    with FSelectQry do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sSelect);
      Open;
      First;
    end;

    while not FSelectQry.Eof do
    begin
      try
        sExec := Format(cRunProc, [
          cProcName,
          FSelectQry.FieldByName('Id').AsInteger,
          FSelectQry.FieldByName('MovementId').AsInteger,
          QuotedStr(FSelectQry.FieldByName('Name').AsString),
          FSelectQry.FieldByName('Qty').AsFloat
        ], tmpSettings);
        {$IFDEF DEBUG}
        if Assigned(AMsgProc) then AMsgProc(sExec);
        {$ENDIF}
        FExecQry.Close;
        FExecQry.SQL.Clear;
        FExecQry.SQL.Add(sExec);
        FExecQry.Open;
      except
        on E: Exception do
          if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
      end;

      FSelectQry.Next;
    end;

    FSelectQry.Close;
  except
    on E: Exception do
      if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
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
  FHeader.Close;
  FDetail.Close;
  FStream.Size := 0;

  case APacket of
    pknOrderStatusChanged: sPacketType := cmtOrderStatusChanged;
    pknReceivingResult:    sPacketType := cmtReceivingResult;
  end;

  FHeader.ParamByName('type').AsString := sPacketType;
  FHeader.ParamByName('status').AsString := cStatusReady;
  FHeader.ParamByName('err_code').AsInteger := cImpErrZero;

  try
    FHeader.Open;
    if FHeader.RecordCount = 0 then Exit;

    sXmlHeader := '<?xml version="1.0"?>' + #13 + '<root>' + #13;
    FStream.Write(sXmlHeader[1], ByteLength(sXmlHeader));

    if not FHeader.FieldByName('type').IsNull then
    begin
      sLine := Format(cWmsMessageType, [FHeader.FieldByName('type').AsString]) + #13;
      FStream.Write(sLine[1], ByteLength(sLine));
    end;

    FHeader.First;
    while not FHeader.Eof do
    begin
      if not FHeader.FieldByName('message').IsNull then
        sLine := FHeader.FieldByName('message').AsString;

      // запись атрибута 'operdate' в конце строки:   <...action="update">   =>  <...action="update" operdate="11-09-2019 15:43">
      if not FHeader.FieldByName('start_date').IsNull then
      begin
        sOperDate := Format(cOperdate, [FormatDateTime('dd-mm-yyyy hh:mm', FHeader.FieldByName('start_date').AsDateTime)]);
        if Pos('/>', sLine) > 0 then
          sLine := Copy(sLine, 1, Length(sLine) - 2) + sOperDate + '/>'
        else
          sLine := Copy(sLine, 1, Length(sLine) - 1) + sOperDate + '>';
      end;

      if Length(sLine) > 0 then
      begin
        sLine := sLine + #13;
        FStream.Write(sLine[1], ByteLength(sLine));

        FDetail.Close;
        FDetail.ParamByName('header_id').AsInteger := FHeader.FieldByName('id').AsInteger;
        try
          FDetail.Open;
        except
          on E: Exception do
           raise EOpenDetail.CreateFmt(cExceptionMsg, [E.ClassName, E.Message + ' ' + FDetail.SQL.Text]);
        end;

        while not FDetail.Eof do
        begin
          if not FDetail.FieldByName('message').IsNull then
          begin
            sLine := FDetail.FieldByName('message').AsString;
            if Length(sLine) > 0 then
            begin
              sLine := sLine + #13;
              FStream.Write(sLine[1], ByteLength(sLine));
            end;
          end;
          FDetail.Next;
        end;
      end;
      FHeader.Next;
    end;

    sXmlFooter := '</root>';
    FStream.Write(sXmlFooter[1], ByteLength(sXmlFooter));
    Result := FStream;
  except
    on E: Exception do
      raise EOpenHeader.CreateFmt(cExceptionMsg, [E.ClassName, E.Message + ' ' + FHeader.SQL.Text]);
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

        FValues[Last].message_type := sMessageType;
        CheckError('type', FValues[Last].message_type, AMsgProc);

        FValues[Last].header_id := getInt(headerNode.Attributes['syncid'], -1);
        CheckError('syncid', FValues[Last].header_id, AMsgProc);

        FValues[Last].movementid := getInt(headerNode.Attributes['order_id'], -1);
        CheckError('order_id', FValues[Last].movementid, AMsgProc);

        FValues[Last].operdate := MyStrToDateTime(headerNode.Attributes['operdate']);
        CheckDateTimeError('operdate', FValues[Last].operdate, AMsgProc);

        if headerNode.HasChildNodes then
          for J := 0 to Pred(headerNode.ChildNodes.Count) do
          begin
            detailNode := headerNode.ChildNodes[J];
            if detailNode.NodeName = 'order_status_changed_detail' then
            begin
              if J > 0 then // нужно продублировать parent-значения для detailNode, если это не первая detailNode
              begin
                IncArray;
                FValues[Last].message_type := FValues[Last - 1].message_type;
                FValues[Last].header_id    := FValues[Last - 1].header_id;
                FValues[Last].movementid  := FValues[Last - 1].movementid;
                FValues[Last].err_code     := FValues[Last - 1].err_code;
                FValues[Last].err_descr    := FValues[Last - 1].err_descr;
              end;

              FValues[Last].detail_id := getInt(detailNode.Attributes['syncid'], -1);
              CheckError('syncid', FValues[Last].detail_id, AMsgProc);

              FValues[Last].sku_id := getInt(detailNode.Attributes['sku_id'], -1);
              CheckError('sku_id', FValues[Last].sku_id, AMsgProc);

              FValues[Last].qty := getFloat(detailNode.Attributes['qty'], -1);
              CheckError('qty', FValues[Last].qty, AMsgProc);

              FValues[Last].weight := getFloat(detailNode.Attributes['real_weight'], -1);
              CheckError('real_weight', FValues[Last].weight, AMsgProc);

              FValues[Last].weight_biz := getFloat(detailNode.Attributes['weight_biz'], -1);
              CheckError('weight_biz', FValues[Last].weight_biz, AMsgProc);

              FValues[Last].production_date := MyStrToDateTime(detailNode.Attributes['production_date']);
              CheckDateTimeError('production_date', FValues[Last].production_date, AMsgProc);
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

        FValues[Last].message_type := sMessageType;
        CheckError('type', FValues[Last].message_type, AMsgProc);

        FValues[Last].header_id := getInt(headerNode.Attributes['syncid'], -1);
        CheckError('syncid', FValues[Last].header_id, AMsgProc);

        FValues[Last].movementid := getInt(headerNode.Attributes['inc_id'], -1);
        CheckError('inc_id', FValues[Last].movementid, AMsgProc);

        FValues[Last].operdate := MyStrToDateTime(headerNode.Attributes['operdate']);
        CheckDateTimeError('operdate', FValues[Last].operdate, AMsgProc);

        if headerNode.HasChildNodes then
          for J := 0 to Pred(headerNode.ChildNodes.Count) do
          begin
            detailNode := headerNode.ChildNodes[J];
            if detailNode.NodeName = 'receiving_result_detail' then
            begin
              if J > 0 then // нужно продублировать parent-значения для detailNode, если это не первая detailNode
              begin
                IncArray;
                FValues[Last].message_type := FValues[Last - 1].message_type;
                FValues[Last].header_id    := FValues[Last - 1].header_id;
                FValues[Last].movementid  := FValues[Last - 1].movementid;
                FValues[Last].err_code     := FValues[Last - 1].err_code;
                FValues[Last].err_descr    := FValues[Last - 1].err_descr;
              end;

              FValues[Last].detail_id := getInt(detailNode.Attributes['syncid'], -1);
              CheckError('syncid', FValues[Last].detail_id, AMsgProc);

              FValues[Last].sku_id := getInt(detailNode.Attributes['sku_id'], -1);
              CheckError('sku_id', FValues[Last].sku_id, AMsgProc);

              FValues[Last].qty := getFloat(detailNode.Attributes['qty'], -1);
              CheckError('qty', FValues[Last].qty, AMsgProc);

              FValues[Last].weight := getFloat(detailNode.Attributes['weight'], -1);
              CheckError('weight', FValues[Last].weight, AMsgProc);

              FValues[Last].name := getStr(detailNode.Attributes['name']);
              CheckError('name', FValues[Last].name, AMsgProc);

              FValues[Last].production_date := MyStrToDateTime(detailNode.Attributes['production_date']);
              CheckDateTimeError('production_date', FValues[Last].production_date, AMsgProc);
            end;
          end;
      end;
    end;
  except
    on E: Exception do
      if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TImportWMS.getFloat(const AttrValue: OleVariant; const ADefValue: Extended): Extended;
var
  tmpSettings: TFormatSettings;
  sValue: string;
begin
  if VarIsNull(AttrValue) then
    Exit(cErrXmlAttributeNotExists);

  tmpSettings := TFormatSettings.Create;
  sValue := AttrValue;

  if Pos('.', sValue) = 1 then // .044
   sValue := '0' + sValue;

  if tmpSettings.DecimalSeparator = ',' then
    sValue := StringReplace(sValue, '.', ',', []);

  Result := StrToFloatDef(sValue, ADefValue);
end;

function TImportWMS.getInt(const AttrValue: OleVariant; const ADefValue: Integer): Integer;
begin
  if VarIsNull(AttrValue) then
    Exit(cErrXmlAttributeNotExists);

  Result := StrToIntDef(AttrValue, ADefValue);
end;

function TImportWMS.getStr(const AttrValue: OleVariant): string;
begin
  if not VarIsNull(AttrValue) then
    Result := AttrValue
  else
    Result := cErrStrXmlAttributeNotExists;
end;

function TImportWMS.ImportPacket(const APacket: TPacketKind; AMsgProc: TNotifyMsgProc): Boolean;
var
  I, J: Integer;
  xmlDocument: IXMLDocument;
  rootNode, headerNode, detailNode: IXMLNode;
  tmpStream: TMemoryStream;
  sMessageType, sHeader_id_done, sUpdateDone: string;
const
  cNoData = 'No data <%s> to import from WMS';
begin
  tmpStream := FetchPacket(APacket);

  if tmpStream = nil then
  begin
    AMsgProc(Format(cNoData, [GetImpTypeCaption(APacket)]));
    Exit(True);
  end
  else
    Result := False;

  SetLength(FValues, 0);
  xmlDocument := TXMLDocument.Create(nil);
  xmlDocument.LoadFromStream(tmpStream);
  xmlDocument.Active := True;
  xmlDocument.SaveToFile(GetImpTypeCaption(APacket) + '.xml');
  rootNode := xmlDocument.DocumentElement;

  case APacket of
    pknOrderStatusChanged: FillArrOrderStatusChanged(rootNode, AMsgProc);
    pknReceivingResult:    FillArrReceivingResult(rootNode, AMsgProc);
  end;

  // записываем статус и коды ошибок в wms.to_host_header_message
  sHeader_id_done := '';

  if Length(FValues) > 0 then
  begin
    FWMSTrans.StartTransaction;
    try
      for I := Low(FValues) to High(FValues) do
      begin
        if FValues[I].err_code = 0 then
        begin
          sHeader_id_done := sHeader_id_done + IntToStr(FValues[I].header_id) + ',';
          Continue;
        end;

        FErrorQry.ParamByName('err_code').AsInteger := FValues[I].err_code;
        FErrorQry.ParamByName('err_descr').AsString := FValues[I].err_descr;
        FErrorQry.ParamByName('header_id').AsInteger := FValues[I].header_id;
        // коды ошибок
        FErrorQry.ExecSQL;
      end;

      if Length(sHeader_id_done) > 0 then
      begin
        sHeader_id_done := Copy(sHeader_id_done, 1, Length(sHeader_id_done) - 1);
        // статус 'done'
        sUpdateDone := 'update to_host_header_message set status=' + QuotedStr('done') + ' where id in(' + sHeader_id_done + ')';
        FDoneQry.SQL.Clear;
        FDoneQry.SQL.Add(sUpdateDone);
        FDoneQry.ExecSQL;
      end;

      FWMSTrans.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        if FWMSTrans.Active then FWMSTrans.Rollback;
        if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
      end;
    end;
  end;

  if Length(FValues) > 0 then
  begin
    try
      // записываем данные в таб. alan.wms_to_host_message
      for J := Low(FValues) to High(FValues) do
      begin
        if FValues[J].err_code <> 0 then Continue;

        FInsertQry.ParamByName('type').AsString := FValues[J].message_type;
        FInsertQry.ParamByName('header_id').AsInteger := FValues[J].header_id;
        FInsertQry.ParamByName('detail_id').AsInteger := FValues[J].detail_id;
        FInsertQry.ParamByName('movementid').AsInteger := FValues[J].movementid;
        FInsertQry.ParamByName('sku_id').AsInteger := FValues[J].sku_id;
        FInsertQry.ParamByName('name').AsString := FValues[J].name;
        FInsertQry.ParamByName('qty').AsFloat := FValues[J].qty;
        FInsertQry.ParamByName('weight').AsFloat := FValues[J].weight;
        FInsertQry.ParamByName('weight_biz').AsFloat := FValues[J].weight_biz;
        FInsertQry.ParamByName('operdate').AsDateTime := FValues[J].operdate;
        FInsertQry.ParamByName('production_date').AsDateTime := FValues[J].production_date;

        FInsertQry.ExecSQL;
      end;

      // вызов храним.процедур, которые использует данные таб. alan.wms_to_host_message
      case APacket of
        pknOrderStatusChanged: ExecuteOrderStatusChanged(AMsgProc);
        pknReceivingResult:    ExecuteReceivingResult(AMsgProc);
      end;

      Result := True;
    except
      on E: Exception do
        if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
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

{ TPacketValues }

function TPacketValues.GetErrDescr: string;
begin
  Result := Ferr_descr;
end;

procedure TPacketValues.SetErrDescr(AValue: string);
begin
  Ferr_descr := Ferr_descr + AValue;
end;

end.
