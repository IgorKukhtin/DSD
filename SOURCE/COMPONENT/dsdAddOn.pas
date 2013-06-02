unit dsdAddOn;

interface

uses Classes, cxDBTL, cxTL, Vcl.ImgList, cxGridDBTableView, cxTextEdit, DB, dsdAction;

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

  // Добавляет функционал быстрой установки фильтров
  TdsdDBFilterAddOn = class(TComponent)
  private
    FView: TcxGridDBTableView;
    // контрол для ввода условия фильтра
    edFilter: TcxTextEdit;
    procedure OnKeyPress(Sender: TObject; var Key: Char);
    procedure OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SetView(const Value: TcxGridDBTableView);
    procedure edFilterExit(Sender: TObject);
    procedure edFilterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    // процедура устанавливает контрол для внесения значения фильтра и позиционируется на заголовке колонки
    procedure lpSetEdFilterPos(inKey: Char);
    //процедура устанавливает фильтр и убирает видимость у контрола
    procedure lpSetFilter;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property View: TcxGridDBTableView read FView write SetView;
  end;

  procedure Register;

implementation

uses Windows, SysUtils, VCL.Controls, cxFilter;

procedure Register;
begin
   RegisterComponents('DSDComponent', [TdsdDBTreeAddOn]);
   RegisterComponents('DSDComponent', [TdsdDBFilterAddOn]);
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

constructor TdsdDBFilterAddOn.Create(AOwner: TComponent);
begin
  inherited;
  edFilter := TcxTextEdit.Create(Self);
  edFilter.Visible := false;
  edFilter.OnKeyDown := edFilterKeyDown;
  edFilter.OnExit := edFilterExit
end;

procedure TdsdDBFilterAddOn.edFilterExit(Sender: TObject);
begin
  edFilter.Visible:=false;
  FView.Focused := true;
end;

procedure TdsdDBFilterAddOn.edFilterKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: lpSetFilter;
  end;
end;

procedure TdsdDBFilterAddOn.lpSetEdFilterPos(inKey: Char);
// процедура устанавливает контрол для внесения значения фильтра и позиционируется на заголовке колонки
var pRect:TRect;
begin

 if (not edFilter.Visible)  and (inKey<>char(VK_BACK)) then
   with FView.Controller do begin
     // позиционируем контрол на место заголовка
     edFilter.Visible := true;
     edFilter.Parent := TWinControl(FView.GetParentComponent);
     pRect := GridView.ViewInfo.HeaderViewInfo.Items[FocusedItemIndex].Bounds;
     edFilter.Left := pRect.Left;
     edFilter.Top := pRect.Top;
     edFilter.Width := pRect.Right - pRect.Left + 1;
     edFilter.Height := pRect.Bottom - pRect.Top;
     edFilter.Text := '';
   end;
 if inKey=char(VK_BACK) then
   edFilter.Text := copy(edFilter.Text, 1, length(edFilter.Text) - 1)
 else
   edFilter.Text := edFilter.Text+inKey;
end;

procedure TdsdDBFilterAddOn.lpSetFilter;
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

procedure TdsdDBFilterAddOn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FView) then
     FView := nil;
end;

procedure TdsdDBFilterAddOn.OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: begin
               // Если нажат Ввод и фильтр введен то установить его}
                  if (edFilter.Visible) then begin
                      lpSetFilter;
                      Key := 0;
                  end;{if}
    end;
  end
end;

procedure TdsdDBFilterAddOn.OnKeyPress(Sender: TObject; var Key: Char);
begin
  // если колонка не редактируема и введена буква или BackSpace то обрабатываем установку фильтра
  if {TcxGridDBColumn(FView.Controller.FocusedColumn).Properties.ReadOnly and} ((Key>#31) or (Key=char(VK_BACK))) then
     lpSetEdFilterPos(Key);
end;

procedure TdsdDBFilterAddOn.SetView(const Value: TcxGridDBTableView);
begin
  FView := Value;
  FView.OnKeyPress := OnKeyPress;
  FView.OnKeyDown := OnKeyDown;
end;

end.
