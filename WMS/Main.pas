unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.Oracle,
  FireDAC.Phys.OracleDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  Vcl.StdCtrls, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Phys.PG, FireDAC.Phys.PGDef;

type
  TMainForm = class(TForm)
    Edit1: TEdit;
    btnFDC_wms: TButton;
    FDC_wms: TFDConnection;
    to_wms_Packets_query: TFDQuery;
    btnFDC_alan: TButton;
    FDC_alan: TFDConnection;
    Edit2: TEdit;
    to_wms_Message_query: TFDQuery;
    btnObject_SKU_to_wms: TButton;
    sp_alan_insert_packets_to_wms: TFDStoredProc;
    spInsert_wms_Message: TFDStoredProc;
    btnObject_SKU_GROUP_DEPENDS_to_wmsClick: TButton;
    btnObject_CLIENT_to_wms: TButton;
    btnObject_USER_to_wms: TButton;
    btnObject_PACK_to_wms: TButton;
    cbRecCount: TCheckBox;
    EditRecCount: TEdit;
    btnObject_SKU_CODE_to_wms: TButton;
    btnMovement_INCOMING_to_wms: TButton;
    btnMovement_ASN_LOAD_to_wms: TButton;
    btnMovement_ORDER_to_wms: TButton;
    cbDebug: TCheckBox;
    btnAll_from_wms: TButton;
    from_wms_PacketsHeader_query: TFDQuery;
    from_wms_PacketsDetail_query: TFDQuery;
    procedure btnFDC_wmsClick(Sender: TObject);
    procedure btnFDC_alanClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnObject_SKU_to_wmsClick(Sender: TObject);
    procedure btnObject_SKU_GROUP_DEPENDS_to_wmsClickClick(Sender: TObject);
    procedure btnObject_CLIENT_to_wmsClick(Sender: TObject);
    procedure btnObject_USER_to_wmsClick(Sender: TObject);
    procedure btnObject_PACK_to_wmsClick(Sender: TObject);
    procedure btnObject_SKU_CODE_to_wmsClick(Sender: TObject);
    procedure btnMovement_INCOMING_to_wmsClick(Sender: TObject);
    procedure btnMovement_ASN_LOAD_to_wmsClick(Sender: TObject);
    procedure btnMovement_ORDER_to_wmsClick(Sender: TObject);
    procedure btnAll_from_wmsClick(Sender: TObject);
  private
    function fIni_FDC_wms: Boolean;
    function fIni_FDC_alan: Boolean;
    // вызов spName - делает Insert в табл. Postresql.wms_Message - для GUID
    function gpInsert_wms_Message (spName, GUID : String) : Boolean;
    // получаем в Oracle - pack_id - потом можно заливать строки
    function p_alan_insert_packets_to_wms : Integer;
    //
    function fInsert_to_wms_SKU : Integer;
    function fInsert_to_wms_CLIENT : Integer;

    function fInsert_to_wms_SKU_all : Integer;
    function fInsert_to_wms_SKU_CODE_all : Integer;
    function fInsert_to_wms_SKU_GROUP_all : Integer;
    function fInsert_to_wms_CLIENT_all : Integer;
    function fInsert_to_wms_PACK_all : Integer;
    function fInsert_to_wms_USER_all : Integer;

    function fInsert_to_wms_Movement_INCOMING_all : Integer;
    function fInsert_to_wms_Movement_ASN_LOAD_all : Integer;
    function fInsert_to_wms_Movement_ORDER_all    : Integer;

    // Только Postresql.CLOCK_TIMESTAMP
    function fGet_GUID_pg : String;
    // Только формируются данные в табл. Postresql.wms_Message
    function fInsert_wms_Message_pg (pgProcName, GUID : String) : Boolean;
    // открываются данные из табл. Postresql.wms_Message для GUID и переносятся в oracle
    function fInsert_wms_Message_to_wms (pgProcName, GUID : String) : Integer;
    // открываются данные из табл. Postresql.Movement и переносятся в oracle
    function fInsert_Movement_to_wms (pgProcName, GUID : String) : Integer;


    procedure AddToLog(LogFileName: string; S: string);
    procedure myShowSql;
    procedure myLogSql;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation
{$R *.dfm}
{------------------------------------------------------------------------}
procedure TMainForm.AddToLog(LogFileName: string; S: string);
var
  LogStr: string;
  //LogFileName: string;
  LogFile: TextFile;
begin
  Application.ProcessMessages;
  //LogStr := FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) + ' ' + S;
  LogStr := S;
  //LogFileName := ChangeFileExt(Application.ExeName, '') + '_' + FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) + '.log';
  //showMessage(LogFileName);
  AssignFile(LogFile, LogFileName);

  if FileExists(LogFileName) then
    Append(LogFile)
  else
    Rewrite(LogFile);

  Writeln(LogFile, LogStr);
  CloseFile(LogFile);
  Application.ProcessMessages;
end;
{------------------------------------------------------------------------}
    procedure TMainForm.myShowSql;
    var str_test : String;
        i : Integer;
    begin
       str_test:='';
       with to_wms_Packets_query do begin
        for i:= 0 to SQL.Count-1 do str_test:= str_test + SQL[i] + #13;
        //
        ShowMessage (IntToStr(Length(str_test)) + ':' + #13 + IntToStr(SQL.Count) + ':' + #13 + str_test);
       end;
    end;
{------------------------------------------------------------------------}
    procedure TMainForm.myLogSql;
    var LogFileName : String;
        i : Integer;
    begin
       LogFileName := ChangeFileExt(Application.ExeName, '') + '_' + FormatDateTime('yyyy-mm-dd hh-mm-ss', Now) + '.log';
       //
       with to_wms_Packets_query do begin
        //AddToLog (LogFileName, IntToStr(SQL.Count) + ':');
        for i:= 0 to SQL.Count-1 do AddToLog (LogFileName, SQL[i]);
       end;
    end;
{------------------------------------------------------------------------}
procedure TMainForm.btnFDC_wmsClick(Sender: TObject);
begin
     if fIni_FDC_wms then showMessage('wms Connected = OK')
end;
{------------------------------------------------------------------------}
procedure TMainForm.btnAll_from_wmsClick(Sender: TObject);
begin

end;
{------------------------------------------------------------------------}
procedure TMainForm.btnFDC_alanClick(Sender: TObject);
begin
     if fIni_FDC_alan then showMessage('alan Connected = OK')
end;
{------------------------------------------------------------------------}
procedure TMainForm.btnMovement_INCOMING_to_wmsClick(Sender: TObject);
var vb_pack_id : Integer;
begin
   // INCOMING
   vb_pack_id:= fInsert_to_wms_Movement_INCOMING_all;
   if vb_pack_id <> 0
   then ShowMessage('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_INCOMING')
   else ShowMessage('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_INCOMING');
end;
{------------------------------------------------------------------------}
procedure TMainForm.btnMovement_ORDER_to_wmsClick(Sender: TObject);
var vb_pack_id : Integer;
begin
   // ASN_LOAD
   vb_pack_id:= fInsert_to_wms_Movement_ORDER_all;
   if vb_pack_id <> 0
   then ShowMessage('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_ORDER')
   else ShowMessage('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_ORDER');
end;
{------------------------------------------------------------------------}
procedure TMainForm.btnMovement_ASN_LOAD_to_wmsClick(Sender: TObject);
var vb_pack_id : Integer;
begin
   // ASN_LOAD
   vb_pack_id:= fInsert_to_wms_Movement_ASN_LOAD_all;
   if vb_pack_id <> 0
   then ShowMessage('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_ASN_LOAD')
   else ShowMessage('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_ASN_LOAD');
end;
{------------------------------------------------------------------------}
function TMainForm.fIni_FDC_wms: Boolean;
begin
     with FDC_wms do begin
       Connected:= false;
       Params.Database:=Edit1.Text;
       Connected:= true;
       Result:= Connected = true;
       if not (Result) then showMessage('wms Connected = ERR');
     end;
end;
{------------------------------------------------------------------------}
function TMainForm.fIni_FDC_alan: Boolean;
begin
     with FDC_alan do begin
       Connected:= false;
     //Params.Database:=Edit1.Text;
       Connected:= true;
       Result:= Connected = true;
       if not (Result) then showMessage('alan Connected = ERR');
     end;
end;
{------------------------------------------------------------------------}
function TMainForm.gpInsert_wms_Message (spName, GUID : String) : Boolean;
begin
     Result:= false;
     with spInsert_wms_Message do begin
       StoredProcName:= spName;
       Params.Clear;
       Params.Add('inGUID', ftString, ptInput);
       Params.Add('inSession', ftString, ptInput);
       Params[0].ParamType:= ptInput;
       Params[0].FDDataType:= dtWideString;
       Params[1].ParamType:= ptInput;
       Params[1].FDDataType:= dtWideString;
       ParamByName('inGUID').AsString:= GUID;
       ParamByName('inSession').AsString:= '5';
       ExecProc;
     end;
     Result:= true;
end;
{------------------------------------------------------------------------}
function TMainForm.p_alan_insert_packets_to_wms : Integer;
begin
     Result:=0;
     with sp_alan_insert_packets_to_wms do
     begin
       ParamByName('in_process_start').AsDateTime:= now;
       Execute;
       Result:=ParamByName('out_pack_id').AsInteger;
     end;
end;
{------------------------------------------------------------------------}
function TMainForm.fInsert_to_wms_SKU_all : Integer;
var spName : String;
    lGUID  : String;
begin
   Result:= 0;
   try
     if not fIni_FDC_wms  then exit;
     if not fIni_FDC_alan then exit;
     //
     // формируем и передаем данные - SKU
     spName:= 'gpInsert_wms_Object_SKU';
     lGUID:= fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
     if not fInsert_wms_Message_pg (spName, lGUID) then exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
     Result:= fInsert_wms_Message_to_wms (spName, lGUID);
     //
   finally
     FDC_wms.Connected := false;
     FDC_alan.Connected:= false;
   end;
end;
{------------------------------------------------------------------------}
function TMainForm.fInsert_to_wms_SKU_CODE_all : Integer;
var spName : String;
    lGUID  : String;
begin
   Result:= 0;
   try
     if not fIni_FDC_wms  then exit;
     if not fIni_FDC_alan then exit;
     //
     // формируем и передаем данные - SKU
     spName:= 'gpInsert_wms_Object_SKU_CODE';
     lGUID:= fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
     if not fInsert_wms_Message_pg (spName, lGUID) then exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
     Result:= fInsert_wms_Message_to_wms (spName, lGUID);
     //
   finally
     FDC_wms.Connected := false;
     FDC_alan.Connected:= false;
   end;
end;
{------------------------------------------------------------------------}
function TMainForm.fInsert_to_wms_SKU_GROUP_all : Integer;
var spName : String;
    lGUID  : String;
begin
   Result:= 0;
   try
     if not fIni_FDC_wms  then exit;
     if not fIni_FDC_alan then exit;
     //
     // формируем и передаем данные - SKU_GROUP + SKU_DEPENDS
     spName:= 'gpInsert_wms_Object_SKU_GROUP';
     lGUID:= fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
     if not fInsert_wms_Message_pg (spName, lGUID) then exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
     Result:= fInsert_wms_Message_to_wms (spName, lGUID);
     //
   finally
     FDC_wms.Connected := false;
     FDC_alan.Connected:= false;
   end;
end;
{------------------------------------------------------------------------}
function TMainForm.fInsert_to_wms_CLIENT_all : Integer;
var spName : String;
    lGUID  : String;
begin
   Result:= 0;
   try
     if not fIni_FDC_wms  then exit;
     if not fIni_FDC_alan then exit;
     //
     // формируем и передаем данные - SKU_GROUP + SKU_DEPENDS
     spName:= 'gpInsert_wms_Object_CLIENT';
     lGUID:= fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
     if not fInsert_wms_Message_pg (spName, lGUID) then exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
     Result:= fInsert_wms_Message_to_wms (spName, lGUID);
     //
   finally
     FDC_wms.Connected := false;
     FDC_alan.Connected:= false;
   end;
end;
{------------------------------------------------------------------------}
function TMainForm.fInsert_to_wms_PACK_all : Integer;
var spName : String;
    lGUID  : String;
begin
   Result:= 0;
   try
     if not fIni_FDC_wms  then exit;
     if not fIni_FDC_alan then exit;
     //
     // формируем и передаем данные - SKU_GROUP + SKU_DEPENDS
     spName:= 'gpInsert_wms_Object_PACK';
     lGUID:= fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
     if not fInsert_wms_Message_pg (spName, lGUID) then exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
     Result:= fInsert_wms_Message_to_wms (spName, lGUID);
     //
   finally
     FDC_wms.Connected := false;
     FDC_alan.Connected:= false;
   end;
end;
{------------------------------------------------------------------------}
function TMainForm.fInsert_to_wms_USER_all : Integer;
var spName : String;
    lGUID  : String;
begin
   Result:= 0;
   try
     if not fIni_FDC_wms  then exit;
     if not fIni_FDC_alan then exit;
     //
     // формируем и передаем данные - SKU_GROUP + SKU_DEPENDS
     spName:= 'gpInsert_wms_Object_USER';
     lGUID:= fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
     if not fInsert_wms_Message_pg (spName, lGUID) then exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
     Result:= fInsert_wms_Message_to_wms (spName, lGUID);
     //
   finally
     FDC_wms.Connected := false;
     FDC_alan.Connected:= false;
   end;
end;
{------------------------------------------------------------------------}
function TMainForm.fInsert_to_wms_Movement_INCOMING_all : Integer;
var spName : String;
    lGUID  : String;
begin
   Result:= 0;
   try
     if not fIni_FDC_wms  then exit;
     if not fIni_FDC_alan then exit;
     //
     // формируем и передаем данные - Movement_INCOMING
     spName:= 'gpInsert_wms_Movement_INCOMING';
     lGUID:= fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
     if not fInsert_wms_Message_pg (spName, lGUID) then exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
     //Result:= fInsert_wms_Message_to_wms (spName, lGUID);
     Result:= fInsert_Movement_to_wms (spName, lGUID);
     //
   finally
     FDC_wms.Connected := false;
     FDC_alan.Connected:= false;
   end;
end;
{------------------------------------------------------------------------}
function TMainForm.fInsert_to_wms_Movement_ASN_LOAD_all : Integer;
var spName : String;
    lGUID  : String;
begin
   Result:= 0;
   try
     if not fIni_FDC_wms  then exit;
     if not fIni_FDC_alan then exit;
     //
     // формируем и передаем данные - Movement_INCOMING
     spName:= 'gpInsert_wms_Movement_ASN_LOAD';
     lGUID:= fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
     if not fInsert_wms_Message_pg (spName, lGUID) then exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
     Result:= fInsert_wms_Message_to_wms (spName, lGUID);
     //
   finally
     FDC_wms.Connected := false;
     FDC_alan.Connected:= false;
   end;
end;
{------------------------------------------------------------------------}
function TMainForm.fInsert_to_wms_Movement_ORDER_all    : Integer;
var spName : String;
    lGUID  : String;
begin
   Result:= 0;
   try
     if not fIni_FDC_wms  then exit;
     if not fIni_FDC_alan then exit;
     //
     // формируем и передаем данные - Movement_INCOMING
     spName:= 'gpInsert_wms_Movement_ORDER';
     lGUID:= fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
     if not fInsert_wms_Message_pg (spName, lGUID) then exit;
     //
     // открываются данные из табл. Postresql.wms_Message и переносятся в oracle
     Result:= fInsert_Movement_to_wms (spName, lGUID);
     //
   finally
     FDC_wms.Connected := false;
     FDC_alan.Connected:= false;
   end;
end;
{------------------------------------------------------------------------}
// Только формируются данные в табл. Postresql.wms_Message
function TMainForm.fInsert_wms_Message_pg (pgProcName, GUID : String) : Boolean;
begin
     Result:= gpInsert_wms_Message (pgProcName, GUID);
     //
     if not Result then ShowMessage('ERR on pg = ' + pgProcName);
end;
{------------------------------------------------------------------------}
// Только Postresql.CLOCK_TIMESTAMP
function TMainForm.fGet_GUID_pg : String;
begin
     with to_wms_Message_query do begin
       Close;
       //
       Sql.Clear;
       Sql.Add('SELECT CLOCK_TIMESTAMP() AS RetV');
       Open;
       //
       Result:= DateTimeToStr(FieldByName('RetV').AsDateTime);
     end;
end;
{------------------------------------------------------------------------}
// открываются данные из табл. Postresql.wms_Message и переносятся в oracle
function TMainForm.fInsert_wms_Message_to_wms (pgProcName, GUID : String): Integer;
var ii , ii_num : Integer;
begin
     Result:= 0;
     //
     with to_wms_Message_query do begin
       Close;
       //
       Sql.Clear;
       Sql.Add(' SELECT * FROM wms_Message'
              +' WHERE GUID     = ' + chr(39) + GUID + chr(39)
//            +'   and ProcName = ' + chr(39) + pgProcName + chr(39)
              +' ORDER BY GroupId, RowNum');
       Open;
       //
       if not (Active) then showMessage('Err = Open = Postgresql = wms_Message = ' + pgProcName + ' GUID = ' + GUID);
       //
       //
       //
       //здесь будем формировать пакет
       to_wms_Packets_query.SQL.Clear;
       to_wms_Packets_query.SQL.Add('begin');
       //
       if (cbRecCount.Checked = true) and (StrToInt(EditRecCount.Text) = 0) then begin Result:= -1; exit; end;
       //
       ii:= 0;
       ii_num:=0;
       First;
       while not EOF do
       begin
            ii:= ii + 1;
            ii_num:= ii_num + 1;
            if ii_num > 3000 then
            begin
                 ii_num:=0;
                 // строчки завершают скрипт
                 to_wms_Packets_query.SQL.Add ('commit;');
                 to_wms_Packets_query.SQL.Add ('end;');
                 //
                 if cbDebug.Checked = TRUE then begin myLogSql;myShowSql;end;
                 // сохранили несколько XML в wms
                 try to_wms_Packets_query.ExecSQL; except
                    ShowMessage('!!!ERROR!!!');
                    myLogSql;
                    myShowSql;
                    exit;
                 end;
                 //
                 //крутим дальше - здесь будем формировать пакет
                 to_wms_Packets_query.SQL.Clear;
                 to_wms_Packets_query.SQL.Add('begin');
            end;

            // формируются несколько XML в пакет
            to_wms_Packets_query.SQL.Add
               ('insert into WMS.from_host_header_message'
                +' (SRC_HOST_ID, DST_HOST_ID'
                +', TYPE'          // VARCHAR2(64)    - Тип сообщения (тэг сообщения)
                +', ACTION'        // VARCHAR2(16)    - Действие (update/insert/delete)
//              +', CREATED'        // DATE            - Дата создания записи (заполняется автоматически)
                +', STATUS'        // VARCHAR2(16)    - текущий статус сообщения (ready – данные готовы к обработке                                     done – данные успешно обработаны                            error – данные обработаны с ошибкой)
//              +', START_DATE'     // DATE            - Дата начала обработки
//                +', FINISH_DATE'    // DATE            - Дата окончания обработки
                +', MESSAGE'       // VARCHAR2(2048)  - Xml-сообщения для обработки
//              +', ERR_CODE'       // NUMBER          - Код ошибки при обработке с                                                                                        ошибкой
//              +', ERR_DESCR'      // VARCHAR2(2048)  - Описание ошибки
                +')'
                +' values (' + chr(39) + 'kpl' + chr(39)
                +'        ,' + chr(39) + 'kpl' + chr(39)
                +'        ,' + chr(39) + FieldByName('TagName').AsString + chr(39)
                +'        ,' + chr(39) + FieldByName('ActionName').AsString + chr(39)
                +'        ,' + chr(39) + 'ready' + chr(39)
                +'        ,' + chr(39) + FieldByName('RowData').AsString + chr(39)
                +'         );'
                );
            //
            if (cbRecCount.Checked = true) and (StrToInt(EditRecCount.Text) = ii)
            then break;
            //
            Next;
       end;
       //
       Close;
     end;
     //
     // строчки завершают скрипт
     to_wms_Packets_query.SQL.Add ('commit;');
     to_wms_Packets_query.SQL.Add ('end;');
     //
     if cbDebug.Checked = TRUE then begin myLogSql;myShowSql;end;
     // сохранили несколько XML в wms
     try to_wms_Packets_query.ExecSQL; except ShowMessage('!!!ERROR!!!');myLogSql;myShowSql; exit;end;
     //
     Result:= -1;
end;
{------------------------------------------------------------------------}
function TMainForm.fInsert_Movement_to_wms (pgProcName, GUID : String): Integer;
var ii : Integer;
begin
     Result:= 0;
     //
     with to_wms_Message_query do begin
       Close;
       //
       Sql.Clear;
       Sql.Add(' SELECT * FROM wms_Message'
              +' WHERE GUID     = ' + chr(39) + GUID + chr(39)
//            +'   and ProcName = ' + chr(39) + pgProcName + chr(39)
              +' ORDER BY GroupId, RowNum');
       Open;
       //
       if not (Active) then showMessage('Err = Open = Postgresql = wms_Message = ' + pgProcName);
       //
       //
       if (cbRecCount.Checked = true) and (StrToInt(EditRecCount.Text) = 0) then begin Result:= -1; exit; end;
       //
       //
       //здесь будем формировать пакет
       to_wms_Packets_query.SQL.Clear;
       {to_wms_Packets_query.SQL.Add('begin');
       to_wms_Packets_query.SQL.Add('  insert into WMS.packets_to_wms (process_start)'
                                  + '     values (now()) returning pack_id into vb_pack_id;'
                                   );}
       //
       ii:= 0;
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
                       ii:= ii + 1;
                       if (cbRecCount.Checked = true) and (StrToInt(EditRecCount.Text) = ii)
                       then break;
                       //
                       // строчки завершают скрипт
                       to_wms_Packets_query.SQL.Add ('commit;');
                       to_wms_Packets_query.SQL.Add ('end;');
                       //
                       if cbDebug.Checked = TRUE then begin myLogSql;myShowSql;end;
                       // сохранили одну накладную с её строчками
                       try to_wms_Packets_query.ExecSQL; except ShowMessage('!!!ERROR!!!');myLogSql;myShowSql; exit;end;
                  end;
                  //
                  // теперь сначала
                  to_wms_Packets_query.SQL.Clear;
                  // здесь будем формировать пакет
                  to_wms_Packets_query.SQL.Add('declare');
                  to_wms_Packets_query.SQL.Add('  vb_id WMS.from_host_header_message.id%TYPE;');
                  to_wms_Packets_query.SQL.Add('begin');
                  // заголовок
                  to_wms_Packets_query.SQL.Add
                     ('insert into WMS.from_host_header_message'
                      +' (SRC_HOST_ID, DST_HOST_ID'
                      +', TYPE'          // VARCHAR2(64)    - Тип сообщения (тэг сообщения)
                      +', ACTION'        // VARCHAR2(16)    - Действие (update/insert/delete)
            //              +', CREATED'        // DATE            - Дата создания записи (заполняется автоматически)
                      +', STATUS'        // VARCHAR2(16)    - текущий статус сообщения (ready – данные готовы к обработке                                     done – данные успешно обработаны                            error – данные обработаны с ошибкой)
            //              +', START_DATE'     // DATE            - Дата начала обработки
            //                +', FINISH_DATE'    // DATE            - Дата окончания обработки
                      +', MESSAGE'       // VARCHAR2(2048)  - Xml-сообщения для обработки
            //              +', ERR_CODE'       // NUMBER          - Код ошибки при обработке с                                                                                        ошибкой
            //              +', ERR_DESCR'      // VARCHAR2(2048)  - Описание ошибки
                      +')'
                      +' values (' + chr(39) + 'kpl' + chr(39)
                      +'        ,' + chr(39) + 'kpl' + chr(39)
                      +'        ,' + chr(39) + FieldByName('TagName').AsString + chr(39)
                      +'        ,' + chr(39) + FieldByName('ActionName').AsString + chr(39)
                      +'        ,' + chr(39) + 'ready' + chr(39)
                      +'        ,' + chr(39) + FieldByName('RowData').AsString + chr(39)
                      +'         )'
                      + '       returning id into vb_id;'
                      );
                  //
                  to_wms_Packets_query.SQL.Add ('commit;');
            end
            else
                //строчная часть
                to_wms_Packets_query.SQL.Add
                   ('insert into WMS.from_host_detail_message'
                    +' (HEADER_ID'
                    +', TYPE'          // VARCHAR2(64)    - Тип сообщения (тэг сообщения)
                    +', ACTION'        // VARCHAR2(16)    - Действие (update/insert/delete)
          //        +', CREATED'        // DATE            - Дата создания записи (заполняется автоматически)
                    +', STATUS'        // VARCHAR2(16)    - текущий статус сообщения (ready – данные готовы к обработке                                     done – данные успешно обработаны                            error – данные обработаны с ошибкой)
          //        +', START_DATE'     // DATE            - Дата начала обработки
          //        +', FINISH_DATE'    // DATE            - Дата окончания обработки
                    +', MESSAGE'       // VARCHAR2(2048)  - Xml-сообщения для обработки
          //        +', ERR_CODE'       // NUMBER          - Код ошибки при обработке с                                                                                        ошибкой
          //        +', ERR_DESCR'      // VARCHAR2(2048)  - Описание ошибки
                    +')'
                    +' values (vb_id'
                    +'        ,' + chr(39) + FieldByName('TagName').AsString + chr(39)
                    +'        ,' + chr(39) + FieldByName('ActionName').AsString + chr(39)
                    +'        ,' + chr(39) + 'ready' + chr(39)
                    +'        ,' + chr(39) + FieldByName('RowData').AsString + chr(39)
                    +'         );'
                    );
            //
            // куртим дальше
            Next;
       end;
       //
       Close;
     end;
     //
     // строчки завершают скрипт
     to_wms_Packets_query.SQL.Add ('commit;');
     to_wms_Packets_query.SQL.Add ('end;');
     //
     if cbDebug.Checked = TRUE then myShowSql;
     // сохранили несколько XML в wms
     try to_wms_Packets_query.ExecSQL; except ShowMessage('!!!ERROR!!!');myShowSql; exit;end;
     //
     Result:= -1;
end;
{------------------------------------------------------------------------}
function TMainForm.fInsert_to_wms_SKU : Integer;
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
var spName : String;
    lGUID  : String;
    i : Integer;
    vb_pack_id : Integer;
begin
   Result:= 0;
   try
     if not fIni_FDC_wms  then exit;
     if not fIni_FDC_alan then exit;
     //
     // формируем и передаем данные - SKU
     spName:= 'gpInsert_wms_Object_SKU';
     lGUID:= fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
     if not fInsert_wms_Message_pg (spName, lGUID) then exit;
     //
     //
     with to_wms_Message_query do begin
       Close;
       //
       Sql.Clear;
       Sql.Add('SELECT * FROM wms_Message WHERE ProcName = ' + chr(39) + spName + chr(39));
       Open;
       //
       if not (Active) then showMessage('Err = Open = alan = wms_Message = ' + spName);
       //
       // !!! insert pack_id
       vb_pack_id:= p_alan_insert_packets_to_wms;
       //
       //
       //здесь будем формировать пакет
       to_wms_Packets_query.SQL.Clear;
       to_wms_Packets_query.SQL.Add('begin');
       //to_wms_Packets_query.Params.ArraySize:= 12000;
       //
       i:= 0;
       First;
       while not EOF do
       begin
            i:= i + 1;
            //
            if (i >= 100) and (1=1) then
            begin
                 to_wms_Packets_query.SQL.Add ('commit;');
                 to_wms_Packets_query.SQL.Add ('end;');
                 // сохранили несколько XML в wms
                 try to_wms_Packets_query.ExecSQL; except ShowMessage('!!!ERROR!!!');myLogSql;myShowSql;end;
                 //
                 to_wms_Packets_query.SQL.Clear;
                 to_wms_Packets_query.SQL.Add ('begin');
                 //начинаем сначада
                 i:= 0;
            end;
            // формируются несколько XML в пакет
            to_wms_Packets_query.SQL.Add ('insert into WMS.xml_data_to_wms (pack_id, line, Data)'
                                         +' values (' + IntToStr(vb_pack_id)
                                         +'        ,' + IntToStr(FieldByName('RowNum').AsInteger)
                                         +'        ,' + chr(39) + FieldByName('RowData').AsString + chr(39)
                                         +'         );'
                                         );
            Next;
       end;
       //
       Close;
     end;
     //
     // строчки завершают скрипт
     to_wms_Packets_query.SQL.Add ('commit;');
     to_wms_Packets_query.SQL.Add ('end;');
     //
     if cbDebug.Checked = TRUE then begin myLogSql;myShowSql;end;
     // сохранили несколько XML в wms
     try to_wms_Packets_query.ExecSQL; except ShowMessage('!!!ERROR!!!');myLogSql;myShowSql;end;

   finally
     FDC_wms.Connected := false;
     FDC_alan.Connected:= false;
   end;
   //
   Result:= vb_pack_id;
end;
{------------------------------------------------------------------------}
function TMainForm.fInsert_to_wms_CLIENT : Integer;
var spName : String;
    lGUID  : String;
    i : Integer;
    vb_pack_id : Integer;
begin
   Result:= 0;
   try
     if not fIni_FDC_wms  then exit;
     if not fIni_FDC_alan then exit;
     //
     // формируем и передаем данные - SKU
     spName:= 'gpInsert_wms_Object_CLIENT';
     lGUID:= fGet_GUID_pg;
     //
     // Только формируются данные в табл. Postresql.wms_Message
     if not fInsert_wms_Message_pg (spName, lGUID) then exit;
     //
     //
     with to_wms_Message_query do begin
       Close;
       //
       Sql.Clear;
       Sql.Add('SELECT * FROM wms_Message WHERE ProcName = ' + chr(39) + spName + chr(39));
       Open;
       //
       if not (Active) then showMessage('Err = Open = alan = wms_Message = ' + spName);
       //
       // !!! insert pack_id
       vb_pack_id:= p_alan_insert_packets_to_wms;
       //
       //
       //здесь будем формировать пакет
       to_wms_Packets_query.SQL.Clear;
       to_wms_Packets_query.SQL.Add('begin');
       //to_wms_Packets_query.Params.ArraySize:= 12000;
       //
       i:= 0;
       First;
       while not EOF do
       begin
            i:= i + 1;
            //
            if (i >= 2) and (1=1) then
            begin
                 to_wms_Packets_query.SQL.Add ('commit;');
                 to_wms_Packets_query.SQL.Add ('end;');
                 // сохранили несколько XML в wms
                 try to_wms_Packets_query.ExecSQL; except ShowMessage('!!!ERROR!!!');myLogSql;myShowSql;end;
                 //
                 to_wms_Packets_query.SQL.Clear;
                 to_wms_Packets_query.SQL.Add ('begin');
                 //начинаем сначада
                 i:= 0;
            end;
            // формируются несколько XML в пакет
            to_wms_Packets_query.SQL.Add ('insert into WMS.xml_data_to_wms (pack_id, line, Data)'
                                         +' values (' + IntToStr(vb_pack_id)
                                         +'        ,' + IntToStr(FieldByName('RowNum').AsInteger)
                                         +'        ,' + chr(39) + FieldByName('RowData').AsString + chr(39)
                                         +'         );'
                                         );
            Next;
       end;
       //
       Close;
     end;
     //
     // строчки завершают скрипт
     to_wms_Packets_query.SQL.Add ('commit;');
     to_wms_Packets_query.SQL.Add ('end;');
     //
     if cbDebug.Checked = TRUE then begin myLogSql;myShowSql;end;
     // сохранили несколько XML в wms
     try to_wms_Packets_query.ExecSQL; except ShowMessage('!!!ERROR!!!');myLogSql;myShowSql;end;

   finally
     FDC_wms.Connected := false;
     FDC_alan.Connected:= false;
   end;
   //
   Result:= vb_pack_id;
end;
{------------------------------------------------------------------------}
procedure TMainForm.btnObject_SKU_to_wmsClick(Sender: TObject);
var vb_pack_id : Integer;
begin
   // SKU
   vb_pack_id:= fInsert_to_wms_SKU_all;
   if vb_pack_id <> 0
   then ShowMessage('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU')
   else ShowMessage('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU');
end;
{------------------------------------------------------------------------}
procedure TMainForm.btnObject_SKU_CODE_to_wmsClick(Sender: TObject);
var vb_pack_id : Integer;
begin
   // SKU_CODE
   vb_pack_id:= fInsert_to_wms_SKU_CODE_all;
   if vb_pack_id <> 0
   then ShowMessage('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU_CODE')
   else ShowMessage('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU_CODE');
end;
{------------------------------------------------------------------------}
procedure TMainForm.btnObject_SKU_GROUP_DEPENDS_to_wmsClickClick(Sender: TObject);
var vb_pack_id : Integer;
begin
   // sku_group + sku_depends
   vb_pack_id:= fInsert_to_wms_SKU_GROUP_all;
   if vb_pack_id <> 0
   then ShowMessage('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU_GROUP + SKU_DEPENDS')
   else ShowMessage('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_SKU_GROUP + SKU_DEPENDS');
end;
{------------------------------------------------------------------------}
procedure TMainForm.btnObject_CLIENT_to_wmsClick(Sender: TObject);
var vb_pack_id : Integer;
begin
   // sku_group + sku_depends
   vb_pack_id:= fInsert_to_wms_CLIENT_all;
   //vb_pack_id:= fInsert_to_wms_CLIENT;
   if vb_pack_id <> 0
   then ShowMessage('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_CLIENT')
   else ShowMessage('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_CLIENT');
end;
{------------------------------------------------------------------------}
procedure TMainForm.btnObject_PACK_to_wmsClick(Sender: TObject);
var vb_pack_id : Integer;
begin
   // sku_group + sku_depends
   vb_pack_id:= fInsert_to_wms_PACK_all;
   if vb_pack_id <> 0
   then ShowMessage('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_PACK')
   else ShowMessage('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_PACK');
end;
{------------------------------------------------------------------------}
procedure TMainForm.btnObject_USER_to_wmsClick(Sender: TObject);
var vb_pack_id : Integer;
begin
   // sku_group + sku_depends
   vb_pack_id:= fInsert_to_wms_USER_all;
   if vb_pack_id <> 0
   then ShowMessage('ok - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_USER')
   else ShowMessage('ERROR - pack_id = ' + IntToStr(vb_pack_id) + ' spName = fInsert_to_wms_USER');
end;
{------------------------------------------------------------------------}
procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
     FDC_wms.Connected:= false;
     FDC_alan.Connected:= false;
end;
{------------------------------------------------------------------------}
end.
