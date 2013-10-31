unit dsdAddOn;

interface

uses Classes, cxDBTL, cxTL, Vcl.ImgList, cxGridDBTableView,
     cxTextEdit, DB, dsdAction, cxGridTableView,
     VCL.Graphics, cxGraphics, cxStyles, Forms, Controls,
     SysUtils, dsdDB, Contnrs, cxGridCustomView, cxGridCustomTableView, dsdGuides,
     VCL.ActnList, cxEdit;

type

  // 1. Обработка признака isErased
  TCustomDBControlAddOn = class(TComponent)
  private
    FImages: TImageList;
    FOnDblClickActionList: TActionItemList;
    FActionItemList: TActionItemList;
    FOnKeyDown: TKeyEvent;
    FErasedFieldName: string;
    FAfterInsert: TDataSetNotifyEvent;
    procedure OnAfterInsert(DataSet: TDataSet);
    procedure OnDblClick(Sender: TObject);
    procedure OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;
  protected
    property OnDblClickActionList: TActionItemList read FOnDblClickActionList write FOnDblClickActionList;
    property ActionItemList: TActionItemList read FActionItemList write FActionItemList;
    property SortImages: TImageList read FImages write FImages;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ErasedFieldName: string read FErasedFieldName write FErasedFieldName;
  end;

  TdsdDBTreeAddOn = class(TCustomDBControlAddOn)
  private
    FDBTreeList: TcxDBTreeList;
    procedure SetDBTreeList(const Value: TcxDBTreeList);
    // сотируем при нажатых Ctrl, Shift или Alt
    procedure onColumnHeaderClick(Sender: TcxCustomTreeList; AColumn: TcxTreeListColumn);
    // рисуем свои иконки
    procedure onCustomDrawHeaderCell(Sender: TcxCustomTreeList;
       ACanvas: TcxCanvas; AViewInfo: TcxTreeListHeaderCellViewInfo;
       var ADone: Boolean);
    // рисуем свой цвет у выделенной ячейки
    procedure onCustomDrawDataCell(Sender: TcxCustomTreeList;
       ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
       var ADone: Boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure onGetNodeImageIndex(Sender: TcxCustomTreeList; ANode: TcxTreeListNode;
              AIndexType: TcxTreeListImageIndexType; var AIndex: TImageIndex);
  published
    property OnDblClickActionList;
    property ActionItemList;
    property SortImages;
    property DBTreeList: TcxDBTreeList read FDBTreeList write SetDBTreeList;
  end;

  ESortException = class(Exception)

  end;

  // Добавляет ряд функционала на GridView
  // 1. Быстрая установка фильтров
  // 2. Рисование иконок сортировки
  // 3. Обработка признака isErased
  TdsdDBViewAddOn = class(TCustomDBControlAddOn)
  private
    FBackGroundStyle: TcxStyle;
    FView: TcxGridTableView;
    FonExit: TNotifyEvent;
    // контрол для ввода условия фильтра
    edFilter: TcxTextEdit;
    FOnlyEditingCellOnEnter: boolean;
    FGridEditKeyEvent: TcxGridEditKeyEvent;
    FOnGetContentStyleEvent: TcxGridGetCellStyleEvent;
    FErasedStyle: TcxStyle;
    procedure ActionOnlyEditingCellOnEnter;
    procedure GridEditKeyEvent(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
                                AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
    procedure OnKeyPress(Sender: TObject; var Key: Char);
    procedure OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;
    procedure SetView(const Value: TcxGridTableView); virtual;
    procedure edFilterExit(Sender: TObject);
    procedure edFilterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    // процедура устанавливает контрол для внесения значения фильтра и позиционируется на заголовке колонки
    procedure lpSetEdFilterPos(inKey: Char);
    //процедура устанавливает фильтр и убирает видимость у контрола
    procedure lpSetFilter;
    // сотируем при нажатых Ctrl, Shift или Alt
    procedure OnColumnHeaderClick(Sender: TcxGridTableView; AColumn: TcxGridColumn);
    // рисуем свои иконки
    procedure OnCustomDrawColumnHeader(Sender: TcxGridTableView;
     ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo;
     var ADone: Boolean);
    // рисуем свой цвет у выделенной ячейки в гриде
    procedure OnCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    // рисуем свой цвет у выделенной ячейки при выгрузке в Excel, например, или печати
    procedure OnGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; out AStyle: TcxStyle);
    // поменять цвет грида в случае установки фильтра
    procedure onFilterChanged(Sender: TObject);
    // если при выходе из грида ДатаСет в Edit mode, то делаем Post
    procedure OnExit(Sender: TObject);
    procedure SetOnlyEditingCellOnEnter(const Value: boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    // Ссылка ссылка на элемент отображающий список
    property View: TcxGridTableView read FView write SetView;
    // список событий на DblClick
    property OnDblClickActionList;
    // список событий, реагирующих на нажатие клавиш в гриде
    property ActionItemList;
    // картинки для сортировки
    property SortImages;
    // Перемещаться только по редактируемым ячейкам по Enter
    // В случае достижения конца колонок и наличия следующей записи перейти на нее и cпозиционироваться на редактируемой ячейке
    property OnlyEditingCellOnEnter: boolean read FOnlyEditingCellOnEnter write SetOnlyEditingCellOnEnter;
  end;

  TCrossDBViewAddOn = class(TdsdDBViewAddOn)
  private
    FHeaderDataSet: TDataSet;
    FTemplateColumn: TcxGridColumn;
    FHeaderColumnName: String;
    FBeforeOpen: TDataSetNotifyEvent;
    FAfterClose: TDataSetNotifyEvent;
    FEditing: TcxGridEditingEvent;
    FFocusedItemChanged: TcxGridFocusedItemChangedEvent;
    FDataSet: TDataSet;
    FCreateColumnList: TList;
    procedure onEditing(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
         var AAllow: Boolean);
    procedure onBeforeOpen(DataSet: TDataSet);
    procedure onAfterClose(DataSet: TDataSet);
    procedure SetView(const Value: TcxGridTableView); override;
    procedure FocusedItemChanged(Sender: TcxCustomGridTableView;
                                 APrevFocusedItem, AFocusedItem: TcxCustomGridTableItem);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    property DataSet: TDataSet read FDataSet;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    // Дата сет с названием колонок и другой необходимой для работы информацией.
    property HeaderDataSet: TDataSet read FHeaderDataSet write FHeaderDataSet;
    // Поле в HeaderDataSet с названиями колонок кроса
    property HeaderColumnName: String read FHeaderColumnName write FHeaderColumnName;
    // Шаблон для Cross колонок
    property TemplateColumn: TcxGridColumn read FTemplateColumn write FTemplateColumn;
  end;

  TdsdUserSettingsStorageAddOn = class(TComponent)
  private
    FOnDestroy: TNotifyEvent;
    //FForm: TForm;
    procedure OnDestroy(Sender: TObject);
    procedure SaveUserSettings;
  public
    procedure LoadUserSettings;
    constructor Create(AOwner: TComponent); override;
  end;

  TControlListItem = class(TCollectionItem)
  private
    FControl: TControl;
    procedure SetControl(const Value: TControl);
  protected
    function GetDisplayName: string; override;
  published
    property Control: TControl read FControl write SetControl;
  end;

  THeaderSaver = class;

  TControlList = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TControlListItem;
    procedure SetItem(Index: Integer; const Value: TControlListItem);
  public
    function Add: TControlListItem;
    property Items[Index: Integer]: TControlListItem read GetItem write SetItem; default;
  end;

  // Вызывает процедуру сохранения для СОХРАНЕННОГО документа в случае изменения значений
  THeaderSaver = class(TComponent)
  private
    FControlList: TControlList;
    FStoredProc: TdsdStoredProc;
    FEnterValue: TStringList;
    FOnAfterShow: TNotifyEvent;
    FParam: TdsdParam;
    FGetStoredProc: TdsdStoredProc;
    procedure OnEnter(Sender: TObject);
    procedure OnExit(Sender: TObject);
    // процедура вызывается после открытия формы и заполняет FEnterValue начальными параметрами
    procedure OnAfterShow(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property IdParam: TdsdParam read FParam write FParam;
    property StoredProc: TdsdStoredProc read FStoredProc write FStoredProc;
    property ControlList: TControlList read FControlList write FControlList;
    property GetStoredProc: TdsdStoredProc read FGetStoredProc write FGetStoredProc;
  end;

  TRefreshAddOn = class(TComponent)
  private
    FFormName: string;
    FDataSet: string;
    FOnClose: TCloseEvent;
    FRefreshAction: string;
    FFormParams: string;
    FKeyField: string;
    procedure OnClose(Sender: TObject; var Action: TCloseAction);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property FormName: string read FFormName write FFormName;
    property DataSet: string read FDataSet write FDataSet;
    property KeyField: string read FKeyField write FKeyField;
    property RefreshAction: string read FRefreshAction write FRefreshAction;
    property FormParams: string read FFormParams write FFormParams;
  end;

  TComponentListItem = class(TCollectionItem)
  private
    FComponent: TComponent;
    FOnChange: TNotifyEvent;
    procedure SetComponent(const Value: TComponent);
    procedure OnChange(Sender: TObject);
  protected
    function GetDisplayName: string; override;
  published
    property Component: TComponent read FComponent write SetComponent;
  end;

  TExecuteDialog = class;

  TRefreshDispatcher = class(TComponent)
  private
    FRefreshAction: TdsdDataSetRefresh;
    FComponentList: TCollection;
    FShowDialogAction: TExecuteDialog;
    procedure SetShowDialogAction(const Value: TExecuteDialog);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure OnComponentChange(Sender: TObject);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property RefreshAction: TdsdDataSetRefresh read FRefreshAction write FRefreshAction;
    property ShowDialogAction: TExecuteDialog read FShowDialogAction write SetShowDialogAction;
    property ComponentList: TCollection read FComponentList write FComponentList;
  end;

  // событие работы с диалогами установки параметров
  TExecuteDialog = class (TdsdOpenForm)
  private
    FRefreshDispatcher: TRefreshDispatcher;
    FOpenBeforeShow: boolean;
    // Прячем свойство модальности - она всегда модальна
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    // данное свойство нужно только в случае открытия диалога ДО формы. Что бы не быдо 2-х перечитываний запроса
    RefreshAllow: boolean;
    function Execute: boolean; override;
    property RefreshDispatcher: TRefreshDispatcher read FRefreshDispatcher write FRefreshDispatcher;
    constructor Create(AOwner: TComponent); override;
  published
    property OpenBeforeShow: boolean read FOpenBeforeShow write FOpenBeforeShow;
  end;

  TAddOnFormData = class(TPersistent)
  private
    FChoiceAction: TdsdChoiceGuides;
    FParams: TdsdFormParams;
    FExecuteDialogAction: TExecuteDialog;
    FRefreshAction: TdsdDataSetRefresh;
    FisSingle: boolean;
    FisAlwaysRefresh: boolean;
  public
    constructor Create;
  published
    // Всегда перечитываем форму
    property isAlwaysRefresh: boolean read FisAlwaysRefresh write FisAlwaysRefresh default true;
    // Событие вызываемое для перечитывания формы
    property RefreshAction: TdsdDataSetRefresh read FRefreshAction write FRefreshAction;
    // Данная форма создается в единственном экземпляре. Актуально, например, для справочников
    property isSingle: boolean read FisSingle write FisSingle default true;
    // Событие вызываемое для выбора значения
    property ChoiceAction: TdsdChoiceGuides read FChoiceAction write FChoiceAction;
    // Событие открытия диалога
    property ExecuteDialogAction: TExecuteDialog read FExecuteDialogAction write FExecuteDialogAction;
    // Параметры формы
    property Params: TdsdFormParams read FParams write FParams;
  end;

  procedure Register;

implementation

uses utilConvert, FormStorage, Xml.XMLDoc, XMLIntf, Windows,
     cxFilter, cxClasses, cxLookAndFeelPainters, cxCustomData,
     cxGridCommon, math, cxPropertiesStore, UtilConst, cxStorage,
     cxGeometry, cxCalendar, cxCheckBox, dxBar, cxButtonEdit, cxCurrencyEdit,
     VCL.Menus, ParentForm, ChoicePeriod, cxGrid, cxDBData, Variants,
     cxGridDBBandedTableView, cxGridDBDataDefinitions,cxGridBandedTableView;

type

  TcxGridColumnHeaderViewInfoAccess = class(TcxGridColumnHeaderViewInfo);

procedure Register;
begin
   RegisterComponents('DSDComponent', [TCrossDBViewAddOn]);
   RegisterComponents('DSDComponent', [THeaderSaver]);
   RegisterComponents('DSDComponent', [TdsdDBTreeAddOn]);
   RegisterComponents('DSDComponent', [TdsdDBViewAddOn]);
   RegisterComponents('DSDComponent', [TdsdUserSettingsStorageAddOn]);
   RegisterComponents('DSDComponent', [TRefreshAddOn]);
   RegisterComponents('DSDComponent', [TRefreshDispatcher]);
   RegisterActions('DSDLib', [TExecuteDialog], TExecuteDialog);
end;

{ TdsdDBTreeAddOn }

procedure TdsdDBTreeAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDesigning in ComponentState then begin
    if (Operation = opRemove) and (AComponent = DBTreeList) then
       DBTreeList := nil;
  end;
end;

procedure TdsdDBTreeAddOn.onColumnHeaderClick(Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn);
begin
  // сотируем при нажатых Ctrl, Shift или Alt
  if not (ShiftDown or CtrlDown or AltDown) then
     raise ESortException.Create('');
end;

procedure TdsdDBTreeAddOn.onCustomDrawDataCell(Sender: TcxCustomTreeList;
  ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
  var ADone: Boolean);
begin
  if AViewInfo.Focused then begin
     ACanvas.Brush.Color := clHighlight;
     ACanvas.Font.Color := clHighlightText;
  end;
end;

procedure TdsdDBTreeAddOn.onCustomDrawHeaderCell(Sender: TcxCustomTreeList;
  ACanvas: TcxCanvas; AViewInfo: TcxTreeListHeaderCellViewInfo;
  var ADone: Boolean);
var
  R: TRect;
  ASortingImageSize: Integer;
  ASortingImageIndex: Integer;
begin
   with AViewInfo do begin
    Painter.DrawHeaderBorder(ACanvas,
      cxRectInflate(AViewInfo.BoundsRect, -1, -1),
      AViewInfo.Neighbors, AViewInfo.Borders);

    Painter.DrawHeaderEx(ACanvas,
      BoundsRect, TextBounds, Neighbors, Borders, State, AlignHorz, AlignVert,
      MultiLine, ShowEndEllipsis, Text, ViewParams.Font, ViewParams.TextColor,
      ViewParams.Color, nil);
   end;

   ASortingImageSize := 0;
   if Assigned(SortImages) then
      ASortingImageSize := SortImages.Width;

    R := AViewInfo.BoundsRect;
    R.Left := R.Right - ASortingImageSize - 3;
    InflateRect(R, -1, -1);
    if AViewInfo.SortOrder <> soNone then
    begin
      //ACanvas.Brush.Color := AViewInfo. Color;
      ACanvas.Brush.Style := bsClear;
      if AViewInfo.SortOrder = soAscending then
         ASortingImageIndex := min(0, 11)
      else
         ASortingImageIndex := 11 + min(0, 11);
      if Assigned(SortImages) then
         ACanvas.DrawImage(SortImages, R.Left, R.Top, ASortingImageIndex);
    end;

  ADone := true
end;

procedure TdsdDBTreeAddOn.onGetNodeImageIndex(Sender: TcxCustomTreeList;
  ANode: TcxTreeListNode; AIndexType: TcxTreeListImageIndexType;
  var AIndex: TImageIndex);
begin
  // Устанавливаем индексы картинок
  if Assigned(FDBTreeList) then
    // Если раскрыта, то всегда изображение раскрытой папки!
    if ANode.Expanded then
       AIndex := 1
    else
       AIndex := 0;
end;

procedure TdsdDBTreeAddOn.SetDBTreeList(const Value: TcxDBTreeList);
begin
  FDBTreeList := Value;
  if Assigned(FDBTreeList) then begin
     FDBTreeList.OnKeyDown := OnKeyDown;
     FDBTreeList.OnDblClick := OnDblClick;
     FDBTreeList.onCustomDrawDataCell := onCustomDrawDataCell;
     FDBTreeList.OnGetNodeImageIndex := OnGetNodeImageIndex;
     FDBTreeList.OnColumnHeaderClick := OnColumnHeaderClick;
     FDBTreeList.OnCustomDrawHeaderCell := OnCustomDrawHeaderCell;
  end;
end;


procedure TdsdDBViewAddOn.ActionOnlyEditingCellOnEnter;
var i: integer;
    NextFocusIndex: integer;
begin
  // 1. Смотрим куда может идти
  NextFocusIndex := -1;
  for I := View.Controller.FocusedColumnIndex + 1 to View.VisibleColumnCount - 1 do
      if View.VisibleColumns[i].Editable then begin
         NextFocusIndex := i;
         break;
      end;
  // 2. Если есть куда на этой строчке, то идем на этой строчке
  if NextFocusIndex > -1 then begin
     View.Controller.FocusedColumnIndex := NextFocusIndex;
     View.Controller.FocusedItem.Editing := true;
  end;
  // 3. Если на этой строчке некуда и находимся в состоянии редактирования, то Post
  if (NextFocusIndex = -1) and (TcxDBDataController(FView.DataController).DataSource.State in [dsEdit, dsInsert]) then
     TcxDBDataController(FView.DataController).DataSource.DataSet.Post;
  // 4. Если есть куда на следующей, то идем на следующую
end;

constructor TdsdDBViewAddOn.Create(AOwner: TComponent);
begin
  inherited;
  edFilter := TcxTextEdit.Create(Self);
  edFilter.OnKeyDown := edFilterKeyDown;
  edFilter.Visible := false;

  edFilter.OnExit := edFilterExit;
  FBackGroundStyle := TcxStyle.Create(nil);
  FBackGroundStyle.Color := $00E4E4E4;
  FErasedStyle := TcxStyle.Create(nil);
  FErasedStyle.TextColor := clRed;
end;

procedure TdsdDBViewAddOn.OnColumnHeaderClick(Sender: TcxGridTableView;
  AColumn: TcxGridColumn);
begin
  // сотируем при нажатых Ctrl, Shift или Alt
  if not (ShiftDown or CtrlDown or AltDown) then
     Abort;
end;

procedure TdsdDBViewAddOn.OnCustomDrawCell(Sender: TcxCustomGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
  var ADone: Boolean);
var Column: TcxGridColumn;
begin
  if AViewInfo.Focused then begin
     ACanvas.Brush.Color := clHighlight;
     ACanvas.Font.Color := clHighlightText;
  end;
  // работаем со свойством Удален
  if (Sender is TcxGridDBTableView) then
      Column := TcxGridDBTableView(Sender).GetColumnByFieldName(FErasedFieldName);
  if (Sender is TcxGridDBBandedTableView) then
      Column := TcxGridDBBandedTableView(Sender).GetColumnByFieldName(FErasedFieldName);
  if Assigned(Column) then
     if not VarIsNull(AViewInfo.GridRecord.Values[Column.Index])
        and AViewInfo.GridRecord.Values[Column.Index] then
            ACanvas.Font.Color := FErasedStyle.TextColor;
end;

procedure TdsdDBViewAddOn.OnCustomDrawColumnHeader(
  Sender: TcxGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
var
  I: Integer;
  R: TRect;
  ASortingImageSize: Integer;
  ASortingImageIndex: Integer;
begin
  ASortingImageSize := 0;
  if Assigned(SortImages) then
     ASortingImageSize := SortImages.Width;
  with AViewInfo do
  begin
    Sender.Painter.LookAndFeelPainter.DrawHeader(ACanvas, Bounds, TextAreaBounds, Neighbors,
      Borders, ButtonState, AlignmentHorz, AlignmentVert, MultiLinePainting, TcxGridColumnHeaderViewInfoAccess(AViewinfo).ShowEndEllipsis,
      Text, Params.Font, Params.TextColor, Params.Color,
      nil, Column.IsMostRight,
      Container.Kind = ckGroupByBox);
    R := AViewInfo.ContentBounds;
    R.Left := R.Right - ASortingImageSize - 3;
    InflateRect(R, -1, -1);
    with TcxGridColumnHeaderViewInfoAccess(AViewinfo) do
      for I := 0 to AreaViewInfoCount - 1 do
        if AreaViewInfos[I] is TcxGridColumnHeaderFilterButtonViewInfo then
        begin
          if AViewInfo.ButtonState = cxbsHot then
          begin
            Sender.Painter.LookAndFeelPainter.DrawFilterDropDownButton(Canvas, AreaViewInfos[I].Bounds,
              GridCellStateToButtonState(AreaViewInfos[I].State), TcxGridColumnHeaderFilterButtonViewInfo(AreaViewInfos[I]).Active);
            R.Right := AreaViewInfos[I].Bounds.Left - 3;
            R.Left := R.Right - ASortingImageSize;
          end;
        end;
    if AViewInfo.Column.SortOrder <> soNone then
    begin
      ACanvas.Brush.Color := AViewInfo.Params.Color;
      ACanvas.Brush.Style := bsClear;
      if AViewInfo.Column.SortOrder = soAscending then
         ASortingImageIndex := min(AViewInfo.Column.SortIndex, 11)
      else
         ASortingImageIndex := 11 + min(AViewInfo.Column.SortIndex, 11);
      if Assigned(SortImages) then
         ACanvas.DrawImage(SortImages, R.Left, R.Top, ASortingImageIndex);
    end;
    ADone := True;
  end;
end;

procedure TdsdDBViewAddOn.OnExit(Sender: TObject);
begin
  if Assigned(FonExit) then
     FOnExit(Sender);
  if Assigned(FView) then
     if Assigned(TcxDBDataController(FView.DataController).DataSource) then
        if TcxDBDataController(FView.DataController).DataSource.State in dsEditModes then
           try
             TcxDBDataController(FView.DataController).DataSource.DataSet.Post;
             // В случае ошибки оставляем фокус
           except
             on E: Exception do begin
               FView.Control.SetFocus;
               raise;
             end;
           end;
end;

procedure TdsdDBViewAddOn.onFilterChanged(Sender: TObject);
begin
  if FView.DataController.Filter.Root.Count > 0 then
     FView.Styles.Background := FBackGroundStyle
  else
     FView.Styles.Background := nil
end;

destructor TdsdDBViewAddOn.Destroy;
begin
  if Assigned(FView) then begin
    FView.OnKeyDown := nil;
    FView.OnKeyPress := nil;
    FView.OnCustomDrawColumnHeader := nil;
    FView.DataController.Filter.OnChanged := nil;
    FView.OnColumnHeaderClick := nil;
    FView.OnDblClick := nil;
    FView.OnCustomDrawCell := nil;
    if Assigned(TcxDBDataController(FView.DataController).DataSource) then
       if Assigned(TcxDBDataController(FView.DataController).DataSource.DataSet) then
          TcxDBDataController(FView.DataController).DataSource.DataSet.AfterInsert := nil;
  end;
  FErasedStyle.Free;
  inherited;
end;

procedure TdsdDBViewAddOn.edFilterExit(Sender: TObject);
begin
  edFilter.Visible:=false;
  TWinControl(FView.GetParentComponent).SetFocus;
  FView.Focused := true;
end;

procedure TdsdDBViewAddOn.edFilterKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: begin lpSetFilter; Key := 0; end;
    VK_ESCAPE: edFilterExit(Sender);
  end;
end;

procedure TdsdDBViewAddOn.GridEditKeyEvent(Sender: TcxCustomGridTableView;
  AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Word;
  Shift: TShiftState);
begin
  if Assigned(FGridEditKeyEvent) then
     FGridEditKeyEvent(Sender, AItem, AEdit, Key, Shift);
  // Если нажат ТОЛЬКО Enter и OnlyEditingCellOnEnter
  if (Key = VK_RETURN) and (Shift = []) and OnlyEditingCellOnEnter then begin
     ActionOnlyEditingCellOnEnter;
     Key := 0;
  end;
end;

procedure TdsdDBViewAddOn.lpSetEdFilterPos(inKey: Char);
// процедура устанавливает контрол для внесения значения фильтра и позиционируется на заголовке колонки
var pRect:TRect;
begin
 if (not edFilter.Visible) then
   with FView.Controller do begin
     // позиционируем контрол на место заголовка
     edFilter.Visible := true;
     edFilter.Parent := TWinControl(FView.GetParentComponent);
     pRect := TcxGridTableView(GridView).ViewInfo.HeaderViewInfo.Items[FocusedItemIndex].Bounds;
     edFilter.Left := pRect.Left;
     edFilter.Top := pRect.Top;
     edFilter.Width := pRect.Right - pRect.Left + 1;
     edFilter.Height := pRect.Bottom - pRect.Top;
     edFilter.SetFocus;
     edFilter.Text := inKey;
     edFilter.SelStart := 1;
     edFilter.SelLength := 0;
   end;
end;

procedure TdsdDBViewAddOn.lpSetFilter;
   function GetFilterItem(ItemLink: TObject): TcxFilterCriteriaItem;
   var i: integer;
   begin
     result := nil;
     with FView.DataController.Filter.Root do
       for i := 0 to Count - 1 do
           if TcxFilterCriteriaItem(Items[i]).ItemLink = ItemLink then begin
              result := TcxFilterCriteriaItem(Items[i]);
              exit;
           end;
   end;
var
  FilterCriteriaItem: TcxFilterCriteriaItem;
begin
  edFilter.Visible := false;
  with TcxGridDBDataController(FView.DataController), Filter.Root do begin
    FilterCriteriaItem := GetFilterItem(GetItem(View.VisibleColumns[Controller.FocusedItemIndex].Index));
    if Assigned(FilterCriteriaItem) then begin
       FilterCriteriaItem.Value := '%' + edFilter.Text + '%';
       FilterCriteriaItem.DisplayValue := '"' + edFilter.Text + '"';
    end
    else
       AddItem(GetItem(View.VisibleColumns[Controller.FocusedItemIndex].Index), foLike, '%' + edFilter.Text + '%', '"' + edFilter.Text + '"');
  end;
  edFilter.Text := '';
  FView.DataController.Filter.Active := True;
end;

procedure TdsdDBViewAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FView) then begin
     FView := nil;
  end;
end;

procedure TdsdDBViewAddOn.OnGetContentStyle(Sender: TcxCustomGridTableView;
  ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem;
  out AStyle: TcxStyle);
var Column: TcxGridColumn;
begin
  if Assigned(FOnGetContentStyleEvent) then
     FOnGetContentStyleEvent(Sender, ARecord, AItem, AStyle);

  if ARecord = nil then exit;
  // Если это сгруппированная строка, то выходим
  if not ARecord.IsData then exit;
  // работаем со свойством Удален

  if (Sender is TcxGridDBTableView) then
      Column := TcxGridDBTableView(Sender).GetColumnByFieldName(FErasedFieldName);
  if (Sender is TcxGridDBBandedTableView) then
      Column := TcxGridDBBandedTableView(Sender).GetColumnByFieldName(FErasedFieldName);
  if Assigned(Column) then
     if not VarIsNull(ARecord.Values[Column.Index])
        and ARecord.Values[Column.Index] then
            AStyle := FErasedStyle;
end;

procedure TdsdDBViewAddOn.OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) and (View.DataController.Filter.Active) then
     View.DataController.Filter.Clear;
  inherited;
end;

procedure TdsdDBViewAddOn.OnKeyPress(Sender: TObject; var Key: Char);
var isReadOnly: boolean;
begin
  isReadOnly := false;
  if Assigned(TcxGridDBColumn(FView.Controller.FocusedColumn).Properties) then
     isReadOnly := TcxGridDBColumn(FView.Controller.FocusedColumn).Properties.ReadOnly;
  // если колонка не редактируема и введена буква или BackSpace то обрабатываем установку фильтра
  if (isReadOnly or  (not TcxGridDBColumn(FView.Controller.FocusedColumn).Editable)) and (Key > #31) then begin
     lpSetEdFilterPos(Char(Key));
     Key := #0;
  end;
end;

procedure TdsdDBViewAddOn.SetOnlyEditingCellOnEnter(const Value: boolean);
begin
  FOnlyEditingCellOnEnter := Value;
end;

procedure TdsdDBViewAddOn.SetView(const Value: TcxGridTableView);
begin
  FView := Value;
  if Assigned(FView) then begin
    if FView.Control is TcxGrid then begin
       FOnExit := TcxGrid(FView.Control).OnExit;
       TcxGrid(FView.Control).OnExit := OnExit;
    end;
    FOnKeyDown := FView.OnKeyDown;
    FView.OnKeyDown := OnKeyDown;
    FView.OnKeyPress := OnKeyPress;
    FView.OnCustomDrawColumnHeader := OnCustomDrawColumnHeader;
    FView.DataController.Filter.OnChanged := onFilterChanged;
    FView.OnColumnHeaderClick := OnColumnHeaderClick;
    FView.OnDblClick := OnDblClick;
    FView.OnCustomDrawCell := OnCustomDrawCell;
    FGridEditKeyEvent := FView.OnEditKeyDown;
    FView.OnEditKeyDown := GridEditKeyEvent;
    FOnGetContentStyleEvent := FView.Styles.OnGetContentStyle;
    FView.Styles.OnGetContentStyle := OnGetContentStyle;

    if Assigned(TcxDBDataController(FView.DataController).DataSource) then
       if Assigned(TcxDBDataController(FView.DataController).DataSource.DataSet) then begin
          FAfterInsert := TcxDBDataController(FView.DataController).DataSource.DataSet.AfterInsert;
          TcxDBDataController(FView.DataController).DataSource.DataSet.AfterInsert := OnAfterInsert;
       end;
  end;
end;

{ TdsdUserSettingsStorageAddOn }

constructor TdsdUserSettingsStorageAddOn.Create(AOwner: TComponent);
begin
  inherited;
  if csDesigning in ComponentState then
     exit;
  if AOwner is TForm then begin
     FOnDestroy := TForm(AOwner).OnDestroy;
     TForm(AOwner).OnDestroy := Self.OnDestroy;
  end;
end;

procedure TdsdUserSettingsStorageAddOn.OnDestroy(Sender: TObject);
begin
  if csDesigning in ComponentState then
     exit;
  SaveUserSettings;
  if Assigned(FOnDestroy) then
     FOnDestroy(Sender);
end;

procedure TdsdUserSettingsStorageAddOn.LoadUserSettings;
var
  Data: WideString;
  XMLDocument: IXMLDocument;
  i: integer;
  PropertiesStore: TcxPropertiesStore;
  GridView: TcxCustomGridView;
  TreeList: TcxDBTreeList;
  BarManager: TdxBarManager;
  FormName: string;
begin
  if gc_isSetDefault then
     exit;
  if Owner is TParentForm then
     FormName := TParentForm(Owner).FormClassName
  else
     FormName := Owner.ClassName;
  Data := StringReplace(TdsdFormStorageFactory.GetStorage.LoadUserFormSettings(FormName), '&', '&amp;', [rfReplaceAll]);
  if Data <> '' then begin
    XMLDocument := TXMLDocument.Create(nil);
    XMLDocument.LoadFromXML(Data);
    with XMLDocument.DocumentElement do begin
      for I := 0 to ChildNodes.Count - 1 do begin
        if ChildNodes[i].NodeName = 'cxGridView' then begin
           GridView := Owner.FindComponent(ChildNodes[i].GetAttribute('name')) as TcxCustomGridView;
           if Assigned(GridView) then
              GridView.RestoreFromStream(TStringStream.Create(gfStrXmlToStr(XMLToAnsi(ChildNodes[i].GetAttribute('data')))));
        end;
        if ChildNodes[i].NodeName = 'cxTreeList' then begin
           TreeList := Owner.FindComponent(ChildNodes[i].GetAttribute('name')) as TcxDBTreeList;
           if Assigned(TreeList) then
              TreeList.RestoreFromStream(TStringStream.Create(gfStrXmlToStr(XMLToAnsi(ChildNodes[i].GetAttribute('data')))));
        end;
        if ChildNodes[i].NodeName = 'dxBarManager' then begin
           BarManager := Owner.FindComponent(ChildNodes[i].GetAttribute('name')) as TdxBarManager;
           if Assigned(BarManager) then
              BarManager.LoadFromStream(TStringStream.Create(gfStrXmlToStr(XMLToAnsi(ChildNodes[i].GetAttribute('data')))));
        end;
        if ChildNodes[i].NodeName = 'cxPropertiesStore' then begin
           PropertiesStore := Owner.FindComponent(ChildNodes[i].GetAttribute('name')) as TcxPropertiesStore;
           if Assigned(PropertiesStore) then begin
              PropertiesStore.StorageType := stStream;
              PropertiesStore.StorageStream := TStringStream.Create(gfStrXmlToStr(XMLToAnsi(ChildNodes[i].GetAttribute('data'))));
              PropertiesStore.RestoreFrom;
              PropertiesStore.StorageStream.Free;
           end;
        end;
      end;
    end;
  end;
end;

procedure TdsdUserSettingsStorageAddOn.SaveUserSettings;
var
  TempStream: TStringStream;
  i: integer;
  xml: string;
  FormName: string;
begin
  if Owner is TParentForm then
     FormName := TParentForm(Owner).FormClassName
  else
     FormName := Owner.ClassName;
  TempStream :=  TStringStream.Create;
  try
    xml := '<root>';
    // Сохраняем установки гридов
    for i := 0 to Owner.ComponentCount - 1 do begin
      if Owner.Components[i] is TdxBarManager then
         with TdxBarManager(Owner.Components[i]) do begin
           SaveToStream(TempStream);
           xml := xml + '<dxBarManager name = "' + Name + '" data = "' + gfStrToXmlStr(TempStream.DataString) + '" />';
           TempStream.Clear;
         end;
      if Owner.Components[i] is TcxCustomGridView then
         with TcxCustomGridView(Owner.Components[i]) do begin
           StoreToStream(TempStream);
           xml := xml + '<cxGridView name = "' + Name + '" data = "' + gfStrToXmlStr(TempStream.DataString) + '" />';
           TempStream.Clear;
         end;
      if Owner.Components[i] is TcxDBTreeList then
         with TcxDBTreeList(Owner.Components[i]) do begin
           StoreToStream(TempStream);
           xml := xml + '<cxTreeList name = "' + Name + '" data = "' + gfStrToXmlStr(TempStream.DataString) + '" />';
           TempStream.Clear;
         end;
      // сохраняем остальные установки
      if Owner.Components[i] is TcxPropertiesStore then
         with Owner.Components[i] as TcxPropertiesStore do begin
            StorageType := stStream;
            StorageStream := TempStream;
            StoreTo;
            xml := xml + '<cxPropertiesStore name = "' + Name + '" data = "' + gfStrToXmlStr(TempStream.DataString) + '"/>';
            TempStream.Clear;
         end;
    end;
    xml := xml + '</root>';
    TdsdFormStorageFactory.GetStorage.SaveUserFormSettings(FormName, xml);
  finally
    TempStream.Free;
  end;
end;


{ THeaderSaver }

constructor THeaderSaver.Create(AOwner: TComponent);
begin
  inherited;
  FParam := TdsdParam.Create(nil);
  FControlList := TControlList.Create(Self, TControlListItem);
  FEnterValue := TStringList.Create;
  if Self.Owner is TParentForm then begin
     FOnAfterShow := TParentForm(Owner).onAfterShow;
     TParentForm(Owner).onAfterShow := onAfterShow;
  end;
end;

destructor THeaderSaver.Destroy;
begin
  FParam.Free;
  FControlList.Free;
  FEnterValue.Free;
  if Self.Owner is TParentForm then
     TParentForm(Owner).onAfterShow := FOnAfterShow;
  inherited;
end;

procedure THeaderSaver.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) then begin
      if AComponent is TControl then begin
         for i := 0 to ControlList.Count - 1 do
            if ControlList[i].Control = AComponent then
               ControlList[i].Control := nil;
      end;
      if AComponent = StoredProc then
         StoredProc := nil;
      if AComponent = FGetStoredProc then
         FGetStoredProc := nil;
    end;
end;

procedure THeaderSaver.OnAfterShow(Sender: TObject);
var i: integer;
begin
  if Assigned(FOnAfterShow) then
     FOnAfterShow(Sender);
  for I := 0 to ControlList.Count - 1 do
      onEnter(ControlList[i].Control)
end;

procedure THeaderSaver.OnEnter(Sender: TObject);
begin
  if Sender is TcxTextEdit then
     FEnterValue.Values[TComponent(Sender).Name] := (Sender as TcxTextEdit).Text;
  if Sender is TcxButtonEdit then
     FEnterValue.Values[TComponent(Sender).Name] := (Sender as TcxButtonEdit).Text;
  if Sender is TcxCurrencyEdit then
     FEnterValue.Values[TComponent(Sender).Name] := (Sender as TcxCurrencyEdit).Text;
  if Sender is TcxDateEdit then
     FEnterValue.Values[TComponent(Sender).Name] := (Sender as TcxDateEdit).Text;
  if Sender is TcxCheckBox then
     FEnterValue.Values[TComponent(Sender).Name] := BoolToStr((Sender as TcxCheckBox).Checked);
end;

procedure THeaderSaver.OnExit(Sender: TObject);
var isChanged: boolean;
begin
  isChanged := false;
  if not Assigned(IdParam) then
     raise Exception.Create('Не установлено свойство IdParam');
  if (IdParam.Value = 0) then
      exit;
  if Sender is TcxTextEdit then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxTextEdit).Text;
  if Sender is TcxButtonEdit then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxButtonEdit).Text;
  if Sender is TcxCurrencyEdit then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxCurrencyEdit).Text;
  if Sender is TcxDateEdit then begin
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxDateEdit).Text;
  end;
  if Sender is TcxCheckBox then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> BoolToStr((Sender as TcxCheckBox).Checked);

  try
    if isChanged then
       StoredProc.Execute;
  // Если в момент сохранения возникает ошибка, то вернем старое значение на гете
  except
    if Assigned(GetStoredProc) then
       GetStoredProc.Execute;
    raise;
  end;
end;

{ TControlList }

function TControlList.Add: TControlListItem;
begin
  result := TControlListItem(inherited Add);
end;

function TControlList.GetItem(Index: Integer): TControlListItem;
begin
  Result := TControlListItem(inherited GetItem(Index));
end;

procedure TControlList.SetItem(Index: Integer; const Value: TControlListItem);
begin
  inherited SetItem(Index, Value);
end;

{ TControlListItem }

function TControlListItem.GetDisplayName: string;
begin
  if Assigned(Control) then
     result := Control.Name
  else
     result := inherited;
end;

procedure TControlListItem.SetControl(const Value: TControl);
begin
  if FControl <> Value then begin
    FControl := Value;
    if Assigned(Value) and Assigned(Collection) then begin
       Value.FreeNotification(TComponent(Collection.Owner));
       if (Collection.Owner is THeaderSaver) then begin
          if FControl is TcxTextEdit then begin
             (FControl as TcxTextEdit).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxTextEdit).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxDateEdit then begin
             (FControl as TcxDateEdit).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxDateEdit).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxButtonEdit then begin
             (FControl as TcxButtonEdit).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxButtonEdit).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxCheckBox then begin
             (FControl as TcxCheckBox).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxCheckBox).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
          if FControl is TcxCurrencyEdit then begin
             (FControl as TcxCurrencyEdit).OnEnter := THeaderSaver(Collection.Owner).OnEnter;
             (FControl as TcxCurrencyEdit).OnExit := THeaderSaver(Collection.Owner).OnExit;
          end;
       end;
    end;
  end;
end;

{ TRefreshAddOn }

constructor TRefreshAddOn.Create(AOwner: TComponent);
begin
  inherited;
  DataSet := 'ClientDataSet';
  RefreshAction := 'actRefresh';
  FormParams := 'FormParams';
  FKeyField := 'Id';
  if AOwner is TForm then begin
     FOnClose := (AOwner as TForm).OnClose;
     (AOwner as TForm).OnClose := Self.OnClose;
  end;
end;

destructor TRefreshAddOn.Destroy;
begin
  if Owner is TForm then
     TForm(Owner).OnClose := FOnClose;
  inherited;
end;

procedure TRefreshAddOn.OnClose(Sender: TObject; var Action: TCloseAction);
var i: integer;
begin
  // Перечитываем и позиционируемся
  // Только сначала находим форму указанного типа
  for I := 0 to Screen.FormCount - 1 do
      if lowercase(Screen.Forms[i].Name) = lowercase(FormName) then
         with Screen.Forms[i] do begin
           if Assigned(FindComponent(RefreshAction)) then
              TdsdDataSetRefresh(FindComponent(RefreshAction)).Execute;
           if Assigned(FindComponent(DataSet)) and Assigned(Self.Owner.FindComponent(FormParams)) then
              if Assigned(TDataSet(FindComponent(DataSet)).FindField(KeyField)) then
                 TDataSet(FindComponent(DataSet)).Locate(KeyField, TdsdFormParams(Self.Owner.FindComponent(FormParams)).ParamByName(FKeyField).AsString, []);
         end;
  if Assigned(FOnClose) then
     FOnClose(Sender, Action);
end;

{ TCustomDBControlAddOn }

constructor TCustomDBControlAddOn.Create(AOwner: TComponent);
begin
  inherited;
  FErasedFieldName := gcisErased;
  ActionItemList := TActionItemList.Create(Self, TShortCutActionItem);
  OnDblClickActionList := TActionItemList.Create(Self, TActionItem);
end;

procedure TCustomDBControlAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) then begin
      if AComponent is TCustomAction then begin
         for i := 0 to ActionItemList.Count - 1 do
            if ActionItemList[i].Action = AComponent then
               ActionItemList[i].Action := nil;
         for i := 0 to OnDblClickActionList.Count - 1 do
            if OnDblClickActionList[i].Action = AComponent then
               OnDblClickActionList[i].Action := nil;
      end;
      if AComponent = SortImages then
         SortImages := nil
    end;
end;

procedure TCustomDBControlAddOn.OnAfterInsert(DataSet: TDataSet);
var Field: TField;
begin
  if Assigned(FAfterInsert) then
     FAfterInsert(DataSet);
  Field := DataSet.FindField(ErasedFieldName);
  if Assigned(Field) then
     Field.AsBoolean := false;
end;

procedure TCustomDBControlAddOn.OnDblClick(Sender: TObject);
var i: integer;
begin
  // Выполняем События на DblClick
  for I := 0 to FOnDblClickActionList.Count - 1 do
    if Assigned(FOnDblClickActionList[i].Action) then
       if OnDblClickActionList[i].Action.Enabled then begin
          // Выполнили первое действие в списке
          OnDblClickActionList[i].Action.Execute;
          // И сразу вышли!!!
          exit;
       end;
end;

procedure TCustomDBControlAddOn.OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i: integer;
begin                       
  if Assigned(FOnKeyDown) then
     FOnKeyDown(Sender, Key, Shift);

  // Сначала проверим все action
  // и если там нет ничего, то тогда идем дальше
  for I := 0 to ActionItemList.Count - 1 do
      if ShortCut(Key, Shift) = TShortCutActionItem(ActionItemList[i]).ShortCut then begin
         if ActionItemList[i].Action.Enabled then begin
            // Выполнили первое действие в списке
            ActionItemList[i].Action.Execute;
            Key := 0;
            Shift := [];
            // И сразу вышли!!!
            exit;
         end;
      end;
end;

{ TRefreshDispatcher }

constructor TRefreshDispatcher.Create(AOwner: TComponent);
begin
  inherited;
  ComponentList := TOwnedCollection.Create(Self, TComponentListItem);
end;

destructor TRefreshDispatcher.Destroy;
begin
  ComponentList.Free;
  inherited;
end;

procedure TRefreshDispatcher.Notification(AComponent: TComponent;
  Operation: TOperation);
var i: integer;
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) then begin
      if AComponent = FRefreshAction then
         FRefreshAction := nil;
      if AComponent = FShowDialogAction then
         FShowDialogAction := nil;
      for i := 0 to ComponentList.Count - 1 do
         if TComponentListItem(ComponentList.Items[i]).Component = AComponent then
            TComponentListItem(ComponentList.Items[i]).Component := nil;
    end;
end;

procedure TRefreshDispatcher.OnComponentChange(Sender: TObject);
begin
  if Assigned(FRefreshAction) then
  // перечитываем запросы только если форма загружена
     if Assigned(Self.Owner) and (Self.Owner is TParentForm)
       and TParentForm(Self.Owner).Visible then
        FRefreshAction.Execute
end;

procedure TRefreshDispatcher.SetShowDialogAction(const Value: TExecuteDialog);
begin
  if FShowDialogAction <> Value then begin
     if Assigned(Value) then
        Value.RefreshDispatcher := Self;
     if Assigned(FShowDialogAction) then
        FShowDialogAction.RefreshDispatcher := nil;
     FShowDialogAction := Value;
  end;
end;

{ TComponentListItem }

function TComponentListItem.GetDisplayName: string;
begin
  result := inherited;
  if Assigned(FComponent) then
     result := FComponent.Name
end;

procedure TComponentListItem.OnChange(Sender: TObject);
begin
  // Вызываем onChange если был
  if Assigned(FOnChange) then
     FOnChange(Sender);
  // Перечитываем запросы
  if Assigned(TRefreshDispatcher(Collection.Owner)) then
     TRefreshDispatcher(Collection.Owner).OnComponentChange(Sender);
end;

procedure TComponentListItem.SetComponent(const Value: TComponent);
begin
  FComponent := Value;
  if Assigned(FComponent) then begin
     if Assigned(Collection) then
        FComponent.FreeNotification(TComponent(Collection.Owner));
     if FComponent is TPeriodChoice then begin
        FOnChange := TPeriodChoice(FComponent).onChange;
        TPeriodChoice(FComponent).onChange := OnChange;
     end;
     if FComponent is TdsdGuides then begin
        FOnChange := TdsdGuides(FComponent).onChange;
        TdsdGuides(FComponent).onChange := OnChange;
     end;
  end;
end;

{ TExecuteDialog }

constructor TExecuteDialog.Create(AOwner: TComponent);
begin
  inherited;
  isShowModal := true;
  OpenBeforeShow := true;
  RefreshAllow := true;
end;

function TExecuteDialog.Execute: boolean;
begin
  result := false;
  with TParentForm(ShowForm) do
    if ModalResult = mrOk then begin
       result := true;
       Self.GuiParams.AssignParams(AddOnFormData.Params.Params);
       if Assigned(RefreshDispatcher) and Assigned(RefreshDispatcher.RefreshAction) and RefreshAllow then
          RefreshDispatcher.RefreshAction.Execute;// OnComponentChange(Self);
       RefreshAllow := true;
    end;
end;

procedure TExecuteDialog.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDesigning in ComponentState then
     if (Operation = opRemove) and (AComponent = FRefreshDispatcher) then
        FRefreshDispatcher := nil;
end;

{ TCrossDBViewAddOn }

constructor TCrossDBViewAddOn.Create(AOwner: TComponent);
begin
  inherited;
  FCreateColumnList := TList.Create;
end;

destructor TCrossDBViewAddOn.Destroy;
begin
  FreeAndNil(FCreateColumnList);
  inherited;
end;

procedure TCrossDBViewAddOn.FocusedItemChanged(Sender: TcxCustomGridTableView;
  APrevFocusedItem, AFocusedItem: TcxCustomGridTableItem);
begin
  if Assigned(FFocusedItemChanged) then
     FFocusedItemChanged(Sender, APrevFocusedItem, AFocusedItem);
  if TcxDBDataController(FView.DataController).DataSource.State = dsEdit then begin
     // Если ошибка, то вернем в прошлую ячейку
     try
       TcxDBDataController(FView.DataController).DataSource.DataSet.Post;
     except
       TcxDBDataController(FView.DataController).DataSource.DataSet.Cancel;
       FView.Controller.FocusedItem := APrevFocusedItem;
       raise;
     end;
  end;
end;

procedure TCrossDBViewAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDesigning in ComponentState then
     if Operation = opRemove then begin
        if AComponent = HeaderDataSet then
           HeaderDataSet := nil;
        if AComponent = FTemplateColumn then
           FTemplateColumn := nil;
     end;
end;

procedure TCrossDBViewAddOn.onAfterClose(DataSet: TDataSet);
var i: integer;
begin
  if Assigned(FAfterClose) then
     FAfterClose(DataSet);

  for i := 0 to FCreateColumnList.Count - 1 do
    View.Columns[View.ColumnCount - 1].Destroy;

  FCreateColumnList.Clear;
end;

procedure TCrossDBViewAddOn.onBeforeOpen(DataSet: TDataSet);
var NewColumnIndex: integer;
    Column: TcxGridColumn;
begin
  if Assigned(FBeforeOpen) then
     FBeforeOpen(DataSet);
  View.BeginUpdate;
    try
      // Заполняем заголовки колонок
      if Assigned(HeaderDataSet) and HeaderDataSet.Active then begin
         if not Assigned(HeaderDataSet.Fields.FindField(HeaderColumnName)) then
            raise Exception.Create('HeaderDataSet не имеет поля ' + HeaderColumnName);
         if not Assigned(TemplateColumn) then
            raise Exception.Create('TemplateColumn не установлен ');
         HeaderDataSet.First;
         NewColumnIndex := 1;
         while not HeaderDataSet.Eof do begin
           Column := View.CreateColumn;
           FCreateColumnList.Add(Column);
           with Column do begin
             Assign(TemplateColumn);
             Visible := true;
             Caption := HeaderDataSet.FieldByName(HeaderColumnName).AsString;
             Width := TemplateColumn.Width;
             if Column is TcxGridDBBandedColumn then
                TcxGridDBBandedColumn(Column).DataBinding.FieldName := TcxGridDBBandedColumn(TemplateColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
             if Column is TcxGridDBColumn then
                TcxGridDBColumn(Column).DataBinding.FieldName := TcxGridDBColumn(TemplateColumn).DataBinding.FieldName + IntToStr(NewColumnIndex);
           end;
           inc(NewColumnIndex);
           HeaderDataSet.Next;
         end;
      end;
    finally
      View.EndUpdate;
    end;
end;

procedure TCrossDBViewAddOn.onEditing(Sender: TcxCustomGridTableView;
  AItem: TcxCustomGridTableItem; var AAllow: Boolean);
begin
  if Assigned(FEditing) then
     FEditing(Sender, AItem, AAllow);
  if Assigned(HeaderDataSet) then
     HeaderDataSet.Locate(HeaderColumnName, Aitem.Caption, []);
end;

procedure TCrossDBViewAddOn.SetView(const Value: TcxGridTableView);
begin
  inherited;
  if Value <> nil then begin
     FDataSet := TcxDBDataController(Value.DataController).DataSet;
     FBeforeOpen := FDataSet.BeforeOpen;
     FDataSet.BeforeOpen := onBeforeOpen;
     FAfterClose := FDataSet.AfterClose;
     FDataSet.AfterClose := onAfterClose;
     FEditing := Value.OnEditing;
     Value.OnEditing := onEditing;
     FFocusedItemChanged := Value.OnFocusedItemChanged;
     Value.OnFocusedItemChanged := FocusedItemChanged;
  end;
end;

{ TAddOnFormData }

constructor TAddOnFormData.Create;
begin
  FisAlwaysRefresh := true;
  FisSingle := true;
end;

end.
