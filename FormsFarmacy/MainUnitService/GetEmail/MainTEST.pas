unit MainTEST;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.DateUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, IdMessage,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdPOP3, IdAttachment, dsdDB,
  Data.DB, Datasnap.DBClient, Vcl.Samples.Gauges, Vcl.ExtCtrls, Vcl.ActnList,
  dsdAction, ExternalLoad, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL, IdIMAP4, dsdInternetAction;

type
  // элемент "почтовый ящик"
  TMailItem = record
    Host          : string;
    Port          : Integer;
    Mail          : string;
    UserName      : string;
    PasswordValue : string;
    Directory     : string;    // путь, по которому сохраняются вложенные файлики из писем, и если необходимо - там же разархивируются
    BeginTime     : TDateTime; // Время последней проверки
    onTime        : Integer;   // с какой периодичностью проверять почту в активном периоде, мин
  end;
  TArrayMail = array of TMailItem;
  // элемент "поставщик и параметры загрузки информации"
  TImportSettingsItem = record
    UserName      : string;
    Id            : Integer;
    Code          : Integer;
    Name          : string;
    JuridicalId   : Integer;
    JuridicalCode : Integer;
    JuridicalName : string;
    JuridicalMail : string;
    ContactPersonId   : Integer;
    ContactPersonName : string;
    ContractId    : Integer;
    ContractName  : string;
    Directory     : string;    // путь, в который должны попасть xls файлы перед загрузкой в программу
    StartTime     : TDateTime; // Время начала активной проверки
    EndTime       : TDateTime; // Время окончания активной проверки
    isMultiLoad   : Boolean;   // Много раз загружать прайс

    zc_Enum_EmailKind_InPrice    : integer;
    zc_Enum_EmailKind_IncomeMMO  : integer;
    EmailKindId                  : integer;
    EmailKindname                : string;
  end;
  TArrayImportSettings = array of TImportSettingsItem;

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
    GaugeLoadXLS: TGauge;
    GaugeMove: TGauge;
    ActionList: TActionList;
    actExecuteImportSettings: TExecuteImportSettingsAction;
    PanelLoadXLS: TPanel;
    MasterCDS: TClientDataSet;
    spSelectMove: TdsdStoredProc;
    PanelMove: TPanel;
    spUpdateGoods: TdsdStoredProc;
    spLoadPriceList: TdsdStoredProc;
    actMovePriceList: TdsdExecStoredProc;
    Timer: TTimer;
    cbTimer: TCheckBox;
    IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    cbBeginMove: TCheckBox;
    spGet_LoadPriceList: TdsdStoredProc;
    spUpdate_Protocol_LoadPriceList: TdsdStoredProc;
    actProtocol: TdsdExecStoredProc;
    mactExecuteImportSettings: TMultiAction;
    PanelError: TPanel;
    actSendEmail: TdsdSMTPFileAction;
    spExportSettings_Email: TdsdStoredProc;
    ExportSettingsCDS: TClientDataSet;
    spRefreshMovementItemLastPriceList_View: TdsdStoredProc;
    actRefreshMovementItemLastPriceList_View: TdsdExecStoredProc;
    procedure BtnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure cbTimerClick(Sender: TObject);
  private
    vbEmailKindDesc :String;// Важный параметр - Определяет "Загрузка Прайса" ИЛИ "Загрузка ММО"

    vbIsBegin :Boolean;// запущена обработка
    vbOnTimer :TDateTime;// время когда сработал таймер
    fIsOptimizeLastPriceList_View :Boolean;// если была загрузка прайса - надо потом запустить оптимизацию

    vbArrayMail :TArrayMail; // массив почтовых ящиков
    vbArrayImportSettings :TArrayImportSettings; // массив поставщиков и параметров загрузки информации

    function GetArrayList_Index_byUserName(ArrayList:TArrayMail;UserName:String):Integer;//находит Индекс в массиве по значению Host
    function GetArrayList_Index_byJuridicalMail(ArrayList:TArrayImportSettings;UserName,JuridicalMail:String):Integer;//находит Индекс в массиве по значению Host + MailJuridical

    function fGet_LoadPriceList (inJuridicalId, inContractId :Integer) : Integer;

    function fError_SendEmail (inImportSettingsId, inContactPersonId:Integer; inByDate :TDateTime; inByMail, inByFileName : String) : Boolean;

    function fBeginAll  : Boolean; // обработка все
    function fInitArray : Boolean; // получает данные с сервера и на основании этих данных заполняет массивы
    function fBeginMail : Boolean; // обработка всей почты
  public
  end;

var
  MainForm: TMainForm;

implementation
uses Authentication, Storage, CommonData, UtilConst, sevenzip, StrUtils;
{$R *.dfm}
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
begin
  // ЗАХАРДКОДИЛ - Важный параметр - Определяет "Загрузка Прайса" ИЛИ "Загрузка ММО"
  if (Pos ('GetEmail.exe', Application.ExeName) > 0) or (Pos ('GetEmailTEST.exe', Application.ExeName) > 0)
  then begin vbEmailKindDesc:= 'zc_Enum_EmailKind_InPrice';   Self.Caption:= Self.Caption + ' - Только Прайсы'; end
  else begin vbEmailKindDesc:= 'zc_Enum_EmailKind_IncomeMMO'; Self.Caption:= Self.Caption + ' - Только ММО';    end;

  //создает сессию и коннект
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Авто-загрузка прайс-поставщик', gc_AdminPassword, gc_User);
  // запущена обработка
  vbIsBegin:= false;
  // переносить прайс в актуальные цены (а загрузка выполняется всегда)
  cbBeginMove.Checked:=false;
  // включаем таймер
  cbTimer.Checked:=true;
  Timer.Enabled:=cbTimer.Checked;
  Timer.Interval:=100;
  cbTimer.Caption:= 'Timer ON ' + FloatToStr(Timer.Interval / 1000) + ' sec';
  Sleep(5000);
  //
  GaugeHost.Progress:=0;
  GaugeMailFrom.Progress:=0;
  GaugeParts.Progress:=0;
  GaugeLoadXLS.Progress:=0;
  GaugeMove.Progress:=0;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.cbTimerClick(Sender: TObject);
begin
     Timer.Enabled:=cbTimer.Checked;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
//находит Индекс в массиве по значению UserName
function TMainForm.GetArrayList_Index_byUserName(ArrayList:TArrayMail;UserName:String):Integer;
var i: Integer;
begin
     //находит Индекс в массиве по значению Host
    Result:=-1;
    for i := 0 to Length(ArrayList)-1 do
      if (ArrayList[i].UserName = UserName) then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------}
//находит Индекс в массиве по значению UserName + MailJuridical + время
function TMainForm.GetArrayList_Index_byJuridicalMail(ArrayList:TArrayImportSettings;UserName,JuridicalMail:String):Integer;
var i: Integer;
    Year, Month, Day: Word;
    Second, MSec: word;
    Hour_calc, Minute_calc: word;
    StartTime_calc,EndTime_calc:TDateTime;
begin
     //находит Индекс в массиве по значению UserName + JuridicalMail
    Result:=-1;
    for i := 0 to Length(ArrayList)-1 do
      if (ArrayList[i].UserName = UserName) and (System.Pos(AnsiUpperCase(JuridicalMail), AnsiUpperCase(ArrayList[i].JuridicalMail)) > 0)
      then begin Result:=i;break;end;
    //
    // проверка - текущее время
    if Result >=0 then
    begin
         //текущая дата
         DecodeDate(NOW, Year, Month, Day);
         //расчет начальные дата + время
         DecodeTime(ArrayList[i].StartTime, Hour_calc, Minute_calc, Second, MSec);
         StartTime_calc:= EncodeDateTime(Year, Month, Day, Hour_calc, Minute_calc, 0, 0);
         //расчет конечные дата + время
         DecodeTime(ArrayList[i].EndTime, Hour_calc, Minute_calc, Second, MSec);
         EndTime_calc:= EncodeDateTime(Year, Month, Day, Hour_calc, Minute_calc, 0, 0);
         //теперь можно проверить
         if not ((StartTime_calc <= NOW) and (EndTime_calc >= NOW))
         then Result:= -1;
    end;
end;
{------------------------------------------------------------------------}
//отправка сообщения если возникла ошибка
function TMainForm.fError_SendEmail (inImportSettingsId, inContactPersonId:Integer; inByDate :TDateTime; inByMail, inByFileName : String) : Boolean;
begin
     if (inByFileName = '0') or (inByFileName = '4')
     then if IdMessage.MessageParts.Count > 0
          then PanelError.Caption:= '+Error : ' + PanelParts.Caption
          else PanelError.Caption:= '+Error : ' + PanelMailFrom.Caption
     else PanelError.Caption:= '+Error : ' + PanelLoadXLS.Caption;
     Application.ProcessMessages;
     //
     with spExportSettings_Email do
     begin
       ParamByName('inObjectId').Value         :=inImportSettingsId;
       ParamByName('inContactPersonId').Value  :=inContactPersonId;
       ParamByName('inByDate').Value    :=inByDate;
       ParamByName('inByMail').Value    :=inByMail;
       ParamByName('inByFileName').Value:=inByFileName;
       //получили кому надо отправить Email об ошибке
       Execute;
       DataSet.First;
       while not DataSet.EOF do begin
          {FormParams.ParamByName('Host').Value       :=DataSet.FieldByName('Host').AsString;
          FormParams.ParamByName('Port').Value       :=DataSet.FieldByName('Port').AsInteger;
          FormParams.ParamByName('UserName').Value   :=DataSet.FieldByName('UserName').AsString;
          FormParams.ParamByName('Password').Value   :=DataSet.FieldByName('PasswordValue').AsString;
          FormParams.ParamByName('AddressFrom').Value:=DataSet.FieldByName('MailFrom').AsString;
          FormParams.ParamByName('AddressTo').Value  :=DataSet.FieldByName('MailTo').AsString;
          FormParams.ParamByName('Subject').Value    :=DataSet.FieldByName('Subject').AsString;
          FormParams.ParamByName('Body').Value       :=DataSet.FieldByName('Body').AsString;}
          //
          actSendEmail.Execute;
          //перешли к следующему
          DataSet.Next;
       end;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// получает данные с сервера и на основании этих данных заполняет массивы
function TMainForm.fInitArray : Boolean;
var i,nn:Integer;
    UserNameStringList:TStringList;
begin
     if vbIsBegin = true then exit;
     // !!!отключили таймер!!!
     Timer.Enabled:=false;
     Timer.Interval:=1000;
     // запущена обработка
     vbIsBegin:= true;

     UserNameStringList:=TStringList.Create;
     UserNameStringList.Sorted:=true;
     //
     with spSelect do
     begin
       StoredProcName:='gpSelect_Object_ImportSettings_Email';
       Params.Clear;
       // Важный параметр - Определяет "Загрузка Прайса" ИЛИ "Загрузка ММО"
       Params.AddParam('inEmailKindDesc',ftString,ptInput,vbEmailKindDesc);

       OutputType:=otDataSet;
       Execute;// получили всех поставщиков, по которым надо загружать Email
       //
       //первый цикл
       DataSet.First;
       i:=0;
       SetLength(vbArrayImportSettings,DataSet.RecordCount);//длина масива соответствует кол-ву поставщиков
       while not DataSet.EOF do begin
          //заполнили каждого поставщика
          vbArrayImportSettings[i].UserName     :=DataSet.FieldByName('UserName').asString;
          vbArrayImportSettings[i].Id           :=DataSet.FieldByName('Id').asInteger;
          vbArrayImportSettings[i].Code         :=DataSet.FieldByName('Code').asInteger;
          vbArrayImportSettings[i].Name         :=DataSet.FieldByName('Name').asString;
          vbArrayImportSettings[i].JuridicalId  :=DataSet.FieldByName('JuridicalId').asInteger;
          vbArrayImportSettings[i].JuridicalCode:=DataSet.FieldByName('JuridicalCode').asInteger;
          vbArrayImportSettings[i].JuridicalName:=DataSet.FieldByName('JuridicalName').asString;
          vbArrayImportSettings[i].JuridicalMail:=DataSet.FieldByName('JuridicalMail').asString;
          vbArrayImportSettings[i].ContactPersonId  :=DataSet.FieldByName('ContactPersonId').asInteger;
          vbArrayImportSettings[i].ContactPersonName:=DataSet.FieldByName('ContactPersonName').asString;
          vbArrayImportSettings[i].ContractId   :=DataSet.FieldByName('ContractId').asInteger;
          vbArrayImportSettings[i].ContractName :=DataSet.FieldByName('ContractName').asString;
          vbArrayImportSettings[i].isMultiLoad  :=DataSet.FieldByName('isMultiLoad').asBoolean;

          vbArrayImportSettings[i].zc_Enum_EmailKind_InPrice   := DataSet.FieldByName('zc_Enum_EmailKind_InPrice').asInteger;
          vbArrayImportSettings[i].zc_Enum_EmailKind_IncomeMMO := DataSet.FieldByName('zc_Enum_EmailKind_IncomeMMO').asInteger;
          vbArrayImportSettings[i].EmailKindId   := DataSet.FieldByName('EmailKindId').asInteger;
          vbArrayImportSettings[i].EmailKindname := DataSet.FieldByName('EmailKindname').asString;

          // путь, в который должны попасть xls файлы перед загрузкой в программу
          vbArrayImportSettings[i].Directory    :=ExpandFileName(DataSet.FieldByName('DirectoryImport').asString);
          // Время начала активной проверки
          vbArrayImportSettings[i].StartTime    :=DataSet.FieldByName('StartTime').AsDateTime;
          // Время окончания активной проверки
          vbArrayImportSettings[i].EndTime      :=DataSet.FieldByName('EndTime').AsDateTime;

          //временно сохранили список UserName
          if not (UserNameStringList.IndexOf(DataSet.FieldByName('UserName').asString) >= 0)
          then begin UserNameStringList.Add(DataSet.FieldByName('UserName').asString);UserNameStringList.Sort;end;

          //перешли к следующему
          DataSet.Next;
          i:=i+1;
       end;
       //
       //обнуляем UserName
       for i:=0 to Length(vbArrayMail) - 1 do vbArrayMail[i].UserName:='';
       //второй цикл
       DataSet.First;
       i:=0;
       SetLength(vbArrayMail,UserNameStringList.Count);//длина масива соответствует кол-ву UserName-ов
       while not DataSet.EOF do
       begin
          nn:= GetArrayList_Index_byUserName(vbArrayMail, DataSet.FieldByName('UserName').asString);
          if nn = -1 then
          begin
                //сохранили новый Host + UserName
                vbArrayMail[i].Host:=DataSet.FieldByName('Host').asString;
                vbArrayMail[i].Port:=DataSet.FieldByName('Port').asInteger;
                vbArrayMail[i].Mail:=DataSet.FieldByName('Mail').asString;
                vbArrayMail[i].UserName:=DataSet.FieldByName('UserName').asString;
                vbArrayMail[i].PasswordValue:=DataSet.FieldByName('PasswordValue').asString;
                // путь, по которому сохраняются вложенные файлики из писем, и если необходимо - там же разархивируются
                vbArrayMail[i].Directory:=ExpandFileName(DataSet.FieldByName('DirectoryMail').asString);
                // с какой периодичностью проверять почту в активном периоде, мин
                vbArrayMail[i].onTime:=DataSet.FieldByName('onTime').asInteger;
                // Время последней проверки - инициализируем значением "много дней назад"
                vbArrayMail[i].BeginTime:=NOW-1000;
                // переносить прайс в актуальные цены (а загрузка выполняется всегда)
                cbBeginMove.Checked:=(vbEmailKindDesc= 'zc_Enum_EmailKind_InPrice') and (DataSet.FieldByName('isBeginMove').asBoolean);
                //
                i:=i+1;
          end
          else if vbArrayMail[nn].onTime > DataSet.FieldByName('onTime').asInteger
               then // обновили новый минимум -  с какой периодичностью проверять почту в активном периоде, мин
                    vbArrayMail[nn].onTime:=DataSet.FieldByName('onTime').asInteger;

          // !!!в таймере!!! обновили новый минимум -  с какой периодичностью проверять почту в активном периоде
          if (Timer.Interval > DataSet.FieldByName('onTime').asInteger * 60 * 1000) or (Timer.Interval <= 1000) then
          begin
               Timer.Interval:= DataSet.FieldByName('onTime').asInteger * 60 * 1000;
               cbTimer.Caption:= 'Timer ON ' + FloatToStr(Timer.Interval / 1000) + ' sec ' + '('+FormatDateTime('dd.mm.yyyy hh:mm:ss',vbOnTimer)+')';
          end;
          //перешли к следующему
          DataSet.Next;
       end;
     end;
     //
     UserNameStringList.Free;
     // завершена обработка
     vbIsBegin:= false;
     // !!!включили таймер!!!
     Timer.Enabled:=true;
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
  ii, i,j: integer;
  msgcnt: integer;
  Session,mailFolderMain,mailFolder,StrCopyFolder: ansistring;
  JurPos: integer;
  arch:i7zInArchive;
  StartTime:TDateTime;
  IdIMAP4:TIdIMAP4;
  searchResult, searchResult_save : TSearchRec;
  fOK,fMMO:Boolean;
  msgDate_save:TDateTime;
begin

     if vbIsBegin = true then exit;
     // запущена обработка
     vbIsBegin:= true;


     //сессия - в эту папку будем сохранять файлики - она определяется временем запуска обработки
     StartTime:=NOW;
     Session:=FormatDateTime('yyyy-mm-dd hh-mm-ss',StartTime);
     //
     arch:=CreateInArchive(CLSID_CFormatZip);

     //
     GaugeHost.Progress:=0;
     GaugeHost.MaxValue:=Length(vbArrayMail);
     Application.ProcessMessages;
     //цикл по почтовым ящикам
     for ii := 0 to Length(vbArrayMail)-1 do
       // если после предыдущей обработки прошло > onTime МИНУТ
       if (NOW - vbArrayMail[ii].BeginTime) * 24 * 60 > vbArrayMail[ii].onTime
       then try

           PanelHost.Caption:= 'Start Mail (0.1) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
           IdIMAP4:=TIdIMAP4.Create(Self);
           PanelHost.Caption:= 'Start Mail (0.2) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
           IdIMAP4.IOHandler:=IdSSLIOHandlerSocketOpenSSL;
           PanelHost.Caption:= 'Start Mail (0.3) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
           IdIMAP4.UseTLS:=utUseImplicitTLS;
           PanelHost.Caption:= 'Start Mail (0.4) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
           IdIMAP4.AuthType:=iatUserPass;
           PanelHost.Caption:= 'Start Mail (0.5) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
           IdIMAP4.MilliSecsToWaitToClearBuffer:=100;

           with IdIMAP4 do
           begin
              //
              PanelHost.Caption:= 'Start Mail (1.1) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
              Application.ProcessMessages;
              Sleep(2000);
              //current directory to store the email
              mailFolderMain:= vbArrayMail[ii].Directory + '\' + ReplaceStr(vbArrayMail[ii].UserName, '@', '_') + '_' + Session;
              //создали папку для писем если таковой нет + это протокол что по данному ящику была обработка
              ForceDirectories(mailFolderMain);

              PanelHost.Caption:= 'Start Mail (1.2) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
              //параметры подключения к ящику
              Host    := vbArrayMail[ii].Host;
              UserName:= vbArrayMail[ii].UserName;
              Password:= vbArrayMail[ii].PasswordValue;
              Port    := vbArrayMail[ii].Port;

              try
                 PanelHost.Caption:= 'Start Mail (2) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                 //подключаемся к ящику
                 //***IdIMAP4.Connect;          //POP3

                 try IdIMAP4.Connect(TRUE);     //IMAP
                 except
                      on E: Exception do begin
                         ShowMessage(' ERROR - IdIMAP4.Connect(TRUE)  : ' + E.Message);
                       exit;
                      end;
                 end;

                 PanelHost.Caption:= 'Start Mail (3.1) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                 IdIMAP4.SelectMailBox('INBOX');//IMAP
                 PanelHost.Caption:= 'Start Mail (3.2) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                 //количество писем
                 //***msgcnt:= IdIMAP4.CheckMessages;  //POP3
                 msgcnt:= IdIMAP4.MailBox.TotalMsgs;   //IMAP
                 PanelHost.Caption:= 'Start Mail (3.4) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                 //
                 GaugeMailFrom.Progress:=0;
                 GaugeMailFrom.MaxValue:=msgcnt;
                 Application.ProcessMessages;
                 //цикл по входящим письмам
                 for I:= msgcnt downto 1 do
                 begin
                   PanelHost.Caption:= 'Start Mail (4) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                   IdMessage.Clear; // очистка буфера для сообщения

                   //такого файла - нет
                   fMMO:= false;

                   PanelHost.Caption:= 'Start Mail (5.1.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                   //если вытянулось из почты письмо
                   if (IdIMAP4.Retrieve(i, IdMessage)) then
                   begin
                        PanelHost.Caption:= 'Start Mail (5.2.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                        //IdMessage.CharSet := 'UTF-8';

                        //находим поставщика, который отправил на этот UserName + есть в нашем списке + время
                        JurPos:=GetArrayList_Index_byJuridicalMail(vbArrayImportSettings, vbArrayMail[ii].UserName, IdMessage.From.Address);
                        //
                        if JurPos >=0
                        then PanelMailFrom.Caption:= 'Mail From : '+FormatDateTime('dd.mm.yyyy hh:mm:ss',IdMessage.Date) + ' (' +  IntToStr(vbArrayImportSettings[JurPos].Id) + ') ' + vbArrayImportSettings[JurPos].Name
                        else PanelMailFrom.Caption:= 'Mail From : '+FormatDateTime('dd.mm.yyyy hh:mm:ss',IdMessage.Date) + ' ' + IdMessage.From.Address + ' - ???';
                        Application.ProcessMessages;
                        //если нашли поставщика, тогда это письмо надо загружать
                        if JurPos >= 0 then
                        begin
                             //current directory to store the email files
                             mailFolder:= mailFolderMain + '\' + FormatDateTime('yyyy-mm-dd hh-mm-ss',IdMessage.Date) + '_' +  IntToStr(vbArrayImportSettings[JurPos].Id) + '_' + vbArrayImportSettings[JurPos].Name;
                             //создали папку для писем если таковой нет
                             ForceDirectories(mailFolder);

                             //
                             GaugeParts.Progress:=0;
                             GaugeParts.MaxValue:=IdMessage.MessageParts.Count;
                             Application.ProcessMessages;
                             PanelHost.Caption:= 'Start Mail (5.3.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                             //пройдемся по всем частям письма
                             for j := 0 to IdMessage.MessageParts.Count - 1 do
                             begin
                               //
                               PanelParts.Caption:= 'Parts : '+IdMessage.From.Address;
                               Application.ProcessMessages;
                               //если это вложенный файлик
                               if IdMessage.MessageParts[j] is TIdAttachment then
                               begin
                                   // сохранили файлик из письма
                                   (IdMessage.MessageParts[j] as TIdAttachment).SaveToFile(mailFolder + '\' + IdMessage.MessageParts[J].FileName);
                                   // если надо - разархивировали
                               end;
                               GaugeParts.Progress:=GaugeParts.Progress+1;
                               Application.ProcessMessages;
                             end;//завершилась обработка всех частей одного письма
                        end
                   end
                   else ShowMessage('not read :' + IntToStr(i));

                   //удаление письма
                   //***if flag then IdIMAP4.Delete(i);   //POP3
                   PanelHost.Caption:= 'Start Mail (5.4.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                   IdIMAP4.CopyMsg(i, 'Удаленные');
                   IdIMAP4.DeleteMsgs(i);    //IMAP
                   IdIMAP4.ExpungeMailBox;
                   PanelHost.Caption:= 'Start Mail (5.5.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
                   //

                   //все, идем дальше
                   Sleep(500);
                   GaugeMailFrom.Progress:=GaugeMailFrom.Progress+1;
                   Application.ProcessMessages;

                 end;//финиш - цикл по входящим письмам

                 PanelHost.Caption:= 'End Mail (5.6) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);

                 //осталось сохранить время последней обработки почтового ящика
                 vbArrayMail[ii].BeginTime:=vbOnTimer;
                 //
                 PanelHost.Caption:= 'End Mail (5.7): '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
                 GaugeHost.Progress:=GaugeHost.Progress + 1;
                 Application.ProcessMessages;
              finally
                 PanelHost.Caption:= 'End Mail (6.1.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
                 //***IdIMAP4.Disconnect;    // POP3
                 IdIMAP4.Disconnect();       //IMAP
                 PanelHost.Caption:= 'End Mail (6.2.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
                 IdIMAP4.Free;               //IMAP
                 PanelHost.Caption:= 'End Mail (6.3) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
              end;

              PanelHost.Caption:= 'OK - End Mail (7.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
              Application.ProcessMessages;
              Sleep(3000);

           end;// with IdIMAP4 do
       except
           PanelHost.Caption:= 'ERROR - TIdIMAP4 - try on Next Step - End Mail (8.) : '+vbArrayMail[ii].UserName+' ('+vbArrayMail[ii].Host+') for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);

           //current directory to store the email
           mailFolderMain:= vbArrayMail[ii].Directory + '\' + ReplaceStr(vbArrayMail[ii].UserName, '@', '_') + '_' + Session;
           //создали папку для ПРОТОКОЛА если таковой нет + это протокол что по данному ящику была обработка
           ForceDirectories(mailFolderMain);
           //сохранили - что была ОШИБКА
           Add_Log_XML(mailFolderMain, PanelHost.Caption);

           Application.ProcessMessages;
           Sleep(5000);
       end;//финиш - цикл по почтовым ящикам

     // завершена обработка
     vbIsBegin:= false;

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// обработка все
function TMainForm.fBeginAll : Boolean;
begin
     PanelError.Caption:= '';

     //инициализируем данные по всем поставщикам
     fInitArray;
     // обработка всей почты
     fBeginMail;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
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
     // время когда сработал таймера
     vbOnTimer:= NOW;
     cbTimer.Caption:= 'Timer ON ' + FloatToStr(Timer.Interval / 1000) + ' seccc ' + '('+FormatDateTime('dd.mm.yyyy hh:mm:ss',vbOnTimer)+')';
     Sleep(1000);
     // обработка все
     fBeginAll;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fGet_LoadPriceList (inJuridicalId, inContractId :Integer) : Integer;
begin
     with spGet_LoadPriceList do
     begin
       ParamByName('inJuridicalId').Value:=inJuridicalId;
       ParamByName('inContractId').Value:=inContractId;
       Execute;
       Result:=ParamByName('outId').Value;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
end.
