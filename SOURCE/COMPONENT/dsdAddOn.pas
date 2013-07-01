unit dsdAddOn;

interface

uses Classes, cxDBTL, cxTL, Vcl.ImgList, cxGridDBTableView,
     cxTextEdit, DB, dsdAction, cxGridTableView, cxGraphics, cxStyles, Forms;

type

  TdsdDBTreeAddOn = class(TComponent)
  private
    FDBTreeList: TcxDBTreeList;
    procedure SetDBTreeList(const Value: TcxDBTreeList);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure onGetNodeImageIndex(Sender: TcxCustomTreeList; ANode: TcxTreeListNode;
              AIndexType: TcxTreeListImageIndexType; var AIndex: TImageIndex);
  published
    property DBTreeList: TcxDBTreeList read FDBTreeList write SetDBTreeList;
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
    property View: TcxGridDBTableView read FView write SetView;
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

  procedure Register;

implementation

uses utilConvert, FormStorage, Xml.XMLDoc, XMLIntf, Windows, SysUtils, VCL.Controls,
     cxFilter, cxClasses, cxLookAndFeelPainters, cxCustomData, VCL.Graphics,
     cxGridCommon, math, cxPropertiesStore, cxGridCustomView, UtilConst, cxStorage;

type

  TcxGridColumnHeaderViewInfoAccess = class(TcxGridColumnHeaderViewInfo);

procedure Register;
begin
   RegisterComponents('DSDComponent', [TdsdDBTreeAddOn]);
   RegisterComponents('DSDComponent', [TdsdDBViewAddOn]);
   RegisterComponents('DSDComponent', [TdsdUserSettingsStorageAddOn]);
end;

{ TdsdDBTreeAddOn }

procedure TdsdDBTreeAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = DBTreeList) then
     DBTreeList := nil;
end;

procedure TdsdDBTreeAddOn.onGetNodeImageIndex(Sender: TcxCustomTreeList;
  ANode: TcxTreeListNode; AIndexType: TcxTreeListImageIndexType;
  var AIndex: TImageIndex);
begin
  if ANode.Expanded then
     AIndex := 1
  else
     AIndex := 0;
end;

procedure TdsdDBTreeAddOn.SetDBTreeList(const Value: TcxDBTreeList);
begin
  FDBTreeList := Value;
  if Assigned(FDBTreeList) then
     FDBTreeList.OnGetNodeImageIndex := onGetNodeImageIndex;
end;

{ TdsdDBFilterAddOn }

constructor TdsdDBViewAddOn.Create(AOwner: TComponent);
begin
  inherited;
  edFilter := TcxTextEdit.Create(Self);
  edFilter.Visible := false;
  edFilter.OnKeyDown := edFilterKeyDown;
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
  if Assigned(Sender.Images) then
     ASortingImageSize := Sender.Images.Width;
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
      if Assigned(Sender.Images) then
         ACanvas.DrawImage(Sender.Images, R.Left, R.Top, ASortingImageIndex);
    end;
    ADone := True;
  end;
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
    VK_RETURN: lpSetFilter;
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
end;

procedure TdsdDBViewAddOn.OnKeyPress(Sender: TObject; var Key: Char);
begin
  // если колонка не редактируема и введена буква или BackSpace то обрабатываем установку фильтра
  if {TcxGridDBColumn(FView.Controller.FocusedColumn).Properties.ReadOnly and} (Key > #31) then begin
     lpSetEdFilterPos(Key);
     Key := #0;
  end;
end;

procedure TdsdDBViewAddOn.SetView(const Value: TcxGridDBTableView);
begin
  FView := Value;
  FView.OnKeyPress := OnKeyPress;
  FView.OnCustomDrawColumnHeader := OnCustomDrawColumnHeader;
  FView.DataController.Filter.OnChanged := onFilterChanged;
  FView.OnColumnHeaderClick := OnColumnHeaderClick;
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
begin
  Data := StringReplace(TdsdFormStorageFactory.GetStorage.LoadUserFormSettings(FForm.Name), '&', '&amp;', [rfReplaceAll]);
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
        if ChildNodes[i].NodeName = 'cxPropertiesStore' then begin
           PropertiesStore := FForm.FindComponent(ChildNodes[i].GetAttribute('name')) as TcxPropertiesStore;
           if Assigned(PropertiesStore) then begin
              PropertiesStore.StorageType := stStream;
              PropertiesStore.StorageStream := TStringStream.Create(XMLToAnsi(ChildNodes[i].GetAttribute('data')));
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
  fff, bbb: string;
begin
  TempStream :=  TStringStream.Create;
  try
    xml := '<root>';
    // Сохраняем установки гридов
    for i := 0 to FForm.ComponentCount - 1 do begin
      if FForm.Components[i] is TcxCustomGridView then
         with TcxCustomGridView(FForm.Components[i]) do begin
           StoreToStream(TempStream);
           xml := xml + '<cxGridView name = "' + Name + '" data = "' + gfStrToXmlStr(TempStream.DataString) + '" />';
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
    TdsdFormStorageFactory.GetStorage.SaveUserFormSettings(FForm.Name, xml);
  finally
    TempStream.Free;
  end;
end;


end.
