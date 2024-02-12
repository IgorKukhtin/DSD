{
   Описание:
   Файл содержит форму TMessagesForm.



   История изменений:

   Автор         Дата создания
   Кухтин И.В.      12.07.2002
   Изменял          Дата модификации
   Кухтин И.В.      26.07.2002   - добавлена возможность обрабатывать сообщения о ошибках и переводить их

}
{$J+} {параметр компилятора, позволяющий менять типизированные константы}
unit MessagesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ActnList, Grids;

type

  TMessagesForm = class(TForm)
    meFullMessage: TMemo;
    paButtons: TPanel;
    btnOk: TBitBtn;
    btnDetails: TButton;
    ActionList: TActionList;
    actExit: TAction;
    rlError: TLabel;
    procedure btnDetailsClick(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    fFullMessage: string;
    m_stMessagePassword: string;
  public
    { Public declarations }
    procedure Execute(const inMessage, inFullMessage: string; ShowFullInfo: boolean = false);
  end;



implementation
uses UtilConst;
const c_Password = '111';
      c_PasswordItem = '1';
      c_ShowFullInfo : boolean = false;
      c_DefaultMessage = 'Ошибка. Обратитесь к разработчику';

{$R *.dfm}
{--------------------------------------------------------------------------------------------------}
procedure TMessagesForm.btnDetailsClick(Sender: TObject);
begin
  btnDetails.Visible:=true;
  meFullMessage.Visible := not meFullMessage.Visible;
  if meFullMessage.Visible then begin
    Height := Height + meFullMessage.Height;
    TButton(Sender).Caption := '<< Сжато';
  end else begin
    Height := Height - meFullMessage.Height;
    TButton(Sender).Caption := 'Подробно >>';
  end;
end;
{--------------------------------------------------------------------------------------------------}
procedure TMessagesForm.Execute(const inMessage, inFullMessage: string; ShowFullInfo: boolean = false);
begin
  m_stMessagePassword:='';
  fFullMessage:=inFullMessage;
  try
    meFullMessage.Lines.Text := Copy(inFullMessage, 1, 4096);
  except
  end;
  if trim(inMessage)<>'' then
     rlError.Caption := Copy(inMessage, 1, 4096)
  else begin
     with rlError.Font do begin
       Color:= clRed;
       Style:= [fsBold];
     end;
     rlError.Caption := c_DefaultMessage;
  end;
  meFullMessage.Visible := false;
  Height := Height - meFullMessage.Height;
  btnDetails.Caption := 'Подробно >>';
  btnDetails.Visible := ShowFullInfo;
  if btnDetails.Visible then
     btnDetailsClick(btnDetails);
  ShowModal;
end;
{--------------------------------------------------------------------------------------------------}
procedure TMessagesForm.actExitExecute(Sender: TObject);
begin
  Close;
end;
{--------------------------------------------------------------------------------------------------}
procedure TMessagesForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;
end;
{--------------------------------------------------------------------------------------------------}
procedure TMessagesForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=c_PasswordItem then
     m_stMessagePassword:=m_stMessagePassword+Key
  else
     m_stMessagePassword:='';
  if m_stMessagePassword=c_Password then
     btnDetailsClick(nil);
end;

initialization

end.
