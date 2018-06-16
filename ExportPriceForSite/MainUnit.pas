unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IniFiles, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, cxLabel, cxTextEdit,
  cxMaskEdit, cxSpinEdit, Vcl.StdCtrls, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxGridCustomView, cxGrid, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  ZAbstractConnection, ZConnection, cxGridExportLink, System.Zip, cxProgressBar;

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
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
  private
    { Private declarations }
    FilePath: string;
    procedure ReportExport(AUnitId: Integer; AUnitName: String);
    procedure ReportCompress(AUnitId: Integer; AUnitName: String);
    procedure ReportCompressMyPharmacy(AUnitId: Integer; AUnitName: String);
  public
    { Public declarations }
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
  Timer1.Enabled := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  ini: TIniFile;
Begin

  ini := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try

    FilePath := ini.readString('Options', 'FilePath', ExtractFilePath(Application.ExeName));
    if FilePath[Length(FilePath)] <> '\' then
      FilePath := FilePath + '\';
    ini.WriteString('Options', 'FilePath', FilePath);

    ZConnection1.Database := ini.ReadString('Connect','DataBase','farmacy');
    ini.WriteString('Connect','DataBase',ZConnection1.Database);

    ZConnection1.HostName := ini.ReadString('Connect','HostName','91.210.37.210');
    ini.WriteString('Connect','HostName',ZConnection1.HostName);

    ZConnection1.User := ini.ReadString('Connect','User','postgres');
    ini.WriteString('Connect','User',ZConnection1.User);

    ZConnection1.Password := ini.ReadString('Connect','Password','postgres');
    ini.WriteString('Connect','Password',ZConnection1.Password);

  finally
    ini.free;
  end;

  ZConnection1.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  try
    ZConnection1.Connect;
  except
    on E: Exception do
    begin
      Add_Log(E.Message);
      Close;
      Exit;
    end;
  end;

  if not ((ParamCount >= 1) and (CompareText(ParamStr(1), 'manual') = 0)) then
  begin
    btnExecute.Enabled := False;
    Timer1.Enabled := True;
  end;
end;

procedure TForm1.ReportCompress(AUnitId: Integer; AUnitName: String);
var
  UnitFile, RestFile: string;
  SR: TSearchRec;
  ZipList: TStringList;
  ZipName: string;
  ZipFile: TZipFile;
begin
  Add_Log('Начало архивирования отчета по аптеке: ' + AUnitName);

  try

    if not ForceDirectories(FilePath + AUnitName + '\zip\') then
    begin
      Add_Log('Не могу создать директорию архивирования');
      exit;
    end;

    UnitFile := FilePath  + AUnitName + '\' + AUnitName + '.xml';
    RestFile := FilePath  + AUnitName + '\Zip\' +
      'Rest_' + IntToStr(AUnitId) + '_' + FormatDateTime('yyyymmddhhmmss', Now) + '.zip';

    ZipList := TStringList.Create;

    if FindFirst(FilePath + AUnitName + '\Zip\Rest_' + IntToStr(AUnitId) + '*.zip', faAnyFile, SR) = 0 then
    repeat
      ZipList.Add(FilePath + AUnitName + '\Zip\' + SR.Name);
    until FindNext(SR) <> 0;
    FindClose(SR);

    ZipFile := TZipFile.Create;

    try
      ZipFile.Open(RestFile, zmWrite);
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
  UnitFile, TempFile, RestFile: string;
  SR: TSearchRec;
  ZipList: TStringList;
  ZipName: string;
  ZipFile: TZipFile;
begin
  Add_Log('Начало архивирования отчета по аптеке: ' + AUnitName);

  try

    if not ForceDirectories(FilePath + AUnitName + '\ZipMyPharmacy\') then
    begin
      Add_Log('Не могу создать директорию архивирования');
      exit;
    end;

    UnitFile := FilePath  + AUnitName + '\' + AUnitName + '.xml';
    RestFile := IntToStr(AUnitId) + '_' + FormatDateTime('yyyymmddhhmmss', Now);
    TempFile := FilePath  + AUnitName + '\' + RestFile + '.xml';
    RestFile := FilePath  + AUnitName + '\ZipMyPharmacy\' + RestFile + '.zip';

    if not CopyFile(PWideChar(UnitFile), PWideChar(TempFile), True) then
    begin
      Add_Log('Ошибка копирования файла для архова');
      exit;
    end;

    ZipList := TStringList.Create;

    if FindFirst(FilePath + AUnitName + '\ZipMyPharmacy\' + IntToStr(AUnitId) + '*.zip', faAnyFile, SR) = 0 then
    repeat
      ZipList.Add(FilePath + AUnitName + '\ZipMyPharmacy\' + SR.Name);
    until FindNext(SR) <> 0;
    FindClose(SR);

    ZipFile := TZipFile.Create;

    try
      ZipFile.Open(RestFile, zmWrite);
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

procedure TForm1.ReportExport(AUnitId: Integer; AUnitName: String);
var
  UnitFile: string;
  sl : TStringList;
begin
  Add_Log('Начало выгрузки отчета');

  UnitFile := FilePath  + AUnitName + '\' + AUnitName + '.xml';

  if not ForceDirectories(FilePath  + AUnitName) then
  begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;

  try
    ExportGridToText(UnitFile, grReport, True, True, '', '', '', 'XML');

    sl := TStringList.Create;
    try
      sl.LoadFromFile(UnitFile);
      sl.SaveToFile(UnitFile, TEncoding.UTF8);
    finally
      sl.Free;
    end;
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
      qryUnit.Open;

      qryUnit.First;
      cxProgressBarUnit.Properties.Max := qryUnit.RecordCount;
      while not qryUnit.Eof do
      Begin
        UnitName.Caption := 'Аптека: ' +  qryUnit.FieldByName('Name').AsString;
        cxProgressBarUnit.Position := qryUnit.RecNo;
        Application.ProcessMessages;
        Sleep(100);
        qryReport.Close;
        qryReport.Params.ParamByName('inUnitId').Value := qryUnit.FieldByName('Id').AsInteger;
        qryReport.Open;

        if qryReport.RecordCount > 3 then
        Begin
          ReportExport(qryUnit.FieldByName('RegNumber').AsInteger, qryUnit.FieldByName('Name').AsString);
          ReportCompress(qryUnit.FieldByName('SerialNumber').AsInteger, qryUnit.FieldByName('Name').AsString);
          ReportCompressMyPharmacy(qryUnit.FieldByName('RegNumber').AsInteger, qryUnit.FieldByName('Name').AsString);
        End;
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
