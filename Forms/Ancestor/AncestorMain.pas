unit AncestorMain;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxLocalization, dsdAddOn, dsdDB,
  Data.DB, Datasnap.DBClient, frxExportXML, frxExportXLS, frxClass, frxExportRTF,
  Vcl.ActnList, dxBar, cxClasses, Vcl.StdActns, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinsdxBarPainter, cxPropertiesStore, Vcl.Menus,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxLabel, dsdAction;

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
    dxBarManager: TdxBarManager;
    actAbout: TAction;
    actUpdateProgram: TAction;
    bbSeparator: TdxBarSeparator;
    cxPropertiesStore: TcxPropertiesStore;
    actLookAndFeel: TAction;
    bbLookAndFillSettings: TdxBarButton;
    actImportExportLink: TdsdOpenForm;
    bbImportExportLink: TdxBarButton;
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
  ShowMessage('��������� ���������');
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
          // ����������� ��� ��� ����� Context
          Result := Copy(E.Message, 1, pos('context', AnsilowerCase(E.Message)) - 1);
       exit;
    end;
    if (E is EOutOfMemory) or (E is EVariantOutOfMemoryError)
        or ((E is EDBClient) and (EDBClient(E).ErrorCode = 9473)) then begin
       Result := '���������� �������� ������� ����� ������.'#10#13'�������� ������ ����������.'#10#13'��� ���������� ������ ������� ��� ������ ������.';
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
    // ��������� �������� � ����
    try
      spUserProtocol.ParamByName('inProtocolData').Value := gfStrToXmlStr(E.Message);
      spUserProtocol.Execute;
    except
      // ����������� ���, ������ ��� ����� �� ����� �����������.
    end;
  end;
  TMessagesForm.Create(nil).Execute(TextMessage, E.Message);
end;

procedure TAncestorMainForm.FormCreate(Sender: TObject);
begin
  // ���������� ��������� DevExpress
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

procedure TAncestorMainForm.FormShow(Sender: TObject);
var i, j, k: integer;
begin
  StoredProc.Execute;
  ClientDataSet.IndexFieldNames := 'ActionName';
  for I := 0 to ActionList.ActionCount - 1 do
      // ��������� ������ �������� �����
      if (ActionList.Actions[i].ClassName = 'TdsdOpenForm') or
         (ActionList.Actions[i].Name = 'actReport_OLAPSold')  then
         if not ClientDataSet.Locate('ActionName', ActionList.Actions[i].Name, []) then begin
            TCustomAction(ActionList.Actions[i]).Enabled := false;
            TCustomAction(ActionList.Actions[i]).Visible := false;
         end;

  ClientDataSet.EmptyDataSet;
  // ���������� ������� ������ ����
  for i := 0 to dxBarManager.ItemCount - 1 do
      if dxBarManager.Items[i] is TdxBarButton then
         if Assigned(dxBarManager.Items[i].Action) then
            if not TCustomAction(dxBarManager.Items[i].Action).Enabled then
               dxBarManager.Items[i].Visible := ivNever;

  for k := 1 to 3 do
    // � ������ �� �������� �� ������� ���� � �������� ��, � ������� ��� ������� �������
    for i := 0 to dxBarManager.ItemCount - 1 do
        if dxBarManager.Items[i] is TdxBarSubItem then begin
           dxBarManager.Items[i].Visible := ivNever;
           for j := 0 to TdxBarSubItem(dxBarManager.Items[i]).ItemLinks.Count - 1 do
               if (TdxBarSubItem(dxBarManager.Items[i]).ItemLinks[j].Item.Visible = ivAlways)
                  and not (TdxBarSubItem(dxBarManager.Items[i]).ItemLinks[j].Item is TdxBarSeparator) then begin
                  dxBarManager.Items[i].Visible := ivAlways;
                  break;
               end;
        end;
end;

end.
