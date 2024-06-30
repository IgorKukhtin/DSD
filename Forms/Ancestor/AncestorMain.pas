unit AncestorMain;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dsdAddOn, dsdDB,
  Data.DB, Datasnap.DBClient, frxExportXML, frxExportXLS, frxClass, frxExportRTF,
  Vcl.ActnList, dxBar, cxClasses, Vcl.StdActns, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinsdxBarPainter, cxPropertiesStore, Vcl.Menus,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxLabel, dsdAction, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  Vcl.ToolWin, Vcl.ActnCtrls, Vcl.ActnMenus, dsdCommon;

type
  TAncestorMainForm = class(TForm)
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    StoredProc: TdsdStoredProc;
    ClientDataSet: TClientDataSet;
    frxXMLExport: TfrxXMLExport;
    ActionList: TActionList;
    actAbout: TAction;
    actUpdateProgram: TAction;
    cxPropertiesStore: TcxPropertiesStore;
    actLookAndFeel: TAction;
    actImportExportLink: TdsdOpenForm;
    MainMenu: TMainMenu;
    miGuide: TMenuItem;
    miService: TMenuItem;
    miProtocol: TMenuItem;
    miExit: TMenuItem;
    miLine801: TMenuItem;
    miMovementProtocol: TMenuItem;
    miUserProtocol: TMenuItem;
    miLine802: TMenuItem;
    miLookAndFillSettings: TMenuItem;
    miAbout: TMenuItem;
    miUpdateProgramm: TMenuItem;
    frxXLSExport: TfrxXLSExport;
    actMovementDesc: TdsdOpenForm;
    miMovementDesc: TMenuItem;
    miProtocolAll: TMenuItem;
    miServiceGuide: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actUpdateProgramExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actLookAndFeelExecute(Sender: TObject);
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
  TLookAndFillSettingsForm.Create(Screen.ActiveForm).Show;
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


procedure TAncestorMainForm.FormCreate(Sender: TObject);
begin
  UserSettingsStorageAddOn.LoadUserSettings;
  TranslateForm(Self);
end;

procedure TAncestorMainForm.FormShow(Sender: TObject);
var i, j, k: integer;
begin
  if gc_CorrectPositionForms and
    (((Monitor.Top + Monitor.Height) < Self.Top) or
    ((Monitor.Left + Monitor.Width) < Self.Left) or
    ((Monitor.Top + Monitor.Height) > (Self.Top + Self.Height)) or
    ((Monitor.Left + Monitor.Width) > (Self.Left + Self.Width))) then
    MakeFullyVisible(Nil);
  StoredProc.Execute;
  ClientDataSet.IndexFieldNames := 'ActionName';
  for I := 0 to ActionList.ActionCount - 1 do
      // Проверяем только открытие формы
      if (ActionList.Actions[i].ClassName = 'TdsdOpenForm') or
         (ActionList.Actions[i].ClassName = 'TdsdOpenStaticForm') or
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
  if not SameText(gc_User.Login, '') then
    // Caption := Caption + ' - Пользователь: ' + gc_User.Login;
    Caption := Caption + ' <' + gc_User.Login + '>';
  //
  //dmMain.cxLookAndFeelController.SkinName:='';
  //
end;

end.
