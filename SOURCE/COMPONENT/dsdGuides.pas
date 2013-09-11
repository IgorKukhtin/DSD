unit dsdGuides;

interface

uses Classes, Controls, dsdDB, VCL.Menus, VCL.ActnList;

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
  published
    property ShortCut: TShortCut read FShortCut write SetShortCut default 0;
    property SecondaryShortCuts: TShortCutList read GetSecondaryShortCuts
       write SetSecondaryShortCuts stored IsSecondaryShortCutsStored;
    end;


  TActionItemList = class(TCollection)
  private
    function GetItem(Index: Integer): TActionItem;
    procedure SetItem(Index: Integer; const Value: TActionItem);
  public
    function Add: TActionItem;
    property Items[Index: Integer]: TActionItem read GetItem write SetItem; default;
  end;



  // Компонент работает со справочниками. Выбирает значение из элементов управления или форм
  TdsdGuides = class(TComponent)
  private
    FFormName: string;
    FLookupControl: TWinControl;
    FKey: String;
    FTextValue: String;
    FPositionDataSet: string;
    FParentDataSet: string;
    FParentId: String;
    FParams: TdsdParams;
    FPopupMenu: TPopupMenu;
    FOnAfterChoice: TNotifyEvent;
    function GetKey: String;
    function GetTextValue: String;
    procedure SetKey(const Value: String);
    procedure SetTextValue(const Value: String);
    procedure SetLookupControl(const Value: TWinControl);
    procedure OpenGuides;
    procedure OnDblClick(Sender: TObject);
    procedure OnPopupClick(Sender: TObject);
    procedure OnButtonClick(Sender: TObject; AButtonIndex: Integer);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // Вызыввем процедуру после выбора элемента из справочника
    procedure AfterChoice(Params: TdsdParams);
  published
    // ID записи
    property Key: String read GetKey write SetKey;
    // Текстовое значение
    property TextValue: String read GetTextValue write SetTextValue;
    // Родитель для древовидных справочников
    property ParentId: String read FParentId write FParentId;
    property LookupControl: TWinControl read FLookupControl write SetLookupControl;
    property FormName: string read FFormName write FFormName;
    // Где позиционируемся по ИД
    property PositionDataSet: string read FPositionDataSet write FPositionDataSet;
    // Где позиционируемся по ParentId
    property ParentDataSet: string read FParentDataSet write FParentDataSet;
    // данные, получаемые после выбора из справочника. Например для передачи в другие контролы
    property Params: TdsdParams read FParams write FParams;
    property OnAfterChoice: TNotifyEvent read FOnAfterChoice write FOnAfterChoice;
  end;

  TGuidesListItem = class(TCollectionItem)
  private
    FGuides: TdsdGuides;
    procedure SetGuides(const Value: TdsdGuides);
  protected
    function GetDisplayName: string; override;
  published
    property Guides: TdsdGuides read FGuides write SetGuides;
  end;

  TGuidesFiller = class;

  TGuidesList = class(TCollection)
  private
    function GetItem(Index: Integer): TGuidesListItem;
    procedure SetItem(Index: Integer; const Value: TGuidesListItem);
  public
    GuidesFiller: TGuidesFiller;
    constructor Create(GuidesFiller: TGuidesFiller);
    function Add: TGuidesListItem;
    property Items[Index: Integer]: TGuidesListItem read GetItem write SetItem; default;
  end;


  // Вызывает заполнение справочников при создании документа
  TGuidesFiller = class(TComponent)
  private
    FGuidesList: TGuidesList;
    FParam: TdsdParam;
    FOnAfterShow: TNotifyEvent;
    FActionItemList: TActionItemList;
    procedure OnAfterShow(Sender: TObject);
    procedure OnAfterChoice(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property IdParam: TdsdParam read FParam write FParam;
    property GuidesList: TGuidesList read FGuidesList write FGuidesList;
    property ActionItemList: TActionItemList read FActionItemList write FActionItemList;
  end;


  procedure Register;

implementation

uses cxDBLookupComboBox, cxButtonEdit, Variants, ParentForm, FormStorage, DB,
     SysUtils, Forms;

procedure Register;
begin
   RegisterComponents('DSDComponent', [TdsdGuides]);
   RegisterComponents('DSDComponent', [TGuidesFiller]);
end;

{ TdsdGuides }

procedure TdsdGuides.AfterChoice(Params: TdsdParams);
begin
  // Расставляем параметры по местам
  Self.Params.AssignParams(Params);
  if Assigned(FOnAfterChoice) then
     FOnAfterChoice(Self);
end;

constructor TdsdGuides.Create(AOwner: TComponent);
var MenuItem: TMenuItem;
begin
  inherited;
  FParams := TdsdParams.Create(TdsdParam);
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
  FParams.Free;
  FPopupMenu.Free;
  inherited;
end;

function TdsdGuides.GetKey: String;
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

function TdsdGuides.GetTextValue: String;
begin
  result := FTextValue
end;

procedure TdsdGuides.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FLookupControl) then
     FLookupControl := nil;
end;

procedure TdsdGuides.OnButtonClick(Sender: TObject; AButtonIndex: Integer);
begin
  OnDblClick(Sender);
end;

procedure TdsdGuides.OnDblClick(Sender: TObject);
begin
  OpenGuides;
end;

procedure TdsdGuides.OnPopupClick(Sender: TObject);
begin
  Key := '0';
  TextValue := '';
end;

procedure TdsdGuides.OpenGuides;
var
  Form: TParentForm;
  DataSet: TDataSet;
begin
  Form := TdsdFormStorageFactory.GetStorage.Load(FormName);
  // Открыли форму
  Form.Execute(Self, nil);
  // Спозиционировались на ParentData если он есть
  if ParentDataSet <> '' then begin
     DataSet := Form.FindComponent(ParentDataSet) as TDataSet;
     if not Assigned(DataSet) then
        raise Exception.Create('Не правильно установлено свойство ParentDataSet для формы ' + FormName);
     if ParentId <> '' then
        DataSet.Locate('Id', ParentId, []);
  end;
  // Спозиционировались на дата сете
  DataSet := Form.FindComponent(PositionDataSet) as TDataSet;
  if not Assigned(DataSet) then
     raise Exception.Create('Не правильно установлено свойство PositionDataSet для формы ' + FormName);
  Form.Show;
  // Нужен что бы успели перечитаться датасеты.
  Application.ProcessMessages;
  if Key <> '' then
     DataSet.Locate('Id', Key, []);
end;

procedure TdsdGuides.SetKey(const Value: String);
begin
  if Value = '' then
     FKey := '0'
  else
     FKey := Value;
  if Assigned(LookupControl) then begin
     if LookupControl is TcxLookupComboBox then
        (LookupControl as TcxLookupComboBox).EditValue := FKey
  end;
end;

procedure TdsdGuides.SetLookupControl(const Value: TWinControl);
begin
  FLookupControl := Value;
  TAccessControl(FLookupControl).OnDblClick := OnDblClick;
  if FLookupControl is TcxButtonEdit then begin
     (LookupControl as TcxButtonEdit).Properties.OnButtonClick := OnButtonClick;
     (LookupControl as TcxButtonEdit).PopupMenu := FPopupMenu;
  end;
  if FLookupControl is TcxLookupComboBox then
     (LookupControl as TcxLookupComboBox).PopupMenu := FPopupMenu;
end;

procedure TdsdGuides.SetTextValue(const Value: String);
begin
  FTextValue := Value;
  if Assigned(LookupControl) then begin

     if LookupControl is TcxLookupComboBox then
        (LookupControl as TcxLookupComboBox).Text := Value;
     if LookupControl is TcxButtonEdit then
        (LookupControl as TcxButtonEdit).Text := Value;
  end;
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
  FGuides := Value;
  if Assigned(FGuides) then begin
     FGuides.OnAfterChoice := TGuidesList(Self.Collection).GuidesFiller.OnAfterChoice;
  end;
end;

{ TGuidesList }

function TGuidesList.Add: TGuidesListItem;
begin
  result := TGuidesListItem(inherited Add);
end;

constructor TGuidesList.Create(GuidesFiller: TGuidesFiller);
begin
  inherited Create(TGuidesListItem);
  Self.GuidesFiller := GuidesFiller;
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
  GuidesList := TGuidesList.Create(Self);
  FParam := TdsdParam.Create(nil);
  FActionItemList := TActionItemList.Create(TActionItem);
  if AOwner is TCustomForm then begin
     FOnAfterShow := TParentForm(AOwner).OnAfterShow;
     TParentForm(AOwner).OnAfterShow := Self.OnAfterShow;
  end;
end;

procedure TGuidesFiller.OnAfterChoice(Sender: TObject);
var i: integer;
begin
  if Assigned(FParam) then
     if FParam.Value = 0 then begin
        for I := 0 to GuidesList.Count - 1 do
            if (GuidesList[i].Guides.Key = '0') or ((GuidesList[i].Guides.Key = '')) then begin
               GuidesList[i].Guides.OpenGuides;
               exit;
            end;
       // Прошли по всем справочникам и они заполнены
       // Выполняем все Action
       for I := 0 to FActionItemList.Count - 1 do
          if Assigned(FActionItemList[i].Action) then
               if FActionItemList[i].Action.Enabled then
                  FActionItemList[i].Action.Execute;
     end;
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
  FAction := Value;
end;

function TActionItem.GetDisplayName: string;
begin
  if Assigned(Action) then
     result := Action.Name
  else
     result := inherited;
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



initialization
  RegisterClass(TdsdGuides);

end.


