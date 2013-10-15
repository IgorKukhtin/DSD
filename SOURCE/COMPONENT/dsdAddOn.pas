unit dsdAddOn;

interface

uses Classes, cxDBTL, cxTL, Vcl.ImgList, cxGridDBTableView,
     cxTextEdit, DB, dsdAction, cxGridTableView,
     VCL.Graphics, cxGraphics, cxStyles, Forms, Controls,
     SysUtils, dsdDB, Contnrs, cxGridCustomView, cxGridCustomTableView, dsdGuides, VCL.ActnList;

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
    procedure OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
    FView: TcxGridDBTableView;
    FonExit: TNotifyEvent;
    // контрол для ввода условия фильтра
    edFilter: TcxTextEdit;
    procedure OnKeyPress(Sender: TObject; var Key: Char);
    procedure SetView(const Value: TcxGridDBTableView); virtual;
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
    // рисуем свой цвет у выделенной ячейки
    procedure OnCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    // поменять цвет грида в случае установки фильтра
    procedure onFilterChanged(Sender: TObject);
    // если при выходе из грида ДатаСет в Edit mode, то делаем Post
    procedure OnExit(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property View: TcxGridDBTableView read FView write SetView;
    property OnDblClickActionList;
    property ActionItemList;
    property SortImages;
  end;

  TCrossDBViewAddOn = class(TdsdDBViewAddOn)
  private
    FHeaderDataSet: TDataSet;
    FTemplateColumn: TcxGridDBColumn;
    FHeaderColumnName: String;
    FFirstOpen: boolean;
    FBeforeOpen: TDataSetNotifyEvent;
    FEditing: TcxGridEditingEvent;
    procedure onEditing(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
         var AAllow: Boolean);
    procedure onBeforeOpen(DataSet: TDataSet);
    procedure SetView(const Value: TcxGridDBTableView); override;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    // Дата сет с названием колонок и другой необходимой для работы информацией.
    property HeaderDataSet: TDataSet read FHeaderDataSet write FHeaderDataSet;
    // Поле в HeaderDataSet с названиями колонок кроса
    property HeaderColumnName: String read FHeaderColumnName write FHeaderColumnName;
    // Шаблон для Cross колонок
    property TemplateColumn: TcxGridDBColumn read FTemplateColumn write FTemplateColumn;
  end;

  TdsdUserSettingsStorageAddOn = class(TComponent)
  private
    FOnClose: TCloseEvent;
    FOnShow: TNotifyEvent;
    FForm: TForm;
    procedure OnClose(Sender: TObject; var Action: TCloseAction);
    procedure OnShow(Sender: TObject);
    procedure LoadUserSettings;
    procedure SaveUserSettings;
  public
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
    procedure OnClose(Sender: TObject; var Action: TCloseAction);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property FormName: string read FFormName write FFormName;
    property DataSet: string read FDataSet write FDataSet;
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

  procedure Register;

implementation

uses utilConvert, FormStorage, Xml.XMLDoc, XMLIntf, Windows,
     cxFilter, cxClasses, cxLookAndFeelPainters, cxCustomData,
     cxGridCommon, math, cxPropertiesStore, UtilConst, cxStorage,
     cxGeometry, cxCalendar, cxCheckBox, dxBar, cxButtonEdit, cxCurrencyEdit,
     VCL.Menus, ParentForm, ChoicePeriod, cxGrid, cxDBData, Variants;

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
  if csDesigning in ComponentState then
    if (Operation = opRemove) and (AComponent = DBTreeList) then
       DBTreeList := nil;
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

{ TdsdDBFilterAddOn }

constructor TdsdDBViewAddOn.Create(AOwner: TComponent);
begin
  inherited;
  edFilter := TcxTextEdit.Create(Self);
  edFilter.OnKeyDown := edFilterKeyDown;
  edFilter.Visible := false;

  edFilter.OnExit := edFilterExit;
  FBackGroundStyle := TcxStyle.Create(nil);
  FBackGroundStyle.Color := $00E4E4E4;
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
var Column: TcxGridDBColumn;
begin
  if AViewInfo.Focused then begin
     ACanvas.Brush.Color := clHighlight;
     ACanvas.Font.Color := clHighlightText;
  end;
  // работаем со свойством Удален
  Column := FView.GetColumnByFieldName(FErasedFieldName);
  if Assigned(Column) then
     if not VarIsNull(AViewInfo.GridRecord.Values[Column.Index])
       and AViewInfo.GridRecord.Values[Column.Index] then
        ACanvas.Font.Color := clRed;
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
        if TcxDBDataController(FView.DataController).DataSource.State in [dsEdit, dsInsert] then
           TcxDBDataController(FView.DataController).DataSource.DataSet.Post;
end;

procedure TdsdDBViewAddOn.onFilterChanged(Sender: TObject);
begin
  if FView.DataController.Filter.Root.Count > 0 then
     FView.Styles.Background := FBackGroundStyle
  else
     FView.Styles.Background := nil
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
  with FView.DataController, Filter.Root do begin
    FilterCriteriaItem := GetFilterItem(GetItem(Controller.FocusedItemIndex));
    if Assigned(FilterCriteriaItem) then begin
       FilterCriteriaItem.Value := '%' + edFilter.Text + '%';
       FilterCriteriaItem.DisplayValue := '"' + edFilter.Text + '"';
    end
    else
       AddItem(FView.DataController.GetItem(FView.Controller.FocusedItemIndex) , foLike, '%' + edFilter.Text + '%', '"' + edFilter.Text + '"');
  end;
  edFilter.Text := '';
  FView.DataController.Filter.Active := True;
end;

procedure TdsdDBViewAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDesigning in ComponentState then
    if (Operation = opRemove) and (AComponent = FView) then begin
       FView := nil;
       FonExit := nil;
    end;
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

procedure TdsdDBViewAddOn.SetView(const Value: TcxGridDBTableView);
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
    if Assigned(FView.DataController.DataSource) then
       if Assigned(FView.DataController.DataSource.DataSet) then begin
          FAfterInsert := FView.DataController.DataSource.DataSet.AfterInsert;
          FView.DataController.DataSource.DataSet.AfterInsert := OnAfterInsert;
       end;
  end;
end;

{ TdsdUserSettingsStorageAddOn }

constructor TdsdUserSettingsStorageAddOn.Create(AOwner: TComponent);
begin
  inherited;
  if AOwner is TCustomForm then begin
     FForm := AOwner as TForm;
     FOnClose := FForm.OnClose;
     FOnShow := FForm.OnShow;
     FForm.OnClose := Self.OnClose;
     FForm.OnShow := Self.OnShow;
  end;
end;

procedure TdsdUserSettingsStorageAddOn.OnShow(Sender: TObject);
begin
  LoadUserSettings;
  if Assigned(FOnShow) then
     FOnShow(Sender)
end;

procedure TdsdUserSettingsStorageAddOn.OnClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveUserSettings;
  if Assigned(FOnClose) then
     FOnClose(Sender, Action);
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
  GridFooter: boolean;
begin
  if FForm is TParentForm then
     FormName := TParentForm(FForm).FormClassName
  else
     FormName := FForm.ClassName;
  Data := StringReplace(TdsdFormStorageFactory.GetStorage.LoadUserFormSettings(FormName), '&', '&amp;', [rfReplaceAll]);
  if Data <> '' then begin
    XMLDocument := TXMLDocument.Create(nil);
    XMLDocument.LoadFromXML(Data);
    with XMLDocument.DocumentElement do begin
      for I := 0 to ChildNodes.Count - 1 do begin
        if ChildNodes[i].NodeName = 'cxGridView' then begin
           GridView := FForm.FindComponent(ChildNodes[i].GetAttribute('name')) as TcxCustomGridView;
           if Assigned(GridView) then begin
              // Это свойство не восстанавливать
              GridFooter := TcxGridDBTableView(GridView).OptionsView.Footer;
              GridView.RestoreFromStream(TStringStream.Create(gfStrXmlToStr(XMLToAnsi(ChildNodes[i].GetAttribute('data')))));
              TcxGridDBTableView(GridView).OptionsView.Footer := GridFooter;
           end;
        end;
        if ChildNodes[i].NodeName = 'cxTreeList' then begin
           TreeList := FForm.FindComponent(ChildNodes[i].GetAttribute('name')) as TcxDBTreeList;
           if Assigned(TreeList) then begin
              TreeList.RestoreFromStream(TStringStream.Create(gfStrXmlToStr(XMLToAnsi(ChildNodes[i].GetAttribute('data')))));
           end;
        end;
        if ChildNodes[i].NodeName = 'dxBarManager' then begin
           BarManager := FForm.FindComponent(ChildNodes[i].GetAttribute('name')) as TdxBarManager;
           if Assigned(BarManager) then begin
              BarManager.LoadFromStream(TStringStream.Create(gfStrXmlToStr(XMLToAnsi(ChildNodes[i].GetAttribute('data')))));
           end;
        end;
        if ChildNodes[i].NodeName = 'cxPropertiesStore' then begin
           PropertiesStore := FForm.FindComponent(ChildNodes[i].GetAttribute('name')) as TcxPropertiesStore;
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
  if FForm is TParentForm then
     FormName := TParentForm(FForm).FormClassName
  else
     FormName := FForm.ClassName;
  TempStream :=  TStringStream.Create;
  try
    xml := '<root>';
    // Сохраняем установки гридов
    for i := 0 to FForm.ComponentCount - 1 do begin
      if FForm.Components[i] is TdxBarManager then
         with TdxBarManager(FForm.Components[i]) do begin
           SaveToStream(TempStream);
           xml := xml + '<dxBarManager name = "' + Name + '" data = "' + gfStrToXmlStr(TempStream.DataString) + '" />';
           TempStream.Clear;
         end;
      if FForm.Components[i] is TcxCustomGridView then
         with TcxCustomGridView(FForm.Components[i]) do begin
           StoreToStream(TempStream);
           xml := xml + '<cxGridView name = "' + Name + '" data = "' + gfStrToXmlStr(TempStream.DataString) + '" />';
           TempStream.Clear;
         end;
      if FForm.Components[i] is TcxDBTreeList then
         with TcxDBTreeList(FForm.Components[i]) do begin
           StoreToStream(TempStream);
           xml := xml + '<cxTreeList name = "' + Name + '" data = "' + gfStrToXmlStr(TempStream.DataString) + '" />';
           TempStream.Clear;
         end;
      // сохраняем остальные установки
      if FForm.Components[i] is TcxPropertiesStore then
         with FForm.Components[i] as TcxPropertiesStore do begin
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
   S:string;
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
     s := (Sender as TcxDateEdit).Text;
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> s;//(Sender as TcxDateEdit).Text;
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
              TDataSet(FindComponent(DataSet)).Locate('Id', TdsdFormParams(Self.Owner.FindComponent(FormParams)).ParamByName('Id').AsString, []);
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
        and TParentForm(Self.Owner).isAfterShow then
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
  with ShowForm do
    if ModalResult = mrOk then begin
       result := true;
       Self.GuiParams.AssignParams(Params);
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
  FFirstOpen := false;
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

procedure TCrossDBViewAddOn.onBeforeOpen(DataSet: TDataSet);
var NewColumnIndex: integer;
begin
  if Assigned(FBeforeOpen) then
     FBeforeOpen(DataSet);
  if not FFirstOpen then
    try
      // Заполняем заголовки колонок
      if Assigned(HeaderDataSet) and HeaderDataSet.Active then begin
         HeaderDataSet.First;
         NewColumnIndex := 1;
         while not HeaderDataSet.Eof do begin
           with View.CreateColumn  do begin
             Assign(TemplateColumn);
             Caption := HeaderDataSet.FieldByName(HeaderColumnName).AsString;
             DataBinding.FieldName := TemplateColumn.DataBinding.FieldName + '_' + IntToStr(NewColumnIndex);
             Width := TemplateColumn.Width;
           end;
           inc(NewColumnIndex);
           HeaderDataSet.Next;
         end;
      end;
      // И удаляем шаблон
      if Assigned(TemplateColumn) then
         TemplateColumn.Free;
    finally
      FFirstOpen := true;
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

procedure TCrossDBViewAddOn.SetView(const Value: TcxGridDBTableView);
begin
  inherited;
  if Value <> nil then begin
     FBeforeOpen := Value.DataController.DataSource.DataSet.BeforeOpen;
     Value.DataController.DataSource.DataSet.BeforeOpen := onBeforeOpen;
     FEditing := Value.OnEditing;
     Value.OnEditing := onEditing;
  end;
end;

end.
