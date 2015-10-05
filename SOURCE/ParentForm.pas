unit ParentForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.ActnList, Vcl.Forms,
  Vcl.Dialogs, dsdDB, cxPropertiesStore, frxClass, dsdAddOn;

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
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SetSender(const Value: TComponent);
    property FormSender: TComponent read FSender write SetSender;
    procedure AfterShow(var a : TWMSHOWWINDOW); message MY_MESSAGE;
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Activate; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute(Sender: TComponent; Params: TdsdParams): boolean;
    procedure CloseAction(Sender: TObject);
    property FormClassName: string read FFormClassName write FFormClassName;
    property onAfterShow: TNotifyEvent read FonAfterShow write FonAfterShow;
    // проперти устанавливается в компоненте TRefreshDispatcher если форма не видима, но было изменение значений для изменения запроса
    property NeedRefreshOnExecute: boolean read FNeedRefreshOnExecute write FNeedRefreshOnExecute;
  published
    property AddOnFormData: TAddOnFormData read FAddOnFormData write FAddOnFormData;
  end;

implementation

uses
  cxControls, cxContainer, cxEdit, UtilConst,
  cxGroupBox, dxBevel, cxButtons, cxGridDBTableView, cxGrid, DB, DBClient,
  dxBar, cxTextEdit, cxLabel, StdActns, cxDBTL, cxCurrencyEdit, cxDropDownEdit,
  cxDBLookupComboBox, DBGrids, cxCheckBox, cxCalendar, ExtCtrls,
  cxButtonEdit, cxSplitter, Vcl.Menus, cxPC, frxDBSet, dxBarExtItems,
  cxDBPivotGrid, ChoicePeriod, cxGridDBBandedTableView,
  cxDBEdit, dsdAction, dsdGuides, cxDBVGrid,
  Vcl.DBActns, cxMemo, cxGridDBChartView;

{$R *.dfm}

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
end;

destructor TParentForm.Destroy;
begin
//  ShowMessage(Self.Name);
  inherited;
end;

function TParentForm.Execute(Sender: TComponent; Params: TdsdParams): boolean;
begin
  try
    // то перечитывать ли ее каждый раз определяет флаг
    result := true;
    // Заполняет параметры формы переданными параметрами
    if Assigned(AddOnFormData.Params) then
       AddOnFormData.Params.Params.AssignParams(Params);
    // Если надо вызываем заполнение диалогом
    if Assigned(AddOnFormData.ExecuteDialogAction) and AddOnFormData.ExecuteDialogAction.OpenBeforeShow then begin
       AddOnFormData.ExecuteDialogAction.RefreshAllow := false; // Что бы не было двух перечитываний.
       result := AddOnFormData.ExecuteDialogAction.Execute;
    end;
    FormSender := Sender;
    // Если открыта первый раз и всегда перечитываем
    if (not FisAlreadyOpen) or AddOnFormData.isAlwaysRefresh or NeedRefreshOnExecute then
       // Перечитываем запросы
       if Assigned(AddOnFormData.RefreshAction) then
          AddOnFormData.RefreshAction.Execute;
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
    // Если данная форма не одиночка, то при закрытии надо проверить единственная она или нет
    // Если не единственная, то сделать ей Free
    if not AddOnFormData.isSingle then begin
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
end;

procedure TParentForm.Loaded;
begin
  inherited;
  if not (csDesigning in ComponentState) then
     if Assigned(AddOnFormData.OnLoadAction) then
        AddOnFormData.OnLoadAction.Execute;
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

  // Библиотека DevExpress
  RegisterClass (TdxBarDockControl);
  RegisterClass (TcxButton);
  RegisterClass (TcxButtonEdit);
  RegisterClass (TcxCheckBox);
  RegisterClass (TcxCurrencyEdit);
  RegisterClass (TcxDateEdit);
  RegisterClass (TcxDBButtonEdit);
  RegisterClass (TcxDBEditorRow);
  RegisterClass (TcxDBPivotGrid);
  RegisterClass (TcxDBPivotGridField);
  RegisterClass (TcxDBTextEdit);
  RegisterClass (TcxDBTreeList);
  RegisterClass (TcxDBTreeListColumn);
  RegisterClass (TcxDBVerticalGrid);
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

  RegisterClass (TdxBarManager);
  RegisterClass (TdxBarStatic);
  RegisterClass (TdxBevel);

  RegisterClass (TcxGridDBChartView);

  // Собственнтые компоненты
  RegisterClass (TBooleanStoredProcAction);
  RegisterClass (TChangeStatus);
  RegisterClass (TChangeGuidesStatus);
  RegisterClass (TCrossDBViewAddOn);
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
  RegisterClass (TdsdUpdateDataSet);
  RegisterClass (TdsdUpdateErased);
  RegisterClass (TdsdUserSettingsStorageAddOn);

  RegisterClass (TExecuteDialog);
  RegisterClass (TFileDialogAction);
  RegisterClass (TGuidesFiller);
  RegisterClass (THeaderSaver);
  RegisterClass (TInsertRecord);
  RegisterClass (TInsertUpdateChoiceAction);
  RegisterClass (TMultiAction);
  RegisterClass (TOpenChoiceForm);
  RegisterClass (TPeriodChoice);
  RegisterClass (TPivotAddOn);
  RegisterClass (TRefreshAddOn);
  RegisterClass (TRefreshDispatcher);
  RegisterClass (TUpdateRecord);
  RegisterClass (TAddOnFormRefresh);

// ДЛЯ ТЕСТА

  RegisterClass (TDBGrid);

end.
