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
    // �����, ������� ������ ������ �����
    FSender: TComponent;
    FFormClassName: string;
    FonAfterShow: TNotifyEvent;
    FisAlreadyOpen: boolean;
    FAddOnFormData: TAddOnFormData;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SetSender(const Value: TComponent);
    property FormSender: TComponent read FSender write SetSender;
    procedure AfterShow(var a : TWMSHOWWINDOW); message MY_MESSAGE;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    function Execute(Sender: TComponent; Params: TdsdParams): boolean;
    procedure Close(Sender: TObject);
    property FormClassName: string read FFormClassName write FFormClassName;
    property onAfterShow: TNotifyEvent read FonAfterShow write FonAfterShow;
  published
    property AddOnFormData: TAddOnFormData read FAddOnFormData write FAddOnFormData;
  end;

implementation

uses
  cxControls, cxContainer, cxEdit, UtilConst,
  cxGroupBox, dxBevel, cxButtons, cxGridDBTableView, cxGrid, DB, DBClient,
  dxBar, cxTextEdit, cxLabel,
  StdActns, cxDBTL, cxCurrencyEdit, cxDropDownEdit, dsdGuides,
  cxDBLookupComboBox, DBGrids, cxCheckBox, cxCalendar, ExtCtrls,
  cxButtonEdit, cxSplitter, Vcl.Menus, cxPC, frxDBSet, dxBarExtItems,
  cxDBPivotGrid, ChoicePeriod, cxGridDBBandedTableView, dsdAction, ClientBankLoad,
  cxDBEdit, cxDBVGrid, Document, Defaults, ExternalSave;

{$R *.dfm}

procedure TParentForm.AfterShow(var a : TWMSHOWWINDOW);
begin
  if csDesigning in ComponentState then
     exit;
  if Assigned(FonAfterShow) then
     FonAfterShow(Self);
end;

procedure TParentForm.Close(Sender: TObject);
var FormAction: IFormAction;
begin
  // ���������� ������� �� �������� �����, �������� ��� ������������ ��� �������������
  if Sender is TdsdInsertUpdateGuides then
     if Assigned(FSender) then
        if FSender.GetInterface(IFormAction, FormAction) then
           FormAction.OnFormClose(AddOnFormData.Params.Params);
  inherited Close;
end;

constructor TParentForm.Create(AOwner: TComponent);
begin
  FAddOnFormData := TAddOnFormData.Create;
  inherited;
  onKeyDown := FormKeyDown;
  onClose := FormClose;
  onShow := FormShow;
  OnCloseQuery := FormCloseQuery;
  KeyPreview := true;
  FisAlreadyOpen := false;
end;

function TParentForm.Execute(Sender: TComponent; Params: TdsdParams): boolean;
begin
  try
    // �� ������������ �� �� ������ ��� ���������� ����
    result := true;
    // ��������� ��������� ����� ����������� �����������
    if Assigned(AddOnFormData.Params) then
       AddOnFormData.Params.Params.AssignParams(Params);
    // ���� ���� �������� ���������� ��������
    if Assigned(AddOnFormData.ExecuteDialogAction) and AddOnFormData.ExecuteDialogAction.OpenBeforeShow then begin
       AddOnFormData.ExecuteDialogAction.RefreshAllow := false; // ��� �� �� ���� ���� �������������.
       result := AddOnFormData.ExecuteDialogAction.Execute;
    end;
    FormSender := Sender;
    // ���� ������� ������ ��� � ������ ������������
    if (not FisAlreadyOpen) or AddOnFormData.isAlwaysRefresh then
       // ������������ �������
       if Assigned(AddOnFormData.RefreshAction) then
          AddOnFormData.RefreshAction.Execute;
  finally
    FisAlreadyOpen := true;
  end;
end;

procedure TParentForm.FormClose(Sender: TObject; var Action: TCloseAction);
var i: integer;
    DataSetList: TList;
begin
  inherited;
  DataSetList := TList.Create;
  try
    // ���� ������ ����� �� ��������, �� ��� �������� ���� ��������� ������������ ��� ��� ���
    // ���� �� ������������, �� ������� �� Free
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
  // ����� ��� �� ������ ������� OnExit �� ��������� ����������
  ActiveControl := nil;
  CanClose := not Assigned(ActiveControl);
end;

procedure TParentForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Ctrl + Shift + S
  if ShortCut(Key, Shift) = 24659 then begin
     gc_isDebugMode := not gc_isDebugMode;
     if gc_isDebugMode then
        ShowMessage('���������� ����� �������')
      else
        ShowMessage('���� ����� �������');
  end;
  // Ctrl + Shift + T
  if ShortCut(Key, Shift) = 24660 then begin
     gc_isShowTimeMode := not gc_isShowTimeMode;
     if gc_isShowTimeMode then
        ShowMessage('���������� ����� �������� �������')
      else
        ShowMessage('���� ����� �������� �������');
  end;
  // Ctrl + Shift + D
  if ShortCut(Key, Shift) = 24644 then begin
     gc_isSetDefault := not gc_isSetDefault;
     if gc_isSetDefault then
        ShowMessage('��������� ������������ �� �����������')
      else
        ShowMessage('��������� ������������ �����������');
  end;
end;

procedure TParentForm.FormShow(Sender: TObject);
begin
  PostMessage(Handle, MY_MESSAGE, 0, 0);
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
  // � ����������� �� ����, ��� ���� ������� ����� �������� ��������� ���������

  // ���� �������� ��� ������, �� ������ ������� ������ ������
  if Assigned(AddOnFormData.ChoiceAction) then begin
     AddOnFormData.ChoiceAction.Visible := Assigned(FSender) and Supports(FSender, IChoiceCaller);
     AddOnFormData.ChoiceAction.Enabled := AddOnFormData.ChoiceAction.Visible;
     if Supports(FSender, IChoiceCaller) then begin
        try
          TdsdChoiceGuides(AddOnFormData.ChoiceAction).ChoiceCaller := nil;
        except
          // ���� ��� ����!!!
        end;
        // ���������� ���������� ���������� � ������ ������!!!
        TdsdChoiceGuides(AddOnFormData.ChoiceAction).ChoiceCaller := FSender as IChoiceCaller;
        (FSender as IChoiceCaller).Owner := AddOnFormData.ChoiceAction;
     end;
  end;
end;

initialization
  // ����������� ����������
  RegisterClass (TActionList);
  RegisterClass (TClientDataSet);
  RegisterClass (TDataSource);
  RegisterClass (TDBGrid);
  RegisterClass (TFileExit);
  RegisterClass (TPopupMenu);
  RegisterClass (TPanel);

  // ���������� DevExpress
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
  RegisterClass (TcxPageControl);
  RegisterClass (TcxPopupEdit);
  RegisterClass (TcxPropertiesStore);
  RegisterClass (TcxSplitter);
  RegisterClass (TcxTabSheet);
  RegisterClass (TcxTextEdit);

  RegisterClass (TdxBarManager);
  RegisterClass (TdxBarStatic);
  RegisterClass (TdxBevel);

  // FastReport
  RegisterClass (TfrxDBDataset);

  // ������������ ����������
  RegisterClass (TBooleanStoredProcAction);
  RegisterClass (TChangeStatus);
  RegisterClass (TChangeGuidesStatus);
  RegisterClass (TClientBankLoadAction);
  RegisterClass (TCrossDBViewAddOn);
  RegisterClass (TDefaultKey);
  RegisterClass (TDocument);
  RegisterClass (TDocumentOpenAction);
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
  RegisterClass (TExternalSaveAction);
  RegisterClass (TGuidesFiller);
  RegisterClass (THeaderSaver);
  RegisterClass (TInsertRecord);
  RegisterClass (TMultiAction);
  RegisterClass (TOpenChoiceForm);
  RegisterClass (TPeriodChoice);
  RegisterClass (TRefreshAddOn);
  RegisterClass (TRefreshDispatcher);
  RegisterClass (TUpdateRecord);

// ��� �����

  RegisterClass (TDBGrid);

end.
