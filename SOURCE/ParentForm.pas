unit ParentForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.ActnList, Vcl.Forms,
  Vcl.Dialogs, dsdDB, cxPropertiesStore, frxClass, dsdAddOn, cxEdit,
  cxGridCustomTableView;

const
  MY_MESSAGE = WM_USER + 1;
type

  TParentForm = class(TForm)
  private
    // Класс, который вызвал данную форму
    FSender: TComponent;
    FFormClassName: string;
    FonAfterShow: TNotifyEvent;
    FisAlreadyOpen: boolean;
    FAddOnFormData: TAddOnFormData;
    FNeedRefreshOnExecute: boolean;
    FNoHelpFile: Boolean;
    FcxEditRepository: TcxEditRepository;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
    procedure SetSender(const Value: TComponent);
    property FormSender: TComponent read FSender write SetSender;
    procedure AfterShow(var a : TWMSHOWWINDOW); message MY_MESSAGE;
    procedure InitHelpSystem;
    procedure InitcxEditRepository;
    procedure InitcxView;
    procedure InitBooleanSetVisible;
    procedure btnHelpClick(Sender: TObject);
    procedure btnLoadUserSettings(Sender: TObject);
    procedure btnSaveUserSettings(Sender: TObject);
    procedure btnDubleForm(Sender: TObject);
    procedure cxGridDBTableViewTextGetProperties(
      Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
      var AProperties: TcxCustomEditProperties);
  protected
    procedure FormClose(Sender: TObject; var Action: TCloseAction); virtual;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Activate; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute(Sender: TComponent; Params: TdsdParams; isNotExecuteDialog : Boolean = False): boolean;
    procedure CloseAction(Sender: TObject);
    property FormClassName: string read FFormClassName write FFormClassName;
    property onAfterShow: TNotifyEvent read FonAfterShow write FonAfterShow;
    // проперти устанавливается в компоненте TRefreshDispatcher если форма не видима, но было изменение значений для изменения запроса
    property NeedRefreshOnExecute: boolean read FNeedRefreshOnExecute write FNeedRefreshOnExecute;
    property isAlreadyOpen: Boolean read FisAlreadyOpen write FisAlreadyOpen;
  published
    property AddOnFormData: TAddOnFormData read FAddOnFormData write FAddOnFormData;
  end;

  // Функция перевода формы
  procedure TranslateForm(Form : TForm);

implementation

uses
  cxControls, cxContainer, UtilConst,
  cxGroupBox, dxBevel, cxButtons, cxGridDBTableView, cxGrid, DB, DBClient,
  dxBar, cxTextEdit, cxLabel, StdActns, cxDBTL, cxCurrencyEdit, cxDropDownEdit,
  cxDBLookupComboBox, DBGrids, cxCheckBox, cxCalendar, ExtCtrls,
  cxButtonEdit, cxSplitter, Vcl.Menus, cxPC, frxDBSet, dxBarExtItems,
  cxDBPivotGrid, ChoicePeriod, cxGridDBBandedTableView, cxDateNavigator,
  cxDBEdit, dsdAction, dsdGuides, cxDBVGrid, cxDBLabel, cxBlobEdit, cxMaskEdit,
  Vcl.DBActns, cxMemo, cxGridDBChartView, ShellAPI, CommonData,
  SHDocVw, GMClasses, GMMap, GMMapVCL, GMLinkedComponents,
  GMMarker, GMMarkerVCL, GMGeoCode, GMDirection, GMDirectionVCL, cxImage,
  cxEditRepositoryItems, cxStyles, dsdPivotGrid, dsdExportToXLSAction,
  dsdTranslator, dsdExportToXMLAction, StrUtils, cxCheckListBox;

{$R *.dfm}

type

  // Для перевода форм
  TLocalizerForm = class(TObject)
  private
    FName : String;
    FLocale : Integer;

    FValue: TStringList;
    FTransfer: TStringList;

  protected
  public
    { Public declarations }
    constructor Create(AName : String; ALocale : Integer);
    destructor Destroy; override;

    procedure AddTransfer(AValue, ATransfer : string);
    function Transfer(AValue : string; ComponentName : string) : string;

    property Name : String read FName;
    property Locale : Integer read FLocale;
  end;

constructor TLocalizerForm.Create(AName : String; ALocale : Integer);
begin
  FName := AName;
  FLocale := ALocale;
  FValue := TStringList.Create;
  FValue.Sorted := True;
  FTransfer := TStringList.Create;
end;

destructor TLocalizerForm.Destroy;
begin
  FValue.Free;
  FTransfer.Free;
  inherited;
end;

procedure TLocalizerForm.AddTransfer(AValue, ATransfer : string);
  var I : integer;
begin
  if not FValue.Find(AValue, I) then
    FValue.AddObject(AValue, TObject(FTransfer.Add(ATransfer)));
end;

function TLocalizerForm.Transfer(AValue : string; ComponentName : string) : string;
  var I : integer;
begin
  if FValue.Find(AValue, I) then
    Result := FTransfer.Strings[Integer(FValue.Objects[I])]
  else if ComponentName <> ''
       then
          Result := ComponentName
       else
          Result := AValue;
end;

var LocalizerForm : TLocalizerForm;

procedure InitLocalizer;
  var cFile, cValue, cTransfer : string; I, nLocale : integer;
      sINI : TStringList;
begin
  LocalizerForm := Nil;
  cFile := ChangeFileExt(Application.exeName, '.LNG');
  if not FileExists(cFile) then Exit;
  sINI := TStringList.Create;
  try
    sINI.LoadFromFile(cFile);
    if sINI.Count < 3 then Exit;
    if Pos(LowerCase('codepage='), LowerCase(sINI.Strings[1])) <> 1 then Exit;
    if not TryStrToInt(Copy(sINI.Strings[1], 10, Length(sINI.Strings[1])), nLocale) then Exit;
    LocalizerForm := TLocalizerForm.Create(sINI.Strings[0], nLocale);

    for I := 2 to sINI.Count - 1 do
    begin
      if Pos(LowerCase('"="'), LowerCase(sINI.Strings[I])) <= 1 then Continue;

      cValue := Copy(sINI.Strings[I], 2, Pos(LowerCase('"="'), LowerCase(sINI.Strings[I])) - 2);
      cTransfer := Copy(sINI.Strings[I], Pos(LowerCase('"="'), LowerCase(sINI.Strings[I])) + 3, Length(sINI.Strings[I]));
      SetLength(cTransfer, Length(cTransfer) - 1);
      LocalizerForm.AddTransfer(cValue, cTransfer);
    end;

  finally
    sINI.Free;
  end;

end;

procedure DestroyLocalizer;
begin
  if Assigned(LocalizerForm) then FreeAndNil(LocalizerForm);
end;

  // Функция перевода формы
procedure TranslateForm(Form : TForm);
  var I : Integer;
  lRes:String;
begin
  if not Assigned(LocalizerForm) then Exit;
  //
  lRes:= ReplaceStr(Form.Name,'Form_2','');
  lRes:= ReplaceStr(lRes,'Form','');
  Form.Caption := LocalizerForm.Transfer(Form.Caption, lRes);
  //
  for I := 0 to Form.ComponentCount - 1 do
    if Form.Components[I] is TcxLabel then
    begin
      if Length(TcxLabel(Form.Components[I]).Name) <= 10 then lRes:=''
      else begin
        lRes:= ReplaceStr(Form.Components[I].Name,'cxLabel','');
        lRes:= ReplaceStr(lRes,'Label','');
      end;
      TcxLabel(Form.Components[I]).Caption := LocalizerForm.Transfer(TcxLabel(Form.Components[I]).Caption,lRes)
    end
    else if Form.Components[I] is TcxButton then
    begin
      if Length(TcxLabel(Form.Components[I]).Name) <= 10 then lRes:=''
      else begin
        lRes:= ReplaceStr(Form.Components[I].Name,'cxButton','');
        lRes:= ReplaceStr(lRes,'Button','');
        lRes:= ReplaceStr(lRes,'bb','');
      end;
      TcxButton(Form.Components[I]).Caption := LocalizerForm.Transfer(TcxButton(Form.Components[I]).Caption,lRes);
      TcxButton(Form.Components[I]).Hint := LocalizerForm.Transfer(TcxButton(Form.Components[I]).Hint,'');
    end
    else if Form.Components[I] is TdxBarButton then
    begin
      lRes:= ReplaceStr(Form.Components[I].Name,'dxButton','');
      lRes:= ReplaceStr(lRes,'Button','');
      lRes:= ReplaceStr(lRes,'bb','');
      TdxBarButton(Form.Components[I]).Hint := LocalizerForm.Transfer(TdxBarButton(Form.Components[I]).Hint,lRes);
    end
    else if Form.Components[I] is TCustomAction then
    begin
      lRes:= ReplaceStr(Form.Components[I].Name,'action','');
      lRes:= ReplaceStr(lRes,'act','');
      TCustomAction(Form.Components[I]).Caption := LocalizerForm.Transfer(TCustomAction(Form.Components[I]).Caption,lRes);
      TCustomAction(Form.Components[I]).Hint := LocalizerForm.Transfer(TCustomAction(Form.Components[I]).Hint,'');
    end
    else
    if Form.Components[I] is TMenuItem then
    begin
      if TMenuItem(Form.Components[I]).Caption = '-' then lRes:=''
      else begin
        lRes:= ReplaceStr(Form.Components[I].Name,'MenuItem','');
        lRes:= ReplaceStr(lRes,'mi','');
      end;
      if TMenuItem(Form.Components[I]).Action = nil then
      begin
        TMenuItem(Form.Components[I]).Caption := LocalizerForm.Transfer(TMenuItem(Form.Components[I]).Caption,lRes);
        TMenuItem(Form.Components[I]).Hint := LocalizerForm.Transfer(TMenuItem(Form.Components[I]).Hint,'');
      end;
    end
    else
    if Form.Components[I] is TcxCheckBox then
    begin
      lRes:= ReplaceStr(Form.Components[I].Name,'CheckBox','');
      lRes:= ReplaceStr(lRes,'cb','');
      TcxCheckBox(Form.Components[I]).Caption := LocalizerForm.Transfer(TcxCheckBox(Form.Components[I]).Caption,lRes);
      TcxCheckBox(Form.Components[I]).Hint := LocalizerForm.Transfer(TcxCheckBox(Form.Components[I]).Hint,'');
    end
    else
    if Form.Components[I] is TcxGridDBColumn then
    begin
      lRes:= ReplaceStr(Form.Components[I].Name,'GridDBColumn','');
      lRes:= ReplaceStr(lRes,'DBColumn','');
      TcxGridDBColumn(Form.Components[I]).Caption := LocalizerForm.Transfer(TcxGridDBColumn(Form.Components[I]).Caption,lRes);
      TcxGridDBColumn(Form.Components[I]).HeaderHint := LocalizerForm.Transfer(TcxGridDBColumn(Form.Components[I]).HeaderHint,'');
    end;
end;

procedure TParentForm.Activate;
begin
  inherited;
  if Assigned(AddOnFormData) then
    if Assigned(AddOnFormData.AddOnFormRefresh) then
      if AddOnFormData.AddOnFormRefresh.NeedRefresh then
        AddOnFormData.AddOnFormRefresh.RefreshRecord;
end;

procedure TParentForm.AfterShow(var a : TWMSHOWWINDOW);
begin
  if csDesigning in ComponentState then
     exit;
  if Assigned(FonAfterShow) then
     FonAfterShow(Self);
end;

procedure TParentForm.btnHelpClick(Sender: TObject);
begin
  if Self.HelpFile = '' then exit;
  ShellExecute(0, 'open', PChar(Self.HelpFile), '', '', 1);

end;

procedure TParentForm.btnLoadUserSettings(Sender: TObject);
  var i : integer;
begin
  if MessageDlg('Загрузить пользовательские настройки формы?',
     mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  // Загрузить пользовательских настроек формы
  for i := 0 to Self.ComponentCount - 1 do
      if Self.Components[i] is TdsdUserSettingsStorageAddOn then
      begin
         TdsdUserSettingsStorageAddOn(Self.Components[i]).LoadUserSettingsBack;
         Exit;
      end;
  ShowMessage('Форма не поддерживает сохранение пользовательских настроек.');
end;

procedure TParentForm.btnSaveUserSettings(Sender: TObject);
  var i, j : integer;
begin
  if MessageDlg('Сохранить пользовательские настройки формы?',
     mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  // Сохранение пользовательских настроек формы
  for i := 0 to Self.ComponentCount - 1 do
      if Self.Components[i] is TdsdUserSettingsStorageAddOn then
      begin
         TdsdUserSettingsStorageAddOn(Self.Components[i]).SaveUserSettingsBack;
         if Assigned(AddOnFormData.RefreshAction) then
         for j := 0 to Self.ComponentCount - 1 do
          begin
            if (Self.Components[J] is TCrossDBViewAddOn) or
               (Self.Components[J] is TCrossDBViewReportAddOn) then
            begin
              AddOnFormData.RefreshAction.Execute;
              Exit;
            end;
          end;
         Exit;
      end;
  ShowMessage('Форма не поддерживает сохранение пользовательских настроек.');
end;

procedure TParentForm.btnDubleForm(Sender: TObject);
begin
  ShowMessage('По дублю формы загрузка и востановление пользовательских настроек невозможна.');
end;

procedure TParentForm.CloseAction(Sender: TObject);
var FormAction: IFormAction;
begin
  // Вызывается событие на закрытие формы, например для справочников для перечитывания
  if Sender is TdsdInsertUpdateGuides then
     if Assigned(FormSender) then
        if FormSender.GetInterface(IFormAction, FormAction) then
           FormAction.OnFormClose(AddOnFormData.Params.Params);
end;

constructor TParentForm.Create(AOwner: TComponent);
begin
  FNeedRefreshOnExecute := false;
  FAddOnFormData := TAddOnFormData.Create;
  inherited;
  onClose := FormClose;
  onShow := FormShow;
  OnCloseQuery := FormCloseQuery;
  KeyPreview := true;
  FisAlreadyOpen := false;
  FNoHelpFile := False;
  FcxEditRepository := Nil;
end;

destructor TParentForm.Destroy;
begin
//  ShowMessage(Self.Name);
  if Assigned(FcxEditRepository) then FreeAndNil(FcxEditRepository);
  inherited;
end;

function TParentForm.Execute(Sender: TComponent; Params: TdsdParams; isNotExecuteDialog : Boolean = False): boolean;
begin
  try
    // то перечитывать ли ее каждый раз определяет флаг
    result := true;
    // Заполняет параметры формы переданными параметрами
    if Assigned(AddOnFormData.Params) then
       AddOnFormData.Params.Params.AssignParams(Params);
    // Если надо вызываем заполнение диалогом
    if Assigned(AddOnFormData.ExecuteDialogAction) and AddOnFormData.ExecuteDialogAction.OpenBeforeShow and not isNotExecuteDialog then begin
       AddOnFormData.ExecuteDialogAction.RefreshAllow := false; // Что бы не было двух перечитываний.
       result := AddOnFormData.ExecuteDialogAction.Execute;
    end;

    FormSender := Sender;
    // Если диалог был открыт нормально
    if result = true then
    begin
        // Если открыта первый раз и всегда перечитываем
        if (not FisAlreadyOpen) or AddOnFormData.isAlwaysRefresh or NeedRefreshOnExecute then
        begin
           // Перечитываем запросы
           if Assigned(AddOnFormData.RefreshAction) then
              AddOnFormData.RefreshAction.Execute;
           // Изменяем шапку формф если есть FormCaption
           if Assigned(AddOnFormData.Params) and Assigned(AddOnFormData.Params.ParamByName('FormCaption')) then
             Caption := AddOnFormData.Params.ParamByName('FormCaption').Value + ' <' + gc_User.Login + '>';
           // Изменяем шапку формф если есть FormCaption
           if Assigned(AddOnFormData.Params) and Assigned(AddOnFormData.Params.ParamByName('FormCaptionLeft')) then
             Caption := Caption + ' ' + AddOnFormData.Params.ParamByName('FormCaptionLeft').Value;
           // Выводим PUSH сообщение
           if Assigned(AddOnFormData.PUSHMessage) then
              AddOnFormData.PUSHMessage.Execute;
        end;

        // Устанавливаем фокус
        if Assigned(AddOnFormData.SetFocusedAction) then
           AddOnFormData.SetFocusedAction.Execute;
    end;
  finally
    FisAlreadyOpen := true;
    NeedRefreshOnExecute := false;
  end;
end;

procedure TParentForm.FormClose(Sender: TObject; var Action: TCloseAction);
var i: integer;
    DataSetList: TList;
begin
  inherited;
  DataSetList := TList.Create;
  try
    // Выводим PUSH сообщение
    if Assigned(AddOnFormData.ClosePUSHMessage) and (not (fsModal in Self.FormState) or (ModalResult in [mrOk, mrYes])) then
      AddOnFormData.ClosePUSHMessage.Execute;

    // Если данная форма не одиночка, то при закрытии надо проверить единственная она или нет
    // Если не единственная, то сделать ей Free
    if AddOnFormData.isFreeAtClosing then Action := caFree
    else if not AddOnFormData.isSingle then begin
       for i := 0 to ComponentCount - 1 do
           if Components[i] is TDataSet then
              DataSetList.Add(Components[i]);
       for i := 0 to DataSetList.Count - 1 do
           TDataSet(DataSetList[i]).Close;
       for i := 0 to Screen.FormCount - 1 do
           if (Screen.Forms[i] is TParentForm) then
              if Screen.Forms[i] <> Self then
                 if TParentForm(Screen.Forms[i]).FormClassName = Self.FormClassName then
                    Action := caFree;
    end;
  finally
    DataSetList.Free
  end;
end;

procedure TParentForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  // Нужно что бы вызать событие OnExit на последнем компоненте
  ActiveControl := nil;
  CanClose := not Assigned(ActiveControl);
end;

procedure TParentForm.FormShow(Sender: TObject);
begin
  PostMessage(Handle, MY_MESSAGE, 0, 0);
  if gc_CorrectPositionForms and
    (((Monitor.Top + Monitor.Height) < Self.Top) or
    ((Monitor.Left + Monitor.Width) < Self.Left) or
    ((Monitor.Top + Monitor.Height) > (Self.Top + Self.Height)) or
    ((Monitor.Left + Monitor.Width) > (Self.Left + Self.Width))) then
    MakeFullyVisible(Nil);
  InitHelpSystem;
  InitcxEditRepository;
  InitcxView;
  InitBooleanSetVisible;
end;

procedure TParentForm.InitHelpSystem;
var
  sp: TdsdStoredProc;
  C: TComponent;
  mni: TMenuItem;
  bb: TdxBarButton;
  pm: TPopupMenu;
begin
  //если хелпфайл заполнен, считаем что все уже отработано ранее
  if (Self.HelpFile <> '') or FNoHelpFile then exit;
  if gc_user.Local then exit;

  //Вытащили путь к файлу помощи
  sp := TdsdStoredProc.Create(nil);
  try
    sp.Params.AddParam('inFormName',ftString,ptInput,FormClassName);
    sp.Params.AddParam('outHelpFile',ftString,ptOutput,Null);
    sp.StoredProcName := 'gpGet_Object_Form_HelpFile';
    sp.OutputType := otResult;
    sp.Execute;
    Self.HelpFile := VarToStr(sp.ParamByName('outHelpFile').Value);
  finally
    sp.Free;
  end;
  //Если форма имеет файл помощи то пытаемся создать пункт меню для вызова
  if Self.HelpFile <> '' then
  Begin
    for C in Self do
    begin
      //Находим все контексные меню
      if C is TPopupMenu then
      Begin
        mni := TMenuItem.Create(C);
        mni.Caption := 'Помощь';
        mni.ShortCut := ShortCut(VK_F1,[]);
        mni.ImageIndex := 26;
        mni.OnClick := btnHelpClick;
        (C as TPopupMenu).Items.Add(mni);
      End;
    end;
    //Если не было создано ни одного пункта меню для вызова помощи (нет ни одного попап меню)
    if not assigned(mni) then
    Begin
//      //пробуем найти тулбар и в него добавить кнопку
//      for C in Self do
//      begin
//        //Находим все контексные меню
//        if C is TdxBarManager then
//        Begin
//          if (C as TdxBarManager).Bars.Count > 0 then
//          Begin
//            bb := (C as TdxBarManager).AddButton;
//            bb.Caption := 'Помощь';
//            bb.Hint := 'Помощь';
//            bb.ImageIndex := 26;
//            bb.ShortCut := ShortCut(VK_F1,[]);
//            bb.OnClick := btnHelpClick;
//            (C as TdxBarManager).Bars[0].ItemLinks.Add(bb);
//          End;
//        End;
//      end;
//      //Если и тулбара нет - то создаем свой попап меню и в него добавляем кнопку
//      if not assigned(bb) then
//      Begin
        pm := TPopupMenu.Create(Self);
//        pm.Images := dmMain.ImageList;
        Self.PopupMenu := pm;
        mni := TMenuItem.Create(pm);
        mni.Caption := 'Помощь';
        mni.ShortCut := ShortCut(VK_F1,[]);
        mni.ImageIndex := 26;
        mni.OnClick := btnHelpClick;
        pm.Items.Add(mni);
        for C in Self do
          //Находим гриды и им присваиваем наше контекстное меню
          if C is TcxGrid then
            (C as TcxGrid).PopupMenu := pm;
//      End;
    End;
  End
  else
    FNoHelpFile := True;

end;

procedure TParentForm.cxGridDBTableViewTextGetProperties(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AProperties: TcxCustomEditProperties);
begin
  AProperties := FcxEditRepository.Items[0].Properties;
end;

procedure TParentForm.InitcxEditRepository;
  var C: TComponent;
begin
  for C in Self do
  begin
    //Находим гриды и им присваиваем наше контекстное меню
    if C is TcxGridDBColumn then
      if (C as TcxGridDBColumn).Properties is TcxMemoProperties then
        if not Assigned((C as TcxGridDBColumn).OnGetProperties) then
    begin
      if not Assigned(FcxEditRepository) then
      begin
        FcxEditRepository := TcxEditRepository.Create(Self);
        FcxEditRepository.CreateItem(TcxEditRepositoryBlobItem);
        TcxEditRepositoryBlobItem(FcxEditRepository.Items[0]).Properties.BlobEditKind := bekMemo;
        TcxEditRepositoryBlobItem(FcxEditRepository.Items[0]).Properties.BlobPaintStyle := bpsText;
      end;

      (C as TcxGridDBColumn).OnGetProperties := cxGridDBTableViewTextGetProperties;
    end;

    if C is TcxGridDBBandedColumn then
        if (C as TcxGridDBBandedColumn).Properties is TcxMemoProperties then
          if not Assigned((C as TcxGridDBBandedColumn).OnGetProperties) then
    begin
      if not Assigned(FcxEditRepository) then
      begin
        FcxEditRepository := TcxEditRepository.Create(Self);
        FcxEditRepository.CreateItem(TcxEditRepositoryBlobItem);
        TcxEditRepositoryBlobItem(FcxEditRepository.Items[0]).Properties.BlobEditKind := bekMemo;
        TcxEditRepositoryBlobItem(FcxEditRepository.Items[0]).Properties.BlobPaintStyle := bpsText;
      end;

      (C as TcxGridDBBandedColumn).OnGetProperties := cxGridDBTableViewTextGetProperties;
    end;

    // Показываем кнопку сегодня
    if C is TcxDateEdit then (C as TcxDateEdit).Properties.DateButtons := (C as TcxDateEdit).Properties.DateButtons + [btnToday];
  end;

end;

procedure TParentForm.InitcxView;
  var I : Integer;
begin
  if gc_ProgramName = 'Farmacy.exe' then
    for I := 0 to ComponentCount - 1 do
      if Components[I] is TdsdDBViewAddOn then
      begin
        TdsdDBViewAddOn(Components[I]).FilterSelectAll := True;
        TdsdDBViewAddOn(Components[I]).FilterLoadFile := True;
      end;
end;

procedure TParentForm.InitBooleanSetVisible;
  var I : Integer;
begin
  for I := 0 to ComponentCount - 1 do
    if Components[I] is TBooleanSetVisibleAction then
      TBooleanSetVisibleAction(Components[I]).SetVisiableAll;
end;

procedure TParentForm.Loaded;
  var
    C: TComponent;
    mni: TMenuItem;
    i : Integer;

procedure dsdTranslateCurrForm(Form : TForm);
  var I : Integer;
begin
  if not dsdTranslatorInit then Exit;

  if dsdTranslatorFull then dsdTranslateForm(Form)
  else for I := 0 to Form.ComponentCount - 1 do
  if Form.Components[I] is TdsdTranslator then
  begin
    TdsdTranslator(Form.Components[I]).TranslateForm;
    Break;
  end;
end;

begin
  inherited;
  if not (csDesigning in ComponentState) then
     if Assigned(AddOnFormData.OnLoadAction) then
        AddOnFormData.OnLoadAction.Execute;
  TranslateForm(Self);
  dsdTranslateCurrForm(Self);

  // Добавляем кнопки сохранения и востановления параметров
  if ExtractFileName(ParamStr(0)) = 'Farmacy.exe' then
    for I := 0 to ComponentCount - 1 do
      if Components[I] is TcxGrid then
      begin
        for C in Self do
        begin
          //Находим все контексные меню
          if C is TPopupMenu then
          Begin
            if not Assigned((C as TPopupMenu).Items.Find('Сохранить пользовательские настройки формы')) then
            begin
              mni := TMenuItem.Create(C);
              mni.Caption := '-';
              (C as TPopupMenu).Items.Add(mni);
              mni := TMenuItem.Create(C);
              mni.Caption := 'Сохранить пользовательские настройки формы';
              mni.ImageIndex := 79;
              mni.OnClick := btnSaveUserSettings;
              (C as TPopupMenu).Items.Add(mni);
            end else (C as TPopupMenu).Items.Find('Сохранить пользовательские настройки формы').OnClick := btnDubleForm;
            if not Assigned((C as TPopupMenu).Items.Find('Загрузить пользовательские настройки формы')) then
            begin
              mni := TMenuItem.Create(C);
              mni.Caption := 'Загрузить пользовательские настройки формы';
              mni.ImageIndex := 80;
              mni.OnClick := btnLoadUserSettings;
              (C as TPopupMenu).Items.Add(mni);
            end else (C as TPopupMenu).Items.Find('Загрузить пользовательские настройки формы').OnClick := btnDubleForm;
          End;
        end;
        Break;
      end;
end;

procedure TParentForm.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) then begin
      if AComponent = AddOnFormData.RefreshAction then
         AddOnFormData.RefreshAction := nil;
      if AComponent = AddOnFormData.ChoiceAction then
         AddOnFormData.ChoiceAction := nil;
      if AComponent = AddOnFormData.ExecuteDialogAction then
         AddOnFormData.ExecuteDialogAction := nil;
      if AComponent = AddOnFormData.Params then
         AddOnFormData.Params := nil;
      if AComponent = AddOnFormData.PUSHMessage then
         AddOnFormData.PUSHMessage := nil;
      if AComponent = AddOnFormData.ClosePUSHMessage then
         AddOnFormData.ClosePUSHMessage := nil;
      if AComponent = AddOnFormData.SetFocusedAction then
         AddOnFormData.SetFocusedAction := nil;
    end;
end;

procedure TParentForm.SetSender(const Value: TComponent);
begin
  FSender := Value;
  // В зависимости от того, как была вызвана форма меняется некоторое поведение

  // Если вызывали для выбора, то делаем видимой кнопку выбора
  if Assigned(AddOnFormData.ChoiceAction) then begin
     AddOnFormData.ChoiceAction.Visible := Assigned(FormSender) and Supports(FormSender, IChoiceCaller);
     AddOnFormData.ChoiceAction.Enabled := AddOnFormData.ChoiceAction.Visible;
     if Supports(FormSender, IChoiceCaller) then begin
        TdsdChoiceGuides(AddOnFormData.ChoiceAction).ChoiceCaller := FormSender as IChoiceCaller;
        (FormSender as IChoiceCaller).Owner := AddOnFormData.ChoiceAction;
    end;
  end;
end;

initialization

  // Стандартные компоненты
  RegisterClass (TActionList);
  RegisterClass (TClientDataSet);
  RegisterClass (TDataSetCancel);
  RegisterClass (TDataSetDelete);
  RegisterClass (TDataSetEdit);
  RegisterClass (TDataSetInsert);
  RegisterClass (TDataSetPost);
  RegisterClass (TDataSource);
  RegisterClass (TDBGrid);
  RegisterClass (TFileExit);
  RegisterClass (TPopupMenu);
  RegisterClass (TPanel);
  RegisterClass (TStringField);
  RegisterClass (TWideStringField);
  RegisterClass (TWebBrowser);
  RegisterClass (TScrollBox);

  // Библиотека DevExpress
  RegisterClass (TdxBarDockControl);
  RegisterClass (TcxButton);
  RegisterClass (TcxButtonEdit);
  RegisterClass (TcxCheckBox);
  RegisterClass (TcxCurrencyEdit);
  RegisterClass (TcxDBCurrencyEdit);
  RegisterClass (TcxDateEdit);
  RegisterClass (TcxDBButtonEdit);
  RegisterClass (TcxDBEditorRow);
  RegisterClass (TcxDBPivotGrid);
  RegisterClass (TcxDBPivotGridField);
  RegisterClass (TcxDBTextEdit);
  RegisterClass (TcxDBTreeList);
  RegisterClass (TcxDBTreeListColumn);
  RegisterClass (TcxDBVerticalGrid);
  RegisterClass (TcxDBMemo);
  RegisterClass (TcxGroupBox);
  RegisterClass (TcxGridDBBandedTableView);
  RegisterClass (TcxGridDBTableView);
  RegisterClass (TcxGrid);
  RegisterClass (TcxLabel);
  RegisterClass (TcxLookupComboBox);
  RegisterClass (TcxMemo);
  RegisterClass (TcxPageControl);
  RegisterClass (TcxPopupEdit);
  RegisterClass (TcxPropertiesStore);
  RegisterClass (TcxSplitter);
  RegisterClass (TcxTabSheet);
  RegisterClass (TcxTextEdit);
  RegisterClass (TcxComboBox);
  RegisterClass (TcxDateNavigator);
  RegisterClass (TcxMaskEdit);
  RegisterClass (TcxEditRepository);
  RegisterClass (TcxStyleRepository);
  RegisterClass (TcxEditStyle);
  RegisterClass (TcxCheckListBox);

  RegisterClass (TdxBarManager);
  RegisterClass (TdxBarStatic);
  RegisterClass (TdxBevel);
  
  RegisterClass (TcxGridDBChartView);

  RegisterClass (TcxDBLabel);

  // Компоненты для карты
  RegisterClass (TGMMap);
  RegisterClass (TGMMarker);
  RegisterClass (TGMGeoCode);
  RegisterClass (TGMDirection);

  // Собственнтые компоненты
  RegisterClass (TBooleanStoredProcAction);
  RegisterClass (TChangeStatus);
  RegisterClass (TChangeGuidesStatus);
  RegisterClass (TCrossDBViewAddOn);
  RegisterClass (TCrossDBViewReportAddOn);
  RegisterClass (TCrossDBViewSetTypeId);
  RegisterClass (TdsdChangeMovementStatus);
  RegisterClass (TdsdChoiceGuides);
  RegisterClass (TdsdDataSetRefresh);
  RegisterClass (TdsdDBViewAddOn);
  RegisterClass (TdsdDBTreeAddOn);
  RegisterClass (TdsdExecStoredProc);
  RegisterClass (TdsdFormClose);
  RegisterClass (TdsdFormParams);
  RegisterClass (TdsdGridToExcel);
  RegisterClass (TdsdGuides);
  RegisterClass (TdsdInsertUpdateAction);
  RegisterClass (TdsdInsertUpdateGuides);
  RegisterClass (TdsdOpenForm);
  RegisterClass (TdsdPrintAction);
  RegisterClass (TdsdStoredProc);
  RegisterClass (TdsdStoredProcSQLite);
  RegisterClass (TdsdUpdateDataSet);
  RegisterClass (TdsdUpdateErased);
  RegisterClass (TdsdUserSettingsStorageAddOn);
  RegisterClass (TdsdLoadXMLKS);
  RegisterClass (TdsdStoredProcExportToFile);
  RegisterClass (TdsdPartnerMapAction);
  RegisterClass (TdsdPivotGridCalcFields);
  RegisterClass (TdsdExportToXLS);
  RegisterClass (TdsdExportToXML);
  RegisterClass (TdsdDuplicateSearchAction);
  RegisterClass (TdsdDOCReportFormAction);
  RegisterClass (TdsdOpenStaticForm);
  RegisterClass (TdsdPropertiesСhange);
  RegisterClass (TdsdSetDefaultParams);
  RegisterClass (TdsdFTP);
  RegisterClass (TdsdDblClickAction);
  RegisterClass (TdsdSendSMSAction);
  RegisterClass (TdsdSendSMSCPAAction);
  RegisterClass (TdsdSendSMSKyivstarAction);
  RegisterClass (TdsdSetFocusedAction);
  RegisterClass (TdsdLoadListValuesFileAction);
  RegisterClass (TdsdPreparePicturesAction);
  RegisterClass (TdsdSetVisibleAction);
  RegisterClass (TdsdDataToJsonAction);
  RegisterClass (TdsdSendTelegramBotAction);
  RegisterClass (TdsdSendClipboardAction);
  RegisterClass (TdsdSetEnabledAction);
  RegisterClass (TdsdRunAction);
  RegisterClass (TdsdForeignData);
  RegisterClass (TdsdMyIPAction);
  RegisterClass (TdsdVATNumberValidation);
  RegisterClass (TdsdLoadAgilis);
  RegisterClass (TdsdLoadFile_https);
  RegisterClass (TdsdeSputnikContactsMessages);
  RegisterClass (TdsdeSputnikSendSMS);
  RegisterClass (TBooleanSetVisibleAction);
  RegisterClass (TdsdSetPropValueAction);
  RegisterClass (TdsdContinueAction);

  RegisterClass (TExecuteDialog);
  RegisterClass (TFileDialogAction);
  RegisterClass (TGuidesFiller);
  RegisterClass (THeaderSaver);
  RegisterClass (THeaderChanger);
  RegisterClass (THeaderExit);
  RegisterClass (TInsertRecord);
  RegisterClass (TInsertUpdateChoiceAction);
  RegisterClass (TMultiAction);
  RegisterClass (TMultiActionFilter);
  RegisterClass (TOpenChoiceForm);
  RegisterClass (TPeriodChoice);
  RegisterClass (TPivotAddOn);
  RegisterClass (TRefreshAddOn);
  RegisterClass (TRefreshDispatcher);
  RegisterClass (TUpdateRecord);
  RegisterClass (TAddOnFormRefresh);
  RegisterClass (TShellExecuteAction);
  RegisterClass (TShowMessageAction);
  RegisterClass (TcxImage);
  RegisterClass (TdsdDataSetRefreshEx);
  RegisterClass (TdsdGMMap);
  RegisterClass (TdsdWebBrowser);
  RegisterClass (TdsdEnterManager);
  RegisterClass (TdsdFileToBase64);
  RegisterClass (TdsdShowPUSHMessage);
  RegisterClass (TdsdFieldFilter);
  RegisterClass (TdsdTranslator);
  RegisterClass (TEnterMoveNext);
  RegisterClass (TChartAddOn);
  RegisterClass (TCheckerboardAddOn);
  RegisterClass (TCheckListBoxAddOn);
  RegisterClass (TcxCurrencyEdit_check);

// ДЛЯ ТЕСТА

  RegisterClass (TDBGrid);

  InitLocalizer;

finalization

  DestroyLocalizer;
end.


