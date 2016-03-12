unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.DateUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, IdMessage,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdPOP3, IdAttachment, dsdDB,
  Data.DB, Datasnap.DBClient, Vcl.Samples.Gauges, Vcl.ExtCtrls, Vcl.ActnList,
  dsdAction, ExternalLoad, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL;

type
  // элемент "почтовый ящик"
  TMailItem = record
    Host          : string;
    Port          : Integer;
    Mail          : string;
    UserName      : string;
    PasswordValue : string;
    Directory     : string;    // путь, по которому сохраняются вложенные файлики из писем, и если необходимо - там же разархивируются
    onTime        : Integer;   // с какой периодичностью проверять почту в активном периоде, мин
    BeginTime     : TDateTime; // Время последней проверки
  end;
  TArrayMail = array of TMailItem;
  // элемент "поставщик и параметры загрузки информации"
  TImportSettingsItem = record
    Host          : string;
    Id            : Integer;
    Code          : Integer;
    Name          : string;
    JuridicalId   : Integer;
    JuridicalCode : Integer;
    JuridicalName : string;
    JuridicalMail : string;
    ContractId    : Integer;
    ContractName  : string;
    Directory     : string;    // путь, в который должны попасть xls файлы перед загрузкой в программу
    StartTime     : TDateTime; // Время начала активной проверки
    EndTime       : TDateTime; // Время окончания активной проверки
  end;
  TArrayImportSettings = array of TImportSettingsItem;

  TMainForm = class(TForm)
    IdPOP3: TIdPOP3;
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
    procedure BtnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure cbTimerClick(Sender: TObject);
  private
    vbIsBegin :Boolean;// запущена обработка

    vbArrayMail :TArrayMail; // массив почтовых ящиков
    vbArrayImportSettings :TArrayImportSettings; // массив поставщиков и параметров загрузки информации

    function GetArrayList_Index_byHost(ArrayList:TArrayMail;Host:String):Integer;//находит Индекс в массиве по значению Host
    function GetArrayList_Index_byJuridicalMail(ArrayList:TArrayImportSettings;Host,JuridicalMail:String):Integer;//находит Индекс в массиве по значению Host + MailJuridical

    function fGet_LoadPriceList (inJuridicalId, inContractId :Integer) : Integer;

    function fBeginAll  : Boolean; // обработка все
    function fInitArray : Boolean; // получает данные с сервера и на основании этих данных заполняет массивы
    function fBeginMail : Boolean; // обработка всей почты
    function fBeginXLS  : Boolean; // обработка всех XLS
    function fBeginMove : Boolean; // перенос цен
  public
  end;

var
  MainForm: TMainForm;

implementation
uses Authentication, Storage, CommonData, UtilConst, sevenzip;
{$R *.dfm}
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
begin
  //создает сессию и коннект
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Авто-загрузка прайс-поставщик', gc_AdminPassword, gc_User);
  // запущена обработка
  vbIsBegin:= false;
  // переносить прайс в актуальные цены (а загрузка выполняется всегда)
  cbBeginMove.Checked:=false;
  // включаем таймер
  cbTimer.Checked:=true;
  Timer.Enabled:=cbTimer.Checked;
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
//находит Индекс в массиве по значению Host
function TMainForm.GetArrayList_Index_byHost(ArrayList:TArrayMail;Host:String):Integer;
var i: Integer;
begin
     //находит Индекс в массиве по значению Host
    Result:=-1;
    for i := 0 to Length(ArrayList)-1 do
      if (ArrayList[i].Host = Host) then begin Result:=i;break;end;
end;
{------------------------------------------------------------------------}
//находит Индекс в массиве по значению Host + MailJuridical + время
function TMainForm.GetArrayList_Index_byJuridicalMail(ArrayList:TArrayImportSettings;Host,JuridicalMail:String):Integer;
var i: Integer;
    Year, Month, Day: Word;
    Second, MSec: word;
    Hour_calc, Minute_calc: word;
    StartTime_calc,EndTime_calc:TDateTime;
begin
     //находит Индекс в массиве по значению Host
    Result:=-1;
    for i := 0 to Length(ArrayList)-1 do
      if (ArrayList[i].Host = Host) and (AnsiUpperCase(ArrayList[i].JuridicalMail) = AnsiUpperCase(JuridicalMail))
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
// получает данные с сервера и на основании этих данных заполняет массивы
function TMainForm.fInitArray : Boolean;
var i:Integer;
    HostStringList:TStringList;
begin
     if vbIsBegin = true then exit;
     // запущена обработка
     vbIsBegin:= true;

     HostStringList:=TStringList.Create;
     HostStringList.Sorted:=true;
     //
     with spSelect do
     begin
       StoredProcName:='gpSelect_Object_ImportSettings_Email';
       OutputType:=otDataSet;
       Params.Clear;
       Execute;// получили всех поставщиков, по которым надо загружать Email
       //
       //первый цикл
       DataSet.First;
       i:=0;
       SetLength(vbArrayImportSettings,DataSet.RecordCount);//длина масива соответствует кол-ву поставщиков
       while not DataSet.EOF do begin
          //заполнили каждого поставщика
          vbArrayImportSettings[i].Host         :=DataSet.FieldByName('Host').asString;
          vbArrayImportSettings[i].Id           :=DataSet.FieldByName('Id').asInteger;
          vbArrayImportSettings[i].Code         :=DataSet.FieldByName('Code').asInteger;
          vbArrayImportSettings[i].Name         :=DataSet.FieldByName('Name').asString;
          vbArrayImportSettings[i].JuridicalId  :=DataSet.FieldByName('JuridicalId').asInteger;
          vbArrayImportSettings[i].JuridicalCode:=DataSet.FieldByName('JuridicalCode').asInteger;
          vbArrayImportSettings[i].JuridicalName:=DataSet.FieldByName('JuridicalName').asString;
          vbArrayImportSettings[i].JuridicalMail:=DataSet.FieldByName('JuridicalMail').asString;
          vbArrayImportSettings[i].ContractId   :=DataSet.FieldByName('ContractId').asInteger;
          vbArrayImportSettings[i].ContractName :=DataSet.FieldByName('ContractName').asString;
          // путь, в который должны попасть xls файлы перед загрузкой в программу
          vbArrayImportSettings[i].Directory    :=ExpandFileName(DataSet.FieldByName('DirectoryImport').asString);
          // Время начала активной проверки
          vbArrayImportSettings[i].StartTime    :=DataSet.FieldByName('StartTime').AsDateTime;
          // Время окончания активной проверки
          vbArrayImportSettings[i].EndTime      :=DataSet.FieldByName('EndTime').AsDateTime;

          //временно сохранили список Host
          if not (HostStringList.IndexOf(DataSet.FieldByName('Host').asString) >= 0)
          then begin HostStringList.Add(DataSet.FieldByName('Host').asString);HostStringList.Sort;end;

          //перешли к следующему
          DataSet.Next;
          i:=i+1;
       end;
       //
       //второй цикл
       DataSet.First;
       i:=0;
       SetLength(vbArrayMail,HostStringList.Count);//длина масива соответствует кол-ву Host-ов
       while not DataSet.EOF do
       begin
          if GetArrayList_Index_byHost(vbArrayMail, DataSet.FieldByName('Host').asString) = -1 then
          begin
                //сохранили новый Host
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
                cbBeginMove.Checked:=DataSet.FieldByName('isBeginMove').asBoolean;
                //
                //в таймер сохраняем - периодичность проверки почты
                if (Timer.Interval > vbArrayMail[i].onTime * 60 * 1000) or (Timer.Interval <= 1000) then
                begin
                     Timer.Interval:= vbArrayMail[i].onTime * 60 * 1000;
                     cbTimer.Caption:= 'Timer ON ' + IntToStr(vbArrayMail[i].onTime * 60) + ' sec';
                end;
                //
                i:=i+1;
          end;
          //перешли к следующему
          DataSet.Next;
       end;
     end;
     //
     HostStringList.Free;
     // завершена обработка
     vbIsBegin:= false;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// обработка всей почты
function TMainForm.fBeginMail : Boolean;
var
  msgs: integer;
  ii, i,j: integer;
  flag: boolean;
  msgcnt: integer;
  Session,mailFolderMain,mailFolder,StrCopyFolder: ansistring;
  JurPos: integer;
  arch:i7zInArchive;
  StartTime:TDateTime;
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
       then
           with IdPOP3 do
           begin
              //
              PanelHost.Caption:= 'Start Host : '+vbArrayMail[ii].Host+' for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
              Application.ProcessMessages;
              //current directory to store the email
              mailFolderMain:= vbArrayMail[ii].Directory + '\' + vbArrayMail[ii].Host + '_' + Session;
              //создали папку для писем если таковой нет + это протокол что по данному ящику была обработка
              ForceDirectories(mailFolderMain);

              //параметры подключения к ящику
              Host    := vbArrayMail[ii].Host;
              UserName:= vbArrayMail[ii].UserName;
              Password:= vbArrayMail[ii].PasswordValue;
              Port    := vbArrayMail[ii].Port;

              try
                 //подключаемся к ящику
                 IdPOP3.Connect;
                 //количество писем
                 msgcnt:= IdPOP3.CheckMessages;
                 //
                 GaugeMailFrom.Progress:=0;
                 GaugeMailFrom.MaxValue:=msgcnt;
                 Application.ProcessMessages;
                 //цикл по входящим письмам
                 for I:= msgcnt downto 1 do
                 begin
                   IdMessage.Clear; // очистка буфера для сообщения
                   flag:= false;

                   //если вытянулось из почты письмо
                   if (IdPOP3.Retrieve(i, IdMessage)) then
                   begin
                        //находим поставщика, который отправил на этот Host + есть в нашем списке + время
                        JurPos:=GetArrayList_Index_byJuridicalMail(vbArrayImportSettings, vbArrayMail[ii].Host, IdMessage.From.Address);
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
                                   if not (System.Pos(AnsiUppercase('.xls'), AnsiUppercase(IdMessage.MessageParts[J].FileName)) > 0)
                                    and not(System.Pos(AnsiUppercase('.xlsx'), AnsiUppercase(IdMessage.MessageParts[J].FileName)) > 0)
                                    and not(System.Pos(AnsiUppercase('.xml'), AnsiUppercase(IdMessage.MessageParts[J].FileName)) > 0)
                                   then begin
                                             arch.OpenFile(mailFolder + '\' + IdMessage.MessageParts[J].FileName);
                                             arch.ExtractTo(mailFolder + '\');
                                        end;
                               end;
                               GaugeParts.Progress:=GaugeParts.Progress+1;
                               Application.ProcessMessages;
                             end;//завершилась обработка всех частей одного письма

                            //создали папку для загрузки, если таковой нет
                            ForceDirectories(vbArrayImportSettings[JurPos].Directory);

                            // ТОЛЬКО если "сегодня" не было загрузки JurPos
                            if fGet_LoadPriceList (vbArrayImportSettings[JurPos].JuridicalId, vbArrayImportSettings[JurPos].ContractId ) = 0 then
                            begin
                                  // потом скопировали ВСЕ файлики в папку из которой уже будет загрузка
                                  StrCopyFolder:='cmd.exe /c copy ' + chr(34) + mailFolder + '\*.xls' + chr(34) + ' ' + chr(34) + vbArrayImportSettings[JurPos].Directory + chr(34);
                                  WinExec(PAnsiChar(StrCopyFolder), SW_HIDE);
                                  // потом скопировали ВСЕ файлики в папку из которой уже будет загрузка
                                  StrCopyFolder:='cmd.exe /c copy ' + chr(34) + mailFolder + '\*.xlsx' + chr(34) + ' ' + chr(34) + vbArrayImportSettings[JurPos].Directory + chr(34);
                                  WinExec(PAnsiChar(StrCopyFolder), SW_HIDE);
                            end;
                            // потом надо удалить письмо в почте
                            flag:= true;
                        end
                        // если не нашли - все равно удалить письмо в почте
                        else flag:= true;
                   end
                   else ShowMessage('not read :' + IntToStr(i));

                   //удаление письма
                   if flag then IdPOP3.Delete(i);

                   //
                   GaugeMailFrom.Progress:=GaugeMailFrom.Progress+1;
                   Application.ProcessMessages;

                 end;//финиш - цикл по входящим письмам
                 //осталось сохранить время последней обработки почтового ящика
                 vbArrayMail[ii].BeginTime:=NOW;
                 //
                 PanelHost.Caption:= 'End Host '+vbArrayMail[ii].Host+' for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW)+' and Next - ' + FormatDateTime('dd.mm.yyyy hh:mm:ss',vbArrayMail[ii].BeginTime + vbArrayMail[ii].onTime / 24 / 60);
                 GaugeHost.Progress:=GaugeHost.Progress + 1;
                 Application.ProcessMessages;
              finally
                 IdPOP3.Disconnect;
              end;

           end;//финиш - цикл по почтовым ящикам

     // завершена обработка
     vbIsBegin:= false;

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// обработка всех XLS
function TMainForm.fBeginXLS : Boolean;
begin
     if vbIsBegin = true then exit;
     // запущена обработка
     vbIsBegin:= true;

     with ClientDataSet do begin
        GaugeLoadXLS.Progress:=0;
        GaugeLoadXLS.MaxValue:=RecordCount;
        Application.ProcessMessages;
        //
        First;
        while not EOF do begin
           PanelLoadXLS.Caption:= 'Load XLS : ('+FieldByName('Id').AsString + ') ' + FieldByName('Name').AsString;
           Application.ProcessMessages;
           //Загружаем если есть откуда
           if FieldByName('DirectoryImport').asString <> ''
           then actExecuteImportSettings.Execute;

           Next;
           //
           GaugeLoadXLS.Progress:=GaugeLoadXLS.Progress + 1;
           Application.ProcessMessages;
        end;
     end;

     // завершена обработка
     vbIsBegin:= false;

end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// перенос цен
function TMainForm.fBeginMove : Boolean;
var StartTime:TDateTime;
begin
     if vbIsBegin = true then exit;
     // запущена обработка
     vbIsBegin:= true;

     with spSelectMove do
     begin
        StoredProcName:='gpSelect_Movement_LoadPriceList';
        OutputType:=otDataSet;
        Params.Clear;
        Execute;// получили все Прайсы
        //
        GaugeMove.Progress:=0;
        GaugeMove.MaxValue:=DataSet.RecordCount;
        Application.ProcessMessages;
        //
        DataSet.First;
        while not Dataset.EOF do begin
           StartTime:=NOW;
           PanelMove.Caption:= 'Move : ('+FormatDateTime('dd.mm.yyyy',DataSet.FieldByName('OperDate').AsDateTime) + ') ' + DataSet.FieldByName('JuridicalName').AsString + ' : ' + DataSet.FieldByName('ContractName').AsString + ' for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime);
           Application.ProcessMessages;
           //
           if DataSet.FieldByName('isMoved').AsBoolean = FALSE
           then actMovePriceList.Execute;
           //
           DataSet.Next;
           //
           PanelMove.Caption:= 'Move : ('+FormatDateTime('dd.mm.yyyy',DataSet.FieldByName('OperDate').AsDateTime) + ') ' + DataSet.FieldByName('JuridicalName').AsString + ' : ' + DataSet.FieldByName('ContractName').AsString + ' for '+FormatDateTime('dd.mm.yyyy hh:mm:ss',StartTime)+' to '+FormatDateTime('dd.mm.yyyy hh:mm:ss',NOW);
           GaugeMove.Progress:=GaugeMove.Progress + 1;
           Application.ProcessMessages;
        end;
     end;

     // завершена обработка
     vbIsBegin:= false;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// обработка все
function TMainForm.fBeginAll : Boolean;
begin
     //инициализируем данные по всем поставщикам
     fInitArray;
     // обработка всей почты
     fBeginMail;
     // обработка всех XLS
     fBeginXLS;
     // перенос цен
     if cbBeginMove.Checked = TRUE then fBeginMove;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.BtnStartClick(Sender: TObject);
begin
     // обработка все
     fBeginAll;
     //
     ShowMessage('Finish');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.TimerTimer(Sender: TObject);
begin
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
