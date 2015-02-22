unit AncestorMain;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxLocalization, dsdAddOn, dsdDB,
  Data.DB, Datasnap.DBClient, frxExportXML, frxExportXLS, frxClass, frxExportRTF,
  Vcl.ActnList, dxBar, cxClasses, Vcl.StdActns, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinsdxBarPainter, cxPropertiesStore, Vcl.Menus,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxLabel, dsdAction, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  Vcl.ToolWin, Vcl.ActnCtrls, Vcl.ActnMenus;

type
  TAncestorMainForm = class(TForm)
    cxLocalizer: TcxLocalizer;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    spUserProtocol: TdsdStoredProc;
    StoredProc: TdsdStoredProc;
    ClientDataSet: TClientDataSet;
    frxRTFExport: TfrxRTFExport;
    frxXLSExport: TfrxXLSExport;
    frxXMLExport: TfrxXMLExport;
    ActionList: TActionList;
    actAbout: TAction;
    actUpdateProgram: TAction;
    cxPropertiesStore: TcxPropertiesStore;
    actLookAndFeel: TAction;
    actImportExportLink: TdsdOpenForm;
    MainMenu: TMainMenu;
    miGuides: TMenuItem;
    miService: TMenuItem;
    miProtocol: TMenuItem;
    miExit: TMenuItem;
    N2: TMenuItem;
    miMovementProtocol: TMenuItem;
    miUserProtocol: TMenuItem;
    N3: TMenuItem;
    miLookAndFillSettings: TMenuItem;
    miAbout: TMenuItem;
    miUpdateProgramm: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure actUpdateProgramExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actLookAndFeelExecute(Sender: TObject);
  private
    procedure OnException(Sender: TObject; E: Exception);
  end;

implementation

{$R *.dfm}

uses ParentForm, Storage, CommonData, MessagesUnit, UtilConst, Math,
     AboutBoxUnit, UtilConvert, LookAndFillSettings;

{ TfmBaseForm }

procedure TAncestorMainForm.actAboutExecute(Sender: TObject);
begin
  TAboutBox.Create(Self).ShowModal;
end;

procedure TAncestorMainForm.actLookAndFeelExecute(Sender: TObject);
begin
  TLookAndFillSettingsForm.Create(nil).Show;
end;

procedure TAncestorMainForm.actUpdateProgramExecute(Sender: TObject);
var Index: integer;
    AllParentFormFree: boolean;
begin
  AllParentFormFree := false;
  while not AllParentFormFree do begin
    AllParentFormFree := true;
    for Index := 0 to Screen.FormCount - 1 do
        if Screen.Forms[Index] is TParentForm then begin
           AllParentFormFree := false;
           Screen.Forms[Index].Free;
           break;
        end;
  end;
  ShowMessage('Программа обновлена');
end;

procedure TAncestorMainForm.OnException(Sender: TObject; E: Exception);
  function GetTextMessage(E: Exception; var isMessage: boolean): string;
  begin
    isMessage := false;
    if E is EStorageException then begin
       isMessage := (E as EStorageException).ErrorCode = 'P0001';
       if pos('context', AnsilowerCase(E.Message)) = 0 then
          Result := E.Message
       else
          // Выбрасываем все что после Context
          Result := Copy(E.Message, 1, pos('context', AnsilowerCase(E.Message)) - 1);
       exit;
    end;
    if (E is EOutOfMemory) or (E is EVariantOutOfMemoryError)
        or ((E is EDBClient) and (EDBClient(E).ErrorCode = 9473)) then begin
       Result := 'Невозможно показать большой объем данных.'#10#13'Закройте другие приложения.'#10#13'Или установите другие условия для выбора данных.';
       exit;
    end;
    Result := E.Message;
  end;
var TextMessage: String;
    isMessage: boolean;
begin
  if E is ESortException then
     exit;

  TextMessage := GetTextMessage(E, isMessage);

  if not isMessage then begin
    // Сохраняем протокол в базе
    try
      spUserProtocol.ParamByName('inProtocolData').Value := gfStrToXmlStr(E.Message);
      spUserProtocol.Execute;
    except
      // Обязательно так, потому как иначе он может зациклиться.
    end;
  end;
  if E is EStorageException then
     TMessagesForm.Create(nil).Execute(TextMessage, E.Message)
  else
     TMessagesForm.Create(nil).Execute(TextMessage, E.Message  + #10#13 + E.StackTrace);
end;

procedure TAncestorMainForm.FormCreate(Sender: TObject);
begin
  // Локализуем сообщения DevExpress
  cxLocalizer.Active:= True;
  cxLocalizer.Locale:= 1049;
  Application.OnException := OnException;
  UserSettingsStorageAddOn.LoadUserSettings;
end;

procedure TAncestorMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Ctrl + Shift + S
  if ShortCut(Key, Shift) = 24659 then begin
     gc_isDebugMode := not gc_isDebugMode;
     if gc_isDebugMode then
        ShowMessage('Установлен режим отладки')
      else
        ShowMessage('Снят режим отладки');
  end;
  // Ctrl + Shift + T
  if ShortCut(Key, Shift) = 24660 then begin
     gc_isShowTimeMode := not gc_isShowTimeMode;
     if gc_isShowTimeMode then
        ShowMessage('Установлен режим проверки времени')
      else
        ShowMessage('Снят режим проверки времени');
  end;
  // Ctrl + Shift + D
  if ShortCut(Key, Shift) = 24644 then begin
     gc_isSetDefault := not gc_isSetDefault;
     if gc_isSetDefault then
        ShowMessage('Установки пользователя не загружаются')
      else
        ShowMessage('Установки пользователя загружаются');
  end;
end;

procedure TAncestorMainForm.FormShow(Sender: TObject);
var i, j, k: integer;
begin
  StoredProc.Execute;
  ClientDataSet.IndexFieldNames := 'ActionName';
  for I := 0 to ActionList.ActionCount - 1 do
      // Проверяем только открытие формы
      if (ActionList.Actions[i].ClassName = 'TdsdOpenForm') or
         (ActionList.Actions[i].Name = 'actReport_OLAPSold')  then
         if not ClientDataSet.Locate('ActionName', ActionList.Actions[i].Name, []) then begin
            TCustomAction(ActionList.Actions[i]).Enabled := false;
            TCustomAction(ActionList.Actions[i]).Visible := false;
         end;

  ClientDataSet.EmptyDataSet;
  // Отображаем видимые пункты меню
  for i := 0 to MainMenu.Items.Count - 1 do
         if Assigned(MainMenu.Items[i].Action) then
            if not TCustomAction(MainMenu.Items[i].Action).Enabled then
               MainMenu.Items[i].Visible := false;

    for i := 0 to ComponentCount - 1 do  //Items.Count
        if Components[i] is TMenuItem then
           if TMenuItem(Components[i]).Count > 0 then
               TMenuItem(Components[i]).Visible := false;

  for k := 1 to 3 do
    // А теперь бы пройтись по группам меню и отрубить те, у которых нет видимых чайлдов
    for i := 0 to ComponentCount - 1 do
        if Components[i] is TMenuItem then
          if TMenuItem(Components[i]).Count > 0 then
             for j := 0 to TMenuItem(Components[i]).Count - 1 do
                 if (TMenuItem(Components[i]).Items[j].Visible)
                    and not (TMenuItem(Components[i]).Items[j].IsLine) then begin
                    TMenuItem(Components[i]).Visible := true;
                    break;
                 end;

end;

end.
