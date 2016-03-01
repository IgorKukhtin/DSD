unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, IdMessage,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdPOP3;

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
  i: integer;
  flag: boolean;
  msgcnt: integer;
begin
     with IdPOP3 do begin
        Host:= 'pop.ua.fm';
        UserName:= 'Ashtu777@ua.fm';
        Password:= 'qsxqsxw1';
        Port:= 110;
     end;

  IdPOP3.Connect;

  try
    msgcnt:= IdPOP3.CheckMessages;
    // ShowMessage (IntToStr(msgcnt));
    for I:= msgcnt downto 1 do
    begin
      IdMessage.Clear; // очистка буфера дл€ сообщени€
      flag:= false;

      if (IdPOP3.Retrieve(i, IdMessage)) then
      begin
        ShowMessage(IdMessage.From.Address + ' : ' + IdMessage.Subject + ' : ' + IdMessage.MessageParts[1].FileName);
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
