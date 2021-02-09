unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.RegularExpressions, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IniFiles, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, DateUtils,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, cxLabel, cxTextEdit,
  cxMaskEdit, cxSpinEdit, Vcl.StdCtrls, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxGridCustomView, cxGrid, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  ZAbstractConnection, ZConnection, cxGridExportLink, System.Zip, cxProgressBar,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    ZConnection1: TZConnection;
    qryReport: TZQuery;
    dsReport: TDataSource;
    grReport: TcxGrid;
    grtvReport: TcxGridDBTableView;
    colRowData: TcxGridDBColumn;
    grlReport: TcxGridLevel;
    Panel1: TPanel;
    btnExecute: TButton;
    qryUnit: TZQuery;
    cxProgressBarUnit: TcxProgressBar;
    UnitName: TStaticText;
    qryRest_Group: TZQuery;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    RegNumber: TcxGridDBColumn;
    isReport2: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    dsUnit: TDataSource;
    btnForm: TButton;
    btnExport: TButton;
    btnSendFTP: TButton;
    IdFTP1: TIdFTP;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure btnFormClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnSendFTPClick(Sender: TObject);
  private
    { Private declarations }
    FHostTabletki: string;
    FPathTabletki: string;
    FUserTabletki: string;
    FPasswordTabletki: string;
    FHostMyPharmacy: string;
    FPathMyPharmacy: string;
    FUserMyPharmacy: string;
    FPasswordMyPharmacy: string;

    FFilePath: string;

    FFileRest_Group: string;
    FFileRest_Tabletki: string;
    FFileRest_MyPharmacy: string;

    function ReportExport(AUnitId: Integer; AUnitName: String) : boolean;
    procedure ReportCompress(AUnitId: Integer; AUnitName: String);
    procedure ReportCompressMyPharmacy(AUnitId: Integer; AUnitName: String);
    function ReportExportRest_Group(AUnitId: Integer) : boolean;
    procedure ReportCompressRest_Group(AUnitId: Integer);
  public
    { Public declarations }
    procedure SendFTP(AHost, AUsername, APassword, ADir, AFileName: String);
    procedure Add_Log(AMessage:String);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Add_Log(AMessage: String);
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
    Writeln(F,FormatDateTime('YYYY.MM.DD hh:mm:ss',now)+' - '+AMessage);
  finally
    CloseFile(F);
  end;
  except
  end;
end;

procedure TForm1.btnExecuteClick(Sender: TObject);
begin
  btnExecute.Enabled := False;
  btnForm.Enabled := False;
  btnExport.Enabled := False;
  btnSendFTP.Enabled := False;
  Timer1.Enabled := True;
end;

procedure TForm1.btnExportClick(Sender: TObject);
begin
  if not qryReport.Active then Exit;

  FFileRest_Group := '';
  FFileRest_Tabletki := '';
  FFileRest_MyPharmacy := '';

  if (qryUnit.RecNo = 1) and (HourOf(Now) < 2) then
  begin
    try
      dsReport.DataSet := qryRest_Group;
      qryRest_Group.Close;
      qryRest_Group.Open;
      if ReportExportRest_Group(qryUnit.FieldByName('SerialNumber').AsInteger) then
      begin
        ReportCompressRest_Group(qryUnit.FieldByName('SerialNumber').AsInteger);
      end;
    finally
      dsReport.DataSet := qryReport;
    end;
  end;

  if qryReport.RecordCount > 3 then
  Begin
    if ReportExport(qryUnit.FieldByName('RegNumber').AsInteger, qryUnit.FieldByName('Name').AsString) then
    begin
      if qryUnit.FieldByName('SerialNumber').AsInteger <> 0 then
        ReportCompress(qryUnit.FieldByName('SerialNumber').AsInteger, qryUnit.FieldByName('Name').AsString);
      if qryUnit.FieldByName('RegNumber').AsInteger <> 0 then
        ReportCompressMyPharmacy(qryUnit.FieldByName('RegNumber').AsInteger, qryUnit.FieldByName('Name').AsString);
    end;
  End;

end;

procedure TForm1.btnFormClick(Sender: TObject);
begin
  FFileRest_Group := '';
  FFileRest_Tabletki := '';
  FFileRest_MyPharmacy := '';

  if ZConnection1.Connected then
  try
    qryReport.Close;
    qryReport.Params.ParamByName('inUnitId').Value := qryUnit.FieldByName('Id').AsInteger;
    qryReport.Open;
  except ON E:Exception DO
    Begin
      ZConnection1.Disconnect;
      Add_Log(E.Message);
      Exit;
    End;
  End;
end;


procedure TForm1.btnSendFTPClick(Sender: TObject);
begin
  if FFileRest_Group <> '' then
    SendFTP(FHostTabletki, FUserTabletki, FPasswordTabletki, FPathTabletki, FFileRest_Group);
  if FFileRest_Tabletki <> '' then
    SendFTP(FHostTabletki, FUserTabletki, FPasswordTabletki, FPathTabletki, FFileRest_Tabletki);
  if FFileRest_MyPharmacy <> '' then
    SendFTP(FHostMyPharmacy, FUserMyPharmacy, FPasswordMyPharmacy, FPathMyPharmacy, FFileRest_MyPharmacy);
end;

procedure TForm1.SendFTP(AHost, AUsername, APassword, ADir, AFileName: String);
begin
  try
    IdFTP1.Disconnect;
    IdFTP1.Host := AHost;
    idFTP1.Username := AUsername;
    idFTP1.Password := APassword;
    try
      idFTP1.Connect;
    Except ON E: Exception DO
      Begin
        Add_Log(E.Message);
        exit;
      End;
    end;
    if ADir <> '' then
    try
      idFTP1.ChangeDir(ADir);
    except ON E: Exception DO
      begin
        Add_Log(E.Message);
        exit;
      end;
    end;
    try
      idFTP1.Put(AFileName);
      // DeleteFile(AFileName);
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

procedure TForm1.FormCreate(Sender: TObject);
var
  ini: TIniFile;
  HostName : String;
  Res: TArray<string>;
  I : integer;
Begin

  ini := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try

    FFilePath := ini.readString('Options', 'FilePath', ExtractFilePath(Application.ExeName));
    if FFilePath[Length(FFilePath)] <> '\' then
      FFilePath := FFilePath + '\';
    ini.WriteString('Options', 'FilePath', FFilePath);

    ZConnection1.Database := ini.ReadString('Connect','DataBase','farmacy');
    ini.WriteString('Connect','DataBase',ZConnection1.Database);

    HostName := ini.ReadString('Connect','HostName','172.17.2.5');
    ini.WriteString('Connect','HostName',HostName);

    ZConnection1.User := ini.ReadString('Connect','User','postgres');
    ini.WriteString('Connect','User',ZConnection1.User);

    ZConnection1.Password := ini.ReadString('Connect','Password','postgres');
    ini.WriteString('Connect','Password',ZConnection1.Password);

    FHostTabletki := ini.ReadString('FTP','HostTabletki','ftp.tabletki.ua');
    FPathTabletki := ini.ReadString('FTP','PathTabletki','');
    FUserTabletki := ini.ReadString('FTP','UserTabletki','479');
    FPasswordTabletki := ini.ReadString('FTP','PasswordTabletki','d83cd49bd18b');

    FHostMyPharmacy := ini.ReadString('FTP','HostMyPharmacy','mypharmacy.com.ua');
    FPathMyPharmacy := ini.ReadString('FTP','PathMyPharmacy','');
    FUserMyPharmacy := ini.ReadString('FTP','UserMyPharmacy','neboley');
    FPasswordMyPharmacy := ini.ReadString('FTP','PasswordMyPharmacy','46306');


  finally
    ini.free;
  end;

  ZConnection1.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  Res := TRegEx.Split(HostName, '[;]');
  for I := 0 to high(Res) do
  begin
    ZConnection1.HostName := Res[I];
    try
      ZConnection1.Connect;
      if ZConnection1.Connected then Break;
    except
      on E: Exception do
      begin
        Add_Log(E.Message);
      end;
    end;
  end;


  if not ZConnection1.Connected then
  begin
    Timer1.Enabled := True;
    Exit;
  end else qryUnit.Open;;

  if not ((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) then
  begin
    btnExecute.Enabled := False;
    btnForm.Enabled := False;
    btnExport.Enabled := False;
    btnSendFTP.Enabled := False;
    Timer1.Enabled := True;
  end;
end;

procedure TForm1.ReportCompress(AUnitId: Integer; AUnitName: String);
var
  UnitFile: string;
  SR: TSearchRec;
  ZipList: TStringList;
  ZipName: string;
  ZipFile: TZipFile;
begin
  Add_Log('Начало архивирования отчета по аптеке: ' + AUnitName);

  try

    if not ForceDirectories(FFilePath + AUnitName + '\zip\') then
    begin
      Add_Log('Не могу создать директорию архивирования');
      exit;
    end;

    UnitFile := FFilePath  + AUnitName + '\' + AUnitName + '.xml';
    FFileRest_Tabletki := FFilePath  + AUnitName + '\Zip\' +
      'Rest_' + IntToStr(AUnitId) + '_' + FormatDateTime('yyyymmddhhmmss', Now) + '.zip';

    ZipList := TStringList.Create;

    if FindFirst(FFilePath + AUnitName + '\Zip\Rest_' + IntToStr(AUnitId) + '*.zip', faAnyFile, SR) = 0 then
    repeat
      ZipList.Add(FFilePath + AUnitName + '\Zip\' + SR.Name);
    until FindNext(SR) <> 0;
    FindClose(SR);

    ZipFile := TZipFile.Create;

    try
      ZipFile.Open(FFileRest_Tabletki, zmWrite);
      ZipFile.Add(UnitFile);
      ZipFile.Close;

      for ZipName in ZipList do
        DeleteFile(ZipName);
    finally
      ZipFile.Free;
      ZipList.Free;
    end;
  except
    on E: Exception do
    begin
      Add_Log(E.Message);
      exit;
    end;
  end;
end;

procedure TForm1.ReportCompressMyPharmacy(AUnitId: Integer; AUnitName: String);
var
  UnitFile, TempFile: string;
  SR: TSearchRec;
  ZipList: TStringList;
  ZipName: string;
  ZipFile: TZipFile;
begin
  Add_Log('Начало архивирования отчета по аптеке: ' + AUnitName);

  try

    if not ForceDirectories(FFilePath + AUnitName + '\ZipMyPharmacy\') then
    begin
      Add_Log('Не могу создать директорию архивирования');
      exit;
    end;

    UnitFile := FFilePath  + AUnitName + '\' + AUnitName + '.xml';
    FFileRest_MyPharmacy := IntToStr(AUnitId) + '_' + FormatDateTime('yyyymmddhhmmss', Now);
    TempFile := FFilePath  + AUnitName + '\' + FFileRest_MyPharmacy + '.xml';
    FFileRest_MyPharmacy := FFilePath  + AUnitName + '\ZipMyPharmacy\' + FFileRest_MyPharmacy + '.zip';

    if not CopyFile(PWideChar(UnitFile), PWideChar(TempFile), True) then
    begin
      Add_Log('Ошибка копирования файла для архова');
      exit;
    end;

    ZipList := TStringList.Create;

    if FindFirst(FFilePath + AUnitName + '\ZipMyPharmacy\' + IntToStr(AUnitId) + '*.zip', faAnyFile, SR) = 0 then
    repeat
      ZipList.Add(FFilePath + AUnitName + '\ZipMyPharmacy\' + SR.Name);
    until FindNext(SR) <> 0;
    FindClose(SR);

    ZipFile := TZipFile.Create;

    try
      ZipFile.Open(FFileRest_MyPharmacy, zmWrite);
      ZipFile.Add(TempFile);
      ZipFile.Close;

      for ZipName in ZipList do
        DeleteFile(ZipName);
      DeleteFile(TempFile);
    finally
      ZipFile.Free;
      ZipList.Free;
    end;
  except
    on E: Exception do
    begin
      Add_Log(E.Message);
      exit;
    end;
  end;
end;

procedure TForm1.ReportCompressRest_Group(AUnitId: Integer);
var
  UnitFile: string;
  SR: TSearchRec;
  ZipName: string;
  ZipFile: TZipFile;
begin
  Add_Log('Начало архивирования отчета Rest_Group');

  try

    if not ForceDirectories(FFilePath) then
    begin
      Add_Log('Не могу создать директорию архивирования');
      exit;
    end;

    UnitFile := FFilePath  + 'rest_group_' + IntToStr(AUnitId) + '.xml';
    FFileRest_Group := FFilePath  + 'rest_group_' + IntToStr(AUnitId) + '.zip';

    if FileExists(FFilePath  + 'rest_group_' + IntToStr(AUnitId) + '.zip') then
      DeleteFile(FFilePath  + 'rest_group_' + IntToStr(AUnitId) + '.zip');

    ZipFile := TZipFile.Create;

    try
      ZipFile.Open(FFileRest_Group, zmWrite);
      ZipFile.Add(UnitFile);
      ZipFile.Close;

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
end;


function TForm1.ReportExport(AUnitId: Integer; AUnitName: String) : boolean;
var
  UnitFile: string;
  sl : TStringList;
begin
  Add_Log('Начало выгрузки отчета');
  Result := False;

  UnitFile := FFilePath  + AUnitName + '\' + AUnitName + '.xml';

  if not ForceDirectories(FFilePath  + AUnitName) then
  begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;

  try
    ExportGridToText(UnitFile, grReport, True, True, '', '', '', 'XML');

    sl := TStringList.Create;
    try
      sl.LoadFromFile(UnitFile);
      if Pos('</Offers>', sl.Strings[sl.Count - 1]) = 0 then
      begin
        DeleteFile(UnitFile);
        Add_Log('Ошибка экпорта нет </Offers>');
        Exit
      end else sl.SaveToFile(UnitFile, TEncoding.UTF8)
    finally
      sl.Free;
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Add_Log(E.Message);
      exit;
    end;
  end;

end;

function TForm1.ReportExportRest_Group(AUnitId: Integer) : boolean;
var
  UnitFile: string;
  sl : TStringList;
begin
  Add_Log('Начало выгрузки отчета');
  Result := False;

  UnitFile := FFilePath  + 'rest_group_' + IntToStr(AUnitId) + '.xml';

  if not ForceDirectories(FFilePath) then
  begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;

  try
    ExportGridToText(UnitFile, grReport, True, True, '', '', '', 'XML');

    sl := TStringList.Create;
    try
      sl.LoadFromFile(UnitFile);
      if Pos('</Data>', sl.Strings[sl.Count - 1]) = 0 then
      begin
        DeleteFile(UnitFile);
        Add_Log('Ошибка экпорта нет </Data>');
        Exit
      end else sl.SaveToFile(UnitFile, TEncoding.UTF8)
    finally
      sl.Free;
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Add_Log(E.Message);
      exit;
    end;
  end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  try
    timer1.Enabled := False;

    if ZConnection1.Connected then
    try

      qryUnit.First;
      cxProgressBarUnit.Properties.Max := qryUnit.RecordCount;
      while not qryUnit.Eof do
      Begin
        UnitName.Caption := 'Аптека: ' +  qryUnit.FieldByName('Name').AsString;
        cxProgressBarUnit.Position := qryUnit.RecNo;
        Application.ProcessMessages;
        Sleep(100);

        btnFormClick(Sender);
        btnExportClick(Sender);
        btnSendFTPClick(Sender);

        qryUnit.Next;
      End;
    except ON E:Exception DO
      Begin
        Add_Log(E.Message);
        Exit;
      End;
    End;
  finally
    Close;
  end;
end;

end.
