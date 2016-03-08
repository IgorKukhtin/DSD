unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.DateUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, IdMessage,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdPOP3, IdAttachment, dsdDB,
  Data.DB, Datasnap.DBClient;

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
    BitBtn1: TBitBtn;
    spSelect: TdsdStoredProc;
    ClientDataSet: TClientDataSet;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    vbArrayMail :TArrayMail; // массив почтовых ящиков
    vbArrayImportSettings :TArrayImportSettings; // массив поставщиков и параметров загрузки информации
    function GetArrayList_Index_byHost(ArrayList:TArrayMail;Host:String):Integer;//находит Индекс в массиве по значению Host
    function GetArrayList_Index_byJuridicalMail(ArrayList:TArrayImportSettings;Host,JuridicalMail:String):Integer;//находит Индекс в массиве по значению Host + MailJuridical
    function fInitArray : Boolean; // получает данные с сервера и на основании этих данных заполняет массивы
    function fBeginMail : Boolean; // обработка всей почты
  public
  end;

var
  MainForm: TMainForm;

implementation
uses Authentication, Storage, CommonData, UtilConst;
{$R *.dfm}
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
begin
  //создает сессию и коннект
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Авто-загрузка прайс-поставщик', gc_AdminPassword, gc_User);
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
                // Время последней проверки
                vbArrayMail[i].BeginTime:=NOW-1000;
                //
                i:=i+1;
          end;
          //перешли к следующему
          DataSet.Next;
       end;
     end;
     //
     HostStringList.Free;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// обработка всей почты
function TMainForm.fBeginMail : Boolean;
var
  msgs: integer;
  ii, i,j: integer;
  flag: boolean;
  msgcnt: integer;
  mailFolder,mailFolder1,mailFolder2,mailFolder3,mailFolder4,Session: ansistring;
  JurPos: integer;
begin
     //сессия - в эту папку будем сохранять файлики - она определяется временем запуска обработки
     Session:=FormatDateTime('yyy-mm-dd hh-mm-ss',NOW);

     //цикл по почтовым ящикам
     for ii := 0 to Length(vbArrayMail)-1 do
       // если после предыдущей обработки прошло > onTime МИНУТ
       if (NOW - vbArrayMail[ii].BeginTime) * 24 * 60 > vbArrayMail[ii].onTime
       then
           with IdPOP3 do
           begin
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
                 //цикл по входящим письмам
                 for I:= msgcnt downto 1 do
                 begin
                   IdMessage.Clear; // очистка буфера для сообщения
                   flag:= false;

                   //если вытянулось из почты письмо
                   if (IdPOP3.Retrieve(i, IdMessage)) then
                   begin
                        //находим поставщика, который отправил на этот Host + есть в нашем списке
                        JurPos:=GetArrayList_Index_byJuridicalMail(vbArrayImportSettings, vbArrayMail[ii].Host, IdMessage.From.Address);
                        //если нашли поставщика, тогда это письмо надо загружать
                        if JurPos >= 0 then
                        begin
                             //current directory to store the email files
                             mailFolder:= vbArrayMail[ii].Directory + '\' + vbArrayMail[ii].Host + '_' + Session + '_' + IntToStr(vbArrayImportSettings[JurPos].Id) + '_' + vbArrayImportSettings[JurPos].JuridicalName;
                             //создали папку для писем если таковой нет
                             ForceDirectories(mailFolder);

                             //пройдемся по всем частям письма
                             for j := 0 to IdMessage.MessageParts.Count - 1
                             do
                               //если это вложенный файлик
                               if IdMessage.MessageParts[j] is TIdAttachment then
                               begin
                                   // сохранили файлик из письма
                                   (IdMessage.MessageParts[j] as TIdAttachment).SaveToFile(mailFolder + '\' + IdMessage.MessageParts[J].FileName);
                                   // если надо - разархивировали
                                   if not (System.Pos(AnsiUppercase('.xls'), AnsiUppercase(IdMessage.MessageParts[J].FileName)) > 0)
                                    and not(System.Pos(AnsiUppercase('.xlsx'), AnsiUppercase(IdMessage.MessageParts[J].FileName)) > 0)
                                   then ;
                                   //ShowMessage(IdMessage.From.Address + ' : ' + IdMessage.Subject + ' : ' + IntToStr(j) + ' : ' + IdMessage.MessageParts[j].FileName + '   '  +FormatDateTime('dd mmm yyyy hh:mm:ss', IdMessage.Date) );
                               end;
                            //завершилась обработка всех частей одного письма

                            //создали папку для загрузки, если таковой нет
                            ForceDirectories(vbArrayImportSettings[JurPos].Directory);

                            // потом скопировали ВСЕ файлики в папку из которой уже будет загрузка
                            mailFolder1:=mailFolder+'\*.xls';
                            CopyFile(PChar(mailFolder1),PChar(vbArrayImportSettings[JurPos].Directory),TRUE);
                            // потом скопировали ВСЕ файлики в папку из которой уже будет загрузка
                            mailFolder2:=mailFolder+'\*.xlsx';
                            CopyFile(PChar(mailFolder2),PChar(vbArrayImportSettings[JurPos].Directory),TRUE);
                            // !!!TEST!!!
                            mailFolder3:='cmd.exe /c copy ' + chr(34) + mailFolder + '\*.*' + chr(34) + ' ' + chr(34) + vbArrayImportSettings[JurPos].Directory + chr(34);
                            WinExec(PAnsiChar(mailFolder3), SW_HIDE);

                            // потом надо удалить письмо в почте
                            flag:= true;
                        end;
                   end
                   else ShowMessage('not read :' + IntToStr(i));

                   //удаление письма
                   //if flag then IdPOP3.Delete(i);

                 end;//финиш - цикл по входящим письмам
              finally
                 IdPOP3.Disconnect;
              end;

           end;//финиш - цикл по почтовым ящикам
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.BitBtn1Click(Sender: TObject);
begin
     //инициализируем данные по всем поставщика
     fInitArray;
     // обработка всей почты
     fBeginMail;
     //
     ShowMessage('Finish');
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------

end.
