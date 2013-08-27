unit dsdAddOn;

interface

uses Classes, cxDBTL, cxTL, Vcl.ImgList, cxGridDBTableView,
     cxTextEdit, DB, dsdAction, cxGridTableView,
     VCL.Graphics, cxGraphics, cxStyles, Forms, Controls,
     VCL.ActnList, SysUtils, dsdDB, Contnrs;

type

  TActionItem = class(TCollectionItem)
  private
    FSecondaryShortCuts: TShortCutList;
    FShortCut: TShortCut;
    FAction: TCustomAction;
    procedure SetAction(const Value: TCustomAction);
    procedure SetShortCut(const Value: TShortCut);
    function GetSecondaryShortCuts: TShortCutList;
    procedure SetSecondaryShortCuts(const Value: TShortCutList);
    function IsSecondaryShortCutsStored: Boolean;
  public
    constructor Create(Collection: TCollection); override;
  published
    property Action: TCustomAction read FAction write SetAction;
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

  TdsdDBTreeAddOn = class(TComponent)
  private
    FDBTreeList: TcxDBTreeList;
    FisLeafFieldName: String;
    FImages: TImageList;
    procedure SetDBTreeList(const Value: TcxDBTreeList);
    // сотируем при нажатых Ctrl, Shift или Alt
    procedure onColumnHeaderClick(Sender: TcxCustomTreeList; AColumn: TcxTreeListColumn);
    // рисуем свои иконки
    procedure onCustomDrawHeaderCell(Sender: TcxCustomTreeList;
       ACanvas: TcxCanvas; AViewInfo: TcxTreeListHeaderCellViewInfo;
       var ADone: Boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure onGetNodeImageIndex(Sender: TcxCustomTreeList; ANode: TcxTreeListNode;
              AIndexType: TcxTreeListImageIndexType; var AIndex: TImageIndex);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property SortImages: TImageList read FImages write FImages;
    property isLeafFieldName: String read FisLeafFieldName write FisLeafFieldName;
    property DBTreeList: TcxDBTreeList read FDBTreeList write SetDBTreeList;
  end;

  ESortException = class(Exception)

  end;

  // Добавляет ряд функционала на GridView
  // 1. Быстрая установка фильтров
  // 2. Рисование иконок сортировки
  TdsdDBViewAddOn = class(TComponent)
  private
    FBackGroundStyle: TcxStyle;
    FView: TcxGridDBTableView;
    // контрол для ввода условия фильтра
    edFilter: TcxTextEdit;
    FImages: TImageList;
    FOnDblClickAction: TCustomAction;
    FActionItemList: TActionItemList;
    procedure OnDblClick(Sender: TObject);
    procedure OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OnKeyPress(Sender: TObject; var Key: Char);
    procedure SetView(const Value: TcxGridDBTableView);
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
    // поменять цвет грида в случае установки фильтра
    procedure onFilterChanged(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property OnDblClickAction: TCustomAction read FOnDblClickAction write FOnDblClickAction;
    property SortImages: TImageList read FImages write FImages;
    property View: TcxGridDBTableView read FView write SetView;
    property ActionItemList: TActionItemList read FActionItemList write FActionItemList;
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

  TControlList = class(TCollection)
  private
    function GetItem(Index: Integer): TControlListItem;
    procedure SetItem(Index: Integer; const Value: TControlListItem);
  public
    HeaderSaver: THeaderSaver;
    constructor Create(HeaderSaver: THeaderSaver);
    function Add: TControlListItem;
    property Items[Index: Integer]: TControlListItem read GetItem write SetItem; default;
  end;

  // Вызывает процедуру
  THeaderSaver = class(TComponent)
  private
    FControlList: TControlList;
    FStoredProc: TdsdStoredProc;
    FEnterValue: TStringList;
    procedure OnEnter(Sender: TObject);
    procedure OnExit(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property StoredProc: TdsdStoredProc read FStoredProc write FStoredProc;
    property ControlList: TControlList read FControlList write FControlList;
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
  published
    property FormName: string read FFormName write FFormName;
    property DataSet: string read FDataSet write FDataSet;
    property RefreshAction: string read FRefreshAction write FRefreshAction;
    property FormParams: string read FFormParams write FFormParams;
  end;

  procedure Register;

implementation

uses utilConvert, FormStorage, Xml.XMLDoc, XMLIntf, Windows,
     cxFilter, cxClasses, cxLookAndFeelPainters, cxCustomData,
     cxGridCommon, math, cxPropertiesStore, cxGridCustomView, UtilConst, cxStorage,
     cxGeometry, cxCalendar, cxCheckBox, dxBar, cxButtonEdit, cxCurrencyEdit,
     VCL.Menus, ParentForm;

type

  TcxGridColumnHeaderViewInfoAccess = class(TcxGridColumnHeaderViewInfo);

procedure Register;
begin
   RegisterComponents('DSDComponent', [THeaderSaver]);
   RegisterComponents('DSDComponent', [TdsdDBTreeAddOn]);
   RegisterComponents('DSDComponent', [TdsdDBViewAddOn]);
   RegisterComponents('DSDComponent', [TdsdUserSettingsStorageAddOn]);
   RegisterComponents('DSDComponent', [TRefreshAddOn]);
end;

{ TdsdDBTreeAddOn }

constructor TdsdDBTreeAddOn.Create(AOwner: TComponent);
begin
  inherited;
  isLeafFieldName := 'isLeaf';
end;

procedure TdsdDBTreeAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
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

procedure TdsdDBTreeAddOn.onCustomDrawHeaderCell(Sender: TcxCustomTreeList;
  ACanvas: TcxCanvas; AViewInfo: TcxTreeListHeaderCellViewInfo;
  var ADone: Boolean);
var
  I: Integer;
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
    if ANode.Expanded then
       AIndex := 1
    else
       if ANode.CanExpand then
          AIndex := 0
       else
          AIndex := 2;
end;

procedure TdsdDBTreeAddOn.SetDBTreeList(const Value: TcxDBTreeList);
begin
  FDBTreeList := Value;
  if Assigned(FDBTreeList) then begin
     FDBTreeList.OnGetNodeImageIndex := OnGetNodeImageIndex;
     FDBTreeList.OnColumnHeaderClick := OnColumnHeaderClick;
     FDBTreeList.OnCustomDrawHeaderCell := OnCustomDrawHeaderCell;
  end;
end;

{ TdsdDBFilterAddOn }

constructor TdsdDBViewAddOn.Create(AOwner: TComponent);
begin
  inherited;
  ActionItemList := TActionItemList.Create(TActionItem);

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

procedure TdsdDBViewAddOn.OnCustomDrawColumnHeader(
  Sender: TcxGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
var
  I: Integer;
  R: TRect;
  ASortingImageSize: Integer;
  ASortingImageIndex: Integer;
begin
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

procedure TdsdDBViewAddOn.OnDblClick(Sender: TObject);
begin
  if Assigned(FOnDblClickAction) then
     FOnDblClickAction.Execute
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
     pRect := GridView.ViewInfo.HeaderViewInfo.Items[FocusedItemIndex].Bounds;
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
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FView) then
     FView := nil;
  if (Operation = opRemove) and (AComponent = FOnDblClickAction) then
     FOnDblClickAction := nil;
end;

procedure TdsdDBViewAddOn.OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i: integer;
begin
  // Сначала проверим все action
  // и если там нет ничего, то тогда идем дальше
  for I := 0 to ActionItemList.Count - 1 do
      if ShortCut(Key, Shift) = ActionItemList[i].ShortCut then begin
         ActionItemList[i].Action.Execute;
         Key := 0;
         Shift := [];
      end;
end;

procedure TdsdDBViewAddOn.OnKeyPress(Sender: TObject; var Key: Char);
begin
  // если колонка не редактируема и введена буква или BackSpace то обрабатываем установку фильтра
  if {TcxGridDBColumn(FView.Controller.FocusedColumn).Properties.ReadOnly and} (Key > #31) then begin
     lpSetEdFilterPos(Char(Key));
     Key := #0;
  end;
end;

procedure TdsdDBViewAddOn.SetView(const Value: TcxGridDBTableView);
begin
  FView := Value;
  FView.OnKeyDown := OnKeyDown;
  FView.OnKeyPress := OnKeyPress;
  FView.OnCustomDrawColumnHeader := OnCustomDrawColumnHeader;
  FView.DataController.Filter.OnChanged := onFilterChanged;
  FView.OnColumnHeaderClick := OnColumnHeaderClick;
  FView.OnDblClick := OnDblClick;
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
     OnShow(Sender)
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
              GridView.RestoreFromStream(TStringStream.Create(gfStrXmlToStr(XMLToAnsi(ChildNodes[i].GetAttribute('data')))));
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
  i, j: integer;
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
  FControlList := TControlList.Create(Self);
  FEnterValue := TStringList.Create;
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
  if Sender is TcxTextEdit then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxTextEdit).Text;
  if Sender is TcxButtonEdit then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxButtonEdit).Text;
  if Sender is TcxCurrencyEdit then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxCurrencyEdit).Text;
  if Sender is TcxDateEdit then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> (Sender as TcxDateEdit).Text;
  if Sender is TcxCheckBox then
     isChanged := FEnterValue.Values[TComponent(Sender).Name] <> BoolToStr((Sender as TcxCheckBox).Checked);
  if isChanged then
     StoredProc.Execute;
end;

{ TControlList }

function TControlList.Add: TControlListItem;
begin
  result := TControlListItem(inherited Add);
end;

constructor TControlList.Create(HeaderSaver: THeaderSaver);
begin
  inherited Create(TControlListItem);
  Self.HeaderSaver := HeaderSaver;
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
  FControl := Value;
  if FControl is TcxTextEdit then begin
     (FControl as TcxTextEdit).OnEnter := TControlList(Collection).HeaderSaver.OnEnter;
     (FControl as TcxTextEdit).OnExit := TControlList(Collection).HeaderSaver.OnExit;
  end;
  if FControl is TcxDateEdit then begin
     (FControl as TcxDateEdit).OnEnter := TControlList(Collection).HeaderSaver.OnEnter;
     (FControl as TcxDateEdit).OnExit := TControlList(Collection).HeaderSaver.OnExit;
  end;
  if FControl is TcxButtonEdit then begin
     (FControl as TcxButtonEdit).OnEnter := TControlList(Collection).HeaderSaver.OnEnter;
     (FControl as TcxButtonEdit).OnExit := TControlList(Collection).HeaderSaver.OnExit;
  end;
  if FControl is TcxCheckBox then begin
     (FControl as TcxCheckBox).OnEnter := TControlList(Collection).HeaderSaver.OnEnter;
     (FControl as TcxCheckBox).OnExit := TControlList(Collection).HeaderSaver.OnExit;
  end;
  if FControl is TcxCurrencyEdit then begin
     (FControl as TcxCurrencyEdit).OnEnter := TControlList(Collection).HeaderSaver.OnEnter;
     (FControl as TcxCurrencyEdit).OnExit := TControlList(Collection).HeaderSaver.OnExit;
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

procedure TRefreshAddOn.OnClose(Sender: TObject; var Action: TCloseAction);
var i: integer;
begin
  if Assigned(FOnClose) then
     FOnClose(Sender, Action);
  // Перечитываем и позиционируемся
  // Только сначала находим форму указанного типа
  for I := 0 to Screen.FormCount - 1 do
      if lowercase(Screen.Forms[i].Name) = lowercase(FormName) then
         with Screen.Forms[i] do begin
           if Assigned(FindComponent(RefreshAction)) then
              TdsdDataSetRefresh(FindComponent(RefreshAction)).Execute;
           if Assigned(FindComponent(DataSet)) and Assigned(FindComponent(FormParams)) then
              TDataSet(FindComponent(DataSet)).Locate('Id', TdsdFormParams(FindComponent(FormParams)).ParamByName('Id').AsString, []);
         end;
end;

{ TActionItem }

constructor TActionItem.Create(Collection: TCollection);
begin
  inherited;

end;

procedure TActionItem.SetAction(const Value: TCustomAction);
begin
  FAction := Value;
end;

function TActionItem.GetSecondaryShortCuts: TShortCutList;
begin
  if FSecondaryShortCuts = nil then
    FSecondaryShortCuts := TShortCutList.Create;
  Result := FSecondaryShortCuts;
end;

procedure TActionItem.SetSecondaryShortCuts(const Value: TShortCutList);
begin
  if FSecondaryShortCuts = nil then
    FSecondaryShortCuts := TShortCutList.Create;
  FSecondaryShortCuts.Assign(Value);
end;

function TActionItem.IsSecondaryShortCutsStored: Boolean;
begin
  Result := Assigned(FSecondaryShortCuts) and (FSecondaryShortCuts.Count > 0);
end;

procedure TActionItem.SetShortCut(const Value: TShortCut);
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

end.
