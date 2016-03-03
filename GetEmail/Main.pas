unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
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
    Directory     : string;
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
    ContractId    : Integer;
    ContractName  : string;
    Directory     : string;
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
// получает данные с сервера и на основании этих данных заполняет массивы
function TMainForm.fInitArray : Boolean;
var i:Integer;
    MailStringList:TStringList;
begin
     MailStringList:=TStringList.Create(nil);
     MailStringList.Sorted:=true;
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
          vbArrayImportSettings[i].ContractId   :=DataSet.FieldByName('ContractId').asInteger;
          vbArrayImportSettings[i].ContractName :=DataSet.FieldByName('ContractName').asString;
          vbArrayImportSettings[i].Directory    :=DataSet.FieldByName('DirectoryImport').asString;
          //перешли к следующему
          DataSet.Next;
          i:=i+1;
       end;
       //
       //второй цикл
       DataSet.First;
       i:=0;
       SetLength(vbArrayMail,MailStringList.Count);//длина масива соответствует кол-ву Host-ов
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
                if AnsiUpperCase(DataSet.FieldByName('DirectoryMail').asString) = AnsiUpperCase('\inbox')
                then vbArrayMail[i].Directory:=GetCurrentDir() + '' + DataSet.FieldByName('DirectoryMail').asString
                else vbArrayMail[i].Directory:=DataSet.FieldByName('DirectoryMail').asString;
                //
                i:=i+1;
          end;
          //перешли к следующему
          DataSet.Next;
       end;
     end;
     //
     MailStringList.Free;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
// обработка всей почты
function TMainForm.fBeginMail : Boolean;
var
  msgs: integer;
  ii, i,j: integer;
  flag: boolean;
  msgcnt: integer;
  mailFolder: String;
begin
     //цикл по почтовым ящикам
     for ii := 0 to Length(vbArrayMail)-1 do
     with IdPOP3 do begin
        //параметры подключения к ящику
        Host    := vbArrayMail[ii].Host;
        UserName:= vbArrayMail[ii].UserName;
        Password:= vbArrayMail[ii].PasswordValue;
        Port    := vbArrayMail[ii].Port;
        try
           //подключаемся к ящику
           IdPOP3.Connect;
           //current directory to store the email files
           mailFolder:= vbArrayMail[ii].Directory;
           //создали папку если таковой нет
           ForceDirectories(mailFolder);
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
                  //пройдемся по всем частям письма
                  for j := 0 to IdMessage.MessageParts.Count - 1
                  do
                    //если это вложенный файлик
                    if IdMessage.MessageParts[j] is TIdAttachment then
                    begin
                         // сохранили файлик из письма
                         (IdMessage.MessageParts[j] as TIdAttachment).SaveToFile(mailFolder +'\' + IdMessage.MessageParts[J].FileName);
                         //ShowMessage(IdMessage.From.Address + ' : ' + IdMessage.Subject + ' : ' + IntToStr(j) + ' : ' + IdMessage.MessageParts[j].FileName + '   '  +FormatDateTime('dd mmm yyyy hh:mm:ss', IdMessage.Date) );
                    end;
                  //завершилась обработка всех частей 1-ого письма

                  // потом удалим письмо в почте
                  flag:= true;
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
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------

end.
