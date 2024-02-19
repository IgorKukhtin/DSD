{
   ��������:
   ���� �������� ����� TMessagesForm.



   ������� ���������:

   �����         ���� ��������
   ������ �.�.      12.07.2002
   �������          ���� �����������
   ������ �.�.      26.07.2002   - ��������� ����������� ������������ ��������� � ������� � ���������� ��

}
{$J+} {�������� �����������, ����������� ������ �������������� ���������}
unit MessagesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ActnList, Grids, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel;

type

  TMessagesForm = class(TForm)
    meFullMessage: TMemo;
    paButtons: TPanel;
    btnOk: TBitBtn;
    btnDetails: TButton;
    ActionList: TActionList;
    actExit: TAction;
    rlError: TcxLabel;
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
      c_DefaultMessage = '������. ���������� � ������������';

{$R *.dfm}
{--------------------------------------------------------------------------------------------------}
procedure TMessagesForm.btnDetailsClick(Sender: TObject);
begin
  btnDetails.Visible:=true;
  meFullMessage.Visible := not meFullMessage.Visible;
  if meFullMessage.Visible then begin
    Height := Height + meFullMessage.Height;
    TButton(Sender).Caption := '<< �����';
  end else begin
    Height := Height - meFullMessage.Height;
    TButton(Sender).Caption := '�������� >>';
  end;
end;
{--------------------------------------------------------------------------------------------------}
procedure TMessagesForm.Execute(const inMessage, inFullMessage: string; ShowFullInfo: boolean = false);
  var List: TStringList;
begin
  m_stMessagePassword:='';
  fFullMessage:=inFullMessage;
  try
    meFullMessage.Lines.Text := Copy(inFullMessage, 1, 4096);
    List := TStringList.Create;
    try
      List.Text := meFullMessage.Lines.Text;
      if List.Count > 10 then rlError.Properties.Alignment.Vert := taTopJustify;
    finally
      List.Free;
    end;
  except
  end;
  if trim(inMessage)<>''then
  begin
     rlError.Caption := Copy(inMessage, 1, 4096)
  end else begin
     with rlError.Style.Font do begin
       Color:= clRed;
       Style:= [fsBold];
     end;
     rlError.Caption := c_DefaultMessage;
  end;
  meFullMessage.Visible := false;
  Height := Height - meFullMessage.Height;
  btnDetails.Caption := '�������� >>';
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
