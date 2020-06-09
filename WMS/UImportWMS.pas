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
    Message_Type: string;
    Header_Id: Integer;
    Detail_Id: Integer;
    MovementId: Integer;
    SKU_Id: Integer;
    Name: string;
    Qty: Double;
    Weight: Double;
    Weight_Biz: Double;
    OperDate: TDateTime;
    Production_Date: TDateTime;
    Err_Code: Integer;
  private
    Ferr_descr: string;
    procedure SetErrDescr(AValue: string);
    function GetErrDescr: string;
  public
    property Err_Descr: string read GetErrDescr write SetErrDescr;
  end;

  TPacketValuesArray = array of TPacketValues;

  TDataObjects = record
    HeaderQry, DetailQry, InsertQry, ErrorQry, DoneQry, SelectQry, ExecQry: TFDQuery;
    WMSTrans: TFDTransaction;
  end;

  TImportWMS = class
  strict private
    FStream: TMemoryStream;
    FValues: TPacketValuesArray;
    FData: TDataObjects;
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
    constructor Create(AData: TDataObjects);
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

constructor TImportWMS.Create(AData: TDataObjects);
begin
  inherited Create;
  FData := AData;
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

  cRunProc  = 'SELECT * FROM %s(inOrderId:= %d, inSession:= %s)';
var
  sSelect, sExec: string;
begin
  sSelect := Format(cSelect, [QuotedStr(cmtOrderStatusChanged)]);

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
      try
        sExec := Format(cRunProc, [cProcName, FData.SelectQry.FieldByName('MovementId').AsInteger, QuotedStr('5')]);
        {$IFDEF DEBUG}
        if Assigned(AMsgProc) then AMsgProc(sExec);
        {$ENDIF}
        with FData.ExecQry do
        begin
          Close;
          SQL.Clear;
          SQL.Add(sExec);
          Open;
        end;
      except
        on E: Exception do
          if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
      end;

      FData.SelectQry.Next;
    end;

    FData.SelectQry.Close;
  except
    on E: Exception do
      if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

procedure TImportWMS.ExecuteReceivingResult(AMsgProc: TNotifyMsgProc);
const
  cProcName = 'gpUpdate_wms_receiving_result';

  cSelect   = 'SELECT DISTINCT Id FROM wms_to_host_message WHERE (Done = FALSE) AND (Type = %s) ORDER BY Id';

  cRunProc  = 'SELECT * FROM %s(inId:= %d, inSession:= %s)';
var
  sSelect, sExec: string;
begin
  sSelect := Format(cSelect, [QuotedStr(cmtReceivingResult)]);

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
      try
        sExec := Format(cRunProc, [
          cProcName,
          FData.SelectQry.FieldByName('Id').AsInteger,
          QuotedStr('5')
        ]);
        {$IFDEF DEBUG}
        if Assigned(AMsgProc) then AMsgProc(sExec);
        {$ENDIF}
        with FData.ExecQry do
        begin
          Close;
          SQL.Clear;
          SQL.Add(sExec);
          Open;
        end;
      except
        on E: Exception do
          if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
      end;

      FData.SelectQry.Next;
    end;

    FData.SelectQry.Close;
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
  FData.HeaderQry.Close;
  FData.DetailQry.Close;
  FStream.Size := 0;

  case APacket of
    pknOrderStatusChanged: sPacketType := cmtOrderStatusChanged;
    pknReceivingResult:    sPacketType := cmtReceivingResult;
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

        FValues[Last].MovementId := getInt(headerNode.Attributes['order_id'], -1);
        CheckError('order_id', FValues[Last].MovementId, AMsgProc);

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
              end;

              FValues[Last].Detail_Id := getInt(detailNode.Attributes['syncid'], -1);
              CheckError('syncid', FValues[Last].Detail_Id, AMsgProc);

              FValues[Last].SKU_Id := getInt(detailNode.Attributes['sku_id'], -1);
              CheckError('sku_id', FValues[Last].SKU_Id, AMsgProc);

              FValues[Last].Qty := getFloat(detailNode.Attributes['qty'], -1);
              CheckError('qty', FValues[Last].Qty, AMsgProc);

              FValues[Last].Weight := getFloat(detailNode.Attributes['real_weight'], -1);
              CheckError('real_weight', FValues[Last].Weight, AMsgProc);

              FValues[Last].Weight_Biz := getFloat(detailNode.Attributes['weight_biz'], -1);
              CheckError('weight_biz', FValues[Last].Weight_Biz, AMsgProc);

              FValues[Last].Production_Date := MyStrToDateTime(detailNode.Attributes['production_date']);
              CheckDateTimeError('production_date', FValues[Last].Production_Date, AMsgProc);
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

        FValues[Last].MovementId := getInt(headerNode.Attributes['inc_id'], -1);
        CheckError('inc_id', FValues[Last].MovementId, AMsgProc);

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
              end;

              FValues[Last].Detail_Id := getInt(detailNode.Attributes['syncid'], -1);
              CheckError('syncid', FValues[Last].Detail_Id, AMsgProc);

              FValues[Last].SKU_Id := getInt(detailNode.Attributes['sku_id'], -1);
              CheckError('sku_id', FValues[Last].SKU_Id, AMsgProc);

              FValues[Last].Qty := getFloat(detailNode.Attributes['qty'], -1);
              CheckError('qty', FValues[Last].Qty, AMsgProc);

              FValues[Last].Weight := getFloat(detailNode.Attributes['weight'], -1);
              CheckError('weight', FValues[Last].Weight, AMsgProc);

              FValues[Last].Name := getStr(detailNode.Attributes['name']);
              CheckError('name', FValues[Last].Name, AMsgProc);

              FValues[Last].Production_Date := MyStrToDateTime(detailNode.Attributes['production_date']);
              CheckDateTimeError('production_date', FValues[Last].Production_Date, AMsgProc);
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
    FData.WMSTrans.StartTransaction;
    try
      for I := Low(FValues) to High(FValues) do
      begin
        if FValues[I].Err_Code = 0 then
        begin
          sHeader_id_done := sHeader_id_done + IntToStr(FValues[I].Header_Id) + ',';
          Continue;
        end;

        with FData.ErrorQry do
        begin
          ParamByName('Err_Code').AsInteger  := FValues[I].Err_Code;
          ParamByName('Err_Descr').AsString  := FValues[I].Err_Descr;
          ParamByName('Header_Id').AsInteger := FValues[I].Header_Id;
          // коды ошибок
          ExecSQL;
        end;
      end;

      if Length(sHeader_id_done) > 0 then
      begin
        sHeader_id_done := Copy(sHeader_id_done, 1, Length(sHeader_id_done) - 1);
        // статус 'done'
        sUpdateDone := 'update to_host_header_message set status=' + QuotedStr('done') + ' where id in(' + sHeader_id_done + ')';
        with FData.DoneQry do
        begin
          SQL.Clear;
          SQL.Add(sUpdateDone);
          ExecSQL;
        end;
      end;

      FData.WMSTrans.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        if FData.WMSTrans.Active then FData.WMSTrans.Rollback;
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
        if FValues[J].Err_Code <> 0 then Continue;

        with FData.InsertQry do
        begin
          ParamByName('type').AsString := FValues[J].Message_Type;
          ParamByName('Header_Id').AsInteger := FValues[J].Header_Id;
          ParamByName('Detail_Id').AsInteger := FValues[J].Detail_Id;
          ParamByName('MovementId').AsInteger := FValues[J].MovementId;
          ParamByName('SKU_Id').AsInteger := FValues[J].SKU_Id;
          ParamByName('Name').AsString := FValues[J].Name;
          ParamByName('Qty').AsFloat := FValues[J].Qty;
          ParamByName('Weight').AsFloat := FValues[J].Weight;
          ParamByName('Weight_Biz').AsFloat := FValues[J].Weight_Biz;
          ParamByName('OperDate').AsDateTime := FValues[J].OperDate;
          ParamByName('Production_Date').AsDateTime := FValues[J].Production_Date;
          ExecSQL;
        end;
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
