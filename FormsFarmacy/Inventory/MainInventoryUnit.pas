unit MainInventoryUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Win.ComObj, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGridExportLink, cxGraphics, Math,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, System.RegularExpressions,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxSpinEdit, Vcl.StdCtrls,
  cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, cxPC, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection, IniFiles,
  IdMessage, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  Vcl.ActnList, IdText, IdSSLOpenSSL, IdGlobal, strUtils, IdAttachmentFile,
  IdFTP, cxCurrencyEdit, cxCheckBox, Vcl.Menus, DateUtils, cxButtonEdit, ZLibExGZ,
  cxImageComboBox, cxNavigator, dxDateRanges, Data.Bind.Components,
  Data.Bind.ObjectScope, System.Actions, dsdDB, Datasnap.DBClient, dsdAction,
  AncestorBase, cxPropertiesStore, dsdAddOn;

type
  TMainInventoryForm = class(TAncestorBaseForm)
    Panel3: TPanel;
    spSelectUnloadMovement: TdsdStoredProc;
    MasterCDS: TClientDataSet;
    MasterDS: TDataSource;
    actDoLoadData: TAction;
    MainMenu: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    actLoadData: TMultiAction;
    actUnitChoice: TOpenChoiceForm;
    FormParams: TdsdFormParams;
    spGet_User_IsAdmin: TdsdStoredProc;
    procedure FormCreate(Sender: TObject);
    procedure ParentFormDestroy(Sender: TObject);
    procedure actDoLoadDataExecute(Sender: TObject);
  private
    { Private declarations }

    APIUser: String;
    APIPassword: String;

  public
    { Public declarations }
    procedure Add_Log(AMessage:String);
  end;

var
  MainInventoryForm: TMainInventoryForm;

implementation

{$R *.dfm}

uses UnilWin, CommonData, IniUtils, Splash;

procedure TMainInventoryForm.actDoLoadDataExecute(Sender: TObject);
begin

  try
    spGet_User_IsAdmin.Execute;
  except
  end;

  if gc_User.Local then
  begin
    ShowMessage('В локальном режим не работает.');
    Exit;
  end;

  StartSplash('Старт', 'Проведение инвентаризации');
  try
    ChangeStatus('Получение "Товаров"');
    SaveGoods;
    ChangeStatus('Получение "Штрих кодов товаров"');
    SaveGoodsBarCode;
  finally
    EndSplash;
  end;
end;

procedure TMainInventoryForm.Add_Log(AMessage: String);
var
  F: TextFile;

begin
  try
    AssignFile(F,ChangeFileExt(Application.ExeName,'.log'));
    if not fileExists(ChangeFileExt(Application.ExeName,'.log')) then
      Rewrite(F)
    else
      Append(F);
  try
    if Pos('----', AMessage) > 0 then Writeln(F, AMessage)
    else Writeln(F,FormatDateTime('YYYY.MM.DD hh:mm:ss',now) + ' - ' + AMessage);
  finally
    CloseFile(F);
  end;
  except
  end;
end;


procedure TMainInventoryForm.FormCreate(Sender: TObject);
begin
  FormClassName := Self.ClassName;
  Self.Caption := 'Проведение инвентаризации (' + GetFileVersionString(ParamStr(0)) + ')' +  ' - <' + gc_User.Login + '>';
  UserSettingsStorageAddOn.LoadUserSettings;
end;

procedure TMainInventoryForm.ParentFormDestroy(Sender: TObject);
begin
  inherited;
  if not gc_User.Local then UserSettingsStorageAddOn.SaveUserSettings;
end;

end.
