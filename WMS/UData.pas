unit UData;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, FireDAC.Phys.Oracle,
  FireDAC.Phys.OracleDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  Vcl.ExtCtrls, FireDAC.Comp.Client, Data.DB, FireDAC.Comp.DataSet,
  UDefinitions, FireDAC.Moni.Base, FireDAC.Moni.Custom, FireDAC.Moni.RemoteClient, UQryThread;

type
  TSite = (stAlan, stWMS);

  TdmData = class(TDataModule)
    FDC_alan: TFDConnection;
    FDC_wms: TFDConnection;
    sp_alan_insert_packets_to_wms: TFDStoredProc;
    sp_alan_insert_packets_from_wms: TFDStoredProc;
    spInsert_wms_Message: TFDStoredProc;
    to_wms_Message_query: TFDQuery;
    to_wms_Packets_query: TFDQuery;
    from_wms_PacketsHeader_query: TFDQuery;
    from_wms_PacketsDetail_query: TFDQuery;
    insert_wms_to_host_message: TFDQuery;
    FDT_wms: TFDTransaction;
    update_wms_to_host_header_message_error: TFDQuery;
    update_wms_to_host_header_message_done: TFDQuery;
    select_wms_to_host_message: TFDQuery;
    alan_exec_qry: TFDQuery;
    dsWMS: TDataSource;
    dsAlan: TDataSource;
    qryWMSGridErr: TFDQuery;
    qryAlanGrid: TFDQuery;
    qryWMSGridAll: TFDQuery;
    qryWmsToHostMessage: TFDQuery;
    dsWmsToHostMessage: TDataSource;
    wms_from_host_header_error: TFDQuery;
    max_headerId_from_host_header_error: TFDQuery;
    qryAlanGridFromHost: TFDQuery;
    dsWmsMessage: TDataSource;
    qryWmsMessageAll: TFDQuery;
    qryWmsMessageErr: TFDQuery;
    dsWmsFromHostError: TDataSource;
    dsWMSDetail: TDataSource;
    qryWMSDetail: TFDQuery;
    dsFromHostMessage: TDataSource;
    qryFromHostMessageAll: TFDQuery;
    qryFromHostMessageErr: TFDQuery;
    dsFromHostDetail: TDataSource;
    qryFromHostDetail: TFDQuery;
    qryInsert_wms_Message: TFDQuery;
  private
    procedure Insert_wms_from_host_error(const AHeaderId, AWmsMsgId: Integer; const ASite: TSite;
      const APacketName, AErrDescription: string; AMsgProc: TNotifyMsgProc);
  private
    function InjectAttributeToXml(const AOrigXml, AAttributeName, AAttributeValue: string): string;
    function GetIdFromAttribute(const AMessage, AAttribute: string; AMsgProc: TNotifyMsgProc): Integer;
  public
    // ����� spName - ������ Insert � ����. Postresql.wms_Message - ��� GUID
    function gpInsert_wms_Message(spName, GUID: string): Integer;
    // �������� � Oracle - pack_id - ����� ����� �������� ������
    function p_alan_insert_packets_to_wms: Integer;
    //
    function fInsert_to_wms_SKU(const ADebug: Boolean;
      AMyLogSql, AMyShowSql: TNotifyProc; AMsgProc: TNotifyMsgProc): Integer;
    function fInsert_to_wms_CLIENT(const ADebug: Boolean;
      AMyLogSql, AMyShowSql: TNotifyProc; AMsgProc: TNotifyMsgProc): Integer;
    function fInsert_to_wms_SKU_all(const ACheckRecCount, ADebug: Boolean;
      const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc;
      AMsgProc: TNotifyMsgProc): Integer;
    function fInsert_to_wms_SKU_CODE_all(const ACheckRecCount, ADebug: Boolean;
      const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc;
      AMsgProc: TNotifyMsgProc): Integer;
    function fInsert_to_wms_SKU_GROUP_all(const ACheckRecCount, ADebug: Boolean;
      const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc;
      AMsgProc: TNotifyMsgProc): Integer;
    function fInsert_to_wms_CLIENT_all(const ACheckRecCount, ADebug: Boolean;
      const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc;
      AMsgProc: TNotifyMsgProc): Integer;
    function fInsert_to_wms_PACK_all(const ACheckRecCount, ADebug: Boolean;
      const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc;
      AMsgProc: TNotifyMsgProc): Integer;
    function fInsert_to_wms_USER_all(const ACheckRecCount, ADebug: Boolean;
      const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc;
      AMsgProc: TNotifyMsgProc): Integer;
    procedure pInsert_to_wms_Movement_INCOMING_all(var lRecCount, lpack_id: Integer;
      const ACheckRecCount, ADebug: Boolean;
      const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc;
      AMsgProc: TNotifyMsgProc);
    procedure pInsert_to_wms_Movement_ASN_LOAD_all(var lRecCount, lpack_id: Integer;
      const ACheckRecCount, ADebug: Boolean;
      const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc;
      AMsgProc: TNotifyMsgProc);
    procedure pInsert_to_wms_Movement_ORDER_all(var lRecCount, lpack_id: Integer;
      const ACheckRecCount, ADebug: Boolean;
      const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc;
      AMsgProc: TNotifyMsgProc);
    procedure Insert_error_from_host_header_message(AMsgProc: TNotifyMsgProc);

    // ������ Postresql.CLOCK_TIMESTAMP
    function fGet_GUID_pg: string;
    // ������ ����������� ������ � ����. Postresql.wms_Message
    function fInsert_wms_Message_pg(pgProcName, GUID: string; AMsgProc: TNotifyMsgProc): Integer;
    // ����������� ������ �� ����. Postresql.wms_Message ��� GUID � ����������� � oracle
    function fInsert_wms_Message_to_wms(pgProcName, GUID, aPacketName: string; const ACheckRecCount, ADebug: Boolean;
      const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc; AMsgProc: TNotifyMsgProc): Integer;
    // ����������� ������ �� ����. Postresql.Movement � ����������� � oracle
    function fInsert_Movement_to_wms(const pgProcName, GUID, aPacketName: string; const ACheckRecCount, ADebug: Boolean;
      const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc; AMsgProc: TNotifyMsgProc): Integer;
    function ImportWMS(const APacket: TPacketKind; AMsgProc: TNotifyMsgProc): Boolean;
  public
    function ConnectWMS(const ADatabase: string; AMsgProc: TNotifyMsgProc): Boolean;
    function ConnectAlan(const AServer: string; AMsgProc: TNotifyMsgProc): Boolean;
    function IsConnectedWMS(AMsgProc: TNotifyMsgProc): Boolean;
    function IsConnectedAlan(AMsgProc: TNotifyMsgProc): Boolean;
    function IsConnectedBoth(AMsgProc: TNotifyMsgProc): Boolean;
    procedure CloseConnections;
  end;

  PExportData = ^TExportData;
  TExportData = record
    RecCount, ThresholdRecCount, Pack_id: Integer;
    UseRecCount, UseDebug: Boolean;
    LogSqlProc, ShowSqlProc: TNotifyProc;
    ShowMsgProc: TNotifyMsgProc;
  end;

  TWorkerThread = class(TThread)
  strict private
    FData: TdmData;
  strict private
    function GetReturnValue: Integer;
  protected
    FMsgProc: TNotifyMsgProc;
    FLogSql: TNotifyProc;
    FShowSql: TNotifyProc;
  protected
    procedure InnerMsgProc(const AMsg: string);
    procedure InnerLogSqlProc;
    procedure InnerShowSqlProc;
    procedure MySleep(const AInterval: Cardinal);
    property Data: TdmData read FData;
  public
    constructor Create(CreateSuspended: Boolean; AMsgProc: TNotifyMsgProc; AKind: TThreadKind = tknNondriven); reintroduce;
    destructor Destroy; override;
    property MyReturnValue: Integer read GetReturnValue;
  end;

  TImportWorkerThread = class(TWorkerThread)
  strict private
    FPacket: TPacketKind;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean; const APacket: TPacketKind; AMsgProc: TNotifyMsgProc;
      AKind: TThreadKind = tknNondriven); reintroduce;
  end;

  TExportWorkerThread = class(TWorkerThread)
  strict private
    FPacket: TPacketKind;
    FData: TExportData;
  strict private
    function GetPacketName: string;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean; AExportData: TExportData; const APacket: TPacketKind;
      AMsgProc: TNotifyMsgProc; AKind: TThreadKind = tknNondriven); reintroduce;
    property PacketName: string read GetPacketName;
  end;

  TProcessExportDataErrorThread = class(TWorkerThread)
  protected
    procedure Execute; override;
  end;

  EData = class(Exception);
    EWrongDate = class(EData);

var
  dmData: TdmData;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  System.Variants,
  System.TypInfo,
  Winapi.ActiveX,
  Xml.XMLIntf,
  Xml.XMLDoc,
  USettings,
  UConstants,
  UImportWMS,
  UCommon;

{ TdmData }

procedure TdmData.CloseConnections;
begin
  FDC_alan.Close;
  FDC_wms.Close;
end;

function TdmData.ConnectAlan(const AServer: string; AMsgProc: TNotifyMsgProc): Boolean;
begin
  with FDC_alan do
  begin
    Result := Connected;

    if not Result then
    begin
      Params.Values['Server'] := AServer;
      try
        Connected := True;
        Result := Connected;
      except
        on E: Exception do
        begin
          Result := False;
          if Assigned(AMsgProc) then
            AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
        end;
      end;
    end;
  end;
end;

function TdmData.ConnectWMS(const ADatabase: string; AMsgProc: TNotifyMsgProc): Boolean;
begin
  with FDC_wms do
  begin
    Result := Connected;

    if not Result then
    try
      Params.Database := ADatabase;
      Connected := True;
      Result := Connected;
    except
      on E: Exception do
      begin
        Result := False;
        if Assigned(AMsgProc) then
          AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
      end;
    end;
  end;
end;

function TdmData.fGet_GUID_pg: string;
begin
  with to_wms_Message_query do
  begin
    Close;
       //
    Sql.Clear;
    Sql.Add('SELECT CLOCK_TIMESTAMP() AS RetV');
    Open;
       //
    Result := DateTimeToStr(FieldByName('RetV').AsDateTime);
  end;
end;

function TdmData.fInsert_Movement_to_wms(const pgProcName, GUID, aPacketName: string;
  const ACheckRecCount, ADebug: Boolean; const AThresholdRecCount: Integer;
  AMyLogSql, AMyShowSql: TNotifyProc; AMsgProc: TNotifyMsgProc): Integer;
var
  ii, iWmsMsgId: Integer;
begin
  Result := 0;
     //
  with to_wms_Message_query do
  begin
    Close;
       //
    Sql.Clear;
    Sql.Add(' SELECT * FROM wms_Message' + ' WHERE GUID     = ' + chr(39) + GUID + chr(39)//            +'   and ProcName = ' + chr(39) + pgProcName + chr(39)
      + ' ORDER BY GroupId, RowNum');
    Open;

    iWmsMsgId := 0;

    if not FieldByName('Id').IsNull then
      iWmsMsgId := FieldByName('Id').AsInteger;
       //
    if not (Active) then
      if Assigned(AMsgProc) then AMsgProc('Err = Open = Postgresql = wms_Message = ' + pgProcName);
       //
       //
    if ACheckRecCount and (AThresholdRecCount = 0) then Exit(-1);
//    begin
//      Result := -1;
//      exit;
//    end;
       //
       //
       //����� ����� ����������� �����
    to_wms_Packets_query.SQL.Clear;
       {to_wms_Packets_query.SQL.Add('begin');
       to_wms_Packets_query.SQL.Add('  insert into WMS.packets_to_wms (process_start)'
                                  + '     values (now()) returning pack_id into vb_pack_id;'
                                   );}
       //
    ii := 0;
    First;
    while not EOF do
    begin
            // ���������
      if FieldByName('RowNum').AsInteger = 0 then
      begin
                  // �� ����� ��������� � �������
        if to_wms_Packets_query.SQL.Count > 0 then
        begin
                       // ���� ���� ������ ��������� - ��� �����
          ii := ii + 1;
          if ACheckRecCount and (AThresholdRecCount = ii) then
            break;
                       //
                       // ������� ��������� ������
          to_wms_Packets_query.SQL.Add('commit;');
          to_wms_Packets_query.SQL.Add('end;');
                       //
          if ADebug then
          begin
            if Assigned(AMyLogSql) then AMyLogSql;
            if Assigned(AMyShowSql) then AMyShowSql;
//
//            myLogSql;
//            myShowSql;
          end;
                       // ��������� ���� ��������� � � ���������
          try
            to_wms_Packets_query.ExecSQL;
          except
            on E: Exception do
            begin
              Insert_wms_from_host_error(-1, to_wms_Message_query.FieldByName('Id').AsInteger, stAlan, aPacketName, E.Message, AMsgProc);
              if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
              if Assigned(AMyLogSql) then AMyLogSql;
              if Assigned(AMyShowSql) then AMyShowSql;
              Exit;
            end;
          end;
        end;
                  //
                  // ������ �������
        to_wms_Packets_query.SQL.Clear;
                  // ����� ����� ����������� �����
        to_wms_Packets_query.SQL.Add('declare');
        to_wms_Packets_query.SQL.Add('  vb_id WMS.from_host_header_message.id%TYPE;');
        to_wms_Packets_query.SQL.Add('begin');
                  // ���������
        to_wms_Packets_query.SQL.Add('insert into WMS.from_host_header_message' + ' (SRC_HOST_ID, DST_HOST_ID' + ', TYPE' // VARCHAR2(64) - ��� ��������� (��� ���������)
          + ', ACTION'        // VARCHAR2(16)    - �������� (update/insert/delete)
            //              +', CREATED'        // DATE            - ���� �������� ������ (����������� �������������)
          + ', STATUS'        // VARCHAR2(16)    - ������� ������ ��������� (ready � ������ ������ � ��������� done � ������ ������� ���������� error � ������ ���������� � �������)
            //              +', START_DATE'     // DATE            - ���� ������ ���������
            //                +', FINISH_DATE'    // DATE            - ���� ��������� ���������
          + ', MESSAGE'       // VARCHAR2(2048)  - Xml-��������� ��� ���������
            //              +', ERR_CODE'       // NUMBER          - ��� ������ ��� ��������� �                                                                                        �������
            //              +', ERR_DESCR'      // VARCHAR2(2048)  - �������� ������
          + ')' + ' values (' + chr(39) + 'kpl' + chr(39) + '        ,' +
                                chr(39) + 'kpl' + chr(39) + '        ,' +
                                chr(39) + FieldByName('TagName').AsString + chr(39) + '        ,' +
                                chr(39) + FieldByName('ActionName').AsString + chr(39) + '        ,' +
                                chr(39) + 'ready' + chr(39) + '        ,' +
                                chr(39) + InjectAttributeToXml(
                                            FieldByName('RowData').AsString,
                                            cWms_message_Id_Attr,
                                            IntToStr(iWmsMsgId)) + chr(39) + '         )' +
          '       returning id into vb_id;');
                  //
        to_wms_Packets_query.SQL.Add('commit;');
      end
      else                //�������� �����
        to_wms_Packets_query.SQL.Add('insert into WMS.from_host_detail_message' + ' (HEADER_ID' + ', TYPE'  // VARCHAR2(64)    - ��� ��������� (��� ���������)
          + ', ACTION'        // VARCHAR2(16)    - �������� (update/insert/delete)
          //        +', CREATED'        // DATE            - ���� �������� ������ (����������� �������������)
          + ', STATUS'        // VARCHAR2(16)    - ������� ������ ��������� (ready � ������ ������ � ��������� done � ������ ������� ���������� error � ������ ���������� � �������)
          //        +', START_DATE'     // DATE            - ���� ������ ���������
          //        +', FINISH_DATE'    // DATE            - ���� ��������� ���������
          + ', MESSAGE'       // VARCHAR2(2048)  - Xml-��������� ��� ���������
          //        +', ERR_CODE'       // NUMBER          - ��� ������ ��� ��������� �                                                                                        �������
          //        +', ERR_DESCR'      // VARCHAR2(2048)  - �������� ������
          + ')' + ' values (vb_id' + '        ,' + chr(39) +
                            FieldByName('TagName').AsString + chr(39) + '        ,' +
                            chr(39) + FieldByName('ActionName').AsString + chr(39) + '        ,' +
                            chr(39) + 'ready' + chr(39) + '        ,' +
                            chr(39) + FieldByName('RowData').AsString + chr(39) + '         );');
            //
            // ������ ������
      Next;
    end;
       //
    Close;
  end;
     //
  if to_wms_Packets_query.Sql.Count > 0 then
  begin
         // ������� ��������� ������
    to_wms_Packets_query.SQL.Add('commit;');
    to_wms_Packets_query.SQL.Add('end;');
         //
    if ADebug then
      if Assigned(AMyShowSql) then AMyShowSql;//myShowSql;
         // ��������� ��������� XML � wms
    try
      to_wms_Packets_query.ExecSQL;
    except
      on E: Exception do
      begin
        Insert_wms_from_host_error(-1, iWmsMsgId, stAlan, aPacketName, E.Message, AMsgProc);
        if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
        if Assigned(AMyLogSql) then AMyLogSql;
        if Assigned(AMyShowSql) then AMyShowSql;
        Exit;
      end;
    end;
  end;
     //
  Result := -1;
end;

function TdmData.fInsert_to_wms_CLIENT(const ADebug: Boolean;
  AMyLogSql, AMyShowSql: TNotifyProc; AMsgProc: TNotifyMsgProc): Integer;
var
  spName: string;
  lGUID: string;
  i: Integer;
  vb_pack_id: Integer;
begin
  Result := 0;
  try
    if not IsConnectedBoth(AMsgProc) then Exit;

     //
     // ��������� � �������� ������ - SKU
    spName := 'gpInsert_wms_Object_CLIENT';
    lGUID := fGet_GUID_pg;
     //
     // ������ ����������� ������ � ����. Postresql.wms_Message
    if fInsert_wms_Message_pg(spName, lGUID, AMsgProc) < 0 then
      exit;
     //
     //
    with to_wms_Message_query do
    begin
      Close;
       //
      Sql.Clear;
      Sql.Add('SELECT * FROM wms_Message WHERE ProcName = ' + chr(39) + spName + chr(39));
      Open;
       //
      if not (Active) then
        if Assigned(AMsgProc) then AMsgProc('Err = Open = alan = wms_Message = ' + spName);
       //
       // !!! insert pack_id
      vb_pack_id := p_alan_insert_packets_to_wms;
       //
       //
       //����� ����� ����������� �����
      to_wms_Packets_query.SQL.Clear;
      to_wms_Packets_query.SQL.Add('begin');
       //to_wms_Packets_query.Params.ArraySize:= 12000;
       //
      i := 0;
      First;
      while not EOF do
      begin
        i := i + 1;
            //
        if (i >= 2) and (1 = 1) then
        begin
          to_wms_Packets_query.SQL.Add('commit;');
          to_wms_Packets_query.SQL.Add('end;');
                 // ��������� ��������� XML � wms
          try
            to_wms_Packets_query.ExecSQL;
          except
            on E: Exception do
            begin
              if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
              if Assigned(AMyLogSql) then AMyLogSql;
              if Assigned(AMyShowSql) then AMyShowSql;
            end;
          end;
                 //
          to_wms_Packets_query.SQL.Clear;
          to_wms_Packets_query.SQL.Add('begin');
                 //�������� �������
          i := 0;
        end;
            // ����������� ��������� XML � �����
        to_wms_Packets_query.SQL.Add('insert into WMS.xml_data_to_wms (pack_id, line, Data)' + ' values (' + IntToStr(vb_pack_id) + '        ,' + IntToStr(FieldByName('RowNum').AsInteger) + '        ,' + chr(39) + FieldByName('RowData').AsString + chr(39) + '         );');
        Next;
      end;
       //
      Close;
    end;
     //
     // ������� ��������� ������
    to_wms_Packets_query.SQL.Add('commit;');
    to_wms_Packets_query.SQL.Add('end;');
     //
    if ADebug then
    begin
      if Assigned(AMyLogSql) then AMyLogSql;
      if Assigned(AMyShowSql) then AMyShowSql;
    end;
     // ��������� ��������� XML � wms
    try
      to_wms_Packets_query.ExecSQL;
    except
      on E: Exception do
      begin
        if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
        if Assigned(AMyLogSql) then AMyLogSql;
        if Assigned(AMyShowSql) then AMyShowSql;
      end;
    end;

  finally
    FDC_wms.Connected := false;
    FDC_alan.Connected := false;
  end;
   //
  Result := vb_pack_id;
end;

function TdmData.fInsert_to_wms_CLIENT_all(const ACheckRecCount, ADebug: Boolean;
  const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc;
  AMsgProc: TNotifyMsgProc): Integer;
var
  spName: string;
  lGUID: string;
begin
  Result := 0;
  try
    if not IsConnectedBoth(AMsgProc) then Exit;

     //
     // ��������� � �������� ������ - SKU_GROUP + SKU_DEPENDS
    spName := 'gpInsert_wms_Object_CLIENT';
    lGUID := fGet_GUID_pg;
     //
     // ������ ����������� ������ � ����. Postresql.wms_Message
    if fInsert_wms_Message_pg(spName, lGUID, AMsgProc) < 0 then
      exit;
     //
     // ����������� ������ �� ����. Postresql.wms_Message � ����������� � oracle
    Result := fInsert_wms_Message_to_wms(
      spName, lGUID, cpnWMSObjectClient, ACheckRecCount, ADebug, AThresholdRecCount, AMyLogSql, AMyShowSql, AMsgProc);
     //
  finally
    FDC_wms.Connected := false;
    FDC_alan.Connected := false;
  end;
end;

function TdmData.fInsert_to_wms_PACK_all(const ACheckRecCount, ADebug: Boolean;
  const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc;
  AMsgProc: TNotifyMsgProc): Integer;
var
  spName: string;
  lGUID: string;
begin
  Result := 0;
  try
    if not IsConnectedBoth(AMsgProc) then Exit;

     //
     // ��������� � �������� ������ - SKU_GROUP + SKU_DEPENDS
    spName := 'gpInsert_wms_Object_PACK';
    lGUID := fGet_GUID_pg;
     //
     // ������ ����������� ������ � ����. Postresql.wms_Message
    if fInsert_wms_Message_pg(spName, lGUID, AMsgProc) < 0 then
      exit;
     //
     // ����������� ������ �� ����. Postresql.wms_Message � ����������� � oracle
    Result := fInsert_wms_Message_to_wms(
      spName, lGUID, cpnWMSObjectPack, ACheckRecCount, ADebug, AThresholdRecCount, AMyLogSql, AMyShowSql, AMsgProc);
     //
  finally
    FDC_wms.Connected := false;
    FDC_alan.Connected := false;
  end;
end;

function TdmData.fInsert_to_wms_SKU(const ADebug: Boolean;
  AMyLogSql, AMyShowSql: TNotifyProc; AMsgProc: TNotifyMsgProc): Integer;
{
create or replace PROCEDURE alan_insert_packets_to_wms
    (in_process_start IN  DATE,
     out_pack_id      OUT Integer
    )
is
  vb_pack_id WMS.packets_to_wms.pack_id%TYPE;
begin
     insert into WMS.packets_to_wms (process_start)
        values (in_process_start) returning pack_id into vb_pack_id;
     --
     out_pack_id:= vb_pack_id;
end;
}
var
  spName: string;
  lGUID: string;
  i: Integer;
  vb_pack_id: Integer;
begin
  Result := 0;
  try
    if not IsConnectedBoth(AMsgProc) then Exit;

     //
     // ��������� � �������� ������ - SKU
    spName := 'gpInsert_wms_Object_SKU';
    lGUID := fGet_GUID_pg;
     //
     // ������ ����������� ������ � ����. Postresql.wms_Message
    if fInsert_wms_Message_pg(spName, lGUID, AMsgProc) < 0 then
      exit;
     //
     //
    with to_wms_Message_query do
    begin
      Close;
       //
      Sql.Clear;
      Sql.Add('SELECT * FROM wms_Message WHERE ProcName = ' + chr(39) + spName + chr(39));
      Open;
       //
      if not (Active) then
        if Assigned(AMsgProc) then AMsgProc('Err = Open = alan = wms_Message = ' + spName);
       //
       // !!! insert pack_id
      vb_pack_id := p_alan_insert_packets_to_wms;
       //
       //
       //����� ����� ����������� �����
      to_wms_Packets_query.SQL.Clear;
      to_wms_Packets_query.SQL.Add('begin');
       //to_wms_Packets_query.Params.ArraySize:= 12000;
       //
      i := 0;
      First;
      while not EOF do
      begin
        i := i + 1;
            //
        if (i >= 100) and (1 = 1) then
        begin
          to_wms_Packets_query.SQL.Add('commit;');
          to_wms_Packets_query.SQL.Add('end;');
                 // ��������� ��������� XML � wms
          try
            to_wms_Packets_query.ExecSQL;
          except
            on E: Exception do
            begin
              if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
              if Assigned(AMyLogSql) then AMyLogSql;
              if Assigned(AMyShowSql) then AMyShowSql;
            end;
          end;
                 //
          to_wms_Packets_query.SQL.Clear;
          to_wms_Packets_query.SQL.Add('begin');
                 //�������� �������
          i := 0;
        end;
            // ����������� ��������� XML � �����
        to_wms_Packets_query.SQL.Add('insert into WMS.xml_data_to_wms (pack_id, line, Data)' + ' values (' + IntToStr(vb_pack_id) + '        ,' + IntToStr(FieldByName('RowNum').AsInteger) + '        ,' + chr(39) + FieldByName('RowData').AsString + chr(39) + '         );');
        Next;
      end;
       //
      Close;
    end;
     //
     // ������� ��������� ������
    to_wms_Packets_query.SQL.Add('commit;');
    to_wms_Packets_query.SQL.Add('end;');
     //
    if ADebug then
    begin
      if Assigned(AMyLogSql) then AMyLogSql;
      if Assigned(AMyShowSql) then AMyShowSql;
    end;
     // ��������� ��������� XML � wms
    try
      to_wms_Packets_query.ExecSQL;
    except
      on E: Exception do
      begin
        if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
        if Assigned(AMyLogSql) then AMyLogSql;
        if Assigned(AMyShowSql) then AMyShowSql;
      end;
    end;

  finally
    FDC_wms.Connected := false;
    FDC_alan.Connected := false;
  end;
   //
  Result := vb_pack_id;
end;

function TdmData.fInsert_to_wms_SKU_all(const ACheckRecCount, ADebug: Boolean;
  const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc;
  AMsgProc: TNotifyMsgProc): Integer;
var
  spName: string;
  lGUID: string;
begin
  Result := 0;
  try
    if not IsConnectedBoth(AMsgProc) then
    begin
      if Assigned(AMsgProc) then
        AMsgProc('��� �����������');
      Exit;
    end
    else
      if Assigned(AMsgProc) then
        AMsgProc('����������� � ���� ������');

     //
     // ��������� � �������� ������ - SKU
    spName := 'gpInsert_wms_Object_SKU';
    lGUID := fGet_GUID_pg;
     //
     // ������ ����������� ������ � ����. Postresql.wms_Message
    if fInsert_wms_Message_pg(spName, lGUID, AMsgProc) < 0 then
      exit;
     //
     // ����������� ������ �� ����. Postresql.wms_Message � ����������� � oracle
    Result := fInsert_wms_Message_to_wms(
      spName, lGUID, cpnWMSObjectSKU, ACheckRecCount, ADebug, AThresholdRecCount, AMyLogSql, AMyShowSql, AMsgProc);
     //
  finally
    FDC_wms.Connected := false;
    FDC_alan.Connected := false;
  end;
end;

function TdmData.fInsert_to_wms_SKU_CODE_all(const ACheckRecCount, ADebug: Boolean;
  const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc;
  AMsgProc: TNotifyMsgProc): Integer;
var
  spName: string;
  lGUID: string;
begin
  Result := 0;
  try
    if not IsConnectedBoth(AMsgProc) then Exit;

     //
     // ��������� � �������� ������ - SKU
    spName := 'gpInsert_wms_Object_SKU_CODE';
    lGUID := fGet_GUID_pg;
     //
     // ������ ����������� ������ � ����. Postresql.wms_Message
    if fInsert_wms_Message_pg(spName, lGUID, AMsgProc) < 0 then
      exit;
     //
     // ����������� ������ �� ����. Postresql.wms_Message � ����������� � oracle
    Result := fInsert_wms_Message_to_wms(
      spName, lGUID, cpnWmsObjectSKUCode, ACheckRecCount, ADebug, AThresholdRecCount, AMyLogSql, AMyShowSql, AMsgProc);
     //
  finally
    FDC_wms.Connected := false;
    FDC_alan.Connected := false;
  end;
end;

function TdmData.fInsert_to_wms_SKU_GROUP_all(const ACheckRecCount, ADebug: Boolean;
  const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc;
  AMsgProc: TNotifyMsgProc): Integer;
var
  spName: string;
  lGUID: string;
begin
  Result := 0;
  try
    if not IsConnectedBoth(AMsgProc) then Exit;

     //
     // ��������� � �������� ������ - SKU_GROUP + SKU_DEPENDS
    spName := 'gpInsert_wms_Object_SKU_GROUP';
    lGUID := fGet_GUID_pg;
     //
     // ������ ����������� ������ � ����. Postresql.wms_Message
    if fInsert_wms_Message_pg(spName, lGUID, AMsgProc) < 0 then
      exit;
     //
     // ����������� ������ �� ����. Postresql.wms_Message � ����������� � oracle
    Result := fInsert_wms_Message_to_wms(
      spName, lGUID, cpnWmsObjectSKUGroup, ACheckRecCount, ADebug, AThresholdRecCount, AMyLogSql, AMyShowSql, AMsgProc);
     //
  finally
    FDC_wms.Connected := false;
    FDC_alan.Connected := false;
  end;
end;

function TdmData.fInsert_to_wms_USER_all(const ACheckRecCount, ADebug: Boolean;
  const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc;
  AMsgProc: TNotifyMsgProc): Integer;
var
  spName: string;
  lGUID: string;
begin
  Result := 0;
  try
    if not IsConnectedBoth(AMsgProc) then Exit;

     //
     // ��������� � �������� ������ - SKU_GROUP + SKU_DEPENDS
    spName := 'gpInsert_wms_Object_USER';
    lGUID := fGet_GUID_pg;
     //
     // ������ ����������� ������ � ����. Postresql.wms_Message
    if fInsert_wms_Message_pg(spName, lGUID, AMsgProc) < 0 then
      exit;
     //
     // ����������� ������ �� ����. Postresql.wms_Message � ����������� � oracle
    Result := fInsert_wms_Message_to_wms(
      spName, lGUID, cpnWmsObjectUser, ACheckRecCount, ADebug, AThresholdRecCount, AMyLogSql, AMyShowSql, AMsgProc);
     //
  finally
    FDC_wms.Connected := false;
    FDC_alan.Connected := false;
  end;
end;

// ������ ����������� ������ � ����. Postresql.wms_Message
function TdmData.fInsert_wms_Message_pg(pgProcName, GUID: string; AMsgProc: TNotifyMsgProc): Integer;
begin
  try
//    if Assigned(AMsgProc) then
//      AMsgProc('������ ������ � wms_message � ������� ' + pgProcName);
    Result := gpInsert_wms_Message(pgProcName, GUID);
    if Assigned(AMsgProc) then
      AMsgProc('�������� � wms_message � ������� ' + pgProcName + '  ' + IntToStr(Result) + ' �������');
  except
    on E: Exception do
    begin
      Result := -1;
      if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
    end;
  end;

  if Result < 0 then
    if Assigned(AMsgProc) then AMsgProc('ERR on pg = ' + pgProcName);
end;

function TdmData.fInsert_wms_Message_to_wms(pgProcName, GUID, aPacketName: string; const ACheckRecCount, ADebug: Boolean;
  const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc; AMsgProc: TNotifyMsgProc): Integer;
var
  ii, ii_num, iWmsMsgId: Integer;
begin
  Result := 0;
     //
  with to_wms_Message_query do
  begin
    Close;
       //
    Sql.Clear;
    Sql.Add(' SELECT * FROM wms_Message' + ' WHERE GUID     = ' + chr(39) + GUID + chr(39)//            +'   and ProcName = ' + chr(39) + pgProcName + chr(39)
      + ' ORDER BY GroupId, RowNum');
    Open;

    iWmsMsgId := 0;

    if not FieldByName('Id').IsNull then
      iWmsMsgId := FieldByName('Id').AsInteger;
       //
    if not (Active) then
      if Assigned(AMsgProc) then AMsgProc('Err = Open = Postgresql = wms_Message = ' + pgProcName + ' GUID = ' + GUID);
       //
       //
       //
       //����� ����� ����������� �����
    to_wms_Packets_query.SQL.Clear;
    to_wms_Packets_query.SQL.Add('begin');
       //
    if ACheckRecCount and (AThresholdRecCount = 0) then
    begin
      Result := -1;
      exit;
    end;
       //
    ii := 0;
    ii_num := 0;
    First;
    while not EOF do
    begin
      ii := ii + 1;
      ii_num := ii_num + 1;
      if ii_num > 3000 then
      begin
        ii_num := 0;
                 // ������� ��������� ������
        to_wms_Packets_query.SQL.Add('commit;');
        to_wms_Packets_query.SQL.Add('end;');
                 //
        if ADebug then
        begin
          if Assigned(AMyLogSql) then AMyLogSql;
          if Assigned(AMyShowSql) then AMyShowSql;
        end;
                 // ��������� ��������� XML � wms
        try
          to_wms_Packets_query.ExecSQL;
        except
          on E: Exception do
          begin
            Insert_wms_from_host_error(-1, iWmsMsgId, stAlan, aPacketName, E.Message, AMsgProc);
            if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
            if Assigned(AMyLogSql) then AMyLogSql;
            if Assigned(AMyShowSql) then AMyShowSql;
            exit;
          end;
        end;
                 //
                 //������ ������ - ����� ����� ����������� �����
        to_wms_Packets_query.SQL.Clear;
        to_wms_Packets_query.SQL.Add('begin');
      end;

            // ����������� ��������� XML � �����
      to_wms_Packets_query.SQL.Add('insert into WMS.from_host_header_message' + ' (SRC_HOST_ID, DST_HOST_ID' + ', TYPE' // VARCHAR2(64) - ��� ��������� (��� ���������)
        + ', ACTION'        // VARCHAR2(16)    - �������� (update/insert/delete)
//              +', CREATED'        // DATE            - ���� �������� ������ (����������� �������������)
        + ', STATUS'        // VARCHAR2(16)    - ������� ������ ��������� (ready � ������ ������ � ���������   done � ������ ������� ����������  error � ������ ���������� � �������)
//              +', START_DATE'     // DATE            - ���� ������ ���������
//                +', FINISH_DATE'    // DATE            - ���� ��������� ���������
        + ', MESSAGE'       // VARCHAR2(2048)  - Xml-��������� ��� ���������
//              +', ERR_CODE'       // NUMBER          - ��� ������ ��� ��������� � �������
//              +', ERR_DESCR'      // VARCHAR2(2048)  - �������� ������
        + ')' + ' values (' + chr(39) + 'kpl' + chr(39) + '        ,' +
                              chr(39) + 'kpl' + chr(39) + '        ,' +
                              chr(39) + FieldByName('TagName').AsString + chr(39) + '        ,' +
                              chr(39) + FieldByName('ActionName').AsString + chr(39) + '        ,' +
                              chr(39) + 'ready' + chr(39) + '        ,' +
                              chr(39) + InjectAttributeToXml(
                                FieldByName('RowData').AsString,
                                cWms_message_Id_Attr,
                                IntToStr(iWmsMsgId)) + chr(39) +
        '         );');
            //
      if ACheckRecCount and (AThresholdRecCount = ii) then
        break;
      Next;
    end;

    Close;
  end;

     // ������� ��������� ������
  to_wms_Packets_query.SQL.Add('commit;');
  to_wms_Packets_query.SQL.Add('end;');
     //
  if ADebug then
  begin
    if Assigned(AMyLogSql) then AMyLogSql;
    if Assigned(AMyShowSql) then AMyShowSql;
  end;
     // ��������� ��������� XML � wms
  try
    AMsgProc('������ � WMS ������ ' + aPacketName);
    to_wms_Packets_query.ExecSQL;
  except
    on E: Exception do
    begin
      Insert_wms_from_host_error(-1, iWmsMsgId, stAlan, aPacketName, E.Message, AMsgProc);
      if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
      if Assigned(AMyLogSql) then AMyLogSql;
      if Assigned(AMyShowSql) then AMyShowSql;
      exit;
    end;
  end;
     //
  Result := -1;
end;

// ������� wms_message.Id, ������� ��� �������� � ���� 'Message' � xml-�������� WMS.from_host_header_message � �������� 'wms_message_id'
function TdmData.GetIdFromAttribute(const AMessage, AAttribute: string; AMsgProc: TNotifyMsgProc): Integer;
var
  xmlDocument: IXMLDocument;
  rootNode, dataNode: IXMLNode;
  sXml: string;
  tmpStream: TMemoryStream;
const
  cXml = '<?xml version="1.0"?><root>%s</root>';
begin
  Result := -1;

  try
    sXml := Format(cXml, [AMessage]);

    tmpStream := TMemoryStream.Create;
    try
      tmpStream.Size := 0;
      tmpStream.Write(sXml[1], ByteLength(sXml));
      tmpStream.Position := 0;

      xmlDocument := TXMLDocument.Create(nil);
      xmlDocument.LoadFromStream(tmpStream);
    finally
      FreeAndNil(tmpStream);
    end;

    xmlDocument.Active := True;
    rootNode := xmlDocument.DocumentElement;
    dataNode := rootNode.ChildNodes[0];

    Result := getInt(dataNode.Attributes[AAttribute], -1);
  except
    on E: Exception do
      if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;
end;

function TdmData.gpInsert_wms_Message(spName, GUID: string): Integer;
const
  cSQL = 'select * from %s(inGUID:= %s, inSession:= %s)';
var
  sSQL: string;
begin
  sSQL := Format(cSQL, [spName, QuotedStr(GUID), QuotedStr('5')]);

  with qryInsert_wms_Message do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sSQL);
    Open;
    Result := Fields[0].AsInteger;
    Close;
  end;
end;

function TdmData.ImportWMS(const APacket: TPacketKind; AMsgProc: TNotifyMsgProc): Boolean;
var
  dataObjects: TDataObjects;
  wmsImport: TImportWMS;
const
  cStartImport   = '����� ������� "%s"';
  cSuccessImport = '������ "%s" ������� �������������';
begin
  with dataObjects do
  begin
    HeaderQry := from_wms_PacketsHeader_query;
    DetailQry := from_wms_PacketsDetail_query;
    InsertQry := insert_wms_to_host_message;
    ErrorQry  := update_wms_to_host_header_message_error;
    DoneQry   := update_wms_to_host_header_message_done;
    SelectQry := select_wms_to_host_message;
    ExecQry   := alan_exec_qry;
  end;

  wmsImport := TImportWMS.Create(dataObjects, AMsgProc);
  try
    try
      if Assigned(AMsgProc) then
        AMsgProc(Format(cStartImport, [GetImpTypeCaption(APacket)]));

      Result := wmsImport.ImportPacket(APacket);
      if Result and Assigned(AMsgProc) then
        AMsgProc(Format(cSuccessImport, [GetImpTypeCaption(APacket)]));
    except
      on E: Exception do
      begin
        Result := False;
        if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
      end;
    end;
  finally
    FreeAndNil(wmsImport);
  end;
end;

// �-�� ������������� ��� ������� wms_message.Id � ��� ������� xml-������� ������ ��������.
// ��� ������� ��� ����, ����� ���������� ����� ����� �������� WMS.from_host_header_message � �������� Alan.wms_message
// ������ �������� WMS.from_host_header_message.Message:
// <asn_load sync_id="625459" action="set" name="AHC-00303" sku_id="796772" qty="32.0000" production_date="25-06-2020" real_weight="15.7700" pack_weight="2.0000" inc_id="40267"></asn_load>

function TdmData.InjectAttributeToXml(const AOrigXml, AAttributeName, AAttributeValue: string): string;
const
  cEnd = '>';
  cNewAttribute = ' %s="%s"';
var
  iPos, iLenOrig: Integer;
  sNewAttribute: string;
begin
  Result := '';
  iPos := Pos(cEnd, AOrigXml);

  if iPos > 0 then
  begin
    iLenOrig := Length(AOrigXml);
    sNewAttribute := Format(cNewAttribute, [AAttributeName, AAttributeValue]);
    Result := Copy(AOrigXml, 1, iPos - 1) + sNewAttribute + Copy(AOrigXml, iPos, iLenOrig - iPos + 1);
  end;
end;

procedure TdmData.Insert_wms_from_host_error(const AHeaderId, AWmsMsgId: Integer; const ASite: TSite; const APacketName,
  AErrDescription: string; AMsgProc: TNotifyMsgProc);
const
  cInsert = 'SELECT gpInsert_wms_from_host_error(%d, %d, %s, %s, %s)';
var
  sInsert, sSite: string;
  thrErr: TQryThread;
begin
  case ASite of
    stAlan: sSite := 'A';
    stWMS:  sSite := 'W';
  end;

  // ���������� ������ � ���. wms_from_host_error
  sInsert := Format(cInsert, [AHeaderId, AWmsMsgId, QuotedStr(sSite), QuotedStr(APacketName), QuotedStr(AErrDescription)]);
  with alan_exec_qry do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sInsert);
  end;
  AMsgProc('������ ������ � wms_from_host_error');
  thrErr := TQryThread.Create(alan_exec_qry, saOpen, AMsgProc);
  thrErr.Start;
end;

function TdmData.IsConnectedAlan(AMsgProc: TNotifyMsgProc): Boolean;
begin
  Result := FDC_alan.Connected;
  if not Result then
    Result := ConnectAlan(TSettings.AlanServer, AMsgProc);
end;

function TdmData.IsConnectedBoth(AMsgProc: TNotifyMsgProc): Boolean;
begin
  Result := IsConnectedWMS(AMsgProc) and IsConnectedAlan(AMsgProc);
end;

function TdmData.IsConnectedWMS(AMsgProc: TNotifyMsgProc): Boolean;
begin
  Result := FDC_wms.Connected;
  if not Result then
    Result := ConnectWMS(TSettings.WMSDatabase, AMsgProc);
end;

procedure TdmData.pInsert_to_wms_Movement_ASN_LOAD_all(var lRecCount, lpack_id: Integer;
  const ACheckRecCount, ADebug: Boolean;
  const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc;
  AMsgProc: TNotifyMsgProc);
var
  spName: string;
  lGUID: string;
begin
  lpack_id := 0;

  if not IsConnectedBoth(AMsgProc) then Exit;

  // ��������� � �������� ������ - Movement_INCOMING
  spName := 'gpInsert_wms_Movement_ASN_LOAD';
  lGUID := fGet_GUID_pg;

  // ������ ����������� ������ � ����. Postresql.wms_Message
  lRecCount := fInsert_wms_Message_pg(spName, lGUID, AMsgProc);
  if lRecCount < 0 then exit;

  // ����������� ������ �� ����. Postresql.wms_Message � ����������� � oracle
  lpack_id := fInsert_wms_Message_to_wms(
    spName, lGUID, cpnWmsMovementASNLoad, ACheckRecCount, ADebug, AThresholdRecCount, AMyLogSql, AMyShowSql, AMsgProc);
end;

procedure TdmData.pInsert_to_wms_Movement_INCOMING_all(var lRecCount, lpack_id: Integer;
  const ACheckRecCount, ADebug: Boolean;
  const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc; AMsgProc: TNotifyMsgProc);
var
  spName: string;
  lGUID: string;
begin
  lpack_id := 0;

  if not IsConnectedBoth(AMsgProc) then Exit;

  // ��������� � �������� ������ - Movement_INCOMING
  spName := 'gpInsert_wms_Movement_INCOMING';
  lGUID := fGet_GUID_pg;

  // ������ ����������� ������ � ����. Postresql.wms_Message
  lRecCount := fInsert_wms_Message_pg(spName, lGUID, AMsgProc);
  if lRecCount < 0 then  exit;

  // ����������� ������ �� ����. Postresql.wms_Message � ����������� � oracle
  // Result:= fInsert_wms_Message_to_wms (spName, lGUID);
  lpack_id := fInsert_Movement_to_wms(
    spName, lGUID, cpnWmsMovementIncoming, ACheckRecCount, ADebug, AThresholdRecCount, AMyLogSql, AMyShowSql, AMsgProc);
end;

procedure TdmData.pInsert_to_wms_Movement_ORDER_all(var lRecCount, lpack_id: Integer;
  const ACheckRecCount, ADebug: Boolean;
  const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc;
  AMsgProc: TNotifyMsgProc);
var
  spName: string;
  lGUID: string;
begin
  lpack_id := 0;
  try
    if not IsConnectedBoth(AMsgProc) then Exit;

     //
     // ��������� � �������� ������ - Movement_INCOMING
    spName := 'gpInsert_wms_Movement_ORDER';
    lGUID := fGet_GUID_pg;
     //
     // ������ ����������� ������ � ����. Postresql.wms_Message
    lRecCount := fInsert_wms_Message_pg(spName, lGUID, AMsgProc);
    if lRecCount < 0 then
      exit;
     //
     // ����������� ������ �� ����. Postresql.wms_Message � ����������� � oracle
    lpack_id := fInsert_Movement_to_wms(
      spName, lGUID, cpnWmsMovementOrder, ACheckRecCount, ADebug, AThresholdRecCount, AMyLogSql, AMyShowSql, AMsgProc);
     //
  finally
    FDC_wms.Connected := false;
    FDC_alan.Connected := false;
  end;
end;

function TdmData.p_alan_insert_packets_to_wms: Integer;
begin
  with sp_alan_insert_packets_to_wms do
  begin
    ParamByName('in_process_start').AsDateTime := now;
    Execute;
    Result := ParamByName('out_pack_id').AsInteger;
  end;
end;

procedure TdmData.Insert_error_from_host_header_message(AMsgProc: TNotifyMsgProc);
var
  iMaxHeaderId, iWmsMessageId: Integer;
  sSQL, sErr_Descr: string;
const
  cProcName = 'gpInsert_wms_from_host_error';
  cRunProc  = 'SELECT * FROM %s(inHeader_Id:= %d, inWms_Message_Id:= %d, inSite:= %s, inPacketName:= %s, inErrDescription:= %s)';
begin
  // ������ ���� ������� ��������� � ���. WMS.from_host_header_message, �� � ���������� ��������� ���� ������ �������� ������.
  // �������� ��� ������ � ���������� � ���. ALAN.wms_to_host_error

  // ������� �������� �� ������, ������� ��� ���� ��������� � ���. ALAN.wms_to_host_error � ���������� ������� ���. WMS.from_host_header_message

  // ���� Header_Id � ���. wms_to_host_error, ������� ������������� ���������� ������ �� ���. WMS.from_host_header_message
  iMaxHeaderId := 0;
  if IsConnectedBoth(AMsgProc) then
  begin
    try
      with max_headerId_from_host_header_error do
      begin
        Close;
        Open;
        if not Fields[0].IsNull then
          iMaxHeaderId := Fields[0].AsInteger;
        Close;
      end;
    except
      on E: Exception do
        if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [
          E.ClassName, max_headerId_from_host_header_error.Name + '.' + E.Message]));
    end;
  end;

  // ������� ������ ��������� ������ ��  WMS.from_host_header_message
  try
    with wms_from_host_header_error do
    begin
      Close;
      ParamByName('Id').AsInteger := iMaxHeaderId;
      ParamByName('Start_Date').AsDateTime := StrToDateTime(cStartDate_TrackingError_from_host_header_message);
      Open;
    end;
  except
    on E: Exception do
      if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [
        E.ClassName, wms_from_host_header_error.Name + '.' + E.Message]));
  end;

  wms_from_host_header_error.First;

  while not wms_from_host_header_error.Eof do
  try
    with wms_from_host_header_error do
    begin
      sErr_Descr := '';
      if not FieldByName('Err_Descr').IsNull then
        sErr_Descr := FieldByName('Err_Descr').AsString;
      // ������ ������� ����������, ����� �������� ����� ������ SQL-�������
      sErr_Descr := StringReplace(sErr_Descr, Char(39), '`', [rfReplaceAll]); // ������ ��������� �������
      sErr_Descr := StringReplace(sErr_Descr, '"', '`', [rfReplaceAll]);

      // ������� wms_message.Id, ������� ��� �������� � ���� 'Message' � xml-�������� WMS.from_host_header_message � �������� 'wms_message_id'
      iWmsMessageId := -1;
      if not FieldByName('Message').IsNull then
        iWmsMessageId := GetIdFromAttribute(FieldByName('Message').AsString, cWms_message_Id_Attr, AMsgProc);

      sSQL := Format(cRunProc, [cProcName,
                                FieldByName('Id').AsInteger,             // Header_Id
                                iWmsMessageId,                           // wms_message.Id
                                QuotedStr('A'),                          // ������ �� ����� ����, ����� 'A'
                                QuotedStr(FieldByName('Type').AsString), // ��� ������ ��������, �������� 'asn_load'
                                QuotedStr(sErr_Descr)                    // ����� ������
                               ]);
    end;

    try
      // ���������� ������ ��������� �������� � ���. ALAN.wms_to_host_error
      with alan_exec_qry do
      begin
        Close;
        SQL.Clear;
        SQL.Add(sSQL);
        Open;
      end;
    except
      on E: Exception do
        if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [
          E.ClassName, alan_exec_qry.Name + '.' + E.Message]));
    end;

    wms_from_host_header_error.Next;

  except
    on E: Exception do
      if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
  end;

  wms_from_host_header_error.Close;
end;

{ TWorkerThread }

constructor TWorkerThread.Create(CreateSuspended: Boolean; AMsgProc: TNotifyMsgProc; AKind: TThreadKind);
begin
  FMsgProc := AMsgProc;
  FData    := TdmData.Create(nil);

  FreeOnTerminate := (AKind = tknNondriven);

  inherited Create(CreateSuspended);
end;

destructor TWorkerThread.Destroy;
begin
  FreeAndNil(FData);
  inherited;
end;

function TWorkerThread.GetReturnValue: Integer;
begin
  Result := ReturnValue;
end;

procedure TWorkerThread.InnerLogSqlProc;
begin
  TThread.Queue(nil, procedure
                     begin
                       if Assigned(FLogSql) then FLogSql;
                     end);
end;

{TODO: �������� �������� �� ��������� �� ��������� DetailLevel: Integer = 0  ����� ������������ ������� ����������� ����� }
procedure TWorkerThread.InnerMsgProc(const AMsg: string);
begin
  TThread.Queue(nil, procedure
                     begin
                       if Assigned(FMsgProc) then FMsgProc(AMsg);
                     end);
end;

procedure TWorkerThread.InnerShowSqlProc;
begin
  TThread.Queue(nil, procedure
                     begin
                       if Assigned(FShowSql) then FShowSql;
                     end);
end;

procedure TWorkerThread.MySleep(const AInterval: Cardinal);
var
  Start: Cardinal;
begin
  // ����� ��������� �������� ������������ Sleep, �� � ������� �� ���� ����� ����� �������� ���� ����� Terminated
  Start := GetTickCount;
  while ((GetTickCount - Start) < AInterval) and not Terminated do
    Sleep(1);
end;

{ TImportWorkerThread }

constructor TImportWorkerThread.Create(CreateSuspended: Boolean; const APacket: TPacketKind; AMsgProc: TNotifyMsgProc;
  AKind: TThreadKind);
begin
  FPacket := APacket;
  inherited Create(CreateSuspended, AMsgProc, AKind);
end;

procedure TImportWorkerThread.Execute;
begin
  inherited;

  CoInitialize(nil);
  try
    if Data.IsConnectedBoth(InnerMsgProc) then
      Data.ImportWMS(FPacket, InnerMsgProc);
  finally
    CoUninitialize;
  end;
end;



{ TExportWorkerThread }

constructor TExportWorkerThread.Create(CreateSuspended: Boolean; AExportData: TExportData;
  const APacket: TPacketKind; AMsgProc: TNotifyMsgProc; AKind: TThreadKind);
begin
  FPacket  := APacket;
  FData    := AExportData;
  FLogSql  := AExportData.LogSqlProc;
  FShowSql := AExportData.ShowSqlProc;

  inherited Create(CreateSuspended, AMsgProc, AKind);
//  InnerMsgProc('������ ����� �������� ��� ������ ' + PacketName);
end;

procedure TExportWorkerThread.Execute;
var
  P: PExportData;
begin
  inherited;

  InnerMsgProc('����� �������� ������ ' + PacketName);

  if Data.IsConnectedBoth(InnerMsgProc) then
    case FPacket of
      pknWmsMovementASNLoad:
        begin
          Data.pInsert_to_wms_Movement_ASN_LOAD_all(FData.RecCount, FData.Pack_id, FData.UseRecCount, FData.UseDebug,
            FData.ThresholdRecCount, InnerLogSqlProc, InnerShowSqlProc, InnerMsgProc);
          New(P);
          P^.Pack_id := FData.Pack_id;
          ReturnValue := LongWord(P);
        end;
      pknWmsObjectClient:
        begin
          ReturnValue := Data.fInsert_to_wms_CLIENT_all(FData.UseRecCount, FData.UseDebug, FData.ThresholdRecCount,
            InnerLogSqlProc, InnerShowSqlProc, InnerMsgProc);
        end;
      pknWmsObjectPack:
        begin
          ReturnValue := Data.fInsert_to_wms_PACK_all(FData.UseRecCount, FData.UseDebug, FData.ThresholdRecCount,
            InnerLogSqlProc, InnerShowSqlProc, InnerMsgProc);
        end;
      pknWmsObjectSKU:
        begin
          ReturnValue := Data.fInsert_to_wms_SKU_all(FData.UseRecCount, FData.UseDebug, FData.ThresholdRecCount,
            InnerLogSqlProc, InnerShowSqlProc, InnerMsgProc);
        end;
      pknWmsObjectSKUCode:
        begin
          ReturnValue := Data.fInsert_to_wms_SKU_CODE_all(FData.UseRecCount, FData.UseDebug, FData.ThresholdRecCount,
            InnerLogSqlProc, InnerShowSqlProc, InnerMsgProc);
        end;
      pknWmsObjectSKUGroup:
        begin
          ReturnValue := Data.fInsert_to_wms_SKU_GROUP_all(FData.UseRecCount, FData.UseDebug, FData.ThresholdRecCount,
            InnerLogSqlProc, InnerShowSqlProc, InnerMsgProc);
        end;
      pknWmsObjectUser:
        begin
          ReturnValue := Data.fInsert_to_wms_USER_all(FData.UseRecCount, FData.UseDebug, FData.ThresholdRecCount,
            InnerLogSqlProc, InnerShowSqlProc, InnerMsgProc);
        end;
      pknWmsMovementIncoming:
        begin
          Data.pInsert_to_wms_Movement_INCOMING_all(FData.RecCount, FData.Pack_id, FData.UseRecCount, FData.UseDebug,
            FData.ThresholdRecCount, InnerLogSqlProc, InnerShowSqlProc, InnerMsgProc);
          New(P);
          P^.Pack_id := FData.Pack_id;
          ReturnValue := LongWord(P);
        end;
      pknWmsMovementOrder:
        begin
          Data.pInsert_to_wms_Movement_ORDER_all(FData.RecCount, FData.Pack_id, FData.UseRecCount, FData.UseDebug,
            FData.ThresholdRecCount, InnerLogSqlProc, InnerShowSqlProc, InnerMsgProc);
          New(P);
          P^.Pack_id := FData.Pack_id;
          ReturnValue := LongWord(P);
        end;
    else
        InnerMsgProc('����������� ��� ������');
    end
    else
      InnerMsgProc('��� �����������');
end;

function TExportWorkerThread.GetPacketName: string;
begin
  Result := GetEnumName(System.TypeInfo(TPacketKind), Ord(FPacket));
end;

{ TProcessExportDataErrorThread }

procedure TProcessExportDataErrorThread.Execute;
begin
  inherited;
  CoInitialize(nil);
  try
    Data.Insert_error_from_host_header_message(InnerMsgProc);
  finally
    CoUninitialize;
  end;
end;

end.
