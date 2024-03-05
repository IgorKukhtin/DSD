unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.DateUtils,
  System.Variants, System.Classes, System.IOUtils, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, IdMessage,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, ShellAPI,
  IdExplicitTLSClientServerBase, IdMessageClient, IdPOP3, IdAttachment, dsdDB,
  Data.DB, Datasnap.DBClient, Vcl.Samples.Gauges, Vcl.ExtCtrls, Vcl.ActnList,
  dsdAction, ExternalLoad, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL, IdIMAP4, dsdInternetAction, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection, System.Actions,
  sevenzip, FormStorage, UnilWin, IniFiles;

const SAVE_LOG = true;

type
  TPanel = class(Vcl.ExtCtrls.TPanel)
  private
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  end;

type

  // элемент "почтовый ящик"
  TMailItem = record
    EmailKindDesc : string;
    Host          : string;
    Port          : Integer;
    Mail          : string;
    UserName      : string;
    Password      : string;
    Directory     : string;    // путь, по которому сохраняются вложенные файлики из писем, и если необходимо - там же разархивируются
    BeginTime     : TDateTime; // Время последней проверки
    onTime        : Integer;   // с какой периодичностью проверять почту в активном периоде, мин
  end;

  TArrayMail = array of TMailItem;

  TMainForm = class(TForm)
    IdMessage: TIdMessage;
    BtnStart: TBitBtn;
    spSelect: TdsdStoredProc;
    ClientDataSet: TClientDataSet;
    PanelHost: TPanel;
    GaugeHost: TGauge;
    PanelMailFrom: TPanel;
    PanelParts: TPanel;
    GaugeMailFrom: TGauge;
    GaugeParts: TGauge;
    GaugeLoadFile: TGauge;
    PanelLoadFile: TPanel;
    Timer: TTimer;
    cbTimer: TCheckBox;
    IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    PanelError: TPanel;
    spInsertUpdate_Invoice: TdsdStoredProc;
    PanelInfo: TPanel;
    spInsertUpdate_InvoicePdf: TdsdStoredProc;
    BtnLoadUnscheduled: TBitBtn;
    procedure BtnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure cbTimerClick(Sender: TObject);
    procedure BtnLoadUnscheduledClick(Sender: TObject);
  private
    vbEmailKindDesc :String;// Важный параметр - Определяет "Загрузка Прайса" ИЛИ "Загрузка ММО"

    vbIsBegin :Boolean;// запущена обработка
    vbOnTimer :TDateTime;// время когда сработал таймер

    vbArrayMail :TArrayMail; // массив почтовых ящиков
    FLoadUnscheduled: Boolean;// отправить внепланово

    function GetArrayList_Index_byUserName (ArrayList : TArrayMail; UserName, EmailKindDesc : String):Integer;//находит Индекс в массиве по значению Host

    function fBeginAll  : Boolean; // обработка все
    function fInitArray : Boolean; // получает данные с сервера и на основании этих данных заполняет массив
    function fBeginMail : Boolean; // обработка всей почты
  public
  end;

var
  MainForm: TMainForm;

implementation
uses Authentication, Storage, CommonData, UtilConst, StrUtils;
{$R *.dfm}

procedure AddToLog(ALogMessage: string);
var F: TextFile;
begin
  if not SAVE_LOG then Exit;

  //
  if (Pos('Error', ALogMessage) = 0) and (Pos('Exception', ALogMessage) = 0) and (Pos('---- Start', ALogMessage) = 0)
  then Exit;
  //
  AssignFile(F, ChangeFileExt(Application.ExeName,'.log'));
  if FileExists(ChangeFileExt(Application.ExeName,'.log')) then
    Append(F)
  else
    Rewrite(F);
  //
  if (ALogMessage = '---- Start')
  then WriteLn(F, '');
  WriteLn(F, DateTimeToStr(Now) + ' : ' + ALogMessage);
  if (ALogMessage = '---- Start')
  then WriteLn(F, '');
  CloseFile(F);
end;

function PADR(Src: string; Lg: Integer): string;
begin
  Result := Src;
  while Length(Result) < Lg do
    Result := Result + ' ';
end;

//Удаление директорий с содержимым
function DelDir(Const dir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc  := FO_DELETE;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    pFrom  := PChar(dir + #0);
  end;
  Result := (0 = ShFileOperation(fos));
end;

//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
  cUserName, cUserPassword: String;
begin

  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + TPath.GetFileNameWithoutExtension(Application.ExeName) + '.ini');

  try

    cUserName := Ini.ReadString('Connect', 'UserName', 'Админ');
    Ini.WriteString('Connect', 'UserName', cUserName);

    cUserPassword := Ini.ReadString('Connect', 'UserPassword', 'Админ');
    Ini.WriteString('Connect', 'UserPassword', cUserPassword);

  finally
    Ini.free;
  end;

  FLoadUnscheduled := False;

  // ЗАХАРДКОДИЛ - Важный параметр - Определяет "Загрузка Счетов"
  vbEmailKindDesc:= 'zc_Enum_EmailKind_Mail_InvoiceKredit';
  Self.Caption:= Self.Caption + ' - Только Счета';

  //создает сессию и коннект
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, cUserName, cUserPassword, gc_User);
  // запущена обработка
  vbIsBegin:= false;
  //
  GaugeHost.Progress:=0;
  GaugeMailFrom.Progress:=0;
  GaugeParts.Progress:=0;
  GaugeLoadFile.Progress:=0;
  //
  AddToLog('---- Start');
  // включаем таймер
  Timer.Interval:=3000;
  cbTimer.Caption:= 'Timer ON ' + FloatToStr(Timer.Interval / 1000) + ' sec';
  cbTimer.Checked:=false;
  cbTimer.Checked:=true;
  //Timer.Enabled:=true;
  Sleep(50);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbTimerClick(Sender: TObject);
begin
     Timer.Enabled:=cbTimer.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//находит Индекс в массиве по значению UserName
function TMainForm.GetArrayList_Index_byUserName (ArrayList : TArrayMail; UserName, EmailKindDesc : String):Integer;
var i: Integer;
begin
     //находит Индекс в массиве по значению Host
    Result:=-1;
    for i := 0 to Length(ArrayList)-1 do
      if (ArrayList[i].UserName = UserName) and (ArrayList[i].EmailKindDesc = EmailKindDesc) then
    begin
      Result:=i;
      break;
    end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// получает данные с сервера и на основании этих данных заполняет массивы
function TMainForm.fInitArray : Boolean;
var i,nn:Integer;
begin
     Result := True;
     if vbIsBegin = true then exit;
     // запущена обработка
     vbIsBegin:= true;

     try
       //
       with spSelect do
       begin
         StoredProcName:='gpSelect_Object_ImportSettings_Email';
         Params.Clear;
         // Важный параметр - Определяет "Загрузка счетов"
         Params.AddParam('inEmailKindDesc',ftString,ptInput,vbEmailKindDesc);

         OutputType:=otDataSet;
         Execute;// получили всех ящики, по которым надо загружать Email
         //
         //первый цикл
         DataSet.First;
         i:=0;
         while not DataSet.EOF do
         begin
            nn:= GetArrayList_Index_byUserName(vbArrayMail, DataSet.FieldByName('UserName').asString, DataSet.FieldByName('zc_Enum_EmailKind_Mail').AsString);
            if nn = -1 then
            begin
                  SetLength(vbArrayMail, I + 1);//длина масива
                  //сохранили новый Host + UserName
                  vbArrayMail[i].EmailKindDesc:=DataSet.FieldByName('zc_Enum_EmailKind_Mail').asString;
                  vbArrayMail[i].Host:=DataSet.FieldByName('Host').asString;
                  vbArrayMail[i].Port:=DataSet.FieldByName('Port').asInteger;
                  vbArrayMail[i].Mail:=DataSet.FieldByName('Mail').asString;
                  vbArrayMail[i].UserName:=DataSet.FieldByName('UserName').asString;
                  vbArrayMail[i].Password:=DataSet.FieldByName('Password').asString;
                  // путь, по которому сохраняются вложенные файлики из писем, и если необходимо - там же разархивируются
                  vbArrayMail[i].Directory:=ExpandFileName(DataSet.FieldByName('DirectoryMail').asString);
                  // с какой периодичностью проверять почту в активном периоде, мин
                  vbArrayMail[i].onTime:=DataSet.FieldByName('onTime').asInteger;
                  // Время последней проверки - инициализируем значением "много дней назад"
                  vbArrayMail[i].BeginTime:=NOW-1000;
                  //
                  i:=i+1;
            end;

            // !!!в таймере!!! обновили новый минимум -  с какой периодичностью проверять почту в активном периоде
            if (Timer.Interval > Cardinal(DataSet.FieldByName('onTime').asInteger * 60 * 1000)) or (Timer.Interval <= 1000) then
            begin
                 Timer.Interval:= DataSet.FieldByName('onTime').asInteger * 60 * 1000;
                 cbTimer.Caption:= 'Timer ON ' + FloatToStr(Timer.Interval / 1000) + ' sec ' + '('+FormatDateTime('dd.mm.yyyy hh:mm:ss',vbOnTimer)+')';
            end;
            //перешли к следующему
            DataSet.Next;
         end;
       end;
       //
     finally
       // завершена обработка
       vbIsBegin:= false;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// что б отловить ошибки - запишим в лог строчку
procedure Add_Log_XML(APath, AMessage: String);
var F: TextFile;
begin
  try
    AssignFile(F,APath+'\'+ChangeFileExt(ExtractFileName (Application.ExeName),'_err.txt'));
    if not fileExists(APath+'\'+ChangeFileExt(ExtractFileName (Application.ExeName),'_err.txt')) then
    begin
      Rewrite(F);
    end
    else
      Append(F);
    //
    try  Writeln(F,AMessage);
    finally CloseFile(F);
    end;
  except
  end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// обработка всей почты
function TMainForm.fBeginMail : Boolean;
var
  msgs: integer;
  ii, i, j, l: integer;
  flag: boolean;
  msgcnt: integer;
  Session,mailFolderMain,mailFolder,StrCopyFolder: string;
  StartTime:TDateTime;
  IdIMAP4:TIdIMAP4;
  searchResult : TSearchRec;
  msgDate_save:TDateTime;
  FileList: TStringList;
begin
   //
   if vbIsBegin = true then exit;
   // запущена обработка
   vbIsBegin:= true;
   // если НЕ было загрузка прайса - НЕ надо потом запускать оптимизацию
   try

     //сессия - в эту папку будем сохранять файлики - она определяется временем запуска обработки
     StartTime:=NOW;
     Session:=FormatDateTime('yyyy-mm-dd hh-mm-ss',StartTime);
     //
     GaugeHost.Progress:=0;
     GaugeHost.MaxValue:=Length(vbArrayMail);
     Application.ProcessMessages;
     //цикл по почтовым ящикам
     for ii := 0 to Length(vbArrayMail)-1 do
     begin
       // если после предыдущей обработки прошло > onTime МИНУТ
       if FLoadUnscheduled or ((NOW - vbArrayMail[ii].BeginTime) * 24 * 60 > vbArrayMail[ii].onTime)
       then try
           PanelHost.Caption:= 'Start Mail (0.1) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
           PanelHost.Invalidate;
           IdIMAP4:=TIdIMAP4.Create(Self);
           PanelHost.Caption:= 'Start Mail (0.2) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
           PanelHost.Invalidate;
           IdIMAP4.IOHandler:=IdSSLIOHandlerSocketOpenSSL;
           PanelHost.Caption:= 'Start Mail (0.3) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
           PanelHost.Invalidate;

           IdIMAP4.UseTLS:=utUseImplicitTLS;

           PanelHost.Caption:= 'Start Mail (0.4) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
           PanelHost.Invalidate;
           IdIMAP4.AuthType:=iatUserPass;
           PanelHost.Caption:= 'Start Mail (0.5) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
           PanelHost.Invalidate;
           IdIMAP4.MilliSecsToWaitToClearBuffer:=100;

           with IdIMAP4 do
           begin
              //
              PanelHost.Caption:= 'Start Mail (1.1) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
              PanelHost.Invalidate;
              Sleep(200);
              //current directory to store the email
              mailFolderMain:= vbArrayMail[ii].Directory + '\' + ReplaceStr(vbArrayMail[ii].UserName, '@', '_') + '_' + Session;
              //создали папку для писем если таковой нет + это протокол что по данному ящику была обработка
              ForceDirectories(mailFolderMain);

              PanelHost.Caption:= 'Start Mail (1.2) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
              PanelHost.Invalidate;
              //параметры подключения к ящику
              Host    := vbArrayMail[ii].Host;
              UserName:= vbArrayMail[ii].UserName;
              Password:= vbArrayMail[ii].Password;
              Port    := vbArrayMail[ii].Port;

              try
                 PanelHost.Caption:= 'Start Mail (2) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                 PanelHost.Invalidate;

                 AddToLog('------------');
                 AddToLog('Подключение к ящику: ' + vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host);

                 //подключаемся к ящику
                 try IdIMAP4.Connect(TRUE);     //IMAP
                 except
                      on E: Exception do begin
                         PanelError.Caption:= ' ERROR - IdIMAP4.Connect(TRUE) for ' + UserName + '  : ' + E.Message;
                         PanelError.Invalidate;
                         Continue;
                      end;
                 end;

                 PanelHost.Caption:= 'Start Mail (3.1) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                 PanelHost.Invalidate;
                 IdIMAP4.SelectMailBox('INBOX');//only IMAP
                 PanelHost.Caption:= 'Start Mail (3.2) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                 PanelHost.Invalidate;
                 //количество писем
                 //***msgcnt:= IdPOP3.CheckMessages;   //POP3
                 msgcnt:= IdIMAP4.MailBox.TotalMsgs;   //IMAP
                 PanelHost.Caption:= 'Start Mail (3.4) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                 PanelHost.Invalidate;
                 //
                 GaugeMailFrom.Progress:=0;
                 GaugeMailFrom.MaxValue:=msgcnt;
                 Application.ProcessMessages;
                 //цикл по входящим письмам
                 AddToLog('    цикл по входящим письмам: ' + IntToStr(msgcnt));
                 for I:= msgcnt downto 1 do
                 begin
                   PanelHost.Caption:= 'Start Mail (4) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                   PanelHost.Invalidate;
                   AddToLog('       - : ' + IntToStr(I));
                   IdMessage.Clear; // очистка буфера для сообщения
                   flag:= false;

                   PanelHost.Caption:= 'Start Mail (5.1.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                   PanelHost.Invalidate;
                   try
                     //если вытянулось из почты письмо
                     if (IdIMAP4.Retrieve(i, IdMessage)) then
                     begin
                         PanelHost.Caption:= 'Start Mail (5.2.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                         PanelHost.Invalidate;
                         //IdMessage.CharSet := 'UTF-8';

                         PanelMailFrom.Caption:= 'Mail From : '+FormatDateTime('dd.mm.yyyy hh:mm:ss',IdMessage.Date) + ' ' + Trim(IdMessage.From.Address);
                         PanelMailFrom.Invalidate;

                         //current directory to store the email files
                         mailFolder:= mailFolderMain + '\' + FormatDateTime('yyyy-mm-dd hh-mm-ss',IdMessage.Date);
                         //создали папку для писем если таковой нет
                         ForceDirectories(mailFolder);

                         //
                         GaugeParts.Progress:=0;
                         GaugeParts.MaxValue:=IdMessage.MessageParts.Count;
                         Application.ProcessMessages;
                         PanelHost.Caption:= 'Start Mail (5.3.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                         PanelHost.Invalidate;

                         //  Если загрузка счетов
                         if vbArrayMail[ii].EmailKindDesc = 'zc_Enum_EmailKind_Mail_InvoiceKredit' then
                         begin

                           //пройдемся по всем частям письма
                           for j := 0 to IdMessage.MessageParts.Count - 1 do
                           begin
                             //
                             PanelParts.Caption:= 'Parts : '+Trim(IdMessage.From.Address);
                             Application.ProcessMessages;
                             //если это вложенный файлик
                             if IdMessage.MessageParts[j] is TIdAttachment then
                             begin
                               // сохранили файлик из письма
                               (IdMessage.MessageParts[j] as TIdAttachment).SaveToFile(mailFolder + '\' + IdMessage.MessageParts[J].FileName);
                               // если надо - разархивировали
                               if (System.Pos(AnsiUppercase('.zip'), AnsiUppercase(IdMessage.MessageParts[J].FileName)) > 0) then
                               begin
                                 try
                                   with CreateInArchive(CLSID_CFormatZip) do
                                   begin
                                     OpenFile(mailFolder + '\' + IdMessage.MessageParts[J].FileName);
                                     ExtractTo(mailFolder + '\');
                                     Close;
                                   end;
                                   DeleteFile(mailFolder + '\' + IdMessage.MessageParts[J].FileName);
                                 except
                                 end;
                               end else if (System.Pos(AnsiUppercase('.rar'), AnsiUppercase(IdMessage.MessageParts[J].FileName)) > 0) then
                               begin
                                 try
                                   with CreateInArchive(CLSID_CFormatRar) do
                                   begin
                                     OpenFile(mailFolder + '\' + IdMessage.MessageParts[J].FileName);
                                     ExtractTo(mailFolder + '\');
                                     Close;
                                   end;
                                   DeleteFile(mailFolder + '\' + IdMessage.MessageParts[J].FileName);
                                 except
                                 end;
                               end else if (System.Pos(AnsiUppercase('.7z'), AnsiUppercase(IdMessage.MessageParts[J].FileName)) > 0) then
                               begin
                                 try
                                   with CreateInArchive(CLSID_CFormat7z) do
                                   begin
                                     OpenFile(mailFolder + '\' + IdMessage.MessageParts[J].FileName);
                                     ExtractTo(mailFolder + '\');
                                     Close;
                                   end;
                                   DeleteFile(mailFolder + '\' + IdMessage.MessageParts[J].FileName);
                                 except
                                 end;
                               end;
                             end;
                             GaugeParts.Progress:=GaugeParts.Progress+1;
                             Application.ProcessMessages;
                           end;//завершилась обработка всех частей одного письма

                           //2.1. Создаем счет на сервере
                           spInsertUpdate_Invoice.ParamByName('ioId').Value := 0;
                           spInsertUpdate_Invoice.ParamByName('inSubject').Value := IdMessage.Subject;
                           spInsertUpdate_Invoice.Execute;

                           //удалить письмо в почте
                           flag := True;

                           //2.1. Прикрепляем файлы к счету
                           if (System.SysUtils.FindFirst(mailFolder + '\*.*', faArchive, searchResult) = 0) then
                           begin
                              FileList := TStringList.Create;
                              try
                                repeat
                                  //
                                  if (searchResult.Attr and faArchive) = searchResult.Attr then
                                  begin
                                    AddToLog('Найден файл: ' + searchResult.Name);
                                    PanelLoadFile.Caption:= 'Add File: '+Trim(searchResult.Name);
                                    FileList.Add(searchResult.Name);
                                  end;
                                until System.SysUtils.FindNext(searchResult) <> 0;
                                System.SysUtils.FindClose(searchResult);

                                GaugeLoadFile.Progress:=0;
                                GaugeLoadFile.MaxValue:=FileList.Count;
                                for l := 0 to FileList.Count - 1 do
                                begin
                                  AddToLog('Добавим файл к счету: ' + FileList.Strings[l]);
                                  PanelLoadFile.Caption:= 'Add File: Добавим файл '+ Trim(FileList.Strings[l]) + ' к счету';

                                  spInsertUpdate_InvoicePdf.ParamByName('ioId').Value := 0;
                                  spInsertUpdate_InvoicePdf.ParamByName('inPhotoName').Value := FileList.Strings[l];
                                  spInsertUpdate_InvoicePdf.ParamByName('inMovmentId').Value := spInsertUpdate_Invoice.ParamByName('ioId').Value;
                                  spInsertUpdate_InvoicePdf.ParamByName('inInvoicePdfData').Value := ConvertConvert(PADR(FileList.Strings[l], 255) + String(FileReadString(mailFolder + '\' + FileList.Strings[l])));
                                  spInsertUpdate_InvoicePdf.Execute;
                                  GaugeLoadFile.Progress:=GaugeLoadFile.Progress + 1;
                                end;
                              finally
                                FileList.Free;
                              end;
                           end;
                       end
                       // если не нашли - все равно удалить письмо в почте
                       else flag:= true;

                       //удаление письма
                       //***if flag then IdPOP3.Delete(i);   //POP3
                       PanelHost.Caption:= 'Start Mail (5.4.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                       PanelHost.Invalidate;
                       if flag then
                       begin
                         IdIMAP4.DeleteMsgs([i]);    //IMAP
                         IdIMAP4.ExpungeMailBox;
                       end;
                       PanelHost.Caption:= 'Start Mail (5.5.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                       PanelHost.Invalidate;
                       //
                       // Почистим папку письма
                       DelDir(mailFolder);
                     end;

                   except  on E: Exception do
                     // Ошибка загузки письма
                     begin
                       AddToLog('Error - обработки письма:'#13#10 + E.Message);
                       // Почистим папку письма
                       DelDir(mailFolder);
                     end;
                   end;

                   //все, идем дальше
                   Sleep(200);
                   GaugeMailFrom.Progress:=GaugeMailFrom.Progress+1;
                   Application.ProcessMessages;

                 end;//финиш - цикл по входящим письмам

                 PanelHost.Caption:= 'End Mail (5.6) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
                 PanelHost.Invalidate;

                 //осталось сохранить время последней обработки почтового ящика
                 vbArrayMail[ii].BeginTime:=vbOnTimer;
                 // Почистим папку загрузки
                 DelDir(mailFolderMain);
                 //
                 PanelHost.Caption:= 'End Mail (5.7): '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
                 PanelHost.Invalidate;
                 GaugeHost.Progress:=GaugeHost.Progress + 1;
                 Application.ProcessMessages;
              finally
                 PanelHost.Caption:= 'End Mail (6.1.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
                 PanelHost.Invalidate;
                 //***IdPOP3.Disconnect;     // POP3
                 IdIMAP4.Disconnect();       //IMAP
                 PanelHost.Caption:= 'End Mail (6.2.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
                 PanelHost.Invalidate;
                 IdIMAP4.Free;               //IMAP
                 PanelHost.Caption:= 'End Mail (6.3) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
                 PanelHost.Invalidate;
              end;

              AddToLog('    конец обработки ящика.');

              PanelHost.Caption:= 'OK - End Mail (7.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
              PanelHost.Invalidate;
              Application.ProcessMessages;
              Sleep(200);

           end;// with IdIMAP4 do
       except
           PanelHost.Caption:= 'ERROR - TIdIMAP4 - try on Next Step - End Mail (8.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
           PanelHost.Invalidate;

           //current directory to store the email
           mailFolderMain:= vbArrayMail[ii].Directory + '\' + ReplaceStr(vbArrayMail[ii].UserName, '@', '_') + '_' + Session;
           //создали папку для ПРОТОКОЛА если таковой нет + это протокол что по данному ящику была обработка
           ForceDirectories(mailFolderMain);
           //сохранили - что была ОШИБКА
           Add_Log_XML(mailFolderMain, PanelHost.Caption);

           Application.ProcessMessages;
           Sleep(1000);
       end;//финиш - цикл по почтовым ящикам
    end;
  finally
   // завершена обработка
   vbIsBegin:= false;
  end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// обработка все
function TMainForm.fBeginAll : Boolean;
var isErr, isErr_exit : Boolean;
begin
     Result := True;
     PanelError.Caption:= '';
     PanelError.Invalidate;
     PanelInfo.Caption:= 'Начало цикла обработки.';
     PanelInfo.Invalidate;
     isErr:= false;
     isErr_exit:= false;
     Timer.Enabled:= false;
     BtnStart.Enabled:= false;

     try

       //инициализируем данные по всем ящикам
       try fInitArray;
       except
         PanelHost.Caption:= '!!! ERROR - fInitArray - exit !!!';
         PanelHost.Invalidate;
         isErr_exit:= true;
         exit;
       end;

       // обработка всей почты
       PanelInfo.Caption:= 'Обработка всей почты.';
       PanelInfo.Invalidate;
       try
        isErr:= true;
        fBeginMail;
        isErr:= false;
       except on E: Exception do
        begin
          vbIsBegin:= false;
          PanelHost.Caption:= '!!! ERROR - fBeginMail: ' + E.Message;
          PanelHost.Invalidate;
        end;
       end;

     finally
       Timer.Enabled:= true;
       BtnStart.Enabled:= vbIsBegin = false;
       PanelInfo.Caption:= 'Цикл завершен.';
       PanelInfo.Invalidate;
       FLoadUnscheduled:= false;
       //
       if isErr_exit= false
       then
       begin
           if isErr = true
           then PanelHost.Caption:= 'End !!!ERROR!!! - fBeginMail ... and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',now + Timer.Interval / 1000 / 60 /  24 / 60 )
           else PanelHost.Caption:= 'End OK all ... and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',now + Timer.Interval / 1000 / 60 / 24 / 60 );
           PanelHost.Invalidate;
       end;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.BtnLoadUnscheduledClick(Sender: TObject);
begin
  Timer.Enabled := False;
  try
    if MessageDlg('Производить внеплановую звгрузку?', mtConfirmation,
      [mbYes, mbCancel], 0) = mrYes then
    begin
      vbOnTimer:= NOW;
      Timer.Interval := 60;
      FLoadUnscheduled := True;
    end else Timer.Interval := 1000 * 10;

  finally
    cbTimer.Caption:= 'Timer ON ' + FloatToStr(Timer.Interval / 1000) + ' seccc ' + '('+FormatDateTime('dd.mm.yyyy hh:mm:ss',vbOnTimer)+')';
    Timer.Enabled := True;
  end;
end;

procedure TMainForm.BtnStartClick(Sender: TObject);
begin
     // типа, время когда сработал таймера
     vbOnTimer:= NOW;
     // обработка все
     fBeginAll;
     //
     ShowMessage('Finish');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.TimerTimer(Sender: TObject);
begin
  try
     // время когда сработал таймера
     vbOnTimer:= NOW;
     Timer.Interval := 10000;
     cbTimer.Caption:= 'Timer ON ' + FloatToStr(Timer.Interval / 1000) + ' seccc ' + '('+FormatDateTime('dd.mm.yyyy hh:mm:ss',vbOnTimer)+')';
     Sleep(500);
     // обработка все
     fBeginAll;
  finally

  end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
{ TPanel }

procedure TPanel.CMTextChanged(var Message: TMessage);
begin
  if (Caption <> '') and (Name = 'PanelError') then
    AddToLog(ReplaceStr(Name, 'Panel', '') + ' - ' + Caption);
end;

end.
