unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, Vcl.StdCtrls,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Vcl.ExtCtrls, ZAbstractConnection, ZConnection, ZAbstractRODataset,
  ZDataset, Vcl.ActnList, cxGridExportLink, System.StrUtils, System.Zip, System.RegularExpressions;

type
  TMainForm = class(TForm)
    ButtonPanel: TPanel;
    ExportGridDBTableView1: TcxGridDBTableView;
    ExportGridLevel1: TcxGridLevel;
    ExportGrid: TcxGrid;
    ExportButton: TButton;
    RunButton: TButton;
    ZConnection: TZConnection;
    ZQuery: TZReadOnlyQuery;
    DataSource: TDataSource;
    ZQuerygoodscode: TIntegerField;
    ZQuerygoodsnameforsite: TWideMemoField;
    ZQueryprice: TFloatField;
    ZQuerygoodsurl: TWideMemoField;
    colGoodsCode: TcxGridDBColumn;
    colGoodsNameForSite: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colGoodsURL: TcxGridDBColumn;
    ActionList: TActionList;
    RunAction: TAction;
    SaveAction: TAction;
    Timer: TTimer;
    RunExportButton: TButton;
    RunAndExport: TAction;
    procedure FormCreate(Sender: TObject);
    procedure RunActionExecute(Sender: TObject);
    procedure RunActionUpdate(Sender: TObject);
    procedure SaveActionExecute(Sender: TObject);
    procedure SaveActionUpdate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure RunAndExportExecute(Sender: TObject);
  private
    { Private declarations }
    FilePath, RestFilePath, InetFilePath, ExportFilePath, InetDostFilePath, ExportDostFilePath, ExportListID, ExportListName: string;
    Running, Saving: Boolean;
    procedure AddToLog(S: string);
    procedure ExportRun;
    procedure ExportRunOne(AUnit: string);
    procedure ExportSave;
    procedure ExportSaveOne(AUnit, AName: string);
    procedure ExportCompress(AFileName: string);
    function EscSpecChars(S: string): string;
    procedure SaveToXML;
    procedure ExportCopy(AFileFrom, AFileTo: string);
    procedure ExportCopies;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  System.IniFiles;

procedure TMainForm.AddToLog(S: string);
var
  F: TextFile;
  LogFileName: string;
begin
  LogFileName := ChangeFileExt(Application.ExeName, '.log');
  AssignFile(F, LogFileName);

  if FileExists(LogFileName) then
    Append(F)
  else
    Rewrite(F);

  Writeln(F, FormatDateTime('yyyy.mm.dd hh:mm:ss.zzz', Now) + ' ' + S);
  CloseFile(F);
end;

function TMainForm.EscSpecChars(S: string): string;
begin
  Result := S;
  Result := ReplaceText(Result, '&',  '&amp;');
  Result := ReplaceText(Result, '"',  '&quot;');
  Result := ReplaceText(Result, '''', '&apos;');
  Result := ReplaceText(Result, '<',  '&lt;');
  Result := ReplaceText(Result, '>',  '&gt;');
end;

procedure TMainForm.ExportRun;
var
  OldCursor: TCursor;
begin
  AddToLog('Формирование отчета ...');

  Running := True;
  Application.ProcessMessages;
  ZQuery.DisableControls;
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  try
    ZQuery.Close;
    ZQuery.SQL.Text := 'SELECT DISTINCT * FROM gpSelect_GoodsOnUnit_ForSite_NeBoley (0, zfCalc_UserSite())';

    try
      ZQuery.Open;
    except
      on E: Exception do
        AddToLog(E.Message);
    end;
  finally
    Screen.Cursor := OldCursor;
    ZQuery.EnableControls;
    Running := False;
  end;
end;

procedure TMainForm.ExportRunOne(AUnit: string);
var
  OldCursor: TCursor;
begin
  AddToLog('Формирование отчета ...');

  Running := True;
  Application.ProcessMessages;
  ZQuery.DisableControls;
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  try
    ZQuery.Close;
    ZQuery.SQL.Text := 'SELECT DISTINCT * FROM gpSelect_GoodsOnUnit_ForSite_OneUnit (' + AUnit + ', zfCalc_UserSite())';

    try
      ZQuery.Open;
    except
      on E: Exception do
        AddToLog(E.Message);
    end;
  finally
    Screen.Cursor := OldCursor;
    ZQuery.EnableControls;
    Running := False;
  end;
end;

procedure TMainForm.ExportSave;
var
  OldDecimalSeparator: Char;
  CSVFile: TStringList;
begin
  Saving := True;
  AddToLog('Выгрузка отчета ...');

  if not ForceDirectories(ExtractFilePath(FilePath)) then
  begin
    AddToLog(Format('Не могу создать директорию выгрузки "%s"', [ExtractFilePath(FilePath)]));
    Saving := False;
    Exit;
  end;

  try
    OldDecimalSeparator := FormatSettings.DecimalSeparator;
    FormatSettings.DecimalSeparator := '.';
    ExportGridToText(FilePath, ExportGrid, True, True, ';', '', '', 'CSV');
    CSVFile := TStringList.Create;
    CSVFile.LoadFromFile(FilePath);
    CSVFile.SaveToFile(FilePath, TEncoding.ANSI);
    CSVFile.Free;
    SaveToXML;
    FormatSettings.DecimalSeparator := OldDecimalSeparator;
    Saving := False;
  except
    on E: Exception do
    begin
      AddToLog(E.Message);
      Saving := False;
    end;
  end;
end;

procedure TMainForm.ExportSaveOne(AUnit, AName: string);
var
  OldDecimalSeparator: Char;
  CSVFile: TStringList;
begin
  Saving := True;
  AddToLog('Выгрузка отчета ...');

  if not ForceDirectories(ExtractFilePath(FilePath)) then
  begin
    AddToLog(Format('Не могу создать директорию выгрузки "%s"', [ExtractFilePath(FilePath)]));
    Saving := False;
    Exit;
  end;

  try
    OldDecimalSeparator := FormatSettings.DecimalSeparator;
    FormatSettings.DecimalSeparator := '.';
    ExportGridToText(ExtractFilePath(FilePath) + AName + '.CSV', ExportGrid, True, True, ';', '', '', 'CSV');
    CSVFile := TStringList.Create;
    CSVFile.LoadFromFile(ExtractFilePath(FilePath) + AName + '.CSV');
    CSVFile.SaveToFile(ExtractFilePath(FilePath) + AName + '.CSV', TEncoding.ANSI);
    CSVFile.Free;
    FormatSettings.DecimalSeparator := OldDecimalSeparator;
  except
    on E: Exception do
    begin
      AddToLog(E.Message);
      Saving := False;
    end;
  end;
end;

procedure TMainForm.ExportCompress(AFileName: string);
var
  ZipName: string;
  ZipFile: TZipFile;
begin
  AddToLog(Format('Архивирование отчета "%s"', [AFileName]));

  ZipName := ChangeFileExt(AFileName, '.zip');
  if FileExists(ZipName) then
    DeleteFile(ZipName);

  ZipFile := TZipFile.Create;
  try
    ZipFile.Open(ZipName, zmWrite);
    ZipFile.Add(AFileName);
    ZipFile.Close;
  finally
    ZipFile.Free;
  end;
end;

procedure TMainForm.ExportCopies;
begin
  ExportCopy(RestFilePath, InetFilePath);
  ExportCopy(RestFilePath, ExportFilePath);
  ExportCopy(RestFilePath, InetDostFilePath);
  ExportCopy(RestFilePath, ExportDostFilePath);
end;

procedure TMainForm.ExportCopy(AFileFrom, AFileTo: string);
begin
  if not ForceDirectories(ExtractFilePath(AFileTo)) then
  begin
    AddToLog(Format('Не могу создать директорию выгрузки "%s"', [ExtractFilePath(AFileTo)]));
    Exit;
  end;

  CopyFile(PChar(AFileFrom), PChar(AFileTo), False);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  IniFile: TIniFile;
  ExePath: string;
begin
  Running := False;
  Saving := False;
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  try
    // Options

    ExePath := ExtractFilePath(Application.ExeName);

    FilePath := IniFile.ReadString('Options', 'FilePath', ExePath + 'neboley.csv');
    IniFile.WriteString('Options', 'FilePath', FilePath);

    RestFilePath := IniFile.ReadString('Options', 'RestFilePath', ExePath + 'Rest_70006.xml');
    IniFile.WriteString('Options', 'RestFilePath', RestFilePath);

    InetFilePath := IniFile.ReadString('Options', 'InetFilePath', ExePath + 'internet-apteka-neboley.xml');
    IniFile.WriteString('Options', 'InetFilePath', InetFilePath);

    ExportFilePath := IniFile.ReadString('Options', 'ExportFilePath', ExePath + 'export.xml');
    IniFile.WriteString('Options', 'ExportFilePath', ExportFilePath);

    InetDostFilePath := IniFile.ReadString('Options', 'InetDostFilePath', ExePath + 'internet-apteka-neboley-dostavka.xml');
    IniFile.WriteString('Options', 'InetDostFilePath', InetDostFilePath);

    ExportDostFilePath := IniFile.ReadString('Options', 'ExportDostFilePath', ExePath + 'export-dostavka.xml');
    IniFile.WriteString('Options', 'ExportDostFilePath', ExportDostFilePath);

    ExportListID := IniFile.ReadString('Options', 'ExportListID', '');
    ExportListName := IniFile.ReadString('Options', 'ExportListName', '');

    // Connect

    ZConnection.HostName := IniFile.ReadString('Connect', 'HostName', '91.210.37.210');
    IniFile.WriteString('Connect', 'HostName', ZConnection.HostName);

    ZConnection.Database := IniFile.ReadString('Connect', 'Database', 'farmacy');
    IniFile.WriteString('Connect', 'Database', ZConnection.Database);

    ZConnection.User := IniFile.ReadString('Connect', 'User', 'postgres');
    IniFile.WriteString('Connect', 'User', ZConnection.User);

    ZConnection.Password := IniFile.ReadString('Connect', 'Password', 'postgres');
    IniFile.WriteString('Connect', 'Password', ZConnection.Password);
  finally
    IniFile.Free;
  end;

  ZConnection.LibraryLocation := ExtractFilePath(Application.ExeName) + 'libpq.dll';

  try
    ZConnection.Connect;
  except
    on E: Exception do
    begin
      AddToLog(E.Message);
      Close;
    end;
  end;

  if FindCmdLineSwitch('auto') then
  begin
    ButtonPanel.Visible := False;
    Timer.Enabled := True;
  end;
end;

procedure TMainForm.RunActionExecute(Sender: TObject);
begin
  ExportRun;
end;

procedure TMainForm.RunActionUpdate(Sender: TObject);
begin
  RunAction.Enabled := not Running;
end;

procedure TMainForm.RunAndExportExecute(Sender: TObject);
  var I : integer; S : string; Res, ResName: TArray<string>;
begin
  if ExportListID = '' then Exit;
  Res := TRegEx.Split(ExportListID, '[,]');
  ResName := TRegEx.Split(ExportListName, '[,]');
  for I := Low(Res) to High(Res) do
  begin
    ExportRunOne(Res[I]);
    if I <= High(ResName) then S := ResName[I]
    else S := Res[I];
    ExportSaveOne(Res[I], S);
  end;
end;

procedure TMainForm.SaveActionExecute(Sender: TObject);
begin
  ExportSave;
  ExportCompress(RestFilePath);
  ExportCopies;
end;

procedure TMainForm.SaveActionUpdate(Sender: TObject);
begin
  SaveAction.Enabled := not Saving;
end;

procedure TMainForm.SaveToXML;
var
  XML: TStringList;
begin
  XML := TStringList.Create;

  try
    XML.Add('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    XML.Add('<Root>');

    with ZQuery do
    begin
      DisableControls;
      First;

      while not Eof do
      begin
        XML.Add(Format('  <Rest Code="%s" Name="%s" Price="%f" Quantity="1" Url="%s"/>', [
          ZQueryGoodsCode.AsString,
          EscSpecChars(ZQueryGoodsNameForSite.AsString),
          ZQueryPrice.AsFloat,
          ZQueryGoodsURL.AsString
        ]));

        Next;
      end;

      First;
      EnableControls;
    end;

    XML.Add('</Root>');

    if not ForceDirectories(ExtractFilePath(RestFilePath)) then
    begin
      AddToLog(Format('Не могу создать директорию выгрузки "%s"', [ExtractFilePath(RestFilePath)]));
      Exit;
    end;

    XML.SaveToFile(RestFilePath, TEncoding.UTF8);
  finally
    XML.Free;
  end;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;

  try
    ExportRun;
    ExportSave;
    ExportCompress(RestFilePath);
    ExportCopies;
    RunAndExportExecute(Sender);
  finally
    Close;
  end;
end;

end.
