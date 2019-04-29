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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SetSender(const Value: TComponent);
    property FormSender: TComponent read FSender write SetSender;
    procedure AfterShow(var a : TWMSHOWWINDOW); message MY_MESSAGE;
    procedure InitHelpSystem;
    procedure InitcxEditRepository;
    procedure btnHelpClick(Sender: TObject);
    procedure cxGridDBTableViewTextGetProperties(
      Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
      var AProperties: TcxCustomEditProperties);
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
    property isAlreadyOpen: Boolean read FisAlreadyOpen write FisAlreadyOpen;
  published
    property AddOnFormData: TAddOnFormData read FAddOnFormData write FAddOnFormData;
  end;

implementation

uses
  cxControls, cxContainer, UtilConst,
  cxGroupBox, dxBevel, cxButtons, cxGridDBTableView, cxGrid, DB, DBClient,
  dxBar, cxTextEdit, cxLabel, StdActns, cxDBTL, cxCurrencyEdit, cxDropDownEdit,
  cxDBLookupComboBox, DBGrids, cxCheckBox, cxCalendar, ExtCtrls,
  cxButtonEdit, cxSplitter, Vcl.Menus, cxPC, frxDBSet, dxBarExtItems,
  cxDBPivotGrid, ChoicePeriod, cxGridDBBandedTableView,
  cxDBEdit, dsdAction, dsdGuides, cxDBVGrid, cxDBLabel, cxBlobEdit,
  Vcl.DBActns, cxMemo, cxGridDBChartView, ShellAPI, CommonData,
  SHDocVw, GMClasses, GMMap, GMMapVCL, GMLinkedComponents,
  GMMarker, GMMarkerVCL, GMGeoCode, GMDirection, GMDirectionVCL, cxImage,
  cxEditRepositoryItems, dsdPivotGrid, dsdExportToXLSAction, 
  dsdExportToXMLAction{DataModul};

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

procedure TParentForm.btnHelpClick(Sender: TObject);
begin
  if Self.HelpFile = '' then exit;
  ShellExecute(0, 'open', PChar(Self.HelpFile), '', '', 1);

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
    // Если диалог был открыт нормально
    if result = true
    then
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
  InitHelpSystem;
  InitcxEditRepository;
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
  RegisterClass (TWebBrowser);

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
  RegisterClass (TdsdUpdateDataSet);
  RegisterClass (TdsdUpdateErased);
  RegisterClass (TdsdUserSettingsStorageAddOn);
  RegisterClass (TdsdLoadXMLKS);
  RegisterClass (TdsdStoredProcExportToFile);
  RegisterClass (TdsdPartnerMapAction);
  RegisterClass (TdsdPivotGridCalcFields);
  RegisterClass (TdsdExportToXLS);
  RegisterClass (TdsdExportToXML);

  RegisterClass (TExecuteDialog);
  RegisterClass (TFileDialogAction);
  RegisterClass (TGuidesFiller);
  RegisterClass (THeaderSaver);
  RegisterClass (THeaderChanger);
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
  RegisterClass (TShellExecuteAction);
  RegisterClass (TShowMessageAction);
  RegisterClass (TcxImage);
  RegisterClass (TdsdDataSetRefreshEx);
  RegisterClass (TdsdGMMap);
  RegisterClass (TdsdWebBrowser);
  RegisterClass (TdsdEnterManager);
  RegisterClass (TdsdFileToBase64);

// ДЛЯ ТЕСТА

  RegisterClass (TDBGrid);

end.
