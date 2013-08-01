unit ParentForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.ActnList, Vcl.Forms, Vcl.Dialogs, dsdDB, cxPropertiesStore, frxClass;

type
  TParentForm = class(TForm)
  private
    FChoiceAction: TCustomAction;
    FParams: TdsdParams;
    // Класс, который вызвал данную форму
    FSender: TComponent;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SetSender(const Value: TComponent);
    property FormSender: TComponent read FSender write SetSender;
  public
    { Public declarations }
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
    property Params: TdsdParams read FParams;
    procedure Execute(Sender: TComponent; Params: TdsdParams);
    procedure Close(Sender: TObject);
  end;

implementation

uses
  cxControls, cxContainer, cxEdit, UtilConst,
  cxGroupBox, dxBevel, cxButtons, cxGridDBTableView, cxGrid, DB, DBClient,
  dxBar, cxTextEdit, cxLabel,
  StdActns, cxDBTL, cxCurrencyEdit, cxDropDownEdit, dsdGuides,
  cxDBLookupComboBox, DBGrids, cxCheckBox, cxCalendar, ExtCtrls, dsdAddOn,
  cxButtonEdit, cxSplitter, Vcl.Menus, cxPC, dsdAction, frxDBSet, dxBarExtItems;

{$R *.dfm}

procedure TParentForm.Close(Sender: TObject);
var FormAction: IFormAction;
begin
  // Вызывается событие на закрытие формы, например для справочников для перечитывания
  if Sender is TdsdInsertUpdateGuides then
     if Assigned(FSender) then
        if FSender.GetInterface(IFormAction, FormAction) then
           FormAction.OnFormClose(Params);
  inherited Close;
end;

constructor TParentForm.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin
  inherited;
  onKeyDown := FormKeyDown;
  onClose := FormClose;
  KeyPreview := true;
end;

procedure TParentForm.Execute(Sender: TComponent; Params: TdsdParams);
var
  i: integer;
begin
  // Заполняет параметры формы переданными параметрами
  for I := 0 to ComponentCount - 1 do begin
    if Components[i] is TdsdFormParams then begin
       FParams := (Components[i] as TdsdFormParams).Params;
       FParams.AssignParams(Params);
    end;
    if Components[i] is TdsdChoiceGuides then
       FChoiceAction := Components[i] as TdsdChoiceGuides;
  end;

  for I := 0 to ComponentCount - 1 do begin
    // Перечитывает видимые компоненты
    if Components[i] is TdsdDataSetRefresh then
       (Components[i] as TdsdDataSetRefresh).Execute;
  end;
  FormSender := Sender;
end;

procedure TParentForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  // Нужно что бы вызать событие OnExit на последнем компоненте
  ActiveControl := nil;
  Action := caFree;
end;

procedure TParentForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssShift in Shift) and (ssCtrl in Shift)
      and (Key in [byte('s'), byte('S')]) then begin
          gc_isDebugMode := not gc_isDebugMode;
          if gc_isDebugMode then
             ShowMessage('Установлен режим отладки')
           else
             ShowMessage('Снят режим отладки');
      end;
end;

procedure TParentForm.SetSender(const Value: TComponent);
begin
  FSender := Value;
  // В зависимости от того, как была вызвана форма меняется некоторое поведение

  // Если вызывали для выбора, то делаем видимой кнопку выбора
  if Assigned(FChoiceAction) then begin
     FChoiceAction.Visible := Assigned(FSender) and (FSender is TdsdGuides);
     FChoiceAction.Enabled := FChoiceAction.Visible;
     if FSender is TdsdGuides then
        // объединили вызывающий справочник и кнопку выбора!!!
        TdsdChoiceGuides(FChoiceAction).Guides := TdsdGuides(FSender);
  end;
end;

initialization
  // Стандартные компоненты
  RegisterClass (TActionList);
  RegisterClass (TClientDataSet);
  RegisterClass (TDataSource);
  RegisterClass (TDBGrid);
  RegisterClass (TFileExit);
  RegisterClass (TPopupMenu);
  RegisterClass (TPanel);
  // Библиотека DevExpress

  RegisterClass (TcxButton);
  RegisterClass (TcxButtonEdit);
  RegisterClass (TcxCheckBox);
  RegisterClass (TcxCurrencyEdit);
  RegisterClass (TcxDateEdit);
  RegisterClass (TcxDBTreeList);
  RegisterClass (TcxDBTreeListColumn);
  RegisterClass (TcxGroupBox);
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

  // Собственнтые компоненты
  RegisterClass (TBooleanStoredProcAction);
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
  RegisterClass (THeaderSaver);
  RegisterClass (TRefreshAddOn);

end.
