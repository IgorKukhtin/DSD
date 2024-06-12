unit dsdTranslator;

interface

uses
  Windows, Messages, Forms, ActnList, Controls, Classes, dsdCommon, DB, DBClient, dsdDataSetDataLink;

type

  TdsdTranslator  = class;

  TdsdTranslator  = class(TdsdComponent)
  private
  protected
    FOnFormKeyDown : TKeyEvent;
    FOnFormCreate  : TNotifyEvent;
    procedure OnFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OnFormCreate(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // Переводит форму
    procedure TranslateForm;
  published
  end;

  procedure dsdInitFullTranslator;
  function dsdTranslatorInit : boolean;
  function dsdTranslatorFull : boolean;
  procedure dsdTranslateForm(Form : TForm);

  procedure Register;

implementation

uses ParentForm, Dialogs, Menus, SysUtils, RegularExpressions, dsdDB, TypInfo;


procedure Register;
begin
  RegisterComponents('DSDComponent', [TdsdTranslator]);
end;

type

  // Для перевода форм из базы данных
  TTranslatorForm = class(TObject)
  private
    FLanguage : Integer;
    FLanguageCount : Integer;
    FisLock_Ctrl_L_0 : boolean;
    FFullProject : Boolean;

    FTranslatorCDS : TClientDataSet;

  protected

    procedure InitTranslatorCDS;
    procedure UpdateLanguage(ALanguage : Integer);
    procedure TranslateStrProp(Instance: TObject; const PropName: string; ALanguageOld, ALanguageNew : Integer);
    function TranslateStr(AText: string; ALanguageOld, ALanguageNew : Integer) : String;
    procedure HandleMessages(var Msg: tMsg; var Handled: Boolean);
    procedure OnActiveFormChange(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AFullProject : Boolean = False);
    destructor Destroy; override;

    // Переводит форму
    procedure TranslateForm(Form : TForm; ALanguageOld, ALanguageNew : Integer);
    // Переводит проект новый язык и меняет его по умолчанию
    procedure TranslateProgramm(ALanguageNew : Integer);
    // Сохраняет все названия из формы в базу
    procedure SaveTranslateForm(Form : TForm);

    property Language : Integer read FLanguage;
    property LanguageCount : Integer read FLanguageCount;
    property FullProject : Boolean read FFullProject;
  end;

{ TTranslatorForm  }

constructor TTranslatorForm.Create(AFullProject : Boolean = False);
begin
  FTranslatorCDS := TClientDataSet.Create(Nil);
  FLanguage := 1;
  FLanguageCount := 0;
  InitTranslatorCDS;
  FFullProject := AFullProject;
  if FFullProject then
  begin
    Application.OnMessage := HandleMessages;
    Screen.OnActiveFormChange := OnActiveFormChange;
  end;
end;

destructor TTranslatorForm.Destroy;
begin
  FTranslatorCDS.Free;
  inherited;
end;

procedure TTranslatorForm.HandleMessages(var Msg: tMsg; var Handled: Boolean);
  var I : Integer;
begin
  if (Msg.Message = WM_KeyDown) then
  begin
    if (GetKeyState(VK_CONTROL) < 0) and (GetKeyState(ord('L')) < 0) then
    begin
      if GetKeyState(ord('0')) < 0 then
      begin
        if Assigned(Screen.ActiveForm) then SaveTranslateForm(Screen.ActiveForm);
        Handled := True;
      end else for I := 1 to LanguageCount do if GetKeyState(ord(IntToStr(I)[1])) < 0 then
      begin
        if FLanguage <> I then TranslateProgramm(I);
        Handled := True;
      end;
    end;
  end;
end;

procedure TTranslatorForm.OnActiveFormChange(Sender: TObject);
begin
  if Assigned(Screen.ActiveForm) then
    if not (Screen.ActiveForm is TParentForm) and (Screen.ActiveForm.Tag = 0) then
    begin
      TranslateForm(Screen.ActiveForm, 1, Language);
      Screen.ActiveForm.Tag := 1;
    end;
end;

  // Иницилизация датасета
procedure TTranslatorForm.InitTranslatorCDS;
  var sp: TdsdStoredProc;
       I : Integer;
begin

    // Получили язык
  sp := TdsdStoredProc.Create(Application);
  try
    sp.OutputType := otDataSet;
    sp.DataSet := FTranslatorCDS;
    sp.StoredProcName := 'gpGet_Object_User_Language';
    sp.Execute();
    if FTranslatorCDS.RecordCount > 0 then
    begin
      FLanguage := FTranslatorCDS.FieldByName('LanguageCode').AsInteger;
      FisLock_Ctrl_L_0 := FTranslatorCDS.FieldByName('isLock_Ctrl_L_0').AsBoolean
    end else FLanguage := 1;

      // Получили справочник
    sp.StoredProcName := 'gpSelect_Object_TranslateWord_list';
    sp.Execute();
  finally
    sp.Free;
  end;

    // Определили количество языков
  if FTranslatorCDS.Active then
  begin
    FLanguageCount := 0;
    for I := 0 to FTranslatorCDS.FieldCount - 1 do
      if Pos('value', FTranslatorCDS.Fields.Fields[I].FieldName) = 1 then Inc(FLanguageCount);

  end else FLanguageCount := 0;
end;

  // Сохраняет все названия из формы в базу
procedure TTranslatorForm.UpdateLanguage(ALanguage : Integer);
  var sp: TdsdStoredProc;
begin

  FLanguage := ALanguage;

    // Отправка названия в базу
  sp := TdsdStoredProc.Create(Application);
  try
    sp.OutputType := otResult;
    sp.DataSet := FTranslatorCDS;
    sp.StoredProcName := 'gpUpdate_Object_User_Language';
    sp.Params.AddParam('inLanguageCode ', ftInteger, ptInput, ALanguage);
    sp.Execute();
  finally

  end;

end;

  // Перевод текста
function TTranslatorForm.TranslateStr(AText: string; ALanguageOld, ALanguageNew : Integer) : String;
begin
  Result := AText;
  if ALanguageOld <> 1 then
  begin
      // переведем на русский
    if FTranslatorCDS.Locate('value' + IntToStr(ALanguageOld), AText, [loCaseInsensitive]) or
       FTranslatorCDS.Locate('value' + IntToStr(ALanguageOld), StringReplace(AText, '&', '', [rfReplaceAll]), [loCaseInsensitive]) then
    begin
      if FTranslatorCDS.FieldByName('value1').AsString <> '' then
        Result :=  FTranslatorCDS.FieldByName('value1').AsString;
    end;
      // если новый не русский переведем
    if ALanguageNew <> 1 then
    begin
      if FTranslatorCDS.Locate('value1', Result, [loCaseInsensitive]) then
      begin
        if FTranslatorCDS.FieldByName('value' + IntToStr(ALanguageNew)).AsString <> '' then
          Result :=  FTranslatorCDS.FieldByName('value' + IntToStr(ALanguageNew)).AsString;
      end;
    end;
  end else
  begin
    if FTranslatorCDS.Locate('value' + IntToStr(ALanguageOld), AText, [loCaseInsensitive]) then
    begin
      if FTranslatorCDS.FieldByName('value' + IntToStr(ALanguageNew)).AsString <> '' then
        Result :=  FTranslatorCDS.FieldByName('value' + IntToStr(ALanguageNew)).AsString;
    end;
  end;
end;

  // Перевод проперти
procedure TTranslatorForm.TranslateStrProp(Instance: TObject; const PropName: string; ALanguageOld, ALanguageNew : Integer);
  var S, Res : string;
begin
  try
    if not IsPublishedProp(Instance, PropName) then Exit;
    S := GetStrProp(Instance, PropName);
    if S = '' then Exit;
    Res := TranslateStr(S, ALanguageOld, ALanguageNew);
    if S <> Res then SetStrProp(Instance, PropName, Res);
  except
  end;
end;

 //  Перевод формы
procedure TTranslatorForm.TranslateForm(Form : TForm; ALanguageOld, ALanguageNew : Integer);
  var I : integer;
begin
  if (ALanguageOld < 1) or (ALanguageNew < 1) or (ALanguageNew > FLanguageCount) or (ALanguageOld = ALanguageNew) then Exit;

  if not FTranslatorCDS.Active then InitTranslatorCDS;

  Form.Caption := TranslateStr(Form.Caption, ALanguageOld, ALanguageNew);

  for I := 0 to Form.ComponentCount - 1 do
  begin
    TranslateStrProp(Form.Components[I], 'Caption', ALanguageOld, ALanguageNew);
    TranslateStrProp(Form.Components[I], 'Hint', ALanguageOld, ALanguageNew);
    TranslateStrProp(Form.Components[I], 'HeaderHint', ALanguageOld, ALanguageNew);
  end;
end;

  // Переводит проект новый язык и меняет его по умолчанию
procedure TTranslatorForm.TranslateProgramm(ALanguageNew : Integer);
  var I, J : Integer;
begin
  for I := 0 to Screen.FormCount - 1 do
    if not FFullProject then
    begin

      for J := 0 to Screen.Forms[I].ComponentCount - 1 do
        if Screen.Forms[I].Components[J] is TdsdTranslator then
        begin
          TranslateForm(Screen.Forms[I], FLanguage, ALanguageNew);
          Continue;
        end;
    end else TranslateForm(Screen.Forms[I], FLanguage, ALanguageNew);

  UpdateLanguage(ALanguageNew);
end;

  // Сохраняет все названия из формы в базу
procedure TTranslatorForm.SaveTranslateForm(Form : TForm);
  var sp: TdsdStoredProc;
      I : integer;

procedure spExecute(AText, AName, AProperties : string);
begin
  if (Trim(AText) <> '') and (Trim(AText) <> '-') and (AText <> AName) then
  begin
    sp.ParamByName('inValue').Value := AText;
    sp.ParamByName('inName').Value := AName + '.' + AProperties;
    sp.Execute();
  end;
end;

begin

  if FisLock_Ctrl_L_0 then Exit;
  if FLanguage <> 1 then
  begin
    ShowMessage('Для сохранения русского текста наду установить русский язык.');
    Exit;
  end;

  if not FTranslatorCDS.Active then InitTranslatorCDS;

    // Отправка названия в базу
  sp := TdsdStoredProc.Create(Application);
  sp.OutputType := otDataSet;
  sp.DataSet := FTranslatorCDS;
  sp.StoredProcName := 'gpInsert_Object_TranslateWord_fill';
  sp.Params.AddParam('inValue', ftString, ptInput, '');
  sp.Params.AddParam('inName', ftString, ptInput, '');
  if Form is TParentForm then
    sp.Params.AddParam('inFormName', ftString, ptInput, TParentForm(Form).FormClassName)
  else sp.Params.AddParam('inFormName', ftString, ptInput, Form.Name);

  try
    spExecute(Form.Caption, Form.Name, 'Caption');
    for I := 0 to Form.ComponentCount - 1 do
    begin
      if IsPublishedProp(Form.Components[I], 'Caption') then spExecute(GetStrProp(Form.Components[I], 'Caption'), Form.Components[I].Name, 'Caption');
      if IsPublishedProp(Form.Components[I], 'Hint') then spExecute(GetStrProp(Form.Components[I], 'Hint'), Form.Components[I].Name, 'Hint');
      if IsPublishedProp(Form.Components[I], 'HeaderHint') then spExecute(GetStrProp(Form.Components[I], 'HeaderHint'), Form.Components[I].Name, 'HeaderHint');
    end;
  finally
    sp.Free;
  end;
end;


var TranslatorForm : TTranslatorForm;

{ TdsdTranslator  }

constructor TdsdTranslator.Create(AOwner: TComponent);
begin
  inherited;
  if csDesigning in ComponentState then Exit;
  if not Assigned(TranslatorForm) then TranslatorForm := TTranslatorForm.Create;

  if (Owner is TForm) and not TranslatorForm.FullProject then
  begin
    FOnFormKeyDown :=  TForm(Owner).OnKeyDown;
    TForm(Owner).OnKeyDown := OnFormKeyDown;
    if not (Owner is TParentForm) then
    begin
      FOnFormCreate := TForm(Owner).OnCreate;
      TForm(Owner).OnCreate := OnFormCreate;
    end;
    if not TForm(Owner).KeyPreview then TForm(Owner).KeyPreview := True;
  end;
end;

destructor TdsdTranslator.Destroy;
begin
  inherited;
end;

procedure TdsdTranslator.OnFormCreate(Sender: TObject);
begin
  if Owner is TForm then TranslatorForm.TranslateForm(TForm(Owner), 1, TranslatorForm.Language);
  if Assigned (FOnFormCreate) then FOnFormCreate(Sender);
end;

procedure TdsdTranslator.OnFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  var I : integer;
begin

  if (Shift = [ssCtrl]) and (GetKeyState(ord('L')) < 0) and Assigned(TranslatorForm) then
  begin
    if GetKeyState(ord('0')) < 0 then
    begin
      if Owner is TForm then TranslatorForm.SaveTranslateForm(TForm(Owner));
    end else for I := 1 to TranslatorForm.LanguageCount do if GetKeyState(ord(IntToStr(I)[1])) < 0 then
    begin
      if TranslatorForm.Language <> I then  TranslatorForm.TranslateProgramm(I);
    end;
  end;

  if Assigned (FOnFormKeyDown) then FOnFormKeyDown(Sender, Key, Shift);
end;

procedure TdsdTranslator.TranslateForm;
begin
  if (Owner is TForm) and Assigned(TranslatorForm) then TranslatorForm.TranslateForm(TForm(Owner), 1, TranslatorForm.Language);
end;


procedure dsdInitFullTranslator;
begin
  if not Assigned(TranslatorForm) then TranslatorForm := TTranslatorForm.Create(True);
end;

function dsdTranslatorInit : boolean;
begin
  Result := Assigned(TranslatorForm);
end;

function dsdTranslatorFull : boolean;
begin
  Result := Assigned(TranslatorForm) and TranslatorForm.FullProject;
end;

procedure dsdTranslateForm(Form : TForm);
begin
  if Assigned(TranslatorForm) then TranslatorForm.TranslateForm(Form, 1, TranslatorForm.Language);
end;


initialization

  TranslatorForm := Nil;

finalization

  if Assigned(TranslatorForm) then FreeAndNil(TranslatorForm);

end.
