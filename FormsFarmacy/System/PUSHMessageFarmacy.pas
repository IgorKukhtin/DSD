unit PUSHMessageFarmacy;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMemo;

type
  TPUSHMessageFarmacyForm = class(TForm)
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

  function ShowPUSHMessageFarmacy(AMessage : string;
                               AFormName : string = '';
                               AButton : string = '';
                               AParams : string = '';
                               ATypeParams : string = '';
                               AValueParams : string = '';
                               ABeep : Integer = 0) : boolean;

implementation

{$R *.dfm}

uses DB, dsdAction, RegularExpressions, TypInfo, dsdPlaySound;

procedure OpenForm(AFormName, AParams, ATypeParams, AValueParams : string);
  var actOF: TdsdOpenForm; I : Integer; Value : Variant;
      arValue, arParams, arTypeParams, arValueParams: TArray<string>;
begin
  actOF := TdsdOpenForm.Create(Nil);
  try
    actOF.FormNameParam.Value := AFormName;
    actOF.isShowModal := True;
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


procedure TPUSHMessageFarmacyForm.btOpenFormClick(Sender: TObject);
begin
  OpenForm(FFormName, FParams, FTypeParams, FValueParams);
  ModalResult := mrOk;
end;

procedure TPUSHMessageFarmacyForm.FormCreate(Sender: TObject);
begin
  Memo.Style.Font.Size := Memo.Style.Font.Size + 4;
end;

procedure TPUSHMessageFarmacyForm.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then ModalResult := mrOk;
end;

function ShowPUSHMessageFarmacy(AMessage : string;
                             AFormName : string = '';
                             AButton : string = '';
                             AParams : string = '';
                             ATypeParams : string = '';
                             AValueParams : string = '';
                             ABeep : Integer = 0) : boolean;
  var PUSHMessageFarmacyForm : TPUSHMessageFarmacyForm;
begin

  if ABeep = 1 then PlaySoundFile('Bell0001.wav');

  if AMessage = '' then
  begin
    OpenForm(AFormName, AParams, ATypeParams, AValueParams);
    Result := True;
    Exit
  end;

  PUSHMessageFarmacyForm := TPUSHMessageFarmacyForm.Create(Screen.ActiveControl);
  try
    PUSHMessageFarmacyForm.Memo.Lines.Text := AMessage;
    PUSHMessageFarmacyForm.FFormName := AFormName;
    PUSHMessageFarmacyForm.FParams := AParams;
    PUSHMessageFarmacyForm.FTypeParams := ATypeParams;
    PUSHMessageFarmacyForm.FValueParams := AValueParams;

    if AButton <> '' then
    begin
      PUSHMessageFarmacyForm.btOpenForm.Width := PUSHMessageFarmacyForm.btOpenForm.Width -
        PUSHMessageFarmacyForm.Canvas.TextWidth(PUSHMessageFarmacyForm.btOpenForm.Caption) +
        PUSHMessageFarmacyForm.Canvas.TextWidth(AButton);
      PUSHMessageFarmacyForm.btOpenForm.Caption := AButton;
      PUSHMessageFarmacyForm.btOpenForm.Visible := True;
    end else PUSHMessageFarmacyForm.btOpenForm.Visible := False;

    Result := PUSHMessageFarmacyForm.ShowModal = mrOk;
  finally
    PUSHMessageFarmacyForm.Free;
  end;
end;

end.
