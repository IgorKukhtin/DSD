unit ParentForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dsdDB, cxPropertiesStore, frxClass;

type
  TParentForm = class(TForm)
  private
    FPropertiesStore: TcxPropertiesStore;
    FParams: TdsdParams;
    // Класс, который вызвал данную форму
    FSender: TComponent;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  public
    { Public declarations }
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
    property Params: TdsdParams read FParams;
    procedure Execute(Sender: TComponent; Params: TdsdParams);
  end;

implementation

uses FormStorage, UtilConst, cxControls, cxContainer, cxEdit,
  cxGroupBox, dxBevel, cxButtons, cxGridDBTableView, cxGrid, DB, DBClient,
  dxBar, Vcl.ActnList, dsdAction, cxTextEdit, cxLabel,
  StdActns, cxDBTL, cxCurrencyEdit, cxDropDownEdit, dsdGuides,
  cxDBLookupComboBox, DBGrids, cxCheckBox, cxCalendar, ExtCtrls, dsdAddOn,
  cxButtonEdit, cxSplitter, Vcl.Menus, cxPC, frxDBSet, dxBarExtItems;

{$R *.dfm}

constructor TParentForm.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin
  inherited;
  onKeyDown := FormKeyDown;
  onClose := FormClose;
end;

procedure TParentForm.Execute(Sender: TComponent; Params: TdsdParams);
var
  i: integer;
begin
  FSender := Sender;
  // Заполняет параметры формы переданными параметрами
  for I := 0 to ComponentCount - 1 do begin
    if Components[i] is TdsdFormParams then begin
       FParams := (Components[i] as TdsdFormParams).Params;
       FParams.AssignParams(Params);
    end;
    if Components[i] is TcxPropertiesStore  then
       FPropertiesStore := Components[i] as TcxPropertiesStore;
  end;

  for I := 0 to ComponentCount - 1 do begin
    // Перечитывает видимые компоненты
    if Components[i] is TdsdDataSetRefresh then
       (Components[i] as TdsdDataSetRefresh).Execute;
  end;
  if Assigned(FPropertiesStore) then begin
     FPropertiesStore.StorageStream := TdsdFormStorageFactory.GetStorage.LoadUserFormSettings(Name);
     FPropertiesStore.RestoreFrom;
  end;
end;

procedure TParentForm.FormClose(Sender: TObject; var Action: TCloseAction);
var i: Integer;
    TempStream: TStringStream;
    FormAction: IFormAction;
begin
  if Assigned(FPropertiesStore) then begin
    TempStream:= TStringStream.Create;
    try
      FPropertiesStore.StorageStream := TempStream;
      FPropertiesStore.StoreTo;
      TdsdFormStorageFactory.GetStorage.SaveUserFormSettings(Name, TempStream);
    finally
      TempStream.Free;
    end;
  end;
  if (ModalResult = mrOk) and Assigned(FSender) then
     if FSender.GetInterface(IFormAction, FormAction) then
        FormAction.OnFormClose(Params);
  Action := caFree;
end;

procedure TParentForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssShift in Shift) and (ssCtrl in Shift)
      and (Key in [byte('s'), byte('S')]) then
      gc_isDebugMode := not gc_isDebugMode;
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
  RegisterClass (TdsdOpenForm);
  RegisterClass (TdsdPrintAction);
  RegisterClass (TdsdStoredProc);
  RegisterClass (TdsdUpdateDataSet);
  RegisterClass (TdsdUpdateErased);

end.
