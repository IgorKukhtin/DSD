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
    movement_id: Integer;
    sku_id: Integer;
    name: string;
    qty: Double;
    weight: Double;
    weight_biz: Double;
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
    FAlanTrans: TFDTransaction;
    FWMSTrans: TFDTransaction;
    FStream: TMemoryStream;
    FValues: TPacketValuesArray;
  strict private
    procedure IncArray; // Inc size of array FValues
    function Last: Integer; // Return High(FValues)
    function getStr(const AttrValue: OleVariant): string;
    function getInt(const AttrValue: OleVariant; const ADefValue: Integer): Integer;
    function getFloat(const AttrValue: OleVariant; const ADefValue: Extended): Extended;
    procedure CheckError(const Attr: string; const AttrValue: Integer; AErrProc: TNotifyMsgProc); overload;
    procedure CheckError(const Attr: string; const AttrValue: Extended; AErrProc: TNotifyMsgProc); overload;
    procedure CheckError(const Attr, AttrValue: string; AErrProc: TNotifyMsgProc); overload;
    procedure CheckDateTimeError(const Attr: string; const AttrValue: TDateTime; AErrProc: TNotifyMsgProc); overload;
  strict private
    procedure FillArrOrderStatusChanged(const ARoot: IXMLNode; AErrProc: TNotifyMsgProc);
    procedure FillArrReceivingResult(const ARoot: IXMLNode; AErrProc: TNotifyMsgProc);
  strict private
    function FetchPacket(APacket: TPacketKind): TMemoryStream;
  public
    constructor Create(AHeaderQry, ADetailQry, AInsertQry, AErrorQry, ADoneQry: TFDQuery;
                       AAlanTrans, AWMSTrans: TFDTransaction);
    destructor Destroy; override;
    function ImportPacket(const APacket: TPacketKind; AErrProc: TNotifyMsgProc; AStoredProc: TFDStoredProc): Boolean;
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

// "11-09-2019 15:43" -> TDateTime
function MyStrToDateTime(const AValue: string): TDateTime;
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

procedure TImportWMS.CheckDateTimeError(const Attr: string; const AttrValue: TDateTime; AErrProc: TNotifyMsgProc);
begin
  if AttrValue = cZeroDateTime then
  begin
    FValues[Last].err_code := cImpErrInvalidDateTime;
    FValues[Last].err_descr := Format(cImpErrDescr_InvalidDate, [Attr]);
    if Assigned(AErrProc) then AErrProc(Format(cImpErrDescr_InvalidDate, [Attr]));
  end;

  if AttrValue = cErrXmlAttributeNotExists then
  begin
    FValues[Last].err_code := cImpErrAttrNotExists;
    FValues[Last].err_descr := Format(cImpErrDecr_AttrNotExists, [Attr]);
    if Assigned(AErrProc) then AErrProc(Format(cImpErrDecr_AttrNotExists, [Attr]));
  end;
end;

procedure TImportWMS.CheckError(const Attr, AttrValue: string; AErrProc: TNotifyMsgProc);
begin
  if AttrValue = cErrStrXmlAttributeNotExists then
  begin
    FValues[Last].err_code := cImpErrAttrNotExists;
    FValues[Last].err_descr := Format(cImpErrDecr_AttrNotExists, [Attr]);
    if Assigned(AErrProc) then AErrProc(Format(cImpErrDecr_AttrNotExists, [Attr]));
  end;
end;

procedure TImportWMS.CheckError(const Attr: string; const AttrValue: Integer; AErrProc: TNotifyMsgProc);
begin
  if AttrValue = -1 then
  begin
    FValues[Last].err_code := cImpErrWrongType;
    FValues[Last].err_descr := Format(cImpErrDescr_NotInteger, [Attr]);
    if Assigned(AErrProc) then AErrProc(Format(cImpErrDescr_NotInteger, [Attr]));
  end;

  if AttrValue = cErrXmlAttributeNotExists then
  begin
    FValues[Last].err_code := cImpErrAttrNotExists;
    FValues[Last].err_descr := Format(cImpErrDecr_AttrNotExists, [Attr]);
    if Assigned(AErrProc) then AErrProc(Format(cImpErrDecr_AttrNotExists, [Attr]));
  end;
end;

procedure TImportWMS.CheckError(const Attr: string; const AttrValue: Extended; AErrProc: TNotifyMsgProc);
begin
  if AttrValue = -1 then
  begin
    FValues[Last].err_code := cImpErrWrongType;
    FValues[Last].err_descr := Format(cImpErrDescr_NotNumeric, [Attr]);
    if Assigned(AErrProc) then AErrProc(Format(cImpErrDescr_NotNumeric, [Attr]));
  end;

  if AttrValue = cErrXmlAttributeNotExists then
  begin
    FValues[Last].err_code := cImpErrAttrNotExists;
    FValues[Last].err_descr := Format(cImpErrDecr_AttrNotExists, [Attr]);
    if Assigned(AErrProc) then AErrProc(Format(cImpErrDecr_AttrNotExists, [Attr]));
  end;
end;

constructor TImportWMS.Create(AHeaderQry, ADetailQry, AInsertQry, AErrorQry, ADoneQry: TFDQuery;
  AAlanTrans, AWMSTrans: TFDTransaction);
begin
  inherited Create;
  FHeader := AHeaderQry;
  FDetail := ADetailQry;
  FInsertQry := AInsertQry;
  FErrorQry := AErrorQry;
  FDoneQry := ADoneQry;
  FAlanTrans := AAlanTrans;
  FWMSTrans := AWMSTrans;

  FStream := TMemoryStream.Create;
end;

destructor TImportWMS.Destroy;
begin
  FreeAndNil(FStream);
  inherited;
end;

function TImportWMS.FetchPacket(APacket: TPacketKind): TMemoryStream;
var
  sPacketType: string;
  sLine: string;
  sXmlHeader, sXmlFooter: string;
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

procedure TImportWMS.FillArrOrderStatusChanged(const ARoot: IXMLNode; AErrProc: TNotifyMsgProc);
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
        CheckError('type', FValues[Last].message_type, AErrProc);

        FValues[Last].header_id := getInt(headerNode.Attributes['syncid'], -1);
        CheckError('syncid', FValues[Last].header_id, AErrProc);

        FValues[Last].movement_id := getInt(headerNode.Attributes['order_id'], -1);
        CheckError('order_id', FValues[Last].movement_id, AErrProc);

        if headerNode.HasChildNodes then
          for J := 0 to Pred(headerNode.ChildNodes.Count) do
          begin
            detailNode := headerNode.ChildNodes[J];
            if detailNode.NodeName = 'order_status_changed_detail' then
            begin
              if J > 0 then // ����� �������������� parent-�������� ��� detailNode, ���� ��� �� ������ detailNode
              begin
                IncArray;
                FValues[Last].message_type := FValues[Last - 1].message_type;
                FValues[Last].header_id    := FValues[Last - 1].header_id;
                FValues[Last].movement_id  := FValues[Last - 1].movement_id;
                FValues[Last].err_code     := FValues[Last - 1].err_code;
                FValues[Last].err_descr    := FValues[Last - 1].err_descr;
              end;

              FValues[Last].detail_id := getInt(detailNode.Attributes['syncid'], -1);
              CheckError('syncid', FValues[Last].detail_id, AErrProc);

              FValues[Last].sku_id := getInt(detailNode.Attributes['sku_id'], -1);
              CheckError('sku_id', FValues[Last].sku_id, AErrProc);

              FValues[Last].qty := getFloat(detailNode.Attributes['qty'], -1);
              CheckError('qty', FValues[Last].qty, AErrProc);

              FValues[Last].weight := getFloat(detailNode.Attributes['real_weight'], -1);
              CheckError('real_weight', FValues[Last].weight, AErrProc);

              FValues[Last].weight_biz := getFloat(detailNode.Attributes['weight_biz'], -1);
              CheckError('weight_biz', FValues[Last].weight_biz, AErrProc);

              FValues[Last].production_date := MyStrToDateTime(detailNode.Attributes['production_date']);
              CheckDateTimeError('production_date', FValues[Last].production_date, AErrProc);
            end;
          end;
      end;
    end;
  except
    on E: Exception do
      if Assigned(AErrProc) then AErrProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TImportWMS.FillArrReceivingResult(const ARoot: IXMLNode; AErrProc: TNotifyMsgProc);
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
        CheckError('type', FValues[Last].message_type, AErrProc);

        FValues[Last].header_id := getInt(headerNode.Attributes['syncid'], -1);
        CheckError('syncid', FValues[Last].header_id, AErrProc);

        FValues[Last].movement_id := getInt(headerNode.Attributes['inc_id'], -1);
        CheckError('inc_id', FValues[Last].movement_id, AErrProc);

        if headerNode.HasChildNodes then
          for J := 0 to Pred(headerNode.ChildNodes.Count) do
          begin
            detailNode := headerNode.ChildNodes[J];
            if detailNode.NodeName = 'receiving_result_detail' then
            begin
              if J > 0 then // ����� �������������� parent-�������� ��� detailNode, ���� ��� �� ������ detailNode
              begin
                IncArray;
                FValues[Last].message_type := FValues[Last - 1].message_type;
                FValues[Last].header_id    := FValues[Last - 1].header_id;
                FValues[Last].movement_id  := FValues[Last - 1].movement_id;
                FValues[Last].err_code     := FValues[Last - 1].err_code;
                FValues[Last].err_descr    := FValues[Last - 1].err_descr;
              end;

              FValues[Last].detail_id := getInt(detailNode.Attributes['syncid'], -1);
              CheckError('syncid', FValues[Last].detail_id, AErrProc);

              FValues[Last].sku_id := getInt(detailNode.Attributes['sku_id'], -1);
              CheckError('sku_id', FValues[Last].sku_id, AErrProc);

              FValues[Last].qty := getFloat(detailNode.Attributes['qty'], -1);
              CheckError('qty', FValues[Last].qty, AErrProc);

              FValues[Last].weight := getFloat(detailNode.Attributes['weight'], -1);
              CheckError('weight', FValues[Last].weight, AErrProc);

              FValues[Last].name := getStr(detailNode.Attributes['name']);
              CheckError('name', FValues[Last].name, AErrProc);

              FValues[Last].production_date := MyStrToDateTime(detailNode.Attributes['production_date']);
              CheckDateTimeError('production_date', FValues[Last].production_date, AErrProc);
            end;
          end;
      end;
    end;
  except
    on E: Exception do
      if Assigned(AErrProc) then AErrProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TImportWMS.getFloat(const AttrValue: OleVariant; const ADefValue: Extended): Extended;
begin
  if VarIsNull(AttrValue) then
    Exit(cErrXmlAttributeNotExists);

  Result := StrToFloatDef(AttrValue, ADefValue);
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

function TImportWMS.ImportPacket(const APacket: TPacketKind; AErrProc: TNotifyMsgProc; AStoredProc: TFDStoredProc): Boolean;
var
  I, J: Integer;
  xmlDocument: IXMLDocument;
  rootNode, headerNode, detailNode: IXMLNode;
  tmpStream: TMemoryStream;
  sMessageType, sHeader_id_done, sUpdateDone: string;
//  sSelectOrderStatusChanged: string;
const
  cNoData = 'No data <%s> to import from WMS';
begin
  tmpStream := FetchPacket(APacket);

  if tmpStream = nil then
  begin
    AErrProc(Format(cNoData, [GetImpTypeCaption(APacket)]));
    Exit(True);
  end
  else
    Result := False;

  SetLength(FValues, 0);
  xmlDocument := TXMLDocument.Create(nil);
  xmlDocument.LoadFromStream(tmpStream);
  xmlDocument.Active := True;
//  xmlDocument.SaveToFile(GetImpTypeCaption(APacket) + '.xml');
  rootNode := xmlDocument.DocumentElement;

  case APacket of
    pknOrderStatusChanged: FillArrOrderStatusChanged(rootNode, AErrProc);
    pknReceivingResult:    FillArrReceivingResult(rootNode, AErrProc);
  end;

  // ���������� ������ � ���� ������ � wms.to_host_header_message
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
        // ���� ������
        FErrorQry.ExecSQL;
      end;

      if Length(sHeader_id_done) > 0 then
      begin
        sHeader_id_done := Copy(sHeader_id_done, 1, Length(sHeader_id_done) - 1);
        // ������ 'done'
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
        if Assigned(AErrProc) then AErrProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
      end;
    end;
  end;

  if Length(FValues) > 0 then
  begin
    FAlanTrans.StartTransaction;
    try
      // ���������� ������ � ���. alan.wms_to_host_message
      for J := Low(FValues) to High(FValues) do
      begin
        if FValues[J].err_code <> 0 then Continue;

        FInsertQry.ParamByName('type').AsString := FValues[J].message_type;
        FInsertQry.ParamByName('header_id').AsInteger := FValues[J].header_id;
        FInsertQry.ParamByName('detail_id').AsInteger := FValues[J].detail_id;
        FInsertQry.ParamByName('movement_id').AsInteger := FValues[J].movement_id;
        FInsertQry.ParamByName('sku_id').AsInteger := FValues[J].sku_id;
        FInsertQry.ParamByName('name').AsString := FValues[J].name;
        FInsertQry.ParamByName('qty').AsFloat := FValues[J].qty;
        FInsertQry.ParamByName('weight').AsFloat := FValues[J].weight;
        FInsertQry.ParamByName('weight_biz').AsFloat := FValues[J].weight_biz;
        FInsertQry.ParamByName('production_date').AsDateTime := FValues[J].production_date;

        FInsertQry.ExecSQL;
      end;

      // ������.����., ������� ���������� ������ ���. alan.wms_to_host_message
      if AStoredProc <> nil then
        AStoredProc.ExecProc;

      FAlanTrans.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        if FAlanTrans.Active then FAlanTrans.Rollback;
        if Assigned(AErrProc) then AErrProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
      end;
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
