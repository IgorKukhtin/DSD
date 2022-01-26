unit PUSHMessage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMemo, cxPropertiesStore, dsdAddOn;

type
  TPUSHMessageForm = class(TForm)
    bbCancel: TcxButton;
    bbOk: TcxButton;
    Memo: TcxMemo;
    pn2: TPanel;
    pn1: TPanel;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    cxPropertiesStore: TcxPropertiesStore;
    FontDialog: TFontDialog;
    ColorDialog: TColorDialog;
    PopupMenu: TPopupMenu;
    pmSelectAll: TMenuItem;
    N1: TMenuItem;
    pmColorDialog: TMenuItem;
    pmFontDialog: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure pmSelectAllClick(Sender: TObject);
    procedure pmColorDialogClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pmFontDialogClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function ShowPUSHMessage(AMessage : string; DlgType: TMsgDlgType = mtInformation) : boolean;

implementation

{$R *.dfm}

procedure TPUSHMessageForm.FormCreate(Sender: TObject);
begin
  UserSettingsStorageAddOn.LoadUserSettings;
  Memo.Style.Font.Size := Memo.Style.Font.Size + 4;
end;

procedure TPUSHMessageForm.FormDestroy(Sender: TObject);
begin
  Memo.Style.Font.Size := Memo.Style.Font.Size - 4;
  UserSettingsStorageAddOn.SaveUserSettings;
end;

procedure TPUSHMessageForm.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then ModalResult := mrOk;
end;

procedure TPUSHMessageForm.pmColorDialogClick(Sender: TObject);
begin
  ColorDialog.Color := Memo.Style.Color;
  if ColorDialog.Execute then Memo.Style.Color := ColorDialog.Color;
end;

procedure TPUSHMessageForm.pmFontDialogClick(Sender: TObject);
begin
  FontDialog.Font := Memo.Style.Font;
  FontDialog.Font.Color := Memo.Style.TextColor;
  if FontDialog.Execute then
  begin
    Memo.Style.Font := FontDialog.Font;
    Memo.Style.TextColor := FontDialog.Font.Color;
  end;
end;

procedure TPUSHMessageForm.pmSelectAllClick(Sender: TObject);
begin
  Memo.SelectAll;
end;

function ShowPUSHMessage(AMessage : string; DlgType: TMsgDlgType = mtInformation) : boolean;
  var PUSHMessageForm : TPUSHMessageForm;
begin
  PUSHMessageForm := TPUSHMessageForm.Create(Screen.ActiveControl);
  try
    PUSHMessageForm.Memo.Lines.Text := AMessage;
    case DlgType of
      mtWarning : PUSHMessageForm.Caption := '��������������';
      mtError : begin
                  PUSHMessageForm.Caption := '������';
                  PUSHMessageForm.Memo.Style.TextColor := clRed;
                end;
      mtInformation : PUSHMessageForm.Caption := '���������';
      mtConfirmation : PUSHMessageForm.Caption := '�������������';
    end;
    Result := PUSHMessageForm.ShowModal = mrOk;
  finally
    PUSHMessageForm.Free;
  end;
end;

end.
