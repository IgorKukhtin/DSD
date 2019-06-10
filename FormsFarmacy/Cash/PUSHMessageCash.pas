unit PUSHMessageCash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMemo;

type
  TPUSHMessageCashForm = class(TForm)
    bbCancel: TcxButton;
    bbOk: TcxButton;
    Memo: TcxMemo;
    pn2: TPanel;
    pn1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function ShowPUSHMessageCash(AMessage : string) : boolean;

implementation

{$R *.dfm}

procedure TPUSHMessageCashForm.FormCreate(Sender: TObject);
begin
  Memo.Style.Font.Size := Memo.Style.Font.Size + 4;
end;

procedure TPUSHMessageCashForm.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then ModalResult := mrOk;
end;

function ShowPUSHMessageCash(AMessage : string) : boolean;
  var PUSHMessageCashForm : TPUSHMessageCashForm;
begin
  PUSHMessageCashForm := TPUSHMessageCashForm.Create(Screen.ActiveControl);
  try
    PUSHMessageCashForm.Memo.Lines.Text := AMessage;
    Result := PUSHMessageCashForm.ShowModal = mrOk;
  finally
    PUSHMessageCashForm.Free;
  end;
end;

end.
