unit Storage;

{$I dsdVer.inc}

interface

uses SysUtils, System.Classes;

type

  ///	<summary>
  /// Интерфейс - мост между приложением и средним уровнем.
  ///	</summary>
  ///	<remarks>
  /// Используейте данный Интерфейс для вызова методов на сервере базе данных
  ///	</remarks>
  IStorage = interface
    function GetConnection: string;
    ///	<summary>
    /// Процедура вызова обработчика XML структры на среднем уровне.
    ///	</summary>
    ///	<remarks>
    /// Возвращает XML как результат вызова
    ///	</remarks>
    ///	<param name="pData">
    ///	  XML структура, хранящая данные для обработки на сервере
    ///	</param>
    ///	<param name="pExecOnServer">
    ///	  если true, то процедуры выполняются в цикле на среднем уровне
    ///	</param>
    function ExecuteProc(pData: String; pExecOnServer: boolean = false;
      AMaxAtempt: Byte = 10; ANeedShowException: Boolean = True): Variant;

    procedure LoadReportList(ASession: string);
    procedure LoadReportLocalList(ASession: string);
    property Connection: String read GetConnection;
  end;

  TStorageFactory = class
     class function GetStorage: IStorage;
  end;

  EStorageException = class(Exception)
  private
    FErrorCode: string;
  public
    constructor Create(AMessage: String; AErrorCode: String = '');
    property ErrorCode: string read FErrorCode write FErrorCode;
  end;

  function ConvertXMLParamToStrings(XMLParam: String): String;
  function GetXMLParam_gConnectHost(XMLParam: String): String;
  function GetStringStream(AValue: String): TStringStream;

implementation

uses IdHTTP, Xml.XMLDoc, XMLIntf, ZLibEx, idGlobal, UtilConst, System.Variants,
     UtilConvert, MessagesUnit, Dialogs, StrUtils, IDComponent, SimpleGauge,
     Forms, Log, IdStack, IdExceptionCore, SyncObjS, CommonData, System.AnsiStrings,
     Datasnap.DBClient, System.Contnrs;

const

   ResultTypeLenght = 13;
   IsArchiveLenght = 2;
   XMLStructureLenghtLenght = 10;

type
  TConnectionType = (ctMain, ctReport, ctReportLocal);

  TConnection = class
  private
    FCString: string;
    FCType: TConnectionType;
  public
    constructor Create(ACString: string; ACType: TConnectionType);
    property CString: string read FCString;
    property CType: TConnectionType read FCType;
  end;

  TConnectionList = class(TObjectList)
  private
    FCurrentConnection: array[TConnectionType] of TConnection;
    function GetConnection(Index: Integer): TConnection;
    procedure SetConnection(Index: Integer; const Value: TConnection);
    function GetCurrentConnection(ACType: TConnectionType): TConnection;
  public
    procedure AfterConstruction; override;
    procedure AddFromFile(AFileName: string; AConnectionType: TConnectionType);
    function FirstConnection(ACType: TConnectionType): TConnection;
    function NextConnection(ACType: TConnectionType): TConnection;
    property Items[Index: Integer]: TConnection read GetConnection write SetConnection; default;
    property CurrentConnection[ACType: TConnectionType]: TConnection read GetCurrentConnection;
  end;

  TStorage = class(TInterfacedObject, IStorage)
  strict private
    class var
      Instance: TStorage;
  private
    IdHTTP: TIdHTTP;
    FSendList: TStringList;
    FReceiveStream: TStringStream;
    FReceiveStreamUTF8: TStringStream;
    FReceiveStreamBytes: TBytesStream;
    Str: String;//RawByteString;
    XMLDocument: IXMLDocument;
    isArchive: boolean;
    // критичесая секция нужна из-за таймера
    FCriticalSection: TCriticalSection;
    FReportList: TStringList;
    FReportLocalList: TStringList;
    FConnectionList: TConnectionList;
    function PrepareStr: String;
    procedure PrepareStream(AStream: TBytesStream);
    function ExecuteProc(pData: String; pExecOnServer: boolean = false;
      AMaxAtempt: Byte = 10; ANeedShowException: Boolean = True): Variant;
    procedure ProcessErrorCode(pData: String; ProcedureParam: String);
    function ProcessMultiDataSet: Variant;
    function GetConnection: string;
    procedure LoadReportList(ASession: string);
    procedure LoadReportLocalList(ASession: string);
    function CheckConnectionType(pData: string): TConnectionType;
    procedure InsertReportProtocol(pData: string);
  public
    property Connection: String read GetConnection;
    class function NewInstance: TObject; override;

  end;

  TIdHTTPWork = class
    FExecOnServer: boolean;
    Gauge: IGauge;
    procedure IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure IdHTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
  end;

  var
    IdHTTPWork: TIdHTTPWork;

function TStorage.GetConnection: string;
begin
  if FConnectionList.CurrentConnection[ctMain] <> nil then
    Result := FConnectionList.CurrentConnection[ctMain].CString
  else
    Result := FConnectionList.FirstConnection(ctMain).CString;
end;

procedure TStorage.InsertReportProtocol(pData: string);
const
  {создаем XML вызова процедуры на сервере}
  pXML =
    '<xml Session = "%s" AutoWidth = "0">' +
      '<gpInsert_ReportProtocol OutputType = "otResult" DataSetType = "">' +
      '<inProtocolData DataType="ftBlob" Value="%s" />' +
      '</gpInsert_ReportProtocol>' +
    '</xml>';
var
  XML: IXMLDocument;
  Data, NodeFun, NodeParam: IXMLNode;
  I, J: Integer;
  S, T, Q: string;
begin
  TXMLDocument.Create(nil).GetInterface(IXMLDocument, XML);

  XML.LoadFromXML(pData);
  Data := XML.DocumentElement;
  S := '';

  if Data <> nil then
  begin
    for I := 0 to Pred(Data.ChildNodes.Count) do
    begin
      NodeFun := Data.ChildNodes.Get(I);
      S := S + NodeFun.NodeName + ' (';
      for J := 0 to Pred(NodeFun.ChildNodes.Count) do
      begin
        NodeParam := NodeFun.ChildNodes.Get(J);
        T := NodeParam.Attributes['DataType'];
        Q := '';
        if (T = 'ftString') or (T = 'ftWideString') or (T = 'ftBlob') or (T = 'ftDateTime') or (T = 'ftDate') then
          Q := '''';
        S := S + NodeParam.NodeName + ':= ' + Q + NodeParam.Attributes['Value'] + Q + ', ';
      end;
      S := S + 'inSession:= ''' + Data.Attributes['Session'] + ''')';
    end;
  end;

  FSendList.Clear;
  FSendList.Add('XML=' + '<?xml version="1.0" encoding="windows-1251"?>' +
    Format(pXML, [gc_User.Session, S {pData}]));
  FReceiveStream.Clear;
  IdHTTPWork.FExecOnServer := False;

  try
    IdHTTP.Post(FConnectionList.CurrentConnection[ctMain].CString, FSendList, FReceiveStream,
      {$IFDEF DELPHI103RIO} IndyTextEncoding(1251) {$ELSE} TIdTextEncoding.GetEncoding(1251) {$ENDIF});
  except
    IdHTTP.Disconnect;
  end;
end;

procedure TStorage.LoadReportList(ASession: string);
const
  {создаем XML вызова процедуры на сервере}
  pXML =
    '<xml Session = "%s" AutoWidth = "0">' +
      '<gpSelect_Object_ReportExternal OutputType = "otDataSet" DataSetType = "TClientDataSet">' +
      '</gpSelect_Object_ReportExternal>' +
    '</xml>';
var
  DataSet: TClientDataSet;
  Stream: TStringStream;
begin
  FReportList.Clear;
  try
    DataSet := TClientDataSet.Create(nil);
    Stream := nil;
    try
      Stream := GetStringStream(String(TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [ASession]))));
      DataSet.LoadFromStream(Stream);
      if not DataSet.IsEmpty then
        while not DataSet.Eof do
        begin
          if not DataSet.FieldByName('isErased').AsBoolean then
            FReportList.Add(DataSet.FieldByName('Name').AsString);
          DataSet.Next;
        end;
    finally
      if Assigned(Stream) then
        Stream.Free;
      DataSet.Free;
    end;
  except
  end;
end;

procedure TStorage.LoadReportLocalList(ASession: string);
const
  {создаем XML вызова процедуры на сервере}
  pXML =
    '<xml Session = "%s" AutoWidth = "0">' +
      '<gpSelect_Object_ReportLocalService OutputType = "otDataSet" DataSetType = "TClientDataSet">' +
      '</gpSelect_Object_ReportLocalService>' +
    '</xml>';
var
  DataSet: TClientDataSet;
  Stream: TStringStream;
begin
  FReportLocalList.Clear;
  try
    DataSet := TClientDataSet.Create(nil);
    Stream := nil;
    try
      Stream := GetStringStream(String(TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [ASession]))));
      DataSet.LoadFromStream(Stream);
      if not DataSet.IsEmpty then
        while not DataSet.Eof do
        begin
          if not DataSet.FieldByName('isErased').AsBoolean then
            FReportLocalList.Add(DataSet.FieldByName('Name').AsString);
          DataSet.Next;
        end;
    finally
      if Assigned(Stream) then
        Stream.Free;
      DataSet.Free;
    end;
  except
  end;
end;

class function TStorage.NewInstance: TObject;
var
  lConnectionPathRep, lConnectionPathRepLocal : String;
begin
  if not Assigned(Instance) then begin
    Instance := TStorage(inherited NewInstance);
    Instance.FReportList := TStringList.Create;
    Instance.FReportLocalList := TStringList.Create;
    Instance.FConnectionList := TConnectionList.Create;

    if gc_ProgramName = 'FDemo.exe' then
    begin
      // !!! DEMO
      Instance.FConnectionList.Add(TConnection.Create('http://farmacy-dev2.neboley.dp.ua', ctMain));
      Instance.FConnectionList.Add(TConnection.Create('http://farmacy-dev2.neboley.dp.ua', ctReport));
    end
    else
    if gc_ProgramName = 'Boutique_Demo.exe' then
    begin
      // !!! DEMO
      Instance.FConnectionList.Add(TConnection.Create('http://94.27.55.146/bout_demo/index.php', ctMain));
      Instance.FConnectionList.Add(TConnection.Create('http://94.27.55.146/bout_demo/index.php', ctReport));
    end
    else begin

      if Pos('\farmacy_init.php', ConnectionPath) > 0 then
        lConnectionPathRep := ReplaceStr(ConnectionPath, '\farmacy_init.php', '\farmacy_initRep.php')
      else lConnectionPathRep := ReplaceStr(ConnectionPath, '\init.php', '\initRep.php');

      if Pos('\farmacy_init.php', ConnectionPath) > 0 then
        lConnectionPathRepLocal := ReplaceStr(ConnectionPath, '\farmacy_init.php', '\farmacy_initRepLocal.php')
      else lConnectionPathRepLocal := ReplaceStr(ConnectionPath, '\init.php', '\initRepLocal.php');

      Instance.FConnectionList.AddFromFile(ConnectionPath, ctMain);
      if (lConnectionPathRep <> ConnectionPath) and FileExists(lConnectionPathRep) then
        Instance.FConnectionList.AddFromFile(lConnectionPathRep, ctReport);
      if (lConnectionPathRepLocal <> ConnectionPath) and FileExists(lConnectionPathRepLocal) then
        Instance.FConnectionList.AddFromFile(lConnectionPathRepLocal, ctReportLocal);
    end;

    if Instance.FConnectionList.Count = 0 then
      Instance.FConnectionList.Add(TConnection.Create('http://localhost/dsd/index.php', ctMain));

    Instance.IdHTTP := TIdHTTP.Create(nil);
//    Instance.IdHTTP.ConnectTimeout := 5000;
    if dsdProject = prBoat then
      Instance.IdHTTP.Response.CharSet := 'utf-8'// 'Content-Type: text/xml; charset=utf-8'
    else
      Instance.IdHTTP.Response.CharSet := 'windows-1251';
    Instance.IdHTTP.Request.Connection:='keep-alive';
    Instance.IdHTTP.OnWorkBegin := IdHTTPWork.IdHTTPWorkBegin;
    Instance.IdHTTP.OnWork := IdHTTPWork.IdHTTPWork;
    Instance.FSendList := TStringList.Create;
    Instance.FReceiveStream := TStringStream.Create('');
    if dsdProject = prBoat then
    begin
      Instance.FReceiveStreamUTF8 := TStringStream.Create('', TEncoding.UTF8);
      Instance.FReceiveStreamBytes := TBytesStream.Create;
    end;
    Instance.XMLDocument := TXMLDocument.Create(nil);
    Instance.FCriticalSection := TCriticalSection.Create;
  end;

  NewInstance := Instance;
end;

procedure TIdHTTPWork.IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  if not FExecOnServer then
     exit;
  if AWorkMode = wmRead then
     Gauge.IncProgress(1);
end;

procedure TIdHTTPWork.IdHTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  if not FExecOnServer then
     exit;
  if AWorkMode = wmWrite then begin
     TIdHTTP(ASender).IOHandler.RecvBufferSize := 1;
     Gauge := TGaugeFactory.GetGauge('Выполнение процедуры на сервере', 1, 100);
     Gauge.Start;
  end;
end;

function TStorage.PrepareStr: String;
begin
  if isArchive then
  begin
    Logger.AddToLog(' TStorage.PrepareStr ... Result := ZDecompressStr(Str)');
    Result := ZDecompressStr(Str);
  end else
  begin
    Logger.AddToLog(' TStorage.PrepareStr ... Result := Str');
    Result := Str;
  end;
  if dsdProject <> prBoat then
    Result := AnsiString(Result);
end;

procedure TStorage.PrepareStream(AStream: TBytesStream);
var FTempStream: TBytesStream;
    FPos: int64;
begin
  FTempStream := TBytesStream.Create;
  FPos := AStream.Position;
  try
    ZDecompressStream(AStream, FTempStream);
    AStream.Bytes[FPos - 2] := Ord('f');
    AStream.Size := FPos;
    FTempStream.Position := 0;
    FTempStream.SaveToStream(AStream);
    AStream.SaveToFile('receive_unpacked.bin');
  finally
    FTempStream.Free;
    AStream.Position := FPos;
  end;
end;

function ReadStringFromTBytesStream(AStream: TBytesStream; ALength: integer): AnsiString;
begin
  SetLength(Result, ALength);
  AStream.Read(Result[1], SizeOf(Byte)*ALength);
end;

function CheckIfTBytesStreamStartsWith(AStream: TBytesStream; AString: AnsiString): boolean;
var SavePos: int64;
begin
  SavePos := AStream.Position;
  Result := SameText(ReadStringFromTBytesStream(AStream, Length(AString)), AString);
  AStream.Position := SavePos;
end;

procedure TStorage.ProcessErrorCode(pData: String; ProcedureParam: String);
begin
  with LoadXMLData(pData).DocumentElement do
    if NodeName = gcError then
       raise EStorageException.Create(StringReplace(GetAttribute(gcErrorMessage), 'ОШИБКА:  ', '', []) + ' context: ' + ProcedureParam, GetAttribute(gcErrorCode));
end;

function TStorage.ProcessMultiDataSet: Variant;
var
  XMLStructureLenght: integer;
  DataFromServer: String;
  i, StartPosition: integer;
begin
  DataFromServer := PrepareStr;
  // Для нескольких датасетов процедура более сложная.
  // В начале надо получить XML, где хранятся данные по ДатаСетам.

  XMLStructureLenght := StrToInt(Copy(DataFromServer, 1, XMLStructureLenghtLenght));
  XMLDocument.LoadFromXML(Copy(DataFromServer, XMLStructureLenghtLenght + 1, XMLStructureLenght));
  with XMLDocument.DocumentElement do begin
    result := VarArrayCreate([0, ChildNodes.Count - 1], varVariant);
    // Сдвигаем указатель на нужное кол-во байт, что бы не копировать строку
    StartPosition := XMLStructureLenghtLenght + 1 + XMLStructureLenght;
    for I := 0 to ChildNodes.Count - 1 do begin
      XMLStructureLenght := StrToInt(ChildNodes[i].GetAttribute('length'));
      result[i] := Copy(DataFromServer, StartPosition,  XMLStructureLenght);
      StartPosition := StartPosition + XMLStructureLenght;
    end;
  end;
end;

function PrepareValue(Value, DataType: string): string;
begin
  if (DataType = 'ftBlob') or (DataType = 'ftString') or (DataType = 'ftWideString') or (DataType = 'ftBoolean') then
     result := chr(39) + Value + chr(39);
  if (DataType = 'ftFloat') or (DataType = 'ftInteger') then
     result := Value;
  if (DataType = 'ftDateTime') then
     result := '(' + chr(39) + Value + chr(39) + ')::TDateTime';
end;

function ConvertXMLParamToStrings(XMLParam: String): String;
var i: integer;
    Session: String;
begin
  result := '';
  with LoadXMLData(XMLParam).DocumentElement do begin
     Session := GetAttribute('Session');
     with ChildNodes.First do begin
       result := 'select * from ' + NodeName + '(';
       for I := 0 to ChildNodes.Count - 1 do
         with ChildNodes[i] do begin
           result := result + NodeName + ' := ' + PrepareValue(GetAttribute('Value'), GetAttribute('DataType')) + ' , ';
         end;
       result := result + ' inSession := ' + chr(39) + Session + chr(39) + ');';
     end;
  end;
end;

function GetXMLParam_gConnectHost(XMLParam: String): String;
var i: integer;
begin
   result := '';
   //
   // захардкодил НАЗВАНИЕ параметра - если он есть, тогда в нем "другой" Веб-сервер
   if Pos('<gConnectHost ', XMLParam) > 0
   then
       with LoadXMLData(XMLParam).DocumentElement do
        with ChildNodes.First do
         for i := 0 to ChildNodes.Count - 1 do
          with ChildNodes[i] do
           if NodeName = 'gConnectHost' then
           begin
              //result := PrepareValue(GetAttribute('Value'), GetAttribute('DataType'));
              result := GetAttribute('Value');
              if result <> '' then result := 'http://' + result;
              break
           end;
end;

function TStorage.CheckConnectionType(pData: string): TConnectionType;
var
  S: string;
begin
  Result := ctMain;
  if FReportLocalList.Count > 0 then
    for S in FReportLocalList do
      if Pos(S + ' ', pData) > 0 then
      begin
        Result := ctReportLocal;
        Break;
      end;
  if FReportList.Count > 0 then
    for S in FReportList do
      if Pos(S + ' ', pData) > 0 then
      begin
        Result := ctReport;
        Break;
      end;
end;

procedure MyDelay_two(mySec:Integer);
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  calcSec,calcSec2:LongInt;
begin
     Present:=Now;
     DecodeDate(Present, Year, Month, Day);
     DecodeTime(Present, Hour, Min, Sec, MSec);
     //calcSec:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
     //calcSec2:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
     calcSec:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     calcSec2:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     while abs(calcSec-calcSec2)<mySec do
     begin
          Present:=Now;
          DecodeDate(Present, Year, Month, Day);
          DecodeTime(Present, Hour, Min, Sec, MSec);
          //calcSec2:=Year*12*31*24*60*60+Month*31*24*60*60+Day*24*60*60+Hour*60*60+Min*60+Sec;
          calcSec2:=Day*24*60*60*1000+Hour*60*60*1000+Min*60*1000+Sec*1000+MSec;
     end;
end;

function TStorage.ExecuteProc(pData: String; pExecOnServer: boolean = false;
  AMaxAtempt: Byte = 10; ANeedShowException: Boolean = True): Variant;
  function GetAddConnectString(pExecOnServer: boolean): String;
  begin
    if pExecOnServer then
       result := 'server.php'
    else
       result := '';
  end;
var
iii : Integer;
  ResultType: string;
  AttemptCount: Integer;
  ok, isBinary: Boolean;
  CType: TConnectionType;
  CString, DString: string;
  function LastAttempt: Boolean;
  Begin
    Result := (AttemptCount >= AMaxAtempt) AND (FConnectionList.CurrentConnection[CType] = nil);
  End;
  function Midle: Boolean;
  Begin
    Result := (AttemptCount = (AMaxAtempt div 2));
  End;
begin
  //!!!Переопределили как то криво
  if gc_User.LocalMaxAtempt > 0 then AMaxAtempt:= gc_User.LocalMaxAtempt;
  //

  FCriticalSection.Enter;
  try
    if (gc_User.Local = true)  and  (AMaxAtempt = 10) then
     AMaxAtempt := 2;   // для локольного режима один проход
    if gc_isDebugMode then
       TMessagesForm.Create(nil).Execute(ConvertXMLParamToStrings(pData), ConvertXMLParamToStrings(pData), true);

    CType := CheckConnectionType(pData);

    if CType = ctReport then
      InsertReportProtocol(pData);

    if CType = ctReportLocal then
     AMaxAtempt := 4;   // для отчетов через локальный сервер 3 прохода

    FSendList.Clear;
    if dsdProject = prBoat then
      FSendList.Add('XML=' + '<?xml version="1.0" encoding="utf-8"?>' + pData)
    else
      FSendList.Add('XML=' + '<?xml version="1.0" encoding="windows-1251"?>' + pData);
    if dsdProject = prBoat then
      FSendList.Add('ENC=UTF8');
    Logger.AddToLog(pData);
    FReceiveStream.Clear;
    if dsdProject = prBoat then
    begin
      FReceiveStreamUTF8.Clear;
      FReceiveStreamBytes.Clear;
    end;
    IdHTTPWork.FExecOnServer := pExecOnServer;
    AttemptCount := 0;
    ok := False;

    // если есть "такое" НАЗВАНИЕ параметра, тогда в нем "другой" Веб-сервер
    CString:= GetXMLParam_gConnectHost(pData);
    //
    if CString = '' then
      if FConnectionList.CurrentConnection[CType] <> nil then
        CString := FConnectionList.CurrentConnection[CType].CString
      else if FConnectionList.FirstConnection(CType) <> nil then
        CString := FConnectionList.FirstConnection(CType).CString
      else CString := FConnectionList.CurrentConnection[ctMain].CString;

    try
      repeat
        for AttemptCount := 1 to AMaxAtempt do
        Begin
          try

   if ((Pos('TSale_OrderJournalForm', pData) > 0) or (Pos('TReturnInJournalForm', pData) > 0))
    and (Pos('gpGet_Object_Form', pData) > 0)
    and (1=0)
   then
      for iii:= 1 to 100 do begin

      if Assigned (FReceiveStream) then FReceiveStream.Clear;

      Logger.AddToLog(' .........' );
      Logger.AddToLog(' ...... start ...' + IntToSTr(iii));
      Logger.AddToLog(' ......... send:');
      Logger.AddToLog(FSendList[0]);
      Logger.AddToLog(' .........');

            idHTTP.Post(CString + GetAddConnectString(pExecOnServer), FSendList, FReceiveStream,
              {$IFDEF DELPHI103RIO} IndyTextEncoding(1251) {$ELSE} TIdTextEncoding.GetEncoding(1251) {$ENDIF});

            DString := FReceiveStream.DataString;

      Logger.AddToLog(' .........');
      Logger.AddToLog(' ......... receive:');
      Logger.AddToLog(DString);
      Logger.AddToLog(' ...... end ...' + IntToSTr(iii));
      Logger.AddToLog(' .........');

      MyDelay_two(1000);


   end
   else
   begin
      Logger.AddToLog(' try ... AttemptCount = ' + IntToStr(AttemptCount));
      if dsdProject = prBoat then
      begin
        if FindCmdLineSwitch('log', true)
        then ShowMessage(CString + GetAddConnectString(pExecOnServer)+#10+#13+ FSendList.Text);
        Logger.AddToLog(CString + GetAddConnectString(pExecOnServer)+#10+#13+ FSendList.Text);
        if FindCmdLineSwitch('log', true)
        then ShowMessage('start idHTTP.Post ...');
        //
        idHTTP.Post(CString + GetAddConnectString(pExecOnServer), FSendList, FReceiveStreamBytes,
            {$IFDEF DELPHI103RIO} IndyTextEncoding(IdTextEncodingType.encUTF8) {$ELSE} TIdTextEncoding.UTF8 {$ENDIF});
        FReceiveStreamBytes.Position := 0;
        //FReceiveStreamBytes.SaveToFile('receive.bin');
        FReceiveStreamBytes.Position := ResultTypeLenght;
        // uncompress if compressed
        if SameText(Trim(ReadStringFromTBytesStream(FReceiveStreamBytes, 2)), 't') then
          PrepareStream(FReceiveStreamBytes);

        if CheckIfTBytesStreamStartsWith(FReceiveStreamBytes, '<?xml version="1.0"')
           or
           CheckIfTBytesStreamStartsWith(FReceiveStreamBytes, '<Result ')
           or
           CheckIfTBytesStreamStartsWith(FReceiveStreamBytes, '<error ') then
        begin
          FReceiveStreamBytes.SaveToStream(FReceiveStreamUTF8);
          isBinary := false;
        end
        else
        begin
          FReceiveStreamBytes.SaveToStream(FReceiveStream);
          isBinary := true;
        end;
      end
      else
      begin
        idHTTP.Post(CString + GetAddConnectString(pExecOnServer), FSendList, FReceiveStream,
              {$IFDEF DELPHI103RIO} IndyTextEncoding(1251) {$ELSE} TIdTextEncoding.GetEncoding(1251) {$ENDIF});
      end;
   end;

      Logger.AddToLog(' ok ...');

            ok := true;
            break;
          except
            on E: EIdSocketError do
            Begin
              if LastAttempt then
              Begin
                if ANeedShowException then
                Begin
                  if gc_allowLocalConnection AND not gc_User.Local then
                  Begin
                    gc_User.Local := True;
                    //ShowMessage('Программа переведена в режим автономной работы.'+#13+
                    //            'Перезайдите в программу после восстановления связи с сервером.')
                  end;
                  case CType of
                     ctMain :
                        case E.LastError of
                          10051: raise EStorageException.Create('Отсутсвует подключение к сети. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                          10054: raise EStorageException.Create('Соединение сброшено сервером. Попробуйте действие еще раз. context TStorage. ' + E.Message);
                          10060: raise EStorageException.Create('Нет доступа к серверу. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                          11001: raise EStorageException.Create('Нет доступа к серверу. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                          10065: raise EStorageException.Create('Нет соединения с интернетом. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                          10061: raise EStorageException.Create('Потеряно соединения с WEB сервером. Необходимо перезайти в программу после восстановления соединения.');
                        else
                          raise E;
                        end;
                     ctReport :
                        case E.LastError of
                          10051: raise EStorageException.Create('Отсутсвует подключение к сети. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                          10054: raise EStorageException.Create('Соединение сброшено сервером отчетов. Попробуйте действие еще раз. context TStorage. ' + E.Message);
                          10060: raise EStorageException.Create('Нет доступа к серверу отчетов. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                          11001: raise EStorageException.Create('Нет доступа к серверу отчетов. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                          10065: raise EStorageException.Create('Нет соединения с интернетом. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                          10061: raise EStorageException.Create('Потеряно соединения с WEB сервером отчетов. Необходимо перезайти в программу после восстановления соединения.');
                        else
                          raise E;
                        end;
                     ctReportLocal :
                        case E.LastError of
                          10051: raise EStorageException.Create('Отсутсвует подключение к сети. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                          10054: raise EStorageException.Create('Соединение сброшено локальным сервером отчетов. Попробуйте действие еще раз. context TStorage. ' + E.Message);
                          10060: raise EStorageException.Create('Нет доступа к локальному серверу отчетов. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                          11001: raise EStorageException.Create('Нет доступа к локальному серверу отчетов. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                          10065: raise EStorageException.Create('Нет соединения с интернетом. Обратитесь к системному администратору. context TStorage. ' + E.Message);
                          10061: raise EStorageException.Create('Потеряно соединения с локальному WEB серверу отчетов. Необходимо перезайти в программу после восстановления соединения.');
                        else
                          raise E;
                        end;
                  end;
                End;
              End
              else
              Begin
                if Midle then begin
                  Logger.AddToLog(' ... Sleep - 2 - idHTTP.Disconnect...');
                  idHTTP.Disconnect;
                end
                else
                  Logger.AddToLog(' ... Sleep - 1...');
                Sleep(1000);
              End;
            End;
            on E: Exception do
            Begin
              if LastAttempt then
              Begin
                raise Exception.Create('Ошибка соединения с Web сервером.'+#10+#13+'Обратитесь к разработчику.'+#10+#13+E.Message);
              End
              else
              Begin
                if Midle then begin
                  Logger.AddToLog(' ... Sleep - 2 - idHTTP.Disconnect...');
                  idHTTP.Disconnect;
                end
                else
                  Logger.AddToLog(' ... Sleep - 2...');
                Sleep(1000);
              End;
            End;
          end;
        End;
        if not Ok AND Not LastAttempt then
        Begin
          if FConnectionList.NextConnection(CType) <> nil then
            CString := FConnectionList.CurrentConnection[CType].CString;
          try
            idHTTP.Disconnect;
          except
          end;
        end
        else
          Break;
      until ok;
    finally
      if IdHTTPWork.FExecOnServer then
         IdHTTPWork.Gauge.Finish;
      IdHTTPWork.FExecOnServer := false;
    end;

    // Определяем тип возвращаемого результата
    if Ok then
    begin
      if dsdProject = prBoat then
      begin
        if isBinary then
          DString := FReceiveStream.DataString
        else
          DString := FReceiveStreamUTF8.DataString;
      end
      else
        DString := FReceiveStream.DataString;

      Logger.AddToLog(' TStorage.ExecuteProc( ... if Ok then Length = ' + IntToStr(Length(DString)) + ' ...');

      //Logger.AddToLog(' TStorage.ExecuteProc( ... if Ok then Length = ' + IntToStr(Length(DString)) + ' ...');

      //Logger.AddToLog('_DString_:');
      //Logger.AddToLog('');
      //Logger.AddToLog(DString);
      //Logger.AddToLog('');
      //Logger.AddToLog('_end_DString_:');

      ResultType := trim(Copy(DString, 1, ResultTypeLenght));
      isArchive := trim(lowercase(Copy(DString, ResultTypeLenght + 1, IsArchiveLenght))) = 't';
      Str := Copy(DString, ResultTypeLenght + IsArchiveLenght + 1, MaxInt);

      //Logger.AddToLog(' TStorage.ExecuteProc( ... if ResultType = gc' + ResultType + ' then ...');

      if ResultType = gcMultiDataSet then
      begin
        Result := ProcessMultiDataSet;
        Exit;
      end else if ResultType = gcError then
        ProcessErrorCode(PrepareStr, ConvertXMLParamToStrings(pData))
      else if (ResultType = gcResult) or (ResultType = gcDataSet) then
        Result := PrepareStr;

      //Logger.AddToLog('_Res_:');
      //Logger.AddToLog('');
      //Logger.AddToLog(Result);
      //Logger.AddToLog('');
      //Logger.AddToLog('_end_Res_:');

    end else
      //Logger.AddToLog(' TStorage.ExecuteProc( ... else ...')
      ;
  finally
    Logger.AddToLog(' TStorage.ExecuteProc( ... finally ...');
    Logger.AddToLog(' ');
    Logger.AddToLog(' ');
    Logger.AddToLog(' ');
    // Выход из критической секции
    FCriticalSection.Leave;
  end;
end;


class function TStorageFactory.GetStorage: IStorage;
begin
  Result := TStorage.NewInstance as TStorage;
end;

{ EStorageException }

constructor EStorageException.Create(AMessage: String; AErrorCode: String = '');
begin
  inherited Create(AMessage);
  ErrorCode := AErrorCode;
end;

{ TConnection }

constructor TConnection.Create(ACString: string; ACType: TConnectionType);
begin
  inherited Create;
  FCString := ACString;
  FCType := ACType;
end;

{ TConnectionList }

procedure TConnectionList.AddFromFile(AFileName: string; AConnectionType: TConnectionType);
var
  InitList: TStringList;
  StartPHP: Boolean;
  I: Integer;
  ConnectionString: string;
begin
  if FileExists(AFileName) then
  begin
    InitList := TStringList.Create;

    try
      InitList.LoadFromFile(AFileName);
      StartPHP := False;

      for I := 0 to InitList.Count - 1 do
      begin
        if not StartPHP and (Pos('<?php', InitList[I]) = 1) then
          StartPHP := True
        else
        if StartPHP and (Pos('?>', InitList[I]) = 1) then
          StartPHP := False
        else
        begin
          ConnectionString := '';

          if StartPHP and (Pos('$host', InitList[I]) > 0) then
            ConnectionString := Trim(AnsiDequotedStr(Trim(InitList.ValueFromIndex[I]), '"'))
          else
          if not StartPHP then
            ConnectionString := Trim(InitList[I]);

          if ConnectionString <> '' then
            Add(TConnection.Create(ConnectionString, AConnectionType));
        end;
      end;
    finally
      InitList.Free;
    end;
  end;
end;

procedure TConnectionList.AfterConstruction;
var
  I: TConnectionType;
begin
  inherited AfterConstruction;

  for I := Low(FCurrentConnection) to High(FCurrentConnection) do
    FCurrentConnection[I] := nil;
end;

function TConnectionList.GetConnection(Index: Integer): TConnection;
begin
  Result := inherited GetItem(Index) as TConnection;
end;

function TConnectionList.GetCurrentConnection(ACType: TConnectionType): TConnection;
begin
  Result := FCurrentConnection[ACType];

  if (Result <> nil) and (IndexOf(Result) = -1) then
    Result := FirstConnection(ACType);
end;

function TConnectionList.FirstConnection(ACType: TConnectionType): TConnection;
var
  I: Integer;
begin
  Result := nil;

  for I := 0 to Pred(Count) do
    if Items[I].CType = ACType then
    begin
      Result := Items[I];
      Break;
    end;

  FCurrentConnection[ACType] := Result;
end;

function TConnectionList.NextConnection(ACType: TConnectionType): TConnection;
var
  I: Integer;
begin
  Result := CurrentConnection[ACType];

  if Result <> nil then
  begin
    I := IndexOf(Result);
    Result := nil;

    repeat
      Inc(I);

      if (I < Count) and (Items[I].CType = ACType) then
      begin
        Result := Items[I];
        Break;
      end;
    until I >= Count;
  end;

  FCurrentConnection[ACType] := Result;
end;

procedure TConnectionList.SetConnection(Index: Integer; const Value: TConnection);
begin
  inherited SetItem(Index, Value);
end;

function GetStringStream(AValue: String): TStringStream;
begin
  if (dsdProject = prBoat) and SameText(Copy(AValue, 1, 19), '<?xml version="1.0"') then
    Result := TStringStream.Create(AValue, TEncoding.UTF8)
  else
    Result := TStringStream.Create(AValue);
end;

initialization
  IdHTTPWork := TIdHTTPWork.Create;

finalization
  IdHTTPWork.Free;

end.
