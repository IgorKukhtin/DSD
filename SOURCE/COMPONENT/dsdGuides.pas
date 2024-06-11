unit dsdGuides;

interface

uses Classes, Controls, dsdDB, VCL.Menus, VCL.ActnList, Forms, dsdCommon;

type

  TAccessControl = class(Controls.TWinControl)
  public
    property OnDblClick;
  end;

  TActionItem = class(TCollectionItem)
  private
    FAction: TCustomAction;
    procedure SetAction(const Value: TCustomAction);
  protected
    function GetDisplayName: string; override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Action: TCustomAction read FAction write SetAction;
  end;

  TShortCutActionItem = class(TActionItem)
  private
    FSecondaryShortCuts: TShortCutList;
    FShortCut: TShortCut;
    procedure SetShortCut(const Value: TShortCut);
    function GetSecondaryShortCuts: TShortCutList;
    procedure SetSecondaryShortCuts(const Value: TShortCutList);
    function IsSecondaryShortCutsStored: Boolean;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property ShortCut: TShortCut read FShortCut write SetShortCut default 0;
    property SecondaryShortCuts: TShortCutList read GetSecondaryShortCuts
       write SetSecondaryShortCuts stored IsSecondaryShortCutsStored;
  end;

  TActionItemList = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TActionItem;
    procedure SetItem(Index: Integer; const Value: TActionItem);
  public
    function Add: TActionItem;
    property Items[Index: Integer]: TActionItem read GetItem write SetItem; default;
  end;

  // имплементирующий данный класс вызывает форму для выбора из справочника
  IChoiceCaller = interface
    ['{879D5206-590F-43CB-B992-26B096342EC2}']
    procedure SetOwner(Owner: TObject);
    procedure AfterChoice(Params: TdsdParams; Form: TForm);
    property Owner: TObject write SetOwner;
  end;

  TCustomGuides = class(TdsdComponent, IChoiceCaller)
  private
    FParams: TdsdParams;
    FKey: String;
    FParentId: String;
    FTextValue: String;
    FPositionDataSet: string;
    FParentDataSet: string;
    FFormName: string;
    FLookupControl: TWinControl;
    FKeyField: string;
    FChoiceAction: TComponent;
    FFormNameParam: TdsdParam;
    FisShowModal: boolean;
    FDisableGuidesOpen: boolean;
    function GetKey: String;
    function GetTextValue: String;
    procedure SetKey(const Value: String);
    procedure SetTextValue(const Value: String);
    procedure SetLookupControl(const Value: TWinControl); virtual;
    procedure OnDblClick(Sender: TObject);
    procedure OpenGuides;
    procedure OnButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure SetOwner(Owner: TObject);
    procedure SetFormName(const Value: string);
    function GetFormName: string;
    function GetFormNameParam: TdsdParam;
  protected
    FOnChange: TNotifyEvent;
    // имя формы
    property FormName: string read GetFormName write SetFormName;
    property FormNameParam: TdsdParam read GetFormNameParam write FFormNameParam;
    // Где позиционируемся по ParentId
    property ParentDataSet: string read FParentDataSet write FParentDataSet;
    // Где позиционируемся по ИД
    property PositionDataSet: string read FPositionDataSet write FPositionDataSet;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    // ID записи
    property Key: String read GetKey write SetKey;
    // Текстовое значение
    property TextValue: String read GetTextValue write SetTextValue;
    // Родитель для древовидных справочников
    property ParentId: String read FParentId write FParentId;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  protected
    property isShowModal: boolean read FisShowModal write FisShowModal default false;
    // Вызыввем процедуру после выбора элемента из справочника
    procedure AfterChoice(Params: TdsdParams; Form: TForm); virtual; abstract;
    // данные, получаемые после выбора из справочника. Например для передачи в другие контролы
    property Params: TdsdParams read FParams write FParams;
  published
    // ключевое поле
    property KeyField: string read FKeyField write FKeyField;
    // визуальный компонент
    property LookupControl: TWinControl read FLookupControl write SetLookupControl;
    // закрыть выбор из справочников
    property DisableGuidesOpen: boolean read FDisableGuidesOpen write FDisableGuidesOpen default false;
  end;

  // Компонент работает со справочниками. Выбирает значение из элементов управления или форм
  TdsdGuides = class(TCustomGuides)
  private
    FOnAfterChoice: TNotifyEvent;
    FPopupMenu: TPopupMenu;
    procedure OnPopupClick(Sender: TObject);
    procedure SetLookupControl(const Value: TWinControl); override;
  protected
    // Вызыввем процедуру после выбора элемента из справочника
    procedure AfterChoice(Params: TdsdParams; Form: TForm); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property isShowModal;
    property Key;
    // Текстовое значение
    property TextValue;
    property FormNameParam;
    property FormName;
    // Родитель для древовидных справочников
    property ParentId;
    // Где позиционируемся по ИД
    property PositionDataSet;
    // Где позиционируемся по ParentId
    property ParentDataSet;
    property Params;
    property OnAfterChoice: TNotifyEvent read FOnAfterChoice write FOnAfterChoice;
  end;

  TChangeStatus = class(TCustomGuides)
  private
    FProcedure: TdsdStoredProc;
    FParam: TdsdParam;
    function GetStoredProcName: string;
    procedure SetStoredProcName(const Value: string);
  protected
    // Вызываем процедуру после выбора элемента из справочника
    procedure AfterChoice(Params: TdsdParams; Form: TForm); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property IdParam: TdsdParam read FParam write FParam;
    property StoredProcName: string read GetStoredProcName write SetStoredProcName;
  end;

  TGuidesListItem = class(TCollectionItem)
  private
    FGuides: TdsdGuides;
    procedure SetGuides(const Value: TdsdGuides);
  public
    procedure Assign(Source: TPersistent); override;
  protected
    function GetDisplayName: string; override;
  published
    property Guides: TdsdGuides read FGuides write SetGuides;
  end;

  TGuidesFiller = class;

  TGuidesList = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TGuidesListItem;
    procedure SetItem(Index: Integer; const Value: TGuidesListItem);
  public
    function Add: TGuidesListItem;
    property Items[Index: Integer]: TGuidesListItem read GetItem write SetItem; default;
  end;

  // Вызывает заполнение справочников при создании документа
  TGuidesFiller = class(TdsdComponent)
  private
    FGuidesList: TGuidesList;
    FParam: TdsdParam;
    FOnAfterShow: TNotifyEvent;
    FActionItemList: TActionItemList;
    procedure OnAfterShow(Sender: TObject);
    procedure OnAfterChoice(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property IdParam: TdsdParam read FParam write FParam;
    property GuidesList: TGuidesList read FGuidesList write FGuidesList;
    property ActionItemList: TActionItemList read FActionItemList write FActionItemList;
  end;

  procedure Register;

implementation

uses cxDBLookupComboBox, cxButtonEdit, Variants, ParentForm, FormStorage, DB,
     SysUtils, Dialogs, dsdAction, cxDBEdit, dsdAddOn;

procedure Register;
begin
   RegisterComponents('DSDComponent', [TdsdGuides]);
   RegisterComponents('DSDComponent', [TGuidesFiller]);
   RegisterComponents('DSDComponent', [TChangeStatus]);
end;

{ TdsdGuides }

type
  TAccessWinControl = class(TWinControl)
  public
    property onExit;
  end;


procedure TdsdGuides.AfterChoice(Params: TdsdParams; Form: TForm);
var i: integer;
begin
  // Расставляем параметры по местам
  Self.Params.AssignParams(Params);
  if Assigned(FOnAfterChoice) then
     // Здесь форму закроют
     FOnAfterChoice(Form)
  else
    // Если форма не закрыта, то закрываем
    if Form.Visible then
       Form.Close;

  // Вызываем заполнение параметров
  for I := 0 to Params.Count - 1 do
      if assigned(Self.Params.ParamByName(Params[i].Name).Component) then
         if Self.Params.ParamByName(Params[i].Name).Component is TCustomGuides then
            if not (Self.Params.ParamByName(Params[i].Name).Component as TCustomGuides).LookupControl.Focused then
               if ansilowercase(Self.Params.ParamByName(Params[i].Name).ComponentItem) = 'textvalue' then
                  if Assigned(TAccessWinControl((Self.Params.ParamByName(Params[i].Name).Component as TCustomGuides).LookupControl).onExit) then
                     TAccessWinControl((Self.Params.ParamByName(Params[i].Name).Component as TCustomGuides).LookupControl).onExit((Self.Params.ParamByName(Params[i].Name).Component as TCustomGuides).LookupControl);

end;

constructor TdsdGuides.Create(AOwner: TComponent);
var MenuItem: TMenuItem;
begin
  inherited;
  FFormNameParam := TdsdParam.Create(nil);
  FFormNameParam.DataType := ftString;
  FFormNameParam.Value := '';
  FParams := TdsdParams.Create(Self, TdsdParam);
  FPopupMenu := TPopupMenu.Create(nil);
  MenuItem := TMenuItem.Create(FPopupMenu);
  with MenuItem do begin
    Caption := 'Обнулить значение';
    ShortCut := 32776;  // Alt + BkSp
    OnClick := OnPopupClick;
  end;
  FPopupMenu.Items.Add(MenuItem);
end;

destructor TdsdGuides.Destroy;
begin
  FreeAndNil(FParams);
  FreeAndNil(FPopupMenu);
  FreeAndNil(FFormNameParam);
  inherited;
end;

procedure TdsdGuides.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDestroying in ComponentState then
     exit;
    if (Operation = opRemove) then begin
      if Assigned(Params) then
         for i := 0 to Params.Count - 1 do
            if Params[i].Component = AComponent then
               Params[i].Component := nil;
    end;
end;

procedure TdsdGuides.OnPopupClick(Sender: TObject);
begin
  Key := '0';
  TextValue := '';
end;

procedure TdsdGuides.SetLookupControl(const Value: TWinControl);
begin
  inherited;
  if FLookupControl is TcxButtonEdit then
     (LookupControl as TcxButtonEdit).PopupMenu := FPopupMenu;
  if FLookupControl is TcxLookupComboBox then
     (LookupControl as TcxLookupComboBox).PopupMenu := FPopupMenu;
end;

{ TGuidesListItem }

function TGuidesListItem.GetDisplayName: string;
begin
  if Assigned(Guides) then
     result := Guides.Name
  else
     result := inherited;
end;

procedure TGuidesListItem.SetGuides(const Value: TdsdGuides);
begin
  if Assigned(Value) then begin
    if Assigned(Collection) then
        Value.FreeNotification(TComponent(Collection.Owner));
    if Collection.Owner is TGuidesFiller then
       Value.OnAfterChoice := TGuidesFiller(Self.Collection.Owner).OnAfterChoice;
  end;
  FGuides := Value;
end;

procedure TGuidesListItem.Assign(Source: TPersistent);
begin
  if Source is TGuidesListItem then
    with TGuidesListItem(Source) do
    begin
      Self.FGuides := FGuides;
    end
  else
    inherited Assign(Source);
end;

{ TGuidesList }

function TGuidesList.Add: TGuidesListItem;
begin
  result := TGuidesListItem(inherited Add);
end;

function TGuidesList.GetItem(Index: Integer): TGuidesListItem;
begin
  Result := TGuidesListItem(inherited GetItem(Index));
end;

procedure TGuidesList.SetItem(Index: Integer; const Value: TGuidesListItem);
begin
  inherited SetItem(Index, Value);
end;

{ TGuidesFiller }

constructor TGuidesFiller.Create(AOwner: TComponent);
begin
  inherited;
  GuidesList := TGuidesList.Create(Self, TGuidesListItem);
  FParam := TdsdParam.Create(nil);
  FActionItemList := TActionItemList.Create(Self, TActionItem);
  if AOwner is TCustomForm then begin
     FOnAfterShow := TParentForm(AOwner).OnAfterShow;
     TParentForm(AOwner).OnAfterShow := Self.OnAfterShow;
  end;
end;

destructor TGuidesFiller.Destroy;
begin
  FreeAndNil(FGuidesList);
  FreeAndNil(FParam);
  FreeAndNil(FActionItemList);
  if Owner is TCustomForm then
     TParentForm(Owner).OnAfterShow := FOnAfterShow;
  inherited;
end;

procedure TGuidesFiller.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDestroying in ComponentState then
     exit;
    if (Operation = opRemove) then begin
      if (AComponent is TdsdGuides) and Assigned(GuidesList) then
         for i := 0 to GuidesList.Count - 1 do
            if GuidesList[i].Guides = AComponent then
               GuidesList[i].Guides := nil;
      if (AComponent is TCustomAction) and Assigned(ActionItemList) then
         for i := 0 to ActionItemList.Count - 1 do
            if ActionItemList[i].Action = AComponent then
               ActionItemList[i].Action := nil;
    end;
end;

procedure TGuidesFiller.OnAfterChoice(Sender: TObject);
var i: integer;
begin
  if Assigned(FParam) then
     if (FParam.Value = 0) or VarIsNull(FParam.Value) then begin
        for I := 0 to GuidesList.Count - 1 do
            if assigned(GuidesList[i].Guides) then
              if (GuidesList[i].Guides.Key = '0') or ((GuidesList[i].Guides.Key = '')) then begin
                 // Закроем форму справочника
                 if Sender is TForm then
                    TForm(Sender).Close;
                 GuidesList[i].Guides.OpenGuides;
                 exit;
              end;
       // Прошли по всем справочникам и они заполнены
       // Выполняем все Action
          for I := 0 to FActionItemList.Count - 1 do
             if Assigned(FActionItemList[i].Action) then
                 if FActionItemList[i].Action.Enabled then begin
                    // ну раз уж сохранили ИД, то уж
                    // нет смысла вызывать THeaderSaver
                      FActionItemList[i].Action.Execute;
                 end;
       // Эмулирует заход во все контролы, чтобы установить текущие значения
          if Assigned(Owner) then
             for i :=0 to Owner.ComponentCount - 1 do
                 if Owner.Components[i] is THeaderSaver then
                    THeaderSaver(Owner.Components[i]).EnterAll;
     end;
   // Если не возникло ошибок!!! закроем форму справочника
   if (Sender is TForm) then
      TForm(Sender).Close;
end;

procedure TGuidesFiller.OnAfterShow(Sender: TObject);
begin
  if Assigned(FOnAfterShow) then
     FOnAfterShow(Sender);
  OnAfterChoice(Self);
end;

{ TActionItem }

procedure TActionItem.SetAction(const Value: TCustomAction);
begin
  if FAction <> Value then begin
     if Assigned(Collection) and Assigned(Value) then
        Value.FreeNotification(TComponent(Collection.Owner));
     FAction := Value;
  end;
end;

procedure TActionItem.Assign(Source: TPersistent);
begin
  if Source is TActionItem then
     Self.Action := TActionItem(Source).Action
  else
    inherited Assign(Source);
end;

function TActionItem.GetDisplayName: string;
begin
  if Assigned(Action) then
     result := Action.Name
  else
     result := inherited;
end;

procedure TShortCutActionItem.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  with TShortCutActionItem(Source) do begin
    Self.ShortCut := ShortCut;
    Self.SecondaryShortCuts.Assign(SecondaryShortCuts);
  end;
end;

function TShortCutActionItem.GetSecondaryShortCuts: TShortCutList;
begin
  if FSecondaryShortCuts = nil then
    FSecondaryShortCuts := TShortCutList.Create;
  Result := FSecondaryShortCuts;
end;

procedure TShortCutActionItem.SetSecondaryShortCuts(const Value: TShortCutList);
begin
  if FSecondaryShortCuts = nil then
    FSecondaryShortCuts := TShortCutList.Create;
  FSecondaryShortCuts.Assign(Value);
end;

function TShortCutActionItem.IsSecondaryShortCutsStored: Boolean;
begin
  Result := Assigned(FSecondaryShortCuts) and (FSecondaryShortCuts.Count > 0);
end;

procedure TShortCutActionItem.SetShortCut(const Value: TShortCut);
begin
  FShortCut := Value;
end;

{ TActionItemList }

function TActionItemList.Add: TActionItem;
begin
  result := TActionItem(inherited Add);
end;

function TActionItemList.GetItem(Index: Integer): TActionItem;
begin
  Result := TActionItem(inherited GetItem(Index));
end;

procedure TActionItemList.SetItem(Index: Integer; const Value: TActionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TCustomGuides }

procedure TCustomGuides.OnDblClick(Sender: TObject);
begin
  OpenGuides;
end;

procedure TCustomGuides.SetLookupControl(const Value: TWinControl);
begin
  FLookupControl := Value;
  if not Assigned(FLookupControl) then
     exit;
  TAccessControl(FLookupControl).OnDblClick := OnDblClick;
  if FLookupControl is TcxButtonEdit then
     (LookupControl as TcxButtonEdit).Properties.OnButtonClick := OnButtonClick;
  if FLookupControl is TcxDBButtonEdit then
     (LookupControl as TcxDBButtonEdit).Properties.OnButtonClick := OnButtonClick;
end;

procedure TCustomGuides.SetOwner(Owner: TObject);
begin
  FChoiceAction := Owner as TComponent;
  FChoiceAction.FreeNotification(Self);
end;

procedure TCustomGuides.OnButtonClick(Sender: TObject; AButtonIndex: Integer);
begin
  if Sender is TcxButtonEdit then
     if not Assigned(TcxButtonEdit(Sender).Properties.Buttons[AButtonIndex].Action) then
        OnDblClick(Sender);
  if Sender is TcxDBButtonEdit then
     if not Assigned(TcxDBButtonEdit(Sender).Properties.Buttons[AButtonIndex].Action) then
        OnDblClick(Sender);
end;

procedure TCustomGuides.OpenGuides;
var
  Form: TParentForm;
  DataSet: TDataSet;
begin
  if DisableGuidesOpen then exit;
  if FormName = ''  then exit;
  Form := TdsdFormStorageFactory.GetStorage.Load(FormName);
  // Открыли форму
  Form.Execute(Self, Params);
  // Спозиционировались на ParentData если он есть
  if ParentDataSet <> '' then begin
     DataSet := Form.FindComponent(ParentDataSet) as TDataSet;
     if not Assigned(DataSet) then
        raise Exception.Create('Не правильно установлено свойство ParentDataSet для формы ' + FormName);
     if ParentId <> '' then
        DataSet.Locate('Id', ParentId, []);
  end;
  if not (Form.FindComponent(PositionDataSet) is TDataSet) then
     raise Exception.Create(FormName + '.  Компонент ' + Name + '. Класс ' + PositionDataSet + ' не является TDataSet');
  // Спозиционировались на дата сете
  DataSet := Form.FindComponent(PositionDataSet) as TDataSet;
  if not Assigned(DataSet) then
     raise Exception.Create('Не правильно установлено свойство PositionDataSet для формы ' + FormName);
  if Key <> '' then
     DataSet.Locate(KeyField, Key, []);
  // Показали форму
  if isShowModal then
     Form.ShowModal
  else
     Form.Show;
end;

constructor TCustomGuides.Create(AOwner: TComponent);
begin
  inherited;
  PositionDataSet := 'ClientDataSet';
  KeyField := 'Id';
  isShowModal := false;
  FDisableGuidesOpen := false;
end;

destructor TCustomGuides.Destroy;
begin
  // Унижтожаем ссылку на себя в другом компоненте!
  try
  if Assigned(FChoiceAction) then
     if FChoiceAction is TdsdChoiceGuides then
        TdsdChoiceGuides(FChoiceAction).ChoiceCaller := nil;
  except

  end;
  inherited;
end;

function TCustomGuides.GetFormName: string;
begin
  result := FFormNameParam.AsString;
  if result = '' then
     result := FFormName
end;

function TCustomGuides.GetFormNameParam: TdsdParam;
begin
  if FFormNameParam.AsString = '' then
     FFormNameParam.Value := FormName;
  Result := FFormNameParam;
end;

function TCustomGuides.GetKey: String;
begin
  if Assigned(LookupControl) then begin
     if LookupControl is TcxLookupComboBox then begin
        // Проверим выбран ли элемент
        if VarisNull((LookupControl as TcxLookupComboBox).EditValue) then
           Result := '0'
        else
           Result := (LookupControl as TcxLookupComboBox).EditValue;
     end
     else
       Result := FKey;
  end;
end;

function TCustomGuides.GetTextValue: String;
begin
  result := FTextValue
end;

procedure TCustomGuides.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDestroying in ComponentState then
     exit;
  if (Operation = opRemove) then begin
      if (AComponent = FLookupControl) then
         FLookupControl := nil;
      if (AComponent = FChoiceAction) then
         FChoiceAction := nil;
  end;
end;

procedure TCustomGuides.SetFormName(const Value: string);
begin
  if (Value <> '') and (csDesigning in ComponentState) and not (csLoading in ComponentState) then
     ShowMessage('Используйте FormNameParam')
  else
     FFormName := Value;
end;

procedure TCustomGuides.SetKey(const Value: String);
var isChange_my:Boolean; // add 25.02.2018
begin
  isChange_my:= TRUE;  // add 25.02.2018
  //
  if Value = '' then
     FKey := '0'
  else begin
     try isChange_my:= FKey <> Value; except isChange_my:= TRUE; end; // add 25.02.2018
     FKey := Value;
  end;

  if Assigned(FOnChange) and (isChange_my = TRUE) then
     FOnChange(Self);
  if Assigned(LookupControl) then begin
     if LookupControl is TcxLookupComboBox then
        (LookupControl as TcxLookupComboBox).EditValue := FKey
  end;
end;

procedure TCustomGuides.SetTextValue(const Value: String);
var
  TextShow: string;
begin
  FTextValue := Value;
  if (FTextValue = '') and (Key <> '0') and (Key <> '') then
     TextShow := Key
  else
     TextShow := FTextValue;
  if Assigned(LookupControl) then begin
     if LookupControl is TcxLookupComboBox then
        (LookupControl as TcxLookupComboBox).Text := TextShow;
     if LookupControl is TcxButtonEdit then
        (LookupControl as TcxButtonEdit).Text := TextShow;
     if LookupControl is TcxDBButtonEdit then
        (LookupControl as TcxDBButtonEdit).Text := TextShow;
  end;
end;

{ TChangeStatus }

procedure TChangeStatus.AfterChoice(Params: TdsdParams; Form: TForm);
begin
  // Вот прямо тут вызываем процедуру и если отработала,
  FProcedure.ParamByName('inMovementId').Value := IdParam.Value;
  FProcedure.ParamByName('inStatusCode').Value := Params.ParamByName('Key').Value;
  FProcedure.Execute;
  // то меняем данные
  Key := Params.ParamByName('Key').Value;
  TextValue := Params.ParamByName('TextValue').Value;
end;

constructor TChangeStatus.Create(AOwner: TComponent);
begin
  inherited;
  FFormName := 'TStatusForm';
  FParam := TdsdParam.Create(nil);
  FProcedure := TdsdStoredProc.Create(Self);
  FProcedure.OutputType := otResult;
  FProcedure.Params.AddParam('inMovementId', ftInteger, ptInput, 0);
  FProcedure.Params.AddParam('inStatusCode', ftInteger, ptInput, 0);
end;

function TChangeStatus.GetStoredProcName: string;
begin
  result := FProcedure.StoredProcName;
end;

procedure TChangeStatus.SetStoredProcName(const Value: string);
begin
  FProcedure.StoredProcName := Value;
end;

initialization
  RegisterClass(TdsdGuides);

end.


