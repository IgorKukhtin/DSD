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
  ZAbstractConnection, ZConnection, cxGridExportLink, System.Zip;

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
    UnitId: TcxSpinEdit;
    cxLabel4: TcxLabel;
    btnExport: TButton;
    FileName: TEdit;
    btnCompress: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCompressClick(Sender: TObject);
  private
    { Private declarations }
    SavePath, FilePath, FileTemplate: string;
    UnitList, RestList: TStringList;
    function GetUnitCode(AUnitId: Integer): string;
    function GetRestCode(AUnitId: Integer): string;
    procedure ReportExecute(AUnitId: Integer);
    procedure ReportExport(AUnitId: Integer);
    procedure ReportCompress(AUnitId: Integer);
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

procedure TForm1.btnCompressClick(Sender: TObject);
begin
  ReportCompress(UnitId.Value);
end;

procedure TForm1.btnExecuteClick(Sender: TObject);
begin
  ReportExecute(UnitId.Value);
end;

procedure TForm1.btnExportClick(Sender: TObject);
begin
  ReportExport(UnitId.Value);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  ini: TIniFile;
Begin
  UnitList := TStringList.Create;
  RestList := TStringList.Create;

  ini := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try
    SavePath := ini.readString('Options', 'Path', ExtractFilePath(Application.ExeName));
    if SavePath[Length(SavePath)] <> '\' then
      SavePath := SavePath + '\';
    ini.WriteString('Options', 'Path', SavePath);

    FilePath := ini.readString('Options', 'FilePath', ExtractFilePath(Application.ExeName));
    if FilePath[Length(FilePath)] <> '\' then
      FilePath := FilePath + '\';
    ini.WriteString('Options', 'FilePath', FilePath);

    UnitId.Value := ini.ReadInteger('Options', 'UnitId', 183292);
    ini.WriteInteger('Options', 'UnitId', UnitID.Value);

    UnitList.CommaText := ini.ReadString('Options', 'UnitList', 'Pravda_6=183292, Kombriga_petrova_6=183293, Yurija_Kondratuka_1=183294');
    ini.WriteString('Options', 'UnitList', UnitList.CommaText);

    RestList.CommaText := ini.ReadString('Options', 'RestList', 'Pravda_6=32490, Kombriga_petrova_6=33622, Yurija_Kondratuka_1=33618');
    ini.WriteString('Options', 'RestList', RestList.CommaText);

    ZConnection1.Database := ini.ReadString('Connect','DataBase','farmacy');
    ini.WriteString('Connect','DataBase',ZConnection1.Database);

    ZConnection1.HostName := ini.ReadString('Connect','HostName','91.210.37.210');
    ini.WriteString('Connect','HostName',ZConnection1.HostName);

    ZConnection1.User := ini.ReadString('Connect','User','postgres');
    ini.WriteString('Connect','User',ZConnection1.User);

    ZConnection1.Password := ini.ReadString('Connect','Password','postgres');
    ini.WriteString('Connect','Password',ZConnection1.Password);

    FileName.Text := ini.ReadString('Export', 'FileName', 'pricelistForTabletki_Pravda_6.xml');
    ini.WriteString('Export', 'FileName', FileName.Text);

    FileTemplate := ini.ReadString('Export', 'FileTemplate', 'pricelistForTabletki_%s.xml');
    ini.WriteString('Export', 'FileTemplate', FileTemplate);

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
    btnExport.Enabled := False;
    btnCompress.Enabled := False;
    Timer1.Enabled := True;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  UnitList.Free;
  RestList.Free;
end;

function TForm1.GetRestCode(AUnitId: Integer): string;
begin
  Result := RestList.Values[GetUnitCode(AUnitId)];
end;

function TForm1.GetUnitCode(AUnitId: Integer): string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to Pred(UnitList.Count) do
    if StrToInt(UnitList.ValueFromIndex[I]) = AUnitId then
    begin
      Result := UnitList.Names[I];
      Break;
    end;
end;

procedure TForm1.ReportCompress(AUnitId: Integer);
var
  UnitCode, RestCode, UnitFile, RestFile: string;
  SR: TSearchRec;
  ZipList: TStringList;
  ZipName: string;
  ZipFile: TZipFile;
begin
  Add_Log('Начало архивирования отчета');

  UnitCode := GetUnitCode(AUnitId);

  if not ForceDirectories(FilePath + UnitCode + '\zip\') then
  begin
    Add_Log('Не могу создать директорию архивирования');
    exit;
  end;

  RestCode := GetRestCode(AUnitId);
  UnitFile := FilePath + UnitCode + '\' + Format(FileTemplate, [UnitCode]);
  RestFile := FilePath + UnitCode + '\zip\Rest_' + RestCode + '_' + FormatDateTime('yyyymmddhhmmss', Now) + '.zip';

  ZipList := TStringList.Create;

  if FindFirst(FilePath + UnitCode + '\zip\Rest_*.zip', faAnyFile, SR) = 0 then
  repeat
    ZipList.Add(FilePath + UnitCode + '\zip\' + SR.Name);
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
end;

procedure TForm1.ReportExecute(AUnitId: Integer);
begin
  Add_Log('Начало Формирования отчета БаДМ');

  qryReport.Close;
  qryReport.Params.ParamByName('inUnitId').Value := AUnitId;

  try
    qryReport.Open;
  except
    on E: Exception do
    begin
      Add_Log(E.Message);
      Exit;
    end;
  end;
end;

procedure TForm1.ReportExport(AUnitId: Integer);
var
  UnitCode, UnitFile: string;
  sl : TStringList;
begin
  Add_Log('Начало выгрузки отчета');

  UnitCode := GetUnitCode(AUnitId);

  if not ForceDirectories(FilePath + UnitCode + '\') then
  begin
    Add_Log('Не могу создать директорию выгрузки');
    exit;
  end;

  UnitFile := FilePath + UnitCode + '\' + Format(FileTemplate, [UnitCode]);

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
var
  I: Integer;
begin
  try
    timer1.Enabled := False;

    for I := 0 to Pred(UnitList.Count) do
    begin
      ReportExecute(StrToInt(UnitList.ValueFromIndex[I]));
      ReportExport(StrToInt(UnitList.ValueFromIndex[I]));
      ReportCompress(StrToInt(UnitList.ValueFromIndex[I]));
    end;
  finally
    Close;
  end;
end;

end.
