unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Win.ComObj, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGridExportLink, cxGraphics, Math,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, System.RegularExpressions,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxSpinEdit, Vcl.StdCtrls, System.Zip,
  cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, cxPC, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection, IniFiles,
  IdMessage, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  Vcl.ActnList, IdText, IdSSLOpenSSL, IdGlobal, strUtils, IdAttachmentFile,
  IdFTP, cxCurrencyEdit, cxCheckBox, Vcl.Menus, DateUtils, cxButtonEdit, ZLibExGZ,
  IdHTTP, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog, cxExport;

type
  TMainForm = class(TForm)
    ZConnection1: TZConnection;
    Timer1: TTimer;
    qryUnit: TZQuery;
    dsUnit: TDataSource;
    Panel2: TPanel;
    btnSendFTP: TButton;
    btnExport: TButton;
    btnExecute: TButton;
    btnAll: TButton;
    grtvUnit: TcxGridDBTableView;
    grReportUnitLevel1: TcxGridLevel;
    grReportUnit: TcxGrid;
    qryReport_Upload: TZQuery;
    dsReport_Upload: TDataSource;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    UnitCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    btnAllUnit: TButton;
    Store: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    Barcode: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    Quantity: TcxGridDBColumn;
    Producer: TcxGridDBColumn;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdHTTP: TIdHTTP;
    IdFTP1: TIdFTP;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnSendFTPClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAllUnitClick(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
  private
    { Private declarations }

    FileName: String;
    SavePath: String;

    glFTPHost,
    glFTPPath,
    glFTPUser,
    glFTPPassword: String;

  public
    { Public declarations }
    procedure Add_Log(AMessage:String);

    procedure AllUnit;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

function GetThousandSeparator : string;
begin
  if FormatSettings.ThousandSeparator = #160 then Result := ' '
  else Result := FormatSettings.ThousandSeparator;
end;


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

procedure TMainForm.AllUnit;
begin
  try

    Add_Log('');
    Add_Log('-------------------');
    Add_Log('������ : ' + qryUnit.FieldByName('ID').AsString);

    btnExecuteClick(Nil);
    btnExportClick(Nil);
    btnSendFTPClick(Nil);

  except
    on E: Exception do
      Add_Log(E.Message);
  end;
end;


procedure TMainForm.btnAllClick(Sender: TObject);
begin
  try
    qryUnit.First;
    while not qryUnit.Eof do
    begin

      AllUnit;

      qryUnit.Next;
      Application.ProcessMessages;
    end;
  except
    on E: Exception do
      Add_Log(E.Message);
  end;

  qryUnit.Close;
  qryUnit.Open;
end;

procedure TMainForm.btnAllUnitClick(Sender: TObject);
begin
  AllUnit;
  qryUnit.Close;
  qryUnit.Open;
end;

procedure TMainForm.btnExecuteClick(Sender: TObject);
begin

  if not qryUnit.Active then Exit;
  qryReport_Upload.Close;

  qryReport_Upload.DisableControls;
  try
    try
      FileName := 'price YA ' + qryUnit.FieldByName('UnitCode').AsString;
      qryReport_Upload.Params.ParamByName('UnitID').AsInteger := qryUnit.FieldByName('ID').AsInteger;
      qryReport_Upload.Open;
    except
      on E:Exception do
      begin
        Add_Log(E.Message);
        Exit;
      end;
    end;

  finally
    qryReport_Upload.EnableControls;
  end;
end;

procedure TMainForm.btnExportClick(Sender: TObject);
begin
  if not qryReport_Upload.Active then Exit;
  if qryReport_Upload.IsEmpty then Exit;
  Add_Log('������ �������� ������');
  if not ForceDirectories(SavePath) then
  Begin
    Add_Log('�� ���� ������� ���������� ��������');
    exit;
  end;

  // ������� �����
  try
    try
//      ExportGridToXLSX(SavePath + FileName, grReportUnit);
//      ExportGridToExcel(SavePath + FileName, grReportUnit);
      ExportGridToFile(SavePath + FileName, cxExportToText, grReportUnit, True, True, False, ';', '', '', 'csv', nil, TEncoding.UTF8);
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
        exit;
      end;
    end;
  finally
  end;
end;

procedure TMainForm.btnSendFTPClick(Sender: TObject);
  VAR ZipFile: TZipFile;
begin

  if not FileExists(SavePath + FileName + '.csv') then Exit;

  Add_Log('������ �������� ������: ' + SavePath + FileName + '.csv');

  try
    ZipFile := TZipFile.Create;

    try
      ZipFile.Open(SavePath + FileName + '.zip', zmWrite);
      ZipFile.Add(SavePath + FileName + '.csv');
      ZipFile.Close;

      DeleteFile(SavePath + FileName + '.csv');
    finally
      ZipFile.Free;
    end;
  except
    on E: Exception do
    begin
      Add_Log(E.Message);
      exit;
    end;
  end;

  try
    IdFTP1.Disconnect;
    IdFTP1.Host := glFTPHost;
    idFTP1.Username := glFTPUser;
    idFTP1.Password := glFTPPassword;
    try
      idFTP1.Connect;
    Except ON E: Exception DO
      Begin
        Add_Log(E.Message);
        exit;
      End;
    end;
    if glFTPPath <> '' then
    try
      idFTP1.ChangeDir(glFTPPath);
    except ON E: Exception DO
      begin
        Add_Log(E.Message);
        exit;
      end;
    end;
    try
      idFTP1.Put(SavePath + FileName + '.zip');
//      CopyFile(PChar(SavePath + FileName + '.zip'), PChar(SavePath + 'arc\' + FormatDateTime('YYYYMMDDHHNNSS', Now) + FileName + '.zip'), False);
      DeleteFile(SavePath + FileName + '.zip');

    except ON E: Exception DO
      Begin
        Add_Log(E.Message);
        exit;
      End;
    end;
  finally
    idFTP1.Disconnect;
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
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ExportFor103UA.ini');

  try
    SavePath := Trim(Ini.ReadString('Options', 'Path', ExtractFilePath(Application.ExeName)));
    if SavePath[Length(SavePath)] <> '\' then SavePath := SavePath + '\';
    Ini.WriteString('Options', 'Path', SavePath);

    ZConnection1.Database := Ini.ReadString('Connect', 'DataBase', 'farmacy');
    Ini.WriteString('Connect', 'DataBase', ZConnection1.Database);

    ZConnection1.HostName := Ini.ReadString('Connect', 'HostName', '172.17.2.5');
    Ini.WriteString('Connect', 'HostName', ZConnection1.HostName);

    ZConnection1.User := Ini.ReadString('Connect', 'User', 'postgres');
    Ini.WriteString('Connect', 'User', ZConnection1.User);

    ZConnection1.Password := Ini.ReadString('Connect', 'Password', 'eej9oponahT4gah3');
    Ini.WriteString('Connect', 'Password', ZConnection1.Password);

    glFTPHost := Ini.ReadString('FTP','Host','Apteka.103.ua');
    Ini.WriteString('FTP','Host',glFTPHost);

    glFTPPath := Ini.ReadString('FTP','Path','');
    Ini.WriteString('FTP','Path',glFTPPath);

    glFTPUser := Ini.ReadString('FTP','User','ne-bolej_ua');
    Ini.WriteString('FTP','User',glFTPUser);

    glFTPPassword := Ini.ReadString('FTP','Password','%q$VVsdfWDq2!AD@Xs');
    Ini.WriteString('FTP','Password',glFTPPassword);

  finally
    Ini.free;
  end;

  ZConnection1.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  try
    ZConnection1.Connect;
  except
    on E:Exception do
    begin
      Add_Log(E.Message);
      Close;
      Exit;
    end;
  end;

  if ZConnection1.Connected then
  begin
    qryUnit.Close;
    try
      qryUnit.Open;
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
        Close;
        Exit;
      end;
    end;


    if not (((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) or
      (Pos('Farmacy.exe', Application.ExeName) <> 0)) then
    begin
      btnAll.Enabled := false;
      btnAllUnit.Enabled := false;
      btnExecute.Enabled := false;
      btnExport.Enabled := false;
      btnSendFTP.Enabled := false;
      Timer1.Enabled := true;
    end;
  end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  try
    timer1.Enabled := False;
    btnAllClick(nil);
  finally
    Close;
  end;
end;


end.
