unit MainUnit;

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
  cxImageComboBox, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxDateRanges,
  dxBarBuiltInMenu, cxGridChartView, cxGridDBChartView, JPEG, ZStoredProcedure,
  Datasnap.DBClient;

type
  TMainForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    MessagesTelegramDS: TDataSource;
    Panel2: TPanel;
    btnProcesMessages: TButton;
    Panel1: TPanel;
    cxGrid1: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    slChatId: TcxGridDBColumn;
    slText: TcxGridDBColumn;
    spProcesUkraineAlarm: TZStoredProc;
    MessagesTelegramCDS: TClientDataSet;
    btnGetMessagesTelegram: TButton;
    tiServise: TTrayIcon;
    pmServise: TPopupMenu;
    pmClose: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnProcesMessagesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pmCloseClick(Sender: TObject);
  private
    { Private declarations }

    FileName: String;
    Token : String;

    FError : boolean;


  public
    { Public declarations }
    procedure Add_Log(AMessage:String);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.Add_Log(AMessage: String);
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
    Writeln(F,FormatDateTime('YYYY.MM.DD hh:mm:ss',now) + ' - ' + AMessage);
  finally
    CloseFile(F);
  end;
  except
  end;
end;

procedure TMainForm.btnProcesMessagesClick(Sender: TObject);
var
  Urgently : boolean; AGraphic: TGraphic; imJPEG : TJPEGImage;
begin
  if not MessagesTelegramCDS.Active then Exit;
  if MessagesTelegramCDS.IsEmpty then Exit;

  try
    ZConnection1.Connect;

    MessagesTelegramCDS.First;
    while not MessagesTelegramCDS.EOF do
    begin
      Add_Log('Начало выгрузки списка сообщений');
      try

        spProcesUkraineAlarm.ParamByName('inChatId').AsInteger :=  MessagesTelegramCDS.FieldByName('ChatId').AsInteger;
        spProcesUkraineAlarm.ParamByName('inText').AsString := MessagesTelegramCDS.FieldByName('Text').AsString;
        spProcesUkraineAlarm.ParamByName('outResult').AsString := '';

        spProcesUkraineAlarm.ExecProc;

      except
        on E:Exception do
        begin
          Add_Log(E.Message);
        end;
      end;

      MessagesTelegramCDS.Delete;
      MessagesTelegramCDS.First;
    end;

    ZConnection1.Disconnect;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
      Timer1.Enabled := true;
      Exit;
    end;
  end;

end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin

  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ProcesUkraineAlarm.ini');

  try

    ZConnection1.Database := Ini.ReadString('Connect', 'DataBase', 'farmacy');
    Ini.WriteString('Connect', 'DataBase', ZConnection1.Database);

    ZConnection1.HostName := Ini.ReadString('Connect', 'HostName', '172.17.2.12');
    Ini.WriteString('Connect', 'HostName', ZConnection1.HostName);

    ZConnection1.User := Ini.ReadString('Connect', 'User', 'postgres');
    Ini.WriteString('Connect', 'User', ZConnection1.User);

    ZConnection1.Password := Ini.ReadString('Connect', 'Password', 'eej9oponahT4gah3');
    Ini.WriteString('Connect', 'Password', ZConnection1.Password);

    Token := Ini.ReadString('UkraineAlarm', 'Token', '');
    Ini.WriteString('Telegram', 'Token', Token);

  finally
    Ini.free;
  end;

  ZConnection1.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  try
    ZConnection1.Connect;
    ZConnection1.Disconnect;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
    end;
  end;


  if not (((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0))) then
  begin
    Application.ShowMainForm:=False;
    Application.MainFormOnTaskBar:=False;
    btnGetMessagesTelegram.Enabled := false;
    btnProcesMessages.Enabled := false;
    Timer1.Enabled := true;
  end;
end;

procedure TMainForm.pmCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  try
    timer1.Enabled := False;

//    btnGetMessagesTelegramClick(Sender);
//    btnProcesMessagesClick(Sender);

  finally
    timer1.Enabled := True;
  end;
end;

end.
