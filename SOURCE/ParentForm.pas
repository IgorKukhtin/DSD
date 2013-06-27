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
    procedure LoadUserSettings;
    procedure SaveUserSettings;
    property FormSender: TComponent read FSender write SetSender;
  public
    { Public declarations }
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
    property Params: TdsdParams read FParams;
    procedure Execute(Sender: TComponent; Params: TdsdParams);
  end;

implementation

uses
  Xml.XMLDoc, XMLIntf, utilConvert, FormStorage, UtilConst, cxControls, cxContainer, cxEdit,
  cxGroupBox, dxBevel, cxButtons, cxGridDBTableView, cxGrid, DB, DBClient,
  dxBar, cxTextEdit, cxLabel,
  StdActns, cxDBTL, cxCurrencyEdit, cxDropDownEdit, dsdGuides,
  cxDBLookupComboBox, DBGrids, cxCheckBox, cxCalendar, ExtCtrls, dsdAddOn,
  cxButtonEdit, cxSplitter, Vcl.Menus, cxPC, dsdAction, frxDBSet, dxBarExtItems;

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
  // Вычитываем пользовательсике настройки
//  LoadUserSettings;

  FormSender := Sender;
end;

procedure TParentForm.FormClose(Sender: TObject; var Action: TCloseAction);
var i: Integer;
    FormAction: IFormAction;
begin
//  SaveUserSettings;
  // Вызывается событие на закрытие формы, например для справочников для перечитывания
  if Assigned(FSender) then
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

procedure TParentForm.LoadUserSettings;
var
  Data: String;
  XMLDocument: TXMLDocument;
  i: integer;
  PropertiesStore: TcxPropertiesStore;
begin
  Data := TdsdFormStorageFactory.GetStorage.LoadUserFormSettings(Name);
  if Data <> '' then begin
    XMLDocument := TXMLDocument.Create(nil);
    try
      XMLDocument.LoadFromXML(Data);
      with XMLDocument.DocumentElement do begin
        for I := 0 to ChildNodes.Count - 1 do begin
          if ChildNodes[i].NodeName = 'cxGrid' then begin

 //         ChildNodes[i].GetAttribute('length'));

          end;
          if ChildNodes[i].NodeName = 'cxPropertiesStore' then begin
             PropertiesStore := FindComponent(ChildNodes[i].GetAttribute('name')) as TcxPropertiesStore;
             if Assigned(PropertiesStore) then begin
                PropertiesStore.StorageStream := TStringStream.Create(XMLToAnsi(ChildNodes[i].GetAttribute('data')));
                PropertiesStore.RestoreFrom;
                PropertiesStore.StorageStream.Free;
             end;
          end;
        end;
      end;
    finally
      XMLDocument.Free;
    end;
  end;

{  if Assigned(FPropertiesStore) then begin
     FPropertiesStore.StorageStream := TdsdFormStorageFactory.GetStorage.LoadUserFormSettings(Name);
     FPropertiesStore.RestoreFrom;
  end;}
end;

procedure TParentForm.SaveUserSettings;
var
  TempStream: TStringStream;
  i, j: integer;
  xml: string;
begin
  TempStream :=  TStringStream.Create;
  try
    xml := '<root>';
    // Сохраняем установки гридов
    for i := 0 to ComponentCount - 1 do begin
      if Components[i] is TcxGrid then
         with TcxGrid(Components[i]) do begin
           xml := xml + '<cxGrid name = "' + Name + '" >';
           for j := 0 to ViewCount -1 do begin
               Views[j].StoreToStream(TempStream);
               xml := xml + '<cxGridView name = "' + Views[j].Name + '" data = "' + gfStrToXmlStr(TempStream.DataString) + '" />';
               TempStream.Clear;
           end;
           xml := xml + '</cxGrid>';
         end;
      // сохраняем остальные установки
   {   if Components[i] is TcxPropertiesStore then
         with Components[i] as TcxPropertiesStore do begin
            StorageStream := TempStream;
            StoreTo;
            xml := xml + '<cxPropertiesStore name = "' + Name + '" data = "' + gfStrToXmlStr(TempStream.DataString) + '"/>';
            TempStream.Clear;
         end;}
    end;
    xml := xml + '</root>';
    TdsdFormStorageFactory.GetStorage.SaveUserFormSettings(Name, xml);
  finally
    TempStream.Free;
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

end.
