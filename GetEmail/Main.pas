unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, IdMessage,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdPOP3, IdAttachment, dsdDB,
  Data.DB, Datasnap.DBClient;

type
  TMailItem = record
    Host          : string;
    Port          : Integer;
    Mail          : string;
    UserName      : string;
    PasswordValue : string;
    Directory     : string;
  end;
  TArrayMail = array of TMailItem;

  TMainForm = class(TForm)
    IdPOP3: TIdPOP3;
    IdMessage: TIdMessage;
    BitBtn1: TBitBtn;
    spSelect: TdsdStoredProc;
    ClientDataSet: TClientDataSet;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    vbArrayMail :TArrayMail;
    function fInitArrayMail : Boolean;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation
uses Authentication, Storage, CommonData, UtilConst;
{$R *.dfm}
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
begin
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', gc_AdminPassword, gc_User);
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
function TMainForm.fInitArrayMail : Boolean;
var i:Integer;
begin
     with spSelect do
     begin
       StoredProcName:='gpSelect_Object_ImportSettings_Email';
       OutputType:=otDataSet;
       Params.Clear;
       Execute;// получили всех поставщиков, по которым надо загружать Email
       //
       DataSet.First;
       i:=0;
       SetLength(vbArrayMail,DataSet.RecordCount);//длина масива соответствует кол-ву поставщиков
       while not DataSet.EOF do begin
          //заполнили каждого поставщика
          vbArrayMail[i].Host:=DataSet.FieldByName('Host').asString;
          vbArrayMail[i].Port:=DataSet.FieldByName('Port').asInteger;
          vbArrayMail[i].Mail:=DataSet.FieldByName('Mail').asString;
          vbArrayMail[i].UserName:=DataSet.FieldByName('UserName').asString;
          vbArrayMail[i].PasswordValue:=DataSet.FieldByName('PasswordValue').asString;
          if AnsiUpperCase(DataSet.FieldByName('Directory').asString) = AnsiUpperCase('\inbox')
          then vbArrayMail[i].Directory:=GetCurrentDir() + '' + DataSet.FieldByName('Directory').asString
          else vbArrayMail[i].Directory:=DataSet.FieldByName('Directory').asString;
          //перешли к следующему
          DataSet.Next;
          i:=i+1;
       end;
     end;
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------
procedure TMainForm.BitBtn1Click(Sender: TObject);
var
  msgs: integer;
  ii, i,j: integer;
  flag: boolean;
  msgcnt: integer;
  mailFolder: String;
begin
     //инициализируем данные по всем поставщика
     fInitArrayMail;
     //теперь всех попробуем обработать
     for ii := 0 to Length(vbArrayMail)-1 do
     with IdPOP3 do begin
        Host:= vbArrayMail[ii].Host;
        UserName:= vbArrayMail[ii].UserName;
        Password:= vbArrayMail[ii].PasswordValue;
        Port:= vbArrayMail[ii].Port;
        try
           //подключаемся
           IdPOP3.Connect;
           //current directory to store the email files
           mailFolder := vbArrayMail[ii].Directory;
           //создали папку если таковой нет
           ForceDirectories(mailFolder);
           //количество писем
           msgcnt:= IdPOP3.CheckMessages;
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
             if flag then IdPOP3.Delete(i);

           end;//завершили обработку всех писем
        finally
           IdPOP3.Disconnect;
        end;

     end;//завершили обработку всех поставщиков
end;
//----------------------------------------------------------------------------------------------------------------------------------------------------

end.
