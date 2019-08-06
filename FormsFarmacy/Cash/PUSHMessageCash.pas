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
    btOpenForm: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btOpenFormClick(Sender: TObject);
  private
    { Private declarations }
    FFormName : string;
    FParams : string;
    FTypeParams : string;
    FValueParams : string;
  public
    { Public declarations }
  end;

  function ShowPUSHMessageCash(AMessage : string;
                               AFormName : string = '';
                               AButton : string = '';
                               AParams : string = '';
                               ATypeParams : string = '';
                               AValueParams : string = '') : boolean;

implementation

{$R *.dfm}

uses DB, dsdAction, RegularExpressions, TypInfo;

procedure OpenForm(AFormName, AParams, ATypeParams, AValueParams : string);
  var actOF: TdsdOpenForm; I : Integer; Value : Variant;
      arValue, arParams, arTypeParams, arValueParams: TArray<string>;
begin
  actOF := TdsdOpenForm.Create(Nil);
  try
    actOF.FormNameParam.Value := AFormName;
    arParams := TRegEx.Split(AParams, ',');
    arTypeParams := TRegEx.Split(ATypeParams, ',');
    arValueParams := TRegEx.Split(AValueParams, ',');
    for I := 0 to High(arParams) do
    begin
      if (High(arTypeParams) < I) or (High(arValueParams) < I) then Break;
      Value := arValueParams[I];
      case TFieldType(GetEnumValue(TypeInfo(TFieldType), arTypeParams[I])) of
        ftDateTime : begin
                       arValue := TRegEx.Split(Value, '-');
                       if High(arValue) = 2 then
                         Value := EncodeDate(StrToInt(arValue[0]), StrToInt(arValue[1]), StrToInt(arValue[2]))
                       else Value := Date;
                     end;
        ftFloat : Value := StringReplace(Value, '.', FormatSettings.DecimalSeparator, [rfReplaceAll]);
      end;
      actOF.GuiParams.AddParam(arParams[I], TFieldType(GetEnumValue(TypeInfo(TFieldType), arTypeParams[I])), ptInput, Value);
    end;
    actOF.Execute;
  finally
    actOF.Free;
  end;
end;


procedure TPUSHMessageCashForm.btOpenFormClick(Sender: TObject);
begin
  OpenForm(FFormName, FParams, FTypeParams, FValueParams);
  ModalResult := mrOk;
end;

procedure TPUSHMessageCashForm.FormCreate(Sender: TObject);
begin
  Memo.Style.Font.Size := Memo.Style.Font.Size + 4;
end;

procedure TPUSHMessageCashForm.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then ModalResult := mrOk;
end;

function ShowPUSHMessageCash(AMessage : string;
                             AFormName : string = '';
                             AButton : string = '';
                             AParams : string = '';
                             ATypeParams : string = '';
                             AValueParams : string = '') : boolean;
  var PUSHMessageCashForm : TPUSHMessageCashForm;
begin

  if AMessage = '' then
  begin
    OpenForm(AFormName, AParams, ATypeParams, AValueParams);
    Result := True;
    Exit
  end;

  PUSHMessageCashForm := TPUSHMessageCashForm.Create(Screen.ActiveControl);
  try
    PUSHMessageCashForm.Memo.Lines.Text := AMessage;
    PUSHMessageCashForm.FFormName := AFormName;
    PUSHMessageCashForm.FParams := AParams;
    PUSHMessageCashForm.FTypeParams := ATypeParams;
    PUSHMessageCashForm.FValueParams := AValueParams;

    if AButton <> '' then
    begin
      PUSHMessageCashForm.btOpenForm.Width := PUSHMessageCashForm.btOpenForm.Width -
        PUSHMessageCashForm.Canvas.TextWidth(PUSHMessageCashForm.btOpenForm.Caption) +
        PUSHMessageCashForm.Canvas.TextWidth(AButton);
      PUSHMessageCashForm.btOpenForm.Caption := AButton;
      PUSHMessageCashForm.btOpenForm.Visible := True;
    end else PUSHMessageCashForm.btOpenForm.Visible := False;

    Result := PUSHMessageCashForm.ShowModal = mrOk;
  finally
    PUSHMessageCashForm.Free;
  end;
end;

end.
