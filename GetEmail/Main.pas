unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, IdMessage,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdPOP3, IdAttachment;

type
  TMainForm = class(TForm)
    IdPOP3: TIdPOP3;
    IdMessage: TIdMessage;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.BitBtn1Click(Sender: TObject);
var
  msgs: integer;
  i,j: integer;
  flag: boolean;
  msgcnt: integer;
  mailFolder: String;
begin
     with IdPOP3 do begin
        Host:= 'pop.ua.fm';
        UserName:= 'Ashtu777@ua.fm';
        Password:= 'qsxqsxw1';
        Port:= 110;
     end;

  IdPOP3.Connect;

    // current directory to store the email files
    mailFolder := GetCurrentDir() + '\inbox';
    ForceDirectories(mailFolder);

      try
    msgcnt:= IdPOP3.CheckMessages;
    // ShowMessage (IntToStr(msgcnt));
    for I:= msgcnt downto 1 do
    begin
      IdMessage.Clear; // очистка буфера дл€ сообщени€
      flag:= false;

      if (IdPOP3.Retrieve(i, IdMessage)) then
      begin
          for j := 0 to IdMessage.MessageParts.Count - 1
          do
            if IdMessage.MessageParts[j] is TIdAttachment
            then begin
                (IdMessage.MessageParts[j] as TIdAttachment).SaveToFile(mailFolder +'\' + IdMessage.MessageParts[J].FileName);
                 ShowMessage(IdMessage.From.Address + ' : ' + IdMessage.Subject + ' : ' + IntToStr(j) + ' : ' + IdMessage.MessageParts[j].FileName + '   '  +FormatDateTime('dd mmm yyyy hh:mm:ss', IdMessage.Date) );
//                 IdMessage.From.GetNamePath
            end;
        flag:= true;
      end
      else ShowMessage('not read :' + IntToStr(i));

      if flag then
      begin
        // IdPOP3.Delete(i); //удаление письма
      end;
    end;
  finally
    IdPOP3.Disconnect;
  end;
end;

end.
