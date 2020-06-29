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
  private
    procedure Insert_wms_from_host_error(const AHeaderId: Integer; const ASite: TSite;
      const APacketName, AErrDescription: string; AMsgProc: TNotifyMsgProc);
  public
    // вызов spName - делает Insert в табл. Postresql.wms_Message - для GUID
    function gpInsert_wms_Message(spName, GUID: string): Integer;
    // получаем в Oracle - pack_id - потом можно заливать строки
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
    procedure Select_error_from_host_header_message(AMsgProc: TNotifyMsgProc);

    // Только Postresql.CLOCK_TIMESTAMP
    function fGet_GUID_pg: string;
    // Только формируются данные в табл. Postresql.wms_Message
    function fInsert_wms_Message_pg(pgProcName, GUID: string; AMsgProc: TNotifyMsgProc): Integer;
    // открываются данные из табл. Postresql.wms_Message для GUID и переносятся в oracle
    function fInsert_wms_Message_to_wms(pgProcName, GUID, aPacketName: string; const ACheckRecCount, ADebug: Boolean;
      const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc; AMsgProc: TNotifyMsgProc): Integer;
    // открываются данные из табл. Postresql.Movement и переносятся в oracle
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
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean; AExportData: TExportData; const APacket: TPacketKind;
      AMsgProc: TNotifyMsgProc; AKind: TThreadKind = tknNondriven); reintroduce;
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
  Winapi.ActiveX,
  USettings,
  UConstants,
  UImportWMS;

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
  ii: Integer;
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
       //здесь будем формировать пакет
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
            // заголовок
      if FieldByName('RowNum').AsInteger = 0 then
      begin
                  // по одной накладной в скрипте
        if to_wms_Packets_query.SQL.Count > 0 then
        begin
                       // если надо только несколько - для теста
          ii := ii + 1;
          if ACheckRecCount and (AThresholdRecCount = ii) then
            break;
                       //
                       // строчки завершают скрипт
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
                       // сохранили одну накладную с её строчками
          try
            to_wms_Packets_query.ExecSQL;
          except
            on E: Exception do
            begin
              Insert_wms_from_host_error(-1, stAlan, aPacketName, E.Message, AMsgProc);
              if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
              if Assigned(AMyLogSql) then AMyLogSql;
              if Assigned(AMyShowSql) then AMyShowSql;
              Exit;
            end;
          end;
        end;
                  //
                  // теперь сначала
        to_wms_Packets_query.SQL.Clear;
                  // здесь будем формировать пакет
        to_wms_Packets_query.SQL.Add('declare');
        to_wms_Packets_query.SQL.Add('  vb_id WMS.from_host_header_message.id%TYPE;');
        to_wms_Packets_query.SQL.Add('begin');
                  // заголовок
        to_wms_Packets_query.SQL.Add('insert into WMS.from_host_header_message' + ' (SRC_HOST_ID, DST_HOST_ID' + ', TYPE'          // VARCHAR2(64)    - Тип сообщения (тэг сообщения)
          + ', ACTION'        // VARCHAR2(16)    - Действие (update/insert/delete)
            //              +', CREATED'        // DATE            - Дата создания записи (заполняется автоматически)
          + ', STATUS'        // VARCHAR2(16)    - текущий статус сообщения (ready – данные готовы к обработке                                     done – данные успешно обработаны                            error – данные обработаны с ошибкой)
            //              +', START_DATE'     // DATE            - Дата начала обработки
            //                +', FINISH_DATE'    // DATE            - Дата окончания обработки
          + ', MESSAGE'       // VARCHAR2(2048)  - Xml-сообщения для обработки
            //              +', ERR_CODE'       // NUMBER          - Код ошибки при обработке с                                                                                        ошибкой
            //              +', ERR_DESCR'      // VARCHAR2(2048)  - Описание ошибки
          + ')' + ' values (' + chr(39) + 'kpl' + chr(39) + '        ,' + chr(39) + 'kpl' + chr(39) + '        ,' + chr(39) + FieldByName('TagName').AsString + chr(39) + '        ,' + chr(39) + FieldByName('ActionName').AsString + chr(39) + '        ,' + chr(39) + 'ready' + chr(39) + '        ,' + chr(39) + FieldByName('RowData').AsString + chr(39) + '         )' + '       returning id into vb_id;');
                  //
        to_wms_Packets_query.SQL.Add('commit;');
      end
      else                //строчная часть
        to_wms_Packets_query.SQL.Add('insert into WMS.from_host_detail_message' + ' (HEADER_ID' + ', TYPE'          // VARCHAR2(64)    - Тип сообщения (тэг сообщения)
          + ', ACTION'        // VARCHAR2(16)    - Действие (update/insert/delete)
          //        +', CREATED'        // DATE            - Дата создания записи (заполняется автоматически)
          + ', STATUS'        // VARCHAR2(16)    - текущий статус сообщения (ready – данные готовы к обработке                                     done – данные успешно обработаны                            error – данные обработаны с ошибкой)
          //        +', START_DATE'     // DATE            - Дата начала обработки
          //        +', FINISH_DATE'    // DATE            - Дата окончания обработки
          + ', MESSAGE'       // VARCHAR2(2048)  - Xml-сообщения для обработки
          //        +', ERR_CODE'       // NUMBER          - Код ошибки при обработке с                                                                                        ошибкой
          //        +', ERR_DESCR'      // VARCHAR2(2048)  - Описание ошибки
          + ')' + ' values (vb_id' + '        ,' + chr(39) + FieldByName('TagName').AsString + chr(39) + '        ,' + chr(39) + FieldByName('ActionName').AsString + chr(39) + '        ,' + chr(39) + 'ready' + chr(39) + '        ,' + chr(39) + FieldByName('RowData').AsString + chr(39) + '         );');
            //
            // куртим дальше
      Next;
    end;
       //
    Close;
  end;
     //
  if to_wms_Packets_query.Sql.Count > 0 then
  begin
         // строчки завершают скрипт
    to_wms_Packets_query.SQL.Add('commit;');
    to_wms_Packets_query.SQL.Add('end;');
         //
    if ADebug then
      if Assigned(AMyShowSql) then AMyShowSql;//myShowSql;
         // сохранили несколько XML в wms
    try
      to_wms_Packets_query.ExecSQL;
    except
      on E: Exception do
      begin
        Insert_wms_from_host_error(-1, stAlan, aPacketName, E.Message, AMsgProc);
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
    if not dmData.IsConnectedBoth(AMsgProc) then Exit;

     //
     // формируем и передаем данные - SKU
    spName := 'gpInsert_wms_Object_CLIENT';
    lGUID := fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
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
       //здесь будем формировать пакет
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
                 // сохранили несколько XML в wms
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
                 //начинаем сначада
          i := 0;
        end;
            // формируются несколько XML в пакет
        to_wms_Packets_query.SQL.Add('insert into WMS.xml_data_to_wms (pack_id, line, Data)' + ' values (' + IntToStr(vb_pack_id) + '        ,' + IntToStr(FieldByName('RowNum').AsInteger) + '        ,' + chr(39) + FieldByName('RowData').AsString + chr(39) + '         );');
        Next;
      end;
       //
      Close;
    end;
     //
     // строчки завершают скрипт
    to_wms_Packets_query.SQL.Add('commit;');
    to_wms_Packets_query.SQL.Add('end;');
     //
    if ADebug then
    begin
      if Assigned(AMyLogSql) then AMyLogSql;
      if Assigned(AMyShowSql) then AMyShowSql;
    end;
     // сохранили несколько XML в wms
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
    if not dmData.IsConnectedBoth(AMsgProc) then Exit;

     //
     // формируем и передаем данные - SKU_GROUP + SKU_DEPENDS
    spName := 'gpInsert_wms_Object_CLIENT';
    lGUID := fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
    if fInsert_wms_Message_pg(spName, lGUID, AMsgProc) < 0 then
      exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
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
    if not dmData.IsConnectedBoth(AMsgProc) then Exit;

     //
     // формируем и передаем данные - SKU_GROUP + SKU_DEPENDS
    spName := 'gpInsert_wms_Object_PACK';
    lGUID := fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
    if fInsert_wms_Message_pg(spName, lGUID, AMsgProc) < 0 then
      exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
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
    if not dmData.IsConnectedBoth(AMsgProc) then Exit;

     //
     // формируем и передаем данные - SKU
    spName := 'gpInsert_wms_Object_SKU';
    lGUID := fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
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
       //здесь будем формировать пакет
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
                 // сохранили несколько XML в wms
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
                 //начинаем сначада
          i := 0;
        end;
            // формируются несколько XML в пакет
        to_wms_Packets_query.SQL.Add('insert into WMS.xml_data_to_wms (pack_id, line, Data)' + ' values (' + IntToStr(vb_pack_id) + '        ,' + IntToStr(FieldByName('RowNum').AsInteger) + '        ,' + chr(39) + FieldByName('RowData').AsString + chr(39) + '         );');
        Next;
      end;
       //
      Close;
    end;
     //
     // строчки завершают скрипт
    to_wms_Packets_query.SQL.Add('commit;');
    to_wms_Packets_query.SQL.Add('end;');
     //
    if ADebug then
    begin
      if Assigned(AMyLogSql) then AMyLogSql;
      if Assigned(AMyShowSql) then AMyShowSql;
    end;
     // сохранили несколько XML в wms
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
    if not dmData.IsConnectedBoth(AMsgProc) then Exit;

     //
     // формируем и передаем данные - SKU
    spName := 'gpInsert_wms_Object_SKU';
    lGUID := fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
    if fInsert_wms_Message_pg(spName, lGUID, AMsgProc) < 0 then
      exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
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
    if not dmData.IsConnectedBoth(AMsgProc) then Exit;

     //
     // формируем и передаем данные - SKU
    spName := 'gpInsert_wms_Object_SKU_CODE';
    lGUID := fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
    if fInsert_wms_Message_pg(spName, lGUID, AMsgProc) < 0 then
      exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
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
    if not dmData.IsConnectedBoth(AMsgProc) then Exit;

     //
     // формируем и передаем данные - SKU_GROUP + SKU_DEPENDS
    spName := 'gpInsert_wms_Object_SKU_GROUP';
    lGUID := fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
    if fInsert_wms_Message_pg(spName, lGUID, AMsgProc) < 0 then
      exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
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
    if not dmData.IsConnectedBoth(AMsgProc) then Exit;

     //
     // формируем и передаем данные - SKU_GROUP + SKU_DEPENDS
    spName := 'gpInsert_wms_Object_USER';
    lGUID := fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
    if fInsert_wms_Message_pg(spName, lGUID, AMsgProc) < 0 then
      exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
    Result := fInsert_wms_Message_to_wms(
      spName, lGUID, cpnWmsObjectUser, ACheckRecCount, ADebug, AThresholdRecCount, AMyLogSql, AMyShowSql, AMsgProc);
     //
  finally
    FDC_wms.Connected := false;
    FDC_alan.Connected := false;
  end;
end;

// Только формируются данные в табл. Postresql.wms_Message
function TdmData.fInsert_wms_Message_pg(pgProcName, GUID: string; AMsgProc: TNotifyMsgProc): Integer;
begin
  try
    Result := gpInsert_wms_Message(pgProcName, GUID);
  except
    on E: Exception do
    begin
      Result := -1;
      if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
    end;
  end;
     //
  if Result < 0 then
    if Assigned(AMsgProc) then AMsgProc('ERR on pg = ' + pgProcName);
end;

function TdmData.fInsert_wms_Message_to_wms(pgProcName, GUID, aPacketName: string; const ACheckRecCount, ADebug: Boolean;
  const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc; AMsgProc: TNotifyMsgProc): Integer;
var
  ii, ii_num: Integer;
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
       //
    if not (Active) then
      if Assigned(AMsgProc) then AMsgProc('Err = Open = Postgresql = wms_Message = ' + pgProcName + ' GUID = ' + GUID);
       //
       //
       //
       //здесь будем формировать пакет
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
                 // строчки завершают скрипт
        to_wms_Packets_query.SQL.Add('commit;');
        to_wms_Packets_query.SQL.Add('end;');
                 //
        if ADebug then
        begin
          if Assigned(AMyLogSql) then AMyLogSql;
          if Assigned(AMyShowSql) then AMyShowSql;
        end;
                 // сохранили несколько XML в wms
        try
          to_wms_Packets_query.ExecSQL;
        except
          on E: Exception do
          begin
            Insert_wms_from_host_error(-1, stAlan, aPacketName, E.Message, AMsgProc);
            if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
            if Assigned(AMyLogSql) then AMyLogSql;
            if Assigned(AMyShowSql) then AMyShowSql;
            exit;
          end;
        end;
                 //
                 //крутим дальше - здесь будем формировать пакет
        to_wms_Packets_query.SQL.Clear;
        to_wms_Packets_query.SQL.Add('begin');
      end;

            // формируются несколько XML в пакет
      to_wms_Packets_query.SQL.Add('insert into WMS.from_host_header_message' + ' (SRC_HOST_ID, DST_HOST_ID' + ', TYPE'          // VARCHAR2(64)    - Тип сообщения (тэг сообщения)
        + ', ACTION'        // VARCHAR2(16)    - Действие (update/insert/delete)
//              +', CREATED'        // DATE            - Дата создания записи (заполняется автоматически)
        + ', STATUS'        // VARCHAR2(16)    - текущий статус сообщения (ready – данные готовы к обработке                                     done – данные успешно обработаны                            error – данные обработаны с ошибкой)
//              +', START_DATE'     // DATE            - Дата начала обработки
//                +', FINISH_DATE'    // DATE            - Дата окончания обработки
        + ', MESSAGE'       // VARCHAR2(2048)  - Xml-сообщения для обработки
//              +', ERR_CODE'       // NUMBER          - Код ошибки при обработке с                                                                                        ошибкой
//              +', ERR_DESCR'      // VARCHAR2(2048)  - Описание ошибки
        + ')' + ' values (' + chr(39) + 'kpl' + chr(39) + '        ,' + chr(39) + 'kpl' + chr(39) + '        ,' + chr(39) + FieldByName('TagName').AsString + chr(39) + '        ,' + chr(39) + FieldByName('ActionName').AsString + chr(39) + '        ,' + chr(39) + 'ready' + chr(39) + '        ,' + chr(39) + FieldByName('RowData').AsString + chr(39) + '         );');
            //
      if ACheckRecCount and (AThresholdRecCount = ii) then
        break;
            //
      Next;
    end;
       //
    Close;
  end;
     //
     // строчки завершают скрипт
  to_wms_Packets_query.SQL.Add('commit;');
  to_wms_Packets_query.SQL.Add('end;');
     //
  if ADebug then
  begin
    if Assigned(AMyLogSql) then AMyLogSql;
    if Assigned(AMyShowSql) then AMyShowSql;
  end;
     // сохранили несколько XML в wms
  try
    to_wms_Packets_query.ExecSQL;
  except
    on E: Exception do
    begin
      Insert_wms_from_host_error(-1, stAlan, aPacketName, E.Message, AMsgProc);
      if Assigned(AMsgProc) then AMsgProc(Format(cExceptionMsg, [E.ClassName, E.Message]));
      if Assigned(AMyLogSql) then AMyLogSql;
      if Assigned(AMyShowSql) then AMyShowSql;
      exit;
    end;
  end;
     //
  Result := -1;
end;

function TdmData.gpInsert_wms_Message(spName, GUID: string): Integer;
begin
  with spInsert_wms_Message do
  begin
    StoredProcName := spName;
    FetchOptions.Items := FetchOptions.Items - [fiMeta];
    Params.Clear;
    Params.Add('inGUID', ftString, ptInput);
    Params.Add('outRecCount', ftInteger, ptOutput);
    Params.Add('inSession', ftString, ptInput);
    Params[0].ParamType := ptInput;
    Params[0].FDDataType := dtWideString;
    Params[1].ParamType := ptOutput;
    Params[1].FDDataType := dtInt32;
    Params[2].ParamType := ptInput;
    Params[2].FDDataType := dtWideString;
    ParamByName('inGUID').AsString := GUID;
    ParamByName('inSession').AsString := '5';
    Prepare;

    ExecProc;

    Result := ParamByName('outRecCount').AsInteger;
  end;
end;

function TdmData.ImportWMS(const APacket: TPacketKind; AMsgProc: TNotifyMsgProc): Boolean;
var
  dataObjects: TDataObjects;
  wmsImport: TImportWMS;
const
  cStartImport   = 'Start import "%s" from WMS'  + #13#10;
  cSuccessImport = 'Data "%s" successfull imported from WMS' + #13#10;
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

procedure TdmData.Insert_wms_from_host_error(const AHeaderId: Integer; const ASite: TSite; const APacketName,
  AErrDescription: string; AMsgProc: TNotifyMsgProc);
const
  cInsert = 'SELECT gpInsert_wms_from_host_error(%d, %s, %s, %s)';
var
  sInsert, sSite: string;
  thrErr: TQryThread;
begin
  case ASite of
    stAlan: sSite := 'A';
    stWMS:  sSite := 'W';
  end;

  // записываем данные в таб. wms_from_host_error
  sInsert := Format(cInsert, [AHeaderId, QuotedStr(sSite), QuotedStr(APacketName), QuotedStr(AErrDescription)]);
  with alan_exec_qry do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sInsert);
  end;
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
//  try
    if not dmData.IsConnectedBoth(AMsgProc) then Exit;

     //
     // формируем и передаем данные - Movement_INCOMING
    spName := 'gpInsert_wms_Movement_ASN_LOAD';
    lGUID := fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
    lRecCount := fInsert_wms_Message_pg(spName, lGUID, AMsgProc);
    if lRecCount < 0 then
      exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
    lpack_id := fInsert_wms_Message_to_wms(
      spName, lGUID, cpnWmsMovementASNLoad, ACheckRecCount, ADebug, AThresholdRecCount, AMyLogSql, AMyShowSql, AMsgProc);
     //
//  finally
//    FDC_wms.Connected := false;
//    FDC_alan.Connected := false;
//  end;
end;

procedure TdmData.pInsert_to_wms_Movement_INCOMING_all(var lRecCount, lpack_id: Integer;
  const ACheckRecCount, ADebug: Boolean;
  const AThresholdRecCount: Integer; AMyLogSql, AMyShowSql: TNotifyProc; AMsgProc: TNotifyMsgProc);
var
  spName: string;
  lGUID: string;
begin
  lpack_id := 0;
//  try
    if not dmData.IsConnectedBoth(AMsgProc) then Exit;

     //
     // формируем и передаем данные - Movement_INCOMING
    spName := 'gpInsert_wms_Movement_INCOMING';
    lGUID := fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
    lRecCount := fInsert_wms_Message_pg(spName, lGUID, AMsgProc);
    if lRecCount < 0 then
      exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
     //Result:= fInsert_wms_Message_to_wms (spName, lGUID);
    lpack_id := fInsert_Movement_to_wms(
      spName, lGUID, cpnWmsMovementIncoming, ACheckRecCount, ADebug, AThresholdRecCount, AMyLogSql, AMyShowSql, AMsgProc);
     //
//  finally
//    FDC_wms.Connected := false;
//    FDC_alan.Connected := false;
//  end;
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
    if not dmData.IsConnectedBoth(AMsgProc) then Exit;

     //
     // формируем и передаем данные - Movement_INCOMING
    spName := 'gpInsert_wms_Movement_ORDER';
    lGUID := fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
    lRecCount := fInsert_wms_Message_pg(spName, lGUID, AMsgProc);
    if lRecCount < 0 then
      exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
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

procedure TdmData.Select_error_from_host_header_message(AMsgProc: TNotifyMsgProc);
var
  iMaxHeaderId: Integer;
  sSQL, sErr_Descr: string;
const
  cProcName = 'gpInsert_wms_from_host_error';
  cRunProc  = 'SELECT * FROM %s(inHeader_Id:= %d, inSite:= %s, inPacketName:= %s, inErrDescription:= %s)';
begin
  // Данные были успешно вставлены в таб. WMS.from_host_header_message, но в результате обработки этих данных возникли ошибки.
  // Собираем эти ошибки и записываем в таб. ALAN.wms_to_host_error

  // Сначала исключим те записи, которые уже были добавлены в таб. ALAN.wms_to_host_error в предыдущих чтениях таб. WMS.from_host_header_message

  // Ищем Header_Id в таб. wms_to_host_error, который соответствует последнему чтению из таб. WMS.from_host_header_message
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

  // Получим список последних ошибок из  WMS.from_host_header_message
  try
    with wms_from_host_header_error do
    begin
      Close;
      ParamByName('Id').AsInteger := iMaxHeaderId;
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
      // замена кавычек необходима, чтобы избежать порчи текста SQL-запроса
      sErr_Descr := StringReplace(sErr_Descr, Char(39), '`', [rfReplaceAll]); // замена одинарной кавычки
      sErr_Descr := StringReplace(sErr_Descr, '"', '`', [rfReplaceAll]);

      sSQL := Format(cRunProc, [cProcName,
                                FieldByName('Id').AsInteger,             // Header_Id
                                QuotedStr('A'),                          // ошибка по нашей вине, пишем 'A'
                                QuotedStr(FieldByName('Type').AsString), // имя пакета экспорта, например 'asn_load'
                                QuotedStr(sErr_Descr)                    // текст ошибки
                               ]);
    end;

    try
      // записываем ошибку обработки экспорта в таб. ALAN.wms_to_host_error
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

{ TImportWorkerThread }

constructor TImportWorkerThread.Create(CreateSuspended: Boolean; const APacket: TPacketKind; AMsgProc: TNotifyMsgProc;
  AKind: TThreadKind);
begin
  FPacket := APacket;
  inherited Create(CreateSuspended, AMsgProc);
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
end;

procedure TExportWorkerThread.Execute;
var
  P: PExportData;
begin
  inherited;

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
    end;
end;


{ TProcessExportDataErrorThread }

procedure TProcessExportDataErrorThread.Execute;
begin
  inherited;
  Data.Select_error_from_host_header_message(InnerMsgProc);
end;

end.
