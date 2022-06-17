unit PUSHMessageCash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMemo, dsdAddOn, cxClasses, cxPropertiesStore;

type
  TPUSHMessageCashForm = class(TForm)
    bbCancel: TcxButton;
    bbOk: TcxButton;
    Memo: TcxMemo;
    pn2: TPanel;
    pn1: TPanel;
    btOpenForm: TcxButton;
    bbYes: TcxButton;
    bbNo: TcxButton;
    PopupMenu: TPopupMenu;
    pmSelectAll: TMenuItem;
    N1: TMenuItem;
    pmColorDialog: TMenuItem;
    pmFontDialog: TMenuItem;
    ColorDialog: TColorDialog;
    FontDialog: TFontDialog;
    cxPropertiesStore: TcxPropertiesStore;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    procedure FormCreate(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btOpenFormClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pmSelectAllClick(Sender: TObject);
    procedure pmColorDialogClick(Sender: TObject);
    procedure pmFontDialogClick(Sender: TObject);
  private
    { Private declarations }
    FPoll : boolean;
    FFormName : string;
    FParams : string;
    FTypeParams : string;
    FValueParams : string;
    FFormLoad : Boolean;
    FExecStoredProc : Boolean;
    FSpecialLighting : Boolean;
  public
    { Public declarations }
  end;

  function ShowPUSHMessageCash(AMessage : string;
                               var AResult : string;
                               APoll : boolean = False;
                               AFormName : string = '';
                               AButton : string = '';
                               AParams : string = '';
                               ATypeParams : string = '';
                               AValueParams : string = '';
                               AFormLoad : Boolean = False;
                               AExecStoredProc : Boolean = False;
                               ASpecialLighting : Boolean = False;
                               ATextColor : Integer = clWindowText;
                               AColor : Integer = clCream;
                               ABold : Boolean = False) : boolean;

procedure OpenForm(AFormName, AParams, ATypeParams, AValueParams : string);
procedure OpenStaticForm(AFormName, AParams, ATypeParams, AValueParams : string);
procedure ExecStoredProc (AFormName, AParams, ATypeParams, AValueParams : string);

implementation

{$R *.dfm}

uses DB, dsdAction, dsdDB, RegularExpressions, TypInfo;

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

procedure OpenStaticForm(AFormName, AParams, ATypeParams, AValueParams : string);
  var actOF: TdsdOpenStaticForm; I : Integer; Value : Variant;
      arValue, arParams, arTypeParams, arValueParams: TArray<string>;
begin
  actOF := TdsdOpenStaticForm.Create(Nil);
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

procedure ExecStoredProc (AFormName, AParams, ATypeParams, AValueParams : string);
  var spESP: TdsdStoredProc; I : Integer; Value : Variant;
      arValue, arParams, arTypeParams, arValueParams: TArray<string>;
begin
  spESP := TdsdStoredProc.Create(Nil);
  try
    spESP.StoredProcName := AFormName;
    spESP.OutputType := otResult;
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
      spESP.Params.AddParam(arParams[I], TFieldType(GetEnumValue(TypeInfo(TFieldType), arTypeParams[I])), ptInput, Value);
    end;
    spESP.Execute;
  finally
    spESP.Free;
  end;
end;

procedure TPUSHMessageCashForm.btOpenFormClick(Sender: TObject);
begin
  if FExecStoredProc then ExecStoredProc(FFormName, FParams, FTypeParams, FValueParams)
  else if FFormLoad then OpenForm(FFormName, FParams, FTypeParams, FValueParams)
  else OpenStaticForm(FFormName, FParams, FTypeParams, FValueParams);
  ModalResult := mrOk;
end;

procedure TPUSHMessageCashForm.FormCreate(Sender: TObject);
begin
  UserSettingsStorageAddOn.LoadUserSettings;
  Memo.Style.Font.Size := Memo.Style.Font.Size + 4;
end;

procedure TPUSHMessageCashForm.FormDestroy(Sender: TObject);
begin
  if not FSpecialLighting then
  begin
    Memo.Style.Font.Size := Memo.Style.Font.Size - 4;
    UserSettingsStorageAddOn.SaveUserSettings;
  end;
end;

procedure TPUSHMessageCashForm.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_Return) and not FPoll then ModalResult := mrOk;
end;

procedure TPUSHMessageCashForm.pmColorDialogClick(Sender: TObject);
begin
  ColorDialog.Color := Memo.Style.Color;
  if ColorDialog.Execute then Memo.Style.Color := ColorDialog.Color;
end;

procedure TPUSHMessageCashForm.pmFontDialogClick(Sender: TObject);
begin
  FontDialog.Font := Memo.Style.Font;
  FontDialog.Font.Color := Memo.Style.TextColor;
  if FontDialog.Execute then
  begin
    Memo.Style.Font := FontDialog.Font;
    Memo.Style.TextColor := FontDialog.Font.Color;
  end;
end;

procedure TPUSHMessageCashForm.pmSelectAllClick(Sender: TObject);
begin
  Memo.SelectAll;
end;

function ShowPUSHMessageCash(AMessage : string;
                             var AResult : string;
                             APoll : boolean = False;
                             AFormName : string = '';
                             AButton : string = '';
                             AParams : string = '';
                             ATypeParams : string = '';
                             AValueParams : string = '';
                             AFormLoad : Boolean = False;
                             AExecStoredProc : Boolean = False;
                             ASpecialLighting : Boolean = False;
                             ATextColor : Integer = clWindowText;
                             AColor : Integer = clCream;
                             ABold : Boolean = False) : boolean;
  var PUSHMessageCashForm : TPUSHMessageCashForm;
begin

  AResult := '';
  if AMessage = '' then
  begin
    if AExecStoredProc then ExecStoredProc(AFormName, AParams, ATypeParams, AValueParams)
    else if AFormLoad then OpenForm(AFormName, AParams, ATypeParams, AValueParams)
    else OpenStaticForm(AFormName, AParams, ATypeParams, AValueParams);
    Result := True;
    Exit
  end;

  PUSHMessageCashForm := TPUSHMessageCashForm.Create(Screen.ActiveControl);
  try
    PUSHMessageCashForm.Memo.Lines.Text := AMessage;
    PUSHMessageCashForm.FPoll := APoll;
    PUSHMessageCashForm.FFormName := AFormName;
    PUSHMessageCashForm.FParams := AParams;
    PUSHMessageCashForm.FTypeParams := ATypeParams;
    PUSHMessageCashForm.FValueParams := AValueParams;
    PUSHMessageCashForm.FFormLoad := AFormLoad;
    PUSHMessageCashForm.FExecStoredProc := AExecStoredProc;

    PUSHMessageCashForm.FSpecialLighting := ASpecialLighting;

    if APoll then
    begin
      PUSHMessageCashForm.Caption := 'Опрос';
      PUSHMessageCashForm.bbOk.Visible := False;
      PUSHMessageCashForm.bbOk.Visible := False;
      PUSHMessageCashForm.bbCancel.Visible := False;
      PUSHMessageCashForm.bbCancel.Visible := False;
      PUSHMessageCashForm.bbCancel.Cancel := False;
      PUSHMessageCashForm.bbYes.Visible := True;
      PUSHMessageCashForm.bbNo.Visible := True;
      PUSHMessageCashForm.Memo.Properties.Alignment := TAlignment.taCenter;
      PUSHMessageCashForm.Memo.Style.Font.Size := PUSHMessageCashForm.Memo.Style.Font.Size + 2;
    end;

    if AButton <> '' then
    begin
      PUSHMessageCashForm.btOpenForm.Width := PUSHMessageCashForm.btOpenForm.Width -
        PUSHMessageCashForm.Canvas.TextWidth(PUSHMessageCashForm.btOpenForm.Caption) +
        PUSHMessageCashForm.Canvas.TextWidth(AButton);
      PUSHMessageCashForm.btOpenForm.Caption := AButton;
      PUSHMessageCashForm.btOpenForm.Visible := True;
    end else PUSHMessageCashForm.btOpenForm.Visible := False;

    if ASpecialLighting then
    begin
      PUSHMessageCashForm.Memo.Style.Color := AColor;
      PUSHMessageCashForm.Memo.Style.TextColor := ATextColor;
      if ABold then PUSHMessageCashForm.Memo.Style.TextStyle := PUSHMessageCashForm.Memo.Style.TextStyle + [fsBold];
    end;

    case PUSHMessageCashForm.ShowModal of
      mrOk : Result := True;
      mrYes : begin Result := True; AResult := 'Да'; end;
      mrNo : begin Result := True; AResult := 'Нет'; end;
      else Result := False;
    end;
  finally
    PUSHMessageCashForm.Free;
  end;
end;

end.
